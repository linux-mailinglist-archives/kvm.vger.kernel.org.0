Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE1158CED8
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 22:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiHHUG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 16:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiHHUG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 16:06:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203A018B2E
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 13:06:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z16so12007562wrh.12
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0j4dwLC8wxMrSAowWiy7rSpW5tCFJnoA4YLc0AuNUGg=;
        b=gld9078CrBQZkkr4yLFP8JyPjvlRn+4NpBrX7b60hIKWn28bkVbenIdUCbRuLNTTV0
         1L/39r5DQ4UKsm46WbkBiD46ElgQhpGCrV3dL2IjRNVKWzoh4RcLMsGeUceFQUKOwfSS
         lKuidI5W5eLJW4bvDU6NCAaZbpFulFWfNzi8pT0hS8wUhPwdVnzf53hNGbSb8efC0kW5
         rAbRal6FivNDSIIFBYuhcY/SU+U3x4tV9f7yNkVkf0A8JI0x7IsYbZ2z7W64UW/k7roj
         9D+5xVc9ZcwERLaDE3Stw31kBjsL/lFxJJhjsNTXENCu2Y/ZofRg5BFreVtm2omGqwjq
         /cdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0j4dwLC8wxMrSAowWiy7rSpW5tCFJnoA4YLc0AuNUGg=;
        b=34Ics6RZMQMYtyM3atvMZ3IyGMfCSGbh/7PicRFec00xgtVPufqguj+th+1o5f7gb7
         UwGBVAcRrGtLGSof3cdxVqMIXTh9Wvgjl5x9yO6Ku8z8Rr1PZdImMkz9SBlkHirkYjMi
         Ez4NecQYyZ6RiC8YDmu+h392KdEZ1Lp2jsHfRzpZIOf9LY9KG7JmdgqftLP4+S2yqT9H
         E5A+eYOuCLaTeJ6qhEF3FpA6yeR8tfyJMCmM6DbOokk7xnZz5ViUxU7QdmCbrJumjunH
         loFNdtZwMqPn5yhFHjfw67ybYy2X2PGWqcbVygllGGRPOD+yD+60+TYOxrS9DjlUiLyE
         9Izw==
X-Gm-Message-State: ACgBeo0TnGSk9MlKxNfOoHeC0R6MVvq/E6/2Nl+Z/IeVFwy6TfMTUsDO
        HjZNtF1WytAdZlyY5Jfl/z9ZTFEJvf66xs0oGG8FbA==
X-Google-Smtp-Source: AA6agR44E4ypoC5H9UBmr2E8FlvOT73br0ors/jVWYMC79q6xf+bqy0nmcGD1ZQ8O3weskn+aiRibfX/QNtndGD1TnE=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr12635954wrx.372.1659989213525; Mon, 08
 Aug 2022 13:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com> <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
In-Reply-To: <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 8 Aug 2022 13:06:15 -0700
Message-ID: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
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

On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > Thanks for taking another look at this!
> > >
> > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > index aab70355d64f3..13190d298c986 100644
> > > > > --- a/include/linux/mmzone.h
> > > > > +++ b/include/linux/mmzone.h
> > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > >  #endif
> > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > >
> > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > and potentially confusing.
> > > >
> > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > stats the depend on a single feature seems to be the status quo for this code.
> > > >
> > >
> > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > currently *only* used for KVM so that it makes sense if users without
> > > KVM don't see the stat at all. I will also remove the stat from
> > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > #ifdefed stats show up there.
> >
> > It's might be worth getting someone from mm/ to weigh in before going through the
> > trouble, my suggestion/question is based purely on the existing code.
>
> Any mm folks with an opinion about this?
>
> Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> with #ifdef CONFIG_KVM for now as it is currently the only source for
> this stat?

Any input here?

Johannes, you have been involved in discussions in earlier versions of
this series, any thoughts here?
