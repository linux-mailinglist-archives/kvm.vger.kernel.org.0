Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29888644AFE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLFSSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLFSSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:18:01 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E0965D8
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 10:17:59 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id s14so10967833qvo.11
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 10:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=002hKsEdw2uXq9ifDp/QlcHXZWFBkFz3BHjDUjDbiHs=;
        b=BzZjb686hC8vzc2qe1MwS0UoWmQVSw9zR+1hKP1jKqAV43vJhvGRby1DXzVD9Yml53
         yFK/9KElZuwlVQJ689yyPZOzyse3Ce7XDnoURXR+0Y8qL1UgLK03T3XV17swWEuCyOtu
         nX6mm5TpdWos8AqU5SD3vYAzsiOfXAmj6tgIRTE6ezTqZVgj/o/nNoVqfcZJqkzbAGlb
         +N96mbikksKt/JMvT2uJzTQqLUJpYGrh+Shyo2tZeDpNoW2wjDJV5EPMYBjRDyPqwRIF
         DE5h0Pbzf+y6bYR3aleueBYC7e1i7Np5LpMAR5PfeW95l03deJLNkSfx+9gi9i3DtLdG
         sY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=002hKsEdw2uXq9ifDp/QlcHXZWFBkFz3BHjDUjDbiHs=;
        b=dFY9f0P2fa+oeSRx6CadNsIaVp3+Wno9CLacT+W+va1pvCCfEb8s/Z6DVWds31VHgI
         NKZvdN+4h4gK2pn/ar10X+l2NHOX2o904+h6aoxTTqNIC/5E/Y+8mdP9r/DGhi4/HjD1
         2Bf2OAPzktA1ZzVjBepXqhGYqjYpeNKGrzTqPr2p8MRA1YFGs7zV+IVUveltDOsMADr7
         aCoJitP2vaolxP/g17puejT7SdME5FMzKnjbnJLMPwCh+3jglLTqlbyMedrw8xDwlAHq
         HpaG5dexUAmZbwRBYwCPIomulKhlcMef879FS65ApsZFzepFAgcu/NJbMOTMi/K6pids
         Kstg==
X-Gm-Message-State: ANoB5plSEFTHOzfBapyhxQKpP4LliJjpllnCBXkz7XupvVrDQH1qNF2a
        idSHRcTPGz06nUNOHyEyHbpBmi3DqYMQUD2rOaN5rQ==
X-Google-Smtp-Source: AA0mqf7oltuiesL/YIJrr0ImRYYsfz9oaxd7tbi7sXdAJ0J0AUzBr9Scon3vM42VBtt6a2W3uijuQzhAi/V/HUIN+co=
X-Received: by 2002:a0c:f70d:0:b0:4c7:39f0:561d with SMTP id
 w13-20020a0cf70d000000b004c739f0561dmr19454464qvn.84.1670350678827; Tue, 06
 Dec 2022 10:17:58 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-3-vipinsh@google.com>
 <CANgfPd9Khg2tMAfpj18R39cqzerFE6pu+4YUSrYr3KD5FG9zRA@mail.gmail.com> <CAHVum0cf_AeJ8rZGcWdne=QV6f_+09b=7kJb3xd-9eNiZr75Qg@mail.gmail.com>
In-Reply-To: <CAHVum0cf_AeJ8rZGcWdne=QV6f_+09b=7kJb3xd-9eNiZr75Qg@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 6 Dec 2022 10:17:47 -0800
Message-ID: <CANgfPd9tBncLoVM4BnD5yq2O+=pXBN5_axBOh=bx=zjG7u8T7Q@mail.gmail.com>
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 5, 2022 at 3:40 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Mon, Dec 5, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 1782c4555d94..4d59c9d48277 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -384,6 +384,11 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > >         kvm_arch_guest_memory_reclaimed(kvm);
> > >  }
> > >
> > > +void * __weak kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > +{
> > > +               return (void *)__get_free_page(gfp_flags);
> > > +}
> > > +
> >
> > Rather than making this __weak, you could use #ifdef CONFIG_NUMA to
> > just put all the code in the arch-neutral function.
> >
>
> I am not sure how it will work. Here, I am trying to keep this feature
> only for x86. This function will be used for all architecture except
> in x86 where we have different implementation in arch/x86/mmu/mmu.c
> So, even if CONFIG_NUMA is defined, we want to keep the same
> definition on other architectures.
>
>

Something like:

+void * kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
+{
+       struct page *spt_page;
+       void *address = NULL;
+
+       #ifdef CONFIG_NUMA
+       if (nid != NUMA_NO_NODE) {
+               spt_page = alloc_pages_node(nid, gfp, 0);
+               if (spt_page) {
+                       address = page_address(spt_page);
+                       return address;
+               }
+       }
+       #endif // CONFIG_NUMA
+       return (void *)__get_free_page(gfp);
+}

>
>
>
> > >  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > >  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > >                                                gfp_t gfp_flags)
> > > @@ -393,7 +398,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > >         if (mc->kmem_cache)
> > >                 return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> > >         else
> > > -               return (void *)__get_free_page(gfp_flags);
> > > +               return kvm_arch_mmu_get_free_page(mc->node, gfp_flags);
> > >  }
> > >
> > >  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > --
> > > 2.39.0.rc0.267.gcb52ba06e7-goog
> > >
