Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50745555D
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 08:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243650AbhKRHTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 02:19:05 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51820 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbhKRHTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 02:19:04 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6B3D41FD35;
        Thu, 18 Nov 2021 07:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637219763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=baFEGAxsiysEjituzoq1WKr6k81T1kykSLl98bT+ZtA=;
        b=EmojhTeMyOI2wPZyDTbK7zRZspKSlUjvv+ksQzQS6RbR/OkTMWHv5wMKu3TU514ioc6LVL
        70HAF5aJVionOlTpk2gOO31+goYZo5bCHs4EnGQrtSzB70yOA0ERjdyQBO+7VoNTR/oXOC
        yUngV3pyFpUBlYXTzf8y1RfLL7CGmt4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1CFA13CD1;
        Thu, 18 Nov 2021 07:16:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Kpc4ObL9lWFMOAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 07:16:02 +0000
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
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
Message-ID: <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com>
Date:   Thu, 18 Nov 2021 08:16:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YZVsnZ8e7cXls2P2@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Vgyb05MMDPjuEojw0H7LxgtMNmA3JgZh"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Vgyb05MMDPjuEojw0H7LxgtMNmA3JgZh
Content-Type: multipart/mixed; boundary="dsGLdNPIr8n6VxWUzBTItEGvjSgM9i7Lt";
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
Message-ID: <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-5-jgross@suse.com> <YZVsnZ8e7cXls2P2@google.com>
In-Reply-To: <YZVsnZ8e7cXls2P2@google.com>

--dsGLdNPIr8n6VxWUzBTItEGvjSgM9i7Lt
Content-Type: multipart/mixed;
 boundary="------------4053FBC510D74F5E561DEA81"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------4053FBC510D74F5E561DEA81
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 17.11.21 21:57, Sean Christopherson wrote:
> On Tue, Nov 16, 2021, Juergen Gross wrote:
>> Today the maximum number of vcpus of a kvm guest is set via a #define
>> in a header file.
>>
>> In order to support higher vcpu numbers for guests without generally
>> increasing the memory consumption of guests on the host especially on
>> very large systems add a boot parameter for specifying the number of
>> allowed vcpus for guests.
>>
>> The default will still be the current setting of 1024. The value 0 has=

>> the special meaning to limit the number of possible vcpus to the
>> number of possible cpus of the host.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> V3:
>> - rebase
>> ---
>>   Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
>>   arch/x86/include/asm/kvm_host.h                 | 5 ++++-
>>   arch/x86/kvm/x86.c                              | 9 ++++++++-
>>   3 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documen=
tation/admin-guide/kernel-parameters.txt
>> index e269c3f66ba4..409a72c2d91b 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2445,6 +2445,13 @@
>>   			feature (tagged TLBs) on capable Intel chips.
>>   			Default is 1 (enabled)
>>  =20
>> +	kvm.max_vcpus=3D	[KVM,X86] Set the maximum allowed numbers of vcpus =
per
>> +			guest. The special value 0 sets the limit to the number
>> +			of physical cpus possible on the host (including not
>> +			yet hotplugged cpus). Higher values will result in
>> +			slightly higher memory consumption per guest.
>> +			Default: 1024
>=20
> Rather than makes this a module param, I would prefer to start with the=
 below
> patch (originally from TDX pre-enabling) and then wire up a way for use=
rspace to
> _lower_ the max on a per-VM basis, e.g. add a capability.
>=20
> VMs largely fall into two categories: (1) the max number of vCPUs is kn=
own prior
> to VM creation, or (2) the max number of vCPUs is unbounded (up to KVM'=
s hard
> limit), e.g. for container-style use cases where "vCPUs" are created on=
-demand in
> response to the "guest" creating a new task.
>=20
> For #1, a per-VM control lets userspace lower the limit to the bare min=
imum.  For
> #2, neither the module param nor the per-VM control is likely to be use=
ful, but
> a per-VM control does let mixed environments (both #1 and #2 VMs) lower=
 the limits
> for compatible VMs, whereas a module param must be set to the max of an=
y potential VM.

The main reason for this whole series is a request by a partner
to enable huge VMs on huge machines (huge meaning thousands of
vcpus on thousands of physical cpus).

Making this large number a compile time setting would hurt all
the users who have more standard requirements by allocating the
needed resources even on small systems, so I've switched to a boot
parameter in order to enable those huge numbers only when required.

With Marc's series to use an xarray for the vcpu pointers only the
bitmaps for sending IRQs to vcpus are left which need to be sized
according to the max vcpu limit. Your patch below seems to be fine, but
doesn't help for that case.


Juergen

>=20
>  From 0593cb4f73a6c3f0862f9411f0e14f00671f59ae Mon Sep 17 00:00:00 2001=

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Fri, 2 Jul 2021 15:04:27 -0700
> Subject: [PATCH] KVM: Add max_vcpus field in common 'struct kvm'
>=20
> Move arm's per-VM max_vcpus field into the generic "struct kvm", and us=
e
> it to check vcpus_created in the generic code instead of checking only
> the hardcoded absolute KVM-wide max.  x86 TDX guests will reuse the
> generic check verbatim, as the max number of vCPUs for a TDX guest is
> user defined at VM creation and immutable thereafter.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 ---
>   arch/arm64/kvm/arm.c              | 7 ++-----
>   arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
>   include/linux/kvm_host.h          | 1 +
>   virt/kvm/kvm_main.c               | 3 ++-
>   5 files changed, 8 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> index 4be8486042a7..b51e1aa6ae27 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -108,9 +108,6 @@ struct kvm_arch {
>   	/* VTCR_EL2 value for this VM */
>   	u64    vtcr;
>=20
> -	/* The maximum number of vCPUs depends on the used GIC model */
> -	int max_vcpus;
> -
>   	/* Interrupt controller */
>   	struct vgic_dist	vgic;
>=20
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f5490afe1ebf..97c3b83235b4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -153,7 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
>   	kvm_vgic_early_init(kvm);
>=20
>   	/* The maximum number of VCPUs is limited by the host's GIC model */=

> -	kvm->arch.max_vcpus =3D kvm_arm_default_max_vcpus();
> +	kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
>=20
>   	set_default_spectre(kvm);
>=20
> @@ -228,7 +228,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>   	case KVM_CAP_MAX_VCPUS:
>   	case KVM_CAP_MAX_VCPU_ID:
>   		if (kvm)
> -			r =3D kvm->arch.max_vcpus;
> +			r =3D kvm->max_vcpus;
>   		else
>   			r =3D kvm_arm_default_max_vcpus();
>   		break;
> @@ -304,9 +304,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsign=
ed int id)
>   	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
>   		return -EBUSY;
>=20
> -	if (id >=3D kvm->arch.max_vcpus)
> -		return -EINVAL;
> -
>   	return 0;
>   }
>=20
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic=
-init.c
> index 0a06d0648970..906aee52f2bc 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -97,11 +97,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   	ret =3D 0;
>=20
>   	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
> -		kvm->arch.max_vcpus =3D VGIC_V2_MAX_CPUS;
> +		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
>   	else
> -		kvm->arch.max_vcpus =3D VGIC_V3_MAX_CPUS;
> +		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
>=20
> -	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
> +	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
>   		ret =3D -E2BIG;
>   		goto out_unlock;
>   	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 60a35d9fe259..5f56516e2f5a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -566,6 +566,7 @@ struct kvm {
>   	 * and is accessed atomically.
>   	 */
>   	atomic_t online_vcpus;
> +	int max_vcpus;
>   	int created_vcpus;
>   	int last_boosted_vcpu;
>   	struct list_head vm_list;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..e509b963651c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1052,6 +1052,7 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe)
>   	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>=20
>   	INIT_LIST_HEAD(&kvm->devices);
> +	kvm->max_vcpus =3D KVM_MAX_VCPUS;
>=20
>   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>=20
> @@ -3599,7 +3600,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *k=
vm, u32 id)
>   		return -EINVAL;
>=20
>   	mutex_lock(&kvm->lock);
> -	if (kvm->created_vcpus =3D=3D KVM_MAX_VCPUS) {
> +	if (kvm->created_vcpus >=3D kvm->max_vcpus) {
>   		mutex_unlock(&kvm->lock);
>   		return -EINVAL;
>   	}
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>=20


--------------4053FBC510D74F5E561DEA81
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

--------------4053FBC510D74F5E561DEA81--

--dsGLdNPIr8n6VxWUzBTItEGvjSgM9i7Lt--

--0Vgyb05MMDPjuEojw0H7LxgtMNmA3JgZh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGV/bIFAwAAAAAACgkQsN6d1ii/Ey/n
IQf/Y1uVrPlTO+3NMOcHAijURL9PlHGMuc3QjBdKmnIHHd4pMyBzpSB1qVnVUxrz0ed0h668weRH
oYSJk3Og9tg2wpG7CtJNMmYRhIfA4weVqUVTlFyAZ6H2obd5oOOnkAZ49w5HXUU1CTZ+FqXMCq8B
VtK5EUYcxUpZc1SSUIDl+O27i8+Tizsky832Uriq3uYhibJ0u4eaZnGqjVlhUxqtwTFFGIraAk6C
sfcpIEaLs6OoCnd1fC1HbHGMHKbsjpRo+PFlrsVz456i0VGx9kMIDdUSIFFsNeZTmtaYa890Pttv
woDsgtgKDRPeoHFz0CcJrKoI8rmkp2Qlny3r+5/NOw==
=izRR
-----END PGP SIGNATURE-----

--0Vgyb05MMDPjuEojw0H7LxgtMNmA3JgZh--
