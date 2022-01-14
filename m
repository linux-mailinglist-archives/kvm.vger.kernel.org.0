Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A23E48E9C7
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbiANMXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:23:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234801AbiANMXn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:23:43 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBRkNT007862;
        Fri, 14 Jan 2022 12:23:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kPO0ZZLv9ivsTnj//vR7qj5rPah80ZaXvKtVs6X9YVY=;
 b=si9wrkCfYul/q1rQUwKXOwmF3Rw7v3Up6BXKcM+r5zImtUf5KrKocrCozhy+Y/RwtWBE
 jAcJfiInv9kKlVWNbU9u+li26larNQ1PU2nHafKgNmwr2IY1BaOaWmQx4DFEZ15hHVGe
 kJN2P76ucPL53tqSwfBT877Fn4mxCRhWHbJnNirq4jRK53mEPSA/KheCNsQrINDz2A2L
 7PUVGwxlHWFXMOikCgm3a4hNEy2lhnLpFcAieLfiHbpwRAyHyFZcu3khVYSc6Fx4iMI5
 FydlSEBUWrbOQAr5AsT37JO4DrtQKlc630igFFiDMYNIIAzacx1dgB9/XlUaio+j/oVV QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8at0x7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:23:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECJffR031171;
        Fri, 14 Jan 2022 12:23:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8at0x70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:23:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECCqk5009534;
        Fri, 14 Jan 2022 12:23:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjx80m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:23:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ECETjQ36176330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 12:14:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AB2252063;
        Fri, 14 Jan 2022 12:23:37 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA2A35204E;
        Fri, 14 Jan 2022 12:23:36 +0000 (GMT)
Message-ID: <f7c76f9a-c138-5dc1-2189-f0177fb19709@linux.ibm.com>
Date:   Fri, 14 Jan 2022 13:23:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 0/5] s390x: Allocation and hosting
 environment detection fixes
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114121948.566e77a6@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220114121948.566e77a6@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5NigK6fB7aWfNmyun-KBW_CUbs-dz22g
X-Proofpoint-ORIG-GUID: 1S0zIlyJopSyLOMd0vG_K3gBWBzL9esX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 12:19, Claudio Imbrenda wrote:
> On Fri, 14 Jan 2022 10:02:40 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> I took some time before Christmas to write a test runner for lpar
>> which automatically runs all tests and sends me the logs. It's based
>> on the zhmc library to control starting and stopping of the lpar and
>> works by having a menu entry for each kvm unit test.
>>
>> This revealed a number of test fails when the tests are run under lpar
>> as there are a few differences:
>>     * lpars most often have a very high memory amount (upwards of 8GB)
>>       compared to our qemu env (256MB)
>>     * lpar supports diag308 subcode 2
>>     * lpar does not provide virtio devices
>>
>> The higher memory amount leads to allocations crossing the 2GB or 4GB
>> border which made sclp and sigp calls fail that expect 31/32 bit
>> addresses.
>>
> 
> the series looks good to me; if you send me a fixed patch 3, I'll queue
> this together with the other ones

Well, since Pierre originally came up with a large part of the code for 
patch 1 I'll wait with a new version until we picked his fixed patch so 
I can rebase on it.

But you can already pick the allocation patches if you want.

> 
>> Janosch Frank (5):
>>    lib: s390x: vm: Add kvm and lpar vm queries
>>    s390x: css: Skip if we're not run by qemu
>>    s390x: diag308: Only test subcode 2 under QEMU
>>    s390x: smp: Allocate memory in DMA31 space
>>    s390x: firq: Fix sclp buffer allocation
>>
>>   lib/s390x/vm.c  | 39 +++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.h  | 23 +++++++++++++++++++++++
>>   s390x/css.c     | 10 +++++++++-
>>   s390x/diag308.c | 15 ++++++++++++++-
>>   s390x/firq.c    |  2 +-
>>   s390x/smp.c     |  4 ++--
>>   s390x/stsi.c    | 21 +--------------------
>>   7 files changed, 89 insertions(+), 25 deletions(-)
>>
> 

