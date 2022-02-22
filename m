Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741794BFC45
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiBVPTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiBVPS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:18:58 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D49414EF47
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:18:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i1so2060250plr.2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KTIgayfF256C1V3doe1DdTxEVA57V8A5z8D2kONEGBU=;
        b=phCKcy6ZlyPZILwJUuf5krXb9GXGiI+Q+qqv/bFW/YJcaPBmAdKjGBM1ZUs+ykOeV4
         nB9egMrtpTXPwCC5WfjBHjfmeDOwlShk+0G6IlEauOM8Njv5XFDbPA55tOT9lKddY/k2
         lDv7A3nqdcxfQPH3wW4Hkm7BDuVp2Bzr+H/GbIV2OHpb6uq9gQ0DzrMZU6p6WXKsgdkW
         oaPc7t1wl5OvRsHba3BUjdT7PMF71C1tqCzUgX+LwsVXpsYEZ60RfnFAHSVOYn44xdym
         UgfS7uxsf+nbtDj170mV8tvJSZP7YlUxWgAydYh6cjvUq3o9XbaY8xhzYe66L3LLHqQ5
         bpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KTIgayfF256C1V3doe1DdTxEVA57V8A5z8D2kONEGBU=;
        b=DVzd7GzfbxEJ6Mc8MN99FpvTJV6gXLy2YVBxzeTekupxin8TXVsrTr8lILu57rDjDB
         mz7Jrb8fvwp7S0R8dFXQJDom+LFht1UoipLljlrBDW0NcYqMQW3T7X9ZjzLXb4EspiCK
         1iMsu/5mJxOTKoSEupp98U/VWA7raLQxQcgFt94EdR0KvFMHuwnQevY/SahN4QHN95pS
         vBar8JpurqEVIPobJiBt+uRwrsKYjrQ+QXNf+x2hpLbOoAG5QAWUVHkfbT23CuCOUXnh
         X3XPcnZQhCOrI6seuic0yZ5S6lhbOlgEM3rbBA2WhqzdPccJWGuXDFLvkZXe+AFfaE4b
         j9Ew==
X-Gm-Message-State: AOAM530EzcqqTO1bLYFAosw7xqyU67BtOKpRCUumEntEZYY+cUa1j/5F
        LBpRSc32YTM8IVNgLet0jE1P/Q==
X-Google-Smtp-Source: ABdhPJwvlQXIDcBUOToJAayzxtth7rwk5FzeKqCmlWGndNY53wWW7Nj0TkPlLboM5Q+8JBUI+Wfa9A==
X-Received: by 2002:a17:90a:168f:b0:1b9:453a:fe79 with SMTP id o15-20020a17090a168f00b001b9453afe79mr4661886pja.107.1645543108883;
        Tue, 22 Feb 2022 07:18:28 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p9sm17849001pfo.97.2022.02.22.07.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:18:28 -0800 (PST)
Date:   Tue, 22 Feb 2022 15:18:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kvm:vmx: Fix typos comment in __loaded_vmcs_clear()
Message-ID: <YhT+wOc18G7Twujw@google.com>
References: <20220222104029.70129-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222104029.70129-1-flyingpeng@tencent.com>
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

Needs a space on this shortlog too.  And please capitalize both KVM and VMX.
Again, no need to send another version.

On Tue, Feb 22, 2022, Peng Hao wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Fix a comment documenting the memory barrier related to clearing a
> loaded_vmcs; loaded_vmcs tracks the host CPU the VMCS is loaded on via
> the field 'cpu', it doesn't have a 'vcpu' field.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6101c2980a9c..75ed7d6f35cc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
>  
>  	/*
>  	 * Ensure all writes to loaded_vmcs, including deleting it from its
> -	 * current percpu list, complete before setting loaded_vmcs->vcpu to
> -	 * -1, otherwise a different cpu can see vcpu == -1 first and add
> -	 * loaded_vmcs to its percpu list before it's deleted from this cpu's
> -	 * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> +	 * current percpu list, complete before setting loaded_vmcs->cpu to
> +	 * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
> +	 * and add loaded_vmcs to its percpu list before it's deleted from this
> +	 * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
>  	 */
>  	smp_wmb();
>  
> -- 
> 2.27.0
> 
