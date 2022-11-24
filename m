Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E91637517
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKXJZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXJZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:25:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAC61165B4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:25:48 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO87U27014182;
        Thu, 24 Nov 2022 09:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qj3Jf37GiwZIE/i8Bo3VVrGMR0Lkjh6AD49hrzKgbyY=;
 b=bcfbnOpxxNwKsnh4ajiKnWGO47MDaF98KHORNMEcWU1KA4bK4ppyB7KAeZR9FUEgHCq6
 xSfrNLT0/0qqDe3mXf6l7lpDTSe1syCH2RGvAcdC9nz4OzgxX/BsJFzxPOZ7Mv0pr45N
 sRygWUCFaY9DKRL+2l9TYGWnQEt9wT6Po1IlQG2KAtDcJaMRHQJuG9TEWJK3Xvgi06T2
 AHY3u5jyt9Zwapk6RHUmKIuj7uD4zOnh8Gnj1WWqZNo3UjaU3OM9AFmfQ8ik/+OQWc1a
 eRe5gTMPWsRQbm3t/a8q+H8vw2uklUS/Jz7PdFtaRGSDBVTlPz759RsPTZRm6o9NQOnm tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153ndwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:25:40 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AO7sY1u030198;
        Thu, 24 Nov 2022 09:25:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153ndvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:25:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AO9KvqB015958;
        Thu, 24 Nov 2022 09:25:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps8ywuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:25:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AO9PXeW35914464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 09:25:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BF1F11C050;
        Thu, 24 Nov 2022 09:25:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48E1311C04C;
        Thu, 24 Nov 2022 09:25:32 +0000 (GMT)
Received: from [9.179.0.51] (unknown [9.179.0.51])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 09:25:32 +0000 (GMT)
Message-ID: <ccb73052-43e5-e072-b201-e983df876e6a@linux.ibm.com>
Date:   Thu, 24 Nov 2022 10:25:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <a2ddbba2-9e52-8ed8-fdbc-a587b8286576@de.ibm.com>
 <1fe0b036-19e7-a8a4-63aa-9bbcaed48187@linux.ibm.com>
 <9e8d4c74-7405-5e1f-6c95-3c0c99c43eb9@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <9e8d4c74-7405-5e1f-6c95-3c0c99c43eb9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cOTIsnPfWLVujPTDk-Le3Ldb9W2AJIJO
X-Proofpoint-GUID: xSUEGmxdjqx25jWhSf6dBxz8LzE2muaV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Gentle ping.

Did I understand the problem or am I wrong?


On 11/17/22 17:38, Pierre Morel wrote:
> 
> 
> On 11/17/22 10:31, Pierre Morel wrote:
>>
>>
>> On 11/16/22 17:51, Christian Borntraeger wrote:
>>> Am 02.09.22 um 09:55 schrieb Pierre Morel:
>>>> Hi,
>>>>
>>>> The implementation of the CPU Topology in QEMU has been drastically
>>>> modified since the last patch series and the number of LOCs has been
>>>> greatly reduced.
>>>>
>>>> Unnecessary objects have been removed, only a single S390Topology 
>>>> object
>>>> is created to support migration and reset.
>>>>
>>>> Also a documentation has been added to the series.
>>>>
>>>>
>>>> To use these patches, you will need Linux V6-rc1 or newer.
>>>>
>>>> Mainline patches needed are:
>>>>
>>>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>>>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>>>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF 
>>>> fac..
>>>>
>>>> Currently this code is for KVM only, I have no idea if it is 
>>>> interesting
>>>> to provide a TCG patch. If ever it will be done in another series.
>>>>
>>>> To have a better understanding of the S390x CPU Topology and its
>>>> implementation in QEMU you can have a look at the documentation in the
>>>> last patch.
>>>>
>>>> New in this series
>>>> ==================
>>>>
>>>>    s390x/cpus: Make absence of multithreading clear
>>>>
>>>> This patch makes clear that CPU-multithreading is not supported in
>>>> the guest.
>>>>
>>>>    s390x/cpu topology: core_id sets s390x CPU topology
>>>>
>>>> This patch uses the core_id to build the container topology
>>>> and the placement of the CPU inside the container.
>>>>
>>>>    s390x/cpu topology: reporting the CPU topology to the guest
>>>>
>>>> This patch is based on the fact that the CPU type for guests
>>>> is always IFL, CPUs are always dedicated and the polarity is
>>>> always horizontal.
>>>> This may change in the future.
>>>>
>>>>    hw/core: introducing drawer and books for s390x
>>>>    s390x/cpu: reporting drawers and books topology to the guest
>>>>
>>>> These two patches extend the topology handling to add two
>>>> new containers levels above sockets: books and drawers.
>>>>
>>>> The subject of the last patches is clear enough (I hope).
>>>>
>>>> Regards,
>>>> Pierre
>>>>
>>>> Pierre Morel (10):
>>>>    s390x/cpus: Make absence of multithreading clear
>>>>    s390x/cpu topology: core_id sets s390x CPU topology
>>>>    s390x/cpu topology: reporting the CPU topology to the guest
>>>>    hw/core: introducing drawer and books for s390x
>>>>    s390x/cpu: reporting drawers and books topology to the guest
>>>>    s390x/cpu_topology: resetting the Topology-Change-Report
>>>>    s390x/cpu_topology: CPU topology migration
>>>>    target/s390x: interception of PTF instruction
>>>>    s390x/cpu_topology: activating CPU topology
>>>
>>>
>>> Do we really need a machine property? As far as I can see, old QEMU
>>> cannot  activate the ctop facility with old and new kernel unless it
>>> enables CAP_S390_CPU_TOPOLOGY. I do get
>>> oldqemu .... -cpu z14,ctop=on
>>> qemu-system-s390x: Some features requested in the CPU model are not 
>>> available in the configuration: ctop
>>>
>>> With the newer QEMU we can. So maybe we can simply have a topology (and
>>> then a cpu model feature) in new QEMUs and non in old. the cpu model
>>> would then also fence migration from enabled to disabled.
>>
>> OK, I can check this.
>> In this case migration with topology will be if I understand correctly:
>>
>> NEW_QEMU/old_machine <-> NEW_QEMU/old_machine OK
>> While
>> OLD_QEMU/old_machine <-> NEW_QEMU/old_machine KO
>> NEW_QEMU/old_machine <-> OLD_QEMU/old_machine KO
> 
> I forgot to say that I mean in the examples above without using a flag.
> 
> Of course using a flag like -ctop=off in NEW_QEMU/new_machine allows
> to migrate from and to old_machines in an old QEMU.
> 
> Also I had the same behavior already in V9 by having a VMState without 
> the creation of a machine property, a new cpu feature and a new cpu flag.
> 
> 
> 
> 
> 
> 
>>
>> Is this something we can accept?
>>
>> regards,
>> Pierre
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
