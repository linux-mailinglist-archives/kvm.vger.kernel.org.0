Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7D3E5680
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhHJJQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:16:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229827AbhHJJQW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 05:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628586959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTHqhfaxRC2Au/zyVTaY73Hq4lXOxk2BbzMt/B/vIMc=;
        b=E2uAUxLblzPgjLrrpR7h/pl0wfS7o6lbzdxX+gbN7A7ZhCIikyoRTQkbMWnia/3hrFJdsJ
        VQO64fRdELMxwgPQnv/GKs/VDVM1JANr4ufbtZb9svI9M+59qpUdtC4v2WIiuOuuzAGMje
        paZninefQDAuUc1V+1ZIxcrIu3xyMmw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-4u68-oQkO1-3GpAvBJjQMw-1; Tue, 10 Aug 2021 05:15:58 -0400
X-MC-Unique: 4u68-oQkO1-3GpAvBJjQMw-1
Received: by mail-ej1-f70.google.com with SMTP id ja25-20020a1709079899b02905b2a2bf1a62so1316748ejc.4
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WTHqhfaxRC2Au/zyVTaY73Hq4lXOxk2BbzMt/B/vIMc=;
        b=li/9fK20i2rsG+pg32Fa/gHq3r8cjQEsYxLpXbVmhAmQbaYsXr7urIIt9Dq89GTkeT
         xe4hjAZ3HJil7Niq34pUfO6sVJIChEbldjZlMxTuAijuoXqc0lS4nppIfFfGN/zl6Upp
         /3ogZcCmcAKtCoO2Sa/Dw8l3SEOSZSD6yCYSIQOrUrwjo93Xl4HLsHEhrrYlBKiTahLc
         vYtcy2VOAevLCDS6FSc1CXyg3fmZtFV0D+RIiBg2OuvdGGeyR/POqhR6Zr8TCDlAkhfh
         2WL2rZX3VIdJeP4LjUb9QLGW3z+ug8NcKnbbWp2JLFQ/FL6vAt9pYjkBtodiF2YZYOWf
         WP0g==
X-Gm-Message-State: AOAM532rHM1oCKQ1CLR4v716bhgjhWabidtSzDaG3TONvdA3s6hRRWnR
        k19AWfFoQnQdgbK1cXkscLEa4VVNR4Vmk7fVNw8R4WlNESlkQaZOrCHuNvLrIW7Lbaitw7jBVlJ
        f4XqJeTGUSC3Q
X-Received: by 2002:a17:907:16a1:: with SMTP id hc33mr26856561ejc.536.1628586957342;
        Tue, 10 Aug 2021 02:15:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmISXaNnWSRteXfXz9vpviT4IQruyRbRcEytLGm5rhSt/w6TacYNKlyINUp94ReUU8sRbGpQ==
X-Received: by 2002:a17:907:16a1:: with SMTP id hc33mr26856544ejc.536.1628586957158;
        Tue, 10 Aug 2021 02:15:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id d2sm6566618ejo.13.2021.08.10.02.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:15:56 -0700 (PDT)
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20210809145343.97685-1-eesposit@redhat.com>
 <20210809145343.97685-3-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: nSVM: temporarly save vmcb12's efer, cr0 and cr4
 to avoid TOC/TOU races
Message-ID: <e56ce029-8ad5-f3bf-f375-384c34b62842@redhat.com>
Date:   Tue, 10 Aug 2021 11:15:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809145343.97685-3-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 16:53, Emanuele Giuseppe Esposito wrote:
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> +
> +	/* Save vmcb12's EFER, CR0 and CR4 to avoid TOC/TOU races. */
> +	vmcb12_efer = vmcb12->save.efer;
> +	vmcb12_cr0 = vmcb12->save.cr0;
> +	vmcb12_cr4 = vmcb12->save.cr4;
> +
> +	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save, vmcb12_efer,
> +				     vmcb12_cr0, vmcb12_cr4) ||
> +	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> +		vmcb12->control.exit_code_hi = 0;
> +		vmcb12->control.exit_info_1  = 0;
> +		vmcb12->control.exit_info_2  = 0;
> +		return 1;
> +	}

At this point you have already done a svm_switch_vmcb, so you need to 
undo its effects.  This is indeed what returning 1 achieves.  However, 
if you return 1 then the caller does:

         if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12)) {
	        svm->nested.nested_run_pending = 0;

	        svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
	        svm->vmcb->control.exit_code_hi = 0;
	        svm->vmcb->control.exit_info_1  = 0;
	        svm->vmcb->control.exit_info_2  = 0;

	        nested_svm_vmexit(svm);
	}

where we have three steps:

1) clearing nested_run_pending is all good

2) setting the exit code is good, but then you don't need to do it in 
enter_svm_guest_mode

3) nested_svm_vmexit is problematic; nested_svm_vmexit copies values 
from VMCB02 to VMCB12 but those have not been set yet 
(nested_vmcb02_prepare_save takes care of it).  The simplest way to fix 
this is to add a bool argument to nested_svm_vmexit, saying whether the 
vmcb12 save area should be updated or not.

Paolo

