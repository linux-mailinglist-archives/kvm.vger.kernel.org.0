Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510083C84F7
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhGNNHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:07:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48580 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhGNNHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 09:07:06 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C3FBC2029A;
        Wed, 14 Jul 2021 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626267853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vw878GUl18v5F9RzhNHg0Q2/AB1LzvtGeWezbwoS2L4=;
        b=JUv2S43+F3WKuvpY/TKcWoae7nhzZMCCF5w/qyce2Yozozgpup5077STiyWDeLRrXgMroE
        UjpUNZmTRMmBwHkgyt1GPB/S2R5NKu1x/T27di6gDB4QLfoCdaHYI50P6iy9rvaoOjOe6z
        d41lKQa8NhGAI/DeTqODL7CH9rM8pyc=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6273013A8C;
        Wed, 14 Jul 2021 13:04:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id mlk2Fs3g7mDdTQAAGKfGzw
        (envelope-from <jgross@suse.com>); Wed, 14 Jul 2021 13:04:13 +0000
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-7-jgross@suse.com>
 <87h7gx2lkt.fsf@vitty.brq.redhat.com>
 <1ddffb87-a6a2-eba3-3f34-cf606a2ecba2@suse.com>
 <878s292k75.fsf@vitty.brq.redhat.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number of
 vcpus per guest
Message-ID: <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
Date:   Wed, 14 Jul 2021 15:04:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <878s292k75.fsf@vitty.brq.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QkRP2XJGCpYimeKxucgaGGg6ugLFlQKDv"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QkRP2XJGCpYimeKxucgaGGg6ugLFlQKDv
Content-Type: multipart/mixed; boundary="YrABznfRmMOBrlRFVSKYKqv3BupeD5ypY";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org
Message-ID: <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number of
 vcpus per guest
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-7-jgross@suse.com>
 <87h7gx2lkt.fsf@vitty.brq.redhat.com>
 <1ddffb87-a6a2-eba3-3f34-cf606a2ecba2@suse.com>
 <878s292k75.fsf@vitty.brq.redhat.com>
In-Reply-To: <878s292k75.fsf@vitty.brq.redhat.com>

--YrABznfRmMOBrlRFVSKYKqv3BupeD5ypY
Content-Type: multipart/mixed;
 boundary="------------6B3428D48E814889440993D9"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6B3428D48E814889440993D9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 14.07.21 13:45, Vitaly Kuznetsov wrote:
> Juergen Gross <jgross@suse.com> writes:
>=20
>> On 14.07.21 13:15, Vitaly Kuznetsov wrote:
>>> Juergen Gross <jgross@suse.com> writes:
>>>
>>>> Today the maximum number of vcpus of a kvm guest is set via a #defin=
e
>>>> in a header file.
>>>>
>>>> In order to support higher vcpu numbers for guests without generally=

>>>> increasing the memory consumption of guests on the host especially o=
n
>>>> very large systems add a boot parameter for specifying the number of=

>>>> allowed vcpus for guests.
>>>>
>>>> The default will still be the current setting of 288. The value 0 ha=
s
>>>> the special meaning to limit the number of possible vcpus to the
>>>> number of possible cpus of the host.
>>>>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>> ---
>>>>    Documentation/admin-guide/kernel-parameters.txt | 10 ++++++++++
>>>>    arch/x86/include/asm/kvm_host.h                 |  5 ++++-
>>>>    arch/x86/kvm/x86.c                              |  7 +++++++
>>>>    3 files changed, 21 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Docum=
entation/admin-guide/kernel-parameters.txt
>>>> index 99bfa53a2bbd..8eb856396ffa 100644
>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>> @@ -2373,6 +2373,16 @@
>>>>    			guest can't have more vcpus than the set value + 1.
>>>>    			Default: 1023
>>>>   =20
>>>> +	kvm.max_vcpus=3D	[KVM,X86] Set the maximum allowed numbers of vcpu=
s per
>>>> +			guest. The special value 0 sets the limit to the number
>>>> +			of physical cpus possible on the host (including not
>>>> +			yet hotplugged cpus). Higher values will result in
>>>> +			slightly higher memory consumption per guest. Depending
>>>> +			on the value and the virtual topology the maximum
>>>> +			allowed vcpu-id might need to be raised, too (see
>>>> +			kvm.max_vcpu_id parameter).
>>>
>>> I'd suggest to at least add a sanity check: 'max_vcpu_id' should alwa=
ys
>>> be >=3D 'max_vcpus'. Alternatively, we can replace 'max_vcpu_id' with=
 say
>>> 'vcpu_id_to_vcpus_ratio' and set it to e.g. '4' by default.
>>
>> Either would be fine with me.
>>
>> A default of '2' for the ratio would seem more appropriate for me,
>> however. A thread count per core not being a power of 2 is quite
>> unlikely, and the worst case scenario for cores per socket would be
>> 2^n + 1.
>>
>=20
> (I vaguely recall AMD EPYC had more than thread id (package id?)
> encapsulated into APIC id).

Ah, yes, that rings a bell.

> Personally, I'd vote for introducing a 'ratio' parameter then so
> generally users will only have to set 'kvm.max_vcpus'.

Okay.

Default '4' then? Or '2 ^ (topology_levels - 2)' (assuming a
topology_level of 3 on Intel: thread/core/socket and 4 on EPYC:
thread/core/package/socket).

>=20
>>>
>>>> +			Default: 288
>>>> +
>>>>    	l1tf=3D           [X86] Control mitigation of the L1TF vulnerabi=
lity on
>>>>    			      affected CPUs
>>>>   =20
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/=
kvm_host.h
>>>> index 39cbc4b6bffb..65ae82a5d444 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -37,7 +37,8 @@
>>>>   =20
>>>>    #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>>>>   =20
>>>> -#define KVM_MAX_VCPUS 288
>>>> +#define KVM_DEFAULT_MAX_VCPUS 288
>>>> +#define KVM_MAX_VCPUS max_vcpus
>>>>    #define KVM_SOFT_MAX_VCPUS 240
>>>>    #define KVM_DEFAULT_MAX_VCPU_ID 1023
>>>>    #define KVM_MAX_VCPU_ID max_vcpu_id
>>>> @@ -1509,6 +1510,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>>>>    extern u64  kvm_default_tsc_scaling_ratio;
>>>>    /* bus lock detection supported? */
>>>>    extern bool kvm_has_bus_lock_exit;
>>>> +/* maximum number of vcpus per guest */
>>>> +extern unsigned int max_vcpus;
>>>>    /* maximum vcpu-id */
>>>>    extern unsigned int max_vcpu_id;
>>>>    /* per cpu vcpu bitmasks (disable preemption during usage) */
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index a9b0bb2221ea..888c4507504d 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -177,6 +177,10 @@ module_param(force_emulation_prefix, bool, S_IR=
UGO);
>>>>    int __read_mostly pi_inject_timer =3D -1;
>>>>    module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>>>>   =20
>>>> +unsigned int __read_mostly max_vcpus =3D KVM_DEFAULT_MAX_VCPUS;
>>>> +module_param(max_vcpus, uint, S_IRUGO);
>>>> +EXPORT_SYMBOL_GPL(max_vcpus);
>>>> +
>>>>    unsigned int __read_mostly max_vcpu_id =3D KVM_DEFAULT_MAX_VCPU_I=
D;
>>>>    module_param(max_vcpu_id, uint, S_IRUGO);
>>>>   =20
>>>> @@ -10648,6 +10652,9 @@ int kvm_arch_hardware_setup(void *opaque)
>>>>    	if (boot_cpu_has(X86_FEATURE_XSAVES))
>>>>    		rdmsrl(MSR_IA32_XSS, host_xss);
>>>>   =20
>>>> +	if (max_vcpus =3D=3D 0)
>>>> +		max_vcpus =3D num_possible_cpus();
>>>
>>> Is this special case really needed? I mean 'max_vcpus' is not '0' by
>>> default so whoever sets it manually probably knows how big his guests=

>>> are going to be anyway and it is not always obvious how many CPUs are=

>>> reported by 'num_possible_cpus()' (ACPI tables can be weird for examp=
le).
>>
>> The idea was to make it easy for anyone managing a large fleet of host=
s
>> and wanting to have a common setting for all of them.
>>
>=20
> I see. It seems to be uncommon indeed to run guests with more vCPUs tha=
n
> host pCPUs so everything >=3D num_online_cpus() should be OK. My only
> concern about num_possible_cpus() is that it is going to be hard to
> explain what 'possible CPUs' mean (but whoever cares that much about
> wasting memory can always set the required value manually).

Right.


Juergen

--------------6B3428D48E814889440993D9
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

--------------6B3428D48E814889440993D9--

--YrABznfRmMOBrlRFVSKYKqv3BupeD5ypY--

--QkRP2XJGCpYimeKxucgaGGg6ugLFlQKDv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmDu4MwFAwAAAAAACgkQsN6d1ii/Ey80
kAgAhNWv3RLh5CvLSMKKq0xEzMkCtelIiLTE+Cy0bNPk61fwo/DZ51UoPuzLCDKrkXjAaN7ZLa6R
UDGfbDRyM/n6Ssoe7L+3DBeV2e9DossVVip1H3Pikky8KZQwm2OCqiE8qwwSgmlKvG6jwBJqubfJ
OdeN90UMZ2o5PJ2FzxSmLLebtQXiMY+rEa5lXn20XF2io6DBdjmmLzTHki7KpCDDvm4QY58OCSor
a3v6QyhU5s+IJrtBYXArdMP96mfAI7Pnm7k2o5ofmLA+v8+sA46lb2NuH/SFvm/DxnfrpRcj6KVs
kXDZUltKKRYV+tqv64f/F8ae1qhfUUZWUAST86TGqw==
=A2uc
-----END PGP SIGNATURE-----

--QkRP2XJGCpYimeKxucgaGGg6ugLFlQKDv--
