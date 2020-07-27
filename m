Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF83022EB7B
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgG0Lwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgG0Lwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 07:52:44 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81777C061794
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 04:52:42 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c2so6055599edx.8
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 04:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=D5pQiMPzLB8XD5JHM4wdoWxT4TgqCFRpOcFljgyTlfc=;
        b=K3CK0lxO2t8MyWxIBSrkltJCVJh7mLsvW2hqQK75KIpcJdI6shjwejuVcaD2hN10Sy
         XmUGeS5ZhpQ//k9mjCdxLGUgkzwPCtJDOe6QXpWr+d3SPbLTiAYCgs0v27wVIYyZ1uBd
         OcZn+xroudR4UzgnffapO5Yw6SDzV0kKiwJDxAurvtpV3r25A6aJd0yA/qILRcEZLKqp
         XQZFeONuAs0DTEqQCcg74OhB54RxAaFmw7ywGEdliCJBqk93YUMXQbE3zik3qfQOLkEm
         +U/TPxXY3UAn8CwtH6KZDw8pVuTdQdc9NTsgXBU0erkaSPowlM934kzZ6g6slUHeFLJj
         /PUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D5pQiMPzLB8XD5JHM4wdoWxT4TgqCFRpOcFljgyTlfc=;
        b=fQxzvZVe/PUG7eajwZ1qerUEgC1TdrJhWqfVsqFDIKUvNQH90H7GO65mpVfXVBID5Z
         s73d3XtHqXAX1z1XpYi6AyOabbsYi3/SZFt7HPGFkZ0u16CminMziQKxaACWkaZsb+he
         4CkshKwlqlc63LjOUKgqo5bmtp5uY6ExF79wKobgRy3e/e+C2PE1zUKJF8cu7YRboKBC
         wyyXK2+6cZBJnRKGCDPde6kpescaqcRGnhGzRRZZCy/2zvgEA2kGmcmsSUgLRV8rPcfM
         HNEGY9pIJzaHZUBSDY91WaoVXV5JC4KuARcjsgdnwoC3UYMsSlNllMHvyFRSXQQargUI
         aFMA==
X-Gm-Message-State: AOAM533o8GnvO27hmHJq+0ynzo60nag89PiCVEmAD/hLJITYZM9XzMjt
        rFsJo5p9uIqZ62g1rFxRxCzp6g==
X-Google-Smtp-Source: ABdhPJyz7oMH5aj3Z7KcOTsoBp1IC9xCaWx+x2xvCBguSsbEnabd8V4mqYOIHsCAcbXk/z+m6gJynw==
X-Received: by 2002:a50:fd8d:: with SMTP id o13mr1277004edt.313.1595850761074;
        Mon, 27 Jul 2020 04:52:41 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id h19sm6777631ejt.115.2020.07.27.04.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 04:52:40 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:52:25 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        Jag Raman <jag.raman@oracle.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200727115225.GA12008@myrica>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
 <874kq1w3bz.fsf@linaro.org>
 <20200727101403.GF380177@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200727101403.GF380177@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 11:14:03AM +0100, Stefan Hajnoczi wrote:
> On Tue, Jul 21, 2020 at 11:49:04AM +0100, Alex Bennée wrote:
> > Stefan Hajnoczi <stefanha@gmail.com> writes:
> > > 2. Alexander Graf's idea for a new Linux driver that provides an
> > > enforcing software IOMMU. This would be a character device driver that
> > > is mmapped by the device emulation process (either vhost-user-style on
> > > the host or another VMM for inter-VM device emulation). The Driver VMM
> > > can program mappings into the device and the page tables in the device
> > > emulation process will be updated. This way the Driver VMM can share
> > > memory specific regions of guest RAM with the device emulation process
> > > and revoke those mappings later.
> > 
> > I'm wondering if there is enough plumbing on the guest side so a guest
> > can use the virtio-iommu to mark out exactly which bits of memory the
> > virtual device can have access to? At a minimum the virtqueues need to
> > be accessible and for larger transfers maybe a bounce buffer. However

Just to make sure I didn't misunderstand - do you want to tell the guest
precisely where the buffers are, like "address X is the used ring, address
Y is the descriptor table", or do you want to specify a range of memory
where the guest can allocate DMA buffers, in no specific order, for a
given device?  So far I've assumed we're talking about the latter.

> > for speed you want as wide as possible mapping but no more. It would be
> > nice for example if a block device could load data directly into the
> > guests block cache (zero-copy) but without getting a view of the kernels
> > internal data structures.
> 
> Maybe Jean-Philippe or Eric can answer that?

Virtio-iommu could describe which bits of guest-physical memory is
available for DMA for a given device. It already provides a mechanism for
describing per-device memory properties (the PROBE request) which is
extensible. And I think the virtio-iommu device could be used exclusively
for this, too, by having DMA bypass the VA->PA translation
(VIRTIO_IOMMU_F_BYPASS) and only enforcing guest-physical boundaries. Or
just describe the memory and not enforce anything.

I don't know how to plug this into the DMA layer of a Linux guest, though,
but there seems to exist a per-device DMA pool infrastructure. Have you
looked at rproc_add_virtio_dev()?  It seems to allocates a specific DMA
region per device, from a "memory-region" device-tree property, so perhaps
you could simply reuse this.

Thanks,
Jean

> 
> > Another thing that came across in the call was quite a lot of
> > assumptions about QEMU and Linux w.r.t virtio. While our project will
> > likely have Linux as a guest OS we are looking specifically at enabling
> > virtio for Type-1 hypervisors like Xen and the various safety certified
> > proprietary ones. It is unlikely that QEMU would be used as the VMM for
> > these deployments. We want to work out what sort of common facilities
> > hypervisors need to support to enable virtio so the daemons can be
> > re-usable and maybe setup with a minimal shim for the particular
> > hypervisor in question.
> 
> The vhost-user protocol together with the backend program conventions
> define the wire protocol and command-line interface (see
> docs/interop/vhost-user.rst).
> 
> vhost-user is already used by other VMMs today. For example,
> cloud-hypervisor implements vhost-user.
> 
> I'm sure there is room for improvement, but it seems like an incremental
> step given that vhost-user already tries to cater for this scenario.
> 
> Are there any specific gaps you have identified?
> 
> Stefan


