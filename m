Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2241DC5BF
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEUDnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48623 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgEUDnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:13 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnr3J0lz9sTK; Thu, 21 May 2020 13:43:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032592;
        bh=b/ySedG6EPtDyWOrvJGyJDxoH9+NiT2I5+DDWgavmns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItLRJ9KpIT0rlyJMStLLstOF0HYYFlpyWulI3c0dxJ8nha6BFpr+2qSz30UlBK9J3
         O/S6/P0+q3njZeUxbKrDpW0b+h6cgXyUgbx4NAMpji/gA/ACJr0h4bEKlPFSf+YWDD
         ESlGHcW8/1tsLgO7w1bsHou7vzvq/Pg/TOcY9IJY=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 01/18] target/i386: sev: Remove unused QSevGuestInfoClass
Date:   Thu, 21 May 2020 13:42:47 +1000
Message-Id: <20200521034304.340040-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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
index 51cdbe5496..2312510cf2 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -287,7 +287,6 @@ static const TypeInfo qsev_guest_info = {
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

