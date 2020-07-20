Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D73227282
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 00:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGTWyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 18:54:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTWyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 18:54:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KMkm9U183278;
        Mon, 20 Jul 2020 22:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=w5eofuKFVxCOXQbXKzfnvBr1A5TCi47/v5VxqaGWsuk=;
 b=PF9MmJ6aQpJCTXNt1aSXYSAjmNj+BWMUpQw6BLpAtCnvpeY2NLjohDFd+FRVdqx/dclN
 3A5i6CE/qMq5FVH4/+wRtrRnHVJ3nteoevePun3w6kI14r4uBpLIHfUV9g2lvTF1DguY
 V9iWghzAKBOCclqkRdJTZaen3uGz3WKyjNmAQERuDMqCW6ItQZLmk/wf/vzB7nqNygJI
 LQrQ8kFt2Bydko7oC7U/VUq1pKHfU/xd6VH/3UvV1t+FpfxN49B9dF/SBBeUG22Smy3S
 +CdvFW4P0kaCHA579EWS+aUUgNN4L23fRBaA0eE3m+v/xtzxpSJ8VYt4i77jctbASivm Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgr9rfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 22:53:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KMn00w120464;
        Mon, 20 Jul 2020 22:53:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32djyx4vt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 22:53:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06KMmnMD028177;
        Mon, 20 Jul 2020 22:48:49 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 15:48:49 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: [PATCH] KVM: x86: Fix names of implemented kvm_x86_ops in VMX and SVM modules
Date:   Mon, 20 Jul 2020 18:07:27 -0400
Message-Id: <20200720220728.11140-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=645
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=672
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no functional change. Just the names of the functions in the two
modules have been made consistent with respect to each other and with respect
to the kvm_x86_ops structure. This will help in better readability and
maintenance.

[PATCH] KVM: x86: Fix names of implemented kvm_x86_ops in VMX and SVM

 arch/x86/kvm/svm/avic.c   |  4 ++--
 arch/x86/kvm/svm/svm.c    | 46 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h    |  2 +-
 arch/x86/kvm/vmx/nested.c |  4 ++--
 arch/x86/kvm/vmx/vmx.c    | 56 +++++++++++++++++++++++------------------------
 arch/x86/kvm/vmx/vmx.h    |  4 ++--
 6 files changed, 58 insertions(+), 58 deletions(-)

Krish Sadhukhan (1):
      KVM: x86: Fix names of implemented kvm_x86_ops in VMX and SVM modules

