Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1764617B
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 20:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLGTGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 14:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiLGTGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 14:06:15 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F896F0EB
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 11:05:46 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id c140so23898462ybf.11
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 11:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WUn+qxGFeua6jnVnEZsyHiVilr8+qvfQhWrzBR+mRkA=;
        b=eC0dm8xhL736RQ47q0R84aRbHuiua23zL5wKpv5jpwq1kciI++DnPFOzFhXBaJEoXY
         O3bAeT29x4XMnx+OFqL/uG4+zq0Wz63bwMOwOVUlmXghbtUL9f+jnlqPG4XEdLEicAld
         S8n4hI7Rzsjq/StTE09vlLY3cOzFR8+uWCZwJcZzHeFp2rGm8sW88SXypFziZj7EdSqw
         ScrAqi/gtqY40t7Q6b3PMSJnUsELZ0GywMnKe6X1MP19T/PQOcT5RP56lBdvSyJzYZvI
         o7fRn6iLe+6H0szEyGWkNVo8yK6eUv8nJuhPQbuJLw6D1Dwe4XjjwWb/uown2CfIdYEL
         aZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUn+qxGFeua6jnVnEZsyHiVilr8+qvfQhWrzBR+mRkA=;
        b=UTablrHYZNJGcf5nfUocEL5/CRucmMO1ia14sYA2VVa5mP/hE2G+Lw1fN7NRIq5MSf
         o3170VLEtTpOwl+ZtGH/QHTQgHeFtEtKXO/SMibB9ASxbNerX9Y3WXKlIOBAjFr2DDoD
         7v8APN6+K9J5iQ3dqfMQ+mWFPDkkf9UXXKaOLC0N45IYs4zi0nyuhVWig7LKc2Cu0zAZ
         2oz5XAjvt+GTdd1+LoJU+RtiOm/Yv2iV2lanz1SFBxCr5lS1zz9RUrg8QXcFzDUfz+MX
         qYhSgac12eE209hwHpi5YozBfsebrmZwnkDsbwjmY0U/GcvdOQzDGpuOnWksIigiiilC
         cB5g==
X-Gm-Message-State: ANoB5pmotFtDRC95OKBoMLT1h2SL20/a3zjmeLAkJ41eYoQ2Dfjnl1p3
        GDrncfZdQbbeqpRqhIIIa9GXE0Fj5euL3LomslUmYQ==
X-Google-Smtp-Source: AA0mqf7x8t9HeWdmFjqdYcjinp/ZnnVLYe6lHRkX5L9isZlK3k7c8bEuvEXdNVXjSOgPEzzhJuNhHC+naAPsFyX7C+c=
X-Received: by 2002:a25:5091:0:b0:703:8471:c745 with SMTP id
 e139-20020a255091000000b007038471c745mr7862390ybb.358.1670439945420; Wed, 07
 Dec 2022 11:05:45 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-3-vipinsh@google.com>
 <CANgfPd9Khg2tMAfpj18R39cqzerFE6pu+4YUSrYr3KD5FG9zRA@mail.gmail.com>
 <CAHVum0cf_AeJ8rZGcWdne=QV6f_+09b=7kJb3xd-9eNiZr75Qg@mail.gmail.com>
 <CANgfPd9tBncLoVM4BnD5yq2O+=pXBN5_axBOh=bx=zjG7u8T7Q@mail.gmail.com>
 <CAHVum0f_6UQvcqWAJxDJyL_LN-6ryAXNuh9xY6nFtLxCOMtoXA@mail.gmail.com>
 <CANgfPd-XkHPZyFsPe75WbUrufLpKtdr1Neri1JrrApQrjRLRJw@mail.gmail.com> <CAHVum0dkKSY9e90xgfBVBHUqntwJOmONK+TYBXFEwg6acvUrAw@mail.gmail.com>
In-Reply-To: <CAHVum0dkKSY9e90xgfBVBHUqntwJOmONK+TYBXFEwg6acvUrAw@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 7 Dec 2022 11:05:09 -0800
Message-ID: <CAHVum0dPRqOmoMQsjV5M0kcaccqTpfwou0zrMj1R1RUYMFBjEg@mail.gmail.com>
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>
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

By mistake I started replying to just Ben and realized it after few
exchanges. Adding others. Sorry about that.

On Wed, Dec 7, 2022 at 10:58 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Tue, Dec 6, 2022 at 11:57 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Tue, Dec 6, 2022 at 11:18 AM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > On Tue, Dec 6, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > >
> > > > On Mon, Dec 5, 2022 at 3:40 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > > >
> > > > > On Mon, Dec 5, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > > > >
> > > > > > On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > > > index 1782c4555d94..4d59c9d48277 100644
> > > > > > > --- a/virt/kvm/kvm_main.c
> > > > > > > +++ b/virt/kvm/kvm_main.c
> > > > > > > @@ -384,6 +384,11 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > > > > > >         kvm_arch_guest_memory_reclaimed(kvm);
> > > > > > >  }
> > > > > > >
> > > > > > > +void * __weak kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > > > > +{
> > > > > > > +               return (void *)__get_free_page(gfp_flags);
> > > > > > > +}
> > > > > > > +
> > > > > >
> > > > > > Rather than making this __weak, you could use #ifdef CONFIG_NUMA to
> > > > > > just put all the code in the arch-neutral function.
> > > > > >
> > > > >
> > > > > I am not sure how it will work. Here, I am trying to keep this feature
> > > > > only for x86. This function will be used for all architecture except
> > > > > in x86 where we have different implementation in arch/x86/mmu/mmu.c
> > > > > So, even if CONFIG_NUMA is defined, we want to keep the same
> > > > > definition on other architectures.
> > > > >
> > > > >
> > > >
> > > > Something like:
> > > >
> > > > +void * kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > +{
> > > > +       struct page *spt_page;
> > > > +       void *address = NULL;
> > > > +
> > > > +       #ifdef CONFIG_NUMA
> > > > +       if (nid != NUMA_NO_NODE) {
> > > > +               spt_page = alloc_pages_node(nid, gfp, 0);
> > > > +               if (spt_page) {
> > > > +                       address = page_address(spt_page);
> > > > +                       return address;
> > > > +               }
> > > > +       }
> > > > +       #endif // CONFIG_NUMA
> > > > +       return (void *)__get_free_page(gfp);
> > > > +}
> > > >
> > >
> > > 'nid' will be 0 not NUMA_NO_NODE for other architectures. In x86, I am
> > > explicitly setting kvm_mmu_memory_cache->node to NUMA_NO_NODE or
> > > specific desired nodes. In others architectures it will be 0 as struct
> > > will be 0 initialized. __weak avoids initializing nid to NUM_NO_NODE
> > > in other architectures.
> >
> > ooh, I see. It might be worth setting it to NUMA_NO_NODE on other
> > archs as 0 could be kind of misleading.
>
> Discussed offline with Ben.
> Initialization code for cache is in the respective architectures.
> Using "__weak" avoids touching code in other architectures.
