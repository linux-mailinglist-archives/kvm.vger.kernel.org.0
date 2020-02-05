Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5630915302C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgBELwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:52:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725385AbgBELwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 06:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580903522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=lBPQ5BkJBqpGEGMdfUYLFeLNx5mfOD9d49fcduAvLfs=;
        b=Tb0ZVBEG8GvMcr15aViQ+Zi7YDMyWvivQKKMCyvj7BQLaT3e8TCxPUSuCqinJSHi1tw3ET
        gVZ4Qodz2QvWhhIbeoUOfLWxihDia+PYjknR5L0ggB9Kzlv3FG8wiWDoLC6BumVCryuuNC
        sXcHYym8AO1wD2SdEe7Q1vZmEmSTllc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-15OPrUM5PzWdXA4dbSMITg-1; Wed, 05 Feb 2020 06:52:01 -0500
X-MC-Unique: 15OPrUM5PzWdXA4dbSMITg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDD1E100551A;
        Wed,  5 Feb 2020 11:51:59 +0000 (UTC)
Received: from [10.36.116.217] (ovpn-116-217.ams2.redhat.com [10.36.116.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E38A5DA2C;
        Wed,  5 Feb 2020 11:51:58 +0000 (UTC)
Subject: Re: [RFCv2 22/37] KVM: s390: protvirt: handle secure guest prefix
 pages
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-23-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8ccf2009-d391-d91b-3088-49e950b94674@redhat.com>
Date:   Wed, 5 Feb 2020 12:51:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-23-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.20 14:19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> The SPX instruction is handled by the ulravisor. We do get a
> notification intercept, though. Let us update our internal view.
>=20
> In addition to that, when the guest prefix page is not secure, an
> intercept 112 (0x70) is indicated.  To avoid this for the most common
> cases, we can make the guest prefix page protected whenever we pin it.
> We have to deal with 112 nevertheless, e.g. when some host code trigger=
s
> an export (e.g. qemu dump guest memory). We can simply re-run the
> pinning logic by doing a no-op prefix change.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/intercept.c        | 15 +++++++++++++++
>  arch/s390/kvm/kvm-s390.c         | 14 ++++++++++++++
>  3 files changed, 30 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index 48f382680755..686b00ced55b 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -225,6 +225,7 @@ struct kvm_s390_sie_block {
>  #define ICPT_PV_INT_EN	0x64
>  #define ICPT_PV_INSTR	0x68
>  #define ICPT_PV_NOTIF	0x6c
> +#define ICPT_PV_PREF	0x70
>  	__u8	icptcode;		/* 0x0050 */
>  	__u8	icptstatus;		/* 0x0051 */
>  	__u16	ihcpu;			/* 0x0052 */
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index d63f9cf10360..ceba0abb1900 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -451,6 +451,15 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>  	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>  }
> =20
> +static int handle_pv_spx(struct kvm_vcpu *vcpu)
> +{
> +	u32 pref =3D *(u32 *)vcpu->arch.sie_block->sidad;
> +
> +	kvm_s390_set_prefix(vcpu, pref);
> +	trace_kvm_s390_handle_prefix(vcpu, 1, pref);
> +	return 0;
> +}
> +
>  static int handle_pv_sclp(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_s390_float_interrupt *fi =3D &vcpu->kvm->arch.float_int;
> @@ -475,6 +484,8 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
> =20
>  static int handle_pv_not(struct kvm_vcpu *vcpu)
>  {
> +	if (vcpu->arch.sie_block->ipa =3D=3D 0xb210)
> +		return handle_pv_spx(vcpu);
>  	if (vcpu->arch.sie_block->ipa =3D=3D 0xb220)
>  		return handle_pv_sclp(vcpu);
> =20
> @@ -533,6 +544,10 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu=
)
>  	case ICPT_PV_NOTIF:
>  		rc =3D handle_pv_not(vcpu);
>  		break;
> +	case ICPT_PV_PREF:
> +		rc =3D 0;
> +		kvm_s390_set_prefix(vcpu, kvm_s390_get_prefix(vcpu));

/me confused

This is the "request to map prefix" case, right?

I'd *really* prefer to have a comment and a manual

/* request to convert and pin the prefix pages again */
kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu)

A TLB flush is IMHO not necessary, as the prefix did not change.

> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 76303b0f1226..6e74c7afae3a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3675,6 +3675,20 @@ static int kvm_s390_handle_requests(struct kvm_v=
cpu *vcpu)
>  		rc =3D gmap_mprotect_notify(vcpu->arch.gmap,
>  					  kvm_s390_get_prefix(vcpu),
>  					  PAGE_SIZE * 2, PROT_WRITE);
> +		if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			do {
> +				rc =3D uv_convert_to_secure(
> +						vcpu->arch.gmap,
> +						kvm_s390_get_prefix(vcpu));
> +			} while (rc =3D=3D -EAGAIN);
> +			WARN_ONCE(rc, "Error while importing first prefix page. rc %d", rc)=
;
> +			do {
> +				rc =3D uv_convert_to_secure(
> +						vcpu->arch.gmap,
> +						kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
> +			} while (rc =3D=3D -EAGAIN);
> +			WARN_ONCE(rc, "Error while importing second prefix page. rc %d", rc=
);

Maybe factor that out into a separate function (e.g., for a single page
and call that twice).

> +		}
>  		if (rc) {
>  			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
>  			return rc;
>=20


--=20
Thanks,

David / dhildenb

