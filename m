Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6951A1F5
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 16:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351058AbiEDOQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 10:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351153AbiEDOQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 10:16:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB82427C5
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 07:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aM8n/tI3Uv+aA351awZbsfyA61431aEbqxleHUipWDsxMw0CIGTW2otMQS8nDf6ahE/WJU8RRGhg6v6QmTQzF+9NVhWsVIYlUME4ECTiqwZqLhg/hkyxp4jPWrUyjdQAy2dpBQOu4sdw8D+MRYKpCWyzZW/TeMJUB3T/pPgRwFON1n4s+m9mULYxkV1Hr6Ss86FHVukdPyU/W3/f6hNWUXYUTZ+SYRovNKn72yjWsFffFCmXUOHuFKDAd/3hS2CzsTbtXac+EFW+v47qSUPDzOyd0nkj83Fk8QyN/FXc2lWttS92pHB28A0wdId23XB9OqGw8sWNt72brRhsKZNoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaSbMuL12ieabc9MwXWXZ/nM/d0u6nTM5B0Jgu3NW+U=;
 b=Ys9yeGASDEvo9I7BglVX5cKLUrE21N8rIvK8BM1GYLVAeQWjx6fJUnd+CikkFj8yepEa+of55vYAm3dQZEbvWOZJUiKp6fQHojwfew5DDvLvkMz9PjQYCL+zSth8gbBAWFAEjwjhKcrB8KezIOiOpvwO0qgsNEPoX+o6vhP/WKYu6AxkNgs4YikjYsZjnPYL5Se+ZWSuaAv8yLF6GNnGrRKQVe24r7hfrOSToDLkOB+z0dyC2PhQ4JF9pOtn7YWuuyTattgoinueZRNFfgrzHiDaLRYjd1IZ/HqPnLV2juA2qfux9aJv675TCRGegZNSN+/NMpHQzYYhkCX54xk6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaSbMuL12ieabc9MwXWXZ/nM/d0u6nTM5B0Jgu3NW+U=;
 b=AXwghcER2Zd+cvbLKB0SaksuzwfkNGrtZAAz3q5/H+qlPNKFKOfI7yVZFn4hzPUowU0pKQdgooMbwBFMNggoPOghLdBpqP/oOWVankqT75ru4Yd2JQqLUJcnmDTvBEmAQNxylB4PEpo0CDEGtm+CbbT7cDDg2G65Bar9dK67TFazVrKVpZyQ3sROk6xq2qFRtDMzLR/0qLhI5tz5/YOpNKOq2wf25LOA+KteBVZH1JJGZHZytf7i3l4+3GDFVPO7H0+w7yLnu4Vud2GWc/j0K2SNVSNotctFeC+5//90X8jaXskzAJPr5wOtNYVGzLk1weQh8yDhZKKHq68aSnd35g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BL0PR12MB2467.namprd12.prod.outlook.com (2603:10b6:207:4c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 14:13:17 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::98b2:1d32:afd7:eb2f]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::98b2:1d32:afd7:eb2f%5]) with mapi id 15.20.5206.024; Wed, 4 May 2022
 14:13:17 +0000
Message-ID: <abb3064c-f606-dfbc-a3ea-c423e33503cf@nvidia.com>
Date:   Wed, 4 May 2022 19:43:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
References: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::12) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcea93ab-058d-4723-82be-08da2dd83be9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2467:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2467483CBEE2F3198C38905EDCC39@BL0PR12MB2467.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ef5DgXYp4MJi6GJfBFB4/3TW5oiLLUO75TeD5YGCI42urXg+tiPmlf14UH69osE+fRRklDgOPnYG0/Do0wF9JjYw66IqaYDPWVmUrusIXYBCPFws7sKQcu1wYz+8EaL5tBj8tYiW99uTq7RAvVKqyvpbBkmiTyXZ8pkmNGqET8JITZ1sYIuOad9ecCQlejNCwA0eozEWGxI9geiil5SH6bUIp4jsFN05zEWmtQTFsDg3XuuLvL6cllu/JzK8NEBRJIAOTb5VnS4x/y4d2jALHJ7U/q4ouDuL5KdJ2j/okXAwB5ULmUp3lsEBQ6BIDFFufOQ924Ua1rB7sTK4IkQBdo54dY/Cw7Z906HlgcE4fwiEb00Yy+DDM42zWy8ki33LAmg37ZgDMkRyTcE2TU42VvsjPu5mbWaHEd/ozJnnCugfu/+pWmKTriHuG0od3jVVPKX4MMBBzrOvni0HlzRFYBUZxeCu/40OkKQm5SbkvlI63Jue9EJWjiRDRt+5xRIMBDFAlUhXZhdV4BF2CeoPXH+S9RFs5GaKSZvb2YSEdlUmSYGMxNmuTiKpS5A6IFNxHB4q//SBTgrW+71svSIpXEHuk4hTX/jOPAOgpPPrPi1/x2YmXlOwCh+uot9VgCPvAJIW+nBecIWsaEUvKu8L3UogLGiN13QJzgDIOpG31wx2MGt/2aI4vJIKvznH6B3J2pE7klolH+wXQmRhlaVa+d7nzU0zarLTB+MXT6ZbsvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(36756003)(83380400001)(186003)(31686004)(6512007)(26005)(2906002)(508600001)(5660300002)(316002)(53546011)(55236004)(110136005)(6636002)(6506007)(8676002)(66476007)(66946007)(66556008)(8936002)(38100700002)(6666004)(86362001)(6486002)(31696002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk5YbzNGYmVpNFBCUDRKQVJPL1EveHVPWTNhS2grQ3R6RWF1ckpqWURSUlBo?=
 =?utf-8?B?c0IvNWVsbmoxd0tiNXBOV1o1QUdhZklVM2ZmVnk4dkI0dnJxbnF6ZXhKOEx2?=
 =?utf-8?B?ZUtDcEhqV055Sm9EY3lxMm1rOEJMN1hBQlR1UnBuMDhLTXVkVFBLTmhydk83?=
 =?utf-8?B?RDlUV3JZWVN2SHdKSzUrWWhEakZHM3dDVUhkRGtmalU3UXZXSFFqOXNvK2ln?=
 =?utf-8?B?Y1pubVgvREpRMTZYb2RKWXhqZitETXNPTUR6ek4rOHYrZTg3b1cxZ2NWeVdP?=
 =?utf-8?B?aWhzWWtGTUxRQlU4U25nalM3YklBUkhVSDdESlRRWkFjS3N2c0xSRDExTjdP?=
 =?utf-8?B?bllHdEp6SWNRNUljWkN1Z09iMC9OKzcwMTg5Q0p0ZER1bVo3MVhPRnoyR1RM?=
 =?utf-8?B?ZjlTY2grcnc2R1JuWlJsNFV5U1JFQjIyc1dnMkZqbERRbmV5eWU5MFJZUDkw?=
 =?utf-8?B?RldiWHNycCtjd0hvMzY0OTcwY2ZRWG4rdFE4ZWxkb1pjWFZhVEpsc1NOdnp6?=
 =?utf-8?B?Ylg2Z0hvUWs3bENlT214SjErMG5HTTNjekwwYlZ4MEF0UWF5TzN6eHJLTUtj?=
 =?utf-8?B?cGNubnpaaXIvaHhzdVgzZlZ3Rkp0dCtuZCs2UXg0L2Q1VUszSVB5N1ZpNHFl?=
 =?utf-8?B?aThUQkpOMkUxcHhOUUlUalV1NHZIZWxOQUFrdlh0WUo1MXFVSnZ1SjU3dHFr?=
 =?utf-8?B?NUxZekFmcG8vWUh4b0FZUkw2M3hlUndPRjBYZ0o1MjVsRDJ3RFdDcHdZMDMz?=
 =?utf-8?B?NTlYQmFQc2JKQkxMSlpxcUlrL09rV1M5TW9wZndGeFdTTnNvMUtNRDRYNHZT?=
 =?utf-8?B?U2QzaW1KaGt0QmZrbDVidVJWT2tFb3JKS0ZjZlM4b1dLcHJ4SmlxaUFEbXRO?=
 =?utf-8?B?Z1NPK0srL2FYYXFRTklieE1QYTY4QnFldm9NaUlaSEpGQVp0a0doaVpLajJG?=
 =?utf-8?B?Z3I2dGEzMXFaOU15MWhWdnZVRXZLWUFDcDJVOGxSeHF2Vzh0ZFI0YjRqYVVz?=
 =?utf-8?B?WHllT3VjV2dmZzhnSFlISTFnMnN1Lzl3YmpHelhUSU10MlM1dmYwSnNtK1BV?=
 =?utf-8?B?TnkyWC9Wc1dxanJzU3FBWjdUNWN0TmNuVnJTRXJ1a0s0L0tXR3hpd0tMWndu?=
 =?utf-8?B?R2FFSEFiVUNQU2VPVHl3L3BTd3FjR0hPRk81UjJyOTc0MGM2Q1dsVUtlYVBm?=
 =?utf-8?B?MzVIUFhKa1FkMGZJamNHdm9uVDZkNDhQUjQ3OXZzL1BtaWIvRnYxWFJhQ0ts?=
 =?utf-8?B?TklkT1RaZXR0dCtIK2ZTaWVYN3MxeTVPNHRGbHNXcEo0NTlvUVRSQmJIRy9M?=
 =?utf-8?B?alhCZElWYTBFRWkrMnZQOXM5NDBzcC9TdFNnWFJXZW4xa2U1WFZwRS8xNHdG?=
 =?utf-8?B?VCtRSExlczRYd1JweXo2Vm5HL2RzQUhZK1J5NTdnK2Z4SUkrTVV0ZktDTHJY?=
 =?utf-8?B?Q2dWdHRPSDZiMFVTWjJCQ3NxTlVHMTBVZnB3dlFrY0dCQm4ySzY0a2hWVHRH?=
 =?utf-8?B?UDRrWGcvQ0tDM0I3QnYyQ3dBZ1ZmZ2hxSXhSV29yWGdYMkZZWW5PUWhBMURR?=
 =?utf-8?B?N2wrL00rTitvMXRFdy8wWEwyU3RzQnNpa1JjZG1hUmlXSHlIVUFGWDZBUmcx?=
 =?utf-8?B?d3liTVNDaU0vRTcvZUtGdHI4dmptUVlsdVc4RytYUVlwY0NOZEJ6anB0Mkk5?=
 =?utf-8?B?Z1U4RUJPYmR0c01HYnpKVTdmNDZRRnVuVTBSQ1pUanVpNU91dTk5VVFsQXp4?=
 =?utf-8?B?RXljMmlmTHdUSXZzcVAvS0FzeGV3TVkyU0hnWkdVeS9FanRIMmdTNVZDd2dn?=
 =?utf-8?B?T3NrWlF1WmZOUGZIdWtPa1JwQm5WNC9TWUZLTE9DaXg5cHRiVVhTTzliZEhI?=
 =?utf-8?B?K3dGVEtUaWxzaHBrWnBEWm1qT3ZKeG81WkhHdEFZb1EvalhhUVRRNnZNaDBL?=
 =?utf-8?B?dVZtdWF4RWJ4U3ZaRC9oVjNnMzlYR1FDVmgraTlPcmoyeTR5czdIdHNieVlK?=
 =?utf-8?B?b1VSNmdpTDc2M2FHbHhyeE5vdzlmVEFDS09RaStydHRTZGtMYnFLdXF4VTR3?=
 =?utf-8?B?bnF3bFFLWVFRNVB4ZlpTOG0yL2dxSGVXNXdiaUlnUUx3YjUzMytlUDAwSnI5?=
 =?utf-8?B?dG9HaUVlTlJ0WDdza1ZkSFBXdU9MRGdvUFdIRVNRTlFyYmlGQ1RQVFp0aXZj?=
 =?utf-8?B?TDhnaHUrdFBiZzd3T3BGZWZHOW84c1VWUytaNXJtdWZhMEI5OE4yYkpmNGlU?=
 =?utf-8?B?eDlhZUkzdnVRc2Q2dUZXYkNFOXJMb0dSajhYNWpXV0RET08rTFNzM0FXWnRi?=
 =?utf-8?B?MFlBdi9mMVVrQkIwMU43TFJWNGVXSkFnaUxwWlBKOGQ5dVBONUFmQ3NtQnlZ?=
 =?utf-8?Q?yvzKwwg6/XvXFNAs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcea93ab-058d-4723-82be-08da2dd83be9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 14:13:17.1284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUr5eigm2mmFjCpQbUayJuD/EUoWAXjqcGtLjXQz9mYz8EP09xxNiG2G+zA06HAfsyk4qDXHfBxxeA/tH1Qs7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2467
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



On 5/3/2022 5:12 AM, Jason Gunthorpe wrote:
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
> any access of the drvdata, under the driver_lock, from a driver callback
> needs no further protection or refcounting.
> 
> Thus the remark in the vfio_device_get_from_dev() comment does not apply
> here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> remove callbacks under the driver lock and cannot race with the remaining
> callers.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

