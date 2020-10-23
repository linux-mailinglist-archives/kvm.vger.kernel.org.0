Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA232976F3
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754848AbgJWSeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754834AbgJWSeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JBSwivOieEBkLj+y5xNLmYzl5BJ4oB5HgP2xMsJ50A=;
        b=DtciYj2ptGdJopFzcU+4Kn/c6PmfpohvsPENpDKCkyKLGK+rQvawxOu/4GKgHbo+MPzLWN
        eb+cKN2M72hqH+Ce6smHj8O5b6OI2FhwgopqoJyRdnY2bNRDoAtMCMXSrwazfDMt75cz5I
        ppph8iEbpM9phskzyTi1jPiGzbiLEI4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-cgx_hfIuOwKM7hTLEJJBDQ-1; Fri, 23 Oct 2020 14:34:06 -0400
X-MC-Unique: cgx_hfIuOwKM7hTLEJJBDQ-1
Received: by mail-qv1-f71.google.com with SMTP id s8so1529663qvv.18
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+JBSwivOieEBkLj+y5xNLmYzl5BJ4oB5HgP2xMsJ50A=;
        b=nAjUkR4miLP0WYUWdxvQwmZBeKOPJTUpSxn0B2ScPX+GsA6cYRq6QMhYZ0UBGr7ysQ
         46s0gFakmNhV34pKz2pik/SNuwpydMHqswJWNlWmjBikLcAQyWaoURQ8tExv90CyIw5Y
         1wg6nH0r4o1jgHrDwM+ZImhT74AM0ELtHHqm2p8FmwD4NT0v5leLri7w9wW0QjswoaVy
         Yr6uqDH3favM+ZALNrjuPwm7V9eCnWnTo5OhVvxTCrCe+zcOpvN1bOcP/NrhAB9X2dgw
         bpjH3/zx7zL7ya4IjuC/jarFRd1tPJHowXJPzZTKzkEwUjodd/rCaWshuJ2842nzTLqI
         baYA==
X-Gm-Message-State: AOAM533YkHAAStpzL9efWbYpCwND8a2OntWQ3lbtM8E5d9vx41pZC1E/
        A37uWG8WBTU6gCWlO3j0nrpvFLNbXcTxuMQ5Tg0wuDjmchszFylr7VCrj44D98XIhZFbEJZ1XtS
        Ja8ckS91xqLQL
X-Received: by 2002:ae9:f305:: with SMTP id p5mr3428365qkg.481.1603478045562;
        Fri, 23 Oct 2020 11:34:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyotm8QmAhrS0v/p7J+qOW64NCqV+9LILBDSp3tkCimtWR3nIRvM9TECufCj/QUX+Vhg4d9ZA==
X-Received: by 2002:ae9:f305:: with SMTP id p5mr3428213qkg.481.1603478043405;
        Fri, 23 Oct 2020 11:34:03 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 02/14] KVM: Documentation: Update entry for KVM_CAP_ENFORCE_PV_CPUID
Date:   Fri, 23 Oct 2020 14:33:46 -0400
Message-Id: <20201023183358.50607-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should be squashed into 66570e966dd9cb4f.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 094e128634d2..f78307e77371 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6381,8 +6381,7 @@ In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
 trap and emulate MSRs that are outside of the scope of KVM as well as
 limit the attack surface on KVM's MSR emulation code.
 
-
-8.26 KVM_CAP_ENFORCE_PV_CPUID
+8.28 KVM_CAP_ENFORCE_PV_CPUID
 -----------------------------
 
 Architectures: x86
-- 
2.26.2

