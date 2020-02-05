Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99D6153A3E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 22:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBEV1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 16:27:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37220 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgBEV1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 16:27:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015LDFq7106893;
        Wed, 5 Feb 2020 21:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=1okV5XAaCMzomy1WZOs7JhAOFw31m5fGLDvuLW4mY88=;
 b=YXoVPYpQYHoT5w5sonAL/ZlYG6NvLg1DCa6PSy0w5p0Kd5GAo0DqMEYXrb3TNzP90AO3
 p/DcUt/c6Wj537Lv8vcDzI7QBt19wMsUiOapJxGvpzknL41wZL7hs+eYSu3Rh4WJLugA
 IsYg9WaAj4xAQlPOZTYY4cMKWy4B+el8xwTl/5wH2MPMAtcExvQ3fkt+VhRdrNRHb/DD
 EKJ1pIYj6CC1WkLZW3iuB239d6sTdX0YaoHLO620e4KUy1ZrkN8ezJcmFG44Ibg6l2C5
 HQDN5e701ujMFHHGv5vTu7izlZeYI3UFMuG3K0TNc1hMQzMnNvetgKIOvD9jBgo2hlyj Hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=1okV5XAaCMzomy1WZOs7JhAOFw31m5fGLDvuLW4mY88=;
 b=dIsS8FRkV47ly1iGv70nHP/z6RZkGXbw5JnsfebjobNwVPWpZrWWPmgY/XR0rBJ2bF3v
 8Ke7ulC2/vOzcKAW7pWaZGMSbmR2xSKvnc/H+MyNN6ELOydUiTx+U5Q0rOmTeoAbYwJa
 OteIlBMuss5XPIF4G4wLQAS8vHVsFh31klRumKGHFxSKzkmMJAPW6r23ebLUzDDwgagg
 J9AnjW4ZT4GkbAW9qRumiaKnPRx8CAxBDQWu3rAD7tkaczldZ+1sWl5cqpXhH8Y2amGj
 2ijhzvVBOInWocm+RhIOeW2qNeifYS4OacMQiUQbr6LBGqXNFxI/6fkoLXhmeZ9hhqZi 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp5ubj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 21:27:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015LDZR9071870;
        Wed, 5 Feb 2020 21:27:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xymutp7yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 21:27:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 015LRejv024135;
        Wed, 5 Feb 2020 21:27:40 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 13:27:39 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] kvm-unit-test: nSVM: Restructure nSVM test code
Date:   Wed,  5 Feb 2020 15:50:25 -0500
Message-Id: <20200205205026.16858-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=880
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=960 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch restructures the test code for nSVM in order to match its
counterpart nVMX. This restructuring effort separates the test infrastructure
from the test code and puts them in different files. This will make it
easier to add future tests, both SVM and nSVM, as well as maintain them.


[PATCH] kvm-unit-test: nSVM: Restructure nSVM test code

 x86/Makefile.x86_64 |    1 +
 x86/svm.c           | 1718 +++++++--------------------------------------------
 x86/svm.h           |   52 +-
 x86/svm_tests.c     | 1279 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 1551 insertions(+), 1499 deletions(-)

Krish Sadhukhan (1):
      nSVM: Restructure nSVM test code

