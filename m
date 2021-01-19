Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539E12FBB35
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 16:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390563AbhASP3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 10:29:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389938AbhASP1i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 10:27:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JF35Yt086896;
        Tue, 19 Jan 2021 10:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PHLHj+hA9wKXHts4b5yR99nip9TKO4H/FjepOVbVozg=;
 b=lv/ZyZ+QKH+H0/tLe37AkGvwnpWS+XbbOeCPKHXz3Du1+k/lPAX54MqtdIfERmFN7Lf1
 WRFHNQusLcSHvbx2dtMnlkw+LcmzKx2TuzKNtlb5WmgId/8C71O+pVWaG/bA2mjy6RZ3
 tE5o8MzeiMagVjXN/GLVfywkJOQxXwyTfab4DuPwVkHB6UU3Y0qzlvQgraLn7EtYwaNU
 crgpsDYNnNhZcWCBwvW83PDLR/gUGU1vK59TiK4v58yOuVYLi6bAh97xIN9By9FrYUJG
 yu3r2IZJ3RuL1rae5tCdjTRBhU6pfg8m1o/UzNzfjbBTbhz8IXWSqV4VctqqSS7mxL04 dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36612pj54y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:26:54 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JF3aX0089693;
        Tue, 19 Jan 2021 10:26:54 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36612pj542-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:26:54 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JFGeCn027216;
        Tue, 19 Jan 2021 15:26:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 363qdhb75c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:26:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JFQnwV45810140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:26:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A46325204E;
        Tue, 19 Jan 2021 15:26:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.160.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2427652052;
        Tue, 19 Jan 2021 15:26:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 03/11] lib/vmalloc: add some asserts and
 improvements
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
 <20210115123730.381612-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <0ddc9535-58ec-86de-6b3a-c45a8f059d77@linux.ibm.com>
Date:   Tue, 19 Jan 2021 16:26:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115123730.381612-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 1:37 PM, Claudio Imbrenda wrote:
> Add some asserts to make sure the state is consistent.
> 
> Simplify and improve the readability of vm_free.
> 
> If a NULL pointer is freed, no operation is performed.
> 
> Fixes: 3f6fee0d4da4 ("lib/vmalloc: vmalloc support for handling allocation metadata")
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@de.ibm.com>

> ---
>  lib/vmalloc.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 986a34c..6b52790 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -162,13 +162,16 @@ static void *vm_memalign(size_t alignment, size_t size)
>  static void vm_free(void *mem)
>  {
>  	struct metadata *m;
> -	uintptr_t ptr, end;
> +	uintptr_t ptr, page, i;
>  
> +	if (!mem)
> +		return;
>  	/* the pointer is not page-aligned, it was a single-page allocation */
>  	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
>  		assert(GET_MAGIC(mem) == VM_MAGIC);
> -		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> -		free_page(phys_to_virt(ptr));
> +		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> +		assert(page);
> +		free_page(phys_to_virt(page));
>  		return;
>  	}
>  
> @@ -176,13 +179,14 @@ static void vm_free(void *mem)
>  	m = GET_METADATA(mem);
>  	assert(m->magic == VM_MAGIC);
>  	assert(m->npages > 0);
> +	assert(m->npages < BIT_ULL(BITS_PER_LONG - PAGE_SHIFT));
>  	/* free all the pages including the metadata page */
> -	ptr = (uintptr_t)mem - PAGE_SIZE;
> -	end = ptr + m->npages * PAGE_SIZE;
> -	for ( ; ptr < end; ptr += PAGE_SIZE)
> -		free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
> -	/* free the last one separately to avoid overflow issues */
> -	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
> +	ptr = (uintptr_t)m & PAGE_MASK;
> +	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {

s/i < m->npages + 1/i <= m->npages/ ?

> +		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
> +		assert(page);
> +		free_page(phys_to_virt(page));
> +	}
>  }
>  
>  static struct alloc_ops vmalloc_ops = {
> 

