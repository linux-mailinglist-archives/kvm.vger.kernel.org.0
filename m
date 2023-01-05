Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0121D65E1BA
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 01:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbjAEAlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 19:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240691AbjAEAis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 19:38:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9725BC23;
        Wed,  4 Jan 2023 16:38:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5685D618A0;
        Thu,  5 Jan 2023 00:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697C2C433AA;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879095;
        bh=DG7Pd7Nd4SDFQ0Z2L3qtkeDuW2Mx222F1hGW9El87wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0KeEQevUbKVz3bYSLrR93Wal79fsjYKnTPR7SX3CUYnrv4rH+W31Q3tgM6QGP1Mt
         Aw/KQZprQxWswMUcgXu1wkPPvaZlLoQgoHr+mhiZGSFiN2GsR9gBScMSVUus3LR8cF
         wLx8T5/6+3CEe6BoSUse4eie7lsotO9KAm0FANz60tJ7VG9dTVbiXxdEhTrSqARvb1
         /mM383P0IXDH53usLPqMDLlh/4gsUS/B7KzyQRRWX7zdUyiYevbmm9pP6guj6sfJfn
         qrBMGJ0iXoc7rDcEtcsIHvn94QWqiz9PpYq6HY7ej7nxpPwj99UnEOb8z+ErJihzc5
         owDecVACEulCA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id C028C5C1ADF; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH rcu 06/27] arch/s390/kvm: Remove "select SRCU"
Date:   Wed,  4 Jan 2023 16:37:52 -0800
Message-Id: <20230105003813.1770367-6-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <kvm@vger.kernel.org>
Cc: <linux-s390@vger.kernel.org>
---
 arch/s390/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 33f4ff909476c..45fdf2a9b2e32 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -31,7 +31,6 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
-	select SRCU
 	select KVM_VFIO
 	select INTERVAL_TREE
 	select MMU_NOTIFIER
-- 
2.31.1.189.g2e36527f23

