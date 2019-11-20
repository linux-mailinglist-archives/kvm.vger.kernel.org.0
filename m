Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1D5104480
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 20:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfKTTqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 14:46:24 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34945 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfKTTqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 14:46:23 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so278169plp.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 11:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWQRhlesp4rx0iZXH5RDESHA9Y4raAckzn7wyOlg0PU=;
        b=TTS7k6dF12So4K2AiukGmARNAC4VPjnprfAYa19cmr3RY5ZetQcSPvqI9EJNJ3RSyC
         /BYijGBylA+7sWQwS/uv1yxPc02Jotnzc8QQYb8jpfRI3R12JElsHUFRiIy/S09TI3G2
         5wwjzNXqVumFvmybfxosuM3JdjpquE4qzekkvPGqF3Rq9+TmPBcgquR2cbv85e0XtKRv
         Df4+IvP+gfZzRbxsVk6VRDoQvI5gucc6jdm7p0gVYn9BAkNQmx84fxdFnmo7+njK9L1F
         1mmzZSHKcHZLq9iuG4fWT3TOdCM8a+e48EgWESaYYOen18+Z810kNGxk0FOi0TfIS4FN
         0WSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWQRhlesp4rx0iZXH5RDESHA9Y4raAckzn7wyOlg0PU=;
        b=eBebMpaUT84TecYZ4877sZN2h197yxzF++8NsuM7HHHNP6swvWqWra4x8etWNY0Rff
         rOrfnOIyubytg693KuHyfh9ohIhtWX07eCAr9CWxuYoChWZ2X12mcTjMHYRSUKli6j+Q
         hHbDxWj74iyteBcj2LaBdH16pRI1BXF3gYxpk0xkACIju4y3bLxtvRizRB6KHF5NG/HH
         VGf81rXGCC+tb8KAUVj6pZnkPMMDTZ8PMV2m/0+8WNFp1xePWgo93hXAL9usp1dyJRxg
         FFtRzagVTi+sFJdJyG0H/pHqqBi6Knd8phTkTJ2WD0McSnLzcidSLDE9sodQGUA8UdIg
         ssxg==
X-Gm-Message-State: APjAAAU5f6X1BRXGXCb3ggAOxhbZ1zZzG8//RuavHZaoIC/xs+kLIV8F
        bmG/3uV//lDKNTUSrhVEFnD+Pw==
X-Google-Smtp-Source: APXvYqxjXMFyy7LYekLsZkeE/2v6Xsp1AbcHHzWQImsf2JBx6DvYlprINlJDduyr4x5PddsPUWGG6Q==
X-Received: by 2002:a17:90a:98d:: with SMTP id 13mr6167964pjo.98.1574279182414;
        Wed, 20 Nov 2019 11:46:22 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o23sm26553pgj.90.2019.11.20.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 11:46:22 -0800 (PST)
Date:   Wed, 20 Nov 2019 11:46:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     <lantianyu1986@gmail.com>, <cohuck@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>, <sashal@kernel.org>,
        <mchehab+samsung@kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <robh@kernel.org>,
        <Jonathan.Cameron@huawei.com>, <paulmck@linux.ibm.com>,
        "Michael Kelley" <mikelley@microsoft.com>,
        "Tianyu Lan" <Tianyu.Lan@microsoft.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, "vkuznets" <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191120114611.4721a7e9@hermes.lan>
In-Reply-To: <20191120120715.0cecf5ea@x1.home>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191119165620.0f42e5ba@x1.home>
        <20191120103503.5f7bd7c4@hermes.lan>
        <20191120120715.0cecf5ea@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 12:07:15 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 20 Nov 2019 10:35:03 -0800
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Tue, 19 Nov 2019 15:56:20 -0800
> > "Alex Williamson" <alex.williamson@redhat.com> wrote:
> >   
> > > On Mon, 11 Nov 2019 16:45:07 +0800
> > > lantianyu1986@gmail.com wrote:
> > >     
> > > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > > > 
> > > > This patch is to add VFIO VMBUS driver support in order to expose
> > > > VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> > > > DPDK now has netvsc PMD driver support and it may get VMBUS resources
> > > > via VFIO interface with new driver support.
> > > > 
> > > > So far, Hyper-V doesn't provide virtual IOMMU support and so this
> > > > driver needs to be used with VFIO noiommu mode.      
> > > 
> > > Let's be clear here, vfio no-iommu mode taints the kernel and was a
> > > compromise that we can re-use vfio-pci in its entirety, so it had a
> > > high code reuse value for minimal code and maintenance investment.  It
> > > was certainly not intended to provoke new drivers that rely on this mode
> > > of operation.  In fact, no-iommu should be discouraged as it provides
> > > absolutely no isolation.  I'd therefore ask, why should this be in the
> > > kernel versus any other unsupportable out of tree driver?  It appears
> > > almost entirely self contained.  Thanks,
> > > 
> > > Alex    
> > 
> > The current VMBUS access from userspace is from uio_hv_generic
> > there is (and will not be) any out of tree driver for this.  
> 
> I'm talking about the driver proposed here.  It can only be used in a
> mode that taints the kernel that its running on, so why would we sign
> up to support 400 lines of code that has no safe way to use it?
>  
> > The new driver from Tianyu is to make VMBUS behave like PCI.
> > This simplifies the code for DPDK and other usermode device drivers
> > because it can use the same API's for VMBus as is done for PCI.  
> 
> But this doesn't re-use the vfio-pci API at all, it explicitly defines
> a new vfio-vmbus API over the vfio interfaces.  So a user mode driver
> might be able to reuse some vfio support, but I don't see how this has
> anything to do with PCI.
> 
> > Unfortunately, since Hyper-V does not support virtual IOMMU yet,
> > the only usage modle is with no-iommu taint.  
> 
> Which is what makes it unsupportable and prompts the question why it
> should be included in the mainline kernel as it introduces a
> maintenance burden and normalizes a usage model that's unsafe.  Thanks,

Many existing userspace drivers are unsafe:
  - out of tree DPDK igb_uio is unsafe.
  - VFIO with noiommu is unsafe.
  - hv_uio_generic is unsafe.

This new driver is not any better or worse. This sounds like a complete
repeat of the discussion that occurred before introducing VFIO noiommu mode.

Shouldn't vmbus vfio taint the kernel in the same way as vfio noiommu does?
