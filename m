Return-Path: <kvm+bounces-18000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 889BB8CC9B1
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E5BE1C21C87
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8A214E2E8;
	Wed, 22 May 2024 23:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvxrjXYy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7FE14D28E;
	Wed, 22 May 2024 23:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420744; cv=none; b=psLAZIa8wxnewWIRt+MVHcSrR+0vyOv0mThixE0sYKlBiuFZnAcy8MLpvMI5q0IE+vDF1MTcIwVS+j9PG5Smw1qIIyYXUFV6O4xfcg/cemSHqTZqgPvIKGj/tphEsokNNgXEMCZHnx5ndC7Xu1EcKlADUf09XzKDwvdOI8dO3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420744; c=relaxed/simple;
	bh=sFivK456BiubdJX56tlNdVWZafvyAwixp16zhXxqH70=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lPQEtbFzLt3yKP1nhPJUoCg8Hd1dLuGEXIalwCS2QqIyW/Gw25ne1y3QgxD9obgT4M0AnfdWucSVxvmkYAg7kuUsF5Tum22lFRwvnQeJzEbYlt7vLh+hoYvAI1jYaPLxoqubdO39LBU+kJZuI1phcxkTNtEirZYUAxZb4gUeWiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvxrjXYy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD809C4AF15;
	Wed, 22 May 2024 23:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716420743;
	bh=sFivK456BiubdJX56tlNdVWZafvyAwixp16zhXxqH70=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MvxrjXYyWgudMCjnBPVn9CXPVvpZNtaSUZ1gyq7PTmVmsLPKSp4NYpwhcGJcgtsps
	 ZQigp0aoMd337dNepQtlG7ONduRS6voeXw8G++uWdKEk6y7kzjYZuq96XJ7/yQN19U
	 IqJrWt8Rxg0xye2QS6uRQncojNKYhA9QElzTRMJox85W4T2sCbklby0gjCZU9wjUxM
	 bIKgDpuY3lMTzfOOvE5ZE3aYgr4zJsDNOJcBlqDMfSjVhfax54WnjBVe7xoJmcD286
	 HTXTNilxLy9lspwts50EVF1udoz+PVsPXjAxFdPOlmfSbHjPLqMQ0/3xuRViW2cwUe
	 cVQfWD+cD2/eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF297C43618;
	Wed, 22 May 2024 23:32:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] KVM: selftest: Define _GNU_SOURCE for all selftests code
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <171642074371.9409.16238055569874422523.git-patchwork-notify@kernel.org>
Date: Wed, 22 May 2024 23:32:23 +0000
References: <20240423190308.2883084-1-seanjc@google.com>
In-Reply-To: <20240423190308.2883084-1-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, maz@kernel.org,
 oliver.upton@linux.dev, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 usama.anjum@collabora.com

Hello:

This patch was applied to riscv/linux.git (fixes)
by Sean Christopherson <seanjc@google.com>:

On Tue, 23 Apr 2024 12:03:08 -0700 you wrote:
> Define _GNU_SOURCE is the base CFLAGS instead of relying on selftests to
> manually #define _GNU_SOURCE, which is repetitive and error prone.  E.g.
> kselftest_harness.h requires _GNU_SOURCE for asprintf(), but if a selftest
> includes kvm_test_harness.h after stdio.h, the include guards result in
> the effective version of stdio.h consumed by kvm_test_harness.h not
> defining asprintf():
> 
> [...]

Here is the summary with links:
  - KVM: selftest: Define _GNU_SOURCE for all selftests code
    https://git.kernel.org/riscv/c/730cfa45b5f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



