Return-Path: <kvm+bounces-44662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EEAAA0140
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96AE91B63DEC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E73275869;
	Tue, 29 Apr 2025 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImSxOheg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CDF270EAF;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745899577; cv=none; b=F7I9BfC8eFgmq2qjxKKEzpzT6q89K/BVVEn9+1g6KGfMPHPxt+M+LyxUMnXZV4oN5gzt9y9FKkMA71iQMKn22qBAX+A80KSjoV9Rbmi2M9yYfTAB7V0GcOjUSruVgmN5FVjmWyG/xjHjj6nZMlmrBKM6saOevCRsaCKGm1wtDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745899577; c=relaxed/simple;
	bh=3PdF33JBq1nyxsd62zvfFmuPbfAnSnsdpa3r3ouJFOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tv7Nbvw519jroQ0WkJLA4Z1CGpkLtnDTGTDEGbjcugf3RAjkbnAcduA6YD21XB1+/Q7XQN6O9QbdSVn9+d90RdY4p6B23dmoxXbq9+Es8QkP4Ko1ghc7wAyPPRfXTLNzsNdc8mIV0ylW3ImHD2NQkqxraIpB1oEN6NBWFKhTQqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImSxOheg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B92EC113CF;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745899577;
	bh=3PdF33JBq1nyxsd62zvfFmuPbfAnSnsdpa3r3ouJFOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ImSxOhegHftYhReRG8oW+oM6LY5yoKLWrzrGW2V//kVusiY4KJ6C0HKApYqiV/umZ
	 jZDui8NpjNYOGK5MqF5aClgT+4pvtjZWMb3AgQxuqqCOAz00C0Lpow4dLS8fVmD8AE
	 Ew5h7vn3uiwE1AvsN5M2//c/5JyZpQKKbX7Q2uuKJzjHODfOAkvLYlkfv/lDyfol63
	 jo+QK5Rd1p+0TMQoBTMEsNJWU3r3jcXOzCGrBtNYQaJBhwRFYH8Og+3Yvb56e+MIWk
	 lrqdTOn18f4raKMikcfbZmVYGUzYJPzipTeU+RQml6v6GlEpxvCZhUZyn6fyKdVLbn
	 3BOR5syl/U+lg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4210C369D1;
	Tue, 29 Apr 2025 04:06:16 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Tue, 29 Apr 2025 12:06:08 +0800
Subject: [PATCH RFC v3 4/8] tpm: add __always_inline for
 tpm_is_hwrng_enabled
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-noautoinline-v3-4-4c49f28ea5b5@uniontech.com>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
In-Reply-To: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
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
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Juergen Gross <jgross@suse.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 kasan-dev@googlegroups.com, xen-devel@lists.xenproject.org, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3942;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=kxFAxUbcgxKFCXw3/ErTxJwPqpRyvp2FJuqCBA7VzuY=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBoEFAxPbGcLXiOi/dV/SoVEXm3HRnbi5/8nSvZh
 +e82+25uS6JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaBBQMQAKCRB2HuYUOZmu
 i+71D/9hbbS4WFdBy9iBvtGFu5uSk9QxvEUgVVEszHz05+5HiG4ksE8wbutqqbHRzodOZ4fTRqw
 FBgWQudMTfmZ9Fzj2OyQSpBDCrM8FsKFEp555qc9ICcP/+NEGCSsRMIq6JHxaZziOrAUiqsMpl7
 PDahCNl1FroL8m5qLyTgyojpMOANxIr1af/VNJ8bPL6C+kt3UbvxE1BQxJaGaFWwu4tuA6W2H6P
 99dM27ARBneT1Ci6a8VKJuN083PUS0DxYveGnH1FdDIjWVzoNOuccgzNF0F8v4/nl2tP84KxlLQ
 oPDVasKXAZJN0tEcMKQIwEAC+r1bcpKYHpMRVEYDYmBa264Q5nFxMISnjvLEJCKf83yqHDECcUe
 tggtJisUCNA23s3fRH1vFO5aVh1wasktvWFK0rezqWKiiSOynNsUWjQButCpUZofWo4wTHmJihb
 Ia2GiI8yLBpkdorp4xsf4SL4zvcLOzgirApNORHtHhkb9txKJ20L2WHS1VhiW7xpl3ejCcR9CpP
 YW9L2nkVmlDG0qngRaNtWv3EZCV/wN9/811wqZzwMQLNekcn/t8lq9fv9RB/bPjq7aCVZESyGER
 OBAzAGQDg3kym5GaVrbjje99pIap2zj0QwO9eZHif/0av9uHNFusDMAZGbKPHCqaEevUMehhBGq
 Eom+AMw7eNH7lTQ==
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
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
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
2.43.0



