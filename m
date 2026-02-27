Return-Path: <kvm+bounces-72177-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNQbIVfOoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72177-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:03:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA35C1BB285
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 236F2317365E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4918435970F;
	Fri, 27 Feb 2026 16:59:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289233491DB
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211581; cv=none; b=fPEJRa2hiF/ZGocJQ3nwaNiFuW3M0UAIcWn9FCjMuBIAPhSYy8DE1P6CZFW2vnLdInjAyP38i/vfwhek8YokQYyUYtRZzuqOb2UCgB1MvF1HYPzOfGpNDMqGnRlq2a88iIdQxrvscZB6h+kWYjCW+s8QClQKoPYj/JxTEPnvxn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211581; c=relaxed/simple;
	bh=bmpY37SfFHrmwJIJ14JXzWKqNu3NnluQ2NHsYxgEuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rO2X6XAdjDggGrbA85fCCFNpH5Js+Z/Pp7r4VHBXgLlQwJFY6PmqXJyRVrwoSwMoltMYeVSgKI4T/2L5WWzJOZVZE4roysLW5CCgzQZppthjJ7ptSbeX997+QLm+VSb8ycXmCs7pRh/qXmvFLWymGM0BcckNKSrjYrHrP+cNxXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A67414BF;
	Fri, 27 Feb 2026 08:59:33 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 635D43F73B;
	Fri, 27 Feb 2026 08:59:38 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v6 01/17] util/update_headers: Update linux/const.h from linux sources
Date: Fri, 27 Feb 2026 16:56:08 +0000
Message-ID: <20260227165624.1519865-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72177-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCPT_COUNT_SEVEN(0.00)[11];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email,ventanamicro.com:email]
X-Rspamd-Queue-Id: BA35C1BB285
X-Rspamd-Action: no action

Building kvmtool from scratch gives me the following errors with buildroot:

In file included from include/kvm/pci.h:7,
                 from include/kvm/vfio.h:6,
                 from include/kvm/kvm-config.h:5,
                 from include/kvm/kvm.h:6,
                 from builtin-version.c:4:
include/linux/virtio_pci.h:323:20: warning: implicit declaration of function ‘__KERNEL_DIV_ROUND_UP’ [-Wimplicit-function-declaration]
  323 | #define MAX_CAP_ID __KERNEL_DIV_ROUND_UP(VIRTIO_DEV_PARTS_CAP + 1, 64)
      |                    ^~~~~~~~~~~~~~~~~~~~~
include/linux/virtio_pci.h:326:24: note: in expansion of macro ‘MAX_CAP_ID’
  326 |  __le64 supported_caps[MAX_CAP_ID];
      |                        ^~~~~~~~~~
include/linux/virtio_pci.h:326:9: error: variably modified ‘supported_caps’ at file scope
  326 |  __le64 supported_caps[MAX_CAP_ID];

We inherit linux/virtio_pci.h from the kernel sources and won't be good to fix
it by including linux/kernel.h. Instead, pick up up uapi/linux/const.h from the
kernel tree. This also removes the ifdefery linux/kernel.h

To prevent a build warning for redefinition, update the headers from v6.19,
remove the hack from linux.kernel.h in one shot. This was also discussed in
the Link, in another context.

Cc: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/all/20250211114018.GB8965@willie-the-truck/
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/linux/const.h  | 53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |  3 ---
 util/update_headers.sh |  1 +
 3 files changed, 54 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/const.h

diff --git a/include/linux/const.h b/include/linux/const.h
new file mode 100644
index 00000000..b8f629ef
--- /dev/null
+++ b/include/linux/const.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _UAPI_LINUX_CONST_H
+#define _UAPI_LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#define _AT(T,X)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#endif
+
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
+
+#if !defined(__ASSEMBLY__)
+/*
+ * Missing asm support
+ *
+ * __BIT128() would not work in the asm code, as it shifts an
+ * 'unsigned __int128' data type as direct representation of
+ * 128 bit constants is not supported in the gcc compiler, as
+ * they get silently truncated.
+ *
+ * TODO: Please revisit this implementation when gcc compiler
+ * starts representing 128 bit constants directly like long
+ * and unsigned long etc. Subsequently drop the comment for
+ * GENMASK_U128() which would then start supporting asm code.
+ */
+#define _BIT128(x)	((unsigned __int128)(1) << (x))
+#endif
+
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#endif /* _UAPI_LINUX_CONST_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index df42d63a..6c22f1c0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -8,9 +8,6 @@
 #define round_down(x, y)	((x) & ~__round_mask(x, y))
 
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#ifndef __KERNEL_DIV_ROUND_UP
-#define __KERNEL_DIV_ROUND_UP(n,d)	DIV_ROUND_UP(n,d)
-#endif
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
diff --git a/util/update_headers.sh b/util/update_headers.sh
index af75ca36..105bfc1d 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -29,6 +29,7 @@ then
 fi
 
 cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
+cp -- "$LINUX_ROOT/include/uap/linux/const.h" include/linux
 
 for header in $VIRTIO_LIST
 do
-- 
2.43.0


