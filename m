Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0231A3BF5
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgDIVav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:30:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgDIVau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:30:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LNvXD133470;
        Thu, 9 Apr 2020 21:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/6mnzP6MXdiweNB+aTC67Y8zflCbakbrTJoiQ62WKvE=;
 b=pUM8stcJKITevNSgsrgJqLlFEtJlu2x8M8xaMdZYEtWRaLpabHfC4yE/+QgG+HGY5EA1
 UWfT3Av2M1cbqbJGYNtrcvRRWitBoiViAGMS13AVPitmew2DIIyZLNRrxgFYcltijjUF
 br4m15XR2t4Sok/Xsw2j/P1eRJIQZVg4NRtGrJnJSxXwy87lIF+JtVYIkjc02/t9Jgy/
 WOCBe+jzmzOEorSKHFwBRBFy5+tVpVGs+y6GOJAM+RRkDiGyWz0Jx97EDrN8/lz44yrw
 6nRfz53UQuOrL+W7El5RhtDh+0WDjrUyAmgiWPxo8TlEC8vzx9La9Ect8C/4CvKfl9WD jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3091m13x9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LMnP1003484;
        Thu, 9 Apr 2020 21:30:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 309ag5r05k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039LUkEG024391;
        Thu, 9 Apr 2020 21:30:46 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 14:30:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3] kvm-unit-tests: SVM: Add #defines for CR0.CD and CR0.NW
Date:   Thu,  9 Apr 2020 16:50:34 -0400
Message-Id: <20200409205035.16830-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
References: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=894 suspectscore=15
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=970 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=15 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3adddee..804673b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -32,6 +32,8 @@
 #define X86_CR0_TS     0x00000008
 #define X86_CR0_WP     0x00010000
 #define X86_CR0_AM     0x00040000
+#define X86_CR0_NW     0x20000000
+#define X86_CR0_CD     0x40000000
 #define X86_CR0_PG     0x80000000
 #define X86_CR3_PCID_MASK 0x00000fff
 #define X86_CR4_TSD    0x00000004
-- 
1.8.3.1

