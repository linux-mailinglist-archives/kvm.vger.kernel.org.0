Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A835FEEE3
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 15:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJNNqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJNNqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 09:46:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589E112D27;
        Fri, 14 Oct 2022 06:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04833B82215;
        Fri, 14 Oct 2022 13:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4D1C433B5;
        Fri, 14 Oct 2022 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665755163;
        bh=wg2Q52DIyrXZbMal2LNh2YUioMr1oyz8EPIe0so6DII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JMkcLOQ1ZRGy8a24GpAGR03dm712NHH9RJ0YtVi5V84pp5M+qfIvJ3lpvIfcABJPc
         LazO9V6dvyU+l+B+FT4j6Qepq0WNUuLiMbYNOQpaLHc/VJp0uElaY3WXmEivOmFhSf
         MQhMJq5/knJLi2nVZeCEgC6+JUI3wv89Zf0bKXxI=
Date:   Fri, 14 Oct 2022 15:46:48 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
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
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <Y0loSBsadhfsBnsr@kroah.com>
References: <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0gH8R8tEqn6sqZ5@ziepe.ca>
 <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0lODVFsp4KMfPdu@kroah.com>
 <MN2PR12MB43583BB73731986D15B3620789249@MN2PR12MB4358.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB43583BB73731986D15B3620789249@MN2PR12MB4358.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 12:13:45PM +0000, Radovanovic, Aleksandar wrote:
> [AMD Official Use Only - General]
> 
> 
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: 14 October 2022 12:55
> > To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Gupta, Nipun
> > <Nipun.Gupta@amd.com>; Marc Zyngier <maz@kernel.org>; Robin Murphy
> > <robin.murphy@arm.com>; robh+dt@kernel.org;
> > krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> > eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> > f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> > will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> > ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> > kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> > devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org;
> > Anand, Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> > <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>; git
> > (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> > domain as parent
> > 
> > Caution: This message originated from an External Source. Use proper
> > caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Fri, Oct 14, 2022 at 11:18:36AM +0000, Radovanovic, Aleksandar wrote:
> > > Anyway, I think we're straying off topic here, none of this is visible to the
> > kernel anyway. The question that we still need to answer is, are you OK with
> > the limitations I listed originally?
> > 
> > What original limitations?  
> 
> Limitations with regards to MSI message configuration of a CDX device:
> 
> 1) MSI write value is at most 16 useable bits
> 
> 2) MSI address value must be the same across all vectors of a single CDX device
> This would be the (potentially IOMMU translated) I/O address of
> GITS_TRANSLATER. As long as that IOMMU translation is consistent across a 
> single device, I think we should be OK.

It's been a while since I read the PCI spec, but this feels like it does
not follow what MSI is supposed to allow.  Is the "CDX" spec anywhere
that mentions any of this as to what is supposed to be allowed and
supported?

And what is a "single device" here in how the kernel knows about it?  Is
it a PCI device, or some other new structure that is handed to the
kernel from the BIOS?

thanks,

greg k-h
