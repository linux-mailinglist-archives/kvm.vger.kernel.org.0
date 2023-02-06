Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F768B859
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBFJMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBFJL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:11:28 -0500
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BA5116;
        Mon,  6 Feb 2023 01:11:26 -0800 (PST)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id CDS00121;
        Mon, 06 Feb 2023 17:11:21 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201610.home.langchao.com (10.100.2.10) with Microsoft SMTP Server id
 15.1.2507.16; Mon, 6 Feb 2023 17:11:22 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <pbonzini@redhat.com>, <corbet@lwn.net>
CC:     <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] Documentation: kvm: Correct spelling
Date:   Mon, 6 Feb 2023 04:11:20 -0500
Message-ID: <20230206091120.1618-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   202320617112153171e11b40f493f02d8f19755ae95c3
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We shuold use the replace thie.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1b1f721e3fd9..4e164d449906 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8193,7 +8193,7 @@ the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute in the KVM_XEN_SET_ATTR
 and KVM_XEN_GET_ATTR ioctls. This controls whether KVM will set the
 XEN_RUNSTATE_UPDATE flag in guest memory mapped vcpu_runstate_info during
 updates of the runstate information. Note that versions of KVM which support
-the RUNSTATE feature above, but not thie RUNSTATE_UPDATE_FLAG feature, will
+the RUNSTATE feature above, but not the RUNSTATE_UPDATE_FLAG feature, will
 always set the XEN_RUNSTATE_UPDATE flag when updating the guest structure,
 which is perhaps counterintuitive. When this flag is advertised, KVM will
 behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
-- 
2.27.0

