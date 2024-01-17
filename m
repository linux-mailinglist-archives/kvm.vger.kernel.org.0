Return-Path: <kvm+bounces-6409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFE8830E78
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 22:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 284C81C21FE5
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 21:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5144925573;
	Wed, 17 Jan 2024 21:19:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3793250E8;
	Wed, 17 Jan 2024 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705526349; cv=none; b=EAFZVareZa3T/NEMOL+B7CDwI1yrNd2YBddexNI4gV0GbZ/ddq9dJ6WsnXeFgmLaEzFsZ+WCFRPyXa3dXeqv0ab43vqgyO3TpfUo83qVpi0P1ePuY8BrI+vM0cb8WlvwAy4ksWG5jxkc8tEY8NTqdnK64hnP6+6ue/9tHwhoD1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705526349; c=relaxed/simple;
	bh=ttyDCLNNMgQEc8e9KdahxH70xGwli3IpEIEtIx9HpG4=;
	h=Received:Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:
	 References:MIME-Version:Content-Type; b=kTf2ERbQvhj4Hv6od3qD7zwvk/sQ1GXKcyJl8kfLvthqEbVli3SPRfWZo/4b1qi2pNueQc7oxG1/hM1e//jzvWozJSiJQ/EgSt+5R3vcm8Epr2P4FszZEoKATYC9fnVbVNtUxPJH2Z7YVpSzunxhlzYnycxjmg1X5tiZjh8uRrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=fail smtp.mailfrom=linux.com; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linux.com
Received: by gentwo.org (Postfix, from userid 1003)
	id 99A0E40A8B; Wed, 17 Jan 2024 13:19:06 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 972ED40A85;
	Wed, 17 Jan 2024 13:19:06 -0800 (PST)
Date: Wed, 17 Jan 2024 13:19:06 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@linux.com>
To: Mihai Carabas <mihai.carabas@oracle.com>
cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
    linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, akpm@linux-foundation.org, 
    pmladek@suse.com, peterz@infradead.org, dianders@chromium.org, 
    npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
    juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
    ankur.a.arora@oracle.com
Subject: Re: [PATCH v2] Enable haltpoll for arm64
In-Reply-To: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
Message-ID: <96ed7928-b979-672c-9551-1739e00ca148@linux.com>
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 20 Nov 2023, Mihai Carabas wrote:

> This patchset enables the usage of haltpoll governer on arm64. This is
> specifically interesting for KVM guests by reducing the IPC latencies.

Any updates on this one? We see good improvements with this patchset using 
a variety of loads on Ampere platforms.

