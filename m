Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18D44BC6FE
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 09:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiBSIkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 03:40:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiBSIkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 03:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E82A770856
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 00:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645260026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EWRQEbURhArmd05PgMJJxgCJWqV85CABLE/ul5StLRE=;
        b=Hi5CR6Q9ms4Wi+UuHfGKma0Gyxr5aEuyHSLz4OO4m4Rxo57OsoJ+LERlPtAE66G9h+MlrU
        /LLCmWSjoUJGAcK6YX0bFODdhDL4f+JUQRuuo2tZY+YNVwUM3A9KapLFOFVGSWelxnMhha
        60hAQl+QIbSaPHRWXLcyJJI5ZfwItsQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-FcIyYQXLOMqpVolAJVTmag-1; Sat, 19 Feb 2022 03:40:25 -0500
X-MC-Unique: FcIyYQXLOMqpVolAJVTmag-1
Received: by mail-ed1-f71.google.com with SMTP id l24-20020a056402231800b00410f19a3103so6997823eda.5
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 00:40:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EWRQEbURhArmd05PgMJJxgCJWqV85CABLE/ul5StLRE=;
        b=GyCOv/fowClpc7p7vvQMDQRAzxrUhAisCgu9aGQmEgXVWJckStvPTml4OE3TKrBC3H
         rnKtQZk/EzxnRdqvWtkMSnF4nTvGLb+wK1Ak3D2g2LFo3cJPON7Cjgq/ynG5N85YdSQ3
         PqI37AaqSacygQAFyTfREaYdWmLCkFWnOZgDRu4lk32teUXP+Cn2u7AeGzcQyEZ0hmGA
         Kvyjp/K8xFWsxfChqLKpDfVsvSz269Bb9b+50cxr3u5meuOr75RmdRQXt1vQZfczHffz
         aFOcVmVRRGNpD61mdsBF6ShHetyqb3GtWaA8j2lu1wC4kysdVin7qlSNZ+iaEJSF7rjY
         Vb2Q==
X-Gm-Message-State: AOAM533FR6Qz5/jzwD8Qn9c64f4Wey50aFVQ9GQZMR8NwHTnbyoDQGrJ
        NUf2J/FHbyDyJHEbpyKPxgC+/sWyD59ULnBSXyhpW9LWyngWN6s57BCiy7x+lg9tQ2sx+6sXp/6
        59zEOjm9d+y8v
X-Received: by 2002:a17:906:b887:b0:6ce:36cb:1e18 with SMTP id hb7-20020a170906b88700b006ce36cb1e18mr9387676ejb.95.1645260024011;
        Sat, 19 Feb 2022 00:40:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOaG0WzNYlXYx4k5bTz4ESGBntaVLOg+dQfvubSVqrCkwld+Vugi9SktveTk01s9jyBbpBGA==
X-Received: by 2002:a17:906:b887:b0:6ce:36cb:1e18 with SMTP id hb7-20020a170906b88700b006ce36cb1e18mr9387665ejb.95.1645260023780;
        Sat, 19 Feb 2022 00:40:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n25sm5611514eds.89.2022.02.19.00.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 00:40:23 -0800 (PST)
Message-ID: <a6635e90-1cf6-e21d-d3d6-49c47074883a@redhat.com>
Date:   Sat, 19 Feb 2022 09:40:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] kvm/x86: rename kvm's read_tsc() as
 kvm_read_host_tsc()
Content-Language: en-US
To:     Pete Swain <swine@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220218221820.950118-1-swine@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220218221820.950118-1-swine@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 23:18, Pete Swain wrote:
> Avoid clash with host driver's INDIRECT_CALLABLE_SCOPE read_tsc()
> 
> Signed-off-by: Pete Swain <swine@google.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 641044db415d..0424d77cd214 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2632,7 +2632,7 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
>   
>   #ifdef CONFIG_X86_64
>   
> -static u64 read_tsc(void)
> +static u64 kvm_read_host_tsc(void)
>   {
>   	u64 ret = (u64)rdtsc_ordered();
>   	u64 last = pvclock_gtod_data.clock.cycle_last;
> @@ -2674,7 +2674,7 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
>   		break;
>   	case VDSO_CLOCKMODE_TSC:
>   		*mode = VDSO_CLOCKMODE_TSC;
> -		*tsc_timestamp = read_tsc();
> +		*tsc_timestamp = kvm_read_host_tsc();
>   		v = (*tsc_timestamp - clock->cycle_last) &
>   			clock->mask;
>   		break;

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

