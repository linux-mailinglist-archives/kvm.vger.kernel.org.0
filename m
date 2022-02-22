Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAE04BFC4D
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiBVPTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiBVPTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:19:53 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F7A1617E4
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:19:27 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so6232611plh.9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=065W2+7lVOrV2GcgMzw5UaR+s8GD1b5OP/wE8XesdUw=;
        b=M6o9Eqsxq9Sw+GXYBxLjd+Tl8x27VtCbtUrM0kPlPwmRvyoeQj4YVcvdFYXRazP9Lq
         8/IulR1QJIiDevh4bufqW/tYtPTdEVBO6p55gMxVWOZ80QToDR2X6EHhRYgyb81yOB+7
         ttV719vvggrvnjI6DnxlCrCq9xetRsCk75OV9MTg6EUx2B8JtPF/JtbWgZ66oYwtQ318
         HILrpMoMxnkFvJ00NVc9jHq8Vl9MhbBd0qSJNMYMlKga2TtQNlZuioXDbv/UUiIMwh06
         y4X8njKSsbcao2FduUFmZWA0hzcvom9YdkO+JDOuvPtHQ9LQCm3Mww0zoQbQNy61r9tr
         /cFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=065W2+7lVOrV2GcgMzw5UaR+s8GD1b5OP/wE8XesdUw=;
        b=hDH+LySRHvVoMz1oaMWS44Pu3V+Jr8LM7/IjIpg3e7B6OyZY82iMCM4FzDUOktF/n2
         vibyPRIgBtIuEY5IapaClACEbO/kusimi7uj3fsTcWWsK6OODeWK3keQw5diiUSj8Mf9
         kqSWHb/PDMVIdov9L6jnlK5am9u28u6CkmjoTy30N1j/OU+tpzuxl+HKs0Gk9V/shpSs
         Wjzi9maJj8Ra+TdtD1EcdjQfWly94YlSZJI/uL8dTaUxTtOLc43Y0JNCkdvz24tmCAdj
         wcSFdzpQFA9GpEretzvtsRp226Lv50aa3TVf1lPIeNJ+xiunR1EFIZAcyt7c57a0Zydg
         WAHA==
X-Gm-Message-State: AOAM530xerbU7YwO8RPNbSBtMcKerRVRTpElMZNv03hsKQ/pHglm4aoB
        tpwhdwFfSKAiHqu5EMeBKe4IJw==
X-Google-Smtp-Source: ABdhPJzi/cY1RRFVwaUXZmKVSHGczkZD8tS0IdmxJVGzLTCaKbkOKxh+swzfMDo5MH1l5QehMEnGZQ==
X-Received: by 2002:a17:902:d502:b0:14b:4520:9380 with SMTP id b2-20020a170902d50200b0014b45209380mr23995568plg.53.1645543166647;
        Tue, 22 Feb 2022 07:19:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y72sm17067538pfb.91.2022.02.22.07.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:19:26 -0800 (PST)
Date:   Tue, 22 Feb 2022 15:19:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM:nVMX: Make setup/unsetup under the same conditions
Message-ID: <YhT++ivZqDVzYRX0@google.com>
References: <20220222104054.70286-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222104054.70286-1-flyingpeng@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Needs a space added as fixup.

On Tue, Feb 22, 2022, Peng Hao wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Make sure nested_vmx_hardware_setup/unsetup() are called in pairs under
> the same conditions.  Calling nested_vmx_hardware_unsetup() when nested
> is false "works" right now because it only calls free_page() on zero-
> initialized pointers, but it's possible that more code will be added to
> nested_vmx_hardware_unsetup() in the future.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75ed7d6f35cc..9fad3c73395a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7852,7 +7852,7 @@ static __init int hardware_setup(void)
>  	vmx_set_cpu_caps();
>  
>  	r = alloc_kvm_area();
> -	if (r)
> +	if (r && nested)
>  		nested_vmx_hardware_unsetup();
>  
>  	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
> -- 
> 2.27.0
> 
