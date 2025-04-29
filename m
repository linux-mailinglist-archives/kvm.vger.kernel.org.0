Return-Path: <kvm+bounces-44664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45630AA0141
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8403B874A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255E8275876;
	Tue, 29 Apr 2025 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JE0vEjoK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86122741C2;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745899578; cv=none; b=AD+WZrqWIz73bswLr1jw5ILxq1fqdXD4PSDDlTQ+cdNNNO2KEtv2Xu+Q8y+HNOfRLRt+VnXipYaVCPMjAfgzCUzqXY1IM/9QSnNkw2FfX1JFHcX44rdo+prluvbiG5C8cXyNJav1eeMAnJf9+6OCf/0pJjtEqBE0F1od613QzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745899578; c=relaxed/simple;
	bh=I3qZ450wr0Q9CAPbI9DMJdfFZ5c1+02YMYdsGYpKCO4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ue+oEsvHSxwCu+IKP/oQYK+5mqilH1/XxEaP84h++etsYrUvISPnq2RI9gTbvHqbc0ezLejkkeqvCLzp7IIhTzVfGZOYyNanSef6hUSCxkY3OL2RyXQQbJ+e0XETXy/HoZ0tPpJbMZtd/qu+2vzHCiQNRMOMgvyYRrIbm7s+jNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JE0vEjoK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58FE1C4CEFF;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745899577;
	bh=I3qZ450wr0Q9CAPbI9DMJdfFZ5c1+02YMYdsGYpKCO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JE0vEjoKdI3aoLXySgz46sIqLxGHS10+ctvdryhzIzUS4HhXuF3Tl298hubpjKFM/
	 w6TK/WAFgLyiSvmTT0C7btzFR8/sJwuEVJ7dvhLp/FopZjfp4F38JZxjFbjWToxx+2
	 ZOs3hbeOeMzuD9W/l6w5BjAZ2TP8rnJk5mpj6qfsfebVTmp5WeguGbLar2dJg+54Ta
	 BQeBNnkwOGxnWBYdRi+L77qoR8Ib+Sgt4uGR4FMtkCWkIFE7JcS9361sDdnaf8uzpI
	 5PpYZSpLvvidhBYF+z1LHu2vN47VszMgmkxuY95ZwPxZ0LohS1hnrc8xtucx7pzmvs
	 64lF44iLXmi+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8CFC3ABA8;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Tue, 29 Apr 2025 12:06:12 +0800
Subject: [PATCH RFC v3 8/8] lib/Kconfig.debug: introduce
 CONFIG_NO_AUTO_INLINE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-noautoinline-v3-8-4c49f28ea5b5@uniontech.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4279;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=Bd93x7WuEFeV0iOsS3dMjqDGQS+n9awf6aimsKD9UOk=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBoEFA1dN0rUHGv15CSgUAacYmKqLp9Xxxon6yon
 c7TiGmprM+JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaBBQNQAKCRB2HuYUOZmu
 i55nD/9Z3vTJGmV0EjUhmeI4qXKmcdAMAq1X/bMvCKKqJb8nDqxr3XzOsrgtlGbWtGbSRpAcMRC
 kIBZwz/EFrXdSky2mgTEfswE2JzuHKo+Mt434POfvbTmTZzfhinHk2rveNLn14K6QQxOZNTHzoq
 DY3XtiBsr5/6XiSk58sFs0UB2do+v1RDxbRgPVRbwakBRf2EpGtYK+ZkSVPourJzkqG7PrIvHKY
 FyKSLRcxh2ehQ+zdjfMyhxbXKMW3rLF6KyReLohSbuPnAZH9vBG07d85cT+hlqayZ2VFrTJWayX
 ogvHBmQbs0jd6kEOOcqxulI9+HLWeFHpLWXkscXCbtKYFnN3of88CFc5dM1NBfTsa2bE/5c69eS
 TXaS9CEvSaJLZP2bguKxeYXuKMcX7aCIEmkb5ywt+zXQ2sBHHXVo62B2vH+ZEPTvJ0JBvREoDHA
 Z07bh3e0yi+U/gCk96uDLgnOmSkQUjen6r/WDp03CqP8r46lIU2aWAN8mPN0/bL6Leb+yx3Y5Gf
 MfHerWdPEqYeBh6stf8GRI22HdoAjnaigM4iGlYaLrvgjiuVjR2tHFFGtnPEviP7O+74W7AnPTn
 n9vHmKNe5H9AurNLXL/K7j5eRYSPpaBVROMuUUngVLHw7qljfnSQMwRNYonB6pGCO3WTd5AnIHj
 tq2/DJ+5MgngDcg==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Chen Linxuan <chenlinxuan@uniontech.com>

Add a new kernel hacking option CONFIG_NO_AUTO_INLINE that prevents the
compiler from auto-inlining functions not explicitly marked with the
'inline' keyword.

This enhancement improves function tracer capabilities as it can only
trace functions that haven't been inlined by the compiler.

Previous discussions:

Link: https://lore.kernel.org/all/20181028130945.23581-3-changbin.du@gmail.com/

This patch is modified from commit 917fad29febd ("kernel hacking: add a
config option to disable compiler auto-inlining") which can be founded
in linux-next-history:

Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git/commit/?id=917fad29febd

Cc: Changbin Du <changbin.du@gmail.com>
Co-developed-by: Winston Wen <wentao@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
---
 Makefile          | 16 ++++++++++++++++
 lib/Kconfig.debug | 21 +++++++++++++++++++++
 lib/Makefile      |  3 +++
 3 files changed, 40 insertions(+)

diff --git a/Makefile b/Makefile
index 5aa9ee52a765b7aed27f44028cdcc34a90979acb..60dec6c123543150a3332a9a819fa6933e94db4f 100644
--- a/Makefile
+++ b/Makefile
@@ -1073,6 +1073,22 @@ endif
 # Ensure compilers do not transform certain loops into calls to wcslen()
 KBUILD_CFLAGS += -fno-builtin-wcslen
 
+ifdef CONFIG_NO_AUTO_INLINE
+# -fno-inline-functions behaves differently between gcc and clang.
+# With gcc, it prevents auto-inlining of functions but still considers functions
+# explicitly marked with "inline" for inlining. However, with clang, the flag
+# prevents inlining of all functions, including those explicitly marked with
+# inline. Clang provides the "-finline-hint-functions" option, which
+# specifically allows inlining of functions marked with "inline".
+#
+# In summary, to achieve equivalent behavior across compilers:
+# -fno-inline-functions (gcc) = -fno-inline-functions + -finline-hint-functions (clang)
+KBUILD_CFLAGS   += -fno-inline-functions \
+		   $(call cc-option, -finline-hint-functions) \
+		   $(call cc-option, -fno-inline-small-functions) \
+		   $(call cc-option, -fno-inline-functions-called-once)
+endif
+
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-ffile-prefix-map=$(srcroot)/=)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f9051ab610d54358b21d61c141b737bb345b4cee..56530f0145c885e9846dae1d2f8c6125c610d25b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -436,8 +436,29 @@ config GDB_SCRIPTS
 	  instance. See Documentation/process/debugging/gdb-kernel-debugging.rst
 	  for further details.
 
+
 endif # DEBUG_INFO
 
+config NO_AUTO_INLINE
+	bool "Disable compiler auto-inline optimizations (EXPERIMENTAL)"
+	default n
+	help
+	  This will prevent the compiler from optimizing the kernel by
+	  auto-inlining functions not marked with the inline keyword.
+	  With this option, only functions explicitly marked with
+	  "inline" will be inlined. This will allow the function tracer
+	  to trace more functions because it only traces functions that
+	  the compiler has not inlined.
+
+	  Note that Clang with -O2 optimization does not fully support
+	  disabling all inline-related optimizations,
+	  as Clang does not support options like
+	  -fno-inline-small-functions and -fno-inline-functions-called-once
+	  that gcc does.
+	  Some functions without the inline keyword may still be inlined.
+
+	  If unsure, select N.
+
 config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
diff --git a/lib/Makefile b/lib/Makefile
index f07b24ce1b3f8db28796e461db1324d97133fdd5..2ac97f0856a12f66e6c3825af6aabafa61869262 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -87,6 +87,9 @@ obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_KASAN),yy)
 # FIXME: Clang breaks test_bitmap_const_eval when KASAN and GCOV are enabled
 GCOV_PROFILE_test_bitmap.o := n
+# FIXME:
+# Clang breaks test_bitmap_const_eval when NO_AUTO_INLINE and KASAN are enabled
+CFLAGS_test_bitmap.o += -finline-functions
 endif
 
 obj-$(CONFIG_TEST_UUID) += test_uuid.o

-- 
2.43.0



