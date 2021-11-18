Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F238D455F5F
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhKRP1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:27:35 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47164 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhKRP1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:27:31 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B07C6212C4;
        Thu, 18 Nov 2021 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637249069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zRV7uWQt5wOO82GENZMQXL2ufpBPou91oq1HzKO2zYU=;
        b=NcASZNZR1e/nAIkAPJS9d2RbsXwbTfERAXm1kQsPh04XyOd6ft4KD29Qqriur+LdNQI4ze
        6F8gJOEUJ9H2m6DfzdmusItVkP3bl6orMfdfxE9YmTEgkJ4F8R3oMPjVfQ4FSsPHQnC+IL
        PZNLQInJxh8N03HFRIL8UyKGqFB6+Ps=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3BDF213D43;
        Thu, 18 Nov 2021 15:24:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GfRqDS1wlmFwHgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 15:24:29 +0000
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com> <YZVrDpjW0aZjFxo1@google.com>
 <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com> <YZZn/iWsi2H845w6@google.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
Message-ID: <c3823bf6-dca3-515f-4657-14aac51679b3@suse.com>
Date:   Thu, 18 Nov 2021 16:24:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YZZn/iWsi2H845w6@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X6jJQE3N0K8ymlGjTFBbrgWYnUljfCxw0"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X6jJQE3N0K8ymlGjTFBbrgWYnUljfCxw0
Content-Type: multipart/mixed; boundary="tOiQG9FrlPl3W6AdWehUB6831YZbWNdhn";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <c3823bf6-dca3-515f-4657-14aac51679b3@suse.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com> <YZVrDpjW0aZjFxo1@google.com>
 <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com> <YZZn/iWsi2H845w6@google.com>
In-Reply-To: <YZZn/iWsi2H845w6@google.com>

--tOiQG9FrlPl3W6AdWehUB6831YZbWNdhn
Content-Type: multipart/mixed;
 boundary="------------CFC25338D1A051C3E504BEEE"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CFC25338D1A051C3E504BEEE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.11.21 15:49, Sean Christopherson wrote:
> On Thu, Nov 18, 2021, Juergen Gross wrote:
>> On 17.11.21 21:50, Sean Christopherson wrote:
>>>> @@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct=
 kvm *kvm, u32 vpidx)
>>>>    	struct kvm_vcpu *vcpu =3D NULL;
>>>>    	int i;
>>>> -	if (vpidx >=3D KVM_MAX_VCPUS)
>>>> +	if (vpidx >=3D min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
>>>
>>> IMO, this is conceptually wrong.  KVM should refuse to allow Hyper-V =
to be enabled
>>> if the max number of vCPUs exceeds what can be supported, or should r=
efuse to create
>>
>> TBH, I wasn't sure where to put this test. Is there a guaranteed
>> sequence of ioctl()s regarding vcpu creation (or setting the max
>> number of vcpus) and the Hyper-V enabling?
>=20
> For better or worse (mostly worse), like all other things CPUID, Hyper-=
V is a per-vCPU
> knob.  If KVM can't detect the impossible condition at compile time, kv=
m_check_cpuid()
> is probably the right place to prevent enabling Hyper-V on an unreachab=
le vCPU.

With HYPERV_CPUID_IMPLEMENT_LIMITS already returning the
supported number of vcpus for the Hyper-V case I'm not sure
there is really more needed.

The problem I'm seeing is that the only thing I can do is to
let kvm_get_hv_cpuid() not adding the Hyper-V cpuid leaves for
vcpus > 64. I can't return a failure, because that would
probably let vcpu creation fail. And this is something we don't
want, as kvm_get_hv_cpuid() is called even in the case the guest
doesn't plan to use Hyper-V extensions.

>=20
>>> the vCPUs.  I agree it makes sense to add a Hyper-V specific limit, s=
ince there are
>>> Hyper-V structures that have a hard limit, but detection of violation=
s should be a
>>> BUILD_BUG_ON, not a silent failure at runtime.
>>>
>>
>> A BUILD_BUG_ON won't be possible with KVM_MAX_VCPUS being selecteble v=
ia
>> boot parameter.
>=20
> I was thinking that there would still be a KVM-defined max that would c=
ap whatever
> comes in from userspace.
>=20

See my answers to you your other responses.


Juergen

--------------CFC25338D1A051C3E504BEEE
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------CFC25338D1A051C3E504BEEE--

--tOiQG9FrlPl3W6AdWehUB6831YZbWNdhn--

--X6jJQE3N0K8ymlGjTFBbrgWYnUljfCxw0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGWcCwFAwAAAAAACgkQsN6d1ii/Ey/r
iQf/bolwpowY42dhidl7jgDoUN3L3lBwGIzssu1WU62NiW0BrC+bCEIx1iQxRlnzbSTzbPad8qsO
3loR2LLouWRaklV2BG8lolbXm4R1GDvq5zP/2DaDY9PBV2XkE0tJ2pPvOvOiki+BMejjDhAN9DEZ
JaiSlkmGTTjK0aaNAm6LSQHfXEYcfLHv6IDytXPq4zCVGFtpNNlFWwXi1h8B6W2XhHuUa84ynZTR
R+Lil6D9RKWQJve6fJ3zrW5dtvffPDllpnH21ER5Y5sbOZL1P5XB/fk5dX+AK6y+ayhDylLFngOB
kut6ozNOEl0wAXQm3/QBixhFyNrG8OfLTkOPE4QgxA==
=E+2E
-----END PGP SIGNATURE-----

--X6jJQE3N0K8ymlGjTFBbrgWYnUljfCxw0--
