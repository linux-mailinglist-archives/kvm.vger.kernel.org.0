Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2266A188DCE
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgCQTPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:15:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQTPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:15:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJDg6J080937;
        Tue, 17 Mar 2020 19:15:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=qD3tunIHYjcyV2L391CyBWutsEdfGEmsYgrnzEg7/do=;
 b=kU60hflsxvBEekTwCKSMxCW5dZPLXxIGcyq2+NUB/lCqMvYpIcaVf/fKaNksQxE3gf3q
 KLI03+tZ2ciPnp313V6x1f9c0fXOPlUQWcIS9MmwWEkd0dlW9E3Lm1kuPXmW9aGUbR0s
 sjj7aoTXVVDm28eyppldM3nD27j9o17rFXW0bl1jh7yd3xZLQ//D6vx09ow6OPjw0ABw
 J3WXHV1iWXvlOIWEoaN4Gz6NgdVq+oKiLyZseFmnwgjI5PPOEbzxF1wPQQ7rn/N6fPWN
 THznGhHw5PqaFfGkK1WTXCiko3fJ/PPzzhQ5NYoiTgBJdxkFx9BCIP9QZmtYfCQBEYGw Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yrqwn6q4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJCacc021289;
        Tue, 17 Mar 2020 19:15:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ys8tscwg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HJFjL8010160;
        Tue, 17 Mar 2020 19:15:45 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 12:15:45 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/2 v2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
Date:   Tue, 17 Mar 2020 19:15:28 +0000
Message-Id: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=13 mlxlogscore=783 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=860
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=13
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	Rebased to the latest Upstream repo. No other changes.


Patch# 1: Adds the required enum values to the header file
Patch# 2: Adds the test code

[PATCH 1/2 v2] kvm-unit-test: VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS
[PATCH 2/2 v2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of

 x86/vmx.h       |  2 ++
 x86/vmx_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

Krish Sadhukhan (2):
      VMX: Add enum for GUEST_BNDCFGS field and LOAD_BNDCFGS vmentry control fie
      nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
