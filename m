Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE378E6E1
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 08:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbjHaG6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 02:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjHaG6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 02:58:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3391B1;
        Wed, 30 Aug 2023 23:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vmt2Sq955fKx4K6M/LcSAO6APtKy4UX511N96vJI1YKv/i7HWkl5IZUwkcoM3YG6Qt0OdM1C/P2JvkB+wrbgRQiUu93Xr2wpIbPaxJ4806o9piebcvkQ+zjmdqkubQBeNcQJ7J4eRAZQ5KD5TQigU38aHaUfyaLtCFhZkvkANPA+mLpT9ZW990hhH59j+Z7RXMAKUrqwUYXy4PmD0WUdDSfSWCo7z6LZ0qFDEpJwam7DX+FEPFAYv/aUaMS3oxQbEyFI83mV6SMjZBtlYUXAI3LSOU1mrwhYeTsicdpraZ8qQ6FOPfLVB7YjSpnnxUS2H/Cm9W6Zlyz8RH231fvPmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBqJy6Qe+vdrP2Nui3KR48vU/0F87P3+P5Gnad5DRjg=;
 b=RZuCEcCpUCqVj849Zg3GDqr5CHTkCu+4cr7T5/t33mhKw/6ItQd8YOaoL5KhYHYKmpunDkbpJ9TlIzUVbZ4+xN5Ta8jygqWvdnh7sYaeti92gOvdHo98CX04XXFA0++RrrYqouuJ0fhp18pHjUl1c7D7PV2P3+APtwpX7ho7LfpZFWVs41x91B5yl4qead17yqaU7rTr/CHNBiPnAu+eHaEcJBrmMrotruH0LG3IoJlJgT7OWGTy9qPykioWHjh+Vpv0ucX//btRKLKt6uOHTk85x1NM/dVibqSdOub+ImXm6jw5o3cFJkduJ9z8fZNWOyOfS+JhIPTaR567+ImU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBqJy6Qe+vdrP2Nui3KR48vU/0F87P3+P5Gnad5DRjg=;
 b=EhwP+D3nJE+e4KVMU8saMSYmYF6A+hXfpQK8tY0PU3BtWVoK/ix8mgHla70FWMItqh3hiqZpa+9X33ldBziqoDwiLA08cTjEdq61PrPw4qQpDBwkJcuQ4NJCJEY1azCUokZBxGvvL2WuGW5mEfcYrZeZSEzBAoTPFCdzvkWoIdk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MN0PR12MB6293.namprd12.prod.outlook.com (2603:10b6:208:3c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20; Thu, 31 Aug
 2023 06:58:08 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::67ec:80e:c478:df8e]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::67ec:80e:c478:df8e%7]) with mapi id 15.20.6745.020; Thu, 31 Aug 2023
 06:58:07 +0000
Message-ID: <0547df76-6ef2-9a1c-bcb1-f9235bb0007d@amd.com>
Date:   Thu, 31 Aug 2023 12:27:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a4fc5fa2-a234-286b-e108-7f54a7c70862@amd.com>
 <20230830124919.GA2855675@myrica>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20230830124919.GA2855675@myrica>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MN0PR12MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b49429-d6b1-424c-0005-08dba9efa10b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cl5DbGaJmiPW9Ib0NKJ09Ihs9oxAbYxr54KptRMzYMVKjLN7ZTvVDjJPF5o/O1LAnOhxkpN9LdD9trpGfEnRS2uKJD/09tKDGdgZQynOXNhINNGC1ILZ+UV9iQq7jqlOeIb9KVwK8wfk2klq/PQmy+zas2X7W6csQf/iUqxqz1iAPqZ0jQaEStz706SrjgRbQkuNNxCb0xMXkAaRJ9uabNAY03XjJqWdsYH64J1HBiQuLWFqQbOZtkSpGs8Glcxt8Zuvf3N8kz3Gu01rI9BCyTX3ipX9yOIaJKOhTmQIMFI2HSt9OLtgbJFj+U0JnDMYkTVOWiqBg/Q5hyEGN7/0yyY8hVlD9fMihvY//B9EIWdDk1KGHt9m8HbNvZbMWA+dArZrCWZdo3A9kM2uzeyIs6MU1cdPqaJFBASA6v/DFIxkAS6HPYf9mrKflG+v97xOdBqDCLiTIogYynCJcAqQ05sX9mDS5A4aOhpwV93v3QaDIponhElWuCoLgQCXRDBE0nvCBU01qzzylNaaHy1XJXmRgKqnkE8lfNnBFDAkcLxCs/Dj9iXNoR8J507WapSVftDQFtytyxIRkanBV3PHV7h02NF8VURALz+CgM4HzDeHCy2uwXNuLSf8H8ZonJv9V5ZpexI1As7LSdicRASS9b3q/vEl9MU3KIAecDsw7qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(376002)(346002)(1800799009)(186009)(451199024)(478600001)(54906003)(66476007)(6916009)(66556008)(66946007)(38100700002)(966005)(316002)(2906002)(41300700001)(7416002)(31696002)(4001150100001)(8676002)(86362001)(8936002)(5660300002)(4326008)(83380400001)(44832011)(6512007)(6486002)(26005)(6506007)(53546011)(6666004)(2616005)(36756003)(31686004)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0pzd2pLVC9NSENKNXBoMWZBc0J2eERMaWkvYk5tM1JsMGFJdFJjazYwZHpa?=
 =?utf-8?B?VitvZWlWd3lhdmV3c1R3ZjM2Z3NIOHV6bmZzZ1FDVndnckw5WGtYR1pvTUV5?=
 =?utf-8?B?UDd0NjBDNnZpUG1Fa2hZb001dnV0MDZoTUtoeWwxQ0FrYlIyTlV4dG1vTnBD?=
 =?utf-8?B?cWFJRHY3WjIxVGthV2xmZzA5RU9OUTNJT3FrT3FWUmtGbVJGZ24vUXB5OC9p?=
 =?utf-8?B?V2Y5N2p5WDN5SytONVRrVklJRVhvb01hTE13NGg1V2prMWRVYjhrNlZ6RnE2?=
 =?utf-8?B?OUpTZktoV3NHTW8rRDV4Q3BNcWoxQjlTTldqckxFcm1xTS9YTE85dUtlQUNV?=
 =?utf-8?B?MWJ3N0dsZEVjNUd3eEJSeU5XWTIydEQ4aHNlY3JaT05PbCthbmYrNVZMbWVs?=
 =?utf-8?B?WERicjhBeEM4dUh4ai81cG9LYkhxa0MwMkxWc3h0bm42Z252cWkyZjFPeERm?=
 =?utf-8?B?MGNWNy8xbnZwb1pTRXJyaWpvSEQ5cEJaQXV4U0VaOGhOS1RKbHJVZmdZRUZa?=
 =?utf-8?B?ckpXbGF1TWhvd0lseTZKQzdwdkswbGdsRXczeVF1Y2hXcy9vM2VaaExINGpj?=
 =?utf-8?B?YXdUNWtRaWxGNytJaTFwaXgvS3NLY1dGbGsybU5XRHpMZGhmZncwdHd3QTI1?=
 =?utf-8?B?Z285bGRQdE9XZ2VKRTA5R2hTYU9rRFVXN1k0WkpNdU5DL3BUMVJab2JjeC9D?=
 =?utf-8?B?T0cvNkhRVEl1V3g3aU5RR1cvdEtNN2pweXNrWkZ3ajhBZWVIWnNKd3Jrdk5X?=
 =?utf-8?B?L2FmUVJqU29YVnBXZzZjZDh3dWxJRHFIMkZBZ1NRT2t1czFHQ0Y2SnRMcTdv?=
 =?utf-8?B?cVQ0bTNDWHkzRnFBWmpobkFRNHB3VkEvODAvMjRjSEIzMm1STm9LUTZYS1FP?=
 =?utf-8?B?Yy9HeFhLeWZJcUlSV2ZmUmw5U2lzdkxpQ0pDSHc5djBjTERkVWRPekROS3pn?=
 =?utf-8?B?cXNiSFhUL0VZYnFTYUNPQUdUVnltUzVUU3EwWWFUelJQOFRHM3dVcytkVGdq?=
 =?utf-8?B?aTNaTkpCdlNCcEZ5QmtoY3VlemRMUEs3NGMwa0hHOVRIcTg2Z0ZMYjZNM2NZ?=
 =?utf-8?B?a3JkcWV6NXlMT2J4aDJCVDVKcWkvU1paUGMrM3N3djlFSHVldEZUQ3Zubkpj?=
 =?utf-8?B?VG5pZXdvYS9vSUxZQVFlSWF5ZDdERlJCU2lOay83YkdVcUNPcHVzdVNuZmtU?=
 =?utf-8?B?ZUYrcHJTRlpoT1J4eER4TDhoWkhOM2F0MGtDdUFtMmpZUHYxek9EZmFoOWxU?=
 =?utf-8?B?dnMxZHU5clh5cnNUN0N0eThKWjBiYWNEUHI1R3VLYUIyZ2JiV0hCUlcrQUY3?=
 =?utf-8?B?dTk2WkFIN3J4WVBuY3lkM3BFRnl5a1ptcWllek0zTUhDcnM3T3phaVNHbVZK?=
 =?utf-8?B?V1F1c3k1aWtRa25TSy9EcW9sb0NYVmZXMTFoVCt2WkI1THc2bVdKYnBUUmF4?=
 =?utf-8?B?YlBKc0dyMkhjWll1VEw1MWhRYWJSMUw1cjNCNDlZSjl2LzlCTzdJa0NDbnpJ?=
 =?utf-8?B?UVNrdFo2UzFMOVZqZTcrVXBEa1NXRUJzOXJFYS95UHJkaW8xZnV1dk5VdEs2?=
 =?utf-8?B?WHgybjdsTGJaMTZ2ZUFuOTBieVlNYzFxZ01KbjhSVjU3R1dnTUNZUlVHR2d4?=
 =?utf-8?B?UHdVcDh3eXh2YWVPc0pseXdJajhraVNldC9JaCtYdUxjOUQ2L1dURnNidFh6?=
 =?utf-8?B?NXVmWW9idVlVdEdkM3E5VkZqY0o4b3d6TGliS1h2Q254d1Z4THppUExrTk9j?=
 =?utf-8?B?clhJT3dhbEdoRFh0dHdBRTlBelVKaWF6OCs4QTRoN3ZoVm1TbEduQSs2cktp?=
 =?utf-8?B?WDhEV2VkRG5ZMUMvbDZMZ0FpZjJLOE92bDg5SFl3MXJONjBTa3Fsb09iMENO?=
 =?utf-8?B?MnlTVmlpMXFPa0hQUkp1T3pyS0FXNFNCVUkzc2d4eTRIWG1heSs5ZEoxblVq?=
 =?utf-8?B?dnd5Y1hJdUxaK0tFQnhvVU8rV2xXcjhPTDFJMlV5VW5yZDVXdjYzejFOZml6?=
 =?utf-8?B?azd5TnNhMW9WblJ2ekk1V21vbm41c3Q0aFlYdTFQUGVoWkdZL2RzSlFTMUZk?=
 =?utf-8?B?SzFhTHpDNmhYUTU1b0IwNm1GUnkxbXRhWDZxTDhYRVRlcEFFTzMzbkpzblh4?=
 =?utf-8?Q?qrwsicTZ+YW+n0cU8eMMfLubZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b49429-d6b1-424c-0005-08dba9efa10b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 06:58:07.0994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjYxWXBc7FLvwUqjUhpZjKJ5+ek2k4T81u7sW4Rx1FGBTI9aAXHTpdfXXpLwmG8ADE6qeadcnbvEbCOdxc8t1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6293
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 8/30/2023 6:19 PM, Jean-Philippe Brucker wrote:
> On Wed, Aug 30, 2023 at 04:32:47PM +0530, Vasant Hegde wrote:
>> Tian, Baolu,
>>
>> On 8/30/2023 1:13 PM, Tian, Kevin wrote:
>>>> From: Baolu Lu <baolu.lu@linux.intel.com>
>>>> Sent: Saturday, August 26, 2023 4:01 PM
>>>>
>>>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>>>> +
>>>>>>   /**
>>>>>>    * iopf_queue_flush_dev - Ensure that all queued faults have been
>>>>>> processed
>>>>>>    * @dev: the endpoint whose faults need to be flushed.
>>>>> Presumably we also need a flush callback per domain given now
>>>>> the use of workqueue is optional then flush_workqueue() might
>>>>> not be sufficient.
>>>>>
>>>>
>>>> The iopf_queue_flush_dev() function flushes all pending faults from the
>>>> IOMMU queue for a specific device. It has no means to flush fault queues
>>>> out of iommu core.
>>>>
>>>> The iopf_queue_flush_dev() function is typically called when a domain is
>>>> detaching from a PASID. Hence it's necessary to flush the pending faults
>>>> from top to bottom. For example, iommufd should flush pending faults in
>>>> its fault queues after detaching the domain from the pasid.
>>>>
>>>
>>> Is there an ordering problem? The last step of intel_svm_drain_prq()
>>> in the detaching path issues a set of descriptors to drain page requests
>>> and responses in hardware. It cannot complete if not all software queues
>>> are drained and it's counter-intuitive to drain a software queue after 
>>> the hardware draining has already been completed.
>>>
>>> btw just flushing requests is probably insufficient in iommufd case since
>>> the responses are received asynchronously. It requires an interface to
>>> drain both requests and responses (presumably with timeouts in case
>>> of a malicious guest which never responds) in the detach path.
>>>
>>> it's not a problem for sva as responses are synchrounsly delivered after
>>> handling mm fault. So fine to not touch it in this series but certainly
>>> this area needs more work when moving to support iommufd. 😊
>>>
>>> btw why is iopf_queue_flush_dev() called only in intel-iommu driver?
>>> Isn't it a common requirement for all sva-capable drivers?
> 
> It's not needed by the SMMUv3 driver because it doesn't implement PRI yet,
> only the Arm-specific stall fault model where DMA transactions are held in
> the SMMU while waiting for the OS to handle IOPFs. Since a device driver
> must complete all DMA transactions before calling unbind(), with the stall
> model there are no pending IOPFs to flush on unbind(). PRI support with
> Stop Markers would add a call to iopf_queue_flush_dev() after flushing the
> SMMU PRI queue [2].
> 

Thanks for the explanation.

> Moving the flush to the core shouldn't be a problem, as long as the driver
> gets a chance to flush the hardware queue first.

I am fine with keeping it as is. I can call iopf_queue_flush_dev() from AMD driver.

-Vasant


> 
> Thanks,
> Jean
> 
> [2] https://jpbrucker.net/git/linux/commit/?h=sva/2020-12-14&id=bba76fb4ec631bec96f98f14a6cd13b2df81e5ce
> 
>>
>> I had same question when we did SVA implementation for AMD IOMMU [1]. Currently
>> we call queue_flush from remove_dev_pasid() path. Since PASID can be enabled
>> without ATS/PRI, I thought its individual drivers responsibility.
>> But looking this series, does it make sense to handle queue_flush in core layer?
>>
>> [1]
>> https://lore.kernel.org/linux-iommu/20230823140415.729050-1-vasant.hegde@amd.com/T/#t
>>
>> -Vasant
>>
>>

