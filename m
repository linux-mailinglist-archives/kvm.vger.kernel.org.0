Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332AB72B5B7
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjFLDIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjFLDIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:08:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C9E68;
        Sun, 11 Jun 2023 20:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fOE6Ra8njD0psF8yweu+6OMqM09Aiea1FRmZ+yo9rtc=; b=LZsIqmVCqBomAQFE39iASpfFOt
        CM38Ky0Ly+ZCS3U2b0+G7kY6yDed/sgKixwmb66WOEZ/mtIUIuteGq1QXzuvUPi6ocyhXWwd1MjKn
        p+3o6x4wA7zkGWFjGGqZ/b66SZBJUiiWme3MPXPsuop5bl9VqA3N5jfnFRJSaB8PQi0DhIWUq7uak
        KYL6owcb0nwL5wkTT10qvsYRKyoknOs+huuLmrPdOmnjMAquvXrXMcdRBIgH0jCZS5P4MJuaP/Vr6
        NFhwJQYO9IinRb2Id/Yi7cgwDjMs1fIHKAFwClHuPUDaxTPrkFfjTGJnzFGKbd7jG7PvaxDS75lcC
        9qHE2iMA==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8Xug-002P78-2c;
        Mon, 12 Jun 2023 03:08:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/4] Documentation: KVM: make corrections to vcpu-requests.rst
Date:   Sun, 11 Jun 2023 20:08:10 -0700
Message-ID: <20230612030810.23376-5-rdunlap@infradead.org>
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

Make corrections to punctuation and grammar.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/virt/kvm/vcpu-requests.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -- a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -101,7 +101,7 @@ also be used, e.g. ::
 
 However, VCPU request users should refrain from doing so, as it would
 break the abstraction.  The first 8 bits are reserved for architecture
-independent requests, all additional bits are available for architecture
+independent requests; all additional bits are available for architecture
 dependent requests.
 
 Architecture Independent Requests
@@ -151,8 +151,8 @@ KVM_REQUEST_NO_WAKEUP
 
   This flag is applied to requests that only need immediate attention
   from VCPUs running in guest mode.  That is, sleeping VCPUs do not need
-  to be awaken for these requests.  Sleeping VCPUs will handle the
-  requests when they are awaken later for some other reason.
+  to be awakened for these requests.  Sleeping VCPUs will handle the
+  requests when they are awakened later for some other reason.
 
 KVM_REQUEST_WAIT
 
