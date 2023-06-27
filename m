Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE164740011
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjF0PuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjF0PuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 11:50:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F3D2D4F
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:50:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bf179fcc200so6082433276.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687881004; x=1690473004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f5n5wbc65BkLjffQxci9ddtPIGz5YKpcfVhEyMlRoQY=;
        b=VhMOUNxSGhmfeN6tDKv9taNLgMcr5boht1EBjABUS4HraFOok8xpcso7YrzEuAs2yD
         +fXKHztOwJwongchscymI1+wRS4M3XnZg0imwW+LEL1Hv5vvZCq8a/kpbVE1NEVPIbck
         NtWyVbZchEPzOXDvF5DoXEYD4gk8bg457Fd2/ZxwwwmhwaRjmW/QLlWLhp98MkO1F19g
         /w9WdiEarwnv76xb0+YaLD7LCHKppXsN2A51pOz0/OtHAq1Zh51CBnotWzXtZuchE1X5
         t22fV9gTuCA0jsyRpGHAumZ4XgtJwNa9sROwT27nws9Ck11caUxgch3giXyO0GTvhZsR
         svWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687881004; x=1690473004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5n5wbc65BkLjffQxci9ddtPIGz5YKpcfVhEyMlRoQY=;
        b=Qn7yWjHURegum+QUacLbXtSZaxjKWskvt3ujeMZO43Os/v0a7jBljshTlWu+Ee9Pm+
         gxYgJHMcury/qUItSdhIVkx9GRj4eFY9WTpsmtiTjCG+Xk6BmcSYiaGubVvdkIe+2/j/
         2E4TLokJneEmFuIVbG99ZoUAFksH49wI14S1owpXZ607Px/oXglaKNUCY2dF4STEntUK
         dGA7BBTnFQ0r17Sa42UCi2fo8TtF6C9URSjieKTVC5XavaE6n+PBpcsvyv7lO8PCFdl3
         jlZvjHmUrbXqxLawBWt2NANA4zgNAUTGvTinm/OuisgqY1RLsNzkGqmtRzZliDglP3MC
         nHdg==
X-Gm-Message-State: AC+VfDzNoEwcN0FUkKp1CwYqXE0fh9BD/k+S8Z7KxFZhOwtTAh30A3BE
        it+uTdtNRVIctgNepKcvhlOS2DA6Ma4=
X-Google-Smtp-Source: ACHHUZ7mMBkSNvozupflxXt5JB6dTU3vVzV21t3j/a/eGE+57DLAKMNVKHP6O6XwIf+08yU+3AhPzi1YxHc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c514:0:b0:ba8:b828:c8ff with SMTP id
 v20-20020a25c514000000b00ba8b828c8ffmr7185326ybe.10.1687881003834; Tue, 27
 Jun 2023 08:50:03 -0700 (PDT)
Date:   Tue, 27 Jun 2023 08:50:02 -0700
In-Reply-To: <20230626182016.4127366-5-mizhang@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com> <20230626182016.4127366-5-mizhang@google.com>
Message-ID: <ZJsFKjbaCKk+fFkv@google.com>
Subject: Re: [PATCH v2 4/6] KVM: Documentation: Add the missing description
 for tdp_mmu_root_count into kvm_mmu_page
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Mingwei Zhang wrote:
> Add the description of tdp_mmu_root_count into kvm_mmu_page description.
> tdp_mmu_root_count is an atomic counter used only in TDP MMU. Its usage and
> meaning is slightly different with root_counter in shadow MMU. Update the
> doc.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 5cd6cd5e8926..97d695207e11 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -231,6 +231,11 @@ Shadow pages contain the following information:
>      A counter keeping track of how many hardware registers (guest cr3 or
>      pdptrs) are now pointing at the page.  While this counter is nonzero, the
>      page cannot be destroyed.  See role.invalid.
> +  tdp_mmu_root_count:
> +    An atomic reference counter in TDP MMU root page that allows for parallel
> +    accesses.

I find the "parallel accesses" simultaneously redundant and confusing.  The fact
that's it's an atomic implies that there are concurrent accesses.  And need for
an atomic is really just a minor note, i.e. shouldn't be the focus of the
documentation.

On a related topic, the description for "root_count" is stale now that KVM keeps
references to roots.

What if we take this opportunity to unify the documentation?

  root_count / tdp_mmu_rount_count:

     A reference counter for root shadow pages.  vCPUs elevate the refcount when
     getting a shadow page that will be used as a root, i.e. will be loaded into
     hardware directly (CR3, PDPTRs, nCR3 EPTP).  Root pages cannnot be freed
     while their refcount is non-zero.  The TDP MMU uses an atomic refcount as
     vCPUs can acquire references while holding mmu_lock for read.  See
     role.invalid and Root Pages.

And then add a section specifically for root pages?  I think trying to cram
everything important about root pages into the description for their refcount
will be difficult and kludgy.  E.g. this doc should also provide an explanation of
previous roots.

Root Pages
==========

Key talking points:

  - Definition of a root page
  - Lifecycle of roots for both the shadow MMU and TDP MMU
  - Previous root tracking, and why only KVM doesn'y track previous roots when
    using PAE paging
  - The importance of preserving roots that are currently not referenced by any
    vCPU, i.e. why TDP MMU roots are initialized with a refcount of '2'
  - Why shadow MMU roots don't gift a reference to the MMU itself, i.e. why they
    naturally survive their refcount going to zero


>   Accessing the page requires lifting the counter value. The
> +    initial value is set to 2 indicating one reference from vCPU and one
> +    from TDP MMU itself. Note this field is a union with root_count.
>    parent_ptes:
>      The reverse mapping for the pte/ptes pointing at this page's spt. If
>      parent_ptes bit 0 is zero, only one spte points at this page and
> -- 
> 2.41.0.162.gfafddb0af9-goog
> 
