Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6C1535C6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBERA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:00:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37848 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727303AbgBERA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 12:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580922056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2HjIC22WDDe89RXOUmc9CxopsRp0jRMwPHeEjAlYVeU=;
        b=ejvBc8f27NLfguaWIJJCUpquEtbgKfMQB99lBvU0J6JwXPwxGVJmQuyB2xUk1Ceru8sGoG
        wdVlOKgYp84XiWpYJDz1M7r4/ia+slpcXhSsIG0Lbcs1sWAjgi2L8bwV/4GQ81k0RA4HEQ
        HoRnZF1Jqn6bb5UNWh/O4WJboprzW0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-BMcPtnimOdSt3LYryJbLwg-1; Wed, 05 Feb 2020 12:00:50 -0500
X-MC-Unique: BMcPtnimOdSt3LYryJbLwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A2251081FA3;
        Wed,  5 Feb 2020 17:00:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B58AA86C4A;
        Wed,  5 Feb 2020 17:00:39 +0000 (UTC)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
 <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7539e1d3-79c6-3581-b3fb-afa545bb81d2@redhat.com>
Date:   Wed, 5 Feb 2020 18:00:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="or1zbOiroipTYUWf2sALfNaXVNimODY4y"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--or1zbOiroipTYUWf2sALfNaXVNimODY4y
Content-Type: multipart/mixed; boundary="Sx0zEr1v6Od5seHZBRbZigVRnETzvTDh3";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.vnet.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
 David Hildenbrand <david@redhat.com>,
 Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>
Message-ID: <7539e1d3-79c6-3581-b3fb-afa545bb81d2@redhat.com>
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
 <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
In-Reply-To: <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>

--Sx0zEr1v6Od5seHZBRbZigVRnETzvTDh3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/02/2020 13.16, Janosch Frank wrote:
> On 2/5/20 1:02 PM, Thomas Huth wrote:
>> On 03/02/2020 14.19, Christian Borntraeger wrote:
>>> From: Janosch Frank <frankja@linux.ibm.com>
>>>
>>> Now that we can't access guest memory anymore, we have a dedicated
>>> sattelite block that's a bounce buffer for instruction data.
>>>
>>> We re-use the memop interface to copy the instruction data to / from
>>> userspace. This lets us re-use a lot of QEMU code which used that
>>> interface to make logical guest memory accesses which are not possible
>>> anymore in protected mode anyway.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>> [...]
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index eab741bc12c3..20969ce12096 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -466,7 +466,7 @@ struct kvm_translation {
>>>  =09__u8  pad[5];
>>>  };
>>> =20
>>> -/* for KVM_S390_MEM_OP */
>>> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
>>>  struct kvm_s390_mem_op {
>>>  =09/* in */
>>>  =09__u64 gaddr;=09=09/* the guest address */
>>> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>>>  =09__u32 op;=09=09/* type of operation */
>>>  =09__u64 buf;=09=09/* buffer in userspace */
>>>  =09__u8 ar;=09=09/* the access register number */
>>> -=09__u8 reserved[31];=09/* should be set to 0 */
>>> +=09__u8 reserved21[3];=09/* should be set to 0 */
>>> +=09__u32 offset;=09=09/* offset into the sida */
>>> +=09__u8 reserved28[24];=09/* should be set to 0 */
>>>  };
>>> +
>>> +
>>>  /* types for kvm_s390_mem_op->op */
>>>  #define KVM_S390_MEMOP_LOGICAL_READ=090
>>>  #define KVM_S390_MEMOP_LOGICAL_WRITE=091
>>> +#define KVM_S390_MEMOP_SIDA_READ=092
>>> +#define KVM_S390_MEMOP_SIDA_WRITE=093
>>>  /* flags for kvm_s390_mem_op->flags */
>>>  #define KVM_S390_MEMOP_F_CHECK_ONLY=09=09(1ULL << 0)
>>>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION=09(1ULL << 1)
>>> @@ -1510,6 +1516,7 @@ struct kvm_pv_cmd {
>>>  /* Available with KVM_CAP_S390_PROTECTED */
>>>  #define KVM_S390_PV_COMMAND=09=09_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
>>>  #define KVM_S390_PV_COMMAND_VCPU=09_IOW(KVMIO, 0xc6, struct kvm_pv_cmd=
)
>>> +#define KVM_S390_SIDA_OP=09=09_IOW(KVMIO, 0xc7, struct kvm_s390_mem_op=
)
>>> =20
>>>  /* Secure Encrypted Virtualization command */
>>>  enum sev_cmd_id {
>>>
>>
>> Uh, why the mix of a new ioctl with the existing mem_op stuff? Could you
>> please either properly integrate this into the MEM_OP ioctl (and e.g.
>> use gaddr as offset for the new SIDA_READ and SIDA_WRITE subcodes), or
>> completely separate it for a new ioctl, i.e. introduce a new struct for
>> the new ioctl instead of recycling the struct kvm_s390_mem_op here?
>> (and in case you ask me, I'd slightly prefer to integrate everything
>> into MEM_OP instead of introducing a new ioctl here).
>=20
> *cough* David and Christian didn't like the memop solution and it took
> me a long time to get this to work properly in QEMU...

I also don't like to re-use MEMOP_LOGICAL_READ and MEMOP_LOGICAL_WRITE
for the SIDA like you've had it in RFC v1 ... but what's wrong with
using KVM_S390_MEMOP_SIDA_READ and KVM_S390_MEMOP_SIDA_WRITE with the
MEM_OP ioctl directly?

 Thomas


--Sx0zEr1v6Od5seHZBRbZigVRnETzvTDh3--

--or1zbOiroipTYUWf2sALfNaXVNimODY4y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl469LYACgkQLtnXdP5w
LbWeGQ/+I+dk7vvBkVJCjZysec1xQ3JoAgW8+gz8A5XkdkEHTzeLTdw+0MQvHck1
P2jenLXMDf/NbSZgkEjafW6gxQRIHzj1hjQQcsvv9Go+mOGi9mZPgkZRjJQHP26y
4JXapka1tZmRg+PHINs8lEgTUm4WFjRAe+P/DBfg8JQnLRh0RgUH5NHbdzXBq6bx
QD3PR8pmQQy4PQRWHIhCjinUftaIX49kQGMfmo9LNAyHgIo11U97OSP7QqyUim12
Hgm4zyoZb2Sqdy7wSROZlcu4r2umCqWKlLiZLk4O5IRQ5kBfKbGvImHe/x1sCpii
aU6V3+kkcTRNvI+F5EE6CeKrUZGbxb140iyT/NDmAZuCS3dfF6pLxS4ppDtiG0PO
XYfNZHZUTlMhe6Pq7qPokCIqYjZU2Wx/Z1X8l8uaH1QGOs1Ppy1hlNr2z/THjH2k
F2/QCn9+Q+NYGB2+4TH8Dz9x7OTrBVBKuh8cqOBNTjFwkxHx2qnERr6fWQ9eFIIk
zAO5OjfPVSGpFMT9nkz4zDwOBJB4k3jKufaf+1zhAjpWJpjDoY5m3HvbGwrqBZgT
tkyBMFvv4AewdDD9x+A5bJZNdN7iRqsBSUPpXgS3szz/68PY62KE0AZHqJuXUBoh
ENe3Dc/y9SUQ5puAKfWTvIROdDXLfTfGscvGlW4JWERUMLrQGPY=
=35yC
-----END PGP SIGNATURE-----

--or1zbOiroipTYUWf2sALfNaXVNimODY4y--

