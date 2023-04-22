Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2836EBAE3
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDVSfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 14:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVSfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 14:35:43 -0400
Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0375E3
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 11:35:41 -0700 (PDT)
Date:   Sat, 22 Apr 2023 18:35:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682188539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqHKKzVd619eUW5V99I0Zi7xDOwX3Ifa7w2NnKl+cO8=;
        b=BxSY27xplIiTxuCK6fU6aZ9yGZZjB8S3YhPaThBG/5CW/pthxfqMrkm0NraCjpZ4mAmQ1f
        xsJ7HphmpatYUayPF+WX4uvoDea59JzXoXU+btVetns3y6JoFD7ilehZDU27xIv2A3MstM
        gPBeAqjj+7FVh4WRPBdIXxVKfvMkJmQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mostafa Saleh <smostafa@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
Message-ID: <ZEQo9+tuGhELAmU1@linux.dev>
References: <ZEAOmK52rgcZeDXg@thinky-boi>
 <417f815d-3cf1-45ea-eba7-83e42f249424@redhat.com>
 <1023162f05aac3b460effa4a7baa0760@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1023162f05aac3b460effa4a7baa0760@kernel.org>
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

On Sat, Apr 22, 2023 at 10:05:38AM +0100, Marc Zyngier wrote:
> On 2023-04-22 00:51, Paolo Bonzini wrote:
> > On 4/19/23 17:54, Oliver Upton wrote:
> > > Hi Paolo,
> > > 
> > > Here is v2 of the last batch of fixes for 6.3 (for real this time!)
> > > 
> > > Details in the tag, but the noteworthy addition is Dan's fix for a
> > > rather obvious buffer overflow when writing to a firmware register.
> > 
> > At least going by the Fixes tag, I think this one should have been
> > Cc'd to stable as well.  Can you send it next week or would you like
> > someone else to handle the backport?

Thanks for spotting that, I had a mental note to do so, but my memory is
fleeting at best :)

> Indeed, that's missing. But yes, backports are definitely on
> the cards, and we'll make sure all stable versions get fixed
> as soon as the fix hits Linus' tree.

Between this last batch of fixes for 6.3 and the 6.4 pull we've accrued
quite a backlog of stable-worthy patches, many of them are likely to be
nontrivial backports.

I'll do the config_lock series, and I can pick up the firmware reg fix
if nobody else is handling that backport.

Are you going to take a stab at the vCPU flags fix?

-- 
Thanks,
Oliver
