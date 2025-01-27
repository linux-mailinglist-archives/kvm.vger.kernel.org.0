Return-Path: <kvm+bounces-36697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44880A1FFCE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F9753A40BB
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012971D86C6;
	Mon, 27 Jan 2025 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BK9jWk4s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U2dhenRY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75C31917D8
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013502; cv=fail; b=Vrpc+X8armSqEEe8Yn+SVMNuKXBvb6XRc6TOF0hPm1FV2D7NQm+HzIaAe44Tgx77t9f2CPRmem4KlWdSSOHv/e48KdxTfU6J9C7lrxw3Y1lddZ2Px9vZYnjCzNuBEoCQrttqQtfQnifjnRn47GJweoabAqzg3wS0V7wXWGTt3jY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013502; c=relaxed/simple;
	bh=fO133q1KRSen3CrQ088uCW8V3UylGdPZxHXaYU88//k=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZR7/I6Vbi6RP3wD3XlpUYn56sYv9YG2HMdlnUx8zBMSd3i4V+/36b7kNHhVEng1bh36uU1elVwW52xUsKnMKcFbZelkbUI6kzUAjNqz7N9dBVP3qt+kYhB8GYuai/jmpk5Cr/jaPg2XVnrbMPAZzm1OT6RFMA3JdnPRSpRwcv6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BK9jWk4s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U2dhenRY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL0s46024684;
	Mon, 27 Jan 2025 21:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=X6hOvBW3fcSp+ALW
	K/hHpN8VrPAuR+8HfgtZ6g6eNx4=; b=BK9jWk4sH3/gTMXNid1y1YR50iyMwKTt
	4DQZcLc2Y+oV0F3p4j/RyX00SI1KDQE89wX8Wep3R6DpI9YGQhk3UNMkKd7NhiVH
	fgNnbmOC8DG56yH3O6eCGLyC0MNJSHa6bTXYEB3Arb2BLqyUymA336PME6XT9pvy
	6YWcLWY0kZsceT/TtOrj8usVdh4f655VzF8pAFOTLAxSh51aHqF7BDsbKfNA/X9h
	7arhx+ZRr1mtBJVIZHhCOA0yGcP4wW4HN9Ac7HEbryoTOmZuEfaffuANuc+EtLLj
	1YdSWAo2RgqySSWCcl8d5qG26EZsr1VPAsbN1d1aTwjYzNeteDaDTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ehpc825k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RLFbjt003407;
	Mon, 27 Jan 2025 21:31:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7k1b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1VbPB7LC8/kZR/a3gvPHJa88l9XRitcKLviIU/SpDT4DWF8eKcB3+HPi16o9kFCywgP0DHLF/X91cszhcy3FNpUSkxvtcL2UXnTFvpqWaIG95pQejsa7YKXC15NHgNUC9TUQnYL/oJAlNY4MCH/HmpQ2wEb/ZSWrovXw7mgTAHKkVCAjn5gUsCkomL+8Af6fmDe1MU/8ECjN0qpu6k61+r3hsnncXvx3QjjvtaNPVpThusrJ0aCEZaeSDqo5THeUDGFaC4yKQGSmpJv11QunMNlyejD4BRpMnh6OYFRKE5P3r/gZ2nu2gtaSE7e6LUVLvhl2B6f9qMT+09AghXycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6hOvBW3fcSp+ALWK/hHpN8VrPAuR+8HfgtZ6g6eNx4=;
 b=I9d9bi9ACtwLhJXfc16NL1AhkEYlignnKtWEpcyQEwvJQeDGTv6byvO3S6/IdMx40/orGQQMuJ7kb4un1dH4lPr+hay2pAJHIHj0pgehWhRAoW+HiZ4eBnL3ic9o5HbUuhnMtL5c2E+QfpBEta2SIt42I+KyTMEaf11ou7kVa5liIJIhO00Xd1utgLRxFEEdOKKnWOEJVl90mPJsghge5zZBrvdDOHM2GjzGqqxdqUEUdsP03Odk3N+hMvGN4tXNL2n5uqVeW9sbIOZKEePxg811USkzcs2FlJq5nD89z/lqazCeZDRbzJovONXqHa85mL0ZkYNTWAx+rTfg+TxBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6hOvBW3fcSp+ALWK/hHpN8VrPAuR+8HfgtZ6g6eNx4=;
 b=U2dhenRYYKURtHrfHoPGLvmkpkpldFrUEPH+Md/ujOBFVy4n4yge9EsJUrOmmvjpRD6iN46Exn526TLeHpvdBm+5b2KZsei/Jq8IeRebDXtNNrUzTTw+KfIp6Z3BO4k7tR+Fa6xjDxUsRxypwdDWQpssIJjzAyiCASqQNL/EP+I=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:21 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 0/6] Poisoned memory recovery on reboot
Date: Mon, 27 Jan 2025 21:31:01 +0000
Message-ID: <20250127213107.3454680-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0273.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: 5770e521-13fc-4eae-5021-08dd3f19f103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C4qshRji3XNuVe4Rp0iwmCt1niPrZDKt4C9i/vc7synihtbx0Sba5D6BOWmT?=
 =?us-ascii?Q?bgvaTsfUPkWslaqMaFuO/yReKoYVZgP1DQJKk6LwEL77zeisjz3mjFQ/ZhD5?=
 =?us-ascii?Q?f4DA8sg6HnO/VOj0Xp68RtZmmEuZCMHqAQF2BOY3iXv8/r5qHK8yxZuRWodH?=
 =?us-ascii?Q?JHNgmN69rYA/y2MVCZTHxS7k7l9Etdbw9fB6o3glAWcmWbT5TM1ew3L2REim?=
 =?us-ascii?Q?c7e5nTCc/JsPemOFq1ynF1BOvKWvxjx2NKzFUZgfs4LUrMXVVh00N/sjbyAP?=
 =?us-ascii?Q?EeEeK6NWKoNBPwcpYs0fA5gJk3C/RqMaKM5OYLre2kH3GSetRBtw5FNmJhg/?=
 =?us-ascii?Q?6iZUoPHeIS1oAWWoQE4OkqvCzKo42x1IB7PX2ONJ3p7B9KkOK892m4xvDQ3t?=
 =?us-ascii?Q?djkLLqhrfs71/F5dcTdSYhw9CXR4efgEtFFoLSPGeWwOAbjI8x4r1GwuZMqn?=
 =?us-ascii?Q?B4Osp4X1pOIVvCElRcPapH8ougBFyth7mQZzUuD8z3R8pXUxAdyWBfX4uMa2?=
 =?us-ascii?Q?8i0DMYsVHIw01cXFu6OOqxBnp/17GAVwa8ndE/Qsi+b+Dsi37DVjGZw7s2dI?=
 =?us-ascii?Q?kJp7E94lATsvGqBOuS8H3m5HV3GFLF3OMoRYrRMAym8jJQBll/sUXlP6X+Du?=
 =?us-ascii?Q?NTOv1o62yPZSUYl44rztcGSwrEyGJ1DG81AV7dgaFV3JXrbPrRBKnTjgsO8I?=
 =?us-ascii?Q?3fyff145/78o1m2Srcr2AWS5mtEZocXGv5E9WW3d0m7OBST7DnxVZfsvtz3D?=
 =?us-ascii?Q?dVleURbVqn/lkrhVg+u8U5c+2KrmfhYGG4Rlpm/NeVW4Rp95VKmmf7wck5kz?=
 =?us-ascii?Q?ITjb8y0bgy+RC8H07W91Tre4JKk5DAtaMj115q3XCGmgODcIFgzMq+Fe8P+e?=
 =?us-ascii?Q?VDByoaEQpxF/8qAffPo+siBh75GMw0tRfh+4Qm0jqMJH3Y9r5jOKhB2ErugE?=
 =?us-ascii?Q?HHu7nRMDGimsHOdYZTk23OkvkD0ewItgCS6kFEsf2+f3kaZn6O95nWwikuVU?=
 =?us-ascii?Q?9uorM/2LiP5M8oDMxOBahc2TEE4h/lHaDpcItO0ZJ3seOVgB6nZoxluJuCUh?=
 =?us-ascii?Q?ugP4UkWOocJ1vv/j3Xe3q47Mi+YgCFiudcHXOrBOSAnZuTROe34NVkr8csGr?=
 =?us-ascii?Q?ve3ir9QWhi3IEtc8A0lTAmi2yGQNa6RVVhaX2AxQPlE0xhkUS28gAT6Y5yFS?=
 =?us-ascii?Q?COUHQhbng0jtrESG6jyuVVXfDJagEWygK4UWo5CyFos8ZbaNJiBynbkI2Pzz?=
 =?us-ascii?Q?FgMEyNK2L5Nh7gh0VXAYNOEr1CtYn0UCkY271dX9rxPBRgVr7wAE9wKxalMH?=
 =?us-ascii?Q?gLHo3N86V3LNg1ae9+6Ls75Zdgk4Zbr0H4yVlF//xVnBhYQDv+O1ooLKHYos?=
 =?us-ascii?Q?40N63DhktFRQkOzrxpvwHzAK/Tki?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ZOAc/UvAIXypUGALA7IaH4e+ixnaK/Iu1qlIy54/Xj5/8P88BzT5ZkskwOA?=
 =?us-ascii?Q?SIiH/N9/Lk2H8xwMUda4Ctw2VBnVPzqGsiqltwj0WtGF5inC9ky+EzejwsCO?=
 =?us-ascii?Q?i5ppoG4jc1Gd/o36XxTDP9sFVfZJ4rM2SR9hPTSunwRadVgj5c7FvRFZc8QK?=
 =?us-ascii?Q?ukXQ5c4QPyleyP6dvx4dmmeZni5aM0H83XTqZDEZ3R25LRHLiLNFCzvGGoOt?=
 =?us-ascii?Q?UmlFrfB8lDM+5P6/fIDJTY7maxKq3x7H/i8xmxGC8yrQ9iRASu7+qWP9KHpS?=
 =?us-ascii?Q?tKXsbJongI4IjBD6L97bTHCBeXT5Go1og8IHfyf2hyy+x5VPaMeMlNS6Ik8N?=
 =?us-ascii?Q?4WDs5RR0ygB2L2ObCdjARxvEL9+cj0BftQ3fiAgQ36betQ1FDV4XyONuJ0Uk?=
 =?us-ascii?Q?5K/+qL49wZp8+vHj3zIlkNet9ooswb0N5lax0WGBUbTy8SIVheDkOSjNqmUQ?=
 =?us-ascii?Q?gQK5NriBjCGpokm/bXpHCAlofgKdOyjVz4TQit8J8FyDNIyZehEQ5Bfye+iW?=
 =?us-ascii?Q?Sgc40K4PROLWyDvxvz+9VZztCF2uWE1j75YdNQz1ZpBQZxU0134r2q6QpgS0?=
 =?us-ascii?Q?J+yE+equurEuLNKx+x5/QDJVgySCe08W/vXjBKJDI2RzxZGvh5nbWKYgP/Sh?=
 =?us-ascii?Q?DIgFw4AAI1uv9Kqs6MzfRrjKhqYzFReeugxvScOs8FM1juttjCtMxu/dA5JJ?=
 =?us-ascii?Q?TJGcWpeWTeYRhfamQ5VmQd/1yih5Qc1rVgMDOgC9TzGKPtLggYTd78anuPuK?=
 =?us-ascii?Q?OO5CjNYFyaUW2JvLC+HgVCAaQGCD76JmLpQLd0XqqDdtS+5aCcGgA++Doswq?=
 =?us-ascii?Q?1FL+2GYCEOfgLD5RhtjFfeOy++fWPm78Bba3r1SAnVWWZe4Nhz2sFqyvyA0e?=
 =?us-ascii?Q?BG/hoq3/xyViPjntZcBIppt1NjotRoTnMrjeCtdwmWNHZGGdrMla8QBQQLu/?=
 =?us-ascii?Q?Tbf4FZZKvuf3p0IdG3itcmIh3UlMH8tQxQu4M5HqzK8t+VCVLa0kO2qQ8C8z?=
 =?us-ascii?Q?9WPEdSBvNa84Y+qA8XPT8Tx5YT/I7bIVCbYdp/wBee0kn2xSdiD2WOKvYVTy?=
 =?us-ascii?Q?qSh7oO/iqOVFbISHqAUP7y72jOLkeOIPtpfiSfNnC3WN1GuSVRmJKnTSg8Dm?=
 =?us-ascii?Q?wV+OiXUk4MKH76K2vQHIUqeyeH20EmkHc5hKt88z8JuM3L0WqyI2GOEYjWhE?=
 =?us-ascii?Q?7dm/gDXc79e9LKjRrPDdrQlOOOkatFK6FOsnHjT0KnKPJH32qLQG04ElZgzx?=
 =?us-ascii?Q?IXp2K1d97/a3FKTjmaqpWxtyLqqDRKd6t7sPAJ+hew4Rfv/ZDRhh5MhkGsnd?=
 =?us-ascii?Q?wRbapc/6aIWu23aHs6OZQWMZSW7RRa0XDY0is6s8sBs+PrflaSwPT3qKEe4O?=
 =?us-ascii?Q?9Ue+Sv+roAyMyRrJv6t8+q0UpAzR6dC19Oz1/eot2eQYOG6W8I2MIa+XdYFL?=
 =?us-ascii?Q?k0xr0QwQA8Z55ILQHV5I4aqJRQBJ4sCh8yU9xLmZUqF0i2VdRiZCLqToI1gv?=
 =?us-ascii?Q?x5ClddDbBCLwjamNWpKSgZpTtXJSzUWNSQbPbuGGovQF00OwIGuvxz9HDZYR?=
 =?us-ascii?Q?rqNt/L1ovSjxt1SsenpPHUyXeLTtisloOl2w3Oe08NgDfnEZi3VPVgrJqU8j?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vQWN0lOxOf6Cvz1pwB2ToevH7FBRwtFTBoKceQWSvxc77VqexG8g1v1z/9PCqeqcqu4hsBXAa1tS2gmMVSwM4Tm/4WaC5f4hY2kaTu4TYZCn1UrRZ7lEPLuodrR/zADjjNLt6wxktrfRSTAb2m2EGmyEjYqPv3yYO56GecizsPkAFTwMEW4hXE/h2yFfrW84AFLm1FhXlTYeK59wMsMUhlb5YSDkxiqIIqeF5paXWXUr5b4EU1KNPD4sJvIIwE4cjL5ve5aoZfwhBYrLtL/UGgCzKmfkG+AVTQXloe9mjTYcb8q+mB5KcxXt17kqhrhIBKA3n+4jpHTS5F555hwLy51S+F/GbOn708Nd46k+wi3kQtXp1nIo5tLlj9zE9QjRC8PwSltOEQxMLwq2vzsCpNiZdWdCGGohp754cyCYNQygUFt/DvoikE5xnv1PjGcjGBCRmBcuScoR0LySL+sUOXQGQRxhkv+ijL+vwrLYYl7Yi6Fx8I9Ch5PrTyDp20OmjCjPaiMG853oGueEO7kUYpIJKt4LBaNy8Ev73IngUziA1u9XQxm1NoEnJCrjtteGjU4vI9a+Dz68HnWGuy+0Y2Kr16JNDcmxuCbWi8grnAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5770e521-13fc-4eae-5021-08dd3f19f103
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:20.9079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gs3oaNkKaV6afMvvt28zuiQCFIwe6+5rsHwMELJa84cN26uZxqSjfk+C0n9B78K6xvM1quq+erSIFfDG1gbE/eglQFrbd64yXsjGNqPIcrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270169
X-Proofpoint-GUID: XTEfQ4Q4q05dHuqkJLDI4xWBbNY78gk_
X-Proofpoint-ORIG-GUID: XTEfQ4Q4q05dHuqkJLDI4xWBbNY78gk_

From: William Roche <william.roche@oracle.com>

Hello David,

I'm back on this topic.
 ---
This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs and the generic memory recovery
on VM reset.
When using hugetlbfs large pages, any large page location being impacted
by an HW memory error results in poisoning the entire page, suddenly
making a large chunk of the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we take into account the page size of the
impacted memory block when dealing with the associated poisoned page
location.

Using the page size information we also try to regenerate the memory
calling ram_block_discard_range() on VM reset when running
qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
file is regenerated with a hole punched in this file. A new page is
loaded when the location is first touched.

In case of a discard failure we fall back to remapping the memory
location. We also have to reset the memory settings and honor the
'prealloc' attribute.

This memory setting is performed by a new remap notification mechanism
calling host_memory_backend_ram_remapped() function when a region of
a memory block is remapped.

We also enrich the messages used to report a memory error relayed to
the VM, providing an identification of memory page and its size in
case of a large page impacted.
 ----

v1 -> v2:
. I removed the kernel SIGBUS siginfo provided lsb size information
  tracking. Only relying on the RAMBlock page_size instead.
. I adapted the 3 patches you indicated me to implement the
  notification mechanism on remap.  Thank you for this code!
  I left them as Authored by you.
  But I haven't tested if the policy setting works as expected on VM
  reset, only that the replacement of physical memory works.
. I also removed the old memory setting that was kept in qemu_ram_remap()
  but this small last fix could probably be merged with your last commit.

v2 -> v3:
. dropped the size parameter from qemu_ram_remap() and determine the page
  size when adding it to the poison list, aligning the offset down to the
  pagesize. Multiple sub-pages poisoned on a large page lead to a single
  poison entry.
. introduction of a helper function for the mmap code
. adding "on lost large page <size>@<ram_addr>" to the error injection
  msg (notation used in qemu_ram_remap() too ).
  So only in the case of a large page, it looks like:
Guest MCE Memory Error at QEMU addr 0x7fc1f5dd6000 and GUEST addr 0x19fd6000 on lost large page 200000@19e00000 of type BUS_MCEERR_AR injected
. as we need the page_size value for the above message, I retrieve the
  value in kvm_arch_on_sigbus_vcpu() to pass the appropriate pointer
  to kvm_hwpoison_page_add() that doesn't need to align it anymore.
. added a similar message for the ARM platform (removing the MCE
  keyword)
. I also introduced a "fail hard" in the remap notification:
  host_memory_backend_ram_remapped()

v3 -> v4:
. Fixed some commit messages typos
. Enhanced some code comments
. Changed the discard fall back conditions to consider only anonymous
  memory
. Fixed missing some variable name changes in intermediary patches.
. Modify the error message given when an error is injected to report
  the case of a large page
. use snprintf() to generate this message
. Adding this same type of message in the ARM case too

v4->v5:
. Updated commit messages (for patches 1, 5 and 6)
. Fixed comment typo of patch 2
. Changed the fall back function parameters to match the
  ram_block_discard_range() function.
. Removed the unused case of remapping a file in this function
. add the assert(block->fd < 0) in this function too
. I merged my patch 7 with your patch 6 (we only have 6 patches now)

v5->v6:
. don't align down ram_addr on kvm_hwpoison_page_add() but create
  a new entry for each subpage reported as poisoned
. introduce similar messages about memory error as discard_range()
. introduce a function to retrieve more information about a RAMBlock
  experiencing an error than just its associated page size
. file offset as an uint64_t instead of a ram_addr_t
. changed ownership of patch 6/6


David Hildenbrand (2):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings

William Roche (4):
  system/physmem: handle hugetlb correctly in qemu_ram_remap()
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page
  hostmem: Handle remapping of RAM

 accel/kvm/kvm-all.c       |  13 ++-
 backends/hostmem.c        | 189 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |  11 ++-
 include/exec/ramlist.h    |   3 +
 include/system/hostmem.h  |   1 +
 system/physmem.c          | 102 ++++++++++++++------
 target/arm/kvm.c          |   3 +
 8 files changed, 231 insertions(+), 102 deletions(-)

-- 
2.43.5


