Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF7F424572
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhJFR6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:58:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42400 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhJFR6l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:58:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196H7KSc010232;
        Wed, 6 Oct 2021 13:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ZBtT1LC8L/Da3I/jhNsn/bYlqusJNaFbMvfCELBu1wU=;
 b=hGnJD2Otfs8G6k3UQCg1NisZYH8rn0tIfsAYa0BHBcAf1tk5rj+MJGjtKtF7ia/UER8V
 fx/OymrW4TgUCgmXpT53Aww0w8Epq+8xgpNZ+iXS2SaXaQQ4eg/30BASulHxF0m/0kjG
 x1XI9SFMWsB8WwEJUa0FDO5d44/ibDbx3ygm3KMkpEVMTrwrg8IikyZQ5mwpsmVMHImJ
 9d1yHYJaQSRAyQbhKlTY+Ucmz84Pm5ZkvSeYmWqonG9KyMuEUluKPkHD4E18OiWfWPK5
 P1TqxJTZ/CbHUVsYtPEkWklK/4FVd9R3S7C6u4CXCvTE0q/aqGHBA3Lzz2szTKuBT6ol tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh38bark5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:56:48 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196HOeDR007271;
        Wed, 6 Oct 2021 13:56:48 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh38barjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:56:48 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196HqBaV002295;
        Wed, 6 Oct 2021 17:56:47 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 3bef2e3v0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 17:56:47 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196HujaA37028250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 17:56:45 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 107C66A054;
        Wed,  6 Oct 2021 17:56:45 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 671486A04D;
        Wed,  6 Oct 2021 17:56:44 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.163.16.42])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 17:56:44 +0000 (GMT)
Message-ID: <6649c066e16bced2786306c401f14113b4699d1f.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] vfio-ccw: step down as maintainer
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 06 Oct 2021 13:56:41 -0400
In-Reply-To: <20211006160120.217636-3-cohuck@redhat.com>
References: <20211006160120.217636-1-cohuck@redhat.com>
         <20211006160120.217636-3-cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sPz3gxhRF_B0qTMTE_tBFjQXj04deH8l
X-Proofpoint-GUID: 89y89X8HeKpizSj-fFGxvu1UWYGfZQpi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=946 mlxscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-06 at 18:01 +0200, Cornelia Huck wrote:
> I currently don't have time to act as vfio-ccw maintainer
> anymore, but I trust that I leave it in capable hands.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

My immense thanks Conny, and with a bittersweet:

Acked-by: Eric Farman <farman@linux.ibm.com>

> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0149e1a3e65e..92db89512678 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16374,7 +16374,6 @@ F:	drivers/s390/crypto/vfio_ap_ops.c
>  F:	drivers/s390/crypto/vfio_ap_private.h
>  
>  S390 VFIO-CCW DRIVER
> -M:	Cornelia Huck <cohuck@redhat.com>
>  M:	Eric Farman <farman@linux.ibm.com>
>  M:	Matthew Rosato <mjrosato@linux.ibm.com>
>  R:	Halil Pasic <pasic@linux.ibm.com>

