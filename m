Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4490D1528AF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgBEJxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:53:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728061AbgBEJxH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 04:53:07 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0159oq70033439
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 04:53:05 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhn2gnv1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:53:04 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 5 Feb 2020 09:53:03 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 09:52:59 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0159qweZ43188324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 09:52:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32AD2AE053;
        Wed,  5 Feb 2020 09:52:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB83AE04D;
        Wed,  5 Feb 2020 09:52:57 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 09:52:57 +0000 (GMT)
Subject: Re: [RFCv2 05/37] s390/mm: provide memory management functions for
 protected KVM guests
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-6-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 5 Feb 2020 10:52:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-6-borntraeger@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I0cnfmJnUd5YoLsHwgnKyfsLQ4VdgFDMs"
X-TM-AS-GCONF: 00
x-cbid: 20020509-0012-0000-0000-00000383DAB3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020509-0013-0000-0000-000021C04475
Message-Id: <24c74c31-578f-1387-afbd-b0daddc50e58@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_02:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=13 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=983 bulkscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I0cnfmJnUd5YoLsHwgnKyfsLQ4VdgFDMs
Content-Type: multipart/mixed; boundary="ZrwNSBofzZnuYTplWjbXBluSLRVg0zvv2"

--ZrwNSBofzZnuYTplWjbXBluSLRVg0zvv2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/3/20 2:19 PM, Christian Borntraeger wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> This provides the basic ultravisor calls and page table handling to cop=
e
> with secure guests.
>=20
> Co-authored-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h        |   2 +
>  arch/s390/include/asm/mmu.h         |   2 +
>  arch/s390/include/asm/mmu_context.h |   1 +
>  arch/s390/include/asm/page.h        |   5 +
>  arch/s390/include/asm/pgtable.h     |  34 +++++-
>  arch/s390/include/asm/uv.h          |  59 ++++++++++
>  arch/s390/kernel/uv.c               | 170 ++++++++++++++++++++++++++++=

>  7 files changed, 268 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.=
h
> index 37f96b6f0e61..f2ab8b6d4b57 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -9,6 +9,7 @@
>  #ifndef _ASM_S390_GMAP_H
>  #define _ASM_S390_GMAP_H
>=20
> +#include <linux/radix-tree.h>
>  #include <linux/refcount.h>
>=20
>  /* Generic bits for GMAP notification on DAT table entry changes. */
> @@ -61,6 +62,7 @@ struct gmap {
>  	spinlock_t shadow_lock;
>  	struct gmap *parent;
>  	unsigned long orig_asce;
> +	unsigned long se_handle;
>  	int edat_level;
>  	bool removed;
>  	bool initialized;
> diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
> index bcfb6371086f..984026cb3608 100644
> --- a/arch/s390/include/asm/mmu.h
> +++ b/arch/s390/include/asm/mmu.h
> @@ -16,6 +16,8 @@ typedef struct {
>  	unsigned long asce;
>  	unsigned long asce_limit;
>  	unsigned long vdso_base;
> +	/* The mmu context belongs to a secure guest. */
> +	atomic_t is_se;
>  	/*
>  	 * The following bitfields need a down_write on the mm
>  	 * semaphore when they are written to. As they are only
> diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/as=
m/mmu_context.h
> index 8d04e6f3f796..0e5e67ecdaf8 100644
> --- a/arch/s390/include/asm/mmu_context.h
> +++ b/arch/s390/include/asm/mmu_context.h
> @@ -23,6 +23,7 @@ static inline int init_new_context(struct task_struct=
 *tsk,
>  	INIT_LIST_HEAD(&mm->context.gmap_list);
>  	cpumask_clear(&mm->context.cpu_attach_mask);
>  	atomic_set(&mm->context.flush_count, 0);
> +	atomic_set(&mm->context.is_se, 0);
>  	mm->context.gmap_asce =3D 0;
>  	mm->context.flush_mm =3D 0;
>  	mm->context.compat_mm =3D test_thread_flag(TIF_31BIT);
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.=
h
> index a4d38092530a..eb209416c45b 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -151,6 +151,11 @@ static inline int devmem_is_allowed(unsigned long =
pfn)
>  #define HAVE_ARCH_FREE_PAGE
>  #define HAVE_ARCH_ALLOC_PAGE
>=20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +int arch_make_page_accessible(struct page *page);
> +#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> +#endif
> +
>  #endif /* !__ASSEMBLY__ */
>=20
>  #define __PAGE_OFFSET		0x0UL
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pg=
table.h
> index 7b03037a8475..65b6bb47af0a 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -19,6 +19,7 @@
>  #include <linux/atomic.h>
>  #include <asm/bug.h>
>  #include <asm/page.h>
> +#include <asm/uv.h>
>=20
>  extern pgd_t swapper_pg_dir[];
>  extern void paging_init(void);
> @@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct mm_struct *m=
m)
>  	return 0;
>  }
>=20
> +static inline int mm_is_se(struct mm_struct *mm)
> +{
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +	if (unlikely(atomic_read(&mm->context.is_se)))
> +		return 1;
> +#endif
> +	return 0;
> +}
> +
>  static inline int mm_alloc_pgste(struct mm_struct *mm)
>  {
>  #ifdef CONFIG_PGSTE
> @@ -1059,7 +1069,12 @@ static inline int ptep_clear_flush_young(struct =
vm_area_struct *vma,
>  static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  				       unsigned long addr, pte_t *ptep)
>  {
> -	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	pte_t res;
> +
> +	res =3D ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	if (mm_is_se(mm) && pte_present(res))
> +		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +	return res;
>  }
>=20
>  #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
> @@ -1071,7 +1086,12 @@ void ptep_modify_prot_commit(struct vm_area_stru=
ct *, unsigned long,
>  static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
>  				     unsigned long addr, pte_t *ptep)
>  {
> -	return ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID))=
;
> +	pte_t res;
> +
> +	res =3D ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID)=
);
> +	if (mm_is_se(vma->vm_mm) && pte_present(res))
> +		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +	return res;
>  }
>=20
>  /*
> @@ -1086,12 +1106,16 @@ static inline pte_t ptep_get_and_clear_full(str=
uct mm_struct *mm,
>  					    unsigned long addr,
>  					    pte_t *ptep, int full)
>  {
> +	pte_t res;
>  	if (full) {
> -		pte_t pte =3D *ptep;
> +		res =3D *ptep;
>  		*ptep =3D __pte(_PAGE_INVALID);
> -		return pte;
> +	} else {
> +		res =3D ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>  	}
> -	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	if (mm_is_se(mm) && pte_present(res))
> +		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +	return res;
>  }
>=20
>  #define __HAVE_ARCH_PTEP_SET_WRPROTECT
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index cdf2fd71d7ab..4eaea95f5c64 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -15,6 +15,7 @@
>  #include <linux/errno.h>
>  #include <linux/bug.h>
>  #include <asm/page.h>
> +#include <asm/gmap.h>
>=20
>  #define UVC_RC_EXECUTED		0x0001
>  #define UVC_RC_INV_CMD		0x0002
> @@ -24,6 +25,10 @@
>=20
>  #define UVC_CMD_QUI			0x0001
>  #define UVC_CMD_INIT_UV			0x000f
> +#define UVC_CMD_CONV_TO_SEC_STOR	0x0200
> +#define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
> +#define UVC_CMD_PIN_PAGE_SHARED		0x0341
> +#define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>  #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
>=20
> @@ -31,8 +36,12 @@
>  enum uv_cmds_inst {
>  	BIT_UVC_CMD_QUI =3D 0,
>  	BIT_UVC_CMD_INIT_UV =3D 1,
> +	BIT_UVC_CMD_CONV_TO_SEC_STOR =3D 6,
> +	BIT_UVC_CMD_CONV_FROM_SEC_STOR =3D 7,
>  	BIT_UVC_CMD_SET_SHARED_ACCESS =3D 8,
>  	BIT_UVC_CMD_REMOVE_SHARED_ACCESS =3D 9,
> +	BIT_UVC_CMD_PIN_PAGE_SHARED =3D 21,
> +	BIT_UVC_CMD_UNPIN_PAGE_SHARED =3D 22,
>  };
>=20
>  struct uv_cb_header {
> @@ -70,6 +79,19 @@ struct uv_cb_init {
>=20
>  } __packed __aligned(8);
>=20
> +struct uv_cb_cts {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 gaddr;
> +} __packed __aligned(8);
> +
> +struct uv_cb_cfs {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 paddr;
> +} __packed __aligned(8);
> +
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];
> @@ -170,12 +192,49 @@ static inline int is_prot_virt_host(void)
>  	return prot_virt_host;
>  }
>=20
> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb,=
 int pins);
> +int uv_convert_from_secure(unsigned long paddr);
> +
> +static inline int uv_convert_to_secure_pinned(struct gmap *gmap,
> +					      unsigned long gaddr,
> +					      int pins)
> +{
> +	struct uv_cb_cts uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D gmap->se_handle,
> +		.gaddr =3D gaddr,
> +	};
> +
> +	return uv_make_secure(gmap, gaddr, &uvcb, pins);
> +}
> +
> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned lon=
g gaddr)
> +{
> +	return uv_convert_to_secure_pinned(gmap, gaddr, 0);
> +}
> +
>  void setup_uv(void);
>  void adjust_to_uv_max(unsigned long *vmax);
>  #else
>  #define is_prot_virt_host() 0
>  static inline void setup_uv(void) {}
>  static inline void adjust_to_uv_max(unsigned long *vmax) {}
> +
> +static inline int uv_make_secure(struct gmap *gmap, unsigned long gadd=
r, void *uvcb, int pins)
> +{
> +	return 0;
> +}
> +
> +static inline int uv_convert_from_secure(unsigned long paddr)
> +{
> +	return 0;
> +}
> +
> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned lon=
g gaddr)
> +{
> +	return 0;
> +}
>  #endif
>=20
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                 =
         \
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f7778493e829..136c60a8e3ca 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -9,6 +9,8 @@
>  #include <linux/sizes.h>
>  #include <linux/bitmap.h>
>  #include <linux/memblock.h>
> +#include <linux/pagemap.h>
> +#include <linux/swap.h>
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  #include <asm/uv.h>
> @@ -98,4 +100,172 @@ void adjust_to_uv_max(unsigned long *vmax)
>  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>  		*vmax =3D uv_info.max_sec_stor_addr;
>  }
> +
> +static int __uv_pin_shared(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb =3D {
> +		.header.cmd	=3D UVC_CMD_PIN_PAGE_SHARED,
> +		.header.len	=3D sizeof(uvcb),
> +		.paddr		=3D paddr,
> +	};

We completely loose .header.rc and rrc if something goes wrong and hence
we'll have no way finding out what went wrong after the fact.

We should either make sure to warn_on_once() or come up with a way of
logging that to somewhere useful.

> +
> +	if (uv_call(0, (u64)&uvcb))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/*
> + * Requests the Ultravisor to encrypt a guest page and make it
> + * accessible to the host for paging (export).
> + *
> + * @paddr: Absolute host address of page to be exported
> + */
> +int uv_convert_from_secure(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_FROM_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.paddr =3D paddr
> +	};
> +
> +	uv_call(0, (u64)&uvcb);
> +
> +	if (uvcb.header.rc =3D=3D 1 || uvcb.header.rc =3D=3D 0x107)

Magic constant is magic
We either need a comment, or a constant with a fitting name. That also
goes for the 0x10a.

> +		return 0;
> +	return -EINVAL;
> +}
> +
> +static int expected_page_refs(struct page *page)
> +{
> +	int res;
> +
> +	res =3D page_mapcount(page);
> +	if (PageSwapCache(page))
> +		res++;
> +	else if (page_mapping(page)) {
> +		res++;
> +		if (page_has_private(page))
> +			res++;
> +	}
> +	return res;
> +}
> +
> +struct conv_params {
> +	struct uv_cb_header *uvcb;
> +	struct page *page;
> +	int extra_pins;
> +};
> +
> +static int make_secure_pte(pte_t *ptep, unsigned long addr, void *data=
)
> +{
> +	struct conv_params *params =3D data;
> +	pte_t entry =3D READ_ONCE(*ptep);
> +	struct page *page;
> +	int expected, rc =3D 0;
> +
> +	if (!pte_present(entry))
> +		return -ENXIO;
> +	if (pte_val(entry) & (_PAGE_INVALID | _PAGE_PROTECT))
> +		return -ENXIO;
> +
> +	page =3D pte_page(entry);
> +	if (page !=3D params->page)
> +		return -ENXIO;
> +
> +	if (PageWriteback(page))
> +		return -EAGAIN;
> +	expected =3D expected_page_refs(page) + params->extra_pins;
> +	if (!page_ref_freeze(page, expected))
> +		return -EBUSY;
> +	set_bit(PG_arch_1, &page->flags);
> +	rc =3D uv_call(0, (u64)params->uvcb);
> +	page_ref_unfreeze(page, expected);
> +	if (rc)
> +		rc =3D (params->uvcb->rc =3D=3D 0x10a) ? -ENXIO : -EINVAL;
> +	return rc;
> +}
> +
> +/*
> + * Requests the Ultravisor to make a page accessible to a guest.
> + * If it's brought in the first time, it will be cleared. If
> + * it has been exported before, it will be decrypted and integrity
> + * checked.
> + *
> + * @gmap: Guest mapping
> + * @gaddr: Guest 2 absolute address to be imported
> + */
> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb,=
 int pins)
> +{
> +	struct conv_params params =3D { .uvcb =3D uvcb, .extra_pins =3D pins =
};
> +	struct vm_area_struct *vma;
> +	unsigned long uaddr;
> +	int rc, local_drain =3D 0;
> +
> +again:
> +	rc =3D -EFAULT;
> +	down_read(&gmap->mm->mmap_sem);
> +
> +	uaddr =3D __gmap_translate(gmap, gaddr);
> +	if (IS_ERR_VALUE(uaddr))
> +		goto out;
> +	vma =3D find_vma(gmap->mm, uaddr);
> +	if (!vma)
> +		goto out;
> +	if (is_vm_hugetlb_page(vma))
> +		goto out;
> +
> +	rc =3D -ENXIO;
> +	params.page =3D follow_page(vma, uaddr, FOLL_WRITE | FOLL_NOWAIT);
> +	if (IS_ERR_OR_NULL(params.page))
> +		goto out;
> +
> +	lock_page(params.page);
> +	rc =3D apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE, make_secure_pt=
e, &params);
> +	unlock_page(params.page);
> +out:
> +	up_read(&gmap->mm->mmap_sem);
> +
> +	if (rc =3D=3D -EBUSY) {
> +		if (local_drain) {
> +			lru_add_drain_all();
> +			return -EAGAIN;
> +		}
> +		lru_add_drain();
> +		local_drain =3D 1;
> +		goto again;
> +	} else if (rc =3D=3D -ENXIO) {
> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
> +			return -EFAULT;
> +		return -EAGAIN;
> +	}
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(uv_make_secure);
> +
> +/**
> + * To be called with the page locked or with an extra reference!
> + */
> +int arch_make_page_accessible(struct page *page)
> +{
> +	int rc =3D 0;
> +
> +	if (!test_bit(PG_arch_1, &page->flags))
> +		return 0;
> +
> +	rc =3D __uv_pin_shared(page_to_phys(page));
> +	if (!rc) {
> +		clear_bit(PG_arch_1, &page->flags);
> +		return 0;
> +	}
> +
> +	rc =3D uv_convert_from_secure(page_to_phys(page));
> +	if (!rc) {
> +		clear_bit(PG_arch_1, &page->flags);
> +		return 0;
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(arch_make_page_accessible);
> +
>  #endif
>=20



--ZrwNSBofzZnuYTplWjbXBluSLRVg0zvv2--

--I0cnfmJnUd5YoLsHwgnKyfsLQ4VdgFDMs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl46kHkACgkQ41TmuOI4
ufgv7A//QkECPfz1+ErA979xR8X9KVVN/qfQuMVOj7A6VL446tGJG4LoTSE1Xa62
49ItVnvSgwoe2F6P3EKHGjWaz2lTbS2EeJW2Bse7J2v6gZllLjsJt2Kod5MVwMAc
q0wPOUxDB3D7C9ZTiTS9mE8Fv+G073iCtuixsqzBFRjQLDFRrkCNu9hH3h07pqiM
ungAkdNL2m1O3k2pzXmFv5zJzjnaYHaJsHlkgxc3C+bTa3Df+pkeJqvdaX+wxcqZ
SUPNH+jNav89Rvtm5rNpdG6chYT0u/pYLwBcgrW9AXnCE/hypARZu2B9iL/6UceR
c3zaKglaJW27xmoRz2g18ij0/8E+O58PzFBmix/3j+Ma1Rz6zOKOLmJ+d8yIiFJ5
zy168WWjw2T8vxzE6zJ4YaUYWk318ZgTe8fHSMHb5im1E4JzpWcqR9qXXrP+tDbI
VXTZSTaMMMMK615FNIQlItDMyV5Rm3kGWD/fztLiB9jHlUw1vu/VhNCThPYmwBgt
en1mX8hAvPgjFkYUs5oU7AmIt0yHctY1yABv2o9NvQLl6RZvJS6Gq0tx+cq8CpkY
tqt0hZGLYGezdjAt9wz1Ak4w76Ctwb6+n1TdhmGj6B3WEYHM113yzlx26BRpY7Te
R/Yn97pGvTyZ76dXpI19x22iq5DNrpm8vHALb3B/eft1dNzYAw8=
=DVbR
-----END PGP SIGNATURE-----

--I0cnfmJnUd5YoLsHwgnKyfsLQ4VdgFDMs--

