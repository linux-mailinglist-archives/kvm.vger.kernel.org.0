Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A516659F920
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 14:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbiHXML5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 08:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiHXMLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 08:11:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF30F4A13D;
        Wed, 24 Aug 2022 05:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7E561982;
        Wed, 24 Aug 2022 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4692DC433D6;
        Wed, 24 Aug 2022 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661343111;
        bh=steFNIiytTlb7li2LRYaxlt67aKuNkpqIloeKeT/MTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2UxpThX3/1pzpXFlYZZQW1U+l8U7SnZMzZOE1rs+FwdPmas8lGG1E+8IRcafHhaS
         Izg6nD3FZoB5ofp2UURQGzRcs5sjnOEEsbh4W6jzxoY488HYCvtpdwaueCzE481L/i
         VdCISNvX8t4F1X5Gm4C9NzQ7mMJY/FX2MrAoAszw=
Date:   Wed, 24 Aug 2022 14:11:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <YwYVhJCSAuYcgj1/@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 08:50:19AM +0000, Gupta, Nipun wrote:
> [AMD Official Use Only - General]
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, August 22, 2022 7:00 PM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> > cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> > <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> > mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> > jeffrey.l.hugo@gmail.com; saravanak@google.com;
> > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> > jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> > kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> > <harpreet.anand@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>;
> > Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx) <git@amd.com>;
> > jgg@nvidia.com; Robin Murphy <robin.murphy@arm.com>
> > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > 
> > [CAUTION: External Email]
> > 
> > On Mon, Aug 22, 2022 at 01:21:47PM +0000, Gupta, Nipun wrote:
> > > [AMD Official Use Only - General]
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > Sent: Wednesday, August 17, 2022 9:03 PM
> > > > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > > > Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > rafael@kernel.org;
> > > > eric.auger@redhat.com; alex.williamson@redhat.com;
> > cohuck@redhat.com;
> > > > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > > > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> > maz@kernel.org;
> > > > f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> > > > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> > > > jgg@ziepe.ca; linux-kernel@vger.kernel.org;
> > devicetree@vger.kernel.org;
> > > > kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> > > > <harpreet.anand@amd.com>; Agarwal, Nikhil
> > <nikhil.agarwal@amd.com>;
> > > > Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx)
> > <git@amd.com>
> > > > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > > >
> > > > [CAUTION: External Email]
> > > >
> > > > On Wed, Aug 17, 2022 at 08:35:38PM +0530, Nipun Gupta wrote:
> > > > > CDX bus driver manages the scanning and populating FPGA
> > > > > based devices present on the CDX bus.
> > > > >
> > > > > The bus driver sets up the basic infrastructure and fetches
> > > > > the device related information from the firmware. These
> > > > > devices are registered as platform devices.
> > > >
> > > > Ick, why?  These aren't platform devices, they are CDX devices.  Make
> > > > them real devices here, don't abuse the platform device interface for
> > > > things that are not actually on the platform bus.
> > >
> > > CDX is a virtual bus (FW based) which discovers FPGA based platform
> > > devices based on communication with FW.
> > 
> > virtual busses are fine to have as a real bus in the kernel, no problem
> > there.
> > 
> > > These devices are essentially platform devices as these are memory
> > mapped
> > > on system bus, but having a property that they are dynamically discovered
> > > via FW and are rescannable.
> > 
> > If they are dynamically discoverable and rescannable, then great, it's a
> > bus in the kernel and NOT a platform device.
> > 
> > > I think your point is correct in the sense that CDX bus is not an actual bus,
> > > but a FW based mechanism to discover FPGA based platform devices.
> > >
> > > Can you kindly suggest us if we should have the CDX platform device
> > scanning
> > > code as a CDX bus in "drivers/bus/" folder OR have it in "drivers/fpga/" or
> > > "drivers/platform/" or which other suitable location?
> > 
> > drivers/cdx/ ?
> 
> I agree that the approach, which is correct should be used, just wanted
> to reconfirm as adding a new bus would lead to change in other areas
> like SMMU, MSI and VFIO too and we will need vfio-cdx interface for CDX
> bus, similar to vfio-platform.
> 
> On another mail Robin and Jason have suggested to use OF_DYNAMIC.
> Can you please also let us know in case that is a suited option where we
> use OF_DYNAMIC and have our code as part of "drivers/fpga" instead of
> using the bus. (something like pseries CPU hotplug is using to add new
> CPU platform devices on runtime:
> https://elixir.bootlin.com/linux/v5.19.3/source/arch/powerpc/platforms/pseries/hotplug-cpu.c#L534).
> We can share the RFC in case you are interested in looking at code flow
> using the of_dynamic approach.

Please no more abuse of the platform device.

If your device can be discovered by scanning a bus, it is not a platform
device.

greg k-h
