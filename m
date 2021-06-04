Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE44A39AF62
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 03:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFDBNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 21:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFDBNB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 21:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622769075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74wa3D7052FGdwsOb19pvsgbuYGA5vLypJgGwvpg9kA=;
        b=ge9WzvkFj4vOnEKDAUqvdpbRtF0oZeWg/E7bYmGtDTvDXcDQ6TXRcj/Y20lxWKhAtsOBtU
        mcJq83w+qFwYzB56iGb252M3D/hN1jz3rX0cqEOu9husQAOzJd5dhdF3EN0GPIgcuCRlo8
        3Algy2r+Y5SBwSxezoFioJdM/yqLRGc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-p3XNhtQ7NYKONMi1Ama3ag-1; Thu, 03 Jun 2021 21:11:14 -0400
X-MC-Unique: p3XNhtQ7NYKONMi1Ama3ag-1
Received: by mail-pg1-f199.google.com with SMTP id 15-20020a630c4f0000b029021a6da9af28so4941998pgm.22
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 18:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=74wa3D7052FGdwsOb19pvsgbuYGA5vLypJgGwvpg9kA=;
        b=pBvuX/CRl4KNu1GhURy2xMWIt4d/DgGmp2TDGYuSu6DTnd6r9t+zYWOxX3GiRi6txy
         pKBcnq6vMHczPT3b74ifY38WcHOxe6fkEMjvByX9ndjWb9iXSo0WwaykC4pZ/c6KkfOt
         9WVKmWyLeDmjdIWCgHxgMmc9ak0ev5VQSKFV7NJmkEb8gJ8Imimap2OVZLre8PYd96DO
         z6xwbY6RybgKEA09kuS/nLfEMTKppg5EeF+0jjiueUd51NRliA3qs5s3enfbrPIZ2qiA
         J5rOoeEFglxcIuO9DcRMwJF9yrGWCKTZKLe8EmTKxfxk5rO1z3U4lQoVwN9jgtpSsIU4
         SaHQ==
X-Gm-Message-State: AOAM531en6ZFB+lm5Z9dN31EqaAx0nLQQCedLsIHwj3E8MtlJRLJ/BD/
        243RMI+TjkRJ23dGH92Ih6JYs5gHHdmjDHLSivmjZ4Y1d4c+HXlMOZKCyCZt4AbqQjKe0AG5B2l
        zQEUkh4jSxPcY
X-Received: by 2002:a63:370b:: with SMTP id e11mr2255872pga.356.1622769073849;
        Thu, 03 Jun 2021 18:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw19wf1A8+65Q36xarUBfhf8NPj5f2hsFRG2/Iexl5uV4W9R5ePiMPVn1Z2bNWIP1oHtD7E3w==
X-Received: by 2002:a63:370b:: with SMTP id e11mr2255853pga.356.1622769073569;
        Thu, 03 Jun 2021 18:11:13 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h18sm248362pgl.87.2021.06.03.18.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 18:11:13 -0700 (PDT)
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
        David Woodhouse <dwmw2@infradead.org>
References: <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
Date:   Fri, 4 Jun 2021 09:11:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603130927.GZ1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/3 ÏÂÎç9:09, Jason Gunthorpe Ð´µÀ:
> On Thu, Jun 03, 2021 at 10:52:51AM +0800, Jason Wang wrote:
>
>> Basically, we don't want to bother with pseudo KVM device like what VFIO
>> did. So for simplicity, we rules out the IOMMU that can't enforce coherency
>> in vhost-vDPA if the parent purely depends on the platform IOMMU:
> VDPA HW cannot issue no-snoop TLPs in the first place.


Note that virtio/vDPA is not necessarily a PCI device.


>
> virtio does not define a protocol to discover such a functionality,


Actually we had:

VIRTIO_F_ACCESS_PLATFORM(33)
This feature indicates that the device can be used on a platform where 
device access to data in memory is limited and/or translated. E.g. this 
is the case if the device can be located behind an IOMMU that translates 
bus addresses from the device into physical addresses in memory, if the 
device can be limited to only access certain memory addresses or if 
special commands such as a cache flush can be needed to synchronise data 
in memory with the device.


> nor do any virtio drivers implement the required platform specific
> cache flushing to make no-snoop TLPs work.


I don't get why virtio drivers needs to do that. I think DMA API should 
hide those arch/platform specific stuffs from us.


>
> It is fundamentally part of the virtio HW PCI API that a device vendor
> cannot alter.


The spec doesn't forbid this, and it just leave the detection and action 
to the driver in a platform specific way.

Thanks


>
> Basically since we already know that the virtio kernel drivers do not
> call the cache flush instruction we don't need the weird KVM logic to
> turn it on at all.
>
> Enforcing no-snoop at the IOMMU here is redundant/confusing.
>
> Jason
>

