Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0C455F2A
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhKRPSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:18:37 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51784 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhKRPSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:18:37 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB2AD1FD38;
        Thu, 18 Nov 2021 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637248535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=815ygcrkHrZO++5vQDLmQslmOWBdzgBrazSgJaUJgCU=;
        b=tukfil+0Q7iesX8f0AAZZnVk3VaiW53UnbpPyMZTtuQdcJpFBSgWuLRrYAWdCC3rgufTDs
        5kkZVk1SisyJDgV527HDRMCf39gTeb6xaLTaBrjq1bFNLrbSA0q2e/ZTjj7YBP+ZfWyFDG
        TQ/Xou8WwrPI54yNUtGP7p4VtH1mR/Q=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51E9F13D43;
        Thu, 18 Nov 2021 15:15:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JLgREhdulmEwGgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 15:15:35 +0000
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
 <20211116141054.17800-5-jgross@suse.com> <YZVsnZ8e7cXls2P2@google.com>
 <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com> <YZZrzSi1rdaP0ETF@google.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
Message-ID: <d5c57c27-e237-ef84-96c7-f50619597023@suse.com>
Date:   Thu, 18 Nov 2021 16:15:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YZZrzSi1rdaP0ETF@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cy1UV5sB4OCe2ei6mQXIIrO6JHN8LxhIZ"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cy1UV5sB4OCe2ei6mQXIIrO6JHN8LxhIZ
Content-Type: multipart/mixed; boundary="zJjxZtNSeFizLk8L4yXlPqhTIRzHT9Jt6";
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
Message-ID: <d5c57c27-e237-ef84-96c7-f50619597023@suse.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-5-jgross@suse.com> <YZVsnZ8e7cXls2P2@google.com>
 <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com> <YZZrzSi1rdaP0ETF@google.com>
In-Reply-To: <YZZrzSi1rdaP0ETF@google.com>

--zJjxZtNSeFizLk8L4yXlPqhTIRzHT9Jt6
Content-Type: multipart/mixed;
 boundary="------------FF34E3C95AE3FD4A9D2728F5"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------FF34E3C95AE3FD4A9D2728F5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.11.21 16:05, Sean Christopherson wrote:
> On Thu, Nov 18, 2021, Juergen Gross wrote:
>> On 17.11.21 21:57, Sean Christopherson wrote:
>>> Rather than makes this a module param, I would prefer to start with t=
he below
>>> patch (originally from TDX pre-enabling) and then wire up a way for u=
serspace to
>>> _lower_ the max on a per-VM basis, e.g. add a capability.
>>
>> The main reason for this whole series is a request by a partner
>> to enable huge VMs on huge machines (huge meaning thousands of
>> vcpus on thousands of physical cpus).
>>
>> Making this large number a compile time setting would hurt all
>> the users who have more standard requirements by allocating the
>> needed resources even on small systems, so I've switched to a boot
>> parameter in order to enable those huge numbers only when required.
>>
>> With Marc's series to use an xarray for the vcpu pointers only the
>> bitmaps for sending IRQs to vcpus are left which need to be sized
>> according to the max vcpu limit. Your patch below seems to be fine, bu=
t
>> doesn't help for that case.
>=20
> Ah, you want to let userspace define a MAX_VCPUS that goes well beyond =
the current
> limit without negatively impacting existing setups.  My idea of a per-V=
M capability

Correct.

> still works, it would simply require separating the default max from th=
e absolute
> max, which this patch mostly does already, it just neglects to set an a=
bsolute max.
>=20
> Which is a good segue into pointing out that if a module param is added=
, it needs
> to be sanity checked against a KVM-defined max.  The admin may be trust=
ed to some
> extent, but there is zero reason to let userspace set max_vcspus to 4 b=
illion.
> At that point, it really is just a param vs. capability question.

I agree. Capping it at e.g. 65536 would probably be a good idea.

> I like the idea of a capability because there are already two known use=
 cases,
> arm64's GIC and x86's TDX, and it could also be used to reduce the kern=
el's footprint
> for use cases that run large numbers of smaller VMs.
>=20
> The other alternative would be to turn KVM_MAX_VCPUS into a Kconfig kno=
b.  I assume

I like combining the capping and a Kconfig knob. So let the distro (or
whoever is building the kernel) decide, which is the max allowed value
(e.g. above 65536 per default).

> the partner isn't running a vanilla distro build and could set it as th=
ey see fit.

And here you are wrong. They'd like to use standard SUSE Linux (SLE).


Juergen

--------------FF34E3C95AE3FD4A9D2728F5
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

--------------FF34E3C95AE3FD4A9D2728F5--

--zJjxZtNSeFizLk8L4yXlPqhTIRzHT9Jt6--

--cy1UV5sB4OCe2ei6mQXIIrO6JHN8LxhIZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGWbhYFAwAAAAAACgkQsN6d1ii/Ey8L
Ogf/bdrs4crmNOsufCY37E5apzQ3MJCpBf57lN/FlhYCDORBvQpPBBXAB2Ut46CDBX5cDXOWQfRO
wG2qdL+IMEr3b1apoVKzxUEe8JvG/ZFQjYP921vYtbLphEm5PCFwfnzGg0McekyRZ9hlRPjVmBxS
nkKeZat6zC/PbQdVLfQqPBCy/LwHA82B/HfP7egQFVEN/76pVgFXaAg02ZE0geL7av5k+SqXAimI
9kwUg3TO6ml7V2XqxRflQNN8oIJmpLRpxf3w9PEfkuFa/oMjRUr2ff6X2l8TLjMDv3bhDZu1awGI
hiCYilyEqzqs99xGmK4hyR3dLkOOBYrjQkupuO6wfw==
=J3wT
-----END PGP SIGNATURE-----

--cy1UV5sB4OCe2ei6mQXIIrO6JHN8LxhIZ--
