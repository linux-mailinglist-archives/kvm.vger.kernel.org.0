Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9712CDBB2
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgLCRCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:02:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbgLCRCb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:02:31 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Gtbn3193009;
        Thu, 3 Dec 2020 12:01:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TySp0bQWuLG9QgCwNcLob5Bj9l+o4YYRu3QmSA7cedk=;
 b=OszUncRmK3x5kyAdWanmLcP6IXwjw1ISV8h0/DVUDi/hJKZHj9yHgrGdeuZXrkw4x5XT
 ZHLQd03PNAZUJvEyJwZVe4EZ2bSFQO3KTO5sGKVLWD4uF/46pXy7rMDjt7wF8IUNMy6r
 8tW3UR5CvGkj+U6wsyLfYoD2MXug/CsVtjTITKT+6M8UXAgk4Dn9LVG8uRr6PxM16Um0
 uXY2FHwFq+9GOxM6a2b/kiPdzDzIOnVzVcSPZVetgPc/clZhj1tM/tozssT8dMVo9Ifs
 JosvWHqshqoaFFVOuE80MXQPQiuEFmIpL2iiYYyusQTxvLR7oMBHYEyDf6/xRWA9xQBg AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3573yh86y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 12:01:50 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B3GtqpR194398;
        Thu, 3 Dec 2020 12:01:49 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3573yh86uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 12:01:49 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Gq3hr018023;
        Thu, 3 Dec 2020 17:01:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 353e68auc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 17:01:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3H1iPL26477034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 17:01:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10C624C046;
        Thu,  3 Dec 2020 17:01:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E0184C040;
        Thu,  3 Dec 2020 17:01:43 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.64.213])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  3 Dec 2020 17:01:43 +0000 (GMT)
Date:   Thu, 3 Dec 2020 18:01:41 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201203180141.19425931.pasic@linux.ibm.com>
In-Reply-To: <20201203111907.72a89884.cohuck@redhat.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <20201203111907.72a89884.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_09:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=859
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Dec 2020 11:19:07 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> > @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> >  
> >  	if (!data) {
> > -		matrix_mdev->kvm = NULL;
> > +		vfio_ap_mdev_put_kvm(matrix_mdev);  
> 
> Hm. I'm wondering whether you need to hold the maxtrix_dev lock here as
> well?

In v12 we eventually did come along and patch "s390/vfio-ap: allow hot
plug/unplug of AP resources using mdev device" made this a part of a
critical section protected by the matrix_dev->lock.

IMHO the cleanup should definitely happen with the matrix_dev->lock held.

Regards,
Halil
