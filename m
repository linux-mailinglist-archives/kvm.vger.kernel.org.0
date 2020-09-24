Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63775277663
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIXQQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbgIXQQc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=4VyDfcbQv6DSbladqxeJEZpto2qmswqxERuS2zfS0lw=;
        b=TF8YmhqRbUInoZ0G4UO5W87dUoOa9QHGqWOEqXm8E08+KJlm4NcKoK+/J5+etire9Yrywq
        gtbBwBGHTdaSoTEtst1SKVg6rLSRqiows5wtGyW7kMkKvB1ICQaNWgZ6hRcNhk31F5h1Sh
        SCsFtDFTM/pPUTU2j7bKGfqIQmgdMb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-o9Y1iHGiON2Zz_eDRt3LTQ-1; Thu, 24 Sep 2020 12:16:29 -0400
X-MC-Unique: o9Y1iHGiON2Zz_eDRt3LTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E27164099;
        Thu, 24 Sep 2020 16:16:28 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C39CD73662;
        Thu, 24 Sep 2020 16:16:24 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 1/9] travis.yml: Update from Bionic to Focal
Date:   Thu, 24 Sep 2020 18:16:04 +0200
Message-Id: <20200924161612.144549-2-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newer version of QEMU in Focal should help to run more tests
with TCG (which will be enabled in later patches).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index 2e5ae41..3b18ce5 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,4 @@
-dist: bionic
+dist: focal
 language: c
 cache: ccache
 git:
-- 
2.18.2

