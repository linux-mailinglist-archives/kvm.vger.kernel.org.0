Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B74AA037
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 20:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiBDTiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 14:38:46 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:40665 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiBDTiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 14:38:46 -0500
Received: by mail-pl1-f169.google.com with SMTP id y17so6006456plg.7
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 11:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=io+i+CzmLFcre/8lkkhzloSJnNMQ+D75oetcmjhqJnE=;
        b=iEWVrGvcOBNJTRz/k21utK9LGBFXk5C4kB49dXuD7M+E2t7+rVz6Mfk+iQtcs63CUt
         lVG48/BfK9l1uqm66dVAIjfjMCnim8bzJwHR3H50YH6qXEX1K0voVe9RX/xcGxdT5rTM
         tDoA4A9h08I+UhtT+gI+w4MmiMYVk2H7loJc8ouqHYLBaYX6TtlHNRHlmep4fzJ6VQrd
         JQzZznRP/49CNzZaRFozAz5foVpMoOUE+UhmkeBpzb6ML/gJxuEYEBNWzYdH6gCPF1dy
         t56GobVgCM+3Z3BMzJe5Ry5H15yw+0hWfnp0jIFxwpWL8HlBepwdw0Kz6ZMxAyAlEJII
         nGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=io+i+CzmLFcre/8lkkhzloSJnNMQ+D75oetcmjhqJnE=;
        b=CYBtAmSi20eJAy1LY6ubuelHuV4RfDqKYrlwNR4TAzvfhT28fhBAo2RL48QNCvNPaa
         fsUlKUw3xeUNkeg9ww1oMYGNm+z7OvWHjq5Jxg1s04NO2NBHvfvB5l4yAkA3Ui+wNWdR
         7ecsISdbttMVqdkIrpAYNvXlDUGkcTq5Ug4QxIrsDPC3+EaiI5/NK0YuuYgoNMDx0EjS
         ETFq07vdT3cP+ZXNCOTHLGG8f19AoxnrPLMHWFMRKKGMX/rubKQlIs4dGtJtxPeFGphZ
         mu62p30y7kSSCyOjgi/kFzmaO5fmVsvKYFtTlJ4kMyvdv2y3aV5EsfulAehArUYpEU5Z
         mmSg==
X-Gm-Message-State: AOAM530lwFFe1THgCibq3mm7CpoqG5NpobTrmx7eW7wRXXR0LRqfVnw/
        DA9YktOBt8KbGCUu+/HV15Gtyg==
X-Google-Smtp-Source: ABdhPJzpgkqiwLJOGzbPh+9TmMR+/YMmBnd2cAKA9Ll6ZjIHckg3YNCOFKQNjSwEehyIW1AdoeE4pg==
X-Received: by 2002:a17:902:ecc2:: with SMTP id a2mr4554988plh.12.1644003525574;
        Fri, 04 Feb 2022 11:38:45 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id y21sm3094863pfr.136.2022.02.04.11.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:38:44 -0800 (PST)
Date:   Fri, 4 Feb 2022 19:38:41 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 08/23] KVM: MMU: rephrase unclear comment
Message-ID: <Yf2AweXukX3TLh5r@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-9-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:03AM -0500, Paolo Bonzini wrote:
> If accessed bits are not supported there simple isn't any distinction
> between accessed and non-accessed gPTEs, so the comment does not make
> much sense.  Rephrase it in terms of what happens if accessed bits
> *are* supported.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 5b5bdac97c7b..6bb9a377bf89 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -193,7 +193,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
>  	if (!FNAME(is_present_gpte)(gpte))
>  		goto no_present;
>  
> -	/* if accessed bit is not supported prefetch non accessed gpte */
> +	/* if accessed bit is supported, prefetch only accessed gpte */
>  	if (PT_HAVE_ACCESSED_DIRTY(vcpu->arch.mmu) &&
>  	    !(gpte & PT_GUEST_ACCESSED_MASK))
>  		goto no_present;
> -- 
> 2.31.1
> 
> 
