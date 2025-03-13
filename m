Return-Path: <kvm+bounces-40987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 083DDA6020C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 339944221B5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EFB1F55F5;
	Thu, 13 Mar 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B5WMdQKE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BgZp0Dwc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475681F460B;
	Thu, 13 Mar 2025 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896638; cv=fail; b=iKgXh5ZrzyDUarLGkhJGzxLfvtE5D71N2xMBk9QABM97cbfyqYoZv8wUmA7XRTw/wrBFNM7IxIPBIHLu5SkE46tCMKcR7YeDZoG/Tu9O5EXGo+UgGTbhwVgrGVCB0hX3Lp17K39jzEF+4QKu+CeBk6b1ZA/fLQhdnwjL+P9GyB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896638; c=relaxed/simple;
	bh=5F9HK8wDitgLiXRHnV0kkOJP9YR1aVsd3ME1Ux4l6l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GkClMkobL/3yNNzhRqnlgugQuqDhFOypf3p2x9DcYeK30sqrUjytNYa+uhAbjrNM3qU592RUs79YmHDFZI9/JRqTLQHrB7x/iCRUP/aEl19zupFVzYIMC39aSBPklGC79DCe26vJ0+3SgNgadc10B7Z8UFM9B3p5IcboeWq6UEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B5WMdQKE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BgZp0Dwc; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFSiGW011159;
	Thu, 13 Mar 2025 13:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1guDpteyDK9Mkh2C9+sR5agtugU71kb9jyl8MW/Zb
	Ek=; b=B5WMdQKEJFAp8O4Bws9l+mYi+FEVN2bwvgyKV23iiUedI/Zoclv5pdyVQ
	Js54C5lwIYbgGPrp8InPYViLaDyoNBmDF+KyYrXEOE/UEIjjPhbFuFlVDvrQrKws
	1kC9UwuLVoFLDrJHTckmEXJ4yR7KMz5jAWPEn3o69WSw7p+QuGP6keU2MQN8qWLD
	tjT7VW8kqnKapHWBA3+hAHh+cRWW8rAqpBL9bKop1lglmQdl8IG4TBbcnaYFbt2k
	thDpRrT7z/tcNik3GJXDOwuJkOL/fGVpeT5K7UusbY2/OQtdOuroA0lPzBtbodBa
	dPoP/UUkeFgzm6bQ1MOpJZnMMmKzw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010003.outbound.protection.outlook.com [40.93.13.3])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge76s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wK19Ax6z1w4dfA3WLqBX4rOr0BKFQ/HLLa0T+y/YCDVm6O8PqbZ1yNvdLPRacvxdjC+BOl2sp6PO2m6vS+OUotYcekQ3K6KMGfuRoKX5lMKu+trKdSYhSu+hGaG6rzduN5Mfd+i5s/JVlU0fzDbwuqC410H3dv7rnZ+RqXTB/WMBWs894rxktLzoTHfPDDgKNVvOci7MTssheDLi4XkjTt71aHab15fmHWJtxAukKV4FDCbYBxfCdX6YZ61+fDV0ymHPois/saFSMeq/RYlBOsE5Pifqe4NvE92fyntkGsMrbLw49OjSshULoQ7wjzkb/9B4FCUWMsARv6LnMOEdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1guDpteyDK9Mkh2C9+sR5agtugU71kb9jyl8MW/ZbEk=;
 b=pqYTXoZq8fUrd+D6qO8ybEL2HxDx5eirNFj3aT2SAnJtFAWMSrhJq2ImSz+rn3zLA/v9/Ac5JQaBDs59tIyfDbBaPUXVpliZ6U4QOh7VnnQIYiZFcWRYgTUAIHmtCyHnS/DqYI56KfK6MIMELLSjdY2T0VsYkhX0VaNHw4W4xviwZHGJPP8dL1qvjgfZWHYN7nFmwcqzzVvk2hD+ImZjv3idvMJhdSfESQrKrS++n44nFKNlqSxdkBjDU9C9ekS1RzeYRONNHCufmTk705Ho3SFowWArsxeBfLdpFyFhWkNacsnGDPy446sJdNK+d9srRolmpWlwatJ/mKnBRde7LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1guDpteyDK9Mkh2C9+sR5agtugU71kb9jyl8MW/ZbEk=;
 b=BgZp0Dwc0TKF+x8RUN1XjksuYKolx5Ut7wCXKfWAJSNrFIAsoKAu/VtUR6jkLAoCPtCKmPMiQ5cqTJU+Sl48kVL+lsrbE3MVPoHBMQHoWxQqrtCW9RjFuKzkWn18F+9/1/wehelqC/8bFxg4w+mssW5H67CzAOCYUUmsXucvNkaa5tC7OP7KKGw7nCFVC5mX6VEpDhWnrfor8kHvBmQMl4koo1JCoLxloMdOwQmmdyxQqd5yV4RiponMXJ4300PCO2FcfqezYvsZ7LlAkPZknC5zJhCuNxuigwKDymc3PjpEA/DGrBCyHC9+St6cxFLmBctt28JrcXHFmdWCDv8YTw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:20 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:20 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 08/18] KVM: x86/mmu: Remove SPTE_PERM_MASK
Date: Thu, 13 Mar 2025 13:36:47 -0700
Message-ID: <20250313203702.575156-9-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d2d77f-eaa7-4de1-5e83-08dd626b1465
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4tgZxpLs6zN2i16Jul4/A8zFnO9WeVX6DmBk9uaTlm9H2/6rw/yYT/xs/AXQ?=
 =?us-ascii?Q?aAcBUYgcD2CD8r9W0JF2MoVMB0JRVL0ebHo7qZS5CVXu8wejwy+odLdp0mHr?=
 =?us-ascii?Q?Dmu/ks3qyBYKZz7h2cQmCi7Yg66c2Xxg3H5Mb2+fy/pHWSRFoqHJyZ+TJZpJ?=
 =?us-ascii?Q?bO2YZHTXDDuoRnZsbKq0S6ojaS8jgF2+D5qwiG2Fqv9OQ0n3MQ4z9Iq7sPZG?=
 =?us-ascii?Q?hKaWda18EBG1jNhz//fduffLPpsZj8BY5g+OMgoLnlJInetS2ZoAZVDVvlR2?=
 =?us-ascii?Q?gkl5opzpUQwZljLOQQe8WB44czV7MIIBGo+z4RelKDnFKU7/lyn2F4x4Cep2?=
 =?us-ascii?Q?ir6/FwQokeGmU87rrkPiyGN/yjr9IS5+zzg7BZymu5zNIIaZG3bA1zpgnxUk?=
 =?us-ascii?Q?1YE58ynyLZiqoOk/OaJJR5POS1WuXeLMzC+2GYBIK4wQsNTDAm8xU1GXoZBa?=
 =?us-ascii?Q?ep35r4RdS2oehO8+vN4iEZklxIqQyaYEE/NMDJDGr2kGCkzttPl8xtF2r41s?=
 =?us-ascii?Q?enNXQwsGZuuVv9PZgEc2jQdTCbmXIH3+Z24OySjFD0ruLnLOplVhf/VW1Ty9?=
 =?us-ascii?Q?tOcig1epIJ63b9gApllmfDv0raWYL8bUJ/fIFubjGWwNb5Mx2MLUjXSbTmJ1?=
 =?us-ascii?Q?2aCckJa5bnWv8BpGK9pB8gU9vYJPpj+0ASrjWxNWIKtcM89EjDiBezyqwfyq?=
 =?us-ascii?Q?cKfbev3Vy/4Nzacjm5Gn9RrxBj23FlmB3CQblWk2hz8C9TB0ucOH/GSdv3cZ?=
 =?us-ascii?Q?lIhgoskvsDlqCnE9PASm/wH43jQOBChy1p4VE5qlNLGptu2GtWYVcatUCM9V?=
 =?us-ascii?Q?k98Q7hjDepxJMXYtjBzfHPRKGsH0C9scXW4NeR08TztI4BGeR00mCEDtA0Pa?=
 =?us-ascii?Q?6MA1z1LlA4aGX+7t7w2wTfm7mO+jceQAxNnZVcB+bbK9vQ53BbXE09p2ERUY?=
 =?us-ascii?Q?SC1ows2I96rXfUp6yBJPoDabQzI1G9dNXL1hFWQgig87cvnDxycKqOHrYVSV?=
 =?us-ascii?Q?GEnNIqJ1SKVuncuO8L2qZJ5LVkogvmJQcDM99giut3yiFx52B+ggeRsD5cJl?=
 =?us-ascii?Q?oejQH8FZp7dJdG7FaZZA+1rxKHwXA7+ZrljgrUFT+lHeKlNHiM79IK4qk5BB?=
 =?us-ascii?Q?x3gu2ERR6rZYuXRy7Tn/vuJ3CGiUfqPOeOuGWwV0Ou/p75MZZiZGJoqlNLCx?=
 =?us-ascii?Q?cDK/HyxuCrF0R0Re4XxyxOD14NLUUhC4qxRrF8T31TZ+XudIL7EMHJMOUg55?=
 =?us-ascii?Q?gi5B1fn+t25yu3ke5gf4ZQDLoBPaxCGvCnrZqmCVQQfxHT9rBjMML6KDy62V?=
 =?us-ascii?Q?H0UzlK73s+QnrzO3XbUt5qzJs/2jKJ/+GibwXomgVIG/h3j4Mb75rrkV2OAB?=
 =?us-ascii?Q?rl9zeslgnhpdqb+Fa0wbu6EWBZYUTX32nHOJ5y3qOjvBP6uFEmbNLh+DI6ML?=
 =?us-ascii?Q?4MwYOBoja4MANR5I854YUPinMXHwgw736IrNgx8nxDiJXEM/KK6EVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+aa9W0llT7NYPNRortyCC+LBNHCujhvBIVfFLZ1KsANIOp2Cgdkpy/VUXwO7?=
 =?us-ascii?Q?QHL4d5+qm2lTIGeNsfV7HWbmbWS+ZGqzTMR9PV1jpqqcHaTSKGeFuBipPHNo?=
 =?us-ascii?Q?QtQoE3OvOa002ceHOIRlCwLYs2QYY4S2F6NsJGNpOZXp0fVW1t/RVvi7EzY+?=
 =?us-ascii?Q?8xA01N+qFF87RHjruQZZ1N+aL/g93xuxxAxOVfMiDEw5SCpY1CZT4q96MiH4?=
 =?us-ascii?Q?uBQQkZ4hhFc2z8AbqyyHowfiiHTnkT74QYibjmfQOSDEej1hEIr2/wVVPYUL?=
 =?us-ascii?Q?MsB3VsD156wmQi7FCmwKIjMstdHeIbHhisaH9n0i7d6pdy47pnZIzX0Xqmti?=
 =?us-ascii?Q?ySD6Qke6hDV5JUy2Kbj5wQ+x5+bYhBmw1A7FxD9o1MuiJ0JjGraoNjPOrDBs?=
 =?us-ascii?Q?lzHNu+cDF7rgTjvnlmubTkeeN+TI0Tz/8EA0x+3RAVt36AkLonA9Ko7g2Vc4?=
 =?us-ascii?Q?eBbfVlRw/zDhRwOEwbV7fHCnVTAd1R6D81Dk/mnJkdgig7CMUcv5FljZIoh0?=
 =?us-ascii?Q?lrxSorppUCZD251JvHNW6Ncazb5a1y0RQDGkSsttMA9vbfFtmCEJmHlhJA5y?=
 =?us-ascii?Q?23Dvg+8CvGaswnixOz+YHTgOGbiQfMAWp9mtalBjRyT+hE+3r+6CVZ/A6K8Z?=
 =?us-ascii?Q?a5/mKwqiNsH4V5bTITRKfpL/a1DYvhklZYG7Aal1xvBjQRVL0rlOFe4FAyZp?=
 =?us-ascii?Q?92XCutkiIn4J37YnDu7Fahzn4A7yMkidNldnPg/KkZtNxQPcgI0qYdNM/ILx?=
 =?us-ascii?Q?UZGqvUbyY3u8N7xCaia0PZTj0axlMYXW7k6K36xCjkhy3JRfkIiXILs0T5FX?=
 =?us-ascii?Q?0zd0aqR0UNYElasFTz8oS66Gm2P341+jn66EeQR77pT495KDBxpf6FGNNYjo?=
 =?us-ascii?Q?109sdBIaS+Nxvhy5SCSgVsLHpe2ci4h4ku2YEmKZEzdM8yInANqFYHQX6NVL?=
 =?us-ascii?Q?XpHkNDCOjsfDGyBhBmhKvcC+NL9HQJYkKUHSqEkHJ/1aEmFu7LM8htiJsR8K?=
 =?us-ascii?Q?yXzyd+RGqAjfHqkQNS5+Q3EJemCmC7okUfIInm4f7PXU9Bu9uM8jh/75pA2b?=
 =?us-ascii?Q?0eetpMXUOl0rtfB2uCuosY8TTgLqaQ/ByCkIJVhTRz1KqLyhfTzPSIBy0Kbi?=
 =?us-ascii?Q?MJkPT8iRMg6UX2mA52pK8lIM+yS11a7FwCPmlp3uGI74KSeNEsf+ZD6f4iFF?=
 =?us-ascii?Q?P6AxJ2DwwIsz5XM+K3SFmG9mv3l96xmvVB0KA1C2aoWc/3jrhs1mk/H3d1NZ?=
 =?us-ascii?Q?rVs2pw/DzXbvoCN4uhlb+c8lUp75f6h1NkKUGn5W8BwZO+xPT2kHlryeOUj7?=
 =?us-ascii?Q?iUJjzUppEu0Hbl92nIDcGG7s2ZSQkiqPWrFlHQM7ezq8zVPNKSna3XnStHHU?=
 =?us-ascii?Q?to7UMIAwB1k4qhFqpPLHlYAsutEFvz1G8czv8lPext1tC0pRmtjzAy8WAjYa?=
 =?us-ascii?Q?wLv6C8egbp9LDgy9U1AARxy/6lOJvz4SMxG1vYjVj7cLZZWRrWxWo1rJeoX1?=
 =?us-ascii?Q?OsdjcHTW8CYi56eKfTEwKO7G/S2Yreo/3r9hnA8qkYJds1mlag32qBGiVAGM?=
 =?us-ascii?Q?+uj9IfJvJGWBgVnya5ayDKubdl8Vjk769J9nvK4cLX4t9C244GB0qYy3AWds?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d2d77f-eaa7-4de1-5e83-08dd626b1465
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:20.1544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbaPnK64mmNWNyrAhk8POGWO7gDlxXtb9LQ2c2FY1jX0grDR1XVR0BVp96GUYs9PprjVx5na98XT1j2njowTqkqdYomGdYxFSVc1mdFlwAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: 4JiSiVgT0F5xT6cJJw5_s5x1Fmbq1fDN
X-Proofpoint-ORIG-GUID: 4JiSiVgT0F5xT6cJJw5_s5x1Fmbq1fDN
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33bae cx=c_pps a=wModh8UEFt2TZzYV9Lvs5Q==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=sKgUPJO2Fa4kC_44OIQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

SPTE_PERM_MASK is no longer referenced by anything in the kernel.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/mmu/spte.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2cb816ea2430..71d6fe28fafc 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -42,9 +42,6 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
 
-#define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
-			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
-
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
-- 
2.43.0


