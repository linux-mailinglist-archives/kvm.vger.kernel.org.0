Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E88324247
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhBXQj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:39:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235413AbhBXQhX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 11:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqZRAPirmJd947ZkT/vhl+S217xyAEtnFK5UWHoVomY=;
        b=JwUF94hp8/4pSUIWFGjiVWYu+c21PcPlUaYwdLCk6toaredmYcqJ0R078fb3LTFvYMh8Tw
        SJrR1zBHaa99M8b1tLpMLlKkLD4bvjvLDzhn5SvhTcufv8jNmuTZquar1oC1Et7Bjna3Tc
        oBX77mBpiXIFYH21TcH/KkbpVpnf+oA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-nRvDkyCnONW6lOuAscryGg-1; Wed, 24 Feb 2021 11:35:55 -0500
X-MC-Unique: nRvDkyCnONW6lOuAscryGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 126F7107ACE6
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:35:54 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 069ED19C46;
        Wed, 24 Feb 2021 16:35:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm-unit-tests v2 3/4] x86: hyperv_stimer: don't require hyperv-testdev
Date:   Wed, 24 Feb 2021 17:35:46 +0100
Message-Id: <20210224163547.197100-4-vkuznets@redhat.com>
In-Reply-To: <20210224163547.197100-1-vkuznets@redhat.com>
References: <20210224163547.197100-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'hyperv-testdev' is completely superfluous for stimer tests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0698d157276c..176f9e80b013 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -361,7 +361,7 @@ groups = hyperv
 [hyperv_stimer]
 file = hyperv_stimer.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
+extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer
 groups = hyperv
 
 [hyperv_clock]
-- 
2.29.2

