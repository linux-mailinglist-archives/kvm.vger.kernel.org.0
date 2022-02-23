Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55F4C1029
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiBWKUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiBWKUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:20:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E0F8BF55;
        Wed, 23 Feb 2022 02:20:09 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N7YIQq026124;
        Wed, 23 Feb 2022 10:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=C/YqzREGFV2dxpR9EfxjVdzy7DZE7BzT9HTOz7UG/fk=;
 b=lWVfuGjOnU2MqEyU5kYW5qDR9NRx1ybpzOOxVSUFF3SmQnNUX1+UqeF+MpMWOraPDuub
 9mG82XaysgihnMB6xyfoBf7hUwvnRzfcJBJs0kmdvSiIZOTrc4qn5+3oY1NVVne9t0ig
 dNSC61S2CJEqGmx9h1TnxPZsnN+TrDiHEJ6Cd+SCyaYc3Fj8gPL0I2upJihEejnTR5zY
 gWQc7hBRZsFs53YL2bco2nhhGTQQt0kLITklQgrNed4J8W4ZejwiDxovSg2iSk3o+2Ib
 g3/VxhIJ8BoCq94aQ+o7X2L9ixSun6W5RI3ERJOzSNMc4mAhIKepUn3qFPGVehKa4DYq Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct6y5a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NAD7Wn025330;
        Wed, 23 Feb 2022 10:20:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct6y59m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NABjqV009326;
        Wed, 23 Feb 2022 10:20:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear6990bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NAK3QK53281162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 10:20:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0378A52069;
        Wed, 23 Feb 2022 10:20:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B43D652057;
        Wed, 23 Feb 2022 10:20:02 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com, pasic@linux.ibm.com,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v4 0/2] KVM: s390: make use of ultravisor AIV support
Date:   Wed, 23 Feb 2022 11:19:58 +0100
Message-Id: <20220223102000.3733712-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0vNTTfEy4fptvzLeHn1p0iQax0FLkV06
X-Proofpoint-GUID: GuYXuArfpVpqlQVfgfPEXtQHm9E7KChk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_03,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=402
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables the ultravisor adapter interruption vitualization
support.

Changes in v4:
- All vcpus are pulled out of SIE and disbled before the control
  blocks are changed to disable/enable the gisa and re-enabled
  afterwards instead of taking the vcpu specific lock.

Changes in v3:
- cache and test GISA descriptor only once in kvm_s390_gisa_enable()
- modified some comments
- removed some whitespace issues

Changes in v2:
- moved GISA disable into "put CPUs in PV mode" routine
- moved GISA enable into "pull CPUs out of PV mode" routine 

[1] https://lore.kernel.org/lkml/ae7c65d8-f632-a7f4-926a-50b9660673a1@linux.ibm.com/T/#mcb67699bf458ba7482f6b7529afe589d1dbb5930
[2] https://lore.kernel.org/all/20220208165310.3905815-1-mimu@linux.ibm.com/
[3] https://lore.kernel.org/all/20220209152217.1793281-2-mimu@linux.ibm.com/

Michael Mueller (2):
  KVM: s390: pv: pull all vcpus out of SIE before converting to/from pv
    vcpu
  KVM: s390: pv: make use of ultravisor AIV support

 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kvm/interrupt.c  | 54 +++++++++++++++++++++++++++++++++-----
 arch/s390/kvm/kvm-s390.c   | 19 +++++++++-----
 arch/s390/kvm/kvm-s390.h   | 11 ++++++++
 4 files changed, 72 insertions(+), 13 deletions(-)

-- 
2.32.0

