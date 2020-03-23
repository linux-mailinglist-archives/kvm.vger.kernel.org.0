Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87224190018
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCWVPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:15:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38620 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgCWVPS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 17:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584998117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DC8AvxEzNplngpy9CnmfYZ+2jV5WDw9rMwFeaQnkgB0=;
        b=g0zxioK5cx2TTUNeTHvLeLpd8Hr6mDUqdL550nxE9JR98AakjKrA3jKTIThLyxooiFDoVd
        2Vc9zc5LTwpwj+EQqU7Gcl/krkYWdiyIn4Is5U14JtflUodTm+4P7a6fPupWHuQsOMLAYc
        Go9WEaz/R+w2q2etVQhfPE09rF9KRsU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-lqRUAB6gPQacapIOIKNa3w-1; Mon, 23 Mar 2020 17:15:15 -0400
X-MC-Unique: lqRUAB6gPQacapIOIKNa3w-1
Received: by mail-wm1-f71.google.com with SMTP id s14so437336wmj.9
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 14:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DC8AvxEzNplngpy9CnmfYZ+2jV5WDw9rMwFeaQnkgB0=;
        b=PjnM3tmMz9lHX6mWSo8DP9ZRX3hZHOyZmj3ajnu9p0rYOTR+cTeb9gRy7BuIRM91+e
         EjmK7qZ0UWeqcwFxrziuhwyZXrRfDTSQSAAZbkQa4mjKdzcZQf048rgndrc47HlaCrK2
         QxUjduytsO1QWVLOf6WeKNySv9hCGuw54EmE68ZPHNgrJZCX15oczrd8gnEebq+9bRTS
         wJ4p9bw9AFbZxJnRCWmSqfNdndc9g1GQxVF04UGh0uIFcE2weYRnn7ZiIzLPXlZLWcR+
         ZsKJJuD9XmrPF1L1W5GtQpBvbiPbs7MsC9tBGTjBPuTlk3DlPcUESvSI+CQ5s4V0dwXo
         0log==
X-Gm-Message-State: ANhLgQ13xJXbK5hhXzUKH1m9IBO/cZT0vK6f35EODDZqoPA3TpWBOylO
        /gNkE7PzROaQJjmUUs1ZOp4v+IbM/XCZ72drHn/1r0ym+foWt71r6YtUD+OvFB1XRI7t5udV7Jn
        iZrRz5CRmw9GW
X-Received: by 2002:a5d:624f:: with SMTP id m15mr21578867wrv.56.1584998114410;
        Mon, 23 Mar 2020 14:15:14 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvj6ocWHkvYJUnrAJtCrEuf/EChbCJZzzpvia6Dum9XkjCe45SBbAHrLXix0dsiy235hO6/CA==
X-Received: by 2002:a5d:624f:: with SMTP id m15mr21578857wrv.56.1584998114240;
        Mon, 23 Mar 2020 14:15:14 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t81sm1135196wmb.15.2020.03.23.14.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 14:15:13 -0700 (PDT)
Date:   Mon, 23 Mar 2020 17:15:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
Message-ID: <20200323211509.GP127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-7-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-7-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:03AM -0700, Liu Yi L wrote:

[...]

> +AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
> +{
> +    PCIBus *bus;
> +    uint8_t devfn;
> +
> +    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
> +    if (bus && bus->iommu_ops &&
> +                     bus->iommu_ops->get_address_space) {

Nit: Since we're moving it around, maybe re-align it to left bracket?
Same to below two places.

With the indent fixed:

Reviewed-by: Peter Xu <peterx@redhat.com>

> +        return bus->iommu_ops->get_address_space(bus,
> +                                bus->iommu_opaque, devfn);
>      }
>      return &address_space_memory;
>  }

-- 
Peter Xu

