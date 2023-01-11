Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28B6665D31
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 14:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbjAKN6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 08:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjAKN6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 08:58:53 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA529283;
        Wed, 11 Jan 2023 05:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673445426; bh=YuADhIukjzso+qvG5iLRUe6TT5MMiZ8U+7M409/SnxQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=R1DmbkebQn9RwfBVn+l4TIzRgBsrWKA0B8ypKCIRcStXwnRhIGh92HAFigxK/JzVD
         hlccdwni1jhXszw8QJ4Fqg3JuW41ocNW8aBwmFV817oyqQYa66Ee9jQKxexTVJWobf
         H+WRHc+RB/q6DyH0lW5PeEFj3x8xGySEnKjs4UG1YQfwr5C8c7SIZRxko3eYP+LdAz
         /UHunkcKR7pi99Gpvk9HhtGC2PqJ957DAf5m2xIcQiVt+Hg/vjEjwlcLadwb+TbXlY
         fYnjfyGv11WqpUL9z/GuE6VCvoVDtBaESgAGQYbfPzuL3sTSW2v7tEELiECWLYvYm6
         mibddLnzAwOYg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([134.147.254.72]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MatVb-1odo8v15Z5-00cNWE; Wed, 11
 Jan 2023 14:57:06 +0100
Date:   Wed, 11 Jan 2023 14:56:47 +0100
From:   Tom Dohrmann <erbse.13@gmx.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 39/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
Message-ID: <Y76/I6Nrh7xEAAwv@notebook>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-40-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-40-michael.roth@amd.com>
X-Provags-ID: V03:K1:8FZCWd43RmskiHQZpa68rs/Bu7gr8itPX5xYdET8Ib6C5V4t9TK
 mDKS2gm+cAEX3FAeiWHwThRnz3/Kq8tWbhnA04gFZUs8+iZ2Inn2kZ2bnhbjTCtIB01RQt1
 L3nlrJTxvppqEyd3OCEOsF0xY2rSY1NhEM9vDaRqYnhEaqNpOgt+FcaysMZvYnIgmJub7wI
 kmUsyFmEKYcmK7TcJ/ApQ==
UI-OutboundReport: notjunk:1;M01:P0:afKNR8FM2KE=;LBgTVY+sTMUb8dK6tdpMQHQ7f3c
 fvbCeTwheVKCuqeHFsP9IMs5Z0vS0943VtSd2l8XVHme3l8B+8DQeOJ/KZAbFMQPWxQL2HEwk
 9OgBKZN6mQ9q45S6l3LBw5+etHDIDFS79hGx98BxHGgD1bvFbRYvQ7y7Xomp4SdU/iL/mRljO
 ER71lLA7HP9X8sMxOZamOISySBJeG/WpTGC6kYdpD98fggTfB97fuQHT9cdN9d5K3jQROm+yG
 uC/2micjX7rJPvHQppwtZ+zsQofaZoUt9qA7rCmfdJOYkIPi+zR59C824nWTFA2Uhu5wX2JdF
 7lWSKO9ichn3GtMEXnonrWuLTZf21L64c5KZwuCf7uhWaFXLDJKEMNopvBypjrkpVt+4YceBS
 I6w9OUVISUpdki2CT/oMCpa4+Ec3Sky2mIdc3vm27rza6iiiMNPrSbJqEPsADja5vjf3noevO
 96XEsJsCsvMOFPHJsTVMBB4ULIQp+I+zbZMG7O3KxqFiWTv4xELvnw4vvFQg0Lr76r2xeVO7X
 pMmT0F60PG5gF7NArLhNGcS5ojEam1849Xpd8+N3qKufnd6kr1W8q/FEoAGqCVxLyrBqxb8P8
 hp4dqRxDzK65tNXdPqn8QsRyJANY6oXhYWRjmK2LJn0EBbZZbUiAiziyxPlvb05afxrCeqHrV
 SqDaIvfVUgVLGEak1eGpiDCV5SceVH7MZ5zI56W065XxYedb8gJyhfzNWAtmg5OTr4dhQe7n5
 7zXFIgyiC7XVrEgEjfpFwYVePEiAUUBi/fhReaosBO/c2VvJUIeceWb4y+lwqd845O2/8MVxB
 /WEIx951rwtDmzFH9GSZyCZ/sY+Km5507h42k91NykB3Dsp2CaB5DnhnY1B3ALyv+HpvKoAUF
 xhcUZj0jg/EBDbyMQIZB5wO30Z4FnRwqdvSWkf2dK7Wl7WNSCbpEDkGLmBTL7RG+hWdD4wcs9
 jHqqpYdwqQr0IDx3PTBuP+SV2H0=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:31PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into th=
e
> guest's memory. The data is encrypted with the cryptographic context
> created with the KVM_SEV_SNP_LAUNCH_START.
>
> In addition to the inserting data, it can insert a two special pages
> into the guests memory: the secrets page and the CPUID page.
>
> While terminating the guest, reclaim the guest pages added in the RMP
> table. If the reclaim fails, then the page is no longer safe to be
> released back to the system and leak them.
>
> For more information see the SEV-SNP specification.
>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  29 ++++
>  arch/x86/kvm/svm/sev.c                        | 161 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 +++
>  3 files changed, 209 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Docu=
mentation/virt/kvm/x86/amd-memory-encryption.rst
> index 58971fc02a15..c94be8e6d657 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -485,6 +485,35 @@ Returns: 0 on success, -negative on error
>
>  See the SEV-SNP specification for further detail on the launch input.
>
> +20. KVM_SNP_LAUNCH_UPDATE
> +-------------------------
> +
> +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It al=
so
> +calculates a measurement of the memory contents. The measurement is a s=
ignature
> +of the memory contents that can be sent to the guest owner as an attest=
ation
> +that the memory was encrypted correctly by the firmware.
> +
> +Parameters (in): struct  kvm_snp_launch_update
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_update {
> +                __u64 start_gfn;        /* Guest page number to start f=
rom. */
> +                __u64 uaddr;            /* userspace address need to be=
 encrypted */
> +                __u32 len;              /* length of memory region */
> +                __u8 imi_page;          /* 1 if memory is part of the I=
MI */
> +                __u8 page_type;         /* page type */
> +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> +        };
> +
> +See the SEV-SNP spec for further details on how to build the VMPL permi=
ssion
> +mask and page type.
> +
> +
>  References
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6d1d0e424f76..379e61a9226a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -238,6 +238,37 @@ static void sev_decommission(unsigned int handle)
>  	sev_guest_decommission(&decommission, NULL);
>  }
>
> +static int snp_page_reclaim(u64 pfn)
> +{
> +	struct sev_data_snp_page_reclaim data =3D {0};
> +	int err, rc;
> +
> +	data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
> +	rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +	if (rc) {
> +		/*
> +		 * If the reclaim failed, then page is no longer safe
> +		 * to use.
> +		 */
> +		snp_mark_pages_offline(pfn,
> +				       page_level_size(PG_LEVEL_4K) >> PAGE_SHIFT);
> +	}
> +
> +	return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak=
)
> +{
> +	int rc;
> +
> +	rc =3D rmp_make_shared(pfn, level);
> +	if (rc && leak)
> +		snp_mark_pages_offline(pfn,
> +				       page_level_size(level) >> PAGE_SHIFT);
> +
> +	return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>  	struct sev_data_deactivate deactivate;
> @@ -2085,6 +2116,133 @@ static int snp_launch_start(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
>  	return rc;
>  }
>
> +static int snp_launch_update_gfn_handler(struct kvm *kvm,
> +					 struct kvm_gfn_range *range,
> +					 void *opaque)
> +{
> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_memory_slot *memslot =3D range->slot;
> +	struct sev_data_snp_launch_update data =3D {0};
> +	struct kvm_sev_snp_launch_update params;
> +	struct kvm_sev_cmd *argp =3D opaque;
> +	int *error =3D &argp->error;
> +	int i, n =3D 0, ret =3D 0;
> +	unsigned long npages;
> +	kvm_pfn_t *pfns;
> +	gfn_t gfn;
> +
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		pr_err("SEV-SNP requires restricted memory.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, size=
of(params))) {
> +		pr_err("Failed to copy user parameters for SEV-SNP launch.\n");
> +		return -EFAULT;
> +	}
> +
> +	data.gctx_paddr =3D __psp_pa(sev->snp_context);
> +
> +	npages =3D range->end - range->start;
> +	pfns =3D kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL_ACCOUNT);
> +	if (!pfns)
> +		return -ENOMEM;
> +
> +	pr_debug("%s: GFN range 0x%llx-0x%llx, type %d\n", __func__,
> +		 range->start, range->end, params.page_type);
> +
> +	for (gfn =3D range->start, i =3D 0; gfn < range->end; gfn++, i++) {
> +		int order, level;
> +		void *kvaddr;
> +
> +		ret =3D kvm_restricted_mem_get_pfn(memslot, gfn, &pfns[i], &order);
> +		if (ret)
> +			goto e_release;
> +
> +		n++;
> +		ret =3D snp_lookup_rmpentry((u64)pfns[i], &level);
> +		if (ret) {
> +			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret:=
 %d\n",
> +			       gfn, ret);
> +			return -EFAULT;
> +		}
> +
> +		kvaddr =3D pfn_to_kaddr(pfns[i]);
> +		if (!virt_addr_valid(kvaddr)) {
> +			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn)=
;
> +			ret =3D -EINVAL;
> +			goto e_release;
> +		}
> +
> +		ret =3D kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> +		if (ret) {
> +			pr_err("Guest read failed, ret: 0x%x\n", ret);
> +			goto e_release;
> +		}
> +
> +		ret =3D rmp_make_private(pfns[i], gfn << PAGE_SHIFT, PG_LEVEL_4K,
> +				       sev_get_asid(kvm), true);
> +		if (ret) {
> +			ret =3D -EFAULT;
> +			goto e_release;
> +		}
> +
> +		data.address =3D __sme_set(pfns[i] << PAGE_SHIFT);
> +		data.page_size =3D X86_TO_RMP_PG_LEVEL(PG_LEVEL_4K);
> +		data.page_type =3D params.page_type;
> +		data.vmpl3_perms =3D params.vmpl3_perms;
> +		data.vmpl2_perms =3D params.vmpl2_perms;
> +		data.vmpl1_perms =3D params.vmpl1_perms;
> +		ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +				      &data, error);
> +		if (ret) {
> +			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
> +			       ret, *error);
> +			snp_page_reclaim(pfns[i]);
> +			goto e_release;

When a launch update fails for a CPUID page with error `INVALID_PARAM` the
firmware writes back corrected values. We should probably write these valu=
es
back to userspace. Before UPM was introduced this happened automatically
because we didn't copy the page to private memory and did the update
completly in place.

> +		}
> +	}
> +
> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRI=
BUTE_PRIVATE);
> +
> +e_release:
> +	/* Content of memory is updated, mark pages dirty */
> +	for (i =3D 0; i < n; i++) {
> +		set_page_dirty(pfn_to_page(pfns[i]));
> +		mark_page_accessed(pfn_to_page(pfns[i]));
> +
> +		/*
> +		 * If its an error, then update RMP entry to change page ownership
> +		 * to the hypervisor.
> +		 */
> +		if (ret)
> +			host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> +
> +		put_page(pfn_to_page(pfns[i]));
> +	}
> +
> +	kvfree(pfns);
> +	return ret;
> +}
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_snp_launch_update params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, size=
of(params)))
> +		return -EFAULT;
> +
> +	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params=
.len,
> +				      snp_launch_update_gfn_handler, argp);
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -2178,6 +2336,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user=
 *argp)
>  	case KVM_SEV_SNP_LAUNCH_START:
>  		r =3D snp_launch_start(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_LAUNCH_UPDATE:
> +		r =3D snp_launch_update(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r =3D -EINVAL;
>  		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b2311e0abeef..9b6c95cc62a8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1941,6 +1941,7 @@ enum sev_cmd_id {
>  	/* SNP specific commands */
>  	KVM_SEV_SNP_INIT,
>  	KVM_SEV_SNP_LAUNCH_START,
> +	KVM_SEV_SNP_LAUNCH_UPDATE,
>
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2057,6 +2058,24 @@ struct kvm_sev_snp_launch_start {
>  	__u8 pad[6];
>  };
>
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
> +
> +struct kvm_sev_snp_launch_update {
> +	__u64 start_gfn;
> +	__u64 uaddr;
> +	__u32 len;
> +	__u8 imi_page;
> +	__u8 page_type;
> +	__u8 vmpl3_perms;
> +	__u8 vmpl2_perms;
> +	__u8 vmpl1_perms;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> --
> 2.25.1
>

Regards, Tom
