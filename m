Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBC65FDC18
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJMOJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 10:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiJMOJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 10:09:16 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B87E3B984
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:09:14 -0700 (PDT)
Date:   Thu, 13 Oct 2022 16:09:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665670153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m4OT6t/hF2QZxwP8g/89k5+woQDdrKhIkPj7KFIFu+M=;
        b=qoFO2n4LWMAwtxat68aciJa0fWzzXGCWd4h2xV6/hkJM+JDOHbIJOOSMXtTHYqbi3o53YQ
        kAsbsYGiqzf5850K4x5mWHS5Rhhq6qoWZHdKvpK+4zzDHf3k1BXe8Y3tFBnfnmKeyzeGy6
        ep5PtDI9xNBtPQMAHfNwOtgGL0FsQRU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oupton@google.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v9 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
Message-ID: <20221013140911.izpjfm72ar6nq2vs@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-9-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 01:06:22AM +0000, Ricardo Koller wrote:
> Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
> aarch64 to fix the alignment of parameters in a couple of calls. This will
> make it easier to fix the alignment in a future commit that adds an extra
> parameter (that happens to be very long).
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
>  .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
>  2 files changed, 30 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
