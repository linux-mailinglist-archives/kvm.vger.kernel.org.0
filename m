Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969D95B3ED0
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 20:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIISab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 14:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIISa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 14:30:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C44915C9
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 11:30:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVEtF4CnOWwj7mscijPtSdbwQDA5/udmMqexQWwzjMs6B67cwG68PBypa98/pobarEwsM2b76ZmSivpKTOSPBdx1yBmkXj1hagGRXf15lzm9N7KJ2ELO29KTFu8yAiEZNaQGdWVCaMzZG7egR+qO/8XB1QKAXtZOkLUTtUXG0uzJSGI2xG7gPNkaeXDsFI+13Fpce87t01QTqMQCbhGvgN1sj4OEArESrn2+zdauaR8PpSyNMnfSZeKfYn9OfcWFUULZ03UyJbhiQeG34eW4fUb+AnpwA1ieWFbuL4dE+yv4E2AQ9i2DBotEQXU/kZOJ9ibQrnnpIgBLzIP03JyyUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXWpo0JMmigKBkXqr/lVO62IA3j7sL3Zc1drDMPHGko=;
 b=O53XXYW5d1bvKdGfgr7lpgX3Tk4j5OCJnyIhPpRrnfAFrpAVhUoIH6eSbEo++ccxtNpTwfEnjnEJ7G2r5U9OuV1/zKwkXEFh28Z74icwmyV95ZvrECOYgLeWGbC0feGUoWO8tP4a50JBEB0aUfnDw5wGD8oY/lTQhnA1gkwfa8P4Hr0S3z7KG2U9HzXqmSaImdR8g3v89bMsAVG2wX3bXTCgMoM81XgWdUhZAJE9oBrlTDOwghfRkjvFOeGPgQt3ifUlZP2H75ETUdqxAJijQdR+FKfx623KtvNj5ODysJtNg+d+UiszDL5EgGQRhRr/utDCOXWnNL+hPJQdh8V/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXWpo0JMmigKBkXqr/lVO62IA3j7sL3Zc1drDMPHGko=;
 b=KV+MxA3NlHjvVPmWAuS7xmEZ0Otp8OUsNoeh88LmQ1TB60Fk9ES2ZzPIh3HDHkXkxHtB6/i/z9dWlLQwst9XGIb+Rk434lmouNVmDkSXX/DhW7trzrgUg0tziuEA5cbxcexb/5u68DkQMZq7fed+KYwj0mQXbz/mpmhfmwdRaEthaoHcwrVLFoUU8tFFhOAcSgPhFjZBWuDrN0tFyiAjopoxJTzk7zZ3k7w8HaVUJQPbtBWMMP5MensVqtbo4uHz18D8fe3cwoq72dAlq2ajE6u2RxegTbsEoolXBC1XbSN5UtntxpvyNBSBd6lrT7t4Z3iOKzgtpdA7l57nF8HF0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 18:30:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 18:30:25 +0000
Date:   Fri, 9 Sep 2022 15:30:24 -0300
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
Message-ID: <YxuGQDCzDsvKV2W8@nvidia.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
 <YxpiBEbGHECGGq5Q@nvidia.com>
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
 <Yxs+1s+MPENLTUpG@nvidia.com>
 <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com>
X-ClientProxiedBy: MN2PR17CA0034.namprd17.prod.outlook.com
 (2603:10b6:208:15e::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BY5PR12MB4903:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a04b80-b032-4f01-8d8a-08da92915cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNczSj6hdhHnnUpVeyvNZ53QDuvznzKO074pUpSM+MyiKIRRtOgQIV9rHKfhaYyvo9Fuo+vvd2DG/fPcnVgeEWGAWFST+VQFaYuRHSG7SE2QAKZMYir7qd+B3zdMcFc/+trQu8TLBb5xAcHH3/1kk6HkDbbn52OBrBFBGkzluBr5sMbeRLKRn73zmsEvIxEN+Lye31g2NcGSDKQeZKT/E4RsS80Nvt6MQwXz7bVn+Omt9tLswGH5npDZ2ila16Snkf9M+FgZargCA8W2TZDGuyVgJLo0H4TCiESGHXJnrTogbn4fwJa4atnyewPYAqapaw9fHWzYD0YGT6831f/jDaN5Y/23gQZo3RfNLTm7lsPlg6UHDJwLBRDyGTror3b43wGvzSa/Rz0rMclqyvp9W1ybgrh71D1Hb9FfgDXwuVEMfv4w+xXliPBnPpA8yQdpfzMgBvHne9DkOUDyJE5kLNtP7zkd8MuS5SoUrH7cZAMaHbQfcqfW+9S2GsxC5PJ9z/0xceSCkzFnX21dKK5kBojvJIiwV0IKtmSioAvjVtpd0Nu8BRSYmoCNParfc2sUxPO1TawAtdJAP0KjVOxTmUAar+SfDVvw7D0RCDXwrQ5vSNzifyG1MXqpGw+VGpuGN3q/XA4twUdvbwdcHpO11AfzZCGMCB5TN3V8cAsV8u3MaHQ9cOt8Rsy9n6KrudKnWOdKdO4CSX3lekYpntaF+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(26005)(6506007)(6512007)(6486002)(83380400001)(186003)(41300700001)(478600001)(2616005)(6916009)(316002)(4326008)(8676002)(8936002)(66476007)(5660300002)(7416002)(2906002)(86362001)(38100700002)(54906003)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MBaDDQdphff3jitlDQ3XmGKeYYRYsTlErCbHZCfA0yLasNLVXtVFs6thHnJz?=
 =?us-ascii?Q?9rsMrVixOsI7VtOhjpYvUY0dTL++zirwLWancYaORycBkqqgQQ6UmPCeyTnj?=
 =?us-ascii?Q?1sO0LgL9Z4TAYWk+iWY74PeNT02sxCFJyYR+MNZy8aJiPtNr/ORoxqSuf7eS?=
 =?us-ascii?Q?AB+CsPrFSydQzm5orm7+ebQ4PCpvc79ng5BfRv6LitY5MWG9D4Vg0cQ4VA53?=
 =?us-ascii?Q?T79TqOvakxiZcABtdJLArfAdoPH+gX849fuQw4WMJpRarEv2NmKiynJRmMTs?=
 =?us-ascii?Q?LQg44gFI9/2zCw5CJRhYjnp9n912BFUNrFy2OGdBbPdykeMlHcXPFX3KAvZu?=
 =?us-ascii?Q?naWjWQFYZcdQa/1box4eOFnGgu3HGqpucHI5acYGEEuy5/CCUF9X3nQ6vkcw?=
 =?us-ascii?Q?i1Fs+C0HqmcsizhDLB2X0lmd9aqOr4a5yvwiA2a9T3Vbmh/3mlmQGf/NqZIM?=
 =?us-ascii?Q?OvHUqyaVTpW5ICFKoKYCfgEjcjq4YT6qOdJWlQj8kmq6MGMM6LJs1eY4AjGl?=
 =?us-ascii?Q?BXVz/S6GOHJL5Ii15ZAI5nNpaVkrF96MpGgrv4OrekS8z41VsXUtZV3lf1zA?=
 =?us-ascii?Q?BLZVriWSqV9TeFyGou9HvUPUHu3A8JeajpEfeAl9JbkSoUnT2YkJEL8+SCgj?=
 =?us-ascii?Q?JIjEu0ysv1nAgC8tmkyzeB8ocCH0KREfRt1j9tePXBh7/Z1DlwR37FEf+Wv7?=
 =?us-ascii?Q?6NBdWyQKFqphqZNG4VYnVp1mGBKMaYCyCTLi15jy6TjFxcWHRMgCDUfm+WsO?=
 =?us-ascii?Q?Q1CdtRPUDWytpBnZYXeEyvG/YgKJ/viRXph33NJxG+qJL6vcc/MugPdppEx+?=
 =?us-ascii?Q?DBYp99HnlJTfgipO5mcN3dgQUGrJJoljEwIipMkhCu0DH2W1uQ+xSjEREIPA?=
 =?us-ascii?Q?U+Q6QiARFUsHX8D+R2nJZhoiJZIScpCXvteEu3y9MZWmgAutNa1xzinNZ57D?=
 =?us-ascii?Q?IX0dFhBhvazGutBlNSEQgayI2AhtCAwr0adhPM0RywWDJjpuJLLltOyAjW2k?=
 =?us-ascii?Q?MGmeVzHhRPiFRxAFEGNKW495z6qi0xM4L3q/PyU4C096C+gUHXDuludGBfmx?=
 =?us-ascii?Q?OsGNhXME8L7nWVEfsNVgPyeUHQysqBuvvbkbTzxWZaHS9T/19LWFlKwOBqDG?=
 =?us-ascii?Q?nmaI56Pt6CfNuvHFZl0QRTp/4w5f/KuD9UtWKsfDtpRUBMjQ5nCoxzj7jvQn?=
 =?us-ascii?Q?xLf3CRhVxfK1n1RJ7M7B7eDkAM7Vxex+bEKuUb+QIgvuB65plYhEiIqkDy+y?=
 =?us-ascii?Q?Rqfw2pq2a/dJ0nxnU3UIXYN8qxEa5zPzlLkBjGUqNkOzLXZiJGrgbNhOM/P+?=
 =?us-ascii?Q?K/lgNk+CNH6vj3YEAk7KZTKuKZFCaem0W7a5eya7RJXxHFFiNgjzjinvEGT5?=
 =?us-ascii?Q?8IZgnsgC7mUpW8O1eTlhePHCqUC0giZ/4NdwvbK1rXgdYAlM8vwV8bTwyTUl?=
 =?us-ascii?Q?akqdvZqwpdb5ugn/xZFr4lCM3W95T5WFWc8ByOg0m6hJKLAQa6Ti6aQBL9PI?=
 =?us-ascii?Q?aTmdd2IfCjZczza+dbYKD12phOaOBk7lcwpnCs6jaHfGxrEm/bY4hdcVOJxw?=
 =?us-ascii?Q?6SBhKqko5sCQXfspR0mitXwSo2tG2YBCWAgTqWEO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a04b80-b032-4f01-8d8a-08da92915cf2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 18:30:25.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kPZS9SsRZ6oyryTyJ8HyxzNnjfHT7rweoyaaobbm7cgK7r0F6A5mNAO2h/4ay0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 06:57:59PM +0100, Robin Murphy wrote:

> > > That then only leaves the issue that that domain may still become
> > > invalid at any point after the group mutex has been dropped.
> > 
> > So that is this race:
> > 
> >          CPU0                         CPU1
> >     iommu_release_device(a)
> >        __iommu_group_remove_device(a)
> > 			         iommu_device_use_default_domain(b)
> >                                   iommu_domain_free(domain)
> >                                   iommu_release_device(b)
> >                                        ops->release_device(b)
> >        ops->release_device(a)
> >          // Boom, a is still attached to domain :(
> > 
> > I can't think of how to solve this other than holding the group mutex
> > across release_device. See below.
> 
> I see a few possibilities:
> 
> - Backtrack slightly on its removal, and instead repurpose detach_dev
> into a specialised domain cleanup callback, called before or during
> iommu_group_remove_device(), with the group mutex held.

See below for why that is somewhat troublesome..
 
> - Drivers that hold any kind of internal per-device references to
> domains - which is generally the root of this issue in the first place -
> can implement proper reference counting, so even if a domain is "freed"
> with a device still attached as above, it doesn't actually go away until
> release_device(a) cleans up the final dangling reference. I suggested
> the core doing this generically, but on reflection I think it's actually
> a lot more straightforward as a driver-internal thing.

Isn't this every driver though? Like every single driver implementing
an UNMANAGED/DMA/DMA_FQ domain has a hidden reference to the
iommu_domain - minimally to point the HW to the IOPTEs it stores.

> - Drivers that basically just keep a list of devices in the domain and
> need to do a list_del() in release_device, can also list_del_init() any
> still-attached devices in domain_free, with a simple per-instance or
> global lock to serialise the two.

Compared to just locking ops->release_device() these all seem more
complicated?

IMHO the core code should try to protect the driver from racing
release with anything else.

Do you know a reason not to hold the group mutex across
release_device? I think that is the most straightforward and
future proof.

Arguably all the device ops should be serialized under the group
mutex.

> @@ -1022,6 +1030,14 @@ void iommu_group_remove_device(struct device *dev)
>  	dev_info(dev, "Removing from iommu group %d\n", group->id);
>  	mutex_lock(&group->mutex);
> +	if (WARN_ON(group->domain != group->default_domain &&
> +		    group->domain != group->blocking_domain)) {

This will false trigger, if there are two VFIO devices then the group
will remained owned when we unplug one just of them, but the group's domain
will be a VFIO owned domain. 

It is why I put the list_empty() protection, as the test only works if
it is the last device.

> +		if (group->default_domain)
> +			__iommu_attach_device(group->default_domain, dev);
> +		else
> +			__iommu_detach_device(group->domain, dev);
> +	}

This was very appealing, but I rejected it because it is too difficult
to support multi-device groups that share the RID.

In that case we expect that the first attach/detach of a device on the
shared RID will reconfigure the iommu and the attach/deatch of all the
other devices on the group with the same parameters will be a NOP.

So in a VFIO configuration where two drivers are bound to a single
group with shared RID and we unplug one device, this will rebind the
shared RID and thus the entire group to blocking/default and break the
still running VFIO on the second device.

The device centric interface only works if we always apply the
operation to every device in the group..

This is why I kept it as ops->release_device() with an implicit detach
of the current domain inside the driver. release_device() has that
special meaning of 'detach the domain but do not change a shared RID'

And it misses the logic to WARN_ON if a domain is set and an external
entity wrongly uses iommu_group_remove_device()..

Jason
