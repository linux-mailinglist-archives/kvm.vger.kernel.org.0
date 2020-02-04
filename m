Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AFB151A61
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBDMNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:13:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727115AbgBDMNV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 07:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580818399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=iEs8HZyVk6Rxn786ymoYxwv7M4tnPGVhtBP3285xSf0=;
        b=eUvd0qvDQFKl9EMPTUUR5Fs95ZEY95tHCjTBWvnjZdQrLjIRvLjDtFrfEXqmuAQARmiy3t
        HanC+PrQvfbAjEujh1BFr/mXAgNjYss0/QfyUYWy8DRcCnM/ET31aY/nbu0Qu9/YG0HBqq
        zLkXf2j8sbpPJla4jdH3iibzPRF/wE0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-nG35jAehMde76pnffmIkjw-1; Tue, 04 Feb 2020 07:13:11 -0500
X-MC-Unique: nG35jAehMde76pnffmIkjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 412CC1882CD8;
        Tue,  4 Feb 2020 12:13:10 +0000 (UTC)
Received: from [10.36.117.121] (ovpn-117-121.ams2.redhat.com [10.36.117.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89B8760BE0;
        Tue,  4 Feb 2020 12:13:08 +0000 (UTC)
Subject: Re: [RFCv2 08/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-9-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8fdcbfc6-3e58-8970-416f-4039bb151394@redhat.com>
Date:   Tue, 4 Feb 2020 13:13:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-9-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r =3D 0;
> +	void __user *argp =3D (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VM_CREATE: {
> +		r =3D -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r =3D kvm_s390_pv_alloc_vm(kvm);
> +		if (r)
> +			break;
> +
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		/* FMT 4 SIE needs esca */
> +		r =3D sca_switch_to_extended(kvm);
> +		if (!r)
> +			r =3D kvm_s390_pv_create_vm(kvm);
> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}

I think KVM_PV_VM_ENABLE/KVM_PV_VM_DISABLE would be a better fit. You're
not creating/deleting VMs, aren't you? All you're doing is allocating
some data and performing some kind of a mode switch.
[...]

>  	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vc=
pu,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> @@ -4353,6 +4502,37 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp=
,
>  	return -ENOIOCTLCMD;
>  }
> =20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
> +				   struct kvm_pv_cmd *cmd)
> +{
> +	int r =3D 0;
> +
> +	if (!kvm_s390_pv_is_protected(vcpu->kvm))
> +		return -EINVAL;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VCPU_CREATE: {
> +		if (kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r =3D kvm_s390_pv_create_cpu(vcpu);
> +		break;
> +	}
> +	case KVM_PV_VCPU_DESTROY: {
> +		if (!kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r =3D kvm_s390_pv_destroy_cpu(vcpu);
> +		break;
> +	}
> +	default:
> +		r =3D -ENOTTY;
> +	}
> +	return r;
> +}

I asked this already and didn't get an answer (lost in the flood of
comments :) )

Can't we simply convert all VCPUs via KVM_PV_VM_CREATE and destoy them
via KVM_PV_VM_DESTROY? Then you can easily handle hotplug as well in the
kernel when a new VCPU is created and PV is active - oh and I see you
are already doing that in kvm_arch_vcpu_create(). So that screams for
doing either this a) completely triggered by user space or b) completely
in the kernel. I prefer the latter. One interface less required.

I would assume that no VCPU is allowed to be running inside KVM while
performing the PV switch, which would make this even easier.

--=20
Thanks,

David / dhildenb

