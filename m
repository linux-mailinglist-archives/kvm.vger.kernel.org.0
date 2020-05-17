Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBB1D66A8
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEQIzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 04:55:43 -0400
Received: from elvis.franken.de ([193.175.24.41]:56343 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgEQIzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 04:55:43 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jaF5B-0003F8-00; Sun, 17 May 2020 10:55:41 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 3BA98C04D3; Sun, 17 May 2020 10:22:42 +0200 (CEST)
Date:   Sun, 17 May 2020 10:22:42 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <20200517082242.GA3939@alpha.franken.de>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589688372-3098-16-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 17, 2020 at 12:06:12PM +0800, Huacai Chen wrote:
> James Hogan has become inactive for a long time and leaves KVM for MIPS
> orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> made some contributions in kernel and QEMU. If possible, we want to take
> the KVM/MIPS maintainership.
> 
> Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e64e5db..59b3f43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9302,9 +9302,11 @@ F:	include/kvm/arm_*
>  F:	virt/kvm/arm/
>  
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> +M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> +M:	Huacai Chen <chenhc@lemote.com>

not sure, if other people see the same problem with this email address,
but wouldn't it be better to use your gmail address here ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
