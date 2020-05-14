Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A582A1D393D
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgENSkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:40:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46930 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726890AbgENSkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 14:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589481629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=VpfJIVeSygQz9fiQxolpd5tHSlpFO9r6a26eIwnHrtM=;
        b=i83kzvNxLUoYPU4KxcFFan9PJhst/lMSxhlAzdTFnyzlcZcWERPjY8vYWZ11birbBBCTW7
        Wjag1YtFH4InN8y4R6a8VNjTCIQk6WpZYn9dauzqi/ZiYnbAGpL6q8BaGa0sm1h3sbYSE+
        GHVWrLSqaD2QF1nJZWLtzltkVMdjM2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-EKfmuuH-OqW2NeOb0jVL0A-1; Thu, 14 May 2020 14:40:21 -0400
X-MC-Unique: EKfmuuH-OqW2NeOb0jVL0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 464CC19200C2;
        Thu, 14 May 2020 18:40:20 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AEED60BF1;
        Thu, 14 May 2020 18:40:14 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Janosch Frank <frankja@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
 <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <55f9b4a8-61a1-aab8-40a2-cb992be72fef@redhat.com>
Date:   Thu, 14 May 2020 20:40:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1gjdqS4d6hDOAuXuvlvoV6Fom8N5KzcDh"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1gjdqS4d6hDOAuXuvlvoV6Fom8N5KzcDh
Content-Type: multipart/mixed; boundary="vkp04YgUUSoBait4imKpIihgoq0Xtcoxy";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
 Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
 cohuck@redhat.com, imbrenda@linux.ibm.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com
Message-ID: <55f9b4a8-61a1-aab8-40a2-cb992be72fef@redhat.com>
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
 <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
In-Reply-To: <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>

--vkp04YgUUSoBait4imKpIihgoq0Xtcoxy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 14/05/2020 10.52, Janosch Frank wrote:
> On 5/14/20 9:53 AM, Thomas Huth wrote:
>> On 14/05/2020 00.15, Collin Walling wrote:
>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>> functions to communicate between userspace and KVM via ioctls. These
>>> will be used to get/set the diag318 related information, as well as
>>> check the system if KVM supports handling this instruction.
>>>
>>> This information can help with diagnosing the environment the VM is
>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>>
>>> By default, this feature is disabled and can only be enabled if a
>>> user space program (such as QEMU) explicitly requests it.
>>>
>>> The Control Program Name Code (CPNC) is stored in the SIE block
>>> and a copy is retained in each VCPU. The Control Program Version
>>> Code (CPVC) is not designed to be stored in the SIE block, so we
>>> retain a copy in each VCPU next to the CPNC.
>>>
>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>> ---
>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>>  arch/s390/kvm/vsie.c                  |  2 +
>>>  7 files changed, 151 insertions(+), 1 deletion(-)
>> [...]
>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>>> index 563429dece03..3caed4b880c8 100644
>>> --- a/arch/s390/kvm/diag.c
>>> +++ b/arch/s390/kvm/diag.c
>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu=
 *vcpu)
>>>  =09return ret < 0 ? ret : 0;
>>>  }
>>> =20
>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>>> +{
>>> +=09unsigned int reg =3D (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>>> +=09u64 info =3D vcpu->run->s.regs.gprs[reg];
>>> +
>>> +=09if (!vcpu->kvm->arch.use_diag318)
>>> +=09=09return -EOPNOTSUPP;
>>> +
>>> +=09vcpu->stat.diagnose_318++;
>>> +=09kvm_s390_set_diag318_info(vcpu->kvm, info);
>>> +
>>> +=09VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>>> +=09=09   vcpu->kvm->arch.diag318_info.cpnc,
>>> +=09=09   (u64)vcpu->kvm->arch.diag318_info.cpvc);
>>> +
>>> +=09return 0;
>>> +}
>>> +
>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>  {
>>>  =09int code =3D kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>  =09=09return __diag_page_ref_service(vcpu);
>>>  =09case 0x308:
>>>  =09=09return __diag_ipl_functions(vcpu);
>>> +=09case 0x318:
>>> +=09=09return __diag_set_diag318_info(vcpu);
>>>  =09case 0x500:
>>>  =09=09return __diag_virtio_hypercall(vcpu);
>>
>> I wonder whether it would make more sense to simply drop to userspace
>> and handle the diag 318 call there? That way the userspace would always
>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
>> handling), it's better if the userspace is in control... e.g. userspace
>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
>> guest just executed the diag 318 instruction.
>>
>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
>> could also be simply used by the diag 318 handler in userspace?
[...]
>> What about a reset of the guest VM? If a user first boots into a Linux
>> kernel that supports diag 318, then reboots and selects a Linux kernel
>> that does not support diag 318? I'd expect that the cpnc / cpnv values
>> need to be cleared here somewhere? Otherwise the information might not
>> be accurate anymore?
>=20
> He resets via QEMU on a machine reset.

Ah, thanks for the pointer, makes sense! ... and actually, I think that
is another indication that QEMU should rather be in control, thus the
kernel code should drop to userspace instead of handling the diag 318
call in diag.c in the kernel above.

 Thomas


--vkp04YgUUSoBait4imKpIihgoq0Xtcoxy--

--1gjdqS4d6hDOAuXuvlvoV6Fom8N5KzcDh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl69kIsACgkQLtnXdP5w
LbXdfA/9GXR5qbjDFvqNZLaFCai8leAeB4rTGA3/pnatXC79XyG1TPhI8wRyPR9/
lqE/lTXA4VjlT/u6IfogDiE6mAapPtNM6NQrvGBFQhc3WFTFWeFtSLSWqZVGex1v
QkGBDr0PmWyIjKqA0ep620T0cd0RUAa8lkAW4G/PHX8ic+y9nqQ6lL8ide6TDiVH
SyC89tBWkMvAwguE5suujdoCGuE0q2jgl53sRRnntCX7/yQsu/Lm2nKWLg4yXi+D
KNCR5H6S+/wYCCvXib19mv3V+y0f+VCBbZrjdhLO6wSXDpNr5OqxU2nhzuJbKTjj
K1oBESKpcLxrS6i91QOGBfe0/AKW6SkeyDoWIJzR6t36+lhdwQJEQ4pB7HZQvqdH
lVZ8JU2Rw70eCIUPhYoj0Sm8Di/x0Dm+5P14M4puwQzdX13gNr1Z9egzob5TpnDm
wbxmUu64yEzD5jd/9HMS4MSU1fFCOv51qZ3xswpMFl2xwrhadH12021WKUFx99+C
EVNf2qOiIfuLW7mBixQPlX4XqG+t4jrSxz9zXLFH6/Gco9ix86XCwiXrPQIwohS4
EJXfVKZag1/vtEP4rGssHVGr7Nz6AI/DYCUjhdmXXN2pao4lLCsGzo8spn7wqJwW
+3GIgBsFUTiqTz5tgRkRWr7icKz2T3aKlXt3LypWc9o8bDKGXC4=
=xGfE
-----END PGP SIGNATURE-----

--1gjdqS4d6hDOAuXuvlvoV6Fom8N5KzcDh--

