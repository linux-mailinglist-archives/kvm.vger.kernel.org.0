Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26F6F08D8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKEV66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:58:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbfKEV66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:58:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5Ls7lF002920;
        Tue, 5 Nov 2019 21:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=6RcoWhXgYzC24MdjlprSolEN3HzrscmlepK6VQohwRg=;
 b=dvtBxTnmn/2/FlzcKS1nwpj0jfNljA3JqSJutwlmmGWtH2psWijkxm5HVfOaaS7q5TX2
 vMm68MNj3qKOnI9pqvQhp9haiOXjlnWCt0AW42sYzS3isGj9dwZbZPgBcS744cKd+wc/
 EUigLnnx1xuzVOdl4hZgdXYbNSZrNQIsC4gsaFBBxgc6GUVtZzQfMBAPZeb/gO1/aXl7
 CFX+hFQvJ1y7ygI2mlZH2M6U6JxsjYN4dBZ+4qndnFEak9jTqOwTsAakMt/IP9sFmMVD
 VEvlesczp3YJDmmEJxppp2Fj6uqW7wxh6wkCvbFZ34zc7Tpk7aQpFmeS5SUWxFM9Vz+K Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117u1r89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:58:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5Lwobb097985;
        Tue, 5 Nov 2019 21:58:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w31624vxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:58:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA5LwHgk027600;
        Tue, 5 Nov 2019 21:58:17 GMT
Received: from [192.168.14.112] (/79.177.228.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 13:58:16 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191105191910.56505-5-aaronlewis@google.com>
Date:   Tue, 5 Nov 2019 23:58:13 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E7BEE4C5-F129-43B2-A70C-F7143E8665C9@oracle.com>
References: <20191105191910.56505-1-aaronlewis@google.com>
 <20191105191910.56505-5-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
> vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
> TSC value that might have been observed by L2 prior to VM-exit. The
> current implementation does not capture a very tight bound on this
> value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to =
the
> vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 =
VM-exit
> MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
> during the emulation of an L2->L1 VM-exit, special-case the
> IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
> VM-exit MSR-store area to derive the value to be stored in the vmcs12
> VM-exit MSR-store area.
>=20
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

The patch looks correct to me and I had only some minor style comments =
below.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

I think you may also consider to separate this patch into two:
First patch add all framework code without still using it specifically =
for MSR_IA32_TSC
and a second patch to use the framework for MSR_IA32_TSC case.

Just out of curiosity, may I ask which L1 hypervisor use this technique =
that you encountered this issue?

-Liran

> ---
> arch/x86/kvm/vmx/nested.c | 92 ++++++++++++++++++++++++++++++++++++---
> arch/x86/kvm/vmx/vmx.h    |  4 ++
> 2 files changed, 90 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7b058d7b9fcc..cb2a92341eab 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -929,6 +929,37 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 	return i + 1;
> }
>=20
> +static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
> +					    u32 msr_index,
> +					    u64 *data)
> +{
> +	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +
> +	/*
> +	 * If the L0 hypervisor stored a more accurate value for the TSC =
that
> +	 * does not include the time taken for emulation of the L2->L1
> +	 * VM-exit in L0, use the more accurate value.
> +	 */
> +	if (msr_index =3D=3D MSR_IA32_TSC) {
> +		int index =3D =
vmx_find_msr_index(&vmx->msr_autostore.guest,
> +					       MSR_IA32_TSC);
> +
> +		if (index >=3D 0) {
> +			u64 val =3D =
vmx->msr_autostore.guest.val[index].value;
> +

Nit: I would remove the new-line here.

> +			*data =3D kvm_read_l1_tsc(vcpu, val);
> +			return true;
> +		}
> +	}
> +
> +	if (kvm_get_msr(vcpu, msr_index, data)) {
> +		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", =
__func__,
> +			msr_index);
> +		return false;
> +	}
> +	return true;
> +}
> +
> static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, =
int i,
> 				     struct vmx_msr_entry *e)
> {
> @@ -963,12 +994,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
> 			return -EINVAL;
>=20
> -		if (kvm_get_msr(vcpu, e.index, &data)) {
> -			pr_debug_ratelimited(
> -				"%s cannot read MSR (%u, 0x%x)\n",
> -				__func__, i, e.index);
> +		if (!nested_vmx_get_vmexit_msr_value(vcpu, e.index, =
&data))
> 			return -EINVAL;
> -		}
> +
> 		if (kvm_vcpu_write_guest(vcpu,
> 					 gpa + i * sizeof(e) +
> 					     offsetof(struct =
vmx_msr_entry, value),
> @@ -982,6 +1010,51 @@ static int nested_vmx_store_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 	return 0;
> }
>=20
> +static bool nested_msr_store_list_has_msr(struct kvm_vcpu *vcpu, u32 =
msr_index)
> +{
> +	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> +	u32 count =3D vmcs12->vm_exit_msr_store_count;
> +	u64 gpa =3D vmcs12->vm_exit_msr_store_addr;
> +	struct vmx_msr_entry e;
> +	u32 i;
> +
> +	for (i =3D 0; i < count; i++) {
> +		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
> +			return false;
> +
> +		if (e.index =3D=3D msr_index)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
> +					   u32 msr_index)
> +{
> +	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +	struct vmx_msrs *autostore =3D &vmx->msr_autostore.guest;
> +	int i =3D vmx_find_msr_index(autostore, msr_index);

Nit: I would rename =E2=80=9Ci" to =E2=80=9Cmsr_autostore_index=E2=80=9D.

> +	bool in_autostore_list =3D i >=3D 0;
> +	bool in_vmcs12_store_list;
> +	int last;
> +
> +	in_vmcs12_store_list =3D nested_msr_store_list_has_msr(vcpu, =
msr_index);

Nit: Why is =E2=80=9Ci" and =E2=80=9Cin_autostore_list=E2=80=9D =
initialised at declaration but =E2=80=9Cin_vmcs12_store_list=E2=80=9D =
initialised here?
I would prefer to just first declare variables and then have logic of =
method after declarations.

> +
> +	if (in_vmcs12_store_list && !in_autostore_list) {
> +		if (autostore->nr =3D=3D NR_MSR_ENTRIES) {
> +			pr_warn_ratelimited(
> +				"Not enough msr entries in =
msr_autostore.  Can't add msr %x\n",
> +				msr_index);
> +			return;

I think it=E2=80=99s worth to add a comment here explaining that we =
don=E2=80=99t fail emulated VMEntry in this case
because on emulated VMExit, we will just get less accurate value by =
nested_vmx_get_vmexit_msr_value() using kvm_get_msr()
instead of reading value from vmcs02 VMExit MSR-store. But we are still =
able to emulate VMEntry properly.

> +		}
> +		last =3D autostore->nr++;
> +		autostore->val[last].index =3D msr_index;
> +	} else if (!in_vmcs12_store_list && in_autostore_list) {
> +		last =3D --autostore->nr;
> +		autostore->val[i] =3D autostore->val[last];
> +	}
> +}
> +
> static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
> {
> 	unsigned long invalid_mask;
> @@ -2027,7 +2100,7 @@ static void prepare_vmcs02_constant_state(struct =
vcpu_vmx *vmx)
> 	 * addresses are constant (for vmcs02), the counts can change =
based
> 	 * on L2's behavior, e.g. switching to/from long mode.
> 	 */
> -	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> +	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, =
__pa(vmx->msr_autostore.guest.val));
> 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, =
__pa(vmx->msr_autoload.host.val));
> 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, =
__pa(vmx->msr_autoload.guest.val));
>=20
> @@ -2294,6 +2367,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx =
*vmx, struct vmcs12 *vmcs12)
> 		vmcs_write64(EOI_EXIT_BITMAP3, =
vmcs12->eoi_exit_bitmap3);
> 	}
>=20
> +	/*
> +	 * Make sure the msr_autostore list is up to date before we set =
the
> +	 * count in the vmcs02.
> +	 */
> +	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
> +
> +	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, =
vmx->msr_autostore.guest.nr);
> 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, =
vmx->msr_autoload.guest.nr);
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 34b5fef603d8..0ab1562287af 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -230,6 +230,10 @@ struct vcpu_vmx {
> 		struct vmx_msrs host;
> 	} msr_autoload;
>=20
> +	struct msr_autostore {
> +		struct vmx_msrs guest;
> +	} msr_autostore;
> +
> 	struct {
> 		int vm86_active;
> 		ulong save_rflags;
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20

