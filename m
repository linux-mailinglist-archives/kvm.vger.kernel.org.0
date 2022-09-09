Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7915B432E
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 01:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiIIXqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 19:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiIIXqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 19:46:01 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3256EC7B9A
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 16:46:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9LuirkcYbG9bxWbvC607mIBVfiFhT2TkzCuScJsL9XFkpKTCVI8iJxew/dfA402lNPaD5F8cZXXd11at49RQo9FRNhXLDDKnsmzcAaSdeCeqC9/Scmgz1ebzLp+lFYQsjwgCzK/YZXCUevrzN5TKLO3B5pBVb2qwFg+J11ibfN5firEXiLisP2DPKHjGz/GDfUfuZ0Qgh11r3oKIvJKsMshOl6wmF9OCP05XzhFyxFdP5UiXKBCIa31R1KFFPHueHA3JG9G9o47gIs6s6I29io6SKe9PWJGYnx5iiVPV0iTImM6FBv3rWW5DjWuS54TkrpcXsJkLr5M7vz2JISslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLMVyY6iJWo/HxpZpXpfvGQzSWakI5hku1C9uvqEX6I=;
 b=PqkxPPDozSlT61BUvxe5MXTeUOWZy2nEYynaUMyPdXO/856mvvG2B2131KN3tcY6VvIokCJkKqIOzQ8KCzmC1SZPer3/xqlMokP+Qc4ZpqpUDwSNyRB9gLwelfSJ/kUjkb/KCJJygI3DotviEotLsj0ana4mOaXYkrvpJU/gQ1ePx5jUoiRdGrBt92DIaCz/5f2q1iM2rq/z+b4N/BwQuwK7IW1loAk+RHuPkN2LbI0Q63FuHiDS59gYE9zavsEB/ZlEaZtVV22etT5EeZXnhoL0nQxlmANe9MN32eyRrXQFk6LrDO9ZawIufWkvruUUms6kNpRyrQ4TVpNprxe1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLMVyY6iJWo/HxpZpXpfvGQzSWakI5hku1C9uvqEX6I=;
 b=tPC1/6RmktaR5C2w+bdIBMcTD5cj3et1NY5SCRMqKM9XwC5lP897CCxTXLeC5F6pbLuOMCpYLKJQdPqvWDyYFxRiCRXTkGR8KHF59cCVweM2WXjrWGzxneKgxlCnQrDkIR31t1AkKizU8ejoQpHAHJJ+PNxsLv/K327gs1SZF413K6Ah6gDjhRzY2vdao05BgcpGqoZ5BMN4P65Ct+5DjKpn4BKyqFM1qM9/gzJ8BZzCCJRnEUZWe6ZN1+gFjUEtNgPHglfDUgMKqwcSRbNKMpNs5E8o6j7FH042+Y9ceriZR2jSb9cxxNB+R6rAnd9hrBN4Kn6hKpN8oPsN3/yH6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6549.namprd12.prod.outlook.com (2603:10b6:930:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Fri, 9 Sep
 2022 23:45:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 23:45:58 +0000
Date:   Fri, 9 Sep 2022 20:45:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Message-ID: <YxvQNTD1U4bs5TZD@nvidia.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
 <YxpiBEbGHECGGq5Q@nvidia.com>
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
 <Yxs+1s+MPENLTUpG@nvidia.com>
 <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com>
 <YxuGQDCzDsvKV2W8@nvidia.com>
 <b753aecb-ee2a-2cd0-1df2-0c3e977b4cb9@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b753aecb-ee2a-2cd0-1df2-0c3e977b4cb9@arm.com>
X-ClientProxiedBy: MN2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:208:234::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 138977a7-5ee7-40ac-daee-08da92bd71be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPJ1D3umR4jIGJLwixx33RkxxvJHzJ3r77HDb3yOQqQzCoL4mn+iuCx7BWW9RNnQM9WUi9zhbgVe5G4zm3s8VmnQ8CaHRu8ycdlp9K+ecRjHpy/9K/usQQeS4nPnMDNLLAsiK//AZQztcVMLYCfcD5VcbSUy1t8BnN3qcLbEKvt4Nwvh2JWiFdIx2/0XA/HWqlDHjoZ+llBFXXs/t1naDzfsORNU4xS1DdBzbuYk+OpDmRQO5KdeWFM3lKUtpKZxuwKlnVe1BoKi9kpEl2rMlDOUVCVPIpxD1nzPqWq/u5/PC3dWqMsluECK6YZuoji0AwteXz26Se2HAIOzQoPI9UCKgNkfhaSQxRzwheuJLYgsTd70krHP0EHXHg+2aIQ7cZ2dJ6fmNXAqZ50xN+YfWBqg4PoOz1D7hyKHfW1Cd5yxAIIHrslTYIFi+/h5VmAtQpfHPR5UpODyXfFl3V/sY2Y1GIo8CIOx+YdlTzhA9qhdE1ahuWuaoB0LJ2fzrOlgAesyKX5cuka3qPS4t4AZKRy1xj3R9jLbEqYXVWhM7sKaJ5E03OSYeiXDQbhh1LgrlqhCcErPxXmdXwJqKe8VVDR3fDAquzjPsGiToC3iF7rW6au6GCa3B4xEoueJBFIAwJys6hbB/AcZHsYxbE0ucSP2Zehs2MLBXWZ9y5ApZS9bWDNALCCDpq2/8JUmtPHugPnv6PY6lZ80VnX8XOTDWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(316002)(54906003)(83380400001)(6916009)(8676002)(4326008)(66556008)(38100700002)(66476007)(66946007)(2906002)(2616005)(6506007)(186003)(5660300002)(7416002)(8936002)(36756003)(6512007)(26005)(41300700001)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C6WBFEq+aHnYcYsukL1MXA29Z9yhxFKyFqPn3XrIgZvGX0EH2AOKZzGM0oEh?=
 =?us-ascii?Q?NW1U7/zPLtV9IQbaRot8xkLoJ1TXDv9GwGYart1rNgoRHJDUjzUngcUZqPJ5?=
 =?us-ascii?Q?26Ro/Nr3Km40MWubhRAc+8N2Jyar9t2buIAqsJ5mXPtU9Re6iYv7twDIJUPu?=
 =?us-ascii?Q?qC9HqdXGD+92WpMpxMma6D4w62LkxeyH7X3YnsQfxl4p5KQQu1PbfxemblAe?=
 =?us-ascii?Q?IklGA/KiJhh+ssXOH5wfLX9Kp+f7vFfwWUHeNFxilydmJXRW5RFKZHtdcLN8?=
 =?us-ascii?Q?dF3v4ipKcgr6zJXKuH7UjqfvX5Rs7qC4qxpAt5mFA6yugwTGTj9hF5G/FDVD?=
 =?us-ascii?Q?m39Vwux1S5iCIMLuj/tyTn6S5khz2watoGJE90wgbWQui0Ssosga8UEDx5ik?=
 =?us-ascii?Q?EMcjJpNRWVvYbPL+O08xsexJFmxwGGwfXPywM8LEqUApvTLhnVgBH3ky+svo?=
 =?us-ascii?Q?3X338PG/1oNMm+7BtO4XDskrPy/R5CgRfzCOIvxqBz/oUfiooNyp+cKhOjZZ?=
 =?us-ascii?Q?SBIp1xdXP5FYSBhxEi30NVdajmwJgZEghvSpxZSxdqApXTDrqimfcoGo/M9M?=
 =?us-ascii?Q?bVIdSaKqaGf/W6Vsvpx4U7RknHuuWhU0P6oPBvED0gobWG21nZahssDwBE5F?=
 =?us-ascii?Q?/ya3yYYZDdHmis4KrOXIFDiPuCBlgnMFM4NoWgKr4Mwi1eV5karMIqtTKU2I?=
 =?us-ascii?Q?TSSawV34/ZuE6xJtBTTFFm8SRl5vUZTVMafUt9N44uYBDYMUE1UpVvmu9nTt?=
 =?us-ascii?Q?5LGBOTR8KMfbx9/qfZSTFf8Tr55SzJrLje6PNZ9iH3AsridtwAvTHVwpyMrV?=
 =?us-ascii?Q?dLHcj96yBpaWbS2Pxk8HibA7nXsyAuXriTcUAhAu70w8xqxBTLW64dThNf9a?=
 =?us-ascii?Q?xUNL4Ia5IYOc0GpPIct30SrIgg51XBOyc2GDU3GbxLsi9VtO3OuJ/VM5fRKn?=
 =?us-ascii?Q?pbH1hpZj+mvMfBsWiwq7y5/YGLgTAbX87kiv/rYL3Qdiv6ZIF4T/lZk5HTWU?=
 =?us-ascii?Q?ML8N0Apq9ZTIqVQa/rLPlHFQWzdtqU3I1D1SktW614eIfqihICouMZ8kEeml?=
 =?us-ascii?Q?yrVK9DJXP/SAEgpwYw1zLf1LLa8BFT1U6PgJRe3UYN/aNMwLAZ/C25MyTw2O?=
 =?us-ascii?Q?qyHijpJu76sx85gj6olqpnQ49s4+Z1kp9eXJkjCkuEFHWj1xXzD/F+JhwXmN?=
 =?us-ascii?Q?U8kwMFHNcCpmnhP0zNrOtY7TuDP3zhWrTAt3Tkwq1ZFIFRVFfN0esY8VjPaZ?=
 =?us-ascii?Q?3xzHlhEtQduHD5by/Aich2FSSD3NC8GoILik0ITVgGD2Tgg+0dFTWAtpz0AR?=
 =?us-ascii?Q?g+Oxe+XQOpwMV1vZ4ZlpnlSyHBhPfb7DBAJKXfMQCgCMD9JzJu5V15ztHCNw?=
 =?us-ascii?Q?VNltqsS+8YlhgKfIplRaWNWwLjGhRlaNuqEvjUrnIjJb5seFJKRKPWUPaLX8?=
 =?us-ascii?Q?9RuDaEHz7lU8gMiwWtbA1DHoeFNyw8N7WvIXMpzo/jgrr0JF9SW4n4TfN0Q4?=
 =?us-ascii?Q?DBqKiML7wq9KTCK39qViWMWRT8XFH2Z2Fx4j7eU2CIIJAbOkIiLml5tXECOQ?=
 =?us-ascii?Q?eP3QhyDXwIofJO3Ma9JM85OAYE1V1sNdLu8F0OLu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138977a7-5ee7-40ac-daee-08da92bd71be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 23:45:58.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pvwb2Dl7+uKM0HmUR5GAg5cRt4UjcPct2lYgP/f73KMiU4eRxiIsDmefyvRrK3RU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6549
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 08:55:07PM +0100, Robin Murphy wrote:

> > Isn't this every driver though? Like every single driver implementing
> > an UNMANAGED/DMA/DMA_FQ domain has a hidden reference to the
> > iommu_domain - minimally to point the HW to the IOPTEs it stores.
> 
> Um, no? Domain ops get the domain passed in as an argument, which is far
> from hidden, and if any driver implemented them to ignore that argument and
> operate on something else it would be stupid and broken. Note I said
> "per-device reference", meaning things like s390's zpci_dev->s390_domain and
> SMMUv3's dev->iommu->priv->domain. It's only those references that are
> reachable from release_device - outside the normal domain lifecycle - which
> are problematic.

If the plan is to make the domain refcounted and then allow a 'put' on
it before we reach release_device() then it means every driver needs
to hold a 'get' on the domain while it is programmed into the HW.

Because the hw will still be touching memory that could be freed by an
iommu_domain_free(). By "hidden" reference I mean the HW walkers are
touching memory that would be freed - ie kasn won't see it.

> > Do you know a reason not to hold the group mutex across
> > release_device? I think that is the most straightforward and
> > future proof.
> 
> Yes, the ones documented in the code and already discussed here. The current
> functional ones aren't particularly *good* reasons, but unless and until
> they can all be cleaned up they are what they are.

Uh, I feel like I missed part of the conversation - I don't know what
this list is..

I did look. I'm looking for a call chain that goes from
release_device() into a core function that grabs the group->mutex.

There is a comment in iommu_group_store_type() that suggest there is a
recursion but doesn't say what it is. It was an Intel person who wrote
the comment so I more carefully checked the intel driver and didn't
find a call path, but it is big and complicated..

There is a commment in iommu_change_dev_def_domain() about recursion
on probe_finalize(), not relevant here, AFAICT.

So, I did two approaches, one I checked quickly through every
release_device looking for something.

Then I looked across the entire exported driver facing API and focused
on callchains going back toward the core from APIs that might be
trouble and audited them almost completely.

These APIs do not take the lock, so completely safe:
 iommu_group_alloc
 iommu_group_set_iommudata
 iommu_group_set_name
 iommu_group_get
 iommu_group_ref_get
 iommu_group_put
 iommu_get_domain_for_dev
 iommu_fwspec_free
 iommu_fwspec_init
 iommu_fwspec_add_ids
 iommu_put_resv_regions (called from release_device)

Does take the lock. Checked all of these in all the drivers, didn't
find an obvious path to release_device:
 iommu_group_remove_device
 iommu_group_for_each_dev
 iommu_attach_device
 iommu_detach_device
 iommu_attach_group
 iommu_detach_group
 bus_set_iommu

Can't tell if these take lock due to driver callbacks, but couldn't
find them in release, and doesn't make sense they would be there:
 iommu_device_register
 iommu_device_unregister
 iommu_domain_alloc
 iommu_domain_free

Rest of the exported interface touching the drivers - didn't carefully
check if they are using the lock - however by name seems unlikely
these are in release_device():
 iommu_register_device_fault_handler
 iommu_unregister_device_fault_handler
 iommu_report_device_fault
 iommu_page_response
 report_iommu_fault
 iommu_iova_to_phys
 iommu_map
 iommu_unmap
 iommu_alloc_resv_region
 iommu_present
 iommu_capable
 iommu_default_passthrough

It is big and complicated, so I wouldn't stake my life on it, but it
seems worth investigating further.

Could the recursion have been cleaned up already?

> > > @@ -1022,6 +1030,14 @@ void iommu_group_remove_device(struct device *dev)
> > >   	dev_info(dev, "Removing from iommu group %d\n", group->id);
> > >   	mutex_lock(&group->mutex);
> > > +	if (WARN_ON(group->domain != group->default_domain &&
> > > +		    group->domain != group->blocking_domain)) {
> > 
> > This will false trigger, if there are two VFIO devices then the group
> > will remained owned when we unplug one just of them, but the group's domain
> > will be a VFIO owned domain.
> 
> As opposed to currently, where most drivers' release_device will blindly
> detach/disable the RID in some fashion so the other device would suddenly
> blow up anyway? 

Er, I think it is OK today, in the non-shared case. If the RID isn't
shared then each device in the group is independent, so most drivers,
most of the time, should only effect the RID release_device() is
called on, while this warning will always trigger for any multi-device
group.

> (It *will* actually work on SMMUv2 because SMMUv2 comprehensively handles
> StreamID-level aliasing beyond what pci_device_group() covers, which I
> remain rather proud of)

This is why I prefered not to explicitly change the domain, because at
least if someone did write a non-buggy driver it doesn't get wrecked -
and making a non-buggy driver is at least allowed by the API.

> > And it misses the logic to WARN_ON if a domain is set and an external
> > entity wrongly uses iommu_group_remove_device()..
> 
> Huh? An external fake group couldn't have a default domain or blocking
> domain, thus any non-NULL domain will not compare equal to either, so if
> that could happen it will warn, and then most likely crash. I did think
> briefly about trying to make it not crash, but then I remembered that fake
> groups from external callers also aren't backed by IOMMU API drivers so have
> no way to allocate or attach domains either, so in fact it cannot happen at
> all under any circumstances that are worth reasoning about.

I mean specificaly thing like FSL is doing where it is a real driver
calling this API and the test of 'group->domain == NULL' is the more
robust precondition.

So, IDK, I would perfer to understand where we hit a group mutex
recursion before rejecting that path... If you know specifics please
share, otherwise maybe we should stick in a lockdep check there and
see if anything hits?

But I'm off to LPC so I probably won't write anything more thoughtful
on this for a while.

Thanks,
Jason
