Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26EF596EC3
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbiHQMtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 08:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiHQMsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 08:48:52 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA504598D;
        Wed, 17 Aug 2022 05:48:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f30so11981386pfq.4;
        Wed, 17 Aug 2022 05:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ILb0urCCzGUfPS1xQtlB5QcmwtGAe53OxwODPA6Tu70=;
        b=VM8giC6aRYYb7P+k+OxkxH7IyP/gYux/9xmb7M2wQQmRzAjwYFXnbfuwCt0Jk3crF5
         GGh51wvjfYW2TgsQ/E9RrisS16or1ZozhMeeXUJglNgAHUCwmaLP2rgkrHb3/oD4lB37
         ZwZJptJuc3QkksM7PlXAlbbEoCHXUGJNAcfrOHw1NOAJdWu79kl0okAxPWgrB3UfnnB0
         tCA19yh6DlNl0UdAubwrWlrzoBFc7KqB+rafLv8JYljbVcoOiZQnLPIO/ayjFu/3L+gI
         7uNV7GfI08N7P5LZB6uopYNljmk3PVjnMp0z+S84Fvy5gP6xi33G5XPGMP1C/0l58pZU
         /Dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ILb0urCCzGUfPS1xQtlB5QcmwtGAe53OxwODPA6Tu70=;
        b=DJ/NGDAu5O37vmAmvdish/TgBmUrIpCqknNOf1rToXofMEj2OebKjTezOPlfPsYXCW
         0NK4+psOofIvTJQJH847S9BHRqs4CvTYwlA9JIwRWEpcbYE8IHD+R8SIiX50rKwX+oik
         W3gQE0bwCVeOGQjFONXgNKQF49Qz32lL0g4Bu2nGWyuanMKMA7Qwv3Euj7N/XfqjhxjV
         pkXLztNdpjwNZT3QqTVRBtwSKAltnRHDeF/0N26Bcmw2hYd11d7dh5ieZR4wz1snKI/l
         dTlBU2B8ovjMTTndc80mvTOdiLkMXw5SWBUGIa7DDaZRzoeWW9T9nluoBfoinaxLBexR
         NISg==
X-Gm-Message-State: ACgBeo28gQUdp4zcqTY2DvPq9zU/xS/iZX4Alk6oplqg1u45Uvt0Hr0H
        6usilei7mEx/54d9RR66znbk+jtxC7HSnw==
X-Google-Smtp-Source: AA6agR7t+EIy8PVMoyftxa2KEfJ9wXtqB9q7bZ1H31irnuBK46TuTZMAcVfvcrY9kYrot38AoYQVZg==
X-Received: by 2002:a05:6a02:30b:b0:41d:ad3b:2733 with SMTP id bn11-20020a056a02030b00b0041dad3b2733mr21836582pgb.8.1660740531386;
        Wed, 17 Aug 2022 05:48:51 -0700 (PDT)
Received: from debian.. (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902a3c500b0016a4db13429sm1386962plb.192.2022.08.17.05.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 05:48:51 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/3] Documentation: ABI: tdx: fix formatting in ABI documentation
Date:   Wed, 17 Aug 2022 19:48:35 +0700
Message-Id: <20220817124837.422695-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817124837.422695-1-bagasdotme@gmail.com>
References: <20220817124837.422695-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6192; i=bagasdotme@gmail.com; h=from:subject; bh=4yhdDPmAg0byhHz5y6rd3XaMpJQUXrl9ZVfPAVugTpE=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/Hi+ZeHTHBFmpOxkl0fF8C2WezVF8fC7tVWm0o5azZOcU 6+APHaUsDGIcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjINx1GhrOJ/Q8L2m7P+6I5tcO++N 8sOalVlzj4grmO7axPvG3qwMLI8K+0SMFtgUJP8YNMv1YjJ+evEs93KumwZjGobJITlZ3EBgA=
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

Link: https://lore.kernel.org/linux-doc/202208171918.9a38xuei-lkp@intel.com/
Fixes: 12cafff9983dad ("x86/virt/tdx: Export TDX keyid number and status of TDX module via sysfs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/ABI/testing/sysfs-firmware-tdx | 32 ++++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-tdx b/Documentation/ABI/testing/sysfs-firmware-tdx
index eba50870ba0e95..bd743d758d7d49 100644
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
@@ -36,19 +38,23 @@ Description:
 
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
+                                   * "shutdown": the TDX module is shutdown due
+                                     to error during initialization.
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
@@ -59,4 +65,4 @@ Description:
                 major_version      major versionas a hexadecimal number with
                                    the "0x" prefix.
                 ================== ============================================
-Users:          libvirt
\ No newline at end of file
+
-- 
An old man doll... just what I always wanted! - Clara

