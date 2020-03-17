Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC33187763
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 02:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733112AbgCQBVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 21:21:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733100AbgCQBVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 21:21:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1Imxc098530;
        Tue, 17 Mar 2020 01:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=cDDq+2csZ2Ig9rWpSfkpLtxHgXmnawO/NWkLoKYH/9c=;
 b=ihoM27JSxuTw4EsvOR2eVU1bVSvnD2ECF+zKHBT7zhW9qMyybn5pWoYjLbhXr2VZW+iA
 dkwVrxKMNzO7wezrKVF9q4PCPv/94IZfzp9mtb5TchjCRXmGLFzrV3NX7q1gqmwwWB5F
 TyJsFB/8Jyq1o5pqy8J5QIBDdeDGBMc6/+a5TJjNzWIIB/gLJdykvtz72CwDceHg/TFt
 uSZ6x10fCRWvZEISFRfi38/8vZKBYfOzxs4xlAs/1idyutpZoyO+0VZhxnhREKHzazSN
 NkhTojPRXKA0JDii7s+0ZRXk2GX5EKxsCMJ6fw/iXDCXB41QDwZ1+ZFBeHrJRWWxca6e SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppr224n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1LEws196466;
        Tue, 17 Mar 2020 01:21:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ys8yx07n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02H1LkwG002071;
        Tue, 17 Mar 2020 01:21:46 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 18:21:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/2] kvm-unit-test: VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS vmentry control field
Date:   Tue, 17 Mar 2020 01:21:34 +0000
Message-Id: <1584408095-16591-2-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=13 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170003
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index 6adf091..beefc2e 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -171,6 +171,7 @@ enum Encoding {
 	GUEST_PAT		= 0x2804ul,
 	GUEST_PERF_GLOBAL_CTRL	= 0x2808ul,
 	GUEST_PDPTE		= 0x280aul,
+	GUEST_BNDCFGS		= 0x2812ul,
 
 	/* 64-Bit Host State */
 	HOST_PAT		= 0x2c00ul,
@@ -373,6 +374,7 @@ enum Ctrl_ent {
 	ENT_LOAD_PERF		= 1UL << 13,
 	ENT_LOAD_PAT		= 1UL << 14,
 	ENT_LOAD_EFER		= 1UL << 15,
+	ENT_LOAD_BNDCFGS	= 1UL << 16
 };
 
 enum Ctrl_pin {
-- 
1.8.3.1

