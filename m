Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9340D56C692
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiGIEVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGIEVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:17 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E204B0E2;
        Fri,  8 Jul 2022 21:21:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so396151pjf.2;
        Fri, 08 Jul 2022 21:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tqnD4C4oV1Jfc5xrbTyXeGKGD2rQbMRtWvUugf25kP4=;
        b=LA1u9zvwL55/Z5e5xyS4ooVm/vxaZju66QhKk7a+rVrCRdEm+MVwOo4mHoollEhRg6
         0ynn5jdfFthSZ6r9s39UJjtZFnhIWgJRHNWZzH9+Rct1aAB5MQVjpAmmqE4q8efSOX6p
         2pBvdmhVz7sWtcXVMpdmwNSOzuX2ghHM2HCxBaJeOd7LPKhWkn4tygs+u8RRLMDnT7kU
         D70wWRHW9A2VB8h3J6lQN0Apvdf2Z/1L5qogxH68MYkPK7l4pcv5xnl7xODWenLO3sE4
         55P//rMC+5VMDKQDeMJ7G4763pu0UaPJ67zyGb7TSVVY15rECG+JVecZLiiehGrysbao
         tSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tqnD4C4oV1Jfc5xrbTyXeGKGD2rQbMRtWvUugf25kP4=;
        b=pZHQ/05Ftq0fH6RrE5T20+XdkpOI0uAxiw4l0dn3HyjMQlF7HmxOFtFwFEJJ2yAX9m
         PScQlaqPQpk0h+NWvp4RGG9665XX3TthoVGZqjagt3kNmdM7ZNSrGDNOyiAwxsFzilb8
         PoQOfgNzMAwD9/NVznRgwunns3ErbH86AFTi196Bnf79P8tsVBjaOQ3F19WLQ1JGcf0v
         nAV6YWVQsFgbFjIQ02RKZDf+yCpcLGZXDjQ6InC2NJ1e0MdeH/8bkw5jULhjJGiRvJXv
         PDdqYbnkpNc/hQpmtonkTAwVcH3uqAKrPZcs/+So1vsDYse2Si90Hy7jLacbaCG+F9+1
         NfKw==
X-Gm-Message-State: AJIora+8epbyR+qqEss3znyfNFrdO7fz1eY4WkLtrPA73DN6JN/Hfvc6
        IppJ7y+6BqMzjO23+/angn8=
X-Google-Smtp-Source: AGRyM1ti0bCsTorLAhWrXlmpFGlIs0Tk6L7syNx3SMzkw98mywxfB3uBBZrKsw/KLgdul/eZWMQeSw==
X-Received: by 2002:a17:902:d4c6:b0:16c:3273:c7b3 with SMTP id o6-20020a170902d4c600b0016c3273c7b3mr1025055plg.108.1657340476187;
        Fri, 08 Jul 2022 21:21:16 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id 15-20020a63134f000000b00412b1043f33sm253283pgt.39.2022.07.08.21.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 272401039B9; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 02/12] Documentation: kvm: tdx: Use appropriate subbullet marker
Date:   Sat,  9 Jul 2022 11:20:28 +0700
Message-Id: <20220709042037.21903-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
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

Sphinx only supports dash (-) and asterisk (*) as bullet marker. Use
them instead of dot (.) and equal (=).

Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/intel-tdx.rst | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
index 46ad32f3248e40..7a7c17da3a045f 100644
--- a/Documentation/virt/kvm/intel-tdx.rst
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -216,15 +216,16 @@ The main issue for it is that the logic of kvm_x86_ops callbacks for
 TDX is different from VMX. On the other hand, the variable,
 kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.
 
-Several points to be considered.
-  . No or minimal overhead when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
-  . Avoid overhead of indirect call via function pointers.
-  . Contain the changes under arch/x86/kvm/vmx directory and share logic
+Several points to be considered:
+
+  * No or minimal overhead when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
+  * Avoid overhead of indirect call via function pointers.
+  * Contain the changes under arch/x86/kvm/vmx directory and share logic
     with VMX for maintenance.
     Even though the ways to operation on VM (VMX instruction vs TDX
     SEAM call) is different, the basic idea remains same. So, many
     logic can be shared.
-  . Future maintenance
+  * Future maintenance
     The huge change of kvm_x86_ops in (near) future isn't expected.
     a centralized file is acceptable.
 
@@ -295,21 +296,23 @@ One bit of GPA (51 or 47 bit) is repurposed so that it means shared
 with host(if set to 1) or private to TD(if cleared to 0).
 
 - The current implementation
-  . Reuse the existing MMU code with minimal update.  Because the
+
+  * Reuse the existing MMU code with minimal update.  Because the
     execution flow is mostly same. But additional operation, TDX call
     for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
-  . For performance, minimize TDX SEAM call to operate on S-EPT. When
+  * For performance, minimize TDX SEAM call to operate on S-EPT. When
     getting corresponding S-EPT pages/entry from faulting GPA, don't
     use TDX SEAM call to read S-EPT entry. Instead create shadow copy
     in host memory.
     Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
     associate S-EPT to it.
-  . Treats share bit as attributes. mask/unmask the bit where
+  * Treats share bit as attributes. mask/unmask the bit where
     necessary to keep the existing traversing code works.
     Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
     for special case.
-    = 0 : for non-TDX case
-    = 51 or 47 bit set for TDX case.
+
+    * 0 : for non-TDX case
+    * 51 or 47 bit set for TDX case.
 
   Pros:
 
-- 
An old man doll... just what I always wanted! - Clara

