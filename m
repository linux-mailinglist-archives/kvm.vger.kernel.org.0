Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC40E52EC9C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349560AbiETMvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349599AbiETMvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:51:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92322CCB4;
        Fri, 20 May 2022 05:51:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s3so10645234edr.9;
        Fri, 20 May 2022 05:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V3DAp54HsR3fyNdArmfnvQ0CwRlJGsKOeC+42b+iHQ0=;
        b=Vud9r0Y5Ez5deYlLUYP2wU3jpXRdKrLCdeLDyRx+u6vvEwlbY2wbYf7Rx8ZRr2v92Y
         0cKG4NobDF5DtvRZJEXTNLgTqvUuLpWCZy86yVFmhyijSku72DuB0S/eC5TGVcGt4PxZ
         DukujkSki12wJrJlc0Z9CtN6sx4cIjNQfpuP2mlUuX5K/SliobjnpfNoLrS1wigCyibA
         k0EC/Jb5URGb3S/FvNfa6rhKhY19GUXL2wCtiMFfxbQnJwxZrFT8bOhemlnXk9lI9Vqy
         vo+WDEns6xSeEaTe1zxogS1WyPpbk1s5DLB2eIr+2s+Pb2F4DEBSONQqy71f8fXFzAj1
         0Tow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V3DAp54HsR3fyNdArmfnvQ0CwRlJGsKOeC+42b+iHQ0=;
        b=C7SbNdbowcmUmLNP61kZ4mNJNZmFBggfmz4GajdESYWt82zT1S5NAU+slL1GQjwTCy
         Ic1lMUaft9gpG7f39uTt4iZz8zLDiPsWchZVngdTj+u2tsapCz8T/IapZ5C04Fc8F8qn
         3BBKgSQrGbRRgXoKUInji4ydhH+UsPyjcbRkAOkqPj3diERDMhqioBhpsSgt6hekP2Mr
         iLYNViKnrRCjAvf/PrpvbJDS63LKMculM/35NYDeLl6YgJ0aRPosrUQRqLQvp2MG0rzH
         5RJ6O2RD3ayaG6fRLI6kgTRoSGY01JXbmIZ2zTfGiYmY2EmoYzNz4W05Qo+Tj/cicjgx
         2RKQ==
X-Gm-Message-State: AOAM532attkfxEZN3CRWBL+VI3pN2QE3r05jPVjA1tJe8p+4NL9aTxK/
        /kgmj5lt63j39wheg1f3wWk=
X-Google-Smtp-Source: ABdhPJxbE8Jb05zTg96BkFazUYGB8EmfOSIeL9XG8ttE8UcTpipKKyNxSB/lkfFzn8CTzcF+qi5zpQ==
X-Received: by 2002:a05:6402:d51:b0:42a:b2cc:33b2 with SMTP id ec17-20020a0564020d5100b0042ab2cc33b2mr10782525edb.248.1653051068183;
        Fri, 20 May 2022 05:51:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 14-20020a17090602ce00b006fe89cafc42sm3049145ejk.172.2022.05.20.05.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:51:07 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <31f3de9a-a752-e322-ebd0-731c42afd47a@redhat.com>
Date:   Fri, 20 May 2022 14:51:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RESEND v3 03/11] KVM: x86/pmu: Protect
 kvm->arch.pmu_event_filter with SRCU
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220518132512.37864-1-likexu@tencent.com>
 <20220518132512.37864-4-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220518132512.37864-4-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/22 15:25, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Similar to "kvm->arch.msr_filter", KVM should guarantee that vCPUs will
> see either the previous filter or the new filter when user space calls
> KVM_SET_PMU_EVENT_FILTER ioctl with the vCPU running so that guest
> pmu events with identical settings in both the old and new filter have
> deterministic behavior.
> 
> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> Signed-off-by: Like Xu <likexu@tencent.com>
> Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

Please always include the call trace where SRCU is not taken.  The ones 
I reconstructed always end up at a place inside srcu_read_lock/unlock:

reprogram_gp_counter/reprogram_fixed_counter
   amd_pmu_set_msr
    kvm_set_msr_common
     svm_set_msr
      __kvm_set_msr
      kvm_set_msr_ignored_check
       kvm_set_msr_with_filter
        kvm_emulate_wrmsr**
        emulator_set_msr_with_filter**
       kvm_set_msr
        emulator_set_msr**
       do_set_msr
        __msr_io
         msr_io
          ioctl(KVM_SET_MSRS)**
   intel_pmu_set_msr
    kvm_set_msr_common
     vmx_set_msr (see svm_set_msr)
   reprogram_counter
    global_ctrl_changed
     intel_pmu_set_msr (see above)
    kvm_pmu_handle_event
     vcpu_enter_guest**
    kvm_pmu_incr_counter
     kvm_pmu_trigger_event
      nested_vmx_run**
      kvm_skip_emulated_instruction**
      x86_emulate_instruction**
   reprogram_fixed_counters
    intel_pmu_set_msr (see above)

Paolo

>   arch/x86/kvm/pmu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index f189512207db..24624654e476 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -246,8 +246,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   	struct kvm *kvm = pmc->vcpu->kvm;
>   	bool allow_event = true;
>   	__u64 key;
> -	int idx;
> +	int idx, srcu_idx;
>   
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
>   	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
>   	if (!filter)
>   		goto out;
> @@ -270,6 +271,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   	}
>   
>   out:
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
>   	return allow_event;
>   }
>   

