Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659023EA414
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhHLLxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 07:53:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44796 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235563AbhHLLxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 07:53:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CBY0m9004973
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=a1rTc/WJyEhL2olKC+PGOKofKeLuc6hEZ3BpYb+GsIk=;
 b=jlz7oWeKK+1+zOEH9MJBKsWGL6CxFmFz977dxb5JP4kiJs16LkgqQIcaNq/kgoDWxZ47
 UHs+0IqjtxZ3Ui3lD8G9PnyCZTGF1b9Zp8V/imtE98OOxX+jySLJrowau8hfcXheuArm
 m0DBDfrTfDzWgckwWLGmSTr+GblrYP2+MLZygM4R2qMENACeUmFICd3JYBYjOHh35QhY
 8fBP1ga4/tO9ccbmVt6dG9ulrAykMT4bNYtCcfxP0+Ihpb8Q/gWae1/pCL5x0hmVBmvX
 wiMpMQeHaZo1f0wg9wd1upkvl+/lzFLNd9vYhczxIiPLnFpOMPnc9i0gtAdICcAsemK6 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abt98nhmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:16 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17CBYPfo006538
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abt98nhmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 07:53:16 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CBllAB031034;
        Thu, 12 Aug 2021 11:53:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8rjuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:53:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CBnvRQ21168414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 11:49:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29FAD4C074;
        Thu, 12 Aug 2021 11:53:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD5114C076;
        Thu, 12 Aug 2021 11:53:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 11:53:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/1] s390x: css: check the CSS is working with any ISC
Date:   Thu, 12 Aug 2021 13:53:08 +0200
Message-Id: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LL44ada8zq5IzUHNZDWVbZIk5t_kgBSl
X-Proofpoint-GUID: mQKFxD_bpFbJ8M6NN_4trRdgCSAVGLoq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_04:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=755 malwarescore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Picking the ISC used by Linux for I/O to make the CSS checks may cause
a bias.

Let's check all possible ISC for I/O to verify that QEMU/KVM is really ISC
independent.


Pierre Morel (1):
  s390x: css: check the CSS is working with any ISC

 s390x/css.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

-- 
2.25.1

