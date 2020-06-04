Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC31EE350
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgFDLUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:20:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgFDLUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 07:20:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054B31La176109;
        Thu, 4 Jun 2020 07:20:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31eu6q1c5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:20:52 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054B320S176182;
        Thu, 4 Jun 2020 07:20:52 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31eu6q1c5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:20:52 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054BFJJ4030094;
        Thu, 4 Jun 2020 11:20:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 31bf4840yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 11:20:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054BKldR18678224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 11:20:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 994E55204F;
        Thu,  4 Jun 2020 11:20:47 +0000 (GMT)
Received: from localhost (unknown [9.145.37.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2E01152052;
        Thu,  4 Jun 2020 11:20:47 +0000 (GMT)
Date:   Thu, 4 Jun 2020 13:20:45 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] vfio-ccw: make vfio_ccw_regops variables declarations static
Message-ID: <patch.git-a34be7aede18.your-ad-here.call-01591269421-ext-5655@work.hours>
References: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200603112716.332801-1-cohuck@redhat.com>
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_07:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=837
 bulkscore=0 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 phishscore=0 impostorscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006040076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes the following sparse warnings:
drivers/s390/cio/vfio_ccw_chp.c:62:30: warning: symbol 'vfio_ccw_schib_region_ops' was not declared. Should it be static?
drivers/s390/cio/vfio_ccw_chp.c:117:30: warning: symbol 'vfio_ccw_crw_region_ops' was not declared. Should it be static?

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_chp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index 876f6ade51cc..a646fc81c872 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -59,7 +59,7 @@ static void vfio_ccw_schib_region_release(struct vfio_ccw_private *private,
 
 }
 
-const struct vfio_ccw_regops vfio_ccw_schib_region_ops = {
+static const struct vfio_ccw_regops vfio_ccw_schib_region_ops = {
 	.read = vfio_ccw_schib_region_read,
 	.write = vfio_ccw_schib_region_write,
 	.release = vfio_ccw_schib_region_release,
@@ -131,7 +131,7 @@ static void vfio_ccw_crw_region_release(struct vfio_ccw_private *private,
 
 }
 
-const struct vfio_ccw_regops vfio_ccw_crw_region_ops = {
+static const struct vfio_ccw_regops vfio_ccw_crw_region_ops = {
 	.read = vfio_ccw_crw_region_read,
 	.write = vfio_ccw_crw_region_write,
 	.release = vfio_ccw_crw_region_release,
-- 
2.21.0
