Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060422B989
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 00:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGWWcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 18:32:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgGWWcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 18:32:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NMMcHo115782;
        Thu, 23 Jul 2020 22:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=rks5fOjKavKDt1iZXF1Sv1m3ADy9gyD46Q9/hbigKOQ=;
 b=URps8MuCtHByb6W8KBgHFY5i0CKkeZB8+WLHbozE7l1bZAxkiYGNgWgP0BWSxFHIzt6v
 KJsemlT5Gt9pwRiLtQb9Hv8JeAFss5D3kXbyHoOoKWYotPsOpU10zlvDcY4XIpoi5Mt2
 aH7B6VmCvm1V9uHgyphWDECD4XJL+SXAnbupOSeSz28rpKfswhur0mAJEp6GdOzKNAGO
 uUnRd+3Byc6QWqdcMZHCyH8BsZ9K3MsJObiHqcmTgNxf0DXCoOsJZSxKk2NyHoxFRaxv
 fXyjfQMNTLFkpXTgcJ9kN3wruzYz3VxK5Nb5BovgeBol6y3NohhipAwHDYNficKF4/fa Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgrv7qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 22:32:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NMNAkC038232;
        Thu, 23 Jul 2020 22:32:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32fhy66kv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 22:32:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06NMW7rY008999;
        Thu, 23 Jul 2020 22:32:07 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 15:32:07 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com
Subject: [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macros
Date:   Thu, 23 Jul 2020 22:31:57 +0000
Message-Id: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=564 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=571
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no functional change. Just the names of the implemented functions in
KVM and SVM modules have been made conformant to the kvm_x86_ops and
kvm_x86_nested_ops structures, by using macros. This will help in better
readability and maintenance of the code.


[PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and

[root@nsvm-sadhukhan linux]# /root/Tools/git-format-patch.sh dcb7fd8
 arch/x86/include/asm/kvm_host.h |  12 +-
 arch/x86/kvm/svm/avic.c         |   4 +-
 arch/x86/kvm/svm/nested.c       |  16 +--
 arch/x86/kvm/svm/sev.c          |   4 +-
 arch/x86/kvm/svm/svm.c          | 218 +++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h          |   8 +-
 arch/x86/kvm/vmx/nested.c       |  26 +++--
 arch/x86/kvm/vmx/nested.h       |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 238 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h          |   2 +-
 arch/x86/kvm/x86.c              |  20 ++--
 11 files changed, 279 insertions(+), 271 deletions(-)

Krish Sadhukhan (1):
      KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops
