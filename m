Return-Path: <kvm+bounces-72694-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MsYLrRYqGlQtgAAu9opvQ
	(envelope-from <kvm+bounces-72694-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:07:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4F4203BA9
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7EB8F3054126
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 15:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BAE35B62C;
	Wed,  4 Mar 2026 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="IB8ThaQy"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CC34D4D2;
	Wed,  4 Mar 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639778; cv=fail; b=omv0/KL1Pki7ouFjd+PLUOU3YUFZdzWHRT54Wx53v9/ZsT+YNl9zzbZfjsX0FhxDdyw5C9lopFBhWNR+dYZYD8CSypEFr0/X1rGcGReAcpvYSSSp0zCCbTLM/VP+eY5Ma0rg135Ik1n6pTALh6n/I4gE3h8dqdJjufncpkZjlXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639778; c=relaxed/simple;
	bh=DeC2hUVqAo4pRe+byXb0TGh6XIHQPfkiuaThzSoeT28=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LylzOKGFbf+gM0vq6G/bU8JscdIw9H+L16wjyQUqdzSTV64OIL2EyOP4Fyj0fKPURxNSUsErXcZtzWWwQjNUcj7xGjEpAsFT6+6i0pGJdtJFk3DZozDbjbnCahJkl0nKrh+Oj0EUVvCSK037NZL2yYn2EdcopaQiog+SEYF7HE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=IB8ThaQy; arc=fail smtp.client-ip=40.107.200.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5cGwQTZgKL6ePbUq5b9C2Y+eiDP18aZ/ZLogjQ8OZa7dnOgF8mhCW3zyjCpJM8O4PfnfqRmtqzJ3f/HyiVqBX+E3LWLEObDjpvy96ABVLE6nD6ZIarNbn2OYoGn/QoohjvaVmBKiTsfqYzv8b1dguMtujVZ0oy3Cud15aLOiMMM4g1rCbw6zMDcGLqBvQpWQN765Vk6lSaomFHHQAPJmSYKZsRf0CCwA76YsJOWpC2wzLEE1YyRGnAvGEDkfcEQnyyZXjqkpLn/G17HOp5IR+ICJT7O2T7GzHR0hbdtNFGzaCfyToPLKs7KcgmXy5H2zp2CQIcK83/Gt28YrzZBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeC2hUVqAo4pRe+byXb0TGh6XIHQPfkiuaThzSoeT28=;
 b=KCTS/CccGf2+xBaDaU7tf1C0xxLyaY0UXMTooleLP/snubkXrj1rLHDoANg4Jhg0l+Wt0qG8EHKdCQx75YtHzzITD7arb7kCJbE2fiEZrTRrCd6k6FcG3r3ahcmEECQijXqRHdpRSC1uII2vQYS6X1cLoRhaPyLN6g/Olx0gKIZMwltwjt6K9XKrjgf3AJdehV7ZQErbNDuxMEDqgNUD/qQz9iIVqmjoG0E5H2fNQ3Oa7fA0yz9qGklpqsqxZAB520dyR7t3zv5X2hj5kH4QQoGFTxEbt0jmDhz+C5QymO3hDhCC8i16rS7obiikM6jqkhnhZcL2y5obzZ6ECBCjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeC2hUVqAo4pRe+byXb0TGh6XIHQPfkiuaThzSoeT28=;
 b=IB8ThaQysrkYsYXRTEa65NkfneBVKL4ZQP2INhlsR2EDW4ZTpY9og1QEPQTJQxPRB1EJx9QYP4sKAJRRAJM+LgUrV6m37lxHKJGaz9hypGsWozACboDhzhwIZjwsdR3ODYraR/ZG4vv2WfasLXY/agqNN4qnBELJItTV45q3Wy4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by PH0PR03MB6621.namprd03.prod.outlook.com (2603:10b6:510:b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 15:56:14 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 15:56:14 +0000
Message-ID: <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
Date: Wed, 4 Mar 2026 15:56:07 +0000
User-Agent: Mozilla Thunderbird
To: dave.hansen@intel.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Ashish.Kalra@amd.com,
 KPrateek.Nayak@amd.com, Michael.Roth@amd.com, Nathan.Fontenot@amd.com,
 Tycho.Andersen@amd.com, aik@amd.com, ardb@kernel.org, babu.moger@amd.com,
 bp@alien8.de, darwi@linutronix.de, dave.hansen@linux.intel.com,
 davem@davemloft.net, dyoung@redhat.com, herbert@gondor.apana.org.au,
 hpa@zytor.com, jackyli@google.com, jacobhxu@google.com, john.allen@amd.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, nikunj@amd.com, pawan.kumar.gupta@linux.intel.com,
 pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
 rientjes@google.com, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, xin@zytor.com
References: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0286.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::13) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|PH0PR03MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d3a0953-be97-4d5f-22e3-08de7a069042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	8mHKXrpazgg8wZC44icjrdRqSrh65Lsl4uYDz4ab3C9ob8jy5SVwjcGppDdA1CwQwiRBZAjOA9RNggKDu1K5Yo/vWoYxpIZSoY8h21CQMc4QFTi672XFvfIivyO1BAuRaOxcK9ZVlYXZZIHYFHIC5fH4rjubv/CJOxXBTypw4fV+I23u/LXFrCIDA4RdBh7WVBR9daG0b1XfnFOxAoBFuMl/VnxOPFiWsM3QX1wy4gm4R3hhz6kJSmw//qPwqKQx8QqSlS0yStrJiOz28VBOLXJDAffbFdWbjN+5VjeqRqzycAxQAAQbDcK2BbuMQRgLEacRAe0mlXVAcr9/WJeobpb9+ABBbBpVMesHeY91w+p8TUq9nRkta4nVJuKRsyI+44kQ/F9PZ5teo8DFp6kIjqdoFiMBwSEWA7XUnlhg1/yNRxjjAiy1JFKvXQom+v1ge/qWk828bxKcVIE9+FKSSzrnw8s2gA9WXPaDEm3MjOiFy/LObZQritHVDQM40B0USr+KIw4m9f1SFeCwV+5E0OGaLmJs49aHQ3PMCIqCLmiTkH7OBMSideLr2YZJ4ln4BBE4zgVYr5vfJu+/kNL3op3X+ozt/Ih1yNW7NxUTVB0wUiBvWsbxhestXHtPSH/ydkoYWiksoiGUi62gHxP3yWbgwpAIabUXbA4I3NXsMURGynnxPexhDMZxNtuhmbFBLShfDp7XVjEZGEZ8dIMkHh+VcXEBkwjeJEZO0Vv2+kw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDNuOUN4Zlg5aUJiRmxuV1lHTy9tdHRpU1lldjJvSmQ3dkZRVmwwR2tmYWly?=
 =?utf-8?B?cEVpVkJFWG5qV2VMbDlyeXNkb3Y3dHErRDZEbG5aeGc4ZDh2c2dCOTZhejFW?=
 =?utf-8?B?Rzk5Y09kU3dOSENia1Myd2kxUzBWd0xtUEpXcmVLNHBlQzBqdjV3bzZvVysv?=
 =?utf-8?B?RWhqMGpRMDMyVEMwK0I0RzRaREVGQU1PYnZRbXI1ak5GbU1zbE0wM0NNK2hp?=
 =?utf-8?B?QUZYcno2RVlmQ3NQWjllZ2gxQWdmYk9HWHJBeWswMER1MEkrSGlRTGFzTmJk?=
 =?utf-8?B?ZTgzRzllNEp1MEE3L0V0OTFtWHNQZlRkaTRVT2FTSmRrZjVGV0xDMzVldDZI?=
 =?utf-8?B?UGpPUUZza2dhUWYxUlhmaW1oYnhLbzhST3hCZW1KSndxSkJKVlBERlR1bW1M?=
 =?utf-8?B?N2NjRVUyOVpoNHM3OEtiUG5sS0ExQmMrS2Z6SEZleVdnNTJKdzgxR042L1U1?=
 =?utf-8?B?SVo4SGtnQSswZ1pyZERacmdOdC9LOVo0ZWhDcWdRbGVuQzI3R2g4RzVvbkp4?=
 =?utf-8?B?Y0xSK2N5QS83S0QxeURiNlg0KzB3UXA5cmNEMVlrL0hJT2M5eE1BYmg4UjB0?=
 =?utf-8?B?cU9YOU9yU0RxRmNvaHBBY0xEYk1iemtsMmtNMXVtRkY2VEZ6elRNN0k0M3gx?=
 =?utf-8?B?Y0FxNXgyaWE4RjB6UEE2MGVmSkpYc0xEL0J3S1hEU3VwSFY1U2lqMHM1Vkpl?=
 =?utf-8?B?aGNRZGRoQjNRWWlWQlNtWWJUTEdrV3pDaXpLVklsRzlvcHVPTFhmbjVvdEY5?=
 =?utf-8?B?QWYxUWxNejlVTGVOaUs1cXUvZWtFOFVmMlVTRWxsSUZSMGhmZnVQNmJpM2ZF?=
 =?utf-8?B?SS9KWHhNVWpCeFJzUzErZGZRREFxWGFXYWtYUStOcHkwb1Avc2d1M01uVDh4?=
 =?utf-8?B?OGh1RkUzUHhvNWNmaUEvZmZQMDVrM2hsbEhNVkxNTCthUW5kK2sxZzg5U1NQ?=
 =?utf-8?B?aDU2M3BFSmVoTUp0V0VReUJDZHFWNXNzOUlEVjJrNm9ITE1BejhnMVRwbVdT?=
 =?utf-8?B?bHFRTnVxUm8vZXBjNnpqVGxkZmlPT004Rk1QcXJUK2hYK0c2eFpUUGJLaFFj?=
 =?utf-8?B?dEZmWVpPZ2E0V2pDSVptQkNaMVg1cEpWQ0trN3BJd2xOa2p5YmltMUluaVZT?=
 =?utf-8?B?cnBjcU1JM0Jsc3VPUXpxaHdpdVRtYXlsT0lWZkdwSXRpVEhhTml5QmVwbEJW?=
 =?utf-8?B?bEVQOGh4UCthSVFTY29GWEpNZzlqekNCSGhvQlBRaFgxaURlbTMxS09ZT3k1?=
 =?utf-8?B?RnpPdDNwQm1hTUdGSThaZXdST3ljMmlZeGVjd3Bqc3BrTmlvOC9MQjVWSTFr?=
 =?utf-8?B?UkptSG1mRDA3UnRSa0hFclZrR2U1N0tLNnpvM3EyWWJITUpEOFN1Y3dLY1pn?=
 =?utf-8?B?NUtacUwvNFY2R3dvdDR2WHVmQlJRQVc5ZmM2RmVJNzRScWFZMXRURnNMZ29Y?=
 =?utf-8?B?SDRtdjRiMTBnbFNwWFlvVmwxSG44ampYclNYbWN6TUJwMU1weU5OQmNiazFG?=
 =?utf-8?B?UXo0cFB2M3F4Tm11czJsTWpFVHpUOThJTjczbzY2bFVWenFrMXNuS05RVDda?=
 =?utf-8?B?UUJBVlN0Q0dTY0I1Tmcycm8yZTV2YTZuMTZJaVJUUUdLYTBuaFFMK1hZM1Jh?=
 =?utf-8?B?TExtbmdqWXA1bS9mZllpeWc4Zm5IK2cwVXdQRXpodnE3Qkp1YzFtNXZEbVQ1?=
 =?utf-8?B?NnJBci9NeGp1K3M1U0ptRUlDbmhlK0hFcHQxVGJxZ3hsbU1hNFNKNWQyZ293?=
 =?utf-8?B?Z3diUW8wUHQ4OVJJS09DRG11RVV5VklBRk1pZjYxajVOZEZiUmphajZtSVNJ?=
 =?utf-8?B?R3dMVHpmTDkrb1FkWGs4QTZTdXhhKzVQN2MwUHhWTC9XWVZVRXFSSkxiQURG?=
 =?utf-8?B?QzZ4TWYzTDRSN01ZREhPM0thK0NqNTdOdUI0Zis0T3RLd1E1eU51NStVeWFZ?=
 =?utf-8?B?SUxGYVhIUUwzcFl3d3dtTTlrcnhoNHJwR2tnYnd5Y01ZRGd3R1ZwaTM3K0Fz?=
 =?utf-8?B?OURPNG1Jb1BLcWt5V0xndTVjK21iRktOR3hvOUt5cE9zLzNQNXBmRVR6MGpn?=
 =?utf-8?B?alQ1WUZEbXZXa05iZkprT2UzWVpLMTZ3aU50cHpZUmQ0S2F1M2ttV2ltZ1VH?=
 =?utf-8?B?SzMwYzBneGpJOTU2dHhIOU03K0wxMERxQ3Z6aDFFaUNaVytiRUNEZm8xa1hQ?=
 =?utf-8?B?SWVuVHpYTWdHdTdPdUxHdmNyemt2Nmp0VC9pbExBUDlxZGZjMUV5a2ttL1ho?=
 =?utf-8?B?QVdUK3lxY2RTbWpMZUdyOEFsdUJoUWpTQ29YUTk2RWVwaUlPN2xqd25SQ1dQ?=
 =?utf-8?B?T25rL1crWEdjYTZ4eGF4ZUtQZHl6SENaZXRTa2FxU1hrS1FDMnlTdz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3a0953-be97-4d5f-22e3-08de7a069042
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:56:14.2665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oa47Z9j3QXM8+e5p5QyMgNXGG3TbXipjfuUGXZ9ubPLdYXLnQ9je4IT7Szts4WOpgrncSPkgjmzdiq3hy0XcFdvE8I38gj9hPAh79jcqZZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6621
X-Rspamd-Queue-Id: BD4F4203BA9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72694-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[36];
	DKIM_TRACE(0.00)[citrix.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:dkim,citrix.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

>> +/* + * 'val' is a system physical address aligned to 1GB OR'ed with
>> + * a function selection. Currently supported functions are 0 + *
>> (verify and report status) and 1 (report status). + */ +static void
>> rmpopt(void *val) +{ + asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc" +
>> : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1) + : "memory",
>> "cc"); +}
> Doesn't this belong in:
>
> arch/x86/include/asm/special_insns.h
>
> Also, it's not reporting *any* status here, right? So why even talk
> about it if the kernel isn't doing any status checks? It just makes it
> more confusing.

The "c" (val & 0x1) constraint encodes whether this is a query or a
mutation, but both forms produce an answer via the carry flag.

Because it's void, it's a useless helper, and the overloading via one
parameter makes specifically poor code generation.

It should be:

static inline bool __rmpopt(unsigned long addr, unsigned int fn)
{
    bool res;

    asm volatile (".byte 0xf2, 0x0f, 0x01, 0xfc"
                 : "=ccc" (res)
                 : "a" (addr), "c" (fn));

    return res;
}

with:

    static inline bool rmpopt_query(unsigned long addr)
    static inline bool rmpopt_set(unsigned long addr)

built on top.

Logic asking hardware to optimise a 1G region because of no guest memory
should at least WARN() if hardware comes back and says "well hang on now..."

The memory barrier isn't necessary and hinders the optimiser.

~Andrew

