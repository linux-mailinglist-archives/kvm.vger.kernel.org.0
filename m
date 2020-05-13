Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A901D12E7
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 14:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgEMMja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 08:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgEMMj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 08:39:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E3BC061A0C;
        Wed, 13 May 2020 05:39:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so28305496wmh.3;
        Wed, 13 May 2020 05:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YAMZzYHc3BSk60ZKYMuYkolep9zJ19WbVFd5/fzkGEw=;
        b=aSzmnjkt1nm4KVfoFZngKWLTaJohY2jch1RA49NsrBpP1BwpDWVbD5AxELhA8WqDtn
         +1xoBJzIoJyWGmLf3QREao+xAe5bBjibNkoRM+rAgl6jHAD6qR4AlZwxANDR8vy/7asO
         QXQ6+zQ5c4AQ1JWd3TRihXc6+5M9G/K6GCbO0PVowdDOgeC+5gps8hlLp8U2Kocg6ffl
         7kGk0buPEVVG9hHvO3H99p/UtDWfC38IGncNKCaXn/HKV81spp3alP3zSsccmYLBljfB
         ZjdDhce1gchcWhAVlgKh9eaUarx3Rhbdrk8m4DbU11/+wo4u/mZ29qiJgnZuWI48sWz6
         0b7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YAMZzYHc3BSk60ZKYMuYkolep9zJ19WbVFd5/fzkGEw=;
        b=Gra76264y0YUNN8UTSwpuv/Wu7Kl8zvYH76MvenLxgWjwX+Hp+tbjXrQ/F+qJIYX5w
         MnE2di8ROZ1G9MEkcs9ThtkFe24OO/tUpOdRYHPCBXcg4pCF1SxNEBk2J/pkDclMle/S
         2it3MBrm9+3zGPnYJxXRPfM+PKGDuPtt6nQ57wjrfh9WzHChRNRHC+YZWR2ALg6waJFr
         hH6HF2kiSlB0Oicoh9NlmoszOLPDQBYZ7Jdynz7V2h5qSwORanK5XrZJi3H1R55ovj0l
         5GsXV7W4jm+Yf+CwhyrydCFoji/m2fF678ItcLfu0LZTGX9lhpqZatUzLzgJddA0EcB6
         QV7g==
X-Gm-Message-State: AGi0Pub+7VNVyluLM+f7eTe4XtHqMT7mAWVdPNdsCqNDMQsy7l47oHkb
        44lanuxjevD3ono/YGvi4kE=
X-Google-Smtp-Source: APiQypKUSNj6yHRllppCwr6DtXaxXqekJe3s/XyxB4rcNCM8c2WTYaTwb/m2P0/HIkltXrZs3+vHZQ==
X-Received: by 2002:a7b:c253:: with SMTP id b19mr22490141wmj.110.1589373567857;
        Wed, 13 May 2020 05:39:27 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id b23sm33041658wmb.26.2020.05.13.05.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 05:39:27 -0700 (PDT)
Date:   Wed, 13 May 2020 15:39:26 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v11 6/7] x86/kvm/hyper-v: Add support for synthetic
 debugger via hypercalls
Message-ID: <20200513123926.GL2862@jondnuc>
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-7-arilou@gmail.com>
 <20200512153353.GB9944@rvkaganb.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200512153353.GB9944@rvkaganb.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/2020, Roman Kagan wrote:
>On Fri, Apr 24, 2020 at 02:37:45PM +0300, Jon Doron wrote:
>> There is another mode for the synthetic debugger which uses hypercalls
>> to send/recv network data instead of the MSR interface.
>>
>> This interface is much slower and less recommended since you might get
>> a lot of VMExits while KDVM polling for new packets to recv, rather
>> than simply checking the pending page to see if there is data avialble
>> and then request.
>>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 524b5466a515..744bcef88c70 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1832,6 +1832,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>  		}
>>  		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>>  		break;
>> +	case HVCALL_POST_DEBUG_DATA:
>> +	case HVCALL_RETRIEVE_DEBUG_DATA:
>> +		if (unlikely(fast)) {
>> +			ret = HV_STATUS_INVALID_PARAMETER;
>> +			break;
>> +		}
>> +		fallthrough;
>> +	case HVCALL_RESET_DEBUG_SESSION: {
>> +		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
>> +
>> +		if (!syndbg->active) {
>> +			ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>> +			break;
>> +		}
>> +
>> +		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
>> +			ret = HV_STATUS_OPERATION_DENIED;
>> +			break;
>> +		}
>> +		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
>> +		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
>> +		vcpu->run->hyperv.u.hcall.input = param;
>> +		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
>> +		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
>> +		vcpu->arch.complete_userspace_io =
>> +				kvm_hv_hypercall_complete_userspace;
>> +		return 0;
>> +	}
>
>I'd personally just push every hyperv hypercall not recognized by the
>kernel to userspace.  Smth like this:
>
>diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>index bcefa9d4e57e..f0404df0f488 100644
>--- a/arch/x86/kvm/hyperv.c
>+++ b/arch/x86/kvm/hyperv.c
>@@ -1644,6 +1644,48 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> 		}
> 		kvm_vcpu_on_spin(vcpu, true);
> 		break;
>+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
>+		if (unlikely(fast || !rep_cnt || rep_idx)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
>+		break;
>+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>+		if (unlikely(fast || rep)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
>+		break;
>+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>+		if (unlikely(fast || !rep_cnt || rep_idx)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
>+		break;
>+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
>+		if (unlikely(fast || rep)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
>+		break;
>+	case HVCALL_SEND_IPI:
>+		if (unlikely(rep)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
>+		break;
>+	case HVCALL_SEND_IPI_EX:
>+		if (unlikely(fast || rep)) {
>+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>+			break;
>+		}
>+		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>+		break;
> 	case HVCALL_SIGNAL_EVENT:
> 		if (unlikely(rep)) {
> 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>@@ -1653,12 +1695,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> 		if (ret != HV_STATUS_INVALID_PORT_ID)
> 			break;
> 		/* fall through - maybe userspace knows this conn_id. */
>-	case HVCALL_POST_MESSAGE:
>-		/* don't bother userspace if it has no way to handle it */
>-		if (unlikely(rep || !vcpu_to_synic(vcpu)->active)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>+	default:
>+		/* forward unrecognized hypercalls to userspace */
> 		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> 		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> 		vcpu->run->hyperv.u.hcall.input = param;
>@@ -1667,51 +1705,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> 		vcpu->arch.complete_userspace_io =
> 				kvm_hv_hypercall_complete_userspace;
> 		return 0;
>-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
>-		if (unlikely(fast || !rep_cnt || rep_idx)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
>-		break;
>-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>-		if (unlikely(fast || rep)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
>-		break;
>-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>-		if (unlikely(fast || !rep_cnt || rep_idx)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
>-		break;
>-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
>-		if (unlikely(fast || rep)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
>-		break;
>-	case HVCALL_SEND_IPI:
>-		if (unlikely(rep)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
>-		break;
>-	case HVCALL_SEND_IPI_EX:
>-		if (unlikely(fast || rep)) {
>-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>-			break;
>-		}
>-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>-		break;
>-	default:
>-		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>-		break;
> 	}
>
> 	return kvm_hv_hypercall_complete(vcpu, ret);
>
>(would also need a kvm cap for that)
>
>Roman.

This looks like a good idea, but I think it should be part of another 
patchset, I could revise one once this is in and expose a new CAP, and 
we need to make sure QEMU can handle this and wont just crash getting 
these additional exits.

-- Jon.
