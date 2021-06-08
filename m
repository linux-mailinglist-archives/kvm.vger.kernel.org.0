Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893D839F000
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 09:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFHH6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 03:58:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230269AbhFHH6L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 03:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623138978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zYa5WyN5uAc4A4H86TawfNojJdggPMlZ/sRJ1BGKDOY=;
        b=hJBLqZ2NABIxr2ZV/r0H++Ps67V0vrQNBltsHD0Ce9zuaGgBVtguo+h2fvqRTfBqiwvJYY
        /ImCqOUAEHYx2B9OUYc9eZJZ5cgDPfcdXTg4pvqWldpjI4devyGLiOmr0d6Ig42yQzbzkw
        LMMSkGjo5s6gF+aERP8hIA6M1EGnwdY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-RRdvQKVSMAG3mnOO4OEA4g-1; Tue, 08 Jun 2021 03:56:13 -0400
X-MC-Unique: RRdvQKVSMAG3mnOO4OEA4g-1
Received: by mail-wr1-f71.google.com with SMTP id k11-20020adfe3cb0000b0290115c29d165cso9041891wrm.14
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 00:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zYa5WyN5uAc4A4H86TawfNojJdggPMlZ/sRJ1BGKDOY=;
        b=qOT2xjaeoqybZs/P/eMcofiYhY5ZTGsWGepeWR8m8h2cSxrVVOwydcg6o29fmvQenq
         BXkDpH4MxLb6GYzUpk15orMONlyRnucpW5BMdE3v32UKouDimffjlyXxTqyUpr9Dkl6a
         fXPvBem+EW0nc3ZPkpN32QKElKbGsOH+Ul1EwTz63TFTF/mbKWh2RWM2S5Ipi+WT8jtz
         IHJPIYHGg3fuDhqrRNz1n0uIY118Q5TxQr/tPErIBIo18FhJOacPjhB8qHjkV4K3kqbU
         6VWWQWxqL3Q2pEhuwlFR7ZkUHGCnUcIDh9eH7VAUCgZ43gIwzxC04WipHKjIhMF9HRqj
         a2xQ==
X-Gm-Message-State: AOAM53061IDiwsq6U82bwnniChfOpqaOMvHoc0EGuidSWrmllxvs3GDJ
        QUEN1+Mgse3FJUfoyebFiMhLjt+0oLS8CMcDFSXqHvTcF1mCt+arjr3ndM+sfZj+rtkRmgCPZjs
        K+IfiAmZPSaze
X-Received: by 2002:a5d:5752:: with SMTP id q18mr21241450wrw.419.1623138972167;
        Tue, 08 Jun 2021 00:56:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxv6B3Fm9uWkkuLZ42Sp23/j0I/On5RIFlSJAMEPX1XlarvGPgTQWrWA1V8+3s21lkavNZEgg==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr21241386wrw.419.1623138971579;
        Tue, 08 Jun 2021 00:56:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l31sm1910414wms.16.2021.06.08.00.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 00:56:11 -0700 (PDT)
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
        Jason Wang <jasowang@redhat.com>
References: <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
Date:   Tue, 8 Jun 2021 09:56:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607175926.GJ1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 19:59, Jason Gunthorpe wrote:
>> The KVM interface is the same kvm-vfio device that exists already.  The
>> userspace API does not need to change at all: adding one VFIO file
>> descriptor with WBINVD enabled to the kvm-vfio device lets the VM use WBINVD
>> functionality (see kvm_vfio_update_coherency).
>
> The problem is we are talking about adding a new /dev/ioasid FD and it
> won't fit into the existing KVM VFIO FD interface. There are lots of
> options here, one is to add new ioctls that specifically use the new
> FD, the other is to somehow use VFIO as a proxy to carry things to the
> /dev/ioasid FD code.

Exactly.

>> Alternatively you can add a KVM_DEV_IOASID_{ADD,DEL} pair of ioctls. But it
>> seems useless complication compared to just using what we have now, at least
>> while VMs only use IOASIDs via VFIO.
>
> The simplest is KVM_ENABLE_WBINVD(<fd security proof>) and be done
> with it.

The simplest one is KVM_DEV_VFIO_GROUP_ADD/DEL, that already exists and 
also covers hot-unplug.  The second simplest one is KVM_DEV_IOASID_ADD/DEL.

It need not be limited to wbinvd support, it's just a generic "let VMs 
do what userspace can do if it has access to this file descriptor". 
That it enables guest WBINVD is an implementation detail.

>> Either way, there should be no policy attached to the add/delete operations.
>> KVM users want to add the VFIO (or IOASID) file descriptors to the device
>> independent of WBINVD.  If userspace wants/needs to apply its own policy on
>> whether to enable WBINVD or not, they can do it on the VFIO/IOASID side:
> 
> Why does KVM need to know abut IOASID's? I don't think it can do
> anything with this general information.

Indeed, it only uses them as the security proofs---either VFIO or IOASID 
file descriptors can be used as such.

Paolo

