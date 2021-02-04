Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A9430E872
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhBDAWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:22:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233288AbhBDAWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 19:22:00 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11402wxN073956;
        Wed, 3 Feb 2021 19:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=R7F2Q13BX9BDFgdpcjCNlFEhUcI3W3Z/Tbbys4WkV5M=;
 b=ileOsj+0yYzRvMyumexxlcpoLY+uHdQwxLocMB5egIUXUFBv8hivKSW/hSTPtpSv+82B
 4iS0Q8uabKT2GG+11u4BK8u2mruk1N+qt6xOeu6ZESKGWutxlE7EJtDrPN+eBG+lQA27
 K41i1mT8MJkzc8qdIxPYtnR4+lCkMhDBt33qkEQ10wno9NUQiY/tdO8DY1I/x0rvQ/xz
 s0FNWvuTMYSFODVPL3e5Ht9xP6QaQpZ5A8lL1XgcTVKJHLECeBLdF8Z11gjLUwPlFV1z
 y64FQnkezbGePMhkrDoLwuHH1Dwb14oxeNuh50QEnHpAejdSuQXisSOIqhs8tUXnS2oA UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36g5am1nut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 19:21:17 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11403Ldh076220;
        Wed, 3 Feb 2021 19:21:16 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36g5am1ntn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 19:21:16 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11401rk7002617;
        Thu, 4 Feb 2021 00:21:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 36cy3829du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 00:21:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1140LBlb37552530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Feb 2021 00:21:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2CB1A405C;
        Thu,  4 Feb 2021 00:21:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B863A4060;
        Thu,  4 Feb 2021 00:21:10 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.0.126])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  4 Feb 2021 00:21:10 +0000 (GMT)
Date:   Thu, 4 Feb 2021 01:21:07 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20210204012107.7215cf3b.pasic@linux.ibm.com>
In-Reply-To: <73ad5b17-f252-2aad-1d08-14635c8460ef@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-10-akrowiak@linux.ibm.com>
        <20210112021251.0d989225.pasic@linux.ibm.com>
        <20210112185550.1ac49768.pasic@linux.ibm.com>
        <73ad5b17-f252-2aad-1d08-14635c8460ef@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_09:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Feb 2021 18:13:09 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/12/21 12:55 PM, Halil Pasic wrote:
> > On Tue, 12 Jan 2021 02:12:51 +0100
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >  
> >>> @@ -1347,8 +1437,11 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
> >>>   	apqi = AP_QID_QUEUE(q->apqn);
> >>>   	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> >>>   
> >>> -	if (q->matrix_mdev)
> >>> +	if (q->matrix_mdev) {
> >>> +		matrix_mdev = q->matrix_mdev;
> >>>   		vfio_ap_mdev_unlink_queue(q);
> >>> +		vfio_ap_mdev_refresh_apcb(matrix_mdev);
> >>> +	}
> >>>   
> >>>   	kfree(q);
> >>>   	mutex_unlock(&matrix_dev->lock);  
> > Shouldn't we first remove the queue from the APCB and then
> > reset? Sorry, I missed this one yesterday.  
> 
> I agreed to move the reset, however if the remove callback is
> invoked due to a manual unbind of the queue and the queue is
> in use by a guest, the cleanup of the IRQ resources after the
> reset of the queue will not happen because the link from the
> queue to the matrix mdev was removed. Consequently, I'm going
> to have to change the patch 05/15 to split the vfio_ap_mdev_unlink_queue()
> function into two functions: one to remove the link from the matrix mdev to
> the queue; and, one to remove the link from the queue to the matrix
> mdev. 

Does that mean we should reset before the unlink (or before the second
part of it after the split up)?

I mean have a look at unassign_adapter_store() with all patches
of this series applied. It does an unlink but doesn't do any reset,
or cleanup IRQ resources. And after the unlink we can't clean up
the IRQ resources properly.

But before all this we should resolve this circular lock dependency
problem in a satisfactory way. I'm quite worried about how it is going
to mesh with this series and dynamic ap pass-through.

Regards,
Halil

>Only the first will be used for the remove callback which should
> be fine since the queue object is freed at the end of the remove
> function anyway.
> 
> >
> > Regards,
> > Halil  
> 

