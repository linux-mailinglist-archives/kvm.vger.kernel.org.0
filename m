Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7CB47D9F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 10:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfFQIvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 04:51:35 -0400
Received: from smtpbguseast2.qq.com ([54.204.34.130]:60895 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbfFQIvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 04:51:35 -0400
X-QQ-mid: bizesmtp18t1560761442thywn1z2
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 17 Jun 2019 16:50:36 +0800 (CST)
X-QQ-SSF: 01400000002000E0IG32B00B0000000
X-QQ-FEAT: Y64gE3f4hx2VZWSorpWU6f/Tcvmvij4jr3FVv1Hv5zo1hj6fK0GYoGiEjS3es
        IhdC3LAOMs0g9z9xASaWqvfklLuauGxbzhC2aDWAnZKPndk0/2psSTnXjrztQdrL4Nt4X4R
        fcdp/2E2EeWbsW8twYAi8gDgcSG1rB4900UySaTxZ688lE6WASdaM3xn574Bh/B79CKIQk/
        Z7LDU9ASeS0ks3zFfVcSjM92gXLqaw/G63i+l1RgM7w5AlWh48eelS7gt7DpYlLBz10bBQf
        YQX0ikNBGT+Y+/U2WoYE/KglhOudSfvBPL9e7pAAM5udMggw6nkYorgns=
X-QQ-GoodBg: 2
From:   huhai <huhai@kylinos.cn>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, huhai <huhai@kylinos.cn>
Subject: [PATCH] vhost_net: remove wrong 'unlikely' check
Date:   Mon, 17 Jun 2019 16:50:29 +0800
Message-Id: <20190617085029.21730-1-huhai@kylinos.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit f9611c43ab0d ("vhost-net: enable zerocopy tx by default")
experimental_zcopytx is set to true by default, so remove the unlikely check.

Signed-off-by: huhai <huhai@kylinos.cn>
---
 drivers/vhost/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 2d9df786a9d3..8c1dfd02372b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -342,7 +342,7 @@ static bool vhost_net_tx_select_zcopy(struct vhost_net *net)
 
 static bool vhost_sock_zcopy(struct socket *sock)
 {
-	return unlikely(experimental_zcopytx) &&
+	return experimental_zcopytx &&
 		sock_flag(sock->sk, SOCK_ZEROCOPY);
 }
 
-- 
2.20.1



