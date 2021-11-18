Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A446455F3A
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhKRPWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:22:19 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51934 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhKRPWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:22:18 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8187E1FD37;
        Thu, 18 Nov 2021 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637248756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xf7DkdQhGiWRoeZ1EV9Ru0DqOCR9S/9CCgSkKFVsu1E=;
        b=uRSezixehLFQs6Hbu0zTDOBK+ONW8XmhFRjKXEHDiu7SWy1AjXmdh+wyGGM5hNLrbVRx6k
        12yBvd3AXM+UqpRLDlFCuE+T8yqJs2I4rP9gQGk5srNHHIsGhMNC6tkhk8O0kpXbRqX58W
        Z27FDhfLjw6EyRyvexel9TTKnNNt/JY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A3E913D43;
        Thu, 18 Nov 2021 15:19:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /blAAfRulmG/GwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 15:19:16 +0000
Subject: Re: [PATCH v3 1/4] x86/kvm: add boot parameter for adding vcpu-id
 bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
 <20211116141054.17800-2-jgross@suse.com>
 <7f10b8b4-e753-c977-f201-5ef17a6e81c8@suse.com> <YZWUV2jvoOS9RSq8@google.com>
 <731540b4-e8fc-0322-5aa0-e134bc55a397@suse.com> <YZZsw6b2iquFpF9P@google.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <eab3fe21-e209-a1af-3b7b-ed831cf1990d@suse.com>
Date:   Thu, 18 Nov 2021 16:19:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YZZsw6b2iquFpF9P@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P2IkS8001Jv52jNnxYTynxvUQ3SHNB1Wg"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P2IkS8001Jv52jNnxYTynxvUQ3SHNB1Wg
Content-Type: multipart/mixed; boundary="0MXfMVWoRZ298st46rlc3jOkPZu6xmN8c";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <eab3fe21-e209-a1af-3b7b-ed831cf1990d@suse.com>
Subject: Re: [PATCH v3 1/4] x86/kvm: add boot parameter for adding vcpu-id
 bits
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-2-jgross@suse.com>
 <7f10b8b4-e753-c977-f201-5ef17a6e81c8@suse.com> <YZWUV2jvoOS9RSq8@google.com>
 <731540b4-e8fc-0322-5aa0-e134bc55a397@suse.com> <YZZsw6b2iquFpF9P@google.com>
In-Reply-To: <YZZsw6b2iquFpF9P@google.com>

--0MXfMVWoRZ298st46rlc3jOkPZu6xmN8c
Content-Type: multipart/mixed;
 boundary="------------321CAFC05EC7AF4C22ED8862"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------321CAFC05EC7AF4C22ED8862
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.11.21 16:09, Sean Christopherson wrote:
> On Thu, Nov 18, 2021, Juergen Gross wrote:
>> On 18.11.21 00:46, Sean Christopherson wrote:
>>> On Wed, Nov 17, 2021, Juergen Gross wrote:
>>>> On 16.11.21 15:10, Juergen Gross wrote:
>>>>> Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is s=
et
>>>>> via a #define in a header file.
>>>>>
>>>>> In order to support higher vcpu-ids without generally increasing th=
e
>>>>> memory consumption of guests on the host (some guest structures con=
tain
>>>>> arrays sized by KVM_MAX_VCPU_IDS) add a boot parameter for adding s=
ome
>>>>> bits to the vcpu-id. Additional bits are needed as the vcpu-id is
>>>>> constructed via bit-wise concatenation of socket-id, core-id, etc.
>>>>> As those ids maximum values are not always a power of 2, the vcpu-i=
ds
>>>>> are sparse.
>>>>>
>>>>> The additional number of bits needed is basically the number of
>>>>> topology levels with a non-power-of-2 maximum value, excluding the =
top
>>>>> most level.
>>>>>
>>>>> The default value of the new parameter will be 2 in order to suppor=
t
>>>>> today's possible topologies. The special value of -1 will use the
>>>>> number of bits needed for a guest with the current host's topology.=

>>>>>
>>>>> Calculating the maximum vcpu-id dynamically requires to allocate th=
e
>>>>> arrays using KVM_MAX_VCPU_IDS as the size dynamically.
>>>>>
>>>>> Signed-of-by: Juergen Gross <jgross@suse.com>
>>>>
>>>> Just thought about vcpu-ids a little bit more.
>>>>
>>>> It would be possible to replace the topology games completely by an
>>>> arbitrary rather high vcpu-id limit (65536?) and to allocate the mem=
ory
>>>> depending on the max vcpu-id just as needed.
>>>>
>>>> Right now the only vcpu-id dependent memory is for the ioapic consis=
ting
>>>> of a vcpu-id indexed bitmap and a vcpu-id indexed byte array (vector=
s).
>>>>
>>>> We could start with a minimal size when setting up an ioapic and ext=
end
>>>> the areas in case a new vcpu created would introduce a vcpu-id outsi=
de
>>>> the currently allocated memory. Both arrays are protected by the ioa=
pic
>>>> specific lock (at least I couldn't spot any unprotected usage when
>>>> looking briefly into the code), so reallocating those arrays shouldn=
't
>>>> be hard. In case of ENOMEM the related vcpu creation would just fail=
=2E
>>>>
>>>> Thoughts?
>>>
>>> Why not have userspace state the max vcpu_id it intends to creates on=
 a per-VM
>>> basis?  Same end result, but doesn't require the complexity of reallo=
cating the
>>> I/O APIC stuff.
>>>
>>
>> And if the userspace doesn't do it (like today)?
>=20
> Similar to my comments in patch 4, KVM's current limits could be used a=
s the
> defaults, and any use case wanting to go beyond that would need an upda=
ted
> userspace.  Exceeding those limits today doesn't work, so there's no AB=
I breakage
> by requiring a userspace change.

Hmm, nice idea. Will look into it.

> Or again, this could be a Kconfig knob, though that feels a bit weird i=
n this case.
> But it might make sense if it can be tied to something in the kernel's =
config?

Having a Kconfig knob for an absolute upper bound of vcpus should
be fine. If someone doesn't like the capability to explicitly let
qemu create very large VMs, he/she can still set that upper bound
to the normal KVM_MAX_VCPUS value.

Juergen

--------------321CAFC05EC7AF4C22ED8862
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

--------------321CAFC05EC7AF4C22ED8862--

--0MXfMVWoRZ298st46rlc3jOkPZu6xmN8c--

--P2IkS8001Jv52jNnxYTynxvUQ3SHNB1Wg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGWbvMFAwAAAAAACgkQsN6d1ii/Ey9t
WQf+JQe4G2JgLmrVh2qcaVs4/hE5CcApGYK1CLVJJN+H/L9Qoetf357n6l+elJwgRogWJ1uxwa0K
usWN+CLI5s7n60IsOxwyPInl7VxN++b5Vp9sygjk2irM1oKjpL4gxszodYBB36wGzB4n7Yry2p4X
z0tY+Apuw0sNFCWvNCa2KDXIuLd/f3knfdnIP3nzNPaM0Qgri2bIpUuUf3bCgPDer75fpvcSs4Ar
TvKZ0caMTyPu9HKY1TvwCrD0zEIduCc3U92XZssfSKrYenwOvsF4tx+Cgvc3QNaEmdhZ1L5QTcSR
PmRw4Bj1R0XUIHA0xx0qDIflmYyK2W4sJP9TB7lfhA==
=Das3
-----END PGP SIGNATURE-----

--P2IkS8001Jv52jNnxYTynxvUQ3SHNB1Wg--
