Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB1967F2D6
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjA1AO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjA1AOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:14:43 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460047B7A4;
        Fri, 27 Jan 2023 16:14:40 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:14:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674864878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGaeFUGsY+6rt83U5mh2TKehFjF1vFRLmfOY7UCFQ/I=;
        b=pNhbow7uuLKcjf8GjIlH4ZXZVFW+eGn1TQv6s84utXqrl5IMaqY0MLjFWh+RPOCyb8ix/m
        t/xU3YchLxx9v6anaCF0TsOqK3YFH9+e1fUV3Gao6b4JXfJrZqFPEpWdet4D0vLvfsmi3l
        JZoapCY84ZSz8/qDRs6AmgJQp0ei5c4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, yuzhe@nfschina.com,
        seanjc@google.com, isaku.yamahata@intel.com, ricarkol@google.com,
        eric.auger@redhat.com, renzhengeek@gmail.com, reijiw@google.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH v4 1/4] KVM: arm64: Include kvm_mmu.h from vgic.h
Message-ID: <Y9Ro6IEjPVeQfmUQ@google.com>
References: <20230127235150.17025-1-gshan@redhat.com>
 <20230127235150.17025-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127235150.17025-2-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 07:51:47AM +0800, Gavin Shan wrote:
> We need a unified helper in 'kvm/vgic/vgic.h' to write guest memory. In
> the helper, the check of no-running-vcpu context for dirty ring will be
> applied. kvm_write_guest_lock(), defined in 'include/asm/kvm_mmu.h', is
> going to be dereferenced by the unified helper.
> 
> Include 'include/asm/kvm_mmu.h' to 'kvm/vgic/vgic.h' to avoid including
> the former header file when the later one is needed. With the change,
> the duplicate inclusions of 'include/asm/kvm_mmu.h' are removed.
> 
> No functional change intended.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>

No, I did not suggest for you to do this. I had suggested you just
include asm/kvm_mmu.h from the vgic header, not to go and remove it from
all the files that include vgic.h.

Who cares if kvm_mmu.h gets included twice? Include guards exist for this
exact reason.

-- 
Thanks,
Oliver
