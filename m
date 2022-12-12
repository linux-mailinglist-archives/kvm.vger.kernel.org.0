Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F24649A62
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 09:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiLLIvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 03:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiLLIv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 03:51:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516EE087
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 00:51:26 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC8aOKo011976;
        Mon, 12 Dec 2022 08:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JBXjQCImaFukSoxP5Ug682SQ3wmFJA9c+KzwN4XOPhk=;
 b=rEhtIqRxAswPbvp03OmfGyOMt57PvLr9Ro7qcB7etVXDIVQEyvMPjQF7zIv2Gsuw702P
 RxJ2ZIJFx1fOu38RAmFo5k/ulroQufP9TRCOmR0tJDFjUN9SU9og3ghyg2OtZstEOpDX
 d2Y6TjEtRkyNtkzn8Hc3U9rhtHG7NTh6Br4Z08D+GiJZHAm6kWgjZ59MUaqvGIYjtKyp
 QbfjmZ6ZjQ1pkg8PBAGKHU/wR4RlbFwoaoFa3qYPG3PREeNLgpSrBSRMPlOzbRSJB3c+
 G6fYbgtohzdXGYt7fqffAktELcv9Y18a4+saH67MmL9bXEir29VNCyFZ/BwN0hjYv/A4 Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3vcbkx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 08:51:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BC8cAXs018684;
        Mon, 12 Dec 2022 08:51:13 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3vcbkw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 08:51:12 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC6YlKW011845;
        Mon, 12 Dec 2022 08:51:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mchr61pfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 08:51:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BC8p5FJ44630380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 08:51:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A6220040;
        Mon, 12 Dec 2022 08:51:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABE2F2004B;
        Mon, 12 Dec 2022 08:51:03 +0000 (GMT)
Received: from [9.171.10.222] (unknown [9.171.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 08:51:03 +0000 (GMT)
Message-ID: <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
Date:   Mon, 12 Dec 2022 09:51:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m96byv4qYfOJ4DWcQl3AZ1_OUAkeGv3o
X-Proofpoint-ORIG-GUID: wc42q8Uin9VSo9_oh6lwwk9QZXviYmid
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_01,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/22 14:32, Thomas Huth wrote:
> On 08/12/2022 10.44, Pierre Morel wrote:
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
> 
> I now thought that it is not possible to enable "ctop" on older QEMUs 
> since the don't enable the KVM capability? ... or is it still somehow 
> possible? What did I miss?
> 
>   Thomas

Enabling ctop with ctop=on on old QEMU is not possible, this is right.
But, if STFL(11) is enable in the source KVM by a new QEMU, I can see 
that even with -ctop=off the STFL(11) is migrated to the destination.

It is highly possible that I missed something in the cpu model.

A solution proposed by Cedric was to add a new machine but we did not 
want this because we decided that we do not want to wait for a new machine.

Another solution could be to have a we can have a new CPU feature 
overruling ctop like S390_FEAT_CPU_TOPOLOGY in the last series version 12.
I am not sure it must be linked with the creation of a new machine.

The solution here in this series is to add a VMState which will block 
the migration with older QEMU if the topology is activated with ctop on 
a new QEMU.

Regards,
Pierre

> 
> 
>> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
>> allows to forbid the migration in such a case.
>>
>> Note that the VMState will be used to hold information on the
>> topology once we implement topology change for a running guest.
> 

-- 
Pierre Morel
IBM Lab Boeblingen
