Return-Path: <kvm+bounces-42283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E103DA7733C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 06:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792633ADECE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 04:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921041D86E6;
	Tue,  1 Apr 2025 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="p3x0ylsl";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SuTMWA7z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C1417C211;
	Tue,  1 Apr 2025 04:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743480372; cv=fail; b=WobxpleuMCtQ1+mpLqu3fSdaBR+zZ/1SLsT1hlS4NlXhWieoxaC4IeyLciJ/+KgSh4vvp9M/OY6myR91UKu6bzeqBeYkHHNLgaZD11RhYjFFeRKFGRGR47B2IWUH9NpKUoN6/tbWGB7z4rIHLDOtEaYJApgxoEslOUrkiIAconE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743480372; c=relaxed/simple;
	bh=tEZuR2JDZdfcPs4AU/w4VNQI5IT+9YRxDwGp8gciVc4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hCMcmXwgkoNoe3LL6Q0WzNCxBIhU8JcJwTN+errCYIKvJm0gTYQjUFK6bzDJPT0TbZD+pGM8XD1hRPx9ymmK776H5SycTQ2+5WRZsGkk8ZhBICOBIVzQbbrCL5adeD0XKZdmHHJx6nN7MlOjhHKH1jNylSxt5q2hWhKm1REC0DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=p3x0ylsl; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SuTMWA7z; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VJlETb026789;
	Mon, 31 Mar 2025 21:04:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=SORhW/NVaJzmZ
	GrE1vDDEFpc/5IspP9jasAFzBkYGE8=; b=p3x0ylsl5KgPdgcAePp/NCtuz8Xwz
	cEyGMD89T21zr4P1DmFCoIKEX5Bs94oW1JM6f/kfXCr6QBcmGJrgRHdJRPz+BI/j
	hlONvXrrMeh9zgan68bG68ssgkrnQjanDGbL3FseEl+jBtcE2WUWfIHERLulqwAR
	JG0XrSxm60oLFwYQidvbvMiSqQvK40P3xtbSbyyHvqs/rTZzYTbILkOlHGl91JjT
	xLUw6VTEodHq4WXB1y1SQ4wz8xQmDsAJo2MBBPPMIWA/+L9RPlZ2Nrbc99uaD+vq
	TWo9gbReC8EmPUOZXGElIr1c1BRgcD+0XHbz7J9ji2raiEinNoH9g6LdA==
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45pcs8vmqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 21:04:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BxM/t/+7OgfpYtsu42LCzpvlmFBUwT4yYX/QZpdsCUi5v6+UnOQoKrakBJ8j4HqDCcDpN0ZWqExdkGSpm2W4FRYNr/h8y5LDFDXweMQygFsQbaHNwnZ10iaeBD/8PYK4uh6QAMGLdHjp3f3EDV8PTD2oOOAHy9hJ/yK5y1hrHijLpBJJmKgZXeIt6PS4T59aFHHwLZK85gEJr5sT2zaYMftpWJFuUkH5BgrOHdfZHbUeGFUOUCHNm6Cb8VdYSxufgBTIpMrndotftIdUO+X9rXMrXCJphQzL+uzL+Ag329NLt7f/JGQHHURdQJWPd+ke8TEHKKKbIKGFClr9LC4YFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SORhW/NVaJzmZGrE1vDDEFpc/5IspP9jasAFzBkYGE8=;
 b=H/n+JuRhX8EvE6Q9rM+z2sMQeEsXOn5diRTqKWfRuqAvww8rNPNx9rDfKcf36vCmtQVBMeQNoWG3wpuwh+vOv+Npn1zAg+moYeSVIMRew2GmLRQk3rAxF2UbWm1633U1Ac39/t3MuUfRiIjt6X3G/kIMFnWcaBjql6tqBxGpmRlkdxrP4yHNBRwpt05ZyRvIzixIIWVuv3YS8DBgGugRvtu8waJFcZbE3YV/eXL0Ih8dci+fKUjkWo2o3pxu1yYkLk3S0Hp4ckdA5hsgHoQRgsB7Pg9MUI0KS+W7ivHQ7of5hxm1aWCb2sdE9mu2ZO38O2GvCeh1r9g3LCoduK5qyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SORhW/NVaJzmZGrE1vDDEFpc/5IspP9jasAFzBkYGE8=;
 b=SuTMWA7zWqZne8vyHS+KTAXvC/Jfw0go8yOzDup37/rBOzjOJiwci7vyH9yKm3PaohlBSZrn8h26kIXThs05LmuhpaS6NXuujzMeethbQzhstD25LCkaFJ/yipxlmUKL/JG8hQ/SoHphimnBAWACxBxAxBfssc6H574rMtMPua0RxlkNsQbyQEwGdm8JRjN7jBuzR8qtw14ewEF/tR8VYsvCoOJKa7qFnyb8Dh+xwHkRPKcPzxNcUxJPZMtHBLoZqNCw6sAcVR5SChm1itWFLaUT72XF1Rtc2qvMZF0Z6oocejGRO+udNYsYB2QohNPY3V+As5RCaTQVwFtUERq0bA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB8513.namprd02.prod.outlook.com
 (2603:10b6:a03:3f2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 04:04:00 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.048; Tue, 1 Apr 2025
 04:03:59 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH] vhost/net: Defer TX queue re-enable until after sendmsg
Date: Mon, 31 Mar 2025 21:32:29 -0700
Message-ID: <20250401043230.790419-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ0PR02MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c7c42a-e386-4094-e333-08dd70d23b42
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oJAl9KYZtmsQRju0eskQNKW24XXUGgrwkrUhZCXtXNO9I/uw4sVDjEGqXCKc?=
 =?us-ascii?Q?5Wn0EigmGDy3YCKJZA9omEQspFSzzeM8JoOTRnc3uvKiWHP0L/A+vZWFHaLK?=
 =?us-ascii?Q?TbbOzxZ3+zmlROvB8Xikha4WeWBBlcaqrsuM7jrETy/xHpD6R2daDRYYuo1g?=
 =?us-ascii?Q?1IeATs4+h5lP5Dw4is690FK+xbW/UQ1Qa/756PCfoujQe4zKeTC0aIvZcDwY?=
 =?us-ascii?Q?1NCy2c5VpksLTHHuqbBCz7nJPX5/rI2RnVlGVb+x/VkfJo21Sdig3dsrerQ9?=
 =?us-ascii?Q?CJFyc2WjknPTZEB69y7UbaP14f9dXnjqQlPsBw6jkGeDpdXz+bn55MjsDATA?=
 =?us-ascii?Q?GzPcbTLL1nnGt08JlPQXWyPBcscRA1IL9iiafsUjXYGoR4FB5WwmgUMJY9qw?=
 =?us-ascii?Q?Im3evJ0HfSk5n0zbZnq40QrlwL4MRI8Fn+cDgX1aBpsBhnEDfR5OPaISDYCR?=
 =?us-ascii?Q?TyClATgl/zaySexTkHhzvjlWI8MyeHPvgw1L+1eJ8BncPB5lr6XwI6ClQwT0?=
 =?us-ascii?Q?+UdCBaNkcqTYjOm2jz8mAW8HDdelqOasdvflvJ2TYLMmZWFjFufacQ1jalkl?=
 =?us-ascii?Q?cP5LS1G+4+xieQ+iAvES98fNw4uYhTFKL5Yb8zGYZKnr25+fvCwfnva+AyTa?=
 =?us-ascii?Q?knaYAFNFE5Qnn8Exw6nEFRng/XYhfSuePnW8uLaGHxwNI3rSNQaBeHdBVp3H?=
 =?us-ascii?Q?a1+ISwFUQTqTlyKPITsPZvrBHhvOEo0BXGD/PH0aCaTjo0jVo7Gh3NZmKtkd?=
 =?us-ascii?Q?vpGQ5808ciF2GbFKKvxWhxo2KMCveQqoLdpr6XTv1pWRUiNW6RG4bfUPunXL?=
 =?us-ascii?Q?lGZSh7+QMzABpnMxR2Gm74wKzfw+CoA7dZarDN5qzriNhG7sf7YdawsOn5Wa?=
 =?us-ascii?Q?SZgNSdq7VKmlfzZW8lGPorvzQ0sSejZ50haPmS7An7IgBfH3Qa+AVeSY7XJ1?=
 =?us-ascii?Q?4gkuKzB0wSoqUt3rObXwPSFju9U5vTXRTFu3X1VPphGGLOkGcVCEl+jh/Jto?=
 =?us-ascii?Q?xzrgehY8vhN2kSmB3DlIb2w92WkoqjZBLveW5dMizoNw69tHSrI0v9was4C+?=
 =?us-ascii?Q?9wjexbWqCV3CTiIew0xRcMyMQdK7HCYT6DWzOhyjyUHZsbJBMmKetHCFMXE0?=
 =?us-ascii?Q?WOnlfaY3gj6HJW4qJZZp3ExkO9qx+aZ7g5q3PwSTKR4JcJ5jYTfxi+Kx+8mU?=
 =?us-ascii?Q?hGU2ZRNMIpRQPnO5IJI3lxsI6N1bz/T4uSuH84ouOy8rZSFlwq53nIW3jDTO?=
 =?us-ascii?Q?R1QV1uyTmCEkyryEHvpWJz4qvjK4u+tvqiL9Poe/XqAFTNJaNgjFBCpyGQUP?=
 =?us-ascii?Q?A20XJouHxeumnXOrkWLciGpgkZBBl/RLNqEtv3mFBnSz9oKdSZb06AONjz6z?=
 =?us-ascii?Q?u3wGiFlM4TFpXrIGeTxRpinc3pub1tZDtSCZyJed2HK7dpNkQ9cs104gnd3/?=
 =?us-ascii?Q?t94ZkveTS5h01zxTJCr+hsxXu86zAth60vSDNgMRBYdGiV0llhyxLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XQDYfI+SL0LLdyuLXFYsFfEA7k+AWb+CC9/CbYIHdni6zhe7GZRPaM/jtUjr?=
 =?us-ascii?Q?KM2506Ytg5et+Oongi+BPFZVN7Pvz1m9GYe3cncozU07aDOXUjBc/jajWJgd?=
 =?us-ascii?Q?XqxxAq6EVxkeM1+UK82Y+LqFrFT4duX+ERC+eKaeBHoMKzp1k2QXyx/PDEYB?=
 =?us-ascii?Q?709XfZF2g7+iI+Vs8B4k0JWrMAGWtX2667XVf6htAlzebuGTacRI+t/XadrK?=
 =?us-ascii?Q?hSn9hUf4zZKQt2501BxL8r38up7iGi5jHj4p1QgEDvqT1DQQs2Z95z256yMg?=
 =?us-ascii?Q?4u1HxWaspfADWW4Frcc/WbTKVbGDnHFgv1WthWxzFAQK0AjcLGMw3X5lBH9D?=
 =?us-ascii?Q?jrjkS405Q850XfJ/N4lzh8v+9BOt+jWP4c0Y3PE8ByJ2HGucsV+5yp79/BiY?=
 =?us-ascii?Q?PVLkdc3yncPYdD0FRzfT9spFnGMk138NMrajpwSMfyHXzYd1JpqUfkDYVhni?=
 =?us-ascii?Q?+ASzDgpNrTUflXaC8d1xbyg6y4iiY1BnuP37VVDQc84D043xmwou2Omsvh8c?=
 =?us-ascii?Q?eZZRepOE8jNKbt8SnLZULEEt/aS+4Qxcu3rFuHGSvRy8BMhHhCM694Kl83aX?=
 =?us-ascii?Q?wVd7BTaSXJK4YX1KrkbLUM91EsjIjABd7u9/cJpUQOQw+wA7QmxTxli8Z7EI?=
 =?us-ascii?Q?bvpa5U9LIPJ8s8MsP57bSN4I/DwDnyMUuZiNgUufV0OXzyPHCIRbBmdIYFBa?=
 =?us-ascii?Q?BtyxzTmNfAwT0hN/8lzG43Ep4q4zDIlYGl2TTjG0/St+yjPOKhsvDk+ozgBm?=
 =?us-ascii?Q?U7CKJ0o+anfxBWLQ8qMUs4AuKonfrn/V4owFAFavddqxiGyx9uZQQIqIiNVT?=
 =?us-ascii?Q?HdcQczWjN7cpZl6eEGAPicDuRhp/KkQsN4IzMWw5iBojNzxeQgQZ6ldRWy7b?=
 =?us-ascii?Q?74ZxB5vPAH1Nq036VGIB3pCU6Jki/IIqmISnv99u7jtJvfEtbmIk/FpdeDGw?=
 =?us-ascii?Q?2vFGR4zdoU8znfqN4aMsmQ3N5swirBUnACA1kusbZ5xjWqOPfmoxS7pS7qWh?=
 =?us-ascii?Q?C61uDHksAF67h8PivMlF6fC0xCC8Fgs47YZcEVyJ+eZCKQJK6RmQ4twdVQzI?=
 =?us-ascii?Q?fozXaE1QlwiVsqxy5u18FwVUfd4NpqVK4K0jm/hOzzeV/KkwYtb5wvyRyijN?=
 =?us-ascii?Q?OOeauGKqHTwNdnqdUGaJJW13aGGh743ls4Anx4f0Rwj39OgNRwrHE3nrQkR2?=
 =?us-ascii?Q?76gmvGauTK8UgwnI9vd47DEGh5ktVk0pRVNfdU3Sd5EmWb6rVPzyWEqgO7BV?=
 =?us-ascii?Q?4lQLW5SV+c713aKnzVoQy/+8fOChR7duY/fZf9wYRrssYCopgg3+f78+joja?=
 =?us-ascii?Q?7r5RnRIioyABn9yLpdMVVaOT7nZTrC5dWLG+1aUWZx83tAwJfBsRWFTAsOrH?=
 =?us-ascii?Q?j0eXk2sXK3dxb4t0V+NVrh3iaO46ysDSqadf8apz5H7R5FECVYLicrKktePb?=
 =?us-ascii?Q?C3Wr6ExN9cdK5w5jqVpR1VTyDhXXZTerkTgBhmr3e76qGedmOakMlVIThTPK?=
 =?us-ascii?Q?2i0rTw36uQ8jQrFd+4lTw49L/7z/Kb66JZHYBBLaPfCilDyvgl7uXiXiHLTM?=
 =?us-ascii?Q?sp64/AYXaX/Xzm4lgJUJB4Kf7aKrqwN/0s3yzsPN39oWxqsD63yGtuN7EuA3?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c7c42a-e386-4094-e333-08dd70d23b42
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 04:03:59.7492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUEFCHKEvUh88f0km8xansJZ4czFyd29BO/vySGFU0aJ7iJpBFfO+XWiH8vlk6PAGzAc2CdOeAtnSbty33qty5obTWDzPXld0MR+gIwUfZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8513
X-Proofpoint-GUID: joQxscvfP9fLFzNZLQh3WuBcATvyrKQn
X-Proofpoint-ORIG-GUID: joQxscvfP9fLFzNZLQh3WuBcATvyrKQn
X-Authority-Analysis: v=2.4 cv=PMMP+eqC c=1 sm=1 tr=0 ts=67eb65b4 cx=c_pps a=hSS9g3ca6WprpwKybkK64g==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=Ngy3d7EZHYTq51gLL0IA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_01,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE and
batches up to 64 messages before calling sock->sendmsg.

Currently, when there are no more messages on the ring to dequeue,
handle_tx_copy re-enables kicks on the ring *before* firing off the
batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
especially if it needs to wake up a thread (e.g., another vhost worker).

If the guest submits additional messages immediately after the last ring
check and disablement, it triggers an EPT_MISCONFIG vmexit to attempt to
kick the vhost worker. This may happen while the worker is still
processing the sendmsg, leading to wasteful exit(s).

This is particularly problematic for single-threaded guest submission
threads, as they must exit, wait for the exit to be processed
(potentially involving a TTWU), and then resume.

In scenarios like a constant stream of UDP messages, this results in a
sawtooth pattern where the submitter frequently vmexits, and the
vhost-net worker alternates between sleeping and waking.

A common solution is to configure vhost-net busy polling via userspace
(e.g., qemu poll-us). However, treating the sendmsg as the "busy"
period by keeping kicks disabled during the final sendmsg and
performing one additional ring check afterward provides a significant
performance improvement without any excess busy poll cycles.

If messages are found in the ring after the final sendmsg, requeue the
TX handler. This ensures fairness for the RX handler and allows
vhost_run_work_list to cond_resched() as needed.

Test Case
    TX VM: taskset -c 2 iperf3  -c rx-ip-here -t 60 -p 5200 -b 0 -u -i 5
    RX VM: taskset -c 2 iperf3 -s -p 5200 -D
    6.12.0, each worker backed by tun interface with IFF_NAPI setup.
    Note: TCP side is largely unchanged as that was copy bound

6.12.0 unpatched
    EPT_MISCONFIG/second: 5411
    Datagrams/second: ~382k
    Interval         Transfer     Bitrate         Lost/Total Datagrams
    0.00-30.00  sec  15.5 GBytes  4.43 Gbits/sec  0/11481630 (0%)  sender

6.12.0 patched
    EPT_MISCONFIG/second: 58 (~93x reduction)
    Datagrams/second: ~650k  (~1.7x increase)
    Interval         Transfer     Bitrate         Lost/Total Datagrams
    0.00-30.00  sec  26.4 GBytes  7.55 Gbits/sec  0/19554720 (0%)  sender

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..9b04025eea66 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -769,13 +769,17 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
+			/* If interrupted while doing busy polling, requeue
+			 * the handler to be fair handle_rx as well as other
+			 * tasks waiting on cpu
+			 */
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev,
-								vq))) {
-				vhost_disable_notify(&net->dev, vq);
-				continue;
 			}
+			/* Kicks are disabled at this point, break loop and
+			 * process any remaining batched packets. Queue will
+			 * be re-enabled afterwards.
+			 */
 			break;
 		}
 
@@ -825,7 +829,14 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
+	/* Kicks are still disabled, dispatch any remaining batched msgs. */
 	vhost_tx_batch(net, nvq, sock, &msg);
+
+	/* All of our work has been completed; however, before leaving the
+	 * TX handler, do one last check for work, and requeue handler if
+	 * necessary. If there is no work, queue will be reenabled.
+	 */
+	vhost_net_busy_poll_try_queue(net, vq);
 }
 
 static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
-- 
2.43.0


