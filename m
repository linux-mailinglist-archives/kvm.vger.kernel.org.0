Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6FB3B7EDE
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 10:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhF3IZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 04:25:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233289AbhF3IZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 04:25:58 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15U84dHQ025321;
        Wed, 30 Jun 2021 04:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ipaZ32MWHNhk2+3pN+FCBjmgbs9XZGvse8kd393wrio=;
 b=i5Dy2Mp1R47ynq08+OLq4rZ7ZN2tB883rD27VkoXppld9ODaT+tKJcylCvNYom9FzC4N
 v2bw6a8fFiLSPbANLAIA6vmI//YFdoMOKdnWtSBGPf5ygAh3IvkE4fF9TrTcBt2PHXt1
 EfbarRyLeNc6rFD2+Sj9qj1irHy8nfaLNPTrzG+/7CY34NQOrDPxknieYUn2xWUu78Sn
 i/ZJFmx6SXxoWrvlpLagRVoVwuVZZR7P23CGkjoH15qgO/Df2w8VQs8/AnsGnVkYZiwS
 nFfDsr5YE5acPq/YPUJJ5VoQaNgXXewP8x+Mk496LyYqTTvzPcJwZHt7jdGGksfXj5qZ hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gj36cutf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 04:23:26 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15U859CI031590;
        Wed, 30 Jun 2021 04:23:26 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gj36cusm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 04:23:26 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15U8NOFB007180;
        Wed, 30 Jun 2021 08:23:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 39dugh8v9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 08:23:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15U8NLYx33161506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 08:23:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BF194C059;
        Wed, 30 Jun 2021 08:23:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29AEA4C063;
        Wed, 30 Jun 2021 08:23:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.84.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 08:23:21 +0000 (GMT)
Subject: Re: [PATCH] KVM: selftests: Fix mapping length truncation in
 m{,un}map()
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com
Cc:     wanghaibin.wang@huawei.com
References: <20210624070931.565-1-yuzenghui@huawei.com>
 <78f94832-4a87-91fa-77fc-6b32252664de@de.ibm.com>
Message-ID: <83857466-6f9b-b45b-284c-708183800e56@de.ibm.com>
Date:   Wed, 30 Jun 2021 10:23:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <78f94832-4a87-91fa-77fc-6b32252664de@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T_6QYwugJ8_zVy2PyuG0qVqTT7vlUwcS
X-Proofpoint-ORIG-GUID: D3zk8yBrwd8w8K0YbK9LLXe4DJB5cbnB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_01:2021-06-29,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30.06.21 09:37, Christian Borntraeger wrote:
> 
> 
> On 24.06.21 09:09, Zenghui Yu wrote:
>> max_mem_slots is now declared as uint32_t. The result of (0x200000 * 32767)
>> is unexpectedly truncated to be 0xffe00000, whilst we actually need to
>> allocate about, 63GB. Cast max_mem_slots to size_t in both mmap() and
>> munmap() to fix the length truncation.
>>
>> We'll otherwise see the failure on arm64 thanks to the access_ok() checking
>> in __kvm_set_memory_region(), as the unmapped VA happen to go beyond the
>> task's allowed address space.
>>
>>   # ./set_memory_region_test
>> Allowed number of memory slots: 32767
>> Adding slots 0..32766, each memory region with 2048K size
>> ==== Test Assertion Failure ====
>>    set_memory_region_test.c:391: ret == 0
>>    pid=94861 tid=94861 errno=22 - Invalid argument
>>       1    0x00000000004015a7: test_add_max_memory_regions at set_memory_region_test.c:389
>>       2     (inlined by) main at set_memory_region_test.c:426
>>       3    0x0000ffffb8e67bdf: ?? ??:0
>>       4    0x00000000004016db: _start at :?
>>    KVM_SET_USER_MEMORY_REGION IOCTL failed,
>>    rc: -1 errno: 22 slot: 2615
>>
>> Fixes: 3bf0fcd75434 ("KVM: selftests: Speed up set_memory_region_test")
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> 
> While likely correct, this now breaks on many test systems in our CI that have less memory than 64GB.
> (We do get ENOMEM). I have not seen the ENOMEM failures in earlier versions. Strange

As we do not need the memory, the following seems to do the trick (MAP_NORESERVE)


diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d8812f27648c..0fc68371fb1b 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -377,7 +377,7 @@ static void test_add_max_memory_regions(void)
                 (max_mem_slots - 1), MEM_REGION_SIZE >> 10);
  
         mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
-                  PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+                  PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
         TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
         mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
