Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD34D649BD4
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 11:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiLLKQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 05:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLLKQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 05:16:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F5E5FF7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:16:18 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC8ejdR014027;
        Mon, 12 Dec 2022 10:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ukJcda36wuWwB17COh+RuDcwukMX66mLeUbHRDlI2XY=;
 b=iHS8um2rfbLPwZwrT15rVnUnChNEwLs2N7sDQBVLlra5tDZu2ruhv60J96FlEGDnNRDa
 dFNeUtvchf0MDwp0mhnH55HNNK8ha71N8qSY+RyNE9P8HV2O/nR6hVmPjICoPwGjh+V3
 JJEMAvSAiZt1NXlfpgFrYCQ/Z2B2UQSFibxKF0XfV10WgiBsB6q/5cs56RrrAG5l1gpx
 G1Uyp8dga+pQER3ABMdQ51FPU8185m8GME8mqtBiw/EtscZHCXOWUkaxB+iApfwl4o3N
 k5tQXfBluCbwv1zYXWhhy/TUWCHfD4DyVQBGgaPIc1Gg2gf44ziuSWqT+FFZY4OjfDr8 XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md4695g8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:16:06 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCAAh1J028580;
        Mon, 12 Dec 2022 10:16:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md4695g7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:16:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BBNFxZ0028332;
        Mon, 12 Dec 2022 10:16:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mchr62emv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:16:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCA1wq844827128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 10:01:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AA0720040;
        Mon, 12 Dec 2022 10:01:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B526D20043;
        Mon, 12 Dec 2022 10:01:56 +0000 (GMT)
Received: from [9.171.10.222] (unknown [9.171.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 10:01:56 +0000 (GMT)
Message-ID: <663e6861-be17-88ae-866a-e62569d6c721@linux.ibm.com>
Date:   Mon, 12 Dec 2022 11:01:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zHbzTN5_u4J_9F1y8WLHLjyZ6Ge3kd-w
X-Proofpoint-ORIG-GUID: 8iBpXvm-M7PY_Q3OfesYtcLnsHN-Gwue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/22 15:45, Cédric Le Goater wrote:
> On 12/8/22 10:44, Pierre Morel wrote:
>> Hi,
>>
>> Implementation discussions
>> ==========================
>>
>> CPU models
>> ----------
>>
>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>> for old QEMU we could not activate it as usual from KVM but needed
>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>> Checking and enabling this capability enables
>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>
>> Migration
>> ---------
>>
>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>> host the STFL(11) is provided to the guest.
>> Since the feature is already in the CPU model of older QEMU,
>> a migration from a new QEMU enabling the topology to an old QEMU
>> will keep STFL(11) enabled making the guest get an exception for
>> illegal operation as soon as it uses the PTF instruction.
>>
>> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
>> allows to forbid the migration in such a case.
>>
>> Note that the VMState will be used to hold information on the
>> topology once we implement topology change for a running guest.
>>
>> Topology
>> --------
>>
>> Until we introduce bookss and drawers, polarization and dedication
>> the topology is kept very simple and is specified uniquely by
>> the core_id of the vCPU which is also the vCPU address.
>>
>> Testing
>> =======
>>
>> To use the QEMU patches, you will need Linux V6-rc1 or newer,
>> or use the following Linux mainline patches:
>>
>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF 
>> fac..
>>
>> Currently this code is for KVM only, I have no idea if it is interesting
>> to provide a TCG patch. If ever it will be done in another series.
>>
>> Documentation
>> =============
>>
>> To have a better understanding of the S390x CPU Topology and its
>> implementation in QEMU you can have a look at the documentation in the
>> last patch of this series.
>>
>> The admin will want to match the host and the guest topology, taking
>> into account that the guest does not recognize multithreading.
>> Consequently, two vCPU assigned to threads of the same real CPU should
>> preferably be assigned to the same socket of the guest machine.
>>
>> Future developments
>> ===================
>>
>> Two series are actively prepared:
>> - Adding drawers, book, polarization and dedication to the vCPU.
>> - changing the topology with a running guest
> 
> Since we have time before the next QEMU 8.0 release, could you please
> send the whole patchset ? Having the full picture would help in taking
> decisions for downstream also.
> 
> I am still uncertain about the usefulness of S390Topology object because,
> as for now, the state can be computed on the fly, the reset can be
> handled at the machine level directly under s390_machine_reset() and so
> could migration if the machine had a vmstate (not the case today but
> quite easy to add). So before merging anything that could be difficult
> to maintain and/or backport, I would prefer to see it all !
> 

The goal of dedicating an object for topology was to ease the 
maintenance and portability by using the QEMU object framework.

If on contrary it is a problem for maintenance or backport we surely 
better not use it.

Any other opinion?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
