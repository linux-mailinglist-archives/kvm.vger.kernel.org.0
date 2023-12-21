Return-Path: <kvm+bounces-5042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF5781B423
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23045B2395A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20F36979B;
	Thu, 21 Dec 2023 10:45:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F056A011;
	Thu, 21 Dec 2023 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SwnCN0Kd0z4xdZ;
	Thu, 21 Dec 2023 21:45:52 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH 00/12] KVM: PPC: Nested APIv2 : Performance improvements
Message-Id: <170315547865.2197670.7761512990003222623.b4-ty@ellerman.id.au>
Date: Thu, 21 Dec 2023 21:44:38 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Fri, 01 Dec 2023 18:56:05 +0530, Vaibhav Jain wrote:
> This patch series introduces series of performance improvements to recently
> added support for Nested APIv2 PPC64 Guests via [1]. Details for Nested
> APIv2 for PPC64 Guests is available in Documentation/powerpc/kvm-nested.rst.
> 
> This patch series introduces various optimizations for a Nested APIv2
> guests namely:
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[01/12] KVM: PPC: Book3S HV nestedv2: Invalidate RPT before deleting a guest
        https://git.kernel.org/powerpc/c/7d370e1812b9a5f5cc68aaa5991bf7d31d8ff52c
[02/12] KVM: PPC: Book3S HV nestedv2: Avoid reloading the tb offset
        https://git.kernel.org/powerpc/c/e0d4acbcba3f2d63dc15bc5432c8e26fc9e19675
[03/12] KVM: PPC: Book3S HV nestedv2: Do not check msr on hcalls
        https://git.kernel.org/powerpc/c/63ccae78cd88b52fb1d598ae33fa8408ce067b30
[04/12] KVM: PPC: Book3S HV nestedv2: Get the PID only if needed to copy tofrom a guest
        https://git.kernel.org/powerpc/c/e678748a8dca5b57041a84a66577f6168587b3f7
[05/12] KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0
        https://git.kernel.org/powerpc/c/ec0f6639fa8853cf6bfdfc3588aada7eeb7e5e37
[06/12] KVM: PPC: Book3S HV: Handle pending exceptions on guest entry with MSR_EE
        https://git.kernel.org/powerpc/c/ecd10702baae5c16a91d139bde7eff84ce55daee
[07/12] KVM: PPC: Book3S HV nestedv2: Do not inject certain interrupts
        https://git.kernel.org/powerpc/c/df938a5576f3f3b08e1f217c660385c0d58a0b91
[08/12] KVM: PPC: Book3S HV nestedv2: Avoid msr check in kvmppc_handle_exit_hv()
        https://git.kernel.org/powerpc/c/a9a3de530d7531bf6cd3f6ccda769cd94c1105a0
[09/12] KVM: PPC: Book3S HV nestedv2: Do not call H_COPY_TOFROM_GUEST
        https://git.kernel.org/powerpc/c/4bc8ff6f170c78f64446c5d5f9ef6771eefd3416
[10/12] KVM: PPC: Book3S HV nestedv2: Register the VPA with the L0
        https://git.kernel.org/powerpc/c/db1dcfae1dae3c042f348175ac0394e2fc14b1b3
[11/12] KVM: PPC: Reduce reliance on analyse_instr() in mmio emulation
        https://git.kernel.org/powerpc/c/797a5af8fc7297b19e5c6b1713956ebf1e6c1cde
[12/12] KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception
        https://git.kernel.org/powerpc/c/180c6b072bf360b686e53d893d8dcf7dbbaec6bb

cheers

