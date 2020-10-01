Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2627FEBE
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbgJAMCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 08:02:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731670AbgJAMCa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 08:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601553749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=il4T9+9ILkXtwEXPO9BKrKbTmlb2ckuffjzbILvxS14=;
        b=QSqhtui3C9B0i7USmjcaeOe/Oi2Ega4U9PaFXeQ5Z/+qIRzUsUXXEl8HF2mJGnRe0KD2Co
        fVuWuiL0dOMcn4GOTQstDXK+2Gd5ReEyuQDBXGcG0M6ERjWsOtXtA1XE3jKgIlgRCKSPwV
        RlofqW0Ql+fetPPwiF9/j0DIn1V4y2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-__QUcEPJPo67Z-4xh9deBg-1; Thu, 01 Oct 2020 08:02:28 -0400
X-MC-Unique: __QUcEPJPo67Z-4xh9deBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FBE1018F84
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 12:02:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 216A255776;
        Thu,  1 Oct 2020 12:02:25 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] MAINTAINERS: Fix [An]drew's name
Date:   Thu,  1 Oct 2020 14:02:24 +0200
Message-Id: <20201001120224.72090-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 52a3eb6f764e..54124f6f1a5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -61,7 +61,7 @@ Architecture Specific Code:
 ---------------------------
 
 ARM
-M: Drew Jones <drjones@redhat.com>
+M: Andrew Jones <drjones@redhat.com>
 L: kvm@vger.kernel.org
 L: kvmarm@lists.cs.columbia.edu
 F: arm/*
-- 
2.26.2

