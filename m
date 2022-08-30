Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CC55A61A0
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 13:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiH3L0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 07:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiH3L0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 07:26:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 525ACBB01F;
        Tue, 30 Aug 2022 04:26:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A4EA23A;
        Tue, 30 Aug 2022 04:26:06 -0700 (PDT)
Received: from [10.57.13.45] (unknown [10.57.13.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A5443F71A;
        Tue, 30 Aug 2022 04:25:55 -0700 (PDT)
Message-ID: <2db3b103-7034-6c0d-4ec8-caae7654b264@arm.com>
Date:   Tue, 30 Aug 2022 12:25:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Content-Language: en-GB
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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
References: <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
 <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
 <Ywzb4RmbgbnQYTIl@nvidia.com>
 <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
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

On 2022-08-30 08:06, Gupta, Nipun wrote:
> [AMD Official Use Only - General]
> 
> 
> 
>> -----Original Message-----
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Monday, August 29, 2022 9:02 PM
>> To: Gupta, Nipun <Nipun.Gupta@amd.com>
>> Cc: Robin Murphy <robin.murphy@arm.com>; Saravana Kannan
>> <saravanak@google.com>; Greg KH <gregkh@linuxfoundation.org>;
>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
>> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
>> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
>> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
>> maz@kernel.org; f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com;
>> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com; linux-
>> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
>> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
>> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
>> git (AMD-Xilinx) <git@amd.com>
>> Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
>>
>> [CAUTION: External Email]
>>
>> On Mon, Aug 29, 2022 at 04:49:02AM +0000, Gupta, Nipun wrote:
>>
>>> Devices are created in FPFGA with a CDX wrapper, and CDX
>> controller(firmware)
>>> reads that CDX wrapper to find out new devices. Host driver then interacts
>> with
>>> firmware to find newly discovered devices. This bus aligns with PCI
>> infrastructure.
>>> It happens to be an embedded interface as opposed to off-chip
>> connection.
>>
>> Why do you need an FW in all of this?
>>
>> And why do you need DT at all?
> 
> We need DT to describe the CDX controller only, similar to
> how PCI controller is described in DT. PCI devices are
> never enumerated in DT. All children are to be dynamically
> discovered.
> 
> Children devices do not require DT as they will be discovered
> by the bus driver.
> 
> Like PCI controller talks to PCI device over PCI spec defined channel,
> we need CDX controller to talk to CDX device over a custom
> defined (FW managed) channel.

OK, thanks for clarifying - it actually sounds quite cool :)

I think it's clear now that this should be a a full-fledged bus 
implementation. Note that if the CDX interface provides a way to query 
arbitrary properties beyond standard resources then you may well also 
want your own fwnode type to hook into the device_property APIs too. 
Yes, it then means a bit more work adapting individual drivers too, but 
that should be far cleaner in the long run, and there's already plenty 
of precedent for IPs which exist with multiple standard interfaces for 
PCI/USB/SDIO/platform MMIO/etc.

Plus it means that if CDX ever makes its way into PCIe-attached FPGA 
cards which can be used on non-OF systems, you've not painted yourself 
into a corner.

Thanks,
Robin.
