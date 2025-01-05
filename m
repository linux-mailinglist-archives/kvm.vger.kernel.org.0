Return-Path: <kvm+bounces-34567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC08A01B3E
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 18:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CA6C7A18BA
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 17:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BAF158DD1;
	Sun,  5 Jan 2025 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Bv0jvX/J";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QkqdOVqF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8905B658
	for <kvm@vger.kernel.org>; Sun,  5 Jan 2025 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736099978; cv=fail; b=PKrQQcL1cUEZWcLjsKBFVkbZwVE8JRqMTGsCN9iFqGhLy/Pw0jwAfUKmZBC7AsLq40+7ZBN2qTPSks3DfdG9AlGCoU6Y5lvzprxrGqPku7ChZppHqMOAC/sVX3cnaA8zchx7Vg/KoKHPN9dqDl6BvmFdrxkcyjkIwFGp4l5HPak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736099978; c=relaxed/simple;
	bh=WQ3yaS2kcM6m5TrtdHcrkw24j5b549rWQyxwuRaS3PM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u4oyzlP8HgjROPjEqBpbKUzP5mIi3SZxv6ProW4xY3C+u+z8kPC/WnAiui0XriFyAvTwh0Sb4ZtgOs5wCNkXnOZ2FtCPYHfX1HwT3t70V/kmKYOGxFb/py6IcMnaumsA+zyMMyVhhfmCMmsaOH4t4kHrLYuMJ5o3qfv3IWlYU8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Bv0jvX/J; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QkqdOVqF; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 505FM6ZS017864;
	Sun, 5 Jan 2025 09:34:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=zuy4fe9b9b2rb
	eduLhqqwkIcvW4e0r7z7NdDuYPKXRQ=; b=Bv0jvX/JrWzakJUG8ARB1OESJPcK0
	VhTnIpOe6vSEXiQUvTyItjrqDgtBx2I6RNA/fx6b5GQSU9V6xDcrwXeGvgsF2Ym+
	jVtwaly+walsebVbuhcV9zgC12DBU696IfqzWxXKFmpxJ6l+OsEz82Wf55jpBZs5
	LH9ZVdW8fz+w5OBJh9kFPiOjhym+4sOKYswtprF2M+vBxTTyHLJpcOsY9K0Q6QQO
	Xg/qk57835HzVDA0FMK+uUCjw511bS+wmCMSC8x7vo4RkdcxBpbSbA3HtudOtzOY
	QkXLThTW0XZKn+0XO6ciNbbkm5gQQmQCPezZ6aACU9XvUIlWVUKolix6A==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010007.outbound.protection.outlook.com [40.93.1.7])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 43y5d3hgka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 05 Jan 2025 09:34:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dbb/O35tCQy9S3b+8+oacxq3KQVoEzrTJQqQoOu7fV61JXEcalR2bsw2hRIN7ZsR4Xa4Brn7Ll22skBtvdxXgMRD3QmcxAs+ITS7o4ypruJeAM1Cetaej+V+6CLVWsnnDlz2f7oDdBUcfKxjCgxXC6tjlb1mlhtHfksl/PdqLsGgQXa1GD0qjxhqavpSH/tGg0Wkal/PVXdbwG68BMJapDQJ3++tkftXFdbpiXP8LJmYXmPrRClx403cXhaJUleuXJdWfVkdSZglztxuCYrZ1s8AOIv9pHzfZT3mKbDdZmZZsTVuQ7T1h8dTT7Y8N2oAmQkVJKSNic5/C0y9T83Azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuy4fe9b9b2rbeduLhqqwkIcvW4e0r7z7NdDuYPKXRQ=;
 b=l7rcyp08kFd7XTGeDoBFWx5CY9qNVlUHNRLZc6jzPSb8XbElLWmwkwzYz05/WZHQm7ukOk+HiUCpEZ5e+RmoZk+tIBFkYuaBY5URLvAMPN7K6peTraTaQK/H6U2XMIec48318sdfGqdkall60GbfITxHvlKUMQIyucnnSq8UwooKP6PQe4oEBTGM3++QMY2GH6Q/OdF2NZBIY9K1I4rqyFN8ad8azWjfNcfPgheKmSLfjLerg/oDo/Q/Lf5MfCxgy04kHCqzjiPm8O3lpt0NrXFr7Z1ZLn2DUhooUqlFtHa4ZabNb1lP/SUA77UNcu1G5xE0NNUFx/ulSnwBiYRP0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuy4fe9b9b2rbeduLhqqwkIcvW4e0r7z7NdDuYPKXRQ=;
 b=QkqdOVqFLVxEjmTHm1GSft4txwWhHcOfb3XryojwUxJSshK0P4tm/jB4u8ZwayFNYgaNQ/DxOX13PABgYqInCxvn1Ag2Hf5jgzTqLv5+f97JCqvThEpXBa80aOndjBJBj9urSnYu1hJfnRszr0V8Efi7Cqi9+OUwBKRlHSGu1gqEUB14+ERaT1cDNrFnn39rihVgBiAfdY3REz9NkQ/zGFPCV+rid9BGO5y51TEXqY2Ie81JKxGkari7/XAKvg+0zx5t0I4we8pr7xAB38NXYOrdpsRrcbx79CS9K0eiC0jC7sIlXJYF1CkjENazIf76bqIsDpY0SIFNgdHFDRMfhA==
Received: from CH3PR02MB10280.namprd02.prod.outlook.com (2603:10b6:610:1ce::6)
 by SA0PR02MB7163.namprd02.prod.outlook.com (2603:10b6:806:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Sun, 5 Jan
 2025 17:33:52 +0000
Received: from CH3PR02MB10280.namprd02.prod.outlook.com
 ([fe80::44c0:b39:548e:2e8b]) by CH3PR02MB10280.namprd02.prod.outlook.com
 ([fe80::44c0:b39:548e:2e8b%5]) with mapi id 15.20.8314.013; Sun, 5 Jan 2025
 17:33:52 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jon Kohler <jon@nutanix.com>, Andrew Jones <andrew.jones@linux.dev>,
        Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] Makefile: add portable mode
Date: Sun,  5 Jan 2025 10:57:23 -0700
Message-ID: <20250105175723.2887586-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:a03:54::43) To CH3PR02MB10280.namprd02.prod.outlook.com
 (2603:10b6:610:1ce::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR02MB10280:EE_|SA0PR02MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3686b7-f63e-4324-af5a-08dd2daf1f53
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wWK0+xbNwnnW9Lkx6c+14sU5iVg1NkellwWA7S1C0v/nLSqTyR4QowZ7dB9Y?=
 =?us-ascii?Q?Vw3F7S8UgVJM7+0DNCT4158dTyUvu4U+NRm9i8AMnmcbzkeq8iKcsJrQASTV?=
 =?us-ascii?Q?QzveqJCK3sEIlunMdYUCkQuAEjlNidHPHhq4APVLYcsmJPOu4iCkMFUsbM/3?=
 =?us-ascii?Q?EBkogjUufTA9PudquEcURHhzY919dzfpKK7+RRoBbqmRLpgAkyvtx+bbiSNF?=
 =?us-ascii?Q?vbHE6H03p7PWyxwBfEBy2e7GlbybCAnXed673qyM+ywalYqJvdT9QMhgPdZh?=
 =?us-ascii?Q?sghDuE7SQZ2H0PaCjdZRbyqEnaU8pkrWY70U0QVEZHlJCRVt/xUyk5rF7bNs?=
 =?us-ascii?Q?EYlDIpcuL8AwlCCH6hOjOqdX/ExtGSrNzyw3LLhVPlfZpJ/5mEGxTA1XgETI?=
 =?us-ascii?Q?lEazYH07k1NKaa87Bmoq/wWvagaBIDY+/LN47u7gyFAP6KZ17osDD87Vaga8?=
 =?us-ascii?Q?7NjVGjqHclpFWGYeHX/z0BswZnBlvwIsvyEeJaZQDytD+OA+2UQ/+9NzF/D+?=
 =?us-ascii?Q?+tjSDFwGJdA8haqfD4J4qp6M/IM0kvEVpJ09GBpZuIRIAJ+29LGYke5U3LOr?=
 =?us-ascii?Q?j+IUQ7a62MK0ZZWMUQLb2aiWhpxeYtzTzQiFfK9CNMfaqAnMcNYTFjA8sJRH?=
 =?us-ascii?Q?7ty7p58oNnhj2eBHDXf19mPuyNT0HRtn3I1nzvVp0dcMnWVA2g8pwMxd3rx9?=
 =?us-ascii?Q?4KyrZpPoDNZ+D2G0lTqtT33wNFJGo4vVObLvZrVsdGnX28kM+zY0sNv1huO6?=
 =?us-ascii?Q?aSBLO7JqzvtmFF171Lx0USdO3zJkCclYRjcqo9x8YBYADrluAXr0CM/ugw3F?=
 =?us-ascii?Q?GGkr1tIXDf+dLUYP2iBgpfCh8ykN74WoH51GZO3ez3PZ7v08OZms0zHWRBwz?=
 =?us-ascii?Q?SAqLI7/4/jUdBVS0FC0wLBbz8GttwRyMXag1Qt/5LHQs61366iHWt2hc90Fu?=
 =?us-ascii?Q?9F5Xz1HCGgiUmNdqw/svTLqU+Xv4cyB6tJIxAj++LSbpT51mgB3WUQJksSxr?=
 =?us-ascii?Q?WiI1RPZ+4+1lVwdMQqdIbg3xQf4N5tJnDE0DBblV8bkEBrt9Yr7+c9Gx3/pW?=
 =?us-ascii?Q?Da9aBYUQFkFOnBCfc3/62eCXcIJ3/cgG9s9q8UpYhvsDo2IBG7EwObSExy4N?=
 =?us-ascii?Q?kGP/KtUf0+kyKZzo/B+JDK53iI9bS1amosXPFQHEErwiXfUUKxuOcxLGnIyK?=
 =?us-ascii?Q?5EmRihl6VRryMlknrmUzNPZUdAP+9W/z+3moJ8ePzOELizt+th1Okl6OWTMH?=
 =?us-ascii?Q?VxnZsn4qUm28MA4SUQsQyE0nhwdid53F/MqEWv5B12hH4rDZP4tPfcFPKkz5?=
 =?us-ascii?Q?fNR5IqjBkbdR9c0k1FxbVr22raxbmj9bPDZIEB5STazpwWbfdqevklAiEfOg?=
 =?us-ascii?Q?9x4Xd12xhyQCVaByzZ4UsN0jKgssU2bqQEkANIRmURKiDs/i+lsU8dK5/394?=
 =?us-ascii?Q?ntWj7qedmo2A+1Otdc6s0xcS6aRCCyQD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR02MB10280.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cEG/4JbyNe1/lZNm7nWFxVRYIn1APEGIzC9J0zIEnapQCxvJn2qWz7Ct9g34?=
 =?us-ascii?Q?i2xWC+UIgWloz4wbJ6L455/j/mguWOcJNKYVqBikA6e0Cm32Gy3AOa+RnsfF?=
 =?us-ascii?Q?qFWjInEySds3KlSK4kWnNpvly9IL63fJpz+iihyzC3Qt1UiY2dVQZbw9oFkD?=
 =?us-ascii?Q?6cTUpsv8K5fEk8Fc3zUH69WXq2kqWJZjRdRQe4SlZWpVCo2Gv4OTW7LiAbAD?=
 =?us-ascii?Q?sA40y4DGmtjrVy9SKKwlEiT/axiUABRVAm2MrUzm96Akio+saQdoB7QVY8hE?=
 =?us-ascii?Q?lawz9RPc+7XXe6dRk2zP3l2Fcb6vn05V9QwBQ8oYrFULzyJ+RiuoDr0xmjAp?=
 =?us-ascii?Q?gCzXJ6he3gFHoz3x8ucncXdnsM76dhyDWzJNzMIOrenvDdlzU4PiIS2I9Oic?=
 =?us-ascii?Q?Yejt3/aX4lnmO01aj1bX441k0hqsDgWnHa1tpCTRwX+27F6rDKc0Uz/hpSv6?=
 =?us-ascii?Q?g5xDzU56T8SBOCb4UTbdEKzleWnZjZjv4T4MmiwdnbtJ40OchYa5ALt03iHN?=
 =?us-ascii?Q?CPT71Bkv/qH0MXpL0hola9segMLPAMNUqzIgO380J2MG8abX2AlBWN6m6cdy?=
 =?us-ascii?Q?rot1vMHir+TjpA4d+fA27+LPY5wFfivwvmfIBLwpjyHK0ENABH6A/us2CvlE?=
 =?us-ascii?Q?a5uCOuCz4DB5t6aUCMw7iojU7QrSrh7MlYoD96QGkaxW5X4JI4sgHBoa08XE?=
 =?us-ascii?Q?H4BQohqzda0t5WgX09hwvx51jBCBOcZv2hXiNB0d3TJmnB1037rinNUOoDc3?=
 =?us-ascii?Q?cHSllSY7BQGR9CBXj+8VW2Jy+/4pQly0/w79TM76kifI1Vr0b3LXZ6m10otF?=
 =?us-ascii?Q?0htbxVSTXCu0QXpKBhuw47BeJyqCLIPIYv0sKcj3TwWK1EQ8Xx1zDYYDi7jw?=
 =?us-ascii?Q?s2GqJeqkGUhOFWlUWgLHALV+qSDI+ZU1Vckpmimnc8DWBKRkkoO2tCQa4f0K?=
 =?us-ascii?Q?srWyss1buvDG4OwpqP5FdcaIFx+KnRlCJt02GGCHoaLcLlygH7GGokjth7iF?=
 =?us-ascii?Q?hjbKLNGwFZLU+ixYSMTaDC5S+AuGqaScfwEW0kSeoSYndIvfeZl1iHFuy7BO?=
 =?us-ascii?Q?4T7D2nOu7hlj/I4rzYdZdH/VT9bKYOJ6wb1dQ9yJa8SYjjal4WR8WbBIKXwk?=
 =?us-ascii?Q?EeRu4PQFGrQAmvg8FeA5uQdRWxxRvRQQpwG0QRNyi4UqgsNScMs8A3ruaUB6?=
 =?us-ascii?Q?483q58swBs7oWSm63TlV0ahV6zIuaFzks81EScR9Vimy/+x6d2evM8JXyW9X?=
 =?us-ascii?Q?B9f+rHbq0tGlBP3s9tjlzZVJ2TJzCLhZIcHhiJjbrWuJvRoI4FF1SyxxNRyn?=
 =?us-ascii?Q?y+1EZOey+IjzzRXWGqDz/V2O+/Vkr3eMABcDh8PpVQoFeqnFlMjS2YH8OYCf?=
 =?us-ascii?Q?ZCXafCMOKu1tEmLbnAi5WXYpjJYa0T16bUZxuvgju0BrtaVBUNaH4HYWS74R?=
 =?us-ascii?Q?iAjigUujyA5IqtHHB+BZH3m/MHHf8j8kk6tThJGOSIzaxjfIdYAqCChdzXos?=
 =?us-ascii?Q?U/Cg3WpLKXuz0pv6SyQttFU+Gvzs8dwvQNvz+vEvFXYqDpn7d3IZPNWnjKLV?=
 =?us-ascii?Q?ccVI60iTxhooZNK2TK33K7jIZTeLQo9kPRDDsv5Sf//Y7JhKIE99p5PHZeqC?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3686b7-f63e-4324-af5a-08dd2daf1f53
X-MS-Exchange-CrossTenant-AuthSource: CH3PR02MB10280.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2025 17:33:52.5760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0lkpw+Opp8eRqYBZFZTqVCw+/Jl3SpHx7Pve2+k8oLI1Kd2/bo4+9u4t3a5JzXqCalB/XirXqsS/PmuYFH1M2JwUhcm14zSuLIC0wUthXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7163
X-Proofpoint-ORIG-GUID: FNGoK0DGdh3SyvkZPjfpebwhRymbBTiU
X-Proofpoint-GUID: FNGoK0DGdh3SyvkZPjfpebwhRymbBTiU
X-Authority-Analysis: v=2.4 cv=YLtlyQGx c=1 sm=1 tr=0 ts=677ac288 cx=c_pps a=+1/HLBYLL4tv2yjlBWnClw==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=VdSt8ZQiCzkA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10
 a=64Cc0HZtAAAA:8 a=bFf2MPwdJAKBPSMp3sQA:9 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Add a 'portable' mode that packages all relevant flat files and helper
scripts into a tarball named 'kut-portable.tar.gz'.

This mode is useful for compiling tests on one machine and running them
on another without needing to clone the entire repository. It allows
the runner scripts and unit test configurations to remain local to the
machine under test.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 .gitignore |  2 ++
 Makefile   | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/.gitignore b/.gitignore
index 2168e013..643220f8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,8 @@ cscope.*
 /lib/config.h
 /config.mak
 /*-run
+/kut-portable
+kut-portable.tar.gz
 /msr.out
 /tests
 /build-head
diff --git a/Makefile b/Makefile
index 7471f728..c6333c1a 100644
--- a/Makefile
+++ b/Makefile
@@ -125,6 +125,23 @@ all: directories $(shell (cd $(SRCDIR) && git rev-parse --verify --short=8 HEAD)
 standalone: all
 	@scripts/mkstandalone.sh
 
+portable: all
+	rm -f kut-portable.tar.gz
+	rm -rf kut-portable
+	mkdir -p kut-portable/scripts/s390x
+	mkdir -p kut-portable/$(TEST_DIR)
+	cp build-head kut-portable
+	cp errata.txt kut-portable
+	cp config.mak kut-portable
+	sed -i '/^ERRATATXT/cERRATATXT=errata.txt' kut-portable/config.mak
+	cp run_tests.sh kut-portable
+	cp -r scripts/* kut-portable/scripts
+	cp $(TEST_DIR)-run kut-portable
+	cp $(TEST_DIR)/*.flat kut-portable/$(TEST_DIR)
+	cp $(TEST_DIR)/unittests.cfg kut-portable/$(TEST_DIR)
+	cp $(TEST_DIR)/run kut-portable/$(TEST_DIR)
+	tar -czf kut-portable.tar.gz kut-portable
+
 install: standalone
 	mkdir -p $(DESTDIR)
 	install tests/* $(DESTDIR)
-- 
2.43.0


