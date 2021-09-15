Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE8340CF24
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 00:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhIOWCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 18:02:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229461AbhIOWCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 18:02:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18FLkXGE003306;
        Wed, 15 Sep 2021 18:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7iRl93veTxWRAyX6LRpljyA5dM+WNqPPZrX1ZQjpDxo=;
 b=dr5NBOWW2BLAQtGuDVVqDzyx2X6SolIHIOI/2XdPrfwF3gpwPW6NI+ybxJc455VnssvD
 QW58y+f9A5kqAbRa3TO/2WEFB+8S/xU9PF9Ew7tMIsAs7kI+Lr/IxdXvjx61OG9FUwx8
 uPiEGdXv+dLs2RNPESd5LqET2Mk66fcWQXAMZaY+A5zPoJjmCOJcQ4T9rOh4fZsRWBj0
 YWPuyR9c6BbNXB2HBmVObDoOOtJNrwur6m5FzpPxcEkhtKieQ03UmU+YSSenYHa3TOgb
 Tq9jU0wUD/wlFdvJ7Yvx5/k0bcJf7a47aoCP8vXi5dTx88SXf1ECAbO5c+ZttmP9diAj uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b3p7nkgyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 18:00:49 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18FLxluZ023762;
        Wed, 15 Sep 2021 18:00:49 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b3p7nkgxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 18:00:48 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18FLcWSX019628;
        Wed, 15 Sep 2021 22:00:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3b0m39sxcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 22:00:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18FLuBlI43123000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 21:56:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1132AE075;
        Wed, 15 Sep 2021 22:00:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFEE3AE073;
        Wed, 15 Sep 2021 22:00:41 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.37.195])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 15 Sep 2021 22:00:41 +0000 (GMT)
Date:   Thu, 16 Sep 2021 00:00:39 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bfu@redhat.com, Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
Message-ID: <20210916000039.7aebfe1a.pasic@linux.ibm.com>
In-Reply-To: <20210915215742.1793314-1-pasic@linux.ibm.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hjQy-GMimYKERMsYSCFa8wkPpfhLKgTA
X-Proofpoint-ORIG-GUID: pE6FKmP0iyw7cx1AdM6mKabhtla7FJn1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/vritio/virtio/
(subject)

[..]

On Wed, 15 Sep 2021 23:57:42 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers") we were supposed to make sure that
> virtio_ccw_release_dev() completes before the ccw device, and the
> attached dma pool are torn down, but unfortunately we did not.
> Before that commit it used to be OK to delay cleaning up the memory
> allocated by virtio-ccw indefinitely (which isn't really intuitive for
> guys used to destruction happens in reverse construction order).
> 

[..]
