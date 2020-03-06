Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39117C30F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCFQgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:36:05 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45654 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCFQgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:36:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id v2so3080426wrp.12;
        Fri, 06 Mar 2020 08:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zJLtaUhpy8iKL7hNpXLQ4iAg1XiWGsEUwHdtM8xVwjU=;
        b=gv9J7c8A/St5GnwUMwSrO6BduAF66YyYUQhSNMHfcB71fzmHBy2MhT3P4sUZJo3CPQ
         6kRffKT6F2qSUK6M8s7+YBbrWpMg2+h+rNfIjS2P20GEUlv8yJAqhxKOBOWDbPaxb3y2
         151tiV7Fn0uQC/FMnwqsI7NHw8PrCj7Mnw/94hSENnNo9ls6TkIoHlYnYDUueXKnin+/
         IsyeTrPwwXw7adUinu+4rwPjsAwLNp6S8YOizzBFg6JLC666cRtQXgpzM55ePN5ySFSw
         UBiB1M4sxOSiy4PiiDlUIieveXfzIxc8qpv5a9G528LmVgaTeSmHD5xA8Eyd7PC+LdTW
         2jRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zJLtaUhpy8iKL7hNpXLQ4iAg1XiWGsEUwHdtM8xVwjU=;
        b=OUoQh25W2tw9O9zmJ60QPrJQBdiuxo2wtCI4XbtdJaeyWfjqiGq6PJGZXyrSH2nuEd
         7Jz+lPtdHgjgyA5Aldqy+S4zuVcGhjGpiNND0lgtjM/TFkIh9/UEIYO59maYMkd7o+0a
         PcVyGSwmiX2xE2Of8ak49ql2Mop+y8/sIB1UMvdgF2URE+fS/7HdDlK2xuWi4/kPd6rr
         2f/LRZn9OHVQZCPHJ+MuzIHBs1qMqTYMtpr6/NAoQ1qjDFamyk6M5Z83SJLRMjMMRint
         4PGFbggThUOmuyxqWx9VTiclLm/AlgflvmdLPYYPuLfrl+ymO2qlc/+7VgVIU0vIHp2q
         ZYsg==
X-Gm-Message-State: ANhLgQ2giqf3P6DFA6JO+mySbqRMmWwT73X80gCqEJNAkItk6D1b7VAb
        K0wkIMPAApUFUitAWEMnAPlmgi8h
X-Google-Smtp-Source: ADFU+vvPU96yHv58UxqrlLN3lsarEdmjJM4v2v055HBl7ISbXeqVmK/TpPJnWevzqbdBjBRIpXXrYg==
X-Received: by 2002:adf:a4d2:: with SMTP id h18mr2463222wrb.90.1583512563245;
        Fri, 06 Mar 2020 08:36:03 -0800 (PST)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id f23sm14323454wmb.1.2020.03.06.08.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:36:02 -0800 (PST)
Date:   Fri, 6 Mar 2020 18:36:01 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 4/4] x86/kvm/hyper-v: Add support for synthetic
 debugger via hypercalls
Message-ID: <20200306163601.GB3559120@jondnuc>
References: <20200305140142.413220-1-arilou@gmail.com>
 <20200305140142.413220-5-arilou@gmail.com>
 <871rq5ebnx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <871rq5ebnx.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/2020, Vitaly Kuznetsov wrote:
>Jon Doron <arilou@gmail.com> writes:
>
>> There is another mode for the synthetic debugger which uses hypercalls
>> to send/recv network data instead of the MSR interface.
>>
>> This interface is much slower and less recommended since you might get
>> a lot of VMExits while KDVM polling for new packets to recv, rather
>> than simply checking the pending page to see if there is data avialble
>> and then request.
>>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h |  5 +++++
>>  arch/x86/kvm/hyperv.c              | 17 +++++++++++++++++
>>  2 files changed, 22 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index 8efdf974c23f..4fa6bf3732a6 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -283,6 +283,8 @@
>>  #define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
>>  #define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
>>
>> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
>
>Nitpick: please add a comment like
>"These are HV_X64_MSR_SYNDBG_OPTIONS bits"
>just before the definition to make it to bluntly obvious.
>

Done.

>> +
>>  /* Hyper-V guest crash notification MSR's */
>>  #define HV_X64_MSR_CRASH_P0			0x40000100
>>  #define HV_X64_MSR_CRASH_P1			0x40000101
>> @@ -392,6 +394,9 @@ struct hv_tsc_emulation_status {
>>  #define HVCALL_SEND_IPI_EX			0x0015
>>  #define HVCALL_POST_MESSAGE			0x005c
>>  #define HVCALL_SIGNAL_EVENT			0x005d
>> +#define HVCALL_POST_DEBUG_DATA			0x0069
>> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
>> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index d657a312004a..52517e11e643 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1800,6 +1800,23 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>  		}
>>  		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>>  		break;
>> +	case HVCALL_POST_DEBUG_DATA:
>> +	case HVCALL_RETRIEVE_DEBUG_DATA:
>> +	case HVCALL_RESET_DEBUG_SESSION: {
>> +		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
>> +		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
>> +			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>
>In TLFS it is said that only HvResetDebugSession of these three can be
>'fast', others are regular hypercalls. We need to add something like
>
>     if (unlikely(fast && code != HVCALL_RESET_DEBUG_SESSION)) {
>            ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>            break;
>     }
>
>also, I'm not sure HV_STATUS_INVALID_HYPERCALL_INPUT is always the right
>return value as TLFS describes this as
>
>"The rep count was incorrect (for example, a non-zero rep count was
>passed to a non-rep call or a zero rep count was passed to a rep call) or
>a reserved bit in the specified hypercall input value was non-zero."
>
>(we may actually be wrong even for existing hypercalls)
>

You are right I believe in the next version I'm using a more proper 
return code.

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
>>  	default:
>>  		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>>  		break;
>
>-- 
>Vitaly
>
