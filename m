Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F77553CC34
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbiFCPU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245437AbiFCPUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:20:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9023C50472;
        Fri,  3 Jun 2022 08:20:54 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253Ehxpv002882;
        Fri, 3 Jun 2022 15:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FxSbxlUzgD0bWBcCWCPGWEC2A5czy7QJos0g+EJ5hbg=;
 b=NZ0LPY3nEtkUSB2WBeZj344gracCZXHmJr8tJhLQXt1FXcjG4zOYTs8UQFLph19F9YAM
 D4Axvzyo0qa1RTH0Th953g10sMiv25DzjKJJlyODugKzpo3P+e/Y3HBSuTAfe0tLY2O5
 ybArry5iH2StkfiS2TDV5vxJ9W+xPU7VDhUJAni9NXP9cydnIm0MoYNwnaIEVO2fqD6h
 vHGg8bbb560P7t+3AWjkgd3/l7b+WVEeKu5jZtwqAzCHdZXwr/D3pzfDddlKhHD4fSx7
 J1Bj4R8m1KTqrukMuZjdSzKm6dy8zSODm5auljjfOoSMX93MqQJG6rT9qxRXWcDCCVLy oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8d9dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:51 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253Eklk1021044;
        Fri, 3 Jun 2022 15:20:51 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8d9d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:51 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253F6UOR008453;
        Fri, 3 Jun 2022 15:20:50 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3gd4n692n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:50 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253FKnVE40829292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:20:49 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166AEAE05F;
        Fri,  3 Jun 2022 15:20:49 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FE5EAE062;
        Fri,  3 Jun 2022 15:20:48 +0000 (GMT)
Received: from [9.160.55.57] (unknown [9.160.55.57])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:20:48 +0000 (GMT)
Message-ID: <feaceeba-6d8b-513e-2611-267eaf23124a@linux.ibm.com>
Date:   Fri, 3 Jun 2022 11:20:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1 03/18] vfio/ccw: Ensure mdev->dev is cleared on mdev
 remove
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-4-farman@linux.ibm.com>
 <65153af9-be41-8f20-98f1-bc047518c3ae@linux.ibm.com>
 <20220603133713.GZ1343366@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220603133713.GZ1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7dLrkoWFO0irfnnXGp38C4yt1HmOKn3_
X-Proofpoint-GUID: DlUVSFwnmGSxV8H2WkAYy5zl499wjNd3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030067
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/3/22 9:37 AM, Jason Gunthorpe wrote:
> On Fri, Jun 03, 2022 at 09:25:19AM -0400, Matthew Rosato wrote:
>> On 6/2/22 1:19 PM, Eric Farman wrote:
>>> The mdev is linked with the vfio_ccw_private pointer when the mdev
>>> is probed, but it's not cleared once the mdev is removed.
>>>
>>> This isn't much of a concern based on the current device lifecycle,
>>> but fix it so that things make sense in later shuffling.
>>>
>>> Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>    drivers/s390/cio/vfio_ccw_ops.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
>>> index a403d059a4e6..a0a3200b0b04 100644
>>> +++ b/drivers/s390/cio/vfio_ccw_ops.c
>>> @@ -159,6 +159,7 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>>>    			   private->sch->schid.ssid,
>>>    			   private->sch->schid.sch_no);
>>> +	dev_set_drvdata(&mdev->dev, NULL);
>>>    	vfio_unregister_group_dev(&private->vdev);
>>>    	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
>> Seems harmless enough.
>>
>> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>
>> But is this just precautionary or is it fixing a real problem (if the former
>> I don't think a fixes tag makes sense)
>>
>> I also ask because I note vfio-ap clears its driver_data in mdev_remove but
>> also leaves the pointer set, meaning they might need a similar cleanup and
>> should probably have a look (CC Tony & Jason H)
> There should be no reason to clear the drvdata on remove - the driver
> must be designed to guarentee all references to the dev stop before
> the remove function returns.

Each function that gets the driver data
backs a sysfs attribute of the mdev. If the mdev is removed, these
attributes will not exist. The mdev remove callback must get the
same locks acquired by the sysfs attribute functions before clearing
the driver data, so I believe this guarantees that all references to
the dev stop before the remove function returns.

>
> Jason

