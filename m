Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195CE39F5CB
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 13:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhFHL5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 07:57:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232317AbhFHL5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 07:57:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158BZATu132042;
        Tue, 8 Jun 2021 07:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KKiAecNGsKcEDWgVqaM6GU8HY4LiNSjWx56Aon7GTSo=;
 b=Qwx0JKlXiPiDuomETHRY6NCSLwUHJXHDU/s3jXPUntb0wnhHCvQ7ZRdA51xARXfWT1Gb
 rhWYtsheNgXEbsf0wAy3xjthV6iiAt9N1WBhpah+4IHfzYCpuhnhNen/R7L9uszyuIQm
 r8KxYAVOfOBuXcGow6uDgMhDPV574625MJMESsRgZtfr0x+E9MkpK63j7YP89GJmncUr
 wlz9SItNAzc9/I3QsiM8cDm7QReFPnaLa7he9/MdIrwdk18nVJ1lIHtTDXAMS+nKjM0v
 ElV2yJOfjWfKzrDodUkgRKsNtlJx0nzfsnChdTxuFIhZAMv53hhf9i7YXe8iaFDzc/m1 cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3927r90pf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:55:48 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158Baiw9143059;
        Tue, 8 Jun 2021 07:55:47 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3927r90pe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:55:47 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158Bt147017277;
        Tue, 8 Jun 2021 11:55:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3900w88u4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 11:55:45 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158BthCP22479216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 11:55:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C229A405F;
        Tue,  8 Jun 2021 11:55:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C91B3A4060;
        Tue,  8 Jun 2021 11:55:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.36.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 11:55:42 +0000 (GMT)
Subject: Re: [PATCH] KVM: selftests: introduce P47V64 for s390x
To:     Janosch Frank <frankja@linux.ibm.com>, pbonzini@redhat.com
Cc:     bgardon@google.com, dmatlack@google.com, drjones@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, peterx@redhat.com,
        venkateshs@chromium.org
References: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
 <20210608114546.6419-1-borntraeger@de.ibm.com>
 <0a3de13f-9a23-428e-fd76-851784da456a@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d811ac58-8342-5274-9984-d4f464d35075@de.ibm.com>
Date:   Tue, 8 Jun 2021 13:55:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0a3de13f-9a23-428e-fd76-851784da456a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HfAHJ7gDY758tZLVktDMf9uW_jMJjVd6
X-Proofpoint-GUID: w2knuZGh9Hr5bP4jg_I96oVtDkigmrLC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_09:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.06.21 13:49, Janosch Frank wrote:
> On 6/8/21 1:45 PM, Christian Borntraeger wrote:
>> s390x can have up to 47bits of physical guest and 64bits of virtual
>> address  bits. Add a new address mode to avoid errors of testcases
>> going beyond 47bits.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
>>   tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>> index fcd8e3855111..6d3f71822976 100644
>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>> @@ -43,6 +43,7 @@ enum vm_guest_mode {
>>   	VM_MODE_P40V48_4K,
>>   	VM_MODE_P40V48_64K,
>>   	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
>> +	VM_MODE_P47V64_4K,	/* For 48bits VA but ANY bits PA */
> 
> /* 64 bits VA but 47 bits PA */
> 
> Or, looking at the other entries above, just remove it.
Yes, will remove.
