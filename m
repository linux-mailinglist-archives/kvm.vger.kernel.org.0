Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7621122EA0C
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgG0Ka2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 06:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgG0Ka1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 06:30:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C40C061794
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 03:30:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r12so14281911wrj.13
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 03:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ef+DlaPDlCdGo3GcQcb/cr5plIeVe0IdjPjPGvh9Xlw=;
        b=z2A9HWvqP8rUdS23qGeI4oeuzorNnNTPzGD9XntkgGyZpU1srjFbFlMHFkcb9StnPJ
         n9v5VN0tFiHnug/CCCCSSkHHWozP8XO4937s/cbUuNFP39chWhbsqlU4tPnflja5OeTE
         kg/dNfhCdNWMednO4Sa/ww97VKQ/mt+9K5UTYUddX2Bnn0yEO2Mt2dor9HG35a4lJHfc
         qqr7BpOpex8xYikAfL5j3MCM+AXUWDYahOUOGqtJxS/HDVpIUt7IYkuhMOE4x2Bb12WZ
         JS2+sNsVkxQXzXYpurbuo7TLVJ7cB6ZimA/0tQayXLAw76xhZP1vrG7NVGO3eeDn0ZMU
         /HqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=ef+DlaPDlCdGo3GcQcb/cr5plIeVe0IdjPjPGvh9Xlw=;
        b=ol2btOYLAiw6RHT5Tu66M+e0WpqGbJ8KQNg7vqegLUNvI3tTiHlwDhxYiPV6kQmEQL
         n95f2QWDfJTmHh5qm7LW2iU6/ctqdYv5P0PBmhPBugz8msJNpFX8bRG3KvtlEu0l4Hfe
         l2ZNh19BuThr6dIzv/1VBQkx6c888d68VVK9zqEvkyyNxPLl0Jsd4OTC3V12OMbRbbZe
         9cwIRdKJ5Mf/7ughEi3H1bECDqyzAm6F4aRS+lp5IGM61fcyd6yNeKmyEkY5UoDvH12v
         ZxxyeQ4JVg59o8Zv7Bw8Uamg0FJJCjagLEGs3JM2oOqHtmLTUeORwGxS51gZk9A9vGip
         DSSA==
X-Gm-Message-State: AOAM530NqNpl1ofFIWrZkQvcOkiTj4fV4qK+yjWbitdAPKA3R7E9XYFp
        Ku2W8Q7/GQCkoMwLHqfWwoQvyA==
X-Google-Smtp-Source: ABdhPJwCGWvlr8PvKPAIatHcCGvWo7ZNxfYvqPc2JcsXJpH3HzTyXWfTPcp+1HArG829ltp3gnr0pg==
X-Received: by 2002:adf:dcc9:: with SMTP id x9mr21684234wrm.153.1595845826053;
        Mon, 27 Jul 2020 03:30:26 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id t17sm3180629wmj.34.2020.07.27.03.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 03:30:24 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 373BB1FF7E;
        Mon, 27 Jul 2020 11:30:24 +0100 (BST)
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
 <874kq1w3bz.fsf@linaro.org>
 <20200727101403.GF380177@stefanha-x1.localdomain>
User-agent: mu4e 1.5.5; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
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
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
In-reply-to: <20200727101403.GF380177@stefanha-x1.localdomain>
Date:   Mon, 27 Jul 2020 11:30:24 +0100
Message-ID: <87h7tt45dr.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Stefan Hajnoczi <stefanha@redhat.com> writes:

> On Tue, Jul 21, 2020 at 11:49:04AM +0100, Alex Benn=C3=A9e wrote:
>> Stefan Hajnoczi <stefanha@gmail.com> writes:
>> > 2. Alexander Graf's idea for a new Linux driver that provides an
>> > enforcing software IOMMU. This would be a character device driver that
>> > is mmapped by the device emulation process (either vhost-user-style on
>> > the host or another VMM for inter-VM device emulation). The Driver VMM
>> > can program mappings into the device and the page tables in the device
>> > emulation process will be updated. This way the Driver VMM can share
>> > memory specific regions of guest RAM with the device emulation process
>> > and revoke those mappings later.
>>=20
>> I'm wondering if there is enough plumbing on the guest side so a guest
>> can use the virtio-iommu to mark out exactly which bits of memory the
>> virtual device can have access to? At a minimum the virtqueues need to
>> be accessible and for larger transfers maybe a bounce buffer. However
>> for speed you want as wide as possible mapping but no more. It would be
>> nice for example if a block device could load data directly into the
>> guests block cache (zero-copy) but without getting a view of the kernels
>> internal data structures.
>
> Maybe Jean-Philippe or Eric can answer that?
>
>> Another thing that came across in the call was quite a lot of
>> assumptions about QEMU and Linux w.r.t virtio. While our project will
>> likely have Linux as a guest OS we are looking specifically at enabling
>> virtio for Type-1 hypervisors like Xen and the various safety certified
>> proprietary ones. It is unlikely that QEMU would be used as the VMM for
>> these deployments. We want to work out what sort of common facilities
>> hypervisors need to support to enable virtio so the daemons can be
>> re-usable and maybe setup with a minimal shim for the particular
>> hypervisor in question.
>
> The vhost-user protocol together with the backend program conventions
> define the wire protocol and command-line interface (see
> docs/interop/vhost-user.rst).
>
> vhost-user is already used by other VMMs today. For example,
> cloud-hypervisor implements vhost-user.

Ohh that's a new one for me. I see it is a KVM only project but it's
nice to see another VMM using the common rust-vmm backend. There is
interest in using rust-vmm to implement VMMs for type-1 hypervisors but
we need to work out if there are two many type-2 concepts backed into
the lower level rust crates.

> I'm sure there is room for improvement, but it seems like an incremental
> step given that vhost-user already tries to cater for this scenario.
>
> Are there any specific gaps you have identified?

Aside from the desire to limit the shared memory footprint between the
backend daemon and a guest not yet.

I suspect the eventfd mechanism might just end up being simulated by the
VMM as a result of whatever comes from the type-1 interface indicating a
doorbell has been rung. It is after all just a FD you consume numbers
over right?

Not all setups will have an equivalent of a Dom0 "master" guest to do
orchestration. Highly embedded are likely to have fixed domains created
as the firmware/hypervisor start up.

>
> Stefan


--=20
Alex Benn=C3=A9e
