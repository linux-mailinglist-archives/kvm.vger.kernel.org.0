Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B341AC88
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhI1KCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 06:02:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2496 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239815AbhI1KCc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 06:02:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S7sPbD039407;
        Tue, 28 Sep 2021 06:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=m4BPNTiVpYdVMboFe1K0kunohLqnQVCHq7p6RsDz8pI=;
 b=JYlxvRubB7DIegTdhSpA2T6oHtk7d9B6HhunKUDuPTQlLqdgOH8juM75oRyIhlTy/C7s
 lK9t/eP8T1PRgAPKGsjbHx097LtXCohK3YFne8/SofFGHP2xOhYFxOcBQhpqssE8eeDo
 pyFwhF8NtsDq5vMSnckjnIK7lh5Q+Nt0PNYIqqxvkDbi0kP8HIiJyC0Nh8eUhhnLAP7M
 TIcih4+A1SNxmCU4UvWILNrVZIvNnOa+tZs1MuvPXhw8if7q5Q0/1D8oW82NpAvQo3T+
 Ou0pB8CuVnCi+lOJ29g/9Hpg7fCf05q5dWdTqSv9Zvk0ZP+MQBsOo2DNGiv9u3WgB09E Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbtew80s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:00:52 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18S9e85W003226;
        Tue, 28 Sep 2021 06:00:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbtew80rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:00:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18S9rMTZ029115;
        Tue, 28 Sep 2021 10:00:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3b9ud9mcpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:00:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SA0khI50659778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:00:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A639C4C04A;
        Tue, 28 Sep 2021 10:00:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5103D4C044;
        Tue, 28 Sep 2021 10:00:46 +0000 (GMT)
Received: from [9.145.12.195] (unknown [9.145.12.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 10:00:46 +0000 (GMT)
Message-ID: <697cc54a-e3dd-75d2-4274-0715f5c7c550@linux.ibm.com>
Date:   Tue, 28 Sep 2021 12:00:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH 5/9] lib: s390x: uv: Add UVC_ERR_DEBUG
 switch
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-6-frankja@linux.ibm.com>
 <30a104a3-02a1-58a7-2377-de6221e7d20b@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <30a104a3-02a1-58a7-2377-de6221e7d20b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nD8XrxBKzqBH-CE38r6FIVf0oEgqa-av
X-Proofpoint-GUID: rQKkuzmhoYoQvGg_X6t6O1TTzydIL8BS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/21 19:41, Thomas Huth wrote:
> On 22/09/2021 09.18, Janosch Frank wrote:
>> Every time something goes wrong in a way we don't expect, we need to
>> add debug prints to some UVC to get the unexpected return code.
>>
>> Let's just put the printing behind a macro so we can enable it if
>> needed via a simple switch.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    lib/s390x/asm/uv.h | 12 ++++++++++++
>>    1 file changed, 12 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 2f099553..0e958ad7 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -12,6 +12,9 @@
>>    #ifndef _ASMS390X_UV_H_
>>    #define _ASMS390X_UV_H_
>>    
>> +/* Enables printing of command code and return codes for failed UVCs */
>> +#define UVC_ERR_DEBUG	0
> 
> Do we maybe want a "#ifndef UVC_ERR_DEBUG" in front of this, so that we
> could also set the macro to 1 from individual *.c files (or from the Makefile)?
> 
>    Thomas
> 

When testing it's the least amount of work to set this to 1 so I 
implemented it this way. If you think it's useful then I'll add the ifndef.
