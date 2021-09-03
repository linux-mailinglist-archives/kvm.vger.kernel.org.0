Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31AA4000CB
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347375AbhICNyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:54:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53728 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbhICNyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:54:03 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3C67F1FD7E;
        Fri,  3 Sep 2021 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630677182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQlJqGf1NvNUladxzaGNCaT4FNE8+bkOZ143wQYZDEU=;
        b=vQE1dA9mqhFqOkfD1QLFr6h1gjNYPFWgiPDVYWmAbU2hatW8DMjf8HOGXuZabCctbQSDlT
        IP+2NcggkbZAVtcFB/GOzouv4PO1UMDuodCAwrBsIh1ROY1rxYQt508F4zPvftiWQBPBIC
        YRpfzPLTF7bzvMBNzeMtDWSTVhl0PNI=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 90CDF13736;
        Fri,  3 Sep 2021 13:53:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id /5+IIb0oMmHeQwAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:53:01 +0000
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
 <874kb1n59j.fsf@vitty.brq.redhat.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
Message-ID: <a6b00e7f-5b8f-315d-1d3c-a8641f44f0c3@suse.com>
Date:   Fri, 3 Sep 2021 15:53:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <874kb1n59j.fsf@vitty.brq.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uERx4rOxpFczsHBoGYHjHYqsoQOU81omb"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uERx4rOxpFczsHBoGYHjHYqsoQOU81omb
Content-Type: multipart/mixed; boundary="wbZOAq6jNmUEMgRDQMpZDeEbQUFI7KMBA";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
 x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maz@kernel.org, ehabkost@redhat.com, Jonathan Corbet <corbet@lwn.net>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <a6b00e7f-5b8f-315d-1d3c-a8641f44f0c3@suse.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
 <874kb1n59j.fsf@vitty.brq.redhat.com>
In-Reply-To: <874kb1n59j.fsf@vitty.brq.redhat.com>

--wbZOAq6jNmUEMgRDQMpZDeEbQUFI7KMBA
Content-Type: multipart/mixed;
 boundary="------------35AFCAB774DF32899366464D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------35AFCAB774DF32899366464D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 03.09.21 15:43, Vitaly Kuznetsov wrote:
> Juergen Gross <jgross@suse.com> writes:
>=20
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
>>   .../admin-guide/kernel-parameters.txt         | 18 ++++++++++++
>>   arch/x86/include/asm/kvm_host.h               |  4 ++-
>>   arch/x86/kvm/ioapic.c                         | 12 +++++++-
>>   arch/x86/kvm/ioapic.h                         |  4 +--
>>   arch/x86/kvm/x86.c                            | 29 +++++++++++++++++=
++
>>   5 files changed, 63 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documen=
tation/admin-guide/kernel-parameters.txt
>> index 84dc5790741b..37e194299311 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2435,6 +2435,24 @@
>>   			feature (tagged TLBs) on capable Intel chips.
>>   			Default is 1 (enabled)
>>  =20
>> +	kvm.vcpu_id_add_bits=3D
>> +			[KVM,X86] The vcpu-ids of guests are sparse, as they
>> +			are constructed by bit-wise concatenation of the ids of
>> +			the different topology levels (sockets, cores, threads).
>> +
>> +			This parameter specifies how many additional bits the
>> +			maximum vcpu-id needs compared to the maximum number of
>> +			vcpus.
>> +
>> +			Normally this value is the number of topology levels
>> +			without the threads level and without the highest
>> +			level.
>> +
>> +			The special value -1 can be used to support guests
>> +			with the same topology is the host.
>> +
>> +			Default: -1
>> +
>>   	l1d_flush=3D	[X86,INTEL]
>>   			Control mitigation for L1D based snooping vulnerability.
>>  =20
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
>> index af6ce8d4c86a..3513edee8e22 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -39,7 +39,7 @@
>>  =20
>>   #define KVM_MAX_VCPUS 288
>>   #define KVM_SOFT_MAX_VCPUS 240
>> -#define KVM_MAX_VCPU_ID 1023
>> +#define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
>>   /* memory slots that are not exposed to userspace */
>>   #define KVM_PRIVATE_MEM_SLOTS 3
>>  =20
>> @@ -1588,6 +1588,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>>   extern u64  kvm_default_tsc_scaling_ratio;
>>   /* bus lock detection supported? */
>>   extern bool kvm_has_bus_lock_exit;
>> +/* maximum vcpu-id */
>> +unsigned int kvm_max_vcpu_id(void);
>>  =20
>>   extern u64 kvm_mce_cap_supported;
>>  =20
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index ff005fe738a4..52e8ea90c914 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -685,11 +685,21 @@ static const struct kvm_io_device_ops ioapic_mmi=
o_ops =3D {
>>   int kvm_ioapic_init(struct kvm *kvm)
>>   {
>>   	struct kvm_ioapic *ioapic;
>> +	size_t sz;
>>   	int ret;
>>  =20
>> -	ioapic =3D kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL_ACCOUNT);
>> +	sz =3D sizeof(struct kvm_ioapic) +
>> +	     sizeof(*ioapic->rtc_status.dest_map.map) *
>> +		    BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1) +
>> +	     sizeof(*ioapic->rtc_status.dest_map.vectors) *
>> +		    (KVM_MAX_VCPU_ID + 1);
>> +	ioapic =3D kzalloc(sz, GFP_KERNEL_ACCOUNT);
>>   	if (!ioapic)
>>   		return -ENOMEM;
>> +	ioapic->rtc_status.dest_map.map =3D (void *)(ioapic + 1);
>> +	ioapic->rtc_status.dest_map.vectors =3D
>> +		(void *)(ioapic->rtc_status.dest_map.map +
>> +			 BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1));
>>   	spin_lock_init(&ioapic->lock);
>>   	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);=

>>   	kvm->arch.vioapic =3D ioapic;
>> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
>> index bbd4a5d18b5d..623a3c5afad7 100644
>> --- a/arch/x86/kvm/ioapic.h
>> +++ b/arch/x86/kvm/ioapic.h
>> @@ -39,13 +39,13 @@ struct kvm_vcpu;
>>  =20
>>   struct dest_map {
>>   	/* vcpu bitmap where IRQ has been sent */
>> -	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
>> +	unsigned long *map;
>>  =20
>>   	/*
>>   	 * Vector sent to a given vcpu, only valid when
>>   	 * the vcpu's bit in map is set
>>   	 */
>> -	u8 vectors[KVM_MAX_VCPU_ID + 1];
>> +	u8 *vectors;
>>   };
>>  =20
>>  =20
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e5d5c5ed7dd4..6b6f38f0b617 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -78,6 +78,7 @@
>>   #include <asm/intel_pt.h>
>>   #include <asm/emulate_prefix.h>
>>   #include <asm/sgx.h>
>> +#include <asm/topology.h>
>>   #include <clocksource/hyperv_timer.h>
>>  =20
>>   #define CREATE_TRACE_POINTS
>> @@ -184,6 +185,34 @@ module_param(force_emulation_prefix, bool, S_IRUG=
O);
>>   int __read_mostly pi_inject_timer =3D -1;
>>   module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>>  =20
>> +static int __read_mostly vcpu_id_add_bits =3D -1;
>> +module_param(vcpu_id_add_bits, int, S_IRUGO);
>> +
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
>=20
> This assumes topology_max_die_per_package() can not be greater than 2,
> or 1 additional bit may not suffice, right?

No. Each topology level can at least add one additional bit. This
mechanism assumes that each level consumes not more bits as
necessary, so with e.g. a core count of 18 per die 5 bits are used,
and not more.

>=20
>> +	}
>> +
>> +	if (!n_bits)
>> +		n_bits =3D 1;
>=20
> Nitpick: AFAIU n_bits can't be zero here as KVM_MAX_VCPUS is still
> static. The last patch of the series, however, makes it possible when
> max_vcpus =3D 1 and vcpu_id_add_bits =3D 0. With this, I'd suggest to m=
ove
> the check to the last patch.

This is true only if no downstream has a patch setting KVM_MAX_VCPUS to
1. I'd rather be safe than sorry here, especially as it would be very
easy to miss this dependency.


Juergen

--------------35AFCAB774DF32899366464D
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

--------------35AFCAB774DF32899366464D--

--wbZOAq6jNmUEMgRDQMpZDeEbQUFI7KMBA--

--uERx4rOxpFczsHBoGYHjHYqsoQOU81omb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmEyKL0FAwAAAAAACgkQsN6d1ii/Ey+q
KggAi65M8OM65Tk17k7bHGToKOjhNNsnHxZ+p0IwGbeBbcJY1sh2hJLrAqI3q7i15Mn6ITAp2YCZ
KabwuQ3ctNZc3VTPDMwhb/U5QlaT7bwO59Cx1eopLxAbhLhd3Ku2PZuLyfCRgykiwRZlu2Mo0hmE
4bGSATJu1UDGwWmMRvP5FaB1jzOB1oCPC/3EWzQgpQk3msDpwT9MluabdyuHMaFopbNnuaoyGaPn
fj5j5TwwbLEvwjhQlBBtn/nQMMqkL+6x9NWKSFZ9HmcWhnoczh8nnzih5rzY9rNAQVsFdlFJmgRb
8jKVBjmhE4ebgPWpSCi4DnMA7hD/vAkJJFjmCccXVQ==
=Gmci
-----END PGP SIGNATURE-----

--uERx4rOxpFczsHBoGYHjHYqsoQOU81omb--
