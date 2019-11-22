Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D86107A5A
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKVWFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:05:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVWFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:05:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMLsM2K074959;
        Fri, 22 Nov 2019 22:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=7vXQL5pPIkGBHm7bmapZHsWbSBntZN1vy2kOpryX8+Q=;
 b=ILZ3RiQ/lipQgw4hCBYARh+0OPb3fYnW8z/+la7lx20QITNApG3lHc4U6cMBuBbosRei
 TylrRPSWuw6oHwEMPFXmWnTNBGMTmENK3fN49F+dNSc+nPkBvSz/6WtYFR3zN3jOaZy6
 FwORsbb33sYqV9rBsrF+p6byUCBqSdSjbZk8cdrJ7+gORDSDqwsLwNYQ93ks8Rz7WWXC
 1YjrScwHza5T8fd24Ylnn/A9+cJ6954VrQd6bRkhhgLmTcPONC0kTjIilnlLKC875lyK
 rx0D2F2+AtyqZM0xtTkUjnatuV2Cc79x/JA6lCZJxYfdaBrzlzqUYVR8BrWpKhXmAWGy xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rr556f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 22:03:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMLsXc0132064;
        Fri, 22 Nov 2019 22:03:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wec29k0ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 22:03:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAMM3bbm020607;
        Fri, 22 Nov 2019 22:03:37 GMT
Received: from [10.0.0.14] (/79.177.63.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 14:03:36 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: x86: Extend Spectre-v1 mitigation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191122184039.7189-1-pomonis@google.com>
Date:   Sat, 23 Nov 2019 00:03:27 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1ADDE0A8-40F1-4642-B8CC-8DE38609DC10@oracle.com>
References: <20191122184039.7189-1-pomonis@google.com>
To:     Marios Pomonis <pomonis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 22 Nov 2019, at 20:40, Marios Pomonis <pomonis@google.com> wrote:
>=20
> From: Nick Finco <nifi@google.com>
>=20
> This extends the Spectre-v1 mitigation introduced in
> commit 75f139aaf896 ("KVM: x86: Add memory barrier on vmcs field =
lookup")
> and commit 085331dfc6bb ("x86/kvm: Update spectre-v1 mitigation") in =
light
> of the Spectre-v1/L1TF combination described here:
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__xenbits.xen.org_xsa=
_advisory-2D289.html&d=3DDwIBaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eap=
I_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D1r1_2c3bq4nLv-MP=
Euf_dyQR9r4XHB3Vst3wJeE43pY&s=3D5GOdMhJ_AQYUkAPAveAzmHrO7hZ0qOgxKmPqKouGvn=
c&e=3D=20
>=20
> As reported in the link, an attacker can use the cache-load part of a
> Spectre-v1 gadget to bring memory into the L1 cache, then use L1TF to
> leak the loaded memory. Note that this attack is not fully mitigated =
by
> core scheduling; an attacker could employ L1TF on the same thread that
> loaded the memory in L1 instead of relying on neighboring =
hyperthreads.

This description is not accurate. The attack still relies on SMT.

If KVM flush L1D$ on every VMEntry to guest, then the only way to =
exploit this is via a sibling hyperthread.
It=E2=80=99s true that core-scheduling does not mitigate this scenario =
completely, but not because the reason described above.

The attack vector that still works when hyperthreading and =
core-scheduling is enabled, is if on a single core,
one hyperthread runs a VMExit handler which executes a cache-load gadget =
(even speculatively) while
the sibling hyperthread runs inside guest and executes L1TF code =
sequence to leak from the core=E2=80=99s L1D$.

You can find more information on this specific attack vector in the =
following KVM Forum 2019 slides:
=
https://static.sched.com/hosted_files/kvmforum2019/34/KVM%20Forum%202019%2=
0KVM%20ASI.pdf

>=20
> This patch uses array_index_nospec() to prevent index computations =
from
> causing speculative loads into the L1 cache. These cases involve a
> bounds check followed by a memory read using the index; this is more
> common than the full Spectre-v1 pattern. In some cases, the index
> computation can be eliminated entirely by small amounts of =
refactoring.
>=20
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Acked-by: Andrew Honig <ahonig@google.com>

I agree with Sean that this patch should be split into a patch-series =
with multiple patches.
It will be easier to review and more importantly, bisect in case one of =
the changes here cause a regression.

In addition, I think that every such patch should have a good =
explanation in commit message on why it is required.
i.e. A proof that the index used as part of the cache-load gadget is =
attacker-controllable.
I had a brief look over the patch below and it seems that there are some =
changes to code-path where attacker doesn=E2=80=99t control the index.
(I commented inline on those changes)
Therefore, I think these changes shouldn=E2=80=99t be necessary.

-Liran

> ---
> arch/x86/kvm/emulate.c       | 11 ++++++++---
> arch/x86/kvm/hyperv.c        | 10 ++++++----
> arch/x86/kvm/i8259.c         |  6 +++++-
> arch/x86/kvm/ioapic.c        | 15 +++++++++------
> arch/x86/kvm/lapic.c         | 13 +++++++++----
> arch/x86/kvm/mtrr.c          |  8 ++++++--
> arch/x86/kvm/pmu.h           | 18 ++++++++++++++----
> arch/x86/kvm/vmx/pmu_intel.c | 24 ++++++++++++++++--------
> arch/x86/kvm/vmx/vmx.c       | 22 ++++++++++++++++------
> arch/x86/kvm/x86.c           | 18 ++++++++++++++----
> 10 files changed, 103 insertions(+), 42 deletions(-)
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 952d1a4f4d7e..fcf7cdb21d60 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5303,10 +5303,15 @@ int x86_decode_insn(struct x86_emulate_ctxt =
*ctxt, void *insn, int insn_len)
> 			}
> 			break;
> 		case Escape:
> -			if (ctxt->modrm > 0xbf)
> -				opcode =3D =
opcode.u.esc->high[ctxt->modrm - 0xc0];
> -			else
> +			if (ctxt->modrm > 0xbf) {
> +				size_t size =3D =
ARRAY_SIZE(opcode.u.esc->high);
> +				u32 index =3D array_index_nospec(
> +					ctxt->modrm - 0xc0, size);
> +
> +				opcode =3D opcode.u.esc->high[index];
> +			} else {
> 				opcode =3D opcode.u.esc->op[(ctxt->modrm =
>> 3) & 7];
> +			}
> 			break;
> 		case InstrDual:
> 			if ((ctxt->modrm >> 6) =3D=3D 3)
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 23ff65504d7e..26408434b9bc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct =
kvm_vcpu *vcpu,
> 				     u32 index, u64 *pdata)
> {
> 	struct kvm_hv *hv =3D &vcpu->kvm->arch.hyperv;
> +	size_t size =3D ARRAY_SIZE(hv->hv_crash_param);
>=20
> -	if (WARN_ON_ONCE(index >=3D ARRAY_SIZE(hv->hv_crash_param)))
> +	if (WARN_ON_ONCE(index >=3D size))
> 		return -EINVAL;
>=20
> -	*pdata =3D hv->hv_crash_param[index];
> +	*pdata =3D hv->hv_crash_param[array_index_nospec(index, size)];
> 	return 0;
> }
>=20
> @@ -852,11 +853,12 @@ static int kvm_hv_msr_set_crash_data(struct =
kvm_vcpu *vcpu,
> 				     u32 index, u64 data)
> {
> 	struct kvm_hv *hv =3D &vcpu->kvm->arch.hyperv;
> +	size_t size =3D ARRAY_SIZE(hv->hv_crash_param);
>=20
> -	if (WARN_ON_ONCE(index >=3D ARRAY_SIZE(hv->hv_crash_param)))
> +	if (WARN_ON_ONCE(index >=3D size))
> 		return -EINVAL;
>=20
> -	hv->hv_crash_param[index] =3D data;
> +	hv->hv_crash_param[array_index_nospec(index, size)] =3D data;
> 	return 0;
> }
>=20
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 8b38bb4868a6..629a09ca9860 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -460,10 +460,14 @@ static int picdev_write(struct kvm_pic *s,
> 	switch (addr) {
> 	case 0x20:
> 	case 0x21:
> +		pic_lock(s);
> +		pic_ioport_write(&s->pics[0], addr, data);
> +		pic_unlock(s);
> +		break;
> 	case 0xa0:
> 	case 0xa1:
> 		pic_lock(s);
> -		pic_ioport_write(&s->pics[addr >> 7], addr, data);
> +		pic_ioport_write(&s->pics[1], addr, data);
> 		pic_unlock(s);
> 		break;
> 	case 0x4d0:
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 9fd2dd89a1c5..8aa58727045e 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -36,6 +36,7 @@
> #include <linux/io.h>
> #include <linux/slab.h>
> #include <linux/export.h>
> +#include <linux/nospec.h>
> #include <asm/processor.h>
> #include <asm/page.h>
> #include <asm/current.h>
> @@ -68,13 +69,14 @@ static unsigned long ioapic_read_indirect(struct =
kvm_ioapic *ioapic,
> 	default:
> 		{
> 			u32 redir_index =3D (ioapic->ioregsel - 0x10) >> =
1;
> -			u64 redir_content;
> +			u64 redir_content =3D ~0ULL;
>=20
> -			if (redir_index < IOAPIC_NUM_PINS)
> -				redir_content =3D
> -					=
ioapic->redirtbl[redir_index].bits;
> -			else
> -				redir_content =3D ~0ULL;
> +			if (redir_index < IOAPIC_NUM_PINS) {
> +				u32 index =3D array_index_nospec(
> +					redir_index, IOAPIC_NUM_PINS);
> +
> +				redir_content =3D =
ioapic->redirtbl[index].bits;
> +			}
>=20
> 			result =3D (ioapic->ioregsel & 0x1) ?
> 			    (redir_content >> 32) & 0xffffffff :
> @@ -292,6 +294,7 @@ static void ioapic_write_indirect(struct =
kvm_ioapic *ioapic, u32 val)
>=20
> 		if (index >=3D IOAPIC_NUM_PINS)
> 			return;
> +		index =3D array_index_nospec(index, IOAPIC_NUM_PINS);
> 		e =3D &ioapic->redirtbl[index];
> 		mask_before =3D e->fields.mask;
> 		/* Preserve read-only fields */
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf9177b4a07f..3323115f52d5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1963,15 +1963,20 @@ int kvm_lapic_reg_write(struct kvm_lapic =
*apic, u32 reg, u32 val)
> 	case APIC_LVTTHMR:
> 	case APIC_LVTPC:
> 	case APIC_LVT1:
> -	case APIC_LVTERR:
> +	case APIC_LVTERR: {
> 		/* TODO: Check vector */
> +		size_t size;
> +		u32 index;
> +
> 		if (!kvm_apic_sw_enabled(apic))
> 			val |=3D APIC_LVT_MASKED;
> -
> -		val &=3D apic_lvt_mask[(reg - APIC_LVTT) >> 4];
> +		size =3D ARRAY_SIZE(apic_lvt_mask);
> +		index =3D array_index_nospec(
> +				(reg - APIC_LVTT) >> 4, size);
> +		val &=3D apic_lvt_mask[index];
> 		kvm_lapic_set_reg(apic, reg, val);
> -
> 		break;
> +	}
>=20
> 	case APIC_LVTT:
> 		if (!kvm_apic_sw_enabled(apic))
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 25ce3edd1872..7f0059aa30e1 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -192,11 +192,15 @@ static bool fixed_msr_to_seg_unit(u32 msr, int =
*seg, int *unit)
> 		break;
> 	case MSR_MTRRfix16K_80000 ... MSR_MTRRfix16K_A0000:
> 		*seg =3D 1;
> -		*unit =3D msr - MSR_MTRRfix16K_80000;
> +		*unit =3D array_index_nospec(
> +			msr - MSR_MTRRfix16K_80000,
> +			MSR_MTRRfix16K_A0000 - MSR_MTRRfix16K_80000 + =
1);
> 		break;
> 	case MSR_MTRRfix4K_C0000 ... MSR_MTRRfix4K_F8000:
> 		*seg =3D 2;
> -		*unit =3D msr - MSR_MTRRfix4K_C0000;
> +		*unit =3D array_index_nospec(
> +			msr - MSR_MTRRfix4K_C0000,
> +			MSR_MTRRfix4K_F8000 - MSR_MTRRfix4K_C0000 + 1);
> 		break;
> 	default:
> 		return false;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7ebb62326c14..13332984b6d5 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -2,6 +2,8 @@
> #ifndef __KVM_X86_PMU_H
> #define __KVM_X86_PMU_H
>=20
> +#include <linux/nospec.h>
> +
> #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, =
arch.pmu))
> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> @@ -102,8 +104,12 @@ static inline bool =
kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
> static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
> 					 u32 base)
> {
> -	if (msr >=3D base && msr < base + pmu->nr_arch_gp_counters)
> -		return &pmu->gp_counters[msr - base];
> +	if (msr >=3D base && msr < base + pmu->nr_arch_gp_counters) {
> +		u32 index =3D array_index_nospec(msr - base,
> +					       =
pmu->nr_arch_gp_counters);
> +
> +		return &pmu->gp_counters[index];
> +	}
>=20
> 	return NULL;
> }
> @@ -113,8 +119,12 @@ static inline struct kvm_pmc =
*get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
> {
> 	int base =3D MSR_CORE_PERF_FIXED_CTR0;
>=20
> -	if (msr >=3D base && msr < base + pmu->nr_arch_fixed_counters)
> -		return &pmu->fixed_counters[msr - base];
> +	if (msr >=3D base && msr < base + pmu->nr_arch_fixed_counters) {
> +		u32 index =3D array_index_nospec(msr - base,
> +					       =
pmu->nr_arch_fixed_counters);
> +
> +		return &pmu->fixed_counters[index];
> +	}
>=20
> 	return NULL;
> }
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c =
b/arch/x86/kvm/vmx/pmu_intel.c
> index 7023138b1cb0..34a3a17bb6d7 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -86,10 +86,14 @@ static unsigned intel_find_arch_event(struct =
kvm_pmu *pmu,
>=20
> static unsigned intel_find_fixed_event(int idx)
> {
> -	if (idx >=3D ARRAY_SIZE(fixed_pmc_events))
> +	u32 event;
> +	size_t size =3D ARRAY_SIZE(fixed_pmc_events);
> +
> +	if (idx >=3D size)
> 		return PERF_COUNT_HW_MAX;
>=20
> -	return intel_arch_events[fixed_pmc_events[idx]].event_type;
> +	event =3D fixed_pmc_events[array_index_nospec(idx, size)];
> +	return intel_arch_events[event].event_type;
> }
>=20
> /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
> @@ -130,16 +134,20 @@ static struct kvm_pmc =
*intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
> 	struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> 	bool fixed =3D idx & (1u << 30);
> 	struct kvm_pmc *counters;
> +	unsigned int num_counters;
>=20
> 	idx &=3D ~(3u << 30);
> -	if (!fixed && idx >=3D pmu->nr_arch_gp_counters)
> -		return NULL;
> -	if (fixed && idx >=3D pmu->nr_arch_fixed_counters)
> +	if (fixed) {
> +		counters =3D pmu->fixed_counters;
> +		num_counters =3D pmu->nr_arch_fixed_counters;
> +	} else {
> +		counters =3D pmu->gp_counters;
> +		num_counters =3D pmu->nr_arch_gp_counters;
> +	}
> +	if (idx >=3D num_counters)
> 		return NULL;
> -	counters =3D fixed ? pmu->fixed_counters : pmu->gp_counters;
> 	*mask &=3D pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : =
KVM_PMC_GP];
> -
> -	return &counters[idx];
> +	return &counters[array_index_nospec(idx, num_counters)];
> }
>=20
> static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d39475e2d44e..84def8e46d10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -753,7 +753,9 @@ static bool vmx_segment_cache_test_set(struct =
vcpu_vmx *vmx, unsigned seg,
>=20
> static u16 vmx_read_guest_seg_selector(struct vcpu_vmx *vmx, unsigned =
seg)
> {
> -	u16 *p =3D &vmx->segment_cache.seg[seg].selector;
> +	size_t size =3D ARRAY_SIZE(vmx->segment_cache.seg);
> +	size_t index =3D array_index_nospec(seg, size);
> +	u16 *p =3D &vmx->segment_cache.seg[index].selector;
>=20
> 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_SEL))
> 		*p =3D =
vmcs_read16(kvm_vmx_segment_fields[seg].selector);
> @@ -762,7 +764,9 @@ static u16 vmx_read_guest_seg_selector(struct =
vcpu_vmx *vmx, unsigned seg)
>=20
> static ulong vmx_read_guest_seg_base(struct vcpu_vmx *vmx, unsigned =
seg)
> {
> -	ulong *p =3D &vmx->segment_cache.seg[seg].base;
> +	size_t size =3D ARRAY_SIZE(vmx->segment_cache.seg);
> +	size_t index =3D array_index_nospec(seg, size);
> +	ulong *p =3D &vmx->segment_cache.seg[index].base;
>=20
> 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_BASE))
> 		*p =3D vmcs_readl(kvm_vmx_segment_fields[seg].base);
> @@ -771,7 +775,9 @@ static ulong vmx_read_guest_seg_base(struct =
vcpu_vmx *vmx, unsigned seg)
>=20
> static u32 vmx_read_guest_seg_limit(struct vcpu_vmx *vmx, unsigned =
seg)
> {
> -	u32 *p =3D &vmx->segment_cache.seg[seg].limit;
> +	size_t size =3D ARRAY_SIZE(vmx->segment_cache.seg);
> +	size_t index =3D array_index_nospec(seg, size);
> +	u32 *p =3D &vmx->segment_cache.seg[index].limit;
>=20
> 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_LIMIT))
> 		*p =3D vmcs_read32(kvm_vmx_segment_fields[seg].limit);
> @@ -780,7 +786,9 @@ static u32 vmx_read_guest_seg_limit(struct =
vcpu_vmx *vmx, unsigned seg)
>=20
> static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
> {
> -	u32 *p =3D &vmx->segment_cache.seg[seg].ar;
> +	size_t size =3D ARRAY_SIZE(vmx->segment_cache.seg);
> +	size_t index =3D array_index_nospec(seg, size);
> +	u32 *p =3D &vmx->segment_cache.seg[index].ar;
>=20
> 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_AR))
> 		*p =3D =
vmcs_read32(kvm_vmx_segment_fields[seg].ar_bytes);
> @@ -5828,6 +5836,8 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> {
> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> 	u32 exit_reason =3D vmx->exit_reason;
> +	u32 bounded_exit_reason =3D array_index_nospec(exit_reason,
> +						=
kvm_vmx_max_exit_handlers);

Unlike the rest of this patch changes, exit_reason is not =
attacker-controllable.
Therefore, I don=E2=80=99t think we need this change to =
vmx_handle_exit().

> 	u32 vectoring_info =3D vmx->idt_vectoring_info;
>=20
> 	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
> @@ -5911,7 +5921,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 	}
>=20
> 	if (exit_reason < kvm_vmx_max_exit_handlers
> -	    && kvm_vmx_exit_handlers[exit_reason]) {
> +	    && kvm_vmx_exit_handlers[bounded_exit_reason]) {
> #ifdef CONFIG_RETPOLINE
> 		if (exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> 			return kvm_emulate_wrmsr(vcpu);
> @@ -5926,7 +5936,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		else if (exit_reason =3D=3D EXIT_REASON_EPT_MISCONFIG)
> 			return handle_ept_misconfig(vcpu);
> #endif
> -		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> +		return kvm_vmx_exit_handlers[bounded_exit_reason](vcpu);
> 	} else {
> 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> 				exit_reason);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a256e09f321a..9a2789652231 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1057,9 +1057,11 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
>=20
> static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long =
val)
> {
> +	size_t size =3D ARRAY_SIZE(vcpu->arch.db);
> +

Why is this change needed?
=E2=80=9Cdr=E2=80=9D shouldn=E2=80=99t be attacker-controllable.
It=E2=80=99s value is read from vmcs->exit_qualification or =
vmcb->control.exit_code on DR-access intercept.
Relevant also for kvm_get_dr().

> 	switch (dr) {
> 	case 0 ... 3:
> -		vcpu->arch.db[dr] =3D val;
> +		vcpu->arch.db[array_index_nospec(dr, size)] =3D val;
> 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
> 			vcpu->arch.eff_db[dr] =3D val;
> 		break;
> @@ -1096,9 +1098,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
>=20
> int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
> {
> +	size_t size =3D ARRAY_SIZE(vcpu->arch.db);
> +
> 	switch (dr) {
> 	case 0 ... 3:
> -		*val =3D vcpu->arch.db[dr];
> +		*val =3D vcpu->arch.db[array_index_nospec(dr, size)];
> 		break;
> 	case 4:
> 		/* fall through */
> @@ -2496,7 +2500,10 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 	default:
> 		if (msr >=3D MSR_IA32_MC0_CTL &&
> 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> -			u32 offset =3D msr - MSR_IA32_MC0_CTL;
> +			u32 offset =3D array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL,
> +				MSR_IA32_MCx_CTL(bank_num) - =
MSR_IA32_MC0_CTL);
> +
> 			/* only 0 or all 1s can be written to =
IA32_MCi_CTL
> 			 * some Linux kernels though clear bit 10 in =
bank 4 to
> 			 * workaround a BIOS/GART TBL issue on AMD K8s, =
ignore
> @@ -2937,7 +2944,10 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, =
u32 msr, u64 *pdata, bool host)
> 	default:
> 		if (msr >=3D MSR_IA32_MC0_CTL &&
> 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> -			u32 offset =3D msr - MSR_IA32_MC0_CTL;
> +			u32 offset =3D array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL,
> +				MSR_IA32_MCx_CTL(bank_num) - =
MSR_IA32_MC0_CTL);
> +
> 			data =3D vcpu->arch.mce_banks[offset];
> 			break;
> 		}
> --=20
> 2.24.0.432.g9d3f5f5b63-goog
>=20

