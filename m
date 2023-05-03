Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F5D6F514B
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 09:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjECH0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 03:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjECHZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 03:25:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BBC4C2C
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 00:24:22 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3437I96i031923;
        Wed, 3 May 2023 07:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ORQzgs7VffDlfBwvqaIQN7cT69Er1nRmzOzEAIKO8Uo=;
 b=tgMBxIa++zT7cZw3vo9dw1i5k3M5pke7Zxd5TLTVt1W2wPmFS1o303GiZz3kseAS1zmT
 1MhN4yWsHPqlrWwsl/UNt0IoFQsUe5ZRGZckbQ+EggvCRed3JXgLH+3ARAeAWqeMJvw7
 n9V/Md9gUCFJrGaokAi79DoDC6Onj7/eUNUH5ErINOZEhSpk8NXW4hsYJ1Q4UCLzZEcn
 be8/ZC/W9fJfAcXfj9H0SRdRnyRv8P8qBv6fiIaimkCQYSTfSYr+DV0Smplkdl55FhSt
 CBM+Nm9FKVOb/ILa2tLF9bUcpDEiF2gxU0lNSj9XA9YU3wciF8TXmrkqIAVit6kUQuVi ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbj9k1by4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:24:09 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3437IQat032553;
        Wed, 3 May 2023 07:24:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbj9k1bx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:24:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342NQ8Fc004096;
        Wed, 3 May 2023 07:24:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6t1du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:24:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3437Nx9B47972894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 07:23:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D9E52004E;
        Wed,  3 May 2023 07:23:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D95C120043;
        Wed,  3 May 2023 07:23:58 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 07:23:58 +0000 (GMT)
Message-ID: <ba23107e-1854-63ba-66f2-5b84c5bc8c59@linux.ibm.com>
Date:   Wed, 3 May 2023 09:23:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-2-pmorel@linux.ibm.com>
 <0e575143-573f-9363-d8dc-103bb819d15b@kaod.org>
 <00455f95-b2e2-2e3d-aeb4-e806418f1f46@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <00455f95-b2e2-2e3d-aeb4-e806418f1f46@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fXr9A_zYC8Qvq_DY9KrMAPpeiBEEyvNh
X-Proofpoint-GUID: UagnDCtDzm24M2VDJW-PQuyfKx27uB2q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030057
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/2/23 15:48, Cédric Le Goater wrote:
> On 5/2/23 14:05, Cédric Le Goater wrote:
>> On 4/25/23 18:14, Pierre Morel wrote:
>>> S390 adds two new SMP levels, drawers and books to the CPU
>>> topology.
>>> The S390 CPU have specific topology features like dedication
>>> and entitlement to give to the guest indications on the host
>>> vCPUs scheduling and help the guest take the best decisions
>>> on the scheduling of threads on the vCPUs.
>>>
>>> Let us provide the SMP properties with books and drawers levels
>>> and S390 CPU with dedication and entitlement,
>>
>> I think CpuS390Entitlement should be introduced in a separate patch and
>> only under target/s390x/cpu.c. It is machine specific and doesn't belong
>> to the machine common definitions.
>>
>> 'books' and 'drawers' could also be considered z-specific but High End
>> POWER systems (16s) have similar topology concepts, at least for 
>> drawers :
>> a group of 4 sockets. So let's keep it that way.
>>
>>
>> This problably means you will have to rework the get/set property 
>> handlers
>> with strcmp() or simply copy the generated lookup struct :
>>
>> const QEnumLookup CpuS390Entitlement_lookup = {
>>      .array = (const char *const[]) {
>>          [S390_CPU_ENTITLEMENT_AUTO] = "auto",
>>          [S390_CPU_ENTITLEMENT_LOW] = "low",
>>          [S390_CPU_ENTITLEMENT_MEDIUM] = "medium",
>>          [S390_CPU_ENTITLEMENT_HIGH] = "high",
>>      },
>>      .size = S390_CPU_ENTITLEMENT__MAX
>> };
>>
>> It should be fine.
>
> The enum is required by the set-cpu-topology QMP command in patch 8.
> Forget my comment, it would require too much changes in your series
> to introduce CPU Entitlement independently.
>
> C.
>
OK, thanks,

Pierre

