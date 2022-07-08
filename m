Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA856C302
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbiGHTeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 15:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiGHTd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 15:33:59 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4693101D7
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 12:33:57 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:33:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657308835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UvsXJEG9CqDhZlAkduXKwdOpQV4TuAtiKD98aN6QoR4=;
        b=MOIeH5Qx8XM9bKH7gcUX6UVc0q9d9VoT4qCEl+P/TkisvUkENUSmfb0ItDEnLaAeBzvdCv
        hTtvWEHy/DPDX/iPBJ3eDLJtOpQsuuCvTjAIjkKlmOvEVTep+M6iBb9cxI9rZlRAm0vAQx
        Qz7ZhcPUnCWYSu8Jyzv2V7DQrA4t8N0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: Re: [PATCH 05/19] KVM: arm64: Consolidate sysreg userspace accesses
Message-ID: <YsiGnbQpWU1cl0bl@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Jul 06, 2022 at 05:42:50PM +0100, Marc Zyngier wrote:
> Until now, the .set_user and .get_user callbacks have to implement
> (directly or not) the userspace memory accesses. Although this gives
> us maximem flexibility, this is also a maintenance burden, making it

typo: maximum

> hard to audit, and I'd feel much better if it was all located in
> a single place.
> 
> So let's do just that, simplifying most of the function signatures
> in the process (the callbacks are now only concerned with the
> data itself, and not with userspace).

Much cleaner!

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
