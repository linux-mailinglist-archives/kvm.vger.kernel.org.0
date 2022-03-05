Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E334CE253
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 03:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiCECs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 21:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiCECs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 21:48:26 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DE7DF45
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 18:47:36 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a5so9124262pfv.9
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 18:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=LVjEuXC4rM+M4KlBcuViREGDCqC/LjjwgQGBbeoRrtI=;
        b=rECfhM1P/3mpDuzhKSLP/02SrnsOWf+Ner+ol+IBbVSbLhw9RIUH41vuQMwM8iymyM
         6mmMFsaybxhYERMmGO8XojS1NadDbs2k9CNX1JggkQTLXHGIt5jbYbTjmdBTyGi97M29
         2IBxAgjVPpckQcudz7fTMtq1V9PoD/HNJIeRaQShmrKpdWYbqTYTwU07jik6aRXAb4uS
         hSVzknUaReW4wRrLp/rQxmi+TCOqBH+pCVnPdyVOZ/AHfRKo08xxr1+a/w5llLa8WpFZ
         FxQSKOs4Dqv3J+3hy6dkHfjtv2ml5km8uv5kOjrc0qPaxdEQsXuDhI5ZvnY4dNHIF871
         fjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=LVjEuXC4rM+M4KlBcuViREGDCqC/LjjwgQGBbeoRrtI=;
        b=pKRyGTJeWtz5G3S9pWYxB3Bl1aeaG+g1HMzq+QwF7VGvUy5gwpvXF5xiEXZ23TMngZ
         CGF27IaSiLEEoGB1jqq/LMkjvXIh6zSCy7FygfnJlNL1TM4lQqzHnkav+3DP7wgbjBGd
         IU1R/yjGtkR8adcyXPbg56swE4QHGUrRWQbzAhL5BrIU4npairrIwsSbagS9TLZ6yf4O
         i8phTveTRG78D15a0MdXwuUVQNp3i9y6IltCyKtF7fjO28kK6syApUm6A2nkGyZ1nnFJ
         2fDAHmUcHsL5Jd5zLt1cpVkXEQiIPX8PNFqgXLrBwO81gXtsH5lTGrILHCZM0KoMZ6F1
         D+7w==
X-Gm-Message-State: AOAM530JdvEhdPbmn/580yNjMvwLPAomiGH0gVX1kxCDebIU5e6+JovO
        X9874tZptK36EDFcU3qoqbdQTg==
X-Google-Smtp-Source: ABdhPJw0F7hYBQfsOlSn+F80ZnjIPIoHv31d+LYnxtNuPGlDmf1W8AVncrc0bl/870kVMdVLmt8Q2g==
X-Received: by 2002:a05:6a00:2348:b0:4f3:bfcd:8365 with SMTP id j8-20020a056a00234800b004f3bfcd8365mr1884832pfj.38.1646448455704;
        Fri, 04 Mar 2022 18:47:35 -0800 (PST)
Received: from [192.168.86.237] (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm7198756pfl.44.2022.03.04.18.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 18:47:35 -0800 (PST)
Message-ID: <5394e049-38a0-bf00-64e9-0728901d44ed@google.com>
Date:   Fri, 4 Mar 2022 18:47:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20220303035408.3708241-1-reijiw@google.com>
 <20220303035408.3708241-2-reijiw@google.com> <87tucf10fg.wl-maz@kernel.org>
 <75e90ab4-141f-21a8-1559-f792b84d60fa@google.com>
 <87mti522ax.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <87mti522ax.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Mar 4, 2022 at 6:57 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 04 Mar 2022 08:00:20 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > > +{
> > > > +     bool is32bit;
> > > > +     bool allowed = true;
> > > > +     struct kvm *kvm = vcpu->kvm;
> > > > +
> > > > +     is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > > > +
> > > > +     mutex_lock(&kvm->lock);
> > > > +
> > > > +     if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
> > > > +             allowed = (is32bit ==
> > > > +                        test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
> > > > +     } else {
> > > > +             if (is32bit)
> > > > +                     set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> > >
> > > nit: probably best written as:
> > >
> > >                 __assign_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags, is32bit);
> > >
> > > > +
> > > > +             set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
> > >
> > > Since this is only ever set whilst holding the lock, you can user the
> > > __set_bit() version.
> >
> > Thank you for the proposal. But since other CPUs could attempt
> > to set other bits without holding the lock, I don't think we
> > can use the non-atomic version here.
>
> Ah, good point. Keep the atomic accesses then.
>
> >
> > >
> > > > +     }
> > > > +
> > > > +     mutex_unlock(&kvm->lock);
> > > > +
> > > > +     return allowed ? 0 : -EINVAL;
> > > > +}
> > > > +
> > > >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> > > >                              const struct kvm_vcpu_init *init)
> > > >  {
> > > > @@ -1140,6 +1177,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> > > >
> > > >       /* Now we know what it is, we can reset it. */
> > > >       ret = kvm_reset_vcpu(vcpu);
> > > > +
> > > > +     if (!ret)
> > > > +             ret = kvm_register_width_check_or_init(vcpu);
> > >
> > > Why is that called *after* resetting the vcpu, which itself relies on
> > > KVM_ARM_VCPU_EL1_32BIT, which we agreed to get rid of as much as
> > > possible?
> >
> > That's because I didn't want to set EL1_32BIT/REG_WIDTH_CONFIGURED
> > for the guest based on the vCPU for which KVM_ARM_VCPU_INIT would fail.
> > The flags can be set in the kvm_reset_vcpu() and cleared in
> > case of failure.  But then that temporary value could lead
> > KVM_ARM_VCPU_INIT for other vCPUs to fail, which I don't think
> > is nice to do.
>
> But it also means that userspace is trying to create incompatible
> vcpus concurrently. Why should we care? We shouldn't even consider
> resetting the flags on failure, as userspace has already indicated its
> intention to create a 32 or 64bit VM.


Right, I understand it won't practically matter:)
I will fix the code to set the flags based on the first vCPU that calls
kvm_reset_vcpu() (and keep the flags even if kvm_reset_vcpu() fails).

Thank you!
Reiji
