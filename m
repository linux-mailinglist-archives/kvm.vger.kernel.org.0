Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52A1374A23
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 23:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhEEV3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 17:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhEEV3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 17:29:36 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3F1C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 14:28:39 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t22so2842119pgu.0
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 14:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ahSIRGK2fYWWMJVxtv1JPWgUm0OPTQW4ZW0oanx+tLQ=;
        b=WNFQ/WRK83n/T1KRmVg59K5vVus49xIttRmJw/BRUayCqpdm5ldKmXXnsj3Mu9jRTn
         bcJIxVVvYky2x8Pt4KYC1HRIXelcFq1ZgQ6bVx6ZslPmRURJr9wh/CUY8i92u11AI6E+
         8tQQ/6A2jg1KJUZA6Sc5qVdOtntRUTGoPxYWZoe4h/MLt7UBnfpgosqLdGNTbrmSOwVJ
         jSysacOM6MvjkBLj4AlDQvnFsExTB2R07kQmKbScySNwHNDtOHGtmv9O3n3vJil2qRls
         1YJlNSul6k0WfkRA975vjiltIQ1MqTJFOt1MwgK/OlQQfFZRW6jNJuzWf2Ols+KeeIbp
         g7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ahSIRGK2fYWWMJVxtv1JPWgUm0OPTQW4ZW0oanx+tLQ=;
        b=XFhaP4oDKwXWyBiZrcF3ojsw7D9un7LddE4dYxw035P2EMkZSrA3JDLOM1YbLvRkCn
         YEGOQCIWsIWNZUuoaoHvgdA62I5T96D09YN6uzc87orwz6VhE5/TQ1m8xIe+AbFalIec
         YGHqu3jN6Nn9sRQGCusY6PW/WNk8s/Ts+ptyxe3hQp/lSkXHUmgLoU2Jr+fSxhOlsz3U
         N3RbHxkTaaBTX3WOsEQIn2qWgo3755vlNfpe0uaO2I5vip9GJR1XuqXbeLSq0NbGCZjX
         g5d1JUMyZZRTzY/4PKKfrSmodeIDAxh4jDEuev5fh5JMQ1XrSFvOFlclIOGB0iSX0Qfv
         RZYw==
X-Gm-Message-State: AOAM530z6K4Xo9gPnlRxYBHGUvSnki5uCLRBW1qBRSgX3iGdbKUCh/LZ
        TW/7v2g0fMGNc4gizhi1k71SYw==
X-Google-Smtp-Source: ABdhPJz3AKd0wVU4oiG2Drgtg1foqJ6TnB/es1muP8FGj5g8t3BWiZ3+Fjm90YwR/yJS5o9BrcjbBw==
X-Received: by 2002:a65:63c5:: with SMTP id n5mr853733pgv.271.1620250118488;
        Wed, 05 May 2021 14:28:38 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:820b:3fc:8d69:7035])
        by smtp.gmail.com with ESMTPSA id i62sm150306pfc.162.2021.05.05.14.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:28:37 -0700 (PDT)
Date:   Wed, 5 May 2021 14:28:31 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: VMX: Fix a typo in comment around
 handle_vmx_instruction()
Message-ID: <YJMN/4LE5u7NNW9e@google.com>
References: <20210429042237.51280-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429042237.51280-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Kai Huang wrote:
> It is nested_vmx_hardware_setup() which overwrites VMX instruction VM
> exits handlers, but not nested_vmx_setup().  Fix the typo in comment.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 10b610fc7bbc..f8661bc113ed 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5618,7 +5618,7 @@ static int handle_preemption_timer(struct kvm_vcpu *vcpu)
>  
>  /*
>   * When nested=0, all VMX instruction VM Exits filter here.  The handlers
> - * are overwritten by nested_vmx_setup() when nested=1.
> + * are overwritten by nested_vmx_hardware_setup() when nested=1.

Alternatively, to reduce the odds of the comment becoming stale again:

    are overwritten during hardware setup when nested=1.

>   */
>  static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
>  {
> -- 
> 2.30.2
> 
