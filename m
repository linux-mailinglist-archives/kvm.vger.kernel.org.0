Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FD4ADEC0
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345008AbiBHQ6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBHQ6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:58:31 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E30C061578
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 08:58:30 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id w1so4769553plb.6
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 08:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BehLNzAs/zQ1lF/lRFmUiYEG0MqDcTlN+Zi4GMNO4po=;
        b=gtD1WqxflWJB+W3B+2IPTB0tczwLG7fEAfX6erBc0MU5nljMZXr+E8SiEnTM4N+BFg
         RjxyhEm/cmjmv0ervzymU069H+VhD045lnQ39rcRknECCnyaucw8K93VEVf8UoKDZSew
         jdP2LEemYZcR5i2XXtiiLw/uLGKW8q/gojZST44XnLhBy+AmIOEsB1Iw9vJRMUTEWeLR
         04asKhrQVyx/py9Gao6ECyqb62nkk/SpW8Cm42Mt4FPy1xSjZMUrEsAZmNS1hS0HcFd5
         G+KT9JLD/hjAa7U929ByWGFWRp/jjxzZ8/OA5yppdq3NtjrTwzncuBmrOEXYNjpnmH68
         H4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BehLNzAs/zQ1lF/lRFmUiYEG0MqDcTlN+Zi4GMNO4po=;
        b=6ZlAfO9r4Gt9mMh0+yBulTLwvVD/X8Fof7KL9giBQgU27GyRHK9zaDZKxqZLUgBcBJ
         clYE6rCI5KhPWbU6+pnSmVZOUNthaFSOzls3RezyDtWmGG7Aac/UnPNs5KAwJGOLDrJm
         x/aJRQw/v2nKjeAyezM1IpEdWiJf7f642T1y8aAK5pXMRJ0YvGdLzV8O+isAmW94gfTV
         trcUGtAw4Q/qshm5npjHLrOA7O9PwQW9SyYbLHj3BEIs0nJExwE4L0lIKyVgcv9rQ98p
         cIMqecNQweooQl9A3vTtq2AGsSr44HGDwPRmvZW4pPPYIdwQPp1foNn/+mmb6unOlwCF
         +Zmw==
X-Gm-Message-State: AOAM530vq7CgtVu7LlEq/HqIP3TfQCZAx5bc7bEbDkL1BBVpGj8mhgOP
        cZONscx9y0T9uGu5kx6LsRJNpg==
X-Google-Smtp-Source: ABdhPJycqIE2rS7QGrW4hrzwOVH1TbvshmoHJyww4j5tVSIRNytldRpHF1r23ExSbwF4NMrAS2Xnog==
X-Received: by 2002:a17:902:8f96:: with SMTP id z22mr5455290plo.2.1644339510071;
        Tue, 08 Feb 2022 08:58:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m20sm16957314pfk.215.2022.02.08.08.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 08:58:29 -0800 (PST)
Date:   Tue, 8 Feb 2022 16:58:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Andrew Jones <drjones@redhat.com>,
        kvmarm@lists.cs.columbia.edu, pshier@google.com,
        ricarkol@google.com, reijiw@google.com, jingzhangos@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com,
        suzuki.poulose@arm.com, Peter Maydell <peter.maydell@linaro.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YgKhMjGtBH+1nJCk@google.com>
References: <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
 <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
 <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
 <875yq88app.wl-maz@kernel.org>
 <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
 <878ruld72v.wl-maz@kernel.org>
 <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
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

On Tue, Feb 08, 2022, Oliver Upton wrote:
> Hi Marc,
> 
> On Tue, Feb 8, 2022 at 1:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > KVM currently restricts the vcpu features to be unified across vcpus,
> > > > but that's only an implementation choice.
> > >
> > > But that implementation choice has become ABI, no? How could support
> > > for asymmetry be added without requiring userspace opt-in or breaking
> > > existing VMMs that depend on feature unification?
> >
> > Of course, you'd need some sort of advertising of this new behaviour.
> >
> > One thing I would like to add to the current state of thing is an
> > indication of whether the effects of a sysreg being written from
> > userspace are global or local to a vcpu. You'd need a new capability,
> > and an extra flag added to the encoding of each register.
> 
> Ah. I think that is a much more reasonable fit then. VMMs unaware of
> this can continue to migrate new bits (albeit at the cost of
> potentially higher lock contention for the per-VM stuff), and those
> that do can reap the benefits of writing such attributes exactly once.

But the "proper" usage is no different than adding support for VM-scoped variants
of KVM_{G,S}ET_ONE_REG and friends, and a VM-scoped variant is conceptually a lot
cleaner IMO.  And making them truly VM-scoped means KVM can do things like support
sysregs that are immutable after vCPUs are created.

So long as KVM defaults to '0' for all such registers, lack of migration support
in userspace that isn't aware of the new API, i.e. doesn't do KVM_GET_REG_LIST at
a VM-scope, is a nop because said userspace also won't modify the registers in the
first place.  The only "unsolvable" problem that is avoided by usurping the per-vCPU
ioctls is rollback to a userspace VMM that isn't aware of the per-VM ioctls, but it
doesn't seem too onerous to tell userspace "don't use these unless your entire fleet
has upgraded", especially since that requirement/advisement is true for the KVM side
with respect to new registers regardless of how those registers are accessed.
