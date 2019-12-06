Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49052114FE6
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLFLnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 06:43:13 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:55209 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfLFLnN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 06:43:13 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1idC0j-0001qF-ES; Fri, 06 Dec 2019 12:43:01 +0100
To:     linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH] KVM: arm: get rid of unused arg in  =?UTF-8?Q?cpu=5Finit=5Fhyp=5Fmode=28=29?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Dec 2019 11:43:01 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
In-Reply-To: <1574320559-5662-1-git-send-email-linmiaohe@huawei.com>
References: <1574320559-5662-1-git-send-email-linmiaohe@huawei.com>
Message-ID: <2ca295ccc30b53b4d57098d9718f8aa3@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: linmiaohe@huawei.com, pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-21 07:15, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> As arg dummy is not really needed, there's no need to pass
> NULL when calling cpu_init_hyp_mode(). So clean it up.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 86c6aa1cb58e..a5470f1b1a19 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1315,7 +1315,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	}
>  }
>
> -static void cpu_init_hyp_mode(void *dummy)
> +static void cpu_init_hyp_mode(void)
>  {
>  	phys_addr_t pgd_ptr;
>  	unsigned long hyp_stack_ptr;
> @@ -1349,7 +1349,7 @@ static void cpu_hyp_reinit(void)
>  	if (is_kernel_in_hyp_mode())
>  		kvm_timer_init_vhe();
>  	else
> -		cpu_init_hyp_mode(NULL);
> +		cpu_init_hyp_mode();
>
>  	kvm_arm_init_debug();

Applied, thanks.

         M.
-- 
Jazz is not dead. It just smells funny...
