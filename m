Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D031F22EB4F
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgG0LiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:38:03 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbgG0LiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 07:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595849880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=deFielYPvv/bZiEsafzeHFqZbfMpQ2UPhHPLYdTxIHk=;
        b=VfdYtIvsYjo5VGwxD57r1MiTSShbe5Zvr3c1Gu5VB+DVUeBfVnT4/FovBC0sOfQk0w1SRE
        nW9f5oE1ieRVI6INw12KVoFwdOpjErQ8QoWqvwD53078kPtiSSra/7wJ3PXWpsP4WWg6rr
        Rx4bjOpmk1MPcq+XroFIyIvNdRK7knY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-5J8AThXUOtqlrd8PHBT8Zw-1; Mon, 27 Jul 2020 07:37:58 -0400
X-MC-Unique: 5J8AThXUOtqlrd8PHBT8Zw-1
Received: by mail-wm1-f69.google.com with SMTP id v4so5602700wmh.3
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 04:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=deFielYPvv/bZiEsafzeHFqZbfMpQ2UPhHPLYdTxIHk=;
        b=dMMuYUbZeOAWqzl0u21G01flsOli8pyZC1U62e+ylkBZC44Ko8c/ReL2FmEqEuLuez
         KPXY8KVImMTySec8X3BIjYtL+QHZm38WPyrMMc6XG14/jdlO3t8zL/jVcVF1NfPc8cxw
         w2kbh/zxVEwwML2IkH4J36rXbfHVA6V6CFHPNU5UK9Ef+2DiKQyf++9XtWmbhs1gvmtU
         N8WjqSVoomiP0B48rJH8zx0a2sA5Uua21J0oLgJNhOcdLNCOfCKbaJSvaBKtQxGkP7Gg
         12T2M835HDXw6DzUPfoOly9OxXH7cb5T9rsEx2m437jO8lWzHHRf8wFDlYOInHB/8OGr
         7MIg==
X-Gm-Message-State: AOAM5339yIyKfTY88ziCilEOWPRKA0DY+BTbTN90rEITSNHXCAuz1IFk
        giJvXHwqxoatbUcBVtVAlbGpIpV+bD3YbHkG3rnlVdN7SJ00+9IbVP26PUENwav2oizZtLo8c/X
        ECRdnc7wHsnpn
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr19753130wmj.105.1595849877539;
        Mon, 27 Jul 2020 04:37:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyC8LSTipBXGm9Ul9bRoWq+upyHZ0Ut55gzk1Ap5DgK521C422fnI/j9iNt+GCvNHP+Fcg+iw==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr19753104wmj.105.1595849877185;
        Mon, 27 Jul 2020 04:37:57 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id n3sm12564666wre.29.2020.07.27.04.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 04:37:56 -0700 (PDT)
Date:   Mon, 27 Jul 2020 07:37:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        Jag Raman <jag.raman@oracle.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200727073311-mutt-send-email-mst@kernel.org>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
 <874kq1w3bz.fsf@linaro.org>
 <20200727101403.GF380177@stefanha-x1.localdomain>
 <87h7tt45dr.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7tt45dr.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 11:30:24AM +0100, Alex Bennée wrote:
> 
> Stefan Hajnoczi <stefanha@redhat.com> writes:
> 
> > On Tue, Jul 21, 2020 at 11:49:04AM +0100, Alex Bennée wrote:
> >> Stefan Hajnoczi <stefanha@gmail.com> writes:
> >> > 2. Alexander Graf's idea for a new Linux driver that provides an
> >> > enforcing software IOMMU. This would be a character device driver that
> >> > is mmapped by the device emulation process (either vhost-user-style on
> >> > the host or another VMM for inter-VM device emulation). The Driver VMM
> >> > can program mappings into the device and the page tables in the device
> >> > emulation process will be updated. This way the Driver VMM can share
> >> > memory specific regions of guest RAM with the device emulation process
> >> > and revoke those mappings later.
> >> 
> >> I'm wondering if there is enough plumbing on the guest side so a guest
> >> can use the virtio-iommu to mark out exactly which bits of memory the
> >> virtual device can have access to? At a minimum the virtqueues need to
> >> be accessible and for larger transfers maybe a bounce buffer. However
> >> for speed you want as wide as possible mapping but no more. It would be
> >> nice for example if a block device could load data directly into the
> >> guests block cache (zero-copy) but without getting a view of the kernels
> >> internal data structures.
> >
> > Maybe Jean-Philippe or Eric can answer that?
> >
> >> Another thing that came across in the call was quite a lot of
> >> assumptions about QEMU and Linux w.r.t virtio. While our project will
> >> likely have Linux as a guest OS we are looking specifically at enabling
> >> virtio for Type-1 hypervisors like Xen and the various safety certified
> >> proprietary ones. It is unlikely that QEMU would be used as the VMM for
> >> these deployments. We want to work out what sort of common facilities
> >> hypervisors need to support to enable virtio so the daemons can be
> >> re-usable and maybe setup with a minimal shim for the particular
> >> hypervisor in question.
> >
> > The vhost-user protocol together with the backend program conventions
> > define the wire protocol and command-line interface (see
> > docs/interop/vhost-user.rst).
> >
> > vhost-user is already used by other VMMs today. For example,
> > cloud-hypervisor implements vhost-user.
> 
> Ohh that's a new one for me. I see it is a KVM only project but it's
> nice to see another VMM using the common rust-vmm backend. There is
> interest in using rust-vmm to implement VMMs for type-1 hypervisors but
> we need to work out if there are two many type-2 concepts backed into
> the lower level rust crates.
> 
> > I'm sure there is room for improvement, but it seems like an incremental
> > step given that vhost-user already tries to cater for this scenario.
> >
> > Are there any specific gaps you have identified?
> 
> Aside from the desire to limit the shared memory footprint between the
> backend daemon and a guest not yet.

So it's certainly nice for security but not really a requirement for a
type-1 HV, right?

> I suspect the eventfd mechanism might just end up being simulated by the
> VMM as a result of whatever comes from the type-1 interface indicating a
> doorbell has been rung. It is after all just a FD you consume numbers
> over right?

Does not even have to be numbers. We need a way to be woken up, a way to
stop/start listening for wakeups and a way to detect that there was a
wakeup while we were not listening.

Though there are special tricks for offloads where we poke through
layers in order to map things directly to hardware.

> Not all setups will have an equivalent of a Dom0 "master" guest to do
> orchestration. Highly embedded are likely to have fixed domains created
> as the firmware/hypervisor start up.
> 
> >
> > Stefan
> 
> 
> -- 
> Alex Bennée

