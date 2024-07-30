Return-Path: <kvm+bounces-22690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B8F94202C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6C01F241BE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 18:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F146C18CBE0;
	Tue, 30 Jul 2024 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="mYkrWsuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4069918A6CB;
	Tue, 30 Jul 2024 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722365747; cv=none; b=ujo/c00swakgFdA2+Ia+SwYlXE7JCYgX+oDOWPW0nxIsol6CCK7c1QDrS8BPkav8oK2ClgAMiUTeHwUzXP/SdwwRYa1nhY2dR02406iCTwCDJpM+GOXEjf3rGyb+5S6IZ3FKRpaDSMnf1Xwf+yB+MzICCqyU0REfiryjStAFZ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722365747; c=relaxed/simple;
	bh=Deu814CCLVwaucA6XBvJViX6k/ku4mshypf1ZnH3w+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SHZ2CM0/n8wJ3jYOEask1wCo4Prw1y6dyx44YaljzxlRlz/1rNzhyeQZlv6P8sfhqL6ESH5CrQEh5aK7XCJeSkT/5LJoklW3u1DYimhDXWb173k8sBqLhlvQsyAnsKe4WRA0jOUO7mmfB+tEtyPYdztxf2fpizZb/ydXci1pkaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=mYkrWsuQ; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1sYs0T-005ZTB-91; Tue, 30 Jul 2024 20:55:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=reBcGaqh1Qs+RsA6vlYhvOzZeocEG4QDGc75R4XnN6I=; b=mYkrWsuQWmTapcM9HgDwRx1Ze6
	azR9QetEQud03iHpktzIPivM14spdbIpJ8I8BeNXuMyuisqIUGSug/b80F93CibzrI4953Os77d/G
	EqC72wIqbbWwe0/9zZUcLIJLcaV9Iezy6X3mn//LZtWtSMTrEAYAMy5ssrPKsXIgTP1g544WyFk0/
	uSEcCLw0M/ED2KgJzxyQpjVyz4g7+lZKtrmfHs2ep/pMVDLs/kLnhzDc1bcw+k6T+rdyANu5V0yiY
	2r3WLHrz3AUHbNDcE2q/33TiioKiEwHhBzCLHuQBMwVQHf5joW+LiQS+N6CMbA8iT4/JEKCuyNYT/
	IMyuKaCQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1sYs0S-0005aB-0C; Tue, 30 Jul 2024 20:55:32 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1sYs0I-001BsR-QL; Tue, 30 Jul 2024 20:55:22 +0200
Message-ID: <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
Date: Tue, 30 Jul 2024 20:55:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
To: Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
References: <20240730155646.1687-1-will@kernel.org>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20240730155646.1687-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/24 17:56, Will Deacon wrote:
> If the xa_store() fails in kvm_vm_ioctl_create_vcpu() then we shouldn't
> drop the reference to the 'struct kvm' because the vCPU fd has been
> installed and will take care of the refcounting.
> 
> This was found by inspection, but forcing the xa_store() to fail
> confirms the problem:
> 
>  | Unable to handle kernel paging request at virtual address ffff800080ecd960
>  | Call trace:
>  |  _raw_spin_lock_irq+0x2c/0x70
>  |  kvm_irqfd_release+0x24/0xa0
>  |  kvm_vm_release+0x1c/0x38
>  |  __fput+0x88/0x2ec
>  |  ____fput+0x10/0x1c
>  |  task_work_run+0xb0/0xd4
>  |  do_exit+0x210/0x854
>  |  do_group_exit+0x70/0x98
>  |  get_signal+0x6b0/0x73c
>  |  do_signal+0xa4/0x11e8
>  |  do_notify_resume+0x60/0x12c
>  |  el0_svc+0x64/0x68
>  |  el0t_64_sync_handler+0x84/0xfc
>  |  el0t_64_sync+0x190/0x194
>  | Code: b9000909 d503201f 2a1f03e1 52800028 (88e17c08)
> 
> Add a new label to the error path so that we can branch directly to the
> xa_release() if the xa_store() fails.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Michal Luczaj <mhal@rbox.co>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  virt/kvm/kvm_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..b80dd8cead8c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  
>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
>  		r = -EINVAL;
> -		goto kvm_put_xa_release;
> +		goto err_xa_release;
>  	}
>  
>  	/*
> @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  
>  kvm_put_xa_release:
>  	kvm_put_kvm_no_destroy(kvm);
> +err_xa_release:
>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
>  unlock_vcpu_destroy:
>  	mutex_unlock(&kvm->lock);

My bad for neglecting the "impossible" path. Thanks for the fix.

I wonder if it's complete. If we really want to consider the possibility of
this xa_store() failing, then keeping vCPU fd installed and calling
kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.


