Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75D939F80A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhFHNqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233049AbhFHNqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 09:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623159871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5paOCX7lF4w7/DDN73q8qlAZey0BD12yaLQLY3fG8Y=;
        b=HvMw9IuGh0vc7C/c703ESVOZF4j+SHKn48EEmlSBuaz0ssRmH9w5Io+Y6iU40OIPAB6WJ+
        uUyWgyRLUh8A2lbzc/4IUC0uewx58RxNl9niW1fkY2kAHhPD/VNkXv5KIB+jFaHsacLaYb
        VeW4SXSpDACTU62OYEREA9fhw2ORhAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-cW6FuMHGN_y8g2-Pvunv9g-1; Tue, 08 Jun 2021 09:44:29 -0400
X-MC-Unique: cW6FuMHGN_y8g2-Pvunv9g-1
Received: by mail-wr1-f70.google.com with SMTP id z3-20020adfdf830000b02901198337bc39so8890097wrl.0
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 06:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A5paOCX7lF4w7/DDN73q8qlAZey0BD12yaLQLY3fG8Y=;
        b=BqxfS1ZooJuSD8aH3/rJTNLVkAaXwVvBKJFB88k3/NdPz1DPXHFP6ZShYyWbkr/tiO
         jSBo8amfdXrIvKpuUKWhGar7It1GPTuSWQ1A51Pb7hvj4p1YfUZvSkqOZ4NH+pcSDSah
         lxcgRxVykKJrpsCC+5KBr24SDT5jJRnEWlRb6BFVIL58zVabejzaesHYL9P22IoPyOmb
         AtRvh9j6lLRnpguRZbweVFq8QsIfWzl9tulruVJkzgdzbt0We91eW9D54mWita+SAYYT
         /Fi1fbJNHSv08k6Sqpr+zz7lUx02VK/vOIqqNLJauexLi3esKdUW4ZMBDcoKRPzl88p0
         cnLA==
X-Gm-Message-State: AOAM530NVs+W2//f18M7+55eg5xc6Eeg3OS1y6c0zSgFg1l5XBpCU3ex
        18FsoKuyawKSJ52OBuBk6Lzz2rLFteVm6UlfekIj55c9foc0Zq0hvF2MkPqK0xNYC/Jm+dKfqig
        IRzprCm0O7qT2
X-Received: by 2002:a1c:770b:: with SMTP id t11mr4365992wmi.79.1623159868319;
        Tue, 08 Jun 2021 06:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ4k7LKRkmCCY0f1XvUXyPaQaBTTeWBOUxIheggqPU28l8+khIBLNZhCQK0mJgXqCT2XApuw==
X-Received: by 2002:a1c:770b:: with SMTP id t11mr4365974wmi.79.1623159868149;
        Tue, 08 Jun 2021 06:44:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o17sm19012181wrp.47.2021.06.08.06.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 06:44:27 -0700 (PDT)
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
        Jason Wang <jasowang@redhat.com>
References: <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
Date:   Tue, 8 Jun 2021 15:44:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608131547.GE1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/21 15:15, Jason Gunthorpe wrote:
> On Tue, Jun 08, 2021 at 09:56:09AM +0200, Paolo Bonzini wrote:
> 
>>>> Alternatively you can add a KVM_DEV_IOASID_{ADD,DEL} pair of ioctls. But it
>>>> seems useless complication compared to just using what we have now, at least
>>>> while VMs only use IOASIDs via VFIO.
>>>
>>> The simplest is KVM_ENABLE_WBINVD(<fd security proof>) and be done
>>> with it.
>>
>> The simplest one is KVM_DEV_VFIO_GROUP_ADD/DEL, that already exists and also
>> covers hot-unplug.  The second simplest one is KVM_DEV_IOASID_ADD/DEL.
> 
> This isn't the same thing, this is back to trying to have the kernel
> set policy for userspace.

If you want a userspace policy then there would be three states:

* WBINVD enabled because a WBINVD-enabled VFIO device is attached.

* WBINVD potentially enabled but no WBINVD-enabled VFIO device attached

* WBINVD forcefully disabled

KVM_DEV_VFIO_GROUP_ADD/DEL can still be used to distinguish the first 
two.  Due to backwards compatibility, those two describe the default 
behavior; disabling wbinvd can be done easily with a new sub-ioctl of 
KVM_ENABLE_CAP and doesn't require any security proof.

The meaning of WBINVD-enabled is "won't return -ENXIO for the wbinvd 
ioctl", nothing more nothing less.  If all VFIO devices are going to be 
WBINVD-enabled, then that will reflect on KVM as well, and I won't have 
anything to object if there's consensus on the device assignment side of 
things that the wbinvd ioctl won't ever fail.

Paolo

