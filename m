Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B872187765
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 02:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733124AbgCQBVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 21:21:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733104AbgCQBVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 21:21:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1I2Ro179228;
        Tue, 17 Mar 2020 01:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=f7CQW5yD+bNNHJvpMDW69FmUb46A0zpHFlOpybxLz4I=;
 b=pffBb7sbyQ1fMdVTzVH1FiPXnXiB/r8kPc1eebgAfs/CyyYFCYJjioDF2guA3u4vPhuv
 S+ypMiiCqGJtv4LaBewRM106NbJaZEPFqTemuEcq2RmHNO+Nhf+j5AyRQtYAAyVcSyOo
 u+84wa2dYer4+5rDbUv8flrL08ytMK8SlDeOwxBR5zveEwsxl1tvZ1QYoTwGlLZrZrhN
 A/DEDlJ46swaGar9epQ5X9vdeKPSSex+ntUaUOoLPgW9cVAUhkxkeJgR4SocG50MQYyF
 aDFAl60lwb4fawYi4d6N2/l9ilLx001XzdG3S1P6uRpXsD3kMl1VJpFlWOnkuDSorfCa zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yrqwn1w3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1KgWS064787;
        Tue, 17 Mar 2020 01:21:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ys8tqs4t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02H1LknT008917;
        Tue, 17 Mar 2020 01:21:46 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 18:21:45 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
Date:   Tue, 17 Mar 2020 01:21:33 +0000
Message-Id: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=13 mlxlogscore=626 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=703
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=13
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170003
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Adds the required enum values to the header file
Patch# 2: Adds the test code


[PATCH 1/2] kvm-unit-test: VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS
[PATCH 2/2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of

 x86/vmx.h       |  2 ++
 x86/vmx_tests.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

Krish Sadhukhan (2):
      VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS vmentry control fie
      nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
