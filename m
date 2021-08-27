Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC7E3F9842
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245000AbhH0Kv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:51:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244774AbhH0Kvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:51:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RAYOhM020243;
        Fri, 27 Aug 2021 06:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=paw2ZvP54Nyg1HvWtofMtUjyz2hooMz2gTQIsa10VVA=;
 b=KH13OAipVp2ZzFGfKlncYxunnZfyyhuw7ndYEPfQ6h5zmLMlv8icJwzKnOIDhI0Jcvrm
 lTXC/b9/DqGKeGkFoXrwkovzfsbmFGI3CeFKLgeCLMMOTxGBLE+ORJFM1h97j9vyiWJY
 gWU68LCtwft6LGZFePSFYd/SKlqrz0Hc5asWUijmucXMitapwt0uHo4iSKmKbo65T5N1
 XZBgHdb7UKUQcrfMLZk668Y961GJ4AD2pGHG8qbW87qbq55CRKxMZEcj0a/7l4Lxt6JJ
 tfnX02i/iI8q47vRoyjoLl/Z88GE339f8QeKxp5PThopZ549M8jIAoxJrugRvR+RG9iM NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apwhtswn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:50:58 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RAYcut021452;
        Fri, 27 Aug 2021 06:50:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apwhtswmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:50:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAlpeH000746;
        Fri, 27 Aug 2021 10:50:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3ajs48kbmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:50:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAoq1f56951164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:50:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37F9111C052;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE44F11C08A;
        Fri, 27 Aug 2021 10:50:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:50:51 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        richard.henderson@linaro.org, mst@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 0/2] s390x: ccw: A simple test device for virtio CCW
Date:   Fri, 27 Aug 2021 12:50:48 +0200
Message-Id: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LLbsC-2Yo4K4ePH_Ofj_SY_9JkTA3oSF
X-Proofpoint-GUID: 4eqRFCTTYLdXaDyq297R63rlzmLMMwsN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=896 adultscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello All,


This series presents a VIRTIO test device which receives data on its
input channel and sends back a simple checksum for the data it received
on its output channel.
 
The goal is to allow a simple VIRTIO device driver to check the VIRTIO
initialization and various data transfer.

For this I introduced a new device ID for the device and having no
Linux driver but a kvm-unit-test driver, I have the following
questions:

Is there another way to advertise new VIRTIO IDs but Linux?
If this QEMU test meet interest, should I write a Linux test program?

Regards,
Pierre


Pierre Morel (2):
  virtio: Linux: Update of virtio_ids
  s390x: ccw: A simple test device for virtio CCW

 hw/s390x/meson.build                        |   1 +
 hw/s390x/virtio-ccw-pong.c                  |  66 ++++++++
 hw/s390x/virtio-ccw.h                       |  13 ++
 hw/virtio/Kconfig                           |   5 +
 hw/virtio/meson.build                       |   1 +
 hw/virtio/virtio-pong.c                     | 161 ++++++++++++++++++++
 include/hw/virtio/virtio-pong.h             |  34 +++++
 include/standard-headers/linux/virtio_ids.h |   1 +
 8 files changed, 282 insertions(+)
 create mode 100644 hw/s390x/virtio-ccw-pong.c
 create mode 100644 hw/virtio/virtio-pong.c
 create mode 100644 include/hw/virtio/virtio-pong.h

-- 
2.25.1

