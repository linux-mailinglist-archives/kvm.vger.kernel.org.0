Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9E2F2E5
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 11:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfD3J3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 05:29:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbfD3J3b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 05:29:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3U9RrVm098960
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 05:29:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6hj3dyt2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 05:29:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 30 Apr 2019 10:29:27 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 10:29:25 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3U9TOWF54460628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 09:29:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A0A64C040;
        Tue, 30 Apr 2019 09:29:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ABC54C046;
        Tue, 30 Apr 2019 09:29:23 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.116])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Apr 2019 09:29:23 +0000 (GMT)
Date:   Tue, 30 Apr 2019 11:29:22 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v7 2/4] vfio: ap: register IOMMU VFIO notifier
In-Reply-To: <b1577203-78c7-24f3-9357-42159feb08ae@linux.ibm.com>
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
        <1556283688-556-3-git-send-email-pmorel@linux.ibm.com>
        <20190429180702.641c9110.pasic@linux.ibm.com>
        <b1577203-78c7-24f3-9357-42159feb08ae@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19043009-0028-0000-0000-00000368CAF3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043009-0029-0000-0000-000024282F4E
Message-Id: <20190430112922.0b0b90c5.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=803 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 09:59:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 29/04/2019 18:07, Halil Pasic wrote:
> > On Fri, 26 Apr 2019 15:01:26 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> > 
> >> @@ -858,7 +887,17 @@ static int vfio_ap_mdev_open(struct mdev_device *mdev)
> >>   		return ret;
> >>   	}
> >>   
> >> -	return 0;
> >> +	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
> >> +	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> >> +	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> >> +				     &events, &matrix_mdev->iommu_notifier);
> >> +	if (!ret)
> >> +		return ret;
> >> +
> >> +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> >> +				 &matrix_mdev->group_notifier);
> >> +	module_put(THIS_MODULE);
> > 
> > Can you please explain this module_put() here? I don't see anything in
> > the cover letter.
> 
> May be you should have a look at the sources or the original patch 
> series of Tony, there is a try_module_get() at the beginning of open to 
> make sure that the module is not taken away while in use by the guest.
> 
> In the case we failed to open the mediated device we let fall the reference.
> 

Right, my bad. I did not notice we were on the error recovery path.

Regards,
Halil

