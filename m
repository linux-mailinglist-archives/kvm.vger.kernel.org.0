Return-Path: <kvm+bounces-5408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0278820B36
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 12:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AC472825C0
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 11:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621C36FBC;
	Sun, 31 Dec 2023 11:08:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C3633EA;
	Sun, 31 Dec 2023 11:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4T2xDm5zzRz4x5m;
	Sun, 31 Dec 2023 22:08:24 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM
In-Reply-To: <20231219092309.118151-1-vaibhav@linux.ibm.com>
References: <20231219092309.118151-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH] powerpc/hvcall: Reorder Nestedv2 hcall opcodes
Message-Id: <170402086354.3311386.14872359556466328787.b4-ty@ellerman.id.au>
Date: Sun, 31 Dec 2023 22:07:43 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Tue, 19 Dec 2023 14:52:36 +0530, Vaibhav Jain wrote:
> This trivial patch reorders the newly introduced hcall opcodes for Nestedv2
> to follow the increasing-opcode-number convention followed in
> 'hvcall.h'. The patch also updates the value for MAX_HCALL_OPCODE which is
> at various places in arch code for range checking.
> 
> 

Applied to powerpc/next.

[1/1] powerpc/hvcall: Reorder Nestedv2 hcall opcodes
      https://git.kernel.org/powerpc/c/eb8446e164572180c2cd0ea4e8494e4419202396

cheers

