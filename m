Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D46A88380
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 21:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfHITyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 15:54:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfHITyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 15:54:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JsDN2012496;
        Fri, 9 Aug 2019 19:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=1bWnf/nRWB4ncA9aEeDgz+YnjRtH2OTE4baRAZbhpD0=;
 b=JZGWA9IUVZJWLVsyARFPO/WdQPZEenzgOcTCiTYHk7xpQ1CIILITOPpFFqsdsz8guMVq
 MqCN641KwHtlA9vGlOpPS9d6IMWqHJGX5ajNL/W0M8g805lC5Oa6FltkxqzQbcqMno8v
 zp6+Jfh4HSE2dujD0y4Pu+/ZRzFDWJa9XN35VTShjYy+iuRr3jF63QziM7iilZA83199
 iCGE4On/iB7h4wGleVYwz6rDmX621cARp4AC9fpqHhFfhXCS+grUwJd/3Ld/1KQlIvB2
 e2TPbx0VG7tqiGY++SRY4cmcOoqvkbRtjadpbANkKm+DVpuNJBDxefhPeLPCijJ4yFBQ Cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=1bWnf/nRWB4ncA9aEeDgz+YnjRtH2OTE4baRAZbhpD0=;
 b=DBO0BtIYuF+ywdFDvQDGwDhQ4whR2rwjV5dg/Yh+soTlop3X/FHi3M78W9VhOEikrSrQ
 XZfGm2J6xLtkRn9+VZyWsHskR6OsbXsX5Un3cjb3b7BTn07tgJSEK9MPEsYtOMq4+2V0
 +GW+FV1zZE8/QBJrpUk0dxJBYIQ7QFtRLOMY1ebjwKk+h4wk8Wn4b7dxxbd537GXlKPt
 DypIxqG1OTW4VDHqjtr98RCG2ECA4AQMRhzuK9avs6sMrADk84QbD7VPU8I4aH7B4vTo
 mYqnInkqru1ng28el1ldA6TPQQxNF8G3/Hbg270OQqkzx24soixg1SMVWCMD5IEfWkXp Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8hashv64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79Jrd56129066;
        Fri, 9 Aug 2019 19:54:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u8x1h3ujv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79JsbYE017973;
        Fri, 9 Aug 2019 19:54:38 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Fri, 09 Aug 2019 12:54:20 -0700
MIME-Version: 1.0
Message-ID: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
Date:   Fri, 9 Aug 2019 12:26:18 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2] KVM: nVMX: Check Host Address Space Size on vmentry of
 nested guests
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=600
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=656 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1 adds the necessary KVM checks while patch# 2 adds the kvm-unit-tests.
Note that patch# 2 only tests those scenarios in which the "Host Address-Space
Size" VM-Exit control field can only be 1 as nested guests are 64-bit only.


[PATCH 1/2] KVM: nVMX: Check Host Address Space Size on vmentry of nested
[PATCH 2/2] kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested

 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Krish Sadhukhan (1):
      nVMX: Check Host Address Space Size on vmentry of nested guests

 x86/vmx_tests.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

Krish Sadhukhan (1):
      nVMX: Check Host Address Space Size on vmentry of nested guests

