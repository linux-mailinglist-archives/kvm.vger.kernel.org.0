Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57B02332EA
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgG3NYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:24:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726281AbgG3NYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 09:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596115478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trBMDum5jaV2PmP6FGjCemPgC956VMcTP3eowoAov1g=;
        b=LMlgrbXFv39/qXeAnmfaWlp5z/9rUMZLgJMw/EgAUXV5fMtPnJWOLBDqiI1tLwYpDRVrfp
        QOa5Tg/BBs163cjUeG2HPHGtjP6MAfyfR5tpXzZccygKl8QqS7p/jJzFJHwgvJJekck2Fu
        IN74fnY8cUBHYkJPBcNXmv7o0dF+WDE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-w99nvzPoM0KhkMOwtdPiqw-1; Thu, 30 Jul 2020 09:24:35 -0400
X-MC-Unique: w99nvzPoM0KhkMOwtdPiqw-1
Received: by mail-wm1-f71.google.com with SMTP id p23so1396474wmc.2
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 06:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=trBMDum5jaV2PmP6FGjCemPgC956VMcTP3eowoAov1g=;
        b=le9gPi7gvEalp7KWj0SZkkBNHuSU2JzlzTuh0TVyDDp1pCycW3dL/MyQpJnZ7WwweB
         Y/4b1Nt4CMRtPjTAK5fsdJ68JN8p4se0c4D9Mwhaoe41u26lwf+OqDev6JzENL1QxH0F
         1VtrOI44A6gdV2U+jZwrlIlXExNE8or0XD/0CXrLiyrb3RVIFe+lWZU4O8r79Jp2e1i2
         T/cphuXrydYZm3+GRUdgRgKSJMj5DKZ/y3HbwwhxBSqdkKdOTey6f3/pGkOiMLuR2nBQ
         UgpAud9EISSfa7RAGTAR8iIWQxLPWolJGlWFLP92CBvtckuI9fpwR0qPlwHyg4PU3D7j
         f6wA==
X-Gm-Message-State: AOAM5301fF+6fOPRyI/2yKHo0bcdR2h4p4iy0SHujXKcwahdkjv/npQ9
        LMRKiLE85CaZBxu8ob0dgQnr1ntIaxD9siunhCbrUOKxyViwd5hRpI+qGV6wPKXR578nPwLKRhK
        SHNhjif8zTzzS
X-Received: by 2002:a1c:28c4:: with SMTP id o187mr12750846wmo.62.1596115474290;
        Thu, 30 Jul 2020 06:24:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbK20wdWHvC4AuD4fC98U/RMEiNOX+IYs63dLbAh2/L5ig+EHrNSXl9Gtwq/lrg+jGKUC+8g==
X-Received: by 2002:a1c:28c4:: with SMTP id o187mr12750834wmo.62.1596115474070;
        Thu, 30 Jul 2020 06:24:34 -0700 (PDT)
Received: from pop-os ([2001:470:1f1d:1ea:4fde:6f63:1f5a:12b1])
        by smtp.gmail.com with ESMTPSA id l11sm8654553wme.11.2020.07.30.06.24.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 06:24:33 -0700 (PDT)
Message-ID: <c56990fe775268793b06d94c679bec2c458b7ecf.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, devel@ovirt.org
Date:   Thu, 30 Jul 2020 14:24:31 +0100
In-Reply-To: <20200730034104.GB32327@joy-OptiPlex-7040>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
         <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
         <20200716083230.GA25316@joy-OptiPlex-7040>
         <20200717101258.65555978@x1.home>
         <20200721005113.GA10502@joy-OptiPlex-7040>
         <20200727072440.GA28676@joy-OptiPlex-7040>
         <20200727162321.7097070e@x1.home>
         <20200729080503.GB28676@joy-OptiPlex-7040>
         <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
         <20200729131255.68730f68@x1.home>
         <20200730034104.GB32327@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-07-30 at 11:41 +0800, Yan Zhao wrote:
> > > >    interface_version=3
> > 
> > Not much granularity here, I prefer Sean's previous
> > <major>.<minor>[.bugfix] scheme.
> > 
> 
> yes, <major>.<minor>[.bugfix] scheme may be better, but I'm not sure if
> it works for a complicated scenario.
> e.g for pv_mode,
> (1) initially,  pv_mode is not supported, so it's pv_mode=none, it's 0.0.0,
> (2) then, pv_mode=ppgtt is supported, pv_mode="none+ppgtt", it's 0.1.0,
> indicating pv_mode=none can migrate to pv_mode="none+ppgtt", but not vice versa.
> (3) later, pv_mode=context is also supported,
> pv_mode="none+ppgtt+context", so it's 0.2.0.
> 
> But if later, pv_mode=ppgtt is removed. pv_mode="none+context", how to
> name its version?
it would become 1.0.0
addtion of a feature is a minor version bump as its backwards compatiable.
if you dont request the new feature you dont need to use it and it can continue to behave like
a 0.0.0 device evne if its capably of acting as a 0.1.0 device.
when you remove a feature that is backward incompatable as any isnstance that was prevously not
using it would nolonger work so you have to bump the major version.
>  "none+ppgtt" (0.1.0) is not compatible to
> "none+context", but "none+ppgtt+context" (0.2.0) is compatible to
> "none+context".
> 
> Maintain such scheme is painful to vendor driver.
not really its how most software libs are version today. some use other schemes
but semantic versioning is don right is a concies and easy to consume set of rules
https://semver.org/ however you are right that it forcnes vendor to think about backwards
and forwards compatiablty with each change which for the most part is a good thing.
it goes hand in hand with have stable abi and api definitons to ensuring firmware updates and driver chagnes
dont break userspace that depend on the kernel interfaces they expose.


