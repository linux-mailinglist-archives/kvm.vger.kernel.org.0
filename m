Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9174F1A3BF4
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgDIVau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:30:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgDIVat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:30:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LOSd9023082;
        Thu, 9 Apr 2020 21:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=+KL6ijpPOJ6Ij2K5bOtSEem/97JNwCGEfRxIViHvcJ8=;
 b=esnhiLRdiK1jwlTUPOLFn37iK3SXKbwECdmEoBOiaz6ltWF7ftkM8s9gwqn6VMHmUFGu
 nryMJ9Ku0L2mCvHrMRW21APWfecxabHYmA/ckeAAg+l59W1NJ8KYu8nBVpF0/FOekKx/
 xf6asiQMMbz/PRaHbl+Dj34t6820XQKMcEnpI6PSFF1eO+7qaKZGT1TVJVZOfRWpg12G
 ydH9UlS85XJ36TE3NHYZAIZERPa0Zz2vQ5PArp0vEYAPPyrjt/wWeDLeWTQXJg2ZHcUx
 0PIfHwysgpkSzv8OB/XStkKe2YL4EJr5y27Ht3OlfCHr6WCsEgpu8qr+lMot7xDpKQLP 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3091m3kwv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LMeCl067938;
        Thu, 9 Apr 2020 21:30:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 309gdcvrvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 039LUjMg031367;
        Thu, 9 Apr 2020 21:30:45 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 14:30:45 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3] KVM: nSVM: Check CR0.CD and CR0.NW on VMRUN of nested guests
Date:   Thu,  9 Apr 2020 16:50:32 -0400
Message-Id: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=473 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=550
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Adds the KVM check.
Patch# 2: Adds the required #defines for the two CR0 bits.
Patch# 3: Adds the kvm-unit-test

[PATCH 1/3] KVM: nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests
[PATCH 2/3] kvm-unit-tests: SVM: Add #defines for CR0.CD and CR0.NW
[PATCH 3/3] kvm-unit-tests: nSVM: Test CR0.CD and CR0.NW combination on VMRUN of

 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

Krish Sadhukhan (1):
      nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests

 lib/x86/processor.h |  2 ++
 x86/svm_tests.c     | 28 +++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      SVM: Add #defines for CR0.CD and CR0.NW
      nSVM: Test CR0.CD and CR0.NW combination on VMRUN of nested guests

