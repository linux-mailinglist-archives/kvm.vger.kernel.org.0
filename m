Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD93596EB8
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbiHQMtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiHQMs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 08:48:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794264DF07;
        Wed, 17 Aug 2022 05:48:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso1763131pjk.0;
        Wed, 17 Aug 2022 05:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=VzLMj8LvRGxRre2xCtIqyaPFtJOI/wcJ1ym0fs0/Ve4=;
        b=Voqf4eE44lswVvEaaAJ8ViBVQhTTiMbP+lyup13sJrmnuuWN6ozA4Q9pOXxF05k9y8
         LzgQG+Hi3d/33q7GPmshZIh8cmFDL/fYdLce/CPjRDNOWyy3a9VnQZ8Q3tyP9+GSjlAU
         tA4oYMxLRq+wL2cJY9B7sOontW5CIsUJxL4tZZCbV4Zr8iVoKjmKNSN0XzliTD7XUIvI
         Mlgimrd1mGhVUN4Y+ONYI8B2Y0ea2KtyOpAN1cf+FmlvDWVCkp5V2ddcwnhCt1Ui2N86
         wKNttnqdkWL8rFxNhE3/9Noq0q4hCJE/nxa7Fx5STYnzFj+dn8lS4M1rTYK+1+IRD15u
         PsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=VzLMj8LvRGxRre2xCtIqyaPFtJOI/wcJ1ym0fs0/Ve4=;
        b=3Umiat0rGwXaqqvHpEiDN+3hDDd4eeVb400+SUozvCOCDSzeFzhoxpGVI4c10GpjsK
         XBTVhDWU+4d1HTzdTf/waqShCdStUgg81uN+pa6RuPimP2kGSpfk8IxqloO1Z3mQTxT+
         EfvRHCARcgibLcLMe1KWn8w+F/cqKWf+qHWVieexbz5FWOzTkycfwjuocNxWM5zTHP9H
         4WxqLiC3edSz5TXW1t1kLOUz0192Xyn+SIkljLtT5OqGEccW0jVkgPnJyvr0n8uioFP3
         QpSKUiWQs2L8iBeQ5cb2erYH/bdQU9AFUSNVtSOMUp9Gc3ZIehJWtNVivwexuftJDpKD
         1m0A==
X-Gm-Message-State: ACgBeo3Ln8M+iHf5tyQbWvvCt1B3b9836Itafu/rUA3e467nEoijbr16
        xGFyFYRTANgQ5cJB51aPhVA2OYE8UdxhiQ==
X-Google-Smtp-Source: AA6agR6ddNFswp3UDS5Ffs2XLojY9UoozV9sFUcAzV30XqRDZISCewVwqK8vesaTNL5+cNyHHazi4g==
X-Received: by 2002:a17:902:d509:b0:16f:1e1:2067 with SMTP id b9-20020a170902d50900b0016f01e12067mr25932253plg.140.1660740534751;
        Wed, 17 Aug 2022 05:48:54 -0700 (PDT)
Received: from debian.. (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902a3c500b0016a4db13429sm1386962plb.192.2022.08.17.05.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 05:48:54 -0700 (PDT)
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
Subject: [PATCH v2 2/3] Documentation: ABI: tdx: grammar improv
Date:   Wed, 17 Aug 2022 19:48:36 +0700
Message-Id: <20220817124837.422695-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817124837.422695-1-bagasdotme@gmail.com>
References: <20220817124837.422695-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4632; i=bagasdotme@gmail.com; h=from:subject; bh=zGFOYDCzO+g93HctfClyZBRrkh/4uGk0QNMepAYSg/4=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/Hi89LaqS3bBXSeLm7V/3BFoKdOpf9Eu/8jMJ3+RQKM7d xt7QUcrCIMbBICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgIlsW8vIsGd1/YfEq6rOJeVFz3bt5e 4KPOwx++/GzO74TzEf/T+wz2NkmJqkyVY8e82qOVzMp494XEswXzGvY0Zk8SS5T8tTt/Qs4gIA
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
index bd743d758d7d49..0f2feff311f047 100644
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
@@ -48,12 +44,12 @@ Description:
                                    * "shutdown": the TDX module is shutdown due
                                      to error during initialization.
 
-                attributes         32bit flags of the TDX module attributes as
+                attributes         32-bit flags of the TDX module attributes as
                                    a hexadecimal number with the "0x" prefix.
 
                                    * Bits 31 - a production module(0) or
                                      a debug module(1).
-                                   * Bits 30:0 Reserved - set to 0.
+                                   * Bits 0-30 - Reserved - set to 0.
 
                 vendor_id          vendor ID as a hexadecimal number with the
                                    "0x" prefix.
@@ -62,7 +58,7 @@ Description:
                                    the "0x" prefix.
                 minor_version      minor version as a hexadecimal number with
                                    the "0x" prefix.
-                major_version      major versionas a hexadecimal number with
+                major_version      major version as a hexadecimal number with
                                    the "0x" prefix.
                 ================== ============================================
 
-- 
An old man doll... just what I always wanted! - Clara

