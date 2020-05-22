Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ACF1DF2AC
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 01:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgEVXEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 19:04:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgEVXEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 19:04:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvx3D177773;
        Fri, 22 May 2020 23:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OacTk3r9hmxNzNfmRFSATxh7r2LDYUwIyj2RDQYLVlg=;
 b=k/opxC14IPIfKy4odBnX6mVMUg3CuKe+kpUOo8gg/2+tqlBHAwfQUi0pU7mj1+P9/LYp
 k1EqfEhR2ZZNcWckaCywf88qP1OpjLnwtnAiNIJwpHlA1zSyDy8Cz/8gMItxCcvCNfhy
 ppUQJXQeP8Zvl+Iwe78Mdxkjl2zSvEU/CAyFApo4SegpXDjKfdDFLIkUpHNa7DJXRsej
 XGSbm3q7bDr9RxdI3iC3ENH7NxrBXEbGmGr389YI6Ls1E3MV5vjiOwo5O8tTzbSbp2/m
 o4ng2fLJacYFKDaTnUnR/k6rlFM3A+sbPkbSo6HD3QLWDC5EL03EawFoddor9YPOMD3q OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krr3e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:04:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMx2AO104014;
        Fri, 22 May 2020 23:02:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 313gj8a0av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:02:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MN2Xv1015974;
        Fri, 22 May 2020 23:02:33 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:02:32 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 4/4] kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
Date:   Fri, 22 May 2020 18:19:54 -0400
Message-Id: <20200522221954.32131-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=13 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=13 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 41685bf..f984a60 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -201,7 +201,6 @@ struct regs get_regs(void)
 #define LOAD_GPR_C      SAVE_GPR_C
 
 struct svm_test *v2_test;
-struct vmcb *vmcb;
 
 #define ASM_VMRUN_CMD                           \
                 "vmload %%rax\n\t"              \
-- 
1.8.3.1

