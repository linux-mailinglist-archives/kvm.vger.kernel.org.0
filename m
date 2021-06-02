Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B6398165
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 08:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhFBGvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 02:51:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229737AbhFBGvl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 02:51:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1526YESt183504;
        Wed, 2 Jun 2021 02:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eV7OHaaJkxhnxAKYxQ3UBXiQubYpTc8z6/Iva34uIBE=;
 b=gCkyuaVJJGpN2/Vgzs7G/zu6ZJRxyMhNA1/xyWcO5kxDJVfghYUVQFtwNz5qM7DP3XP5
 cS3NCvg1jOEzC2QKh0C+x2ymgXeJpF4r/91hg6FXWv+dhVHmr4OH/ugkjAUS/TK/3wY7
 LuHkRqx3JBFeEhmB9B4PBuGpMELcXubSIWsKbqkwJkjyss8ydf3q7i0rFHWLGcXypwCZ
 3XIACI1milEwAss4DV3Jrte9DXoD3f21LGKc6ZS6X+K78ZXoBKSlyHEM3xUdF5JbeY1Z
 bhZg6lHSaBUJkMXIRUPl1pbQUTFQajGywANqx9fz9z7UfxtL+1AXkojyxPQHpjMyyt5h FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38x20j43s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 02:49:58 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1526ZUHi186605;
        Wed, 2 Jun 2021 02:49:58 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38x20j43rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 02:49:58 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1526n89r030702;
        Wed, 2 Jun 2021 06:49:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 38ud88964d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 06:49:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1526nsDB29491474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 06:49:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBA684C040;
        Wed,  2 Jun 2021 06:49:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 501634C046;
        Wed,  2 Jun 2021 06:49:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.5])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 06:49:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: unify header guards
To:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210601161525.462315-1-cohuck@redhat.com>
 <d87b32d6-1d41-1413-96c6-0d6b2361b079@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <28419313-ab8e-322e-4995-30f42e4f5236@linux.ibm.com>
Date:   Wed, 2 Jun 2021 08:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d87b32d6-1d41-1413-96c6-0d6b2361b079@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qCyUMehGgiQSabYvi8dtvaYi9iY-ejG8
X-Proofpoint-ORIG-GUID: pq3rBoS0tiEPDm9VcysTNGXlnoHTfwua
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_01:2021-06-01,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106020041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/21 5:56 AM, Thomas Huth wrote:
> On 01/06/2021 18.15, Cornelia Huck wrote:
>> Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
>> _S390X_FILE_H_. This makes it more obvious what the file is
>> about, and avoids possible name space collisions.
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>
>> Only did s390x for now; the other archs seem to be inconsistent in
>> places as well, and I can also try to tackle them if it makes sense.
> ...
>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>> index 792881ec3249..61cd38fd36b7 100644
>> --- a/lib/s390x/asm/bitops.h
>> +++ b/lib/s390x/asm/bitops.h
>> @@ -8,8 +8,8 @@
>>    *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
>>    *
>>    */
>> -#ifndef _ASMS390X_BITOPS_H_
>> -#define _ASMS390X_BITOPS_H_
>> +#ifndef _ASM_S390X_BITOPS_H_
>> +#define _ASM_S390X_BITOPS_H_
> 
> Why not the other way round (S390X_ASM_BITOPS_H) ?
> 
>  > diff --git a/s390x/sthyi.h b/s390x/sthyi.h
>  > index bbd74c6197c3..eb92fdd2f2b2 100644
>  > --- a/s390x/sthyi.h
>  > +++ b/s390x/sthyi.h
>  > @@ -7,8 +7,8 @@
>  >   * Authors:
>  >   *    Janosch Frank <frankja@linux.vnet.ibm.com>
>  >   */
>  > -#ifndef _STHYI_H_
>  > -#define _STHYI_H_
>  > +#ifndef _S390X_STHYI_H_
>  > +#define _S390X_STHYI_H_
> 
> While we're at it: Do we also want to drop the leading (and trailing) 
> underscores here? ... since leading underscore followed by a capital letter 
> is a reserved namespace in C and you should normally not use these in nice 
> programs...? I think I'm ok with keeping the underscores in the files in the 
> lib folder (since these are our core libraries, similar to the system and 
> libc headers on a normal system), but in files that are not part of the lib 
> folder, we should rather avoid them.

Yes please.
Also, I have the feeling that we should document our decision so we can
point people to a file if questions arise.


> 
>   Thomas
> 

