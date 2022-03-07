Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2964D041A
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244165AbiCGQ3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 11:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiCGQ3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 11:29:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B6FE5044C
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 08:28:22 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63DE0153B;
        Mon,  7 Mar 2022 08:28:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50A483FA45;
        Mon,  7 Mar 2022 08:28:19 -0800 (PST)
Date:   Mon, 7 Mar 2022 16:28:44 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
Message-ID: <YiYyqvwp3xkieF6S@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
 <YiYcLIhdo5fQFbSA@monolith.localdoman>
 <c084f234eff61b0ab8da5716879745e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c084f234eff61b0ab8da5716879745e2@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Mar 07, 2022 at 03:48:19PM +0000, Marc Zyngier wrote:
> On 2022-03-07 14:52, Alexandru Elisei wrote:
> > Hi,
> > 
> > I was under the impression that KVM's nested virtualization doesn't
> > support
> > AArch32 in the guest, why is the subject about hyp mode aarch32 timers?
> 
> Where did you see *ANY* mention of AArch32?

I saw an implicit mention of aarch32 when the commit message used the term
"hyp", which is the name of an aarch32 execution mode.

> 
> Or is that a very roundabout way to object to the 'hyp' name?

Bingo.

> If that's the case, just apply a mental 's/hyp/el2/' substitution.

I'm a bit confused about that. Is that something that anyone reading the patch
should apply mentally when reading the patch, or is it something that you plan
to change in the commit subject?

Thanks,
Alex
