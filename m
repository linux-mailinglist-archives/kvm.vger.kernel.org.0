Return-Path: <kvm+bounces-43411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89536A8B5F6
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 11:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EC157AE6C0
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F218238D28;
	Wed, 16 Apr 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekqj+Gu/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55142236441;
	Wed, 16 Apr 2025 09:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796701; cv=none; b=nx3RUg73RehQFrl3TlPSXoj1GsLYuHk34ISAUrUBaw6Hr0jgxmzd/kmXE1xRkc2yoXyLolC2jcKE/a98AsSgZAivjeb3xHBkmaH3zUmA58n8oAcD9zAPiTsrrnbc6HDjIPtHWM5+y6RB1GWNn9Mw3F3EI+A0OayZQsbQ1guJIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796701; c=relaxed/simple;
	bh=pRU6wLgxXnLL1nq6ekG3r0pNLgbdqaE3J4O9xny8g9g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u1BGpr8kGLvNxhgHeEvxIWZY2YL740+jmQfknJzaBVEWTARjSXKbgKkQn3DgDZn0pCegSZDJbbJLdAyObn9sJPNKft2Y+p+q882yESNWBDs/vM5P9VSkREkvx+5Wy8U+eaR4C2kbIW9nadLNjnp+qHgu4cN3aOKYrrN5EQvaCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekqj+Gu/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2A3BC4CEF3;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796700;
	bh=pRU6wLgxXnLL1nq6ekG3r0pNLgbdqaE3J4O9xny8g9g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ekqj+Gu/0hKmxeU3sm6q1f2ryuXtUFna6ArZ7i8VRK8suIQwaNNKThLw6ImaKsr5K
	 t0mZIWV5XLpX6VHLck+gcTnsQVTrinH9PM7QVd9oguTIrn7SNyEEyk6GhQt2eCE+Xq
	 58clWQAoWoEdCiRa24pVL33ZaWLNOUUCVE8PHQl6gKwS4H+pAlXWIgRnzBmqWeoxZ+
	 STzsWCztCoWIdguL6ckBQtCF9551uC+sBRoMfvnJNK5FFrkWClkz563175vEhlF9nU
	 B+hfAzBO8AkYTDIbAad2roMX8GONH0N9cvXRru8OFUGmGo3obvCkayvcukwGaF4p/D
	 zk8QiATZhVaGQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12E6C369C1;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Wed, 16 Apr 2025 17:44:50 +0800
Subject: [PATCH RFC v2 4/5] tpm: add __always_inline for
 tpm_is_hwrng_enabled
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250416-noautoinline-v2-4-e69a2717530f@uniontech.com>
References: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
In-Reply-To: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
To: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3892;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=eVMGMErwkSKVlhFsRXd5VgFhkcLZ6sQRGgY0l5PVv8Q=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBn/3wYTeAxxXYaBDNq6MoKT5/qwja5tvQJEZiWQ
 VjsA0MmYHeJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCZ/98GAAKCRB2HuYUOZmu
 i72UEAD2OIFAhd0YqHWxRgTYgam80CB7jU1JXtFVmnHuEVb2fZKwu3HLJvvNPTdU488rihW29Gv
 a7Mp25dYGsmpP7Y94+fu8UZ4WFHadCc8hD/JMAHf9TYKA/QHF305zxqKfWDFsh45+9l/9GyxUGx
 pn9FPSvodZ2un0zqttouu2KSsIVrqiSaWsJ/CJMWPUymTUQtgjhjTQYRpNgPD1Hgzy1NLg7qFn2
 xXZ8H66IWPbH/UYx8FYT4u1nexNR8phuoDm1tbZgVG2reCPwbE7aqnvbp4nvOni6Ry75bTal19f
 1ph+O4sFDpacQ3l/zIvqqWbja+D5nbtDyeljbPTOLtO9BiUunxTtWzxx1jP9pZ+AfthSYLHtP6i
 Fw0i6kS/FCH2vL86HtHiWMVhZLa2TB0sXTxz8IG1a5F+Ws6KUU8ATsuG7kYv/CVgO4uMR3caLvt
 9ZmjawH5WNd8M6YqYA9gX4OzOGn9BJL5MYTQQNg6vbx6UpzwWXxG1m/96VBePk+auO80b2gyVcW
 kLoKOHVePJDYSgmqibXWCc2BQIEjkqDF1/bZgB/tuqmreGPUjrxR2RtT0xRLlh2K1fSFHUjMV26
 wpWwKRlygPJbqNOMeoSfRl7qf5jn3XSxZvex19Soc7LaN/0iI+vfTTCYk/j6PbihEFAmhkJ92r1
 +J10jZUB46Z8qgg==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Winston Wen <wentao@uniontech.com>

Presume that kernel is compiled for x86_64 with gcc version 13.3.0:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_TCG_TPM=y
    echo CONFIG_HW_RANDOM=m
  )
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once"

This results a link error:

  ld: vmlinux.o: in function `tpm_add_hwrng':
  tpm-chip.c:(.text+0x6c5924): undefined reference to `hwrng_register'
  ld: vmlinux.o: in function `tpm_chip_unregister':
  (.text+0x6c5bc9): undefined reference to `hwrng_unregister'
  ld: vmlinux.o: in function `tpm_chip_register':
  (.text+0x6c5c9b): undefined reference to `hwrng_unregister'

With `CONFIG_TCG_TPM=y` and `CONFIG_HW_RANDOM=m`,
the functions `tpm_add_hwrng`, `tpm_chip_unregister`, and
`tpm_chip_register` are compiled into `vmlinux.o`
and reference the symbols `hwrng_register` and `hwrng_unregister`.
These symbols, however, are compiled into `rng-core.ko`, which results
in the linking error.

I am not sure but I think this weird linking error only arises when
auto inlining is disabled because of some dead code elimination.

`CONFIG_TCG_TPM=y` and `CONFIG_HW_RANDOM=m` set `CONFIG_HW_RANDOM_TPM=n`.
This causes the function `tpm_is_hwrng_enabled` to always return
`false`, as shown below:

  static bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
  {
      if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
          return false;
      if (tpm_is_firmware_upgrade(chip))
          return false;
      if (chip->flags & TPM_CHIP_FLAG_HWRNG_DISABLED)
          return false;
      return true;
  }

When `tpm_is_hwrng_enabled` is inlined, dead code elimination
optimizations are applied and the reference to the `hwrng_*` functions
will been removed.
For instance, in the `tpm_chip_unregister` function:

  void tpm_chip_unregister(struct tpm_chip *chip)
  {
  #ifdef CONFIG_TCG_TPM2_HMAC
      int rc;

      rc = tpm_try_get_ops(chip);
      if (!rc) {
          tpm2_end_auth_session(chip);
          tpm_put_ops(chip);
      }
  #endif

      tpm_del_legacy_sysfs(chip);
      if (tpm_is_hwrng_enabled(chip))
          hwrng_unregister(&chip->hwrng);
      tpm_bios_log_teardown(chip);
      if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip))
          tpm_devs_remove(chip);
      tpm_del_char_device(chip);
  }

When `tpm_is_hwrng_enabled` is inlined and always returns `false`,
the call to `hwrng_unregister` is effectively part of a `if (false)`
block, which I guess that will be then optimized out.

However, when the `-fno-inline-small-functions` and
`-fno-inline-functions-called-once` flags are used,
tpm_is_hwrng_enabled is not inline.

And this optimization some how cannot occur,
leading to the undefined reference errors during linking.

Adding the `__always_inline` attribute ensures that
`tpm_is_hwrng_enabled` is inlined regardless of the compiler flags.
This allows the dead code elimination to proceed as expected,
resolving the linking issue.

Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 drivers/char/tpm/tpm-chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e25daf2396d37bcaeae8a96267764df0861ad1be..48cc74d84247e258a39f2118e03aa10d0cbb066a 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -534,7 +534,7 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	return tpm_get_random(chip, data, max);
 }
 
-static bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
+static __always_inline bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
 {
 	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
 		return false;

-- 
2.48.1



