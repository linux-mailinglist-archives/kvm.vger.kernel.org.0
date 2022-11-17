Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F3362D70F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiKQJcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiKQJbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:31:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E926D48C
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:31:51 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH9Nice008862;
        Thu, 17 Nov 2022 09:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mOjDGlykK/GDEz0zep7DNt2Hcg75a47hUXy30T23ZkM=;
 b=VKW0SaGjjiNNOiGz+IBcKOzBQyPTOY1zf2dxV2CDJX7bMlryPyoNL+u4T31aKbcpV6Ob
 Yd20B4N7EgUI4XpQrSfghlD0ofYEn1fhLDqxWTCPrZHcz5GPssszh15U3N6nzRaELFWm
 ISUVbc2SMyM8iUmzI4mFdZ6LPOkswRLTUUkLHNhqzjnW3zu8RtDQuNo9TaqVWtBt+bt/
 nAnE3+lu7O5qX8gnAeSIGEkSxhaHfaA981K5QJ8re8t6pfJpVOdmnYK2rA2lcUgbhyiv
 QTXr0GokQp/vV2DWD9+6joOdo6p+CLAr7QrKPuw0vfTPkCxZeNg3nGer1oAb8goAK/4r zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwj9qg7nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:31:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AH9O6op011468;
        Thu, 17 Nov 2022 09:31:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwj9qg7m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:31:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AH9KtlV016296;
        Thu, 17 Nov 2022 09:31:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kt348yavj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:31:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AH9Vd2b28443002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 09:31:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A18D05204F;
        Thu, 17 Nov 2022 09:31:39 +0000 (GMT)
Received: from [9.171.46.61] (unknown [9.171.46.61])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BCF0C5204E;
        Thu, 17 Nov 2022 09:31:38 +0000 (GMT)
Message-ID: <1fe0b036-19e7-a8a4-63aa-9bbcaed48187@linux.ibm.com>
Date:   Thu, 17 Nov 2022 10:31:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
Content-Language: en-US
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
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a2ddbba2-9e52-8ed8-fdbc-a587b8286576@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m60qo2apCFNv_nzDErwOJbF_7_qRLX7E
X-Proofpoint-ORIG-GUID: RsDJGxIRzkgCWFTEtxqK_MBRn9fuDhqY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_04,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/16/22 17:51, Christian Borntraeger wrote:
> Am 02.09.22 um 09:55 schrieb Pierre Morel:
>> Hi,
>>
>> The implementation of the CPU Topology in QEMU has been drastically
>> modified since the last patch series and the number of LOCs has been
>> greatly reduced.
>>
>> Unnecessary objects have been removed, only a single S390Topology object
>> is created to support migration and reset.
>>
>> Also a documentation has been added to the series.
>>
>>
>> To use these patches, you will need Linux V6-rc1 or newer.
>>
>> Mainline patches needed are:
>>
>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF 
>> fac..
>>
>> Currently this code is for KVM only, I have no idea if it is interesting
>> to provide a TCG patch. If ever it will be done in another series.
>>
>> To have a better understanding of the S390x CPU Topology and its
>> implementation in QEMU you can have a look at the documentation in the
>> last patch.
>>
>> New in this series
>> ==================
>>
>>    s390x/cpus: Make absence of multithreading clear
>>
>> This patch makes clear that CPU-multithreading is not supported in
>> the guest.
>>
>>    s390x/cpu topology: core_id sets s390x CPU topology
>>
>> This patch uses the core_id to build the container topology
>> and the placement of the CPU inside the container.
>>
>>    s390x/cpu topology: reporting the CPU topology to the guest
>>
>> This patch is based on the fact that the CPU type for guests
>> is always IFL, CPUs are always dedicated and the polarity is
>> always horizontal.
>> This may change in the future.
>>
>>    hw/core: introducing drawer and books for s390x
>>    s390x/cpu: reporting drawers and books topology to the guest
>>
>> These two patches extend the topology handling to add two
>> new containers levels above sockets: books and drawers.
>>
>> The subject of the last patches is clear enough (I hope).
>>
>> Regards,
>> Pierre
>>
>> Pierre Morel (10):
>>    s390x/cpus: Make absence of multithreading clear
>>    s390x/cpu topology: core_id sets s390x CPU topology
>>    s390x/cpu topology: reporting the CPU topology to the guest
>>    hw/core: introducing drawer and books for s390x
>>    s390x/cpu: reporting drawers and books topology to the guest
>>    s390x/cpu_topology: resetting the Topology-Change-Report
>>    s390x/cpu_topology: CPU topology migration
>>    target/s390x: interception of PTF instruction
>>    s390x/cpu_topology: activating CPU topology
> 
> 
> Do we really need a machine property? As far as I can see, old QEMU
> cannot  activate the ctop facility with old and new kernel unless it
> enables CAP_S390_CPU_TOPOLOGY. I do get
> oldqemu .... -cpu z14,ctop=on
> qemu-system-s390x: Some features requested in the CPU model are not 
> available in the configuration: ctop
> 
> With the newer QEMU we can. So maybe we can simply have a topology (and
> then a cpu model feature) in new QEMUs and non in old. the cpu model
> would then also fence migration from enabled to disabled.

OK, I can check this.
In this case migration with topology will be if I understand correctly:

NEW_QEMU/old_machine <-> NEW_QEMU/old_machine OK
While
OLD_QEMU/old_machine <-> NEW_QEMU/old_machine KO
NEW_QEMU/old_machine <-> OLD_QEMU/old_machine KO

Is this something we can accept?

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
