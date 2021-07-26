Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC863D652D
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhGZQ2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242184AbhGZQTh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 12:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627318803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZLSNcMxQ4xlEdY2svWL5I1k/39Nv5ohWiPhxMYTfxA=;
        b=RLxY/eCtFWpNG/O4AMsAnBni4LHz87b4jsp9rDnOSvxF6cz39zxatmSL9FP2NQeStQfq8o
        UOiUTz1ljzqeVujEtTCVJzQYPzjru0xRqLHgIE6XxAaoU5cvhoVKPelxZmSmGRxAN/FNxJ
        GJ+sticUWbKEdKHz8QodTTsIfVbmBHQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-ODSToniDP1C2b_bvf8jhTA-1; Mon, 26 Jul 2021 13:00:01 -0400
X-MC-Unique: ODSToniDP1C2b_bvf8jhTA-1
Received: by mail-ed1-f72.google.com with SMTP id i89-20020a50b0620000b02903b8906e05b4so5010623edd.19
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZLSNcMxQ4xlEdY2svWL5I1k/39Nv5ohWiPhxMYTfxA=;
        b=ueNPBo3o9hhheALZS0s+8UHHiyjN1fKHHCEz7ATW2GcmPeBYk96y+ebxn7U+ug8Vc2
         nC7Ju9UhxQMZLHZJlZP9q2N//WEayeKiNGwGBWtz295ZG8z28ULyT0bk2peFzulB2sWw
         uDH5bzjSdjuMmX5b98OmXcjjP3K0nwrsRU207D6+lPhyWvsvLmutyOKRgAPuCUER+7gB
         6Va05gTZDXvWwpxG6OJXVVT+3gCJHEDgjSqeCYEz1RASdvaDNeDApE2tXCJHmbSlLD1G
         KeU1qMpTf+eC+MSrWM+dazrCzyaJ5zJeyDN9+0TjxJveZ5WTbEYSUkCadwiyoZWRtfXc
         9a6w==
X-Gm-Message-State: AOAM530oaofE7AGta9QyxVEIoZDE0wkHv0vLVm/pzS6zii5dWZGV5grn
        pxVQT1YuPBWKh9vroL3py7G1wei3PShv/CD3iUh8P2Ly6wJqIQc6s5JGQcyIl9lCAQam4z97ElK
        ybCJaM+YB4Nsx
X-Received: by 2002:a17:906:abc9:: with SMTP id kq9mr3881573ejb.420.1627318799871;
        Mon, 26 Jul 2021 09:59:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1ptFha15jOjnukiq1LqzJS/fHkpLf03gXleyoj/QgiZm7EdUZyI6AzrrsUGnK9UFquGTmrg==
X-Received: by 2002:a17:906:abc9:: with SMTP id kq9mr3881552ejb.420.1627318799644;
        Mon, 26 Jul 2021 09:59:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id cm1sm64038edb.68.2021.07.26.09.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:59:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: restore old debugfs names
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210726150108.5603-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d73836d5-9ae8-43ca-6163-72798a01ac4e@redhat.com>
Date:   Mon, 26 Jul 2021 18:59:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726150108.5603-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/07/21 17:01, Christian Borntraeger wrote:
> commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> did replace the old definitions with the binary ones. While doing that
> it missed that some files are names different than the counters. This
> is especially important for kvm_stat which does have special handling
> for counters named instruction_*.
> 
> Fixes: commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 18 +++++++++---------
>   arch/s390/kvm/diag.c             | 18 +++++++++---------
>   arch/s390/kvm/kvm-s390.c         | 18 +++++++++---------
>   3 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3a5b5084cdbe..f1a202327ebd 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -446,15 +446,15 @@ struct kvm_vcpu_stat {
>   	u64 instruction_sigp_init_cpu_reset;
>   	u64 instruction_sigp_cpu_reset;
>   	u64 instruction_sigp_unknown;
> -	u64 diagnose_10;
> -	u64 diagnose_44;
> -	u64 diagnose_9c;
> -	u64 diagnose_9c_ignored;
> -	u64 diagnose_9c_forward;
> -	u64 diagnose_258;
> -	u64 diagnose_308;
> -	u64 diagnose_500;
> -	u64 diagnose_other;
> +	u64 instruction_diagnose_10;
> +	u64 instruction_diagnose_44;
> +	u64 instruction_diagnose_9c;
> +	u64 diag_9c_ignored;
> +	u64 diag_9c_forward;
> +	u64 instruction_diagnose_258;
> +	u64 instruction_diagnose_308;
> +	u64 instruction_diagnose_500;
> +	u64 instruction_diagnose_other;
>   	u64 pfault_sync;
>   };
>   
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 02c146f9e5cd..807fa9da1e72 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -24,7 +24,7 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
>   
>   	start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
>   	end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
> -	vcpu->stat.diagnose_10++;
> +	vcpu->stat.instruction_diagnose_10++;
>   
>   	if (start & ~PAGE_MASK || end & ~PAGE_MASK || start >= end
>   	    || start < 2 * PAGE_SIZE)
> @@ -74,7 +74,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
>   
>   	VCPU_EVENT(vcpu, 3, "diag page reference parameter block at 0x%llx",
>   		   vcpu->run->s.regs.gprs[rx]);
> -	vcpu->stat.diagnose_258++;
> +	vcpu->stat.instruction_diagnose_258++;
>   	if (vcpu->run->s.regs.gprs[rx] & 7)
>   		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>   	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
> @@ -145,7 +145,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
>   static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
>   {
>   	VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
> -	vcpu->stat.diagnose_44++;
> +	vcpu->stat.instruction_diagnose_44++;
>   	kvm_vcpu_on_spin(vcpu, true);
>   	return 0;
>   }
> @@ -169,7 +169,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>   	int tid;
>   
>   	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
> -	vcpu->stat.diagnose_9c++;
> +	vcpu->stat.instruction_diagnose_9c++;
>   
>   	/* yield to self */
>   	if (tid == vcpu->vcpu_id)
> @@ -192,7 +192,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>   		VCPU_EVENT(vcpu, 5,
>   			   "diag time slice end directed to %d: yield forwarded",
>   			   tid);
> -		vcpu->stat.diagnose_9c_forward++;
> +		vcpu->stat.diag_9c_forward++;
>   		return 0;
>   	}
>   
> @@ -203,7 +203,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>   	return 0;
>   no_yield:
>   	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
> -	vcpu->stat.diagnose_9c_ignored++;
> +	vcpu->stat.diag_9c_ignored++;
>   	return 0;
>   }
>   
> @@ -213,7 +213,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
>   	unsigned long subcode = vcpu->run->s.regs.gprs[reg] & 0xffff;
>   
>   	VCPU_EVENT(vcpu, 3, "diag ipl functions, subcode %lx", subcode);
> -	vcpu->stat.diagnose_308++;
> +	vcpu->stat.instruction_diagnose_308++;
>   	switch (subcode) {
>   	case 3:
>   		vcpu->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
> @@ -245,7 +245,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>   {
>   	int ret;
>   
> -	vcpu->stat.diagnose_500++;
> +	vcpu->stat.instruction_diagnose_500++;
>   	/* No virtio-ccw notification? Get out quickly. */
>   	if (!vcpu->kvm->arch.css_support ||
>   	    (vcpu->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
> @@ -299,7 +299,7 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>   	case 0x500:
>   		return __diag_virtio_hypercall(vcpu);
>   	default:
> -		vcpu->stat.diagnose_other++;
> +		vcpu->stat.instruction_diagnose_other++;
>   		return -EOPNOTSUPP;
>   	}
>   }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7675b72a3ddf..01925ef78518 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -163,15 +163,15 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	STATS_DESC_COUNTER(VCPU, instruction_sigp_init_cpu_reset),
>   	STATS_DESC_COUNTER(VCPU, instruction_sigp_cpu_reset),
>   	STATS_DESC_COUNTER(VCPU, instruction_sigp_unknown),
> -	STATS_DESC_COUNTER(VCPU, diagnose_10),
> -	STATS_DESC_COUNTER(VCPU, diagnose_44),
> -	STATS_DESC_COUNTER(VCPU, diagnose_9c),
> -	STATS_DESC_COUNTER(VCPU, diagnose_9c_ignored),
> -	STATS_DESC_COUNTER(VCPU, diagnose_9c_forward),
> -	STATS_DESC_COUNTER(VCPU, diagnose_258),
> -	STATS_DESC_COUNTER(VCPU, diagnose_308),
> -	STATS_DESC_COUNTER(VCPU, diagnose_500),
> -	STATS_DESC_COUNTER(VCPU, diagnose_other),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_10),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_44),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_9c),
> +	STATS_DESC_COUNTER(VCPU, diag_9c_ignored),
> +	STATS_DESC_COUNTER(VCPU, diag_9c_forward),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_258),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_308),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_500),
> +	STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
>   	STATS_DESC_COUNTER(VCPU, pfault_sync)
>   };
>   static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
> 

Queued, thanks.

Paolo

