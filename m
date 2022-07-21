Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EEC57C9CF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiGULh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiGULhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:37:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA452459
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:37:22 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LBFRYD029655;
        Thu, 21 Jul 2022 11:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jG4UrI7tJxrYRS1TiGzcdECRfBA3oj3rSHWMn7wkNeM=;
 b=jEAYVu7M2n5G58V4cdq6rttjOxpam28VkhW0pJ9IyVHI3AiaPBupeKULfwZgJpCK+AvK
 0fNqsrfbvWz9qaHVcNHpVg5d9Znh69W5xJf+hf7a73Y5iN+PM/f3uOq4oCnnj8PP9eVK
 fc4Gqo+WSmuBp+Yi1gan+jTY95xPlC3Wj5ihZkjl99jHbm0B+BEsAwghwMbt7deGeWrp
 R4wU6LidjQQIb/TGkFpxxdKxk3U/V0tFZtjmN8Kf2sqK5rO4p7YDMUlV1ZrRHhqwaJGB
 DB8dLcj2arq53Db699wup+eVjpkLHMQoprY2fOfpWrPcavS6U8MWatXTBFVua81FPxlN Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf5ru0fcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 11:37:07 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LBJDac011467;
        Thu, 21 Jul 2022 11:37:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf5ru0fc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 11:37:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LBYmHW029689;
        Thu, 21 Jul 2022 11:37:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8xun7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 11:37:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LBbDYj30015846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 11:37:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D5EA405B;
        Thu, 21 Jul 2022 11:37:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD1DEA4054;
        Thu, 21 Jul 2022 11:36:59 +0000 (GMT)
Received: from [9.171.89.164] (unknown [9.171.89.164])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 11:36:59 +0000 (GMT)
Message-ID: <2c0b3926-482a-9c3f-1937-1be672ba7aeb@linux.ibm.com>
Date:   Thu, 21 Jul 2022 13:41:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-9-pmorel@linux.ibm.com>
 <3a821cd1-b8a0-e737-5279-8ef55e58a77f@linux.ibm.com>
 <b1e89718-232c-2b0b-2133-102ab7b4dad4@linux.ibm.com>
 <b30eb75a-5a0b-3428-b812-95a2884914e4@linux.ibm.com>
 <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
 <e497396a-eadf-15ae-e11c-d6a2bbbff7c7@linux.ibm.com>
 <3b2f62a7-b526-adfd-e791-f2bc2cae3ccf@linux.ibm.com>
 <4d0d25e9-fedf-728c-12e9-70e4dc04d6b7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <4d0d25e9-fedf-728c-12e9-70e4dc04d6b7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KkAy_KrZRIrsAu4fh4feqta8Io22-Ygt
X-Proofpoint-GUID: ciCFhT6-OlcRrRo8X9bZQsSKr2fMwGsH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_16,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/22 10:16, Janis Schoetterl-Glausch wrote:
> On 7/21/22 09:58, Pierre Morel wrote:
>>
>>

...snip...

>>
>> You are right, numa is redundant for us as we specify the topology using the core-id.
>> The roadmap I would like to discuss is using a new:
>>
>> (qemu) cpu_move src dst
>>
>> where src is the current core-id and dst is the destination core-id.
>>
>> I am aware that there are deep implication on current cpu code but I do not think it is not possible.
>> If it is unpossible then we would need a new argument to the device_add for cpu to define the "effective_core_id"
>> But we will still need the new hmp command to update the topology.
>>
> I don't think core-id is the right one, that's the guest visible CPU address, isn't it?

Yes, the topology is the one seen by the guest.

> Although it seems badly named then, since multiple threads are part of the same core (ok, we don't support threads).

I guess that threads will always move with the core or... we do not 
support threads.

> Instead socket-id, book-id could be changed dynamically instead of being computed from the core-id.
> 

What becomes of the core-id ?




-- 
Pierre Morel
IBM Lab Boeblingen
