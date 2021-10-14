Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099C542D97C
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhJNMuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:50:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231373AbhJNMud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634215708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgAoUCr2g0Q8buC4lqB3qIFgK3kCF8Dcx4KwnHcO10Y=;
        b=NF1NRbDdSJZNUhgOJ6lpz0Iv3aWNRYyucKd+uTTQ++CLPsUlTU4XTOyDMVWGywnhCsZaml
        nB9bnLWXCITZGtKNsBoHm2GWSotZB9nAELjvzXvIRNTYCxdl4P7KwlTq3UTLuC4LEXFlnG
        dnzz2ivi1GzU8dWTk7AmFIcx6CMFfvI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-qxhlg7uxN7eQyTmk1RAXXA-1; Thu, 14 Oct 2021 08:48:27 -0400
X-MC-Unique: qxhlg7uxN7eQyTmk1RAXXA-1
Received: by mail-oi1-f197.google.com with SMTP id y5-20020aca3205000000b0027644481fe7so3480424oiy.10
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 05:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SgAoUCr2g0Q8buC4lqB3qIFgK3kCF8Dcx4KwnHcO10Y=;
        b=rkaNxxjpDkvWBwUGV7jkeGcFVR5AVfRuv2sIkMM5XLJ238WfmagXLXqUPFTaku+Jkr
         U4HdARS2fDHSBlBJbkDu3d2Ej3vC3J9WENy5EwGfpLiW1tMw7ezOKYzNiblzWYMCVmCm
         hosi/3YRPPmaqQeJuf4PbpAAOV97NAgEyJnKFuc5GcM66T5DbMu9Wb/OlSZHL5OXztbQ
         32R2dTJeislrGAjhwkkQFB1zJlpayqERnJ31wxBBsSq67aXrgLL9rwkbNx3QdiVEFHD3
         8mJoRcIxafs5bihBwALpzb03lXG324v4GlHqhPA94hYxKbplPvUi79dAgVho+sSlFVVQ
         ZwDQ==
X-Gm-Message-State: AOAM533AcxuXhWn6L+gbVWFmQcw2RzduVNrd/1fi9a+rzbHRqaSswOvF
        Of2XAvkFcWqSvihI7OkknUadofwc4sO8/AJZgdn2oLZ1stEGKtEx00nb6zaAwbyHqfV+C+i8Nhz
        tEgDH4aKEwsC5
X-Received: by 2002:a05:6830:438a:: with SMTP id s10mr2309508otv.173.1634215706577;
        Thu, 14 Oct 2021 05:48:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSKGJprFUyB3lW9nKrVTdQmRUksS+T9Ng9vGvaqMDfrQ5m5mcDtpHxincGLmthR+LKCcvPSg==
X-Received: by 2002:a05:6830:438a:: with SMTP id s10mr2309489otv.173.1634215706360;
        Thu, 14 Oct 2021 05:48:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13sm586128oig.35.2021.10.14.05.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 05:48:26 -0700 (PDT)
Date:   Thu, 14 Oct 2021 06:48:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhenguo Yao <yaozhenguo1@gmail.com>
Cc:     bhelgaas@google.com, cohuck@redhat.com, jgg@ziepe.ca,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yaozhenguo@jd.com
Subject: Re: [PATCH v1 0/2] Add ablility of VFIO driver to ignore reset when
 device don't need it
Message-ID: <20211014064824.66c90ee5.alex.williamson@redhat.com>
In-Reply-To: <20211014095748.84604-1-yaozhenguo1@gmail.com>
References: <20211014095748.84604-1-yaozhenguo1@gmail.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Oct 2021 17:57:46 +0800
Zhenguo Yao <yaozhenguo1@gmail.com> wrote:

> In some scenarios, vfio device can't do any reset in initialization
> process. For example: Nvswitch and GPU A100 working in Shared NVSwitch
> Virtualization Model. In such mode, there are two type VMs: service
> VM and Guest VM. The GPU devices are initialized in the following steps:
> 
> 1. Service VM boot up. GPUs and Nvswitchs are passthrough to service VM.
> Nvidia driver and manager software will do some settings in service VM.
> 
> 2. The selected GPUs are unpluged from service VM.
> 
> 3. Guest VM boots up with the selected GPUs passthrough.
> 
> The selected GPUs can't do any reset in step3, or they will be initialized
> failed in Guest VM.
> 
> This patchset add a PCI sysfs interface:ignore_reset which drivers can
> use it to control whether to do PCI reset or not. For example: In Shared
> NVSwitch Virtualization Model. Hypervisor can disable PCI reset by setting
> ignore_reset to 1 before Gust VM booting up.
> 
> Zhenguo Yao (2):
>   PCI: Add ignore_reset sysfs interface to control whether do device
>     reset in PCI drivers
>   vfio-pci: Don't do device reset when ignore_reset is setting
> 
>  drivers/pci/pci-sysfs.c          | 25 +++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++------------
>  include/linux/pci.h              |  1 +
>  3 files changed, 56 insertions(+), 18 deletions(-)
> 

This all seems like code to mask that these NVSwitch configurations are
probably insecure because we can't factor and manage NVSwitch isolation
into IOMMU grouping.  I'm guessing this "service VM" pokes proprietary
registers to manage that isolation and perhaps later resetting devices
negates that programming.  A more proper solution is probably to do our
best to guess the span of an NVSwitch configuration and make the IOMMU
group include all the devices, until NVIDIA provides proper code for
the kernel to understand this interconnect and how it affects DMA
isolation.  Nak on disabling resets for the purpose of preventing a
user from undoing proprietary device programming.  Thanks,

Alex

