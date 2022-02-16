Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B264B87B7
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 13:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiBPMcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 07:32:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiBPMcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 07:32:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA17C795;
        Wed, 16 Feb 2022 04:31:55 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GCBIkb021683;
        Wed, 16 Feb 2022 12:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tKoH4E24pTpdzIA7TbOy8d1+jcNh3vgbh76j8txNVCs=;
 b=QvmvkmnwWwUw/HGcl7bAcormBt4Gkde+25H8OvEC123d1LoGofJZhGt26v00nFXjZfhJ
 H24lTfF3/1aiI+hG5V3JvZBm/07/JVjNrU8PeLaRuoQnr8EobBWRn6NAWBxqDrc3Gf6v
 5qH4EEJ4Fl4hiKny0o6sg1rFcEbYUPTx5+IfifTgY5SWNa53niwl48uX6Z42lE+c3kX6
 MVvrqvAwNQtrXahNDeXZShgmR/+oTdsg77NmpUD/SOx29Tr2e66+5LeRGSgIv7ilT3gT
 jKTotQxoQuLV2D9SDNqpX4HeBMSda/uNJBhzvGJ/ZIHZLCTUOEcsu3yysKVlsB13Dc0W nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e908qh899-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:31:54 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GCScI6020214;
        Wed, 16 Feb 2022 12:31:54 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e908qh88k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:31:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GCRteI005782;
        Wed, 16 Feb 2022 12:31:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3e64ha6g1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:31:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GCVnvh38928812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:31:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E63F52054;
        Wed, 16 Feb 2022 12:31:49 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.75.169])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D1ED35204E;
        Wed, 16 Feb 2022 12:31:48 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/1]  s390x: stsi: Define vm_is_kvm to be used in different tests
Date:   Wed, 16 Feb 2022 13:34:01 +0100
Message-Id: <20220216123402.86538-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IZ3me3jpwUEelB5YUENqLOaG-x92om3I
X-Proofpoint-ORIG-GUID: TV0PQVL6tmGdr6g8A_wJpPYtNCX8tS9M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_05,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 mlxlogscore=708 priorityscore=1501 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

In this new version we suppress vm_is_vm to use directly stsi_get_fc().

Regards,
Pierre


Pierre Morel (1):
  s390x: stsi: Define vm_is_kvm to be used in different tests

 lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++
 lib/s390x/vm.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++--
 lib/s390x/vm.h   |  2 ++
 s390x/stsi.c     | 23 ++--------------------
 4 files changed, 85 insertions(+), 23 deletions(-)
 create mode 100644 lib/s390x/stsi.h

-- 
2.27.0

