Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A03647A71
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIAGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIAGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:06:32 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698615C0E1
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 16:06:31 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c13so2544082pfp.5
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 16:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aXPgCiWEn4KqpNvDV1bjWt6gr8wgSQNFAq4xiow/SE=;
        b=RdBqSc6M4CRSmpGk02jYZa4dcKFJimgLaChffzjNbU2wVkOQG6eD2WGzanYIohroQY
         AbeZDovqExaPRQ8s0CnPuprwv5ZjmzOwCGQnWJB4AQP/15y38j/Eb4/CLV1s7R/BzVzG
         y9Oi5cQWHpGNqq67QlQpPKjko3dGs1ue8Vs5Sf6L1E/j2MZVU3A/eDg71zgCTqoEcGZG
         dh13GnYgoNVkfEtMKkfOrMvyuqWRxNATkZDVmfCmZCuIBs6Op2F7eHgPRfndb6xsH78Q
         cNOOU1buHucGHI8MjUcB+piHd96M6DJO1Bbw/ybJGHQ/CkLRTF8a5X7qDfWpJULEyvP1
         edTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1aXPgCiWEn4KqpNvDV1bjWt6gr8wgSQNFAq4xiow/SE=;
        b=lgQwzSg3/ugWEMi8A2gzBIGX7WaOBr6tvjpuV/Mnpjx1BS/Jgnrg8xr5/ql5P0jlYs
         tahpzBiVaPwqll3Vv8x4/SEF7WI9T54YAFxfT9W+wTem0Kti4Ns6GwYChZ/PtMc8EMAw
         SaU/8ro3T+ChKZ8W2jJDlfUvblOVblF+xDM+Rb3OD58tocqEUDAdibImJMkvxRU15ijx
         jooWJebVkAr6Ph1n+Yay6f7XQO3gNvvNs4d0ltUBqOT2PrW7jAGXyKKQ6p9yUF3kL51a
         hUBHMXv8LFE1Gdpj/abvwYM0sSAZNx4AroBLKMqDcdAiVoFiPvY937pFZOyRsLK2oSv5
         ZIpA==
X-Gm-Message-State: ANoB5plWuh3GNT15ps0RajpOHk/z+OpPtRHuBr3Lm+OJrPMiSOqXiuZL
        lObQyfO09481Si+0o2CXARP5+mAsUsKp36G+
X-Google-Smtp-Source: AA0mqf4AMhsIf2K3Tptm8/7d4RQtGLeL65KmhGjthDZ2yajQnvnet3vuitTe3LK2aCIDKN2PgXFCHA==
X-Received: by 2002:aa7:870a:0:b0:574:f201:660a with SMTP id b10-20020aa7870a000000b00574f201660amr3294647pfo.33.1670544390734;
        Thu, 08 Dec 2022 16:06:30 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id x17-20020aa79411000000b005777fe7681esm78051pfo.20.2022.12.08.16.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:06:30 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:06:26 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
Message-ID: <Y5J8ArpcVVyBm3CY@google.com>
References: <20221201195718.1409782-1-vipinsh@google.com>
 <20221201195718.1409782-3-vipinsh@google.com>
 <CANgfPd9Khg2tMAfpj18R39cqzerFE6pu+4YUSrYr3KD5FG9zRA@mail.gmail.com>
 <CAHVum0cf_AeJ8rZGcWdne=QV6f_+09b=7kJb3xd-9eNiZr75Qg@mail.gmail.com>
 <CANgfPd9tBncLoVM4BnD5yq2O+=pXBN5_axBOh=bx=zjG7u8T7Q@mail.gmail.com>
 <CAHVum0f_6UQvcqWAJxDJyL_LN-6ryAXNuh9xY6nFtLxCOMtoXA@mail.gmail.com>
 <CANgfPd-XkHPZyFsPe75WbUrufLpKtdr1Neri1JrrApQrjRLRJw@mail.gmail.com>
 <CAHVum0dkKSY9e90xgfBVBHUqntwJOmONK+TYBXFEwg6acvUrAw@mail.gmail.com>
 <CAHVum0dPRqOmoMQsjV5M0kcaccqTpfwou0zrMj1R1RUYMFBjEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0dPRqOmoMQsjV5M0kcaccqTpfwou0zrMj1R1RUYMFBjEg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 11:05:09AM -0800, Vipin Sharma wrote:
> By mistake I started replying to just Ben and realized it after few
> exchanges. Adding others. Sorry about that.
> 
> On Wed, Dec 7, 2022 at 10:58 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Tue, Dec 6, 2022 at 11:57 AM Ben Gardon <bgardon@google.com> wrote:
> > >
> > > On Tue, Dec 6, 2022 at 11:18 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > >
> > > > On Tue, Dec 6, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > > >
> > > > > On Mon, Dec 5, 2022 at 3:40 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > > > >
> > > > > > On Mon, Dec 5, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > > > > >
> > > > > > > On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > > > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > > > > index 1782c4555d94..4d59c9d48277 100644
> > > > > > > > --- a/virt/kvm/kvm_main.c
> > > > > > > > +++ b/virt/kvm/kvm_main.c
> > > > > > > > @@ -384,6 +384,11 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > > > > > > >         kvm_arch_guest_memory_reclaimed(kvm);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +void * __weak kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > > > > > +{
> > > > > > > > +               return (void *)__get_free_page(gfp_flags);
> > > > > > > > +}
> > > > > > > > +
> > > > > > >
> > > > > > > Rather than making this __weak, you could use #ifdef CONFIG_NUMA to
> > > > > > > just put all the code in the arch-neutral function.
> > > > > > >
> > > > > >
> > > > > > I am not sure how it will work. Here, I am trying to keep this feature
> > > > > > only for x86. This function will be used for all architecture except
> > > > > > in x86 where we have different implementation in arch/x86/mmu/mmu.c
> > > > > > So, even if CONFIG_NUMA is defined, we want to keep the same
> > > > > > definition on other architectures.
> > > > > >
> > > > > >
> > > > >
> > > > > Something like:
> > > > >
> > > > > +void * kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > > +{
> > > > > +       struct page *spt_page;
> > > > > +       void *address = NULL;
> > > > > +
> > > > > +       #ifdef CONFIG_NUMA
> > > > > +       if (nid != NUMA_NO_NODE) {
> > > > > +               spt_page = alloc_pages_node(nid, gfp, 0);
> > > > > +               if (spt_page) {
> > > > > +                       address = page_address(spt_page);
> > > > > +                       return address;
> > > > > +               }
> > > > > +       }
> > > > > +       #endif // CONFIG_NUMA
> > > > > +       return (void *)__get_free_page(gfp);
> > > > > +}
> > > > >
> > > >
> > > > 'nid' will be 0 not NUMA_NO_NODE for other architectures. In x86, I am
> > > > explicitly setting kvm_mmu_memory_cache->node to NUMA_NO_NODE or
> > > > specific desired nodes. In others architectures it will be 0 as struct
> > > > will be 0 initialized. __weak avoids initializing nid to NUM_NO_NODE
> > > > in other architectures.
> > >
> > > ooh, I see. It might be worth setting it to NUMA_NO_NODE on other
> > > archs as 0 could be kind of misleading.
> >
> > Discussed offline with Ben.
> > Initialization code for cache is in the respective architectures.
> > Using "__weak" avoids touching code in other architectures.

But it's still a bit gross to have node=0 in struct
kvm_mmu_memory_cache for other architectures, even if it doesn't happen
to be misused in this series.

I would just bite the bullet and modify the other architectures. Do it
in a precusor patch where you just add node to struct
kvm_mmu_memory_cache and initialize it to NUMA_NO_NODE across all
architectures, probably with a common macro e.g.

#define INIT_KVM_MMU_MEMORY_CACHE(_cache) do { \
	(_cache)->node = NUMA_NO_NODE; \
} while (0)

Then, you can follow Ben's approach and avoid the __weak function.
