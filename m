Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1675D8B0
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 03:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjGVB23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 21:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjGVB21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 21:28:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECE93AAD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:28:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8ad356f6fso13160855ad.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689989305; x=1690594105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aVuOJi4p6R+oWVqYM04BRjT7YTKinYLVZF7mVB27JU=;
        b=53nMhtDHVrBhZrfs0o3fbYfzq59/6d2VisNdxNl7flD7JzyzeaXlCYtwk004G2feNg
         X62ufNG8xZSBzynjAkIhuU1d9Nloet8/0U1t/jQiuDPmPawkss3TeIedq6VFvzy1zyL6
         NVMnal+DQ14XXTlipiy4PWOnti2wOnhc+CNXHmZxRXwmKueTowtBIWCaGRJaRhy+KIkO
         wDdtE0FmI3Lx9xMqRF3X+sWYMAWefeJfitD9xzd6dB3CrHo71hy6w7CcfGZ0Z258LYhW
         RkXbIL1E0B2TcLMuKigvhXoE2cOH+rnls/2XeqCa9GORldosDTev7dwH8nRn+LbjUAy/
         dfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689989305; x=1690594105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1aVuOJi4p6R+oWVqYM04BRjT7YTKinYLVZF7mVB27JU=;
        b=Xn4yiBkF401jxW5DYO8T13spuuP71PhpVyhtTnOG3Lw0LI0q4gekYfzC24PFIa6ZiN
         IWC6nyL4GuIvlTRri1/XA/DskIYV5uVJC3Pjv4GcCiegwOwRqx+N8yQ6jin0dNAE2vLs
         YOMhyJHuytMZB7XdJ0mt+tlHv2e1x3DyfWJLar477WV64kZi9ODL5YF6GpkZtDMTHNlR
         12rv7S8VdczaTIs1iMg0ZBhtIkpOJiWAY2lkYsqpl7MdKcfBWfE9sNVjecHU93x9F1xp
         iPIWvYFhDoXPVQ1BkjEFeXPLNxZ1V4eEDXzK5CANQzOHpvt5wkTSMRuHJaWOvuhs0U9l
         DuTQ==
X-Gm-Message-State: ABy/qLYQhWsjh67tMflYy9hDdSZqzWKEJyOSC/kc6Sdzjbje2LlSJPsf
        1Jf2r3DT8sfnHuHm93mEm1nMO8Ds8HA=
X-Google-Smtp-Source: APBJJlE5fyTLe8Av8vgAjnpGC6KaeaXF544cF46Nyy6GjtO1N4mJgdsCJ4OwDt2AWBBCyC+TlcrUexSYPdQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cece:b0:1bb:1ffd:5cc8 with SMTP id
 d14-20020a170902cece00b001bb1ffd5cc8mr15856plg.11.1689989305504; Fri, 21 Jul
 2023 18:28:25 -0700 (PDT)
Date:   Fri, 21 Jul 2023 18:28:23 -0700
In-Reply-To: <5caef6bf-c3da-5928-32c9-54d6e42511ec@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-4-binbin.wu@linux.intel.com> <ZJtzdftocuwTvp67@google.com>
 <e11e348c-3763-8eda-281d-c8d965cd52b6@linux.intel.com> <ZJxwgCx3YatyH9or@google.com>
 <5caef6bf-c3da-5928-32c9-54d6e42511ec@linux.intel.com>
Message-ID: <ZLswtzHxfHv/JaM4@google.com>
Subject: Re: [PATCH v9 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023, Binbin Wu wrote:
> 
> On 6/29/2023 1:40 AM, Sean Christopherson wrote:
> > On Wed, Jun 28, 2023, Binbin Wu wrote:
> > > 
> > > On 6/28/2023 7:40 AM, Sean Christopherson wrote:
> > > > I think I'd prefer to drop this field and avoid bikeshedding the name entirely.  The
> > > > only reason to effectively cache "X86_CR3_LAM_U48 | X86_CR3_LAM_U57" is because
> > > > guest_cpuid_has() is slow, and I'd rather solve that problem with the "governed
> > > > feature" framework.
> > > Thanks for the suggestion.
> > > 
> > > Is the below patch the lastest patch of "governed feature" framework
> > > support?
> > > https://lore.kernel.org/kvm/20230217231022.816138-2-seanjc@google.com/
> > Yes, I haven't refreshed it since the original posting.
> > 
> > > Do you have plan to apply it to kvm-x86 repo?
> > I'm leaning more and more towards pushing it through sooner than later as this
> > isn't the first time in recent memory that a patch/series has done somewhat odd
> > things to workaround guest_cpuid_has() being slow.  I was hoping to get feedback
> > before applying, but that's not looking likely at this point.
> Hi Sean,
> 
> I plan to adopt the "KVM-governed feature framework" to track whether the
> guest can use LAM feature.
> Because your patchset is not applied yet, there are two ways to do it. Which
> one do you prefer?
> 
> Option 1:
> Make KVM LAM patchset base on your "KVM-governed feature framework"
> patchset.
> 
> Option 2:
> Temporarily add a bool in kvm_vcpu_arch as following, and use the bool
> "can_use_lam" instead of guest_can_use(vcpu, X86_FEATURE_LAM).
> And provide a cleanup patch to use "KVM-governed feature framework", which
> can be applied along with or after your patchset.

Sorry for not responding.  I was hoping I could get v2 posted before advising on
a direction, but long story short, I made a few goofs and got delayed (I won't get
v2 out until next week).  Belatedly, either option is fine by me (I see you posted
v10 on top of the governed feature stuff).

Thank!  And again, sorry.
