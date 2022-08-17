Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0604B596C7B
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 11:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiHQJy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 05:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiHQJyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 05:54:21 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD315EDDB;
        Wed, 17 Aug 2022 02:54:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso41656pjr.3;
        Wed, 17 Aug 2022 02:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=OSRhyh9Ks6ic/j5omy+mHMVSviULGICf8m/5A4n/kak=;
        b=JSATBztfZOa/ECyvZvSW2u3Q53AS0OSKhRdxbZkDDZx8UMvz+ghZU0neT59NGljnS/
         q/jDKlpZZ0/7vrJjF0onHnHXnONabQk13dgk1Qq5rqvt3Xfuge2ba4wmwUxhSD2DYzQU
         4ADhTPwesWqDTgo7Es62gzGrtg6xdWdobtVo4Sx4LYZF5dICNGMdPdC9g2LtNPqOf4/w
         E/NvBAO8dReb+AggnXSvaCBLGpcSbgsRo8rS8nU1BJ0yopAQdwqiVIYNyZVqwpazDQOK
         bXBNlops3fCHpZNihe52e1LuXVQifFqjx5JWPiQE9Xgz7AS3jZ7Ayw4x2lsjPOWMv5wD
         AEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=OSRhyh9Ks6ic/j5omy+mHMVSviULGICf8m/5A4n/kak=;
        b=Ztv23hRcsgp47y+MTMigrrWmBJO3/k1hpRJuQc9IvgqXwgmm7U7jc01+o1XggpTkNI
         SSfEqXSb8Ut9tN3jMSQ6INv4SDvkKvH3QoNCEgfABSCCYOrgGJHzUp6tSzNDaa7V4I71
         bM6IXc90KTAFOCxgGajC3xybOa9nYPEppr5Y23F+gLz7P4xSZMEa6votG/Jw7P2whC/f
         z0gtuk/iRGVtroYM5+oJ02E+JpqfFPq+SsmijafEDeYuoMuSaKcOyOI4v2JcvCRdCsqV
         TJcTBZYcIzb/Fu0gFW71aEa8Kyve9mrJz561IbSSY1flRrjiK1AdGW91LQJhoCc1li20
         9EWQ==
X-Gm-Message-State: ACgBeo2/+PSmzAvMZLwTkLU8YFL8NrenGyCCrx4TXch1qcSgs6fFMVzS
        dyV5HMyZcjGP1HhxAPXZhhMgEjmr5Oo=
X-Google-Smtp-Source: AA6agR5CdFQTmErJ5PeA+pP5XV80A8edoibMYvEVeQcVfHK4keaYst0+ij/nXSZP8PIBHuOzSQeXpA==
X-Received: by 2002:a17:90b:4c52:b0:1f5:5129:af1a with SMTP id np18-20020a17090b4c5200b001f55129af1amr2890284pjb.202.1660730059327;
        Wed, 17 Aug 2022 02:54:19 -0700 (PDT)
Received: from debian.. (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016dbce87aecsm1066486plh.182.2022.08.17.02.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:54:19 -0700 (PDT)
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
Subject: [PATCH 1/3] Documentation: ABI: tdx: fix formatting in ABI documentation
Date:   Wed, 17 Aug 2022 16:54:03 +0700
Message-Id: <20220817095405.199662-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817095405.199662-1-bagasdotme@gmail.com>
References: <20220817095405.199662-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6064; i=bagasdotme@gmail.com; h=from:subject; bh=9hnt8j0yIVDyATCikq47pHyr5zF4i+bejofywfftp3U=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/du2Zmi3D47JKSPvCux4OrcAvX7uUbDxPP1/qN/Pkxlx2 +ZqrHaUsDGIcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZhIWgIjw13vSzf6NAWeTHll4/L/m8 oG253LdvEskq9S71bZWr9wNQsjw0yGs/dOuCkpSu3l9pilu1woPK03qyN1ie/kljyWq1ZhHAA=
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

Sphinx reported many warnings on ABI testing symbols doc entry:

Documentation/ABI/testing/sysfs-firmware-tdx:2: WARNING: Unexpected indentation.
Documentation/ABI/testing/sysfs-firmware-tdx:2: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:2: WARNING: Malformed table.
Bottom/header table border does not match top border.

=============== ================================================
<snipped>
================== ============================================
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Blank line required after table.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Unexpected indentation.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Unexpected indentation.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Definition list ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Unexpected indentation.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Definition list ends without a blank line; unexpected unindent.
Documentation/ABI/testing/sysfs-firmware-tdx:22: WARNING: Malformed table.
No bottom table border found.

================== ============================================
<snipped>

Fix the table and lists formatting.

Fixes: 12cafff9983dad ("x86/virt/tdx: Export TDX keyid number and status of TDX module via sysfs")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/ABI/testing/sysfs-firmware-tdx | 31 ++++++++++++--------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-tdx b/Documentation/ABI/testing/sysfs-firmware-tdx
index eba50870ba0e95..8bf2079b83dd9f 100644
--- a/Documentation/ABI/testing/sysfs-firmware-tdx
+++ b/Documentation/ABI/testing/sysfs-firmware-tdx
@@ -2,6 +2,7 @@ What:           /sys/firmware/tdx/
 Date:           March 2022
 KernelVersion:  5.17
 Contact:        Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
+Users:          libvirt
 Description:
                 Intel's Trust Domain Extensions (TDX) protect guest VMs from
                 malicious hosts and some physical attacks.  This directory
@@ -12,16 +13,17 @@ Description:
                 the first phase firmware loader (a.k.a NP-SEAMLDR) that loads
                 the next loader and the second phase firmware loader(a.k.a
                 P-SEAMLDR) that loads the TDX firmware(a.k.a the "TDX module").
+
                 =============== ================================================
                 keyid_num       the number of SEAM keyid as an hexadecimal
                                 number with the "0x" prefix.
                 =============== ================================================
-Users:          libvirt
 
 What:           /sys/firmware/tdx/tdx_module/
 Date:           March 2022
 KernelVersion:  5.17
 Contact:        Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
+Users:          libvirt
 Description:
                 The TDX requires a firmware as known as the TDX module.  It comes
                 with its attributes, vendor_id, build_data, build_num,
@@ -36,19 +38,22 @@ Description:
 
                 ================== ============================================
                 status             string of the TDX module status.
-                                   "unknown"
-                                   "none": the TDX module is not loaded
-                                   "loaded": The TDX module is loaded, but not
-                                             initialized
-                                   "initialized": the TDX module is fully
-                                                  initialized
-                                   "shutdown": the TDX module is shutdown due to
-                                               error during initialization.
+
+                                   * "unknown", "none": the TDX module is not
+                                     loaded
+                                   * "loaded": The TDX module is loaded, but
+                                     not initialized
+                                   * "initialized": the TDX module is fully
+                                     initialized
+                                   * "shutdown": the TDX module is shutdown due                                      to error during initialization.
+
                 attributes         32bit flags of the TDX module attributes as
                                    a hexadecimal number with the "0x" prefix.
-                                   Bits 31 - a production module(0) or
-                                             a debug module(1).
-                                   Bits 30:0 Reserved - set to 0.
+
+                                   * Bits 31 - a production module(0) or
+                                     a debug module(1).
+                                   * Bits 30:0 Reserved - set to 0.
+
                 vendor_id          vendor ID as a hexadecimal number with the
                                    "0x" prefix.
                 build_date         build date in yyyymmdd BCD format.
@@ -59,4 +64,4 @@ Description:
                 major_version      major versionas a hexadecimal number with
                                    the "0x" prefix.
                 ================== ============================================
-Users:          libvirt
\ No newline at end of file
+
-- 
An old man doll... just what I always wanted! - Clara

