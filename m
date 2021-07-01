Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752AF3B8BB6
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 03:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhGABS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 21:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhGABS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 21:18:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B7C0617A8
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4nZly+HxJMQ950EhlHUpBhY6by/McA6MbPri8IWpeAw=; b=YfkdQ/ZkKMN+ctaGyH9/dMZbMZ
        xZwTPKWcnrfgUaWFWaMc4jvhORUL4U8+GXo76hpwjSPugfbqvtug4WZUUwtM7702F6gb9at9iZCKJ
        gqJ4IHnFelkX29odbctRdaNeF8D0QLaAiUIkaHX6TGzYIaX4oRof4tXeL4Yupy2HZYuPjmISlmmZz
        AdRzOxgVdPOjIK/sxPujJSS7QS/t5tapD8mnc8dXddW0o84TzbJ1COiB/ebp91WFmXzF4vib8qZX2
        rykgESrW9mumZqrIPlRQ60b01Vp3Dpk4RoLptdrO5KY01PElFG3VAd3r9JMpq/N3uA6crYpKaSBLj
        UhMkglhw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lylIz-00603z-Vc; Thu, 01 Jul 2021 01:15:58 +0000
Date:   Thu, 1 Jul 2021 02:15:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>, Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <YN0XRZvCrvroItQQ@casper.infradead.org>
References: <20210630214802.1902448-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021 at 09:47:56PM +0000, David Matlack wrote:
> This patch series adds support for the TDP MMU in the fast_page_fault

Nowhere in this message do you explain what the TDP MMU is.
