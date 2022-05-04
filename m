Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3C51AEED
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 22:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbiEDUYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 16:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343843AbiEDUYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 16:24:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82884D9E6
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 13:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncd5Wa5u3/rNDnoVldhgmWjt64AA4HoW4B8EtS2qrnMIyabZwmUhgN/12XDXAdG0R/ZDPprLwjpuMGciJKNBvntgSxPXVDKUGHVCUnE1tFmu4nhTjC51ega5uozp0lQss7FLTpr9iGzRL5F22iozr3jnabHbZdNMdGKOaEdcnp0iTTki3yv3wLVtWJjhSgN6eRZ+XZdnogQ8lhQrl03BWkx+d1OXOEUJTFL+Ipj+Y6Dw89ZQHmbs0+67mTlpOqxx2Lnv1Th1dhserVEsKMqlg5fmSE3VESAQzqjYebpXQQi7QtU3FqLwEBl5guaypDgcCPl7V5BkGUzcMkxuvj1adQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p3Qfqz0y61luvRAFymPgTKXJsX+zbVQsVCX3UNg8gU=;
 b=MbiLxqTnUQkqDm4zAF8vL0rIPPrx92BOQRSi9TEDu2B58ywOg5MTRRgmfrq/XOTePjMZnc8N9brA74ROjG0eMVqAdLc/q00GyMQNNp1kGNEs0gGsu2NCjh0NSfwwNxFY5K4rCRSOLfvu+dN2QOkmvxUF9rhMgqolloX17aLtxLUI7vIB1w9KVNtI8FokR96Pw31PUdFVKEI73RNBWBn6LEvMrn/z+/8rB2QcnfdqfltUCFkxlrHNfIGtLUpErE+0VSzuWwK7hZYe6jZYHyfvjnujTFvEw4MDmN36xMY6n5ZRVNggqS2BowKVbj9Qs1BJDCrWxQosVwT8bx5wGnN90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p3Qfqz0y61luvRAFymPgTKXJsX+zbVQsVCX3UNg8gU=;
 b=QbzZD8qzXdKvvvmpNJIqSpVbOWJrb8jRiVPmBusCLUR36LziNAXhNW297cXxNlsbLdajOjQHx+CjE5ETT9SjaOgMD60NgRAxFNmJN5FbXaAluqm93EIFkUt6lrOg4BLIlULKWRSN0VECABqGmCGwAgBsBCMm6Fh4D/4LRx6npkKt6Y0T/jZ6EgSltqdMHDAU3y4lyGaBCbbJuLlBP2krr5F46AO7dSZojODHTuZJ8tiZO1TzDr7M14ibVZw8ojagiu235GEZQKYYojyd6JJjCEd6UUmJWVd1r0jMZIo1wSZGdhAY3btQxxIX1DHGMGi7W4XWaDdurS5YD4KgM+NGZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BN6PR12MB1890.namprd12.prod.outlook.com (2603:10b6:404:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 20:20:56 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::98b2:1d32:afd7:eb2f]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::98b2:1d32:afd7:eb2f%5]) with mapi id 15.20.5206.024; Wed, 4 May 2022
 20:20:56 +0000
Message-ID: <ab4dcdd6-cc30-f9a9-5e6e-6f040b21e5b2@nvidia.com>
Date:   Thu, 5 May 2022 01:50:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 2/2] vfio/pci: Remove vfio_device_get_from_dev()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>
References: <2-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
X-Nvconfidentiality: Public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <2-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7cb086f-6e68-4f81-ce73-08da2e0b9864
X-MS-TrafficTypeDiagnostic: BN6PR12MB1890:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB18908D0C89428D2D532E1AA7DCC39@BN6PR12MB1890.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61JFxEo2xfvpj+9g+LvR8dGpNtJcfkuZC4vhLC1MNWzPC3P9g/yzgnftjFx0+ndONhu48d29EdCUH6fy+648OEcN7ZyX2XnsWUlG2mfNqof0UdsX7TF5TaNL2sWK4rsc4fc7iqPogFmzBgCdlZNs23dSy6r2HS3+eaucrXb5Mr+K/184f3ljpW6CEEshYt3uLt2MyAcyluSJdSjC+GZYq3UOdscsgGWkkX31SbcCPmlpNijgKAF1Paml1VYptWeyzKDbhbNjs4B+yw/QpgMKCOBQ2d4Vu/GjmMRgAT5acwxx2aB1DMYLBy27aSam6iC2MHVuahf2SKpPg6yteOD/HHtsWHLvds5dLlqNhnFLDbKGy8wuukCoiLrR7w5FpZXvCU2DmENHHYW0hailv1yUu90mvLzl+wBprcDWv7EKkMnHUmu5aP+2gqnfJesUCE86L6Oyhg390uMXIXtozVvZx/KJpVExvpOCU7aBl/GeYEiXm99UfnBVz0zXvFYfKi1ttcgkPKwoOSZ9LJP34VD/5n3gs82TB47ynnT/NOvY1zux+AgCyi9Q5lF0aK6J8EqXO4PxBlZeV7y/OaT/01G6ELLQk4qiQJJ8TaQDT4GD1Q+5zdR+JsRIvJDjT2T97badFyiIWOof6v4wBIp+5aowTKOrnCD0Pm+DHqR21gmkKblwZIrxLNGsuNY6HxSxubYa3jQipdSrTVDANoxL5+gcsRWVtMToj3GFa4mJCPkv0AE6B5Y7yRb3q6tJYjL+TB3TSsfbQZT4yswe0YCnOexTgCJRcaDsFaNplpWWFEXoWelpDcuMyvZ1onZv4dIRGqC0cwgwTTQFALJQlH1dJpk77w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(2616005)(6506007)(6512007)(2906002)(26005)(31696002)(55236004)(107886003)(186003)(86362001)(6666004)(8936002)(38100700002)(83380400001)(5660300002)(8676002)(66476007)(4326008)(66556008)(66946007)(110136005)(508600001)(6636002)(36756003)(6486002)(316002)(966005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG02WCtKdXNodmpwVzJEYXo5dHl6clF0aFBiTGJ4Sm5wK0hreWRTMXUwS1FN?=
 =?utf-8?B?RStwNEhkeEYzbWxrbUZpNm5Ld0xCUXAxZmpIbmJqMXNCVzdOOWNMSW1vbENP?=
 =?utf-8?B?TldacGhjd0ZuR1lNMkhReHNxdWk5aVp1QVlRMVBBMjJ3bUNsZXpYZS9oNCtH?=
 =?utf-8?B?Qkk1aExBYkwyZEpVcU93OWthYVFicGgzV0RxNThrM3ZvdmxoR1gxblJ4SFhr?=
 =?utf-8?B?b0ZHOXlpdG5ZcEQvNkovN2pYNDl3My8vdUswekMvdWtaQi9IZmR6aHB6UnZD?=
 =?utf-8?B?bGhHZEh3cElGY0lESjExVUcrMnZqY054OUd0SzdyZTlvWU1qdzRZWGI3Wjhk?=
 =?utf-8?B?TDdKWUdjSi95YzlyTkpyWFNjL0l3K1JVUHBsZkk0ZGZQMXEzSUdjK2hQSElN?=
 =?utf-8?B?VE5SV1VwQVRxVGFqclFzcTAvYzRPaDFMUWNQUVUwaUpDTjdCbHVDUkFVRmg0?=
 =?utf-8?B?czI1NUg0V1dkaFNKWnpFN1NaZWRERHB0US9IbUZJUE02QzFaMENlRXlSUmZh?=
 =?utf-8?B?Ui9NL0JIVmc1UHQxK1hiMzYrSkdVZEVhL0laanZwRE9oTEx5dFM0T0Rnb0ZR?=
 =?utf-8?B?Tlg5ZysrNzU2MHRBeTdhOE5JK1JybkdaVFpVMmI5SGNGaW1OWlU1RHVObUp6?=
 =?utf-8?B?d1dhZ0NGL3dBNnRBQVVPaTk5WjJGR1JnU2oyZTBwaTZBZ0hKd0tueEdyTVE1?=
 =?utf-8?B?S1pWMVNLY1BwaFJITjVxRWNzb1ZPb0pSOHN5T0JIa3dIRlp3elg5emt3RVBT?=
 =?utf-8?B?Q0FHZDlPTm5YZy9lRUNXQWJvUjhwNi9NQTVJQzdVYThVdGhMNTkzQ1NEOVFk?=
 =?utf-8?B?a0ViSHNhWExYUjhkVUZFYWloNHdmZzc0NUVWeGIrdWMzaHF6MUxzRFJrS3Iy?=
 =?utf-8?B?c3RuQ2NUNVhKSG4yNUw3VFplUVRsSTJmeEZCMGVWL204Q1lRWFFNQm42cjdK?=
 =?utf-8?B?dGErMEVNUC9PMjFSeVlVS3Q1M1NSMnNmckJ5eE5wRThnY3lQZ1N5OVpYZHcr?=
 =?utf-8?B?N3NZUTZra0tMRDRtWHlyYUcvcEEwdWlhWU1SWThwTUZuT2FhUzFtNklzLzZR?=
 =?utf-8?B?ZVdNajVudFFHMTRyOTFoRG9OSEp2MXJSd1BhTE1RQmFMYWYyS1Q3VVRxZVRO?=
 =?utf-8?B?L25keDdTY1VGVU1WNzBVcEJQd2FPNGliS3BGVGFCTmRtakV6RzJPcmNUVzhF?=
 =?utf-8?B?TWNZK014N2FBMCtjd3Y0RWczNEtwSGV2VFN1QzgxZUxLNktPUU9sbmo1bjVQ?=
 =?utf-8?B?WTk4dGdkV3pYVzJkdjV5SnZkaTRVSDdILzJwcU9wN00rUTQ3K2p0aktVb0NV?=
 =?utf-8?B?YTlIbFFQNFVVVzhYZGg3MTU0MkViQXU1SytBU0J0d1pLVUdxUk4xdEZUem5N?=
 =?utf-8?B?MDhSanc5RFdTS1hnVUVSZTdDVnNlT3BIVlBteWVyVTk2bmFSTlJ4aUJlNEJq?=
 =?utf-8?B?ZE54R3Z5ZEo5ZnNjc09Hb3o5dFZTbUphK2huVndyVE1GZWpSOHF3dTl2TUhn?=
 =?utf-8?B?YmxCdkIzaldWc0p2RzlHYWdEM3RKVVA5VmhUWFRjTWdIcG5rLytFaGxCSFN6?=
 =?utf-8?B?VTdwc1BSVVJrcVptOGxwTUhXWVJrSU9tNjFPTXQ4L2tHRjlueGpYZmRPN2sy?=
 =?utf-8?B?SG93dy9hcGx2WURhMHl2S04yTDBVNGxjaXlDVkRXbi9abWpLeVBiRlY5L2hj?=
 =?utf-8?B?ZFRUMEdOSlIxTFFrR3VrekRQQ01VTUFCQjU5ZC9GaXNmQmFsY1VoNUU2Y2xD?=
 =?utf-8?B?WEliRCszWGtTOElzVENOdzFGRmN2V0pwUW1Yc3FjeUJUSFlHTEFvd2pFVGdV?=
 =?utf-8?B?Q2JpZ2hvOWZiL3JUNFcxM3FhemJWOHZ1eWNwUGwweDY3T3hqYzBGRHJjZGdG?=
 =?utf-8?B?TWlBUTAzQ0ZJM29VbmM5VGV0eG8ycWxUTGJoSlg5cE5nRlFhOXpTNXNYRHZQ?=
 =?utf-8?B?ZVlyeDZjb0RkbXR4NXBUb2p5dkRDSnJBeWNEczUxRWNhcFdydUNXZnNvWFJI?=
 =?utf-8?B?YlVIZUo4aFJQeGUrNXpMRGZmcE5INkgxSnVhSUNydTVGUlhxazdjNWxDbk1q?=
 =?utf-8?B?MFpQQUkrT1h1RzVIclloTGhEUEpENWtvYzdZNTN6RkEzVjUxNjA3UXJmWWVR?=
 =?utf-8?B?UVpmTHhTM1B3Z1NwU1NPTTk0Q3VXS2w1dGl3d2tQeDNRNGhMOEtYMTVxeVZx?=
 =?utf-8?B?cFpuRXpTQnZzQksxR1RqZUlCZnVrY1kzajlZWDVWeW1qaVZMSE5pQjN2WUF4?=
 =?utf-8?B?RDQzZnFtb1k2SDAxaWxuMFE3WWNvbGcrak10clBnNkZrazBkMy9tRXpXczFt?=
 =?utf-8?B?MC9abzVpSVhhZnMraUYybFpobVNLamhWWElEekc5UTVnc1h3SGxJRFNOdzcz?=
 =?utf-8?Q?xEyBM/E5PAG9BRXQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7cb086f-6e68-4f81-ce73-08da2e0b9864
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 20:20:56.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXXjWqVX4CUmzQFcCyO/ej9D27pTuvfwNqkfyTrhnZCRbzYl7u2c6rUSzp7QxLrt+8ojXgYOvZXxt2EnaloQ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1890
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 12:31 AM, Jason Gunthorpe wrote:
> The last user of this function is in PCI callbacks that want to convert
> their struct pci_dev to a vfio_device. Instead of searching use the
> vfio_device available trivially through the drvdata.
> 
> When a callback in the device_driver is called, the caller must hold the
> device_lock() on dev. The purpose of the device_lock is to prevent
> remove() from being called (see __device_release_driver), and allow the
> driver to safely interact with its drvdata without races.
> 
> The PCI core correctly follows this and holds the device_lock() when
> calling error_detected (see report_error_detected) and
> sriov_configure (see sriov_numvfs_store).
> 
> Further, since the drvdata holds a positive refcount on the vfio_device
> any access of the drvdata, under the device_lock(), from a driver callback
> needs no further protection or refcounting.
> 
> Thus the remark in the vfio_device_get_from_dev() comment does not apply
> here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> remove callbacks under the device_lock() and cannot race with the
> remaining callers.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

My ack was on previous version where drvdata is set and used in same module.
  https://www.spinics.net/lists/kvm/msg275737.html

Its not a good practice to force vfio_pci_core vendor drivers to set a 
particular structure pointer in drvdata. drvdata set from a driver 
should be used by same driver and other driver should not assume/rely on it.

I still prefer earlier version.

Thanks,
Kirti

