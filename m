Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB2A4F7A15
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiDGIqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiDGIqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C3181DAB;
        Thu,  7 Apr 2022 01:44:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377LfnV006169;
        Thu, 7 Apr 2022 08:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=veiKVs8HLS/lyF+A1C3zg7djcWIcRUAFxc/w2Hml72s=;
 b=WxgadiInCX8akM5gvCezEqlH/TXsjxRRFOOSERYl5oPmy5deMT13YGgEEa4Ni9Fq7e5v
 5buAX0YH2W8hZOLu9B9C47MMK+FaQ13ztXlzsO4WtZ9y+3F8bQ264xL6e/t/vEqoek7u
 D6wKySvvKPftSeM9Rb7q38wLDHIbAcljCd4QKZWcD288G3850PNDOaI4ns7MQZztGtMX
 PsIvxXoFYs2XuF0ZnZSxSZ2IHMkPy4yfr2GGZnPLDXOh6s0PxejGrsajVcohDc6NfIY6
 GAVSreAVV6W6qZU1ley8OWReIu5aJO9E0znpCS+kgqdSYVd2bzwdfJ9uhk2xa2iqjYh0 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugf9hdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378REGR017618;
        Thu, 7 Apr 2022 08:44:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugf9hcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378Xaxx026077;
        Thu, 7 Apr 2022 08:44:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3f6e48qrw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378WBrC47579590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:32:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BF0FAE055;
        Thu,  7 Apr 2022 08:44:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FFF9AE045;
        Thu,  7 Apr 2022 08:44:28 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/9] s390x: Cleanup and maintenance 4
Date:   Thu,  7 Apr 2022 08:44:12 +0000
Message-Id: <20220407084421.2811-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jFC-YndD9gqAAxJobcMksunOJsxOTX3d
X-Proofpoint-ORIG-GUID: QZwk6FwSsnooH3Ynp0NHvk4kBvC174UK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=944
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few small cleanups and two patches that I forgot to upstream which
have now been rebased onto the machine.h library functions.

v2:
	* Added host_is_qemu() function
	* Fixed qemu checks

Janosch Frank (9):
  lib: s390x: hardware: Add host_is_qemu() function
  s390x: css: Skip if we're not run by qemu
  s390x: diag308: Only test subcode 2 under QEMU
  s390x: pfmf: Initialize pfmf_r1 union on declaration
  s390x: snippets: asm: Add license and copyright headers
  s390x: pv-diags: Cleanup includes
  s390x: css: Cleanup includes
  s390x: iep: Cleanup includes
  s390x: mvpg: Cleanup includes

 lib/s390x/hardware.h                       |  5 +++
 s390x/css.c                                | 18 ++++++----
 s390x/diag308.c                            | 15 ++++++++-
 s390x/iep.c                                |  3 +-
 s390x/mvpg.c                               |  3 --
 s390x/pfmf.c                               | 39 +++++++++++-----------
 s390x/pv-diags.c                           | 17 ++--------
 s390x/snippets/asm/snippet-pv-diag-288.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |  9 +++++
 10 files changed, 80 insertions(+), 47 deletions(-)

-- 
2.32.0

