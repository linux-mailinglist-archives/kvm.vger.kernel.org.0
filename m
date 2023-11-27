Return-Path: <kvm+bounces-2502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5457F9BF0
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 09:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D7CF1C20826
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 08:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A08134AA;
	Mon, 27 Nov 2023 08:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Snz5MQ2O"
X-Original-To: kvm@vger.kernel.org
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D13E18E;
	Mon, 27 Nov 2023 00:40:20 -0800 (PST)
Received: from [100.98.85.67] (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id B2ADA66022D0;
	Mon, 27 Nov 2023 08:40:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1701074418;
	bh=rZXsF737DimmD6akpQH1k64WG7vCDa/yrvr/Hhcm6dQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=Snz5MQ2OHBon5UJH+98mdDbgTrFRKjLtGTX5KRDipqlr95JztPXgEMEhEl7fdNZfy
	 K1pHJorNBvh8Y7mSbjXC9MIgzJ3jGm7YSs6SxNLTsG+NvGXBSbifiplJZPGt8LaxJx
	 qYAtbVmdbZRrvWnJwfFDRH3p8tAtvWeLbf33iGk9PNyWoTo9qJluOSofDzJAQDEycD
	 sxtkv3tlLlN6WSfY5LFv3kXoNEALMVKgd8ZqAUirOS4Wptzrl4GblpaqnNj50tTIOn
	 l7/eMnPlFHQLOG0Q1zRxQYHNRSV5AHsHvD3srWytZfUhSVAlbaEbVqOjv3G0/AAl1Q
	 ks7Y75il3qS/g==
Message-ID: <ce4b8316-1529-48d2-aadf-2ea25670edcf@collabora.com>
Date: Mon, 27 Nov 2023 13:40:13 +0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
Content-Language: en-US
To: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, jarkko@kernel.org,
 jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com,
 tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
 x86@kernel.org
References: <0000000000001bfd01060b0fc7dc@google.com>
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <0000000000001bfd01060b0fc7dc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/23 8:24 PM, syzbot wrote:
> This bug is marked as fixed by commit:
> KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU
> 
> But I can't find it in the tested trees[1] for more than 90 days.
The commit is already in 6.7-rc3:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b0151caf73a656b75b550e361648430233455a0

> Is it a correct commit? Please update it by replying:
> 
> #syz fix: exact-commit-title
The title is already correct.

> 
> Until then the bug is still considered open and new crashes with
> the same signature are ignored.
> 
> Kernel: Linux 5.15
> Dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e
> 
> ---
> [1] I expect the commit to be present in:
> 
> 1. linux-5.15.y branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

-- 
BR,
Muhammad Usama Anjum

