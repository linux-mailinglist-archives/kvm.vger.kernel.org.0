Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241FE2B9730
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgKSP4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 10:56:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729084AbgKSP4U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 10:56:20 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJFrkkk164787;
        Thu, 19 Nov 2020 10:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YvmWBuxco1p78c3rYVm8V9t4vczey/FmgFLnBQuVHBs=;
 b=c2KSbDRCzPFY1LxYwLqRZNlO0VbQRAMI0t+lFckwpvSvTPOkyZhHxceTCifylbSdgsE4
 okHkewhhIIMRswoHr/CNhWODKHR6YHgsOgm+yo75tQlselWIyAHsdsTwLq70reSeli1n
 rEqKMBSiORXZxQoZVukWkDdyXHZrgESUrnkszs2GalHHvvEhlzarmm0sbqZSXHWLxvV2
 7N0fyuQajfhFf/P85UmTrYcX9hWrLTwabT6x8Z/ZmrH8HgwLuh4Mj3MTleJTTLoL7bjZ
 VsQFjN5GB4/yoR/OurVvRP9z7jMy6sUpoW+9bN0HX/A4H7XM8Z6QNlrBDuXoIkvbkY4I cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34wu6x9dnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 10:56:18 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJFrs3d165539;
        Thu, 19 Nov 2020 10:56:17 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34wu6x9dms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 10:56:17 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJFlIMG017958;
        Thu, 19 Nov 2020 15:56:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8d5eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 15:56:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJFuD1a3736286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 15:56:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A0252063;
        Thu, 19 Nov 2020 15:56:13 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.7.71])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id BECA652050;
        Thu, 19 Nov 2020 15:56:12 +0000 (GMT)
Date:   Thu, 19 Nov 2020 16:56:11 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201119165611.6a811d76.pasic@linux.ibm.com>
In-Reply-To: <20201119123026.1353cb3c.cohuck@redhat.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
        <20201117032139.50988-2-farman@linux.ibm.com>
        <20201119123026.1353cb3c.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Nov 2020 12:30:26 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> > +static void vfio_mdev_request(void *device_data, unsigned int count)
> > +{
> > +	struct mdev_device *mdev = device_data;
> > +	struct mdev_parent *parent = mdev->parent;
> > +
> > +	if (unlikely(!parent->ops->request))  
> 
> Hm. Do you think that all drivers should implement a ->request()
> callback?

@Tony: What do you think, does vfio_ap need something like this?

BTW how is this supposed to work in a setup where the one parent
has may children (like vfio_ap or the gpu slice and dice usecases).

After giving this some thought I'm under the impression, I don't
get the full picture yet.

Regards,
Halil
