Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E90C53F06C
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiFFUq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiFFUpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:45:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CB2B0A46;
        Mon,  6 Jun 2022 13:39:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KUtXX038478;
        Mon, 6 Jun 2022 20:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=td1VMGMGm9prnYY2BFNKGCmnqq4ZYbreIcwsQdN4RX8=;
 b=hBEBMJnrPie3R3fNe7QKP40DvCkA3siVFdLLWG6YL6VUJ08qgzA0Pr7dIF6y9GuO0OvE
 HuyWndt34C1MtwsX6nY5ydzhxAGOhFGm3AENWoYebIuH8bhK8u98YlkIOYORiXOPRGCB
 wzCnkE1ONX7LZtk23SjWZhNkmtPNlgjz9yMCALemtDrlnqgALOPlQ9moewEtPSOAOJ8W
 aKXu9Zb8Dss7L8UKg0quItYnz5kmE7YNEFUU8lHqMwplN03+Rr19Q0yFfejz2UiqBTSv
 SBUjbXebBhe2JrR+5I8xxcI5ESRN3kf9yxWR9G3FG88SoirKtJFmceImpC7iT5RztpW1 EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs6152q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:37:38 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KVPqw040433;
        Mon, 6 Jun 2022 20:37:37 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs6152e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:37:37 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KLI5w007267;
        Mon, 6 Jun 2022 20:37:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3gfy1abrua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:37:36 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KbZQi31261020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:37:35 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 317846A047;
        Mon,  6 Jun 2022 20:37:35 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C33D46A04D;
        Mon,  6 Jun 2022 20:37:33 +0000 (GMT)
Received: from [9.163.20.188] (unknown [9.163.20.188])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:37:33 +0000 (GMT)
Message-ID: <14f7d1a0-ebe6-c8b5-827b-4cb6d4c3f1bc@linux.ibm.com>
Date:   Mon, 6 Jun 2022 16:37:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance checking
 to the core
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-15-farman@linux.ibm.com>
 <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
 <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -bq0nodvXUjtZZ_wnNklHY1T1Bq-8VsA
X-Proofpoint-GUID: HykemnhgA4_SAbdofqMswThuHLHtmpMU
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 clxscore=1011 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 4:23 PM, Eric Farman wrote:
> On Tue, 2022-06-07 at 01:32 +0530, Kirti Wankhede wrote:
>>
>> On 6/2/2022 10:49 PM, Eric Farman wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> Many of the mdev drivers use a simple counter for keeping track of
>>> the
>>> available instances. Move this code to the core code and store the
>>> counter
>>> in the mdev_type. Implement it using correct locking, fixing mdpy.
>>>
>>> Drivers provide a get_available() callback to set the number of
>>> available
>>> instances for their mtypes which is fixed at registration time. The
>>> core
>>> provides a standard sysfs attribute to return the
>>> available_instances.
>>>
>>> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>>> Cc: Jonathan Corbet <corbet@lwn.net>
>>> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Cc: Jason Herne <jjherne@linux.ibm.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Link:
>>> https://lore.kernel.org/r/7-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
>>> [farman: added Cc: tags]
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>    .../driver-api/vfio-mediated-device.rst       |  4 +-
>>>    drivers/s390/cio/vfio_ccw_drv.c               |  1 -
>>>    drivers/s390/cio/vfio_ccw_ops.c               | 26 ++++---------
>>>    drivers/s390/cio/vfio_ccw_private.h           |  2 -
>>>    drivers/s390/crypto/vfio_ap_ops.c             | 32 ++++--------
>>> ----
>>>    drivers/s390/crypto/vfio_ap_private.h         |  2 -
>>>    drivers/vfio/mdev/mdev_core.c                 | 11 +++++-
>>>    drivers/vfio/mdev/mdev_private.h              |  2 +
>>>    drivers/vfio/mdev/mdev_sysfs.c                | 37
>>> +++++++++++++++++++
>>>    include/linux/mdev.h                          |  2 +
>>>    samples/vfio-mdev/mdpy.c                      | 22 +++--------
>>>    11 files changed, 76 insertions(+), 65 deletions(-)
>>>
>>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
>>> b/Documentation/driver-api/vfio-mediated-device.rst
>>> index f410a1cd98bb..a4f7f1362fa8 100644
>>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>>> @@ -106,6 +106,7 @@ structure to represent a mediated device's
>>> driver::
>>>    	     int  (*probe)  (struct mdev_device *dev);
>>>    	     void (*remove) (struct mdev_device *dev);
>>>    	     struct device_driver    driver;
>>> +	     unsigned int (*get_available)(struct mdev_type *mtype);
>>>         };
>>>
>>
>> This patch conflicts with Christoph Hellwig's patch. I see
>> 'supported_type_groups' is not is above structure, I beleive that
>> your
>> patch is applied on top of Christoph's patch series.
>>
>> but then in below part of code, 'add_mdev_supported_type' has also
>> being
>> removed in Christoph's patch. So this patch would not get applied
>> cleanly.
> 
> Apologies. This series was fit to 5.18 as the merge window progressed.
> Both this patch and the previous one have to adjust to the removal of
> mdev_parent_ops that came about from
> 
> commit 6b42f491e17ce13f5ff7f2d1f49c73a0f4c47b20
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> Date:   Mon Apr 11 16:14:01 2022 +0200
> 
>      vfio/mdev: Remove mdev_parent_ops
> 
> I have this rebased for v2.
> 
> Eric

Thanks Eric -- FYI, I'm planning to review the entire series but will 
likely hold off until v2 on a number of patches at this point as there 
are a few other collisions with 5.19

