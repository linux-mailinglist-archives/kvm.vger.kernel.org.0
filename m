Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974D639EB49
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 03:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhFHBWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 21:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhFHBWe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 21:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623115242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCwzQn65+dgzBoFvWj2wr+QLjXlAu9EeWSx0GqEzC4M=;
        b=hj2ZlBF56qdE51oVdoOYR17j6mV4SpmuNhkGRKqNRM3m2j05SbCyN9DIw1y4WYcCakJkYR
        m/a5IE+RZoKEQLnPtuZdIf0ORQs1fTJr/YCXFwRUYsKIJpsU6RppO34rhpqjWpe8BbzmHG
        8EekV3O5u8f/b2ceS2Fayzp1LK3U2nM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-T_l2Hvi6NxGn1-oVvPppOg-1; Mon, 07 Jun 2021 21:20:41 -0400
X-MC-Unique: T_l2Hvi6NxGn1-oVvPppOg-1
Received: by mail-pf1-f197.google.com with SMTP id y11-20020aa79e0b0000b02902e9e0e19fdcso8591534pfq.14
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 18:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TCwzQn65+dgzBoFvWj2wr+QLjXlAu9EeWSx0GqEzC4M=;
        b=lHT6dWncjFLHO6AqlW0/Kjastco0SymTGf73L8osSqSBRcitb3EhkzhqkmNguiOFPJ
         gN2QTMIXzVO1aFDdPsWPeBsdVN7ivpkw7qrHUd3JZeKAxhVj20ZnRi1B8HwL8SWbajVJ
         pLg2YxEhKOmB0OmvzrsDNyiYr4LDLo+6XSXErYuXnJLMZmwMVonXVAFFOCmElYmVmv/4
         IFSWesVVvVlkxm0F35TUcSvC5Ne6yfCAV+bBqy7dpIx3EdJlqS1T8QJbhgyT3UMR6LkQ
         mKlxlhQFipUtY/XswxlCZUaGRHmbru2uGA80xFJlGbuLUV6fzsPOQ/LIt98sKnr1zso0
         3JbQ==
X-Gm-Message-State: AOAM533aBFisKstUUwwe2pgtvoo5RqW+cKF/7YHc68TJTsgXEX3+FvMv
        2qDddI465Ojl5XGIb3NdO5+4lCmxzogXYRLinhTWwekE+P6E4F2wE3Va2Poa4eV8/CwkCamU5lA
        YF2yAJvr0IVIX
X-Received: by 2002:a17:90a:c20b:: with SMTP id e11mr2002394pjt.67.1623115240160;
        Mon, 07 Jun 2021 18:20:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPiYk/pvMKx+vaHmZlDroPiezFsE2XFpj2cfJDKpSRv32vxsQprEkdJWoAQEkbam2OXdw2Rw==
X-Received: by 2002:a17:90a:c20b:: with SMTP id e11mr2002339pjt.67.1623115239324;
        Mon, 07 Jun 2021 18:20:39 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm9342812pfb.19.2021.06.07.18.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 18:20:38 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        David Woodhouse <dwmw2@infradead.org>
References: <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <20210604230108.GB1002214@nvidia.com>
 <20210607094148.7e2341fc.alex.williamson@redhat.com>
 <20210607181858.GM1002214@nvidia.com>
 <20210607125946.056aafa2.alex.williamson@redhat.com>
 <20210607190802.GO1002214@nvidia.com>
 <20210607134128.58c2ea31.alex.williamson@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <12631cf3-4ef8-7c38-73bb-649d57c0226b@redhat.com>
Date:   Tue, 8 Jun 2021 09:20:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607134128.58c2ea31.alex.williamson@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/8 ÉÏÎç3:41, Alex Williamson Ð´µÀ:
> On Mon, 7 Jun 2021 16:08:02 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Mon, Jun 07, 2021 at 12:59:46PM -0600, Alex Williamson wrote:
>>
>>>> It is up to qemu if it wants to proceed or not. There is no issue with
>>>> allowing the use of no-snoop and blocking wbinvd, other than some
>>>> drivers may malfunction. If the user is certain they don't have
>>>> malfunctioning drivers then no issue to go ahead.
>>> A driver that knows how to use the device in a coherent way can
>>> certainly proceed, but I suspect that's not something we can ask of
>>> QEMU.  QEMU has no visibility to the in-use driver and sketchy ability
>>> to virtualize the no-snoop enable bit to prevent non-coherent DMA from
>>> the device.  There might be an experimental ("x-" prefixed) QEMU device
>>> option to allow user override, but QEMU should disallow the possibility
>>> of malfunctioning drivers by default.  If we have devices that probe as
>>> supporting no-snoop, but actually can't generate such traffic, we might
>>> need a quirk list somewhere.
>> Compatibility is important, but when I look in the kernel code I see
>> very few places that call wbinvd(). Basically all DRM for something
>> relavent to qemu.
>>
>> That tells me that the vast majority of PCI devices do not generate
>> no-snoop traffic.
> Unfortunately, even just looking at devices across a couple laptops
> most devices do support and have NoSnoop+ set by default.  I don't
> notice anything in the kernel that actually tries to set this enable (a
> handful that actively disable), so I assume it's done by the firmware.


I wonder whether or not it was done via ACPI:

"

6.2.17 _CCA (Cache Coherency Attribute) The _CCA object returns whether 
or not a bus-master device supports hardware managed cache coherency. 
Expected values are 0 to indicate it is not supported, and 1 to indicate 
that it is supported. All other values are reserved.

...

On Intel platforms, if the _CCA object is not supplied, the OSPM will 
assume the devices are hardware cache coherent.

"

Thanks


> It's not safe for QEMU to make an assumption that only GPUs will
> actually make use of it.
>
>>>> I think it makes the software design much simpler if the security
>>>> check is very simple. Possessing a suitable device in an ioasid fd
>>>> container is enough to flip on the feature and we don't need to track
>>>> changes from that point on. We don't need to revoke wbinvd if the
>>>> ioasid fd changes, for instance. Better to keep the kernel very simple
>>>> in this regard.
>>> You're suggesting that a user isn't forced to give up wbinvd emulation
>>> if they lose access to their device?
>> Sure, why do we need to be stricter? It is the same logic I gave
>> earlier, once an attacker process has access to wbinvd an attacker can
>> just keep its access indefinitely.
>>
>> The main use case for revokation assumes that qemu would be
>> compromised after a device is hot-unplugged and you want to block off
>> wbinvd. But I have a hard time seeing that as useful enough to justify
>> all the complicated code to do it...
> It's currently just a matter of the kvm-vfio device holding a reference
> to the group so that it cannot be used elsewhere so long as it's being
> used to elevate privileges on a given KVM instance.  If we conclude that
> access to a device with the right capability is required to gain a
> privilege, I don't really see how we can wave aside that the privilege
> isn't lost with the device.
>
>> For KVM qemu can turn on/off on hot plug events as it requires to give
>> VM security. It doesn't need to rely on the kernel to control this.
> Yes, QEMU can reject a hot-unplug event, but then QEMU retains the
> privilege that the device grants it.  Releasing the device and
> retaining the privileged gained by it seems wrong.  Thanks,
>
> Alex
>

