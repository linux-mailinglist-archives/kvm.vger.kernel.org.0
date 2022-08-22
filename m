Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A5559C090
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiHVN3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 09:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbiHVN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 09:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7518346;
        Mon, 22 Aug 2022 06:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B50761196;
        Mon, 22 Aug 2022 13:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7E7C433C1;
        Mon, 22 Aug 2022 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661174978;
        bh=tKR+1ncaLktuwBqOq+cs01Cvto2mRKf0wx5WnwSpD0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTkh9d2Haa525kwq2grlzk2TfJzupWlmdIDQ5qo0V4w55EsXMCH6v1DJh2tvLXpfu
         DrZ7mhtp3qKmb7fNWOImHLVlYbOQdRn88AvwmFxXXov+Y+Bv007ApBHm64gHBnHBZr
         s2NReW++3jE2tMLkvDU/VdpAQO1j8Q8pySCO8tns=
Date:   Mon, 22 Aug 2022 15:29:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "git (AMD-Xilinx)" <git@amd.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <YwOEv6107RfU5p+H@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022 at 01:21:47PM +0000, Gupta, Nipun wrote:
> [AMD Official Use Only - General]
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, August 17, 2022 9:03 PM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> > eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> > f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> > jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> > kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> > <harpreet.anand@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>;
> > Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > 
> > [CAUTION: External Email]
> > 
> > On Wed, Aug 17, 2022 at 08:35:38PM +0530, Nipun Gupta wrote:
> > > CDX bus driver manages the scanning and populating FPGA
> > > based devices present on the CDX bus.
> > >
> > > The bus driver sets up the basic infrastructure and fetches
> > > the device related information from the firmware. These
> > > devices are registered as platform devices.
> > 
> > Ick, why?  These aren't platform devices, they are CDX devices.  Make
> > them real devices here, don't abuse the platform device interface for
> > things that are not actually on the platform bus.
> 
> CDX is a virtual bus (FW based) which discovers FPGA based platform
> devices based on communication with FW.

virtual busses are fine to have as a real bus in the kernel, no problem
there.

> These devices are essentially platform devices as these are memory mapped
> on system bus, but having a property that they are dynamically discovered
> via FW and are rescannable.

If they are dynamically discoverable and rescannable, then great, it's a
bus in the kernel and NOT a platform device.

> I think your point is correct in the sense that CDX bus is not an actual bus,
> but a FW based mechanism to discover FPGA based platform devices.
> 
> Can you kindly suggest us if we should have the CDX platform device scanning
> code as a CDX bus in "drivers/bus/" folder OR have it in "drivers/fpga/" or
> "drivers/platform/" or which other suitable location?

drivers/cdx/ ?

thanks,

greg k-h
