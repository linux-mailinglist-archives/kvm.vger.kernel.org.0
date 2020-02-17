Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350731610A8
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgBQLIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 06:08:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbgBQLIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 06:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581937718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=hEs7TjrznZyPgDTkgLBuJ+NxjJuDkDAHWOwyHgi6GDw=;
        b=DHYbLJMzpH0fPYmW7eAk1JOEdATHLqbBO2MUhcofKZzjjLUStx905WdiMCH6/oLrYInIEO
        Y6kKDvrIU9zBxhYPFe9Draa8aN+wszszOTl2LKxzmKBuZiPS9Ch2XHF/RBFTHZFgERgWAd
        GRfMAMVt5x/OiF7tptNpbZfsmtoPJD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-GNUUTqNMM8eyW8upToavRg-1; Mon, 17 Feb 2020 06:08:33 -0500
X-MC-Unique: GNUUTqNMM8eyW8upToavRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCD038017DF;
        Mon, 17 Feb 2020 11:08:31 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF0E910016DA;
        Mon, 17 Feb 2020 11:08:25 +0000 (UTC)
Subject: Re: [PATCH v2 20/42] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-21-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <ad84934a-3d18-d56e-5658-1d8b8292f6b3@redhat.com>
Date:   Mon, 17 Feb 2020 12:08:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-21-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -4460,6 +4489,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  
>  	switch (mop->op) {
>  	case KVM_S390_MEMOP_LOGICAL_READ:
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			r = -EINVAL;
> +			break;
> +		}

Could we have a possible race with disabling code, especially while
concurrently freeing? (sorry if I ask again, there was just a flood of
emails)

>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
>  					    mop->size, GACC_FETCH);
> @@ -4472,6 +4505,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  		}
>  		break;
>  	case KVM_S390_MEMOP_LOGICAL_WRITE:
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			r = -EINVAL;
> +			break;
> +		}

dito

>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
>  					    mop->size, GACC_STORE);
> @@ -4483,6 +4520,11 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  		}
>  		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>  		break;
> +	case KVM_S390_MEMOP_SIDA_READ:
> +	case KVM_S390_MEMOP_SIDA_WRITE:
> +		/* we are locked against sida going away by the vcpu->mutex */
> +		r = kvm_s390_guest_sida_op(vcpu, mop);
> +		break;
>  	default:
>  		r = -EINVAL;
>  	}
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 09573e36c329..80169a9b43ec 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -92,6 +92,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>  
>  	free_pages(vcpu->arch.pv.stor_base,
>  		   get_order(uv_info.guest_cpu_stor_len));
> +	free_page(sida_origin(vcpu->arch.sie_block));
>  	vcpu->arch.sie_block->pv_handle_cpu = 0;
>  	vcpu->arch.sie_block->pv_handle_config = 0;
>  	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
> @@ -121,6 +122,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>  	uvcb.state_origin = (u64)vcpu->arch.sie_block;
>  	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
>  
> +	/* Alloc Secure Instruction Data Area Designation */
> +	vcpu->arch.sie_block->sidad = __get_free_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!vcpu->arch.sie_block->sidad) {
> +		free_pages(vcpu->arch.pv.stor_base,
> +			   get_order(uv_info.guest_cpu_stor_len));
> +		return -ENOMEM;
> +	}
> +
>  	cc = uv_call(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 207915488502..0fdee1bc3798 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -475,11 +475,15 @@ struct kvm_s390_mem_op {
>  	__u32 op;		/* type of operation */
>  	__u64 buf;		/* buffer in userspace */
>  	__u8 ar;		/* the access register number */
> -	__u8 reserved[31];	/* should be set to 0 */
> +	__u8 reserved21[3];	/* should be set to 0 */
> +	__u32 sida_offset;	/* offset into the sida */
> +	__u8 reserved28[24];	/* should be set to 0 */
>  };

As discussed, I'd prefer an overlaying layout for the sida, as the ar
does not make any sense (correct me if I'm wrong :) )

__u32 op;		/* type of operation */
__u64 buf;		/* buffer in userspace */
uinon {
	__u8 ar;		/* the access register number */
	__u32 sida_offset;	/* offset into the sida */
	__u8 reserved[32];	/* should be set to 0 */
};

With something like that

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

