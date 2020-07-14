Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A925321EEC2
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGNLKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:10:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9248 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbgGNLKJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:10:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EB2M0i095775;
        Tue, 14 Jul 2020 07:10:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279du4acu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:10:06 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EB2PE9096112;
        Tue, 14 Jul 2020 07:09:59 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279du4a4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:09:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EB7HI2004500;
        Tue, 14 Jul 2020 11:09:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgu62a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:09:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EB9Kmo34340874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 11:09:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1758A4066;
        Tue, 14 Jul 2020 11:09:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F416A405F;
        Tue, 14 Jul 2020 11:09:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.230])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 11:09:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [kvm-unit-tests PATCH v1 0/2] Fix some compilation issues on 32bit
Date:   Tue, 14 Jul 2020 13:09:17 +0200
Message-Id: <20200714110919.50724-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=741
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small patches to fix compilation issues on 32bit:

one for a typo in x86/cstart

one for a thinko in lib/alloc_page

notice that there is another patch for the lib/alloc_page issue floating
around, this patch is an alternative to that one

Claudio Imbrenda (2):
  x86/cstart: Fix compilation issue in 32 bit mode
  lib/alloc_page: Fix compilation issue on 32bit archs

 lib/alloc_page.c | 5 +++--
 x86/cstart.S     | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.26.2

