Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A934FE92E
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiDLUAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiDLUAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:00:08 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F97004B
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:53:08 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id w128so9546727vkd.3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XNjj2es3e35xyCGEKo5+M+bxb4jnxzy0zCjwt6jEQo4=;
        b=bpsoErcvQq04JtqXPWJtBAZu1Xv9/HpycDfZsotYxvxH+b0pgeclA3s+dGxwtPjFt5
         ABGBsHNxRFTN4IoNkhn2muJkVNyS+UWWALYVk9ZaQAWlxdwfuvtVo5+LRGLPz5NJVkjU
         4ejXs1p5hwfBb0zr2tzCkXfsZ+2jQtq7jTA88jMlq9TG+6m1e9twiVXhzHVXIQ5Lr1pL
         8KNNRAePiMN4YjngaPQ6Z7sToUGAezVb+JTfNnhmyDnC9fwu8CO2TnwrSwiiki7KucGY
         GhsXdbIFHc7JhesXWd7Bts4G6/AWT1j7D8Pcm2pApsilLrQ8ldWq2yEwWWgB6LcV2lei
         qftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XNjj2es3e35xyCGEKo5+M+bxb4jnxzy0zCjwt6jEQo4=;
        b=qO+eRAw4/G5Bd8qeWbiR8weq6wKHFXBejB/O+D9Y6YKSgQSPLGuTycBdA+I0KlUxeH
         7fup5HZWjUFIfCA/GAQxkcEFDMu98LkWK7dMiZQanEJkodH6E9DcEyqwBFjr3/2VqG3o
         tP8I1o5Xr4abnkAHhdAKYG60u8jF7mQWU4W30vEaZOeLzSlaQYno1N7gdIQp8PKfwP2d
         rx6DJ4wqh9TMvkC2NKWUWgDIOqQTto0zu+HmTc3tQID/j30BZlbeWiNJNH3OxNmqsIrw
         QCokOPu+El8QgIf5W7Ig24KqtOKf0bf2/D8VQshkafTofphOR+QbKpJ3R2w00nLvJf0c
         VsAw==
X-Gm-Message-State: AOAM532Qpiv8EpTR3qjwel1zyBk1II2m0H3IUBOF0uNHIBrdp5yaefh0
        9INCOpLwzJr2o00evK4EXaP+cg1/II43oL8UGMsnnA==
X-Google-Smtp-Source: ABdhPJyNrqWIJ2j60ZlbjK0gMwwcDwo2pPX/3N3Jl9//MFNvngaRwF1n2I+6pV6d7wyCpn7EeKMKd/1GXaN78BmUC2Q=
X-Received: by 2002:a1f:ac95:0:b0:345:2ade:e54b with SMTP id
 v143-20020a1fac95000000b003452adee54bmr7146295vke.3.1649793187239; Tue, 12
 Apr 2022 12:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220323182816.2179533-1-juew@google.com> <YlR8l7aAYCwqaXEs@google.com>
 <390f6cd9-1757-b83c-ab97-5a991559e998@redhat.com> <YlXCvEevoCZPj9Ba@google.com>
In-Reply-To: <YlXCvEevoCZPj9Ba@google.com>
From:   Jue Wang <juew@google.com>
Date:   Tue, 12 Apr 2022 12:52:55 -0700
Message-ID: <CAPcxDJ6+Dn=+0=0MzWtfk83KBObMQTnFL0=p3St-Yytcn4019g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
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

On Tue, Apr 12, 2022 at 11:19 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Paolo Bonzini wrote:
> > On 4/11/22 21:08, Sean Christopherson wrote:
> > > > +                 if (!(mcg_cap & MCG_CMCI_P) &&
> > > > +                     (data || !msr_info->host_initiated))
> > > This looks wrong, userspace should either be able to write the MSR or not, '0'
> > > isn't special.  Unless there's a danger to KVM, which I don't think there is,
> > > userspace should be allowed to ignore architectural restrictions, i.e. bypass
> > > the MCG_CMCI_P check, so that KVM doesn't create an unnecessary dependency between
> > > ioctls.  I.e. this should be:
> > >
> > >             if (!(mcg_cap & MCG_CMCI_P) && !msr_info->host_initiated)
> > >                     return 1;
> > >
> >
> > This is somewhat dangerous as it complicates (or removes) the invariants
> > that other code can rely on.  Thus, usually, only the default value is
> > allowed for KVM_SET_MSR.
>
> Heh, I don't know if "usually" is the right word, that implies KVM is consistent
> enough to have a simple majority for any behavior, whatever that behavior may be :-)
>
> Anyways, on second look, I agree that KVM should require that userspace first enable
> CMCI via mcg_cap.  I thought that vcpu->arch.mcg_cap could be written via the MSR
> interface, i.e. via userspace writes to MSR_IA32_MCG_CAP, and could create dependencies
> within KVM_SET_MSRS.  But KVM only allows reading the MSR.

vcpu->arch.mcg_cap is written via kvm_vcpu_ioctl_x86_setup_mce and it
requires explicit enablement in kvm_mce_cap_supported for MCG_CMCI_P.

The pattern of KVM_SET/GET_MSRS depending on bits in
vcpu->arch.mcg_cap seems common so I will keep the check of MCG_CMCI_P
in V2.

As only allowing 0 to be set to MCi_CTL2 in set_msr_mce, it is more
consistent to hardware behavior and the invariants that other code
depends on as Paolo pointed out. I will keep this implementation in V2
as well.

Thanks,
-Jue
