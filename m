Return-Path: <kvm+bounces-6072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A4C82AD94
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F182A1C23476
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 11:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942E2156F4;
	Thu, 11 Jan 2024 11:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="YQYjAlT0"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409A16439
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.19.56])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id DD56A10CBB641;
	Thu, 11 Jan 2024 11:32:21 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id C64E510000951;
	Thu, 11 Jan 2024 11:32:13 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1704972732.759000
X-TM-MAIL-UUID: d0cff788-5a05-4cee-9f45-92795e46d5f4
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id B97D310000318;
	Thu, 11 Jan 2024 11:32:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXhJBST69fEc4MZdzz1Llzz3x2W/OAaqYqeOBLGtnq/jc9/mz1CyGZxe1fWpjPLJRIgLt8Tf0MQuwxPS9vqkA5I3sUWquOsuSkGYy7Lcvpq6F5ukUZm5d8mMV8L9kcxKIPJxCwaxDXpdo2gZtmcYcJx/wclfCo+72Dwfhqch/WR1sHbXwflmXNcsxxijECr2fAP7Bcy1LUAa/2Xt7hHh5AdX0kbCdWbZJziv1OfHRYEkAfblLb6gV14MuxDsO4IZGm6eVe7Og96tsCzAcNuHwuvrtF3/SdM/RK9/2ShyWdA1OElSjZnv5GPWTsACYEGuRsICEhSI+NKVQwi/mzmoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGOO7Xl7O/XphM/c0jlLv1sk25ZMgG0QYDDsieubI/Y=;
 b=PmNRKTBcsx86e4BTPzalOfre+KeCixWL+VuiLIzIuAl+Cfxtff6Ti4CVhQOhfk4iL3WPM5xeDFenteNwdMeXA88Ew63HbPzk7rcDLPADUROV5rDBzow727qL+I5z2U22Q3cAiVNr7+9xeaX+MnOCJNVggOaQLEeHvqB5s41Oefi/M6g/o3/ZLzgiDyFE4adnZK/1a2Nsa836lCguaP7sAUF+Nr2hrulmMf+llsOtrZ/8G3Na/whdeWMeuied0eBga2W0tPVwEL/O7GCTCkg2BVxAEffPOPkgtBnRPHHKC36nDKt0H3aBeG6ZVW4lb+j++IobUc4ZDNUgikn/2t457w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <97c53faf-2eeb-43e7-a146-b53da8ea14c2@opensynergy.com>
Date: Thu, 11 Jan 2024 12:32:09 +0100
From: Peter Hilber <peter.hilber@opensynergy.com>
Subject: Re: [RFC PATCH v2 3/7] x86/kvm, ptp/kvm: Add clocksource ID, set
 system_counterval_t.cs_id
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
 "D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, jstultz@google.com,
 giometti@enneenne.com, corbet@lwn.net, "Dong, Eddie" <eddie.dong@intel.com>,
 "Hall, Christopher S" <christopher.s.hall@intel.com>,
 Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Richard Cochran <richardcochran@gmail.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
 <20231215220612.173603-4-peter.hilber@opensynergy.com>
 <ZYAdpPfFa2jlmZ44@smile.fi.intel.com>
Content-Language: en-US
Autocrypt: addr=peter.hilber@opensynergy.com; keydata=
 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
In-Reply-To: <ZYAdpPfFa2jlmZ44@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0042.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::12) To BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:77::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB3267:EE_|BEVP281MB3569:EE_
X-MS-Office365-Filtering-Correlation-Id: bacb97ab-69b2-4576-e09b-08dc1298f378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fWQ43VhpOiWp5Cu90HRAwvOkGIZF2zKYbWhytwSK9PtDFKu4GMR9Os7xWeZ8sonexoWBKGiy0lBZduIrllZdNxfBbqMUEd8oln3LzENTogNzDdKCfptMe/mc4rxNCuUrPpx7QTpB7QmnJGuDL2UFgNfAZJh9IllLqxWqqh66QkIGmev2Y/YR7XvF6af8Kw8Y192QSLhCCw2Xs5+ol04wfrpc+qoj4lAtxDxWr5SzTxPlsTW3OGLG2vsLPtSdWSNhRCJT1J8mPtUw+f8d1B0o4upZGpnKWMCks20pm+bkqdYf+3TKAVzxFCkXaXjaLtu8YZYdSTYabEsSw2BVgsg+46c9XaZaoTPltarql3Isj/Vvc1QKNOeTJQgt/eLY7W+JTs/QRUHfd5EKRlyo8Gl2/J6tn28TGoM9mpjFP3dt88UWiBBEKzR9f7jQqC0BqK+aT3eC7nnKgyudd1JN/3OKNp+jIfTz+BWxNFq7hjo60Jxrpo2LZ7YbF/lXxRa9lP5k5TDPI+Lpw6Y/OQGMQRuN61/ZzwIaAfgbCZ3z6uogk3eydtymK5rMeKDWyaJFCHoqas77zRd11aDhCwJLcqrUwkybMQlgfZ8+7mPaD9jpDuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39840400004)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(83380400001)(31696002)(53546011)(478600001)(2616005)(26005)(41300700001)(4326008)(8676002)(8936002)(44832011)(86362001)(38100700002)(2906002)(7416002)(31686004)(36756003)(5660300002)(316002)(6916009)(42186006)(54906003)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlltSUhTTmY1SjlFUkowaFA3enM2MFVrU1JuR0craXdmTVIyTWVNeVM0ZEZv?=
 =?utf-8?B?cHpmY0swZ1hCZGdablRURGRubGdJTGFjYmpNaERabFlyQXFtRi80MFNncFY3?=
 =?utf-8?B?ait5NmRRZnhhbm8rOW9mZkw2TkpSbm1uSHdqcm1XVWpjZ1lRWXppR2g4b1gx?=
 =?utf-8?B?UGxMRVhuaEFnZUlKMDZ1N3lCMDhEWUsrdXJoNVhrOHhOWUxyMUZpanBZV2dv?=
 =?utf-8?B?UW1mN3UxcTByZzhycHZ1d01veVJSWXhNZWpIZ2dvYnB0ZlREcW4xMW1TYm5R?=
 =?utf-8?B?SmhxYVRyMGhydEFRMkplekZYa2UyV08zT0szVFEzODJ6TjcvTU92YmtBbmxK?=
 =?utf-8?B?c0o5eVM2RHg0Rjl2VEFodFFtenpHVnRpdTZVNUZmWkZpRlFRQjZYMDBQQWdj?=
 =?utf-8?B?YStlNDBKVWNiS2RMM1RaT0RNRHhDUDVNQi9LN1g2YWlKNlNSenNlVGwxam45?=
 =?utf-8?B?Rk5xVytvMnBjTWFMaFFZN3NZNWs1dEdydVdXQUNGazg5a29ZeGEvUE5WYzlY?=
 =?utf-8?B?WTJNR2p5M3lKWTRuQ2ZqYU40Z3kwcXNESWwrTk0zNG1IcVkxeURwT2FNNE5v?=
 =?utf-8?B?OU4vZ2tSZjJlb2hobmJFZzJFUzk3VldEUXk0QXYwVE8wbVNhaU9KK2hlejlU?=
 =?utf-8?B?Q01RSHlONGFWWC85UkhwbjRvcktEc3JobENhUU5UK1RqNzZLTklYbG9HN3Np?=
 =?utf-8?B?c2IrU1BDKzlQR3pJclNoT1ZYZmtReVduckc2MGtoeGpnZE1yM3FKek40UHAv?=
 =?utf-8?B?ZmNaelZjcEE0SG9CZldMak11MU1NaTVuOFhDaVhYL2dxTlN5T2VDRmVTRlhH?=
 =?utf-8?B?VzNWcmdSaWtPQUVhSzYvSmF6Vk9TK0d3Kzd4ZXVoOXpReHA2cXZsc1ZrS210?=
 =?utf-8?B?MXNKOXdzUlFWaE1ENkx3MGxFUHZ6eDhsdkNJZkRtTlBYUlNDWlZ1OERHb1Nj?=
 =?utf-8?B?RldKV2tqdGdiYjVVYzUzWG5xMHFDSTRkVDgyUVBEYkpubWI1bmhtbHFTWmc0?=
 =?utf-8?B?eUJYbUR6cHAyYlNZNkdpd1JIOFFhQ2ZyR3duaWkzWHl2OEpRV2VUeU5SSSty?=
 =?utf-8?B?OWMvTkpLWkVDQ1poTWk3V1U3cVJOaUhWM0Eyb2hoSkdPK0syRDdsQmc5dEl2?=
 =?utf-8?B?azRDOGtoL1FHTHhkTVRaMjl4bktlb3RsdzBMZW1INkx2UXl1MHBkMnZ1MHdx?=
 =?utf-8?B?Yk5Sbjlsb3ZSTzRYalRzQVhNc2k2NnJBZ2ZBZDN1aUdPcS9Ma1ZpZHZjWEd3?=
 =?utf-8?B?d2IweURUcHNLSTFURzBocDkvcWlCQUZ0a0owWmp1ODdIekVORzg5Y2hNT3hM?=
 =?utf-8?B?eU80UWdOc1dRakM4ck4xeUhmT2g3cHdFTEtwREF3ZG1laS9JbFpVVG12S253?=
 =?utf-8?B?WXM1dGR6SjBPWk1Sc1lRWDFWamREV0ZveStnU1ZUMVEyUFRWZ08rcXNTN2tp?=
 =?utf-8?B?cnYweTlpSFFFbFhVRk9NYUZLb2Y0ZzVaaHdMWmFGK1dPRERLN0QwZi9QRW56?=
 =?utf-8?B?SENWUGhpU2NIQ0FGMVBrTnBiK3pkWUJQdmxwcVBhRzZGNkJ2V2xNMzd6dkFI?=
 =?utf-8?B?WFlteDBiYWt6TUxXOHZVK05VZkFZQ285cVVncWVNZ1E4ZktNcDRma20weHNt?=
 =?utf-8?B?UU1UWUhLdkdIcEYvMXJ3eGVZYzVQb3h4TU9FcTI0VXZHblJYaC8xMjNtMzdk?=
 =?utf-8?B?bDBvNjVjUlRqZ2IzT25zUmFwdVU0T2swc3RUekNnZW1nMUZMUlhvRXhaRGoz?=
 =?utf-8?B?N0pFRHY3cGJhQ09NTEpWaVExTjRHT1VxZ3E5aVZRU2tlVG1LSGZST0FsSFUz?=
 =?utf-8?B?RmxXVGVqbGN2VGZYaFFBRHhZaGlqY2hmdFhtMVFCK3poMUEySGZMR1FVTkNC?=
 =?utf-8?B?SDNpQ2EvVXIwdmhNM2FJRVYzY1NTeFV3ZURQZGVlSWY4c3dRbnNsMFBhNGFz?=
 =?utf-8?B?MlFMNHhmcFQ1ZFFOZ1RoOVF3VlAwWkc4eGtxU0s4c216REtIZXVVY2xmOU9k?=
 =?utf-8?B?a0gwWHhBZkd2N1FDT3BpMm90MWM0VUtEZGZ6Q1owMWNhQ2RNS3UrM1NMb2d2?=
 =?utf-8?B?aTN3ZTZEMHlUOFRMczRlMHA2aFYzS0YzVHpCVTQ2MkU1MGpRNlJVZnZvYUli?=
 =?utf-8?Q?sYkL9w2LjvUydc/4rJ7fGnGgW?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bacb97ab-69b2-4576-e09b-08dc1298f378
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 11:32:11.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOkSSMI7F/ys/sy9o7wtrVmsH9q9sBws4+WYiWUd4f9n5zzMbVplJgJf0NmWPqaFJWjE3By/NvthGL+5vc7ibg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEVP281MB3569
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28112.006
X-TMASE-Result: 10--6.754200-4.000000
X-TMASE-MatchedRID: zGP2F0O7j/v5ETspAEX/ngw4DIWv1jSVbU+XbFYs1xLtLmKv+xcD1YHs
	r+Lk3p/gC2QDPheido9iBl6ePEpdZRIModjUeZCSiHUmvUOLMwX2dS5FWFU6LsYppFvP5T5CUo0
	7kZMcJurqUJy7ghq44IOamxs197YArFT8/8buivWSHQtEOSQwHPhwJOI9xff0aWT+OhT1YFFPQF
	Fk0j5jBsA2iDfbpfy+jX3M0aFmhUOwz/eb2SjfKGB6KL0WmlgVXFAIRSIiEKJxg7svMtapLmspz
	GEY2FM+ZDDVZwtwCCzhSU284lmHb0vU4MkBkIL19YzNdaonZeA=
X-TMASE-XGENCLOUD: 9fe72cc4-4976-4983-9d62-fcb15f3b14ad-0-0-200-0
X-TM-Deliver-Signature: DF442A7D045259E13B961E4ADC7EE8ED
X-TM-Addin-Auth: pq3sHyz+MuhDPjJXIZiK0MFY5ybrydV/xu1JsAEoHC8gWPQT5xklx+qSMnK
	ECQ2r+IcMmIKKQYWShAsjPd8I4OLumTPUv4Thqa2cYOPCnZq1Hr8W5CrVBfYv92iUcy3IhikuIR
	JAMuOnC1rb7QvWdYQzpyqj1En6P7CESFdwtPYmlN2I6dsZsEFZ+8+rWetReYKy9gDK2EmCVNJS6
	Qpb0fszy1dRNVWv+KgjLCzKl8pvGPiyL3dpWYDWRzDk2Wf6mA26NMwA7AW9TXoqe0dB2byHDdMl
	yHBNU7fzcuHaH0c=.LrFOj08vFg05VZqX1AFN/mULmHBEWFmUoQ+x4EkGsMpllF4bduzvxs8+89
	NUDGhw/uqyIs/7Ns7d5QpoXyFQ194Dg7ZIXcy5z9fDlS2B3nVwFiv+5ecoTwQy7lSxVUPdShRmW
	K0hUbKF5mknso3BRj9TrIe79x2Jjlm6GFT27O1ir5hWyH6HdzjbSK6OUbr1bst+DiC3JG6AfzGT
	wtCb4k7S45RKaqhcEx4fCO0HdDEuV3+vEWqyTR8L4g+gGjnZz8FhsVEIKkcQOFL03m1K1IreoXH
	js4t4TcSD52bSjVkCUwI5l01mu8DXdaQWr6Buc6IKl7z/xzs1DR6nXJUU9Q==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1704972733;
	bh=0bKxh4Rwn8dh6cAE+Jo1d2BYfdyVGfyJ2bQ7zTCUuEs=; l=1129;
	h=Date:From:To;
	b=YQYjAlT0FBygM9z38TdcgC0u+nIObDKTzrvfeH/Fa/KNqBQPuSxvONtA6jqgy6TAw
	 GLGzuw8//pTS0hMAwLvPp0vTaBe/6BURi53gPvpyRoRADj3wUqS4KS/vxKNuk1eUbA
	 mFnqOVklTFI9/Hze1gOlRQSAWeTfz0I1mIhj52idYkDgVwlSv0pAWRuTGY3JiNr0Bk
	 H/SRcmNZZJ17AnkY+Ch+pvbNVgZy6ryJnLTgUv7Rh+58AyQdfur4UKfOu0IEOyogY1
	 ++KwhadmYnpvZgtUhyN8L0ozGku+NehjjA+v8qMNbrTlbNqciOnK17NA7MRpr5xquu
	 Uyr6z7PjpF9Zg==

On 18.12.23 11:23, Andy Shevchenko wrote:
> On Fri, Dec 15, 2023 at 11:06:08PM +0100, Peter Hilber wrote:
>> Add a clocksource ID for the x86 kvmclock.
>>
>> Also, for ptp_kvm, set the recently added struct system_counterval_t member
>> cs_id to the clocksource ID (x86 kvmclock or Arm Generic Timer). In the
>> future, this will keep get_device_system_crosststamp() working, when it
>> will compare the clocksource id in struct system_counterval_t, rather than
>> the clocksource.
>>
>> For now, to avoid touching too many subsystems at once, extract the
>> clocksource ID from the clocksource. The clocksource dereference will be
>> removed in the following.
> 
> ...
> 
>>  #include <linux/clocksource.h>
>> +#include <linux/clocksource_ids.h>
> 
> It's the second file that includes both.
> 
> I'm just wondering if it makes sense to always (?) include the latter into
> the former.
> 

Actually, clocksource.h already includes clocksource_ids.h, always since
the latter was created. So I'll just omit the unnecessary clocksource_ids.h
includes in other files.

Thanks for the comment,

Peter

