Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A96754AE
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjATMgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjATMgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:36:13 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDF9BD167;
        Fri, 20 Jan 2023 04:35:46 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i65so3876708pfc.0;
        Fri, 20 Jan 2023 04:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lvj+lN3n7gefBrB84WznopDQnyQbloNFZJdkxIWwwlI=;
        b=ZfW1d0HR/tk/QCHoZnAMTXPdoeTVIT2gV3uMXWQzT31Mdof6xlOLODGS0vst1zBZS4
         CCRjOqDiJBHMLCYX8bcdF4wSwTJUAe3h+tOzX1pwue5irt+hVJ0mFE5Wvql40VLysVl2
         mi1AVGI9o5zTyIHpqUkINK4BZcV3J/Ir0nX2llGk9OTbPthamRiAEfTkkCNgt5Y2SeZt
         7Am4smTPmyoY5pvr8pjx0qiHjuAg2w5lYIk7uyZ7HE7lAcUeJHv4u9XpHfxcTmcmlaax
         SYgaHTUjDIntLvPXlLZtZNvYljq6URzR4B+e2A+TuDb6ZGSGA8YoqyURoPTi7laUPjrz
         cDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lvj+lN3n7gefBrB84WznopDQnyQbloNFZJdkxIWwwlI=;
        b=WOe03OuWsoHrqblzPxbdQPtNueJseDCNk2in4DvCJXP5ktFkb8lqBPct0d1LPLV1A6
         LnC6yJWwHTjp27nH4sfQOMOW7wQKiLgCUqU/qVjF55cASNsZbZm9aHMOsaWLxbVfCWbC
         13BPFpEOH63ISlBXadVNelr577FCGDSBNP2gyfKBFSZBoqX2Tn2A+kk1FpFTfQS+T7+U
         6G9Q1MAZMZ4GA6yfVwRTd6CuE+PevajbtES9o8EnvqsiSEIw1swdUYRooONPoK98+hms
         Gijwig3xEc0lseygPhjt9caghImX5tivmcYQv/0xtdptLKjgbFk14Mi/udw12krgXK9x
         XVyg==
X-Gm-Message-State: AFqh2konu5pJdvUcn6cHqx2HE4ktRBEf87ldzWPUkP2/O8TWTNFioAWa
        bcivnUuuup6B9luwlSo/0yg=
X-Google-Smtp-Source: AMrXdXtZ/M/gTDupP1SLugiGMDeZsFeFVq5ip3UIWgzNz4DvstctcAj8vF4TfiG0adZJw226cSjXwg==
X-Received: by 2002:a62:aa0c:0:b0:58d:af0c:92f with SMTP id e12-20020a62aa0c000000b0058daf0c092fmr14179055pff.27.1674218143425;
        Fri, 20 Jan 2023 04:35:43 -0800 (PST)
Received: from debian.me (subs02-180-214-232-6.three.co.id. [180.214.232.6])
        by smtp.gmail.com with ESMTPSA id 128-20020a620586000000b0058b9dc62071sm15752917pff.6.2023.01.20.04.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:35:42 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 5A7E5104FA0; Fri, 20 Jan 2023 19:35:37 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH linux-next 2/3] habanalabs: Fix list of /sys/class/habanalabs/hl<n>/status
Date:   Fri, 20 Jan 2023 19:35:33 +0700
Message-Id: <20230120123534.137413-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120123534.137413-1-bagasdotme@gmail.com>
References: <20230120123534.137413-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2954; i=bagasdotme@gmail.com; h=from:subject; bh=xOFrJ7qMCcoxa1ECSCebtHmj8ODJRFVzE+m4j/iDdnc=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMmnuqbeEXh1nd/aolWu1juU49p54U+xwWqVWwMfn1EV2bzf /ldQRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACYi7M3IsP6SoMTCC1xWYhNMViqZfm 3/53r29KqM49VitaEPFVQrdjMyzIxuln19YPMTNe9i51DHGQm9IaV9LjWC4euaA2LZFK4zAwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stephen Rothwell reported htmldocs warnings when merging accel tree:

Documentation/ABI/testing/sysfs-driver-habanalabs:201: ERROR: Unexpected indentation.
Documentation/ABI/testing/sysfs-driver-habanalabs:201: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-driver-habanalabs:201: ERROR: Unexpected indentation.
Documentation/ABI/testing/sysfs-driver-habanalabs:201: WARNING: Block quote ends without a blank line; unexpected unindent.

Fix these by fixing alignment of list of card status returned by
/sys/class/habanalabs/hl<n>/status.

Link: https://lore.kernel.org/linux-next/20230120130634.61c3e857@canb.auug.org.au/
Fixes: 0a14c331682f61 ("habanalabs: update device status sysfs documentation")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../ABI/testing/sysfs-driver-habanalabs       | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-habanalabs b/Documentation/ABI/testing/sysfs-driver-habanalabs
index df2ca1a401b5a1..1b98b6503b23f5 100644
--- a/Documentation/ABI/testing/sysfs-driver-habanalabs
+++ b/Documentation/ABI/testing/sysfs-driver-habanalabs
@@ -202,17 +202,18 @@ Date:           Jan 2019
 KernelVersion:  5.1
 Contact:        ogabbay@kernel.org
 Description:    Status of the card:
-                "operational" - Device is available for work.
-                "in reset" - Device is going through reset, will be available
-                        shortly.
-                "disabled" - Device is not usable.
-                "needs reset" - Device is not usable until a hard reset will
-                        be initiated.
-                "in device creation" - Device is not available yet, as it is
-                        still initializing.
-                "in reset after device release" - Device is going through
-                        a compute-reset which is executed after a device release
-                        (relevant for Gaudi2 only).
+
+                  * "operational" - Device is available for work.
+                  * "in reset" - Device is going through reset, will be
+                    available shortly.
+                  * "disabled" - Device is not usable.
+                  * "needs reset" - Device is not usable until a hard reset
+                    is initiated.
+                  * "in device creation" - Device is not available yet, as it
+                    is still initializing.
+                  * "in reset after device release" - Device is going through
+                    a compute-reset which is executed after a device release
+                    (relevant for Gaudi2 only).
 
 What:           /sys/class/habanalabs/hl<n>/thermal_ver
 Date:           Jan 2019
-- 
An old man doll... just what I always wanted! - Clara

