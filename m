Return-Path: <kvm+bounces-71951-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EC3OHJAWoGlifgQAu9opvQ
	(envelope-from <kvm+bounces-71951-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:46:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A791A3B38
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D35E230095EC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D45C313E32;
	Thu, 26 Feb 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="oAK/OIqi"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012048.outbound.protection.outlook.com [52.103.66.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D53C1885A5;
	Thu, 26 Feb 2026 09:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772099206; cv=fail; b=H1Tj4oAo6I/Zkkpj6twcFMUaw2kttXs2n/UkNXtBfsnZ8XugZVSwjOSCppBXn3yf1fBoReie0sPCX7RcDQt9kSMyvJvnYzwO883qAYSlYmKhFTUwxxqA6d8uSGSS2kWPKATkbCX15gKxGleimDVsTiZTxa7SqzfvYL1QKKeUhy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772099206; c=relaxed/simple;
	bh=0LhcIkFLJAEwPVXEqrNwsJQ5bHej9BnOIKrFfTLV5GA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MfRjmk01HPzBkGV79Vh0cMPJdX08Yp2mPv85iiDOIfomQJ+tVQXx+O2DybvpF9BWLqbNMgZ3SGo1kxgGdg35uZl5ajjyc0Vxswv6hBfe1Dx5hlv8oQL59mfWvKlg8FU0Bdw0PtOnHF3+avoYKps01hAmf6GREXbB2QSZrTgslL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=oAK/OIqi; arc=fail smtp.client-ip=52.103.66.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uivdc3KOPnN4IXuZXN1sjIaNsny72hNRVihE/bXpZXFlmqQWV/d6okcgLFCM/TwcjB6fm7yKAcJ1MBPlga/UmdrcV3aECHLtECHRJo/kVFlyJaDQmtNxM29YZ1eGYg/WNblZpy01whDWBiKnRk0YnyXEXWuayR0H18r1dk/SBd7SZXva45e+r4VEDv0yMuWxrqi0oyRq+yvy18z10HVjAXRQHp1FUl/zQLHNCKJEeEJ9vL68kp+jI/VWBcyGb9LbhavNjPNmYyXikFbrJLoxWD15cnO6DHXtoDdnrDSkYfU4q2SWnXu+AdpBfefTfXpSDitQWroSOx/KIUD+4ukWeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoYpyFo/K50tNuvgj6SKBH3RrQLtjI2yBLhe0KwabEs=;
 b=Ij8uyFIRxd0/ZGcJIsOE3YRqoBNBBDpijGtHvyd72Uem0bqqTwnyCeFdM2E+L+aJE9XsxIqaQvrNY0/E4B99p7Yz0UjPW/UcW9Q3o4yFxA7irkikIGxxy0NAlRaSdiDAhsaRV81fPj/QrF0+buQAFGg62YFi8HHpOGbmxeHsSGqeO213ssD/79DLuUGWi/z++UpzjOASG0r2nU/5CQlWgt+xg02HFCAYzwP7fbScQmYN+n9XZWr/QRJnifdwTrw+ON1bIItQ5AQ/K/G+m6QkDIbOmBe9SADvu7qDT/c5I4JNvNSA+yCayIabwHKghv/Hhf/55hFiYPl7ep84LqMS/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoYpyFo/K50tNuvgj6SKBH3RrQLtjI2yBLhe0KwabEs=;
 b=oAK/OIqiI8nAwk8FD1ntjxwtFsJO6lqFuJtZA8crBEBKCyYsJszwckJ2uAnnUVRwlpKHMg4MGe1u6AP2Fm5Z66Mg/IO9rrx2qqqVhMXk1esvpPKmIz1KvpUuxW0qThx3qzTm2H5+5PAJe23cJ7kd/cawDx30ljIDC0cp7WF5GBfFfd287B3UKkDEbXEj6yuE5Be5vAbmDkh5BYgEzSpJvZx0g0yUCExZDbo2+zBl/aQkhgdqjeW9CMLNbuDuUfvfQFLJ+RQaFf3euaceE3EOqTz2uJL/wWOBcNGaxFBXPTEUmTi+LDF19vdnd3mgcqgCXgPz+4d6eS8wmCSsXrOWPQ==
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com (2603:1096:101:2e9::7)
 by TYZPR04MB8093.apcprd04.prod.outlook.com (2603:1096:405:a8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 09:46:41 +0000
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58]) by SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58%6]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 09:46:41 +0000
Message-ID:
 <SE3PR04MB8922DAB758E81D8B16CE44CBF372A@SE3PR04MB8922.apcprd04.prod.outlook.com>
Date: Thu, 26 Feb 2026 17:46:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in
 kvm_riscv_vcpu_aia_rmw_topei()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Atish Patra <atish.patra@linux.dev>,
 Anup Patel <anup@brainfault.org>, Jiakai Xu <jiakaiPeanut@gmail.com>
References: <20260226085119.643295-1-xujiakai2025@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260226085119.643295-1-xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0169.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::25) To SE3PR04MB8922.apcprd04.prod.outlook.com
 (2603:1096:101:2e9::7)
X-Microsoft-Original-Message-ID:
 <333005f2-b55b-4df0-98e7-40e998f4118b@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR04MB8922:EE_|TYZPR04MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a8a6e09-2b62-4596-45b5-08de751bf028
X-MS-Exchange-SLBlob-MailProps:
	vuaKsetfIZmcv7cN2CQdJd4XVKwegu/4uZqsT57xel8AYRw3XRvKlv6Fxa/8NQfcRlA/WQMsrQkf0j++puNEbukN7jNIR4Pg19+5zUVJuzMKKvPRa1dL2cqZ7pMZvgeJJ++1C2i3dwcFHPMUOpKaSXhrue3hgo1Qq6AO4lt/QSIxPdepvzX6R6jJ+HEvc7sPYrprQUp6pG14yJI1UPJIOxNtbBKFVASiRETNyxXwlwb+FBjCXqq4Fq9nVuv/jGFbsANj6jgEmOHWLXYFUDQnFNMKIPdJ4upnHw64l0T3pTPHTpjkO53TSR5jCe6RszCSwZwUcFDkkYrkPbeSg/tDpU0kxWk3sbclPph2hEaK2orivRTVDVgFQQcgvPPtONEFlQpNs6x/rouagVBubQ+Zvd1nGMjHJJDztKkeBbEHWjCY30zASFysCmIFus7Di9JCm7KLTCYcr/GzCd/iUbq6PMHwXXzBhaqbe5OtOk4Rv8NgvEJcexaBgHZmDQ+cbsNCCvZUPeFSfP0ZZijXZl302KpxKmYlAocqVOHxNEGlwbYkHKW1X5GMEwkxAssgFsjRTSTVoMpvzcL/SCvF0pRFA+XDiOQW4W48y/bOJ037M4X+vVDay5GkQaWerVhHD1Qnry7capFLYWDtH9NxR7G3tRvA7db3wGBMR5+JnI/lRB/A7GCY2GgJRTi8Vyj9iqZQY/kHH8+chZrAiwLJrm1RkMEue5OEadpaolbZyLN2b9q80b9N6ii9Ngq4bfwNQOii8FpsQsU2UkEozpJw0sNPzzTckSHKNKioxIeLptEyEaMJ2UqyqBKaw0b5XfeOMrQ4
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|6090799003|19110799012|8060799015|15080799012|5072599009|51005399006|461199028|7042599007|23021999003|12121999013|40105399003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzlBUEh5MVZ5eVY1VWhMa3VYSlk1L3VVbnc4UC96VnArYTlPRTA0SDhNTjlt?=
 =?utf-8?B?V2NOekJBenNUcDBLeG4reHY0RFYyTGlVc20vQzZWZlc2a0RlTWlKSDBtV2VH?=
 =?utf-8?B?bkk2OVJXRzU4RjRsSFhCYW1xOG5EQkk2MUFMSGw4QnlTL1kveTZkMW5OWS9I?=
 =?utf-8?B?N0daTkJjdXVqbStwSmkvakVLeFNWVy9WZDVHUWFsWk44MzhsTTU4Z01zbjRD?=
 =?utf-8?B?bTdrbVlWcnRFYXQ5VXJXZ3dza3lFTzBoV01QNFE2L0Q1aCtJSVdJV1kxTTRh?=
 =?utf-8?B?elR6OGtIZXdreUVaR0dlQnFSeGxPeCtxZnpKdmhubCt1d1RYbGQrdi9saHA1?=
 =?utf-8?B?TjlrM2R6RWFSZFVmNXlYb01URTNlcXZFSjFTZG5ubjRONEtwc0swZXhjc3Zn?=
 =?utf-8?B?aFVYZHRzdTlpbXM2Sjk5Zll0em9EUFBhUlhuZHlIc2dSSE0vall1dWpHRElk?=
 =?utf-8?B?UTluWjArekg3UDNibmlkblRISTJnZTl6ck0yVUsyYitIbkl2cE1QaGJka0Rs?=
 =?utf-8?B?RVNwOG9NR2ZyYmRyMWhrTGR1V2ZHZmRscmQ5OFVWejQ4MVZ3VTlIRG96WjFJ?=
 =?utf-8?B?Ym1MVFNZcTN1QnFYTTFjRWwzbE9mcWJUdUZwNDh4Uk95czBTc3IwbjFlR1Jr?=
 =?utf-8?B?UVA1Wk1KMEp5OUtBZ2RFcnBhSG5yd3JTMktoeGhQSDduT0lWSUFmOGFKK1NX?=
 =?utf-8?B?R1NiUVBZSWRXZ1ZXeDRQelVsalN2alJZaG5YdUZ5eWRXdU9lTWV4czRwdHNn?=
 =?utf-8?B?S3ZkZTRMRXhjWHlkdU9GNjFPSjZZQ2NhNGY0NDc3L295VWxhREFFWGRhS1li?=
 =?utf-8?B?UUVKV01JSDZHL3BTdDdISkp0SmNENm5jREZyZGVWaW5PdzFIVDZDRHdYRkJi?=
 =?utf-8?B?TnZ4a3FGa0pDR2ZCTkozYTFsVVQxY01KWU4yWFlLQ01jTE9aQXc2aE5ua2dP?=
 =?utf-8?B?V3ZzR1QwbDE5UXplQWJQN2ozdlc1R3FQVnBtSG9qVkxucGlEeS9FTXpjbkVr?=
 =?utf-8?B?SDhWZ1h2T1VMZnRTSGpQTnJZV09mWHJ5THRkTERLN0hudU1tMUFsSTBLd200?=
 =?utf-8?B?U1FMZGJnUlN3M3FMcktWbDlaZnNuTGpkVmtTV2V1Lys2OVpUWVJNd1MwOWZ4?=
 =?utf-8?B?NGRlNlVIY2M3dG1xWDc0VzZMT2pHK1Zsa0ZMcWZEOHFKb0k3WnQ3Mi9KMnNR?=
 =?utf-8?B?RVZROXovRjcyZldDMVFUYWttcERMMU9uUGkzWnkyZndRZGIrL1NNcms3YTh6?=
 =?utf-8?B?NzJyZVdtQkprMVlwdFNjRmhERDJDUkw4Qy9vS3NRcndKc1JhWTYvUmFSV0lp?=
 =?utf-8?B?VTBSOG8yeDRzVzEwcEduaitCT1p1cjA5TDNla2RSbHZrdkJjTVpNa1p6am1C?=
 =?utf-8?B?VUtPbUlUeVFkSkE9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzBubFI4citKbE9NckdyWVkxQXh4d0xXUFN3L3Q3S2xva3dqcVplMzVZT2lj?=
 =?utf-8?B?M1BSaVl0d2hrT1dYTkxLVXRyVnBkOEdBUlIzSTRzbEwrV1EyRitWeG9XbHly?=
 =?utf-8?B?Y0ZYdjROR0VqR1JTQ3F6ZWpQUVh2QnZGaDFiWmRJSlJYdWhHamV1SXJBSFoy?=
 =?utf-8?B?Ykp2cUY0TDJKWFUvNmVTWTBlN1F3TVZSSWNtVUQ0TEdsdk9UMzBFMnVuODQ5?=
 =?utf-8?B?eUl2Rm8zazF2QUFORnpwNWErRW9tSExjVkdpZVpTRW0xd3N0eUx6MitUQlhu?=
 =?utf-8?B?cVVZWCtpSk5aT3dyYXJCeGdEV2RFY0hxMk9HK3NDYzdTa3RqT2RucG5taDk3?=
 =?utf-8?B?QU1lc2ZzT3J0TW9ZSnl4Yk1jc0RlMEtWcko4cDZLS3RRNlpPL2RVcFJEcmV1?=
 =?utf-8?B?azZPWGtZUjBwT01wRnNpQndGOGRvU0ZEMWxvWllSbUc3Z0FOaEZNMU83V1Nw?=
 =?utf-8?B?TGtNb3p2Sk9pS0crZTRFeDZHTEtUTWhhWklhWEQxdHNvRUh5ZzgwWG9iaitB?=
 =?utf-8?B?UGxReVhLeFZMcVV3VUxjN1Iwd0l6cG9KRzMreWdYRXM0R0dxMFkwVUEwVHJQ?=
 =?utf-8?B?TWs5REV4Y3dMd29Hb0hjTmx5WS8vbFZkRllTTEZDcUlIWWl1ZU9Ld0VMWjlx?=
 =?utf-8?B?QmttYStDZW1NelV5UkdObXVDZXdEU0xNSUswbVhXWXNHREdFRzFhaERqTHdX?=
 =?utf-8?B?a1lHWXpsUEplRFgzRktISVk2cDJOZ0cwbitYWlZoODNvZ3VYZG5ZdFJVWkh2?=
 =?utf-8?B?STFIQ3gxcnA3OXZuRTNnTkxBQWpxMURPWEY0SVhTcnYrWmEvZm00RWhtU3ZV?=
 =?utf-8?B?azZyNFNhSjUyL3RtWnkvNEFGbnZ0MUx6OVdrUi9CUk0wQWRMRnFqdHBJaXFv?=
 =?utf-8?B?ejA2UDZISW9GWWNRdkhWNkRUbW9Bb1dhcVFOSTlSSnpUL0VKN1dVR3NSVEhQ?=
 =?utf-8?B?dUM4eDllZElubGRIcnpFbWZNQnVNNnB5MG9aMzNYWmZqalJNSnNNRUJsUk84?=
 =?utf-8?B?SnMyVU9Hem1raDZQZFpzOEpDTzBZN2JrUjZraWtxVTJNdEV3RkZDUHI5dEcw?=
 =?utf-8?B?WDE2TTFPWWkzTUxSRGp3dHFYY09wMWt3QkRDV2ZlRnJjRXpKbzNsS2IyZTdL?=
 =?utf-8?B?Nmc0Z2tVQVpBb1F5Q0t6T3hCSFJFazNNajJiR3pjOUZvK1Z2Zll1bjZnaCs2?=
 =?utf-8?B?bi85MUQxVzYvSEZqY1RoL1kwLzBGeUlXR1dheG9kV09VZWFmYXI1d1dlMXpX?=
 =?utf-8?B?S2cwME83MnJZcldTbTRha09raFUxdXRqQ2t5WHdxQ1lZeFd6cERNVjNxRDRN?=
 =?utf-8?B?dnB1dEMzZ05RV21wY0ZlSnlqdWtkeTZkVFpTQTVVeEgxUU5YL0NLdHhHa0ZN?=
 =?utf-8?B?Q0NCSlV4dEVHS0k0UU9DbktDenk2NnVVZjBKczRYUEZDY1EvREtJN1BNNzkx?=
 =?utf-8?B?RUV6bDl1MGRKRTk5KytxdTdvT1ZmRXVCTzBvajBEdWRIaDB1WGxYZTRMS0FS?=
 =?utf-8?B?ZThoS21rT3libDNCRVI5TTJPb2ZFNGgzY2J2WjlUdEEvcFM3M2t5S1U2Qk9u?=
 =?utf-8?B?aUpYWCtqdkkwcTRramRVV0pJRDgxSmNFdXpHVDFOOGZtY2o1RW5hSVZvZ0lv?=
 =?utf-8?B?amZPTlFjQzM3OFVrTFQ2V1ZhZUhtRzQwZ1JuQk83dko5NURwOW8vVTBVd0VU?=
 =?utf-8?B?MExWekdLZmRPSTQ4N05xV01DT1ZzN3NDbitMOWFEOWVycXJwSDAvT3NiQk5q?=
 =?utf-8?B?RHc1YWNLOEZ0Y2l6SzdCNC9hOGxqQ2RxWFY2c1BORmh2Y2wvZ080cVhZQWNN?=
 =?utf-8?B?cDk4bU9IOWx4Y1d6ODdwbXNWbmt3eGdPaGowaUZoRExobjZHNGNqMFN1Y0hO?=
 =?utf-8?Q?gzs2PCXhRpG0x?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-c3e7a.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8a6e09-2b62-4596-45b5-08de751bf028
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8922.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:46:40.8881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB8093
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71951-lists,kvm=lfdr.de];
	FORGED_MUA_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[hotmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nutty.liu@hotmail.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,brainfault.org,gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DKIM_TRACE(0.00)[hotmail.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,SE3PR04MB8922.apcprd04.prod.outlook.com:mid]
X-Rspamd-Queue-Id: 96A791A3B38
X-Rspamd-Action: no action


On 2/26/2026 4:51 PM, Jiakai Xu wrote:
> kvm_riscv_vcpu_aia_rmw_topei() assumes that the per-vCPU IMSIC state has
s/kvm_riscv_vcpu_aia_rmw_topei/kvm_riscv_vcpu_aia_imsic_rmw ?
> been initialized once AIA is reported as available and initialized at
> the VM level. This assumption does not always hold.
>
> Under fuzzed ioctl sequences, a guest may access the IMSIC TOPEI CSR
> before the vCPU IMSIC state is set up. In this case,
> vcpu->arch.aia_context.imsic_state is still NULL, and the TOPEI RMW path
> dereferences it unconditionally, leading to a host kernel crash.
>
> The crash manifests as:
>    Unable to handle kernel paging request at virtual address
>    dfffffff0000000e
>    ...
>    kvm_riscv_vcpu_aia_imsic_rmw arch/riscv/kvm/aia_imsic.c:909
>    kvm_riscv_vcpu_aia_rmw_topei arch/riscv/kvm/aia.c:231
>    csr_insn arch/riscv/kvm/vcpu_insn.c:208
>    system_opcode_insn arch/riscv/kvm/vcpu_insn.c:281
>    kvm_riscv_vcpu_virtual_insn arch/riscv/kvm/vcpu_insn.c:355
>    kvm_riscv_vcpu_exit arch/riscv/kvm/vcpu_exit.c:230
>    kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:1008
>    ...
>
> Fix this by explicitly checking whether the vCPU IMSIC state has been
> initialized before handling TOPEI CSR accesses. If not, forward the CSR
> emulation to user space.
>
> Fixes: db8b7e97d6137 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V1 -> V2: Moved imsic_state NULL check into kvm_riscv_vcpu_aia_imsic_rmw().
>            Updated Fixes tag to db8b7e97d6137.
> ---
>   arch/riscv/kvm/aia_imsic.c | 4 ++++
>   1 file changed, 4 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index fda0346f0ea1f..60917f4789d84 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -892,6 +892,10 @@ int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long isel,
>   	int r, rc = KVM_INSN_CONTINUE_NEXT_SEPC;
>   	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
>   
> +	/* If IMSIC vCPU state not initialized then forward to user space */
> +	if (!imsic)
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +
>   	if (isel == KVM_RISCV_AIA_IMSIC_TOPEI) {
>   		/* Read pending and enabled interrupt with highest priority */
>   		topei = imsic_mrif_topei(imsic->swfile, imsic->nr_eix,

