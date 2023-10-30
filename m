Return-Path: <kvm+bounces-92-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 567F07DBD99
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E426B20EDE
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1514A18E14;
	Mon, 30 Oct 2023 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="0fnLza0D"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251C018E00
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:17:25 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C9CC2;
	Mon, 30 Oct 2023 09:17:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNEWITsrSlVqE6daEdxkqPWNJBB0YGNdLA4GH5cF8sGZzH4fYvKJIRU6Vr25dDmoxqAzinzVus8rWMgrRuyH3CwUynG/o2dsS7Kfx/CEbrONZA6LMKXrN97MvZF0/9zPBE08l51vA28EmgmvL42j1KQt+87OwlUBeGj8SlQlgx2QTY+Fb6r/qhFTaO/PKy5W1WdKlnuSLniF+mHwZ1S9abNmzLhvu3mpCD8G0E15fxfyyPdbw1EEY3g0ISOrDCsGhHDVpgUHMuwBNOQCQOAew85P6OyhVD1tedaUUyBF/IxM4XIXVXp/J5QPBnthiqUR1PocpzonCYavT7Ktx7IbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dj4/aTXKHZZG1AZpy8lmyppcI1CqjqHF+gLH2yyYM8=;
 b=ZklY79HLkE9csmHcJ8pq/ELAQeuiv9lanX43EXk2Uh7FkVwvt3WPqXKRkEVRo3ueAneh6RRlji6514XGUh6BUhxtCrI+DPQFsTxB/qzRWTwLBuFKSsyIAq2cmoVFBpamn+Voq9DopDgdQjKsh2oLZe3nEXKxIMtFmo74so4mEKdoD7eb1c94qQAOobOAolYnvkXvmAVZd+5gA+f5CsQR3fEpCU5fOmc5LGwnfvpV3RsSNEoJhL0q/S9LTZz08ZGkVfKTCT4fOu7kkfwQ4giUYH32y20ll71eu97UzHXLwOXMR/99SIjJMs+v5+rPx/V5jzGgGz20dm0mpZLyyYWBhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dj4/aTXKHZZG1AZpy8lmyppcI1CqjqHF+gLH2yyYM8=;
 b=0fnLza0DNpRoVaUWBcH91OFb5f82v+xKaUqE0R+EexLtd/rJO4N/+Ha/aeUVbZPpEQR76na3gmzuMXVH4ymrTBMdeaU3XsVYrRFpmV9PB+3D5r6xXfCm0nXJmoo2+/Q3/sjHdejqQygASYOwnCsHvlJ1Jy0znzymaHFWSd5DOzQDlwdYv5vCr5Puu/77ktryoQ14dCOYGh8UHDqv5P0jDYPKU6ZEHIOCz5H8y+jDcZ26a4TUJmy4qLMaEzMx6zcp1b39OAy/zzodclDIpCNcMvyUJfDB+fAXE13VoPFR87z0k0HYE8v4nVzYI09Sp2wR9SlY9LzcixtetGKpSJZkgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AS5PR04MB9754.eurprd04.prod.outlook.com (2603:10a6:20b:654::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Mon, 30 Oct
 2023 16:17:21 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780%4]) with mapi id 15.20.6933.019; Mon, 30 Oct 2023
 16:17:21 +0000
Message-ID: <d0a37147-ff96-44b3-bee4-7004f0af5199@suse.com>
Date: Mon, 30 Oct 2023 18:17:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate
 __kvm_x86_vendor_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com>
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <ZT_UtjWSKCwgBxb_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::19) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AS5PR04MB9754:EE_
X-MS-Office365-Filtering-Correlation-Id: 5daf183a-6d80-44d4-ec89-08dbd963b1ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GhhHULMA5Byb0v1dzgwBvZDiZMSRElMnCnEZlAaMcKvmz9zy7lNjPXYRcD6AORD91T/PTzBh/E5qY5yx+bH3DcS0Q2sfeYdqwgwlv2UDZHpnJEuQ7THtr2t/zcDyVEauQDQKgaAXSgsQNEK6a/v5v3Nb+IqLUYklaHyfnI/todoYp5ZcoapcxmS40i3G1wOiv3lfz04Zu4ZRXQ34PVwNAWXPENg5Zw58x38ES95YgK0dCUVYBXJn+Rdbe5cWuYiGpkmIDME1G9yS95NPgxNtysUjcHZPvxn20JK7cv4sNO8Kx9wcInwWACPWv+tp/t21e584U5vVZqoN8ayBTBZlbTkz0KKJhFabEp1b0I7x8PNGl+3TFMO9uY+mTDAyio2EBWDXMqYJgzzVzzMJHgx8joCywuQYWcwJDDJYGro/0TqyEQ7B3lVT4ycocjz6bMtPb+zsmbtg5UkrC2sZpWGj3NCdWjgqPIZ02MgD615hSsscUF+LWzNJmWWXJxr0TUAjXTQq7tis4KnX2mBPxlkE6XZGAVre8gOpbASEkGt6463IAfKgnFclwUdb3+/oSvwzrBoXZ53DiLi3WgT1VE2SbrjJCVleMOjxFu+FNuW4lss3fdYDJB7H5ZOa4C8436giDNAA0nhAry6vVY4i2pI76g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6506007)(2616005)(8676002)(86362001)(36756003)(6916009)(31696002)(5660300002)(6486002)(6512007)(41300700001)(6666004)(66476007)(4326008)(66556008)(83380400001)(478600001)(8936002)(66946007)(2906002)(316002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXJYSGFMUkRiMDF6QlNtOXZRNzYwSFZoejFrNExVYWlwUjZUMHk0VktFMXF6?=
 =?utf-8?B?SW1QZlFMRmkrcnlKNUpDeDhXLzFKODJheEZCTnNRT3p2ZGFWNFdSeGhSUkE0?=
 =?utf-8?B?Sy9QZDUvVmFjanVFZ2x3US8xRVZWbWpFN0dPM25vengvZEc5eDZrZ0JKNS9R?=
 =?utf-8?B?WHFLNDNxMGUwdjRBMkpkaU1EaWlNZkxSWmlwM0Z1cExIY2RYQ3pQNDEwZlVa?=
 =?utf-8?B?VW50OHR4NU11ZWJ4MTFuTklSdjZ1b2J1OUxPVDl4VkV6WFhBSUNCQ2NOTTk4?=
 =?utf-8?B?TDVvTlBZcnpOcEpPdmxGZUZOUGRNbmlIQ2JRT090OWJzYUI1SWN4R3lqNmRX?=
 =?utf-8?B?aCtBN0g2ZDd5VmU3UzFqL1dFVVNBOFN1UmFLUUdzelBnUEllQjFVZDZQU1A2?=
 =?utf-8?B?b0hGS0tiRjJpY1lOd2swRGNhSWFXWFBzR0kzYlFRMG5pTEM2czFWV1hWeFRu?=
 =?utf-8?B?a21tTXN4aW45emFoK1MxTUoxL1ltM09NOFJZTDNUQlozMmxMcTBncVF3Y1Zx?=
 =?utf-8?B?TlkyQlNVZUN0MVIxdkpvUVBCcWQ5cmNrSTNKakQvQzE2TUtqWUl2NktPWlRR?=
 =?utf-8?B?aVFFcFJhWWVvYWhyQ01JUmZpMTRoem9OQkh5Sk92R0xmUzN1cmR5UTZYcVVi?=
 =?utf-8?B?RXJzRUFVaGs5NGlBZDJtZWU3cXpEbFlGbTYyYW42WnZhNk5CNGFOWkNoQ2pt?=
 =?utf-8?B?ZiszRVBLSFRkUzd3b0ZLYUV4aHQ2QXl6SnhTVlord01mK1FNdmIvRkpzeFBr?=
 =?utf-8?B?anV1RFJlTDZJUnR0MjZVVkhxaXFNaStxU1ZaUWtoWUZBNm1pR2cxUmZ1eE0y?=
 =?utf-8?B?QlpjVEVRbGw1VDZoL1AvWU9qeGZwWllBbGs3eEFpa05BdXlWOS96YzgxZ1Qy?=
 =?utf-8?B?N0kwMTdKS0JkTVEvQ0RyOXdGUlhSdG0wcG9IYy9CVlJVM0M5akxkOHY4cldj?=
 =?utf-8?B?Q0Z5Zkt0Y001SVBGYlg3YUVyb0FLbE9sVUwvUG1USGZUSS9uUHYyZzJabmZE?=
 =?utf-8?B?ak16VXZiN1ZUb2N3aDlBSEtFYUFmd29tV0VMWmJYeFlEa2k0TmVDT3NFZWJi?=
 =?utf-8?B?N1NDTHU3VzdEampSeExqQjZCaTlobHhyYytFcmFzekF0ckVyZTlCWWZkUDMz?=
 =?utf-8?B?WTQxRlRuWkN3b2ZCeHRadHNqcGc0NXJQT1pWQzREaEVGSDVVZ3FaOHZ2Qkkv?=
 =?utf-8?B?aU9CNkhhWm5PTC9iQWcvWHQwRFdYTnQ1MklZODh0Q3ZNckZ1bndkekRCVTFD?=
 =?utf-8?B?M1hRdkVTZzBmSW81N2tXTjlUUlc2YVFiMWIrd0pYci9aQ2pDZG54K04vWHEw?=
 =?utf-8?B?andqK3lrNmJKSk11eFBCMG1QTTd2THJKOElQdjRYTGJraDU5b3BEZlhUWWg1?=
 =?utf-8?B?UUd0bUpvbHJPRitQUXZ6UVZJRzNoa3F3T3UvTGVFc2d2OXZSWm50bHhDaWxS?=
 =?utf-8?B?RXRuRVczQnF4cUJqRlZ0S2s4aTdSeis0RWdtVmpURmppTWdSaDlNZGRyY3pm?=
 =?utf-8?B?OUxGcC9TVHM5bUFJVWhBWGlycUlBblNLZHVlMHJ3bE01K3BOSWVPQzhUSEta?=
 =?utf-8?B?U3pKN1FaSEVXWXMrdzVtT1Bacm9pSlIya1Jzb004bG1CaHV1RjBnR2xxWjh4?=
 =?utf-8?B?SVNERzNhQmt5QzRnQ3JxQkRnRGdONkIrR0tjR1lMZUFZUnlaMFU5WWhIa0p4?=
 =?utf-8?B?YW5mV3hRTTYranZ6cUF4cVkwUXhYYWxoaUJEd2J1RkhIc3RHUnZUcVROUW5n?=
 =?utf-8?B?N3F0c3BxcTVyMmV5RjZXcGlLTFZLUkNKOXNwcWJGN214dDJrM0VPclBSZzBN?=
 =?utf-8?B?VWZQeVdMVGpVL25qaitjV2xLTFYrWlZqQktodTFsUFE2c2JuQ0pqaDl4SWx6?=
 =?utf-8?B?UnpSWkR6cUdGNGo0cW9BcHByUnVSVDI0N3Q4TXl1ZTFIT3czZFJkTklVaUhN?=
 =?utf-8?B?dWZpdWQ1Mk5DZTFjd3kyTUFJRE9VS1ZQNFlNKzY3cE1FREhXRDNoNUxSaEZJ?=
 =?utf-8?B?N3ZCeE40a3V6UFhPRWYwdVN2a3kwMTU5NGFnTGM3WXJsTWxiS2FTL0tTTUIx?=
 =?utf-8?B?MElWMUdxVjN1enRHSEUyNlY2dFZ5UEVHRVlFRWZvSTZnd2lpQXpyUDg4dVZG?=
 =?utf-8?B?eDFLWkErUWZYcUl1UTVFMEtPQnFLbjVMVXVKMUdLTUllVFVQak1IWFgwQXhm?=
 =?utf-8?Q?cB7lundLN/vTZs+c7Q2D7SkPoIdOjx+KZz/JVNSQ9gFe?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5daf183a-6d80-44d4-ec89-08dbd963b1ab
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 16:17:21.1775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SQLgfPyGaaIDPqMMf+3B0ZJYrtw3z+1CCis+T/fu3S7rjq8ohoF9HjK2mXeCTZfbiRGOIIFbmst3g5sm//SCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9754



On 30.10.23 г. 18:07 ч., Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Nikolay Borisov wrote:
>> Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as
> 
> superfluous
> 
> But this intro is actively misleading.  The double-underscore variant most definitely
> isn't superfluous, e.g. it eliminates the need for gotos reduces the probability
> of incorrect error codes, bugs in the error handling, etc.  It _becomes_ superflous
> after switching to guard(mutex).
> 
> IMO, this is one of the instances where the "problem, then solution" appoach is
> counter-productive.  If there are no objections, I'll massage the change log to
> the below when applying (for 6.8, in a few weeks).
> 
>    Use the recently introduced guard(mutex) infrastructure acquire and
>    automatically release vendor_module_lock when the guard goes out of scope.
>    Drop the inner __kvm_x86_vendor_init(), its sole purpose was to simplify
>    releasing vendor_module_lock in error paths.
> 
>    No functional change intended.

Thanks, I'm fine with this changelog.

> 
>> the the underscore version doesn't have any other callers.
>>
>> Instead, use the newly added cleanup infrastructure to ensure that
>> kvm_x86_vendor_init() holds the vendor_module_lock throughout its
>> exectuion and that in case of error in the middle it's released. No
>> functional changes.
> 

