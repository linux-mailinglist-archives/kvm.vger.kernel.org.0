Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED239331227
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 16:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhCHP1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 10:27:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21308 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhCHP1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 10:27:08 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128FNqmi090338;
        Mon, 8 Mar 2021 10:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MDSYaiB8Z3C5R/Xkca+XoQfczzHGgXt/pHJEmHLYxpo=;
 b=JrLoSXOyaMM7S9rPQgM1zkmytFOif47EixHJymhS9Jgw/hTxq8w5Fb+ZijvQcgDZm4Wn
 82+OuoZLubtw511Eorwnwrnpsa24cpsYLjD5sudlATfw2c/zkbmYuzl9d+Hg1Bv0cO1+
 2jAWeKIZxx+tfhQWjuI5zzbDmXRF/ric6U5f0OEeK4Bl4vWZ5BAwQqVCEme1JUmDdTeE
 Qc1UcSQ/N2VReYEWAj141gi8rZXNUEF3FYiuJO8e92SBeqpmkNjSX6W0WZi7a5Cl55gK
 +xwWm1KnPkHaZdogfQRYmhluTuK6La+gpRZbHoH8pfp9dng6VTCItytMTFVguxgzLSHr vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375peyg59v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:27:06 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128FOkBa094812;
        Mon, 8 Mar 2021 10:27:06 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375peyg584-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:27:06 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128FR2a4027654;
        Mon, 8 Mar 2021 15:27:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3741c8h0t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:27:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128FQxYo59834700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 15:26:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A7204C05A;
        Mon,  8 Mar 2021 15:26:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC7B64C04A;
        Mon,  8 Mar 2021 15:26:58 +0000 (GMT)
Received: from [9.145.7.187] (unknown [9.145.7.187])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 15:26:58 +0000 (GMT)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
 <e548903d-ed72-d84f-8010-1bb765696ffe@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v5 0/3] s390/kvm: fix MVPG when in VSIE
Message-ID: <262c0955-0283-6812-c841-cd1f18acf835@linux.ibm.com>
Date:   Mon, 8 Mar 2021 16:26:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <e548903d-ed72-d84f-8010-1bb765696ffe@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_11:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 mlxlogscore=759 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/21 4:19 PM, Christian Borntraeger wrote:
> On 02.03.21 18:44, Claudio Imbrenda wrote:
>> The current handling of the MVPG instruction when executed in a nested
>> guest is wrong, and can lead to the nested guest hanging.
>>
>> This patchset fixes the behaviour to be more architecturally correct,
>> and fixes the hangs observed.
>>
>> v4->v5
>> * split kvm_s390_logical_to_effective so it can be reused for vSIE
>> * fix existing comments and add some more comments
>> * use the new split _kvm_s390_logical_to_effective in vsie_handle_mvpg
>>
>> v3->v4
>> * added PEI_ prefix to DAT_PROT and NOT_PTE macros
>> * added small comment to explain what they are about
>>
>> v2->v3
>> * improved some comments
>> * improved some variable and parameter names for increased readability
>> * fixed missing handling of page faults in the MVPG handler
>> * small readability improvements
>>
>> v1->v2
>> * complete rewrite
> 
> 
> queued (with small fixups) for kvms390. Still not sure if this will land in master or next.
> Opinions?

I'd go for the next merge window

>>
>> Claudio Imbrenda (3):
>>    s390/kvm: split kvm_s390_logical_to_effective
>>    s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
>>    s390/kvm: VSIE: correctly handle MVPG when in VSIE
>>
>>   arch/s390/kvm/gaccess.c |  30 ++++++++++--
>>   arch/s390/kvm/gaccess.h |  35 ++++++++++---
>>   arch/s390/kvm/vsie.c    | 106 ++++++++++++++++++++++++++++++++++++----
>>   3 files changed, 151 insertions(+), 20 deletions(-)
>>

