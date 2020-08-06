Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4591323DE0B
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHFRVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:21:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730267AbgHFRQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFwy7e2/BEqkhEQtkFfwSeARVG8Dp3lgZH+uIout38Q=;
        b=DHn4MoURhq49EqHO1QDNa2kONPcRKjKPddgg36qfaitIM2XSOH6pHuccR3ruFkahLTqZWC
        QTZSbBnlbKKcy0fZki0ZQJ7Bp/c0mUGvrpQzyyvhloOnkLhMMVzXXrGpboH2ACri1m3G8q
        uZuTN8aJx1T8dbDv7luf8OpDdu0xHrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-an0cKzITPa-P4KJwKUGBlA-1; Thu, 06 Aug 2020 08:44:22 -0400
X-MC-Unique: an0cKzITPa-P4KJwKUGBlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61CFBA4769;
        Thu,  6 Aug 2020 12:44:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16B5F5C1BD;
        Thu,  6 Aug 2020 12:44:08 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Mohammed Gamal <m.gamal005@gmail.com>
Subject: [kvm-unit-tests PATCH 1/3] unittests.cfg: Increase timeout for access test
Date:   Thu,  6 Aug 2020 14:43:56 +0200
Message-Id: <20200806124358.4928-2-mgamal@redhat.com>
In-Reply-To: <20200806124358.4928-1-mgamal@redhat.com>
References: <20200806124358.4928-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

In case of npt=0 on kvm_amd, tests run slower and timeout,
so increase the timeout. The tests then do succeed.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3a79151..4fa42fa 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -117,6 +117,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 file = access.flat
 arch = x86_64
 extra_params = -cpu host,host-phys-bits
+timeout = 180
 
 [smap]
 file = smap.flat
-- 
2.26.2

