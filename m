Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECC01C4A12
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEDXQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:16:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEDXQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:16:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDvte092880;
        Mon, 4 May 2020 23:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=xix1JS17waCW46hIEzQZ34HR8LQPsHrXQ24phEqFE5M=;
 b=Lm8bPKG958bZjSFxl9sMzmge6VoSEYeaF2cd45ttC14I/K6OpAUR9NxnBMJKvEHubeVe
 MFuosmK0sthUo4gMiV/fTGMtBKcAoFhSFWqz5THXhqgsGarT6VS1K3RjBvD0RzFn+UMO
 8TH7yIMMBojS98UVZhBbSK5k7Nu0JeIQimMcKz6wgIhxPT1pYGIOVqieFyeHzA8wRui1
 w0YDt4BdUykkuWyvN0zIJc9mp9ocpqNqSPedW+B3iXvOzRu/ZgDeoPOMSsFgLsugwy2j
 JQJGcvkjgUy+/nOoeN9sMv8P6PnMObbAEpfMThSEbbWlTJZhJLACQQxDchvortvBYJdx FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1mnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NGg7M082589;
        Mon, 4 May 2020 23:16:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrp2jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044NGgDn031007;
        Mon, 4 May 2020 23:16:42 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:16:42 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun of nested guests
Date:   Mon,  4 May 2020 18:35:21 -0400
Message-Id: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=565 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=625
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Adds the required KVM check.
Patch# 2: Adds the kvm-unit-test.

[PATCH 1/2] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun
[PATCH 2/2] kvm-unit-tests: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun

 arch/x86/kvm/svm/nested.c | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h    |  7 ++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested gu
 x86/svm.h       |   6 ++++
 x86/svm_tests.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 99 insertions(+), 12 deletions(-)

Krish Sadhukhan (1):
      nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested gue

