Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E73592CA8
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiHOJTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 05:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiHOJTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 05:19:00 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A65C22509
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 02:18:59 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bs25so8395325wrb.2
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 02:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OOL4Y5kIDK4GpzcnTvXTZTdG7FAR6zzCfj7Cij1BefI=;
        b=CT2aSa6BZY94dkNNot3yaqnr3j9O7orSKuwxILRsqvRnd8WvEpXenBNae1eQ3He/Vr
         3AhSFAuhYY2hqrnn0IDDF0KHetLNrj4QcIGdxSVAjSYmODvxB/brvk0Zl7qi20uhok1U
         L8Vaasnomd+kIjC2rkJJhN7AU6emb3HjWMmp7U1Vlx8usn0ap0gN9exTvoztmuHkK+uZ
         bbG7qHXipz8305jwg9NNwjHODD3YuBTXoLQlVrnf796/Ss23Cy7QGESwKPeZDSbvamLV
         pmcUj/wRO29vXhL6WEKTuroMzefWNmVuDRvkPNn4jz3RLjyIYBjxzVAIO2YyineAt7Js
         iEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OOL4Y5kIDK4GpzcnTvXTZTdG7FAR6zzCfj7Cij1BefI=;
        b=Fwqc1UnwulAN2ux6IQsQnbjeDYonF8h6oHM57hnvUrPPfH77ps8ZKo84QPUgdFtS1C
         EYNLwxIJOn4562P8pobL5b8NpoTHcyAcrhFNn0PPIKNs1mELEyuGDQJSUyRxY9SKUS2h
         DNsdYSvpYHteal/5i7K7SAZGDcq30zSR4SRqAFSS0gEhcDIuWO3Z5n6dC5oKlu3epJxs
         ryKVSlMQf9/zDWJr4tlsNDF0IdslYYAxklmhlrilzzwO/8EvrdePxUy7vifyQw7kCKT+
         yU+iW1cuoLBiLrNcAm5FepcBfn0BpTsE6UgiUxsXtYmQTu19CC2roAcmWfho3W51qFOW
         n1ng==
X-Gm-Message-State: ACgBeo1W8qCULxmJuhxS98O2XZNw15hM3CF9IB+0bc9g/NI1tUF0mBvP
        /2PY8cScmloc+kwGFH6tyYzXIWoZfjtYXUQTh6ojQA==
X-Google-Smtp-Source: AA6agR4QK9DrJvHonI1zBR+KQRhkzI0CIqlFVXf7sQNjUkmnKeVQNB5PPIgTmo8PY85gS3TgTEj3HFWKmVMVmO9RYPA=
X-Received: by 2002:a5d:5a82:0:b0:224:f744:1799 with SMTP id
 bp2-20020a5d5a82000000b00224f7441799mr854866wrb.582.1660555137638; Mon, 15
 Aug 2022 02:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com> <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
In-Reply-To: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 15 Aug 2022 02:18:20 -0700
Message-ID: <CAJD7tkY5SfdhC7-4B7QuJGUVj_Ts+xwCP5FUZ-Lvg=fd1p_xAQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Sean Christopherson <seanjc@google.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>,
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 8, 2022 at 1:06 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > Thanks for taking another look at this!
> > > >
> > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > --- a/include/linux/mmzone.h
> > > > > > +++ b/include/linux/mmzone.h
> > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > >  #endif
> > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > >
> > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > and potentially confusing.
> > > > >
> > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > >
> > > >
> > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > currently *only* used for KVM so that it makes sense if users without
> > > > KVM don't see the stat at all. I will also remove the stat from
> > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > #ifdefed stats show up there.
> > >
> > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > trouble, my suggestion/question is based purely on the existing code.
> >
> > Any mm folks with an opinion about this?
> >
> > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > this stat?
>
> Any input here?
>
> Johannes, you have been involved in discussions in earlier versions of
> this series, any thoughts here?

Andrew, do you have an opinion on this? If not, I will send a v7 with
the nits discussed with Sean. I think otherwise this series has
sufficient ACKs.

Would this be merged through the mm tree or kvm tree? This was based
on the kvm/queue branch but I think I can rebase it on top of
mm-unstable, I think all dependencies that this would have added in
kvm/queue would have been fanned to mm by now.
