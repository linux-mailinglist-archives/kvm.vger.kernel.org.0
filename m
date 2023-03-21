Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7896C36F1
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCUQ3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCUQ3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:29:18 -0400
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CC29000
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:29:16 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:29:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679416153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kq9+N9QHigTIZJPGoarTcMFC8BV6VmA0s4hGrCXu9A8=;
        b=E7YkmmJOGc64rALiUiWchdtqPfUA3dJ3hk3qRbaFwceDz0W4NnR9uATOTkwJZXYHhwMS2Z
        ZffbweNa7z03FDpCGQ0PZROLG1HeIg5RTWOz6jGajiVWDMzgVEKlpeUQ+IsFKwrLJVSl19
        TmDqR9QjzfKs9ML7WndnqkKpbNBGdKg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH 02/11] KVM: arm64: Add a helper to check if a VM has ran
 once
Message-ID: <ZBnbVchNxHRchlE0@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-3-oliver.upton@linux.dev>
 <60fbd578-0391-98b1-d8d1-200a716e1500@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60fbd578-0391-98b1-d8d1-200a716e1500@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suzuki,

On Tue, Mar 21, 2023 at 09:42:25AM +0000, Suzuki K Poulose wrote:
> Hi Oliver,
> 
> On 20/03/2023 22:09, Oliver Upton wrote:
> > The test_bit(...) pattern is quite a lot of keystrokes. Replace
> > existing callsites with a helper.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 3 +++
> >   arch/arm64/kvm/pmu-emul.c         | 4 ++--
> 
> There is one more instance in arch/arm64/kvm/hypercalls.c at
> kvm_arm_set_fw_reg_bmap(). Is there a reason why that can't be replaced ?

Oops! Missed that one. I'll address it in v2.

-- 
Thanks,
Oliver
