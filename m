Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736BD7AA0E4
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjIUUuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjIUUth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:49:37 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E368E685;
        Thu, 21 Sep 2023 10:44:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RrqpW44ZDz4x5k;
        Thu, 21 Sep 2023 19:28:51 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Jordan Niethe <jniethe5@gmail.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, sachinp@linux.ibm.com
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
Subject: Re: [PATCH v5 00/11] KVM: PPC: Nested APIv2 guest support
Message-Id: <169528846875.874757.8861595746180557787.b4-ty@ellerman.id.au>
Date:   Thu, 21 Sep 2023 19:27:48 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 13:05:49 +1000, Jordan Niethe wrote:
> A nested-HV API for PAPR has been developed based on the KVM-specific
> nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API had
> to break compatibility to accommodate implementation in other
> hypervisors and partitioning firmware. The existing KVM-specific API
> will be known as the Nested APIv1 and the PAPR API will be known as the
> Nested APIv2.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[01/11] KVM: PPC: Always use the GPR accessors
        https://git.kernel.org/powerpc/c/0e85b7df9cb0c65f840109159ef6754c783e07a0
[02/11] KVM: PPC: Introduce FPR/VR accessor functions
        https://git.kernel.org/powerpc/c/52425a3b3c11cec58cf66e4c897fc1504f3911a9
[03/11] KVM: PPC: Rename accessor generator macros
        https://git.kernel.org/powerpc/c/2a64bc673133346a7a3bd163f2e6048bd1788727
[04/11] KVM: PPC: Use accessors for VCPU registers
        https://git.kernel.org/powerpc/c/7028ac8d174f28220f0e2de0cb3346cd3c31976d
[05/11] KVM: PPC: Use accessors for VCORE registers
        https://git.kernel.org/powerpc/c/c8ae9b3c6e7f22a4b71e42edb0fc3942aa7a7c42
[06/11] KVM: PPC: Book3S HV: Use accessors for VCPU registers
        https://git.kernel.org/powerpc/c/ebc88ea7a6ad0ea349df9c765357d3aa4e662aa9
[07/11] KVM: PPC: Book3S HV: Introduce low level MSR accessor
        https://git.kernel.org/powerpc/c/6de2e837babb411cfb3cdb570581c3a65576ddaf
[08/11] KVM: PPC: Add helper library for Guest State Buffers
        https://git.kernel.org/powerpc/c/6ccbbc33f06adaf79acde18571c6543ad1cb4be6
[09/11] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
        https://git.kernel.org/powerpc/c/dfcaacc8f970c6b4ea4e32d2186f2bea4a1d5255
[10/11] KVM: PPC: Add support for nestedv2 guests
        https://git.kernel.org/powerpc/c/19d31c5f115754c369c0995df47479c384757f82
[11/11] docs: powerpc: Document nested KVM on POWER
        https://git.kernel.org/powerpc/c/476652297f94a2e5e5ef29e734b0da37ade94110

cheers
