Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE44C424FFD
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbhJGJYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:24:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240518AbhJGJYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:24:40 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978kfvp026371;
        Thu, 7 Oct 2021 05:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H9OTXeruu0eSOdhpYh9pMY16Vs5cYsGCCfT9JxeXu4w=;
 b=YqbJo6EvVMGRjXIWb9ICMQ859sHS7Adsp4KUlqXNCJOH0BS+KuRp96AtFs4CURVBjjpX
 yQ0ktvnCNW3vrq3ZYAZnDJJwn8vgDCArKZlXLvr6BNUawB6pZW2ahdrUPAvHFJt/+nxT
 kLKkTzLpc/IFpHH7uX/VI1UBIZ5iPoe1yYmBwZwHu24Cvz10xEUSQquUpQtNoMlorQwQ
 +0D3duWpk0rAyLYWi5tYydLGQvY29ZrBs9H6yRvMw/kOdy3Bh1zQ827oGzLRRZ2t2+vC
 DXWEK4+ErThWQ5GJVBPWB12JUXh8QYZ0QI5H/cHN98cU6e/kTtDecMHLtlZUQ/dqEgwB 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhsgpedyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:22:47 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978wM78008346;
        Thu, 7 Oct 2021 05:22:47 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhsgpedxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:22:46 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1979Bu01010869;
        Thu, 7 Oct 2021 09:22:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3bef2aawr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 09:22:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1979HIX242795486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 09:17:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA72FA405E;
        Thu,  7 Oct 2021 09:22:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BE11A404D;
        Thu,  7 Oct 2021 09:22:39 +0000 (GMT)
Received: from [9.145.66.140] (unknown [9.145.66.140])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 09:22:39 +0000 (GMT)
Message-ID: <2119bbdd-3533-1995-9a68-0c772ec583d2@linux.ibm.com>
Date:   Thu, 7 Oct 2021 11:22:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 8/9] s390x: snippets: Set stackptr and
 stacktop in cstart.S
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-9-frankja@linux.ibm.com>
 <39c39816-146e-6715-fe22-0f56bd943d6f@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <39c39816-146e-6715-fe22-0f56bd943d6f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fta8P44Vgd5ZKnhRAhp2aRAo7YW9z012
X-Proofpoint-ORIG-GUID: -9QQswmr39VxsmK0KT1qiIe9CUrsZGYH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 11:13, Thomas Huth wrote:
> On 07/10/2021 10.50, Janosch Frank wrote:
>> We have a stack, so why not define it and be a step closer to include
>> the lib into the snippets.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/snippets/c/cstart.S | 2 +-
>>    s390x/snippets/c/flat.lds | 2 ++
>>    2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
>> index a1754808..031a6b83 100644
>> --- a/s390x/snippets/c/cstart.S
>> +++ b/s390x/snippets/c/cstart.S
>> @@ -17,7 +17,7 @@ start:
>>    	xgr \i,\i
>>    	.endr
>>    	/* 0x3000 is the stack page for now */
>> -	lghi	%r15, 0x4000 - 160
>> +	lghi	%r15, stackptr
> 
> I already wanted to ask you to replace the magic value 0x4000 here ... great
> to see that you already did it :-)

Magic mind reading :-)

> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
Thanks!
