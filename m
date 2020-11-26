Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF852C5155
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 10:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbgKZJf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 04:35:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730787AbgKZJf4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 04:35:56 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9VISY116782;
        Thu, 26 Nov 2020 04:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FAVxL9P22rSr6aus9kpG2zf2SJCVGfdfDw+5+G1+VV4=;
 b=nmaa2uNAkyleu5vZBN9JnJjV1rzzdtNGiyYGsC3uTwzk+k3QKjpzYoe2J+g7LPQMA1+v
 VrvOPEyauU/pIcJyFuFRdcQ08FR+4M/6WxRvkWurkyp88PNS04+kn2/xVtxBvbt4c/80
 O1P6W/4RS1Nt9IV4g26ymvZ6g1Vu3+rzCU54nX/eHJqv38zTLJIosb7pvVvgzhFPqYZT
 EqWZSPkvLpl61wrGlpzhRT1aUwUmZCHAo2rVEa0FYenrrkOeAZKIVLUp3EVOcGtablbR
 Mjt4zVeS3aOmHTy7zURGhmbHkOqbx5A6X5SrDsbrdXD1jPEEqccJ4KkL8S6/1KqnCOxL uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3529r5r6hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:35:54 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQ9VnwM118750;
        Thu, 26 Nov 2020 04:35:54 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3529r5r6gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:35:53 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9QfeF023280;
        Thu, 26 Nov 2020 09:35:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 34yy8r2qb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 09:35:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ9Zncq60752132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 09:35:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A75B42049;
        Thu, 26 Nov 2020 09:35:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D78042042;
        Thu, 26 Nov 2020 09:35:48 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 09:35:48 +0000 (GMT)
Date:   Thu, 26 Nov 2020 10:35:44 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 01/17] s390/vfio-ap: move probe and remove callbacks
 to vfio_ap_ops.c
Message-ID: <20201126103544.482ddd90.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-2-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_02:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:00 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's move the probe and remove callbacks into the vfio_ap_ops.c
> file to keep all code related to managing queues in a single file. This
> way, all functions related to queue management can be removed from the
> vfio_ap_private.h header file defining the public interfaces for the
> vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
