Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1731C104387
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfKTSjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 13:39:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34579 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfKTSfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 13:35:14 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so168204pff.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 10:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SguOXdXD06UvXlpJTQF3X/gOJzOdybHb3TZxh+LFCwE=;
        b=M/k0aGFFVeGdcEMo7ik+UWlR4SsoP7CucR9U2FHwRbjsoS6Jxqcz+93aeJIKZnBOzz
         Pc2jMYjAyvzMe3GuRy2XS+vsHKuraV6vaRry8HP7s2ycXSVK14bhkWt0MHSY9/CrZrdK
         lqj5Uq3IVc1Ruu12WucILWSR/ZVulbvVir963Af99szrifaRyz40CQxsJreqUZ2NW7tt
         BKXdpeVpeahKlUXC1lcurEuXhuKmhgK4D48SlaAxPptv067Vwgdtd8/EG2o9CrfnSEwT
         NOo3JtRemeRmdsJLTsEbcx7959y1TZcjFUgLWdAojE5jZX7AqeRishMiOyM+3npTA7DT
         iLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SguOXdXD06UvXlpJTQF3X/gOJzOdybHb3TZxh+LFCwE=;
        b=I/3SPXrRnNqkHqY/GGXoVaGOnJP6OYKZHu2a72DdDsVajoRYxrbicvSAuBvgqRvYcn
         tfkWlurzw/TKECI8o7npd/3tyNsC6wAIDj2CdHn9aUMaoo0wBRprGVaE+PN+madSdeCa
         A9XQG+VUCMjAZF2q8K0XS9LzmCVXfrDO9LiFjAT88I/Cugea4D+hQLBn00HpyS2nNww5
         trWsVQajFtmr31IhbC9Cy+gcoMdmqadIim4CwS2P0qtiL7aIPdSv+zDrcKgD7LR7u9X4
         C0NumktPm3q0k3qNwx4rh7dwCqsxMxWheb1Ce5smzy2WZ8UkHxuiUkw+UFUAmze/IkoT
         lQug==
X-Gm-Message-State: APjAAAX7F+plIujLr8Uyzh6A4eRZ+ND8TXsV+0N9whWpq8aiw229iUlz
        VCecGe0RKzf6GpZf4x2WQTq3GQ==
X-Google-Smtp-Source: APXvYqxyYAth7L1wiJL1kecEmScQt3Ogum8pKto+OQyv1LHRbY3avm8XD4YP/3EEZhm/qCZxoniQDg==
X-Received: by 2002:a63:ec4b:: with SMTP id r11mr4749669pgj.147.1574274912209;
        Wed, 20 Nov 2019 10:35:12 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p123sm78577pfg.30.2019.11.20.10.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 10:35:11 -0800 (PST)
Date:   Wed, 20 Nov 2019 10:35:03 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Alex Williamson" <alex.williamson@redhat.com>
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
Message-ID: <20191120103503.5f7bd7c4@hermes.lan>
In-Reply-To: <20191119165620.0f42e5ba@x1.home>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191119165620.0f42e5ba@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Nov 2019 15:56:20 -0800
"Alex Williamson" <alex.williamson@redhat.com> wrote:

> On Mon, 11 Nov 2019 16:45:07 +0800
> lantianyu1986@gmail.com wrote:
> 
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > 
> > This patch is to add VFIO VMBUS driver support in order to expose
> > VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> > DPDK now has netvsc PMD driver support and it may get VMBUS resources
> > via VFIO interface with new driver support.
> > 
> > So far, Hyper-V doesn't provide virtual IOMMU support and so this
> > driver needs to be used with VFIO noiommu mode.  
> 
> Let's be clear here, vfio no-iommu mode taints the kernel and was a
> compromise that we can re-use vfio-pci in its entirety, so it had a
> high code reuse value for minimal code and maintenance investment.  It
> was certainly not intended to provoke new drivers that rely on this mode
> of operation.  In fact, no-iommu should be discouraged as it provides
> absolutely no isolation.  I'd therefore ask, why should this be in the
> kernel versus any other unsupportable out of tree driver?  It appears
> almost entirely self contained.  Thanks,
> 
> Alex

The current VMBUS access from userspace is from uio_hv_generic
there is (and will not be) any out of tree driver for this.

The new driver from Tianyu is to make VMBUS behave like PCI.
This simplifies the code for DPDK and other usermode device drivers
because it can use the same API's for VMBus as is done for PCI.

Unfortunately, since Hyper-V does not support virtual IOMMU yet,
the only usage modle is with no-iommu taint.
