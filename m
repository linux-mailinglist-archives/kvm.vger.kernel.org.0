Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34FB58997E
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 10:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiHDItZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 04:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiHDItV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 04:49:21 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB58EC3F;
        Thu,  4 Aug 2022 01:49:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 17so18824906pfy.0;
        Thu, 04 Aug 2022 01:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YuZgAf9eJDiIQ1pfzGSgYaDFUDPS+whO4VhSlSI0bQI=;
        b=Nmc3YZfbiVDljfe1S3Nnwdzg+Heu9NiAzb8XYTDkWy//pJAFpCxwgfFeLQf2ohvT/e
         mFW7ObPEdj0F3bnRJeesXm2sulwWEH/fC4xRE1xeyPCZApTHvR1I+OV17k7a/gAJ/1m8
         6mZ+FkdlsDjiA7CatUJuQmtJaC0KKnO/koGR5mJOLAS942loviG+34p3x7vSykD4xFlJ
         fTqe49yQlWYEfucrNvf1To1zhNLim+Q2z8++lkfY0C+d+++st5vFrouiFj39nqKn0hGs
         zrErSeX9TCxrqnrEcxd7WK7KfJd9y6v7+2Jh/DrFSyMglhHV/7Qh7XCcxMd6YMHqS+t5
         eGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YuZgAf9eJDiIQ1pfzGSgYaDFUDPS+whO4VhSlSI0bQI=;
        b=b3Axv2Eng02YYx8gZi54WVuEjncGMpz3Qbk3mPAoua9OGPw/dCrblNNZ+Hyi69RiW8
         GMQL6egs8rPCtZ4wn4wFqAyfwNq35klYVVilXqmLlYcq8zQRa/IgREQ8F7cVb1aZduVE
         OO5LAzLc0JQ5LPHXgkjhL82650pB0zaZi5NIEVtBpNVnOiW7bh3Q93DYjhszaOVVyxwA
         xWj9VQLyNgTGoSAf3ZiPScbddFv1EwDHKeDiONCM1cyFoYkJNeixFNWj/rG0KBROI8Sc
         lb6PwWt7hU7Q+ppsuAAzBU1zI3RoSFdYvMq61P7bK6XPrrmwq6B/7UOxjE5r0xUWFpvv
         ketA==
X-Gm-Message-State: ACgBeo01Ds+uPTLUn2RMx5TvrAfS1AZniJKI6Xd2EspeZWUYyxv83Fdj
        H2uIMWqrs+3M+AWkGQbY/J4=
X-Google-Smtp-Source: AA6agR6f3u0cPfCCQAl+H1d7gVecNdB5HL/YM90VhrCkP10fYBmef0cMO23jtPBYj2yRVDo6s4uuhg==
X-Received: by 2002:a63:fd0b:0:b0:415:f76b:a2cd with SMTP id d11-20020a63fd0b000000b00415f76ba2cdmr816661pgh.440.1659602957225;
        Thu, 04 Aug 2022 01:49:17 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z4-20020a170902ccc400b0016be9d498d0sm283814ple.211.2022.08.04.01.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 01:49:16 -0700 (PDT)
Message-ID: <fcb0e878-29ff-e408-ccf3-3b594160c0df@gmail.com>
Date:   Thu, 4 Aug 2022 16:49:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/7] perf/x86/core: Remove unnecessary stubs provided
 for KVM-only helpers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <20220803192658.860033-1-seanjc@google.com>
 <20220803192658.860033-3-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220803192658.860033-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/2022 3:26 am, Sean Christopherson wrote:
> Remove CONFIG_PERF_EVENT=n stubs for functions that are effectively
> KVM-only.  KVM selects PERF_EVENT and will never consume the stubs.
> Dropping the unnecessary stubs will allow simplifying x86_perf_get_lbr()

Giggling, I used to have a similar cleanup patch sitting in a corner somewhere.

> by getting rid of the impossible-to-hit error path (which KVM doesn't
> even check).
> 
> Opportunstically reorganize the declarations to collapse multiple
> CONFIG_PERF_EVENTS #ifdefs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/perf_event.h | 53 ++++++++-----------------------
>   1 file changed, 13 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index cc47044401ff..aba196172500 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -509,46 +509,18 @@ extern u64 perf_get_hw_event_config(int hw_event);
>   extern void perf_check_microcode(void);
>   extern void perf_clear_dirty_counters(void);
>   extern int x86_perf_rdpmc_index(struct perf_event *event);
> -#else
> -static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
> -{
> -	memset(cap, 0, sizeof(*cap));
> -}
>   
> -static inline u64 perf_get_hw_event_config(int hw_event)
> -{
> -	return 0;
> -}
> -
> -static inline void perf_events_lapic_init(void)	{ }
> -static inline void perf_check_microcode(void) { }
> -#endif
> -
> -#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
> +#ifdef CONFIG_CPU_SUP_INTEL
>   extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
>   extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
> -#else
> -struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
> -static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
> -{
> -	return -1;
> -}
> -#endif
> +extern void intel_pt_handle_vmx(int on);
> +#endif /* CONFIG_CPU_SUP_INTEL */
>   
> -#ifdef CONFIG_CPU_SUP_INTEL
> - extern void intel_pt_handle_vmx(int on);
> -#else
> -static inline void intel_pt_handle_vmx(int on)
> -{
> +#ifdef CONFIG_CPU_SUP_AMD
> +extern void amd_pmu_enable_virt(void);
> +extern void amd_pmu_disable_virt(void);
>   
> -}
> -#endif
> -
> -#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> - extern void amd_pmu_enable_virt(void);
> - extern void amd_pmu_disable_virt(void);
> -
> -#if defined(CONFIG_PERF_EVENTS_AMD_BRS)
> +#ifdef CONFIG_PERF_EVENTS_AMD_BRS
>   
>   #define PERF_NEEDS_LOPWR_CB 1
>   
> @@ -566,12 +538,13 @@ static inline void perf_lopwr_cb(bool lopwr_in)
>   	static_call_mod(perf_lopwr_cb)(lopwr_in);
>   }
>   
> -#endif /* PERF_NEEDS_LOPWR_CB */

Oops, now the definition of PERF_NEEDS_LOPWR_CB will not be unset.
This is not mentioned in the commit message and may cause trouble.

> +#endif /* CONFIG_PERF_EVENTS_AMD_BRS */
> +#endif /* CONFIG_CPU_SUP_AMD */
>   
> -#else
> - static inline void amd_pmu_enable_virt(void) { }
> - static inline void amd_pmu_disable_virt(void) { }
> -#endif
> +#else  /* !CONFIG_PERF_EVENTS */
> +static inline void perf_events_lapic_init(void)	{ }
> +static inline void perf_check_microcode(void) { }
> +#endif /* CONFIG_PERF_EVENTS */
>   
>   #define arch_perf_out_copy_user copy_from_user_nmi
>   
