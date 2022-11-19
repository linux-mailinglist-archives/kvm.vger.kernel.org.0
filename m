Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB612630DE7
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 10:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiKSJrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 04:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiKSJrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 04:47:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BCEA8C19
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 01:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=b8ZgT6RbBnzkNeTBc6ByTeeNsOPcRDCc7Qtn8enZgQI=; b=ovpqrfdbAdWToJhp1It+5aHqR8
        ZhfmxGimMKrUoQJ95YFjIIDm/ZZRFfnqbrngBwJAZivlNRjza2jIGdeGB7F4TIBOgmLGcnneF6CbA
        0CDX9o0Y+EqhLHhL/+O0fTJpKFLUoGqB1zvH5LwAQ8O6OSRLe31Bu8RqoeXhWDV8VF4yxdJEnafUt
        CIhLdGKSYzv5Rg82/KeZU000waB75VQ9nCuJemmU6IZk5sYf7OZGOmNaaiT162Gl45JZtk27ByAbU
        U48FboVHNAuQ3cY28r40TMY0326OzmAJu3M8Qiz2SjVKCMM8WzCA2LXNaS/5BPlgP8vkFCNewDTZC
        Spv7VEVg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-002Hug-TK; Sat, 19 Nov 2022 09:47:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-00035f-L5; Sat, 19 Nov 2022 09:46:59 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mhal@rbox.co
Subject: [PATCH 1/4] MAINTAINERS: Add KVM x86/xen maintainer list
Date:   Sat, 19 Nov 2022 09:46:56 +0000
Message-Id: <20221119094659.11868-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Adding Paul as co-maintainer of Xen support to help ensure that things
don't fall through the cracks when I spend three months at a time
travelling...

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 046ff06ff97f..89672a59c0c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11324,6 +11324,16 @@ F:	arch/x86/kvm/svm/hyperv.*
 F:	arch/x86/kvm/svm/svm_onhyperv.*
 F:	arch/x86/kvm/vmx/evmcs.*
 
+KVM X86 Xen (KVM/Xen)
+M:	David Woodhouse <dwmw2@infradead.org>
+M:	Paul Durrant <paul@xen.org>
+M:	Sean Christopherson <seanjc@google.com>
+M:	Paolo Bonzini <pbonzini@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	arch/x86/kvm/xen.*
+
 KERNFS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	Tejun Heo <tj@kernel.org>
-- 
2.35.3

