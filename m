Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960314BFC3C
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiBVPRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiBVPRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:17:38 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37F9A88BD
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:17:04 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id m11so12319049pls.5
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lcRYoN5Uf3rBH9v/7qdYElQaWmfVzREsyATDiT2CRiQ=;
        b=WOnf61l0rum3il1zfoKqAJBV8UpvfqPLdVI2HNdp0/fkGZhP8BLuhXuHloYSx87D7i
         vD/oiHYQhINsdy7aNuzrOQxnCtcwwQ7RNIkZoGImk22FmjdmEJzRpUmpP8WPfKfhnNCg
         eNQsX7Ji9mOqEjLE3cxiValuU2L6vFsahcS9hlQ6Lh5rOKChD33zVFMX56mT2yhVuiGj
         MgDfp3Pma4sl5hKjucCbSHn7WKfAwyMzAzn21cZ9xkRnFZUir5Fkht+vjpT4TCiQG+2t
         ASN4hutVwU80e0OPrN21Y3fcUhw+NPPnQWFWqhN2oDGb22n/a7YkI5CHvry2Visg4w2y
         DSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lcRYoN5Uf3rBH9v/7qdYElQaWmfVzREsyATDiT2CRiQ=;
        b=MnDDbUpe8dknY9Aj6nSW0dN/L5n64XfrDh/wVHlDi+ylXwXwZOfVq8ab9H4xaON00Z
         TH6ad5NnfoT4qCDhFtceeU6a4XDOqdlZ43ATl54jG4pw847Z4yof8pLl9W32jk0Z7Dmb
         hj6aLY5vt2ho3qlb2/2/BW1ZJf7ZZEm/8t4x4CBfHyhxPkRybfJw+G81y3lejocFnx94
         P6AjYp1QH88SpUdLRuTq/bgSXL5kw25Tk5Xva8ej0pgQsBnC4h7x+DOz1szLo4aPvxHP
         kVCjPY5xxW3xxNXEcE4HXdDs4EVcID+kR0BP+DubtywN8ji8oVtKcEn5UlfIDMkbrnuT
         XS7Q==
X-Gm-Message-State: AOAM532KWnfrRZ345w1hL1ofTxyvi0bheskZa9azOkEumZpEYboibfoQ
        wBjtROnuLmcDJ9vb3WJXOSrWoQ==
X-Google-Smtp-Source: ABdhPJxOKcTBsgn4bM4lfQ6m0TCJ8CTWmoDGUwk8YW+5S3eaRB5CkZRKDnw3qqsiCVaVhGIcU8Bkrg==
X-Received: by 2002:a17:90a:8d85:b0:1b8:a215:e3e4 with SMTP id d5-20020a17090a8d8500b001b8a215e3e4mr4520719pjo.175.1645543023501;
        Tue, 22 Feb 2022 07:17:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090a450900b001b9b5ca299esm2962733pjg.54.2022.02.22.07.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:17:02 -0800 (PST)
Date:   Tue, 22 Feb 2022 15:16:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM:VMX:Remove scratch 'cpu' variable that shadows an
 identical scratch var
Message-ID: <YhT+a4I0ytA7eVE5@google.com>
References: <20220222103954.70062-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222103954.70062-1-flyingpeng@tencent.com>
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

Needs a space between "KVM:" and "VMX:".  No need to resend, Paolo can fixup when
applying.

On Tue, Feb 22, 2022, Peng Hao wrote:
>  From: Peng Hao <flyingpeng@tencent.com> 
> 
>  Remove a redundant 'cpu' declaration from inside an if-statement that
>  that shadows an identical declaration at function scope.  Both variables
>  are used as scratch variables in for_each_*_cpu() loops, thus there's no
>  harm in sharing a variable.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
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
