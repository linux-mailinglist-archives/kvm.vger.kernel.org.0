Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373221ACC61
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409097AbgDPP7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:59:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35812 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2897266AbgDPP7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 11:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JPDoCdd6Mz59gLMUCJpo/feFNXBVnhyS3Hu+/K7Ll1U=;
        b=LCyd/RWndwnvee4TIChxTMW99flEu5b1sPnTViC8n2VP4gKIx/fyB2t/0w7KqR/jE9jKUA
        ccoZW3AoHviIvmX+rMPpslHb3mDNXbFrmuKCpc8fylMO/vK+PzpveP216CzIHc2k4judb0
        g4Bv30LtbORuLaG6kIiuWOhRUPyaSeQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-yWAsYfmxMnGf3UJc5L98BA-1; Thu, 16 Apr 2020 11:59:16 -0400
X-MC-Unique: yWAsYfmxMnGf3UJc5L98BA-1
Received: by mail-qk1-f197.google.com with SMTP id k13so2563285qkg.2
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JPDoCdd6Mz59gLMUCJpo/feFNXBVnhyS3Hu+/K7Ll1U=;
        b=Pq/eTLXVx77P0EPa0ta4W8vW6DKhVOAjeByvtWwjIPdH9zfwzIq9V4heEo0Wgw03R9
         dxQjatwyFCkU98ENt4/pJQQdjIT6qSfSTaOXZyWk5i3DDYEM9HTWVGYftyCFYdEaOcul
         AYkDTwdLJ0G3K/ZDKCr7+Q1fFWpSV99sbTDBPmP1Xw83mtkpxEsDQwsR0vy+g+Oc2I9H
         LC8oVxIegVTXwK65XvnMu4TV6j8KrAZ+cDgZAgAcMKEIjOzpRg+439T+dt416bMfcjo/
         gpZOjH69nbccP/YgMEBy45svNg7LZIkn8U24Nu/zahGBfmf4gnjcCmJgU+qzTtfqdyyf
         JRGA==
X-Gm-Message-State: AGi0PuYFXaWS/zif96uTmIoc0sizWE6ZXK8krMbCpjYfbTdWED2xPhZJ
        61AdyaBIRN5xFFCVE/VSkGrq9081o8NhQPiK+3/0dhosuuOcMX1aIks5eneT5zH4jVMF5PAfQlQ
        V2lSzuOn0KPjw
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr9997820qve.211.1587052755355;
        Thu, 16 Apr 2020 08:59:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypK+7QOzQNp7II51CKMz7W9yt//0mr5pcpNxTmnKALRjFnlpuLVkr+q9GhnPW+9sTClwrKTJRw==
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr9997807qve.211.1587052755176;
        Thu, 16 Apr 2020 08:59:15 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c41sm12164124qta.96.2020.04.16.08.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:59:14 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: Documentation: Fix up cpuid page
Date:   Thu, 16 Apr 2020 11:59:13 -0400
Message-Id: <20200416155913.267562-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

0x4b564d00 and 0x4b564d01 belong to KVM_FEATURE_CLOCKSOURCE2.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..f721c89327ec 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -50,8 +50,8 @@ KVM_FEATURE_NOP_IO_DELAY          1           not necessary to perform delays
 KVM_FEATURE_MMU_OP                2           deprecated
 
 KVM_FEATURE_CLOCKSOURCE2          3           kvmclock available at msrs
-
                                               0x4b564d00 and 0x4b564d01
+
 KVM_FEATURE_ASYNC_PF              4           async pf can be enabled by
                                               writing to msr 0x4b564d02
 
-- 
2.24.1

