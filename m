Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1420930EEB4
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhBDIn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:43:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235031AbhBDInX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 03:43:23 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 1148WmlD122981;
        Thu, 4 Feb 2021 03:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Lvf79ttOY7+ByvpR6bUQS+gP98gtUqv4tfoGlSsubvk=;
 b=SToaCB9b5YlCgtAePPaWnFMaObp+R7h7eFVSV8Otuqa2Pdg2qBqIK6bqmC3+A1QCFdvS
 CfRFLu+sMFGiYMPPmimS+XeF5TVkwZYaEA/doFta9Iq309LEpJzBIf4KMuvCwVhrq/A7
 xE6b52atPU8HkcPcBV71GtO3hHYNl1snP5REO4yoZ/l7mxwtriVvsFvrf2Ih6wo2+Amt
 9ipXlbDwie6LyuYvz+noSlcjFgV7jjsO5WBRHJXNA8KMhzBd/l52zbhTTn7ZecHaGKmI
 DHz3aKQ8r4t/b0D+XoDbMdshaF+pIfZIuQzjGs9+nv0VrqazvMTbSmscsfnSue0kqUKz Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36gd7krrnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 03:42:34 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1148YO73128292;
        Thu, 4 Feb 2021 03:42:34 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36gd7krrmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 03:42:34 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1148am47020269;
        Thu, 4 Feb 2021 08:42:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 36cy38af0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 08:42:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1148gIjK36634890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Feb 2021 08:42:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80D5EA4054;
        Thu,  4 Feb 2021 08:42:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE39CA405B;
        Thu,  4 Feb 2021 08:42:26 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.45.97])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Feb 2021 08:42:26 +0000 (GMT)
Subject: Re: [PATCH -next] KVM: s390: Return the correct errno code
To:     Cornelia Huck <cohuck@redhat.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <20210204080523.18943-1-zhengyongjun3@huawei.com>
 <20210204093227.3f088c8a.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <267785c5-527d-3294-cc7e-670d49d87082@de.ibm.com>
Date:   Thu, 4 Feb 2021 09:42:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210204093227.3f088c8a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_03:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 clxscore=1011
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.02.21 09:32, Cornelia Huck wrote:
> On Thu, 4 Feb 2021 16:05:23 +0800
> Zheng Yongjun <zhengyongjun3@huawei.com> wrote:
> 
>> When valloc failed, should return ENOMEM rather than ENOBUF.
>>
>> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
>> ---
>>  arch/s390/kvm/interrupt.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 2f177298c663..6b7acc27cfa2 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -2252,7 +2252,7 @@ static int get_all_floating_irqs(struct kvm *kvm, u8 __user *usrbuf, u64 len)
>>  	 */
>>  	buf = vzalloc(len);
>>  	if (!buf)
>> -		return -ENOBUFS;
>> +		return -ENOMEM;
>>  
>>  	max_irqs = len / sizeof(struct kvm_s390_irq);
>>  
> 
> This breaks a user space interface (see the comment right above the
> vzalloc).


Right. Please do not send (generated?) patches without looking at the code
that you are patching.
