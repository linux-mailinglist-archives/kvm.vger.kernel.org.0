Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958631B1A33
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 01:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDTXis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 19:38:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51544 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTXis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 19:38:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNcjDn051778;
        Mon, 20 Apr 2020 23:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=3wO9u70OUyZRe9Ja0eXRb3YLTqwZ5kDwzuXJU59gmUw=;
 b=j+x27+4Y1pNG6KqlEYUFXuHDG0alv8Su1vjlcDzSsoVsAwnkDCxwWcj5ifkC05f2pXjh
 4R4IgKAkp8jP55FrmPkkP96AFCqKJEFNNyNRFCpAAYH//94Q2CQ04NRVFhwBh+nNLKVx
 K1miqs5Qfet7lHoBOa5y6BlvNyC711anrBLBF8o/f5z7hR5N+BdFkqw0L+EJCS7zxgiP
 wLnCQV3VjYIvIYGTles3IG9fdjtZ8M8AXJJEKUm1db+bumXmLvUdTYCnMbrG5LkBmrkb
 dec/aU+4tgFethS/1Cou98pBUaueU+niqJVAArgeY5t7M7PQ5KMve3Z0PLt8bqQL32fp Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgkt4mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:38:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNcWEs081632;
        Mon, 20 Apr 2020 23:38:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30gbbbywy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:38:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KNchRT007330;
        Mon, 20 Apr 2020 23:38:43 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 16:38:43 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] kvm-unit-test: nSVM: Test CR0[63:32] on VMRUN of nested guests
Date:   Mon, 20 Apr 2020 18:58:24 -0400
Message-Id: <20200420225825.3184-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=13 mlxlogscore=674 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=728 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=13 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


[PATCH] kvm-unit-tests: nSVM: Test that CR0[63:32] are not set on VMRUN of nested

 x86/svm_tests.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test that CR0[63:32] are not set on VMRUN of nested guests

