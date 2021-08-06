Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E791C3E2D68
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 17:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbhHFPQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 11:16:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232091AbhHFPQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 11:16:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F4I3v020863;
        Fri, 6 Aug 2021 11:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=syQV8uN5W9JS7Yp81CMW1qDS06SO7yI9K3N8agnRKEs=;
 b=g2N0wrbAdEKRxRwW6pAZUyhKjtqt2aKWly1IxcC4Z+S+MpZr1UxYzMfPfR4ofbsJpzrx
 ZACTTHp9EewrLaxFNBCwEq7tOnZIWU/tauEBvRKauOwOIhJlA3Ve5zliD/WugzwR7Hr/
 Oyu0dHc3Qvnm3w8+hRCC5YJq6xeHqc7/XIftGq/Hk1aPU3gidngpuuRbrUo8jYT+RDjo
 Gbxg267oNAaY1Oi05vLCXi1LQioi/QlTXUM57D8Pv2VGokIF1nDX3HUXlTe0dIWSBLns
 VPr6xVrRtFs1C75BO5D2ZWM3i88GL2ICmJCVNrpxRrgxN15vFD3ZI1QPTwQwnDNiHvZq ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a885ac215-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:15:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 176F4ebX028590;
        Fri, 6 Aug 2021 11:15:54 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a885ac204-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:15:54 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176F8nOW010873;
        Fri, 6 Aug 2021 15:15:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3a4x58ux7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 15:15:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176FCitS51970558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 15:12:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6545611C050;
        Fri,  6 Aug 2021 15:15:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBC0311C052;
        Fri,  6 Aug 2021 15:15:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.27.67])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 15:15:46 +0000 (GMT)
Subject: Re: [PATCH v3 01/14] KVM: s390: pv: add macros for UVC CC values
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <20210804154046.88552-2-imbrenda@linux.ibm.com>
 <f3fc81a7-ea71-56f6-16e0-e43fc36d646e@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <54a3b55e-bf05-e661-0618-7839f3d2c8dd@linux.ibm.com>
Date:   Fri, 6 Aug 2021 17:15:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f3fc81a7-ea71-56f6-16e0-e43fc36d646e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TGGl0JWygJMUpFiGCuFprQKPdR0NOyNt
X-Proofpoint-ORIG-GUID: 3XcH6j7RSQDgLeSGg9v6VwyviDswaCVm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108060104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/6/21 9:26 AM, David Hildenbrand wrote:
> On 04.08.21 17:40, Claudio Imbrenda wrote:
>> Add macros to describe the 4 possible CC values returned by the UVC
>> instruction.
>>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/uv.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 12c5f006c136..b35add51b967 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -18,6 +18,11 @@
>>   #include <asm/page.h>
>>   #include <asm/gmap.h>
>>   
>> +#define UVC_CC_OK	0
>> +#define UVC_CC_ERROR	1
>> +#define UVC_CC_BUSY 	2
>> +#define UVC_CC_PARTIAL	3
>> +
>>   #define UVC_RC_EXECUTED		0x0001
>>   #define UVC_RC_INV_CMD		0x0002
>>   #define UVC_RC_INV_STATE	0x0003
>>
> 
> Do we have any users we could directly fix up? AFAIKs, most users don't 
> really care about the cc value, only about cc vs !cc.
> 
> The only instances I was able to spot quickly:

The only fix for the functions below that I would accept would be to
check for cc 2 and 3. A cc >= UVC_CC_BUSY confuses me way too much when
reading.

But honestly for those two I'd just keep the code as is. I only asked
Claudio to fix the code in the next patch and add this patch as it was
not clearly visible he was dealing with a CC.

> 
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..dd72d325f9e8 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -233,7 +233,7 @@ static inline int uv_call(unsigned long r1, unsigned 
> long r2)
> 
>          do {
>                  cc = __uv_call(r1, r2);
> -       } while (cc > 1);
> +       } while (cc >= UVC_CC_BUSY);
>          return cc;
>   }
> 
> @@ -245,7 +245,7 @@ static inline int uv_call_sched(unsigned long r1, 
> unsigned long r2)
>          do {
>                  cc = __uv_call(r1, r2);
>                  cond_resched();
> -       } while (cc > 1);
> +       } while (cc >= UVC_CC_BUSY);
>          return cc;
>   }
> 
> 
> Of course, we could replace all checks for cc vs !cc with "cc != 
> UVC_CC_OK" vs "cc == UVC_CC_OK".
> 

