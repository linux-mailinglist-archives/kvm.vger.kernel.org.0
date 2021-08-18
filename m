Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB73F0518
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhHRNqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbhHRNq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 09:46:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859D1C061764;
        Wed, 18 Aug 2021 06:45:54 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4GqTgg1gpFz9sVw; Wed, 18 Aug 2021 23:45:51 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <20210805075649.2086567-1-aik@ozlabs.ru>
References: <20210805075649.2086567-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel v2] KVM: PPC: Use arch_get_random_seed_long instead of powernv variant
Message-Id: <162929392634.3619265.14874763094240884044.b4-ty@ellerman.id.au>
Date:   Wed, 18 Aug 2021 23:38:46 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Aug 2021 17:56:49 +1000, Alexey Kardashevskiy wrote:
> The powernv_get_random_long() does not work in nested KVM (which is
> pseries) and produces a crash when accessing in_be64(rng->regs) in
> powernv_get_random_long().
> 
> This replaces powernv_get_random_long with the ppc_md machine hook
> wrapper.

Applied to powerpc/next.

[1/1] KVM: PPC: Use arch_get_random_seed_long instead of powernv variant
      https://git.kernel.org/powerpc/c/2ac78e0c00184a9ba53d507be7549c69a3f566b6

cheers
