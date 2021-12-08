Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A546D3DA
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhLHNBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:01:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229479AbhLHNBR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:01:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Clows031277;
        Wed, 8 Dec 2021 12:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iX6MTS2ZPqKXo8BKu7jTgIaJ1AphhqS27RB1+KTdzF0=;
 b=cCGtbbRjnglWtgBzbRiMauiRH2kgQkcO9wsD3n4E4HG/+zVJYEA8Y5gtrzAKMT67I1eI
 iHDnZ+9SUUg0y0PEDOh3wLjGHlr+bD017MbsaoEx40A4R9c0qRb0PFb6UiOaNPAeULQt
 YyvmYgcSeMmNWtIcaky7njRM2uanl3oD4Ssruyz0dcVOsvcPexMFfoc17+8ppmaEP4nj
 mYSe/Re1+P4NmeM1RUwpoUikaziz9arTXVokvSz8qfgv0B9pdY5LYou+KQl8OP8Y7r20
 nOnpjUCuPHM5xeQrvLKwmMZtpmhh3vILDwMV1NkMDgDhvjKE5HZ/nGCFD/a12j2yr46c /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cttd1kds3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:44 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8ClomX031263;
        Wed, 8 Dec 2021 12:57:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cttd1kdrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CrskN026287;
        Wed, 8 Dec 2021 12:57:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyya7rgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8Cvcdt31064392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:57:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD45311C05C;
        Wed,  8 Dec 2021 12:57:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AC2E11C04C;
        Wed,  8 Dec 2021 12:57:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:57:38 +0000 (GMT)
Date:   Wed, 8 Dec 2021 12:46:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 08/10] lib: s390x: Introduce snippet
 helpers
Message-ID: <20211208124631.1e79d807@p-imbrenda>
In-Reply-To: <20211207160005.1586-9-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
 <20211207160005.1586-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7HscA0fs6SzA4ZBx3S0r-MGWSZqFUWik
X-Proofpoint-GUID: aflr7bZP4CETJTBybIw-rWzgWPMq3Wj4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 16:00:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> These helpers reduce code duplication for PV snippet tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

although I'd prefer different names for the functions.

snippet_setup_guest sounds like it is actually doing something
snippet-related, whereas it is just preparing an empty guest, the
actual snippet part comes later when you call snippet_init.

Maybe rename snippet_setup_guest to something like
"prepare_guest_for_snippet"? (or maybe something shorter, but you get
what I mean) maybe even "prepare_1m_guest"

> ---
>  lib/s390x/snippet.h | 103 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/uv.h      |  21 +++++++++
>  2 files changed, 124 insertions(+)
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index 6b77a8a9..b17b2a4c 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -9,6 +9,10 @@
>  #ifndef _S390X_SNIPPET_H_
>  #define _S390X_SNIPPET_H_
>  
> +#include <sie.h>
> +#include <uv.h>
> +#include <asm/uv.h>
> +
>  /* This macro cuts down the length of the pointers to snippets */
>  #define SNIPPET_NAME_START(type, file) \
>  	_binary_s390x_snippets_##type##_##file##_gbin_start
> @@ -26,6 +30,12 @@
>  #define SNIPPET_HDR_LEN(type, file) \
>  	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
>  
> +#define SNIPPET_PV_TWEAK0	0x42UL
> +#define SNIPPET_PV_TWEAK1	0UL
> +#define SNIPPET_OFF_C		0
> +#define SNIPPET_OFF_ASM		0x4000
> +
> +
>  /*
>   * C snippet instructions start at 0x4000 due to the prefix and the
>   * stack being before that. ASM snippets don't strictly need a stack
> @@ -38,4 +48,97 @@ static const struct psw snippet_psw = {
>  	.mask = PSW_MASK_64,
>  	.addr = SNIPPET_ENTRY_ADDR,
>  };
> +
> +/*
> + * Sets up a snippet guest on top of an existing and initialized SIE
> + * vm struct.
> + * Once this function has finished without errors the guest can be started.
> + *
> + * @vm: VM that this function will populated, has to be initialized already
> + * @gbin: Snippet gbin data pointer
> + * @gbin_len: Length of the gbin data
> + * @off: Offset from guest absolute 0x0 where snippet is copied to
> + */
> +static inline void snippet_init(struct vm *vm, const char *gbin,
> +				uint64_t gbin_len, uint64_t off)
> +{
> +	uint64_t mso = vm->sblk->mso;
> +
> +	/* Copy test image to guest memory */
> +	memcpy((void *)mso + off, gbin, gbin_len);
> +
> +	/* Setup guest PSW */
> +	vm->sblk->gpsw = snippet_psw;
> +
> +	/*
> +	 * We want to exit on PGM exceptions so we don't need
> +	 * exception handlers in the guest.
> +	 */
> +	vm->sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
> +}
> +
> +/*
> + * Sets up a snippet UV/PV guest on top of an existing and initialized
> + * SIE vm struct.
> + * Once this function has finished without errors the guest can be started.
> + *
> + * @vm: VM that this function will populated, has to be initialized already
> + * @gbin: Snippet gbin data pointer
> + * @hdr: Snippet SE header data pointer
> + * @gbin_len: Length of the gbin data
> + * @hdr_len: Length of the hdr data
> + * @off: Offset from guest absolute 0x0 where snippet is copied to
> + */
> +static inline void snippet_pv_init(struct vm *vm, const char *gbin,
> +				   const char *hdr, uint64_t gbin_len,
> +				   uint64_t hdr_len, uint64_t off)
> +{
> +	uint64_t tweak[2] = {SNIPPET_PV_TWEAK0, SNIPPET_PV_TWEAK1};
> +	uint64_t mso = vm->sblk->mso;
> +	int i;
> +
> +	snippet_init(vm, gbin, gbin_len, off);
> +
> +	uv_create_guest(vm);
> +	uv_set_se_hdr(vm->uv.vm_handle, (void *)hdr, hdr_len);
> +
> +	/* Unpack works on guest addresses so we only need off */
> +	uv_unpack(vm, off, gbin_len, tweak[0]);
> +	uv_verify_load(vm);
> +
> +	/*
> +	 * Manually import:
> +	 * - lowcore 0x0 - 0x1000 (asm)
> +	 * - stack 0x3000 (C)
> +	 */
> +	for (i = 0; i < 4; i++) {
> +		uv_import(vm->uv.vm_handle, mso + PAGE_SIZE * i);
> +	}
> +}
> +
> +/* Allocates and sets up a snippet based guest */
> +static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
> +{
> +	u8 *guest;
> +
> +	/* Allocate 1MB as guest memory */
> +	guest = alloc_pages(8);
> +	memset(guest, 0, HPAGE_SIZE);
> +
> +	/* Initialize the vm struct and allocate control blocks */
> +	sie_guest_create(vm, (uint64_t)guest, HPAGE_SIZE);
> +
> +	if (is_pv) {
> +		/* FMT4 needs a ESCA */
> +		sie_guest_sca_create(vm);
> +
> +		/*
> +		 * Initialize UV and setup the address spaces needed
> +		 * to run a PV guest.
> +		 */
> +		uv_init();
> +		uv_setup_asces();
> +	}
> +}
> +
>  #endif
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 6ffe537a..8175d9c6 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -3,6 +3,7 @@
>  #define _S390X_UV_H_
>  
>  #include <sie.h>
> +#include <asm/pgtable.h>
>  
>  bool uv_os_is_guest(void);
>  bool uv_os_is_host(void);
> @@ -14,4 +15,24 @@ void uv_destroy_guest(struct vm *vm);
>  int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t
> tweak); void uv_verify_load(struct vm *vm);
>  
> +/*
> + * To run PV guests we need to setup a few things:
> + * - A valid primary ASCE that contains the guest memory and has the
> P bit set.
> + * - A valid home space ASCE for the UV calls that use home space
> addresses.
> + */
> +static inline void uv_setup_asces(void)
> +{
> +	uint64_t asce;
> +
> +	/* We need to have a valid primary ASCE to run guests. */
> +	setup_vm();
> +
> +	/* Set P bit in ASCE as it is required for PV guests */
> +	asce = stctg(1) | ASCE_P;
> +	lctlg(1, asce);
> +
> +	/* Copy ASCE into home space CR */
> +	lctlg(13, asce);
> +}
> +
>  #endif /* UV_H */

