Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95527324
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 02:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfEWAMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 20:12:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfEWAMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 20:12:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N047As121755;
        Thu, 23 May 2019 00:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=ZAx5pdqX1K1ipF4397VdY5xbElVquceEuaINwTGVVzw=;
 b=JMAurhALYEUfFyPozYAF8M9uHDFteWrsQIrbQLft/l8JP+D41lE0vEjZMD80IJi/fzq5
 lw1/A6z0whcU7lzTbtCTT9Odmd2+71FiRXCeCXHdPcOvBn3uIkp7b0BbhHbQ1PyZ+2f4
 gfDc45HgDAzdf8dcYDRPtW8+UTtf8K2TlI2qf/UeURywXoiGN4Jhi84zup3WL316EgMP
 F7qzBo1nBDU2Q4QOtfOdUoYW60OU6JZBCWG+fOwa6HrbZ3vft7w/QNElQir3RfQBLF+3
 T+SxEr/08z8WaxOmkpLETgn0F11mj/vFMpfnWSMFVeJzsdFXq1ftQzBolf3d6tAH+hkQ 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2smsk5f43n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N0BPf9156758;
        Thu, 23 May 2019 00:12:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2smshewt26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4N0C166020235;
        Thu, 23 May 2019 00:12:01 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 00:12:00 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of nested guests
Date:   Wed, 22 May 2019 19:45:43 -0400
Message-Id: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=602
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=657 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1 creates a wrapper for checking if the NX bit in MSR_EFER is enabled.
It is used in patch# 2.

Patch# 2 adds tests for "Load IA32_EFER" VM-exit control.


[PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the CPU supports NX bit in
[PATCH 2/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of

 lib/x86/processor.h |   8 ++++
 x86/vmexit.c        |   2 +-
 x86/vmx_tests.c     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      x86: Add a wrapper to check if the CPU supports NX bit in MSR_EFER
      nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of nested guests

