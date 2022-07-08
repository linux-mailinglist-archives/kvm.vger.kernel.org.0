Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED756AF6A
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiGHANP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 20:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiGHANN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 20:13:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971EC6EE9B
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 17:13:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g4so21027547pgc.1
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 17:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=geWP06GzncOelPKkQeN+0o1/tBU6en0d2lL1f1V+nR8=;
        b=r2+VJXXTf3VPwem08ap/MwUaEIwqGGJZja/0+IAdDWNytLe6PRw6uG1C2XqVZqsX3Y
         st1DQPbh9zGLhc2v2/O733ySbvOalLT2v5aHFTEKHZtCIUntL9x/YGAAQ9pAZzvchbuC
         22xYUS5eW1gYlLGLV6CJlWWSo0P0jr2VubGmBdOJ6wEtQyBPudIPZzwqe8JR8tNpLvI0
         eamkjsdgN/Do8QOT1Hz4A4s5H6Urkfu0f3YXrt6s/v1DLy1wah7bxoB9rpJz2FTQ1agO
         IaPt0ebDTt0AvlAffFO57AMytDf8FMCjqPt4IpN6tMz6yDudgLSHlEQRT6keU+w53gvW
         I86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=geWP06GzncOelPKkQeN+0o1/tBU6en0d2lL1f1V+nR8=;
        b=TbM62Uvx5TElZ105yAelO6YVon7U60ZiKKM/tzvbKvfUsdfzdHFFVsUrTjydJC7UuF
         MtLYuaKblsZI4h8+eSUy8AgFNiwWIxEiiixC3zh7tAxEE0Toz5v79+iWE479ghFl4cZM
         fEDtxq+L7lcZ9GYLblKPPt2LC4WXmWZ4RUVh5A/ysSTrTxL230i3hA2H+oXZmMixggmC
         L9+QR3/QPJrWEy3v9HHLwkv2r3TZZlGgA9u+8YwSdNiWl8nMbI8k0C7JYyRtea4DGnA6
         sRps6JnY7GHWTvaism+Q76PwYtJuoTeiBtY/1xwUeji8nRD6OGMAgK+lydO3+/rHSaS6
         CbTQ==
X-Gm-Message-State: AJIora93XtPfz2sHdbPZJ2oDxTcAODNUKLlQnY9YgOqEeIYDhNpq9/ff
        dIywWgoySKLE7qu5TLgcUww/AA==
X-Google-Smtp-Source: AGRyM1tluLbrMuY8kHgQZxzpjI69HBv1Wie45ti4QPPbO+NeOViJ4vvKG3Zf9CiUrh/1x3SbQYff8Q==
X-Received: by 2002:a63:6984:0:b0:40d:9ebe:5733 with SMTP id e126-20020a636984000000b0040d9ebe5733mr686576pgc.170.1657239191045;
        Thu, 07 Jul 2022 17:13:11 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090a31c100b001ef79eb5033sm164489pjf.11.2022.07.07.17.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:13:10 -0700 (PDT)
Date:   Fri, 8 Jul 2022 00:13:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: x86: VMX: Replace some Intel model numbers with
 mnemonics
Message-ID: <Ysd2ksYsp/ie2Xx0@google.com>
References: <20220629222221.986645-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629222221.986645-1-jmattson@google.com>
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

+Vitaly (if you want to carry my R-b in your series)

On Wed, Jun 29, 2022, Jim Mattson wrote:
> Intel processor code names are more familiar to many readers than
> their decimal model numbers.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c30115b9cb33..1e3ab13bc17d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2645,11 +2645,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	 */
>  	if (boot_cpu_data.x86 == 0x6) {
>  		switch (boot_cpu_data.x86_model) {
> -		case 26: /* AAK155 */
> -		case 30: /* AAP115 */
> -		case 37: /* AAT100 */
> -		case 44: /* BC86,AAY89,BD102 */
> -		case 46: /* BA97 */
> +		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
> +		case INTEL_FAM6_NEHALEM:	/* AAP115 */
> +		case INTEL_FAM6_WESTMERE:	/* AAT100 */
> +		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
> +		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */

Thanks for the opportunity to test my hex=>decimal abilities ;-)

>  			_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>  			_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>  			pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
