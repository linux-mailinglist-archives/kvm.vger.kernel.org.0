Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74D7569B4
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjGQQ4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 12:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGQQ4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 12:56:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C1410C;
        Mon, 17 Jul 2023 09:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjIItiLwoWZE3t53zzqyDm4YeEHwKMJ0aaaUDibNEE2qXOahzIiYZuytMzSTPN5GPStKuKXswOWmTdY+WVdMceCxR+ea2OwEdNEnSGZoe+0KS7knUDuD/c/17eK7MzEq62Fd3LN7NAEzNKI62PA64MHqwq01RDKRr7U+5qlQYj+gyPTfe+pxB7rx4eLbptqXZ4NHWGkI6cRYx4BYlZcV2WYTfIlp6kjjo2UriGUnZfDHE/ytTn5lbNsT6Ilt2yPaqe4NZ4qi7KEqy1kTXjyX/oPviI5mWwLRg3Yk578RyB07zK/Js2dDaOXI5F/w51Ty/p5PF5BJzyNwEjkZhKQ/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2p0AkZhLKYruRO4d0FUnIkMg9Gku/Tg9qnSh+vX8zUs=;
 b=U7ZzYNm3OdMLF53+A4VLA3ggxo6BLCi2ILvGOrOmSPkOyILET/nhROv4fIDbWIe/KAsgiukLK7sdJ0o06+S3nWNBHP1nSpj1o8vmWczmrdrxcmXIptZM1LS945PG0FczzI60pvM+So17zSzwiU/5FbrW1dBh1H2K8g4PGV5RVIR4FYNhibS0J6fjLzy8mSv14Drb2q7FJu0TBiYQWZpsmsypfYvzjECDW2ys+LgrAsT58Og1Jmvvcodkd79SrONaVMULkwsLjTnMHgYbFEx8BtL+nNFDE7VWcdgXkwtSEeWRoSmn9VViYAJIizejR+aIeDL9DE3PYphoId5ZTb/Dhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2p0AkZhLKYruRO4d0FUnIkMg9Gku/Tg9qnSh+vX8zUs=;
 b=D7wHH6E70GRBQulseb9i/XHWCnxvjsCmRPRzyg0UuYdYFoE1vKUgOJX9ttV9QLw25bo7xTYbOmu9GpPkaEAfWVb+Sr4qgKiabV1y/sbZOzMz9u4tQiG1ar1j5TjVnUlTlQ6koeSFJX7m1lVBObf9Q58Y7xfUcl1xhw9BIdsdw0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 16:56:02 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 16:56:01 +0000
Message-ID: <c8978b1c-2e45-6557-47fd-6f57dda8e433@amd.com>
Date:   Mon, 17 Jul 2023 09:55:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v11 vfio 7/7] vfio/pds: Add Kconfig and documentation
To:     Simon Horman <simon.horman@corigine.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
References: <20230713003727.11226-1-brett.creeley@amd.com>
 <20230713003727.11226-8-brett.creeley@amd.com>
 <ZLJhXRdA2a72Cb5/@corigine.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZLJhXRdA2a72Cb5/@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 8188ff71-c57a-4a65-6110-08db86e6b394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4KtC2pyH8+C8zik2WdwkrZJNs0rHRb2h6BVHno5TPU+b9dEuZ+lRP82Uc43tiL9J+1DxBa/nQIyoXgyCYY1vqmvEuWg6nuNYXiLdt7sYx+IMgnLq8v8dlUsZEZXka7Kuew+JKWVLFyWgNsmcpmfzWsZdKvrGNvEVq2BWrJnIRJ5LflWj7vhWqdRCaVWsFNZ9PDdrk0HjQsGsQf0MfxNpWpxKCnqWcLuu6e6w9TPzoUB2OlD10f8pj5DsWUkz915+X8/QYLVCRNz9bn83/NRWSmvh75AFkHK5JUA3CwzCIg2Fz654nmx2hwVzcrTWXdg1N78T3NBnqvhXanpwQztq5puS0uYkv06GI1kCggOm1VBTdkZfuPv7J7Bqj6GIcrW9AHvcVzMQnp4D+zBQ1Z2ibId9Ol3VpgURazsD1PkOfdTE7UdWueLfAqYOY8ay0DZDLeqAGycgZrKFwsszBUiqh/kCM9JTX/GTOOWkSIebmSp/jTHQMYxBjN2+TdmncNuxImzFkqIXiEzZTmsRoBihsRDVJDMjPDtWDG/Myj7k8Zs2A0NDRu3uagrMCp38SlTE2pwvDnTqqA4Gal5lKErwL6ZUhs+u8ACUv321bfpSvJRiNRfaF3rMw0CiuVVwpYHhcShXwI8kiZYliTvppgGEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199021)(31686004)(31696002)(2906002)(36756003)(6636002)(6512007)(2616005)(186003)(83380400001)(26005)(6506007)(53546011)(38100700002)(6486002)(110136005)(316002)(4326008)(66946007)(66476007)(66556008)(8936002)(478600001)(5660300002)(41300700001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ank5aDYwRUhJOWdsdlFZTkRxODhXZ0dqc01zSUk4cEFpZlhlZWpFL3NkVGVK?=
 =?utf-8?B?T3c0cW40ZkZBQmJGMExEb0E5WUI4MlVnRFdtclc0UkFGM0RqNlJrMXpidWdw?=
 =?utf-8?B?bXFzNGZadW8vcmZoYjMvOWpWUkRvVWRSYnpPVlg1aXpDd2N3NVpTQVZKMjJY?=
 =?utf-8?B?ejBGNE9rYklmdDR5bFlKNi9GdkNvaHdrM3VlOWtWbVBmNEtPeE1FRHUya0t2?=
 =?utf-8?B?cS80cWVnK29udVI3SmlRallZaHFQcmxWYmswZTlDUFoxZXBKcG9CSHRBK0xL?=
 =?utf-8?B?ZUwwM3ZQZjdKaXhvS1lRN0NOZ3loK3cxYS9DbUdDbFU1bVIyVkdYakJreHZm?=
 =?utf-8?B?U1pTN1NoUFVmdS9vU3dSV0drV2NoeTFHTjdYUGFXcE90ZWxTT3A3R1lRd0tC?=
 =?utf-8?B?Nk11allyc2NaTkZQQm43S3lXWVU0RUMzVmdVZDhGblR5cjE4M1BNQ0NkV1RX?=
 =?utf-8?B?ejlOVkJDUDdGWHIxZHIxWVZXYisvbW93NERDKzc2bWl1ODI5SHN2ZWoxYWo4?=
 =?utf-8?B?VkRqNENOR2c3Yy9LYzNPY09uVDFVdDlsZTgrcWhRL0JON2F6QkFYTG5hV2FO?=
 =?utf-8?B?cTZXRzk3WWU2bkdVbWNrc3ExZnluSTYxK1RmWVVUZjJHQklOeHU0MmxzeVZn?=
 =?utf-8?B?ZmlnNzVUYTluL2ptSDhETWlTWmplS0s0TVkzNnFDM1QyRDFTRFVWYlZkVFN3?=
 =?utf-8?B?aEFaQnk3K1hKU1d4SlRhRlFIMzBycStjdXVtK3FsZ1YzYU4rTXk5LzNHY2dl?=
 =?utf-8?B?cCtlblo1eGtGZUJFWnhkcVY2NUduSXh1RXJlSG1xTTNFZGJmUVZmc2pIQ0lx?=
 =?utf-8?B?Z09wZnFheFJVT21EcjFraWdycFByRWZicEt6V2pNRGJhcDg2K25KUGlsYlQr?=
 =?utf-8?B?ck1XQ1E3TGh4cUJKbkdjc05RM0dGRThWK1MxYjNsVjUvL2NzMVNDZkp5T21D?=
 =?utf-8?B?cEZGcGRVK3phZVYrbi9TRXpFTi9qb281UnY3SzludjNjWjYwVStISnRpVWly?=
 =?utf-8?B?ckJhK015eWV2aEdJQnJhb0JwS09HeEFuZzNicFpmL2ZvcFNKcExhQ3JsS0h6?=
 =?utf-8?B?SCtLWVF1bm5PdVhTUTdCRGhSZWRxYmVaODJtSFU1dkVwMlJXTllac2JqSmVX?=
 =?utf-8?B?TTBuZUpkZlczMXlhb1I4b05razNJSWNONDJXeDQwU2V4YkVZbmNsaklqUERk?=
 =?utf-8?B?L2VkQjgrUXZOM1VzMWFRR0JXNHBOb041cytnTTdQa1hpeVY3ZzcrcWxjRHh0?=
 =?utf-8?B?Y3ZGMDJUajdHWmx1TUN4anZsQXU2WW1RZmg1Q3pJRS9iRURJTkxEcUNNT1FR?=
 =?utf-8?B?SWNNckhVWFgxN0N4VVZZMHBqRC85dC8xdGNIK3pGcTJKYk9nOGlqdlhwd1NJ?=
 =?utf-8?B?NzZYUmJ2dDNudEI0Tk45UEp2ZG4wWnhPZi9HZ0VIc2JGRG9GZkFMV3U0K2Ey?=
 =?utf-8?B?RnVGV3h1dmgzK3ZJNFRuZTV2UVpjUkVoK3JQM1cwR2VKc3VqSi9mSEc2TUpH?=
 =?utf-8?B?dW14TGgvQmp2VkhUNTdKUUdmTXh6M3JKSHUvbFBOMFJzUGV4VnhIMGJMR3RR?=
 =?utf-8?B?WWdMQWhGMWFhNDZPbTlMdkxMWHl1aW9qR1hmTW5VbFl2OWZpWEx2TXZOYTU1?=
 =?utf-8?B?bm01STRvSTI0SFd2UFhtdWZCV3Q4T05JelYvanFxMTFOc1BsK0c2WG9QNE90?=
 =?utf-8?B?YTZiZGxEcDlyZ0s0T1NNS0lpRUdvL0NmMzVRMXlIMmtScFE1RkpOTk9qaEJk?=
 =?utf-8?B?VVh5R0tOT2lRTU9POG5DYVh2d1BEODhQQnVUOGJzT0VZY3BWenhwRmhKUjBv?=
 =?utf-8?B?bFhYSVVVTUtQZ2JMVG13Ym5sZlc5OXViWVMreTJMNkRjYk5vaG9xNnhERjZB?=
 =?utf-8?B?YkVLaHNOTVBkYUw0dlpNOWVPeVlxcmFIeFJKS2lrWEo2djNud0NGa0diM0M1?=
 =?utf-8?B?S2Yxb0VJeVJ6NitWVzY0SFV4UnhDWnRpa1hjTXBTOVF4Zm9YTmtyMDJUUUlv?=
 =?utf-8?B?emhUNnRtZGVKV3owV0ZtZFUzdlhINWVyOTlyeTFvbHdpNlcyS3l6b2Mrbi9D?=
 =?utf-8?B?UU40aTJsb2xMdnAzTUtmRXI5SVVyb0RsMWdKcEpmZ0hidnNNYjV0NnVWVGlF?=
 =?utf-8?Q?wcG5oZD0EvLdkIAJ/+Yuh+5HG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8188ff71-c57a-4a65-6110-08db86e6b394
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 16:56:01.8037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nyLndooszJvFqeqgJXFxHPmb5dTatbi+SX/3P0Pqa0LDhv7Bt730kFAXDVg3v6+sU27/hz3JbA/I4AG29klhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/15/2023 2:05 AM, Simon Horman wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Jul 12, 2023 at 05:37:27PM -0700, Brett Creeley wrote:
>> Add Kconfig entries and pds-vfio-pci.rst. Also, add an entry in the
>> MAINTAINERS file for this new driver.
>>
>> It's not clear where documentation for vendor specific VFIO
>> drivers should live, so just re-use the current amd
>> ethernet location.
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> ---
>>   .../ethernet/amd/pds-vfio-pci.rst             | 79 +++++++++++++++++++
>>   .../device_drivers/ethernet/index.rst         |  1 +
>>   MAINTAINERS                                   |  7 ++
>>   drivers/vfio/pci/Kconfig                      |  2 +
>>   drivers/vfio/pci/pds/Kconfig                  | 19 +++++
>>   5 files changed, 108 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
>>   create mode 100644 drivers/vfio/pci/pds/Kconfig
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
>> new file mode 100644
>> index 000000000000..7a6bc848a2b2
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
>> @@ -0,0 +1,79 @@
> 
> ...
> 
>> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
>> index 94ecb67c0885..804e1f7c461c 100644
>> --- a/Documentation/networking/device_drivers/ethernet/index.rst
>> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
>> @@ -16,6 +16,7 @@ Contents:
>>      altera/altera_tse
>>      amd/pds_core
>>      amd/pds_vdpa
>> +   amd/pds_vfio
>>      aquantia/atlantic
>>      chelsio/cxgb
>>      cirrus/cs89x0
> 
> Sorry for not noticing this, but there seems to be a missmatch
> between 'amd/pds_vfio' above, and the name of the file in
> question. Perhaps the file should be renamed pds_vfio.rst?

I will take a look at this. I renamed comments/files based on renaming 
the driver to pds-vfio-pci, but missed this.

Thanks for taking another look. I will get this fixed on v12.

Brett

> 
> 'make htmldocs' reports:
> 
>   .../index.rst:10: WARNING: toctree contains reference to nonexisting document 'device_drivers/ethernet/amd/pds_vfio'
>   .../amd/pds-vfio-pci.rst: WARNING: document isn't included in any toctree
> 
> 
> 
