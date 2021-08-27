Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581D93F9821
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbhH0KcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:32:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244708AbhH0KcP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630060286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qGkym4g2PvOJklDj+5KXsp+RcnkjG/ygbTs/CDHWmhI=;
        b=Ti0ihuhavXZpiXfbS0S0uG49fHbrgSGnB1tF/0OxJnwND/4aI9zv2cT6rAdHPYJnlcAN9j
        Ijo4Xk/YO1fNLJ8OWSn7WH1lPZn0NmZoodD8qnYORZPBkj09AtId2DpG26q46/kZgyJr+D
        TQqHWnuL4FI9jO5SMJ46vYlnFbvMQm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-2tvS90aLOV-M67ochhAkIA-1; Fri, 27 Aug 2021 06:31:24 -0400
X-MC-Unique: 2tvS90aLOV-M67ochhAkIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAFF6800493;
        Fri, 27 Aug 2021 10:31:23 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3590260C04;
        Fri, 27 Aug 2021 10:31:17 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, thuth@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] Makefile: Don't trust PWD
Date:   Fri, 27 Aug 2021 12:31:15 +0200
Message-Id: <20210827103115.309774-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's possible that PWD is already set to something which isn't
the full path of the current working directory. Let's make sure
it is.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index f7b9f28c9319..a65f225b7d5c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,5 @@
 SHELL := /usr/bin/env bash
+PWD := $(shell pwd)
 
 ifeq ($(wildcard config.mak),)
 $(error run ./configure first. See ./configure -h)
-- 
2.31.1

