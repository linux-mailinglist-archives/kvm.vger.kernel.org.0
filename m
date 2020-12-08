Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370EE2D1F2A
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgLHAlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:41:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17238 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728765AbgLHAlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 19:41:16 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B80Xj7T054269;
        Mon, 7 Dec 2020 19:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IC6Kk3gP/OahChiG2pcmMlbtU2G3+ci07xaTOo6Bp0c=;
 b=FZaX7hqreiAdstCNPe9x+Lubh2O7fCNPYJ0IU+Crtk5RudlowxTtquonXElyA03PN2aG
 0exnQUr2HIjmw3IBJtCYNmiSdg3ULR5g6yr5bxqKj8QO6cNaPTCXzEMpAqLfoz3xhKsA
 xZh5oJTk/o6fvOU6UFt/CGivwU3wLzzFGe9xu1VGUEKmNPeva9bfMmyAmRbhN48hAdoB
 JDSE/jaj2bDbIJjwg8R5cAXplShUVN0VdwJ1FbsoLaHA40TUf+V9E64MM1FobHqVuTiV
 mcBX8rBG9VfFbEwA1pP3P9rVJDaMjDuCcp5J/y3WOcghnplKBx4m+uz5MlPFGMh8aA/Y GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359rg8auat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 19:40:33 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B80YZSm056945;
        Mon, 7 Dec 2020 19:40:33 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359rg8aua0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 19:40:32 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B80cKCr023259;
        Tue, 8 Dec 2020 00:40:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u830yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 00:40:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B80eR7q62718282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 00:40:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6447A4054;
        Tue,  8 Dec 2020 00:40:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50343A405B;
        Tue,  8 Dec 2020 00:40:27 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.6.119])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  8 Dec 2020 00:40:27 +0000 (GMT)
Date:   Tue, 8 Dec 2020 01:40:18 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201208014018.3f89527f.pasic@linux.ibm.com>
In-Reply-To: <ab3f1948-bb23-c0d0-7205-f46cd6dbe99d@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <ab3f1948-bb23-c0d0-7205-f46cd6dbe99d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070159
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Dec 2020 14:05:55 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 12/2/20 6:41 PM, Tony Krowiak wrote:
> > The vfio_ap device driver registers a group notifier with VFIO when the
> > file descriptor for a VFIO mediated device for a KVM guest is opened to
> > receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> > event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
> > and calls the kvm_get_kvm() function to increment its reference counter.
> > When the notifier is called to make notification that the KVM pointer has
> > been set to NULL, the driver should clean up any resources associated with
> > the KVM pointer and decrement its reference counter. The current
> > implementation does not take care of this clean up.
> >
> > Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > ---
> >   drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
> >   1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > index e0bde8518745..eeb9c9130756 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
> >   	return NOTIFY_DONE;
> >   }
> >   
> > +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> > +{
> > +	if (matrix_mdev->kvm) {
> > +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> > +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> > +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> 
> This reset probably does not belong here since there is no
> reason to reset the queues in the group notifier (see below).

What about kvm_s390_gisc_unregister()? That needs a valid kvm
pointer, or? Or is it OK to not pair a kvm_s390_gisc_register()
with an kvm_s390_gisc_unregister()?

Regards,
Halil

> The reset should be done in the release callback only regardless
> of whether the KVM pointer exists or not.
> 
> > +		kvm_put_kvm(matrix_mdev->kvm);
> > +		matrix_mdev->kvm = NULL;
> > +	}
> > +}
> > +
> >   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >   				       unsigned long action, void *data)
> >   {
> > @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> >   
> >   	if (!data) {
> > -		matrix_mdev->kvm = NULL;
> > +		vfio_ap_mdev_put_kvm(matrix_mdev);
> >   		return NOTIFY_OK;
> >   	}
> >   
> > @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
> >   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >   
> >   	mutex_lock(&matrix_dev->lock);
> > -	if (matrix_mdev->kvm) {
> > -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> > -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> > -		vfio_ap_mdev_reset_queues(mdev);
> 
> This release should be moved outside of the block and
> performed regardless of whether the KVM pointer exists or
> not.
> 
> > -		kvm_put_kvm(matrix_mdev->kvm);
> > -		matrix_mdev->kvm = NULL;
> > -	}
> > +	vfio_ap_mdev_put_kvm(matrix_mdev);
> >   	mutex_unlock(&matrix_dev->lock);
> >   
> >   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> 

