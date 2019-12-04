Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E1E112964
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 11:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfLDKhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 05:37:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21251 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfLDKhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 05:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575455851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nLt4HFCMZdjN5fYw9xFdC17/DzxDFC8QzLeH5bh/084=;
        b=IE+YCK5VSHfRLmC1Z512t5ClsV+lQ/wIYFresfBZcYdrvEyZA9BniSEkmGmQrDXxP0d1rV
        FggUEiZFq7PTXPo7fJulxXYphh24nBzPqGrojlDVbkcQf22i1foCRXH3ltvp/y9C5n+grf
        44+CAQhpxufrRyepG5AqF0ATGiqvvyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-kvO5j03IMfSBU-JrVP5b1g-1; Wed, 04 Dec 2019 05:37:28 -0500
X-MC-Unique: kvO5j03IMfSBU-JrVP5b1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA7EEA053D;
        Wed,  4 Dec 2019 10:37:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-39.ams2.redhat.com [10.36.117.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 486845DA70;
        Wed,  4 Dec 2019 10:37:22 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191203162055.3519-1-frankja@linux.ibm.com>
 <c22eefd7-2c99-ec8e-3b5c-fabb343230a9@redhat.com>
 <26845508-9a35-7ec6-fc01-49ab4b7e3473@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ac908a16-9b00-9c86-42f2-88cff497ed5c@redhat.com>
Date:   Wed, 4 Dec 2019 11:37:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <26845508-9a35-7ec6-fc01-49ab4b7e3473@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qR7wqTKRxEjnmAonEU9nCTVzn0nEQX453"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qR7wqTKRxEjnmAonEU9nCTVzn0nEQX453
Content-Type: multipart/mixed; boundary="XOTxow7ibzXRVYbHlE1y7VQsmzPAjTnA7";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
 cohuck@redhat.com, linux-s390@vger.kernel.org
Message-ID: <ac908a16-9b00-9c86-42f2-88cff497ed5c@redhat.com>
Subject: Re: [PATCH v2] KVM: s390: Add new reset vcpu API
References: <20191203162055.3519-1-frankja@linux.ibm.com>
 <c22eefd7-2c99-ec8e-3b5c-fabb343230a9@redhat.com>
 <26845508-9a35-7ec6-fc01-49ab4b7e3473@linux.ibm.com>
In-Reply-To: <26845508-9a35-7ec6-fc01-49ab4b7e3473@linux.ibm.com>

--XOTxow7ibzXRVYbHlE1y7VQsmzPAjTnA7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 04/12/2019 11.06, Janosch Frank wrote:
> On 12/4/19 10:32 AM, Thomas Huth wrote:
>> On 03/12/2019 17.20, Janosch Frank wrote:
>>> The architecture states that we need to reset local IRQs for all CPU
>>> resets. Because the old reset interface did not support the normal CPU
>>> reset we never did that.
>>>
>>> Now that we have a new interface, let's properly clear out local IRQs
>>> and let this commit be a reminder.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  arch/s390/kvm/kvm-s390.c | 13 +++++++++++++
>>>  include/uapi/linux/kvm.h |  4 ++++
>>>  2 files changed, 17 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index d9e6bf3d54f0..602214c5616c 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>>>  =09case KVM_CAP_S390_CMMA_MIGRATION:
>>>  =09case KVM_CAP_S390_AIS:
>>>  =09case KVM_CAP_S390_AIS_MIGRATION:
>>> +=09case KVM_CAP_S390_VCPU_RESETS:
>>>  =09=09r =3D 1;
>>>  =09=09break;
>>>  =09case KVM_CAP_S390_HPAGE_1M:
>>> @@ -3287,6 +3288,13 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struc=
t kvm_vcpu *vcpu,
>>>  =09return r;
>>>  }
>>> =20
>>> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>>> +{
>>> +=09kvm_clear_async_pf_completion_queue(vcpu);
>>> +=09kvm_s390_clear_local_irqs(vcpu);
>>> +=09return 0;
>>> +}
>>> +
>>>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>>  {
>>>  =09kvm_s390_vcpu_initial_reset(vcpu);
>>> @@ -4363,7 +4371,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>  =09=09r =3D kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>>>  =09=09break;
>>>  =09}
>>> +=09case KVM_S390_NORMAL_RESET:
>>> +=09=09r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>>> +=09=09break;
>>>  =09case KVM_S390_INITIAL_RESET:
>>> +=09=09/* fallthrough */
>>> +=09case KVM_S390_CLEAR_RESET:
>>>  =09=09r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>>  =09=09break;
>>
>> Isn't clear reset supposed to do more than the initial reset? If so, I'd
>> rather expect it the other way round:
>=20
> In the PV patch I remove the fallthrough and add a function for the
> clear reset. I add the UV reset calls into the
> kvm_arch_vcpu_ioctl_*_reset() functions, therefore I can't fallthrough
> because the Ultravisor does currently not allow staged resets (i.e.
> first initial then clear if a clear reset is needed)

Ok, then it's fine. But in case you respin your patch, it's maybe less
confusing if you swap it.

 Thomas


--XOTxow7ibzXRVYbHlE1y7VQsmzPAjTnA7--

--qR7wqTKRxEjnmAonEU9nCTVzn0nEQX453
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl3njGAACgkQLtnXdP5w
LbVn6Q/8CnGgKZzCuHCOdW6qjfakbo/fIfuAPbPOA5zm14avRLAUMJP/eJKZGcQl
U1gAILLeQ6QcTsi0WGvS2qm7kdbKJKDKzy2N3/wboTV/huFGvLXdvUEu/wLMw8mQ
ozieP2gD+TLCvI6NKHISoAfm65IgMrzhL+b6c3aZx9brIbsgD87sZrSum4F6XxMW
jjxr+0dg/tvHu1hSU+VlTBrxhj5z6+Ix+gcGwgafnJ4V/gN0SFyHOfx5bwudHAHD
oAF4RUXOcHnnJ3Sp9KttingpAGGsU7pSZWbYmQJsyQEvIM7X4qu485FOEkfRSFll
hToZcVnSMISMM7Rdb+XpIRAen7095re3jI4YL6Xsrw/bOfR0+f11YUMcDQowbL+y
FrnZa3PsEJqeOqtbXzY52uuhZLZlx5kkDXqNwvlvaYgTE5qPW7/3yu3wKZk8i2fi
MM8uGSWKTi9Oajj5djm7XrODQZJZKLOuxKOVsJjBOmygcC2JF2aNbgPppzQ2KbRu
Gz9JjDEGOxYrw9QZBWAaWc7Y+P7rMK2ZjnLyEB2b2npbZfBb3a/qSssXBaYOUbeF
VztexG66N0PK5tOIieIE0nnkqJ+Zkw3VM9ICgMxCJZWBPVcE8LV2sGFC6LcCeYGv
7eS6jHvWvDEslwMYwhfgGXG9Bbnl7+kQ8LjC4nMG7jUg5/mnT5E=
=nXSx
-----END PGP SIGNATURE-----

--qR7wqTKRxEjnmAonEU9nCTVzn0nEQX453--

