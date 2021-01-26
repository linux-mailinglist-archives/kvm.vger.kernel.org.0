Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265F5305CCA
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313738AbhAZWoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:44:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393977AbhAZSDa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 13:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611684121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MdWP0uQnXXkXJZHH0rQndsx8DUDi4/ani+vrBbllukg=;
        b=KFnglcPjKf+yj0GIvQedVixzdiDt12I2bqNEk1HqnQl4V9xf6KuK78y7CY2SrTkrkr9Q2X
        O3Whl2VcNLvHSwQD2P+b+BflPVJnOXJ1s5x8qlLVQwiG2KaRvcIht9xTvN9KDEYYeepoVC
        7qjK50x9jMKrLnXqiLEoDO3tqVWssgM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-n6ue6I4ZN7Ow0kJc7YzQrw-1; Tue, 26 Jan 2021 13:01:59 -0500
X-MC-Unique: n6ue6I4ZN7Ow0kJc7YzQrw-1
Received: by mail-ed1-f72.google.com with SMTP id u19so9269599edr.1
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MdWP0uQnXXkXJZHH0rQndsx8DUDi4/ani+vrBbllukg=;
        b=AYTMXuKUP3C04V5im7Figxij5wvhxlUv3gZxZ3xcy6oZjw5qxsA9UW3MYEJ+lQyKrn
         jre4jbqHdVyXWa1pTFqBlbRSWdjwAWPjg614clGZSiV0s/nKfNWZKbuHKhheHeLtgNOJ
         hLZboJc2ge9/Pd+StR0bqYNcZm4FgsbK95SARThilMSdMHj0g0+vbMNc7rkLg6faYEHU
         p4VYUkalohiirKkOpBr9/JdWayxR5ff2d8/CZRYxxt87iz4bs/27BpBgYuiZKaxBvnGe
         vMjZiqU4Drh+xKfTTjye95yxUz5lJ+9WaM5UuHVMXRCTB1I7CchLAyCSHoKjDyE7j129
         JRbg==
X-Gm-Message-State: AOAM530r5AMLeUg4H5QVaZTYurAVT7f78wrRkWut4OyBANvoneFxvESZ
        fQuQXCnLhnJPZzBtDpIylNJlaxQTKL4Pi/fPEkZvZc77Gv/wf/NJMsycxNNvDBAiOAqI2jlbzOz
        yXyt5udCO1vgS
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr5464491edb.202.1611684117669;
        Tue, 26 Jan 2021 10:01:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXWyX23eVRTCZ+Y/PAA8KWE+r6Um2ibPctwkRx8m/pqFP0kMwUTGC9QapLSa6it6dg7Deczg==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr5464468edb.202.1611684117441;
        Tue, 26 Jan 2021 10:01:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s2sm8187970edx.77.2021.01.26.10.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:01:56 -0800 (PST)
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-3-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62f5f5ba-cbe9-231d-365a-80a656208e37@redhat.com>
Date:   Tue, 26 Jan 2021 19:01:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200807084841.7112-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/20 10:48, Chenyi Qiang wrote:
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	bool pks_supported = guest_cpuid_has(vcpu, X86_FEATURE_PKS);
> +
> +	/*
> +	 * set intercept for PKRS when the guest doesn't support pks
> +	 */
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PKRS, MSR_TYPE_RW, !pks_supported);
> +
> +	if (pks_supported) {
> +		vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
> +		vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
> +	} else {
> +		vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
> +		vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
> +	}

Is the guest expected to do a lot of reads/writes to the MSR (e.g. at 
every context switch)?

Even if this is the case, the MSR intercepts and the entry/exit controls 
should only be done if CR4.PKS=1.  If the guest does not use PKS, KVM 
should behave as if these patches did not exist.

Paolo

