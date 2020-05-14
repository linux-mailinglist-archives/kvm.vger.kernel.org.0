Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01E91D3D68
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgENT0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:26:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20027 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727910AbgENT0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Z1+cCPr77ZxTZCfVeRFGI2KL+VvU2bdBfuP7xBCYBIQ=;
        b=IaDZfDN82rAgmDU6ZDqhp7gzLbJoYwsgAEkK59mm/J3nQ1pppfd//Jp8ufXLEHRF2HXRW+
        1ai2nPfnbl+uNqqVlkXd8KGWkwAsEgKyQ/cuO5gPRj65SeFNsAn4Jp5NC+xljEvjYwKyf1
        /SOjuNRkqxXV0qGHafn6aXpPPTLugvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-DXbUGwLaMfajUCyMxGFAVg-1; Thu, 14 May 2020 15:26:47 -0400
X-MC-Unique: DXbUGwLaMfajUCyMxGFAVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C61818FF660;
        Thu, 14 May 2020 19:26:46 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C548A5C1BE;
        Thu, 14 May 2020 19:26:43 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 03/11] x86: avoid multiply defined symbol
Date:   Thu, 14 May 2020 21:26:18 +0200
Message-Id: <20200514192626.9950-4-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Fedora 32 croaks about a symbol that is defined twice, fix it.

Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/x86/fault_test.c | 2 +-
 lib/x86/usermode.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
index 078dae3..e15a218 100644
--- a/lib/x86/fault_test.c
+++ b/lib/x86/fault_test.c
@@ -1,6 +1,6 @@
 #include "fault_test.h"
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f01ad9b..f032523 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -14,7 +14,7 @@
 #define USERMODE_STACK_SIZE	0x2000
 #define RET_TO_KERNEL_IRQ	0x20
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
-- 
2.18.1

