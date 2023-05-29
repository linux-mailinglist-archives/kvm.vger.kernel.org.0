Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3FF714609
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 10:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjE2IH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 04:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjE2IHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 04:07:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B499AF5;
        Mon, 29 May 2023 01:07:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZt2VseziN9gpI7cmNiXcLiWT/fwLayvuhOj7UJ+27L/KNvmES8dfgSvJP7Xh12qrEFEDETf3yB0zzTJ46Hxeze8ryc8j50H1KhwcXmCmeCwVTf/HI6ls1rGNURXlkRMk7VVxjzS18ruIfSTk8S00aAnIprYqrlI4FG1yIw4XoMuGzhz1wfTzeG5FB5Hp7Wa0U5sptPMOMzUT3cbeaf596g4RqkGE4Bvms6V83zfEHhtiXdFQx7ddI1DH+fynNmLRUTH10xLzLBcN9oDejy3+Ib/uPmTS3icHWrExHZaQ3RSZLSaM3HtTYl3N7ZGTGrTrCUBkMs1MEryvQ3h25/VOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtaSRgdEMB6Z0xl2JA0XToTjrGybNczPhHrXGdMgXj4=;
 b=b4/yUSHPcKOEnI/5z1dTVL7ZqgrJ0WakO5l8icIxd3/SrsHd5YBFRW7A1meI1dMy9eNFjzPlXeRb6fodKnojMRS1iV7swXKqdwxpw2VuTti/zbnqKvvofC7Mql0dlzQZGo6ABDaLWWjZ5H9tG5gZGi62+BHQZQk2fVor02bmRBX6/rk37YHnyWRJEGpUZb2rRa/GM3J285J+iAFC1B7f7cKKvjTrq58sitatz+VkYhdrBQpEONOQ9z68iIjkBPh2su1r99nkz49nG8HxCdTFX/QoGEfIeIUPXCCDLaSITLKDKtubWvrLhgnvazGq+aE+GXM0wdwHZAMCbbq7plxj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtaSRgdEMB6Z0xl2JA0XToTjrGybNczPhHrXGdMgXj4=;
 b=4ZzgypDiy4mR09QvwYLMTzD32qKgIsUmItx6eAc7A4vBGwHoQJItGh4vRKOKhlR2TcN2BhvZudwjrh7TkxYo0MoWS/M7f49Q9l00IiUQJq2qwAdJcY9Zw4eZ3Fpr9q7slUA8GoZQiCeZiBPj4q1XQ7Gano2Fy7OIeppJUR3QGRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8)
 by SJ2PR12MB9192.namprd12.prod.outlook.com (2603:10b6:a03:55d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 08:07:42 +0000
Received: from CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c]) by CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 08:07:42 +0000
Message-ID: <1bf0323b-1191-de11-061e-00227e09dc35@amd.com>
Date:   Mon, 29 May 2023 13:36:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6] vfio/cdx: add support for CDX bus
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     jgg@ziepe.ca, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        nicolas@fjasle.eu, git@amd.com, harpreet.anand@amd.com,
        pieter.jansen-van-vuuren@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com
References: <20230517095718.16117-1-nipun.gupta@amd.com>
 <20230524104529.28708ae8.alex.williamson@redhat.com>
 <20230524134831.28dc97e2.alex.williamson@redhat.com>
From:   Nipun Gupta <nipun.gupta@amd.com>
In-Reply-To: <20230524134831.28dc97e2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To CH3PR12MB8308.namprd12.prod.outlook.com
 (2603:10b6:610:131::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8308:EE_|SJ2PR12MB9192:EE_
X-MS-Office365-Filtering-Correlation-Id: 232d117e-2ad6-41e8-19f8-08db601bc625
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgkF64vuyeBXfCTfJasz9GZXYvYw7p+Fe9YgsmBKVjYzMucF7oDT9LMB3eR4cE1l6PioY7WxD1FWBKg9XDv3rrOVC1kcXWEEqFmKFTPLvsr3lUEqA0F3EpDJYwlbJ1AG5PKZiI7iDaEgzHQqPXbB7dPz7ZonYVQecoPPbOJWEWsHMmWuCGY3/11ZAcN4bPxU455/3QEYfIl6JaQ/eGtN8h/HAhEqgVZO2HxSOMg0TbaakNJq8HBeDNA5jzJy+n8biNrGKex16uwOcbELRzlrf2ofPDBLVIwIE/Wv52Lq4l/fOxziYoBMGnmB5BihhnqgNyl8hh1B7uxwwypSoIsoFaFmI9hoHWiAdOiVMPgHvTjgfUAJa51bFzUHBeZGmSt9XFCBk4fUswb6iSELCFgVaBPnYGGDe7mChv1jxCs+yuxP3JHvnD0WTaPq286PT+ptGIvkQZtRutVtaCrtwpPTdN7NHo3blmlmA2+e7ExqSm5kq2XyxYYeFcL13kCH8zj0tQSFAwAwAXOjOWgNjhXZ6Kiq5QjO/KY7yMxp0V5vfoJs5OcHhoxzUad6mW3oHJAafppT+reaJgJfC5LJDA93tTnaFggtZ7sZ1pHVkwNCO82GMEuACuGDFu+rq9LavzTbyGuPm4MJTL7Mu/YskVZ/ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8308.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(26005)(6486002)(53546011)(6512007)(6506007)(2906002)(6666004)(316002)(186003)(5660300002)(44832011)(41300700001)(36756003)(8676002)(8936002)(478600001)(38100700002)(31686004)(4326008)(6916009)(31696002)(86362001)(2616005)(66946007)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHdQc0FsTHZMS0c2OEZJTGVvaUxneXVZWFRrK2htSXJWSmJVc2xUQUNtejVV?=
 =?utf-8?B?VVdzMWt5eVBvS0M0ZG40YWJCcm1IVGZubXJqYWVYTmpQeWJqeHI2QUd3bUFh?=
 =?utf-8?B?aGJsT0xlMjZRcTRyT3BzWXhGUFhXQnN1ZUo5dmlhc0gxUVA3YWl1dW5GNTBM?=
 =?utf-8?B?V0dsaTRWdXZLd2x1emNBN3NwNlNXdHRrd3pSMjVTODFUTDdCUDF4S3NSZlg1?=
 =?utf-8?B?VTlRRXdLclc2WVQ5MTFQMCtmOG5aeXJMWHp5RUVmVDQzOFZ6SWpSTEdCOVor?=
 =?utf-8?B?RGFzSmNUeHBMZHUyR3V5MndpaHl4eEFPUU9HdGNDNmJrbURNUkIxWGFSSEt1?=
 =?utf-8?B?YzhEbytvazAycnpDTzBoRHVBYnFod1RnUzJpVlpUNHd0R2J4MEVKbDk1UzJZ?=
 =?utf-8?B?M1VpZ01FeE9WQjBqc1VsaWgrTXZocGMvZUt2cWxIV2swUW5HaXdiQmF1QjhU?=
 =?utf-8?B?TE4ralI5QmV3T2J1dkVaeFRTUU1lMER4MUJxUDF6all1OE5JRmtBTXlFV1Ri?=
 =?utf-8?B?NGlTSDdJSjBiY3FmNGN2NGcxTEJuejNTbFZrQTR5bTJnVWlMSzkyc01ZZVp6?=
 =?utf-8?B?QzhscEZrRmhXM3BhWXhEVDI5SE8zZ0xEK2tFMmpXWjVKRXFWS0I5RXN4VEtN?=
 =?utf-8?B?VGRFNTFycGlvVmVpUGVrMEdLN25jQUlrcEgzRHBzdVphbUFJSWkrV1hweTVX?=
 =?utf-8?B?TUl1eHA4MXEvWmZ6cEV2OWRlM2w2NjhOOTg2Mmgydmw2VmJxRkNiK245QkJ4?=
 =?utf-8?B?Z1NoN1FKNE9Ub1dGd2QwVVd2NzRFSTU5dVJRTVpSL1dzY3R2YzYwWjRZWldK?=
 =?utf-8?B?a053bUU3TjZwZmNOWXRRRXNidUZSenJqK0pHS0pWa3daSFpkYTB6Ny95cGpK?=
 =?utf-8?B?ZnRLZ2pPQktKOWdVM253U21pcGIrYi9la1VCcmEwa3RuVUE1TDlnb3pyYktL?=
 =?utf-8?B?Smtlczc3eDJvajNjQS94SzltWkdpS2ZCWHdwZ01lZkx0YzV0U1FRS3Rsa1Zs?=
 =?utf-8?B?VUcxc083REN2TVFJQ1JpV0NDbzlmenByNFR6R3MvKzdNL1g4ejk1TDM3cnZp?=
 =?utf-8?B?ZTB1TU83eHZPTXB4d1FsK0YvcXp3MDFiRCtVQjBpcXdXYUgyV1NjZi9MdzA0?=
 =?utf-8?B?YUVNa3d6N2pjWmVXdVRpWDViV21jcXRSVmdLTEVGV2RGdmI1bUhUY2JvMGtP?=
 =?utf-8?B?LzNYL2sxdlVrWEpXd2RlU0xjbTF3R1BRMnZDeTFpYTlQdG9MKyt2Ylg2SEJh?=
 =?utf-8?B?aSt0WXhqQ1Q0MVI1Nm5WK1RsYW5FNVczWnI1Wk1oNXZ5Nmd6YW02TWxxVmVr?=
 =?utf-8?B?NUwrVGJLZDQ0ZkxxTkZwUnlsL0h2bE11RVNVZlZoZDMyU3duNEFiNU14VERS?=
 =?utf-8?B?Q09lQXlZSnQ0OFY4dG12RTcrS0RPcHdJUmRlSUxrbXhvSTVsbVhwaWZHNS80?=
 =?utf-8?B?U0xoWEVabVBXQ1ZWN1RHamZNbUN2YWdzUW0xVUtJcDdMYnVnR2U2VXJVY1FL?=
 =?utf-8?B?ZGd4cDNWOEhjMWRrbytIZXZxUyszUm5zZ2xpM0JiTTJOSmxBSGE1TGRuUTVs?=
 =?utf-8?B?SDZBZDBOWDNLTXNLc2xSSm9ZQzNoS2xCN2pYdFE4VmdNNklUOHlYOFlWS3ZC?=
 =?utf-8?B?MTJBNC9QTGcyc3NsU0EwMkRPaENhYXMzTXFkMVpQOHQxLy9aU0JSeWFHQTU0?=
 =?utf-8?B?cWdMSEZJRWwwSjh6bnBaQjIxelFUd05RVldwTnRaZURqVFpHZW85c29BVTNk?=
 =?utf-8?B?NjE5T0Y1WTlQM2FxYW1nV0huQU9sRHRHVXF5YWw3R21qOHorKzhQM2Q2QjJ5?=
 =?utf-8?B?a043N3A1WnNwaWZUS1RWeFZNaWZTbnI0NUFCci9DK2xxVEN6ODU4NUhNVlpH?=
 =?utf-8?B?WlFNbjFmNzNGcGh0YmNXSmZEUEZ4NDNabmNvSStxRGVQYmpxSlhRT3JleDBC?=
 =?utf-8?B?QTdjVzIwSktPejZiS29RSjQvOEVxd3lwVmZpQ1h5VWlES0ExRHg1TFJoMGtq?=
 =?utf-8?B?MzQwV0xyMVBPQnAraTJOOG5IS3hreEFOcTVoNHFobkt4UjV5R01rUkNnMzBo?=
 =?utf-8?B?Y3RnUDZINUdRRklweThlVDlVdHZib2dqa1R5K291VzdxbW5LT2w1QU1SYTg1?=
 =?utf-8?Q?GHu+BBoxMBvLgg4qMiVW05SqW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232d117e-2ad6-41e8-19f8-08db601bc625
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8308.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 08:07:41.2873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnrJsOuPAJ9DYdog7bxPosW3W/qZWjGWFqLHauOBT1nRPAUL5z7hvWMbmKsQgctU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9192
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2023 1:18 AM, Alex Williamson wrote:
> 
> On Wed, 24 May 2023 10:45:29 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Wed, 17 May 2023 15:27:18 +0530
>> Nipun Gupta <nipun.gupta@amd.com> wrote:
>>

<snip>

>>> +
>>> +MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
>>> +
>>> +static struct cdx_driver vfio_cdx_driver = {
>>> +   .probe          = vfio_cdx_probe,
>>> +   .remove         = vfio_cdx_remove,
>>> +   .match_id_table = vfio_cdx_table,
>>> +   .driver = {
>>> +           .name   = "vfio-cdx",
>>> +           .owner  = THIS_MODULE,
>>> +   },
>>> +   .driver_managed_dma = true,
> 
> Hmm, looks like cdx bus is broken here, there's no actual
> implementation of a dma_configure callback and no setup of the IOMMU
> default domain for theoretical cdx drivers that might want to use the
> DMA API.  Without that, this driver_manged_dma flag doesn't provide any
> guarantees to a vfio driver that we have exclusive ownership of the
> group.  Please fix, this flag needs to actually have some meaning on
> cdx.  Thanks,
> 
> Alex

Agree, this change was missed on CDX bus and we are working on fixing 
this. Shall I send this fix as a commit with this patch?

Thanks,
Nipun
