Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A48227D99
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgGUKtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 06:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbgGUKtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 06:49:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79121C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 03:49:08 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f18so2390372wml.3
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 03:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BwjPlzHMUtPVG0XJ6cyWe/umel7VC/2YOnRDeZNJZF8=;
        b=b8YkF4CgyWzejoHcBbMAHm/ntjlF7NtM9HmxZNVcV7aVXzO5ahQcfo3RWZuifuPVYF
         2/0NQ+cLlFstL1EvtTbCb696gdkyMfXk+l5v5cPA50fnZkW0M6+gdH1OGYKctfL3EkCa
         R7758mgdkJiAFJMcVxQ6hwOTlLnLXuCyqzzW+aGIbGsNCP9SulthcrviFkZP5P3bNncD
         NMhHGue8hfw2HCXDq/g9/xYh6gY2xkplwXxefogAr9bP9wSbmWKR0WXDilw5F1w0vZbD
         8bpTL2ebErExsqSvYCxbrQc4POnLR8iOSoBzyL2GMbxQuSIdDJTb27PVspeNBqAiwDZE
         JTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=BwjPlzHMUtPVG0XJ6cyWe/umel7VC/2YOnRDeZNJZF8=;
        b=CeHRnjd131JM6u31jDS6QLO+gJFc6zhfniKkYhpYqUoV1JC5fNkqv2N/UfvrbFbfvB
         ziWfd/ZLAN/UGVHgSJTp1s7LEXNuRFccIWhGgWBpiDEU23MDe9yzGqAdaDm3sEbqw648
         /k5zg64gJEkgNFhUYQiquPFy39vqk4twpKa9dQYgpxgwgkxDeyR/cj3eH+z6NiraR9p4
         IQEDQjBsKv4OzhTFSyBjsPA0GYoJEYalxmcHUJyNW0QzEo1BG7vGH0qFotqkBqUsh74S
         cPZ0FDdM4Ievh3JlFfJV6SrdT0LwfasaIdpqE4mHtzXlZuKjz4YOlNCMSlLP+eEpO79S
         qkIg==
X-Gm-Message-State: AOAM533Ql2q0GTulXWSHuFEfGjB5fGg/KazC1rikZRNaVe10Rj3Wrfsd
        Uz3OLl6runEdTMMjoer6JaEB4w==
X-Google-Smtp-Source: ABdhPJzOYUQPu+9u+WdYV7gQrEhOcaf1fAhKgr73grq/S8XnC7DQy5zSNafFz8FD3WON0KCpPTpuxQ==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr3367915wmm.156.1595328546908;
        Tue, 21 Jul 2020 03:49:06 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id l15sm35877030wro.33.2020.07.21.03.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:49:05 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 01FAB1FF7E;
        Tue, 21 Jul 2020 11:49:05 +0100 (BST)
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
User-agent: mu4e 1.5.5; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
In-reply-to: <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
Date:   Tue, 21 Jul 2020 11:49:04 +0100
Message-ID: <874kq1w3bz.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Stefan Hajnoczi <stefanha@gmail.com> writes:

> Thank you everyone who joined!
>
> I didn't take notes but two things stood out:
>
> 1. The ivshmem v2 and virtio-vhost-user use cases are quite different
> so combining them does not seem realistic. ivshmem v2 needs to be as
> simple for the hypervisor to implement as possible even if this
> involves some sacrifices (e.g. not transparent to the Driver VM that
> is accessing the device, performance). virtio-vhost-user is more aimed
> at general-purpose device emulation although support for arbitrary
> devices (e.g. PCI) would be important to serve all use cases.

I believe my phone gave up on the last few minutes of the call so I'll
just say we are interested in being able to implement arbitrary devices
in the inter-VM silos. Devices we are looking at:

  virtio-audio
  virtio-video

these are performance sensitive devices which provide a HAL abstraction
to a common software core.

  virtio-rpmb

this is a secure device where the backend may need to reside in a secure
virtualised world.

  virtio-scmi

this is a more complex device which allows the guest to make power and
clock demands from the firmware. Needless to say this starts to become
complex with multiple moving parts.

The flexibility of vhost-user seems to match up quite well with wanting
to have a reasonably portable backend that just needs to be fed signals
and a memory mapping. However we don't want daemons to automatically
have a full view of the whole of the guests system memory.

> 2. Alexander Graf's idea for a new Linux driver that provides an
> enforcing software IOMMU. This would be a character device driver that
> is mmapped by the device emulation process (either vhost-user-style on
> the host or another VMM for inter-VM device emulation). The Driver VMM
> can program mappings into the device and the page tables in the device
> emulation process will be updated. This way the Driver VMM can share
> memory specific regions of guest RAM with the device emulation process
> and revoke those mappings later.

I'm wondering if there is enough plumbing on the guest side so a guest
can use the virtio-iommu to mark out exactly which bits of memory the
virtual device can have access to? At a minimum the virtqueues need to
be accessible and for larger transfers maybe a bounce buffer. However
for speed you want as wide as possible mapping but no more. It would be
nice for example if a block device could load data directly into the
guests block cache (zero-copy) but without getting a view of the kernels
internal data structures.

Another thing that came across in the call was quite a lot of
assumptions about QEMU and Linux w.r.t virtio. While our project will
likely have Linux as a guest OS we are looking specifically at enabling
virtio for Type-1 hypervisors like Xen and the various safety certified
proprietary ones. It is unlikely that QEMU would be used as the VMM for
these deployments. We want to work out what sort of common facilities
hypervisors need to support to enable virtio so the daemons can be
re-usable and maybe setup with a minimal shim for the particular
hypervisor in question.


--=20
Alex Benn=C3=A9e
