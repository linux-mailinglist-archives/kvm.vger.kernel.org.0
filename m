Return-Path: <kvm+bounces-5976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A767082932D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 06:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C013D284665
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 05:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEF8D52B;
	Wed, 10 Jan 2024 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="N+ySi0IK"
X-Original-To: kvm@vger.kernel.org
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE638CA4A;
	Wed, 10 Jan 2024 05:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1704863388;
	bh=LF9k27EaTdGjd/ELz7vnWNnV+yYPr8oFSfpOovS9tS4=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=N+ySi0IKD5ADkKwT8bG/Ac6HiBfnqkCLqhnG+tWYaE3X1eLfqHgSxepKY/TSAXvQ/
	 8tx54XbuO/qoYNuCe2rI/4g8tl+uQGlXQGEQD3bemrSO9lrTK+JM+mkXc7g2i+6VB8
	 3AFbb2wEqD67WPjpIV8fpKhf7THQ3VlW/gQKGhkjcMJR+koNF24XPP15OgktjY+pSh
	 2P3OqI43EdyHUNtAoZw3Jlc6l+cO6XT8Aj83hJXbYG8X3jyP28VIQ8wFiqt8kW7/Uu
	 jtXlc20SUrZBWUONMlIQR74ey6RR7XxCqBsZ/g3MS176YHGP9jOAK78E2f+g077nvJ
	 24/RRxEA/cE3Q==
Received: from [100.96.234.34] (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id D61233780C1F;
	Wed, 10 Jan 2024 05:09:42 +0000 (UTC)
Message-ID: <e000707c-79ce-4ef9-a42c-52997d14c08d@collabora.com>
Date: Wed, 10 Jan 2024 10:09:48 +0500
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
References: <000000000000c237b7060e875640@google.com>
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <000000000000c237b7060e875640@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/24 11:18 PM, syzbot wrote:
> This bug is marked as fixed by commit:
> KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU
> 
> But I can't find it in the tested trees[1] for more than 90 days.
Just found out that the fix hasn't been back ported to this kernel. The fix
could be backported and sent to be included in this stable kernel.

#syz unfix

> Is it a correct commit? Please update it by replying:
> 
> #syz fix: exact-commit-title
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

