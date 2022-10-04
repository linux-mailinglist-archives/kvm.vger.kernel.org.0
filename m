Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DCE5F497E
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 20:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJDSxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 14:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJDSwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 14:52:45 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2711B6AE8D
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:52:39 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id a2so7259330iln.13
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 11:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OIgPyGrMPjz+gDLAg9kEoqdqEvTP4OkVilCCr8OCKSk=;
        b=m6VUfw3ZZzy6RhysyIB1Hgg5/KlyWRGF31b91A6T0mWaTZMmO0RLaiIiI8YldeQXik
         ezqy4m0OTJj9Bi/bWfXIMaMDbf679eqqbZiGig+salzLLX6dFEvxSdmSAlbo7SfMMuCd
         EalkGfEk5qcpH7kjkd6n1jDjnWlc+s1ivMhnpctdeZP9MS+5HXzfd3HDQZi/fBr2EqGl
         sPlBbi36vLjcFXveD6mQLUir5RyJM1PZzbCCKu91NpUcYV1vrDk+pOMmPKsnghzMOs11
         SxXY99ezyJeV8sjLcTB6jxEB3tOdF1MVptcbPi9h/PDWIn8r6XeJP59ELC+FClswjrjz
         THAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OIgPyGrMPjz+gDLAg9kEoqdqEvTP4OkVilCCr8OCKSk=;
        b=3Zs4DC6MAo+NK7RZzUVjDE0EdTWn6Vcq5NDnCIqufIWwrxEQ0kWGwrcg8xS8/XA6ho
         s9mjnpDf8vczSAxLa7sSx0TxSrw+iydGY1wPUrMw24gL22BBW63ccwjczRzAQd7YMoOx
         NgLhJWLM0rkIwWB9wWPkLc5Sz554gAYMV6pWf29AtufJqKULRnUTcttnl/HG5Xk27MeB
         pOqMCHyL080N2ID5Fp7GiCLbG+dNo44WZLWFo3EbP0vlejKB8VmSmG3xOA8Pau68SHfX
         qLosc/8NMPk0lx0FeYlfIVvF6U4KLgdBtNYzhVjxzjZ0dC1aFVWJ+xI9dsosGXijCPTn
         ToBw==
X-Gm-Message-State: ACrzQf0g6ZcdBAk1f0k61CWB7qHzRGeL3/KEa8SWNCRZk8jx7w+eRW+e
        yZxi0GhJkraBToHPnkbWGLez6vTiQFNZCkQsJ1jDag==
X-Google-Smtp-Source: AMsMyM4d8lAYdsJB32d8lIXQfbqETNRdu+zpA/9R3+8n3icR7P2QIdvZCoIKD6q4TqfoIMSTwTHt6COCrIzKNDiID0Q=
X-Received: by 2002:a05:6e02:1bc6:b0:2f9:98c3:62e2 with SMTP id
 x6-20020a056e021bc600b002f998c362e2mr6898105ilv.240.1664909557191; Tue, 04
 Oct 2022 11:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
 <CALMp9eSJbb6sSmv4c8c3ebCtfgdAARgryq5jHXdRmhxm6fYQsw@mail.gmail.com>
 <Yy4W86qofpjoh2LA@google.com> <d9036fdc-1fd5-f5bd-1afa-7b7243f681c0@redhat.com>
In-Reply-To: <d9036fdc-1fd5-f5bd-1afa-7b7243f681c0@redhat.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 4 Oct 2022 11:52:26 -0700
Message-ID: <CAL715WLvb7H3T-WqL7QKLBKP6Q_+ma=sXZQJXt0bXzkLstpWVQ@mail.gmail.com>
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>
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

On Mon, Sep 26, 2022 at 1:50 AM Emanuele Giuseppe Esposito
<eesposit@redhat.com> wrote:
>
>
>
> Am 23/09/2022 um 22:28 schrieb David Matlack:
> > On Fri, Sep 23, 2022 at 12:25:00PM -0700, Jim Mattson wrote:
> >> On Fri, Sep 23, 2022 at 3:16 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >>>
> >>> Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
> >>> notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
> >>> the memory is not intercepted and because of this doesn't turn back
> >>> the accessed bit in the guest EPT tables.
> >>
> >> Does the guest execute an INVEPT after clearing the accessed bit?
> >
> > No, that's the problem. In L1, access_tracking_perf_test is using
> > page_idle to mark guest memory as idle, which results in clear_young()
> > notifiers being sent to KVM clear access bits. clear_young() is
> > explicitly allowed to omit flushes, so KVM happily obliges.
> >
> >       /*
> >        * clear_young is a lightweight version of clear_flush_young. Like the
> >        * latter, it is supposed to test-and-clear the young/accessed bitflag
> >        * in the secondary pte, but it may omit flushing the secondary tlb.
> >        */
> >       int (*clear_young)(struct mmu_notifier *subscription,
> >                          struct mm_struct *mm,
> >                          unsigned long start,
> >                          unsigned long end);
> >
> > We could modify page_idle so that KVM performs TLB flushes. For example,
> > add a mechanism for userspace to trigger a TLB flush. Or change
> > page_idle to use clear_flush_young() (although that would be incredibly
> > expensive since page_idle only allows clearing one pfn at a time). But
> > I'm not sure creating a new userspace API just for this test is really
> > worth it, especially with multigen LRU coming soon.

Can we add an operation that causes KVM to flush guest TLB explicitly?
For instance, we can use any operation that causes a change in
EPT/NPT, which would invoke an explicit TLB flush.  E.g., enabling
dirty logging will do the job. Alternatively, adding a memslot for the
guest, letting the guest touch it and then removing it at host level
will also flush the TLB. I believe the both should be architecturally
neutral and the latter seems more stable.

In any case, would an explicit TLB suffice in this case? I think this
will cause the zapping of PTEs in L0 EPT/NPT.

Thanks.
-Mingwei
