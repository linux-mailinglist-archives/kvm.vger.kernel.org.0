Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911D55152C
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 12:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiFTKDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 06:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiFTKCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 06:02:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31F313F16
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 03:02:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t21so3509314pfq.1
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 03:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=bukIkCz1BLVKZfua+9ATfKw2JsMlFEtEDfvvXjSwxLg=;
        b=uecC0bAKuqHCbuB/PSdZ+I92Im8L03KxMgUeN7vuTNdV/cRAIs5OCSH1qrYF4nDtnS
         1duhcw3G064kfxVLb0ZErph4kkFZjPBEyq53m+NI4eyuWjD2WyyffYdgmP9mQuDwAjdm
         JCge31UqzJILIaSyufD2e33+VYbOu43SeSAV22LMIV230OS2Cu9Gv+GA0NCa8nNQOAJH
         rhNpOiKFUaOdyRPKo7FDi9pRx9BHVhc20Bu2WAqWp/wmLUl2msEMOu3guEVnT4ENqUSh
         /LW0+ojrz+JIoEd/LDkjGkaGv9hECJOUoM++8Efk+AD9ztaZ5iqjX49OlMFziFVZWVuQ
         w7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bukIkCz1BLVKZfua+9ATfKw2JsMlFEtEDfvvXjSwxLg=;
        b=mouisdtECQtWLSP4PWksrDmwfYxrqcsXbj/hGbsOd2H5wpMwGuP5Fl05hHbvyVa+FD
         IEZtOxz8AEmjVGiJzUg/tm8QqqeKWBKFWaJ0sWOXon9T2NiG8vAklYWCAT4J3ybaWKWK
         ZxFZ3cCyb4aVdXSKZTGERIDqZputqpU6YcFz4P25w/mH9qcKfdcZELFFWTWk8PIuJ7QX
         yPnelDaqeBkpjIn7BHYblgnP8bhKBvdYBTLjODJ9zlS5xKDJ1KEUuBWdWPyuisvS3IsB
         5TlwCrSbpyGwdfLujdE26OWKyoEgysqT0UWMl4eWy7hEpK0kgVKZ9ry6JK9/pcEHqyKt
         fy/Q==
X-Gm-Message-State: AJIora8kjgUR1peopScZhtZh6rGyxBQ9cCHFyB1wJ9wpqhj4wHjCy48t
        bfmiqlxLekyZedMovGOkD/aVFA==
X-Google-Smtp-Source: AGRyM1vTOkwfISXt2hbk/1TBm1m3zcQzk2gA7vwjcrqp97tXsUH8cwsHfdp/OIovzieVHmh1JwLjCQ==
X-Received: by 2002:aa7:8e9e:0:b0:525:1d15:8fb8 with SMTP id a30-20020aa78e9e000000b005251d158fb8mr6784149pfr.35.1655719362190;
        Mon, 20 Jun 2022 03:02:42 -0700 (PDT)
Received: from [10.94.57.128] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902edc300b0016370e1af6bsm8280491plk.128.2022.06.20.03.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 03:02:41 -0700 (PDT)
Message-ID: <cdead652-cbd6-90e4-dab8-9cb18f71a624@bytedance.com>
Date:   Mon, 20 Jun 2022 18:02:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [External] [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>, zhouyibo@bytedance.com
References: <20220419154510.11938-1-guang.zeng@intel.com>
From:   Shenming Lu <lushenming@bytedance.com>
In-Reply-To: <20220419154510.11938-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/2022 23:45, Zeng Guang wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> With IPI virtualization enabled, the processor emulates writes to
> APIC registers that would send IPIs. The processor sets the bit
> corresponding to the vector in target vCPU's PIR and may send a
> notification (IPI) specified by NDST and NV fields in target vCPU's
> Posted-Interrupt Descriptor (PID). It is similar to what IOMMU
> engine does when dealing with posted interrupt from devices.
> 

...


> @@ -3872,6 +3875,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>   		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
> +		if (enable_ipiv)
> +			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR), MSR_TYPE_RW);
>   	}
>   }
>   
> @@ -4195,14 +4200,19 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   
>   	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>   
> -	if (kvm_vcpu_apicv_active(vcpu))
> +	if (kvm_vcpu_apicv_active(vcpu)) {
>   		secondary_exec_controls_setbit(vmx,
>   					       SECONDARY_EXEC_APIC_REGISTER_VIRT |
>   					       SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> -	else
> +		if (enable_ipiv)
> +			tertiary_exec_controls_setbit(vmx, TERTIARY_EXEC_IPI_VIRT);
> +	} else {
>   		secondary_exec_controls_clearbit(vmx,
>   						 SECONDARY_EXEC_APIC_REGISTER_VIRT |
>   						 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> +		if (enable_ipiv)
> +			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
> +	}
>   
>   	vmx_update_msr_bitmap_x2apic(vcpu);
>   }

Hi, just a small question here:

It seems that we clear the TERTIARY_EXEC_IPI_VIRT bit before enabling
interception for APIC_ICR when deactivating APICv on some reason.
Is there any problem with this sequence?

Thanks,
shenming
