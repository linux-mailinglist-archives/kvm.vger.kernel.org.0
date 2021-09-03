Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B563FFACA
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 09:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbhICHCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 03:02:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51644 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347087AbhICHCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 03:02:14 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C98292000D;
        Fri,  3 Sep 2021 07:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630652472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yalwCrNyiShCtjj21JfQ+dobjU/tHRKadJjhoJHAOwQ=;
        b=WpmmBO+y9yfW3tqBHfgQA3W9zAa/3zwaRTg9iUjfW9t9paz6RAtSWpyWcQHoc8Aw+dnVl2
        YE1bVrb3tv9uNl2QSXsFNqsmeFZt2nGDftwdaLcFFyQDKKLORjg528EDuSmcvqc2Z7vgC5
        tQvP4/c6axsTsQjd8zD6Misl8ICSzRY=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 513E2136BF;
        Fri,  3 Sep 2021 07:01:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id CBi8ETjIMWHKWwAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 07:01:12 +0000
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
 <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
 <8735sh2fr7.fsf@vitty.brq.redhat.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number of
 vcpus per guest
Message-ID: <bb4ebe24-1de5-82b8-001d-1c0f9f28861b@suse.com>
Date:   Fri, 3 Sep 2021 09:01:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8735sh2fr7.fsf@vitty.brq.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gCj3IbJEMvpHW8XTVyNSugAMzxOfv2zEk"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gCj3IbJEMvpHW8XTVyNSugAMzxOfv2zEk
Content-Type: multipart/mixed; boundary="GvcaP8GkYIMbygjk2yW19biht3REG7Obc";
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
Message-ID: <bb4ebe24-1de5-82b8-001d-1c0f9f28861b@suse.com>
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number of
 vcpus per guest
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-7-jgross@suse.com>
 <87h7gx2lkt.fsf@vitty.brq.redhat.com>
 <1ddffb87-a6a2-eba3-3f34-cf606a2ecba2@suse.com>
 <878s292k75.fsf@vitty.brq.redhat.com>
 <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
 <8735sh2fr7.fsf@vitty.brq.redhat.com>
In-Reply-To: <8735sh2fr7.fsf@vitty.brq.redhat.com>

--GvcaP8GkYIMbygjk2yW19biht3REG7Obc
Content-Type: multipart/mixed;
 boundary="------------CF9085161ADCB4335B0C165B"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CF9085161ADCB4335B0C165B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 14.07.21 15:21, Vitaly Kuznetsov wrote:
> Juergen Gross <jgross@suse.com> writes:
>=20
>> On 14.07.21 13:45, Vitaly Kuznetsov wrote:
>>
>>> Personally, I'd vote for introducing a 'ratio' parameter then so
>>> generally users will only have to set 'kvm.max_vcpus'.
>>
>> Okay.
>>
>> Default '4' then? Or '2 ^ (topology_levels - 2)' (assuming a
>> topology_level of 3 on Intel: thread/core/socket and 4 on EPYC:
>> thread/core/package/socket).
>=20
> I'd suggest we default to '4' for both Intel and AMD as we haven't give=
n
> up completely on cross-vendor VMs (running AMD VMs on Intel CPUs and
> vice versa). It would be great to leave a comment where the number come=
s
> from of course.
>=20

Thinking more about it I believe it would be better to make the
parameter something like "additional vcpu-id bits" with a default of
topology_levels - 2 (cross-vendor VMs are so special that I think the
need to specify another value explicitly in this case is acceptable).

Reasons are:

- the ability to specify factor values not being a power of 2 is weird
- just specifying the additional number of bits would lead to compatible
   behavior (e.g. a max vcpu-id of 1023 with max_vcpus being 288 and the
   default value of 1)
- the max vcpu-id should (normally) be 2^n - 1


Juergen

--------------CF9085161ADCB4335B0C165B
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

--------------CF9085161ADCB4335B0C165B--

--GvcaP8GkYIMbygjk2yW19biht3REG7Obc--

--gCj3IbJEMvpHW8XTVyNSugAMzxOfv2zEk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmExyDcFAwAAAAAACgkQsN6d1ii/Ey9t
3Qf/RAxsf3SKfMMMISWAfi1cq8UDoIdCQMaRA+0i7uYijw+U+zd1PklJwxiq5xxxrU9w8FiXb1a8
Upq9Xf4oaMes0Ab+aXP6pecYDhbKvZC18m2pRRPRrFX6F03KH9jQPr/FZkuMVvxcTevtwlapAoDf
wln7J3hLDkitPGr1xF+ed40fdcQL/f0qe/EnapN1fFObqNrQ+MEwNdlIu4su20FZNcTP9S2+Fy8B
wvAfibTIe5+IXq3sXvYR9SZaeU9TjU4/PT7UEGhJrcPjKLVfOb842GOS9cmf6Y/Up88X4AOkvPfI
19pNBbNZiVEy5bKggQfgP2Qp0UaynovBB67nfpKQ0w==
=1QXQ
-----END PGP SIGNATURE-----

--gCj3IbJEMvpHW8XTVyNSugAMzxOfv2zEk--
