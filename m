Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAE177C3A3
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbjHNWwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjHNWwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:52:04 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F1911D;
        Mon, 14 Aug 2023 15:52:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nednKRBRkaJmNHBL0VItqwCDXJ3Uebym8sSULMHv7QcsCootzB4ouccWMmZxuh4OzwB08k3LsKT64v7mQDMxlCVS+Qt6VuR9Ztr4EGrgY6CGUaPLwl6i3SqEriFs1WnOYoHyOWWzm9soi/5s+VtNY6zUr9YGIJUENKQ6muMp+yiy98u2ra+u9+M0Ldm71qHwH3uCGfJ6z8QOwNU0gEezPY91UiSLt9nAXOytNhZAd4eQQgjS+sHwU87F1a6B35CgpMqhyNeOno0WlDFNzJSx3Oe9i5BFtK3SbaIwdxsjwiD+pSnPj+432HNgNlduQfET3qWFx1Fh5D799PhAHTY9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ac5yvHfSmL2Lghlc8eanSbEyA12KUyIbFO6u0Sn3R60=;
 b=Osm7Zuh0znbPVY2gGsEx0maPhP/twub2ogw620/qyRb+Wc5nJ6rkJtNQt3pq03Z6RaATh+ja/Gio3QSZrOGR97T6XS2e4Npm3oMjDdYLcBPzXE7ILI4n67G/JcXKQc4t9KBqNSeBwX0og8nCDcmlg4jdi9BXmRK3X0LJ+rpGV4Mds9YuHlxSf/UhjKuGXHyirAB+AWV6Q4wBuq1HSsc1qOJ6EzyGQD3GiJ19GFJMtYT3AitrSV125tIlAixAztm5j5ohNY+LGNdrTbTTxxhpF6P/T6o4jQn2IMbpq2EDVWZavxXoRJA89ADwaXJyyuar2xEBvMEf9jQSAZq3CCUVmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ac5yvHfSmL2Lghlc8eanSbEyA12KUyIbFO6u0Sn3R60=;
 b=4NAjdEawFYpqlSGk4tE2P0HX5OoqqaB6yq6zDTfQxifs1bop94/C6iQUxCYLt50dN570MOp0JmuIppSovIR3cJgrpPJobCYULoP0mgXieQhXevrPK9Uf6UFsW8pAbl2EA/vCGj6n90mvC0Ocnt/3TnjCY+4ik3mlvvwNBdFEHQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Mon, 14 Aug
 2023 22:51:58 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 22:51:58 +0000
Message-ID: <b1fef809-b3de-433d-c21c-836612a4d9ba@amd.com>
Date:   Mon, 14 Aug 2023 15:51:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com> <20230812104951.GC11480@lst.de>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230812104951.GC11480@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:a03:505::11) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW3PR12MB4379:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af5b073-a7d3-4eec-6fde-08db9d1910ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0bzblrl7MRjy9SLBphF6FFTag7hvxUs/pc9IAW3R1APRR7bwUrG76LHY6/CQlIrzD3Vdr+ax6k6TWjHFFde81CEzdEHOJUFxC9fTmDGh+9DWfY4faUIcy6UihstrQpzQ7EiiCHekNNr74U3oC3QBEXWRgRmbcuRi8D+W8BkBg7l1d1rHVzLx0arwjRB1uaCQpRCMRjVKWBVxzfY1e2QbweC8/B4wQCtfpZBPmzYQLQn+2+IzGYIK84b3mjSO7mNm1qzq5jKBoCiToWwIrNZQYNpTOX3L6PNDELq1ElvEzdhzIwnyNlQcs6XNfJuKEi6W4o/CHsrY/cDYTWhk3KUV2f5N+MkqgO/Tyxk+ApUf18FTsJcKgIBhQn6jigGB15GrHT/HGKaEPTYHavCIT4uJzYRq8nYtPMa8OFudbEXiAx0hYXv3tf8uclT9h4rz+q0At7QebmVSfiSMNRRa0suB+AZ4eHcr2ZWU/al+gkvC+31V44Pdc3vbI5J0gN9epGJDzqWduVCjQRHU+LLuGIbzC5VQWTnKOEapbJIVM76kd+ZXQqx2ixBNzae6M/oaZfumwDUocBtCOyfj/VZyRuD5c9WYSuLqZYkrOvEOK74B3v0q4taALfEcfyvjqkWIfqbbntVoV1h8K84SqjDKFYqN++MoxnjxmCDdvROXjo2oeNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(1800799006)(186006)(38100700002)(54906003)(110136005)(6486002)(478600001)(2906002)(5660300002)(36756003)(31696002)(4326008)(66476007)(66556008)(66946007)(41300700001)(8936002)(8676002)(316002)(53546011)(6506007)(26005)(83380400001)(31686004)(2616005)(6512007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGNmV2RpRzhjdXFlV01XUEJ4Y2tJZi85eEQ2bjJQZElMQ3RhcnpBd2pkM0px?=
 =?utf-8?B?dS9UQjh5K2t3YnFRZ3FId1hzaHJaZXBCeTlNOTV5SmxIalp5b0V6ek5XaHpD?=
 =?utf-8?B?OUJ1VHd0T3RrazJTS1RoWEN1UTRWUk43cENpR1gyR2RwTzhLdTJ4MnRtR3pp?=
 =?utf-8?B?M0lyK1N6ZFdTcWpqaEFqSk5QWlo3ZDVoa2VuWUdXVnl4WFlva0NXb3NlaDRa?=
 =?utf-8?B?cWNBeHFKVXFtT3ZVVGllNit5RFdIUFBKbTVQRHpwcGhkNnpldlh5N016R3NL?=
 =?utf-8?B?YXBLVE4vaXYxS2phNkhPb1hEcjBvRVV4OG43K1IrUy93L25Ec3M3aHpLUzlI?=
 =?utf-8?B?Q0owRy8vSmxUeXJ1NTFJemRRdENuNHE0b2hOQ2VhMUpNVFJ6MmdsaGZTR1lx?=
 =?utf-8?B?d2JvSFpvbm4vTWQvOTR2V21NUDRIUHF5MGdodS9XdHd0bndKdkJNeC9Jakoy?=
 =?utf-8?B?Si9IMjVpNmpFUDFkSEk4M3JnWmc2U3N6V1hhZkNKekt3WE1RanBmQUxIQWc3?=
 =?utf-8?B?L0daTEFVU0luNFNPWVdJSkhMRVFDTm1EZlZ3ekdTR090d0I0aUZha3BFV2xV?=
 =?utf-8?B?WVRxVThIZDhGNitiTkJvTUpVaDB6SFUrbGtmZEJodGlqRFhhSkJxeGhmQzhE?=
 =?utf-8?B?ZFpJMGVBQTA5YkpQV3ZLRlNBS3ZqU2s2ek5hZjVhNmlub1NPQStjeVZhZ1Zj?=
 =?utf-8?B?K3Q5aXp3T2k2eFpCZWpWak9RYjV1ME9la0FhNkRkcG9GeUVHQUxrbVhQRmFD?=
 =?utf-8?B?TTMrV0dtU2Fha2N0QnE1a1dORWc2Q2ZudVBhWUZmdGtGZVRqTUhMd2wwSU5h?=
 =?utf-8?B?ZlpVa0tHWUw4S25qQXpPclZ6TEVKNTJSaytVOFZTeE5UM2diOG0wRHJQTHNF?=
 =?utf-8?B?SytKSEs0UHRmZFpiTGMwcmxaUXpuS3J3QWNhUVpWaGduN2lmdUIrUTNQVXRk?=
 =?utf-8?B?TloveVNabUZRN01mM1VhTjc2SlZjaDRCajFGTHdwMm00QXBsbS9IQm9LV0RI?=
 =?utf-8?B?ODdqRU16TU5JYnR5eGg0di9jNTdLWHI4T1p6cU1jazhyRGF5ZVpvU0FrR0hm?=
 =?utf-8?B?UisrRW01dS9mTmZNT3R5dTVsOGY4U3hKbitrMUhRMDN4REIyN0VIejQ1OW11?=
 =?utf-8?B?cEVpcFJFenhBYUdQSE5FU0x6S0J3MlZaK2twcThHRyt1STBiYjRYZk0wcC8x?=
 =?utf-8?B?MEw0bEl0ajQrdkRZamtTTnhJQTlyWlhlSDhXS0ZWalcvNEFlVzRBdERRL1Vv?=
 =?utf-8?B?aHBQbTJDYWhJWTA3TElVS2g0bzFYdEF6amgrOFI5Qzl0K0M0Nm5aWTZOSHdw?=
 =?utf-8?B?MitXajM4bER6VWE4cCtSNFRNc1FIbjZWVGN5a3V0QzZtc2t2NWdyVndIcEVL?=
 =?utf-8?B?YTJVL090SndnNFVIRFp2V2haVHNsUTB2T0hOWFhlM3FlQy9nRzZlZVhCdnhJ?=
 =?utf-8?B?bnExclhWNENSeGRHNG1KQ0pEWk5jMlRoM1VPQ2QzK1ltMHhDRnBLZjJHemtw?=
 =?utf-8?B?V2txeHNXUmtkcU5HTC8xc01tUis2Y3FTVVBVQUFSNkpJOVFuOUNhRkplRXpk?=
 =?utf-8?B?OFlqcHdOS3JKUlZyaVc0NGxwbndXWU9WWWYxVjFPRTRzQW1FYjZNSmFlblpN?=
 =?utf-8?B?UVFYVEg2K0hGNmVnbHZSUjNEODJYb2RMZXRyZWVkaEppYUs5MlF5aGJ2aERK?=
 =?utf-8?B?WlpiRDkraHY5QXI3T0l5T1h5SXp0ZkpNTWluOFQzYjJWUFhJL1BpNDFqMlJO?=
 =?utf-8?B?MG9DbGtBT1hIdERWTVIyWlBuazlyV05CV2pjS3VMWkVzNFdveGNIVWlpMEJ0?=
 =?utf-8?B?TU1WUkxPbFg0Y0lsNnV5ZW1PRXhoV3VmbGUvTDFhVG9kdGZYTGhvUUpjcjdB?=
 =?utf-8?B?bjhhSXJyNXM3cE5HUSs2VUpNTVZMSWcvYjdqK0s3enhKak9zekZHOERnZGZC?=
 =?utf-8?B?c3pFOS9SQnYwZHh3OGUvcG1abVBZVW81dTQ3RzN0YlJJdXBqVXFVTnRKZWRX?=
 =?utf-8?B?SFZPQ1pSbXBqV3hPOUZHRVAwWmZJbHpGYVlaVWRsV3lER1NUUjNYa2dZSVdZ?=
 =?utf-8?B?enpMV1hxRUgxRXVudjM3a0ZnSmtuUHAyczBIVmd6bjlWVXl2c0lZNnRrZkdq?=
 =?utf-8?Q?4b6xWCT2FlalzhKFJIc8s7cXL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af5b073-a7d3-4eec-6fde-08db9d1910ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 22:51:58.6372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDI4eGp9njwWoSsRJmWerJao7vB0pzWceIXuIDZTGap4HaNpmKHswhf2Rd1YlCigzj0QPD03QR70IT3Os0xtow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4379
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/2023 3:49 AM, Christoph Hellwig wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Thu, Aug 10, 2023 at 02:19:40PM -0300, Jason Gunthorpe wrote:
>>> It's somewhat a strange requirement since we have no expectation of
>>> compatibility between vendors for any other device type, but how far
>>> are we going to take it?  Is it enough that the device table here only
>>> includes the Ethernet VF ID or do we want to actively prevent what
>>> might be a trivial enabling of migration for another device type
>>> because we envision it happening through an industry standard that
>>> currently doesn't exist?  Sorry if I'm not familiar with the dynamics
>>> of the NVMe working group or previous agreements.  Thanks,
>>
>> I don't really have a solid answer. Christoph and others in the NVMe
>> space are very firm that NVMe related things must go through
>> standards, I think that is their right.
> 
> Yes, anything that uses a class code needs a standardized way of
> being managed.  That is very different from say mlx5 which is obviously
> controlled by Mellanox.
> 
> So I don't think any vfio driver except for the plain passthrough ones
> should bind anything but very specific PCI IDs.
> 
> And AMD really needs to join the NVMe working group where the passthrough
> work is happening right now.  If you need help finding the right persons
> at AMD to work with NVMe send me a mail offline, I can point you to them.
> 

Hi Christoph,

We have folks at AMD participating in NVMe working groups and are aware 
of TPARs related to NVMe live migration. We’re checking to be sure they 
are up to speed on the discussions and will reach out to you if they 
need help getting further involved.

As I mentioned in another response, I've been out for a few days so 
apologies for the delayed response.

Thanks for your help,

Brett
