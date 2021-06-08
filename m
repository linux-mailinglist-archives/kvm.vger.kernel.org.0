Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD453A05FA
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhFHV2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233318AbhFHV2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 17:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTl1+jTDXK4/+Z//CZLJMjtvlHBS0lRzIg34WUYNSgw=;
        b=JKuWakcuXqfgDtPUuA/1t4qBP5RXAVJ1YDcy78PIAcmhiUnC+H/c/UCG4990x3RRJ92tjh
        QtV0jTwYvjVth81ipxKx//BvSk/FXv8vs7+GrRxgJi1YyzZKc4WC1LZDnIFYVfx0RFj5dS
        42UEk4uiSPyqMabpdcKQfsn3d2pFMXM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-NRnb3ro_OSGH-U4JAVKHgQ-1; Tue, 08 Jun 2021 17:26:46 -0400
X-MC-Unique: NRnb3ro_OSGH-U4JAVKHgQ-1
Received: by mail-oo1-f72.google.com with SMTP id x24-20020a4a9b980000b0290249d5c08dd6so4681146ooj.15
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oTl1+jTDXK4/+Z//CZLJMjtvlHBS0lRzIg34WUYNSgw=;
        b=PcJdkw2blMfYp/Slp0CFg0buzGLa9rttXQ2eebXeuJ1UWQDa5wIRMVomw1VSuSBgWn
         QnscGUg00oMrJKA9W3P2pIhgcHdUxuOVctPsFpqYgbuUYhp545J4fafW+csOLqAymgoJ
         Y0bdhjIc1DSEXIGKq4/lAS8Fgznrbna3LFtBqtGd/OH0UUc2gFJ/jkbqHW9JbBUL1cBC
         uKtKbquIJzxAm8qjkK76wM1MIP4ihpHWbnzqykZLg2NN7Cwer8ga2E+J6qjLq0LIH3YC
         iAWlKcEHfcBTB8cTt6gXsatGm22WiOBcUmCXfudBcJLaRrMvyL+cZ0bmgD6Y3Qclriw/
         dTXQ==
X-Gm-Message-State: AOAM532xp9vNvKQteYZWqcbYLvgGLYFAno57Ue+2QEa+cjPjRQIfDICd
        r3I7HkTW/ZoqjWmKOV1FLbFHalgUtwNgbnoS8wgzbqVE8q5pEBCWLdduWkPppSdP/oWaXimnBo9
        m8SWa+6LalPgw
X-Received: by 2002:aca:39d4:: with SMTP id g203mr4304813oia.158.1623187605873;
        Tue, 08 Jun 2021 14:26:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhqt8hzm9PPzK237+q2Oz4nn7wvQvfT2ISKovodCgGN3KvS0c+qDcFTQB17aEM+Z/wGTvIOA==
X-Received: by 2002:aca:39d4:: with SMTP id g203mr4304793oia.158.1623187605677;
        Tue, 08 Jun 2021 14:26:45 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o21sm642393oie.34.2021.06.08.14.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:26:45 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:26:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210608152643.2d3400c1.alex.williamson@redhat.com>
In-Reply-To: <20210603160809.15845-10-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-10-mgurtovoy@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 19:08:07 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> Allowing any driver in the system to be unconditionally bound to any
> PCI HW is dangerous. Connecting a driver to a physical HW device it was
> never intended to operate may trigger exploitable kernel bugs, or worse.
> It also allows userspace to load and run kernel code that otherwise
> would never be runnable on the system.

This is just another way that an admin can do bad things, with the
intention that they know what they're doing and if not they get to
keep the pieces.  There's also still the new_id scheme for binding the
wrong drivers to devices, so the hole this claims to be addressing is
still fully present.

> driver_override was designed to make it easier to load vfio_pci, so

Actually driver_override was designed to resolve the non-deterministic
behavior of new_id, which allows inserting dynamic match entries.  The
problem is those match entries match any device that might come along
during the time window when userspace is trying to bind a specific
device to a specific driver.  driver_override flipped the problem to
match a device to a driver rather than vice versa.  Other bus types
have since adopted driver_override interfaces as well.

> focus it on that single use case. driver_override will only work on

It's used for other use cases across numerous bus types now.  For
instance, how can I user driver_override to bind pci-stub to a device
after this?  driverctl(8) uses driver_override to perform arbitrary
driver overrides, this breaks all but the vfio-pci use case.

> drivers that specifically opt into this feature and the driver now has
> the opportunity to provide a proper match table that indicates what HW
> it can properly support. vfio-pci continues to support everything.

In doing so, this also breaks the new_id method for vfio-pci.  Sorry,
with so many userspace regressions, crippling the driver_override
interface with an assumption of such a narrow focus, creating a vfio
specific match flag, I don't see where this can go.  Thanks,

Alex

