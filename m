Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26C56C323
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbiGHTUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 15:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGHTU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 15:20:29 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC031B7B1
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 12:20:27 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:20:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657308026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ce9I51hIbs9Z/U1FMq7ylQYjRrpFbV3lrcD9ud+ZtUY=;
        b=nni5m67niu1sIBms4nFqs5MRgsnvB28TnAbmD53TKH6yQRILHmUBXxCP/+ZbuX4+uS/lgU
        wl72YkUO5ajRxudvYVQTDxb0llI6uzEwt+FIfntI5LLSWAFPc3cBPZKetwz1DoR+P/hdoB
        Jrn4rviZlLBuV04gGoJj4RPXX4tHhCc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: Re: [PATCH 03/19] KVM: arm64: Introduce generic get_user/set_user
 helpers for system registers
Message-ID: <YsiDdbREzX/ATbBn@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 05:42:48PM +0100, Marc Zyngier wrote:
> The userspace access to the system registers is done using helpers
> that hardcode the table that is looked up. extract some generic
> helpers from this, moving the handling of hidden sysregs into
> the core code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
