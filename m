Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CE62834E
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 15:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiKNO4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 09:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbiKNOz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 09:55:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4092C103;
        Mon, 14 Nov 2022 06:55:58 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.5) with ESMTP id 2AEEe01b016648;
        Mon, 14 Nov 2022 14:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fqKTGIO2jE8deoyOm/DWSJOF09dxfDZxr8vIhsAJle4=;
 b=fyRJC8akQniM25UdBBkTo3RNz2iN8SVoLEBe142d6baOO1AL7z+NW+RJQ6Y5GXQXEGek
 0c/dUqmtLRTUowVHqaubf/UJp7LXPWPek1gG3OB0KwtjsxXkv8elricNW3vq5NW2njdb
 w/aEVWvlkpnNRbKA4XaPren5u6qLISCT/YhdywQz0C94RiIxJe32u8mnbhpB8xm2kgOL
 8p+d9/g0Etb3VIzfMHmg4K/v9ff/eYctAfhu0KL2wK+5zlpts1TK4yrWgyTQxuaCYGeG
 66JTPuRiPCsINqdu0fpDLF5t619/Z92WtRBp6zcKp6ZX55M8dd3wX21U6wenh9h6fxXx Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kuqmt0d5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 14:55:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AEEefR5018422;
        Mon, 14 Nov 2022 14:55:28 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kuqmt0d4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 14:55:28 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AEEpDn0022586;
        Mon, 14 Nov 2022 14:55:26 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3kt349hv8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 14:55:26 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AEEtT6M65733038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 14:55:29 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C55DB58052;
        Mon, 14 Nov 2022 14:55:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C56DB58062;
        Mon, 14 Nov 2022 14:55:21 +0000 (GMT)
Received: from [9.160.3.49] (unknown [9.160.3.49])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 14 Nov 2022 14:55:21 +0000 (GMT)
Message-ID: <2890d53a-2437-c74c-2082-1ee29414878f@linux.ibm.com>
Date:   Mon, 14 Nov 2022 09:55:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 00/11] Connect VFIO to IOMMUFD
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
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y3JPZwEHjGDU4Oyq@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dBrd63fegQfRUKjt3UIsxah8kwhEL6ZM
X-Proofpoint-GUID: dDymrDDZIbN5X0CC3sVQFV42JXGQNI1t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_12,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 mlxlogscore=792 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 9:23 AM, Jason Gunthorpe wrote:
> On Thu, Nov 10, 2022 at 10:01:13PM -0500, Matthew Rosato wrote:
>> On 11/7/22 7:52 PM, Jason Gunthorpe wrote:
>>> This series provides an alternative container layer for VFIO implemented
>>> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
>>> not be compiled in.
>>>
>>> At this point iommufd can be injected by passing in a iommfd FD to
>>> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
>>> to obtain the compat IOAS and then connect up all the VFIO drivers as
>>> appropriate.
>>>
>>> This is temporary stopping point, a following series will provide a way to
>>> directly open a VFIO device FD and directly connect it to IOMMUFD using
>>> native ioctls that can expose the IOMMUFD features like hwpt, future
>>> vPASID and dynamic attachment.
>>>
>>> This series, in compat mode, has passed all the qemu tests we have
>>> available, including the test suites for the Intel GVT mdev. Aside from
>>> the temporary limitation with P2P memory this is belived to be fully
>>> compatible with VFIO.
>>
>> AFAICT there is no equivalent means to specify
>> vfio_iommu_type1.dma_entry_limit when using iommufd; looks like
>> we'll just always get the default 65535.
> 
> No, there is no arbitary limit on iommufd

Yeah, that's what I suspected.  But FWIW, userspace checks the advertised limit via VFIO_IOMMU_GET_INFO / VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL, and this is still being advertised as 65535 when using iommufd.  I don't think there is a defined way to return 'ignore this value'. 

This should go away later when we bind to iommufd directly since QEMU would not be sharing the type1 codepath in userspace. 

> 
>> Was this because you envision the limit being not applicable for
>> iommufd (limits will be enforced via either means and eventually we
>> won't want to ) or was it an oversight?
> 
> The limit here is primarily about limiting userspace abuse of the
> interface.
> 
> iommufd is using GFP_KERNEL_ACCOUNT which shifts the responsiblity to
> cgroups, which is similar to how KVM works.
> 
> So, for a VM sandbox you'd set a cgroup limit and if a hostile
> userspace in the sanbox decides to try to OOM the system it will hit
> that limit, regardless of which kernel APIs it tries to abuse.
> 
> This work is not entirely complete as we also need the iommu driver to
> use GFP_KERNEL_ACCOUNT for allocations connected to the iommu_domain,
> particularly for allocations of the IO page tables themselves - which
> can be quite big.
> 
> Jason

