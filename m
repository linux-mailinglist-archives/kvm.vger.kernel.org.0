Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8243F6AA135
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjCCVay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjCCVax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:30:53 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B7118A8E
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:30:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id AC8DB37E2A8275
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:30:51 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id n-a7_6PcvUgs for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:30:50 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 4951C37E2A8272
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:30:50 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 4951C37E2A8272
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677879050; bh=9yubLUg66wLypeTZGqt8xeQ1r0fR/ij41gawF147drs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=LWeVfpvvvMkrY0PlZXKvyDhuvZJTkq9dK86mynqIjKvHG9z56pElGNRw/S3UC49J9
         eE6+E18mI4MdcYGpWKIALbxBhVFY4Zo7JzxnZz2n3EMfbBSPRfnjQMtIOgbTZQiyaO
         5MLmhAvCjtG5rVaT6sQOjOV6LZKiOL48VihGOnwE=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iDA3ZqWO1fsJ for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:30:50 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 2F00A37E2A826F
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:30:50 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:30:50 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <1233540152.16281479.1677879050163.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 5/5] Add myself to MAINTAINERS for Power VFIO support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: a3FxygzvEfYkYGcFAiS08/w5955CqQ==
Thread-Topic: Add myself to MAINTAINERS for Power VFIO support
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a5c25c20d00..2b5358ccc8f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9954,6 +9954,11 @@ F:	drivers/crypto/vmx/ghash*
 F:	drivers/crypto/vmx/ppc-xlate.pl
 F:	drivers/crypto/vmx/vmx.c
 
+IBM Power VFIO Support
+M:	Timothy Pearson <tpearson@raptorengineering.com>
+S:	Supported
+F:	drivers/vfio/vfio_iommu_spapr_tce.c
+
 IBM ServeRAID RAID DRIVER
 S:	Orphan
 F:	drivers/scsi/ips.*
-- 
2.30.2
