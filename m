Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110A34555F6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 08:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244039AbhKRHrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 02:47:04 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52574 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244023AbhKRHqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 02:46:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 082CF1FD35;
        Thu, 18 Nov 2021 07:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637221413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cYDfG1oWSZbpBbHPdOX+BBO1kGppbDRZd6YB8IrMIt4=;
        b=GoW67FhrZiEQtZbWrTUGjiuO1TLmmGJatHDV07tfXVYycEOebd3Trh9TuO7lIkVidGyiLV
        pmsuLca+A3mZIVabrNdkMeU7X0JZZ7aRYsZ0GvceZv/N1LteG5sbz6ychGzF+SOzGtVBcz
        cl81O0BddObSuJ02niDMkgEHuNAbWD4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8026813CE6;
        Thu, 18 Nov 2021 07:43:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ncWsHSQElmG0QwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 07:43:32 +0000
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
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
Message-ID: <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com>
Date:   Thu, 18 Nov 2021 08:43:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YZVrDpjW0aZjFxo1@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5cBUQoToneO8V1pOyzcWLmtIJYL04gXMC"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5cBUQoToneO8V1pOyzcWLmtIJYL04gXMC
Content-Type: multipart/mixed; boundary="LPl7Rl1ITYfjr8Kctme8DZCrMQ2s3J761";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com> <YZVrDpjW0aZjFxo1@google.com>
In-Reply-To: <YZVrDpjW0aZjFxo1@google.com>

--LPl7Rl1ITYfjr8Kctme8DZCrMQ2s3J761
Content-Type: multipart/mixed;
 boundary="------------02CD9F29A3AC9F1BB7F0C3BA"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------02CD9F29A3AC9F1BB7F0C3BA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 17.11.21 21:50, Sean Christopherson wrote:
> On Tue, Nov 16, 2021, Juergen Gross wrote:
>> When emulating Hyperv the theoretical maximum of vcpus supported is
>> 4096, as this is the architectural limit for sending IPIs via the PV
>> interface.
>>
>> For restricting the actual supported number of vcpus for that case
>> introduce another define KVM_MAX_HYPERV_VCPUS and set it to 1024, like=

>> today's KVM_MAX_VCPUS. Make both values unsigned ones as this will be
>> needed later.
>>
>> The actual number of supported vcpus for Hyperv emulation will be the
>> lower value of both defines.
>>
>> This is a preparation for a future boot parameter support of the max
>> number of vcpus for a KVM guest.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> V3:
>> - new patch
>> ---
>>   arch/x86/include/asm/kvm_host.h |  3 ++-
>>   arch/x86/kvm/hyperv.c           | 15 ++++++++-------
>>   2 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
>> index 886930ec8264..8ea03ff01c45 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -38,7 +38,8 @@
>>  =20
>>   #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>>  =20
>> -#define KVM_MAX_VCPUS 1024
>> +#define KVM_MAX_VCPUS 1024U
>> +#define KVM_MAX_HYPERV_VCPUS 1024U
>=20
> I don't see any reason to put this in kvm_host.h, it should never be us=
ed outside
> of hyperv.c.

Okay, fine with me.

>=20
>>   #define KVM_MAX_VCPU_IDS kvm_max_vcpu_ids()
>>   /* memory slots that are not exposed to userspace */
>>   #define KVM_PRIVATE_MEM_SLOTS 3
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 4a555f32885a..c0fa837121f1 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -41,7 +41,7 @@
>>   /* "Hv#1" signature */
>>   #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
>>  =20
>> -#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 6=
4)
>> +#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_HYPERV_V=
CPUS, 64)
>>  =20
>>   static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
>>   				bool vcpu_kick);
>> @@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct k=
vm *kvm, u32 vpidx)
>>   	struct kvm_vcpu *vcpu =3D NULL;
>>   	int i;
>>  =20
>> -	if (vpidx >=3D KVM_MAX_VCPUS)
>> +	if (vpidx >=3D min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
>=20
> IMO, this is conceptually wrong.  KVM should refuse to allow Hyper-V to=
 be enabled
> if the max number of vCPUs exceeds what can be supported, or should ref=
use to create

TBH, I wasn't sure where to put this test. Is there a guaranteed
sequence of ioctl()s regarding vcpu creation (or setting the max
number of vcpus) and the Hyper-V enabling?

> the vCPUs.  I agree it makes sense to add a Hyper-V specific limit, sin=
ce there are
> Hyper-V structures that have a hard limit, but detection of violations =
should be a
> BUILD_BUG_ON, not a silent failure at runtime.
>=20

A BUILD_BUG_ON won't be possible with KVM_MAX_VCPUS being selecteble via
boot parameter.


Juergen

--------------02CD9F29A3AC9F1BB7F0C3BA
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

--------------02CD9F29A3AC9F1BB7F0C3BA--

--LPl7Rl1ITYfjr8Kctme8DZCrMQ2s3J761--

--5cBUQoToneO8V1pOyzcWLmtIJYL04gXMC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGWBCMFAwAAAAAACgkQsN6d1ii/Ey8x
Ygf8DFYWyQw1inq76Yw8Q1TG8ZD594hLI99Mb3mC5mBbAGhvHMnbhsG1FwyNW5bFxGMmg+uzr7+p
n08vckLGia8R8qP/enjy9ZscsTJBX56N/MIHd0dUwMce5cwkgd0ExvR18h7hMsnQSAzJrGJAuz5L
jymRQEWG8Y/Y4QR+xKLbSpYZU/KypdFTCzu+3ymIuySp/3ASr/SKUyl5RcmMPFXYUsj5r8652owM
clj373YdqT+lBM5AjVJ+6z8XDJEMNVug4ZX6B7P6How66jytwUDEYdpHfRMrQ8RkpJAEGaHdHQtv
dvNOW6dJkKNfYjHeH56G3vby6+K0wBNa2l7l+jdRNQ==
=0eHa
-----END PGP SIGNATURE-----

--5cBUQoToneO8V1pOyzcWLmtIJYL04gXMC--
