Return-Path: <kvm+bounces-6073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B249A82ADAA
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47E07283CD8
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 11:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A43154BF;
	Thu, 11 Jan 2024 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="YuM4JmWf"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030D1EEDB
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.10.134])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 7C2E3101CE76F;
	Thu, 11 Jan 2024 11:35:08 +0000 (UTC)
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.165.80])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 1BEF810001FC1;
	Thu, 11 Jan 2024 11:35:01 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1704972900.518000
X-TM-MAIL-UUID: e2589c17-a7a0-496b-8fe4-d2ccfd8d5875
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 7E9CA10000E54;
	Thu, 11 Jan 2024 11:35:00 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5/8ByuaM4RRmY+mLSSVBD9raS9j/cE2Ei7TrDwvnmYGbwhReshKD0Op0URwH9W0pKDz3SUqV5GNj2k1gwhzQiX3qty65KxRkWn0JMAAYNFl8Evj5BpXWwA23HV2uyN2/967YVCsptgsTemPOOBCVmHONWtSeefM3yK8/liUNP0c+g4jGAw2fHIH8f9IW+NJgS0+tRi3xoVffhqSTItqiWzJ0+GW8953d5au1zZWtzlZ/C3du33MzFTQHImHr26bbMp1i+/Ek2mCEU8nOnQwaeQoEAe5lP3pMj3eNSmPrRI2IbjGBE62NREpbVwWA4CIMqL2TCfBSVLFQ/FAgVBZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJfbe+QLg7WEQ5j2KCoXWBewKp+g+yPqTxXDxqwPDDQ=;
 b=Gj/b1kcgugq/hvAJnMadGzVXh5h6IAbmcu1BJuKkY+B/m+uk1Enh6mQLMPtrud/0OT7SxzDTAj6etvRpn6rg7KE6DMePu9mD2COXuExXOsK0QdLGW5c6JEzd/LRyn2gGY52QL68o+rtFUQaP9sK9TmbsBNp4KIY7OluT6R1LRZ8igZrZrUR3P3zte6bF0q+FzuX1HH6xglOxgSb4aSH5Yyrmz9mNX5XuteL/Y5vl/wza3FjS1cknl1ovfWAyRnW2v+LnILfX+eK4OD0KK94wJ0BJXD53gq15KEgg/j19pkGXYjTU13u23WbW1wOBvw+L2sDAvp4VjH51TKzsso8cxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <03b8e9d3-ef57-4883-b02c-94b003398b61@opensynergy.com>
Date: Thu, 11 Jan 2024 12:34:57 +0100
From: Peter Hilber <peter.hilber@opensynergy.com>
Subject: Re: [RFC PATCH v2 2/7] x86/tsc: Add clocksource ID, set
 system_counterval_t.cs_id
To: Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org,
 "D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, jstultz@google.com,
 giometti@enneenne.com, corbet@lwn.net, andriy.shevchenko@linux.intel.com,
 "Dong, Eddie" <eddie.dong@intel.com>,
 "Hall, Christopher S" <christopher.s.hall@intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Richard Cochran <richardcochran@gmail.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
 <20231215220612.173603-3-peter.hilber@opensynergy.com>
 <20231224162709.GA230301@kernel.org>
Content-Language: en-US
Autocrypt: addr=peter.hilber@opensynergy.com; keydata=
 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
In-Reply-To: <20231224162709.GA230301@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::15) To BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:77::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB3267:EE_|FR3P281MB2252:EE_
X-MS-Office365-Filtering-Correlation-Id: 41aff268-be22-44c7-e2c2-08dc129957e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tbQAPoC7DcA0i+OcZcXP0dT/fHg1xtAxduQ26y8Bdf9HLyUlC3MY7dDQFMLALyo5erMgn2GR2t5WLB47RwwzbMGlnZwufdNsF7eJUqBWPuWqRPtJkVKa2aWVS3DEz/dgxlSf/u7pO3vGwbFJTydMLZOh5DIOjaXUonOil40JW8JpkvixDewp0CZ7VHVJzsHmwQB9amqNrr9R321pG4CXVZA8f9P1OLQL9y3P30biBPiR+HsS/dy4K41OU+5JcxvLAuTRNwG2/nGHEmlk+/oTdSeTybfZ3uJfG9FfVkd1DqbqT0rtiWsrky4HUd9icFR47ZAy8Hg7hIQ/6Tbz8NWSVlK//sfir7PFUskiqzRxbbwnN6kVQEm9+bGSC0ioyO5i1oAEYWt3AJn5TwcsQfkhBWw0SXcGco+d/Z7Ox/ayYRoBCyRwyEPicLDn+iUtTcqGUR92D3Gnd2mTrXI3fqCWBmfVcGBVfL6tvYCVWgrB7PSxpjwFyW72BshnqvWLwqT2rif4zavJihU9X5GHnTMithMCKR9qNlOg1U8i30UVHJNnitQE8wWEVH5FP4CpcGJDG6zOBJTQDulhoQCMnyrG+QFc/Sd+YNdze3RBLyWEbPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39840400004)(396003)(366004)(346002)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(316002)(8676002)(8936002)(2906002)(7416002)(5660300002)(38100700002)(44832011)(4326008)(31686004)(83380400001)(2616005)(478600001)(26005)(53546011)(66476007)(41300700001)(66946007)(66556008)(6916009)(86362001)(31696002)(42186006)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVhXbnhreHlkTHFwRXQ2Y2pOR3pZTTc0SlBSMkdjTVRha2lIeFk1MDZHTlZw?=
 =?utf-8?B?eEpIZ2dyMDBCVXNoajBBTldRWUpMYzJiaHJYeDU1NlBZaGJ2WjhFc2ZSMFF6?=
 =?utf-8?B?czdqeVJvc3J5ekQvd1FBOEx0TVJsUHpsVU0zRE5kUml2Z2JNVEZPTmFmOXFn?=
 =?utf-8?B?RzZxMjZ6bWZ5UXVCa0p2d082cXZLYVk0djVsQ1M4UTJBcUphbHFKM1hFcFNJ?=
 =?utf-8?B?TEluU2VkWXVYdCtieGQxUnVaZ3VYaWN4ek5nMWhkUVVFYk9QSXljOGFnM3Ew?=
 =?utf-8?B?dGJuUERxMEhYaWtmMy9zeXlsVGppTGhlVy9oUGhYTDI3NFcvMXk5TWlSSmVx?=
 =?utf-8?B?TXUyaldJMjhaTmdWbXRCQ0FwRWt1MkRLM2ZadDRYc2V0S25CTmZxSmtlRmZ1?=
 =?utf-8?B?cEh6WFE2bEJ3bGhBQUZSaThlcDhMcHZlRCsxd3Y1ZUVYRkYwRVZ5NlB4MldL?=
 =?utf-8?B?SnF4ckNWTnpzbWxDZUk5Tm42eURFK1pkaG9UNi9CaW9ubUZMZEhrY2lKL2Fm?=
 =?utf-8?B?WG1QKzhEUFRNT2lRampiaE1ScmtYZVpWOFFVaCtoUElhTHgwbDlTejF0eHpS?=
 =?utf-8?B?ek9xa01EQTRmZ0NLWG5ad0xLNlp2ZGZkOUgyakJDemdJZDcwZk9LYVAzczdo?=
 =?utf-8?B?Q29Dd1Y4UkVjK2tzR1dHK25zZThJVnZpTVZ3bzBqT0UxRGhoZUdnSkM5K1dz?=
 =?utf-8?B?dWYwaUl4b0JjaW80ZjdBaS9VeDdkYWlLT2RzQ2NrdDgzaHRWKzVEOHRIdUZx?=
 =?utf-8?B?dzhaNnhHR3Q3eUtvZlVjb3lyMXhyWEttMGk5SDZpaVQ0RDEyYUtQbG1OWWwx?=
 =?utf-8?B?K0hpYWpEdEpxM3FVM1BURG9FQTVQN3lNZ25ybnRkSnVLaUtHQzRnOFFNeFVU?=
 =?utf-8?B?dk03VDNnSWU2NGtCUDAraWNkSWNDcmdLQ3FxSUpLVmtnM2RVT3crWWF6a2Y5?=
 =?utf-8?B?bVhaNzFtR1Y4eTd6d0prY3p6YWhDZDUvVEdGL280a3BwL0JnRUk2aUlDZ3lZ?=
 =?utf-8?B?aVY0cWR4SUsxeFZUV2s4aXhsb2E2aTZNQ2YzYkphbGQzVUtxVkNIenFHeU1F?=
 =?utf-8?B?Z2VJUHZKeDFlN1lrNUliVWlHYjZzQ09NN2RlWkJNYmN5NTBCbm5zaEpXdkZa?=
 =?utf-8?B?VTNueFd3OU5ZREpaOTdDY3pvNmxvUitJR3pRdWRLVEwrYmFLN3pIQTJ0Z3RZ?=
 =?utf-8?B?ZjRZd0pxU0NrNzlSNXBoNUJsdkM4V2hEUkRSaUVONGpYZDNKb3pjMjh6K3dh?=
 =?utf-8?B?WERZQm5RL09rZStrRXZxdk01WUtETkhmUUNhUVl4UHhCSEswcDZ0eXBVVmlw?=
 =?utf-8?B?N3VaSEpUQ2V4ZkFDSisxeHBZc0xsblRpb0g0N2k2eUNKMmdSckxMcmUvczB1?=
 =?utf-8?B?ZHZQTU15SmhpVkoxMUk5MXVDUWxqaXdRRlVRL2ljeCt2ajNEbVNGWkNDanUw?=
 =?utf-8?B?UnBnUWkrWVNrSUtKZFpXQnJnR0xoL3hndXI5dkVuYWM0bnZhL0Y5T0VscjV2?=
 =?utf-8?B?YVBLNWVROHRJWFRoRkZ1dkdQaytxbVc0VHJmS01Lb3pTVS9PSithRmJDWXFo?=
 =?utf-8?B?am9qUHNiMGV0RXVBMW1kWmdRdXBXdGxZWDk5eGtaRm1KaDRHYUE1YWpGSmFX?=
 =?utf-8?B?VmYvWXZWZnhCbGtvemlySlJ3aXlGaFg3MkxOUmhhYnEzOTg4ODNUd2JuNklv?=
 =?utf-8?B?ZXQ3UndqZ0p0SjJacTNQdHBlaTNmMkJqNlZqcUpNYk41Y0M2YVQ1WTdkeU8r?=
 =?utf-8?B?YUs1NDl1SUVTWWVZUDV4MmtVQXRIMnNCVW9JOWZaYXdsZW40YXdQOUpIaVlV?=
 =?utf-8?B?cHVUTzRhdlQwalJnaEgzUkVPczRsd054VXFoVitZYzhMV2Z4T0swbUtwNGpj?=
 =?utf-8?B?aEdSaDJyK3dFclorMGlRc0djNnNibm9WeFlYV01QdElpSi8wbUcwRE96TlVl?=
 =?utf-8?B?cUdxTWVaQU1nWjB0eFFWRGhKL2ZwRDllYmh5TjBJNU9rYmF4c3NKcm1LekVF?=
 =?utf-8?B?WGRlMlVQTXJLY3gyWW1Qa3BFY3NPZzg1eC9WdTZvOXl5S3NsYmRSSk5tMmM5?=
 =?utf-8?B?VjI5ckpZQm9wTXBzejdjbEN2eWZEZjhFN3MxQ0lpdytsL2dFZUZBVjRrbTJk?=
 =?utf-8?Q?TEfpXkLBFSsARanSl0neifrRW?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41aff268-be22-44c7-e2c2-08dc129957e5
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 11:34:59.5041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QR0eqdOmKY/+zLv6f/NO1WBQBHbPRuz/GEtIlfAVFKOmdMH2TMKsCI/1O9dQVSSozTTYG9uatRZ5OvPPITaOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB2252
X-TM-AS-ERS: 104.47.11.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28112.006
X-TMASE-Result: 10--19.927500-4.000000
X-TMASE-MatchedRID: hls5oAVArl/5ETspAEX/ngw4DIWv1jSVbU+XbFYs1xK9i+/f9tLGG9T8
	nzhI7jct08q4PMUbAPinyNbHJWoNRSbbwRdGbc5Ehi2C7dlNKWoSRRLwSueD2gHzrV7k27Q/P1b
	i6L5FWkPf3jJm6h2Ae5uIb9c3VdbGmisT+ybs5MYI1pqhes/vCcEYnQj44hfD86dFkmAkYZ+ECn
	xZMJxvURqoqV74MuLyPkO5+0gZtdsM177w97hxZmwEEr52PwDFm5eMQpabFXYhkL0gCMh6Ds+c7
	BOZ9lQf31w1NnIhFDLCoxkUJ0PNYWiJ+5GHGsyDJPlTeUnhPwqs0m4CN4NCDVo7GmCOJYd1AqYB
	E3k9Mpw=
X-TMASE-XGENCLOUD: 49bc9f4c-0eb1-4a58-b079-7d4ed6cb64c6-0-0-200-0
X-TM-Deliver-Signature: 74113D733E3B975245E7D4B75044E1C8
X-TM-Addin-Auth: Xk7WKXqnBn1/Y+8jl1AOGBP9KgPVZrLdC2d9+GIrP6Fgoe6DkztInLjsm0g
	ISfth25SzfbRedBKRZj3phNL6nlW/XtyUu275rfqGyjQ6uH2mM8ff7YFyvReOj/a8V4Coqs0Czc
	oNmTWUWZhiScrdx0N+PTzn51KfCL9/4i7jW++qMWtSFS0KEeFqY2O7mgJZksRB37nQjyJc6oStT
	e6WohBq3VyB9pHkhvKAPmBWegcPu0glqa+RKEVRriGiLZX1BGhy+0OMH9kl+xg0+hIF+symmHDi
	O71V7F5V4bxNaX8=.F2DcIaIW9hEWHO8iAPI4p1W0L5uXtVGLXjRiwSXj9gnImF57fPGAhm9ROy
	rTMroWsnLKamR7AuVgSYdx/PpiLb9EsCmGThumEnO36zaVj0gzDdngrfNQg08v3AEC91J8qK7BX
	hIMdxb3ydF5fHlmn/PmNCGYrjxAXodWajQZyUB9k5bnft6x+aIDCgIA/QGxtRgp2D/OFerkVjLg
	eyMFuIiaNcplTG6C1j2/u66/7MsVZKptGACGQUywsGgWXSISFI+se56tF+RgwWq4nF7O2Fnie3/
	ANgeOPd9jITBgnvLoynEC5u9rKKYEgAQuewY9jOKbCNOTzpEi2TQ3pjQQig==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1704972900;
	bh=eW+fpyWlizLYaNIzPsjX8SDD0TLigdxu7I2fvM0OzlI=; l=2533;
	h=Date:From:To;
	b=YuM4JmWfmZUSW/R0Mpa2WnlCRSC/ZbHvM4hPbLd0hdmBhzbuuMstL2lYn98Ylvx5b
	 qrb/agEkjwSOL/c3So01eIyiNx7prAKxvubS8uoHRupMDlslYKFVGikPXlShasTmjk
	 9xVCmJn9dw0Kd2aa7CGpf7c7yutJYwBPJYv+5pTZ8uzYEPHg0ddbZfudp4fqmYMSAX
	 CRUXlbLecSHBPuvfa9fwZeylO7hwpCZiSpP0t4A2ynSgzru8m0tQ6vvsWaY9wUnLrM
	 lg+4yyNnklvfHFLLQ6rfkIRFrbB0aag0NpNN++Rl45cI5Rj26rlDjanXldekc+FdtQ
	 U2DKEWhYtlIaQ==

On 24.12.23 17:27, Simon Horman wrote:
> On Fri, Dec 15, 2023 at 11:06:07PM +0100, Peter Hilber wrote:
>> Add a clocksource ID for TSC and a distinct one for the early TSC.
>>
>> Use distinct IDs for TSC and early TSC, since those also have distinct
>> clocksource structs. This should help to keep existing semantics when
>> comparing clocksources.
>>
>> Also, set the recently added struct system_counterval_t member cs_id to the
>> TSC ID in the cases where the clocksource member is being set to the TSC
>> clocksource. In the future, this will keep get_device_system_crosststamp()
>> working, when it will compare the clocksource id in struct
>> system_counterval_t, rather than the clocksource.
>>
>> For the x86 ART related code, system_counterval_t.cs == NULL corresponds to
>> system_counterval_t.cs_id == CSID_GENERIC (0).
>>
>> Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
> 
> Hi Peter,
> 
> some minor feedback from my side that you may consider for
> a future revision.
> 
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> 
> ...
> 
>> @@ -1327,12 +1334,15 @@ EXPORT_SYMBOL(convert_art_to_tsc);
>>   * that this flag is set before conversion to TSC is attempted.
>>   *
>>   * Return:
>> - * struct system_counterval_t - system counter value with the pointer to the
>> + * struct system_counterval_t - system counter value with the ID of the
>>   *	corresponding clocksource
>>   *	@cycles:	System counter value
>>   *	@cs:		Clocksource corresponding to system counter value. Used
>>   *			by timekeeping code to verify comparability of two cycle
>>   *			values.
>> + *	@cs_id:		Clocksource ID corresponding to system counter value.
>> + *			Used by timekeeping code to verify comparability of two
>> + *			cycle values.
> 
> None of the documented parameters to convert_art_ns_to_tsc() above
> correspond to the parameters of convert_art_ns_to_tsc() below.
> 
> I would suggest a separate patch to address this.
> And dropping this hunk from this patch.
> 

In the quoted documentation, @cycles, @cs and @cs_id document members of
the return type struct system_counterval_t (not parameters). I will just
drop the members documentation, since they are documented at the struct
definition site anyway.

> The same patch that corrects the kernel doc for convert_art_ns_to_tsc()
> could also correct the kernel doc for tsc_refine_calibration_work()
> by documenting it's work parameter.
> 

OK.

Thanks for the comments,

Peter

