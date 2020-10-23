Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD8297714
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754830AbgJWSeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754796AbgJWSeF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9RAo1p5Z3QHuNccDaVSZ9lEhBh3TGuTwN8hkmUR6Fw=;
        b=Xn/CXJbHQLDqvTwGjto5A2ieLmUwsxFkdov09erOIunRgDQM6cCnyowgDtOhkz7MznG0MX
        JA6LNgXJ2mTaakOxiyTPeYbkS/bjbjkUnPtjMn5Ht1lKFvIb9aHaDUq61DTBpCNZDc//gE
        Q6gZc1wGngLvB1spsQvUPo75RQOVoow=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ZjkYdkSuNL-7h7ecQesWmQ-1; Fri, 23 Oct 2020 14:34:02 -0400
X-MC-Unique: ZjkYdkSuNL-7h7ecQesWmQ-1
Received: by mail-qv1-f71.google.com with SMTP id k15so184074qvx.4
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f9RAo1p5Z3QHuNccDaVSZ9lEhBh3TGuTwN8hkmUR6Fw=;
        b=PllFPkD6vki9KjSEwU+PxtKxPL3hW+S5i29uHJpWgjDSzDfmKQYaIItHFb6zUYX3JY
         nr7NNh8/sqK85FaHM2ISQodzF+A7J9vYcGbt9OZH2ULX/tB1L513l8uQm5U1A3HEmIJY
         eXu4orsC63Jf965Nr5Xziv/0E4hl9DG9XkVqaV1Q9jgJ5+zIa4QsPagvABB/ynIfld0Z
         caS5/ZGsFeGcjEpZwLySNK/V9GiRMK2dL7900IfKlxiIpgdmK0MQRMpS6DQmZv2ikoYj
         l//kf8sp6kmVgUvjHVd9YwB7pxun866QdoAJkWKIuJdArWaZZ97aKciMTOPhBm1ZoWp2
         VHhg==
X-Gm-Message-State: AOAM532uVMXnBOc99HDig/hWzKR9elM1BX9CEFHHPI1oRIiIhnMPRhNp
        xQNfbYqADzMUpQGzegzu5VSISBrmJXQfgRs76KrOz8t9XZbLvite4yBMVY9SETOPVPsJdFe6u3N
        ue9l+Pr1Y9lh5
X-Received: by 2002:ac8:2f91:: with SMTP id l17mr3488387qta.252.1603478041961;
        Fri, 23 Oct 2020 11:34:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyay/GTLlaHShgebWAWLZqPirAfvX+bQW7w7XUQEvI4fD7jH+bC1CjDWb2H2QxOTagrC/TUKA==
X-Received: by 2002:ac8:2f91:: with SMTP id l17mr3488368qta.252.1603478041747;
        Fri, 23 Oct 2020 11:34:01 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:01 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 01/14] KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER
Date:   Fri, 23 Oct 2020 14:33:45 -0400
Message-Id: <20201023183358.50607-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It should be an accident when rebase, since we've already have section
8.25 (which is KVM_CAP_S390_DIAG318).  Fix the number.

Should be squashed into 1a155254ff937ac92cf9940d.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 76317221d29f..094e128634d2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6367,7 +6367,7 @@ accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
 
-8.25 KVM_X86_SET_MSR_FILTER
+8.27 KVM_X86_SET_MSR_FILTER
 ---------------------------
 
 :Architectures: x86
-- 
2.26.2

