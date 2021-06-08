Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E868639EB28
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 03:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFHBCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 21:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230314AbhFHBCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 21:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623114029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9Hxnp9TzX1Qa0LPCbDI+r/Swgm1W5T0HqpzgDaMsIM=;
        b=cJCSUgDFNaKbpGVyueCsW9AsPJ87rUUNJ2uMBjgxXT2QJvdiZBdYfxXHP3+/3p6nGYzEWg
        tmD9Sw/ctpoL8CGN2Jao+RWPj6m+4UmOTw2ch+nQomfNLK+jYu4/ul7/uLSGdM5FMIH/GF
        Uck9AV0RXzwXaKJm07iuCruZvckdEOY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-gzXCXNEsOVaR2e1Nlh-Y7A-1; Mon, 07 Jun 2021 21:00:28 -0400
X-MC-Unique: gzXCXNEsOVaR2e1Nlh-Y7A-1
Received: by mail-pg1-f197.google.com with SMTP id t10-20020a6564ca0000b02902205085fa58so11179389pgv.16
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 18:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=l9Hxnp9TzX1Qa0LPCbDI+r/Swgm1W5T0HqpzgDaMsIM=;
        b=FZNtGCwrpnjpyE/jsqUHlCYf9YS/RVm1RIxyRUnBghJ+zOpma87OLhc6yXEmnElxQi
         1KAAXMqil0OefZ+XF4+f7AKrQX/2aDImUWC8gsNgEwF8JovM3PHjR2J9ZUXnOsPfGIjh
         XwVb65x1ieHHbmJWj1JjvMMTip4Wx5zJyjCnpsrqhCeNk8SD0B6UwUBbkMc7GZ+El9LY
         IgYbNSSoE3kNtvJiNFB0YabDGc3hYBCd1Fngg75f9T26dNOFghmAdNV1NL2JVe6kIGGh
         /HVrB7Fe8HaW89Z0AIzVlzU2aIthQQ20myQxl/C7/Qoo6hnCLfCdf808kv+Q9OxW0PA8
         bC6g==
X-Gm-Message-State: AOAM5336118BXT6ZYatHlz4BHw02ML1lUTxYCMp0jFNes4b9gRlL88Z6
        hRrcpUEuV1mIzCHm6dCGy7x1dWh5+Fm4jLcUHvUIV08GD6axbDEdl6ixWFlLM5OmtGOU9xegbui
        nHrQNcWC5vX5m
X-Received: by 2002:a17:90a:db0f:: with SMTP id g15mr1973144pjv.156.1623114026999;
        Mon, 07 Jun 2021 18:00:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYWbmdIHR4JeIkPyMKnrD47V0fE4/gLC34oE2C1BXzJ6Yk+6wQV2cQXaOEH+lTIww5tPr8Pg==
X-Received: by 2002:a17:90a:db0f:: with SMTP id g15mr1973123pjv.156.1623114026742;
        Mon, 07 Jun 2021 18:00:26 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w142sm9258485pff.154.2021.06.07.18.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 18:00:26 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerd Hoffmann <kraxel@redhat.com>
References: <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
 <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
 <20210604115805.GG1002214@nvidia.com>
 <895671cc-5ef8-bc1a-734c-e9e2fdf03652@redhat.com>
 <20210607141424.GF1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1cf9651a-b8ee-11f1-1f70-db3492a76400@redhat.com>
Date:   Tue, 8 Jun 2021 09:00:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607141424.GF1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/7 ÏÂÎç10:14, Jason Gunthorpe Ð´µÀ:
> On Mon, Jun 07, 2021 at 11:18:33AM +0800, Jason Wang wrote:
>
>> Note that no drivers call these things doesn't meant it was not
>> supported by the spec.
> Of course it does. If the spec doesn't define exactly when the driver
> should call the cache flushes for no-snoop transactions then the
> protocol doesn't support no-soop.


Just to make sure we are in the same page. What I meant is, if the DMA 
behavior like (no-snoop) is device specific. There's no need to mandate 
a virtio general attributes. We can describe it per device. The devices 
implemented in the current spec does not use non-coherent DMA doesn't 
mean any future devices won't do that. The driver could choose to use 
transport (e.g PCI), platform (ACPI) or device specific (general virtio 
command) way to detect and flush cache when necessary.


>
> no-snoop is only used in very specific sequences of operations, like
> certain GPU usages, because regaining coherence on x86 is incredibly
> expensive.
>
> ie I wouldn't ever expect a NIC to use no-snoop because NIC's expect
> packets to be processed by the CPU.


For NIC yes. But virtio is more that just NIC. We've already supported 
GPU and crypto devices. In this case, no-snoop will be useful since the 
data is not necessarily expected to be processed by CPU.

And a lot of other type of devices are being proposed.

Thanks


>
> "non-coherent DMA" is some general euphemism that evokes images of
> embedded platforms that don't have coherent DMA at all and have low
> cost ways to regain coherence. This is not at all what we are talking
> about here at all.
>   
> Jason
>

