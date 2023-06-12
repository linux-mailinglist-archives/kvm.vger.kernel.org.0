Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9608472B5B2
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjFLDIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjFLDIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:08:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AB4E5F;
        Sun, 11 Jun 2023 20:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kYsaDINwgGyBkCQoDFNAkvO4v5df2UfOXAdRONE+VsA=; b=cuhGQNGphwJUwp0UMhVoYyu2tM
        H9F7lOZDO201p3qw3R1q8bQtHyuWu0Ww+eKkYHBp2SnCKuOjfD6kgi6m69yXk4p8uoAisA9qsHuMv
        NZ+EO4hMOMVyYXlSs63l3oG5dPiJ78trxjJexR5Sfy8VX8lTb2HSP6n5JCMPs1BrMk2t353Ht4z7y
        ajHHQh6qV3BcUH7Np9z/Hyh/VfcsEyJLb2dEfJQ7sbKUTpS2sgvFs+l5wj+LyR9ojtmX1GZtq1CuV
        93PdN6DAikYuO8xL+WRqN403rR53yreatar8GTfojD5i+4Meicwk0sy7/jFlbJgYm2fwuoD1f6VgC
        oUxdexdQ==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8Xuf-002P78-1j;
        Mon, 12 Jun 2023 03:08:13 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/4] Documentation: KVM: make corrections to halt-polling.rst
Date:   Sun, 11 Jun 2023 20:08:07 -0700
Message-ID: <20230612030810.23376-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612030810.23376-1-rdunlap@infradead.org>
References: <20230612030810.23376-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Module parameters are in sysfs, not debugfs, so change that.

Remove superfluous "that" following "Note:".
Hyphenate "system-wide" values.
Hyphenate "trade-off".

Don't treat "denial of service" as a verb.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/virt/kvm/halt-polling.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -- a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
--- a/Documentation/virt/kvm/halt-polling.rst
+++ b/Documentation/virt/kvm/halt-polling.rst
@@ -112,11 +112,11 @@ powerpc kvm-hv case.
 |			| function.		    |			      |
 +-----------------------+---------------------------+-------------------------+
 
-These module parameters can be set from the debugfs files in:
+These module parameters can be set from the sysfs files in:
 
 	/sys/module/kvm/parameters/
 
-Note: that these module parameters are system wide values and are not able to
+Note: these module parameters are system-wide values and are not able to
       be tuned on a per vm basis.
 
 Any changes to these parameters will be picked up by new and existing vCPUs the
@@ -142,12 +142,12 @@ Further Notes
   global max polling interval (halt_poll_ns) then the host will always poll for the
   entire block time and thus cpu utilisation will go to 100%.
 
-- Halt polling essentially presents a trade off between power usage and latency and
+- Halt polling essentially presents a trade-off between power usage and latency and
   the module parameters should be used to tune the affinity for this. Idle cpu time is
   essentially converted to host kernel time with the aim of decreasing latency when
   entering the guest.
 
 - Halt polling will only be conducted by the host when no other tasks are runnable on
   that cpu, otherwise the polling will cease immediately and schedule will be invoked to
-  allow that other task to run. Thus this doesn't allow a guest to denial of service the
-  cpu.
+  allow that other task to run. Thus this doesn't allow a guest to cause denial of service
+  of the cpu.
