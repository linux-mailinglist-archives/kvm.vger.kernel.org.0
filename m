Return-Path: <kvm+bounces-66593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 094A6CD8196
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A9D63017EE3
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865D12FDC2C;
	Tue, 23 Dec 2025 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Qcc0QxHP";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="m7n9snAY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7C2F39AB
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466307; cv=fail; b=A+HsBX0DoTsr1nZWKdxWzxejafxBOhZC8SFo0jMyKk7PfyG8tksUyEdKptq4mKYbgGcl6llK1Kno89aiH5bdiFDTJrQWXXDXQY5so/pIF3+XABu6v1oQ8dvBKtwrlhVtInIZiKBAXUhqQjloZrM6nOHwXwM/5Q+vFWflQF8ku3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466307; c=relaxed/simple;
	bh=f8mEbcEk5pGDfcF0G0DWaRdHB+8IuvpJGlpwg4K2xQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U4AOh+xkL7pSFwJwnOw3BV0HHKE6C2NZUt95AIkWRFI9zFlcBWQ3x+quEwiUgmsr7caHjwdAOUorpvqlF/TquBYBsZ3tDt4rJwW1zucOlMwZPlTfPW9cQLWBeH4Bt+UAIrGvI/li4PaK1GFMxRd8m+FFLPQZo15O8Pf7hzf7fvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Qcc0QxHP; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=m7n9snAY; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLNNoR723792;
	Mon, 22 Dec 2025 21:05:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=uhKzS0H1IfadtciEBDNji6QSJUGcdZG3A0gh3e8ik
	08=; b=Qcc0QxHPxkGebKyXQU4GM5YxhOVKkMBJzNI3dOieodo/T+oibABFKYB8b
	JS66EtbfHpqKppoM4peqkJEOyFt7azS44bMgrkNl0L9u8GW2685Q1jxguIZI8ewj
	g6X02A+pJQRwQj+33mx223pm/RyAqxES6Ie1szE5LTGgjHR+tXaAhig3+wJQZmi4
	QifgSiOGbodOVLgjQsnhJ+B9/dkeWSTPwjZGIjaarsWQEc5/rJK8VNCx4WQtqIPg
	Bk/L9f4hLgAtiW6XWv9qSMhh+erub22ZQ8VBAvSWX6yAeqzIXeRns4nRLKQa2vwf
	By4bMEe+XdSK8YMULzHkXvdktJa5Q==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwva-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbbJZanmV326jLtxpiQUjtakhas8iign8Ccloi+Uor2bPxwCetEXTSe1j89CRXuVSqYFN0DEk+edcL+CSQuOEGYn012Or2YwUUNj2UgbaqBbMfhEbXsZd4P8gWyf/3Ri6izNzI6cKCD+CZrK8FarF5LOzlhPakvfyQxcgPdaKTuFYhrSAyO6DIjlyzgUW7MCGP/F1cImHNOrhiaqhRak9PoxehH/88QeMvOqHbRRwIqBTnjj/B8ZM6dqeT2TKosu3RRTeLHP+dr+mclO1QI7ubbpabx74ba4W2AHUlCOTqJfkJNttmqk24m7Wa8MZU/Nul8hA9jjrn1CDz+yY0hKtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhKzS0H1IfadtciEBDNji6QSJUGcdZG3A0gh3e8ik08=;
 b=MMwWQnKcZprFdKrgH1/vfzWqSbEsDHcfNQbNtfsDUe3LehXO3bVzP1RisKd1ERmgH/+S4NVAxRLLbfCETdrj3bA+FJPX/Xc1b9tzdrt8tf+u5FXdfHTJaqeIq9RhxzrZtc6JiRmas1xzW2N5KfJ7OobEgb63QHca0HCmlJl5YBEu9+HmXLzsAlOXKH78JHHtdKlPNDgl0CPc6A2t4cBP/sukE/7MvFukM6kvLwsScpBArCdbbYbdPFSgJLAQinD/7TtPCppay8Zb457l5HARc4xCD2N++k6j/b0OJintkbDhFZuIsjA88C0mcMVrG/7U5y/hNf8Q9ZSYRlFRSB6GXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhKzS0H1IfadtciEBDNji6QSJUGcdZG3A0gh3e8ik08=;
 b=m7n9snAYojmYb5W9mfrG22bir4fR7p3yWDvCDKwJnPtE4p47CPDq0LAQ1u1/GOascNan87+H8x8f6/LlJ4ORhujRCXiBzuExruFfHLPO623NZpVoo1Ptqk62rWMuB4rVG5ULMmnSA97bbxdznaiWojMliEKMu0bkL5vgQ4SBNSVFy4MYXfrTcw42gkyoKuUlCU5rJ73gX9Pd+r8SyqvRl0H8u7yXyBJhnnrHBxo5J33fJEzbVqc5UQbFn/71b/z7gzyHgJBxMqJ5bT/94VLiSKia1NxwUiQkylObt0DlKMGKVWux+XiYT691iiKWv4slRcHfaSSpZy1AvltnoeqVGA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:59 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:59 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 04/10] x86/vmx: conditionally include EPT ignored bit 10 based on MBEC support
Date: Mon, 22 Dec 2025 22:48:44 -0700
Message-ID: <20251223054850.1611618-5-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 42fde84d-e340-4b18-8f87-08de41e0d299
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HqnogR1niwGUWW5ueKmgQpnKt/Haj1pBx7RUALOMUT5wglL7TnudUd49lIWt?=
 =?us-ascii?Q?tPts3XPE7lru37HyfddyVp2H0YURsuQpFJOmXQoUY86VM/VLAZobatueazyj?=
 =?us-ascii?Q?BmtEQh6u+zx128HUXuJQ2xCCV7AwjQeVjjq/RhlTqGE1QtstQYx6qeyDYWAw?=
 =?us-ascii?Q?YnRUQoHxN6+uLmq1x5KmxkUiqhUr34r0tC5hXaZCc5a4DGvKdV2b/RX9n5vJ?=
 =?us-ascii?Q?bvS3Lkwr6emm2tmSAjKUkeqthGiSZHV+9sCU/HyQXSLb3WWB8G7lQUJul9ac?=
 =?us-ascii?Q?T6B/QMXxgHx72UaVlXdZTz2TM8D6meuoFmb1QasX4LHYAEZtcfUYTxQj+qz8?=
 =?us-ascii?Q?TWH4OsDpN/3PbufXNZb0xkKXylvtpuCaZqYi8SHWActym2Smnwr96Mae7ReR?=
 =?us-ascii?Q?X4WajYOq1uezksGegWTtZWaEPLAsDbHmr1RbUjAsQnw2cjhLBzXfIogSo3qd?=
 =?us-ascii?Q?i741KAe9HkBYM+JCeQH6fXaI7iIGVjDj/eidJYLWsu+2Vaquklh42TleQcJi?=
 =?us-ascii?Q?u8t8U9Ljg/D/xeZubqbiVTy3qV1VSkcprGcGQEAiCyuS6rg/SpVm4EsWuAc3?=
 =?us-ascii?Q?Pf5T060tMF866z/mSox0d2TVHARzLmdJclr9bJ/DqVfD8JFlPs5PG9nza9VF?=
 =?us-ascii?Q?z5tG6awlGBh+klhxiXsV+toxUGhTkWyaG1O1TfVx0yeNrF3ip8bMg6s+srzV?=
 =?us-ascii?Q?FCN/2CDUZFREqJgpIO1MhzZ7t+99UrmTAWNQCHpIg9XyFNMyCJPWYDQcj6/M?=
 =?us-ascii?Q?JA7s8ng/V9z4Km49wnskS7TgaZ760HWt4FquVV/tzhFJ8jRVOm6BXpRFTTuI?=
 =?us-ascii?Q?v+mOS9KxNufmjCkHVlvukXjLFyAT1SLDTNGyT2xOyiXb5uBGNYTWA3UuZ3Rs?=
 =?us-ascii?Q?j/ZHHu+EXwp19fi97ACo3Tst5IZgXQTy5ugKL5T1cyBsUnbdxOiRX+ChTIQb?=
 =?us-ascii?Q?SpozRPbvNQNl+QCMD92EjtNGt22U02opzmxDygiu6IUNh7lQUglvgcNoQDDw?=
 =?us-ascii?Q?is06CLZCuGuECBeps6jJ8ETjB8joXoVMXMZ4VLmJ9979u7z//P49P0VSna+W?=
 =?us-ascii?Q?uMdueGM1R+ci/y4k2LnGBth9uMhNEv4jKqPsjFcklIniu0PVxdYKTdX4He3S?=
 =?us-ascii?Q?Uvj+3gIUUu52qWuFl3e7XTEfqQzBm12vk323Px0g4pzMmgTLw+ezTCB5xHXI?=
 =?us-ascii?Q?m6OpS921qgQP5xU69CVGaylVf/fPQR2Hj4Tku5W+3xxO3gkQHt1qq0kVgP5P?=
 =?us-ascii?Q?75AhNhBqlShHWcc1FBx+Sy2g0zDRUVqjfc+LGs3Pxgd1GXMz13e6U8ByIaDj?=
 =?us-ascii?Q?eG8PucjnmaE9+NyQJGAeSCSbi1hMV6RBqzGuh+BDeRgdVbzMZuZJbnveJHF7?=
 =?us-ascii?Q?ktZ6QKVN4PAWNVGcwHmFM/KZ3W1plZojzN2qotQtsIEsJsK+w2cg2L4Vz9pk?=
 =?us-ascii?Q?m06173XTBMp9YeoANuvg52S1foh+Tapg99sdR71LMULg56M2KQg8nUmZReSl?=
 =?us-ascii?Q?1JfhHwUjbC/UTZkjslnN/MyfkljfCDaS2tbX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h/ubu9v86WAamp+cU3LXe+x0T4TWfg8OFbvvNDqEBQjsIl4YRT56peR2cTXt?=
 =?us-ascii?Q?tm4uNEDQt6twxKPQJonB3WfKNXmvsaKM/NukCCqQG3LT6G3co76KSRaJri/V?=
 =?us-ascii?Q?GAlcu92kRQKoUalnrWmW2/qBTbFJWiLzMz0bTuz4gLnalxXURBPmTiJTuqAh?=
 =?us-ascii?Q?t8mRy8FZm7rJDOClSm9UeuGmRw0VRjHZFPgVI5WkYQzc2PAcLDEIJuKhCaFg?=
 =?us-ascii?Q?eADwISnHMBcQSqLv0+KoyUCQA8rHoyyX5D5YkLumM68jA7x7H7zgvfEqEHNf?=
 =?us-ascii?Q?rr5BpCl5RVnqZNmuIUn93sWtcDNZDaWFa8Q8ZMTGDqxYQDBncOOMiIM/7ZAk?=
 =?us-ascii?Q?owYyquQYV7j7i2NFaTG6DCvjEESV+gvSqZuyVz0geTwDPWm3PGHnaGij5/TN?=
 =?us-ascii?Q?AfMbCl9Z/gEFGq9JRZu9lgfWe4PD73hE0UcZbDVEk4XarMmOndWRspOQKNJ8?=
 =?us-ascii?Q?zpNkhF7c/YWWul9kKDSXgqYbw9Ne57F7l97DsMBoh8W1x7M8FgOS+z9NsQbE?=
 =?us-ascii?Q?a88gkHXmRekM7AUF3ff0Fxb4Yxoe2hOIKO384Q4O70iQrmGQM7D9kFqxPI1q?=
 =?us-ascii?Q?3ICeXR0ghNy1Zzy5ZId21jQ2Zg+NrUG80mE/vCLIxaQeqoLtPn85jQez260e?=
 =?us-ascii?Q?pXApZQ5CEABEQM1W/1Ijn/E17Jv+NbbTlMYAcljUEbBCnAbmn0Dx4eF9HGg/?=
 =?us-ascii?Q?W1TgqmjfO1PXmiyWN8tSAA1Go16nOe7Mnx0yX9hZAsbPgzHxdu1zMCnZHSfd?=
 =?us-ascii?Q?ns4G+DCgw8bvTb0Dev3Uq2mCdwD/Ksi/VvNqvgYwLuslnQyZN28wUxAju6qt?=
 =?us-ascii?Q?ydKWzZ6UlBApw1wQcoRPLhZlnXrk/MKaS5iUVqqUC/QmPEawMXHfiC0jJzFz?=
 =?us-ascii?Q?ZTIkjfWqvhmHvbwlSIkULpO+KeqpVpKsRgRv6eZkxDHlY+IXdXblMYro8LiD?=
 =?us-ascii?Q?xe2jaoN6jyB/B3BeR5Uvo+jBhvAUgK2vCKWXMWpomxveqRwHjoUeZKCahSVJ?=
 =?us-ascii?Q?RmWS9UFojYFPJm1a9S8cGcJbAXXFAOu1n6MkdirK1bSRZnqnNxGYttFoyuZn?=
 =?us-ascii?Q?IQyzhcuAqmUJguFzNFzhdpsA7OC7fSaehGuNx3Tgg2xMa+8FVR/VElU2ABgQ?=
 =?us-ascii?Q?ppnJ05ES68WxuJ0fNkTrgNg/BbxfM3ZxrXO1Yn6BXUe4DgshQ9KufSUtt+FH?=
 =?us-ascii?Q?/u9dh5KFDdpQGuy9z8CWYqu4vxIl2gseOdwXgMCeEFs4s5BGm2Uomda9KNZ+?=
 =?us-ascii?Q?umGokZdZ3yhRJzfy5VDhHzkD7DMhlJKzuJHIesBIAUFXpXRTzuKyJnYDgS6T?=
 =?us-ascii?Q?Oqfn6re4rUlIH4px1i3tdX8ygFmv87cRwNsszc1LXaEUXl1jHbnDzCd/sM9x?=
 =?us-ascii?Q?4DeFF07XuHggymApzkZRLmskHwG+nEin5CN6HLbEQVPck6ER8bW0XCTsbeCn?=
 =?us-ascii?Q?etGFxW3bpX1iNhPM2a62Il8n46AxEWNSKFS5hQddfYQnDVKUtm+QZMxWQ1JJ?=
 =?us-ascii?Q?WSIyupyJsiH8/e0lYn4ZPUGrY62FwtTAgsAmr4MDK9k4EwjarZsW9LeKHxSU?=
 =?us-ascii?Q?Hf5XkeQJ/N5TlnVJsGqX7LzDRA/pHKr7Ld8cZWEwj0bwlaXQEA0Jbj74SPOe?=
 =?us-ascii?Q?ZiZlfOwfbkzBUJW+Xvx6yV/ntUmMEynwxJOiAg3noG2hE9M0edhfGKeLP5V1?=
 =?us-ascii?Q?Zma2ClMt6zp/WtDdzHLswl8PqAAzpTW1hIztuheR29eR3KFPHmWbs4H38BG7?=
 =?us-ascii?Q?Vds0tjkpRCJ8/h2Nky5YeKdLc3AE5H4=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42fde84d-e340-4b18-8f87-08de41e0d299
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:59.5512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmX7uebXq9NwzuUGB1G28BpN0A9vKc7dhlYiOtbI4tzZGwCg0UQjzJnLZu81qldt9nNHyUmdpk2VTkNTf/Zeaa0e95JRTcTfBD4HdTNhkVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX69wkvY/SEoJT
 LkPPXOqkxzW3n4oX72qJQFRwJ9IP0cu12ym4xSRkJYz622flNsMFvPdfOlI449dCUAe0QwRT3B/
 j5TbtPVjLWmiAlr0sAch4Qb67KZUEbxH1kNWsWKQMmjdzMTHhKGD/u9jfqM/JJPLDPfuOMOuo3R
 TAMsx2a2sS4j5Zowg5iCIOX+hSFTMq4HH60qWsWsVNYLPRhCJ3IJZ0Ip7l9mQjR//Jv7fz0Z+qi
 RVcUf8wLfyqZUN/0ROKhkSuMGhtC5JriPNlVPhmsxXZN8mOLUHybABi/gE9eCmJAdgUI2oQ47em
 MtFVHdcoibmaPebmfeF1OZsJPWmVJXh6SpLdA0sRTgp+aH/+dfkDsfYIYFR3FKLowgr7s2OfWa6
 k7lffVjBnRhu//pqVgmUlDQwIGi6FqjRima1caOXSskhC18tGxNVJ39Kjo/NNz84zfTP39Ba+oC
 ZQRo/P1FIrYmwUCpEng==
X-Proofpoint-GUID: xfDYyjqD7ZBn-ktL0flzjN4yI7a_mZ4q
X-Proofpoint-ORIG-GUID: xfDYyjqD7ZBn-ktL0flzjN4yI7a_mZ4q
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22fc cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=INKjLyNY9homF54oEkEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Update the ept_access_test_ignored_bits test only ignore bit 10 if
MBEC is not supported, as the bit is not ignored when MBEC is enabled.

When MBEC is enabled, test ept_allowed for OP_EXEC_USER in ept_ignored_bit.

Update unittest.cfg to break off MBEC into a separate test suite, as using
-cpu max will automagically pick up MBEC, and it should be testable with
MBEC enabled and disabled.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/unittests.cfg | 12 +++++++++++-
 x86/vmx_tests.c   |  8 +++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b82bbc4e..022ea52c 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -336,7 +336,17 @@ groups = vmx
 [ept]
 file = vmx.flat
 test_args = "ept_access*"
-qemu_params = -cpu max,host-phys-bits,+vmx -m 2560
+qemu_params = -cpu max,host-phys-bits,+vmx,-vmx-mbec -m 2560
+arch = x86_64
+groups = vmx
+
+# EPT is a generic test; however, mode-based execute control aka MBEC
+# is only available on Skylake and above, be specific about the CPU
+# model and test it directly.
+[ept-mbec]
+file = vmx.flat
+test_args = "ept_access*"
+qemu_params = -cpu Skylake-Server,host-phys-bits,+vmx,+vmx-mbec -m 2560
 arch = x86_64
 groups = vmx
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3ea6f9e2..9a636eef 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2586,6 +2586,11 @@ static void ept_ignored_bit(int bit)
 	ept_allowed(1ul << bit, 0, OP_READ);
 	ept_allowed(1ul << bit, 0, OP_WRITE);
 	ept_allowed(1ul << bit, 0, OP_EXEC);
+
+	if (is_mbec_supported()) {
+		ept_allowed(0, 1ul << bit, OP_EXEC_USER);
+		ept_allowed(1ul << bit, 0, OP_EXEC_USER);
+	}
 }
 
 static void ept_access_allowed(unsigned long access, enum ept_access_op op)
@@ -2936,7 +2941,8 @@ static void ept_access_test_ignored_bits(void)
 	 */
 	ept_ignored_bit(8);
 	ept_ignored_bit(9);
-	ept_ignored_bit(10);
+	if (!is_mbec_supported())
+		ept_ignored_bit(10);
 	ept_ignored_bit(11);
 	ept_ignored_bit(52);
 	ept_ignored_bit(53);
-- 
2.43.0


