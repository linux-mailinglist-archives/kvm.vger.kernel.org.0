Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95F6533F62
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiEYOko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 10:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244820AbiEYOkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:40:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519AA986FE;
        Wed, 25 May 2022 07:40:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PDwkuv005307;
        Wed, 25 May 2022 14:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+ly6y3EWbftkMbv2r7OI/2BwAvsGa95a6deEFCesDEo=;
 b=dr+ejCFEI0WepRoE/DE+rlXXqa4ke7MqVT2FdKHESa2ackEIXX6mwyIDEWw8AV+Mjsva
 yTWL0sn2jt4Pfu6dQajEzPLkDRO0xuB7SiUcM4U8AFN6GzfN5H5ZhqZkBylErSn4BTDa
 zesqF9yieSOYUQ8V2R0E8KF2wRUEmDVoYci0FK/T6AmpsV9wUBexk74sqD0uX+waWszr
 MqPA3YWOPS7OmmgX+UK0pfpoa562p5f9OTuAlHGW2vJY8ZHvz2mym23+E3cojs4ahS7v
 ExJD+8f4sVqDdgCCiXgw/V3aNA33vB4pNloTr2Xzdouam/TdTMqJORXTsl9g4U6GhZvz pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ntarx06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:36 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PEYf51031976;
        Wed, 25 May 2022 14:40:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ntarwy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PEWai3006627;
        Wed, 25 May 2022 14:40:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3g93v01ahw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PEeT0C45941176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 14:40:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E094C046;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F96E4C040;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 May 2022 14:40:29 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 59C0BE7919; Wed, 25 May 2022 16:40:29 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH 0/1] Update s390 virtio-ccw
Date:   Wed, 25 May 2022 16:40:27 +0200
Message-Id: <20220525144028.2714489-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HZ-EUsv_YjW6HDAUzyGlKchHoXyOwNsf
X-Proofpoint-ORIG-GUID: 6rMXd1kazjQiO6YCIGHzLNY3OgAsdubF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_04,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=897 spamscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conny, Halil,

As we talked earlier this year about having some more eyeballs on
userspace [1], perhaps it would be wise to do this on the kernel
side of virtio-ccw as well?

[1] QEMU commit 6a6d3dfd6e ("MAINTAINERS: Add myself to s390 I/O areas")

Eric Farman (1):
  MAINTAINERS: Update s390 virtio-ccw

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

-- 
2.32.0

