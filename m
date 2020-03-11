Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6B2181DB0
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 17:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgCKQZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 12:25:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726314AbgCKQY7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 12:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583943897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DVeoZZJMMZCCIarL9YyHSuTSAyd4nyhK1RYWiCBuaY4=;
        b=BAZQOUatm2J80CrF99MDtRG73DPnskbYcb70Db3KG4mbOVHt80FMFrcXujGCS9u9OpMxZ3
        zsZFCHiZcNwiNtSA3eYrDxx4rEDB5/z6Pf686h1EuWJX3Lr3WzJJxF2qYtPx4qfNnmwb5r
        dtBO/mnFu7YwBXaXoEuRqt4g3EZffs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-E-cCTqctOkmBYw0OSiI2mQ-1; Wed, 11 Mar 2020 12:24:53 -0400
X-MC-Unique: E-cCTqctOkmBYw0OSiI2mQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 174C61005510;
        Wed, 11 Mar 2020 16:24:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-206-80.brq.redhat.com [10.40.206.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 407F726E6D;
        Wed, 11 Mar 2020 16:24:45 +0000 (UTC)
Date:   Wed, 11 Mar 2020 17:24:42 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v6 00/13] arm/arm64: Add ITS tests
Message-ID: <20200311162442.th564amlnxsvzjqc@kamzik.brq.redhat.com>
References: <20200311135117.9366-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311135117.9366-1-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 02:51:04PM +0100, Eric Auger wrote:
> This series is a revival of an RFC series sent in Dec 2016 [1].
> Given the amount of code and the lack of traction at that time,
> I haven't respinned until now. However a recent bug found related
> to the ITS migration convinced me that this work may deserve to be
> respinned and enhanced.
> 
> Tests exercise main ITS commands and also test migration.
> With the migration framework, we are able to trigger the
> migration from guest and that is very practical actually.
> 
> What is particular with the ITS programming is that most of
> the commands are passed through queues and there is real error
> handling. Invalid commands are just ignored and that is not
> really tester friendly.
> 
> The series can be fount at:
> https://github.com/eauger/kut/tree/its-v6
> 
> Applies on top of arm/queue.
> 
> Best Regards
> 
> Eric
> 
> History:
> v5 -> v6:
> - Took into account Zenghui's comments, mostly functional: see invidual
>   history logs
> - fix wrong assert!
> 
> v4 -> v5:
> - 32b stubs moved back to arm/gic.c
> - some changes reordering
> - minor style issues
> 
> v3 -> v4:
> - addressed comments from Drew and Zenghui
> - added "page_alloc: Introduce get_order()"
> - removed "arm: gic: Provide per-IRQ helper functions"
> - ITS files moved to lib64
> - and many more, see individual logs
> 
> v2 -> v3:
> - fix 32b compilation
> - take into account Drew's comments (see individual diff logs)
> 
> v1 -> v2:
> - took into account Zenghui's comments
> - collect R-b's from Thomas
> 
> References:
> [1] [kvm-unit-tests RFC 00/15] arm/arm64: add ITS framework
>     https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00575.html
> 
> Execution:
> x For other ITS tests:
>   ./run_tests.sh -g its
> 
> x non migration tests can be launched invidually. For instance:
>   ./arm-run arm/gic.flat -smp 8 -append 'its-trigger'
> 
> Eric Auger (13):
>   libcflat: Add other size defines
>   page_alloc: Introduce get_order()
>   arm/arm64: gic: Introduce setup_irq() helper
>   arm/arm64: gicv3: Add some re-distributor defines
>   arm/arm64: gicv3: Set the LPI config and pending tables
>   arm/arm64: ITS: Introspection tests
>   arm/arm64: ITS: its_enable_defaults
>   arm/arm64: ITS: Device and collection Initialization
>   arm/arm64: ITS: Commands
>   arm/arm64: ITS: INT functional tests
>   arm/run: Allow Migration tests
>   arm/arm64: ITS: migration tests
>   arm/arm64: ITS: pending table migration test
> 
>  arm/Makefile.arm64         |   1 +
>  arm/Makefile.common        |   2 +-
>  arm/gic.c                  | 460 ++++++++++++++++++++++++++++++++++--
>  arm/run                    |   2 +-
>  arm/unittests.cfg          |  38 +++
>  lib/alloc_page.c           |   7 +-
>  lib/alloc_page.h           |   1 +
>  lib/arm/asm/gic-v3-its.h   |  22 ++
>  lib/arm/asm/gic-v3.h       |  29 +++
>  lib/arm/asm/processor.h    |   2 +
>  lib/arm/gic-v3.c           |  78 +++++++
>  lib/arm/gic.c              |  34 ++-
>  lib/arm/io.c               |  28 +++
>  lib/arm64/asm/gic-v3-its.h | 170 ++++++++++++++
>  lib/arm64/gic-v3-its-cmd.c | 464 +++++++++++++++++++++++++++++++++++++
>  lib/arm64/gic-v3-its.c     | 172 ++++++++++++++
>  lib/libcflat.h             |   3 +
>  17 files changed, 1484 insertions(+), 29 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/gic-v3-its-cmd.c
>  create mode 100644 lib/arm64/gic-v3-its.c
> 
> -- 
> 2.20.1
> 
>

Hi Eric,

You don't need to respin for me, but let's see if Zenghui has time for
another review and possibly more r-b's for me to collect.

While applying I made a few changes that you can integrate if you do
respin (I can also make the for_each_present_cpu changes myself, if
you don't respin.)

The changes are for the following reasons and are almost all in
"arm/arm64: ITS: Introspection tests"

 * Only calling its_init for arm64-gicv3, and removing the report call
 * Not including gic-v3-its.h anywhere directly
 * One spaces to tab

diff of the changes below

diff --git a/arm/gic.c b/arm/gic.c
index 763ed1bc5106..2c56eb212425 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -16,7 +16,6 @@
 #include <asm/processor.h>
 #include <asm/delay.h>
 #include <asm/gic.h>
-#include <asm/gic-v3-its.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
 #include <asm/io.h>
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 2167099eb5d1..1af085ef53be 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -5,10 +5,15 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-
 #ifndef _ASMARM_GIC_V3_ITS_H_
 #define _ASMARM_GIC_V3_ITS_H_
 
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v3-its.h>. Include <asm/gic.h>
+#endif
+
+#include <libcflat.h>
+
 /* dummy its_data struct to allow gic_get_dt_bases() call */
 struct its_data {
 	void *base;
@@ -16,7 +21,7 @@ struct its_data {
 
 static inline void its_init(void)
 {
-	report_abort("not supported on 32-bit");
+	assert_msg(false, "ITS not supported on 32-bit");
 }
 
-#endif /* _ASMARM_GICv3_ITS_H_ */
+#endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 922cbe95750c..9564d4f80b93 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -40,6 +40,7 @@
 
 #include <asm/gic-v2.h>
 #include <asm/gic-v3.h>
+#include <asm/gic-v3-its.h>
 
 #define PPI(irq)			((irq) + 16)
 #define SPI(irq)			((irq) + GIC_FIRST_SPI)
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 4f6f15b1eb8a..a807d5f86ee9 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -6,7 +6,6 @@
 #include <devicetree.h>
 #include <asm/gic.h>
 #include <asm/io.h>
-#include <asm/gic-v3-its.h>
 
 struct gicv2_data gicv2_data;
 struct gicv3_data gicv3_data;
@@ -123,11 +122,14 @@ int gic_version(void)
 
 int gic_init(void)
 {
-	if (gicv2_init())
+	if (gicv2_init()) {
 		gic_common_ops = &gicv2_common_ops;
-	else if (gicv3_init())
+	} else if (gicv3_init()) {
 		gic_common_ops = &gicv3_common_ops;
-	its_init();
+#ifdef __aarch64__
+		its_init();
+#endif
+	}
 	return gic_version();
 }
 
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index 872953c005d2..412f43849bac 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -8,6 +8,10 @@
 #ifndef _ASMARM64_GIC_V3_ITS_H_
 #define _ASMARM64_GIC_V3_ITS_H_
 
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v3-its.h>. Include <asm/gic.h>
+#endif
+
 struct its_typer {
 	unsigned int ite_size;
 	unsigned int eventid_bits;
@@ -26,7 +30,7 @@ struct its_baser {
 	phys_addr_t table_addr;
 };
 
-#define GITS_BASER_NR_REGS              8
+#define GITS_BASER_NR_REGS		8
 #define GITS_MAX_DEVICES		8
 #define GITS_MAX_COLLECTIONS		8
 
diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
index 34b090459ef4..65f1c8c8752f 100644
--- a/lib/arm64/gic-v3-its-cmd.c
+++ b/lib/arm64/gic-v3-its-cmd.c
@@ -7,7 +7,6 @@
  */
 #include <asm/io.h>
 #include <asm/gic.h>
-#include <asm/gic-v3-its.h>
 
 #define ITS_ITT_ALIGN		SZ_256
 
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index 9c9fa60400f3..6a3642182bf7 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -5,7 +5,6 @@
  */
 #include <asm/gic.h>
 #include <alloc_page.h>
-#include <asm/gic-v3-its.h>
 
 void its_parse_typer(void)
 {

 

