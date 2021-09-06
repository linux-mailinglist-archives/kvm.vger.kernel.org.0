Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07574015D1
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 06:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhIFEs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 00:48:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57918 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbhIFEs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 00:48:26 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 44F99220B9;
        Mon,  6 Sep 2021 04:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630903641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OXt/kb3J0ajJK0Mr7oTdfIxp0ZyFKkK0TKL1fz1LMPA=;
        b=k2aLrchRJPoqKc1DPTHI7xdzZrgpM6X1TLqlEFvj+1v/wctUx1XfgrfiiqnUr2G66EJ3LD
        fLkd73pjxyU5FKXzFjLcMidZy5t9kYftArQZY9NLCGiIoHE5ye+GmrCvP6sBQ5nBmv44KI
        U0YRtfZx23Yf6ojqtThfoNedtopEkwE=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B02211332A;
        Mon,  6 Sep 2021 04:47:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id qw8wKVidNWFwQwAAGKfGzw
        (envelope-from <jgross@suse.com>); Mon, 06 Sep 2021 04:47:20 +0000
Subject: Re: [PATCH v2 6/6] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
To:     Yao Yuan <yaoyuan0329os@gmail.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, ehabkost@redhat.com,
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
 <20210903130808.30142-7-jgross@suse.com>
 <20210906004510.3r3cgigswbfivkeg@sapienza>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <f5410f97-222a-a91d-908f-2ec8e9f97ea5@suse.com>
Date:   Mon, 6 Sep 2021 06:47:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210906004510.3r3cgigswbfivkeg@sapienza>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ixODA2n7R2faenxQGqDkcgN3OXGYOmOaS"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ixODA2n7R2faenxQGqDkcgN3OXGYOmOaS
Content-Type: multipart/mixed; boundary="sqxKVVCV5sfQIgTHXtqglg4pYp89Hgddf";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, maz@kernel.org, ehabkost@redhat.com,
 Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <f5410f97-222a-a91d-908f-2ec8e9f97ea5@suse.com>
Subject: Re: [PATCH v2 6/6] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-7-jgross@suse.com>
 <20210906004510.3r3cgigswbfivkeg@sapienza>
In-Reply-To: <20210906004510.3r3cgigswbfivkeg@sapienza>

--sqxKVVCV5sfQIgTHXtqglg4pYp89Hgddf
Content-Type: multipart/mixed;
 boundary="------------61A99CEC643528FA7B1FF49E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------61A99CEC643528FA7B1FF49E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 06.09.21 02:45, Yao Yuan wrote:
> On Fri, Sep 03, 2021 at 03:08:07PM +0200, Juergen Gross wrote:
>> Today the maximum number of vcpus of a kvm guest is set via a #define
>> in a header file.
>>
>> In order to support higher vcpu numbers for guests without generally
>> increasing the memory consumption of guests on the host especially on
>> very large systems add a boot parameter for specifying the number of
>> allowed vcpus for guests.
>>
>> The default will still be the current setting of 288. The value 0 has
>> the special meaning to limit the number of possible vcpus to the
>> number of possible cpus of the host.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
>>   arch/x86/include/asm/kvm_host.h                 | 5 ++++-
>>   arch/x86/kvm/x86.c                              | 9 ++++++++-
>>   3 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documen=
tation/admin-guide/kernel-parameters.txt
>> index 37e194299311..b9641c9989ef 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2435,6 +2435,13 @@
>>            feature (tagged TLBs) on capable Intel chips.
>>            Default is 1 (enabled)
>>
>> +	kvm.max_vcpus=3D	[KVM,X86] Set the maximum allowed numbers of vcpus =
per
>> +			guest. The special value 0 sets the limit to the number
>> +			of physical cpus possible on the host (including not
>> +			yet hotplugged cpus). Higher values will result in
>> +			slightly higher memory consumption per guest.
>> +			Default: 288
>> +
>>    kvm.vcpu_id_add_bits=3D
>>            [KVM,X86] The vcpu-ids of guests are sparse, as they
>>            are constructed by bit-wise concatenation of the ids of
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
>> index 6c28d0800208..a4ab387b0e1c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -38,7 +38,8 @@
>>
>>   #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>>
>> -#define KVM_MAX_VCPUS 288
>> +#define KVM_DEFAULT_MAX_VCPUS 288
>> +#define KVM_MAX_VCPUS max_vcpus
>>   #define KVM_SOFT_MAX_VCPUS 240
>>   #define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
>>   /* memory slots that are not exposed to userspace */
>> @@ -1588,6 +1589,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>>   extern u64  kvm_default_tsc_scaling_ratio;
>>   /* bus lock detection supported? */
>>   extern bool kvm_has_bus_lock_exit;
>> +/* maximum number of vcpus per guest */
>> +extern unsigned int max_vcpus;
>>   /* maximum vcpu-id */
>>   unsigned int kvm_max_vcpu_id(void);
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ff142b6dd00c..49c3d91c559e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -188,9 +188,13 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_I=
WUSR);
>>   static int __read_mostly vcpu_id_add_bits =3D -1;
>>   module_param(vcpu_id_add_bits, int, S_IRUGO);
>>
>> +unsigned int __read_mostly max_vcpus =3D KVM_DEFAULT_MAX_VCPUS;
>> +module_param(max_vcpus, uint, S_IRUGO);
>> +EXPORT_SYMBOL_GPL(max_vcpus);
>> +
>>   unsigned int kvm_max_vcpu_id(void)
>>   {
>> -	int n_bits =3D fls(KVM_MAX_VCPUS - 1);
>> +	int n_bits =3D fls(max_vcpus - 1);
>=20
> A quesintion here: the parameter "vcpu_id_add_bits" also depends
> on the "max_vcpus", we can't calculate the "vcpu_id_add_bits" from
> "max_vcpus" because KVM has no topologically knowledge to determine
> bits needed for each socket/core/thread level, right?

Correct.


Juergen

--------------61A99CEC643528FA7B1FF49E
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

--------------61A99CEC643528FA7B1FF49E--

--sqxKVVCV5sfQIgTHXtqglg4pYp89Hgddf--

--ixODA2n7R2faenxQGqDkcgN3OXGYOmOaS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE1nVgFAwAAAAAACgkQsN6d1ii/Ey+x
bwgAmsT4XhIk5BvNcqhl4D1qHQUXZAZ/AQNdioURmtSzRP6Tb+caqofu0pWMiNpifpqHQ8hQPPYN
+OfesDeTqpFCOxwBXVDE8HjmKx4deEvA+Durvjln7553FJf8XUKNc3aCl8JT3gZPNDhN+lb4eGw2
MW9sZqkjnDHvJPKSW/BCHXY4zH8oRXV9dhBwDDq7Uq8uwjFPc5V3HjpgUvwGt5c23neJlgg58a0T
nQp6VMZBptW386vIariWY4eqU5hx1Uw66DTmVVUmCgdFE0IIZ7TBXQce+XYHffF8O4aa4aM2HhcZ
l9GzootPfba95ZEFXcI14icwljF7zUx+WlijyKmFsQ==
=fRaP
-----END PGP SIGNATURE-----

--ixODA2n7R2faenxQGqDkcgN3OXGYOmOaS--
