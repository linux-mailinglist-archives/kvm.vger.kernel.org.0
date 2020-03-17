Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9824B188DCF
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgCQTPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:15:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQTPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:15:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJCiTx020725;
        Tue, 17 Mar 2020 19:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fSfXYgyHzEMx9gbiq8n7yU8fgmIGczt0UqMQJeziZa0=;
 b=K+Rb/qVdu/sg4M703EQOoiXk0oECmtfQ3nOUcj+iaBM4ZExa8gzEVctANF32O1+qL6KR
 axpOTwKmfyH4ZacBPFfhX9Vk45J81gzTIoNVS9zym2oQsn8GxXMaVMVLPF4WFBS62A2q
 N+1F0O2WVjNKCJscT2uWmzcmlxcyawC7zQYMx3YokxFEXNOazLcSurnCj1oVB5ySYoz2
 bA2NutBxvANf3Q/NSrUpkd7YHoMTjtF3iWRsnNyLO480D/kd9nE9apyoPj5pxCbbHohh
 lPLqAI3EQZ6uicznapDFS+1O0REm48a2aDcZ5+xljMFXZUPs/2IQ3FyrFXGa3kBe9k8S dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7kxt8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJCvjB022088;
        Tue, 17 Mar 2020 19:15:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ys8tscwgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HJFjgb025935;
        Tue, 17 Mar 2020 19:15:46 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 12:15:45 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/2 v2] kvm-unit-test: VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS vmentry control field
Date:   Tue, 17 Mar 2020 19:15:29 +0000
Message-Id: <1584472530-31728-2-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=13 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=13
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index e6ee776..2e28ecb 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -198,6 +198,7 @@ enum Encoding {
 	GUEST_PAT		= 0x2804ul,
 	GUEST_PERF_GLOBAL_CTRL	= 0x2808ul,
 	GUEST_PDPTE		= 0x280aul,
+	GUEST_BNDCFGS		= 0x2812ul,
 
 	/* 64-Bit Host State */
 	HOST_PAT		= 0x2c00ul,
@@ -400,6 +401,7 @@ enum Ctrl_ent {
 	ENT_LOAD_PERF		= 1UL << 13,
 	ENT_LOAD_PAT		= 1UL << 14,
 	ENT_LOAD_EFER		= 1UL << 15,
+	ENT_LOAD_BNDCFGS	= 1UL << 16
 };
 
 enum Ctrl_pin {
-- 
1.8.3.1

