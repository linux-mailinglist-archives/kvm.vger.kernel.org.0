Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E236F5F57AE
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiJEPlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 11:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiJEPlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 11:41:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F272E9D4;
        Wed,  5 Oct 2022 08:41:11 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295EmIZ1018838;
        Wed, 5 Oct 2022 15:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G+k4TTHlQuu3tT++nxtY6QsA4Br6p5zxOaKrc5Zcxvo=;
 b=BKAAMKVXui/tLDovG5S/AHHAsEEqMHTb8WMwUAaNR6MCtjPnoh9zvEdXZoqcb71b0F3r
 mtOyJz1oPTUOUgJGD+PRVlOW8wX88PBsLgatqCQWAt8JFlinLKVii0Umn6V3Ho9KIt6D
 JFG65x5A1jj9P4KfPltPJuPgTuKFNsJyO4rxlj0yn0cgI70J2tjPooDxwLws5TVjTQx+
 +/cmDdf/c6FLY4VO5exi8shsu1neXg4ZcGutnkwqrU+leFFKkZdBq/ecUG+R4gor3N9J
 FzOgthXSmEi4+sc8tPM7xrz7FraXYqWabvHbSR7gNv559UwRuojqxa9A2wGeuDi3AqN9 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1c0v1tm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 15:41:04 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295EmRiM019358;
        Wed, 5 Oct 2022 15:41:04 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1c0v1tkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 15:41:04 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295FannR018918;
        Wed, 5 Oct 2022 15:41:02 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 3jxd69ve8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 15:41:02 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295Ff1vw42336578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 15:41:01 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D0ED5805E;
        Wed,  5 Oct 2022 15:41:01 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4AED5805C;
        Wed,  5 Oct 2022 15:40:59 +0000 (GMT)
Received: from [9.160.167.172] (unknown [9.160.167.172])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 15:40:59 +0000 (GMT)
Message-ID: <2a3ebbda-aafc-d65c-ad99-1a88968f9db7@linux.ibm.com>
Date:   Wed, 5 Oct 2022 11:40:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
 <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
 <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
 <Yz2NSDa3E6LpW1c5@nvidia.com> <Yz2OH5wJUi8kI/FF@ziepe.ca>
 <f449699f-38e3-9e15-cc1b-7213014e52ca@linux.ibm.com>
In-Reply-To: <f449699f-38e3-9e15-cc1b-7213014e52ca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MG8A9AgkZ7eEAEy1gVS4TrbR3KgybeMM
X-Proofpoint-GUID: VReJ2-h3O178TJN-7dAi03y6I12trmDb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050097
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/22 10:21 AM, Matthew Rosato wrote:
> On 10/5/22 10:01 AM, Jason Gunthorpe wrote:
>> On Wed, Oct 05, 2022 at 10:57:28AM -0300, Jason Gunthorpe wrote:
>>> On Wed, Oct 05, 2022 at 09:46:45AM -0400, Matthew Rosato wrote:
>>>
>>>  
>>>> (again, with the follow-up applied) Besides the panic above I just
>>>> noticed there is also this warning that immediately precedes and is
>>>> perhaps more useful.  Re: what triggers the WARN, both group->owner
>>>> and group->owner_cnt are already 0
>>>
>>> And this is after the 2nd try that fixes the locking?
>>>
>>> This shows that vfio_group_detach_container() is called twice (which
>>> was my guess), hoever this looks to be impossible as both calls are
>>> protected by 'if (group->container)' and the function NULL's
>>> group->container and it is all under the proper lock.
>>>
>>> My guess was that missing locking caused the two cases to race and
>>> trigger WARN, but the locking should fix that.
>>>
>>> So I'm at a loss, can you investigate a bit?
>>
>> Huh, perhaps I'm loosing my mind, but I'm sure I sent this out, but it
>> is not in the archive. This v2 fixes the missing locking and the rest
>> of the remarks.
> 
> Ah, here we go.  OK, initial testing with vfio-pci on this version and I note that
> 
> 1) the warning/crash is gone
> 2) the iommu group ID no longer increments
> 
> I next will take it through the longer series of tests that would crash before 'vfio: Follow a strict lifetime for struct iommu_group' but this looks good so far.
> 

OK, this also looks good - thanks!  Besides the vfio-pci testing on s390 I also ran some brief tests against both vfio-ccw and vfio-ap.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>

