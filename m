Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8543FC2EE
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 08:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhHaGoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 02:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhHaGoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 02:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A32160724;
        Tue, 31 Aug 2021 06:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630392187;
        bh=ADxNS/MsmWdCPv3pB98riSkxnOCLkLaCV4LN7vxCy94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pd5wisrNSONH8C8Oh/yXbcmZd8xjfgng7etw1X3Crk/emROqd23gHGm7SLW4hYYnP
         NfT/+/E2XbLiFiXDCxK39sSg+0R886W/J6LuiGjIjgPdNvvmAV3lGQR+HsMScPriLY
         UvQUJ2KAc/GkyrKsAWFdO+PKKpVRNye1swff3XUo=
Date:   Tue, 31 Aug 2021 08:43:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     George-Aurelian Popescu <popegeo@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
Message-ID: <YS3Peu/ax4gAVb6P@kroah.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-2-andraprs@amazon.com>
 <20210830155907.GG10224@u90cef543d0ab5a.ant.amazon.com>
 <f57fd0eb-271c-b8d7-ee9b-276c0f0c62ba@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f57fd0eb-271c-b8d7-ee9b-276c0f0c62ba@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021 at 09:30:04PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 30/08/2021 18:59, George-Aurelian Popescu wrote:
> > On Fri, Aug 27, 2021 at 06:49:24PM +0300, Andra Paraschiv wrote:
> > > Update the kernel config to enable the Nitro Enclaves kernel driver for
> > > Arm64 support.
> > > 
> > > Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> > > Acked-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > Changelog
> > > 
> > > v1 -> v2
> > > 
> > > * No changes.
> > > 
> > > v2 -> v3
> > > 
> > > * Move changelog after the "---" line.
> > > ---
> > >   drivers/virt/nitro_enclaves/Kconfig | 8 ++------
> > >   1 file changed, 2 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
> > > index 8c9387a232df8..f53740b941c0f 100644
> > > --- a/drivers/virt/nitro_enclaves/Kconfig
> > > +++ b/drivers/virt/nitro_enclaves/Kconfig
> > > @@ -1,17 +1,13 @@
> > >   # SPDX-License-Identifier: GPL-2.0
> > >   #
> > > -# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> > > +# Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> > >   # Amazon Nitro Enclaves (NE) support.
> > >   # Nitro is a hypervisor that has been developed by Amazon.
> > > -# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
> > > -# the NE kernel driver can be built for aarch64 arch.
> > > -# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
> > > -
> > >   config NITRO_ENCLAVES
> > >   	tristate "Nitro Enclaves Support"
> > > -	depends on X86 && HOTPLUG_CPU && PCI && SMP
> > > +	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
> > >   	help
> > >   	  This driver consists of support for enclave lifetime management
> > >   	  for Nitro Enclaves (NE).
> > > -- 
> > > 2.20.1 (Apple Git-117)
> > > 
> > Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>
> > 
> 
> Thanks, George, for review.
> 
> Greg, let me know if other updates are needed for the patch series.
> Otherwise, please include the patches in the char-misc tree and we can
> target the current merge window, for v5.15. Thank you.

It's too late for 5.15-rc1, I will queue them up after 5.15-rc1 is out,
thanks.

greg k-h
