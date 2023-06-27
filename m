Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290A574009E
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjF0QQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 12:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjF0QQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 12:16:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2241727
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:16:25 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53f06f7cc74so3523a12.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687882585; x=1690474585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wKCZPhCEoRc2hrFofo6TcR+e3uVxroaKugj4hSasIz4=;
        b=wv+by0SriSajzT+2XIqEDT28zSYRBBs8Rp8uYg4K9k6Wsu5XMFBv5O9AIQshwERDEQ
         XarL7vAonCfVPlfC1Mk+S6fy9hlYIXK3f+Ae81yBlrd1/UywHwE8g/4NboAAuGcGGNMa
         giDTBkXtdf8lEsf7vbZHl+4rlXJKRDfLbwbMNpLYePcfGaPZoeyog4YMoI6dafdp+hdu
         pCWhZvDh4poO45mGI1q8GE+upySHw8y44rtIPAYLNK4hifTNv2E7G4akHIbgJRWATNuf
         1Q4o2x3ZcLyn99p32Yd6MAJuumzKPh8Lw89MTnTFzlxDKtu2h4+8jjkDLl1ynCRVpWnJ
         cusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687882585; x=1690474585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKCZPhCEoRc2hrFofo6TcR+e3uVxroaKugj4hSasIz4=;
        b=V1OlkKYg8M06/yFRTWuU6p0m12QPfoQpbwHN3UpWeOOuTr5O2z/plxela7jdlK0n6V
         6110v6r0HuMxtvZYfpGkbUuVQxFsuKdAMtLrKamD/rpmDwR+RSM+d+DPoZQsaPUHS43e
         0K51gKHTC/CrIojRH3j4tB4esVRCcTCEw11H3BGiprvOhO8EqG97wBpZXmbBENWoh//s
         7NLV/ieAsHEAR+B3XmyUJCZZrhKFFxOuInm/iAkxNjkqpWOTy9wPnQfysQA3UPEYPX+b
         Mb5BSBqBteFts89y7DK7ok7416R20qbxeHMNXUjHffVMgJsCaxWEaeraJ0FUSgJqeB44
         TjSA==
X-Gm-Message-State: AC+VfDwHHpOvacjubHpFnqUKRzkQ1TfIPRR0ioCBBq7hz+tMivLIv3iq
        r/t/0oTBGFjDrdh9cTD/j4PtQQHJ7Qk=
X-Google-Smtp-Source: ACHHUZ62vvfMawNXLc5hGBJfx6LqoonyWGDMSdygAGWq2/PldG1BPMO2N03oq360iSWTrVdUlKxr/i08jsE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e281:b0:263:25f9:6588 with SMTP id
 d1-20020a17090ae28100b0026325f96588mr256696pjz.1.1687882585393; Tue, 27 Jun
 2023 09:16:25 -0700 (PDT)
Date:   Tue, 27 Jun 2023 09:16:23 -0700
In-Reply-To: <20230626182016.4127366-7-mizhang@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com> <20230626182016.4127366-7-mizhang@google.com>
Message-ID: <ZJsLV+urA0Yrw6Wn@google.com>
Subject: Re: [PATCH v2 6/6] KVM: Documentation: Add the missing description
 for tdp_mmu_page into kvm_mmu_page
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Mingwei Zhang wrote:
> Add the description for tdp_mmu_page into kvm_mmu_page description.
> tdp_mmu_page is a field to differentiate shadow pages from TDP MMU and
> non-TDP MMU. When TDP MMU is enabled, sp->tdp_mmu_page=1 indicates a shadow
> page for L1, while sp->tdp_mmu_page=0 indicates a shadow page for an L2.
> When TDP MMU is disabled, sp->tdp_mmu_page is always 0. So update the doc
> to reflect the information.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index cc4bd190c93d..678dc0260a54 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -278,6 +278,8 @@ Shadow pages contain the following information:
>      since the last time the page table was actually used; if emulation
>      is triggered too frequently on this page, KVM will unmap the page
>      to avoid emulation in the future.
> +  tdp_mmu_page:
> +    Is 1 if the shadow page is a TDP MMU page.

Maybe add a short blurb explaining that it's used for control flow when starting
from a common entry point?  E.g. walking page tables given a root, and walking
lists that can hold both shadow MMU and TDP MMU pages.
