Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE862E21F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiKQQjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240665AbiKQQix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:38:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B3D2DE7
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:38:33 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGarHH024533;
        Thu, 17 Nov 2022 16:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EJ8Q71Cqj9/GimTIc4PuBQRDAXN8o7k2d3gD3eHxlEE=;
 b=UA7WpHdtG+ZXNQPEF7T8JVDCmWz44UaykKPMtZM71U2VHLdjsAiqG4hviUf8tVlj5VmC
 jzedsIi095Bsjz8Vimi5a54BnP8JkwhEaryFt9xsPvaeSZ0tUUCDOB29NC5JPdDW1Z5s
 EnNOlmRwil4Fe0ja+Kc2PW/DCx5NhuiTHUBIXZMGqr61w4IsbmP+1nW9uDkTQspZuUA8
 jnddsmBBvzdsn/csptnFeS4gtnKuq+yAUMglgSQPs5kpAKZ71znoT25xfKNoCyOsdxzz
 g4NfFBMSreDYHTbzIAeqDUNdvjNq3wf8M0hla9ZEK3jV/LXcppSa2tHMPDfxKK6Rmj5z Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwq2eb5ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 16:38:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHG65D1020057;
        Thu, 17 Nov 2022 16:38:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwq2eb59s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 16:38:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AHGZSE9030918;
        Thu, 17 Nov 2022 16:38:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3kt349dv95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 16:38:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AHGcJdN3146262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 16:38:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0C1F5204F;
        Thu, 17 Nov 2022 16:38:19 +0000 (GMT)
Received: from [9.171.46.61] (unknown [9.171.46.61])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F28365204E;
        Thu, 17 Nov 2022 16:38:18 +0000 (GMT)
Message-ID: <9e8d4c74-7405-5e1f-6c95-3c0c99c43eb9@linux.ibm.com>
Date:   Thu, 17 Nov 2022 17:38:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <a2ddbba2-9e52-8ed8-fdbc-a587b8286576@de.ibm.com>
 <1fe0b036-19e7-a8a4-63aa-9bbcaed48187@linux.ibm.com>
In-Reply-To: <1fe0b036-19e7-a8a4-63aa-9bbcaed48187@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2aYYKbWNWahZ9MuH66zZpUtBk1Hw4106
X-Proofpoint-ORIG-GUID: YsF9G5rZ8vfe9ZACFG2_4lpa0qQm7r2C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/17/22 10:31, Pierre Morel wrote:
> 
> 
> On 11/16/22 17:51, Christian Borntraeger wrote:
>> Am 02.09.22 um 09:55 schrieb Pierre Morel:
>>> Hi,
>>>
>>> The implementation of the CPU Topology in QEMU has been drastically
>>> modified since the last patch series and the number of LOCs has been
>>> greatly reduced.
>>>
>>> Unnecessary objects have been removed, only a single S390Topology object
>>> is created to support migration and reset.
>>>
>>> Also a documentation has been added to the series.
>>>
>>>
>>> To use these patches, you will need Linux V6-rc1 or newer.
>>>
>>> Mainline patches needed are:
>>>
>>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF 
>>> fac..
>>>
>>> Currently this code is for KVM only, I have no idea if it is interesting
>>> to provide a TCG patch. If ever it will be done in another series.
>>>
>>> To have a better understanding of the S390x CPU Topology and its
>>> implementation in QEMU you can have a look at the documentation in the
>>> last patch.
>>>
>>> New in this series
>>> ==================
>>>
>>>    s390x/cpus: Make absence of multithreading clear
>>>
>>> This patch makes clear that CPU-multithreading is not supported in
>>> the guest.
>>>
>>>    s390x/cpu topology: core_id sets s390x CPU topology
>>>
>>> This patch uses the core_id to build the container topology
>>> and the placement of the CPU inside the container.
>>>
>>>    s390x/cpu topology: reporting the CPU topology to the guest
>>>
>>> This patch is based on the fact that the CPU type for guests
>>> is always IFL, CPUs are always dedicated and the polarity is
>>> always horizontal.
>>> This may change in the future.
>>>
>>>    hw/core: introducing drawer and books for s390x
>>>    s390x/cpu: reporting drawers and books topology to the guest
>>>
>>> These two patches extend the topology handling to add two
>>> new containers levels above sockets: books and drawers.
>>>
>>> The subject of the last patches is clear enough (I hope).
>>>
>>> Regards,
>>> Pierre
>>>
>>> Pierre Morel (10):
>>>    s390x/cpus: Make absence of multithreading clear
>>>    s390x/cpu topology: core_id sets s390x CPU topology
>>>    s390x/cpu topology: reporting the CPU topology to the guest
>>>    hw/core: introducing drawer and books for s390x
>>>    s390x/cpu: reporting drawers and books topology to the guest
>>>    s390x/cpu_topology: resetting the Topology-Change-Report
>>>    s390x/cpu_topology: CPU topology migration
>>>    target/s390x: interception of PTF instruction
>>>    s390x/cpu_topology: activating CPU topology
>>
>>
>> Do we really need a machine property? As far as I can see, old QEMU
>> cannot  activate the ctop facility with old and new kernel unless it
>> enables CAP_S390_CPU_TOPOLOGY. I do get
>> oldqemu .... -cpu z14,ctop=on
>> qemu-system-s390x: Some features requested in the CPU model are not 
>> available in the configuration: ctop
>>
>> With the newer QEMU we can. So maybe we can simply have a topology (and
>> then a cpu model feature) in new QEMUs and non in old. the cpu model
>> would then also fence migration from enabled to disabled.
> 
> OK, I can check this.
> In this case migration with topology will be if I understand correctly:
> 
> NEW_QEMU/old_machine <-> NEW_QEMU/old_machine OK
> While
> OLD_QEMU/old_machine <-> NEW_QEMU/old_machine KO
> NEW_QEMU/old_machine <-> OLD_QEMU/old_machine KO

I forgot to say that I mean in the examples above without using a flag.

Of course using a flag like -ctop=off in NEW_QEMU/new_machine allows
to migrate from and to old_machines in an old QEMU.

Also I had the same behavior already in V9 by having a VMState without 
the creation of a machine property, a new cpu feature and a new cpu flag.






> 
> Is this something we can accept?
> 
> regards,
> Pierre
> 

-- 
Pierre Morel
IBM Lab Boeblingen
