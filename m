Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36664450E1
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 10:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhKDJJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 05:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230335AbhKDJJh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 05:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636016819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J72mhiqGRFYRvygHvcw0ArqPSiFW1B/A7lz2bTwCWPc=;
        b=FKFqnK7CjjY4L9U+049Fm3faeQ18+s78YQI/ECzHPgSNJPAE96GE/QEJH/10Nb37cDCK/e
        mBdHG4rFzehVMfNiYLfD6p0rQz5yw+T1Y8KFx+JKU1JFC20vfcKCHtzp06ekkZT3FMA6G1
        TFahYRs5s8sb4JKSxSHhBSDnPRTHjvM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-J1ogxmFbM4-CRoQxE3NHdA-1; Thu, 04 Nov 2021 05:06:58 -0400
X-MC-Unique: J1ogxmFbM4-CRoQxE3NHdA-1
Received: by mail-wm1-f69.google.com with SMTP id k6-20020a7bc306000000b0030d92a6bdc7so2421214wmj.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 02:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=J72mhiqGRFYRvygHvcw0ArqPSiFW1B/A7lz2bTwCWPc=;
        b=Y9LJhTVKY8XzWpwBTbCyCdV4EdfzTRVggCoS80QiBisW4nSTXA5vECxNCjI4pBiTN7
         85JTBhBrD6lExbZSvYKkrYDNcXKkErxLdvJl+IvhMiWlzkyQ3/JhSGNQoFm+0/2/C7FH
         RmCjRwmBZOluDcbomKa4BM6NdnNzDPd+AodXwqMWme5cPMXjPTsftYNYyid9ERmmkISh
         LkFn6EuGIo3EhXOCDCOG2J6ni5SDPQ3TNYFQ4tI0Eu5kVo2qvhTu4rGCKBOVugcnNmBK
         itYL9m9Wnt7GTjsK9a9oeh89pw+DlBmG9G7Br7ymXhO+Z839CXZDwd54T2+5EeO7g6mI
         EKUw==
X-Gm-Message-State: AOAM532JmmQQJ0/GKK8+zlsmuaGPZEvMu8DSpYMDmFMFJEfUsKHNU0dd
        V1zQiMVIEyCBLCqyCUAww+0u46PmcvHGff0o/qeZmNXfTTP7MPbzDf4YuA0oAERxOsuJUFWtS/P
        rJGnSaCmcltLa
X-Received: by 2002:a7b:c1cb:: with SMTP id a11mr22646547wmj.30.1636016816972;
        Thu, 04 Nov 2021 02:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQ0lgfUYPAkjQEu60+Z8xXY1dE1yv97Q2JMx7qvT+BLZRqsn2kN4RDPs4+NZNyizZLvDEiBw==
X-Received: by 2002:a7b:c1cb:: with SMTP id a11mr22646517wmj.30.1636016816694;
        Thu, 04 Nov 2021 02:06:56 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23c9c.dip0.t-ipconnect.de. [79.242.60.156])
        by smtp.gmail.com with ESMTPSA id t11sm4359988wrz.97.2021.11.04.02.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 02:06:55 -0700 (PDT)
Message-ID: <7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com>
Date:   Thu, 4 Nov 2021 10:06:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211102194652.2685098-1-farman@linux.ibm.com>
 <20211102194652.2685098-3-farman@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v2 2/2] KVM: s390: Extend the USER_SIGP capability
In-Reply-To: <20211102194652.2685098-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.11.21 20:46, Eric Farman wrote:
> With commit 2444b352c3ac ("KVM: s390: forward most SIGP orders to user
> space") we have a capability that allows the "fast" SIGP orders (as
> defined by the Programming Notes for the SIGNAL PROCESSOR instruction in
> the Principles of Operation) to be handled in-kernel, while all others are
> sent to userspace for processing.
> 
> This works fine but it creates a situation when, for example, a SIGP SENSE
> might return CC1 (STATUS STORED, and status bits indicating the vcpu is
> stopped), when in actuality userspace is still processing a SIGP STOP AND
> STORE STATUS order, and the vcpu is not yet actually stopped. Thus, the
> SIGP SENSE should actually be returning CC2 (busy) instead of CC1.
> 
> To fix this, add another CPU capability, dependent on the USER_SIGP one,
> that will mark a vcpu as "busy" processing a SIGP order, and a
> corresponding IOCTL that userspace can call to indicate it has finished
> its work and the SIGP operation is completed.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/kvm-s390.c         | 18 ++++++++++++++
>  arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>  arch/s390/kvm/sigp.c             | 40 ++++++++++++++++++++++++++++++++
>  4 files changed, 70 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..bd202bb3acb5 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -746,6 +746,7 @@ struct kvm_vcpu_arch {
>  	__u64 cputm_start;
>  	bool gs_enabled;
>  	bool skey_enabled;
> +	atomic_t sigp_busy;
>  	struct kvm_s390_pv_vcpu pv;
>  	union diag318_info diag318_info;
>  };
> @@ -941,6 +942,7 @@ struct kvm_arch{
>  	int user_sigp;
>  	int user_stsi;
>  	int user_instr0;
> +	int user_sigp_busy;
>  	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
>  	wait_queue_head_t ipte_wq;
>  	int ipte_lock_count;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5f52e7eec02f..ff23a46288cc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_VCPU_RESETS:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_USER_SIGP_BUSY:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -706,6 +707,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  		kvm->arch.user_sigp = 1;
>  		r = 0;
>  		break;
> +	case KVM_CAP_S390_USER_SIGP_BUSY:
> +		r = -EINVAL;
> +		if (kvm->arch.user_sigp) {
> +			kvm->arch.user_sigp_busy = 1;
> +			r = 0;
> +		}
> +		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_USER_SIGP_BUSY %s",
> +			 r ? "(not available)" : "(success)");
> +		break;
>  	case KVM_CAP_S390_VECTOR_REGISTERS:
>  		mutex_lock(&kvm->lock);
>  		if (kvm->created_vcpus) {
> @@ -4825,6 +4835,14 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  			return -EINVAL;
>  		return kvm_s390_inject_vcpu(vcpu, &s390irq);
>  	}
> +	case KVM_S390_VCPU_RESET_SIGP_BUSY: {
> +		if (!vcpu->kvm->arch.user_sigp_busy)
> +			return -EFAULT;
> +
> +		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x reset busy", vcpu->vcpu_id);
> +		kvm_s390_vcpu_clear_sigp_busy(vcpu);
> +		return 0;
> +	}
>  	}
>  	return -ENOIOCTLCMD;
>  }
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c07a050d757d..9ce97832224b 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -82,6 +82,16 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
>  	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
>  }
>  
> +static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu *vcpu)
> +{
> +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) == 0);
> +}
> +
> +static inline void kvm_s390_vcpu_clear_sigp_busy(struct kvm_vcpu *vcpu)
> +{
> +	atomic_set(&vcpu->arch.sigp_busy, 0);
> +}
> +
>  static inline int kvm_is_ucontrol(struct kvm *kvm)
>  {
>  #ifdef CONFIG_KVM_S390_UCONTROL
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 5ad3fb4619f1..034ea72e098a 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -341,9 +341,42 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
>  			   "sigp order %u -> cpu %x: handled in user space",
>  			   order_code, dst_vcpu->vcpu_id);
>  
> +	kvm_s390_vcpu_clear_sigp_busy(dst_vcpu);
> +
>  	return rc;
>  }
>  
> +static int handle_sigp_order_busy(struct kvm_vcpu *vcpu, u8 order_code,
> +				  u16 cpu_addr)
> +{
> +	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
> +
> +	if (!vcpu->kvm->arch.user_sigp_busy)
> +		return 0;
> +
> +	/*
> +	 * Just see if the target vcpu exists; the CC3 will be set wherever
> +	 * the SIGP order is processed directly.
> +	 */
> +	if (!dst_vcpu)
> +		return 0;
> +
> +	/* Reset orders will be accepted, regardless if target vcpu is busy */
> +	if (order_code == SIGP_INITIAL_CPU_RESET ||
> +	    order_code == SIGP_CPU_RESET)
> +		return 0;
> +
> +	/* Orders that affect multiple vcpus should not flag one vcpu busy */
> +	if (order_code == SIGP_SET_ARCHITECTURE)
> +		return 0;
> +
> +	/* If this fails, the vcpu is already busy processing another SIGP */
> +	if (!kvm_s390_vcpu_set_sigp_busy(dst_vcpu))
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
>  static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
>  					   u16 cpu_addr)
>  {
> @@ -408,6 +441,13 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>  
>  	order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
> +
> +	rc = handle_sigp_order_busy(vcpu, order_code, cpu_addr);
> +	if (rc) {
> +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> +		return 0;
> +	}
> +
>  	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>  		return -EOPNOTSUPP;


After looking at the QEMU side, I wonder if we should instead:

a) Let user space always set/reset SIGP busy. Don't set/reset it in the
   kernel automatically. All "heavy weight" SIGP orders are carried out
   in user space nowadays either way.
b) Reject all in-kernel SIGP orders targeting a CPU if marked BUSY by
   user space. (i.e., SIGP SENSE)
c) Don't reject SIGP orders that will be handled in QEMU from the
   kernel. Just let user space deal with it -- especially with the
   "problematic" ones like RESET and SET_ARCHITECTURE.

For example, we don't care about concurrent SIGP SENSE. We only care
about "lightweight" SIGP orders with concurrent "heavy weight" SIGP orders.

This should simplify this code and avoid having to clear the the BUSY
flag in QEMU (that might be bogus) when detecting another BUSY situation
(the trylock thingy, see my QEMU reply). The downside is that we have to
issue yet another IOCTL to set the CPU busy for SIGP -- not sure if we
really care.

-- 
Thanks,

David / dhildenb

