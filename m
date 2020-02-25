Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0408016ECF8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgBYRqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 12:46:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727983AbgBYRqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 12:46:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582652778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=+ejOLs6ZuOGjps88cbB/YMCPyRAtJ6xGpeCTimQ2me4=;
        b=euj8m2YOZpkeU9xmwdBrvcHI6NzkWxRh9DKTo+EbKVYEfUOVDdGWwWAhHWlBKneqjix/JK
        jTXwifQQ2P2+X9Xn/s1hPlmu22rc8buD4qHL+M95dow+ALj8lTbnxrAWU/SE9DD623ogue
        fF4Y0h3X78ih7trELQifWoYywOdGZl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-7cWbNyrGNumjw_K6R8X8-A-1; Tue, 25 Feb 2020 12:46:14 -0500
X-MC-Unique: 7cWbNyrGNumjw_K6R8X8-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7003477;
        Tue, 25 Feb 2020 17:46:12 +0000 (UTC)
Received: from [10.36.117.12] (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3786F8B759;
        Tue, 25 Feb 2020 17:46:10 +0000 (UTC)
Subject: Re: [PATCH v4 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
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
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
 <20200224114107.4646-10-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
Date:   Tue, 25 Feb 2020 18:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224114107.4646-10-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.02.20 12:40, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines

side note: I really dislike such patch descriptions (lists!) and
squashing a whole bunch of things that could be nicely split up into
separat patches (with much nicer patch descriptions) into a single
patch. E.g., enable/disable would be sufficiently complicated to review.

This makes review unnecessary complicated. But here we are in v4, so
I'll try my best for (hopefully) the second last time ;)

[...]

> +static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
> +{
> +	struct kvm_vcpu *vcpu;
> +	bool failed =3D false;
> +	u16 rc, rrc;
> +	int cc =3D 0;
> +	int i;
> +
> +	/*
> +	 * we ignore failures and try to destroy as many CPUs as possible.

nit: "We"

> +	 * At the same time we must not free the assigned resources when
> +	 * this fails, as the ultravisor has still access to that memory.
> +	 * So kvm_s390_pv_destroy_cpu can leave a "wanted" memory leak
> +	 * behind.
> +	 * We want to return the first failure rc and rrc though.

nit, ", though".

> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		mutex_lock(&vcpu->mutex);
> +		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !failed) {
> +			*rcp =3D rc;
> +			*rrcp =3D rrc;
> +			cc =3D 1;
> +			failed =3D true;

no need for "failed". Just check against cc !=3D 0 instead.

> +		}
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +	return cc;

The question will repeat a couple of times in the patch: Do we want to
convert that to a proper error (e.g., EBUSY, EINVAL, EWHATSOEVER)
instead of returning "1" to user space (whoch looks weird).

> +}
> +
> +static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	int i, r =3D 0;
> +	u16 dummy;
> +
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		mutex_lock(&vcpu->mutex);
> +		r =3D kvm_s390_pv_create_cpu(vcpu, rc, rrc);
> +		mutex_unlock(&vcpu->mutex);
> +		if (r)
> +			break;
> +	}
> +	if (r)
> +		kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
> +	return r;
> +}

[...]

> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hosting Secure Execution virtual machines

Just wondering "Protected Virtualization" vs. "Secure Execution".

[...]

> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
> +{
> +	int cc =3D 0;
> +
> +	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> +		cc =3D uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> +				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +
> +		KVM_UV_EVENT(vcpu->kvm, 3,
> +			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> +			     vcpu->vcpu_id, *rc, *rrc);
> +		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> +			  *rc, *rrc);
> +	}

/* Intended memory leak for something that should never happen. */

> +	if (!cc)
> +		free_pages(vcpu->arch.pv.stor_base,
> +			   get_order(uv_info.guest_cpu_stor_len));

Should we clear arch.pv.handle?

Also, I do wonder if it makes sense to

vcpu->arch.pv.stor_base =3D NULL;

So really remove any traces and act like the error never happened. Only
skip the freeing. Makes sense? Then we're not stuck with a
half-initialized VM state.


> +	vcpu->arch.sie_block->pv_handle_cpu =3D 0;
> +	vcpu->arch.sie_block->pv_handle_config =3D 0;
> +	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
> +	vcpu->arch.sie_block->sdf =3D 0;
> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +
> +	return cc;

Convert to a proper error?

> +}
> +
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
> +{
> +	struct uv_cb_csc uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CREATE_SEC_CPU,
> +		.header.len =3D sizeof(uvcb),
> +	};
> +	int cc;
> +
> +	if (kvm_s390_pv_cpu_get_handle(vcpu))
> +		return -EINVAL;
> +
> +	vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL,
> +						   get_order(uv_info.guest_cpu_stor_len));
> +	if (!vcpu->arch.pv.stor_base)
> +		return -ENOMEM;
> +
> +	/* Input */
> +	uvcb.guest_handle =3D kvm_s390_pv_get_handle(vcpu->kvm);
> +	uvcb.num =3D vcpu->arch.sie_block->icpua;
> +	uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
> +	uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
> +
> +	cc =3D uv_call(0, (u64)&uvcb);
> +	*rc =3D uvcb.header.rc;
> +	*rrc =3D uvcb.header.rrc;
> +	KVM_UV_EVENT(vcpu->kvm, 3,
> +		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
> +		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
> +		     uvcb.header.rrc);
> +
> +	if (cc) {
> +		u16 dummy;
> +
> +		kvm_s390_pv_destroy_cpu(vcpu, &dummy, &dummy);
> +		return -EINVAL;

Ah, here we convert from cc to an actual error :)

> +	}
> +
> +	/* Output */
> +	vcpu->arch.pv.handle =3D uvcb.cpu_handle;
> +	vcpu->arch.sie_block->pv_handle_cpu =3D uvcb.cpu_handle;
> +	vcpu->arch.sie_block->pv_handle_config =3D kvm_s390_pv_get_handle(vcp=
u->kvm);
> +	vcpu->arch.sie_block->sdf =3D 2;
> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +	return 0;
> +}
> +
> +/* only free resources when the destroy was successful */

s/destroy/deinit/

> +static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
> +{
> +	vfree(kvm->arch.pv.stor_var);
> +	free_pages(kvm->arch.pv.stor_base,
> +		   get_order(uv_info.guest_base_stor_len));
> +	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
> +}
> +
> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> +{
> +	unsigned long base =3D uv_info.guest_base_stor_len;
> +	unsigned long virt =3D uv_info.guest_virt_var_stor_len;
> +	unsigned long npages =3D 0, vlen =3D 0;
> +	struct kvm_memory_slot *memslot;
> +
> +	kvm->arch.pv.stor_var =3D NULL;
> +	kvm->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL, get_order(bas=
e));
> +	if (!kvm->arch.pv.stor_base)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Calculate current guest storage for allocation of the
> +	 * variable storage, which is based on the length in MB.
> +	 *
> +	 * Slots are sorted by GFN
> +	 */
> +	mutex_lock(&kvm->slots_lock);
> +	memslot =3D kvm_memslots(kvm)->memslots;
> +	npages =3D memslot->base_gfn + memslot->npages;

I remember I asked this question already, maybe I missed the reply :(

1. What if we have multiple slots?
2. What is expected to happen if new slots are added (e.g., memory
hotplug in the future?)

Shouldn't you bail out if there is more than one slot and make sure that
no new ones can be added as long as pv is active (I remember the latter
should be very easy from an arch callback)?

> +	mutex_unlock(&kvm->slots_lock);
> +
> +	kvm->arch.pv.guest_len =3D npages * PAGE_SIZE;
> +
> +	/* Allocate variable storage */
> +	vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE)=
;
> +	vlen +=3D uv_info.guest_virt_base_stor_len;
> +	kvm->arch.pv.stor_var =3D vzalloc(vlen);
> +	if (!kvm->arch.pv.stor_var)
> +		goto out_err;
> +	return 0;
> +
> +out_err:
> +	kvm_s390_pv_dealloc_vm(kvm);
> +	return -ENOMEM;
> +}
> +
> +/* this should not fail, but if it does we must not free the donated m=
emory */
> +int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	int cc;
> +
> +	cc =3D uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> +			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);

Could convert to

int cc =3D ...

> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +	atomic_set(&kvm->mm->context.is_protected, 0);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> +	if (!cc)
> +		kvm_s390_pv_dealloc_vm(kvm);

Similar to the VCPU path, should be set all pointers to NULL but skip
the freeing? With a similar comment /* Inteded memory leak ... */

> +	return cc;

Does it make more sense to translate that to a proper error? (EBUSY,
EINVAL etc.) I'd assume we translate that to a proper error - if any.
Returning e.g., "1" does not make too much sense IMHO.

> +}
> +
> +int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	u16 drc, drrc;
> +	int cc, ret;
> +

superfluous empty line.

> +	struct uv_cb_cgc uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CREATE_SEC_CONF,
> +		.header.len =3D sizeof(uvcb)
> +	};

maybe

int ret =3D kvm_s390_pv_alloc_vm(kvm);

no strong feelings.

> +
> +	ret =3D kvm_s390_pv_alloc_vm(kvm);
> +	if (ret)
> +		return ret;
> +
> +	/* Inputs */
> +	uvcb.guest_stor_origin =3D 0; /* MSO is 0 for KVM */
> +	uvcb.guest_stor_len =3D kvm->arch.pv.guest_len;
> +	uvcb.guest_asce =3D kvm->arch.gmap->asce;
> +	uvcb.guest_sca =3D (unsigned long)kvm->arch.sca;
> +	uvcb.conf_base_stor_origin =3D (u64)kvm->arch.pv.stor_base;
> +	uvcb.conf_virt_stor_origin =3D (u64)kvm->arch.pv.stor_var;
> +
> +	cc =3D uv_call(0, (u64)&uvcb);
> +	*rc =3D uvcb.header.rc;
> +	*rrc =3D uvcb.header.rrc;
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x =
rrc %x",
> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
> +
> +	/* Outputs */
> +	kvm->arch.pv.handle =3D uvcb.guest_handle;
> +
> +	if (cc && (uvcb.header.rc & UVC_RC_NEED_DESTROY)) {

So, in case cc!=3D0 and UVC_RC_NEED_DESTROY is not set, we would return a=
n
error (!=3D0 from this function) and not even try to deinit the vm?

This is honestly confusing stuff.

> +		if (!kvm_s390_pv_deinit_vm(kvm, &drc, &drrc))
> +			kvm_s390_pv_dealloc_vm(kvm);

kvm_s390_pv_deinit_vm() will already call kvm_s390_pv_dealloc_vm().

> +		return -EINVAL;
> +	}
> +	kvm->arch.gmap->guest_handle =3D uvcb.guest_handle;
> +	atomic_set(&kvm->mm->context.is_protected, 1);
> +	return cc;

Convert to a proper error?


Feel free to send a new version of this patch only on top. I'll try to
review it very fast :)

--=20
Thanks,

David / dhildenb

