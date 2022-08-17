Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71647596C64
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 11:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiHQJyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 05:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbiHQJy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 05:54:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3846171F;
        Wed, 17 Aug 2022 02:54:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso1327085pjf.5;
        Wed, 17 Aug 2022 02:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Q8yIeDXKvAPXO/u191ojnCcXVcR6Jj8Vwm4nP5oHJBk=;
        b=fqChXqXag1w8BrkhvYXBkAv/HnCPvcu6gWDuPHukP869W3y2WwTyF9j5EzWyw6q0y8
         farL0wYDAbzY/2d/0iDqysTveUCZ0rk/POVNv+raR4DL5kjl4/1zJ7hG0pBc1L0uxC2r
         f/bRnu96NnwGdAZI/BdebKaOb0WBm7vQZ3czw+hU18NXDZdPYCELDU+I+crmLwcfoo+v
         esTQwA9/GVdC1jV636GipkbpDxvJpoLsBF2ML7rjJWlad1F2P83mu94SK9OPqqAAXnHu
         oWlto9olDA7Pl7OmKlujY9cmdrSdQzIsyHo82RKYo3uY+yzZNHs+QqRXIVQ1/3PIwNSg
         JeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Q8yIeDXKvAPXO/u191ojnCcXVcR6Jj8Vwm4nP5oHJBk=;
        b=VWGUh9rNmU1VJaKDyWPl/EOUp055XVWs+er/gkznwk33C1f25+fb22ylaDg27wxteK
         4MHhULmsTeYRw8ietBxiQUwv2vPWkFO5kdxY+U3C3vmrxLYeRsBftVUh3iW05ZwyBb6C
         EMS/9Lm/hpbNEuOqrygvCsgU2whJC93E9LNVmQPitVz734adChzSor6tljaXPKMVfoBt
         ATDikF7XemOiGGFXTCKizerRAtv9D/+GWPtUhBwEG53DGP/xusHa7dPtfNFPvkvOK/iB
         1t2KN5KgjBaSJh25ty52uQmqMQyHFBYBNW0gEIQZRyufUEx6vHS3muRljOYZZ1Esvl1h
         qg5w==
X-Gm-Message-State: ACgBeo1nAh20RnoQG2e/7fsso9QOp6Zoco7ZCVARoGhsP5fK+9u3CM+w
        wO50pbXcZYop1FEdlHNcI2O0mEGAan0=
X-Google-Smtp-Source: AA6agR6l1wXEuTDMQH2DUMEm2R8qGuIXRUtZALMkGQuEsZS4a//HtjIPdsjNsKxtq8fGuOkY96kF8Q==
X-Received: by 2002:a17:90b:4b04:b0:1f5:2da0:b2f6 with SMTP id lx4-20020a17090b4b0400b001f52da0b2f6mr2841616pjb.195.1660730062768;
        Wed, 17 Aug 2022 02:54:22 -0700 (PDT)
Received: from debian.. (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016dbce87aecsm1066486plh.182.2022.08.17.02.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:54:22 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 2/3] Documentation: ABI: tdx: grammar improv
Date:   Wed, 17 Aug 2022 16:54:04 +0700
Message-Id: <20220817095405.199662-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817095405.199662-1-bagasdotme@gmail.com>
References: <20220817095405.199662-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4681; i=bagasdotme@gmail.com; h=from:subject; bh=gPYfLNZAgutYZuDMkr+1ZOb2UPKl6XXae6w2D88mA4k=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/du0REIvfstNn/YucmQYKQX9UmHaGlVon5n05WF+0YNst wa1nOkpZGMQ4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRvZcY/vuaXos5PCma7Tjz7KvGE5 jrpOyD5ZqC32uufJl04fPh+QcY/oduKMpgZOYI7mori1iQUvfwrSmvc8Kz3ruS9yqmTvMo5QEA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve the grammar used in TDX ABI documentation.

Fixes: 12cafff9983dad ("x86/virt/tdx: Export TDX keyid number and status of TDX module via sysfs")
Fixes: 5318e72c20e45a ("x86/virt/tdx: Export information about the TDX
module via sysfs")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/ABI/testing/sysfs-firmware-tdx | 32 +++++++++-----------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-tdx b/Documentation/ABI/testing/sysfs-firmware-tdx
index 8bf2079b83dd9f..08c477c1d00e15 100644
--- a/Documentation/ABI/testing/sysfs-firmware-tdx
+++ b/Documentation/ABI/testing/sysfs-firmware-tdx
@@ -8,11 +8,11 @@ Description:
                 malicious hosts and some physical attacks.  This directory
                 represents the entry point directory for the TDX.
 
-                the TDX requires the TDX firmware to load into an isolated
-                memory region.  It requires a two-step loading process.  It uses
-                the first phase firmware loader (a.k.a NP-SEAMLDR) that loads
-                the next loader and the second phase firmware loader(a.k.a
-                P-SEAMLDR) that loads the TDX firmware(a.k.a the "TDX module").
+                This feature requires the TDX firmware to load into an isolated
+                memory region.  It uses two-step loading process; the first
+                phase is NP-SEAMLDR loader that loads the next one and the
+                second phase is P-SEAMLDR loader that loads the TDX firmware
+                (a.k.a the "TDX module").
 
                 =============== ================================================
                 keyid_num       the number of SEAM keyid as an hexadecimal
@@ -25,16 +25,12 @@ KernelVersion:  5.17
 Contact:        Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
 Users:          libvirt
 Description:
-                The TDX requires a firmware as known as the TDX module.  It comes
-                with its attributes, vendor_id, build_data, build_num,
-                minor_version, major_version, etc.
-
-                Provides the information about the TDX module loaded on the
-                platform.  It contains the following read-only files.  The
-                information corresponds to the data structure, TDSYSINFO_STRUCT.
-                The admins or VMM management software like libvirt can refer to
-                that information, determine if TDX is supported, and identify
-                the loaded the TDX module.
+                The TDX feature requires a firmware that is known as the TDX
+                module. The module exposes its information in the following
+                read-only files. The information corresponds to the data
+                structure named TDSYSINFO_STRUCT. Administrators or VMM
+                managers like libvirt can refer to it to determine if TDX is
+                supported and identify the loaded module.
 
                 ================== ============================================
                 status             string of the TDX module status.
@@ -47,12 +43,12 @@ Description:
                                      initialized
                                    * "shutdown": the TDX module is shutdown due                                      to error during initialization.
 
-                attributes         32bit flags of the TDX module attributes as
+                attributes         32-bit flags of the TDX module attributes as
                                    a hexadecimal number with the "0x" prefix.
 
                                    * Bits 31 - a production module(0) or
                                      a debug module(1).
-                                   * Bits 30:0 Reserved - set to 0.
+                                   * Bits 0-30 - Reserved - set to 0.
 
                 vendor_id          vendor ID as a hexadecimal number with the
                                    "0x" prefix.
@@ -61,7 +57,7 @@ Description:
                                    the "0x" prefix.
                 minor_version      minor version as a hexadecimal number with
                                    the "0x" prefix.
-                major_version      major versionas a hexadecimal number with
+                major_version      major version as a hexadecimal number with
                                    the "0x" prefix.
                 ================== ============================================
 
-- 
An old man doll... just what I always wanted! - Clara

