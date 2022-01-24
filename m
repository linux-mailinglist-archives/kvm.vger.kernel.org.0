Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FF4986D1
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244602AbiAXRaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:30:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244617AbiAXRay (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 12:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643045454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dgmheP820PSeiT2ULGO4Onqs77vyCkC2g7OOa3oPHLc=;
        b=bmIdvLnpiRjb57Ed5H/EXejhIQ0Pp94K/8KtBLK20ySTwULZ5NJOL3hm3eIunzBabFd4TL
        uM8HLOh+37GByYtmGHdP3u+GXuhNL7EucjpUa4G/gPw2n0ANXXMaseS6wuwW0GsjE7JZrK
        PwiFqnl+E+jq2lA1a84AH3EIlK457yc=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-QlEPnG30P9q6K-yltwA4tg-1; Mon, 24 Jan 2022 12:30:52 -0500
X-MC-Unique: QlEPnG30P9q6K-yltwA4tg-1
Received: by mail-oi1-f198.google.com with SMTP id e15-20020aca230f000000b002cc254cb694so7706043oie.21
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgmheP820PSeiT2ULGO4Onqs77vyCkC2g7OOa3oPHLc=;
        b=n8WekXN7HmyDwLADhlyFfqK32WE7ZkafocldiVB+gRw21IR/AMI6PNyInedPzegwct
         yOp0zxq3dDErrqHQZlMEJCRhODwiyLcRXvXsVvuuwLimeLvn0V4d1uvo3APbzNDX/yWP
         Ydf9Y28kJOlUorPqcHSjxyo3Bd9R7Ec5YA09FW0vwilMAman6h3JCihtx1Z51xSS9uaB
         co340XZkS8f/J8gzxvtmkTh6rvhSVv+9vwY/oelMhQD3W/9ViZCCqfOuXgZGE+v/HW2j
         Lg/uCtGAP8ub3w3/1ZW2GFSmSX6c3ltvxZ58NmH0Tz3KynDbiK+wYcD+ZeIX1aRj841k
         iIkQ==
X-Gm-Message-State: AOAM533VwF7fKqgzMfKcRygVN/qCmH/n5j87P/GG8nl5GZviH/sgazXD
        oNvYF1BHlp82iwrOUJe8//yYpDR+N5kIh3AcY+n4jP0jad2zkiF/CFW3lFcVLNI4cA6Ri2o0YSY
        ohBZ+aeehH/Qm
X-Received: by 2002:a05:6830:1e89:: with SMTP id n9mr9311773otr.304.1643045451897;
        Mon, 24 Jan 2022 09:30:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNbG8a1p/Pz9Hx4D54aH1sfIRemdv4XTKC6BeBEnOC4SSSFVBa1s73P8JKhNP8tqDgM4SGJw==
X-Received: by 2002:a05:6830:1e89:: with SMTP id n9mr9311753otr.304.1643045451658;
        Mon, 24 Jan 2022 09:30:51 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bj19sm6167338oib.9.2022.01.24.09.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:30:51 -0800 (PST)
Date:   Mon, 24 Jan 2022 10:30:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     James Turner <linuxkernel.foss@dmarc-none.turner.link>,
        "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Message-ID: <20220124103050.0229ae92.alex.williamson@redhat.com>
In-Reply-To: <CADnq5_P5RAJxKWCQBmJae8eWjJ5_wPG01uJYOpXMGsieWqUDvw@mail.gmail.com>
References: <87ee57c8fu.fsf@turner.link>
        <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
        <87a6ftk9qy.fsf@dmarc-none.turner.link>
        <87zgnp96a4.fsf@turner.link>
        <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
        <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
        <87czkk1pmt.fsf@dmarc-none.turner.link>
        <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
        <87sftfqwlx.fsf@dmarc-none.turner.link>
        <CADnq5_P5RAJxKWCQBmJae8eWjJ5_wPG01uJYOpXMGsieWqUDvw@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jan 2022 12:04:18 -0500
Alex Deucher <alexdeucher@gmail.com> wrote:

> On Sat, Jan 22, 2022 at 4:38 PM James Turner
> <linuxkernel.foss@dmarc-none.turner.link> wrote:
> >
> > Hi Lijo,
> >  
> > > Could you provide the pp_dpm_* values in sysfs with and without the
> > > patch? Also, could you try forcing PCIE to gen3 (through pp_dpm_pcie)
> > > if it's not in gen3 when the issue happens?  
> >
> > AFAICT, I can't access those values while the AMD GPU PCI devices are
> > bound to `vfio-pci`. However, I can at least access the link speed and
> > width elsewhere in sysfs. So, I gathered what information I could for
> > two different cases:
> >
> > - With the PCI devices bound to `vfio-pci`. With this configuration, I
> >   can start the VM, but the `pp_dpm_*` values are not available since
> >   the devices are bound to `vfio-pci` instead of `amdgpu`.
> >
> > - Without the PCI devices bound to `vfio-pci` (i.e. after removing the
> >   `vfio-pci.ids=...` kernel command line argument). With this
> >   configuration, I can access the `pp_dpm_*` values, since the PCI
> >   devices are bound to `amdgpu`. However, I cannot use the VM. If I try
> >   to start the VM, the display (both the external monitors attached to
> >   the AMD GPU and the built-in laptop display attached to the Intel
> >   iGPU) completely freezes.
> >
> > The output shown below was identical for both the good commit:
> > f1688bd69ec4 ("drm/amd/amdgpu:save psp ring wptr to avoid attack")
> > and the commit which introduced the issue:
> > f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")
> >
> > Note that the PCI link speed increased to 8.0 GT/s when the GPU was
> > under heavy load for both versions, but the clock speeds of the GPU were
> > different under load. (For the good commit, it was 1295 MHz; for the bad
> > commit, it was 501 MHz.)
> >  
> 
> Are the ATIF and ATCS ACPI methods available in the guest VM?  They
> are required for this platform to work correctly from a power
> standpoint.  One thing that f9b7f3703ff9 did was to get those ACPI
> methods executed on certain platforms where they had not been
> previously due to a bug in the original implementation.  If the
> windows driver doesn't interact with them, it could cause performance
> issues.  It may have worked by accident before because the ACPI
> interfaces may not have been called, leading the windows driver to
> believe this was a standalone dGPU rather than one integrated into a
> power/thermal limited platform.

None of the host ACPI interfaces are available to or accessible by the
guest when assigning a PCI device.  Likewise the guest does not have
access to the parent downstream ports of the PCIe link.  Thanks,

Alex

