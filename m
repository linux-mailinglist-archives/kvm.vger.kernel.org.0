Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5FF763F30
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjGZTFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 15:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjGZTFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 15:05:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850BEE7;
        Wed, 26 Jul 2023 12:05:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZthxYFhGtkmDUsCMlfGTdxQBMJmFLfKqwkcj4q3EIITjvZ3IjUzJG71C6zsujD3dGAxqdb/HbZiETLYEnkWGj9C60caR+HVKv+gFzzypttoNJpwN9jTZ8G3bBh2WXo4Z0IvxGt0xIG3nggbk8AUh49hoD6Ilt5kWn5VwImJOGvu9rZu5glvFfQiaNKTkoL7tWSYK1cuahRfeMx5r/hxvjUh2+G7MBVG2mAUZEXirikCln5rXSFFrS8mkCYfacnU1lNvlB+lhuQYuv92GWlv0JwVK0pMygnGZAXfW2964+WbkKckRXnSpFtF2oDliFnnwweeFVAm51AG9E+4PdS4SLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzR+LxNKZwCadXpbFUuDxhN8oHRVyaAEZ4uXSt0WGQA=;
 b=djPKyk95gc1X0BWATmJ6lsT0yiqSDS0ahIzJYi8C57d7bSKMvCZt8DSkO+biwBXPUjjIxC4gOop2adqlier9o/Mm4Wt4JnFmb5AWwQAmB+OffrtGds7AKQoo7nIwarI3E8cjmWbqz11tfpdRcOxF435Y3H6rjr1BT9p6KBXNZFvnXg74L42X0gXlSRiop/oM9yyFmAcUeT9Q8ZFgLwN+Hx2ldGbgLKR42HdqQG/he0woKCrtwlgWpzmHapasMaek7ven0UW6oW796GZNTxpkYOCFONuyPCg8uyH9knKqS2ot+Y6Mi/aTUzOutj7p9n0wy8VnzNzCW7At2hodGD5z4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzR+LxNKZwCadXpbFUuDxhN8oHRVyaAEZ4uXSt0WGQA=;
 b=h8IXeVF9pMSoueX6Xc0uXiM9zTZhkxHUk9gPADvl4GEo/05miOG3TN8oM4lu8cK8+lu+LWv/fjXFpImIXXGaNm0vwLF3XVqH8sqWo66xcWPIIIx1dDKgpsqqHGnRA4KBOlbSv5ha9p9gOvUIYYOvDYGm3zTZxWGSBCpISQswOIw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CY8PR12MB7516.namprd12.prod.outlook.com (2603:10b6:930:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 19:05:16 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 19:05:16 +0000
Message-ID: <95fa9f2d-a529-4d79-167f-eaee1ed0ac4f@amd.com>
Date:   Wed, 26 Jul 2023 12:05:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <ZMEhCrZDNLSrWP/5@nvidia.com>
 <20230726125051.424ed592.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230726125051.424ed592.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::18) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CY8PR12MB7516:EE_
X-MS-Office365-Filtering-Correlation-Id: f357dba7-1639-4b3a-141f-08db8e0b3f42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XwjTKMIfkIEitWF1AJlIAy8MC/A9Q5JN+hakJ/3Qut+iyoXY8xzNAtJrPhUWr9k3fWkJMa67iFdKinRyZfO5ZOCBgLQ59TtzW8xVqfEw8r2x/SzsxQp+Twr69Hxr2kQvXsK/91GdmWwAGieQwX5a4JHGIexeuyZI7/Ax+QBr0IQ7Oe+0SxeBPKlFj0ogm+RFv4qhhyBq+4VCtm4XwrzG+b0lz8smH0OfRAJHJnwvEffI/Lf17696frTMRXRRpkDa7DStVncUh2WlxC1rCkJUqKNBVUTGLmfG8DnBEY6qomjkL5/tNAtr1YgRD7iO3e263UOmN15CcFCxIt3q4dX6HJ5T5g0jZAT2CNnTdp6HQ6/QYSn3UdJDGVXT62OHb7l3Tp6CNxmKgteW2nh4A6zS2pBJedifihUlZE8ZRDf3MmODNOAVlf2Ym4HZ26QD2IRxZSci6x/LpEifOjcM7jQnMOEjUqb3EXPkmhjAzMIF+AJszf9vSPC4IsPJcCeq33DfNfsfOVVOm/UiJ1TEOOywfOueoqhl6g+k2WZtGQzugETDYlZmXsdvjhCV/DDWcYCtnJU44ZKK+lHyrsNSUsuNbvgIWJSmPzU2CJcgR9jlxGwj/V4jUTWe5QUOMjXQZrIp64TEHYw5dKbTnVnmRko+nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199021)(6666004)(6486002)(478600001)(83380400001)(6506007)(53546011)(26005)(6512007)(38100700002)(110136005)(4326008)(186003)(66946007)(66556008)(66476007)(31686004)(2616005)(5660300002)(8676002)(8936002)(2906002)(41300700001)(316002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWVkekppandiMVY0bFRtSkdmdFN5NFU0bmJWa3RnZFVBVEd3YVJUNEVHODZT?=
 =?utf-8?B?NGVKQit2RE5lVDVkVTlOM2tFSFhacUZzVTFQbkIyT2RLa3d6M1dzUTNFcE5p?=
 =?utf-8?B?RnROY2t5OTNvZ1FyR2V1bmNDcWk0WUgzTW1XbU5hOXNrQ0k1cDJRRHRxR284?=
 =?utf-8?B?dDZ4UlZMOWg4SnYwdGUwOENUNCtlMUpTN2p5Ym92c2VXNzVDTjZqQmNKUHl2?=
 =?utf-8?B?OFJpK3JhRDNUbVVVYmNub3lEc1E5ZXE5MzdkZnU4amx6b21IUFIxSEorVEtF?=
 =?utf-8?B?TTdlbEZjOFpYaWRKVUYrZ1hjYVdtTEhUdlE4RzloOTNXUlNFMDBnd1hvTWVY?=
 =?utf-8?B?am91bmJmOU1QRDRFdG1WelB1OWZKT01Zc2luK01FVWJ5SFM1am5HbnBobmtL?=
 =?utf-8?B?WnFVRGg0amw5c1VvQ1Z5VDhocHgxQXc3b2oxRE5Zd0FWMzdNQURFd281ZEpH?=
 =?utf-8?B?UXNBMDUzUDVTMmlJTWRHeFhLOEg0c1hwR3FQY3VCZjFQSlZlSEQwQXdzNk9R?=
 =?utf-8?B?K2dMM1o2V1NkT05NQVZmcmxZT3lLNnlkajNNNW5QNVhUQ3RDbk51UTBDRHdD?=
 =?utf-8?B?aldtcXRiR2szVnhjWmRpVnZ0L2FoMVNnL1VrZy8zb1RZVEFWZnpJWEpjcXhM?=
 =?utf-8?B?Rk52QVNDSlN1dHAxcEJZcEJnWmpxU1gzQnZvYmgwZytiamtDakZycHJINVBl?=
 =?utf-8?B?bjVYekFrRURuQk1CNS8xY1VPangxbW0wcEdUQ2QxMFhGL3hKNStyWmlVNGFi?=
 =?utf-8?B?NHNBd2c5dlRmM1VEYmJWbE5LSjhJa0I2WmJUY2JtODJyOWZNOTlWUU5OS3Zj?=
 =?utf-8?B?cm5CL0FaWXhsQ1kvSURvQ1YveXZLU2NkUTd6NHlSaEZQMEpZY2cxMzAycTRD?=
 =?utf-8?B?YTVrNmk5cGxvS1dOd2I2RkZPWHZaQ1BFNmxqaDZqMUNjVmp5aDU1aEZ4dTBY?=
 =?utf-8?B?R0pRRzk5bDdPVzhKR1J1Y0dPbDNrU1JJemJTR1JtVVMvZmNGT0JCTVRSbEdG?=
 =?utf-8?B?Z0RLTGFibVJQZHJwM3o1Sm1yRGs1NDE5VnVrUEZnZGdmbWNwTTZyZ2RYSzNZ?=
 =?utf-8?B?LzhSRmI5MTVBL0FENkJqRXFoK1VzMFdkdi9XR093bnBtVytmNS9KMkZ5MkZM?=
 =?utf-8?B?RTlRN1N5RStxTXg4SXY4V0VkY1BmM2RoOHVZRnBmeHkxN1lkTUlIUUZ1QTZk?=
 =?utf-8?B?U3gwMjJUTmluY01mMVROZWJrMDBwWGdzbmdKTHdNVTdiZTlkdUs3d21XQXpv?=
 =?utf-8?B?Zk92MlRNbi9zY2lOa0RBaWovUE1IYTIvRVEvZnlOK0tzZllXeFlCYTZoRGE4?=
 =?utf-8?B?YmFsT1RaNmtjMnNpK0svOGNvY2FSZFY2OXhZQXNySHl5QnZHZ3g4WjJsMWE0?=
 =?utf-8?B?Yk5xaEpGaTJVN3dCL2JOdkdOazh1MVNrYm9jbGo0eE5WR3lMY0NVRnhKbUU0?=
 =?utf-8?B?Q052UTIwY2VBR2VVZmkrSmVQVXJWM0c4a2d5bUNJOTRBaG1oR3FyN2Y3MzFR?=
 =?utf-8?B?cG05WkpVRCtlaDNkd29wQkpCR3ppWElWWGl2WHMwMFlZeHV0Q0lZcFNkR1dI?=
 =?utf-8?B?aXViY2lXU3R1UEdKNDYvQXRiQnB5VFZRbTgyNW1kdHFHVHJ4bE9QaG5jTTkx?=
 =?utf-8?B?OTVpWHd4UDdIR2JYQ0JWTmROV3B4Z01BZUdOTXpRVDRGNDNGUGRXMTdVckZi?=
 =?utf-8?B?UFFVdy9uc01zdU50dkVGblorNVlIdlYvUjRCSHhnY2VNdm9ub2lhU0dTQ2pM?=
 =?utf-8?B?cWIva0RsN2kxS2JmazZOcFExZDVZcFYwNnRqSnBIT2lXc3dzQXIwZmR6Nk91?=
 =?utf-8?B?ZUVSUlBYeFRydERGeGtxUTN0Qzc0VkZ5Z1E1RERhSXdjUkNxTGpYanhNVHdW?=
 =?utf-8?B?WjlZNlpRcXR3c3A1UlpUcURzK3RXWGJKWi9XaVF0aWpmTnJrWnJ5KzNUeUFB?=
 =?utf-8?B?TUhEWHpjYmM5M0VtRmVRRi9zWENkMVZLRHBQdTdWRVRmNHdPaERORktsL2NU?=
 =?utf-8?B?d2h3UEp3KzdseGhCOXBlTFRFZVdPaFhtRG5LMVVwRllvamxOMnMzYUhKVisx?=
 =?utf-8?B?dDhVWmhtbTY2KzZ5VmJFMWg1c3haa24wYVlGbG5rTUZtcFlxUmNLKzA1OU1k?=
 =?utf-8?Q?gpqoznuTgY8pDFVAIQ0Hw0tGS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f357dba7-1639-4b3a-141f-08db8e0b3f42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 19:05:16.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9/zC5mHuoAI3Da/kRpJAq+edbIlUaIIgbG5zlhb45fALsPCWKNmdSZC6EC7L97tv+dyNl4gYchpQ728c83GKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7516
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/2023 11:50 AM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, 26 Jul 2023 10:35:06 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Jul 25, 2023 at 02:40:18PM -0700, Brett Creeley wrote:
>>
>>> Note: This series is based on the latest linux-next tree. I did not base
>>> it on the Alex Williamson's vfio/next because it has not yet pulled in
>>> the latest changes which include the pds_vdpa driver. The pds_vdpa
>>> driver has conflicts with the pds-vfio-pci driver that needed to be
>>> resolved, which is why this series is based on the latest linux-next
>>> tree.
>>
>> This is not the right way to handle this, Alex cannot apply a series
>> against linux-next.
>>
>> If you can't make a shared branch and the conflicts are too
>> significant to forward to Linus then you have to wait for the next
>> cycle.
> 
> Brett, can you elaborate on what's missing from my next branch vs
> linux-next?
> 
> AFAICT the pds_vdpa driver went into mainline via a8d70602b186 ("Merge
> tag 'for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost") during the
> v6.5 merge window and I'm not spotting anything in linux-next obviously
> relevant to pds-vfio-pci since then.
> 
> There's a debugfs fix on the list, but that's sufficiently trivial to
> fixup on merge if necessary.  This series also applies cleanly vs my
> current next branch.  Was the issue simply that I hadn't updated my
> next branch (done yesterday) since the v6.5 merge window?  You can
> always send patches vs mainline.  Thanks,

Yeah, this was exactly it. Your vfio/next branch didn't have the 
pds_vdpa series in it yet, which also included some changes to the 
header files used by the pds-vfio-pci series, which is where the 
conflicts are.

Should I rebase my series on your vfio/next branch and resend?

Thanks,

Brett

> 
> Alex
> 
