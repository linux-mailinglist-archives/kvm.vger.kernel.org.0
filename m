Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28C45A19DF
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbiHYT6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiHYT6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:58:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13B512981B;
        Thu, 25 Aug 2022 12:58:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57027D6E;
        Thu, 25 Aug 2022 12:58:04 -0700 (PDT)
Received: from [10.57.16.12] (unknown [10.57.16.12])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5BDA3F67D;
        Thu, 25 Aug 2022 12:57:55 -0700 (PDT)
Message-ID: <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
Date:   Thu, 25 Aug 2022 20:57:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Content-Language: en-GB
To:     Saravana Kannan <saravanak@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
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
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-08-25 19:38, Saravana Kannan wrote:
> On Wed, Aug 24, 2022 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>> On Wed, Aug 24, 2022 at 02:11:48PM +0200, Greg KH wrote:
>>>> We can share the RFC in case you are interested in looking at code flow
>>>> using the of_dynamic approach.
>>>
>>> Please no more abuse of the platform device.
>>
>> Last time this came up there was some disagreement from the ARM folks,
>> they were not keen on having xx_drivers added all over the place to
>> support the same OF/DT devices just discovered in a different way. It is
>> why ACPI is mapped to platform_device even in some cases.
>>
>> I think if you push them down this path they will get resistance to
>> get the needed additional xx_drivers into the needed places.
>>
>>> If your device can be discovered by scanning a bus, it is not a platform
>>> device.
>>
>> A DT fragment loaded during boot binds a driver using a
>> platform_driver, why should a DT fragment loaded post-boot bind using
>> an XX_driver and further why should the CDX way of getting the DT
>> raise to such importantance that it gets its own cdx_driver ?
>>
>> In the end the driver does not care about how the DT was loaded.
>> None of these things are on a discoverable bus in any sense like PCI
>> or otherwise. They are devices described by a DT fragement and they
>> take all their parameters from that chunk of DT.
>>
>> How the DT was loaded into the system is not a useful distinction that
>> raises the level of needing an entire new set of xx_driver structs all
>> over the tree, IMHO.
> 
> Jason, I see your point or rather the point the ARM folks might have
> made. But in this case, why not use DT overlays to add these devices?
> IIRC there's an in kernel API to add DT overlays. If so, should this
> be more of a FPGA driver that reads FPGA stuff and adds DT overlays?
> That'd at least make a stronger case for why this isn't a separate
> bus.

Right, that's exactly where this discussion started.

To my mind, it would definitely help to understand if this is a *real* 
discoverable bus in hardware, i.e. does one have to configure one's 
device with some sort of CDX wrapper at FPGA synthesis time, that then 
physically communicates with some sort of CDX controller to identify 
itself once loaded; or is it "discoverable" in the sense that there's 
some firmware on an MCU controlling what gets loaded into the FPGA, and 
software can query that and get back whatever precompiled DTB fragment 
came bundled with the bitstream, i.e. it's really more like fpga-mgr in 
a fancy hat?

It's pretty much impossible to judge from all the empty placeholder code 
here how much is real and constrained by hardware and how much is 
firmware abstraction, which makes it particularly hard to review whether 
any proposal heading in the right direction.

Even if it *is* entirely firmware smoke-and-mirrors, if that firmware 
can provide a standardised discovery and configuration interface for 
common resources, it can be a bus. But then it should *be* a bus, with 
its own bus_type and its own device type to model those standard 
interfaces and IDs and resources. Or if it is really just a very clever 
dynamic DT overlay manager for platform devices, then it can be that 
instead. But what it should clearly not be is some in-between mess 
making the worst of both worlds, which is what the code here inescapably 
smells of.

Thanks,
Robin.
