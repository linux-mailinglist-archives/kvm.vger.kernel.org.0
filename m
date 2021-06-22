Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44C93B0A78
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhFVQlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:41:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhFVQlR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624379940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahYCCUG34HQVi+l7/3X4cPIGOYt2HFC5/QUhGDOfhYI=;
        b=R6mscLwVORiDTcDA7pEfJnmIFR+5jVj73q17jL4SzLaoI0nau1w7LzFN1yosGhvhtMe+5r
        VqzVW4ng29juLJr/KMNUqAx8xVSTCsfBExrsTnU6k07lm0Ou+u63WadyQSrhHkFKp1UysH
        iDiKsclzyooYsgHWE19qIk3Fw6iP+xA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-dof6zE37MmaHUMCJnjuoPg-1; Tue, 22 Jun 2021 12:38:59 -0400
X-MC-Unique: dof6zE37MmaHUMCJnjuoPg-1
Received: by mail-wm1-f70.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so1340612wmh.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ahYCCUG34HQVi+l7/3X4cPIGOYt2HFC5/QUhGDOfhYI=;
        b=igN9/kYAEG/GprW8biaE30lrhaTKDmXMBxRbxn43vacd7J3oX3EIvt/4HthQ+QG/m9
         qkM/rMQtbXToEaFf6haiIatykgQEPqnsedsyYR+iX9BJJPzwZzKoVvfXAQBS7B63Nl1M
         CFn+Akb6mVhjkK29B232sQiNiSkp9YTRAx/e6wU52K0Ai4vrrG16k+CTtW9IJ0xq/KpK
         tE2klfYc/E04pT8MW+XhZbziIkBwCKtwXbc0NvBVQMdHz6nv8YBR5BwAlkeY5SpXyZzJ
         ImRorejeZtMZfV772/vJrQ2FToWxklSYNEDGRmmQ/9YUmp9uCEs95w3e6GEgrs6e8o5Z
         Sg4A==
X-Gm-Message-State: AOAM533EezHXltt9lrg/J5kRsUnJCQxVtFmnT78KEnl1BaYR93+CCXuH
        a2ZdeSVTYpzsjJBx8br7F9GIlN+RnpmTXZfu7syEMYyUCDRrbMZdgeiQIjx6fpM7lOPKoWIkOZk
        aJXHQIXwBC0KqeH+LIHz0RqL76Jk+p+lJ+9rQkcd8L0tdq4tJX+qNjTTIMKLJy3y1
X-Received: by 2002:a1c:9dce:: with SMTP id g197mr5544771wme.176.1624379937993;
        Tue, 22 Jun 2021 09:38:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydzEhr0dfWp++MUKsJMCx9xg+yjolQFCOWExEjkqPbfjVLkIAa+HcZbY7FoZYA8K89gW9sUA==
X-Received: by 2002:a1c:9dce:: with SMTP id g197mr5544754wme.176.1624379937774;
        Tue, 22 Jun 2021 09:38:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v1sm12469749wru.61.2021.06.22.09.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:38:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Print CPU of last attempted VM-entry when
 dumping VMCS/VMCB
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210621221648.1833148-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <91dea6ce-4dbe-70cc-9c61-17d97f47d2e7@redhat.com>
Date:   Tue, 22 Jun 2021 18:38:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210621221648.1833148-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 00:16, Jim Mattson wrote:
> Failed VM-entry is often due to a faulty core. To help identify bad
> cores, print the id of the last logical processor that attempted
> VM-entry whenever dumping a VMCS or VMCB.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   arch/x86/kvm/vmx/vmx.c | 2 ++
>   2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 12c06ea28f5c..af9e9db1121e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3132,6 +3132,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>   		return;
>   	}
>   
> +	pr_err("VMCB %llx, last attempted VMRUN on CPU %d\n",
> +	       svm->current_vmcb->pa, vcpu->arch.last_vmentry_cpu);
>   	pr_err("VMCB Control Area:\n");
>   	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[INTERCEPT_CR] & 0xffff);
>   	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[INTERCEPT_CR] >> 16);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ab6f682645d7..94c7375eb75c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5724,6 +5724,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>   	if (cpu_has_secondary_exec_ctrls())
>   		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
>   
> +	pr_err("VMCS %llx, last attempted VM-entry on CPU %d\n",
> +	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
>   	pr_err("*** Guest State ***\n");
>   	pr_err("CR0: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
>   	       vmcs_readl(GUEST_CR0), vmcs_readl(CR0_READ_SHADOW),
> 

Queued, thanks.

Paolo

