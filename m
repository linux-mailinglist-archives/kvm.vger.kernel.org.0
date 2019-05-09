Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F1194E1
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfEIVrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:47:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbfEIVrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:47:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LietJ179451;
        Thu, 9 May 2019 21:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=VQpXL/clTktpS8xx2VoyaaQXVgtMSt6AdxgtKogxprs=;
 b=1pkhXEewsmQ/mHWitsLYYgGNA+9zS4jgBkO216nZiRHuPxHkDXWG0pmCXnjGU0bsUlBh
 Io0C5wecw3TtOjY1NRzSwMRglDiMsdzVDzqypTBDmdKm5DrhlYtwzq/BUQBC8DNcAZs1
 h6IBzOnp0Ja9lCRWhGrbEVJdv5XpaQcT+MXL5wuD1pJJGuMSUW6FRbgeWOOqz8xayALN
 vrEK4IC3OlpGWKhhxrlmdYuGJvhJXoPbzWFgdssWvMGw9FA79oztDyq3yAjVc1VYgzpL
 dpjBrAhcHcI2zBBSdetQcfmYGrzTFSGz1fIt0yatk8vWy8M37iG36ETfao1FACdHPgHe OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2s94b6dpv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49Lk1Mr152302;
        Thu, 9 May 2019 21:46:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sagyvgagh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49Lku9S012688;
        Thu, 9 May 2019 21:46:56 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 14:46:56 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/4][kvm-unit-test nVMX]: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
Date:   Thu,  9 May 2019 17:20:51 -0400
Message-Id: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=847
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=874 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This set contains the unit test, and related changes, for the "load
IA32_PERF_GLOBAL_CONTROL" VM-entry control that was enabled in my previous
patchset titled:

	[KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested guests


[PATCH 1/4][kvm-unit-test nVMX]: Rename guest_pat_main to guest_state_test_main
[PATCH 2/4][kvm-unit-test nVMX]: Rename report_guest_pat_test to
[PATCH 3/4][kvm-unit-test nVMX]: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
[PATCH 4/4][kvm-unit-test nVMX]: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry

 x86/vmx.h       |   1 +
 x86/vmx_tests.c | 108 +++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 87 insertions(+), 22 deletions(-)

Krish Sadhukhan (4):
      nVMX: Rename guest_pat_main to guest_state_test_main
      nVMX: Rename report_guest_pat_test to report_guest_state_test
      nVMX: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
      nVMX: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests

