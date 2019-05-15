Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59CBA1EC71
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEOKzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 06:55:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbfEOKzp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 06:55:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FAsFuN138230
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 06:55:44 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sgfe8xfsm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 06:55:43 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 15 May 2019 11:55:42 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 11:55:39 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FAtcVi58458156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 10:55:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 228FB4C040;
        Wed, 15 May 2019 10:55:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C435D4C04A;
        Wed, 15 May 2019 10:55:37 +0000 (GMT)
Received: from dyn-9-152-224-73.boeblingen.de.ibm.com (unknown [9.152.224.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 10:55:37 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: change default halt poll to 50000
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Collin Walling <walling@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>
References: <20190515082324.112755-1-borntraeger@de.ibm.com>
 <d4227b89-4161-084a-91dc-6178afe5aad0@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Date:   Wed, 15 May 2019 12:55:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d4227b89-4161-084a-91dc-6178afe5aad0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051510-0012-0000-0000-0000031BE6D0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051510-0013-0000-0000-00002154833D
Message-Id: <a742cf8b-d480-e469-6bda-2f34131781fb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150070
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/15/19 12:22 PM, David Hildenbrand wrote:
> "KVM: s390: change default halt poll time to 50us
> 
> Recent measurements indicate that using 50us results in a reduced CPU
> consumption, while still providing the benefit of halt polling. Let's
> use 50us instead."
> 
> Acked-by: David Hildenbrand <david@redhat.com>

With that change:
Acked-by: Janosch Frank <frankja@linux.vnet.ibm.com>

> 
> 
> 
> On 15.05.19 10:23, Christian Borntraeger wrote:
>> older performance measurements indicated that 50000 vs 80000 reduces cpu
>> consumption while still providing the benefit of halt polling. We had
>> this change in the IBM KVM product, but it got lost so it never went
>> upstream. Recent re-measurement indicate that 50k is still better than
>> 80k.>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index dbe254847e0d..cb63cc7bbf06 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -36,7 +36,7 @@
>>   */
>>  #define KVM_NR_IRQCHIPS 1
>>  #define KVM_IRQCHIP_NUM_PINS 4096
>> -#define KVM_HALT_POLL_NS_DEFAULT 80000
>> +#define KVM_HALT_POLL_NS_DEFAULT 50000
>>  
>>  /* s390-specific vcpu->requests bit members */
>>  #define KVM_REQ_ENABLE_IBS	KVM_ARCH_REQ(0)
>>
> 
> 

