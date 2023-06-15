Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8C8731145
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245297AbjFOHtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245137AbjFOHs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:48:58 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2049.outbound.protection.outlook.com [40.107.14.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41002D79;
        Thu, 15 Jun 2023 00:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+1rQs5j0ZVpuFs9vhKENu7m6ESlKIlAlwVLgFiPOFmjWg0Vsgo84K0MjW75usnYOUclInREVl2TSklJuyzJreE/B+BMShkqIoB+yYRl2+Kabh5KVpi8dsKiphu9LZugFrJCY+q3z42tfoGsSrQLI7+VuGzt3vqLYnbDTHx6EAFHmDN+Xoa2Fa1Tqk7VsV9aCqMvKdYZBnbQrQb8M2iFk/QEaOPHgk79Aim9JHEJ6FlXLnNpkQXqH+QhVuIQoG/zNG3FZDA8CjEbFlDVTQbERfuOO1l2lmQpXmyIXOjdV8gyLL6VgFU21r++69rVPbbXBy89+rY954QlvjQB4W8hxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDiZfHHu5UuW89C3SOpWMjNWGIsDXjq48VYLFVUKlr0=;
 b=lnvLZvQx3LIh6L9nSc4nASBfTf/N9SpdNKKsAvCG9QA9QGDnwWOatMMLR6b3YL1Vm7SEjH7yDqBOIzxIB6BcLSlv9CdJ0tYfZ5ew/e1a5uqpdMCsCIWEPDL6jHoKm0LfGbStni7n0OKgGBfB71tow8mBIr4j7Bo8MdSfPsHGpN7ZxDnptTE0Uo4xLJcUTLE9eIXVO02USSvQ1nA4qLECr58Fb4L5NzEtb164eyay5eh212ddQg7lTTQ3t4zCZ6991p/zba1wKak7TCmB8gx0ZlVD1vpMXy53i0mpAu5t3Z/2NCraDGufe5HRP2/nUhVBMZA0JDkxtRe0MQABMRiEuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDiZfHHu5UuW89C3SOpWMjNWGIsDXjq48VYLFVUKlr0=;
 b=SBwDYtIbDmM0lXb4y+qXj+e6fvPWGrdXnZgR7K/8uTEMX3k2tAX0TaCt45rGKDhbEuCfLOZ5OOgxKD29+JoYE3qhJgGTaYvSxzk1nsLx4l3nqWTpl+MkdWrUfVjN76CuFVF7uQ8MEwO8id0e81wy+Uk9uFHeMc7JX6t/lIpzby9Ye8pfkTyyxuiSKQiuTJn/RikykWZ8QnBoBv1VlKXEzYPTo8cCdAgLtWy48qWupRGGiMGDmUrH6Lt1SEsxmYCouYFgIBLEMvDSgBv4N/Fiw4Ki/B4iPdUfavBZSNRPfUJHxgsb8Vzx0oMLFzDNBdubnl9ZwlIuGQhN/dNQ7afEOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM0PR04MB6916.eurprd04.prod.outlook.com (2603:10a6:208:185::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:48:21 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 07:48:21 +0000
Message-ID: <b516b042-bec8-63fa-2474-72301fec67c7@suse.com>
Date:   Thu, 15 Jun 2023 10:48:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <4e108968c3294189ad150f62df1f146168036342.1685887183.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
In-Reply-To: <4e108968c3294189ad150f62df1f146168036342.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM0PR04MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: ae2c5d3f-59cf-429c-6065-08db6d74e3b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZ1929BrvtogSeRZi6/6+Vs/ECJU0gOIH8NbbB3ZOSxmEMU4UsvNilP6PcwwYRJdvBGjX/opiiDTyTMTbBM+1nksT/PYxNKAVrB2BSOmhFSsTDQZjI9ajfKdBPTcT+J1c3w34UoRyZ0j7MeZuzRr3O9RPds1Tc0QAcDr/qxKdZjQXKZDf7ypl3dY9OACoidyQiUP2FRypeG0wpVQ8aLS5R6BJFwHLxy9+j/ZwyGxho2r+FChJSNwLjj4I+SDmIRtUvgkXZLCwBrF8xJgMj4M0okZAYtUrGbIc6UzmvqLoeEZy0EgC5rZTjLO/xh68E+eL2YKJp+ZMHcBC5r0tKoFmr7jFckCyT6A4OT7XS8R4FE4jRMw2q+MTV9lEfZDLVbuFMIjC1qaSVzDw/56ZW9NAbUqI7xdpauS1HJ8PcjooN7Zg5ovuArTFrV0u2tERIr6fVjuHcHmoVqmxWMeyz77+BWaazDi0tNWAsoGkxYB4dEgPStZlSZ6dsKHcJ6y4Sx0KC0sGvfzjfop1ZsC12BKigBWC3gh1s8NKoRpzXX5b9uMUdNJBPIxSzwMMKD4VdxSUt181dg/qu8w3iil4oqqmpypVIvrCnf8FaPKSurck+F2QVqF1uwyxD/FlgYTpUXg0JoTCfPIfZwCjAKSffgv4pTIVa1X7965PNyoxpilpwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(36756003)(6506007)(6512007)(186003)(478600001)(6666004)(6486002)(2906002)(316002)(41300700001)(8936002)(86362001)(31696002)(31686004)(5660300002)(8676002)(7416002)(38100700002)(2616005)(66946007)(83380400001)(66476007)(66556008)(4326008)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWxESjV1bDAxQnJFcFJOSjRPTkFPd2cwaW5QY0w0a1BkQXdvVi82STlJZ2ox?=
 =?utf-8?B?emFNWlhEa0Q1bVFnTkVUWDVQallSMkw5NHZnd2dGOXorNDI4ZndxUVlVMmMv?=
 =?utf-8?B?YlYyeU1sUlJ5WURONnBPTTBhS2s0Ynh5SXZmQmJIQWFCNFc1YzBJdlhVcW51?=
 =?utf-8?B?OGh1enNOSnBJd3pWL1hHdXVvQTBEdnZKRllNK3M2YXh5RnpVd096UU4raHNl?=
 =?utf-8?B?M2pvUjEvSXpGcFZEd2U0WEV5S2VnZU5NVE5IQWFJZFh3aHJGVzVUSTlFMmtl?=
 =?utf-8?B?OHEzSTY5aUQ2ZHFXNzF4dUxBa0g4NlBIcWVoKzZxREVzM2hLMGpIai95LzBE?=
 =?utf-8?B?YlhSaC9TNUdLTzJ5dEhzYzF2SU02QWRsbXZDWVdGRWFsbmxQK2FZaVE1Q1Ry?=
 =?utf-8?B?TGNiT0V3aStOdEEwK0Q2NUhac2xkTktNd21wNHd2eDd2YWErbjJ1aXYrdy9o?=
 =?utf-8?B?Y1hoUUNGbE9uMEFVN01XUzNLNXpsanFBQkpZc3NOdis3T05vb3BMNllvenBj?=
 =?utf-8?B?eVFkTnFPdmZTOVI1NERkdnRTQzl1UkZrR3lwSnJkWXI5SmFSK2lmd1FwbVFJ?=
 =?utf-8?B?aHpOV3BscnJPQlVsNE5JYkcrVEpDV05FbUVkMzFURmU3VWwwOFVQTkhqMGts?=
 =?utf-8?B?ZEhsWXJjSTBWL0hlZ016aUkzNW5ZTVpVNW1FdWVjdnVadUI2SS81MXVtQkIx?=
 =?utf-8?B?d2Ryd3lyQmtrNnB4MFZkZldXS3RNWjZBYmZSUWRveVk0K1BQV1NoMWlvYkUy?=
 =?utf-8?B?cWpNS3l0OVhHbFc5STh6YTBQSWtCMk82dTF3QXhXL1RFKy9oVzRYUFZrZ1lD?=
 =?utf-8?B?M2JDNGFIcFQyMEQyMVMwTVU5bU1OckloOHUxWktrTGQxd1QweW1HNzF4eHR1?=
 =?utf-8?B?L0d2Z1B5bmp4ejdvWjN3a1R4REZHK1VZVmQ2azZsdVQxL251WE1KcDN5cUJV?=
 =?utf-8?B?SjZvTDl5TzFsejRlT0lYL2hmS1lidlBQSXdmUUNsdVRMc1gxSzA1ZFBuUk9q?=
 =?utf-8?B?a1ltRHB3TW1Qb0djd3NXUW1SeGowNElYNUcwbnkxNlhPSk9POWc5ZFd3UzB6?=
 =?utf-8?B?bTYvU3JMbDI2bmlwSGtnK3hpai9CakRpT1NVREpabkJtVWNzVnFyVjVZUlpL?=
 =?utf-8?B?Q3IvSEp2VU9jYmRBRjA5cUxGZEMwS1V2S3VKVlhrOE9VMlhqVGxEaThsT0xT?=
 =?utf-8?B?d3JvSGVXdFE5cHl0ZTJibzcvMktZb2NUdVovL0preWhDbGJwbGRsdkk5eks4?=
 =?utf-8?B?VlA4LzdxY1JMQlEvTjF4ZERuaFIzYkU0MXR4VFhRUmlXQlkzbnpmVytJK0Ri?=
 =?utf-8?B?V09abTBsMmUvTHFmTkxFQ3JSM3MxbVo0ZFIrNndZZFFNbExIdFlBdzhVZFVh?=
 =?utf-8?B?bSszdU04Wk9LMzlJSXZ4U1RmbGlSMWtLTGtOaTFMaFd1SUhxN0NzYmQzTThS?=
 =?utf-8?B?T1NCM2ZTWUl1MW96aTZwMGZ3eVk0MDN5T0hHQWZNNTZKNXlkRzBBOFlRWWVx?=
 =?utf-8?B?SHFOZ05Sb1N1VFFCUG5JMGVwNnAyclBuUy9ycnI0RmkwbFR6OHphS0hoTGNt?=
 =?utf-8?B?Ri85NWxSWWhkdjBET0pOWGhJKzVMQkF6UXF6cDk1bkZSRzVNOHdod0FVOFNr?=
 =?utf-8?B?TVFRdTQ4eHlxSW1ISzVqRDR1RStyUjZpQVV3ZG5CNzFGK2l1cGErdDhtaGps?=
 =?utf-8?B?RHFnQ1k0dEVHVjgwRnRVN29Za0dZd0NsSkVPZVVSVzZhRGdLYkI3bTJmeDVV?=
 =?utf-8?B?WjA0N1F4WTFCSjlyc3k5ZUtQaFpxaHMvVzRBNTFYbTJzdFdIVElHM2srZGpL?=
 =?utf-8?B?YTc1WlBMenEwVU5QYklycjB1WFNhaDdReUtIMndqcDY2RGZiQlduMU9IQTBI?=
 =?utf-8?B?T252b25id05uODREak9YTi9BL1pZV3ZERzJ0R2Zqbk05Z2RsdUkyOHpUWFdN?=
 =?utf-8?B?NjVGc1R5bmdqLzNGSnB6OGJYSFMvR1gzRFA4RTVjNmhKRXlmZVBHY0lqeHVP?=
 =?utf-8?B?bGlHSUtVMFltVjFZL3d3N2FSQW5ic29QaW1lQnpCckRKRXg4ZWY0Y1pRYlVK?=
 =?utf-8?B?eXVGSW00QmdzejB4NHhCNmdNMG8ycXpVc29Tc0JnVThETFY2MDRPZzB4bEVk?=
 =?utf-8?B?UEhhc0t5NlZKSU5FK2RNRkJNN01VTXZNOXU5RS9ncVc5M0RydVpjVnNQY3pa?=
 =?utf-8?Q?pFX+176lgU8kLuFh+20Gj5BtjrKosGS66A25wcudhCSh?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2c5d3f-59cf-429c-6065-08db6d74e3b4
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:48:20.8678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eClDVououNUybRG+ikqCD1i5V4S/aGL8x6Ge7ywyRWTTLnfb6hw8wfq+R19fdNZagwLExHYWQ4AfB4BuePfmgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6916
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4.06.23 г. 17:27 ч., Kai Huang wrote:

<snip>

>   /*
>    * Construct a list of TDMRs on the preallocated space in @tdmr_list
>    * to cover all TDX memory regions in @tmb_list based on the TDX module
> @@ -487,10 +684,13 @@ static int construct_tdmrs(struct list_head *tmb_list,
>   	if (ret)
>   		return ret;
>   
> +	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
> +			sysinfo->pamt_entry_size);
> +	if (ret)
> +		return ret;
>   	/*
>   	 * TODO:
>   	 *
> -	 *  - Allocate and set up PAMTs for each TDMR.
>   	 *  - Designate reserved areas for each TDMR.
>   	 *
>   	 * Return -EINVAL until constructing TDMRs is done
> @@ -547,6 +747,11 @@ static int init_tdx_module(void)
>   	 *  Return error before all steps are done.
>   	 */
>   	ret = -EINVAL;
> +	if (ret)
> +		tdmrs_free_pamt_all(&tdx_tdmr_list);
> +	else
> +		pr_info("%lu KBs allocated for PAMT.\n",
> +				tdmrs_count_pamt_pages(&tdx_tdmr_list) * 4);

Why not put the pr_info right after the 'if (ret)' check following 
tdmrs_setup_pamt_all(). And make the tdmrs_free_pamt_all call 
unconditional.

It seems the main reason for having a bunch of conditionals in the exit 
reason is that you share the put_online_mems(); in both the success and 
failure cases. If you simply add :


put_online_mems();
return 0;

// failure labels follow

Then you can make do without the if (ret) checks and have straight line 
code doing the error handling.

>   out_free_tdmrs:
>   	if (ret)
>   		free_tdmr_list(&tdx_tdmr_list);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index c20848e76469..e8110e1a9980 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -133,6 +133,7 @@ struct tdx_memblock {
>   	struct list_head list;
>   	unsigned long start_pfn;
>   	unsigned long end_pfn;
> +	int nid;
>   };
>   
>   struct tdmr_info_list {
