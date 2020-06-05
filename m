Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BEE1F005C
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgFETUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:20:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47224 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgFETUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:20:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JIaDA192300;
        Fri, 5 Jun 2020 19:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=bMkflYSOYVoWdMH52y+bdI1S3snCBEUjXDeaQaP5oPc=;
 b=WMtHEHhIZomuuplk04ZvCEiQNiK7IwpNB4+4ItLuxtYuHyPVYdT08Uge9cRmiFIzRmnQ
 ES1tlvAX2Wk4ov/LuWcEeX/lBYAntEefAGCIYcn9kymTSKmW28Ue4xRRzoa2U70vXls6
 CTAkdozcFDEjInl+wmQ2sBQuHzwZ2ir4DPeHSUOzRaE0eWZfl+bBoiZmZ6EU/gEYenhr
 G1I2HEJx9djE3o7yFiVbaZw45ogsXCfSIWKwpkzkLilRvPr2jUrnCNHiCH9lXcH1X6iq
 kB12BiaqmGNqpN6ToDKZAyYu021gGv8DBWUUxNawwSsY3nY/fG7EwnM1DVlN8h7CD+jS 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31f9244d3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 19:20:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JIBYs012036;
        Fri, 5 Jun 2020 19:20:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31f927mpr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 19:20:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055JKXjV017164;
        Fri, 5 Jun 2020 19:20:33 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 19:20:33 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/3 v2] kvm-unit-tests: nVMX: Test base and limit fields of guest GDTR and IDTR
Date:   Fri,  5 Jun 2020 19:20:19 +0000
Message-Id: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=695 bulkscore=0 suspectscore=13 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=745 mlxscore=0 bulkscore=0
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
        This only change is in patch# 1 where I have removed the '#ifdef __x86_64__' guard.


[PATCH 1/3 v2] KVM: kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and
[PATCH 2/3 v2] KVM: kvm-unit-tests: nVMX: Optimize test_guest_dr7() by
[PATCH 3/3 v2] KVM: kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and

 x86/vmx_tests.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

Krish Sadhukhan (3):
      kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and GUEST_BASE_IDTR on vmentry 
      kvm-unit-tests: nVMX: Optimize test_guest_dr7() by factoring out the loops
      kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and GUEST_LIMIT_IDTR on vmentr
