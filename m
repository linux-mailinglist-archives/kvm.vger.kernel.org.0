Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B5E42879D
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhJKH3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:29:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhJKH3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633937270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvOdY5dv0NaqIHwDhuSUbGefm0JpiW+on/ZN6/uLP7s=;
        b=COxfvipv99Yj4/Elui8ZcWA1BY/eYHq3T3aFXyiZIdpj7PVeVLNmwTA86ys5uIjfxlXIwI
        vPSK9Z0+jSPf1y3aBhAI7jgRZ5/9/RsXhsnCN9hameU/UjlFyjbQuIuRcwNZBqkmQa6xFA
        bL/E5msUnyPV6kq+Nn6K3FXEO2PMXY8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-tiAKHfK5OkmR8ubT6iQ3Bg-1; Mon, 11 Oct 2021 03:27:48 -0400
X-MC-Unique: tiAKHfK5OkmR8ubT6iQ3Bg-1
Received: by mail-wr1-f72.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso12488074wrb.20
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 00:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvOdY5dv0NaqIHwDhuSUbGefm0JpiW+on/ZN6/uLP7s=;
        b=XSB4Se2z2HK1xYk6PMtnxwYaVkN5dTRXjvpWYnyCzC71OFDtU718x+A5ev85EiTCXU
         DkmIfxE1L87HbV+Pqq2zIO7gEiZUYVHxI2AOmTLP2kxILz4BQxyuGZDaX8o4tVj2Xeu9
         iGyInO0qSThN4KZ5BlY4FzuL60IUHgub/nzDufHE6K1VzoioVea3pBpX3DpxUx07ZqmY
         LIbue+rfzsmpfzRLpJAykCP0v4eObIc9M535uAtfFUvBWFvJmumYCNq5ZtY/NQbVIVyp
         +sDZfU4uYQ4LTp+VkB8s8U6BQeAc14EINGmpjE9ZK2JpVBJO3tazTO8ACE82tx80YiGW
         kzKA==
X-Gm-Message-State: AOAM530L98Rd4sAfL9sbo2QMcpqTq66Fne91IJwh9n/nwZawFZJDLfAK
        zQ41cHITTtREqU7jxSw8Fjz1hAMMaIZEaBdlk3k7nbSkyO9BlxmpkB0M0c3CflJb1R5AQPW/n69
        cLSs8XwGd+nPX
X-Received: by 2002:a5d:6daa:: with SMTP id u10mr22533872wrs.150.1633937267819;
        Mon, 11 Oct 2021 00:27:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG4WUVRgigXaAq8N8+1EWpb3MXuN4yr4c6+5smaKkRzRvpUc2xDP4dz6mVv3XhWZeCDCYFIw==
X-Received: by 2002:a5d:6daa:: with SMTP id u10mr22533845wrs.150.1633937267592;
        Mon, 11 Oct 2021 00:27:47 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id b10sm2377717wrf.68.2021.10.11.00.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 00:27:47 -0700 (PDT)
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-3-farman@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC PATCH v1 2/6] KVM: s390: Reject SIGP when destination CPU is
 busy
Message-ID: <4c6c0b14-e148-9000-c581-db14d2ea555e@redhat.com>
Date:   Mon, 11 Oct 2021 09:27:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/2021 22.31, Eric Farman wrote:
> With KVM_CAP_USER_SIGP enabled, most orders are handled by userspace.
> However, some orders (such as STOP or STOP AND STORE STATUS) end up
> injecting work back into the kernel. Userspace itself should (and QEMU
> does) look for this conflict, and reject additional (non-reset) orders
> until this work completes.
> 
> But there's no need to delay that. If the kernel knows about the STOP
> IRQ that is in process, the newly-requested SIGP order can be rejected
> with a BUSY condition right up front.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/kvm/sigp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index cf4de80bd541..6ca01bbc72cf 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -394,6 +394,45 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
>   	return 1;
>   }
>   
> +static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
> +					u16 cpu_addr)
> +{
> +	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
> +	int rc = 0;
> +
> +	/*
> +	 * SIGP orders directed at invalid vcpus are not blocking,
> +	 * and should not return busy here. The code that handles
> +	 * the actual SIGP order will generate the "not operational"
> +	 * response for such a vcpu.
> +	 */
> +	if (!dst_vcpu)
> +		return 0;
> +
> +	/*
> +	 * SIGP orders that process a flavor of reset would not be
> +	 * blocked through another SIGP on the destination CPU.
> +	 */
> +	if (order_code == SIGP_CPU_RESET ||
> +	    order_code == SIGP_INITIAL_CPU_RESET)
> +		return 0;
> +
> +	/*
> +	 * Any other SIGP order could race with an existing SIGP order
> +	 * on the destination CPU, and thus encounter a busy condition
> +	 * on the CPU processing the SIGP order. Reject the order at
> +	 * this point, rather than racing with the STOP IRQ injection.
> +	 */
> +	spin_lock(&dst_vcpu->arch.local_int.lock);
> +	if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
> +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> +		rc = 1;
> +	}
> +	spin_unlock(&dst_vcpu->arch.local_int.lock);
> +
> +	return rc;
> +}
> +
>   int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>   {
>   	int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
> @@ -408,6 +447,10 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>   		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>   
>   	order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
> +
> +	if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
> +		return 0;
> +
>   	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>   		return -EOPNOTSUPP;

We've been bitten quite a bit of times in the past already by doing too much 
control logic in the kernel instead of doing it in QEMU, where we should 
have a more complete view of the state ... so I'm feeling quite a bit uneasy 
of adding this in front of the "return -EOPNOTSUPP" here ... Did you see any 
performance issues that would justify this change?

  Thomas

