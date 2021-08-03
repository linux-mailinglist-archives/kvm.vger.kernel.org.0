Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1051F3DE865
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhHCI1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:27:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234517AbhHCI1G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:27:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1738FJln049769;
        Tue, 3 Aug 2021 04:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=SykDvfuDhGiKWrRYA/vYadWCInVTWC5oFhkc3mo436A=;
 b=eFcb5DiIxjS12n3LJvOoAEU3Pag8buz1DiiQbS/CkEJtVGYT3kTOy/7TW1MI46fZm9KG
 aveqUTdLuNzqEbtjv5BQpdmdGjHKrH+5IR3h1Vy+GYfsVinRL3YljeGO22yO2rsGE84V
 y7z575hNsK3XBJK+ySgO0ISZZMD3OrdmeTgmbuV7ZV9CFXo5gOHpLFIsEjX4/ZPZ3xZ5
 J9mm9k+IC7ha+Iu9Cu2kpkRpc32AQoiZclpmhPwHrzatqM86GFV5QZ76NxAGr05eikST
 3hXFNRJQp5giC39+4akbxpK94OpmJijxsEZO4lmLbWER6RU3rO6utNpF2TSFAodBH24M 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a72320bgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:55 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1738FUEY050503;
        Tue, 3 Aug 2021 04:26:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a72320bg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:54 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738HGB3008814;
        Tue, 3 Aug 2021 08:26:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshpp42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:26:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738NsMc56492526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:23:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D40FEA405F;
        Tue,  3 Aug 2021 08:26:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FF8FA406F;
        Tue,  3 Aug 2021 08:26:49 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 08:26:49 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v3 3/3] s390x: optimization of the check for CPU topology change
Date:   Tue,  3 Aug 2021 10:26:46 +0200
Message-Id: <1627979206-32663-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1PYLi39yGSt-JEAcbOEjMNil9JiYrdcm
X-Proofpoint-ORIG-GUID: JAk0DWKu_RPKFoLoRExq4pCpq571bs7C
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-02,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the PTF instruction is interpreted by the SIE we can optimize
the arch_update_cpu_topology callback to check if there is a real need
to update the topology by using the PTF instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/kernel/topology.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 26aa2614ee35..741cb447e78e 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -322,6 +322,9 @@ int arch_update_cpu_topology(void)
 	struct device *dev;
 	int cpu, rc;
 
+	if (!ptf(PTF_CHECK))
+		return 0;
+
 	rc = __arch_update_cpu_topology();
 	on_each_cpu(__arch_update_dedicated_flag, NULL, 0);
 	for_each_online_cpu(cpu) {
-- 
2.25.1

