Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA518FDC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfEISF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 14:05:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726683AbfEISF2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 14:05:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49I0tie039828
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 14:05:27 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2scr0hjrcs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 14:05:27 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <jjherne@linux.ibm.com>;
        Thu, 9 May 2019 19:05:26 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 19:05:24 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49I5L1X34144330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 18:05:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80CF228066;
        Thu,  9 May 2019 18:05:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2287428060;
        Thu,  9 May 2019 18:05:21 +0000 (GMT)
Received: from [9.60.75.213] (unknown [9.60.75.213])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 18:05:21 +0000 (GMT)
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH 04/10] s390/mm: force swiotlb for protected virtualization
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, "Cornelia Huck ," <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>
References: <20190426183245.37939-5-pasic@linux.ibm.com>
 <ad23f5e7-dc78-04af-c892-47bbc65134c6@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin ," <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Thomas Huth ," <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        "Vasily Gorbik ," <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
Date:   Thu, 9 May 2019 14:05:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <ad23f5e7-dc78-04af-c892-47bbc65134c6@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050918-0060-0000-0000-0000033E0CE0
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011078; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01200929; UDB=6.00630161; IPR=6.00981820;
 MB=3.00026815; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-09 18:05:26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050918-0061-0000-0000-000049494241
Message-Id: <4c7a990a-7f11-17f3-2024-18acaf7ceb06@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Subject: [PATCH 04/10] s390/mm: force swiotlb for protected virtualization
> Date: Fri, 26 Apr 2019 20:32:39 +0200
> From: Halil Pasic <pasic@linux.ibm.com>
> To: kvm@vger.kernel.org, linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>, 
> Martin Schwidefsky <schwidefsky@de.ibm.com>, Sebastian Ott <sebott@linux.ibm.com>
> CC: Halil Pasic <pasic@linux.ibm.com>, virtualization@lists.linux-foundation.org, Michael 
> S. Tsirkin <mst@redhat.com>, Christoph Hellwig <hch@infradead.org>, Thomas Huth 
> <thuth@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Viktor Mihajlovski 
> <mihajlov@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Janosch Frank 
> <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, Farhan Ali 
> <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>
> 
> On s390, protected virtualization guests have to use bounced I/O
> buffers.  That requires some plumbing.
> 
> Let us make sure, any device that uses DMA API with direct ops correctly
> is spared from the problems, that a hypervisor attempting I/O to a
> non-shared page would bring.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   arch/s390/Kconfig                   |  4 +++
>   arch/s390/include/asm/mem_encrypt.h | 18 +++++++++++++
>   arch/s390/mm/init.c                 | 50 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 72 insertions(+)
>   create mode 100644 arch/s390/include/asm/mem_encrypt.h
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 1c3fcf19c3af..5500d05d4d53 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -1,4 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
> +config ARCH_HAS_MEM_ENCRYPT
> +        def_bool y
> +
>   config MMU
>       def_bool y
>   @@ -191,6 +194,7 @@ config S390
>       select ARCH_HAS_SCALED_CPUTIME
>       select VIRT_TO_BUS
>       select HAVE_NMI
> +    select SWIOTLB
>     config SCHED_OMIT_FRAME_POINTER
> diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
> new file mode 100644
> index 000000000000..0898c09a888c
> --- /dev/null
> +++ b/arch/s390/include/asm/mem_encrypt.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef S390_MEM_ENCRYPT_H__
> +#define S390_MEM_ENCRYPT_H__
> +
> +#ifndef __ASSEMBLY__
> +
> +#define sme_me_mask    0ULL
> +
> +static inline bool sme_active(void) { return false; }
> +extern bool sev_active(void);
> +

I noticed this patch always returns false for sme_active. Is it safe to assume that 
whatever fixups are required on x86 to deal with sme do not apply to s390?

> +int set_memory_encrypted(unsigned long addr, int numpages);
> +int set_memory_decrypted(unsigned long addr, int numpages);
> +
> +#endif    /* __ASSEMBLY__ */
> +
> +#endif    /* S390_MEM_ENCRYPT_H__ */
> +
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 3e82f66d5c61..7e3cbd15dcfa 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -18,6 +18,7 @@
>   #include <linux/mman.h>
>   #include <linux/mm.h>
>   #include <linux/swap.h>
> +#include <linux/swiotlb.h>
>   #include <linux/smp.h>
>   #include <linux/init.h>
>   #include <linux/pagemap.h>
> @@ -29,6 +30,7 @@
>   #include <linux/export.h>
>   #include <linux/cma.h>
>   #include <linux/gfp.h>
> +#include <linux/dma-mapping.h>
>   #include <asm/processor.h>
>   #include <linux/uaccess.h>
>   #include <asm/pgtable.h>
> @@ -42,6 +44,8 @@
>   #include <asm/sclp.h>
>   #include <asm/set_memory.h>
>   #include <asm/kasan.h>
> +#include <asm/dma-mapping.h>
> +#include <asm/uv.h>
>    pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>   @@ -126,6 +130,50 @@ void mark_rodata_ro(void)
>       pr_info("Write protected read-only-after-init data: %luk\n", size >> 10);
>   }
>   +int set_memory_encrypted(unsigned long addr, int numpages)
> +{
> +    int i;
> +
> +    /* make all pages shared, (swiotlb, dma_free) */

This comment should be "make all pages unshared"?

> +    for (i = 0; i < numpages; ++i) {
> +        uv_remove_shared(addr);
> +        addr += PAGE_SIZE;
> +    }
> +    return 0;
> +}
> +EXPORT_SYMBOL_GPL(set_memory_encrypted);
> +
> +int set_memory_decrypted(unsigned long addr, int numpages)
> +{
> +    int i;
> +    /* make all pages shared (swiotlb, dma_alloca) */
> +    for (i = 0; i < numpages; ++i) {
> +        uv_set_shared(addr);
> +        addr += PAGE_SIZE;
> +    }
> +    return 0;
> +}
> +EXPORT_SYMBOL_GPL(set_memory_decrypted);

The addr arguments for the above functions appear to be referring to virtual addresses. 
Would vaddr be a better name?

> +
> +/* are we a protected virtualization guest? */
> +bool sev_active(void)
> +{
> +    return is_prot_virt_guest();
> +}
> +EXPORT_SYMBOL_GPL(sev_active);
> +
> +/* protected virtualization */
> +static void pv_init(void)
> +{
> +    if (!sev_active())
> +        return;
> +
> +    /* make sure bounce buffers are shared */
> +    swiotlb_init(1);
> +    swiotlb_update_mem_attributes();
> +    swiotlb_force = SWIOTLB_FORCE;
> +}
> +
>   void __init mem_init(void)
>   {
>       cpumask_set_cpu(0, &init_mm.context.cpu_attach_mask);
> @@ -134,6 +182,8 @@ void __init mem_init(void)
>       set_max_mapnr(max_low_pfn);
>           high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
>   +    pv_init();
> +
>       /* Setup guest page hinting */
>       cmma_init();
>   -- 2.16.4
> 
> 

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)

