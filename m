Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9914213B765
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 03:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgAOCC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 21:02:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgAOCC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 21:02:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F22tjS111514;
        Wed, 15 Jan 2020 02:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=66y6/bzb6knDvZeFzJdqOTqNPnDuDsF1gXa4bDc+gQ0=;
 b=VY+bzNe6uK32JOPapTU4Tp6uZlrWdTnOSBov/K72cAEJMhvoi5ECdZhs/zZqD1pNxVax
 F5xJmN5AEadj9C+BqSdjCLhozQdxQLp+GvQZxR4vLNtC8HKIdFhC8zQ3DbdIhssGh3P3
 CW8m0OrQ4dCS4jKmAUhci4Tfo+BFOy2pIfpjNajCH47hCOodW7hLLdAZDuP/CAX3qEn8
 gfG/FqtqQ4mE//YPHvx7nEsozSRSt3SNQJcwrVhES+SJO8CPdOlZotBxl9jt9Kr2X7jN
 unHkFxntuhjkVi6TQCbNQmTeRpbK1bv3pYRjJBcKw9YXbslIx0ZfNRaz+A1gtW2zLm2b EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73tshx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:02:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F1wxZI057781;
        Wed, 15 Jan 2020 02:02:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xh31524j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:02:55 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00F22tfJ031581;
        Wed, 15 Jan 2020 02:02:55 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jan 2020 18:02:55 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2 v2] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
Date:   Tue, 14 Jan 2020 20:25:39 -0500
Message-Id: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=532
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=597 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150017
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I sent out v1 a few months back. Here are the changes:

v1 -> v2:
	1. Patch# 1 has been dropped as we do not want to check GUEST_DEBUGCTL
	   software.
	2. Patch# 3 has been dropped.
	3. Patch# 4 has been modified to include only the tests for GUEST_DR7
	   and to be run directly on hardware as well.


[PATCH 1/2 v2] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
[PATCH 2/2 v2] kvm-unit-test: nVMX: Test GUEST_DR7 on vmentry of nested guests

 arch/x86/kvm/vmx/nested.c | 6 ++++++
 arch/x86/kvm/x86.c        | 2 +-
 arch/x86/kvm/x86.h        | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nVMX: Check GUEST_DR7 on vmentry of nested guests

 x86/vmx_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test GUEST_DR7 on vmentry of nested guests

