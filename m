Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DD6EE51C
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjDYP6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 11:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjDYP6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 11:58:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9332CC17
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 08:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF7ZabL/EnEVU2HZuVf1DW8ww4yHn5mbHkrGING1sTyQTLnnrwjR0234iVYh8lDAWFAatEXRfVXz8nfCCj0005kAtD0pQkzblK7TJJcqaN0AYxFZCfJL4fX/78Z9JYN17ZQAOapo5ggrOGwt7K2UPdRYLgEylzoo5jJxYh5FZRKTl+b6hQ8YXrwlXmlpYJtDOdgRAQ7U2TvzqeIkmwbTNKF5vP8cO0T3KKo4lVLSxnCJv6Pxm1Qc1li6hH0HjXV3i6tY3nx/T2q2nJmLXq5tbZbNPg4L0KLljf1qcaB2+gWvR9z1ax/BSKSAc3EbCXI9M9msbG4v66VyjNIJMmLaXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clWst3b6Qmd+kqrUTHpsw/cWdyeioO+m7YXA72/XEm0=;
 b=li9xUU9q5pf+/H+HUMdai30Zcrj4lOtpAyw2gJLUgadQctl9hVQ1K9anFGsv+/nTLHH8xcYO3vd9LsAJ8HX96VJTXajb0Pd8CUeT32PJ8Y9GTVrfnaXEmn0xppIz53puZ6dIP2BSuQDa4WkCNgIX/vMe2g3oyb/bfGHaXI0cwF6xxbRGfQbzHsjNV0bzFQalgHiatf3rlyBPt4WUtqi+CfeJXhlaySyBw/9jpbkcgYRQwxc56hBwoJE8VylVDsMA6g65QgeqTttNpnSsu0jjS74qgqU1bBl7TwDXuUo1xnbIwXbEN0pXA/lazLwXM90MJ89iesPbtZ+mALwJD9dQNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clWst3b6Qmd+kqrUTHpsw/cWdyeioO+m7YXA72/XEm0=;
 b=JFbv0iVCtgjt2PV3pTVTr7FpZJTFYYfJc2O6jRln0XkBs/bJQIXhZcsBeEIumvoWk1G9Q7E++HVjOK86UpuNN+6auL6av4TfYbPDLFUK1Z9Z+TBwi/+PNcyBIo+fKjWAtkrDwIJLdYm87k20G3I2Dm66YkS4wRG5UOWPWtV767E7G/Fwu3Hwj4whPtZNdT0JAI58Fv+1umr1HFIPPkB450bKHpY7PiO2l8xkDBD7LAxnxsXFtumoiJCIBdZ5F2ItbsZ0dGVJoOxkJCYbUryr+Sec9f3pUtI93aBDGDuhPv5R0TXMlyLWQfG2gS5teaDdJPV3dXg6PaEpJ35NuRdy1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 15:58:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 15:58:27 +0000
Date:   Tue, 25 Apr 2023 12:58:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEf4oef6gMevtl7w@nvidia.com>
References: <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
 <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
X-ClientProxiedBy: YT4PR01CA0420.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: f4080f44-a9d0-4935-d0da-08db45a5e856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ggGPvvlbGglHb/ij7ECL39eRLVU74uO+MqCu6uduSVmV5/Hvy7Wr/m/VMEymI98MLksZ1uiGBkuLo4XUPS+ME5je6JY5h8SKZg6zJBuJEWL1+7dIcQnuq5SDdyN5VmlEJh/0cGCywS6rscxMZ5l3I85i04z/1uNVN2izdcMuwpWxJ5ifrkjowan83F7MYQtP14AIJcmkvb1Rp5Z9hmLnAU9xDp1i1u0sBO84X9FRQdW+EZHowso90FIX9AQngiffsWm1hBGcug2seXhLjL0X6lzJ3PLB6QRkYeiy1pBgv4Fx29+/LYlEMOo1AOfAshPOfQyA2i2hzy3cIaXgyK/r4y1FYr1eRThdW6lxVQGxjMFjD2o5L7uOH9OTjrjgJ+mIXp5fb8z9IyC0m6A9BN53ZW16fdf2FImwPkbFzlQQzt2EBypBAZ3OGq9LinCu9nMHLLoDJTlKNKm6z8PEOlGdwCWLcIlWqh/EWb1wnBIBevtZirR4wxg5lRrNbcBbWLNv9FCeoFjf8jRZWb4n2jb622DGAa90oXzUNepSlJYZa3op0suJuz2gu74FHwKXVPu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(83380400001)(478600001)(6486002)(110136005)(2616005)(6512007)(54906003)(26005)(6506007)(186003)(53546011)(5660300002)(36756003)(38100700002)(66946007)(66556008)(4326008)(66476007)(41300700001)(86362001)(2906002)(8936002)(316002)(8676002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+PG6eV+LFJWEXRhlwXxUOPxJ0Te+NZo5Xc4DquDXyXq82MZzfqRXiqesesz?=
 =?us-ascii?Q?2sYf2cjo6QqBZxTGV2O55491QlGXUEHtwgagEhIT+9ff6MVAsN6tXDLctnUL?=
 =?us-ascii?Q?ACCZNKyrHTF/WslxMGXiDQmtp3BnNFY0RWjSxLdpK9xYe9kL+HCUSTkrKEL7?=
 =?us-ascii?Q?B1mqXXdTh9+eM5pdfdF7i47AsBsXUv9CV3PRNN1FdyZqbSBnb0TAlgDMiaJ3?=
 =?us-ascii?Q?NaggDsbZdZyJy05ptJ3UPh0koZEN7tMOMYGj7G1c/lIVHMqK/DWJWkmsxDl6?=
 =?us-ascii?Q?UMogDgd11wopGVLx6G/OQP/66yZ7P1gdLOueIU50owOzmItHw+JmpS+CxI0w?=
 =?us-ascii?Q?tAVP8StijvI0NM6a1uVGieuW572IW9ByHsQmbynodcOKaEdz13s1yzf/elDn?=
 =?us-ascii?Q?OKYbB8My0njzsaLp7J8c+DCxLfmVdhChGEXeB1IuCqqRTjiqZhe3D3HYdK7y?=
 =?us-ascii?Q?tw5vrhOD6O5gFzd7AvfgDkouKqy06x7GXnMX7RwJ1DHb0V46BMIVRsbb0qM8?=
 =?us-ascii?Q?nMFz1lmYaWmMA6E8zpTtwAFKtuFrAN7ZoAZR0aw2NaNtOih7KncCbW8YwedM?=
 =?us-ascii?Q?oDffJsIB1lqkqbpCppA3ACFssgSAp+mtDJV+dLu5UknPDnIbenKWIa93aocr?=
 =?us-ascii?Q?KSTUTEyPyhSSFkULkvTfet9rgUAdHk9BGxnLNpLWb64k2Cxx0X19VgR3JZL5?=
 =?us-ascii?Q?ccQGTwKaschfKa1ToMuK8FaC/uBR7ULbO3QjNmpLFlaFRu0H9ak2cO5YeFjm?=
 =?us-ascii?Q?4xRZGrjD6KlJGdMeNY4UGOP2PhvCiblnD3FX1UYVC05irGkCDG3MfpfcQn3q?=
 =?us-ascii?Q?zoFFBMkekg2Okjj4ADWG4KfM/csdBM9t+6FTdMbMAzBRubK6SJmMY7iqdrjR?=
 =?us-ascii?Q?XZN+F/VsXr4NeAv2jqVLYEtMvJTwXpAuXJQpMmoOoL+SZEMNs8zAxHZyDGzE?=
 =?us-ascii?Q?jXnDuVxsuQ04bwOi6s5h+vyka7XkUWuvp9205HaH936cbJpdXf+27sAC4vhH?=
 =?us-ascii?Q?9FUyau0WN0szKjtMB9CUO2eFghkm9Peq9ZzCVhMHtvQYjMWARkhA2Fd5VWjX?=
 =?us-ascii?Q?q+V5c4YICaS0WInY/e78uu5m25I0syTr7zu3EE/R6MSSi21jnoGpxoYpHItN?=
 =?us-ascii?Q?+Yzn7NTDbbNgm5BEceSYuhr97WlPjXZj8SISoL2rraxk8axoHbUNu0reYNoL?=
 =?us-ascii?Q?bPywWspEqYMoA9WxalAievPnWVBplDpEF+xywGcsPqnVNOYhJz9xQ9waJCnn?=
 =?us-ascii?Q?Hi3TJyHZl+XWFlXe2hyYeWP+uCdSnhvJYpFlPH4JVNqrvviWLP8f+bAyL9Di?=
 =?us-ascii?Q?du4PQEaMSn9GXkBQr8H7AEEzXJC7KwktA07Y5w65jVawI9p2qI7YmHJISbSl?=
 =?us-ascii?Q?Q1OioWzNyw0OStnu/XyL4A4PwEV44PHH9cAg3hd6Nlg0deyOqEwZVjMg1QzA?=
 =?us-ascii?Q?C2AIJnCxmdp0iW+khiLgGdWkqjshsFT9zzFDKviWAQ1YPHdvNLIg7Z9Ddald?=
 =?us-ascii?Q?v/VAZlUYcyBb32lSHgZ19AALYzbvBCmnzW23ROtXq13thlHo90p+obvCznN+?=
 =?us-ascii?Q?SEk8bzfsWFplQXJi8aEzX7Qyi3VqumrXYNZT3Hsf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4080f44-a9d0-4935-d0da-08db45a5e856
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 15:58:27.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3TzxEmf2il1iYOnSCDRMrnpk0hFPuAtBn+2isC9s444Av9Pv5VS9waU7N8708Xb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023 at 03:48:11PM +0100, Robin Murphy wrote:
> On 2023-04-21 18:58, Jason Gunthorpe wrote:
> > On Fri, Apr 21, 2023 at 06:22:37PM +0100, Robin Murphy wrote:
> > 
> > > I think a slightly more considered and slightly less wrong version of that
> > > idea is to mark it as IOMMU_RESV_MSI, and special-case direct-mapping those
> > > on Arm (I believe it would technically be benign to do on x86 too, but might
> > > annoy people with its pointlessness). However...
> > 
> > I'd rather have a IOMMU_RESV_MSI_DIRECT and put the ARM special case
> > in ARM code..
> 
> Maybe, but it's still actually broken either way, because how do you get
> that type into the VM? Firmware can't encode that a particular RMR
> represents the special magic hack for IOMMUFD, so now the SMMU driver needs
> to somehow be aware when it's running in a VM offering nested translation
> and do some more magic to inject the appropriate region, and it's all
> just... no.

Er, I figured ARM had sorted this out somehow :(

Eric, do you know anything about this? Where did you setup the 1:1 map
in the VM in your series?

So you are saying, the basic problem statement, is that the ACPI table
that describes the ITS direct mapping in the VM is supposed to be
interpreted by the SMMU driver as "memory must be iommu mapped 1:1 at
all times and is possibly dangerous enough to block userspace access
to the device, like Intel does" ?

This isn't end of the world bad, it just means that VFIO will not work
in ARM guests under this interrupt model. Sad, and something to fix,
but we can still cover alot of ground..

Maybe a GICv5 can correct it..

> > Frankly, I think something whent wrong with the GICv4 design. A purely
> > virtualization focused GIC should not have continued to rely on the
> > hypervisor trapping of the MSI-X writes. The guest should have had a
> > real data value and a real physical ITS page.
> 
> ...I believe the remaining missing part is a UAPI for the VMM to ask the
> host kernel to configure a "physical" vLPI for a given device and EventID,
> at the point when its vITS emulation is handling the guest's configuration
> command. With that we would no longer have to rewrite the MSI payload
> either, so can avoid trapping the device's MSI-X capability at all, and the
> VM could actually have non-terrible interrupt performance.

Yes.. More broadly I think we'd need to allow the vGIC code to
understand that it has complete control over a SID, and like we are
talking about for SMMU a vSID mapping as well.

This would have to replace the eventfd based hookup we have now.

I really want to avoid opening this can of worms because it is
basically iommufd all over again just irq focused :(

> Except GCC says __builtin_ctzl(0) is undefined, so although I'd concur that
> the chances of nasal demons at the point of invoking __ffs() are
> realistically quite low, I don't fancy arguing that with the static checker
> brigade. So by the time we've appeased them with additional checks,
> initialisations, etc., we'd have basically the same overhead as running 0
> iterations of another for loop (the overwhelmingly common case anyway), but
> in more lines of code, with a more convoluted flow. All of which leads me to
> conclude that "number of times we walk a usually-empty list in a one-off
> slow path" is not in fact the most worthwhile thing to optimise for ;)

Heh, well fair enough, we do have a UBSAN that might trip on this. Lu
can correct it

Jason
