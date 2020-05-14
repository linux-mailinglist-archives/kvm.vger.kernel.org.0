Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C021D2811
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgENGl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726031AbgENGl3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:29 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422DAC061A0E
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:29 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j1TrSz9sRY; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=ashVLzPUBifri1PsQalHIQvNrsJ7OliY+iJiflpx624=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiBTk1QbghtBjYM+WrQtIfWtFhpPd5X6iT0EF/7XMdBNfNEuR3wvJc171H5jBAZvN
         H/sCHg6g6uTIt1XvtIBhFUnoBXIKzvQsZqZ9onnPv/oPYhjqUnjr3yhzW7V1Gaw9PL
         Op7imZWHE2rboK07LAUL2RbBsiaDPtit+enovnCo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 01/18] target/i386: sev: Remove unused QSevGuestInfoClass
Date:   Thu, 14 May 2020 16:41:03 +1000
Message-Id: <20200514064120.449050-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure is nothing but an empty wrapper around the parent class,
which by QOM conventions means we don't need it at all.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c      | 1 -
 target/i386/sev_i386.h | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 846018a12d..d73d53d558 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -290,7 +290,6 @@ static const TypeInfo qsev_guest_info = {
     .name = TYPE_QSEV_GUEST_INFO,
     .instance_size = sizeof(QSevGuestInfo),
     .instance_finalize = qsev_guest_finalize,
-    .class_size = sizeof(QSevGuestInfoClass),
     .class_init = qsev_guest_class_init,
     .instance_init = qsev_guest_init,
     .interfaces = (InterfaceInfo[]) {
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 8ada9d385d..4f193642ac 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -41,7 +41,6 @@ extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(void);
 
 typedef struct QSevGuestInfo QSevGuestInfo;
-typedef struct QSevGuestInfoClass QSevGuestInfoClass;
 
 /**
  * QSevGuestInfo:
@@ -64,10 +63,6 @@ struct QSevGuestInfo {
     uint32_t reduced_phys_bits;
 };
 
-struct QSevGuestInfoClass {
-    ObjectClass parent_class;
-};
-
 struct SEVState {
     QSevGuestInfo *sev_info;
     uint8_t api_major;
-- 
2.26.2

