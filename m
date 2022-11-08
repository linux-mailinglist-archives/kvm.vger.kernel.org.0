Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE44621C9A
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 19:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKHS7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 13:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKHS7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 13:59:46 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF3260EA8;
        Tue,  8 Nov 2022 10:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667933986; x=1699469986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f/jLGb3VftbiMJ9+Hf3kCuMm11wmD3y9Crzv0IU8wPw=;
  b=uh1ni13vxjFuqBIX+A01rosMSefaoENXUfXZGJalyhavXpakbFemJKdY
   ZVcUChIDZ5l25Xo8fDDXkvtOhA/P1sODpD7lH9t2MoFN8m0B0yDEawmPy
   9W7nb+5K+p9LnD6zg2q1mDdEodA7olh4D0K1HKcdMtGuDP9wiAQW3+LY6
   8=;
X-IronPort-AV: E=Sophos;i="5.96,148,1665446400"; 
   d="scan'208";a="148956021"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 18:59:43 +0000
Received: from EX13D25EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 4B4DC41991;
        Tue,  8 Nov 2022 18:59:42 +0000 (UTC)
Received: from EX19D016EUA004.ant.amazon.com (10.252.50.4) by
 EX13D25EUA002.ant.amazon.com (10.43.165.40) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 18:59:40 +0000
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.162.178) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Tue, 8 Nov 2022 18:59:35 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        "The AWS Nitro Enclaves Team" <aws-nitro-enclaves-devel@amazon.com>,
        "Andra Paraschiv" <andraprs@amazon.com>
Subject: [PATCH v1] MAINTAINERS: Update entries from the Nitro Enclaves section
Date:   Tue, 8 Nov 2022 20:59:12 +0200
Message-ID: <20221108185912.15792-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D44UWC001.ant.amazon.com (10.43.162.26) To
 EX19D016EUA004.ant.amazon.com (10.252.50.4)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the list of maintainers for the Nitro Enclaves project. Alex
(lexnv@) is not working at Amazon anymore and there will be the same
case for me starting with 2023.

Add a reference to the mailing list of the Nitro Enclaves development
team.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 046ff06ff97f..af2c178ba0dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14564,10 +14564,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux.git
 F:	arch/nios2/
 
 NITRO ENCLAVES (NE)
-M:	Andra Paraschiv <andraprs@amazon.com>
-M:	Alexandru Vasile <lexnv@amazon.com>
 M:	Alexandru Ciobotaru <alcioa@amazon.com>
 L:	linux-kernel@vger.kernel.org
+L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 S:	Supported
 W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
 F:	Documentation/virt/ne_overview.rst
-- 
2.37.1




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

