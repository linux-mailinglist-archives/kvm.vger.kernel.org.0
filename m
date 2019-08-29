Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C73A28EB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfH2V1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:27:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfH2V1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:27:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLP4T8165925;
        Thu, 29 Aug 2019 21:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=WwwNCFkwDLUAzglbHUOnYAvCmaEVb+qt+sraM/XXYX8=;
 b=sj0AKfhBCX3P9USg/w74ykiyBRfSUZWBtkKKqG/1mokQgoi3fbvVey9L4m9c0fheknF3
 g0Spzlxy4NYbZyuQquJzsNRug5TLCzwb+qIr0nGc3NRAOMQuc6697cPCenFWnt4Bssee
 r6ZV2OH/kHkZC//v8+bCecBdL3+XzH5VG70wVPVj3bB1oizxGeRWownxs1tbVl/IC7B+
 Fa/TYtqPEqzPayJDmi9wj/4V779ahy1u9dGbHCEPRuNVee+3nDJr/4LGIHjtDTDMQkuX
 syNiIXypIWpHi0LDSCIvLJdm0xzKCsnFnBqZyXlbGPnT5UOvgGoTZdjV/09D+Jh2a+nA WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uppjc00rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:27:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE6Zl085260;
        Thu, 29 Aug 2019 21:25:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uphaub0fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLPHS1027445;
        Thu, 29 Aug 2019 21:25:17 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:25:17 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/4] KVM: nVMX: Check GUEST_DEBUGCTL and GUEST_DR7 on vmentry of nested guests
Date:   Thu, 29 Aug 2019 16:56:31 -0400
Message-Id: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=705
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=766 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1: Adds KVM check for GUEST_DEBUGCTL
Patch 2: Adds KVM check for GUEST_DR7
Patch 3: Fixes a bug in __enter_guest() in kvm-unit-test source
Patch 4: Adds kvm-unit-tests related to patch# 1 and 2


[PATCH 1/4] KVM: nVMX: Check GUEST_DEBUGCTL on vmentry of nested guests
[PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
[PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set "launched" state
[PATCH 4/4] kvm-unit-test: nVMX: Check GUEST_DEBUGCTL and GUEST_DR7 on vmentry of

 arch/x86/kvm/vmx/nested.c | 10 ++++++++++
 arch/x86/kvm/x86.c        |  2 +-
 arch/x86/kvm/x86.h        | 12 ++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      nVMX: Check GUEST_DEBUGCTL on vmentry of nested guests
      nVMX: Check GUEST_DR7 on vmentry of nested guests

 x86/vmx.c       |  9 +++++----
 x86/vmx_tests.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 4 deletions(-)

Krish Sadhukhan (2):
      nVMX: __enter_guest() should not set "launched" state when VM-entry fails
      nVMX: Check GUEST_DEBUGCTL and GUEST_DR7 on vmentry of nested guests

