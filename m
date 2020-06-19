Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE42011C3
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405011AbgFSPoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:44:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29821 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404502AbgFSPod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjSxq7yztb/JRLpgt28mDLuXnBEGCZxUJIt/QDoQYsc=;
        b=apCpC7bd9zqYqGBqRAoZxbpqPyUIZ+Z73t6nbP8MlQgGY9+TdyWmpAxo0y84Ct3TOzCh4+
        laZhCY8B3j1rJexdWmKEEy81h/AgqXbqOoeMGDLue444b/j43oAPTGthRDrE2DRVIi1xK9
        gWeMB3zILCVbCymVVSbcABFu4Qt28SQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-u_WJo5xBO-eDPwwAQHJopw-1; Fri, 19 Jun 2020 11:44:30 -0400
X-MC-Unique: u_WJo5xBO-eDPwwAQHJopw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 396E581EDDB;
        Fri, 19 Jun 2020 15:43:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CFB160BF4;
        Fri, 19 Jun 2020 15:43:09 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-test PATCH 1/2] Revert "access: disable phys-bits=36 for now"
Date:   Fri, 19 Jun 2020 17:42:55 +0200
Message-Id: <20200619154256.79216-2-mgamal@redhat.com>
In-Reply-To: <20200619154256.79216-1-mgamal@redhat.com>
References: <20200619154256.79216-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 71de9c93fbdb15978ffa2f290dd120d3005a9292.

Now that guest_maxphyaddr < host_maxphyaddr patches are sent.
Revert this change in kvm-unit-test

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 504e04e..bf0d02e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,host-phys-bits
+extra_params = -cpu host,phys-bits=36
 
 [smap]
 file = smap.flat
-- 
2.26.2

