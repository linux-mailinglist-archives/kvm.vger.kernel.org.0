Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8463AD0DE
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhFRRGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 13:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhFRRGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 13:06:03 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26B0C06175F
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 10:03:53 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ji1so10804087ejc.4
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZO+mLMtBmmkLNPwv3zhliZxU6KZC5d6RsGFH75FYv2M=;
        b=zWUlO12gOz2OERwXyreg7Ulhmi9E56KEw7Qw+3yW43QiICBJfPKbj8krfUBOdMP+gK
         pLmFZ385DrBlqf844plfiaQADkGD19b5iE6b79BwVzBA/7gN4sMLdozHNj9WDXbHrLwD
         7GQDssKv6Crw0GVWUv7ikqpQ4jKQZXxSbB9QCvXeL4X09uX7HO75qqfbcP8BNTVVCxdn
         nKAGGhRgEUquYMAuSzssyQycozXiMjmgF8lc73wvdbIR/dbIX2ba86Mftem08eF08cQ6
         axooW6WKpTISgIRtKYIbVGkoPKFGIDD9EFe1zVkm+P5F7eV/ZclTnQfYNAnbNS6SkBYt
         m4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZO+mLMtBmmkLNPwv3zhliZxU6KZC5d6RsGFH75FYv2M=;
        b=iDtjegD7/P50WgkMA50TUdK5LXlPpBcwkw7ZQMKfA0JRvjfQ3yxbubsEzK2J/OL1Dy
         Fbdn84Entdh37mT4XM88AMXYx0F4jOa/b1GSDbUvDLh7nIEjqqfmo0kYLkFk0P8chWYE
         uGcrK4ZSty/IwgIe8vLaSB0fRHo9ljOMLj/12oHyvIa5jeIThyFVxaaUqo9+2Zpl1ogL
         +P3BhXNyirNEdXk/vQIsOZgPoe2ARytTE7+Ycujnkw0il/qZsUoo0Zk5IfIm46R/gdN4
         1w5zZIVpNDW7kTVHbmfo5b6QVoJ1lHwnBYgukNzPeh4XgjuMzFYjR59yqSrF9GBaMwnD
         xRkQ==
X-Gm-Message-State: AOAM531kTveWcArIqeg3MtTIH8o7oSMQcMIwZLSFMcTANv1bR2tB2ObQ
        nK6Ab2jagd4xnLsCcHAb3DaxUw==
X-Google-Smtp-Source: ABdhPJzcyYDv6aSKnhXtTDMkhc8qOBAYB16gr9FATqdfat0iAjtcVmzU9ngRif5A9tWMT/G36FBa/A==
X-Received: by 2002:a17:907:e90:: with SMTP id ho16mr12120777ejc.410.1624035832047;
        Fri, 18 Jun 2021 10:03:52 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id h9sm6373752edt.18.2021.06.18.10.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 10:03:51 -0700 (PDT)
Date:   Fri, 18 Jun 2021 19:03:31 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YMzR46luaG7hXsJi@myrica>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica>
 <YL8O1pAlg1jtHudn@yekko>
 <YMI/yynDsX/aaG8T@myrica>
 <YMq6voIhXt7guI+W@yekko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMq6voIhXt7guI+W@yekko>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 01:00:14PM +1000, David Gibson wrote:
> On Thu, Jun 10, 2021 at 06:37:31PM +0200, Jean-Philippe Brucker wrote:
> > On Tue, Jun 08, 2021 at 04:31:50PM +1000, David Gibson wrote:
> > > For the qemu case, I would imagine a two stage fallback:
> > > 
> > >     1) Ask for the exact IOMMU capabilities (including pagetable
> > >        format) that the vIOMMU has.  If the host can supply, you're
> > >        good
> > > 
> > >     2) If not, ask for a kernel managed IOAS.  Verify that it can map
> > >        all the IOVA ranges the guest vIOMMU needs, and has an equal or
> > >        smaller pagesize than the guest vIOMMU presents.  If so,
> > >        software emulate the vIOMMU by shadowing guest io pagetable
> > >        updates into the kernel managed IOAS.
> > > 
> > >     3) You're out of luck, don't start.
> > >     
> > > For both (1) and (2) I'd expect it to be asking this question *after*
> > > saying what devices are attached to the IOAS, based on the virtual
> > > hardware configuration.  That doesn't cover hotplug, of course, for
> > > that you have to just fail the hotplug if the new device isn't
> > > supportable with the IOAS you already have.
> > 
> > Yes. So there is a point in time when the IOAS is frozen, and cannot take
> > in new incompatible devices. I think that can support the usage I had in
> > mind. If the VMM (non-QEMU, let's say) wanted to create one IOASID FD per
> > feature set it could bind the first device, freeze the features, then bind
> 
> Are you thinking of this "freeze the features" as an explicitly
> triggered action?  I have suggested that an explicit "ENABLE" step
> might be useful, but that hasn't had much traction from what I've
> seen.

Seems like we do need an explicit enable step for the flow you described
above:

a) Bind all devices to an ioasid. Each bind succeeds.
b) Ask for a specific set of features for this aggregate of device. Ask
   for (1), fall back to (2), or abort.
c) Boot the VM
d) Hotplug a device, bind it to the ioasid. We're long past negotiating
   features for the ioasid, so the host needs to reject the bind if the
   new device is incompatible with what was requested at (b)

So a successful request at (b) would be the point where we change the
behavior of bind.

Since the kernel needs a form of feature check in any case, I still have a
preference for aborting the bind at (a) if the device isn't exactly
compatible with other devices already in the ioasid, because it might be
simpler to implement in the host, but I don't feel strongly about this.


> > I'd like to understand better where the difficulty lies, with migration.
> > Is the problem, once we have a guest running on physical machine A, to
> > make sure that physical machine B supports the same IOMMU properties
> > before migrating the VM over to B?  Why can't QEMU (instead of the user)
> > select a feature set on machine A, then when time comes to migrate, query
> > all information from the host kernel on machine B and check that it
> > matches what was picked for machine A?  Or is it only trying to
> > accommodate different sets of features between A and B, that would be too
> > difficult?
> 
> There are two problems
> 
> 1) Although it could be done in theory, it's hard, and it would need a
> huge rewrite to qemu's whole migration infrastructure to do this.
> We'd need a way of representing host features, working out which sets
> are compatible with which others depending on what things the guest is
> allowed to use, encoding the information in the migration stream and
> reporting failure.  None of this exists now.
> 
> Indeed qemu requires that you create the (stopped) machine on the
> destination (including virtual hardware configuration) before even
> attempting to process the incoming migration.  It does not for the
> most part transfer the machine configuration in the migration stream.
> Now, that's generally considered a flaw with the design, but fixing it
> is a huge project that no-one's really had the energy to begin despite
> the idea being around for years.
> 
> 2) It makes behaviour really hard to predict for management layers
> above.  Things like oVirt automatically migrate around a cluster for
> load balancing.  At the moment the model which works is basically that
> you if you request the same guest features on each end of the
> migration, and qemu starts with that configuration on each end, the
> migration should work (or only fail for transient reasons).  If you
> can't know if the migration is possible until you get the incoming
> stream, reporting and exposing what will and won't work to the layer
> above also becomes an immensely fiddly problem.

That was really useful, thanks. One thing I'm worried about is the user
having to know way too much detail about IOMMUs in order to pick a precise
configuration. The Arm SMMUs have a lot of small features that
implementations can mix and match and that a user shouldn't have to care
about, and there are lots of different implementations by various vendors.
I suppose QEMU can offer a couple of configurations with predefined sets
of features, but it seems easy to end up with a config that gets rejected
because it is slightly different than the hardware. Anyway this is a
discussion we can have once we touch on the features in GET_INFO, I don't
have a precise idea at the moment.

Thanks,
Jean

