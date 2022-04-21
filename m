Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38A6509D40
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388120AbiDUKQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388153AbiDUKQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1F0C27;
        Thu, 21 Apr 2022 03:13:33 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9ZVw5002649;
        Thu, 21 Apr 2022 10:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=EU2XgCQfd2UYLsyU7gZxSwFse6opEUDtqv9UEaoNBEc=;
 b=DLc0Fs5pJzFEurBWlqBJjDfxwwVzQ0gl4Zp5gApzLpw5+buwfp9tfI8W47rEw5Nrc8oA
 RgOeMIG9ZVgAiDal9/3scfGHz7GaPPQcUXVklD1fnbn+BeQ6t8jow2lTXD50bFgAwe4J
 d2grrqm9w2rbfxG78Xp21yl97eDhasJXhqFgnKfqM+iUYPq5YtvbahJEpRoW2xHq4q4E
 s2KaXp1U/rBCPcrrnxOs9MjN6l5oOXoE/E9bVg2Tj4jEiPtgPbNuMxzovurLWwNK9gZ9
 aMXDLCGWFFchA/m3RJfrBm0fnIKJumPPFiXxjIiMnuRcUrRDlghh8xOOoRZVha+Iiq6V ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhxh90a5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LA6JcJ028941;
        Thu, 21 Apr 2022 10:13:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhxh90a4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LA3MKK026794;
        Thu, 21 Apr 2022 10:13:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8x2vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LADQAr44368194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:13:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41728AE04D;
        Thu, 21 Apr 2022 10:13:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7ECAAAE045;
        Thu, 21 Apr 2022 10:13:25 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 00/11] s390x: Cleanup and maintenance 4
Date:   Thu, 21 Apr 2022 10:11:19 +0000
Message-Id: <20220421101130.23107-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T3RcI7zI4g6pt6AlmwP3RAN3uFPXRw-a
X-Proofpoint-GUID: j-yvrDbZu9sYFO-PdzKCNbjF6A065rcv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=942
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few small cleanups and two patches that I forgot to upstream which
have now been rebased onto the machine.h library functions.

v3:
	* Added review tags
	* Added uv-host and diag308 fix
	* Diag308 subcode 2 patch, moved the prefix push and pop outside of the if

v2:
	* Added host_is_qemu() function
	* Fixed qemu checks

Janosch Frank (11):
  lib: s390x: hardware: Add host_is_qemu() function
  s390x: css: Skip if we're not run by qemu
  s390x: diag308: Only test subcode 2 under QEMU
  s390x: pfmf: Initialize pfmf_r1 union on declaration
  s390x: snippets: asm: Add license and copyright headers
  s390x: pv-diags: Cleanup includes
  s390x: css: Cleanup includes
  s390x: iep: Cleanup includes
  s390x: mvpg: Cleanup includes
  s390x: uv-host: Fix pgm tests
  s390x: Restore registers in diag308_load_reset() error path

 lib/s390x/hardware.h                       |  5 +++
 s390x/cpu.S                                |  1 +
 s390x/css.c                                | 18 ++++++----
 s390x/diag308.c                            | 18 +++++++++-
 s390x/iep.c                                |  3 +-
 s390x/mvpg.c                               |  3 --
 s390x/pfmf.c                               | 39 +++++++++++-----------
 s390x/pv-diags.c                           | 17 ++--------
 s390x/snippets/asm/snippet-pv-diag-288.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |  9 +++++
 s390x/uv-host.c                            |  2 +-
 12 files changed, 85 insertions(+), 48 deletions(-)

-- 
2.32.0

