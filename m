Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D56596C74
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 11:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiHQJyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiHQJy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 05:54:28 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9765559;
        Wed, 17 Aug 2022 02:54:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a8so12025877pjg.5;
        Wed, 17 Aug 2022 02:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=sDDQV3PgZqx2/9abOCF0VxB++9+m/C4n+txZ5R5CM3Y=;
        b=ClLeS0OxnPHA3dFHRXvBfklk7W5B0Sr4o8A8jwuXMXwK8B93fTkrH2PJDK+pwVGPsG
         6EyydiJJnUKoGP6JE3FoalOPkLDo0w/ZG7kVN1ywZoVcja9Fbr/QtZWE4tZk7wu0VZa3
         iiLRO3crXxGLPYKDkyOV9XDD2aadhGOZahmeGooXBphUk5zljJjPoNicZpIuV4x4t50w
         B4Dwym5cNp4FIAk3AePSOwZDFTOuMrsZz1oVYUboyu/I6cADZv1ksA/SAKXkZaDdqgQF
         BKoJf2uFtVFvVqFneygJ8QKQ89e7ZJEa4K71bc2f8iqkCyxOl1VdhwFKK1cMbNedxcBa
         hBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=sDDQV3PgZqx2/9abOCF0VxB++9+m/C4n+txZ5R5CM3Y=;
        b=B1nyQSDc1L7SZCjk59SHHEgva7nHh3T7QY97ISmCx/os/3p8YD7zZLQ8m6BIx4K7gz
         z+j9xYK4GTUcAUCEwceb2/Pg+4WnrruYh6yhLCGNe2cpk7EpHY26GVVuZnKN6/WY5Lnf
         emxx/p5RzrvKaQ1KBRxOXOZYUE6iHqaLE5xmbwbrID6cJajaNeWb9KgkHutWBVrnw2Vv
         iqnJxQ68WRHvyM3aHxN9o4JnL0OTc8U/39XCYht5AHz3SoyAp86A+KTfqXq8ZTyG3dE8
         E2Ebo0Ks41nVUf8ZkCJUBsHIlrDl1VhQhEH7OvyiONnn4aykHyZiXipAsziiDrnp5mlQ
         U1Bw==
X-Gm-Message-State: ACgBeo1REo+Nmp8LcsoVG26Z3uQuwzEm+49af/zjyNJ/ND0iAk/oXG5g
        PvUnnJCvmpcqam5HnbFqyAMkYy/PkKc=
X-Google-Smtp-Source: AA6agR4dG8Em+rsLmsFK9sCcPltsxfwjucStQACjQwPe0z4lOHbNcrA6Hu4LmTBmUweCle3MQJVX+g==
X-Received: by 2002:a17:90b:1c0a:b0:1f3:1848:591c with SMTP id oc10-20020a17090b1c0a00b001f31848591cmr2915339pjb.24.1660730066419;
        Wed, 17 Aug 2022 02:54:26 -0700 (PDT)
Received: from debian.. (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016dbce87aecsm1066486plh.182.2022.08.17.02.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:54:26 -0700 (PDT)
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
Subject: [PATCH 3/3] Documentation: kvm: enclose the final closing brace in code block
Date:   Wed, 17 Aug 2022 16:54:05 +0700
Message-Id: <20220817095405.199662-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817095405.199662-1-bagasdotme@gmail.com>
References: <20220817095405.199662-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1175; i=bagasdotme@gmail.com; h=from:subject; bh=pZtYWIvpNrlcv7lJWS5yJDXQNN6EtLfOfO5biSvqfVc=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/du3Nvfpm360XZypkJVv7louyvnD/fKdp+Rz9hTP7vDRq P7tzdJSyMIhxMMiKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAippsZGe77XeybKm9c/9FB5UTPiR P7v/N2TJu9tO0d77X35b8fWeYwMhwr2BBe8mv574O6ISLyFv9PL+KqEnjkU6yZ8eeIdQjzX3YA
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

