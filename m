Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9D44A9A5
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 09:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbhKIIts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 03:49:48 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40420 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244489AbhKIItr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 03:49:47 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D81D71FDB7;
        Tue,  9 Nov 2021 08:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636447620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oU9XWgJQlaJrXpUT4FnrNjHqt2Qw25sadfWuBpjts30=;
        b=fmcvaFxniPGxoGVm+/rtu7J2uWZvWLkiyn30Cz0PZlm1Q29CWkcoD1iBz1yHK8V5j6d54D
        kGcBULlIN4CFMugjYjpjkqnF5o4MHXY4UpPqEp46fYJCdX9qflvp20IsNJltQ2Ap+E/KlR
        9r+0HSPIOYe3OnvctsNX/OAlqTVGaiI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 65EBA13ADA;
        Tue,  9 Nov 2021 08:47:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CBQUF4Q1imHUPQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 09 Nov 2021 08:47:00 +0000
Subject: Re: [PATCH 1/2] x86/kvm: revert commit 76b4f357d0e7d8f6f00
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210913135745.13944-1-jgross@suse.com>
 <20210913135745.13944-2-jgross@suse.com>
 <CANgfPd-DjawJpZDAFzwS54yukPSsUAU+rWsais2_FCeLCZuY0A@mail.gmail.com>
 <CANgfPd-njeSYSiytAYEXLG8wwTmLBA6viV7YAHj5uVeukPde=g@mail.gmail.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <c4f051e2-2c85-d367-549a-d5ad34af7a13@suse.com>
Date:   Tue, 9 Nov 2021 09:46:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd-njeSYSiytAYEXLG8wwTmLBA6viV7YAHj5uVeukPde=g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zmgKaTk2yWz1VVGsXgq6m6uw49XCBq6Ud"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zmgKaTk2yWz1VVGsXgq6m6uw49XCBq6Ud
Content-Type: multipart/mixed; boundary="Erc7fE3CVEmgkMtiaUCbT4Wdi5tnCgAsq";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Ben Gardon <bgardon@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Eduardo Habkost <ehabkost@redhat.com>
Message-ID: <c4f051e2-2c85-d367-549a-d5ad34af7a13@suse.com>
Subject: Re: [PATCH 1/2] x86/kvm: revert commit 76b4f357d0e7d8f6f00
References: <20210913135745.13944-1-jgross@suse.com>
 <20210913135745.13944-2-jgross@suse.com>
 <CANgfPd-DjawJpZDAFzwS54yukPSsUAU+rWsais2_FCeLCZuY0A@mail.gmail.com>
 <CANgfPd-njeSYSiytAYEXLG8wwTmLBA6viV7YAHj5uVeukPde=g@mail.gmail.com>
In-Reply-To: <CANgfPd-njeSYSiytAYEXLG8wwTmLBA6viV7YAHj5uVeukPde=g@mail.gmail.com>

--Erc7fE3CVEmgkMtiaUCbT4Wdi5tnCgAsq
Content-Type: multipart/mixed;
 boundary="------------C5E462C3B90A44332A89644F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C5E462C3B90A44332A89644F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.11.21 21:15, Ben Gardon wrote:
> On Mon, Nov 8, 2021 at 12:14 PM Ben Gardon <bgardon@google.com> wrote:
>>
>> On Mon, Sep 13, 2021 at 7:51 AM Juergen Gross <jgross@suse.com> wrote:=

>>>
>>> Commit 76b4f357d0e7d8f6f00 ("x86/kvm: fix vcpu-id indexed array sizes=
")
>>> has wrong reasoning, as KVM_MAX_VCPU_ID is not defining the maximum
>>> allowed vcpu-id as its name suggests, but the number of vcpu-ids.
>>>
>>> So revert this patch again.
>>>
>>> Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>> The original commit 76b4f357d0e7d8f6f00 CC'ed Stable but this revert
>> does not. Looking at the stable branches, I see the original has been
>> reverted but this hasn't. Should this be added to Stable as well?
>=20
> *the original has been incorporated into the stable branches but this h=
asn't.

Just yesterday I received mails that this patch has been added to the
stable branches.


Juergen

--------------C5E462C3B90A44332A89644F
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

--------------C5E462C3B90A44332A89644F--

--Erc7fE3CVEmgkMtiaUCbT4Wdi5tnCgAsq--

--zmgKaTk2yWz1VVGsXgq6m6uw49XCBq6Ud
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGKNYMFAwAAAAAACgkQsN6d1ii/Ey/v
mgf6AjsXky5cdrgdticRqBFH8gwzSfijuppud7XFCd+yQ9Tnoqxs7skYvoYAveHNjdJp5rWLwsMy
Wtnqv5K2aYavhu+EGlt0gBFuT17Es95uda09SjW+inA1IL3BnreTCqSgCM6m/kypno+UNhfa+YUe
qha6M5PN5WwKtfZka/ctIDkhoQoDS6sM5F0m6S2INK6XTVt/06CenfhKdxPIRnlbONIouxKB8Nrs
9QpkfZw0PMC+6HjylYGpPmwVsrv9OHcDRp2oTC3zidfqRakg3cKMND/7F1t6KMMVqT236Jbi+9/h
jlslWSzoHQ3Uv9hEowvzuUVlfyQFQnU3tLPNY+FcNQ==
=PTv5
-----END PGP SIGNATURE-----

--zmgKaTk2yWz1VVGsXgq6m6uw49XCBq6Ud--
