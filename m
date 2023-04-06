Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240596D8BF0
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 02:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbjDFAgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 20:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDFAgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 20:36:23 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298F47A81
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 17:36:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PsMxc1WWbz4xDt;
        Thu,  6 Apr 2023 10:36:20 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Neuling <mikey@neuling.org>
In-Reply-To: <20230330103224.3589928-1-npiggin@gmail.com>
References: <20230330103224.3589928-1-npiggin@gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: PPC: Book3S HV: Injected interrupt SRR1
Message-Id: <168074126988.3672916.619022230380161209.b4-ty@ellerman.id.au>
Date:   Thu, 06 Apr 2023 10:34:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 20:32:22 +1000, Nicholas Piggin wrote:
> I missed this in my earlier review and testing, but I think we need
> these in the prefix instruction enablement series before the final patch
> that enables HFSCR[PREFIX] for guests.
> 
> Thanks,
> Nick
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/2] KVM: PPC: Permit SRR1 flags in more injected interrupt types
      https://git.kernel.org/powerpc/c/460ba21d83fef766a5d34260e464c9ab8f10aa05
[2/2] KVM: PPC: Book3S HV: Set SRR1[PREFIX] bit on injected interrupts
      https://git.kernel.org/powerpc/c/6cd5c1db9983600f1848822e86e4906377b4a899

cheers
