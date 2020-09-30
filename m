Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113F127F456
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgI3Vpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:45:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgI3Vph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 17:45:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08ULiCPu097607;
        Wed, 30 Sep 2020 21:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=46KbTF0OAF22T/oKcyzqNkda115P5bsT1F97NsMzEXg=;
 b=XWjC31SsCOfW3QjIjFlYFxcBzRvJV8/kFHww3XBfRSamz68CNe2i45lot/E7mAvzkMQI
 Q4ur511xSxTnHwaSy0wjPbBrzdaUPA1v0I2x0KFp+MNf/HG9NiXklAe+rH3Xw+FTbmrV
 FfZCx1QtUDJk3/BZ2dbGEntq6PbXZ73ih2hO1gUeruHaZdneNngO23MAydDyvAG60mrA
 Dk+hmSlYrVtnsCoO7LXElK2oeVxWU3Du44LlhBF6NhuRQ1rICR4wZ1vI+se1VgvjSCJM
 3YEPFxAmOkJ3jcwjEJratjPgiGzOIAT02OBX4kJiZIhat0WtdCW7kWLW5/u30CMPYoun IA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5b31xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 21:45:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08ULiulA007327;
        Wed, 30 Sep 2020 21:45:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33uv2g1bca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 21:45:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08ULjWhF005128;
        Wed, 30 Sep 2020 21:45:32 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 14:45:31 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/3 v4] nVMX: Test Selector and Base Address fields of Guest Segment registers
Date:   Wed, 30 Sep 2020 21:45:13 +0000
Message-Id: <20200930214516.20926-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=877 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=899 suspectscore=1
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch-series tests the Selector and Base Address fields of the Guest
Segement register according to section "Checks on Guest Segment Registers"
in SDM vol 3C. "Unrestricted guest" VM-execution control is a condition in
testing some parts of the Guest Segement registers.

v3 -> v4:
	In patch# 3's commit message, I have changed the following
		"Signed-off-by: Jim Mattson <jmattson@google.com>"
	to
		"Co-developed-by: Jim Mattson <jmattson@google.com>"


[PATCH 1/3 v4] KVM: nVMX: KVM needs to unset "unrestricted guest"
[PATCH 2/3 v4] nVMX: Test Selector and Base Address fields of Guest Segment
[PATCH 3/3 v4] nVMX: Test vmentry of unrestricted (unpaged protected) nested

 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 17 +++++++++--------
 arch/x86/kvm/vmx/vmx.h    |  7 +++++++
 3 files changed, 19 insertions(+), 8 deletions(-)

Krish Sadhukhan (1):
      KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it

 lib/x86/processor.h |   1 +
 x86/vmx_tests.c     | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests

 x86/vmx.c       |  2 +-
 x86/vmx.h       |  1 +
 x86/vmx_tests.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nVMX: Test vmentry of unrestricted (unpaged protected) nested guest

