Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407A163F184
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiLANYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiLANX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:23:59 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785104E69E
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:23:58 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1D3Ao7005439;
        Thu, 1 Dec 2022 13:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7MPDOovTCWDf9JypLWGVTVZX0U3681sunW8i6pIHnAk=;
 b=tarY3ned2TE/t5u9wSZWEZUf7LJ+RuHgAp4ggQhrQALiDarqrqL8yRGv3+f/CPpojdrM
 c/BiqZknjzP8xoXv+Vtcj0TC9bvbLJnQwDGeoSS6h4Ok411mLi9MEuHBEOZP7ON+hk3K
 TazFgmDWWi5IMULhsPwRGcLiqYbP2wfYm2g008G40g5+91+dwzkKy/Rl0hXFke+Sp6uj
 zNEl0JFBOfXKRIInk1TcNjWIJLJrWD5K0X+j+SSHI9GFwb/H0Gh/wjwvbHZ1g1Puw6OI
 /v+08hQMAUAlxl8y+hyZeAA9c7S0Hvp9LrRNsYqYSPXrC8USjFkd34ChIFFUFEWM3Nc0 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6vtfrkga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:23:51 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1D43NZ011163;
        Thu, 1 Dec 2022 13:23:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6vtfrkfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:23:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1DL2xp020940;
        Thu, 1 Dec 2022 13:23:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hwbwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:23:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1DNiTd5571082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 13:23:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F6611C04C;
        Thu,  1 Dec 2022 13:23:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4EED11C04A;
        Thu,  1 Dec 2022 13:23:43 +0000 (GMT)
Received: from [9.171.21.111] (unknown [9.171.21.111])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 13:23:43 +0000 (GMT)
Message-ID: <75948ee7-f34b-1ff9-2bae-ca56c09e74ed@linux.ibm.com>
Date:   Thu, 1 Dec 2022 14:23:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 0/7] s390x: CPU Topology
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
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <68e075ec-2698-3591-b808-9cb0f4b2c4f1@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <68e075ec-2698-3591-b808-9cb0f4b2c4f1@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _DCEOKEIfsBWjYLhcXmBxSJXimePptZB
X-Proofpoint-ORIG-GUID: m4y7hqPS-PF-SNfzPs570HVMvnPhhYIg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=737 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010093
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/1/22 09:45, Cédric Le Goater wrote:
> Hello Pierre
> 
> On 11/29/22 18:41, Pierre Morel wrote:
>> Hi,
>>
>> The implementation of the CPU Topology in QEMU has been modified
>> since the last patch series.
>>
>> - The two preliminary patches have been accepted and are no longer
>>    part of this series.
>>
>> - The topology machine property has been abandoned
>>
>> - the topology_capable QEMU capability has been abandoned
>>
>> - both where replaced with a new CPU feature, topology-disable
>>    to fence per default the ctop topology information feature.
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
>> To have a better understanding of the S390x CPU Topology and its
>> implementation in QEMU you can have a look at the documentation in the
>> last patch of this series.
>>
>> The admin will want to match the host and the guest topology, taking
>> into account that the guest does not recognize multithreading.
>> Consequently, two vCPU assigned to threads of the same real CPU should
>> preferably be assigned to the same socket of the guest machine.

Hello Cedric,

> Please make sure the patchset compiles on non-s390x platforms and check

Yes,

> that the documentation generates correctly. You will need to install :
> 
>    python3-sphinx python3-sphinx_rtd_theme
> 
> 'configure' should then enable doc generation.

Yes, thanks,

Pierre

> 
> Thanks,
> 
> C.
> 

-- 
Pierre Morel
IBM Lab Boeblingen
