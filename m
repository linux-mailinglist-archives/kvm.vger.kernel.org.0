Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA62B194E0
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfEIVrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:47:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34870 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfEIVrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:47:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LiQpf179132;
        Thu, 9 May 2019 21:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=TZBt4pA7NKxXTWaITFJcnks62kgz7q+5yunnkc9Z6qU=;
 b=VPLibSP8J9BPeRVtDfyyig1qQ/CNbefew03fAEkiKOsCkfS3qSH6Ad1vxaZja0SB/wER
 AAHmylYeS+SckcEtEUKbpkIvJC5pZhB4wEw2c7M2wDt+XpdxEw4QK7HvudgsJ/gF7D0B
 rVN+QVwRM32ovVxhsFTH2FkNMDKSKC7utU/+/zZig5XcYa35f0e5LNDDw6JSGfQynsOQ
 T8Wz7B4bCwCsFsa2AF8PzfmYRBDXi29l/pSQpnSiODnxEII8PPxhJq2dWX9gxJw1at/6
 h1U27aaZEeg5+lHVG/uR3N9kYNcT6HMAfO0a87Mg035DzTBOcree0wTp9eDwSkVgk1j0 Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2s94b6dpv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49Lk7oh152467;
        Thu, 9 May 2019 21:46:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sagyvgagt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:58 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49LkwZf012695;
        Thu, 9 May 2019 21:46:58 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 14:46:57 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/4][kvm-unit-test nVMX]: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
Date:   Thu,  9 May 2019 17:20:54 -0400
Message-Id: <20190509212055.29933-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
References: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index eefd5dc..a4ceac3 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -370,6 +370,7 @@ enum Ctrl_exi {
 enum Ctrl_ent {
 	ENT_LOAD_DBGCTLS	= 1UL << 2,
 	ENT_GUEST_64		= 1UL << 9,
+	ENT_LOAD_PERF		= 1UL << 13,
 	ENT_LOAD_PAT		= 1UL << 14,
 	ENT_LOAD_EFER		= 1UL << 15,
 };
-- 
2.20.1

