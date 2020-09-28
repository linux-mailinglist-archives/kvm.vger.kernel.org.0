Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D027B39E
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgI1RuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgI1RuR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8s73DBEwfUJyOef9kIF/6IX60LH6lIK9HLhlRVM93Mk=;
        b=QdQimiFNBdmD0Hd3BoR9MReCWKDBJaWMyFI0Y7gZvN2cpOxcXVBJ3qnD6wwmNToKA+Ie3K
        BqxSwrKP1GpSuTsWhEAmwXavZSBVBmy7B13JKuGTSR5GcbHZ/OqUKW4T2hjnuDhQPBLKyW
        TvJ63e5cgGBh7TvM7XPPzc/Z/MgBNeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-oYQU8qBpOiu14DrlP8OAAQ-1; Mon, 28 Sep 2020 13:50:11 -0400
X-MC-Unique: oYQU8qBpOiu14DrlP8OAAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 855791019632;
        Mon, 28 Sep 2020 17:50:10 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10BF710013C0;
        Mon, 28 Sep 2020 17:50:08 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 04/11] travis.yml: Update from Bionic to Focal
Date:   Mon, 28 Sep 2020 19:49:51 +0200
Message-Id: <20200928174958.26690-5-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newer version of QEMU in Focal should help to run more tests
with TCG (which will be enabled in later patches).

Message-Id: <20200924161612.144549-2-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index b497264..4b7947c 100644
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

