Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE13E3FFB9D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 10:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347810AbhICIOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 04:14:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36254 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348177AbhICIOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 04:14:45 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C973220015;
        Fri,  3 Sep 2021 08:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630656824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/8mQG7rAg+oZJaFpsa/TTNkc3K3gPyUkm37uyK/E3yY=;
        b=cDOnHfX5G5jxig5dgUxm/McUBG6exiUJivPBRhD/55gWLQ8QKBBnAWp390WkcVIvl6ZG8y
        o9+Ug81m3KtRNGfY1yvVhWgUtwkPN73tErjlc5bR+7jXJap2R3IxltMnzk0Uh+LN7xjMy1
        C1NQ0GOFo8m+yfWCzT13NUcLSAKi47Q=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 96E0E13748;
        Fri,  3 Sep 2021 08:13:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 9hZFIzjZMWEXbAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 08:13:44 +0000
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com> <20210901111326.2efecf6e@redhat.com>
 <87ilzkob6k.fsf@vitty.brq.redhat.com> <20210901153615.296486b5@redhat.com>
 <875yvknyrj.fsf@vitty.brq.redhat.com>
 <20210901152525.g5fnf5ketta3fjhl@habkost.net>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <442852d2-a5f7-8f6f-deb7-31f66a4579d6@suse.com>
Date:   Fri, 3 Sep 2021 10:13:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901152525.g5fnf5ketta3fjhl@habkost.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m6ShGWfQxPe9FtjRayQOP5Slb5gzOmsqz"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m6ShGWfQxPe9FtjRayQOP5Slb5gzOmsqz
Content-Type: multipart/mixed; boundary="d7POsgqVIY7msFHQDvS95qJS9Xbm9A4wm";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Eduardo Habkost <ehabkost@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Message-ID: <442852d2-a5f7-8f6f-deb7-31f66a4579d6@suse.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com> <20210901111326.2efecf6e@redhat.com>
 <87ilzkob6k.fsf@vitty.brq.redhat.com> <20210901153615.296486b5@redhat.com>
 <875yvknyrj.fsf@vitty.brq.redhat.com>
 <20210901152525.g5fnf5ketta3fjhl@habkost.net>
In-Reply-To: <20210901152525.g5fnf5ketta3fjhl@habkost.net>

--d7POsgqVIY7msFHQDvS95qJS9Xbm9A4wm
Content-Type: multipart/mixed;
 boundary="------------BCBBAA31329AFD1B67438792"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------BCBBAA31329AFD1B67438792
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 01.09.21 17:25, Eduardo Habkost wrote:
> On Wed, Sep 01, 2021 at 04:42:08PM +0200, Vitaly Kuznetsov wrote:
>> Igor Mammedov <imammedo@redhat.com> writes:
>>
>>> On Wed, 01 Sep 2021 12:13:55 +0200
>>> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>
>>>> Igor Mammedov <imammedo@redhat.com> writes:
>>>>
>>>>> On Wed, 01 Sep 2021 10:02:18 +0200
>>>>> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>>>  =20
>>>>>> Eduardo Habkost <ehabkost@redhat.com> writes:
>>>>>>   =20
>>>>>>> Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
>>>>>>> Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
>>>>>>>
>>>>>>> For reference, visible effects of changing KVM_MAX_VCPUS are:
>>>>>>> - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of =
course)
>>>>>>> - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000=
005)].EAX
>>>>>>>    will now be 710
>>>>>>> - Bitmap stack variables that will grow:
>>>>>>>    - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
>>>>>>>      - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
>>>>>>>      - vcpu_bitmap will be 92 bytes long
>>>>>>>    - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes lon=
g
>>>>>>>      once patch "KVM: x86: Fix stack-out-of-bounds memory access
>>>>>>>      from ioapic_write_indirect()" is applied
>>>>>>>
>>>>>>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>>>>>>> ---
>>>>>>>   arch/x86/include/asm/kvm_host.h | 4 ++--
>>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/a=
sm/kvm_host.h
>>>>>>> index af6ce8d4c86a..f76fae42bf45 100644
>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>>>>> @@ -37,8 +37,8 @@
>>>>>>>  =20
>>>>>>>   #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>>>>>>>  =20
>>>>>>> -#define KVM_MAX_VCPUS 288
>>>>>>> -#define KVM_SOFT_MAX_VCPUS 240
>>>>>>> +#define KVM_MAX_VCPUS 710
>>>>>>
>>>>>> Out of pure curiosity, where did 710 came from? Is this some parti=
cular
>>>>>> hardware which was used for testing (weird number btw). Should we =
maybe
>>>>>> go to e.g. 1024 for the sake of the beauty of powers of two? :-)
>=20
> 710 wasn't tested with real VMs yet due to userspace limitations
> that still need to be addressed (specifically, due to SMBIOS 2.1
> table size limits).
>=20
> I would be more than happy to set it to 1024 or 2048 if the KVM
> maintainers agree.  :)
>=20
> For reference, RHEL-8.4 is compiled with KVM_MAX_VCPUS=3D2048, but
> userspace enforces a 710 VCPU limit.
>=20
>>>>>>   =20
>>>>>>> +#define KVM_SOFT_MAX_VCPUS 710
>>>>>>
>>>>>> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCP=
US?
>>>>>>
>>>>>> Reading
>>>>>>
>>>>>> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
>>>>>> Author: Sasha Levin <levinsasha928@gmail.com>
>>>>>> Date:   Mon Jul 18 17:17:15 2011 +0300
>>>>>>
>>>>>>      KVM: x86: Raise the hard VCPU count limit
>>>>>>
>>>>>> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test=
 high
>>>>>> vCPU numbers without claiming such configurations as supported.
>>>>>>
>>>>>> I have two alternative suggestions:
>>>>>> 1) Drop KVM_SOFT_MAX_VCPUS completely.
>>>>>> 2) Raise it to a higher number (e.g. 2048)
>=20
> I will send a RFC later proposing we make KVM_MAX_VCPUS
> configurable by Kconfig, and dropping KVM_SOFT_MAX_VCPUS.
>=20
>>>>>>   =20
>>>>>>>   #define KVM_MAX_VCPU_ID 1023
>>>>>>
>>>>>> 1023 may not be enough now. I rememeber there was a suggestion to =
make
>>>>>> max_vcpus configurable via module parameter and this question was
>>>>>> raised:
>>>>>>
>>>>>> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
>>>>>>
>>>>>> TL;DR: to support EPYC-like topologies we need to keep
>>>>>>   KVM_MAX_VCPU_ID =3D 4 * KVM_MAX_VCPUS
>=20
> 1024 seems to be enough on all the CPU topologies I have seen,
> but I can happily implement the 4x rule below, just to be sure.
>=20
>>>>>
>>>>> VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution)=
,
>>>>> so topology encoded in the later should be orthogonal to VCPU_ID.
>>>>
>>>> Why do we even have KVM_MAX_VCPU_ID which is !=3D KVM[_SOFT]_MAX_VCP=
US
>>>> then?
>>> I'd say for compat reasons (8c3ba334f85 KVM: x86: Raise the hard VCPU=
 count limit)
>>>
>>> qemu warns users that they are out of recommended (tested) limit when=

>>> it sees requested maxcpus over soft limit.
>>> See soft_vcpus_limit in qemu.
>>>
>>
>> That's the reason why we have KVM_SOFT_MAX_VCPUS in addition to
>> KVM_MAX_VCPUS, not why we have KVM_MAX_VCPU_ID :-)
>>
>>>
>>>> KVM_MAX_VCPU_ID is only checked in kvm_vm_ioctl_create_vcpu() which
>>>> passes 'id' down to kvm_vcpu_init() which, in its turn, sets
>>>> 'vcpu->vcpu_id'. This is, for example, returned by kvm_x2apic_id():
>>>>
>>>> static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>>>> {
>>>>          return apic->vcpu->vcpu_id;
>>>> }
>>>>
>>>> So I'm pretty certain this is actually APIC id and it has topology i=
n
>>>> it.
>>> Yep, I mixed it up with cpu_index on QEMU side,
>>> for x86 it fetches actual apic id and feeds that to kvm when creating=
 vCPU.
>>>
>>> It looks like KVM_MAX_VCPU_ID (KVM_SOFT_MAX_VCPUS) is essentially
>>> MAX_[SOFT_]APIC_ID which in some places is treated as max number of v=
CPUs,
>>> so actual max count of vCPUs could be less than that (in case of spar=
se APIC
>>> IDs /non power of 2 thread|core|whatever count/).
>>
>> Yes. To avoid the confusion, I'd suggest we re-define KVM_MAX_VCPU_ID =
as
>> something like:
>>
>> #define KVM_MAX_VCPU_ID_TO_MAX_VCPUS_RATIO 4
>> #define KVM_MAX_VCPU_ID (KVM_MAX_VCPUS * KVM_MAX_VCPU_ID_TO_MAX_VCPUS_=
RATIO)
>>
>> and add a comment about sparse APIC IDs/topology.
>=20
> I will submit a new version of this patch with a rule like the
> above.
>=20
> A 4x ratio is very generous, but the only impact of a large
> KVM_MAX_VCPU_ID is a larger struct kvm_ioapic.  Changing
> KVM_MAX_VCPU_ID from 1024 to 4096 will make struct kvm_ioapic
> grow from 1628 bytes to 5084 bytes, which I assume is OK.
>=20

I'm just about to send V2 of my series [1] to support specifying the
max vcpu-id and max number of vcpus of a guest via command line
parameters.


Juergen

[1]: https://lore.kernel.org/kvm/20210701154105.23215-1-jgross@suse.com/

--------------BCBBAA31329AFD1B67438792
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

--------------BCBBAA31329AFD1B67438792--

--d7POsgqVIY7msFHQDvS95qJS9Xbm9A4wm--

--m6ShGWfQxPe9FtjRayQOP5Slb5gzOmsqz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmEx2TcFAwAAAAAACgkQsN6d1ii/Ey+a
6gf5AZxv2hyFPCEl7Bt2oup8++j5qqORQCdhDAbzDXlMl/TV1I/AMoGOOD6O2ta/yV6uAWJPkamL
8Ot85ntMIiL2ge29zrL1PGlFrBFnOVHyT6IKpF7CY4OCG/rn+nn9UpyRZozpyqJhcUnYXrdaftmX
sVHTyMrpFJTor1Bopc6LrtB7mX71MBGsw25OM4Q3daTJczYbDv+S7CzF7OFusrU3rhJ7B34avZft
PLzBQWqneuufRlgkPmbYLn9qmQU3AqhqFuPQ0Y+zH7PvF4QyLUn/ZU+U+CtANeUEQoUB8lesC9+7
2IF6bjF7BfESFGyx+l/6j5sy3CG2/pUc5Gu+Ik3xwQ==
=sc1T
-----END PGP SIGNATURE-----

--m6ShGWfQxPe9FtjRayQOP5Slb5gzOmsqz--
