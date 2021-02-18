Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D131EC0E
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhBRQLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:11:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhBRNRd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 08:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613654160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x1InpcjNtn1WO1uMr7ydGzVJe3PkHnP+TrsVrmd764k=;
        b=FcK5y7vRtPZDPrw7KF24uqUPfbe5BQYBE7x/lcUmMZcMdkn4cVBAsSqmllAjEn1yBZzPzO
        JlQ3cMxuZ64mX+LzBuGdda373L2dBF0liu89f54fxwphNPBB8I+hzOhT9QZiY5ca2CrsJW
        F3vyWc3r9ZmDxrJ1D3WkuyNTWBJ7P/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-10RtWFfOPgO36-bSX8_3_A-1; Thu, 18 Feb 2021 08:15:56 -0500
X-MC-Unique: 10RtWFfOPgO36-bSX8_3_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9211835E3C
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 13:15:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CA7F50EDF
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 13:15:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmx: make !EPT error messages consistent
Date:   Thu, 18 Feb 2021 08:15:54 -0500
Message-Id: <20210218131554.1396965-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always add a \t at the beginning and a \n at the end.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f9883f0..bbb006a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1032,11 +1032,11 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 {
 	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_EPT)) {
-		printf("\tEPT is not supported");
+		printf("\tEPT is not supported\n");
 		return 1;
 	}
 	if (!(ept_vpid.val & EPT_CAP_WB)) {
-		printf("WB memtype for EPT walks not supported\n");
+		printf("\tWB memtype for EPT walks not supported\n");
 		return 1;
 	}
 	if (!(ept_vpid.val & EPT_CAP_PWL4)) {
-- 
2.26.2

