Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C059518E00
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfEIQ1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 12:27:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfEIQ1J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 12:27:09 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49GO59g062615
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 12:27:08 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scq0ssxjf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 12:27:07 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 9 May 2019 17:27:05 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 17:27:02 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49GR0CL34930696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 16:27:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 847CC42047;
        Thu,  9 May 2019 16:27:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB53542042;
        Thu,  9 May 2019 16:26:59 +0000 (GMT)
Received: from [9.145.47.201] (unknown [9.145.47.201])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 16:26:59 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
To:     Cornelia Huck <cohuck@redhat.com>,
        Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20190430224937.57156-1-parav@mellanox.com>
 <20190430224937.57156-9-parav@mellanox.com>
 <20190508190957.673dd948.cohuck@redhat.com>
 <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190509110600.5354463c.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 9 May 2019 18:26:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509110600.5354463c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050916-0008-0000-0000-000002E4FA37
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050916-0009-0000-0000-0000225181AA
Message-Id: <eb34e9a3-32a3-98fe-e871-7d541d620b6e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/2019 11:06, Cornelia Huck wrote:
> [vfio-ap folks: find a question regarding removal further down]
> 
> On Wed, 8 May 2019 22:06:48 +0000
> Parav Pandit <parav@mellanox.com> wrote:
> 
>>> -----Original Message-----
>>> From: Cornelia Huck <cohuck@redhat.com>
>>> Sent: Wednesday, May 8, 2019 12:10 PM
>>> To: Parav Pandit <parav@mellanox.com>
>>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
>>> Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
>>> sequence
>>>
>>> On Tue, 30 Apr 2019 17:49:35 -0500
>>> Parav Pandit <parav@mellanox.com> wrote:
>>>    

...snip...

>>>> @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev,
>>> bool force_remove)
>>>>   	mutex_unlock(&mdev_list_lock);
>>>>
>>>>   	type = to_mdev_type(mdev->type_kobj);
>>>> +	mdev_remove_sysfs_files(dev, type);
>>>> +	device_del(&mdev->dev);
>>>>   	parent = mdev->parent;
>>>> +	ret = parent->ops->remove(mdev);
>>>> +	if (ret)
>>>> +		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
>>>
>>> I think carrying on with removal regardless of the return code of the
>>> ->remove callback makes sense, as it simply matches usual practice.
>>> However, are we sure that every vendor driver works well with that? I think
>>> it should, as removal from bus unregistration (vs. from the sysfs
>>> file) was always something it could not veto, but have you looked at the
>>> individual drivers?
>>>    
>> I looked at following drivers a little while back.
>> Looked again now.
>>
>> drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in intel_vgpu_release(), which should finish first before remove() is invoked.
>>
>> s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c remove() always returns 0.
>> s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm null, which should finish before remove() is invoked.
> 
> That one is giving me a bit of a headache (the ->kvm reference is
> supposed to keep us from detaching while a vm is running), so let's cc:
> the vfio-ap maintainers to see whether they have any concerns.
> 

We are aware of this race and we did correct this in the IRQ patches for 
which it would have become a real issue.
We now increment/decrement the KVM reference counter inside open and 
release.
Should be right after this.

Thanks for the cc,
Pierre


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

