Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1C281C91
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBUHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:07:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgJBUHM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:07:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K1w3t008793;
        Fri, 2 Oct 2020 16:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=mPRqIry+1htThAWT37oYyw8XVX4dUwbBHMUdDjTjQWY=;
 b=barTABkbKQVwLKpgbh1ZqTiXwNxsMZVUqf0Ui0+N5wxRq2JVn55yKFa4CBGn9NSzDERh
 taPuIUwdtW7aNCeU+gFYFkr1WZS8Ay0rkES69/bzloF132zel7pphWkts7JYRQt2zbaR
 j9QxpY7vtlv0N1ouGl8pzLIUgfkxaR1+AdhjRDqqB8l5V0dudJyLVea1fud9DssCliCH
 HS10lh4sKwg4HAcPh7swtD8rSUvIvYrRhI8Ei6ZmJFFuPV3sK3kPeAJRjg2Hi68ZTEZj
 eoS6aPywmkjsuYXshVvt0XmUsbQu+ufA8b89wWq2Er/3OSW5laUurMjIPEAWWIj1VsJK xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9uasp0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:48 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K2CDU009899;
        Fri, 2 Oct 2020 16:06:48 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9uasp07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:48 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092Jm86p011502;
        Fri, 2 Oct 2020 20:06:47 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 33sw99rab6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:46 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6jWJ57147790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:45 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D581BE053;
        Fri,  2 Oct 2020 20:06:45 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BA40BE04F;
        Fri,  2 Oct 2020 20:06:44 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:44 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 7/9] s390x/pci: clean up s390 PCI groups
Date:   Fri,  2 Oct 2020 16:06:29 -0400
Message-Id: <1601669191-6731-8-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a step to remove all stashed PCI groups to avoid stale data between
machine resets.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index c99f2f0..c34f14a 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -811,6 +811,17 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
                              S390_ADAPTER_SUPPRESSIBLE, errp);
 }
 
+static void s390_pcihost_unrealize(DeviceState *dev)
+{
+    S390PCIGroup *group;
+    S390pciState *s = S390_PCI_HOST_BRIDGE(dev);
+
+    while (!QTAILQ_EMPTY(&s->zpci_groups)) {
+        group = QTAILQ_FIRST(&s->zpci_groups);
+        QTAILQ_REMOVE(&s->zpci_groups, group, link);
+    }
+}
+
 static int s390_pci_msix_init(S390PCIBusDevice *pbdev)
 {
     char *name;
@@ -1165,6 +1176,7 @@ static void s390_pcihost_class_init(ObjectClass *klass, void *data)
 
     dc->reset = s390_pcihost_reset;
     dc->realize = s390_pcihost_realize;
+    dc->unrealize = s390_pcihost_unrealize;
     hc->pre_plug = s390_pcihost_pre_plug;
     hc->plug = s390_pcihost_plug;
     hc->unplug_request = s390_pcihost_unplug_request;
-- 
1.8.3.1

