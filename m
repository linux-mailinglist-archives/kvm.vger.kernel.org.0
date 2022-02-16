Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283524B81E8
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 08:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiBPHsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 02:48:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiBPHsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 02:48:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 214136AA6D
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 23:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644997696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yHZYsT5ix1DYMi+Zf0P6MnA53EdR4cjFb5WjbXBThys=;
        b=FZcp3srALKjmoIFOfSL7ik9BKYp3YdzAJ84yBzitjZgjZPfVN6SiJsHSimmiiq8hBmNyLF
        6OdmMZ/uNnCFzwqDMo8Ah77day9wKhBHIeYFXq+8DIuuo3j4OpsdBtxcZletGk1qnGKAZS
        MCq1QU2ml3aQQQG0smq79mNRahLA0Cw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-9hK2rMFsPCyuM_e7Mby00w-1; Wed, 16 Feb 2022 02:48:15 -0500
X-MC-Unique: 9hK2rMFsPCyuM_e7Mby00w-1
Received: by mail-lf1-f71.google.com with SMTP id u24-20020a05651220d800b0043f923edd9eso442387lfr.18
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 23:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHZYsT5ix1DYMi+Zf0P6MnA53EdR4cjFb5WjbXBThys=;
        b=r76SJwOUJ7hqxzSFYmNb4380zEXm0/SClh2a5FvWC39ksZ85d8CYmIcSAzq+c+IVku
         dN9wMHkIXLmD86aNlkUAuYzP2KbBzbuhYU4ZQ3RtZYFxjDds8NsH1MAdrlrEiFAIdPgk
         ULSzybvKO4Poai6OhJl96v1dQAfit03pn/nIjavuutVRrNLVow8yTsvv7OeXLqbprlYQ
         BdM5C4TkG4yvynzBXZk+1ZZSFFxqX6yddjLzQeTtEwUaVDVyLC+2Rxjfl/kQ3iDq1nDZ
         KQAZcFo8JFBdM9zVxLnKMjUuVIb1dAITD9GFAeXlvICKU3PKjBYGbYzn/QOmPa23xLy5
         WuUw==
X-Gm-Message-State: AOAM5307PrTpAVfd8JKzQqF45XbKqYpgkhMayzVX5gZbSWD8JWofeemZ
        sHM5mMzPUsZq2JXMIfAfbyljUzw6aandwyqBp4+ygZq33GPovlXLvcXGiyoaEZHzha1EBSEk3Kl
        xzuS8R59EIuj5OgyXeH4WMB3llmSF
X-Received: by 2002:a19:761a:0:b0:43c:79ae:6aef with SMTP id c26-20020a19761a000000b0043c79ae6aefmr1154794lff.630.1644997693748;
        Tue, 15 Feb 2022 23:48:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzllVwf8xyUIv+2iLLWS6Qj/Jdq4aMgi9FUbytGUO2dDIeLl24XOTc73Yb/RVau2um+auQDQ4sK5y6MgMa7+QY=
X-Received: by 2002:a19:761a:0:b0:43c:79ae:6aef with SMTP id
 c26-20020a19761a000000b0043c79ae6aefmr1154776lff.630.1644997693558; Tue, 15
 Feb 2022 23:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20220211060742.34083-1-leobras@redhat.com> <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com>
 <cunsfslpyvh.fsf@oracle.com> <6bee793c-f7fc-2ede-0405-7a5d7968b175@redhat.com>
In-Reply-To: <6bee793c-f7fc-2ede-0405-7a5d7968b175@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Wed, 16 Feb 2022 04:48:02 -0300
Message-ID: <CAJ6HWG6RB6NS8vx0vWdgRhO54B+NqHyBvpg7dRjd_78TRnJ9eg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo, thanks for the feedback!

On Mon, Feb 14, 2022 at 6:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/14/22 10:43, David Edmondson wrote:
> > Sorry if this is a daft question:
> >
> > In what situations will there be bits set in
> > vcpu->arch.guest_supported_xcr0 that are not set in
> > vcpu->arch.guest_fpu.fpstate->xfeatures ?
> >
> > guest_supported_xcr0 is filtered based on supported_xcr0, which I would
> > expect to weed out all bits that are not set in ->xfeatures.
>
> Good point, so we can do just
>
>         vcpu->arch.guest_fpu.fpstate->user_xfeatures =
>                 vcpu->arch.guest_supported_xcr0;

Updated for v4.

>
> On top of this patch, we can even replace vcpu->arch.guest_supported_xcr0
> with vcpu->arch.guest_fpu.fpstate->user_xfeatures. Probably with local
> variables or wrapper functions though, so as to keep the code readable.

You mean another patch (#2) removing guest_supported_xcr0 field from
kvm_vcpu_arch ?
(and introducing something like kvm_guest_supported_xcr() ?)

> For example:
>
> static inline u64 kvm_guest_supported_xfd()
> {
>         u64 guest_supported_xcr0 = vcpu->arch.guest_fpu.fpstate->user_xfeatures;
>
>         return guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC;
> }

Not sure If I get the above.
Are you suggesting also removing fpstate->xfd and use a wrapper instead?
Or is the above just an example?
(s/xfd/xcr0/ & s/XFEATURE_MASK_USER_DYNAMIC/XFEATURE_MASK_USER_SUPPORTED/ )

>
> Also, already in this patch fpstate_realloc should do
>
>          newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
>
> only if !guest_fpu.  In other words, the user_xfeatures of the guest FPU
> should be controlled exclusively by KVM_SET_CPUID2.

Just to check, you suggest adding this on patch #2 ?
(I am failing to see how would that impact on #1)

>
> Thanks,
>
> Paolo
>

Thank you!

Best regards,
Leo

