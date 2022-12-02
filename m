Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E13640E0B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiLBS6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiLBS6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:58:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFE99D2C6
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:58:34 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 140so5730788pfz.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8CjG38HgVtAjJNd72bRSgYsbZChXVUHosYMjw3lrVs=;
        b=m5Nbc1mqsgsUGKSL01aq/GkmZXHxZCUIDarhm2bnSwjjugIPZjjwS/5N0teNaP9EoC
         cwX+ewDJW77fqtk2loQuN1f7r4/x39uv3DXqL79M0iljck3KuyXDZXIZmZT+BSUt+f0x
         VgQG9YZLZjVh+2VhUlvhOxszQek1Uhy/12gCMgK+LFkSQS4dPaLzow0GIzMCvAtnIFpZ
         nqtC+/eYoTiN7IDuDaxatfox/fsZokWnFmHBHwHEAeZ7TuEXZZ1ytdR1zZE5uaM1C7hK
         cqjqCHkpBANdSATvhVNp7tZojo6etuN5FonTehHwtO2jp/mpO0DpfQas/33el9njK9rY
         da6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8CjG38HgVtAjJNd72bRSgYsbZChXVUHosYMjw3lrVs=;
        b=lJ0hDRe5c2ahCAdg6n+0dWDiLcUnsEMqWWLkOYOxwR5wBoX8qMYtlPU/guOBwCuGVH
         LuJeMHlqmCptjWstqRnlAKyAy8hTOqPQNydrpxGlb3561XyHX3J43Hhs/E/8FsFwQr4a
         /oGHonxy6/pYB6VYPRPHAWRsoydy/UIo42nbdzh/mS0iT/qgYvvY4DFpnZC1SxEOzuKg
         BXdN/2Go8TF3fjkFU1e1kXI09iYPD0ILsHXyzlWFlP2kN2s6Gs+b6mu/bAbNKtju/cQ6
         hMtWmM28+Ln2gM6tsckHQqVc6T/L4uKqt5hXVrNwZ8MppWgL0xdhS+E0GLeZ0UU/bzk6
         IkSw==
X-Gm-Message-State: ANoB5pmJPd16ShmkVFn6PUbnM0uuNoQ0s7uFiNt39JcwZwaNuShGlcyp
        QafoF4MFFpYQblKwuG5NHEAzkw==
X-Google-Smtp-Source: AA0mqf7kYc+kIdV9+/AmHQbbQRAwdY4YLgcVy0ORoug4rfu9zw13hVWezKxrvWeZBB2nIuqgNvdB1w==
X-Received: by 2002:aa7:9192:0:b0:563:1ae2:6daf with SMTP id x18-20020aa79192000000b005631ae26dafmr59407849pfa.71.1670007513529;
        Fri, 02 Dec 2022 10:58:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902da8a00b00186b758c9fasm5994147plx.33.2022.12.02.10.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:58:33 -0800 (PST)
Date:   Fri, 2 Dec 2022 18:58:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
Message-ID: <Y4pK1cTAuEYRXgrB@google.com>
References: <20221007221644.138355-1-jmattson@google.com>
 <bf1d172f-df7c-844c-587e-cfedd82e509b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf1d172f-df7c-844c-587e-cfedd82e509b@redhat.com>
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

On Fri, Dec 02, 2022, Paolo Bonzini wrote:
> On 10/8/22 00:16, Jim Mattson wrote:
> > CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
> > is not supported. This defeature can be advertised by
> > KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
> > enumerates it.
> > 
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2796dde06302..b748fac2ae37 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1199,8 +1199,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >   		 * Other defined bits are for MSRs that KVM does not expose:
> >   		 *   EAX      3      SPCL, SMM page configuration lock
> >   		 *   EAX      13     PCMSR, Prefetch control MSR
> > +		 *
> > +		 * KVM doesn't support SMM_CTL.
> > +		 *   EAX       9     SMM_CTL MSR is not supported
> >   		 */
> >   		entry->eax &= BIT(0) | BIT(2) | BIT(6);
> > +		entry->eax |= BIT(9);
> >   		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
> >   			entry->eax |= BIT(2);
> >   		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> 
> Queued, thanks.  Negative features suck, though.

LOL, you and Jim should start a club, Jim's had a few good rants on negative
features :-)
