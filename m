Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5D71F0F8
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjFARlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 13:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjFARlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 13:41:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D950189;
        Thu,  1 Jun 2023 10:41:12 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351HbgG9011936;
        Thu, 1 Jun 2023 17:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=t3gOxhU5E4Vu+BTa81DHHLjlzCZhatqRD++4UZnlGtM=;
 b=NwBijD+g3h1ppI8LhAfDB2AHHPlWS1UH3vCTQ5zok5i0l0a6Qxdn7OzdViH8idcqqmVK
 Me1XGWlFJfrzm3MIwpvvio8uQq+ticNCymCvSYFB/PIheEcqQ1aeVJuy/drzYBUoQhC2
 PAgGNCkC8/7AmcvguDp5r4v55b4Rvu808Tl8+9WW+5dqTE5UxX/EQUr500VRH4Z8s5IR
 lA6cPpTktLx7yHxFuS0kdHS+O1+7yL5HYuo8TfkTh1OMQD4gWG7KcDSO0B4o1QJRRjOe
 wHq2lLdNknGzWriLmtaxbVHDp/WFjDfK0V6fiFWCweEIw052Wvu9LotRYhyQX5CeVY6J sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxyptrjm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 17:41:11 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351Hc3vZ014967;
        Thu, 1 Jun 2023 17:41:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxyptrjh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 17:41:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514ToB3013017;
        Thu, 1 Jun 2023 17:41:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qu9g5a7bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 17:41:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351Hf3LS4588170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 17:41:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AED1620043;
        Thu,  1 Jun 2023 17:41:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 336FD20040;
        Thu,  1 Jun 2023 17:41:03 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 17:41:03 +0000 (GMT)
Message-ID: <5d8f2ecc-0858-4708-a6cd-bf9692218935@linux.ibm.com>
Date:   Thu, 1 Jun 2023 19:41:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xuf56d59TY4gzYQ8glii08ARNKr4r--J
X-Proofpoint-GUID: jf44_Rh4im4_XPJdBo5N0wZbnMDrsUkf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/23 11:38, Janosch Frank wrote:
> On 5/19/23 13:22, Pierre Morel wrote:
>> STSI with function code 15 is used to store the CPU configuration
>> topology.
>>
>> We retrieve the maximum nested level with SCLP and use the
>> topology tree provided by the drawers, books, sockets, cores
>> arguments.
>>
>> We check :
>> - if the topology stored is coherent between the QEMU -smp
>>    parameters and kernel parameters.
>> - the number of CPUs
>> - the maximum number of CPUs
>> - the number of containers of each levels for every STSI(15.1.x)
>>    instruction allowed by the machine.
>
>>   [topology]
>>   file = topology.elf
>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, 
>> origin)
>> +# 1 CPU on socket 2
>> +extra_params = -smp 
>> 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on 
>> -device z14-s390x-cpu,core-id=1,entitlement=low -device 
>> z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 
>> -device z14-s390x-cpu,core-id=20 -device 
>> z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append 
>> '-drawers 3 -books 3 -sockets 4 -cores 4'
>> +
>> +[topology-2]
>> +file = topology.elf
>> +extra_params = -smp 
>> 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  -append '-drawers 
>> 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high 
>> -device 
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on
>
> Pardon my ignorance but I see z14 in there, will this work if we run 
> on a z13?

I think it will, we do not use anything specific to the CPU but the 
Configuration topology facility which start with z10EC
and AFAIU QEMU will accept a processor newer than the one of the host, 
at least it does on my LPAR (VM z16b > host z16a)

But we can use z13 as basis, which also covers the case where I forgot 
something.


>
> Also, will this work/fail gracefully if the test is run with a quemu 
> that doesn't know about topology or will it crash?

It will crash, QEMU will refuse the drawers and book parameters if the 
QEMU patch for topology has not been applied.

So, I should first propose a simple unittests.cfg working with both, 
which will SKIP with "Topology facility not present" without the patch.

When the patch is becoming used we can add more testings.

Thanks for the comments.

Pierre



