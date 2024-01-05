Return-Path: <kvm+bounces-5753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5C2825C60
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 002E11C23AEE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53131321AC;
	Fri,  5 Jan 2024 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yynS7Ds8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D6B35297
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36000a26f8aso29535ab.0
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 14:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704492517; x=1705097317; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwlLOBBYePpLJI+ZCa7Tq9sayi/mDxTaVztGeIAF2Qg=;
        b=yynS7Ds8wE9NX56uZcNjWiXU2jOHL9ivewBMBDVyS0kW61qE9R3c6rLTLuQjCrQyGx
         FRx74epYl01vl+90MrHz+Hj3Up8K5nPY3r0/tItaUTawzQ8ve+xOj3z0EEL1woRsu0pE
         0zqw8g/wizrJvh+f1EEP5dfITCV40IyfBKJaK+D1KjZavxagKm3P1MmPHGGOZZe7rNQD
         pDq/Rh/JggJRsWsgx7reHJ4uWUTg/LpmW+76etZdtDVE8qoB0quKXMic8P+IKtjt1UyS
         g/FFRJLSWerJjH6Jf3Jy3mLppRQISbzBk6EDBLX6V2VTX84+EDVlHRgS9IGWVQHxrVVS
         M9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704492517; x=1705097317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kwlLOBBYePpLJI+ZCa7Tq9sayi/mDxTaVztGeIAF2Qg=;
        b=TBz0KLyjTuMkz5loJ0T+zxpgembqiJLPrAuiOKQ7v6fFA/zr5Q3uVZwIr392aE4YS4
         KZnG62sosHW3s7laJ3qahM7Xs7ih6zplhVq3h5REJFkRy3ZKrUn6v0m/vL0fVzNi1KPR
         woo7REWmfFAAzcWLwGqjksXUpsdvO0GeuHsjTDqVWpEuI+8dAzy2nm37a0Pzoukcb3/l
         1KTTDm4lTlAJKikDkXJfxXhg+d+NYQxyULPaImseIFaej0jqqb6h8UEIMNPABiqH+pMR
         siDjZttrf83ERrNvVWD3rvddKzQdpVxPjmXZKnOGmgCTeliXiK61SNUlcGN6Gk8NzPW4
         Q6+g==
X-Gm-Message-State: AOJu0YxfGFEsWSI70jbqp9nhh9DtS0qkgz8WoFvJhJYAWdEC2d/R5c+V
	tpzZd1ECaX+kCxG8diA+LlNWzRYI0+PLQ/Wh5H5v3B00Fis9
X-Google-Smtp-Source: AGHT+IGPv70wZ6AFOIkxXqhir3xSkvaDS2YuYLURQ1YKBHPf4U8D93dPWsA4iion3PtZSZRd3rI6B19xWMpfPmFDuP0=
X-Received: by 2002:a05:6e02:1b08:b0:360:6233:1377 with SMTP id
 i8-20020a056e021b0800b0036062331377mr18945ilv.27.1704492516442; Fri, 05 Jan
 2024 14:08:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-27-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-27-michael.roth@amd.com>
From: Jacob Xu <jacobhxu@google.com>
Date: Fri, 5 Jan 2024 14:08:24 -0800
Message-ID: <CAJ5mJ6hpSSVhZ5hbPZ8vfSnmNU6W+g4e=PeLrG7fG2u8KptfHQ@mail.gmail.com>
Subject: Re: [PATCH v11 26/35] KVM: SEV: Support SEV-SNP AP Creation NAE event
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Adam Dunlap <acdunlap@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 9:32=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
> guests to alter the register state of the APs on their own. This allows
> the guest a way of simulating INIT-SIPI.
>
> A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
> so as to avoid updating the VMSA pointer while the vCPU is running.
>
> For CREATE
>   The guest supplies the GPA of the VMSA to be used for the vCPU with
>   the specified APIC ID. The GPA is saved in the svm struct of the
>   target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
>   to the vCPU and then the vCPU is kicked.
>
> For CREATE_ON_INIT:
>   The guest supplies the GPA of the VMSA to be used for the vCPU with
>   the specified APIC ID the next time an INIT is performed. The GPA is
>   saved in the svm struct of the target vCPU.
>
> For DESTROY:
>   The guest indicates it wishes to stop the vCPU. The GPA is cleared
>   from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
>   added to vCPU and then the vCPU is kicked.
>
> The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
> as a result of the event or as a result of an INIT. The handler sets the
> vCPU to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will
> leave the vCPU as not runnable. Any previous VMSA pages that were
> installed as part of an SEV-SNP AP Creation NAE event are un-pinned. If
> a new VMSA is to be installed, the VMSA guest page is pinned and set as
> the VMSA in the vCPU VMCB and the vCPU state is set to
> KVM_MP_STATE_RUNNABLE. If a new VMSA is not to be installed, the VMSA is
> cleared in the vCPU VMCB and the vCPU state is left as
> KVM_MP_STATE_UNINITIALIZED to prevent it from being run.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: add handling for gmem]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/include/asm/svm.h      |   5 +
>  arch/x86/kvm/svm/sev.c          | 219 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |   3 +
>  arch/x86/kvm/svm/svm.h          |   8 +-
>  arch/x86/kvm/x86.c              |  11 ++
>  6 files changed, 246 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 3fdcbb1da856..9e45402e51bc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -121,6 +121,7 @@
>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_HV_TLB_FLUSH \
>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
>
>  #define CR0_RESERVED_BITS                                               =
\
>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_=
TS \
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ba8ce15b27d7..4b73cf5e9de0 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -287,6 +287,11 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICA=
L_MAX_INDEX_MASK) =3D=3D X2AVIC_
>
>  #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>  #define SVM_SEV_FEAT_SNP_ACTIVE                        BIT(0)
> +#define SVM_SEV_FEAT_RESTRICTED_INJECTION              BIT(3)
> +#define SVM_SEV_FEAT_ALTERNATE_INJECTION              BIT(4)
> +#define SVM_SEV_FEAT_INT_INJ_MODES             \
> +       (SVM_SEV_FEAT_RESTRICTED_INJECTION |    \
> +        SVM_SEV_FEAT_ALTERNATE_INJECTION)
>
>  struct vmcb_seg {
>         u16 selector;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 996b5a668938..3bb89c4df5d6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -652,6 +652,7 @@ static int sev_launch_update_data(struct kvm *kvm, st=
ruct kvm_sev_cmd *argp)
>
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(svm->vcpu.kvm)->sev_info=
;
>         struct sev_es_save_area *save =3D svm->sev_es.vmsa;
>
>         /* Check some debug related fields before encrypting the VMSA */
> @@ -700,6 +701,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>         if (sev_snp_guest(svm->vcpu.kvm))
>                 save->sev_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;
>
> +       /*
> +        * Save the VMSA synced SEV features. For now, they are the same =
for
> +        * all vCPUs, so just save each time.
> +        */
> +       sev->sev_features =3D save->sev_features;
> +
>         pr_debug("Virtual Machine Save Area (VMSA):\n");
>         print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*s=
ave), false);
>
> @@ -3082,6 +3089,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm=
 *svm)
>                 if (!kvm_ghcb_sw_scratch_is_valid(svm))
>                         goto vmgexit_err;
>                 break;
> +       case SVM_VMGEXIT_AP_CREATION:
> +               if (lower_32_bits(control->exit_info_1) !=3D SVM_VMGEXIT_=
AP_DESTROY)
> +                       if (!kvm_ghcb_rax_is_valid(svm))
> +                               goto vmgexit_err;
> +               break;
>         case SVM_VMGEXIT_NMI_COMPLETE:
>         case SVM_VMGEXIT_AP_HLT_LOOP:
>         case SVM_VMGEXIT_AP_JUMP_TABLE:
> @@ -3322,6 +3334,202 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu=
)
>         return 1; /* resume guest */
>  }
>
> +static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +       hpa_t cur_pa;
> +
> +       WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
> +
> +       /* Save off the current VMSA PA for later checks */
> +       cur_pa =3D svm->sev_es.vmsa_pa;
> +
> +       /* Mark the vCPU as offline and not runnable */
> +       vcpu->arch.pv.pv_unhalted =3D false;
> +       vcpu->arch.mp_state =3D KVM_MP_STATE_HALTED;
> +
> +       /* Clear use of the VMSA */
> +       svm->sev_es.vmsa_pa =3D INVALID_PAGE;
> +       svm->vmcb->control.vmsa_pa =3D INVALID_PAGE;
> +
> +       /*
> +        * sev->sev_es.vmsa holds the virtual address of the VMSA initial=
ly
> +        * allocated by the host. If the guest specified a new a VMSA via
> +        * AP_CREATION, it will have been pinned to avoid future issues
> +        * with things like page migration support. Make sure to un-pin i=
t
> +        * before switching to a newer guest-specified VMSA.
> +        */
> +       if (cur_pa !=3D __pa(svm->sev_es.vmsa) && VALID_PAGE(cur_pa))
> +               kvm_release_pfn_dirty(__phys_to_pfn(cur_pa));
> +
> +       if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
> +               gfn_t gfn =3D gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
> +               struct kvm_memory_slot *slot;
> +               kvm_pfn_t pfn;
> +
> +               slot =3D gfn_to_memslot(vcpu->kvm, gfn);
> +               if (!slot)
> +                       return -EINVAL;
> +
> +               /*
> +                * The new VMSA will be private memory guest memory, so
> +                * retrieve the PFN from the gmem backend, and leave the =
ref
> +                * count of the associated folio elevated to ensure it wo=
n't
> +                * ever be migrated.
> +                */
> +               if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
> +                       return -EINVAL;
> +
> +               /* Use the new VMSA */
> +               svm->sev_es.vmsa_pa =3D pfn_to_hpa(pfn);
> +               svm->vmcb->control.vmsa_pa =3D svm->sev_es.vmsa_pa;
> +
> +               /* Mark the vCPU as runnable */
> +               vcpu->arch.pv.pv_unhalted =3D false;
> +               vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
> +
> +               svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
> +       }
> +
> +       /*
> +        * When replacing the VMSA during SEV-SNP AP creation,
> +        * mark the VMCB dirty so that full state is always reloaded.
> +        */
> +       vmcb_mark_all_dirty(svm->vmcb);
> +
> +       return 0;
> +}
> +
> +/*
> + * Invoked as part of svm_vcpu_reset() processing of an init event.
> + */
> +void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +       int ret;
> +
> +       if (!sev_snp_guest(vcpu->kvm))
> +               return;
> +
> +       mutex_lock(&svm->sev_es.snp_vmsa_mutex);
> +
> +       if (!svm->sev_es.snp_ap_create)
> +               goto unlock;
> +
> +       svm->sev_es.snp_ap_create =3D false;
> +
> +       ret =3D __sev_snp_update_protected_guest_state(vcpu);
> +       if (ret)
> +               vcpu_unimpl(vcpu, "snp: AP state update on init failed\n"=
);
> +
> +unlock:
> +       mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
> +}
> +
> +static int sev_snp_ap_creation(struct vcpu_svm *svm)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(svm->vcpu.kvm)->sev_info=
;
> +       struct kvm_vcpu *vcpu =3D &svm->vcpu;
> +       struct kvm_vcpu *target_vcpu;
> +       struct vcpu_svm *target_svm;
> +       unsigned int request;
> +       unsigned int apic_id;
> +       bool kick;
> +       int ret;
> +
> +       request =3D lower_32_bits(svm->vmcb->control.exit_info_1);
> +       apic_id =3D upper_32_bits(svm->vmcb->control.exit_info_1);
> +
> +       /* Validate the APIC ID */
> +       target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
> +       if (!target_vcpu) {
> +               vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from=
 guest\n",
> +                           apic_id);
> +               return -EINVAL;
> +       }
> +
> +       ret =3D 0;
> +
> +       target_svm =3D to_svm(target_vcpu);
> +
> +       /*
> +        * The target vCPU is valid, so the vCPU will be kicked unless th=
e
> +        * request is for CREATE_ON_INIT. For any errors at this stage, t=
he
> +        * kick will place the vCPU in an non-runnable state.
> +        */
> +       kick =3D true;
> +
> +       mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> +
> +       target_svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
> +       target_svm->sev_es.snp_ap_create =3D true;
> +
> +       /* Interrupt injection mode shouldn't change for AP creation */
> +       if (request < SVM_VMGEXIT_AP_DESTROY) {
> +               u64 sev_features;
> +
> +               sev_features =3D vcpu->arch.regs[VCPU_REGS_RAX];
> +               sev_features ^=3D sev->sev_features;
> +               if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
> +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP injection =
mode [%#lx] from guest\n",
> +                                   vcpu->arch.regs[VCPU_REGS_RAX]);
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +       }
> +
> +       switch (request) {
> +       case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> +               kick =3D false;
> +               fallthrough;
> +       case SVM_VMGEXIT_AP_CREATE:
> +               if (!page_address_valid(vcpu, svm->vmcb->control.exit_inf=
o_2)) {
> +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA addre=
ss [%#llx] from guest\n",
> +                                   svm->vmcb->control.exit_info_2);
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
> +               /*
> +                * Malicious guest can RMPADJUST a large page into VMSA w=
hich
> +                * will hit the SNP erratum where the CPU will incorrectl=
y signal
> +                * an RMP violation #PF if a hugepage collides with the R=
MP entry
> +                * of VMSA page, reject the AP CREATE request if VMSA add=
ress from
> +                * guest is 2M aligned.
> +                */
> +               if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE))=
 {
> +                       vcpu_unimpl(vcpu,
> +                                   "vmgexit: AP VMSA address [%llx] from=
 guest is unsafe as it is 2M aligned\n",
> +                                   svm->vmcb->control.exit_info_2);
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
> +               target_svm->sev_es.snp_vmsa_gpa =3D svm->vmcb->control.ex=
it_info_2;
> +               break;
> +       case SVM_VMGEXIT_AP_DESTROY:
> +               break;
> +       default:
> +               vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [=
%#x] from guest\n",
> +                           request);
> +               ret =3D -EINVAL;
> +               break;
> +       }
> +
> +out:
> +       if (kick) {
> +               if (target_vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINIT=
IALIZED)
> +                       target_vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNA=
BLE;
> +
> +               kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, ta=
rget_vcpu);

I think we should  switch the order of these two statements for
setting mp_state and for making the request for
KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.
There is a race condition I observed when booting with SVSM where:
1. BSP sets target vcpu to KVM_MP_STATE_RUNNABLE
2. AP thread within the loop of arch/x86/kvm.c:vcpu_run() checks
vm_vcpu_running()
3. AP enters the guest without having updated the VMSA state from
KVM_REQ_UPDATE_PROTECTED_GUEST_STATE

This results in the AP executing on a bad RIP and then crashing.
If we set the request first, then we avoid the race condition.

> +               kvm_vcpu_kick(target_vcpu);
> +       }
> +
> +       mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
> +
> +       return ret;
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>         struct vmcb_control_area *control =3D &svm->vmcb->control;
> @@ -3565,6 +3773,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>                 vcpu->run->vmgexit.psc.shared_gpa =3D svm->sev_es.sw_scra=
tch;
>                 vcpu->arch.complete_userspace_io =3D snp_complete_psc;
>                 break;
> +       case SVM_VMGEXIT_AP_CREATION:
> +               ret =3D sev_snp_ap_creation(svm);
> +               if (ret) {
> +                       ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ER=
R_INVALID_INPUT);
> +               }
> +
> +               ret =3D 1;
> +               break;
>         case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>                 vcpu_unimpl(vcpu,
>                             "vmgexit: unsupported event - exit_info_1=3D%=
#llx, exit_info_2=3D%#llx\n",
> @@ -3731,6 +3948,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>         set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
>                                             GHCB_VERSION_MIN,
>                                             sev_enc_bit));
> +
> +       mutex_init(&svm->sev_es.snp_vmsa_mutex);
>  }
>
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index da49e4981d75..240518f8d6c7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1398,6 +1398,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, b=
ool init_event)
>         svm->spec_ctrl =3D 0;
>         svm->virt_spec_ctrl =3D 0;
>
> +       if (init_event)
> +               sev_snp_init_protected_guest_state(vcpu);
> +
>         init_vmcb(vcpu);
>
>         if (!init_event)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4ef41f4d4ee6..d953ae41c619 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -96,6 +96,7 @@ struct kvm_sev_info {
>         atomic_t migration_in_progress;
>         u64 snp_init_flags;
>         void *snp_context;      /* SNP guest context page */
> +       u64 sev_features;       /* Features set at VMSA creation */
>  };
>
>  struct kvm_svm {
> @@ -214,6 +215,10 @@ struct vcpu_sev_es_state {
>         bool ghcb_sa_free;
>
>         u64 ghcb_registered_gpa;
> +
> +       struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates=
 of VMSA. */
> +       gpa_t snp_vmsa_gpa;
> +       bool snp_ap_create;
>  };
>
>  struct vcpu_svm {
> @@ -689,7 +694,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *=
vcpu);
>  #define GHCB_VERSION_MAX       2ULL
>  #define GHCB_VERSION_MIN       1ULL
>
> -#define GHCB_HV_FT_SUPPORTED   GHCB_HV_FT_SNP
> +#define GHCB_HV_FT_SUPPORTED   (GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREAT=
ION)
>
>  extern unsigned int max_sev_asid;
>
> @@ -719,6 +724,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_sav=
e_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>  struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_c=
ode);
> +void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>
>  /* vmenter.S */
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 87b78d63e81d..df9ec357d538 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10858,6 +10858,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcp=
u)
>
>                 if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, v=
cpu))
>                         static_call(kvm_x86_update_cpu_dirty_logging)(vcp=
u);
> +
> +               if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STAT=
E, vcpu)) {
> +                       kvm_vcpu_reset(vcpu, true);
> +                       if (vcpu->arch.mp_state !=3D KVM_MP_STATE_RUNNABL=
E) {
> +                               r =3D 1;
> +                               goto out;
> +                       }
> +               }
>         }
>
>         if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> @@ -13072,6 +13080,9 @@ static inline bool kvm_vcpu_has_events(struct kvm=
_vcpu *vcpu)
>         if (kvm_test_request(KVM_REQ_PMI, vcpu))
>                 return true;
>
> +       if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
> +               return true;
> +
>         if (kvm_arch_interrupt_allowed(vcpu) &&
>             (kvm_cpu_has_interrupt(vcpu) ||
>             kvm_guest_apic_has_interrupt(vcpu)))
> --
> 2.25.1
>
>

