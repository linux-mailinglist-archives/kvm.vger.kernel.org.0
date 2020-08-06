Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E2223DE35
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgHFRXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:23:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729955AbgHFRE5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 13:04:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076E4BLq037516;
        Thu, 6 Aug 2020 10:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=kmhmWCdm048zOKwXHN42FLNuOm7WrXWJMfUPgkm2BNs=;
 b=XogXsXMRXlfm/JAY1LPooBLT63IRYCp8ojV2ctAf3lkvx5Vw9iebfbHieezthAQNC8c0
 /b1g87Yz1d4zB3k1WmuW66G9PU53U8W4EKMQAt7AIgCI/psb/OtVEE/vgSFef0buG0Z7
 JYYwr4i98hQQjP4LOaXvML4fgtZAkymKXVkOEnyDvVVF2gFiGNfUIeZK/XEjsOlO4vj2
 JabFvOzanHZCzsGRQ9PzVHJrSjmUeuJaEAN0xISsn+fffwArKOrYc5vb2gWSAF6EBLid
 tAJK30i6TKzf/UYtYNXDr7tiutyamSPYWlkM7VKb4hqRKBliSIvFSDVr+n1qfByVXcpS JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32rgnf5y0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 10:23:10 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 076E4iXH040969;
        Thu, 6 Aug 2020 10:23:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32rgnf5xyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 10:23:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 076EF6Jl029907;
        Thu, 6 Aug 2020 14:23:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 32n0185j5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 14:23:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 076EN48J16253204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Aug 2020 14:23:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAB55AE059;
        Thu,  6 Aug 2020 14:23:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 541CFAE04D;
        Thu,  6 Aug 2020 14:23:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Aug 2020 14:23:04 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v1 0/1] s390: virtio-ccw: PV needs VIRTIO I/O device protection
Date:   Thu,  6 Aug 2020 16:23:01 +0200
Message-Id: <1596723782-12798-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_09:2020-08-06,2020-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=1 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

In another series I proposed to add an architecture specific
callback to fail feature negociation on architecture need.

In VIRTIO, we already have an entry to reject the features on the
transport basis.

Transport is not architecture so I send a separate series in which
we fail the feature negociation inside virtio_ccw_finalize_features,
the virtio_config_ops.finalize_features for S390 CCW transport,
when the device do not propose the VIRTIO_F_IOMMU_PLATFORM.

This solves the problem of crashing QEMU when this one is not using
a CCW device with iommu_platform=on in S390.

Regards,
Pierre

Regards,
Pierre

Pierre Morel (1):
  s390: virtio-ccw: PV needs VIRTIO I/O device protection

 drivers/s390/virtio/virtio_ccw.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.25.1

