Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C1A4BBD0E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbiBRQKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:10:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbiBRQKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:10:45 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B575105A92
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:10:28 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 12so4711933pgd.0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HAYrDphdekGq8Y2YdxSlByL5fP4/mKHO4xQXVEQlRIA=;
        b=WtOl1Gg29/RXqP6+l0OXUA7jj3EGFt3yNmclK999v8XN6uBArMXVClQ5BwJBGv27IT
         BGn5tyTnaQM8s8Qt0IZ8zzJS53z8duXCnHVMmXMw0O1+eMscP65VAWsOENGj/inhp5OX
         9XBhFpnpSCPLMN57fyFbWCoLfruG34fNyaahsdlRtnAUzM3nNq3twp27QmFVPCpfUtgE
         UrzW9dtFrptd+xjnw0PsjCJDIKKnP569LFbWwej8zp3ObBjJshq3lJhweZSBAAIncxrp
         JcegXpKPzjQqLOyNPkT4/G76KEAzNhs744LP+1r+cdV7yKCv/aSyCTBnTNlcHe0WkE34
         /4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HAYrDphdekGq8Y2YdxSlByL5fP4/mKHO4xQXVEQlRIA=;
        b=EsszCFM+cxPiQ+Z0lnreJ01aFs17XRlk8duOBYQ+3g/sEa2hulXEXmVtzANSV/70Ha
         rYJIwv1k+LdtQ/ccg9ri1FCanDq9YJDFmAft5xUv2/KxtmHcxtY2p1dPK4ppLSfF1tbW
         ADd5awB1VPQoHg7uVhXjKm+VHB8LUlJnHVXlNAMFfyMZLiJ5DLM/7qbt4cKgWPifReps
         +ZFwRE0OlKyagiQz1VYSuwM0vPzcQo8f+F47W5mF0k6d25LznGzZ91rAPErRErDuynNc
         vmHnJxhAIsOPafRQGXBshfgVbL9OeK9XBL3MfegYboQt73gdimSAfv+Xg4RsQWTG3Xrc
         QnrA==
X-Gm-Message-State: AOAM532fs8NksZloE6MhGZzF0mbp+vI2U9FETOvqF26A24wJxPjXjk4f
        XtoSh4PMITndzb6LErn4vGzsMkkjwoy8lQ==
X-Google-Smtp-Source: ABdhPJwcLmDZWmg0L3526xbxQ3iTxJHpDES/UOFw0XqtXvvvDJ8V2+nR1w2BOMdmn38i0LpaESo6cQ==
X-Received: by 2002:a63:5911:0:b0:36c:4394:5bfa with SMTP id n17-20020a635911000000b0036c43945bfamr6763463pgb.519.1645200627893;
        Fri, 18 Feb 2022 08:10:27 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x5sm5130665pjr.37.2022.02.18.08.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:10:27 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:10:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4]  x86/kvm: remove a redundant variable
Message-ID: <Yg/E71MbiFWq9A0p@google.com>
References: <20220218110747.11455-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218110747.11455-1-flyingpeng@tencent.com>
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

Similar comments to the other patch.  "KVM: VMX:" for the scope, and a more descriptive
shortlog.

Also, this patch isn't part of a series, it should be simply "PATCH", not "patch 1/4".

On Fri, Feb 18, 2022, Peng Hao wrote:
> variable 'cpu' is defined repeatedly.

The changelog should make it clear why it's ok to remove the redundant variable.
E.g.

  KVM: VMX: Remove scratch 'cpu' variable that shadows an identical scratch var

  Remove a redundant 'cpu' declaration from inside an if-statement that
  that shadows an identical declaration at function scope.  Both variables
  are used as scratch variables in for_each_*_cpu() loops, thus there's no
  harm in sharing a variable.

With that,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ba66c171d951..6101c2980a9c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7931,7 +7931,6 @@ static int __init vmx_init(void)
>  	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
>  	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
>  	    KVM_EVMCS_VERSION) {
> -		int cpu;
>  
>  		/* Check that we have assist pages on all online CPUs */
>  		for_each_online_cpu(cpu) {
> -- 
> 2.27.0
> 
