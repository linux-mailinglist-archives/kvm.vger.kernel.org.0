Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C7781569
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 00:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbjHRW2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 18:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbjHRW1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 18:27:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED434210
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 15:27:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-268099fd4f5so1661711a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 15:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692397669; x=1693002469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bymdpw5BwAgBe6vd/lRyy3tT469gRmx/9eNAhu/kn78=;
        b=T2ItJNvJQWWT5xJXrDTXrCdEsTphGTaYuAoQ1UY1UGSRZlnkMaMq1dg2eF1+vY+Rqu
         6nodf5UEVz2FU9HBYlECc5RdQxWEE4PtNluS8WFpD13cYiayNGG7gNS/U0zLwWIyMXQP
         R0svUCCcNmUNBMdQUc96cViluqmDvzjcQRKVHmFm2BHG0cAYpkikOwVBHrnBTif/QkNd
         W4JxrBhb3jpyEpV9iiXiQJBZCx5hADxOkoLAvANpjqqFtCoIImvTm8f0Ky/rt+jh9Gr2
         0DUyiRkYIm/u/xW0FxA0MqyvpuRBXsqcrCOYNKYlvlURQcUwMO2qwSdt0I6/M+pNo6fs
         sFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692397669; x=1693002469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bymdpw5BwAgBe6vd/lRyy3tT469gRmx/9eNAhu/kn78=;
        b=Ky6kTpJqFhgoW/FbzUCIf6qfdoFC0gfvLnuQxZ2OgjTi3yFm1n0qYCv/GTpfHqWNii
         MBi2H7ccTbs6pcqsauhe/3UAsShiiuLcdZt3BwnLJ7ZN3F6IpbF8Y3fd2kiH5e8YChsg
         yn91IYVqt1WuF5PiB6qhMq2qZZacGSL30e2/ivrzLLQde9hiNSY7/v0vCV1dAe6iTggK
         fI77CsM0N/aHDYW2s8GUD6suqKuouOFqr9yrD8GgsguAk3LHnrrl9vvYA0TCOUQ56fIc
         xxKYeYJN0UHIcofckhoz1vVa0BanZ990gZkzKgmMFhV3GlmoAeDtf4DgW+V+PrhhXqK6
         twJA==
X-Gm-Message-State: AOJu0YxSiulmbzrdccv0fdcxL5ub89DxDDAQsLJYa8w62PzwWOItLDYl
        bNGnk8rZj2SuDH9NU3Uav4rORcNCJJE=
X-Google-Smtp-Source: AGHT+IGul9UJGtwGNYasqwR9RLSmn/8F8fFlVfq6NR5Y30gteta3UsK1r5i+/DmPlumhaWwSsITeoo50fV8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1082:b0:26d:fab:bcce with SMTP id
 gj2-20020a17090b108200b0026d0fabbccemr130337pjb.4.1692397669211; Fri, 18 Aug
 2023 15:27:49 -0700 (PDT)
Date:   Fri, 18 Aug 2023 15:27:47 -0700
In-Reply-To: <20230722003449.664x3xcu6ydi2vrz@amd.com>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
 <ZLqVdvsF11Ddo7Dq@google.com> <20230722003449.664x3xcu6ydi2vrz@amd.com>
Message-ID: <ZN/wY53TF2aOZtLu@google.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for responding so late, lost track of this and only found it against when
reviewing the next version :-/

On Fri, Jul 21, 2023, Michael Roth wrote:
> On Fri, Jul 21, 2023 at 07:25:58AM -0700, Sean Christopherson wrote:
> > Practically speaking, hooking the fault path will result in undesirable behavior.
> > Just because KVM *maps* at 4KiB granularity doesn't mean the RMP must be assigned
> > at 4KiB granularity, e.g. if userspace chooses to *not* PUNCH_HOLE when the guest
> > shares a single 4KiB page in a 2MiB chunk.   Dirty logging is another case where
> > the RMP can stay at 2MiB.  Or as a very silly example, imagine userspace pulls a
> > stupid and covers a single 2MiB chunk of gmem with 512 memslots.
> 
> Unfortunately I don't think things aren't quite that flexible with SNP. If
> RMP entry is 2MB, and you map a sub-page as 4K in the NPT, you'll immediately
> get a PFERR_GUEST_SIZEM on the first access (presumably when the guest tries
> to PVALIDATE it before use). The RMP fault handler will then subsequently
> need to PSMASH the 2MB entry into 4K before that guest can access it. So you
> get an extra page fault for every 2MB page that's mapped this way.
> (APM Volume 2, Section 15.36.10).

Well that's just bloody stupid.  Why is that a restriction?  Obviously creating
an NPT mapping that's larger would be annoying to handle, e.g. would require
locking multiple entries or something, so I can understand why that's disallowed.
But why can't software map at a finer granularity?

Note, I'm expecting a spec change, just expressing a bit of disbelief.

Anyways, IMO, we should eat the extra #NPF in that scenario and optimize for much,
much more likely scenario of the RMP and NPT both being able to use 2MiB pages.
And that means not inserting into the RMP when handling #NPFs, e.g. so that userspace
can do fallocate() to prep the memory before mapping, and so that if the SPTEs
get zapped for whatever reason, faulting them back in doesn't trigger useless
RMP updates.

I guess the other way to optimze things would be for userspace to use the ioctl()
to map memory into the guest[*].  But even then, initializing when allocating
seems cleaner, especially for TDX.

[*] https://lore.kernel.org/all/ZMFYhkSPE6Zbp8Ea@google.com

> That might not be a big deal for guests that are at least somewhat optimized
> to make use of 2MB pages, but another situation is:
> 
>   - gmem allocates 2MB page
>   - guest issues PVALIDATE on 2MB page
>   - guest later converts a subpage to shared but doesn't holepunch
>   - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>   - KVM MMU splits NPT mapping to 4K
>   - guest converts that shared page back to private
> 
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are validated/4K and cannot be promoted on
> the hypervisor, so the NPT mappings must still be limited to 4K to
> match this, otherwise we hit the reverse of the PFERR_GUEST_SIZEM
> scenario above, where the NPT mapping level is *larger* than the RMP
> entry level. Unfortunately that does not result in a PFERR_GUEST_SIZEM
> where we can fix things up in response, but instead it's a general
> RMP fault that would be tricky to distinguish from an RMP fault
> resulting from an implicit page conversion or some other guest weirdness
> without doing RMP table checks every time we get a general RMP fault.

This seems like a bug in the SNP code.  (a) why would KVM/SNP PSMASH in that
scenario and (b) why can't it zap/split the NPT before PSMASH?

> So for all intents and purposes it does sort of end up being the case
> that the mapping size and RMP entry size are sort of intertwined and
> can't totally be decoupled, and if you don't take that into account
> when updating the RMP entry, you'll have to do some extra PSMASH's
> in response to PFERR_GUEST_SIZEM RMP faults later.
> 
> > 
> > That likely means KVM will need an additional hook to clamp the max_level at the
> > RMP, but that shouldn't be a big deal, e.g. if we convert on allocation, then KVM
> > should be able to blindly do the conversion because it would be a kernel bug if
> > the page is already assigned to an ASID in the RMP, i.e. the additional hook
> > shouldn't incur an extra RMP lookup.
> 
> Yah we'd still need a hook in roughly this same place for clamping
> max_level. Previous versions of SNP hypervisor patches all had a separate
> hook for handling these cases, but since the work of updating the RMP table
> prior to mapping isn't too dissimilar from the work of determining max
> mapping size, I combined both of them into the kvm_x86_gmem_prepare()
> hook/implementation.
> 
> But I don't see any major issue with moving RMPUPDATE handling to an
> allocation-time hook. As mentioned above we'd get additional
> PFERR_GUEST_SIZEM faults by not taking MMU mapping level into account, but
> I previously had it implemented similarly via a hook in kvm_gmem_get_pfn()
> (because we need the GPA) and didn't notice anything major. But I'm not
> sure exactly where you're suggesting we do it now, so could use some
> clarify on that if kvm_gmem_get_pfn() isn't what you had in mind.

I was thinking kvm_gmem_get_folio().  If userspace doesn't preallocate, then
kvm_gmem_get_pfn() will still east the cost of the conversion, but it at least
gives userspace the option and handles the zap case.  Tracking which folios have
been assigned (HKID or RMP) should be pretty straightforward.

I'm not totally opposed to doing more work at map time, e.g. to avoid faults or
to play nice with PSMASH, but I would rather that not bleed into gmem.   And I
think/hope if we hook kvm_gmem_get_folio(), then TDX and SNP can use that as a
common base, i.e. whatever extra shenanigans are needed for SNP can be carried
in the SNP series.  For me, having such "quirks" in the vendor specific series
would be quite helpful as I'm having a hell of a time keeping track of all the
wrinkles of TDX and SNP.
