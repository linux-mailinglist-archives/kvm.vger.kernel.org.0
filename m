Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8389664889E
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 19:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLISsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 13:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLISsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 13:48:31 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC6912A9B
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 10:48:30 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h17so336535ila.6
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 10:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gaCkzOJ3JcEKzXNq8HvAtVCsHZl4FsYrpyHDMrGZRq0=;
        b=DMc3Xh9+cHhAWtN5Nh/3gk4FqGEaN/ZkjSd1lVDsz5idjNhS+Y6Zd7S5bnqOTwuumQ
         cYWXNQ8wBNYsx37bvuTGY8aIFn0PzuHbdpbIrO9x8HTHTW5oL7CxWgiLAD3nnFgYZ3sM
         Hqxg2XFZVDTAUr5dkJGnVZXoBPharBXdDWb6e9j4L54EXZwzEEYs6lnDkC76Hvv0czG8
         UHv0jU14OMQwWFkKaTEnsrH0F/vaRAMf7KP9cFkm/9K0Vf407IX2G4Xk6sTyZiq8KoNN
         3KE3JqY3SrKqzoyNO0TbmuS27qPvw+JqqFcZkF5mVLSityyfMZTDGU2bJJ8emd9FP086
         HlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gaCkzOJ3JcEKzXNq8HvAtVCsHZl4FsYrpyHDMrGZRq0=;
        b=QxO80Raeg7u/R8fpzHvcDix4z5yEfZ96LJY0YhMvblCL5+oR5TuaFNmAooauqk2Nj/
         E3xN2KkIuP1zX7qoTy+FsQj4/r/1q1/Tmim2qQUBMccm1p4ZETwz7UCFMcyhMCu1MAgH
         QHo4FAQhi5PfCG8+xd9q5iqK9m6FcvDwbWAvYH8WfipNCDG6mtHYCcUoPYNFyPrSLK9B
         3hJtm0X1VRe3pjTG0KhKFQ0iyFRALLDbLhn/loqiWOL90NEGekKpYCKUfZC5TY2M6NkJ
         CfshNdLL1lQnIddEpech2jakYtKyKwh5gmD62WlJ5vKO741hgfY9JuEiApbH28pt/bpE
         x7Ww==
X-Gm-Message-State: ANoB5pnZBOnxzMU00m5pxkcXy+cOethjPqKObeevOpnF5qyoS8+06R0+
        ovCMzvx+NRrm6mEZF5Ju7ImkRUH697JAwksLuZTLUQ==
X-Google-Smtp-Source: AA0mqf6co6Vm3Gzd75j8kOBjlZE3Jxhs9jwtmjErxqfhPHm3vYC4r/AWTIoQS9fbyLdLBbRqlkJRjel9rANL1yL7Ykk=
X-Received: by 2002:a92:6e12:0:b0:302:abfb:51d5 with SMTP id
 j18-20020a926e12000000b00302abfb51d5mr37028304ilc.196.1670611709743; Fri, 09
 Dec 2022 10:48:29 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-3-vipinsh@google.com>
 <CANgfPd9Khg2tMAfpj18R39cqzerFE6pu+4YUSrYr3KD5FG9zRA@mail.gmail.com>
 <CAHVum0cf_AeJ8rZGcWdne=QV6f_+09b=7kJb3xd-9eNiZr75Qg@mail.gmail.com>
 <CANgfPd9tBncLoVM4BnD5yq2O+=pXBN5_axBOh=bx=zjG7u8T7Q@mail.gmail.com>
 <CAHVum0f_6UQvcqWAJxDJyL_LN-6ryAXNuh9xY6nFtLxCOMtoXA@mail.gmail.com>
 <CANgfPd-XkHPZyFsPe75WbUrufLpKtdr1Neri1JrrApQrjRLRJw@mail.gmail.com>
 <CAHVum0dkKSY9e90xgfBVBHUqntwJOmONK+TYBXFEwg6acvUrAw@mail.gmail.com>
 <CAHVum0dPRqOmoMQsjV5M0kcaccqTpfwou0zrMj1R1RUYMFBjEg@mail.gmail.com> <Y5J8ArpcVVyBm3CY@google.com>
In-Reply-To: <Y5J8ArpcVVyBm3CY@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 9 Dec 2022 10:47:53 -0800
Message-ID: <CAHVum0ezqOaaCzZfcRpSE=pznVx2zQUaqiz34RmAB5s+U=rLFg@mail.gmail.com>
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
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

On Thu, Dec 8, 2022 at 4:06 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Dec 07, 2022 at 11:05:09AM -0800, Vipin Sharma wrote:
> > By mistake I started replying to just Ben and realized it after few
> > exchanges. Adding others. Sorry about that.
> >
> > On Wed, Dec 7, 2022 at 10:58 AM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > On Tue, Dec 6, 2022 at 11:57 AM Ben Gardon <bgardon@google.com> wrote:
> > > >
> > > > On Tue, Dec 6, 2022 at 11:18 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > > >
> > > > > On Tue, Dec 6, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > > > >
> > > > > > On Mon, Dec 5, 2022 at 3:40 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > > > > >
> > > > > > > On Mon, Dec 5, 2022 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > > > > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > > > > > index 1782c4555d94..4d59c9d48277 100644
> > > > > > > > > --- a/virt/kvm/kvm_main.c
> > > > > > > > > +++ b/virt/kvm/kvm_main.c
> > > > > > > > > @@ -384,6 +384,11 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > > > > > > > >         kvm_arch_guest_memory_reclaimed(kvm);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +void * __weak kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > > > > > > +{
> > > > > > > > > +               return (void *)__get_free_page(gfp_flags);
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > >
> > > > > > > > Rather than making this __weak, you could use #ifdef CONFIG_NUMA to
> > > > > > > > just put all the code in the arch-neutral function.
> > > > > > > >
> > > > > > >
> > > > > > > I am not sure how it will work. Here, I am trying to keep this feature
> > > > > > > only for x86. This function will be used for all architecture except
> > > > > > > in x86 where we have different implementation in arch/x86/mmu/mmu.c
> > > > > > > So, even if CONFIG_NUMA is defined, we want to keep the same
> > > > > > > definition on other architectures.
> > > > > > >
> > > > > > >
> > > > > >
> > > > > > Something like:
> > > > > >
> > > > > > +void * kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> > > > > > +{
> > > > > > +       struct page *spt_page;
> > > > > > +       void *address = NULL;
> > > > > > +
> > > > > > +       #ifdef CONFIG_NUMA
> > > > > > +       if (nid != NUMA_NO_NODE) {
> > > > > > +               spt_page = alloc_pages_node(nid, gfp, 0);
> > > > > > +               if (spt_page) {
> > > > > > +                       address = page_address(spt_page);
> > > > > > +                       return address;
> > > > > > +               }
> > > > > > +       }
> > > > > > +       #endif // CONFIG_NUMA
> > > > > > +       return (void *)__get_free_page(gfp);
> > > > > > +}
> > > > > >
> > > > >
> > > > > 'nid' will be 0 not NUMA_NO_NODE for other architectures. In x86, I am
> > > > > explicitly setting kvm_mmu_memory_cache->node to NUMA_NO_NODE or
> > > > > specific desired nodes. In others architectures it will be 0 as struct
> > > > > will be 0 initialized. __weak avoids initializing nid to NUM_NO_NODE
> > > > > in other architectures.
> > > >
> > > > ooh, I see. It might be worth setting it to NUMA_NO_NODE on other
> > > > archs as 0 could be kind of misleading.
> > >
> > > Discussed offline with Ben.
> > > Initialization code for cache is in the respective architectures.
> > > Using "__weak" avoids touching code in other architectures.
>
> But it's still a bit gross to have node=0 in struct
> kvm_mmu_memory_cache for other architectures, even if it doesn't happen
> to be misused in this series.
>
> I would just bite the bullet and modify the other architectures. Do it
> in a precusor patch where you just add node to struct
> kvm_mmu_memory_cache and initialize it to NUMA_NO_NODE across all
> architectures, probably with a common macro e.g.
>
> #define INIT_KVM_MMU_MEMORY_CACHE(_cache) do { \
>         (_cache)->node = NUMA_NO_NODE; \
> } while (0)
>
> Then, you can follow Ben's approach and avoid the __weak function.

Okay, 2 votes for NUMA_NO_NODE and 1 for __weak. I will remove the
__weak and modify other architecture code.
