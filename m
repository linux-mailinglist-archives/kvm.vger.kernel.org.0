Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C1F40DC46
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbhIPOFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 10:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235546AbhIPOFJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 10:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631801028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InkSSQy+zkt1/Sq2nJaTJOAqUI+Qk6BMdAVU8hoiD9c=;
        b=JzpCOuhTM7msh1MensiJ3xLj8cQEmy9n7jp5Ef7WdTgfDLqLmKqE7AkjJYGM+a/FKXvXwR
        roBEK/b0whzny3FJLJ9OUfPGS6iqUePYo+5nKoTXCumAz/jCRYxKJkF4bgx/P1vR3pMYmu
        jgqACkIpn9iGeClf44L4cQZ3PZMddT4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-NkTi5dK-N1GA-7ZGArVI9Q-1; Thu, 16 Sep 2021 10:03:46 -0400
X-MC-Unique: NkTi5dK-N1GA-7ZGArVI9Q-1
Received: by mail-wr1-f72.google.com with SMTP id z1-20020adfec81000000b0015b085dbde3so2472476wrn.14
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 07:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=InkSSQy+zkt1/Sq2nJaTJOAqUI+Qk6BMdAVU8hoiD9c=;
        b=lxw266D9uXXCFXQqYTosAMk2OLrZiz8qMNMT39rReguKfqIlZt2olX4UFPbB5iG6CC
         GJm/cys6eu7EzA4kQFa8brthTCgMQKp5zJeAyt+ufOwFYyjp3Gvgr3zVwtEaFjG2PSbm
         uF9z5gTDTpNHr6FVOlvADgDjqa+D8cBb828a+5P1DHWLuYV7BUQvro9yWg1dRbjjgb2b
         QqhZJBrUDObGHs21BJEEMfTNXNEwCcqZZ/QWHYg0tlH8EZifraJWfTQU9KItj4z+09vm
         tW131jbbb/wOlc0fSA4lk8Jj1m2Lky0mYv937P0eomzVhWpdLK67XfcUeG3tMovne0OD
         im7w==
X-Gm-Message-State: AOAM532GrFJwJrrzmK9JCVN2OrnzMDXdJvxgo61XQuU0SNKaRhHCX5hv
        cAkTR0Hvizv2Wu52NhNJwStMfAUViUNJQ0Rcfu4YpKE02PTF7VhqYsLymxlEGmKszbjhCFKkBDb
        CPMScJZe4WjEl
X-Received: by 2002:adf:e74b:: with SMTP id c11mr6371110wrn.101.1631801025691;
        Thu, 16 Sep 2021 07:03:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/lhk0vbwJSHMlHYygHpizbHLXpjbz403gb1bSwePYyjBwbWX/UNKyVaKVGPdD3tXAKLjHow==
X-Received: by 2002:adf:e74b:: with SMTP id c11mr6371074wrn.101.1631801025407;
        Thu, 16 Sep 2021 07:03:45 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23828.dip0.t-ipconnect.de. [79.242.56.40])
        by smtp.gmail.com with ESMTPSA id s15sm3612858wrb.22.2021.09.16.07.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 07:03:44 -0700 (PDT)
Subject: Re: [PATCH v4 1/1] s390x: KVM: accept STSI for CPU topology
 information
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1631799845-24860-1-git-send-email-pmorel@linux.ibm.com>
 <1631799845-24860-2-git-send-email-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <eef5ed95-3f54-b709-894d-cdf75bc3180b@redhat.com>
Date:   Thu, 16 Sep 2021 16:03:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1631799845-24860-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>   struct kvm_vm_stat {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 51d1594bd6cd..f3887e13c5db 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -608,6 +608,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_PROTECTED:
>   		r = is_prot_virt_host();
>   		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		r = test_facility(11);
> +		break;
>   	default:
>   		r = 0;
>   	}
> @@ -819,6 +822,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		icpt_operexc_on_all_vcpus(kvm);
>   		r = 0;
>   		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:

As given in my example, this should be

r = -EINVAL;
mutex_lock(&kvm->lock);
if (kvm->created_vcpus) {
	r = -EBUSY;
} else if (test_facility(11)) {
...
}

Similar to how we handle KVM_CAP_S390_VECTOR_REGISTERS.

[...]

> +
> +	/* PTF needs both host and guest facilities to enable interpretation */
> +	if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
> +		vcpu->arch.sie_block->ecb |= ECB_PTF;

This should be simplified to

if (test_kvm_facility(vcpu->kvm, 11))

then. (vsie code below is correct)


-- 
Thanks,

David / dhildenb

