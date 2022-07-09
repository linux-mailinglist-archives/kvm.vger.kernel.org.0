Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AE856C696
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiGIEVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiGIEVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07549459B7;
        Fri,  8 Jul 2022 21:21:18 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r1so359172plo.10;
        Fri, 08 Jul 2022 21:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWwGLeTWyw9jKzSZsmjhlLKaDKWP550W214VN7zaysw=;
        b=WYCo2fGaWwnu45w6tRjJ6orAAOOBTC+PlmRl3imZXqQa9mCSiZlY/e0oxaD7uksVck
         8y2SqgzBb/5pi76/0TfZtYlKGPm/JSL1MzS6BpvChVObmw/DR4kvMZ6PTMPZxn7LffdR
         oSO573w838kuNVOE+1SXIV87pxZarwuwbnbremt32hO/EcCcSyk9+Nmfg8EO9N/MH1FR
         uRqBNlnwRyBZJE2xEVqJ+SoeZWVMyAZoEtH/Kc/GcZVL/96HYP/BV/LwHP2kX49UEfQB
         YWhknYAb1Nc2AeahsEPPpyIUKRtPbO/5LYcpzzlSWwwvnaJWnQGvFzm03JBIvVTk4/N0
         GtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWwGLeTWyw9jKzSZsmjhlLKaDKWP550W214VN7zaysw=;
        b=JINplhMW0f7dn7Q8MGxE0RZs/BIynmTZdJT/DK99RmhGgu1074WCBuze3YwDp/N0uc
         uEE5IE8RgUYEuP/5BSrphoX2qGGCahyUykGNeRj/kqEol1vHkuPEzE5NJn5Ho/mQoD1s
         uEzWJARjbAuwJtbxWEQvXh+OlJmVJB3KJGf2QKIW/CyQSEdb/YVD+QnuJMhAXrqWJr16
         Rj+ctAQFu/rEPdI6YI7mtFeOPyjdx7NlyxJsmriUggoAXZXnc63drKmho6b2fq5HPBXZ
         A+V1aBNV+PORW+UZHJUmPn4/RMGlz53Se2qYkLLmeavgGwnZlvVauFRfY7hcyAgzEg87
         d8Fw==
X-Gm-Message-State: AJIora9rKH8zX+BeoRpCpZUKtBN/LB4mgH488hBXOmkL6NfuKPkMM6nK
        Yrs2/SQHeObfJmBVoK3hT3o=
X-Google-Smtp-Source: AGRyM1vdNLFydRZUS8daU18hpg7XwZBDgQfVQARuB1Ic9Vad468l62USBxyyQxpG31K74dVZh8naiA==
X-Received: by 2002:a17:903:31c9:b0:16c:3024:69c4 with SMTP id v9-20020a17090331c900b0016c302469c4mr2273129ple.81.1657340477548;
        Fri, 08 Jul 2022 21:21:17 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b0016bf10203d9sm335655plh.144.2022.07.08.21.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7B2ED1039B6; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
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
Subject: [PATCH 00/12] Documentation: tdx: documentation fixes
Date:   Sat,  9 Jul 2022 11:20:26 +0700
Message-Id: <20220709042037.21903-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Here is the documentation fixes for KVM TDX feature tree ([1]). There
are 58 new warnings reported when making htmldocs, which are fixed.

[1]: https://github.com/intel/tdx/tree/kvm-upstream

Bagas Sanjaya (12):
  Documentation: kvm: Pad bullet lists with blank line
  Documentation: kvm: tdx: Use appropriate subbullet marker
  Documentation: kvm: tdx: Add footnote markers
  Documentation: kvm: tdx: Use bullet list for public kvm trees
  Documentation: kvm: tdx: title typofix
  Documentation: kvm: tdx-tdp-mmu: Add blank line padding for lists
  Documentation: kvm: tdx-tdp-mmu: Use literal code block for EPT
    violation diagrams
  Documentation: kvm: tdx-tdp-mmu: Properly format nested list for EPT
    state machine
  Documentation: kvm: tdx-tdp-mmu: Add blank line padding to lists in
    concurrent sections
  Documentation: x86: Enclose TDX initialization code inside code block
  Documentation: x86: Use literal code block for TDX dmesg output
  Documentation: kvm: Add TDX documentation to KVM table of contents

 Documentation/virt/kvm/index.rst       |   4 +
 Documentation/virt/kvm/intel-tdx.rst   | 114 ++++++++++----
 Documentation/virt/kvm/tdx-tdp-mmu.rst | 198 ++++++++++++++++---------
 Documentation/x86/tdx.rst              |  32 ++--
 4 files changed, 229 insertions(+), 119 deletions(-)


base-commit: 7af4efe32638544aecb58ed7365d0ef2ea6f85ea
-- 
An old man doll... just what I always wanted! - Clara

