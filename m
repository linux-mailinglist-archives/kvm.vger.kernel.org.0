Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D626EB21E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 21:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjDUTKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 15:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjDUTKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 15:10:52 -0400
Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2699018C
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 12:10:51 -0700 (PDT)
Date:   Fri, 21 Apr 2023 19:10:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682104248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5kEUXy1CbokJdFdrH1CrGU/uDHVVqhx84Ypt0F7BYAo=;
        b=Y7ZvjFKD+R8zgE2XnA/bZAD1IJEau2l6Ayo2f2VjDJPuxebqWWS72OpttJluJLDXnJZ/PD
        cM53xM+dV3me3eHXpkRZIfvtwFrTqe/AKABpZ5G8gLfdU+QYNFsnEn9cExgbDpZzKGhk7j
        MCxNrI9OR+bH04II9To+qmCOvq7uFCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anup Patel <anup@brainfault.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Getting the kvm-riscv tree in next
Message-ID: <ZELftWeNUF1Dqs3f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anup,

I was recently poking around on linux-next and noticed that kvm-riscv
isn't included in it.

Having all of the KVM ports represented in -next is quite beneficial, as
it gives us an early signal to any conflicts that may arise between our
trees. Additionally, Linus likes to see that patches have been sitting
in -next for a while, and is generally suspicious of any content applied
immediately before the merge window. I've also noticed that for the past
few kernel release cycles you've used an extremely late rc (i.e. -rc7 or
-rc8), which I fear only draws more scrutiny.

So, in the interest of greasing the wheels of KVM maintenance, could you
consider doing the following:

 - Apply patches well in advance of the upcoming merge window on an
   early -rc. At least for KVM/arm64 we tend to base things on -rc3,
   allowing for a few weeks of soak time in -next.

 - Ask Stephen to include your tree in linux-next.

As I said, I just care about reducing friction in KVM, so hopefully this
doesn't come off as though I'm policing your tree.

-- 
Thanks,
Oliver
