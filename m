Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BEF5C5E7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 01:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGAXSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 19:18:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGAXSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 19:18:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61NEDkm185492;
        Mon, 1 Jul 2019 23:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=Xjhm0NLKDYTbem7gsqHaB6Er5bifF9aylg5PXgTufDw=;
 b=Za2EbQVA1wz96yY69gGUsdAwVxByhz8iPG5tRrGf2PZ41h+VyRgAKE8PVW2UWZqrZDY0
 1SPoZ0rwPX7cvBuoCRAw9jVYbTt8WWNn3TLgZ11j+gYj9/cuWg8EsXAHoXUnQc/pW6R0
 85HDKXjBQQgLzAtsX/TSwVdQr10BtTtV1ItpZE0GcrV84l8ZLJZ0cGWLTrmVi7M/AHlQ
 dthFPN5+acLGBZzcrfAeb2F6UTFN8rqxDg6xWyGkQ4OEZy2m8x9RUyzAh6qKXfBNEie7
 ImgExtsLIXD6RcpvJe0Okk8maw/DaEqDLwz68iAcX8EUjeF9Z3NczJsb1fA2Ts+quVk1 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbgacj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 23:18:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61NHXF7040658;
        Mon, 1 Jul 2019 23:18:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tebktxnu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 23:18:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61NI9YQ007621;
        Mon, 1 Jul 2019 23:18:10 GMT
Received: from [192.168.14.112] (/79.183.235.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 16:18:09 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12
 is copied from eVMCS
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190626130927.121459-1-liran.alon@oracle.com>
Date:   Tue, 2 Jul 2019 02:18:05 +0300
Cc:     vkuznets@redhat.com, Maran Wilson <maran.wilson@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BF6405C9-8684-4516-B679-9902602D54A2@oracle.com>
References: <20190626130927.121459-1-liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010271
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010270
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

> On 26 Jun 2019, at 16:09, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> Currently KVM_STATE_NESTED_EVMCS is used to signal that eVMCS
> capability is enabled on vCPU.
> As indicated by vmx->nested.enlightened_vmcs_enabled.
>=20
> This is quite bizarre as userspace VMM should make sure to expose
> same vCPU with same CPUID values in both source and destination.
> In case vCPU is exposed with eVMCS support on CPUID, it is also
> expected to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS capability.
> Therefore, KVM_STATE_NESTED_EVMCS is redundant.
>=20
> KVM_STATE_NESTED_EVMCS is currently used on restore path
> (vmx_set_nested_state()) only to enable eVMCS capability in KVM
> and to signal need_vmcs12_sync such that on next VMEntry to guest
> nested_sync_from_vmcs12() will be called to sync vmcs12 content
> into eVMCS in guest memory.
> However, because restore nested-state is rare enough, we could
> have just modified vmx_set_nested_state() to always signal
> need_vmcs12_sync.
>=20
> =46rom all the above, it seems that we could have just removed
> the usage of KVM_STATE_NESTED_EVMCS. However, in order to preserve
> backwards migration compatibility, we cannot do that.
> (vmx_get_nested_state() needs to signal flag when migrating from
> new kernel to old kernel).
>=20
> Returning KVM_STATE_NESTED_EVMCS when just vCPU have eVMCS enabled
> have a bad side-effect of userspace VMM having to send nested-state
> from source to destination as part of migration stream. Even if
> guest have never used eVMCS as it doesn't even run a nested
> hypervisor workload. This requires destination userspace VMM and
> KVM to support setting nested-state. Which make it more difficult
> to migrate from new host to older host.
> To avoid this, change KVM_STATE_NESTED_EVMCS to signal eVMCS is
> not only enabled but also active. i.e. Guest have made some
> eVMCS active via an enlightened VMEntry. i.e. vmcs12 is copied
> from eVMCS and therefore should be restored into eVMCS resident
> in memory (by copy_vmcs12_to_enlightened()).
>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
> arch/x86/kvm/vmx/nested.c                     | 25 ++++++++++++-------
> .../testing/selftests/kvm/x86_64/evmcs_test.c |  1 +
> 2 files changed, 17 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b66001fb0232..18efb338ed8a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5240,9 +5240,6 @@ static int vmx_get_nested_state(struct kvm_vcpu =
*vcpu,
> 	vmx =3D to_vmx(vcpu);
> 	vmcs12 =3D get_vmcs12(vcpu);
>=20
> -	if (nested_vmx_allowed(vcpu) && =
vmx->nested.enlightened_vmcs_enabled)
> -		kvm_state.flags |=3D KVM_STATE_NESTED_EVMCS;
> -
> 	if (nested_vmx_allowed(vcpu) &&
> 	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
> 		kvm_state.hdr.vmx.vmxon_pa =3D vmx->nested.vmxon_ptr;
> @@ -5251,6 +5248,9 @@ static int vmx_get_nested_state(struct kvm_vcpu =
*vcpu,
> 		if (vmx_has_valid_vmcs12(vcpu)) {
> 			kvm_state.size +=3D =
sizeof(user_vmx_nested_state->vmcs12);
>=20
> +			if (vmx->nested.hv_evmcs)
> +				kvm_state.flags |=3D =
KVM_STATE_NESTED_EVMCS;
> +
> 			if (is_guest_mode(vcpu) &&
> 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
> 			    vmcs12->vmcs_link_pointer !=3D -1ull)
> @@ -5350,6 +5350,15 @@ static int vmx_set_nested_state(struct kvm_vcpu =
*vcpu,
> 		if (kvm_state->hdr.vmx.vmcs12_pa !=3D -1ull)
> 			return -EINVAL;
>=20
> +		/*
> +		 * KVM_STATE_NESTED_EVMCS used to signal that KVM should
> +		 * enable eVMCS capability on vCPU. However, since then
> +		 * code was changed such that flag signals vmcs12 should
> +		 * be copied into eVMCS in guest memory.
> +		 *
> +		 * To preserve backwards compatability, allow user
> +		 * to set this flag even when there is no VMXON region.
> +		 */
> 		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
> 			return -EINVAL;
> 	} else {
> @@ -5358,7 +5367,7 @@ static int vmx_set_nested_state(struct kvm_vcpu =
*vcpu,
>=20
> 		if (!page_address_valid(vcpu, =
kvm_state->hdr.vmx.vmxon_pa))
> 			return -EINVAL;
> -    	}
> +	}
>=20
> 	if ((kvm_state->hdr.vmx.smm.flags & =
KVM_STATE_NESTED_SMM_GUEST_MODE) &&
> 	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> @@ -5383,13 +5392,11 @@ static int vmx_set_nested_state(struct =
kvm_vcpu *vcpu,
> 	    !(kvm_state->hdr.vmx.smm.flags & =
KVM_STATE_NESTED_SMM_VMXON))
> 		return -EINVAL;
>=20
> -	vmx_leave_nested(vcpu);
> -	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
> -		if (!nested_vmx_allowed(vcpu))
> +	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
> +		(!nested_vmx_allowed(vcpu) || =
!vmx->nested.enlightened_vmcs_enabled))
> 			return -EINVAL;
>=20
> -		nested_enable_evmcs(vcpu, NULL);
> -	}
> +	vmx_leave_nested(vcpu);
>=20
> 	if (kvm_state->hdr.vmx.vmxon_pa =3D=3D -1ull)
> 		return 0;
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c =
b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index b38260e29775..241919ef1eac 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -146,6 +146,7 @@ int main(int argc, char *argv[])
> 		kvm_vm_restart(vm, O_RDWR);
> 		vm_vcpu_add(vm, VCPU_ID, 0, 0);
> 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +		vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, =
&enable_evmcs_cap);
> 		vcpu_load_state(vm, VCPU_ID, state);
> 		run =3D vcpu_state(vm, VCPU_ID);
> 		free(state);
> --=20
> 2.20.1
>=20

