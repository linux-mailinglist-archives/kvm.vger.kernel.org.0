Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0834A62513D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 04:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiKKDCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 22:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiKKDCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 22:02:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFAE5CD14;
        Thu, 10 Nov 2022 19:02:02 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB2g8qS006091;
        Fri, 11 Nov 2022 03:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=00TlcYUA8IwStTfXDoL3E2DxuQ2WZQRuZzKUP07vGNo=;
 b=Q4T42teEFhWY4+CvWtkyh4GJKfmrYAUM9/0H1D6q0GKmkbrSwNpcZzUmrECi6mvPh4XO
 uzTFc5T2f1fsw8vEBYTZ5ntL82EarPMYNi2flne2Ib1unFb7snOP58ju0XSxBUD34TmX
 13wXg7guBbYQL/ugCp/E7SdZtwH0BUXHm+Z7ofWfexAQOdo5Q/d5gk1YGy68Odc4MecG
 s50zbglmG6NHXz1Kh4qK/VmR35m20HfVWt/dV2rNLbo2ZYygDm0cP0i3Ku3OjUEIgJr0
 FeRYqwJF58fb9+WecXajXcSScuXoqXvIAAkXI0Q79nouUQO/X3Vb2mnM2Q2XY25E9gu/ LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ksdu7rbn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 03:01:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AB2i0tJ016049;
        Fri, 11 Nov 2022 03:01:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ksdu7rbmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 03:01:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AB2pAm0019707;
        Fri, 11 Nov 2022 03:01:19 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3kngne22qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 03:01:19 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AB31Fle52101886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 03:01:15 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABC3D5806E;
        Fri, 11 Nov 2022 03:01:17 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6D9458064;
        Fri, 11 Nov 2022 03:01:14 +0000 (GMT)
Received: from [9.160.191.98] (unknown [9.160.191.98])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 03:01:14 +0000 (GMT)
Message-ID: <f54c2a93-539f-4520-0561-fbe5cea7772f@linux.ibm.com>
Date:   Thu, 10 Nov 2022 22:01:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 00/11] Connect VFIO to IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
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
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YxgRt1vdsvEvvbqfh55g1ZCYoW5D9RzD
X-Proofpoint-GUID: IC9-lYTkfXZkVJXpdPA5tora7izdjnW6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=738 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211110019
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 7:52 PM, Jason Gunthorpe wrote:
> This series provides an alternative container layer for VFIO implemented
> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> not be compiled in.
> 
> At this point iommufd can be injected by passing in a iommfd FD to
> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> to obtain the compat IOAS and then connect up all the VFIO drivers as
> appropriate.
> 
> This is temporary stopping point, a following series will provide a way to
> directly open a VFIO device FD and directly connect it to IOMMUFD using
> native ioctls that can expose the IOMMUFD features like hwpt, future
> vPASID and dynamic attachment.
> 
> This series, in compat mode, has passed all the qemu tests we have
> available, including the test suites for the Intel GVT mdev. Aside from
> the temporary limitation with P2P memory this is belived to be fully
> compatible with VFIO.

AFAICT there is no equivalent means to specify vfio_iommu_type1.dma_entry_limit when using iommufd; looks like we'll just always get the default 65535.  Was this because you envision the limit being not applicable for iommufd (limits will be enforced via either means and eventually we won't want to ) or was it an oversight?

Thanks,
Matt

