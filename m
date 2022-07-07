Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F06856ACAD
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiGGU00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiGGU0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:26:24 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E152A265
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 13:26:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a15so21614415pfv.13
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 13:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/2oEiUtXB8zdTZI8StEa7a6n0nIv8i48Mk6Aya0636A=;
        b=EANP21qrJPqht5EjCTYD/qIOUvfF79QB94rNdP7AsSrbS75s5gHlgDarLBUsAx7KMG
         BhzO47UeF4aq/qA/Ya+JPNTaFHS9bEzo2DNzwSJRtE1yBN2lnty7sVoL85RDj7d2r+O6
         iX7VIFkXsaXCYuVlWHwrvvuN1w0tZExODAGy6zK+wh1SppaCQuN9yUYCk+579zruwwqk
         K7LSfyzhAgwJIDhkS4f2V+GJtjoDtTXqC4N7zzNv6gwDujdtYWyybyKTq9Ve0+t1RED0
         LiforkRPm5re8QcmHlfo14pdbEdsmXTgcsog0kbQNdsYZGPAbNUJGLUC7NWOH8liWubT
         oEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/2oEiUtXB8zdTZI8StEa7a6n0nIv8i48Mk6Aya0636A=;
        b=39EF7avPZOFzxJEboWr6+tZb9IOUjZVvCvMw9vqz60qotBgnNG3GsnjCHIXoKYyifH
         sGrbidX3K8qJaL8wHjbGeazJFPl8Uu8aP2mIVk4xe3ywAWtlg/ubQM8lGcJHrspGmPix
         TsIjHy5HVTntfBI6CmMuNZgj2v9Ic4MawLbzvZ7C3/oAl+Zn9+YVlEyIc7idCGmLXUqt
         Z6s7foPt6Bt1WujzAYUu7hnKXhltYovKKYOrpgYf/KvVn0yuJesY8eLSjyCtcJGwnOdO
         4OoqaVvNPS0tbB6INOCnGhf1/5NN8iHnZpQ4w5/hFRXbGJgUOSwhnCqdL69QwlWL2St2
         RgXw==
X-Gm-Message-State: AJIora/MHPALXGd66b2hnxo3sohrs0uAHVak5l/VOYQC/SoiZJKQnnhm
        A/RWD+L+Qd282Y7ErFxi4IWbyw==
X-Google-Smtp-Source: AGRyM1ulgMk7hBQnPDy9W9by9/Gc5QsLrc82OWqbBGCs9F1Dfv4XxMWyySkCakkguG05CsLpNTzxYg==
X-Received: by 2002:a17:902:b598:b0:168:f664:f1cb with SMTP id a24-20020a170902b59800b00168f664f1cbmr55664867pls.26.1657225583587;
        Thu, 07 Jul 2022 13:26:23 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id l14-20020a170903244e00b0016c18f479d5sm1440937pls.19.2022.07.07.13.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 13:26:22 -0700 (PDT)
Date:   Thu, 7 Jul 2022 20:26:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 1/2] x86: Skip perf related tests when
 platform cannot support
Message-ID: <YsdBa6BNrwdwBMPI@google.com>
References: <20220628093203.73160-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628093203.73160-1-weijiang.yang@intel.com>
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

On Tue, Jun 28, 2022, Yang Weijiang wrote:
> Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
> are supported in KVM. When pmu is disabled with enable_pmu=0,
> reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
> so skip related tests in this case to avoid test failure.
> 
> Opportunistically replace some "printf" with "report_skip" to make
> the output log clean.

Ooof, these end up dominating the patch.  Can you split them to a separate prep
patch?  Thanks!

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> v4:
> - Use supported_fn() to make the code nicer. [Sean]
> - Replace some of the printf with report_skip to make the results clean. [Sean]

Put the versioning info below the three dashes so that it doesn't show up in the
final changelog.

> ---

<version info goes here>

>  lib/x86/processor.h | 10 ++++++++++
>  x86/vmx_tests.c     | 40 +++++++++++++++++++++++++++-------------
>  2 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 9a0dad6..7b6ee92 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -690,4 +690,14 @@ static inline bool cpuid_osxsave(void)
>  	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
>  }
>  
> +static inline u8 pmu_version(void)
> +{
> +	return cpuid(10).a & 0xff;
> +}
> +
> +static inline bool cpu_has_perf_global_ctrl(void)
> +{
> +	return pmu_version() > 1;
> +}
> +
>  #endif
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4d581e7..3a14cb2 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -852,6 +852,10 @@ static bool monitor_supported(void)
>  	return this_cpu_has(X86_FEATURE_MWAIT);
>  }
>  
> +static inline bool pmu_supported(void) {

Curly brace goes on a new line.

> +	return !!pmu_version();
> +}

Why not put this in processor.h?  And maybe call it cpu_has_pmu()?
