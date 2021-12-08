Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0046D4E7
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhLHN77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:59:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhLHN76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:59:58 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DmiCM027529;
        Wed, 8 Dec 2021 13:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bgRgTS8k1pFAQ15gZHvh75o0a+WeH1sf/g/A8PUiKUw=;
 b=fHqRtVih/+RYgqULLWZAA6VLhZp2JLgCLn7s21nnMDpAmE3umNVNOhSS/RuJghfaFP6i
 qvmVzOc8zYcLa3C36QnDLI8//Lw0k/K74gejhFqNjQ2JzoovjYQWfChyBcJ8G/1e4RDJ
 LlFdiwkPPwmTlCyKJhuJrEVSeJ+oE1wdhfVF9LYOygaKzQv7yf15WkODk2WFtXLGAOja
 UJtEdqma1pWERYIcfZcDH0AcKgrnyIxrmmMv0GREs+jL39P/NyXIbJ5aUcfdHlc6vHeX
 9mbG4s7+OYRYjyHa1c3w8WaiQ0pmfYH9wLonc/pbcrG5XorMF1HpcZVu9j1mxgaXEcGd LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctwwnr4q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:56:26 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8DoMYG003454;
        Wed, 8 Dec 2021 13:56:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctwwnr4pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:56:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DqsZS015107;
        Wed, 8 Dec 2021 13:56:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy9pt0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:56:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8DuKix28836100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 13:56:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11821AE045;
        Wed,  8 Dec 2021 13:56:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92F45AE04D;
        Wed,  8 Dec 2021 13:56:19 +0000 (GMT)
Received: from [9.145.90.190] (unknown [9.145.90.190])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 13:56:19 +0000 (GMT)
Message-ID: <51679135-2f4b-ea1f-30b4-6549179a6098@linux.ibm.com>
Date:   Wed, 8 Dec 2021 14:56:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 08/10] lib: s390x: Introduce snippet
 helpers
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
References: <20211207160005.1586-1-frankja@linux.ibm.com>
 <20211207160005.1586-9-frankja@linux.ibm.com>
 <20211208124631.1e79d807@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211208124631.1e79d807@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AZL69zedAA1L48OO6rB_pm2TobBdNK8J
X-Proofpoint-GUID: wRE9W1iw7O6rVicilZZO9fB7rjotSNbE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 12:46, Claudio Imbrenda wrote:
> On Tue,  7 Dec 2021 16:00:03 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> These helpers reduce code duplication for PV snippet tests.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> although I'd prefer different names for the functions.
> 
> snippet_setup_guest sounds like it is actually doing something
> snippet-related, whereas it is just preparing an empty guest, the
> actual snippet part comes later when you call snippet_init.
> 
> Maybe rename snippet_setup_guest to something like
> "prepare_guest_for_snippet"? (or maybe something shorter, but you get
> what I mean) maybe even "prepare_1m_guest"

snippet_setup_guest_shell() ?

> 
>> ---
>>   lib/s390x/snippet.h | 103 ++++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/uv.h      |  21 +++++++++
>>   2 files changed, 124 insertions(+)
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> index 6b77a8a9..b17b2a4c 100644
>> --- a/lib/s390x/snippet.h
>> +++ b/lib/s390x/snippet.h
>> @@ -9,6 +9,10 @@
>>   #ifndef _S390X_SNIPPET_H_
>>   #define _S390X_SNIPPET_H_
>>   
>> +#include <sie.h>
>> +#include <uv.h>
>> +#include <asm/uv.h>
>> +
>>   /* This macro cuts down the length of the pointers to snippets */
>>   #define SNIPPET_NAME_START(type, file) \
>>   	_binary_s390x_snippets_##type##_##file##_gbin_start
>> @@ -26,6 +30,12 @@
>>   #define SNIPPET_HDR_LEN(type, file) \
>>   	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
>>   
>> +#define SNIPPET_PV_TWEAK0	0x42UL
>> +#define SNIPPET_PV_TWEAK1	0UL
>> +#define SNIPPET_OFF_C		0
>> +#define SNIPPET_OFF_ASM		0x4000
>> +
>> +
>>   /*
>>    * C snippet instructions start at 0x4000 due to the prefix and the
>>    * stack being before that. ASM snippets don't strictly need a stack
>> @@ -38,4 +48,97 @@ static const struct psw snippet_psw = {
>>   	.mask = PSW_MASK_64,
>>   	.addr = SNIPPET_ENTRY_ADDR,
>>   };
>> +
>> +/*
>> + * Sets up a snippet guest on top of an existing and initialized SIE
>> + * vm struct.
>> + * Once this function has finished without errors the guest can be started.
>> + *
>> + * @vm: VM that this function will populated, has to be initialized already
>> + * @gbin: Snippet gbin data pointer
>> + * @gbin_len: Length of the gbin data
>> + * @off: Offset from guest absolute 0x0 where snippet is copied to
>> + */
>> +static inline void snippet_init(struct vm *vm, const char *gbin,
>> +				uint64_t gbin_len, uint64_t off)
>> +{
>> +	uint64_t mso = vm->sblk->mso;
>> +
>> +	/* Copy test image to guest memory */
>> +	memcpy((void *)mso + off, gbin, gbin_len);
>> +
>> +	/* Setup guest PSW */
>> +	vm->sblk->gpsw = snippet_psw;
>> +
>> +	/*
>> +	 * We want to exit on PGM exceptions so we don't need
>> +	 * exception handlers in the guest.
>> +	 */
>> +	vm->sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>> +}
>> +
>> +/*
>> + * Sets up a snippet UV/PV guest on top of an existing and initialized
>> + * SIE vm struct.
>> + * Once this function has finished without errors the guest can be started.
>> + *
>> + * @vm: VM that this function will populated, has to be initialized already
>> + * @gbin: Snippet gbin data pointer
>> + * @hdr: Snippet SE header data pointer
>> + * @gbin_len: Length of the gbin data
>> + * @hdr_len: Length of the hdr data
>> + * @off: Offset from guest absolute 0x0 where snippet is copied to
>> + */
>> +static inline void snippet_pv_init(struct vm *vm, const char *gbin,
>> +				   const char *hdr, uint64_t gbin_len,
>> +				   uint64_t hdr_len, uint64_t off)
>> +{
>> +	uint64_t tweak[2] = {SNIPPET_PV_TWEAK0, SNIPPET_PV_TWEAK1};
>> +	uint64_t mso = vm->sblk->mso;
>> +	int i;
>> +
>> +	snippet_init(vm, gbin, gbin_len, off);
>> +
>> +	uv_create_guest(vm);
>> +	uv_set_se_hdr(vm->uv.vm_handle, (void *)hdr, hdr_len);
>> +
>> +	/* Unpack works on guest addresses so we only need off */
>> +	uv_unpack(vm, off, gbin_len, tweak[0]);
>> +	uv_verify_load(vm);
>> +
>> +	/*
>> +	 * Manually import:
>> +	 * - lowcore 0x0 - 0x1000 (asm)
>> +	 * - stack 0x3000 (C)
>> +	 */
>> +	for (i = 0; i < 4; i++) {
>> +		uv_import(vm->uv.vm_handle, mso + PAGE_SIZE * i);
>> +	}
>> +}
>> +
>> +/* Allocates and sets up a snippet based guest */
>> +static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
>> +{
>> +	u8 *guest;
>> +
>> +	/* Allocate 1MB as guest memory */
>> +	guest = alloc_pages(8);
>> +	memset(guest, 0, HPAGE_SIZE);
>> +
>> +	/* Initialize the vm struct and allocate control blocks */
>> +	sie_guest_create(vm, (uint64_t)guest, HPAGE_SIZE);
>> +
>> +	if (is_pv) {
>> +		/* FMT4 needs a ESCA */
>> +		sie_guest_sca_create(vm);
>> +
>> +		/*
>> +		 * Initialize UV and setup the address spaces needed
>> +		 * to run a PV guest.
>> +		 */
>> +		uv_init();
>> +		uv_setup_asces();
>> +	}
>> +}
>> +
>>   #endif
>> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
>> index 6ffe537a..8175d9c6 100644
>> --- a/lib/s390x/uv.h
>> +++ b/lib/s390x/uv.h
>> @@ -3,6 +3,7 @@
>>   #define _S390X_UV_H_
>>   
>>   #include <sie.h>
>> +#include <asm/pgtable.h>
>>   
>>   bool uv_os_is_guest(void);
>>   bool uv_os_is_host(void);
>> @@ -14,4 +15,24 @@ void uv_destroy_guest(struct vm *vm);
>>   int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t
>> tweak); void uv_verify_load(struct vm *vm);
>>   
>> +/*
>> + * To run PV guests we need to setup a few things:
>> + * - A valid primary ASCE that contains the guest memory and has the
>> P bit set.
>> + * - A valid home space ASCE for the UV calls that use home space
>> addresses.
>> + */
>> +static inline void uv_setup_asces(void)
>> +{
>> +	uint64_t asce;
>> +
>> +	/* We need to have a valid primary ASCE to run guests. */
>> +	setup_vm();
>> +
>> +	/* Set P bit in ASCE as it is required for PV guests */
>> +	asce = stctg(1) | ASCE_P;
>> +	lctlg(1, asce);
>> +
>> +	/* Copy ASCE into home space CR */
>> +	lctlg(13, asce);
>> +}
>> +
>>   #endif /* UV_H */
> 

