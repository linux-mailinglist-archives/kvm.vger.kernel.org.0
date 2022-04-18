Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6B505C15
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345962AbiDRP7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345915AbiDRP6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 11:58:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85799FE7;
        Mon, 18 Apr 2022 08:52:52 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IFf4Rt001424;
        Mon, 18 Apr 2022 15:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1wjrGt+jz3gay8kmdqW05asTN6hbLBWSKqdUxv2BzzU=;
 b=VPDCtMG3WqRBaYP2VMEBeUDp4yldL9pYZ9X04i13ESLadydLV/cKsHBG+TbM3F9JUpSo
 TTRFhgpKWANUO+PJ1Lezb98ndwBvSDC3nIVyOTHqvRUggumLnKEws9xlQJiAKx768kdM
 ah+SC/a23IHqrx68LN9kDi+DUN3SqmjI2M0lHd0fcpGHIf0qv75u1dgSpXciiiKk96Rh
 AduavrLDw4o/eGrDqw5oy0LwPoWU0SgDQZ9baZjy4mUm058U2L4F7NvL9th/8g+hc3IQ
 WR45rGb71yXxHbP3XL77slO6ukGsTkgulCatgtapN62s5V3iPBjUhoEAq9WBy2AkVeSk sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7d6qs63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Apr 2022 15:52:43 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23IFpFZK003744;
        Mon, 18 Apr 2022 15:52:43 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7d6qs5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Apr 2022 15:52:43 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IFkmQj017331;
        Mon, 18 Apr 2022 15:52:41 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3ffne9tnqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Apr 2022 15:52:41 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IFqeCl11731344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Apr 2022 15:52:40 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72016BE051;
        Mon, 18 Apr 2022 15:52:40 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBEF0BE04F;
        Mon, 18 Apr 2022 15:52:37 +0000 (GMT)
Received: from [9.65.204.148] (unknown [9.65.204.148])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 18 Apr 2022 15:52:37 +0000 (GMT)
Message-ID: <93b098e6-d04d-ac82-7761-317c16c5d401@linux.ibm.com>
Date:   Mon, 18 Apr 2022 11:52:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/9] vfio: Make vfio_(un)register_notifier accept a
 vfio_device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
References: <1-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com>
 <aa721d27-9622-5d47-2671-a503ba6cf2ef@linux.ibm.com>
 <20220418154400.GR2120790@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220418154400.GR2120790@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rgJy0e0kYk3do_dlfwnwymnKwBS-qH3B
X-Proofpoint-GUID: anGGdsUpI220lEQdo-lRtgbIpTjO4dnA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=648 phishscore=0
 clxscore=1011 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204180091
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/18/22 11:44 AM, Jason Gunthorpe wrote:
> On Mon, Apr 18, 2022 at 11:28:30AM -0400, Tony Krowiak wrote:
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index a4555014bd1e72..8a5c46aa2bef61 100644
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -2484,19 +2484,15 @@ static int vfio_unregister_group_notifier(struct vfio_group *group,
>>>    	return ret;
>>>    }
>>> -int vfio_register_notifier(struct device *dev, enum vfio_notify_type type,
>>> +int vfio_register_notifier(struct vfio_device *dev, enum vfio_notify_type type,
>>>    			   unsigned long *events, struct notifier_block *nb)
>>>    {
>>> -	struct vfio_group *group;
>>> +	struct vfio_group *group = dev->group;
>> Is there a guarantee that dev != NULL? The original code below checks
>> the value of dev, so why is that check eliminated here?
> Yes, no kernel driver calls this with null dev. The original code
> should have been a WARN_ON as it is just protecting against a buggy
> driver. In this case if the driver is buggy we simply generate a
> backtrace through a null deref panic.
>
> Jason

Regarding the vfio_ap parts:
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>


