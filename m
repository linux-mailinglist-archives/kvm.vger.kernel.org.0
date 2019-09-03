Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCF5A6791
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfICLjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 07:39:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfICLjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 07:39:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BdFpt148184;
        Tue, 3 Sep 2019 11:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=o+76MX0zZGyc4fh6Y1W/BKqN8rsYX1w7XdQdvwal/RA=;
 b=WMJ8SKogJsz3Si6BLKBRZKd1Y/ujdztk1RcRCpDc1Z+tXD2Aa9Cile4xKa2JC8/Jnqat
 z8Id33qp5wcL9bUR6EUY30/teCkIBZsyvJKCuIlypZ9CQUKaiW+N5jLpxStlrNdtZ8nd
 +Gl93qFHrm91cWK4ptkQWndeffNjz+eRUnpCw4UHpOcs6LL8AxiVzpitFlWNO2bt+829
 lVeqq19XjCduUXdCx8wgmm0UAFv5hTT7Dl+dcyE3qWwU36fIz+Vs2ZQ494WkBfgZ0GLE
 LSrerpjOh70FFHF/WOLE+lvLBysVY01qW8cX+xbI67xWWskvsKOlbGCt05Py2pWd96WT jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2usptvg6ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BcHYQ070767;
        Tue, 3 Sep 2019 11:39:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2us5pgs2hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83BdTMF028461;
        Tue, 3 Sep 2019 11:39:29 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 04:39:29 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 0/4] cpuidle, haltpoll: governor switching on idle register
Date:   Tue,  3 Sep 2019 12:39:09 +0100
Message-Id: <20190903113913.9257-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=816
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=875 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

Presented herewith a series with aims to tie in together the haltpoll
idle driver and governor, without sacrificing previous governor setups.
In addition, there are a few fixes with respect to module loading for
cpuidle-haltpoll. 

The series is organized as follows:

 Patch 1: Allows idle driver stating a preferred governor that it
          wants to use, based on discussion here:

  https://lore.kernel.org/kvm/457e8ca1-beb3-ca39-b257-e7bc6bb35d4d@oracle.com/

 Patch 2: Decrease rating of governor, and allows previous defaults
	  to be as before haltpoll, while using @governor to switch to haltpoll
	  when haltpoll driver is registered;

 Patch 3 - 4: Module loading fixes. first is the incorrect error
	      reporting and second is supportting module unloading.

Thoughts, comments appreciated.

Thanks,
	Joao

Joao Martins (4):
  cpuidle: allow governor switch on cpuidle_register_driver()
  cpuidle-haltpoll: set haltpoll as preferred governor
  cpuidle-haltpoll: return -ENODEV on modinit failure
  cpuidle-haltpoll: do not set an owner to allow modunload

 drivers/cpuidle/cpuidle-haltpoll.c   |  4 ++--
 drivers/cpuidle/cpuidle.h            |  1 +
 drivers/cpuidle/driver.c             | 26 ++++++++++++++++++++++++++
 drivers/cpuidle/governor.c           |  6 +++---
 drivers/cpuidle/governors/haltpoll.c |  2 +-
 include/linux/cpuidle.h              |  3 +++
 6 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.17.1

