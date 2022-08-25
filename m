Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314B35A1582
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbiHYPXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiHYPXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:23:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA19B8F27
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:23:31 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p9-20020a17090a2d8900b001fb86ec43aaso5062492pjd.0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AHkYLosTUlLzDn2E62SzaMtiFX4B6CYSNh1rEJtPsS4=;
        b=XPykrXJnPtaVVrcd0/FJM5bJ9x9N5oHBNowUK8REQaSIxJQ5fgVKbic+daIEsTLBOU
         IKpjQwIrvsj2ME1uePBk8XBmSpeHN/Y2DAjzHA+GXh4eJsBGKETloAde1aQkHimPT58b
         pvkTlFbtDXHIWrRapcCaWLNnpo2MANPsafKsdX2vDNg9JyB+N/CNIBhTCExmOO4xajXP
         Ksc0vDokShK7dWI3bwEkRrkkriGPpqpMxrUePfPivUBdZqMNTqxAJsVpJXbi3qIDuwwR
         RNDAYnIPXqv8vjH3P8dK8RCHGhR0KYCCuM+W7aZ0RFngklXvwzrIJhcKzgYimQ1naZty
         7cnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AHkYLosTUlLzDn2E62SzaMtiFX4B6CYSNh1rEJtPsS4=;
        b=SajUwEvaRtgtFbHM7e2INRRaNbo9JG4/WR6x+97zeM71YkGDG0iTkgENrnoWGgzvZd
         xWhjlopU2EfrGxJ1fY9+QKETlGHzmiNvJfoFww598Mrc/V4aPvSb5DhlvCxM+pVCCja8
         3Yss/taVaoQHzb7bl8tFJXks2g9kZa1Rr3yTEQbzkHrPQ1euxxqOG9GlOXMIHJqSu8S+
         0rUoWeigEoINoiT8j3zlbR8lRlWO+2b+EyEwpX4tuKoUWGR4xKYNgHyTEaVsuHvqxe4I
         4ztfTEq3RdJQIE6YAlmHyLGhuUSsUYSqN/8NpYF1KIyOO2PNFezo+qD4T/G+T7Hj9qRY
         bdCg==
X-Gm-Message-State: ACgBeo2KMDwHYSzI8ygO2Ql7+OmQthsyjPLMDW0mVX4sy6/fF8GkFwXB
        B/wp8x9l4eZyptU/8BPUhGcoZGors0A61A==
X-Google-Smtp-Source: AA6agR7ecob0vG/6HjfUWKLFj9Rm64OSuEbn9LI4vl068lplif764DZbpGrjjFpYzOE8yxwJfuwZkg==
X-Received: by 2002:a17:902:ce81:b0:172:9ac1:6ee with SMTP id f1-20020a170902ce8100b001729ac106eemr4104207plg.93.1661441010644;
        Thu, 25 Aug 2022 08:23:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090a1f0400b001fa79c1de15sm3640192pja.24.2022.08.25.08.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:23:30 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:23:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] perf/x86/intel/pt: Introduce
 intel_pt_{stop,resume}()
Message-ID: <YweT7jqpHI0+JHi+@google.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <20220825085625.867763-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825085625.867763-2-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Xiaoyao Li wrote:
> KVM supports PT_MODE_HOST_GUEST mode for Intel PT that host and guest
> have separate Intel PT configurations and work independently. In that
> mdoe, KVM needs to context switch all the Intel PT configurations
> between host and guest on VM-entry and VM-exit.
> 
> Before VM-entry, if Intel PT is enabled on host, KVM needs to disable it
> first so as to context switch the PT configurations. After VM exit, KVM
> needs to re-enable Intel PT for host. Currently, KVM achieves it by
> manually toggle MSR_IA32_RTIT_CTL.TRACEEN bit to en/dis-able Intel PT.
> 
> However, PT PMI can be delivered after MSR_IA32_RTIT_CTL.TRACEEN bit is
> cleared. PT PMI handler changes PT MSRs and re-enable PT, that leads to
> 1) VM-entry failure of guest 2) KVM stores stale value of PT MSRs.
> 
> To solve the problems, expose two interfaces for KVM to stop and
> resume the PT tracing.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/events/intel/pt.c      | 11 ++++++++++-
>  arch/x86/include/asm/intel_pt.h |  6 ++++--
>  arch/x86/kernel/crash.c         |  4 ++--
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index 82ef87e9a897..55fc02036ff1 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -1730,13 +1730,22 @@ static int pt_event_init(struct perf_event *event)
>  	return 0;
>  }
>  
> -void cpu_emergency_stop_pt(void)
> +void intel_pt_stop(void)
>  {
>  	struct pt *pt = this_cpu_ptr(&pt_ctx);
>  
>  	if (pt->handle.event)
>  		pt_event_stop(pt->handle.event, PERF_EF_UPDATE);
>  }
> +EXPORT_SYMBOL_GPL(intel_pt_stop);
> +
> +void intel_pt_resume(void) {

Curly brace goes on its own line.

> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
> +
> +	if (pt->handle.event)
> +		pt_event_start(pt->handle.event, 0);
> +}
> +EXPORT_SYMBOL_GPL(intel_pt_resume);
>  
>  int is_intel_pt_event(struct perf_event *event)
>  {
