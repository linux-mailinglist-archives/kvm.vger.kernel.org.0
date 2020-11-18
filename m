Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63CF2B7D6F
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 13:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKRMNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 07:13:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58520 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgKRMNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 07:13:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AICAGB5010026
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=W7v0tmK1TCLDpLJZ2EE4JMHNPz7sXtOKQcinlqs8uxg=;
 b=0XX3CN6RGdeSBUEupJbfZjPARMdilMGxtlILcFM26B3vgXQH0Cvry9M2dEha8vM/Huqs
 Z0KPDoa4XBnWxpONqRztRoyFRMTvdLAj0swUDXZu72rGkd43BI8TKvKdPsHFFOWTYflT
 jvmfrxmwvA+JmvTr4IDR1AqMdiWe9kmyKbg8Qy/jJ5L273/1IxFWsPzfXVZZ3YfM+HOy
 QyKQSyz937oXHDY6X1xfn9tnib50SSMSs5ysrPY4y7l4T7NvEkVBSfJlBgGCQvEi8hhM
 8CdSiYopRHphozBP6EALQUwwTDIoV0a5v9Vzf9gI/hvV4vcO2RvZJ48tERl3vFm12OYW 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rayv0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:13:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AICAbY4115662
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34ts5xeg5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AICBVxB022588
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:31 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 04:11:31 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 2a888b2a;
        Wed, 18 Nov 2020 12:11:29 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     kvm@vger.kernel.org
Cc:     David Edmondson <david.edmondson@oracle.com>
Subject: [kvm-unit-tests PATCH v2 0/1] x86: test clflushopt of MMIO address
Date:   Wed, 18 Nov 2020 12:11:28 +0000
Message-Id: <20201118121129.6276-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=961
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=992 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel fix was merged in 51b958e5aeb1e18c00332e0b37c5d4e95a3eff84.

v2:
- Use HPET rather than the PCI test device (Nadav Amit).

David Edmondson (1):
  x86: check that clflushopt of an MMIO address succeeds

 x86/Makefile.common   |  3 ++-
 x86/clflushopt_mmio.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg     |  5 +++++
 3 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 x86/clflushopt_mmio.c

-- 
2.29.2

