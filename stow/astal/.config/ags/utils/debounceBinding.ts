// debounce.ts
import { Variable } from "astal";

export function debounceBinding<T>(binding, delay: number) {
  const debounced = Variable(binding.get());
  let timeout: any = null;

  binding.subscribe((value: T) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => {
      debounced.setValue(value);
    }, delay);
  });

  return debounced;
}
