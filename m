Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234581FBE91
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgFPS4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44486 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730082AbgFPS4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 14:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=7sORUDwgRVhhtfiGbJgwh7emKoMOBNl3hnH5dpBlRZc=;
        b=V5RFi+2tVWGVCjPb3Lgb3YKrl8jWwApqzVSs1KQ/McSA2WjIWgWr7DgwD/0o15NyVFNcQJ
        JHwxk9BwAO+F1VWCNQrD+8WnndiDDDaLeNADgj0KKFmKNqTmch9O6Apm3C84qiz/Jnh0jO
        vD0fJeWHp8KRksEWVAZcjWl32NQI2jQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-qQBRkPb3OrmiKxx0muK7fA-1; Tue, 16 Jun 2020 14:56:29 -0400
X-MC-Unique: qQBRkPb3OrmiKxx0muK7fA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19B35134ED
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:28 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40ED57CAA8;
        Tue, 16 Jun 2020 18:56:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 02/12] x86: avoid multiple defined symbol
Date:   Tue, 16 Jun 2020 20:56:12 +0200
Message-Id: <20200616185622.8644-3-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Fedora 32 croaks about a symbol that is defined twice, fix it.

Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20200511165959.42442-1-pbonzini@redhat.com>
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

