Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1090B4015C5
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 06:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbhIFEre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 00:47:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36086 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbhIFErc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 00:47:32 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 608F21FEC0;
        Mon,  6 Sep 2021 04:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630903586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5WXZWDjsL6VCDzFfKsy+fr5w2Ib5Q48se+K6nAixw7A=;
        b=skiUEYbZPkGoKoSnNKDcWM2FTl6pRFomATdSKpYlwHm+RVUcnGhls0q3bU138VCdwYyHAn
        Rkh/CE3wMrsCbW8E6Q274XJ+Imtmo22cZt7aKVwITgcELWNkbAgZlhhDVBdi7D79TrR29m
        WcqcE3xs8V6NIepJ9N/RHBbbPcpCw8M=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id CB30A1332A;
        Mon,  6 Sep 2021 04:46:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id qWCDLyGdNWFDQwAAGKfGzw
        (envelope-from <jgross@suse.com>); Mon, 06 Sep 2021 04:46:25 +0000
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
 <20210903194824.lfjzeaab6ct72pxn@habkost.net>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
Message-ID: <2f7d511e-e846-e6a4-f180-987511518f42@suse.com>
Date:   Mon, 6 Sep 2021 06:46:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210903194824.lfjzeaab6ct72pxn@habkost.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qJYM4kX82J82dgMD9nuy8n4hbZ6zojjbg"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qJYM4kX82J82dgMD9nuy8n4hbZ6zojjbg
Content-Type: multipart/mixed; boundary="qU4uyZzhiMzt6qlPfC6tu7Ah3DhhJy0mE";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, maz@kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <2f7d511e-e846-e6a4-f180-987511518f42@suse.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
 <20210903194824.lfjzeaab6ct72pxn@habkost.net>
In-Reply-To: <20210903194824.lfjzeaab6ct72pxn@habkost.net>

--qU4uyZzhiMzt6qlPfC6tu7Ah3DhhJy0mE
Content-Type: multipart/mixed;
 boundary="------------0F5B31BAE14E271D71F849BD"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------0F5B31BAE14E271D71F849BD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 03.09.21 21:48, Eduardo Habkost wrote:
> On Fri, Sep 03, 2021 at 03:08:03PM +0200, Juergen Gross wrote:
>> Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is set
>> via a #define in a header file.
>>
>> In order to support higher vcpu-ids without generally increasing the
>> memory consumption of guests on the host (some guest structures contai=
n
>> arrays sized by KVM_MAX_VCPU_ID) add a boot parameter for adding some
>> bits to the vcpu-id. Additional bits are needed as the vcpu-id is
>> constructed via bit-wise concatenation of socket-id, core-id, etc.
>> As those ids maximum values are not always a power of 2, the vcpu-ids
>> are sparse.
>>
>> The additional number of bits needed is basically the number of
>> topology levels with a non-power-of-2 maximum value, excluding the top=

>> most level.
>>
>> The default value of the new parameter will be to take the correct
>> setting from the host's topology.
>=20
> Having the default depend on the host topology makes the host
> behaviour unpredictable (which might be a problem when migrating
> VMs from another host with a different topology).  Can't we just
> default to 2?

Okay, fine with me.

>=20
>>
>> Calculating the maximum vcpu-id dynamically requires to allocate the
>> arrays using KVM_MAX_VCPU_ID as the size dynamically.
>>
>> Signed-of-by: Juergen Gross <jgross@suse.com>
>> ---
>> V2:
>> - switch to specifying additional bits (based on comment by Vitaly
>>    Kuznetsov)
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
> [...]
>>   #define KVM_MAX_VCPUS 288
>>   #define KVM_SOFT_MAX_VCPUS 240
>> -#define KVM_MAX_VCPU_ID 1023
>> +#define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
> [...]
>> +unsigned int kvm_max_vcpu_id(void)
>> +{
>> +	int n_bits =3D fls(KVM_MAX_VCPUS - 1);
>> +
>> +	if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
>> +		pr_err("Invalid value of vcpu_id_add_bits=3D%d parameter!\n",
>> +		       vcpu_id_add_bits);
>> +		vcpu_id_add_bits =3D -1;
>> +	}
>> +
>> +	if (vcpu_id_add_bits >=3D 0) {
>> +		n_bits +=3D vcpu_id_add_bits;
>> +	} else {
>> +		n_bits++;		/* One additional bit for core level. */
>> +		if (topology_max_die_per_package() > 1)
>> +			n_bits++;	/* One additional bit for die level. */
>> +	}
>> +
>> +	if (!n_bits)
>> +		n_bits =3D 1;
>> +
>> +	return (1U << n_bits) - 1;
>=20
> The largest possible VCPU ID is not KVM_MAX_VCPU_ID,
> it's (KVM_MAX_VCPU_ID - 1).  This is enforced by
> kvm_vm_ioctl_create_vcpu().
>=20
> That would mean KVM_MAX_VCPU_ID should be (1 << n_bits) instead
> of ((1 << n_bits) - 1), wouldn't it?

Oh, indeed. I have been fooled by the IMO bad naming of this macro.

The current value 1023 suggests it is not only me having been fooled.

Shouldn't it be named "KVM_MAX_VCPU_IDS" instead?


Juergen

--------------0F5B31BAE14E271D71F849BD
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

--------------0F5B31BAE14E271D71F849BD--

--qU4uyZzhiMzt6qlPfC6tu7Ah3DhhJy0mE--

--qJYM4kX82J82dgMD9nuy8n4hbZ6zojjbg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE1nSEFAwAAAAAACgkQsN6d1ii/Ey/F
iwf+JakrFmIMZA1TmRtmVd91vNMvvhViqIM50lB0PwvHQil927rdUMhZt3zkycnFGG8cKZt9pr4s
3slKFOOABizkHQPY+PxcZvkTqb08IhIoUN7aXcg4nPkTzqV7PCU7fpO8szHWNA8pcPIwWLF5KStK
dNRVlhZcplKOXKdO6U2zK/cUrM0IkzcW4RSOmOI58VNgoO1RDC2h6ATx9llKqbw1nv0/s/31vbQ/
2bhMMYd55xv+2tN8fqZXJ/1lalwOokXn5WlVmoet5nx779ZFSrl+Zi0H5DgmSJNO1iImbuf+KYCx
sezN3deb7YtLXlhRe0WirXZv+6pzScmzbOHryDVQUA==
=u0+B
-----END PGP SIGNATURE-----

--qJYM4kX82J82dgMD9nuy8n4hbZ6zojjbg--
