Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337EF6283C9
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 16:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiKNPWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 10:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiKNPWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 10:22:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D751FCEB;
        Mon, 14 Nov 2022 07:22:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.5) with ESMTP id 2AEFHMr7005097;
        Mon, 14 Nov 2022 15:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/Z1ovYZEh50gAU/VDhHQTeJLnVQKYU8Bz/YxvyJhsrc=;
 b=BtXFdoq8w/tLgRG9MgZvfmbltvdE8NU9syTmC0EeARe6GIWyMYcZ3T6QwtEKNKIJReV1
 cBrkuxBg5fb0Q+4mmDS1rbVu6uKE8udpbz4IUnQVwPFrQ3wwpQa1vh8hMwxNZLdtGnIT
 e0sCx/U2Aqo43RkDj7tlVp8pCCf3diigWlT2yCYdbYqnyjtwlh6yFTUmvdo84G4EURbi
 focoEW/DIGmVMVYIlPiv4e7v0+1SJJxlJBoUUk4HtTWwFqG7UQRZJLyF8TdPPLOpoviO
 J9fP8HBBwk54zHx+/PuNTPZDdVWfYahBO7ubdoaY42EkZp0Bg0O+oTCv/M5mumlQO0iT yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kur6e82bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 15:21:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AEFHmUD006072;
        Mon, 14 Nov 2022 15:21:56 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kur6e82b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 15:21:56 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AEFLH0S002920;
        Mon, 14 Nov 2022 15:21:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3kt349j2m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 15:21:55 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AEFLw7b62980488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 15:21:58 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7585658052;
        Mon, 14 Nov 2022 15:21:53 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67AA95805A;
        Mon, 14 Nov 2022 15:21:50 +0000 (GMT)
Received: from [9.160.3.49] (unknown [9.160.3.49])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 14 Nov 2022 15:21:50 +0000 (GMT)
Message-ID: <5ab00688-aa61-171c-13b4-e9aea7a6a09d@linux.ibm.com>
Date:   Mon, 14 Nov 2022 10:21:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 00/11] Connect VFIO to IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, iommu@lists.linux.dev,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
 <f54c2a93-539f-4520-0561-fbe5cea7772f@linux.ibm.com>
 <Y3JPZwEHjGDU4Oyq@nvidia.com>
 <2890d53a-2437-c74c-2082-1ee29414878f@linux.ibm.com>
 <Y3JXwd4sZJfm/Il2@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y3JXwd4sZJfm/Il2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GAIJeCod5S4Fb_X4JFlyEbCg5Huv7a9e
X-Proofpoint-GUID: 8gBKnPNxv1dolpQF6DJK7SrP9tixHzI1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_12,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 9:59 AM, Jason Gunthorpe wrote:
> On Mon, Nov 14, 2022 at 09:55:21AM -0500, Matthew Rosato wrote:
>>>> AFAICT there is no equivalent means to specify
>>>> vfio_iommu_type1.dma_entry_limit when using iommufd; looks like
>>>> we'll just always get the default 65535.
>>>
>>> No, there is no arbitary limit on iommufd
>>
>> Yeah, that's what I suspected.  But FWIW, userspace checks the
>> advertised limit via VFIO_IOMMU_GET_INFO /
>> VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL, and this is still being advertised
>> as 65535 when using iommufd.  I don't think there is a defined way
>> to return 'ignore this value'.
> 
> Is something using this? Should we make it much bigger?

Yes, s390 when doing lazy unmapping likes to use larger amounts of concurrent DMA, so there can be cases where we want to raise this limit.

The initial value of 65535 is already pretty arbitrary (U16_MAX) -- If iommufd is doing its own management and this value becomes deprecated in this scenario, and we can't set it to a magic value that says 'ignore me' then maybe it just makes sense for now to set it arbitrarily larger when using iommufd e.g. U32_MAX?

