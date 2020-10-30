Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA6D2A0361
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgJ3Kye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:54:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbgJ3Kye (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 06:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604055272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNcsDz2cy5Yr+LEYgMRQaMYGAlPoileX7l+cMy1V2mc=;
        b=JcV45RN+NwNFMLQ2vPQbUP8pMqFMofswjVPBdRz+pllSkLpwIGG9uA6pCQjCbBMZShSQD/
        bu8a/DyXB4gRzkV1TTuVVOdI8PztvU3S6caamFSMtjehTwi3u86wV4XBbx9qMV6QyZ12uN
        2Rw+n9EwJpXm5BWWpZHa1FOd5k2yxMU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-6lg78MlgPR6J2HCzv6jENw-1; Fri, 30 Oct 2020 06:54:31 -0400
X-MC-Unique: 6lg78MlgPR6J2HCzv6jENw-1
Received: by mail-wr1-f69.google.com with SMTP id i1so2496729wrb.18
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eNcsDz2cy5Yr+LEYgMRQaMYGAlPoileX7l+cMy1V2mc=;
        b=L77qPhORJ8wHA6NBnY2lVJiSxqVumM21limcn43Pk+4R7BWhYXHsHUOChN5PiUMAGx
         rUT8kCZPMKc1+VCoNgKnyT1TfZwcZGgWZhkpUPM7v5NA0dXGD1RXQ+WYBCmddgyFEgPr
         ho0rqRqmaoE5MHtRe0sLRCEu2gEMRqYQ79BSQrU2sKhblc/U5fkgeujaRKA7f7sDJUw9
         U+3c9ypLnUPVg/UkaPkPv9K2vUTfGyGpoCvan7n/4h6yPZPW/I98hEjdeTweB30LOTNU
         BZzUf2/g4yugQp+zAo1rtOTh8SJNhQCqyupK1Uzj6rWN2lWRALMabq3bGcGZ04ncDcoC
         48lA==
X-Gm-Message-State: AOAM532jFFqJd3EX0jI9jkCUBH9RfldoIG+KP+4u/lLYUMefTqDrBiv4
        hvOAf4swoMl7yrClPOTP2jY9VzgifL0ujK48iPt9lWl+zyQnHzcrV8XtRSKBbnWFvtsohdxB1Gv
        c6ApxWByR0rL/
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr2069444wmk.106.1604055269704;
        Fri, 30 Oct 2020 03:54:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzY5s4HQ3sHRjqMi8kZt0VprXDyGubGokKC7oZxhjQ9kRgwiCSE61bhqv62SbSqffXe8fXikA==
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr2069422wmk.106.1604055269495;
        Fri, 30 Oct 2020 03:54:29 -0700 (PDT)
Received: from steredhat (host-79-22-200-33.retail.telecomitalia.it. [79.22.200.33])
        by smtp.gmail.com with ESMTPSA id x65sm4178936wmg.1.2020.10.30.03.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:54:28 -0700 (PDT)
Date:   Fri, 30 Oct 2020 11:54:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
Message-ID: <20201030105422.ju2aj2bmwsckdufh@steredhat>
References: <20201029174351.134173-1-sgarzare@redhat.com>
 <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 06:02:18PM +0800, Jason Wang wrote:
>
>On 2020/10/30 上午1:43, Stefano Garzarella wrote:
>>This patch enables the IOTLB API support for vhost-vsock devices,
>>allowing the userspace to emulate an IOMMU for the guest.
>>
>>These changes were made following vhost-net, in details this patch:
>>- exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>>   device if the feature is acked
>>- implements VHOST_GET_BACKEND_FEATURES and
>>   VHOST_SET_BACKEND_FEATURES ioctls
>>- calls vq_meta_prefetch() before vq processing to prefetch vq
>>   metadata address in IOTLB
>>- provides .read_iter, .write_iter, and .poll callbacks for the
>>   chardev; they are used by the userspace to exchange IOTLB messages
>>
>>This patch was tested with QEMU and a patch applied [1] to fix a
>>simple issue:
>>     $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>>            -drive file=fedora.qcow2,format=qcow2,if=virtio \
>>            -device intel-iommu,intremap=on \
>>            -device vhost-vsock-pci,guest-cid=3,iommu_platform=on
>
>
>Patch looks good, but a question:
>
>It looks to me you don't enable ATS which means vhost won't get any 
>invalidation request or did I miss anything?
>

You're right, I didn't see invalidation requests, only miss and updates.
Now I have tried to enable 'ats' and 'device-iotlb' but I still don't 
see any invalidation.

How can I test it? (Sorry but I don't have much experience yet with 
vIOMMU)

Thanks,
Stefano

