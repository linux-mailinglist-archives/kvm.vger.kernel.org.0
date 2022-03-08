Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149904D0D1F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 01:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiCHA6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 19:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiCHA6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 19:58:35 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58DDDFFE
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 16:57:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p17so15592814plo.9
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 16:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qS3TzKPL75XICp05kREKW8KRScobRKaXAD+ax7RQFw=;
        b=Ci/h8oBVMef9Rx4X5O9DK0VRqasexjFfYKmlBn2wDIhDissu+Dop63KOi3NfqUKfQX
         du1i9OvH1JvHgaaS9IVCZORrhhHj7fBJcgFqBjGHFsPGUSZWjOOyayZNcUo0SFkUUAt5
         E3viOkKwFMQ8TBBPc+FN13hEPwymbCMK7Aak9YO3exc40nyf8t/MRdaA27p76vmrycI3
         /nNrKx0nr9pKNjqto7jAINHtJplgf9oiDpWmHbPsd2d3f97E/weptoNzxrDy86h6bZoj
         pyw49YZvogIzm7nM0Lgqjk1vH3XQywnJzS4ggOz2FXd3PmEqAomS+OVlbmH41U3+8bJO
         ZBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qS3TzKPL75XICp05kREKW8KRScobRKaXAD+ax7RQFw=;
        b=mPW1hADNZflXCUgQeNH7+EyuchLEdu5n2mjfG1Pvs1hW63ivuzTW4j9tLQ1WNoh/xu
         U2TVQ+EzG0DCd9+grIJE2pRGyr6lYZpxM5reHgIoMCEUyGKa0xDPwhbg+qAWVJo/RiFg
         ST3WfjGeKKNThsG3iAffgLqlLQYtAywneE9lVrhEbtxAp+1zggbT14ALZp6JIY79VGvx
         z1qAWJQIVzrlRWFyg2BLhxr+no7yNulayIqbX2+OSxMTTZkA7KlkL+QyY4+NKGr0uwF4
         e7+NYM+rzhofogjD+6cER+HAqh4z4dYzl6x7mmfIbOrQ+kA4mEysa5Y4r+vIZeMZhb+w
         t7jQ==
X-Gm-Message-State: AOAM5307j4WhYNjXPwWCHv/Xcr/hRa4nk1qWDRit/lFhJ+wscZw1hdaP
        cmKYO02AlOS9sGNLzW+j/MuJAw==
X-Google-Smtp-Source: ABdhPJxVCkz0h6/CxZGnaJgaTvJx3cqk5I4li1eW25r1ih1AAGZaSvy1GALcrVbMoFLzsUB0zsiSiw==
X-Received: by 2002:a17:903:247:b0:151:b174:fba9 with SMTP id j7-20020a170903024700b00151b174fba9mr14870422plh.79.1646701059040;
        Mon, 07 Mar 2022 16:57:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm18175192pfl.140.2022.03.07.16.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:57:38 -0800 (PST)
Date:   Tue, 8 Mar 2022 00:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        jmattson@google.com, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH][resend] KVM: x86: check steal time address when enable
 steal time
Message-ID: <Yiap/zUi2TgGcurq@google.com>
References: <1646641011-55068-1-git-send-email-lirongqing@baidu.com>
 <87sfru9ldk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfru9ldk.fsf@redhat.com>
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

On Mon, Mar 07, 2022, Vitaly Kuznetsov wrote:
> Li RongQing <lirongqing@baidu.com> writes:
> 
> > check steal time address when enable steal time, do not update
> > arch.st.msr_val if the address is invalid,  and return in #GP
> >
> > this can avoid unnecessary write/read invalid memory when guest
> > is running

Are you concerned about the host cycles, or about the guest triggering emulated
MMIO?

> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index eb402966..3ed0949 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3616,6 +3616,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		if (data & KVM_STEAL_RESERVED_MASK)
> >  			return 1;
> >  
> > +		if (!kvm_vcpu_gfn_to_memslot(vcpu, data >> PAGE_SHIFT))
> > +			return 1;
> > +
> 
> What about we use stronger kvm_is_visible_gfn() instead? I didn't put
> much thought to what's going to happen if we put e.g. APIC access page
> addr to the MSR, let's just cut any possibility.

Hmm, I don't love handling this at WRMSR, e.g. the memslot might be moved/deleted,
and it's not necessarily a guest problem, userspace could be at fault.  The other
issue is that there's no guarantee the guest will actually handle the #GP correctly,
e.g. Linux guests will simply continue on (with a WARN).

That said, I can't think of a better idea.  Documentation/virt/kvm/msr.rst does say:

  64-byte alignment physical address of a memory area which must be in guest RAM

But doesn't enforce that :-/  So it's at least reasonable behavior.
