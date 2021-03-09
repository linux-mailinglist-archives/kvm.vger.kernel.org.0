Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B88331F08
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhCIGPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:15:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:50702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhCIGOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:14:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615270479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Szn8CoKcdFhLmILaUcNU5Mw5xCclHsTUFexJC8stRy4=;
        b=jPjIK0O/HZtDDoN9i5q9qE9tCBF+qqDn/LLQf1IVkph/JDoObaw8ldwo6HNokrvlhNodgL
        Vs85iV11L2fM3q2k47ZOpXDOg6M687QX/KgVkfAXyk4PzKrZF8y74kYMkCJgwRL2t8uQV6
        Lgy5TUIAMbtKoMqVu92zSt/DdCmoRak=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 378E8AC24;
        Tue,  9 Mar 2021 06:14:39 +0000 (UTC)
Subject: Re: [PATCH v5 02/12] x86/paravirt: switch time pvops functions to use
 static_call()
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Cc:     Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20210308122844.30488-1-jgross@suse.com>
 <20210308122844.30488-3-jgross@suse.com>
 <1346dbb1-c43e-9ac2-10e4-3c10cb2ead78@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <5cea7551-ce84-c084-ddaf-e84075823bd8@suse.com>
Date:   Tue, 9 Mar 2021 07:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1346dbb1-c43e-9ac2-10e4-3c10cb2ead78@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="71uw2iHz3Ya5XGSDna2ezasDmqthVMGA6"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--71uw2iHz3Ya5XGSDna2ezasDmqthVMGA6
Content-Type: multipart/mixed; boundary="WlyrUNrhACnKGE7g1Gx1k7ZM6h5PqkFRP";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, x86@kernel.org,
 virtualization@lists.linux-foundation.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Cc: Deep Shah <sdeep@vmware.com>, "VMware, Inc." <pv-drivers@vmware.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>,
 Stephen Hemminger <sthemmin@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Stefano Stabellini <sstabellini@kernel.org>
Message-ID: <5cea7551-ce84-c084-ddaf-e84075823bd8@suse.com>
Subject: Re: [PATCH v5 02/12] x86/paravirt: switch time pvops functions to use
 static_call()
References: <20210308122844.30488-1-jgross@suse.com>
 <20210308122844.30488-3-jgross@suse.com>
 <1346dbb1-c43e-9ac2-10e4-3c10cb2ead78@oracle.com>
In-Reply-To: <1346dbb1-c43e-9ac2-10e4-3c10cb2ead78@oracle.com>

--WlyrUNrhACnKGE7g1Gx1k7ZM6h5PqkFRP
Content-Type: multipart/mixed;
 boundary="------------F998C827E1466225E03A1952"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------F998C827E1466225E03A1952
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.03.21 18:00, Boris Ostrovsky wrote:
>=20
> On 3/8/21 7:28 AM, Juergen Gross wrote:
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -379,11 +379,6 @@ void xen_timer_resume(void)
>>   	}
>>   }
>>  =20
>> -static const struct pv_time_ops xen_time_ops __initconst =3D {
>> -	.sched_clock =3D xen_sched_clock,
>> -	.steal_clock =3D xen_steal_clock,
>> -};
>> -
>>   static struct pvclock_vsyscall_time_info *xen_clock __read_mostly;
>>   static u64 xen_clock_value_saved;
>>  =20
>> @@ -528,7 +523,8 @@ static void __init xen_time_init(void)
>>   void __init xen_init_time_ops(void)
>>   {
>>   	xen_sched_clock_offset =3D xen_clocksource_read();
>> -	pv_ops.time =3D xen_time_ops;
>> +	static_call_update(pv_steal_clock, xen_steal_clock);
>> +	paravirt_set_sched_clock(xen_sched_clock);
>>  =20
>>   	x86_init.timers.timer_init =3D xen_time_init;
>>   	x86_init.timers.setup_percpu_clockev =3D x86_init_noop;
>> @@ -570,7 +566,8 @@ void __init xen_hvm_init_time_ops(void)
>>   	}
>>  =20
>>   	xen_sched_clock_offset =3D xen_clocksource_read();
>> -	pv_ops.time =3D xen_time_ops;
>> +	static_call_update(pv_steal_clock, xen_steal_clock);
>> +	paravirt_set_sched_clock(xen_sched_clock);
>>   	x86_init.timers.setup_percpu_clockev =3D xen_time_init;
>>   	x86_cpuinit.setup_percpu_clockev =3D xen_hvm_setup_cpu_clockevents;=

>=20
>=20
> There is a bunch of stuff that's common between the two cases so it can=
 be factored out.

Yes.

>=20
>=20
>>  =20
>> diff --git a/drivers/xen/time.c b/drivers/xen/time.c
>> index 108edbcbc040..152dd33bb223 100644
>> --- a/drivers/xen/time.c
>> +++ b/drivers/xen/time.c
>> @@ -7,6 +7,7 @@
>>   #include <linux/math64.h>
>>   #include <linux/gfp.h>
>>   #include <linux/slab.h>
>> +#include <linux/static_call.h>
>>  =20
>>   #include <asm/paravirt.h>
>>   #include <asm/xen/hypervisor.h>
>> @@ -175,7 +176,7 @@ void __init xen_time_setup_guest(void)
>>   	xen_runstate_remote =3D !HYPERVISOR_vm_assist(VMASST_CMD_enable,
>>   					VMASST_TYPE_runstate_update_flag);
>>  =20
>> -	pv_ops.time.steal_clock =3D xen_steal_clock;
>> +	static_call_update(pv_steal_clock, xen_steal_clock);
>>  =20
>=20
>=20
> Do we actually need this? We've already set this up in xen_init_time_op=
s(). (But maybe for ARM).

Correct. Arm needs this.


Juergen

--------------F998C827E1466225E03A1952
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
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

--------------F998C827E1466225E03A1952--

--WlyrUNrhACnKGE7g1Gx1k7ZM6h5PqkFRP--

--71uw2iHz3Ya5XGSDna2ezasDmqthVMGA6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBHEk0FAwAAAAAACgkQsN6d1ii/Ey8E
swf+OyODJL+GMlmaqXVphW8kb4oF9BSQVqkcEtzcS+L7SRmJ9ZuimdIeCk6WrrqzUiDE1aeFsNeK
hVT12DE64j551Af0uJdt3Q/PBEDiSsvW7V87fiAg8DL8I0XqJj29wP8vBjfJPVFgDVJHIsNK2Tnm
K4O/6BbctZcBqC6WwuSpss7JXmRAS0ApTaaAypMTffbSKAwJ9whX+tlcFKpqvBqKVjV2x65b7Cj2
hE/CQ/MjxQhK9Qjz7y4M62kBOGiWt3PhJInwZSpRmbf1j0Qieht6KAbJhWvwm0WGTeoOI/JCLQWd
I8/SFQj2W6p8N5ijnvLD5KskevErq8ti98OafCVDpA==
=2Vak
-----END PGP SIGNATURE-----

--71uw2iHz3Ya5XGSDna2ezasDmqthVMGA6--
