Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8964827F525
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 00:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgI3W3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 18:29:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbgI3W3k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 18:29:40 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UM2Dse065892;
        Wed, 30 Sep 2020 18:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bqnKSnYGkMCTbMLLZkuOCFSYLg7Fmfo08VtiyWQBCJY=;
 b=tus6AHdOze2k/FZcRkIhwA8epIJYOL//4BpfUwO49ALKs672nn5a2t6SitBCUye85DXF
 XNqu4Oi+8lLZdTAoXMDlzC37cS9M8TwpM8fL5KmlAU/tv9ZxwTtBsU7uAtH79Rgfo4Nq
 yTg0iwUOC4Ib0lTehGtyDh7Quc2AKvSK7ekFPyWl889T4wyNlughAKRaKaEeVy71aopo
 ZIHWTnW9s1GFXfJ+T5alL37BW+9rZJp0gO/K5q8YGuUSJJR2MtCE5jjtyArRE7pbZvUn
 BLiwg8htBmPdn4PBMlfXG0U0I7q3wt2qY+PYKZV8UeCXPKWadP93Y8Ecp8OFIRwjza4N IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33w2618ycp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 18:29:39 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08UMMslD009593;
        Wed, 30 Sep 2020 18:29:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33w2618ybs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 18:29:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08UMROl7013228;
        Wed, 30 Sep 2020 22:29:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw984utx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 22:29:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08UMTXhU14549402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 22:29:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9ABFAE045;
        Wed, 30 Sep 2020 22:29:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F4118AE04D;
        Wed, 30 Sep 2020 22:29:32 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.63.21])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Sep 2020 22:29:32 +0000 (GMT)
Date:   Thu, 1 Oct 2020 00:29:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 09/16] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20201001002930.26185810.pasic@linux.ibm.com>
In-Reply-To: <76600ed5-60cc-c530-56db-43f7026d8c8e@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-10-akrowiak@linux.ibm.com>
        <20200927014902.1a1a0d8c.pasic@linux.ibm.com>
        <76600ed5-60cc-c530-56db-43f7026d8c8e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Sep 2020 08:59:36 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> @@ -572,6 +455,11 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
> >>   	DECLARE_BITMAP(aqm, AP_DOMAINS);
> >>   
> >>   	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> >> +		/*
> >> +		 * If either of the input masks belongs to the mdev to which an
> >> +		 * AP resource is being assigned, then we don't need to verify
> >> +		 * that mdev's masks.
> >> +		 */
> >>   		if (matrix_mdev == lstdev)
> >>   			continue;
> >>     
> > Seems unrelated.  
> 
> What seems unrelated? The matrix_mdev passed in is the mdev to which 
> assignment is
> being made. This function is verifying that no APQN assigned to the 
> matrix_mdev is
> assigned to any other mdev. Since we are looping through all mdevs here, 
> we are
> skipping the verification if the current mdev being examined is the same 
> as the matrix_mdev
> to which the assignment is being made. Maybe I'm not understanding your 
> point here.

Sorry I did not explain myself clear enough. By seems unrelated, I mean
that while valid possibly it does not contribute towards achieving the
objective of the patch (as stated by the commit message and the short
description).

AFAICT this is about documenting some pre-existing logic that is not
changed, nor it needs to be changed to achieve the objective.

This patch does not change the function at all (except for the
comment). If the comment is about the new arguments, then is
belongs to "implement in-use callback for vfio_ap driver" where those
were added.

BTW I find the comment hard to understand because I don't see "If either
of the input masks belongs to the mdev to which an  AP resource is being
assigned expressed in the code.

I would rather have the docstring of the function updated so the
relationship of the three arguments is clear.

Regards,
Halil
