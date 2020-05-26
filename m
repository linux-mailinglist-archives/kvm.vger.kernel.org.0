Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1EC1DF3BB
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 03:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbgEWBHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 21:07:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387531AbgEWBHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 21:07:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N11WLh086549;
        Sat, 23 May 2020 01:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=xvJpkd0McCUwHK7qpMaBTPqSG76xUVmhav7yoJ2Qv7A=;
 b=PxmMRfDot+eXp5xyLu0rnQKo4UGvzPUJpec46aoeXM/DFed0rdLJ5zF6yWu3QC32az2t
 4yDBdbuXIc++XnZSEtn+Ab+PUJjqDcSMb72mf9vi3smPVOetz5mMB4pn4rKPjDA2C644
 SFml8v5DJzzAsIRce3sdOFzgPcYOtVETUeR2U1lC5J40P+hBSKFW8m1spncMZdDE2YCX
 u4URk3itdYwmOV/FJP8J+6+39/5nimagm9lWZUmVN5HnlLYuwJubBBGEskWozQvazVKY
 mgqktV0Att7OUvm6P/94skPcTwOIRdV/cPKD1FIyxvvue4r8Wt7OwN8rFjezOXvdvhME Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316qrvr7bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 01:07:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N12ZKr148105;
        Sat, 23 May 2020 01:07:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 316rxqspe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 01:07:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04N173oi006845;
        Sat, 23 May 2020 01:07:03 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 18:07:03 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/3] kvm-unit-tests: nVMX: Test base and limit fields of guest GDTR and IDTR
Date:   Fri, 22 May 2020 20:26:00 -0400
Message-Id: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 mlxlogscore=746
 phishscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=13 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=779 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Adds the kvm-unit-tests for the base field of GUEST_BASE_GDTR and
	  GUEST_BASE_IDTR
Patch# 2: Factors out the loops from test_guest_dr7() to a macro
Patch# 3: Adds the kvm-unit-tests for the limit fields of GUEST_BASE_GDTR and
	  GUEST_BASE_IDTR


[PATCH 1/3] kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and
[PATCH 2/3] kvm-unit-tests: nVMX: Optimize test_guest_dr7() by
[PATCH 3/3] kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and

 x86/vmx_tests.c | 52 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

Krish Sadhukhan (3):
      kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and GUEST_BASE_IDTR on vmentry 
      kvm-unit-tests: nVMX: Optimize test_guest_dr7() by factoring out the loops
      kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and GUEST_LIMIT_IDTR on vmentr

