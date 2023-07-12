Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4DB7514C0
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjGLXre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 19:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjGLXrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 19:47:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF441E65
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:47:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8af49a5d2so945855ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689205645; x=1691797645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o7nUtvGiaimaAY0cZqfNqB77rOB1r7Cx9gcJevlv5Iw=;
        b=dH1TkkwIH2N3rOv98vFjMjLNR2RzgZXxmQvbeFRMHxFC/oiz1qxPNuXga6xPpLXjvo
         YYscOCfrhUcI5vrQ/IQMdHShU3Li7MRlpxpTNq2PYQ1OGj0vjymqubLgQztkxs62pGRu
         lI2TpohTkYwtrRZDNkPZtSruf4F91iAda7vn8NPbIIgULXidctMeUZ1xMWpEzKmLk7FZ
         M70o/gYhexV2rzlWbmYOnVs+QnfrwDR01qu9qCiM+3iZd8SgFUgMpEp+3gNndOhmRBow
         +T0Ua51N+3qQ9sqijHhfoCPVp91c54/Dwki66c4p7n54uLSffPzfXMsVk7z4RbS3TD72
         nHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689205645; x=1691797645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7nUtvGiaimaAY0cZqfNqB77rOB1r7Cx9gcJevlv5Iw=;
        b=il2o8ML/7L92B8ufaABmNrFc4EE6TgtFi+iUdyK57LimzgFGjtxsa1EPQL+1IfqKsV
         QuVRKzDuRZSvEiMxkvTx7Mlyj37MxjRSfDcvM0Xy8B65F/kYTgSGwJuUpKyLSuYp3y5L
         uKG5ZBRxGHWyoi2gbqe9pk9QsG7M4yl4EjXC2f9AMj6TX7czniAxuLqbjBzDERPXitve
         nxXmIV4mNCCoNzn8+P+Zx3v59thI30vQWelkr3cerUuAC90OGiVF0/o9b9fmVWhA1o9j
         k2wFbF8Q/9JPJz93W/Sfsk2jaNv9QmBri0I/eE1d+GrdzDUc1/ienV2Ou/0wEg4WkKHh
         dclQ==
X-Gm-Message-State: ABy/qLZFDN2IPtsXK+9UrFuJaXdBHVAPXjf44oNOk5ql0PrNZ92gUx1b
        p/CvVczvP4pNohsN744tYjU8t7DQQ1s=
X-Google-Smtp-Source: APBJJlG8AVJYisMIvs4i+GAPybPJ3kflUqvW2Anjys1LU6hiE7fvf1/XgKFKGN5opvdzCvacxKCsy6n5hhs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cd:b0:1af:f80f:185d with SMTP id
 n13-20020a170902d2cd00b001aff80f185dmr545plc.4.1689205645373; Wed, 12 Jul
 2023 16:47:25 -0700 (PDT)
Date:   Wed, 12 Jul 2023 16:47:24 -0700
In-Reply-To: <4b621470-8c58-264b-1e8b-75cec73cd7b0@gmail.com>
Mime-Version: 1.0
References: <20230602005859.784190-1-seanjc@google.com> <168667299355.1927151.1998349801097712999.b4-ty@google.com>
 <abf509a2-ebfd-7b5f-4f7a-fdd4ef60c1de@amazon.com> <ZIoQDbte/uAiit9N@google.com>
 <4b621470-8c58-264b-1e8b-75cec73cd7b0@gmail.com>
Message-ID: <ZK87jGkrc9/LVsWz@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Luiz Capitulino <luizcap@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023, Like Xu wrote:
> On 2023/6/15 03:07, Sean Christopherson wrote:
> > On Wed, Jun 14, 2023, Luiz Capitulino wrote:
> > > > Applied to kvm-x86 mmu.  I kept the default as "auto" for now, as that can go on
> > > > top and I don't want to introduce that change this late in the cycle.  If no one
> > > > beats me to the punch (hint, hint ;-) ), I'll post a patch to make "never" the
> > > > default for unaffected hosts so that we can discuss/consider that change for 6.6.
> > > 
> > > Thanks Sean, I agree with the plan. I could give a try on the patch if you'd like.
> > 
> > Yes please, thanks!
> 
> As a KVM/x86 *feature*, playing with splitting and reconstructing large
> pages have other potential user scenarios, e.g. for performance test
> comparisons in a easier approach, not just for itlb_multihit mitigation.

Enabling and disabling dirty logging is a far better tool for that, as it gives
userspace much more explicit control over what pages are are split/reconstituted,
and when.
 
> On unaffected machines (ICX and later), nx_huge_pages is already "N",
> and turning it into "never" doesn't help materially in the mitigation
> implementation, but loses flexibility.

I'm becoming more and more convinced that losing the flexibility is perfectly
acceptable.  There's a very good argument to be made that mitigating DoS attacks
from the guest kernel should be done several levels up, e.g. by refusing to create
VMs for a customer that is bringing down hosts.  As Jim has a pointed out, plugging
the hole only works if you are 100% confident there are no other holes, and will
never be other holes.

> IMO, the real issue here is that the kernel thread "kvm-nx-lpage-
> recovery" is created unconditionally. We also need to be aware of the
> existence of this commit 084cc29f8bbb ("KVM: x86/MMU: Allow NX huge
> pages to be disabled on a per-vm basis").
> 
> One of the technical proposals is to defer kvm_vm_create_worker_thread()
> to kvm_mmu_create() or kvm_init_mmu(), based on
> kvm->arch.disable_nx_huge_pages, even until guest paging mode is enabled
> on the first vcpu.
> 
> Is this step worth taking ?

IMO, no.  In hindsight, adding KVM_CAP_VM_DISABLE_NX_HUGE_PAGES was likely a
mistake; requiring CAP_SYS_BOOT makes it annoyingly difficult to safely use the
capability.  My preference at this point is to make changes to the NX hugepage
mitigation only when there is a substantial benefit to an already-deployed usecase.
