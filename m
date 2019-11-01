Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF50AEC107
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 11:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfKAKIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 06:08:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729452AbfKAKIF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 06:08:05 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA1A7VR5006783
        for <kvm@vger.kernel.org>; Fri, 1 Nov 2019 06:08:04 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w0jku869x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 06:08:03 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 1 Nov 2019 10:08:01 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 1 Nov 2019 10:07:57 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA1A7uEg46989578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Nov 2019 10:07:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169BA4C052;
        Fri,  1 Nov 2019 10:07:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F7C4C04A;
        Fri,  1 Nov 2019 10:07:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.72.35])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Nov 2019 10:07:55 +0000 (GMT)
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-4-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Fri, 1 Nov 2019 11:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110110-0028-0000-0000-000003B1C18A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110110-0029-0000-0000-000024740EEB
Message-Id: <f00cf177-246d-8da8-ddfd-a0b1bea930d6@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911010102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.10.19 13:40, Janosch Frank wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Before being able to host protected virtual machines, donate some of
> the memory to the ultravisor. Besides that the ultravisor might impose
> addressing limitations for memory used to back protected VM storage. Treat
> that limit as protected virtualization host's virtual memory limit.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


> ---
>  arch/s390/include/asm/uv.h | 16 ++++++++++++
>  arch/s390/kernel/setup.c   |  3 +++
>  arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 6db1bc495e67..82a46fb913e7 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -23,12 +23,14 @@
>  #define UVC_RC_NO_RESUME	0x0007
>  
>  #define UVC_CMD_QUI			0x0001
> +#define UVC_CMD_INIT_UV			0x000f
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>  #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
>  
>  /* Bits in installed uv calls */
>  enum uv_cmds_inst {
>  	BIT_UVC_CMD_QUI = 0,
> +	BIT_UVC_CMD_INIT_UV = 1,
>  	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
>  	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
>  };
> @@ -59,6 +61,15 @@ struct uv_cb_qui {
>  	u64 reserved98;
>  } __packed __aligned(8);
>  
> +struct uv_cb_init {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 stor_origin;
> +	u64 stor_len;
> +	u64 reserved28[4];
> +
> +} __packed __aligned(8);
> +
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];
> @@ -158,8 +169,13 @@ static inline int is_prot_virt_host(void)
>  {
>  	return prot_virt_host;
>  }
> +
> +void setup_uv(void);
> +void adjust_to_uv_max(unsigned long *vmax);
>  #else
>  #define is_prot_virt_host() 0
> +static inline void setup_uv(void) {}
> +static inline void adjust_to_uv_max(unsigned long *vmax) {}
>  #endif
>  
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index f36370f8af38..d29d83c0b8df 100644
> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -567,6 +567,8 @@ static void __init setup_memory_end(void)
>  			vmax = _REGION1_SIZE; /* 4-level kernel page table */
>  	}
>  
> +	adjust_to_uv_max(&vmax);
> +
>  	/* module area is at the end of the kernel address space. */
>  	MODULES_END = vmax;
>  	MODULES_VADDR = MODULES_END - MODULES_LEN;
> @@ -1147,6 +1149,7 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
>  
> +	setup_uv();
>  	setup_memory_end();
>  	setup_memory();
>  	dma_contiguous_reserve(memory_end);
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 35ce89695509..f7778493e829 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -45,4 +45,57 @@ static int __init prot_virt_setup(char *val)
>  	return rc;
>  }
>  early_param("prot_virt", prot_virt_setup);
> +
> +static int __init uv_init(unsigned long stor_base, unsigned long stor_len)
> +{
> +	struct uv_cb_init uvcb = {
> +		.header.cmd = UVC_CMD_INIT_UV,
> +		.header.len = sizeof(uvcb),
> +		.stor_origin = stor_base,
> +		.stor_len = stor_len,
> +	};
> +	int cc;
> +
> +	cc = uv_call(0, (uint64_t)&uvcb);
> +	if (cc || uvcb.header.rc != UVC_RC_EXECUTED) {
> +		pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
> +		       uvcb.header.rc);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +void __init setup_uv(void)
> +{
> +	unsigned long uv_stor_base;
> +
> +	if (!prot_virt_host)
> +		return;
> +
> +	uv_stor_base = (unsigned long)memblock_alloc_try_nid(
> +		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
> +		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
> +	if (!uv_stor_base) {
> +		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n",
> +			uv_info.uv_base_stor_len);
> +		goto fail;
> +	}
> +
> +	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
> +		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
> +		goto fail;
> +	}
> +
> +	pr_info("Reserving %luMB as ultravisor base storage\n",
> +		uv_info.uv_base_stor_len >> 20);
> +	return;
> +fail:
> +	prot_virt_host = 0;
> +}
> +
> +void adjust_to_uv_max(unsigned long *vmax)
> +{
> +	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> +		*vmax = uv_info.max_sec_stor_addr;
> +}
>  #endif
> 

