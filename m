Return-Path: <kvm+bounces-66591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AACB0CD8181
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B3AD43002775
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E2E2F5A2D;
	Tue, 23 Dec 2025 05:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xTDjZJ5Q";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MjBux4Bx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ADE2D6E4B
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466306; cv=fail; b=I5tGczKDcpQXO3lqMfm3Os+0RUEo34FvjtPisdJ6J7KD/sXlhw4E9fFQ3Og6uZDeKn+yQr5RMApZTLm5ybwydntOcrkx47rV0knsiwiIB6qLwNgVVpAWgSPykyzHh/gccB2YbIM92R1Gf7dfvRldN5mYkN9pYCMoKgftGzNs5jQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466306; c=relaxed/simple;
	bh=7zWo0kqzLnFu8fk2+gnng8/Nu9QI4NG2daxZm17hxpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jpNicuPyVliZyP8GuCJx304Qi9Q8lDtEdBpIJW0Hui9kPwXXBzWlF3RDwT5vuMviUSeQjEIIqHu9Q3OmDcdczBXsE8t5sh7opkdZcwH3tVeZC6X1QQDRYiDXGPx5EzW5wBBa47clU0ZwvWAag8hpT4yjGBDl6O2N3PDUZq+XJkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xTDjZJ5Q; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MjBux4Bx; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLNNoQ723792;
	Mon, 22 Dec 2025 21:05:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ylL2kQSZTshaA/nqpTJfNEoFX6CnZ4IB1zPmvacN4
	hI=; b=xTDjZJ5QjetI3Zh0k7OgCMft9YJu7sV6eEmmFFMnnp/JYu2rWUnDaI3wW
	EQAujppie7n6ebBI2LcNuWvgud12U9EVlVk4v4EffH6HRJtk8B3gyOxLmuABbEQf
	BezjikVYw8YCY4QcmoAUcudQlFZPZchHZVHa7BwkZK1zFiWfLGZuGU2q7uLEbbSR
	OLX8cRmRViHSaWTg9cgVzYQ8nS3DRAitvh2//4ZKVrk4hjx+JzZlyoLDI2P89C6o
	GacC5wVjFdI77LE9F5xqxfOegAk2R0txtJ5IYqoQilTy5EnrPyqRDM/rEaxJHFXv
	J1NaMDISaWMEmGpfxXyqBoEp/Tr+A==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwva-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAZby3QGjgOFJR70JbgCIppvBpU6Mb8ELSCIa26MStBbDZpiaBjTBb9DpotLCjA3V9LFL78ln28aHUWu2SstMeIhOonmGLs32x2ruH44ehvW12Xh+LNZm18bb1U803yX2u6yJu5RRU5wOA2pSnmAqIsY+OoeJ+rxZW1eHNHkfo9xg6q/ckSg1ucLy930w3lvb3KKDm1SBeY9wmH1AgvZK+0sNj/K+RDRqfdxbctM+pNWyYY5NNcHgQCSP0Y9C7LdoQxG/5p3RT1/kt19KE0ZfaQi1EH+mrAgIB+xJWl6EYzIJ326WLvPWhC7ivmcSCvuycdhq/i8UjEE7v/922ZJzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylL2kQSZTshaA/nqpTJfNEoFX6CnZ4IB1zPmvacN4hI=;
 b=Ab8EHs+cjdcxWgiV0AikpJzbeoOhzLtHucrp+E4Qi5jeR03zS6FCr1z7MAf8gRy4OJVB49nqulzD/w4kLDeG46giXO+xhbjOWz22bsOvXI6Z078y+56n3w/shD3iBHKR58jlfNcdVsM9M2/1aPdGWIXYqfV1jnAztkwx7Nea8JlJ8sljqac6e/zaEuziSKHpMycNwQuXAsFm6SissdAkeEbdo6NgrFFgyM3+ohGs4kRYr2HKV0/ox76Ty1KdksnXduuupW/wCLpoXWB/4hCb6xM9XH5DXTjumnB1o5eo5HifANbHJ3EfpBaa4SYfP+0ctBQFCoZewwTx2EuqjPplEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylL2kQSZTshaA/nqpTJfNEoFX6CnZ4IB1zPmvacN4hI=;
 b=MjBux4BxOohP2/sZh6iTYKxelYlxL+cw6SjjQVbkTfX7YRvYdiRq/0Y+1p2BmLa+p7cjhwC4/Gt0wuzD3RJZCIq5TC0G8QmFHuPXeTWDDmkNTCr8quberBCJuPCgo6VSDY66B9SnMYTiGmSwAQ1YmqnY9m+GQFNJI+Ja6FqIriu3o7yvzV3cZlCEIM6ZU9EvcdIWvbzazqucLkz+9ct5X20gUfWy9VMB7zsbByzdxATOBcr77gkUzAcD0jp5BOGkmcJJZXMitun/DOelFEBmzJsUdm8z0aRgpH6WJvDQT56KBxhAbiRuenp/DFKKTQPqeD0R5l9FSFZxvkCppx2JoQ==
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
Subject: [kvm-unit-tests PATCH 03/10] x86/vmx: add user execution operation to EPT access tests
Date: Mon, 22 Dec 2025 22:48:43 -0700
Message-ID: <20251223054850.1611618-4-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: cdec2c7d-b32f-4e09-81ea-08de41e0d244
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oTm5Svym3AOlrlhhxZ9wfVJnuwX2juiQHwdwVk4+vpWZtb64ri/EIX41aDLp?=
 =?us-ascii?Q?AwgFxIErLj1Zx55z2abeXGeAl1JZuNbH+l+A2KoBoEd1Wj3x7PK/bBDwvm1t?=
 =?us-ascii?Q?uFDPngLHEbI2cdUnGEBctw7To0e+7kieJqmS0vvmi8ZjxlYPLGnyYgC1mh0I?=
 =?us-ascii?Q?xW24Bt/H4aoJorRLj2TCFReHC/2dl/mwhYy7U8eHULR8fX6ZhY6WuNax4o6c?=
 =?us-ascii?Q?1Wa3zvfiQtlnEEJeMvBY6XXZF7Wm3NmSqS9K7Q2mF6DuWi3XCRFqxVQ4qOkD?=
 =?us-ascii?Q?/QGE7lfKVCS87IcCrdjlm6P3v+9gB4ZobiLk1btide3BD7JZh4Xbh6od5fsI?=
 =?us-ascii?Q?gkS5lyLk9ZHGeirW05POR6ppOsiMsUDdl74FaCZ69c5D5lPIp5e72YfMEPOu?=
 =?us-ascii?Q?6wpJUAZEA++C0Js2opQ+ONf/OBavA6kdLKVeTUwTgFqToYNvlQenBBxwGt7W?=
 =?us-ascii?Q?/aBpk9iMl+N+M3NSyk4E3T5yvQI3mCt1D6XKuJ/Wzj/SBkKlcwrcAhEzOspP?=
 =?us-ascii?Q?7ai3WVVHgfVIu0mtrDJ9z9NBmAXNeUxW+kzPQ5VB/fczqZtibWXNsZRlRLdy?=
 =?us-ascii?Q?8aPWRV74u/FQ2XKzTxsE12jvFhS5kckSdrce/oYCuRi1u6HDLMRVSpWYw8R1?=
 =?us-ascii?Q?zBvymbIsxmg0u0+5Czu/ESapTLvK1t2rtITQTYa5jXrgVUr1rxZo2pe5RF8v?=
 =?us-ascii?Q?hok5ex/HGN7O1tWfii6dHC/tPuNemxjVaDYgmRvB5eReTYHWGGVw5Tiy7Pg+?=
 =?us-ascii?Q?DejkvbfgUYadSlLln3jMBVX81AzNCiCCizpqpMj2dXIwvMAJ6oufhZJEDZzY?=
 =?us-ascii?Q?HVTsQfXeA11toGHUkWYDhkRr+xiPBLCmRymjv6AGDYGFrFZXZ+/GhoxoTZ0N?=
 =?us-ascii?Q?ZxMC4yQ4HE06pb9tbkSW5UsEa+4ZbocQ4C4wye6oLRPcenRJQziGmMZGjvey?=
 =?us-ascii?Q?bqoxVxFpeA5LCSlYAvxUhfKxa80+Kwy6Mrw2P1z64vEnFX7+oKlNyWbLizmF?=
 =?us-ascii?Q?jyf91nvXY4Xd+iEvNjUUFH8RjdKCdtySKdWUHRLK/rgFebvTA+rg3LB3a7YK?=
 =?us-ascii?Q?KWPuo39eJDFfJOh3U/6Wlrnl7SMjuz4ebxJrp/K689fp7JSVx8ONcqB0se3z?=
 =?us-ascii?Q?k8Q+rQTz/Ym/mcQoWs2xOtpNPDfP51XH6RQPk+NsOPP7LjByVSVeHVwE7PjU?=
 =?us-ascii?Q?XjpKfJKxQlre6+wxk2KR/UiE8o9NqalvYCzJs7HgUo35FnK/sa71dZZIsSY0?=
 =?us-ascii?Q?8PjUxsItYt346x+EXAh9uLlfFqo4d3t8ImvO85CRs2ZhvSm5OsBrmD62MUBT?=
 =?us-ascii?Q?PqT2z3NoimQal5GnisTdeROCTlg0qqMwLxVChEx529XsPpqoSj4Nwh8kIliK?=
 =?us-ascii?Q?lQrS0wx7buTkVjRoxRkgb9O5KHbzmZvZzSAxyRd6FJZJg1Y4fL1abhuQf+hq?=
 =?us-ascii?Q?yMoCLtP2A5Z2EcMoag/p41o1CFlalFgAn/clWBmAZY5Ivev6jSSMj2Arii0F?=
 =?us-ascii?Q?ZhcgRq7RXgzSjh/VF4FsVlpA5WTm399rOs7W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7sk4oR+3zsyklWazIxANLdnRQOupfRSfax6xyryWkPq6K2nvGckzwyjnrn/?=
 =?us-ascii?Q?f4Ml7dQOeC9IbSVaArXvuIJLNvW9/7gXJodId+hpMDidId9B/pVp9Cp1Rw5P?=
 =?us-ascii?Q?3yXGIXRnqCfvT12Q5fEa4IRXK25RfahgN5Ag2+pH8EdWlTDBPE8929yPF3qs?=
 =?us-ascii?Q?W5fpo4gPpgWjz6DvC/arAQmdD7eHnUXBqGyeX9A/3RHArG3XUtVowqYr5Ftv?=
 =?us-ascii?Q?kZMMgLPCN+iA6WlZ/Fy6mhWBlQ5+lgTvBLQ2Q7DbpOnByy3Jdi7D/8YNhTwd?=
 =?us-ascii?Q?g0Xuo5chr+1OpmmekCpAjg0A4h/NUgVtG+RX5HtU7RbACVrfQhc5kKsteMgH?=
 =?us-ascii?Q?50JjBlyyEBVWDaxjMhS52cpgcW3zqP8t3MtZIpQiLWcYdp2dC4RGKkOUyRB+?=
 =?us-ascii?Q?hISSUpnI9LtGPGONJgeRIBlAUmEg6s4lksKj+dmVKZk/b7VSrArfGHoXkdIc?=
 =?us-ascii?Q?113DBt8hm3SCy9wX5H72kC2OS0wrnCtpu2F88MCCbhLxFn0JZriRVXKPiojV?=
 =?us-ascii?Q?Hrqow0tA37DAo2fA9Z1YHiR3pzqGfMw1tGoBCzmHXbNfazGPeTWUnCDi5pHc?=
 =?us-ascii?Q?zCTNUkVbmT0hL93yLN/ivYQ0O4zCPE8vhXFg8z2FB5SXD29iwMLztgWwcSYn?=
 =?us-ascii?Q?LR59YgE2P071maGKdBdyjKUuvWuuR4o9hGpCa1aYetHlv9LzgWyysZzU4r+n?=
 =?us-ascii?Q?T2oQA8GNXNwK2uWwqWiyCoQo0Nahwlh7Iw18sVF2thR3Z3uzP9ijIHIO6qoH?=
 =?us-ascii?Q?0AQEDoYZZ2IXLJ4vb3qwbD5/OQtYtzZdozW/6r/wm8fQ+h7mU9v8nISS7RkH?=
 =?us-ascii?Q?DmV+LTBmBdaX+V7t0Vv6huQrtNYh+UVI4JtaUuTn01ZVgwxuvLeVZYPl1Jhu?=
 =?us-ascii?Q?RpaedgYv+8f2Ww4OeKQDwHckB2+VOisxI1KELqizuGCWX79TovNxQoeAaB2v?=
 =?us-ascii?Q?wWSpTYuPuSuWtg9x9VbGyWRZFTVQws2bm9Hul2mWo6g8BZl7SKP8czvwsQ0D?=
 =?us-ascii?Q?jvPOnzUSONynqzLu29iT8UWIBK8PUCBZfwDYc4+WEIoHJz0/SGDe0cwBTBJh?=
 =?us-ascii?Q?vreBqTGy10xnIl6UVdZWxQDCVk5HMf1IzucqGStIwpNPQ1qQtuzpar4vAqWs?=
 =?us-ascii?Q?1jTaqkkfdwVroFSCJslu0EenyzsJ9HzCiuRrCQ/VQA6ZyyuCxq+07guj6f5M?=
 =?us-ascii?Q?zedCZuBUfZy+0M5m4f/GJtt4iFFo5hKfHE+uwfCWHoRcaQNEm4zSUDPGAUvM?=
 =?us-ascii?Q?w5a0wfWtnIL95+sFn9xuicne/VBftLuBLln6oirzHIazXKz3Eg1vfQa5Oy47?=
 =?us-ascii?Q?7uchIVJY9o63Z0eeluwCZHicMVa3FOcWeg3wTF10zVXNUk7SKabXYXE1s4YW?=
 =?us-ascii?Q?w/xdeRZY1HLnQ3jub9OZc9tPIZpdWvAj2NFCJVq+5Tgg5v6yYNIeVbtxhPxJ?=
 =?us-ascii?Q?G0Jp9LuBt1xb2X7QkfZ6Y+GAxjVz/M6IA4sqbgzDmRvU3OhChGseSTEbD8tl?=
 =?us-ascii?Q?3CrO2aAL8j89WfoffgBdc/CgdM/NDtw10e6Zli+eOhRt5Bj/kZqjCawiNew0?=
 =?us-ascii?Q?p6Opnfj66Hi7Ydty6wtenyLjhI/uwhpFmtbvD+B3aqJioYS5isLbxKDFlMBJ?=
 =?us-ascii?Q?OQe+OTldmtbAkKldcNdPQ42HcWn5pMqYeaSQROtB/TuyORZyfYLkVTvgiL7u?=
 =?us-ascii?Q?iI/eTEIkJAVISCYJLFQR5ESLk+9bwEhLs/C8u/KYahVTCKobiNPi6X4ogVjT?=
 =?us-ascii?Q?177Wab3xdwEc87o2e2aBRwF4gS8bYgg=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdec2c7d-b32f-4e09-81ea-08de41e0d244
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:59.0000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TDTkfQQqYDRxE2ZQ9PlZcdEjp+Hkqlf13baPeZBM5LY1yQ2alGXr2ObZZUCreULg8V8Bwvr31B0h5ED7Ez5ZLsamfYL8GNLHL3RZqKi6vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX02OIGgx+9QdK
 qc+elonQAuK20jFZoBbA5pLD1hiqH/K10h4n9lw6tW+885OfsSS6UNsqJA7Y2uGn1bzqp0qAyln
 p5jy8kjY/Ivvix0/fbHqFBk6Fp6JcMAnxSgGTrDKhp5gUF0kZx5urEGUrH2xPNamHZ0QBU0+hVB
 llkGCxJxGvchDF+1bfLr6K7RG+8jxJvAtQPKkGLgXnMQrnuHc4zwNc4dj438eT6vW8YZWvpOFmQ
 H+0gDigzVATsMyOvhgZZV2nTyXCWimEHy5H6BylYbFCbQ9x9BVi017SaGM5XpVLCdzDndHD9fiz
 QY7pEtrKGzVxwpTsRUtuGqH3+5NpQJJ/7QIB7sRiAl4kVrZCIA+WTTc/glszxFL8v/hc2UJLeUr
 xX+lTaEdUNDu55fVHUMTgPmZEwjO9zFQGlfg1ooxC0R3OlnMAppOwRgiYmWpIQnRoPw07KwP35M
 2aKmuElKY1z2ffp9YxA==
X-Proofpoint-GUID: bIE9dQFySQ29WOXCoqTBgYb-rTrHljBy
X-Proofpoint-ORIG-GUID: bIE9dQFySQ29WOXCoqTBgYb-rTrHljBy
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22fc cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=NqvX_VXME2EYbl0ecGYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce a new ept_access_op, OP_EXEC_USER, to the EPT access tests to
prepare for MBEC, which allows execution of user-level code.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9d91ce6b..3ea6f9e2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2252,6 +2252,7 @@ enum ept_access_op {
 	OP_READ,
 	OP_WRITE,
 	OP_EXEC,
+	OP_EXEC_USER,
 	OP_FLUSH_TLB,
 	OP_EXIT,
 };
@@ -2717,10 +2718,20 @@ static void ept_access_test_teardown(void *unused)
 	do_ept_access_op(OP_EXIT);
 }
 
+static u64 exec_user_on_gva(void)
+{
+	struct ept_access_test_data *data = &ept_access_test_data;
+	int (*code)(void) = (int (*)(void)) &data->gva[1];
+
+	return code();
+}
+
 static void ept_access_test_guest(void)
 {
 	struct ept_access_test_data *data = &ept_access_test_data;
 	int (*code)(void) = (int (*)(void)) &data->gva[1];
+	bool unused;
+	u64 ret_val;
 
 	while (true) {
 		switch (data->op) {
@@ -2735,6 +2746,12 @@ static void ept_access_test_guest(void)
 		case OP_EXEC:
 			TEST_ASSERT_EQ(42, code());
 			break;
+		case OP_EXEC_USER:
+			TEST_ASSERT_EQ(is_mbec_supported(), true);
+			ret_val = run_in_user(exec_user_on_gva, GP_VECTOR,
+					      0, 0, 0, 0, &unused);
+			TEST_ASSERT_EQ(42, ret_val);
+			break;
 		case OP_FLUSH_TLB:
 			write_cr3(read_cr3());
 			break;
-- 
2.43.0


