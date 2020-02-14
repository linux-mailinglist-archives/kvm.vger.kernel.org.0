Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5E15D5D5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgBNKdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:33:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbgBNKdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:33:55 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EAQGfa077153
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 05:33:54 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y57dduxgy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 05:33:54 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 10:33:52 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 10:33:50 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EAXm0J50004158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 10:33:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A85195204F;
        Fri, 14 Feb 2020 10:33:48 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5389252050;
        Fri, 14 Feb 2020 10:33:48 +0000 (GMT)
Subject: Re: [PATCH 04/35] s390/protvirt: add ultravisor initialization
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-5-borntraeger@de.ibm.com>
 <44aa351c-2333-e1df-42ce-6cf3a6808802@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 11:33:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <44aa351c-2333-e1df-42ce-6cf3a6808802@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021410-0020-0000-0000-000003AA101F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021410-0021-0000-0000-00002201FE6C
Message-Id: <81e4d5a1-ec8a-4de8-e136-8e61ad1fc788@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_02:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 suspectscore=2 phishscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.02.20 11:25, David Hildenbrand wrote:
> [...]
> 
>>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
>> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
>> index f2ab2528859f..5f178d557cc8 100644
>> --- a/arch/s390/kernel/setup.c
>> +++ b/arch/s390/kernel/setup.c
>> @@ -560,6 +560,8 @@ static void __init setup_memory_end(void)
>>  			vmax = _REGION1_SIZE; /* 4-level kernel page table */
>>  	}
>>  
>> +	adjust_to_uv_max(&vmax);
> 
> I'd somewhat prefer
> 
> if (prot_virt_host)
> 	adjust_to_uv_max(&vmax);
> 
>> +

fine with me. ack

>>  	/* module area is at the end of the kernel address space. */
>>  	MODULES_END = vmax;
>>  	MODULES_VADDR = MODULES_END - MODULES_LEN;
>> @@ -1140,6 +1142,7 @@ void __init setup_arch(char **cmdline_p)
>>  	 */
>>  	memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
>>  
>> +	setup_uv();
> 
> and
> 
> if (prot_virt_host)
> 	setup_uv();

ack
> 
> Moving the checks out of the functions. Makes it clearer that this is
> optional.
> 
>>  	setup_memory_end();
>>  	setup_memory();
>>  	dma_contiguous_reserve(memory_end);
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index fbf2a98de642..a06a628a88da 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -46,4 +46,57 @@ static int __init prot_virt_setup(char *val)
>>  	return rc;
>>  }
>>  early_param("prot_virt", prot_virt_setup);
>> +
>> +static int __init uv_init(unsigned long stor_base, unsigned long stor_len)
>> +{
>> +	struct uv_cb_init uvcb = {
>> +		.header.cmd = UVC_CMD_INIT_UV,
>> +		.header.len = sizeof(uvcb),
>> +		.stor_origin = stor_base,
>> +		.stor_len = stor_len,
>> +	};
>> +	int cc;
>> +
>> +	cc = uv_call(0, (uint64_t)&uvcb);
> 
> Could do
> 
> int cc = uv_call(0, (uint64_t)&uvcb);

I could actually get rid of the cc and the comparison with UVC_RC_EXECUTED.
When the condition code is 0, rc must be 1.

Something like
	if (uv_call(0,.....

> 
>> +	if (cc || uvcb.header.rc != UVC_RC_EXECUTED) {
>> +		pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
>> +		       uvcb.header.rc);
>> +		return -1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +void __init setup_uv(void)
>> +{
>> +	unsigned long uv_stor_base;
>> +
>> +	if (!prot_virt_host)
>> +		return;
>> +
>> +	uv_stor_base = (unsigned long)memblock_alloc_try_nid(
>> +		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
>> +		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
>> +	if (!uv_stor_base) {
>> +		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n",
>> +			uv_info.uv_base_stor_len);
> 
> pr_err() ? pr_warn()

ack.


> 
>> +		goto fail;
>> +	}
>> +
>> +	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
>> +		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
>> +		goto fail;
>> +	}
>> +
>> +	pr_info("Reserving %luMB as ultravisor base storage\n",
>> +		uv_info.uv_base_stor_len >> 20);
>> +	return;
>> +fail:
> 
> I'd add here:
> 
> pr_info("Disabling support for protected virtualization");

ack

> 
>> +	prot_virt_host = 0;> +}
>> +
>> +void adjust_to_uv_max(unsigned long *vmax)
>> +{
>> +	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>> +		*vmax = uv_info.max_sec_stor_addr;
> 
> Once you move the prot virt check out of this function


> 
> 	*vmax = max_t(unsigned long, *vmax, uv_info.max_sec_stor_addr);

ack
> 
>> +}
>>  #endif
>>
> 
> 

