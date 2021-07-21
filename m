Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC293D1589
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhGURLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 13:11:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhGURLn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 13:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626889939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V0nt+n4q6n0RxekQsRBmQ7ZNs4jdMJ0l4IHy8vbT5Go=;
        b=K2wSrXUIglcmpzqduyW6Dw14L/dIoA1YlQLEpbGN/TDokx0dxlQ3abB2tfQp75JK2PRsDS
        4oKatVrwlaqc9lLNiG9fb40NClS969t0YeP33gRob3WIZeF9oBGfT3zfpVMB7q9hRb5reF
        egdnFYNvFa8BUAryNT6OX3FTBxnTTQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-Mq6STnKCO1yk5HzOtVef4A-1; Wed, 21 Jul 2021 13:52:05 -0400
X-MC-Unique: Mq6STnKCO1yk5HzOtVef4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78316800D62;
        Wed, 21 Jul 2021 17:52:04 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BC0260854;
        Wed, 21 Jul 2021 17:51:58 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: s390x: remove myself as maintainer
Date:   Wed, 21 Jul 2021 19:51:57 +0200
Message-Id: <20210721175157.4104-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests for s390x is nowadays in a pretty good shape and in even
better hands. As I've been mostly only reviewing selected patches
lately because other projects are more important, and Thomas and Janosch
have been handling PULL requests for a long time now without me, remove
myself as maintainer.

But I want to know what's happening, so keep me added as a reviewer --
so I can continue reviewing selected patches :)

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aaa404c..89b21c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -82,10 +82,10 @@ F: lib/ppc64/*
 
 S390X
 M: Thomas Huth <thuth@redhat.com>
-M: David Hildenbrand <david@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
 R: Cornelia Huck <cohuck@redhat.com>
 R: Claudio Imbrenda <imbrenda@linux.ibm.com>
+R: David Hildenbrand <david@redhat.com>
 L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
 F: s390x/*
-- 
2.31.1

