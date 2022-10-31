Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D26613265
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 10:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJaJTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 05:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaJTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 05:19:01 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE27BBE15
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 02:18:59 -0700 (PDT)
Date:   Mon, 31 Oct 2022 09:18:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667207937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UNUd2hX0hdMkIdzwLXRZNRwHJG+w0L3BFPgCSF2V2h4=;
        b=CaGONynma9CEbwNZEVDG+yImQsIJB5eeX0/0rXtRLfnfNR59VQBxdGKz6OlFPOb+BKcSaZ
        1R55TELwMkeAGgecUypT465F9EutTVn2+LKfa+q0uToOuYVa05UhmGaWelJJn3Hobqz5kz
        jptzmt0+r8P9aPbHrF1iijrimPgKgtM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL}
 prior to enabling them
Message-ID: <Y1+S9FC6GTpYehwJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-4-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 08:36:15AM +0800, Gavin Shan wrote:
> There are two capabilities related to ring-based dirty page tracking:
> KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL. Both are
> supported by x86. However, arm64 supports KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> only when the feature is supported on arm64. The userspace doesn't have
> to enable the advertised capability, meaning KVM_CAP_DIRTY_LOG_RING can
> be enabled on arm64 by userspace and it's wrong.
> 
> Fix it by double checking if the capability has been advertised prior to
> enabling it. It's rejected to enable the capability if it hasn't been
> advertised.
> 
> Fixes: 17601bfed909 ("KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

This patch should be picked up separate from this series for 6.1. The
original patch went through kvmarm and I think there are a few other
arm64 fixes to be sent out anyway.

Marc, can you grab this? :)

--
Thanks,
Oliver
