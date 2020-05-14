Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0C1D3D66
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgENT0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:26:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38448 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727869AbgENT0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rY2cYf+JQwIw292enk42+PfnTxsr6TeBeQ3Eoug1TqY=;
        b=J/O/3AAwz543qHavoGJOOZ6D57jMhbg7CYW0ri/TI3Z8PFYeLlzPS/TE8h4/8xPBhqS9JT
        WuUlahcQQz0ceEVBDQ2MgeoZy3uhqWpJbDTOfqGzcgaVtbb+sXlVEKZBnz10Ssug3USVam
        dtujEGjIpw0fySqtppbWylXi8lGq5fc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-3ZyGTTl2MNCVgZr3BK1Bpg-1; Thu, 14 May 2020 15:26:41 -0400
X-MC-Unique: 3ZyGTTl2MNCVgZr3BK1Bpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA108872FE0;
        Thu, 14 May 2020 19:26:40 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5507C5C1D6;
        Thu, 14 May 2020 19:26:32 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 01/11] x86/access: Fix phys-bits parameter
Date:   Thu, 14 May 2020 21:26:16 +0200
Message-Id: <20200514192626.9950-2-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mohammed Gamal <mgamal@redhat.com>

Some QEMU versions don't support setting phys-bits argument directly.
This causes breakage to Travis CI. Work around the bug by setting
host-phys-bits=on

Fixes: 1a296ac170f ("x86: access: Add tests for reserved bits of guest physical address")

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index bf0d02e..d43cac2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,phys-bits=36
+extra_params = -cpu host,host-phys-bits=on,phys-bits=36
 
 [smap]
 file = smap.flat
-- 
2.18.1

