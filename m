Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C3E663098
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbjAITkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 14:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjAITkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 14:40:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887A176801;
        Mon,  9 Jan 2023 11:40:36 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309INvA5005048;
        Mon, 9 Jan 2023 19:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QyKqcW400I7fdGBwWxCZ2QGqWWUUfCAvtddLjZAuzhM=;
 b=WthHWu2Ty/j5+16LcQpum2P2laRu3PBjiDNgPGzaw9nPTSN3R7g9ZvjPT6dJPU058R+t
 f1UuJNWNKK6zdf44ZX0sScqYOLKtJwrbFwEBCBLY13jj4RVrHfuACV7XtdR78eD93EQv
 Z2rur9frkyBZeP8ftPt8B7UteMWL8FAGUqdugD4Z2/iK1HOUjn3uQkE9bXisdcyfc4Gr
 FHmDS4Y6z/gZwMt8Cyp7lrBw13e7Ul8SOw725PHR5Rh2hKTP3H3qvo56tXVkQ40qA5b5
 HyxzaXpFR3kHCDV+oStUV1kiwTFOG/SB5rhFS1/xcNzoZx/FME5d6soUseKE5B/Aprv7 Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjasyefw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 19:40:33 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309J8lxv021500;
        Mon, 9 Jan 2023 19:40:33 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjasyefq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 19:40:33 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 309IxVms029729;
        Mon, 9 Jan 2023 19:40:32 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3my0c7gy6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 19:40:32 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309JeUsZ4063868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 19:40:30 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44EAF58054;
        Mon,  9 Jan 2023 19:40:30 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1F3658045;
        Mon,  9 Jan 2023 19:40:28 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 19:40:28 +0000 (GMT)
Message-ID: <3a1863b1-f0f2-92a6-09c4-eab1faafcd41@linux.ibm.com>
Date:   Mon, 9 Jan 2023 14:40:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-8-akrowiak@linux.ibm.com>
 <20221219151007.639dff5f.pasic@linux.ibm.com>
 <7b6d7e91-ba00-6486-39ae-91fca30b2cfb@linux.ibm.com>
 <20221220182407.5959a4b6.pasic@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20221220182407.5959a4b6.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aXW4Uzq5MvLmCkoZBv9Qd31NJIr6vMUx
X-Proofpoint-ORIG-GUID: _YGSmIYlAhw2DvPq9EdmY1vbisvdMPDp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_13,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090136
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/20/22 12:24 PM, Halil Pasic wrote:
> On Tue, 20 Dec 2022 09:33:03 -0500
> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 12/19/22 9:10 AM, Halil Pasic wrote:
>>> On Tue, 13 Dec 2022 10:44:37 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an error
>>>> not handled by a case statement.
>>> Why?
>>
>> If the ZAPQ failed, then instructions submitted to the same queue will
>> likewise fail. Are you saying it's not safe to assume, therefore, that
>> interrupts will not be occurring?
> Right. We are talking about the default branch here, and I suppose, the
> codes where we know that it is safe to assume that no reset is needed
> handled separately (AP_RESPONSE_DECONFIGURED).
>
> I'm not convinced that if we take the default branch we can safely
> assume, that we won't see any interrupts.
>
> For example consider hot-unplug as done by KVM. We modify the
> CRYCB/APCB with all vCPUS take out of SIE, but we don't keep
> the vCPUs out of SIE until the resets of the unpugged queues
> are done, and we don't do any extra interrupt disablement
> with all vCPUs keept out of SIE. So I believe currently there
> may be a window where the guest can observe a 01 but the
> interrupts are still live. That may be a bug, but IMHO it ain't clear
> cut.
>
> But it is not just about interrupts. Before we returned an error
> code, which gets propagated to the userspace if this reset was
> triggered via the ioctl.
>
> With this change, ret seems to be uninitialized when returned
> if we take the code path which you change here. So we would
> end up logging a warning and returning garbage?


That was an oversight. The -EIO value was returned previously, so the 
ret = -EIO should be set in the default case.


>
> One could also debate, whether RCs introduced down the road
> can affect the logic here (even if the statement "if we
> see an RC other that 00 and 02, we don't need to pursue a
> reset any further, and interrpts are disabled" were to be
> guaranteed to be true now, new RCs could theoretically mess
> this up).


I think that would be the case regardless of this change. If new RCs are 
introduced, this function ought to be revisited anyway and appropriate 
changes made.


>
>   
>>
>>> I'm afraid this is a step in the wrong direction...
>>
>> Please explain why.
>>
> Sorry, I kept this brief because IMHO it is your job to tell us why
> this needs to be changed. But I gave in, as you see.
>
> Regards,
> Halil
