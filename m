Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2019042BD58
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhJMKoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:44:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhJMKoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KV1UzSu/dfBqv39FkZcvqMEG7LTj87cKAMHcgkxcYc=;
        b=B0AG1YmcpIbta2ELHhG+CD5LTQ+wCi9SF3QfC5u59d1zZutbRnyg5ZIoPVpC9Q/35jTIHw
        MD4bJkBrk81fhIynM6wYJanfuNLB8N9Noj4q4KQXXUWwxQb0jUIS5vyr1BvpeTXWZjGNZf
        f33lZLksDrtt+2D1rXbTrQCQny5QOpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-pGTXNjp_MA6vZTI1fy6W1g-1; Wed, 13 Oct 2021 06:42:18 -0400
X-MC-Unique: pGTXNjp_MA6vZTI1fy6W1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C959126D;
        Wed, 13 Oct 2021 10:42:17 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3B085D9D5;
        Wed, 13 Oct 2021 10:41:39 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Subject: [PATCH RFC 14/15] libvhost-user: Increase VHOST_USER_MAX_RAM_SLOTS to 4096
Date:   Wed, 13 Oct 2021 12:33:29 +0200
Message-Id: <20211013103330.26869-15-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

4096 is the maximum we can have right now in QEMU with vhost-user, so
increase the libvhost-user limit as well.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 subprojects/libvhost-user/libvhost-user.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 3d13dfadde..d9628ed9f0 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -30,11 +30,8 @@
 
 #define VHOST_MEMORY_BASELINE_NREGIONS 8
 
-/*
- * Set a reasonable maximum number of ram slots, which will be supported by
- * any architecture.
- */
-#define VHOST_USER_MAX_RAM_SLOTS 32
+/* Set the RAM slots based on the maximum supported by QEMU vhost-user. */
+#define VHOST_USER_MAX_RAM_SLOTS 4096
 
 #define VHOST_USER_HDR_SIZE offsetof(VhostUserMsg, payload.u64)
 
-- 
2.31.1

