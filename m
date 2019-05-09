Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D911950C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 00:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfEIWMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 18:12:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726795AbfEIWMW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 18:12:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49MCKCB114958
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 18:12:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scv5x17pk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 18:12:21 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 9 May 2019 23:12:18 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 23:12:16 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49MCFFK61145188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 22:12:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30B3FA4054;
        Thu,  9 May 2019 22:12:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1BB9A405B;
        Thu,  9 May 2019 22:12:14 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.181.188])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 22:12:14 +0000 (GMT)
Date:   Fri, 10 May 2019 00:12:12 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
In-Reply-To: <eb34e9a3-32a3-98fe-e871-7d541d620b6e@linux.ibm.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-9-parav@mellanox.com>
        <20190508190957.673dd948.cohuck@redhat.com>
        <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190509110600.5354463c.cohuck@redhat.com>
        <eb34e9a3-32a3-98fe-e871-7d541d620b6e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050922-0016-0000-0000-0000027A1961
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050922-0017-0000-0000-000032D6D0DD
Message-Id: <20190510001212.3e2bf5ea.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 18:26:59 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 09/05/2019 11:06, Cornelia Huck wrote:
> > [vfio-ap folks: find a question regarding removal further down]
> > 
> > On Wed, 8 May 2019 22:06:48 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> > 
> >>> -----Original Message-----
> >>> From: Cornelia Huck <cohuck@redhat.com>
> >>> Sent: Wednesday, May 8, 2019 12:10 PM
> >>> To: Parav Pandit <parav@mellanox.com>
> >>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> >>> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> >>> Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> >>> sequence
> >>>
> >>> On Tue, 30 Apr 2019 17:49:35 -0500
> >>> Parav Pandit <parav@mellanox.com> wrote:
> >>>    
> 
> ...snip...
> 
> >>>> @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev,
> >>> bool force_remove)
> >>>>   	mutex_unlock(&mdev_list_lock);
> >>>>
> >>>>   	type = to_mdev_type(mdev->type_kobj);
> >>>> +	mdev_remove_sysfs_files(dev, type);
> >>>> +	device_del(&mdev->dev);
> >>>>   	parent = mdev->parent;
> >>>> +	ret = parent->ops->remove(mdev);
> >>>> +	if (ret)
> >>>> +		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> >>>
> >>> I think carrying on with removal regardless of the return code of the
> >>> ->remove callback makes sense, as it simply matches usual practice.
> >>> However, are we sure that every vendor driver works well with that? I think
> >>> it should, as removal from bus unregistration (vs. from the sysfs
> >>> file) was always something it could not veto, but have you looked at the
> >>> individual drivers?
> >>>    
> >> I looked at following drivers a little while back.
> >> Looked again now.
> >>
> >> drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in intel_vgpu_release(), which should finish first before remove() is invoked.
> >>
> >> s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c remove() always returns 0.
> >> s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm null, which should finish before remove() is invoked.
> > 
> > That one is giving me a bit of a headache (the ->kvm reference is
> > supposed to keep us from detaching while a vm is running), so let's cc:
> > the vfio-ap maintainers to see whether they have any concerns.
> > 
> 
> We are aware of this race and we did correct this in the IRQ patches for 
> which it would have become a real issue.
> We now increment/decrement the KVM reference counter inside open and 
> release.
> Should be right after this.
> 

Tony, what is your take on this? I don't have the bandwidth to think
this through properly, but my intuition tells me: this might be more
complicated than what Pierre's response suggests.

Regards,
Halil 

