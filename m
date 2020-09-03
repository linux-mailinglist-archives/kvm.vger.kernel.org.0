Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4056325B983
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 06:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgICEFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 00:05:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57812 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgICEFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 00:05:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831T9d7106563;
        Thu, 3 Sep 2020 01:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=7WDbja8ZJCyyBMNKCmDFHnlAbzxdZnYuIc5rCHK/uwQ=;
 b=ITf8qCbARyfalc+gdxUjYso9QcF1eng3G+ND/An6giA53EqRBTk9bP8ahuindWWGrnP6
 my8vqCTU4oI+IALAW9zijFXExx5AfXPIR1RVgnfA1JEfoz4a/Whb8F9BeInHn2DUq87S
 pUw1lF55xsp909rdsyERFhxDEaYidfsikAu1jNKJIwUz4JhbKMzsLR3y+SStRtSQiNk4
 knEkOkEdN4ZFqtP35hEAdUM8/yjEjtCgCS1POeg+4V5qJWNdTm0epFxMR2Zag74Z1zfT
 k7WzTydxBrT5ztjeojHCB3fVJ6iCT4Dlf0IBsNMkjQWnY91iIqTRSWa8xRNGv5Hy2zNh dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer60ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 01:29:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831PFQt175881;
        Thu, 3 Sep 2020 01:29:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kqy1ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 01:29:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0831T8DK004321;
        Thu, 3 Sep 2020 01:29:08 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 18:29:08 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH v2] nSVM: Add a test for the P (present) bit in NPT entry
Date:   Thu,  3 Sep 2020 01:28:50 +0000
Message-Id: <20200903012851.22299-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=907 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=902 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	Enhanced the commit message.


[PATCH v2] nSVM: Add a test for the P (present) bit in NPT entry

 x86/svm_tests.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Krish Sadhukhan (1):
      nSVM: Add a test for the P (present) bit in NPT entry

