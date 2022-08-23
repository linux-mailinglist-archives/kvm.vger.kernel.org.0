Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B4659D264
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 09:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbiHWHiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 03:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbiHWHiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 03:38:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746AA647FC
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:38:08 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N7Ufqg007321
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BT9Ps1I0Tzjy1+ZbWt+9rDmpfaiU9sl7PZd1XASzrVA=;
 b=VHMuGJpVu8mUebHi1C8QDqG5wz7l8OmXFsl3LFQpBJuz5ai3rTq5qZStL2dVYSS1KBcK
 s00TM4X8VWHPergEMIbI8Qvea+xh9tcQOGKGGSVA9sI7qmeVKUla7X604V5WSehSVHab
 /8Uje8vI3nxApnejh39Nn5/G1iR39iaCx3p3UEprjZtjcDENBIGdX3nxD6/QAPF0tsz/
 564iqIJK0BkY+woENQiNilSysgI1k3farpLGUeEBB/EptP3UQ/Bmp3G2wCnuftQM/e7X
 z1nbueGgRE0VqIfR7zncYgBCaotxXTkL5nK0z2vzJ6qxTVTD7QjmS4vithD7nzYJ8Mix Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tjn854s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:38:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N7XQjt018477
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:38:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tjn8542-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 07:38:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N7bLv2007493;
        Tue, 23 Aug 2022 07:38:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88udu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 07:38:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N7c1Zf25624900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 07:38:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD42C4C04A;
        Tue, 23 Aug 2022 07:38:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 867C54C044;
        Tue, 23 Aug 2022 07:38:01 +0000 (GMT)
Received: from [9.145.84.26] (unknown [9.145.84.26])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 07:38:01 +0000 (GMT)
Message-ID: <4d00e7ff-f90a-cae1-b8cd-7d56a0b4e455@linux.ibm.com>
Date:   Tue, 23 Aug 2022 09:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220818152114.213135-1-imbrenda@linux.ibm.com>
 <d65e5beb-e417-b13d-f5f6-eb0e91ccc1f3@linux.ibm.com>
 <20220819111210.4b1e3fe6@p-imbrenda>
 <8f9714f6-3780-1499-70db-38c74136ae50@linux.ibm.com>
In-Reply-To: <8f9714f6-3780-1499-70db-38c74136ae50@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rTddkX-zqkXd6yfrwc3JTrk1HEUC0b07
X-Proofpoint-ORIG-GUID: zobAWb9gsCvsKMVgVJGiZcbf-95jxpSG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_02,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 bulkscore=0 mlxlogscore=641
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/22 12:31, Janosch Frank wrote:
> On 8/19/22 11:12, Claudio Imbrenda wrote:
>> On Fri, 19 Aug 2022 10:52:40 +0200
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> On 8/18/22 17:21, Claudio Imbrenda wrote:
>>>> The lowcore pointer pointing to the current CPU (THIS_CPU) was not
>>>> initialized for the boot CPU. The pointer is needed for correct
>>>> interrupt handling, which is needed in the setup process before the
>>>> struct cpu array is allocated.
>>>>
>>>> The bug went unnoticed because some environments (like qemu/KVM) clear
>>>> all memory and don't write anything in the lowcore area before starting
>>>> the payload. The pointer thus pointed to 0, an area of memory also not
>>>> used. Other environments will write to memory before starting the
>>>> payload, causing the unit tests to crash at the first interrupt.
>>>>
>>>> Fix by assigning a temporary struct cpu before the rest of the setup
>>>> process, and assigning the pointer to the correct allocated struct
>>>> during smp initialization.
>>>>
>>>> Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>
>>> I've considered letting the IPL cpu have a static struct cpu and setting
>>> it up in cstart64.S. But that would mean that we would need extra
>>> handling when using smp functions and that'll look even worse.
>>>
>>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
>>>
[...]
>>
>> this temporary struct is then not accessible from smp_setup, so it
>> can't be memcpy-ed.
>>
>> if you really want something meaningful in the temporary struct, it has
>> to be initialized in smp.c and called in io.c (something like
>> smp_boot_cpu_tmp_setup(&this_cpu_tmp) ), but then still no memcpy.
>>
>> in the end the struct cpu is needed only to allow interrupts to happen
>> without crashes, I don't think we strictly need initialization
> 
> Ugh, this feels like a quick fix.
> But alright, I've just tried setting it up from cstart64.S and it's way
> more ugly code so let's stick with this for now.
> 

Anyway:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks, picked
