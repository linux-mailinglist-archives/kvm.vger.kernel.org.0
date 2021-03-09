Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775763320D0
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCIIf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:35:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhCIIfK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 03:35:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615278909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PORgpV8btKUVlSqAuXSV1oXMJ8Z1sUdHU+sPVlWF2pY=;
        b=U+JOy3ubcEoxUHg91dxPOc19MLfsh7W/etOifvW+rShYrtrzxFj3W0Y6tXlyJ76xyKaxgW
        siVkkbVmZv/zU90NHfYpCic6hSBrC/KpemS4y+USxp+S4XV9qJ57nZutXzKOljMLT4kQWa
        //4LWd63GKHn8UO63IagoNTHwAdd8oQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-89eTXVwsNEG1-WzSMfaXZQ-1; Tue, 09 Mar 2021 03:35:07 -0500
X-MC-Unique: 89eTXVwsNEG1-WzSMfaXZQ-1
Received: by mail-ed1-f71.google.com with SMTP id a2so6369219edx.0
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 00:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PORgpV8btKUVlSqAuXSV1oXMJ8Z1sUdHU+sPVlWF2pY=;
        b=NiZrCluoUnMKLsDnEZG1dqN6kz+bO+ivoZqzsyOidC8uD2JC09KSrQNoalI3MwPx4M
         HDkA+Lq+inw7A/Z6NeP9KmHirt19hN8cscTMcOCIAwbnr2iW4WDhuPkWc4NM0M8L9BZu
         g4CJ9GE6G+3U2tS1wzbUGxeQ0QrXWpoGjztDRGxM1FWIN3TY+nTv+C1UpHBqrLWClqC6
         EU7YiYy9ie4RwklUvnca9VzpZskYZpunGQN+k1z7WZBvynyjM1XCXZm4LVJ6vFqrMx/m
         Kl6Q4VZ5NJnV2QB4hOZxarv3jWEFizlKCLiIL7kfQdImsuavhAUr5SARZclAAaJO7GYs
         y5FQ==
X-Gm-Message-State: AOAM533dQhAE5Uej7OzQpHKSwq+64qiO+wSOiEGV536vAnnyKmJjf1SY
        c/d46y3Wj/c/U9OLArKH9MeJpKa2VkfAeGl93RSEvXJW/Ql03p5RlqHcbu4cvsw2yRD11lPS7At
        WRMUnjHAqS4Ik
X-Received: by 2002:a17:906:2816:: with SMTP id r22mr18866476ejc.2.1615278906740;
        Tue, 09 Mar 2021 00:35:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8C6rFsRpziOKWkG0LsP2Jk+17IqacQhd3MOq1Jzaf/Tw+fkvNG2ar6TkwhORB06B1B//fyw==
X-Received: by 2002:a17:906:2816:: with SMTP id r22mr18866458ejc.2.1615278906544;
        Tue, 09 Mar 2021 00:35:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y9sm7913368ejd.110.2021.03.09.00.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 00:35:06 -0800 (PST)
Subject: Re: [PATCH v4 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20210305183123.3978098-1-seanjc@google.com>
 <f1edcb01-41f5-d26f-e8d6-0dbd09a1eb89@redhat.com>
 <YEbM0SYpnfcTnfdA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <787911b2-28df-7019-6f2d-55edadc91ed9@redhat.com>
Date:   Tue, 9 Mar 2021 09:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEbM0SYpnfcTnfdA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/21 02:18, Sean Christopherson wrote:
> Maybe this series is cursed.  The first patch got mangled and broke SME.
> It shows up as two commits with the same changelog, so maybe you intended to
> split the patch and things went sideways?

There was a conflict.  I admit kvm/queue is not always that good, 
usually I try to test it but yesterday I just didn't have time.

I'll fix up everything (also 20/24 in the other series).

Oh well, you have to break eggs to make an omelette. :)

Paolo

> Anyways, commit a16241ae56fa ("KVM: x86: Get active PCID only when writing a
> CR3 value") breaks SME and PCID.  The kvm/queue code looks like this:
> 
> 
> 	cr3 = __sme_set(root_hpa);
> 	if (npt_enabled) {
> 		svm->vmcb->control.nested_cr3 = root_hpa;
> 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> 
> 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
> 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> 			return;
> 		cr3 = vcpu->arch.cr3;
> 	}
> 
> 	svm->vmcb->save.cr3 = cr3;
> 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> 
> but it should look like this:
> 
> 	if (npt_enabled) {
> 		svm->vmcb->control.nested_cr3 = __sme_set(root);
> 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> 
> 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
> 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> 			return;
> 		cr3 = vcpu->arch.cr3;
> 	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> 		cr3 = __sme_set(root);
> 	} else {
> 		cr3 = root;
> 	}
> 
> 	svm->vmcb->save.cr3 = cr3;
> 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> 
> I'll generate a delta patch, and test and post, just in case there is other
> stuff that got lost.
> 

