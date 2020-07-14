Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238D321EC0D
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 11:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGNJDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 05:03:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36410 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgGNJDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 05:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594717413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfzrpnDksjrV/E9eLW/uyC+yehYtUw0XCcZEGedYMzg=;
        b=fyGK2XDa1nLt8GJQyGM/KboAuk8yMJVEw7t95stwnE5/w81PlpwgyU1BvRrdbopn1VpNqw
        RJkgDy1SaTX3kdMes4xqMSFa3DW3UT9HQEcn1k4z6d6vPIskGHzUT7P4qcA5Kiye7uir3Z
        SNhBuKRRPv2hLt2aITtf6+DZMcIXMR8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-UIbXpavqNxO_ih7eYmFTaA-1; Tue, 14 Jul 2020 05:03:30 -0400
X-MC-Unique: UIbXpavqNxO_ih7eYmFTaA-1
Received: by mail-wr1-f71.google.com with SMTP id 89so20757110wrr.15
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 02:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DfzrpnDksjrV/E9eLW/uyC+yehYtUw0XCcZEGedYMzg=;
        b=VUkA2oSdzztoYVMfirHAj6TacynrHTpVy3w8nOAMcJ7W7XuWCcHCvYkCftW2STFffz
         W+SVUUhHEMm+EZLzKm5IYyzhMKfQFKn5SFxZcB4xzuWdGVfO5yQ7yZ7JF3kdtPBR98QY
         OjYGEokk1e06YGHVOo9Yr4RKVfVQiiovztCeMd5lwsxD9EBB0Y3wptTas9DO+3zgLWW8
         gUBXZZGB5XIIsY6z7KhP2gAujmdgFsehSgO5sUulQWz3UbRTi1ehsAAkCAwy27TFJg/z
         GS7BXuzeA0Yj/2qET/TMnBAmLx8PHCWI6XMatmLxUTXAsfkliVjmU9qsrZ0FcwtlBYfV
         vF1Q==
X-Gm-Message-State: AOAM530gcCeOW5KsAA+HIOTOe81mCH4R0MTTKxk+7OHdvW/aw003IjuG
        QaH1wlG+NW1nolXvaEQT4NhZsL5TsxGIYzlBDaua5bnzCiklYVOTUu4Yc0dQaXpBln53AnikV0+
        Vuq1+mzHGhleT
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr3197920wml.36.1594717408731;
        Tue, 14 Jul 2020 02:03:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXFKbRHAyh+9vVQvN7eLfJsIxJJAssbByyfjo+ePDaaH3nSHiQ776m2H8PMkGHjwfKUW7mHg==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr3197913wml.36.1594717408523;
        Tue, 14 Jul 2020 02:03:28 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id y77sm3755145wmd.36.2020.07.14.02.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 02:03:27 -0700 (PDT)
Date:   Tue, 14 Jul 2020 05:03:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, dan.daly@intel.com
Subject: Re: [PATCH 2/7] kvm/vfio: detect assigned device via irqbypass
 manager
Message-ID: <20200714050301-mutt-send-email-mst@kernel.org>
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-2-git-send-email-lingshan.zhu@intel.com>
 <20200712170518-mutt-send-email-mst@kernel.org>
 <bcb03e95-d8b9-6e19-5b0e-0119d3f43d6d@redhat.com>
 <20200713065222-mutt-send-email-mst@kernel.org>
 <aca899f7-ec2e-2b55-df78-44eacb923c00@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aca899f7-ec2e-2b55-df78-44eacb923c00@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 08:52:43AM +0800, Zhu, Lingshan wrote:
> 
> On 7/13/2020 6:52 PM, Michael S. Tsirkin wrote:
> 
>     On Mon, Jul 13, 2020 at 04:13:35PM +0800, Jason Wang wrote:
> 
>         On 2020/7/13 上午5:06, Michael S. Tsirkin wrote:
> 
>             On Sun, Jul 12, 2020 at 10:49:21PM +0800, Zhu Lingshan wrote:
> 
>                 We used to detect assigned device via VFIO manipulated device
>                 conters. This is less flexible consider VFIO is not the only
>                 interface for assigned device. vDPA devices has dedicated
>                 backed hardware as well. So this patch tries to detect
>                 the assigned device via irqbypass manager.
> 
>                 We will increase/decrease the assigned device counter in kvm/x86.
>                 Both vDPA and VFIO would go through this code path.
> 
>                 This code path only affect x86 for now.
> 
>                 Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
>             I think it's best to leave VFIO alone. Add appropriate APIs for VDPA,
>             worry about converting existing users later.
> 
> 
> 
>         Just to make sure I understand, did you mean:
> 
>         1) introduce another bridge for vDPA
> 
>         or
> 
>         2) only detect vDPA via bypass manager? (we can leave VFIO code as is, then
>         the assigned device counter may increase/decrease twice if VFIO use irq
>         bypass manager which should be no harm).
> 
>         Thanks
> 
>     2 is probably easier to justify. 1 would depend on the specific bridge
>     proposed.
> 
> Thanks Michael, so we should just drop changes in vfio, just increase / decrease
> the counter in irq bypass manager. right?
> 
> Thanks

I don't see any issue with that.

> 
> 
>                 ---
>                   arch/x86/kvm/x86.c | 10 ++++++++--
>                   virt/kvm/vfio.c    |  2 --
>                   2 files changed, 8 insertions(+), 4 deletions(-)
> 
>                 diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>                 index 00c88c2..20c07d3 100644
>                 --- a/arch/x86/kvm/x86.c
>                 +++ b/arch/x86/kvm/x86.c
>                 @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>                   {
>                         struct kvm_kernel_irqfd *irqfd =
>                                 container_of(cons, struct kvm_kernel_irqfd, consumer);
>                 +       int ret;
>                         irqfd->producer = prod;
>                 +       kvm_arch_start_assignment(irqfd->kvm);
>                 +       ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
>                 +                                        prod->irq, irqfd->gsi, 1);
>                 +
>                 +       if (ret)
>                 +               kvm_arch_end_assignment(irqfd->kvm);
>                 -       return kvm_x86_ops.update_pi_irte(irqfd->kvm,
>                 -                                          prod->irq, irqfd->gsi, 1);
>                 +       return ret;
>                   }
>                   void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>                 diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>                 index 8fcbc50..111da52 100644
>                 --- a/virt/kvm/vfio.c
>                 +++ b/virt/kvm/vfio.c
>                 @@ -226,7 +226,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>                                 list_add_tail(&kvg->node, &kv->group_list);
>                                 kvg->vfio_group = vfio_group;
>                 -               kvm_arch_start_assignment(dev->kvm);
>                                 mutex_unlock(&kv->lock);
>                 @@ -254,7 +253,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>                                                 continue;
>                                         list_del(&kvg->node);
>                 -                       kvm_arch_end_assignment(dev->kvm);
>                   #ifdef CONFIG_SPAPR_TCE_IOMMU
>                                         kvm_spapr_tce_release_vfio_group(dev->kvm,
>                                                                          kvg->vfio_group);
>                 --
>                 1.8.3.1
> 

