Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323136ACAE6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 18:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCFRnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 12:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCFRnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 12:43:05 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723D3E09C
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 09:42:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id BF64737E2D6111;
        Mon,  6 Mar 2023 11:31:29 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SmH_P4v-Vbwj; Mon,  6 Mar 2023 11:31:29 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 0AAB037E2D610E;
        Mon,  6 Mar 2023 11:31:29 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 0AAB037E2D610E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678123889; bh=fTU8lI8Un7GOGF+BJicHxq+cOFMCDRta41UtYHK65M0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=PiV7TdGr8IO82iim6h2i3e1dweRFs3Ez0um5+JxUVhcNp/hijecIMQpaBGOivT6GA
         TuU5CaDqM5dO8d/Ynk2UM2qUlbfLnCNJauVdKA9W1at+xrlpu8Is1vf4l2swJFwpj+
         +ji3t8sWm4pG2waH4jHQ9XT4X4YgtlHWgou0r3UE=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MEEI5Y3J0Rx7; Mon,  6 Mar 2023 11:31:28 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id E327937E2D6101;
        Mon,  6 Mar 2023 11:31:28 -0600 (CST)
Date:   Mon, 6 Mar 2023 11:31:28 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <256219069.16998525.1678123888896.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v2 4/4] Add myself to MAINTAINERS for Power VFIO support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: AKxleKwX8tG6hTXHlIF77Cy3UrdaGA==
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
index 8d5bc223f305..876f96e82d66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9836,6 +9836,11 @@ F:	drivers/crypto/vmx/ghash*
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
