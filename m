Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98B66399F5
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiK0KrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 05:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiK0KrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 05:47:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE13DEBD
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 02:47:10 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AR6SqBj011532;
        Sun, 27 Nov 2022 10:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CJO8gkfgnP46VNO/hbXonKbJsDMbjZ4ZUiMXFh6jvsA=;
 b=lKpE5P1zfmYMXdcOZUddv6dTkfkd2zvKuUS2lUs/0Uy8knAn9MYcY7Yivli/c+v4wI0i
 Xr57qJF9sCIQzTCGnEuh996DRqno2v6VdALBcYhKOvgDBna2g4OzuYXxeoZIRLb0UmgU
 EBAi52Xiw3ijItdjmAJbWhKZ31FPeIE4ydvGHfI/vQ1i+yfKidF1+SKavdPMhgAnLYbY
 3fuzg/KGKQL/IFiNUvOK4HL7dpq40B77BZfleIXhE1t5q7SY0YPN1Mz0jhK/94kRFEQE
 mEdNvafA+ESe4BxedzT5gAmdkHA9/CZ6/zo7gd7TE4lfKxUmRJPqJPTNScyCUvmKg49X Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3v8hr7ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Nov 2022 10:46:50 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ARAkoe4017044;
        Sun, 27 Nov 2022 10:46:50 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3v8hr7h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Nov 2022 10:46:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ARAZCtE030191;
        Sun, 27 Nov 2022 10:46:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae997bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Nov 2022 10:46:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ARAkiuJ524984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Nov 2022 10:46:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 450CE4C044;
        Sun, 27 Nov 2022 10:46:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B9384C040;
        Sun, 27 Nov 2022 10:46:43 +0000 (GMT)
Received: from [9.171.55.247] (unknown [9.171.55.247])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 27 Nov 2022 10:46:43 +0000 (GMT)
Message-ID: <2e377924-b738-1b02-e7d5-381d4bcebaa8@linux.ibm.com>
Date:   Sun, 27 Nov 2022 11:46:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v11 04/11] s390x/cpu topology: reporting the CPU topology
 to the guest
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-5-pmorel@linux.ibm.com>
 <1888d31f-227f-7edf-4cc8-dd88a9b19435@kaod.org>
 <34caa4c4-0b94-1729-fe88-77d9b4240f04@linux.ibm.com>
 <8b29a416-8190-243f-c414-e9e77efae918@kaod.org>
 <d82db5c8-171b-1570-e000-25e381843e8d@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <d82db5c8-171b-1570-e000-25e381843e8d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n4UkPdsWqtU801Bh_GG2Vecm558xg-Oc
X-Proofpoint-ORIG-GUID: ahBeNFUK5QdRUP2Dns7tc5YgCw0t66qL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-27_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211270087
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/22/22 10:05, Pierre Morel wrote:
> 
> 
> On 11/21/22 15:13, Cédric Le Goater wrote:
>>>>> +static char *s390_top_set_level2(S390Topology *topo, char *p)
>>>>> +{
>>>>> +    int i, origin;
>>>>> +
>>>>> +    for (i = 0; i < topo->nr_sockets; i++) {
>>>>> +        if (!topo->socket[i].active_count) {
>>>>> +            continue;
>>>>> +        }
>>>>> +        p = fill_container(p, 1, i);
>>>>> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; 
>>>>> origin++) {
>>>>> +            uint64_t mask = 0L;
>>>>> +
>>>>> +            mask = topo->socket[i].mask[origin];
>>>>> +            if (mask) {
>>>>> +                p = fill_tle_cpu(p, mask, origin);
>>>>> +            }
>>>>> +        }
>>>>> +    }
>>>>> +    return p;
>>>>> +}
>>>>
>>>> Why is it not possible to compute this topo information at "runtime",
>>>> when stsi is called, without maintaining state in an extra S390Topology
>>>> object ? Couldn't we loop on the CPU list to gather the topology bits
>>>> for the same result ?
>>>>
>>>> It would greatly simplify the feature.
>>>>
>>>> C.
>>>>
>>>
>>> The vCPU are not stored in order of creation in the CPU list and not 
>>> in a topology order.
>>> To be able to build the SYSIB we need an intermediate structure to 
>>> reorder the CPUs per container.
>>>
>>> We can do this re-ordering during the STSI interception but the idea 
>>> was to keep this instruction as fast as possible.> The second reason 
>>> is to have a structure ready for the QEMU migration when we introduce 
>>> vCPU migration from a socket to another socket, having then a 
>>> different internal representation of the topology.
>>>
>>>
>>> However, if as discussed yesterday we use a new cpu flag we would not 
>>> need any special migration structure in the current series.
>>>
>>> So it only stays the first reason to do the re-ordering preparation 
>>> during the plugging of a vCPU, to optimize the STSI instruction.
>>>
>>> If we think the optimization is not worth it or do not bring enough 
>>> to be consider, we can do everything during the STSI interception.
>>
>> Is it called on a hot code path ? AFAICT, it is only called once
>> per cpu when started. insert_stsi_3_2_2 is also a guest exit andit 
>> queries the machine definition in a very similar way.
> 
> 
> It is not fully exact, stsi(15) is called at several moments, not only 
> on CPU creation, but each time the core calls rebuild_sched_domains() 
> that is for s390 on:
> - change in the host topology
> - changes in CPUSET: for allowed CPU or load balancing
> 
> Regards,
> Pierre

These are no good reasons to not make as you propose.
This allows to use the s390_has_feature() and use the cpu feature as 
proposed Christian.
What I can not do with the early topology initialization.

Regards,
Pierre

> 
>>
>> Thanks,
>>
>> C.
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
