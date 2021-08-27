Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5B3F9658
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 10:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbhH0IoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 04:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhH0IoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 04:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C57060F6F;
        Fri, 27 Aug 2021 08:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630053793;
        bh=hHb2wdMjI7FvcvoPutzMeKVb5FQHNPxUguvPilqgxII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g+DhAG7BY0c6OsQNVfLrCDw52yR0lE3h56m+n3q42sg0PUdYaSKIR1I5YNRCCvGMf
         S+XkUt0mPWN/TXMrGsED+JIY2+PMpecLHONOl9cOeg7CUnAoLfcTWt1nihm44Ohv3Q
         nTyr9owIlEHBO7r4soWGyH/AIv1NilXJH/XugDr8=
Date:   Fri, 27 Aug 2021 10:43:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v1 1/3] nitro_enclaves: Enable Arm support
Message-ID: <YSilmGyvEAc46ujH@kroah.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826173451.93165-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 08:34:49PM +0300, Andra Paraschiv wrote:
> Update the kernel config to enable the Nitro Enclaves kernel driver for
> Arm support.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  drivers/virt/nitro_enclaves/Kconfig | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
> index 8c9387a232df8..f53740b941c0f 100644
> --- a/drivers/virt/nitro_enclaves/Kconfig
> +++ b/drivers/virt/nitro_enclaves/Kconfig
> @@ -1,17 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0
>  #
> -# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> +# Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>  
>  # Amazon Nitro Enclaves (NE) support.
>  # Nitro is a hypervisor that has been developed by Amazon.
>  
> -# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
> -# the NE kernel driver can be built for aarch64 arch.
> -# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
> -
>  config NITRO_ENCLAVES
>  	tristate "Nitro Enclaves Support"
> -	depends on X86 && HOTPLUG_CPU && PCI && SMP
> +	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP

So no code change needed?  If not, they why do we have a cpu type at all
here?

thanks,

greg k-h
