Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3AD7A95FD
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjIUQ44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjIUQ4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:56:47 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2066.outbound.protection.outlook.com [40.107.249.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D209196;
        Thu, 21 Sep 2023 09:56:28 -0700 (PDT)
Received: from PAXPR04MB8376.eurprd04.prod.outlook.com (2603:10a6:102:1bf::11)
 by GVXPR04MB10046.eurprd04.prod.outlook.com (2603:10a6:150:112::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 16:23:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZxRD2j797bEs4bd1mIG7D3F2lOb92s4MIxWp+NlxLGI2Qy0B2KKvFPHe1UKwvOSK2EZUTkJNsVY3yTix8T1UajQiqbNurdDJQF6PhbO511o0d0/zi6H7GmSG/3pt5TlgxufdaYFjltF19L1cCKu/tEan62cQzpD706q1HKTjUVVhhnzbkALNrclKVndlO5yUOv1iwxl9kyQcK42D0MBPXU3oyIVT4BT9KI6cWJwLWgXW4pgUU0MviUPnPNLgla7s7WjTnzYI18AGyKP+TUSDBFE0BzyvCNYkKEN2pLAarkUnIg4LEY16MgXgvcRwN1LjrOEAALqz2GKCHClo0CFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/w4+6L5OnO0MSGurjdET7KtBJjK42HGTO+AkrCjCYtE=;
 b=nc2OfAot6FHIwzPpWuf4/xX4+YaoDxQ4PmdmU6kJGv4077jCxWlkceb4rrxZPVahXWzBXIPw70g1EOPsygjAjqtVNKpv1R2+axRLdaaQBs2m2PHuVa+pcYc8qBAbJ3JoqJjXJEjrEc9eH0eMOfwpotpZgjAxLF5NzNTsPVE4m5lYGVYaUGI19SV+n0H5aWwWQJD8X/yXNF2+R/khRrTWJ9/SdOdHmR5+na92KDXhy1jVotvDyN9KiKlku6lWU4Id6GAAyxBrgac0XOfOy0BVorRkbbbZvzFZA/QVLhaYGLKHR1jTE0KcPBBrOo6D3bEXM00kD8VH7uow9GyA8a+XHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w4+6L5OnO0MSGurjdET7KtBJjK42HGTO+AkrCjCYtE=;
 b=kXoW6m0EGo4k7g7o7xVIab97k8p8Skx7JEAQNzcu6cXslgkvlnxaCmctDWaAzPC821dqDUzi7QzioJ1idoQLPo3R6gHVtAnFxQjWC1WB83WzKGInp3BQ5dqMeA17t/hrVhkmoZ64/ylUXTpSHZRjFc7kDeGS7EFP5urtFoahIXgeA+CGY6Xxr3S4hO7IKpDzFrFXQKNsUbkw556hXAXkU/SCVVtFA7x8g/+hMQWT0G98B5xJmojM8+jmpkK0/4ZnQ3noQtUj16K6BLF12qfEd3CpO+7Y744h53FIOV/FlOeUfLApo7qqydFZN1uWcRbMYf9HZmPxZR1Wrm7L5El/aQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB8376.eurprd04.prod.outlook.com (2603:10a6:102:1bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Thu, 21 Sep
 2023 06:07:48 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 06:07:48 +0000
Message-ID: <587bcb4e-dc09-4c89-3c8d-ab2b7b75e40e@suse.com>
Date:   Thu, 21 Sep 2023 09:07:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
Content-Language: en-US
To:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-17-xin3.li@intel.com>
 <336f77d6-1d94-d2b7-f429-855bfbc3f271@suse.com>
 <SA1PR11MB6734182B172E9204CD11688CA8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <SA1PR11MB6734182B172E9204CD11688CA8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0032.eurprd08.prod.outlook.com
 (2603:10a6:803:104::45) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB8376:EE_|GVXPR04MB10046:EE_
X-MS-Office365-Filtering-Correlation-Id: bbbad59e-4526-496a-92a9-08dbba69144d
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rxboVQCj+gtokA45ZnPVyBxkkioB8gnKUGxYl/zFbqafDvUqga4juKE9zlUT/lVyiEpT06mYViFgTzrBdj92Vp82rzmj/QVb+PKJKXi2wwb3m+j5sXFoDKwi1pDNuIZ7NW4z4SqcQzA8XRv2unu43kwukRjWwTP9SsTnXdJXywnG9netSyFpLcY61Hf6Ld+RsHOs1d2xnlvqR6r3dCWNXhTu4IM5udl/02oXh3CIHKCtkTzmGnAME+Y0wqK8GnOlicPo4Hd1pJ3oxcZK+8B7VUhsguCB2YFOtbA/MLSuP1Of6dzvB+tVkUaWpagjidj7zofiB0VxlS/jJ0jlB0P2kQLD0HIHTqOktuut/O6nGXdUWo+2OSzsr5sscXnCauhJ3ebXdjItr9K2bR32s2xE1VdnVEw5Ynm6fodWn7NzzamrQ/lcj5EaYDWRVPGQJouuM/WQdMvC06Cp9DAcPajNI37ithETy+QjOB88wgYmTS44S1qnmSKY8S4L3BUZzG24hdtJDMGijQxjc4poY5gcFdDxELbZmbBzGCuJToj64deAcTf6ZyA6z3f2XD2D1rr55s6mOI2EhiL3HPcMPLjUZyYVZEoKrsOdNyUgeL8OwF8NOaEMyULhMyRguOZBJJhT+zpUBd+yYjhF5RJDXDnMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199024)(186009)(1800799009)(41300700001)(2616005)(5660300002)(4744005)(26005)(2906002)(7416002)(86362001)(31696002)(36756003)(38100700002)(4326008)(8936002)(8676002)(83380400001)(6506007)(478600001)(6512007)(6666004)(6486002)(110136005)(316002)(31686004)(66476007)(66556008)(66946007)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzVoa3ZKbm9VbWcrWGdjbk5JU09OOHF1Q1dyeXdnT3UyclFGSW4zMDJHQlJX?=
 =?utf-8?B?Z2tOOU0wTitsYWpOTk0wcTRJbnAyU0VsOEVJb1lITmk4KzZqdWVMNkVZL3FJ?=
 =?utf-8?B?STRjYW1aazlsSEw1RFZTS1VkeVdNQlQ5Ykx6TTlCbG9DWTQrQkV2SjFSaTJi?=
 =?utf-8?B?cnU0Y2hURVVhS3hzbmswdHRBT3UvR0NBbm1RbEk2U2l6bzh2UVdkZHpmSEtt?=
 =?utf-8?B?VkhlQ0lGQi9BdXJQcXZyVUpyLysxZ3BQOUxFRE9CR0xONUpWMys3a2lhUFl4?=
 =?utf-8?B?SStqWFVTQVdNbngyUlRHdVRRa3p4cnJvY3Y3SGFremxRNjViRWVCOGNsaGhD?=
 =?utf-8?B?RGFLL2lLR2REQzYvZnl4eTd5N1BJbisyMUZndVZuU1pRVm5EemM3cmUzMGsr?=
 =?utf-8?B?bUxpNG9kcDVmSXdxOFNNSXRLeTM5eEVpUHVzNUw3T0NaVlh6V3NCRkpmNDEr?=
 =?utf-8?B?bk9VMG5JMERmTnFDZGtVUDg1LzVXakY3eW13VFJLNnZuY29Qam5kSWd3V0ZY?=
 =?utf-8?B?UWRKeXpVY0syMHBHZEhJWkpvTjQ5OE5zVEZ1elJJNllNVWIwVEliUlhJdUQ1?=
 =?utf-8?B?ekk3aU51WHZ4V2M2cW8xOExVd2xKemdCdnFaME50MURQdkNlV0c3VlNobEtO?=
 =?utf-8?B?WVFvNFpXdWtrTlNDVDVYenhRSi9pSnBBbzJXTk9McUdFN0hSaFQ5R3J1aWJJ?=
 =?utf-8?B?WkJWWDE4VUFuWWVQU1ZFajdabzNsUEZqc0xlVWhObC93K1NTbThiS05wUkow?=
 =?utf-8?B?RXpSS3dKWVkwM0JiQ21Ea1VyNUtQeWl3ZjZuZDIwQVBSYzVpRU1acUpIQkxE?=
 =?utf-8?B?ZlZvQitNVXFCQjE3ZUtIT2w3RGhkekVSZFpWTnFzUkQwa2dvVW9Nd3hCTGxE?=
 =?utf-8?B?ZEs2TEl6L1ozdVJtU1hIQjZTY1JhR015ZFF6MjBVa2xta1RFaHlsRitVSzJV?=
 =?utf-8?B?aE9wTXppcHZ5VG11SldCVHdWdUhqajUwZTBMK2JlK2h0dE0zZUlxdVlPR1c3?=
 =?utf-8?B?UEpkeU01TkZnYTZpODZEQU00M3ZRNUxHMStGUHlTc29TOXNsUncvWGVTYWVh?=
 =?utf-8?B?VDJLYStSVTlYcE9NellJcE05UEtJeTZRNzVleFphRHo2VStQVE40c2c4cmxQ?=
 =?utf-8?B?empubmk1QjRHcHRPZHFqS1diREQ5eUhNYmhoVGNXMmRXYlZoSGRTUzlod004?=
 =?utf-8?B?c2VqT1lWR2haS0h3bWFVYkhpSTdDWXk5NVBTd3A5ZC9pSFMrbTdnUnlOci9h?=
 =?utf-8?B?b1lPNUg3WU15MVlHVXZZelJqL25vMEk0UHQwOUZvaENCL1pndFlrNmQ3U1hR?=
 =?utf-8?B?YkpiNzJIQVpaSUZQUlo4YU5TbmpsbzBHK0ptUmFoaE8zRkhCSXQzTnlia3kx?=
 =?utf-8?B?VjNIVUE5WmRjRE5tRFBjemd6RklsODFDd0MzQ2k1YnpsMkJyZWNUZjdaa3A2?=
 =?utf-8?B?Vm5FWDM3U01qUWJ6aWhYalhoaTk0YktPVHRnSHFGVytvaDh5d29KMzM3YXBp?=
 =?utf-8?B?Ym5lTEZTWm9nSmFJY1hIcjI2VFVUMFZ0RTh6M3RwRlFKM3JjaXEzOGNDVFBa?=
 =?utf-8?B?S3RGaUtOYzVPemRIUyt2M1EyU1B4OFA4RVZaMWgrVTErd1RxSEZvRWpJWThJ?=
 =?utf-8?B?QjJCS203Sm9BdVdWVFVQaDhBbHV6U2dtVkh1YzNqRmFadGtSTG9vOEZUeEJX?=
 =?utf-8?B?dGFVaE5xRmhvZ0NFU0RjOVZKWWx2RGJMWEhyTDU1UHd1TU1rRks5aXUwbmpX?=
 =?utf-8?B?MHBmMHhHU3dtZ1ZCbnIvSEUwTkcxRnNza3pwbitoWU9hbU1mTCt2UnB5M04v?=
 =?utf-8?B?dEx3QlRvWThWMGRlUjdJRWp6cUxLQW1OS296MVJKQmxvTzZFanFXNGZCUGls?=
 =?utf-8?B?dzljNFdPNmYzSThyYWplL2RWWGFUbTJibDNyOGRVYVJCcFRnQ3dBdDE0UEY0?=
 =?utf-8?B?aWFBdXp5alBwQlo0a083VWprbEF6emNkVU9kYWRHVXh1YVlxQzVHYjc3R1Iz?=
 =?utf-8?B?YWxuVXY2UTd5K3IvRlRDY3RlUjFkZ1Fqa25qOTRXaEVOejBYcUdwdUdpSG5j?=
 =?utf-8?B?dzN1SG4vVnpOOXBNN1hCTTdyMUZBcXNRWm9ia2s5Sm5CNmcwZjZhekN3M0pV?=
 =?utf-8?Q?kFF+xE79XfvOhYdsRGRdkpe68?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbad59e-4526-496a-92a9-08dbba69144d
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 06:07:47.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsAdWXztiG7H8jg7+cjILghyegTFb/fSi+fAL8klpbiiOUnNa0hs3cL8rf8PFJ0YloUcfSlV/4n5eUl/DyZliA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8376
X-OriginatorOrg: suse.com
X-Spam-Status: No, score=-1.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.09.23 г. 20:23 ч., Li, Xin3 wrote:
>>> +struct fred_ss {
>>> +	u64	ss	: 16,	// SS selector
>>
>> Is this structure conformant to the return state as described in FRED 5.0?
>>
>> — The stack segment of the interrupted context, 64 bits formatted as follows:
>>
>> • Bits 15:0 contain the SS selector. < - WE HAVE THIS
>>
>> • Bits 31:16 are not currently defined and will be zero until they are.
> 
> Where did you download the FRED 5.0 spec from?
> 
> Mine says bit 16 is sti, bit 17 for sw initiated events and bit 18 is NMI.
> 
> I guess you have FRED 3.0 spec, no?
Doh you are right, I was looking at the wrong version of the document 
.... sorry for the noise.
> 
>>   < - MISSING > hole?
>>
>>> +		sti	:  1,	// STI state < -
>>> +		swevent	:  1,	// Set if syscall, sysenter or INT n
>>> +		nmi	:  1,	// Event is NMI type
>>> +			: 13,
>   
