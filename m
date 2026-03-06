Return-Path: <kvm+bounces-72979-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JMXMnNIqmlkOgEAu9opvQ
	(envelope-from <kvm+bounces-72979-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:22:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6908F21B045
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3427130961F7
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 03:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F7D353EEB;
	Fri,  6 Mar 2026 03:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="gDcEp4xa"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013081.outbound.protection.outlook.com [52.103.74.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3092C0F7F;
	Fri,  6 Mar 2026 03:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772767169; cv=fail; b=Ab40AlyXMzhI3j15Tf9mYIqNv3BnD65vH1wzbgbRGzcftYXGxwkY5pIuyHXUV6oKkTC190Fi/HPNxchQSj9rBOhA8Ah1FE18Qey36L2k4WoF1cdHLk0ZpT+lX8kr44EJh/6cf3cZcjHahp0r5JvSKQHagqx5I9Nxl7rFGRccRBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772767169; c=relaxed/simple;
	bh=RRq21928F+O3bB88kfMOH+wkV8jfq0OrNPszJ0wDXW0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XqSuZKeBZXTAx2XEeDqYKMeBaQ8/nAUDTtC0Wx70jVDer5bKm+vksXhKXVZUPPqVkpqEQFaCGDy1hsJxPl8+PAlAqwFQxTthFyXnrLQnZGLaCg9Yxxq7HLl8id7G9VaoAuh0pvuEbFD1v+CGVDhhLReHr/mbbslnrEZc2aHrPro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=gDcEp4xa; arc=fail smtp.client-ip=52.103.74.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXABWCX3YFVZRlAZVt+2AVEI4oFxT9UiZSh2rxbWcscH0jwbR9waPaSQNPlVDOYLitKWwJQXcyNlC/15wIQZKbenguo4yJBNuLL6MpOZsr9Wwy5ZogzM2+bMl50vRaiK98jsIMQZUhhzHYRNmVvSVC795UNUVcm2nqwmCMb5lhwWHlXKevhUkBBB/1G7TQPzsKHgX+C9HnYjr7umKtl0R5Z4RRdk56z00FLgPzZe+CXj+W/vsPeQB3LldjuQHS86x4VTJR1mj7GJyV/L2TK+Lc+dJGUT/EriLU9jgGHsF4l539o+D4F5NRiqez2ecAoKheDLcgcoJWfJxwW/NnksiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MN7XuoFcoeylCzv84+en1fJPBufZS2NPH7ky2tsE37k=;
 b=FiFrjybMEwnfSQ2xvH1cCAoZZGs6ytHCnHuBsWfPLVaXxoZj9c4XhAGZKZE44bB5+zu91V3FeFPV/dMEwuZpzOK0UPeu3wnH2s/oH4evi7rsofadL1EEFGe2snoRG/HH3IdCVhJAC51f5iHmj1h66zgXDXE8OaLJUq1I5Kk/cBtcu/vfKWI+psnr+yIsWRYJ2r9+H3QfPi3hTtTaGnr+HV//qtoHkhlv0RGujAPtLuyeUv4hvGr+sfUI3+hhsN9c6daln9OVKgSvw7K4NXPvwZheMDz2mJxr72AOMQqTe3uhpZv4+Ve6qErshfFPwyJaSwY5ooL13tQvpcH/lSZ0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MN7XuoFcoeylCzv84+en1fJPBufZS2NPH7ky2tsE37k=;
 b=gDcEp4xalkES4RXD/YgrYYThHpPBQxqjXBWd7XcLBxNl8tye33YHtMPxfNfc+/liFwy/ATKWnd0fZxr82eFf0DND8aGCOe7/SrS01dr7+rnCGLuaAzeofNb3kfEmpVioMODrF7nn2+xaGd0NMC0oTiUiVVAkUKUjY5es+Hh1zFCz1BzGvMdOd4DbxDXWpluYi7A/9AAKr3xNXycgbGuegnUPY+po0wIKJ1nI4OcwZxar9wigiLEjQ/o/HEyj8cnfkOu+lLHqgO93cBwL+sy++6VqhSSmvnWaBOl6NybzAVWzJll2q4T7iQrVWY8egsDzYNl00Qbz9o6TEKMpdjmibw==
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com (2603:1096:101:2e9::7)
 by OS8PR04MB8181.apcprd04.prod.outlook.com (2603:1096:604:286::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 03:19:22 +0000
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58]) by SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58%6]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 03:19:22 +0000
Message-ID:
 <SE3PR04MB8922523E41D9D89A046F59AFF37AA@SE3PR04MB8922.apcprd04.prod.outlook.com>
Date: Fri, 6 Mar 2026 11:19:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Fix lost write protection on huge
 pages during dirty logging
To: wang.yechao255@zte.com.cn, anup@brainfault.org, atish.patra@linux.dev,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260304172601396IhMZyDqdV3dRmc2rVopfJ@zte.com.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260304172601396IhMZyDqdV3dRmc2rVopfJ@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To SE3PR04MB8922.apcprd04.prod.outlook.com
 (2603:1096:101:2e9::7)
X-Microsoft-Original-Message-ID:
 <e8bf8331-cedc-4561-9d2d-d295a85a6e57@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR04MB8922:EE_|OS8PR04MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bfac32f-dec7-4423-ccb5-08de7b2f23b7
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|19110799012|15080799012|7042599007|5072599009|6090799003|12121999013|461199028|8060799015|51005399006|23021999003|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDYzY3l2RzFOSHVDVmY2MUdQalBJbWJhQ2NPMFljVE1PSXplZERNUGZoL3Zq?=
 =?utf-8?B?Z2hHVVBPaGVQVW16YndCMHE5QXZBSWhYMWJVRjBYeU1pUkltNHlZVDBKZzhK?=
 =?utf-8?B?aDhIWDg3bFZLRE1zQ001bmpjTU55bUxST0NYK24yNGZaZ3BNWWtwUkN2bmVk?=
 =?utf-8?B?OERyZkJtNUlZT1MyZHFxejJRYTJJN0IxUWU0TVV1SmhvTHMvMWNkWndmN0Fx?=
 =?utf-8?B?Vlo3QkdzTHIvV2UyTnhYSWNDdmtRUWNqcTVVWkk1OWdhaVlGeHJ3SHh1Tm1N?=
 =?utf-8?B?dGZ6QzVkTExSSTR4MEgrZUhJQkRDRTltQ0FJdU9pdlFGaFhRaHo0R3lPdCtp?=
 =?utf-8?B?TzU2SHVIdnRod2lmaVcyREcxOU5xZVFyTjlmL1hkOWNvYlBEb0Q0YUc5MDZV?=
 =?utf-8?B?S2ovOWQvTStCNmo2aDM1azJKYXd2ZVhKTlBabWltbU5kVkxnNHJQNVF5NlNa?=
 =?utf-8?B?cGJqNnl3b0EzRHBYSGNaVnEwWklrUzUyR1BYYVhSb1JBYVgrbG5qY0E1MFox?=
 =?utf-8?B?TlAvWDY1RkxKTXIxMWNYZFJWbGlyWUVmZElKaXZvL2RHZUxUblYwa0RVekdt?=
 =?utf-8?B?cFJOL3dxMUFrVnB3MG80bCtKWGhNSnU3dnU0VnRhckRkUkJVMTI5OVVmV0pi?=
 =?utf-8?B?MXlCaGdtUW9TU1NJSnVmM3VLNVFDME4wS0xmZ2FaQ2lDclA4TjNQVjl5THds?=
 =?utf-8?B?WHRxcHp3TVFJdmlMYlJvY3g2cGlyOU9mRDFKS2hKeW4wVmpVSzBzNHE4VVB0?=
 =?utf-8?B?MnA0MlVRV3NYS3Z5emdzbDhGWmJWRzQwWjZ3OU5Lczd5WmdtUVlaWG9zK2NJ?=
 =?utf-8?B?Tm1rRXY0Z25QeXhHMzNjK0E4bFBqY1Y1UDBqMVpBWmxwYnp4RXZHS01IbEE3?=
 =?utf-8?B?U0VoRWJicElOeFdHQ25BQUN2TzhiaDlpMFdWQkx6blFuOGlGTDZsRlM2Smoz?=
 =?utf-8?B?QmZGMTl2K1FsSU1LMFVsMlc1Mms5MTF6QkVJb2doWG5MOFhab1g0NldxVHAy?=
 =?utf-8?B?aXo3WkdFSWpZMVRvdXZpVnNqN2wxTEZUNHYvL2Foa2MxOGU3cnJmL2NuZ0x2?=
 =?utf-8?B?Q1ExeUQ2djZsY0pkOEFVbUpNTWlTTXp3YkQrbnlTVE1Bd0djNmFCZ3RZdGJa?=
 =?utf-8?B?cXNpQ2hJV1Z4M0xwTmRvUDZ5SjIyZEo0WlJqNlVxUWJVSDA5STFKRGNOQ0t3?=
 =?utf-8?B?SldZTkJ6KzNOcGFVb3dYRE0yS3NiNlp6NHgzOHl6TU9YWEJiVHplbXFQSjJo?=
 =?utf-8?B?OE1ONjIzWTJ4ZHZaa0RHaHhiWnVEU2c3bXVPZG9JQzNsZE1obCtkNzNmb0JT?=
 =?utf-8?B?UllQK0tKNTJlVUtkelRqY2ZmTGhDK2lsV283anY4bkowTW94d3FnQXNuQVZM?=
 =?utf-8?B?cm1aQTMzbXZiN2c9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG1YNGViR3dxaGk1djZ4T3orRTRJWlBRTUt6c3JMTGtsTk1mYk1iajhyOUEy?=
 =?utf-8?B?ZkN1cFJCa0N2TkhMdWJ4Yk81RDF6RThWTGx2bitrL0xaOXo5S1JuOU1MYjhv?=
 =?utf-8?B?V3plMDlkTUN4Y1U1eG9kTU1JVlpubHp3SjNGaHJ4TDgxRWxMOStqalRqeEFH?=
 =?utf-8?B?dmNyTnZPMUpUeGlBb3lvL3NxVm5HSGNGTEcwRU9sUlZtcU0zSXpSZGtIdHo4?=
 =?utf-8?B?Qy9hZTY5Ri85QndZRjBKK3V5eHZjY2Z5U0F3N1RPaEgxTUVYajZ4ZzNQVVRm?=
 =?utf-8?B?YlMrUXJEek4wWUtmQVBPZXozbERsYjJudnRtdTBtNC9vNU1EQkJ0NmVtNEZM?=
 =?utf-8?B?eVhlZWl2bnk1MDZ2ajJGOEpjcGs1UnVHK3kvRlZjZWVjaXJKL0lOYmNnNGdY?=
 =?utf-8?B?QUk2cUhKemdIL1F3cG9HeDFGbHZXeTg3WkhhNytsU3RQeEp4RGdiTWh4UWln?=
 =?utf-8?B?U2lRc1dhaFdIbGNHa080amdHazRpemg4TkQ1bGRueGtKN1gvMkw1dElYTVJS?=
 =?utf-8?B?UVNRRzAxMnY0SVFaaXpFeTg3dEliQUp0Z3MzaHhTWVNNcVZqZC9zaGpIdnB5?=
 =?utf-8?B?eVVLRzR3MVBRZ2ZzWnRmUU9RRDN2RlludFZ3NnlMQjhhTEQxSFF3ODJ1M29L?=
 =?utf-8?B?Q2ZrdlZaUGhuMS9yYWtsbU5hbGZhTFN6b1diUWtEVXY5dEphYWs2VDhQS2xU?=
 =?utf-8?B?WDZiNTZteG1SSXJHanhMSzFIbjBRbmZGWWQrQUdKeXM1OW1GbmZGMlBRUWNZ?=
 =?utf-8?B?NUFrK2o3eXl5Mm03RThHaDE0R1Y0aUlFN0UwREJzNnNKTjBDZW9CMzdPMEVM?=
 =?utf-8?B?NUFGT3Z4dlU5SkNLeWpEWDVlQUNKUllpSDJISDdveUdrc2dnUFFZZzFIK2dv?=
 =?utf-8?B?UW13SUx3ekdWSGliMTVRWisrdHlhR0xTWGVXQlg5T01VZ0NiMW5kaFNJRDBX?=
 =?utf-8?B?Z1B2NWNYNXREWmsrZ2hZUFRiZXozVmk4Wm9yelgyTGtEcVUvWU8zYnN0Nncz?=
 =?utf-8?B?U1Y2WGg5Wkhzd1RONVV6UTlVTFZMUGp4Z1JGWS9Rc1QraFVvTnRheGNISXd1?=
 =?utf-8?B?bGJFQ0xBTG9uN3F1K1FndUNyaXJRc1psc2tjMFI3ZUpyR1ZLd2p2K3NnTEUw?=
 =?utf-8?B?dGFZbmorM1BPQk1DaklubldRNnh0TzhUTjd1TGZtK1RJMEtITTlCSFZUck84?=
 =?utf-8?B?OEJIOUNOTmNnd1dmMHFtU2g1VkJINkwybzhtTmhoRHRQb2Q3QWx0YS81czNT?=
 =?utf-8?B?MThodGF0VTZqT09MbG1XYkFmNnlEK2Nuc0poZlNRTkM5OHpTZExMQXE5N3dC?=
 =?utf-8?B?c3NzdWJ5Qzh5WUc5STRFWTRkUXBndXBDYnN2aFhGYUtBUjlzTEdIejdpZkd2?=
 =?utf-8?B?OGszNHhxV0VGQXplbGlQdnlmbGdiUy9ONmRIckNZMWp6QWg5Wjlxd3hUbk5l?=
 =?utf-8?B?YXBNY1Ntd0FlYUJ3elVrNk96Y3NpME9LeTcxNUU1OG1BVmM3cUk3V2hzMWFw?=
 =?utf-8?B?bVpSei9JczJKS2xvZ0g4d1dzY1h5T2F5dThSaWRVc0tXZHJQd0FscEFZS1Mw?=
 =?utf-8?B?T2MrejZJUGlRVWIxVW10TitFMHdYWUVYYzVmMTVwVDdpbVEvNU5BSHdNTC9p?=
 =?utf-8?B?YmlwRklaNlJ6Wk1qZWVwZXl2VytrRWhUMUx5ZDdEZi9VR2xLV1pPSWFscElq?=
 =?utf-8?B?SHk3Smhrc0hQWlZsSFlLVmx0YkloVXYzeGhrYW91RGdaV2FsTUhVYzZDSmFS?=
 =?utf-8?B?YU0rTEp1Qm9sUkFhWFVwWVhDU01MRUZnN3owaDhNVnVuMjlHOHBZN3dQelhw?=
 =?utf-8?B?YjRERXB6SzJ4TzBUcWhFT2V0bWNxTUgxVHpLZFpCMHhYVjg2NWJReENWSXpi?=
 =?utf-8?Q?4cbOQFyNmqp02?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-c3e7a.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfac32f-dec7-4423-ccb5-08de7b2f23b7
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8922.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 03:19:22.6427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS8PR04MB8181
X-Rspamd-Queue-Id: 6908F21B045
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[hotmail.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72979-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_MUA_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[hotmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nutty.liu@hotmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zte.com.cn:email]
X-Rspamd-Action: no action


On 3/4/2026 5:26 PM, wang.yechao255@zte.com.cn wrote:
> From: Wang Yechao <wang.yechao255@zte.com.cn>
>
> When enabling dirty log in small chunks (e.g., QEMU default chunk
> size of 256K), the chunk size is always smaller than the page size
> of huge pages (1G or 2M) used in the gstage page tables. This caused
> the write protection to be incorrectly skipped for huge PTEs because
> the condition `(end - addr) >= page_size` was not satisfied.
>
> Remove the size check in `kvm_riscv_gstage_wp_range()` to ensure huge
> PTEs are always write-protected regardless of the chunk size. Additionally,
> explicitly align the address down to the page size before invoking
> `kvm_riscv_gstage_op_pte()` to guarantee that the address passed to the
> operation function is page-aligned.
>
> This fixes the issue where dirty pages might not be tracked correctly
> when using huge pages.
Would it be better to add a description of which specific commit is 
fixed  like  "Fixes: <id>..." ?

Otherwise,
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
> ---
>   arch/riscv/kvm/gstage.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index b67d60d722c2..d2001d508046 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -304,10 +304,9 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>   		if (!found_leaf)
>   			goto next;
>
> -		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
> -			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
> -						ptep_level, GSTAGE_OP_WP);
> -
> +		addr = ALIGN_DOWN(addr, page_size);
> +		kvm_riscv_gstage_op_pte(gstage, addr, ptep,
> +					ptep_level, GSTAGE_OP_WP);
>   next:
>   		addr += page_size;
>   	}

