Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A47155DD1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBGSQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:41 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40544 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgBGSQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:40 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A7241305CA1E;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6EDF63086D0A;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 02/78] export kill_pid_info()
Date:   Fri,  7 Feb 2020 20:15:20 +0200
Message-Id: <20200207181636.1065-3-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mathieu Tarral <mathieu.tarral@protonmail.com>

This function is used by KVMI (KVM introspection sub-system) to
ungracefully shutdown the guest when an introspection tool requests it.

A security application will use it as a last resort in stopping the
spread of a malware from a guest

Signed-off-by: Mathieu Tarral <mathieu.tarral@protonmail.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index bcd46f547db3..461881343991 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1451,6 +1451,7 @@ int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid)
 		 */
 	}
 }
+EXPORT_SYMBOL(kill_pid_info);
 
 static int kill_proc_info(int sig, struct kernel_siginfo *info, pid_t pid)
 {
