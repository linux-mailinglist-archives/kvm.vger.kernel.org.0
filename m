Return-Path: <kvm+bounces-64638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C2735C88FDC
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 073D2349719
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851592FC877;
	Wed, 26 Nov 2025 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KnrJ2ksU";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SOaYSGGf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544F3303CB0
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 09:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764149941; cv=fail; b=HqhCHD35HIWj/o2u54WoQS7zBmGClRQVLTGQuO4fULROJYvZow9pWmYLDB+2fqfJYaNe31AFsfr6BmOpTql6C6m2xSJ26A9SUa5BxAm4BmA/0NXsveBK2VPZ2BxXk6djFVoXmSGR6o0BxuesuHYosjuhqA4eG1vZnivOsVg6zG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764149941; c=relaxed/simple;
	bh=U0DzpOouTzwu2NSKsw49MTEi5DeaqbnLDH7yVrHLyoA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gbt81GH6/e61xLxfEJ4NiOtiknMSAL4eMBtSKAlI05l3iF2vrIiT4NAWBMxvXHmL/yvxlHDUPt85eX9XV3ry0p2zJPzTofR5FCdIhem7NBHmFw+CDf7Y+8mMjk17GSNaJ6tWz8YT4Uy6FYegRKWIoQG0dQgBujRYT/I3TrhlBAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KnrJ2ksU; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SOaYSGGf; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQ97H0J989437;
	Wed, 26 Nov 2025 01:38:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=I63ifLMVjKK/Q
	1eY1jNoNpB5GrwBujLPdltCUAgORJo=; b=KnrJ2ksUuNS4a/jhQlsKhfAzhTbC7
	yC7+nmFUlKEY5W94yn0TGmHRY7eP7jge1W6O8TLMB9CPmMj/vRn2/ugBS1Yr2Ob7
	OzsYPgr3x5fk8Pu2RqUMu8xB32X61qOKBWL9F6YJzwc+TiQd5oCMidJefOgITs4F
	PZE8WkhMO7J/GdEOQFrVf4RQm7hqHztbcfVqJ7iQfh1GQ9wjT9ls0M2FGqgTeZAY
	gbjKzRemkVc6NFCu6dA10pUYykJkXZzD/5OoSgvZnYbx9zQttIkSUQgRD/m8PoDU
	P4DW+8ga5G7CU8hPA13D1ORpd8kLaKDSjpsKAo1S2bsCDD1k0ZcnqH77w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021112.outbound.protection.outlook.com [52.101.62.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4anm6y99ay-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 01:38:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSQRq5XwFQeezIqNahe7zvOIqJv3iTH5e6baeJ54dMtxkSQ2P4BiNZOAKgLIRT5j67FBPagOvLmg54VXSszA/JH76rrRkHndEN4PBonWGP+q+2JSDvN/aT6bu+h+skZRFP7tfXQbhPpBzfBzN5XZtILqxz9xBEHT3Wr0ugIzZnZMYPeRgHFxJyPCL7Gy6yAqlF3TOkUAuYvZNbwsSUXufhdhy84bFQoE4AjzJI+hLHg08jbPTxI4D2UF/mPe78jBIoy4eYpTkBm0NBuWajQlbfIk9dl4O8NlY3+uITlKuOfa6upvUQIthofnvCftM/QyaOcMBW9xnKFajdnXhh0Xhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I63ifLMVjKK/Q1eY1jNoNpB5GrwBujLPdltCUAgORJo=;
 b=TYrzkd8iD+Mctb3IbjiWj/T69SKcobjKMwalghp+0yoLo4gp7HjMS+lkvOPX+KaRVeMDvI5BAwK1IEHZkxsf5G7E37EER7SfUyO8Ngtfjzd285dilHalqY9RIkmOMQeY54wwJPzcNwrkAzqQHXewHIY29hq5yo0wPjtSwppmlzNtDzu+KuIQLBQGfrai9ke7YJrQTg+6WTcebM0lBZqD0/Ybm1wG3q9sSdiY5Nd1JsnYq2rYr86txczYr88O/zwflRE4LfV3JyvPXWxQfIlkM2IkmR0oTaEUdwOjtYuqlCYDgqztim2AV+RKC4UiQCNNGbk/FN0wkwYHYtpVZIOoMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I63ifLMVjKK/Q1eY1jNoNpB5GrwBujLPdltCUAgORJo=;
 b=SOaYSGGfXy/ieDNpBndxpscVodwjCjZIoq8j4mmTEkFfQ5Yry86TztZEV9FlXtTy8fkzx1jtdej6EyDbbaIxvQTmC5PtC+tquUhziphVJvPBxF8r6swtLaCArNnZkcsaCNRqfl/aROOW3ZzICVV5qOkhR8Z7Vjr4v+81KLAUE9P9I4CrFc2Bg5nVqSJ/+6usG//b9+UZM/7xi1ZxILm6v8gMpW6Gw3OU+yAnTBSclk0koHJWQlk9LmJk48qzmSe7XIwotbpDyEU4uqGyCl79K89wVENJsYjLG++IAqpgmcqm2+Ffoyg4d96CM8bStDB3uTmd+ydPmlnJ9lwMtPSf8w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM8PR02MB7973.namprd02.prod.outlook.com (2603:10b6:8:12::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Wed, 26 Nov 2025 09:38:33 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 09:38:33 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Khushit Shah <khushit.shah@nutanix.com>
Subject: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Date: Wed, 26 Nov 2025 09:37:42 +0000
Message-ID: <20251126093742.2110483-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0099.namprd07.prod.outlook.com
 (2603:10b6:510:4::14) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|DM8PR02MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e39c9a2-41e1-4aff-27ec-08de2ccf9105
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HXK2WT1VlqlCv56/D0CohLHeqNPG/MchrC5xOdtx9RcwOQFnYqjlSnJIlzgO?=
 =?us-ascii?Q?2Q/o0IYT579ue+6hDpH5HY1z+qcT2rRZBXa8ivggF4JOFx3yiDHwLgxlSOFM?=
 =?us-ascii?Q?s3rQkM/h+pR+7dpNfEtRoAHJH9M8dQzm5QQCF4u1RE3W/yZqNNLzorPn4Hjb?=
 =?us-ascii?Q?x/X0lDrgxclwkmN/OSoROH/0mc5JnmlTwEgzgQIhYzsE/mEUraBh0pK+b2Lf?=
 =?us-ascii?Q?HHZMvMlQtBb4VdGdwadTETnJKE6/uqQ9PpartkGW+INSg4FmTZnYoPR/xhA2?=
 =?us-ascii?Q?DZK892M32rjmMydrRgzYWcWsYXsvvLB0QLPw5avRCYQLjlYuXzPa2GeqZokL?=
 =?us-ascii?Q?CqP/MqW8jPsb3GyA3R5RakSkrtuGnIAWA5ZKPgju8MeKAmzHWuun/vB77LWO?=
 =?us-ascii?Q?1XG3DKPbiV3tNAP475PGbaZML3nB0t7JkR8+bkfB/3Ol8JRGJaqkMtQF2hcT?=
 =?us-ascii?Q?08V1f082s/DVcZPK92jmUYcIhBECOpKxpw4Bf5vWbO1eBs6c2mMyuGF3M1W9?=
 =?us-ascii?Q?Vk3raLMzkDwxPJvhGSrfZJNVoBejkWLRt68VfWSYlMqZYJFjcG9bIWhjNoBN?=
 =?us-ascii?Q?stQ2IFJEXkpkw/u0JHE9NIwD42Acr4UqboLtnHNlKwW4Zo6tK+NwXrInyFZa?=
 =?us-ascii?Q?csZggqX1eDuh++YBRYo42ObO1T3jayn68kQSBN+7pc01NA633g9TyWL1ML3E?=
 =?us-ascii?Q?2BSSXnmDPvNxoZQ1lTKIBYky4dfCGUXZHIuir1dKdDGZYm2A+rvIqyWZRSMS?=
 =?us-ascii?Q?sUw9veUv8k6Z8gLpBH6+KkLhZQJjBZuyyNxiWUjdnLsK7dAB0nyMIYWnU0pd?=
 =?us-ascii?Q?YdZbpBN0RsUI8cH8JP1JlUJu2cXqQ+cyBcg9ZPPWqgvEGKXIvhTOpv7thi+t?=
 =?us-ascii?Q?dVWw04wP/vrUdsfGQJoQRONWRRXQHKYWEnOWQ6/clLVBxxpuo5/HK2sgLAPC?=
 =?us-ascii?Q?cehNeDLdF7i9Bfx97XiuGL4u/V+fNI/N+cSTcm9wi8UxA1BKD7chN9Du53ZF?=
 =?us-ascii?Q?/zzv8tatlVRIJRh7OAv3g43VpAqFgzR1ifsdTlVvWVHVF/IK3GeuCNndMCWj?=
 =?us-ascii?Q?CAHl8QRqljo8j7l3uptKDz5LCKdJS5ifU/VEm9fZ1H8IvRH5nPny7xS0DIGt?=
 =?us-ascii?Q?IlKdJkJHc95gL8aHYD5JIqr9wCPr2FbQpTiu/XgWV0cxvt7eWXl5vFP6omwX?=
 =?us-ascii?Q?VUQzSmvvE7g8VdslMo8BMEdaxaWuZQVpfcCIh1+YyGC7G+6ufISka5WW6d0w?=
 =?us-ascii?Q?cl4vRwz9xyvC57B1H6YYRrtbFcSO813y7tbJ5DCwcGOUkbZ64FcseCR1Fshi?=
 =?us-ascii?Q?7RWHy3OYPiOYioDLNiy2xQJqPEgYHNTFVTjaHcZP9MO9YAbmChrujYZCkOc0?=
 =?us-ascii?Q?kj7JXPzO59sXsD6XUzl7NKCmFvftrEIsGTFgU66ixwj90NugqicnoCYyxkSe?=
 =?us-ascii?Q?jK4WFGWV1IoRfFgdUHwC7kUUGEo3eAPii8mz3z6jsgQFWWGqwsWAqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jc9unZGK1jCIskrUpfXnHEz678a+XgeoC+moZrXC+GCtG/adVpaNOjcLEmCA?=
 =?us-ascii?Q?9awS1tP3cL3cqDLVs/Odm9G99okHxVGKSNwu1SSMSk8f8ImGMOJrrdMrpYBj?=
 =?us-ascii?Q?Awico5OeOy6pvZ+hZVXQoOkugg2RHmOXSZvWCs3YcA/kAgBMSguNgIs9Iymu?=
 =?us-ascii?Q?r/p8RHJLZeDHTJzABgq9h++88vv7uphcqSe0F4I9qWnFw9hBX3SAxJp2fwby?=
 =?us-ascii?Q?5IR4hWkG2Ke483G8ku2Dgar3LucnMQh4KKrf2i2D0QAevZAceRqM9iLC6PVB?=
 =?us-ascii?Q?oI/im7Fhq+f4v2mt832jtRon0Y3CJjZRs2nF8iOlcYpmt3PupHUeKmNfoNY2?=
 =?us-ascii?Q?GpZJO6kAwQe3RMCN+IQ0z5sBD+q1f2qwkgfaLPo5w1otqjrwjM4p8WezXXvA?=
 =?us-ascii?Q?BDQLdCuFUWh+LcYbWN07BjNqOt+MlJRL15C1F9cl3NlhsgwpsZ6JZLkZeE2C?=
 =?us-ascii?Q?uXCLy5faqNNVsZaIS+P8gYh6qeH3pyEScVhUoCmrvZwgQzpLL55C0zaMyBkW?=
 =?us-ascii?Q?cb17iIeXiTE+kF610S+Xr592klcN0GFD+7n5ZsbWXa0JXrE2FfIxKYpn9ZCg?=
 =?us-ascii?Q?t2h9O69gdeW9yplaHDYv61rmGcrjCtvxgMDzz/0GZUsPp1hThAFPTSlPACrB?=
 =?us-ascii?Q?HEvr8OiCBIgOHuiQhXdMoPMYFEnc+Tx7q7rCPjWuFP0y1eW7KzdmvDZtQbBs?=
 =?us-ascii?Q?tlTF0/q7Q2WglwmPfPGuxHA99WPDPLGTfOlucnRccHhAExiNhq9OKHl9gWc1?=
 =?us-ascii?Q?nl2JSOiTsuJJ9EGIz387uGB1dlxYtIggeW+RQ2SEyrBxmAYHBg7xSTfXI/6F?=
 =?us-ascii?Q?2835BAVp3xoApURSXFPgzQRk4uB0eO/VNtbi1m6HVjWK8Oi7NAqbWUrXBq/Z?=
 =?us-ascii?Q?ShDWknXHJUUIWTsbrKzEEFeL14yKyPuzRWFfGKbhdGRKcvWTfjNsrrQ7Tszw?=
 =?us-ascii?Q?JHhEo3ECgmzVWQ1iO0xmf+OXU62uTBgMrDXSOQQ/bL0oGwI1OwFRj8PIfvTf?=
 =?us-ascii?Q?QlkYbJ8cLL3fe/o3+vWCND1BJaIUaSCTi9pWjTRt4BWiWAhIbJTUSwcKdu8C?=
 =?us-ascii?Q?iUVPGRsdY7h8BAGsIJZ5RXyhJciPSBNmssuAw8KguMlCNI9MDzXGAb7ClYdj?=
 =?us-ascii?Q?7hbkXzhSLpRhKJF1WusXc0kRPDJrhRuQbhynO7PRLdhffQxPEp+ZmOr19N9f?=
 =?us-ascii?Q?Rb5aI00HMOWbKt8OIyhUDJYH7Y+cayPZdv53fYCmu8HRsb9tSdUHRInHX5J/?=
 =?us-ascii?Q?hYoGRBdTSzv75MwrjIQ+quLW4kY/NBAhFkMvNJRDsKpS2vs/+cFcNkERUbfL?=
 =?us-ascii?Q?RfzB3Awq/FVTdj6jipgA0urgeTkeLtBT6XA/fWaAMT4fL656RjV6eoGr1ZEI?=
 =?us-ascii?Q?Nm3SpQ15RVpfm94wdEaAXyY8rluOL9hJhbJZaTH5+vOKRfMUJ1oG8/DywNXg?=
 =?us-ascii?Q?dJlFOWEFgCnGM59kJr6dzXtOWCjsJp90naAP2Mln8b4JUSGn1UTMG4VgCYCh?=
 =?us-ascii?Q?I5pQSlSZqTCTj6J8iN0byA24YIX6Gn+W/0tcf189BnHXnAgHdlhEjXnidEKT?=
 =?us-ascii?Q?GDSekD5llSMDBGpARF3xmVZippNnSNxHdepNPhJCjkxQohy16fnVG5d7XP7r?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e39c9a2-41e1-4aff-27ec-08de2ccf9105
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 09:38:33.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfQHygkksvqXs+n3n2gREeslTL7hSsXmIZJeWBF83bobGtAReS4KJLqOnvQzFz7ItjfxKPOCJ70PaqFFswKlmS0la5nw9qfUJJicSSqRm0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB7973
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDA3OCBTYWx0ZWRfXwjS6AGHwRjJ7
 pNg0gy056SRahvCt8nCeFKwLoj8MJhBiNQGz/71d0vYKZyW90E+2kXsReuc1Qyfd619IOnM90G5
 ayX2UZEINE+tvxBTR9/cK8oJ3ZE3lSwHhzFA4Gf5Zow4ebVmh4fV0VjizoP03JJn1OYTZYAJaiT
 sqKBkkR0vGKpxC1pbGe8y6X8HzQ2BEnsuOvtioygk5F2TT1rrt6fIjdQnPYQhcKlTNZiWBbVdFi
 dBqECzaVIFt6ChFcBRE40L6iYsBxizx7qe/n2BMO8hbf/iUUZsNJarsn4htLcCeV3dZZpfjVqjb
 y2vCvSjGqqOi8EyEBi2i6Q+r7N/ssDctwFKz86/0RrUb8d1ASJSe9mcFBorsw59zy51B0pMnqsg
 tfg5YI3tLS1eb9cF4142Etirf2k5rw==
X-Proofpoint-GUID: NJN_trVKpMxfgsZG95sKRLVdPpF__6Uk
X-Authority-Analysis: v=2.4 cv=JJY2csKb c=1 sm=1 tr=0 ts=6926ca9b cx=c_pps
 a=D81verZRVWLMjAELYjey2g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8
 a=SPKR8aX6tQ3WdjJAWn4A:9
X-Proofpoint-ORIG-GUID: NJN_trVKpMxfgsZG95sKRLVdPpF__6Uk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Historically, KVM always advertised x2APIC Suppress EOI Broadcast
(SEOIB) support in split-irqchip mode, This is incorrect for userspace
IOAPIC implementations without an EOI register (e.g. version 0x11).
Furthermore, KVM did not actually honor guest suppression requests and
continued to broadcast LAPIC EOIs to userspace IOAPIC. This can cause
interrupt storms in guests that rely on Directed EOI semantics
(notably Windows with Credential Guard, which experiences boot hangs).

KVM is adding two new x2APIC API flags to control this behavior:
  - KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK
  - KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST
[https://patchwork.kernel.org/project/kvm/patch/20251125180557.2022311-1-khushit.shah@nutanix.com/]

Wire those flags into QEMU via a new machine-level state variable
(kvm_lapic_seoib_state), which models three possible policies:

  - SEOIB_STATE_QUIRKED:
        Legacy behavior. SEOIB advertised but LAPIC EOIs are
        broadcasted even when guest turns on SEOIB. This is the default
        for backward compatibility.

  - SEOIB_STATE_RESPECTED:
        SEOIB advertised and suppression honored.

  - SEOIB_STATE_NOT_ADVERTISED:
        SEOIB not advertised (required for IOAPIC v0x11).

For new VMs using split-irqchip, QEMU selects a policy based on the
userspace IOAPIC version and programs KVM accordingly during
x86_cpus_init(). If KVM does not support the new API, QEMU falls back
to the quirked behavior with a warning.

SEOIB state is migrated only when non-quirked. Legacy VMs remain in QUIRKED
mode and behave exactly as before. Older VMs that migrate into a newer
QEMU version will also be able to migrate back to an older QEMU version,
as they always stay in the QUIRKED state. VMs powered on with new QEMU and
a new kernel that use a non-quirked SEOIB state will not be able to migrate
to older QEMU versions or older kernels. The state is applied on the
destination in x86_seoib_post_load() to ensure correct KVM configuration
before VM execution resumes.

Additional changes:
  - Add qemu_will_load_snapshot() to detect loadvm scenarios
  - Move IOAPIC_VER_DEF to header for use in x86-common.c
  - Add get_ioapic_version_from_globals() helper
  - Add trace events (kvm_lapic_seoib_*) for debugging

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/i386/x86-common.c         | 98 ++++++++++++++++++++++++++++++++++++
 hw/i386/x86.c                |  1 +
 hw/intc/ioapic.c             |  2 -
 include/hw/i386/x86.h        | 12 +++++
 include/hw/intc/ioapic.h     |  2 +
 include/system/system.h      |  1 +
 system/vl.c                  |  5 ++
 target/i386/kvm/kvm.c        | 46 +++++++++++++++++
 target/i386/kvm/kvm_i386.h   | 12 +++++
 target/i386/kvm/trace-events |  4 ++
 10 files changed, 181 insertions(+), 2 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index c8447499..72cfd295 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -35,10 +35,14 @@
 #include "target/i386/cpu.h"
 #include "hw/rtc/mc146818rtc.h"
 #include "target/i386/sev.h"
+#include "hw/qdev-properties.h"
+#include "hw/intc/ioapic.h"
 
 #include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
 #include "hw/loader.h"
+#include "migration/migration.h"
+#include "migration/vmstate.h"
 #include "multiboot.h"
 #include "elf.h"
 #include "standard-headers/asm-x86/bootparam.h"
@@ -67,6 +71,65 @@ out:
     object_unref(cpu);
 }
 
+static uint32_t get_ioapic_version_from_globals(void)
+{
+    Object *tmp = object_new(TYPE_IOAPIC);
+    const GlobalProperty *gp = qdev_find_global_prop(tmp, "version");
+    uint32_t version = 0;
+    if (gp) {
+        qemu_strtoui(gp->value, NULL, 0, &version);
+    } else {
+        version = IOAPIC_VER_DEF;
+    }
+    object_unref(tmp);
+    return version;
+}
+
+static int x86_seoib_post_load(void *opaque, int version_id)
+{
+    X86MachineState *x86ms = opaque;
+
+    if (kvm_enabled() && kvm_irqchip_is_split()) {
+        /* Set KVM LAPIC SEOIB flags based on x86ms->kvm_lapic_seoib_state */
+        if (!kvm_try_set_lapic_seoib_state(x86ms->kvm_lapic_seoib_state)) {
+            /* Migration from newer to older kernel. */
+            error_report("Failed to set KVM LAPIC SEOIB flags");
+            abort();
+        }
+    } else {
+        /*
+         * SEOIB state is only valid for split irqchip mode.
+         * This should never happen.
+         */
+        error_report("SEOIB state is only valid for split irqchip mode.");
+        abort();
+    }
+    return 0;
+}
+
+static bool x86_seoib_needed(void *opaque)
+{
+    /*
+     * Only migrate the SEOIB state if the state is not QUIRKED. This enables
+     * migration from new qemu version to older qemu version.
+     */
+    return kvm_irqchip_is_split() &&
+           ((X86MachineState *)opaque)->kvm_lapic_seoib_state !=
+               SEOIB_STATE_QUIRKED;
+}
+
+static const VMStateDescription vmstate_x86_seoib = {
+    .name = "x86-seoib-state",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .post_load = x86_seoib_post_load,
+    .needed = x86_seoib_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT32(kvm_lapic_seoib_state, X86MachineState),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
 void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 {
     int i;
@@ -76,6 +139,8 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
     x86_cpu_set_default_version(default_cpu_version);
 
+    vmstate_register(NULL, 0, &vmstate_x86_seoib, x86ms);
+
     /*
      * Calculates the limit to CPU APIC ID values
      *
@@ -110,6 +175,39 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
         apic_set_max_apic_id(x86ms->apic_id_limit);
     }
 
+    if (kvm_enabled() && kvm_irqchip_is_split()) {
+        /*
+         * If -incoming or -loadvm, then defer the flag setting to later after
+         * the migration/loadvm is complete, but this must be done before apic
+         * state is migrated/loaded. This is done in x86_seoib_post_load. This
+         * is because x2apic api does not have support to unset flags. And, at
+         * this point we cannot determine the incoming SEOIB state.
+         * e.g. for ioapic version 0x20, incoming state can be either RESPECTED
+         * or QUIRKED.
+         *
+         * But for new power-ons, this is right place to set the flags.
+         */
+        if (!runstate_check(RUN_STATE_INMIGRATE) &&
+            !qemu_will_load_snapshot()) {
+            uint32_t ioapic_version = get_ioapic_version_from_globals();
+            if (ioapic_version >= 0x20) {
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_RESPECTED;
+            } else {
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_NOT_ADVERTISED;
+            }
+
+            /*
+             * Try setting the KVM SEOIB flags if that flags are present
+             * in the kernel.
+             */
+            if (!kvm_try_set_lapic_seoib_state(x86ms->kvm_lapic_seoib_state)) {
+                warn_report("Kernel does not support SEOIB flags; "
+                            "Falling back to QUIRKED lapic SEOIB behavior.");
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_QUIRKED;
+            }
+        }
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index f80533df..1a671238 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->kvm_lapic_seoib_state = SEOIB_STATE_QUIRKED;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, const void *data)
diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 38e43846..5c22e697 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -450,8 +450,6 @@ static void ioapic_machine_done_notify(Notifier *notifier, void *data)
 #endif
 }
 
-#define IOAPIC_VER_DEF 0x20
-
 static void ioapic_realize(DeviceState *dev, Error **errp)
 {
     IOAPICCommonState *s = IOAPIC_COMMON(dev);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 8755cad5..38891e5b 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -36,6 +36,15 @@ struct X86MachineClass {
     bool apic_xrupt_override;
 };
 
+typedef enum KvmLapicSEOIBState {
+    /* Legacy behavior. SEOIB advertised but LAPIC still broadcasts EOIs. */
+    SEOIB_STATE_QUIRKED = 0,
+    /* SEOIB advertised and suppression honored. */
+    SEOIB_STATE_RESPECTED = 1,
+    /* SEOIB not advertised (required for IOAPIC v0x11). */
+    SEOIB_STATE_NOT_ADVERTISED = 2,
+} KvmLapicSEOIBState;
+
 struct X86MachineState {
     /*< private >*/
     MachineState parent;
@@ -95,6 +104,9 @@ struct X86MachineState {
     uint64_t bus_lock_ratelimit;
 
     IgvmCfg *igvm;
+
+    /* KVM LAPIC SEOIB policy for the VM. */
+    uint32_t kvm_lapic_seoib_state;
 };
 
 #define X86_MACHINE_SMM              "smm"
diff --git a/include/hw/intc/ioapic.h b/include/hw/intc/ioapic.h
index aa122e25..1e1317cb 100644
--- a/include/hw/intc/ioapic.h
+++ b/include/hw/intc/ioapic.h
@@ -28,6 +28,8 @@
 #define TYPE_KVM_IOAPIC "kvm-ioapic"
 #define TYPE_IOAPIC "ioapic"
 
+#define IOAPIC_VER_DEF 0x20
+
 void ioapic_eoi_broadcast(int vector);
 
 #endif /* HW_INTC_IOAPIC_H */
diff --git a/include/system/system.h b/include/system/system.h
index 03a2d0e9..7a8e7abe 100644
--- a/include/system/system.h
+++ b/include/system/system.h
@@ -14,6 +14,7 @@ extern QemuUUID qemu_uuid;
 extern bool qemu_uuid_set;
 
 const char *qemu_get_vm_name(void);
+bool qemu_will_load_snapshot(void);
 
 /* Exit notifiers will run with BQL held. */
 void qemu_add_exit_notifier(Notifier *notify);
diff --git a/system/vl.c b/system/vl.c
index 5091fe52..eb0e6ab7 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -518,6 +518,11 @@ const char *qemu_get_vm_name(void)
     return qemu_name;
 }
 
+bool qemu_will_load_snapshot(void)
+{
+    return loadvm != NULL;
+}
+
 static void default_driver_disable(const char *driver)
 {
     int i;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 60c79811..8abaa9b1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -292,6 +292,52 @@ bool kvm_enable_x2apic(void)
              has_x2apic_api);
 }
 
+bool kvm_try_set_lapic_seoib_state(KvmLapicSEOIBState state)
+{
+    KVMState *s = KVM_STATE(current_accel());
+
+    trace_kvm_lapic_seoib_set_state(state);
+
+    if (state == SEOIB_STATE_QUIRKED) {
+        /*
+         * In case of SEOIB_STATE_QUIRKED, do nothing.
+         * The support will be advertised yet EOI broadcasts will still
+         * happen in case the guest decides to suppress EOI broadcasts.
+         */
+        return true;
+    }
+
+    uint64_t required =
+        KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK |
+        KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST;
+
+    int supported = kvm_check_extension(s, KVM_CAP_X2APIC_API);
+    if ((supported & required) != required) {
+        trace_kvm_lapic_seoib_set_state_failed(state, supported, required);
+        return false;
+    }
+
+    if (state == SEOIB_STATE_RESPECTED) {
+        /*
+         * The support will be advertised and the guest decision will be
+         * respected.
+         */
+        return kvm_x2apic_api_set_flags(
+            KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK);
+    } else if (state == SEOIB_STATE_NOT_ADVERTISED) {
+        /*
+         * The support will not be advertised and the guest decision will
+         * be ignored (does not matter as the support is not advertised).
+         */
+        return kvm_x2apic_api_set_flags(
+            KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK |
+            KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST);
+    } else {
+        /* Invalid state.*/
+        return false;
+    }
+}
+
 bool kvm_hv_vpindex_settable(void)
 {
     return hv_vpindex_settable;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 2b653442..c31d7894 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -15,6 +15,14 @@
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+#ifndef KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK
+#define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK (1ULL << 2)
+#endif
+
+#ifndef KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST
+#define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST (1ULL << 3)
+#endif
+
 /* always false if !CONFIG_KVM */
 #define kvm_pit_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
@@ -23,8 +31,12 @@
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
+/* Forward declaration to avoid including x86.h here */
+typedef enum KvmLapicSEOIBState KvmLapicSEOIBState;
+
 bool kvm_has_smm(void);
 bool kvm_enable_x2apic(void);
+bool kvm_try_set_lapic_seoib_state(KvmLapicSEOIBState state);
 bool kvm_hv_vpindex_settable(void);
 bool kvm_enable_hypercall(uint64_t enable_mask);
 
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 74a6234f..dfe46c3b 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -13,3 +13,7 @@ kvm_xen_soft_reset(void) ""
 kvm_xen_set_shared_info(uint64_t gfn) "shared info at gfn 0x%" PRIx64
 kvm_xen_set_vcpu_attr(int cpu, int type, uint64_t gpa) "vcpu attr cpu %d type %d gpa 0x%" PRIx64
 kvm_xen_set_vcpu_callback(int cpu, int vector) "callback vcpu %d vector %d"
+
+# kvm.c - x2APIC SEOIB
+kvm_lapic_seoib_set_state(uint32_t state) "state=%" PRIu32
+kvm_lapic_seoib_set_state_failed(uint32_t state, int supported, uint64_t required) "state=%" PRIu32 " supported=0x%x required=0x%" PRIx64
-- 
2.39.3


