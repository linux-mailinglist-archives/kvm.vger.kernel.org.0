Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1AD7D436F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjJWXqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjJWXqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:46:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8304BDD
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:46:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9be0884ffso26015065ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104788; x=1698709588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DRTta2TjFX3FWgIj07+aRef6sC8s7S30TJagNFrajY=;
        b=Q9+/xTv1H0O6IkMgD5WoMmx9kl6zYCOqnuHu5eiX3c28xv89a9VCxBPY1vEuF4tZvb
         MW5ZCeOSEFNo3DO5mxDSfEGB4OB5f7tunNwOqJb/UsJQJ6sfR/bdUFAqZWxAGLoBiFc2
         nXxQ7vsKJRMipcac6AWDyFW72Hlud7JWo4PmWUXJqtm6KG/1vvoqlEWbo54lsBJA3R7W
         PmgD/2ksLrtK3QC920s7YVlc9TzF0bF4hRp04Z1w7wpEHuui7MiiWUWP6AP3J3SVhLAL
         dIb2PAp39d0cYG6Sz/yfu+cSrvaAbTxrC9dNZCBJelfBd9DkzytkfOqM1xoRcHEaeZZh
         HLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104788; x=1698709588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DRTta2TjFX3FWgIj07+aRef6sC8s7S30TJagNFrajY=;
        b=OHZNXeUfxYCZyrWnHXbgRldN4MtVtucQD+ZYYPP3F1hIaC001S9vM3iYA8rO3+kS9F
         751VZWSi+AsNbiQy8B8XEXFQby0/FFOEzEggB5pa4/ZRMiGyUW5ywwotnkTIDLRp1YNT
         Yh6K1Qz3rvPCHJteCaUljcN7nkBbdsR/fjGur2tlImaXOjFELkB5MLF/XugsDpt+RJyM
         8zQHaREgEh3XLb7x/Lg1p422h2klJ2Cp5PLLDClJpa9NcVe1lShsrF3t/HVLWFq8XRZJ
         42YhhKWaN/rU4r/EYospdN2Jh+iTeMPOEHTmSa4MHgTr+DrlbFn1m0S0jlGLStLMVlSz
         Dz1g==
X-Gm-Message-State: AOJu0YwRmPLSszqgAWUjqt4ge5uLOxDB/TCVcNCPGpvzgLVWvEhv0rHF
        Q7p3v37iP+3YKtXE8UwS46fGahkJan0=
X-Google-Smtp-Source: AGHT+IH0FqeYHDo7LQTtCwPn4EPd8cZOz3rQPZu7Oxo0Y0ebrlgG7M9bpedWQhyT/9zOEX8RSOtOhgN3CHY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:64c2:b0:1ca:874c:e031 with SMTP id
 y2-20020a17090264c200b001ca874ce031mr170131pli.6.1698104787957; Mon, 23 Oct
 2023 16:46:27 -0700 (PDT)
Date:   Mon, 23 Oct 2023 16:43:30 -0700
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <169810442917.2499338.3440694989716170017.b4-ty@google.com>
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@ACULAB.COM, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Sep 2023 20:42:11 +0800, Binbin Wu wrote:
> This patch series includes KVM enabling patches for Linear-address masking
> (LAM) v11 and Linear Address Space Separation (LASS) v3 since the two features
> have overlapping prep work and concepts. Sent as a single series to reduce the
> probability of conflicts.
> 
> The patch series is organized as follows:
> - Patch 1-4: Common prep work for both LAM and LASS.
> - Patch 5-13: LAM part.
> - Patch 14-16: LASS part.
> 
> [...]

Applied to kvm-x86 lam (for 6.8)!  I skipped the LASS patches, including patch 2
(the branch targets patch).  I kept the IMPLICIT emulator flag even thought it's
not strictly needed as it's a nice way to document non-existent code.

I massaged a few changelogs and fixed the KVM_X86_OP_OPTIONAL() issue, but
otherwise I don't think I made any code changes (it's been a long day :-) ).
Please take a look to make sure it all looks good.

Thanks!

[01/16] KVM: x86: Consolidate flags for __linearize()
        https://github.com/kvm-x86/linux/commit/81c940395b14
[02/16] KVM: x86: Use a new flag for branch targets
        (no commit info)
[03/16] KVM: x86: Add an emulation flag for implicit system access
        https://github.com/kvm-x86/linux/commit/90532843aebf
[04/16] KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
        https://github.com/kvm-x86/linux/commit/34b4ed7c1eaf
[05/16] KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
        https://github.com/kvm-x86/linux/commit/8b83853c5c98
[06/16] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
        https://github.com/kvm-x86/linux/commit/82ba7169837e
[07/16] KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
        https://github.com/kvm-x86/linux/commit/95df55ee42fe
[08/16] KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
        https://github.com/kvm-x86/linux/commit/7a747b6c84a1
[09/16] KVM: x86: Untag address for vmexit handlers when LAM applicable
        https://github.com/kvm-x86/linux/commit/ef99001b30a8
[10/16] KVM: x86: Virtualize LAM for supervisor pointer
        https://github.com/kvm-x86/linux/commit/4daea9a5183f
[11/16] KVM: x86: Virtualize LAM for user pointer
        https://github.com/kvm-x86/linux/commit/0cadc474eff0
[12/16] KVM: x86: Advertise and enable LAM (user and supervisor)
        https://github.com/kvm-x86/linux/commit/6ef90ee226f1
[13/16] KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
        https://github.com/kvm-x86/linux/commit/b291db540763
[14/16] KVM: emulator: Add emulation of LASS violation checks on linear address
        (no commit info)
[15/16] KVM: VMX: Virtualize LASS
        (no commit info)
[16/16] KVM: x86: Advertise LASS CPUID to user space
        (no commit info)

--
https://github.com/kvm-x86/linux/tree/next
