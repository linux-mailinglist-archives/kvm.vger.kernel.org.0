Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DCA4015B7
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 06:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhIFEen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 00:34:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35196 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIFEem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 00:34:42 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 527B41FEC6;
        Mon,  6 Sep 2021 04:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630902817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6KesdnObrJg5+ClNtCWSOtVfuLB+kzMDZMASkULnEk=;
        b=GcXVXkEIu9iocw5lg4Fn8QY09733juIXOTrEcNOD+fEC2RvJqHbr8aH14M72cJYK4OLGNb
        2WA/YTLwDnbsaEINkGU+ZVDrAlYndQ9kU0Uxg92tBgfltSyfeSRxi3TvJJuEd/ecI9Kd80
        KoOzHB2hBsh8Ryww+lKkE8MU1GrS3hQ=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 956EC1332A;
        Mon,  6 Sep 2021 04:33:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id yi82IiCaNWHEQQAAGKfGzw
        (envelope-from <jgross@suse.com>); Mon, 06 Sep 2021 04:33:36 +0000
Subject: Re: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ehabkost@redhat.com, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-6-jgross@suse.com> <871r65wwk7.wl-maz@kernel.org>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <37699e98-9a47-732d-8522-daa90f35c52f@suse.com>
Date:   Mon, 6 Sep 2021 06:33:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <871r65wwk7.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3dKagCqFG6FiVYjedP4HdfuCcShAmNIje"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3dKagCqFG6FiVYjedP4HdfuCcShAmNIje
Content-Type: multipart/mixed; boundary="yUBA9nuSqFZ1BE2ukBhqlNbvtfSdlrTKR";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 ehabkost@redhat.com, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
Message-ID: <37699e98-9a47-732d-8522-daa90f35c52f@suse.com>
Subject: Re: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-6-jgross@suse.com> <871r65wwk7.wl-maz@kernel.org>
In-Reply-To: <871r65wwk7.wl-maz@kernel.org>

--yUBA9nuSqFZ1BE2ukBhqlNbvtfSdlrTKR
Content-Type: multipart/mixed;
 boundary="------------C4707903CEBE0F68C86AD315"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C4707903CEBE0F68C86AD315
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 03.09.21 16:41, Marc Zyngier wrote:
> On Fri, 03 Sep 2021 14:08:06 +0100,
> Juergen Gross <jgross@suse.com> wrote:
>>
>> Prepare support of very large vcpu numbers per guest by moving the
>> vcpu pointer array out of struct kvm.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> V2:
>> - rebase to new kvm_arch_free_vm() implementation
>> ---
>>   arch/arm64/kvm/arm.c            | 21 +++++++++++++++++++--
>>   arch/x86/include/asm/kvm_host.h |  5 +----
>>   arch/x86/kvm/x86.c              | 18 ++++++++++++++++++
>>   include/linux/kvm_host.h        | 17 +++++++++++++++--
>>   4 files changed, 53 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 38fff5963d9f..8bb5caeba007 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -293,10 +293,27 @@ long kvm_arch_dev_ioctl(struct file *filp,
>>  =20
>>   struct kvm *kvm_arch_alloc_vm(void)
>>   {
>> +	struct kvm *kvm;
>> +
>> +	if (!has_vhe())
>> +		kvm =3D kzalloc(sizeof(struct kvm), GFP_KERNEL);
>> +	else
>> +		kvm =3D vzalloc(sizeof(struct kvm));
>> +
>> +	if (!kvm)
>> +		return NULL;
>> +
>>   	if (!has_vhe())
>> -		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
>> +		kvm->vcpus =3D kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
>> +	else
>> +		kvm->vcpus =3D vzalloc(KVM_MAX_VCPUS * sizeof(void *));
>> +
>> +	if (!kvm->vcpus) {
>> +		kvm_arch_free_vm(kvm);
>> +		kvm =3D NULL;
>> +	}
>>  =20
>> -	return vzalloc(sizeof(struct kvm));
>> +	return kvm;
>>   }
>>  =20
>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
>> index f16fadfc030a..6c28d0800208 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1517,10 +1517,7 @@ static inline void kvm_ops_static_call_update(v=
oid)
>>   }
>>  =20
>>   #define __KVM_HAVE_ARCH_VM_ALLOC
>> -static inline struct kvm *kvm_arch_alloc_vm(void)
>> -{
>> -	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZER=
O);
>> -}
>> +struct kvm *kvm_arch_alloc_vm(void);
>>  =20
>>   #define __KVM_HAVE_ARCH_VM_FREE
>>   void kvm_arch_free_vm(struct kvm *kvm);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cc552763f0e4..ff142b6dd00c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11126,6 +11126,24 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu,=
 int cpu)
>>   	static_call(kvm_x86_sched_in)(vcpu, cpu);
>>   }
>>  =20
>> +struct kvm *kvm_arch_alloc_vm(void)
>> +{
>> +	struct kvm *kvm;
>> +
>> +	kvm =3D __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZE=
RO);
>> +	if (!kvm)
>> +		return NULL;
>> +
>> +	kvm->vcpus =3D __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
>> +			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +	if (!kvm->vcpus) {
>> +		vfree(kvm);
>> +		kvm =3D NULL;
>> +	}
>> +
>> +	return kvm;
>> +}
>> +
>>   void kvm_arch_free_vm(struct kvm *kvm)
>>   {
>>   	kfree(to_kvm_hv(kvm)->hv_pa_pg);
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index d75e9c2a00b1..9e2a5f1c6f54 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -536,7 +536,7 @@ struct kvm {
>>   	struct mutex slots_arch_lock;
>>   	struct mm_struct *mm; /* userspace tied to this vm */
>>   	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>> -	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> +	struct kvm_vcpu **vcpus;
>=20
> At this stage, I really wonder why we are not using an xarray instead.
>=20
> I wrote this [1] a while ago, and nothing caught fire. It was also a
> net deletion of code...

Indeed, I'd prefer that solution!

Are you fine with me swapping my patch with yours in the series?


Juergen


--------------C4707903CEBE0F68C86AD315
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

--------------C4707903CEBE0F68C86AD315--

--yUBA9nuSqFZ1BE2ukBhqlNbvtfSdlrTKR--

--3dKagCqFG6FiVYjedP4HdfuCcShAmNIje
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE1mh8FAwAAAAAACgkQsN6d1ii/Ey95
Jgf+LbjnMKAdUVgG3BhFJfsNSzkdPVAPn5TQArYk2Sp2212QW26YQWoc53ZcgTbminY0H8kil7wo
rSHpgVcn/QeA0pc+c0u7K6ELL9G1qUiXRm4zzyxQBcACcNXo608G9lCKKnCcosErejmW0SxcDYq4
zqKTb3V+u16Y5p7KtE/DfpmhOyj7sje/XWQJVBrnC9V1fwKHOYXddjOnE5gcUUrNlqfmhmmwVRyt
oqGszCIy3BJtW5IeSbPndeZuxOCg78vUXRpMjzCPSsyx2Qf53ORR16UYTH6W7SkNYyezq2p49S1/
dsa969OK6dmF/t4wAqKcr4qbNzycazW+5iZSq5yJdQ==
=jgiO
-----END PGP SIGNATURE-----

--3dKagCqFG6FiVYjedP4HdfuCcShAmNIje--
