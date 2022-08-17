Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434AE596ED0
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbiHQMtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 08:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiHQMtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 08:49:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC70A7331C;
        Wed, 17 Aug 2022 05:48:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x19so839609plc.5;
        Wed, 17 Aug 2022 05:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=sDDQV3PgZqx2/9abOCF0VxB++9+m/C4n+txZ5R5CM3Y=;
        b=l1SicTD3Sr9KN4ruqv+LLZmG8wRuU8ddgK7yNps2Uf7R1yLROjSOUGQdqj9vxI+ZiV
         tM65n9j9Lhj/as55ucCu+jdlmHOn3AYY/qmMyM8BBXKNVtoGqkBZhBplMKXZnaruK0OD
         ZoH/xq6XfWsOMevupbmejop+3cOz3eaRBuHTzSPat1+eY3rPDdYAJMXzydWHf5KL35mU
         N/zUIZMRgQXWYLMFL8+2MPEbhs4ZXdIpCNoNlRDTUDTNcV1XPm84XHVuTfIBKWlyGqtY
         pSOeTqbWQ8UYZJRbRNogkwfBIq/IVVbYlzg2Y0pWd90ecZM3PFc5OeDyU1252oiL9n3G
         RFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=sDDQV3PgZqx2/9abOCF0VxB++9+m/C4n+txZ5R5CM3Y=;
        b=6FKH+SMU25yli4akxj688nyZ+jVsEX6xvL0HiZqQmPh/Ix1KgvhDF4GUUo10sX01g3
         0xWEFw4kITKdAxq+mmeSxd60A3EQHnoX43P7EGBoIgDBcbqfam4+BzU6KCMqEqPIICkD
         8g7Ge4qQJvkDXStbQG/k54S6FH1L7Zq5hpC/2f5lJ0qys8y251x1ZvXZI288MO/DSy4M
         AWXd/ZgFPWI2YcIHy+XU2DWCEUWiYdPAKVHvRULsLdiQgqI19Ps5ABmcAWjP+6ik8CLr
         415ovK7gzVFR++R6MOTebX+sOIQh0mU0XK0R/F1t0armSBHiroVtE1gTezph6d209cgY
         opLg==
X-Gm-Message-State: ACgBeo0Z2AaILXM3mhX9vHQib3jv6T6aceduF8whS7FOYL3Ltw44CZEq
        BxC4aLuuGVdcE843RM+5354pIKA4fy4Clw==
X-Google-Smtp-Source: AA6agR7FR3iL/j6v8XJIocqgdSQOAW87gCVU1em/6BeoDiRvo1J0p2clcTnEKG2Df8gbx4uvbL4B6w==
X-Received: by 2002:a17:90a:f490:b0:1f7:6ecf:33d7 with SMTP id bx16-20020a17090af49000b001f76ecf33d7mr3663495pjb.210.1660740538330;
        Wed, 17 Aug 2022 05:48:58 -0700 (PDT)
Received: from debian.. (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902a3c500b0016a4db13429sm1386962plb.192.2022.08.17.05.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 05:48:58 -0700 (PDT)
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
Subject: [PATCH v2 3/3] Documentation: kvm: enclose the final closing brace in code block
Date:   Wed, 17 Aug 2022 19:48:37 +0700
Message-Id: <20220817124837.422695-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817124837.422695-1-bagasdotme@gmail.com>
References: <20220817124837.422695-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1175; i=bagasdotme@gmail.com; h=from:subject; bh=pZtYWIvpNrlcv7lJWS5yJDXQNN6EtLfOfO5biSvqfVc=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/Hi/Nvfpm360XZypkJVv7louyvnD/fKdp+Rz9hTP7vDRq P7tzdJSyMIhxMMiKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiX+MY/ofulF6dvyvmiUZFcWWouH yu6r398nuOLFjoZ1z0Wm1xUgvDLybntW0fH2Zzas8KP7FZ5PAr78C1q6aveN4QWfFJ8bOmPDcA
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

Sphinx reported literal block warning:

Documentation/virt/kvm/api.rst:1362: WARNING: Literal block ends without a blank line; unexpected unindent.

The warning is caused by the final closing brace in KVM_SET_USER_MEMORY_REGION
struct definition is not indented as literal code block.

Indent the closing brace to fix the warning.

Link: https://lore.kernel.org/linux-doc/202208171109.lCfseeP6-lkp@intel.com/
Fixes: bb90daae9d7551 ("KVM: Extend the memslot to support fd-based private memory")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d9d43078080030..4acf4d1c95c099 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1359,7 +1359,7 @@ yet and must be cleared on entry.
 	__u32 private_fd;
 	__u32 pad1;
 	__u64 pad2[14];
-};
+  };
 
   /\* for kvm_memory_region::flags \*/
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
-- 
An old man doll... just what I always wanted! - Clara

