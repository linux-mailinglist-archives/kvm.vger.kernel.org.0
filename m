Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4647374DE
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 21:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjFTTE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 15:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjFTTEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 15:04:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABE194;
        Tue, 20 Jun 2023 12:04:46 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6686708c986so3334741b3a.0;
        Tue, 20 Jun 2023 12:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687287886; x=1689879886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BqnI0X/tUa5p41Kr9KTCugnCscPF7VztDuhJ1HA5TFk=;
        b=HAVRWq/AEdxndIvP0eGk9OhiyDlhg8jpf+xW1/xEzbYtnFCDSGpYxHR9Sopc2julZ0
         UwJs946+SPR9wxAOk5qMblB99kpDj8tmrAdhxx4SF3XC4N09WI5NMyK63kJZHltMz8d3
         xFaQJIR+g2LJ3AExorOLtFt9qUkv4ayYa8Gzue76bmEh3Y2yLMddqyJHsB+AnfUm0t+y
         v4BHDF2W2H6grmQHAyvuMh3Poya8PTXLXeNUY3Kc6De8hG2qZW2WtFKa3RNoB9iuFD7x
         GcGdfEJRSQYYwzTyi1TmmAr8CETJaiseO4oG/SEyHTFEzpCT/PIjjqyf+1GHG2zussyE
         KmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687287886; x=1689879886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqnI0X/tUa5p41Kr9KTCugnCscPF7VztDuhJ1HA5TFk=;
        b=fzEYj7XGWJOiaZI5ldj9VfY2Oev/lejCw1VSSfFsBul5N4esyKmGluGmq4AlOAkuzf
         tmqq3DAVwmMvacPojNS/roYzs++0jdlGYVktv8FVTLI+ymzANm5T6dWcgPZBNvnYVE+4
         bDC65uOfzfJkT9k1OhIOHw3O0O9X3FEGbnjeeuu4yiSZ6C16bkayab0XANh8r1yv7yaa
         QDLZsBpdLM3pC2fab67pSqN2kYGKVd8QQg7V7zjYDV4MvNWK3ELzq69rvruScsA88J8l
         7G38iXjSW3BY8O9A1v4oQjLrFGRi1ICNB+/a7NlYm4du93CG2mrapy0Ea5SuXKLOwRvy
         WD/g==
X-Gm-Message-State: AC+VfDxrvGjqmnFE3C4plvcQUz3TP3W4U2o+gm3AqFEkxiitB+sA99Hh
        /ySNk2h5ui1ifN67HhS55VRNuJzixi0=
X-Google-Smtp-Source: ACHHUZ4U5bbrr7AZ6aHXhG+XnUrHjA/90TVgNdRICstsIkvsIFiSbYsimbwtHMRVRypuYYfB8QdQHw==
X-Received: by 2002:a05:6a20:12d3:b0:122:7e90:61c2 with SMTP id v19-20020a056a2012d300b001227e9061c2mr3610606pzg.9.1687287886110;
        Tue, 20 Jun 2023 12:04:46 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id d19-20020aa78693000000b0066883d75932sm1603783pfo.204.2023.06.20.12.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 12:04:45 -0700 (PDT)
Date:   Tue, 20 Jun 2023 12:04:43 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [RFC PATCH 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230620190443.GU2244082@ls.amr.corp.intel.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <e8d3ab4a56d69a09ba74ff1c439f904075d38c16.1686858861.git.isaku.yamahata@intel.com>
 <20230620162835.xsmaao63brira7as@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230620162835.xsmaao63brira7as@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 11:28:35AM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Thu, Jun 15, 2023 at 01:12:18PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX and SEV-SNP need to know the reason for a callback by
> > kvm_unmap_gfn_range().  mmu notifier, set memory attributes ioctl or KVM
> > gmem callback.  The callback handler changes the behavior or does the
> > additional housekeeping operation.  For mmu notifier, it's zapping shared
> > PTE.  For set memory attributes, it's the conversion of memory attributes
> > (private <=> shared).  For KVM gmem, it's punching a hole in the range, and
> > releasing the file.
> 
> I think it's still an open topic that we need to hear more from Sean about:
> 
>   https://lore.kernel.org/lkml/20230522235838.ov3722lcusotzlvo@amd.com/
> 
> but I *think* we were leaning toward decoupling the act of invalidating
> GFNs, vs. the act of invalidating/free'ing gmem pages.
> 
> One concrete example of where this seperation makes sense if with
> hole-punching. SNP has unique platform-specific stuff it has to do before
> free'ing that gmem page back to the host. If we try to plumb this through
> kvm_unmap_gfn_range() via a special flag then it's a little awkward
> because:
> 
> a) Presumably that hole-punch would have occurred after a preceeding
>    KVM_SET_MEMORY_ATTRIBUTES was issued to switch the page to shared
>    state in the xarray. So all it should really need to do is handle
>    that platform-specific behavior, like updating RMP table in case of
>    SNP. But none of the other details like GFN ranges are relevant in
>    that case, RMP updates here only need the PFN, so we end up walking
>    memslots to do GFN->PFN translations, when it would actually be much
>    more efficient to do these translations by translating the
>    hole-punched FD offset range to the corresponding folio()'s backing
>    those ranges
> 
> b) It places an unecessary dependency on having an active memslot to do
>    those translations. This ends up not being an issue with current
>    version of gmem patchset because the release() happens *before*
>    gmem_unbind(), so there is a memslot associated with the ranges at
>    gmem_release() time, but in the initial version of gmem it was the
>    reverse, so if things ever changed again in this regard we'd once
>    again have to completely rework how to issue these platform-specific
>    invalidation callbacks.
> 
> I really *really* like having a separate, simple invalidation mechanism
> in place that just converts FD offsets to PFNs and then passes those on
> to platform-defined handlers to clean up pages before free'ing them back
> to the system. It's versatile in that it can be called pretty much
> anywhere regardless of where we are in KVM lifecycle, it's robust in
> that it doesn't rely on unecessary outside dependencies, and it avoids
> added uneeded complexity to paths like kvm_unmap_gfn_range().
> 
> That's the approach taken with SNP hypervisor v9 series, with the
> gmem hook being introduced here:
> 
>   https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m3ad8245235a27ed0f41c359c191dcda6c77af043
> 
> and the SEV-SNP implementation of that hook being here:
> 
>   https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m6ac04b44722dbc07839011816e94fadf5ad6794e
> 
> Would a similar approach work for TDX? At least WRT cleaning up pages
> before returning them back to the host? If we could isolate that
> requirement/handling from all the other aspects of invalidations it
> really seems like it would cause us less headaches down the road.

In short, TDX KVM doesn't need an extra callback for invalidating/freeing gmem
pages. kvm_unmap_gfn_range() callback works.  Instead TDX needs attributes
(private-or-shared) for it.

The reason is, TDX uses encrypted page table for guest (We call it Secure-EPT),
and decicated operation on it.  The TDX KVM mmu hooks TDP MMU operations.
In in the case of invalidating/releasing page, it eventually hooks
handle_removed_pt() for additional operation.

Because TDX simply won't use gmem_invalidate callback, I'm fine with it.


> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  include/linux/kvm_host.h | 11 ++++++++++-
> >  virt/kvm/guest_mem.c     | 10 +++++++---
> >  virt/kvm/kvm_main.c      |  4 +++-
> >  3 files changed, 20 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1a47cedae8a1..c049c0aa44d6 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -256,12 +256,21 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> >  #endif
> >  
> >  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> > +
> > +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR		BIT(0)
> 
> Can you go into more detail on why special handling is needed for
> SET_MEM_ATTR?

When in TDX, the VMM zaps a private page from the encrypted page table and the
VMM adds the page back to the same GPA, it results in zeroing page and guest
needs to accept the page again.  When converting a page from shared to private,
KVM needs to zap only shared pages.  So the callback needs to know this zap
is for converting shared-to-private or private-to-shared.


> > +#define KVM_GFN_RANGE_FLAGS_GMEM_PUNCH_HOLE		BIT(1)
> > +#define KVM_GFN_RANGE_FLAGS_GMEM_RELEASE		BIT(2)
> 
> Would the need to distinguish between PUNCH_HOLE/RELEASE go away in the
> TDX case if you take the above approach? For SNP, the answer is yes. If
> that's also the case for TDX I think that would be another argument in
> favor of decoupling these from existing KVM MMU invalidation path.

TDX doesn't need gmem_invalidate callback.  TDx doesn't need the difference
betwee punch hole and release. So in short TDX needs
KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR and KVM_GFN_RANGE_FLAGS_GMEM.

With KVM_GFN_RANGE_FLAGS_GMEM, the callback can know that invalidating private
pages. Maybe by (ab)using KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR(attr=shared),
KVM_GFN_RANGE_FLAGS_GMEM can be dropped.  

Thanks,
Isaku Yamahata
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
