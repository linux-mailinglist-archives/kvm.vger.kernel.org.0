Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE527B39C
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgI1RuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgI1RuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=DOZfFRPVyC+pOeVZsy5QetzWnL2NYBRY8w0e8CElX6k=;
        b=F0WFuG4so93hQd+QyF71UN/yAioBSekyrHXHok0er5sQXPwVFZepQlR8CcOQBwyTPnAKya
        6Q5ikEogYKVThyCQ+i1BkSd7YjsLG2xNrK3UCJWSx3GfifuPeeOu7kbW7YTatiS8SY3jTG
        0TP4GXwE66SrLhFO52ImRpmCQSPqGeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-VqaATA2QMX67L2vkEzNuzw-1; Mon, 28 Sep 2020 13:50:08 -0400
X-MC-Unique: VqaATA2QMX67L2vkEzNuzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C27CF801AB1;
        Mon, 28 Sep 2020 17:50:04 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8576510013C0;
        Mon, 28 Sep 2020 17:50:03 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 01/11] runtime.bash: remove outdated comment
Date:   Mon, 28 Sep 2020 19:49:48 +0200
Message-Id: <20200928174958.26690-2-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
comment is no longer valid. Therefore let's remove it.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200825102036.17232-2-mhartmay@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c88e246..caa4c5b 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -53,9 +53,6 @@ skip_nodefault()
 
 function print_result()
 {
-    # output test results in a TAP format
-    # https://testanything.org/tap-version-13-specification.html
-
     local status="$1"
     local testname="$2"
     local summary="$3"
-- 
2.18.2

