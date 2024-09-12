Return-Path: <kvm+bounces-26715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F19976B50
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F8891C23A4B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF421AD26A;
	Thu, 12 Sep 2024 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uZhJ9L/1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G/JNulI6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA2D17966F;
	Thu, 12 Sep 2024 13:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149366; cv=fail; b=PHxiihpBxaIQGnqfH84PJY83LT+CUIIdwzzIRXRnZa5fUpYHrm+9jzdn1eCVcdwkV9YDjT5MV39LkD/4XOmSc9874fDsKMdAyvY8aePzEV2ZvHEMT/RX92Y766Ueq+XSU0pb5fr5jm3mJy+tL07KWP6cudNEXYUQzcgdn6PmBu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149366; c=relaxed/simple;
	bh=v7kC89Jtc7C00glZf5zVD2T0pPp8s8KwL4Lunek4FM4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bxgZ7H0gQfDV8CJ38g3lJ/lNaA2H4zIcTGQZWszY/lI2QkOIoDaC5ms7lRuk1rIYlcIPKIFuK+0iGbbbmITfYPxfUpLjc7wHLlScY2MEAinwGOe6Y2YQ9AEwqzY/wMVk5CYRPTDF+vALl8RL9IkmpXiuGjB1Wm8tyU6PRvA1c9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uZhJ9L/1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G/JNulI6; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48C8AGjk032669;
	Thu, 12 Sep 2024 06:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=riUYsmnz+INUw
	L03oEjzD3RgTbZLrD9bRPDmE9LDFmk=; b=uZhJ9L/1whppgT5eupRwO/aCczt34
	ax7YwWz50/BJ5kbExXE6S7smoEZqE/GHOFQ/Q5T+eisjRxE81ntGRTRHaMJoGAc3
	HDLBMO17YaO98GFI8j+UlpBNNe3kWS89OmSTAAMVWcnOupKzKpS3CFK+LuexNnmU
	v8Cv34UyvGpyxHfwspPqKhZJzW80lWDaXMMwYxbjZi/5KgFMDIg0R6MPZhazlEia
	s7Yk+kbnHBLfdzvAjMmyU3hqpnpq2WjAN2eRBaDEsdRyi2sPy2GeUDMcGpePZkM9
	lLL2LP61nVCgmwNeKvgp27Y1QpPnCFJF7AS76IoZ7l9oLWeXa0YbFDMgA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012036.outbound.protection.outlook.com [40.93.1.36])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41gmc7vgw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 06:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qG3V2qlkBpeKvkYxb1fxw4nmprGvmuQ11qn2NdbdIRSJCuEzoqXtjvLe/0MkLJujqFndNIj2PeJr6uZpBqzKgz4eqc1kPFgB2yWYG3JvBorFtFo2nxEBFIARTtV3KEAU8oYc+fhxCEksTND8PZUf2IX0XLgjGNvuf7Z3s5LZnNujtmcINuV5S9gQqaUo7D24oCYUJBqrQDYaihQs8+6ch0Bb8slflz39Uk2NKQB4JgexqCRO5+ePgE5eROLk2NLpQGeh8XInFZm3taVm1FuZuRmw5SvYETZowRd97xzOURLO3cEVTtEv8HbaiacHepZ5PGWBCoBlol1xnI8WZR+Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riUYsmnz+INUwL03oEjzD3RgTbZLrD9bRPDmE9LDFmk=;
 b=iX2rUJx8a5RxPQ9VVg27svu8BuUT2TF7amTa2PIOa5RJU+l2JqvbBH2rDSkH+xxVcLMr9lOngecIYxvWvNRvrWFYnGuQh1vEhp1uq9b6u3BdXbC0UW/RG6vdfZrc8jAsuzCnrcGIxkIrUkzsIgDcyI8quzB/0NXjXz7n4zXZGmLSFzntDsE/w6XUl2U5DWxOO3q35poVZwo/XmsVe+XIfF4InXSx3J3TDZAck7/78IEAfyFJXAuPcWzrAYCHxSWuvGTGUeij6bvgJnBWoUIhdUFpCtvC0gJb9bnH5vOyX8KqlH9eTN7dm3d5auGj7DyX0CRqFiyKBPnbzCQYtD7yBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riUYsmnz+INUwL03oEjzD3RgTbZLrD9bRPDmE9LDFmk=;
 b=G/JNulI6cFH4aLSwSB9tWI0Mmp/NS39COLjiXR8i7//+1XGX5y0bAbKLdaKaWITqVT0mTjY/+ihXESVpQq6M7Y0Tc2uj3f12ILwZFaCFPq+NPQAYuBvQbFP5uzLzriVTBTnyYHd7P9MLUl6kAhU7evMcfO6jGscP5svte7mu+ErZ18nIDUxGWhK7myqHorT9GpcdBRck3HB1PCVPzq8tA5mgN6xYKVw6k75YyhiI5/D4cq/Gmci7V0Os6iW6E8WdYJ6C647BA9tW4Sfoch2SgWQR4GokaMq3qIcpr8W3GHPA8j2JX1/ESdp3zINFJ+uC378EY/fq0gNsYHKFW2jl+Q==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9454.namprd02.prod.outlook.com
 (2603:10b6:8:dc::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Thu, 12 Sep
 2024 13:55:20 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Thu, 12 Sep 2024
 13:55:20 +0000
From: Jon Kohler <jon@nutanix.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jon Kohler <jon@nutanix.com>
Subject: [PATCH] x86/bhi: avoid hardware mitigation for 'spectre_bhi=vmexit'
Date: Thu, 12 Sep 2024 07:11:56 -0700
Message-ID: <20240912141156.231429-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:a03:331::26) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 850f858e-ad6b-458f-7582-08dcd3328a4e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hFwqPM8JqJtXvB6WOiaR6sFQapdU/X/VGHkQ06M4tI8UVOHnKPw6ICROCDb/?=
 =?us-ascii?Q?Fvk4dbnsP3LxDQ+wbkJR0jwQja+95zXAWpnxXkrIN1Sk9dsAnZi3yBWNB+BW?=
 =?us-ascii?Q?18E0YRrsTcNyNpzgzCQIrxuZ2ysuvRgUHHpUK1RpImq8pyof5kroIjUjKInk?=
 =?us-ascii?Q?Lgk4pygSaFAVEwrDIH+hAyFH0sZphJwiOx2bKHwCkx5WjG/nFqVuzujb330y?=
 =?us-ascii?Q?rRDE6/tM4U7nMEcvaSSLFT3ZQWNmtelOciQI7yltOosv4jeUuiXESxR4N0OD?=
 =?us-ascii?Q?iK9eyxEUyysLaB6bBvWoe+s9oI/l0tywTic4Iu8lEsTfit/3UnwUEGqBopJC?=
 =?us-ascii?Q?89dPdKc2/1R1oeL5OYSYWGVPkMRCEG8DI30SsmLA+Kk8Wpuho1avzW/2j0u5?=
 =?us-ascii?Q?8YMi5PIvyN8uVlekxnIZS7xOt8VCfyaTcv8qjdmWqFpiU93Goeh7mbY1HJ6M?=
 =?us-ascii?Q?TYzU+8XWgMIW3OpnMFGnupe+BOBLimoME49ixUq+WF80xjqUK6/Fo5lyjl5t?=
 =?us-ascii?Q?I+CZfErO1WhtszwUoTBemWnWF+jUNdugQG9nybYp6DE5cUyxnveqqvzOU30y?=
 =?us-ascii?Q?XkaGb0XH1lkiu48DRsVrbYk79ugMJSK5akGLpwzXJbF15s9Mr9Go6qS9vayA?=
 =?us-ascii?Q?bpeaoll15fchWzEQeeB4ewn5l9n+85kahKVM+n+PNScLtJKjtFZa7JhZdEsw?=
 =?us-ascii?Q?xHPblKxtotwzCrlc6PtyDyZCS89woFrcLr8/LPLtuq2IhNw1x7pSBjxuX2NW?=
 =?us-ascii?Q?Htjn0K9OrNDSw+UfZH2hzKn9u3N2zwrrVhynusmMvKvC/tbfv9ki2LRedxt+?=
 =?us-ascii?Q?X9aaSgOpLhkaWZkyWRhdGUpONYwiI21saTrHfs8nHXXHefxDYeqbHeVbUpTb?=
 =?us-ascii?Q?riVqgx9E6yUp9r1ygRs9bruXvqolh7oH4fMBi+yylRlpmlC34eHl8ONDD14C?=
 =?us-ascii?Q?/XYuvvA1ZXBT4092lOGQscSg8oC287c6luMioa4bQs5xfpARBxoz9zd8StPm?=
 =?us-ascii?Q?b2yneCdW5SijDC2M/drFH+di/rqp/oFX12KX+WmWH1M+u06hQOE/wwlJ1yrT?=
 =?us-ascii?Q?TJp4comRzVODAPIooWJhTGmzM+e0GxxiiEyKWbrluLGXegf4CMDGGSAN4iYA?=
 =?us-ascii?Q?oHx8smDdsKlwmXteGa0/iYcCCCt1NR9zDPZog2vMzUe+3QMdfrGe18mB58P9?=
 =?us-ascii?Q?BQwgw5ov4S9AZUXBnzyaX/dQ/k7nkBHFjWL7HM/rNaU4uidgUe5LWQ9TpVV1?=
 =?us-ascii?Q?yWPom+/TL/WNLTURjFPRAqGP+HdgLVrO2cBIDXxltPRC5EcHHyrWo+NewnGB?=
 =?us-ascii?Q?ixBg8owOs4FOtuu/XebkyskUTs6PaKM3QYQXu3t+C66AzXQQwRENpvA7ciio?=
 =?us-ascii?Q?3AJPOoUNiFgcA0C5lbe5EkxqW17Qg82mi2g3rBVYdelZPuxGlSgEYCow0RPW?=
 =?us-ascii?Q?GoqYNw9supA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xbjrpRnMOApdR1CvE68in4m/Frvfl16Q1zYMgc92YlWu941YJp+j60rKbs+8?=
 =?us-ascii?Q?ABiPmK1XS8hXT+rHXfjXWJGh4ReDfnwi2zYBa3VSsX50NHNc+/2E+y7zZjur?=
 =?us-ascii?Q?9ouEhOo2HdkqN45z8ocgw93zZT+6/SbSIzXYJ7CtcsRtg9gqkmViE56xUbuS?=
 =?us-ascii?Q?9skoyMLLkqy6g84nqAiFSUAfxlL+PxGXFcCHZQgxqoPGjV4Po2IDyTEH42Uw?=
 =?us-ascii?Q?JnG5GNEtBUOZuIDKvZNSy+zoHvK8QSwZ+hHxzyjBr+aLBHr9VevZvot60ITI?=
 =?us-ascii?Q?jiAYqDbRkfeIebPdtZAkjYsr0X8EI4Ovo5y0vwYTngph2HoT3sGRHJouIgwn?=
 =?us-ascii?Q?oNB2Fbh4S+ATagel9az/KZIxgJH3vRU8xzdmE0udY0LAxK73XtSFL0P2TOUN?=
 =?us-ascii?Q?/J2beS/CtwapNNxpc8X3F2R4O2znkYYhuM7X1Do3vbgBVNHisp4XUo/sPNc5?=
 =?us-ascii?Q?BjBY2ZxLc6zy4ZncervwxJ8X2jxmpyY8KuWcrPV3R4r00PVGmMDY6tcGN47l?=
 =?us-ascii?Q?e3197lYB6LV1kvHeMNL8GrDeRgKnuk5sslnNNyxLX6uys0pRjE0TuM10bYTj?=
 =?us-ascii?Q?P+BYrvvDJGG4q1wjnr1K9JL/5sh7GNsZtLO6xFU508oKiz6cjtbLkfe7TT39?=
 =?us-ascii?Q?5ID73fz5IYvfI2llwejBSeeYbRV3oyhb+wxqqzEkkmXwbz+Yjtrw6gMsoyjs?=
 =?us-ascii?Q?O8BNIYQzdfZNogimSD6/XTI2hWUpsZ2x+UHxPUePiASC5TurtNdv44GvXjyj?=
 =?us-ascii?Q?MIoaa4iaCPCgC9Zk0nqzg0L090y23p1MSP3AxInDDdB3IWEHvj75pqUijdV6?=
 =?us-ascii?Q?z2XyQxBan6Zlu9plS7n1T6nfJ15MqzmlpMe2nAPsP79WPD/Q9BxZyoXrgFLk?=
 =?us-ascii?Q?rpI72fi81T/IYKp9ZRuZEA1iHZsz+d4UEc2oedkSqzkBdCc8GLuLrybjQfoe?=
 =?us-ascii?Q?fRmqBI+sEPSzdD6My410tdaOognipCUHAjXZBMjEyDMVcO4oHZ788gds+YO6?=
 =?us-ascii?Q?/IrXaUsuPDVa2dNoeP8Hbo8w1Yz0ysdpnxUkKSCzI4hGOP/rIny9aMh4c3il?=
 =?us-ascii?Q?d80418X8DOndgQbGV8nTNsAJlBgyPFKqKlvp1rKkRSr++m7N8yc7E7O2XwsW?=
 =?us-ascii?Q?iQkVbJKAJr752F5aehyzlxCs8QfpksbImDFKowUC05Grq0kabr80PypkXs+s?=
 =?us-ascii?Q?zfJuorerpoC7AW2MtkgDPcVs2yJi8ueQVMJjWTheMgUWrv5P3IS7snxMTqsj?=
 =?us-ascii?Q?z02f4HmYdepZEYfV3nhm5IaEDDL34AeBXn0rnChnL/447mswtHwiDTMkZ/E4?=
 =?us-ascii?Q?HN76HvOCcAulHFz1e7AnmchnU3Swe+bAr/3Zev8hZ4QtbaHjveCG7CTmaouA?=
 =?us-ascii?Q?dKt4u2HqazSsYwYxFxwr/LhoYbZS+V0dJoI+Jyw4LBlrj5qeLWq9kDuA33hF?=
 =?us-ascii?Q?LLeXfLVpPEzzk+lwRSNB9oIcMJhLq2T5J8Z8blxrF/mL3cwJ+jAIsl5qSKgg?=
 =?us-ascii?Q?JsxK/ZKLS7lcQYE0OxTJd/ucGz3Ki/9E9IZon7C5hXzw8E+5E4f+PA1pS3lv?=
 =?us-ascii?Q?AjCH7ILLMfk6W+vYHhf0xYNNpIU/eLQjfw1BC+hHb7IMBfG3P78ECLod5kCL?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850f858e-ad6b-458f-7582-08dcd3328a4e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 13:55:20.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bp4m2Nm+TgmUNQjStFsbO4eb2s/aGG1a+zBTuInTmNaUx/wt2Oj0MQZ3c73+FyeYlWrstqVw1MFKqsEcNlBjaZENkggC47AiW4/CnoRlRfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9454
X-Proofpoint-ORIG-GUID: QhSNjKNr6bPguf_a4MhtcG-_SNO77zwm
X-Authority-Analysis: v=2.4 cv=TevEtgQh c=1 sm=1 tr=0 ts=66e2f2cb cx=c_pps a=eoA+jwG2N97X2eoE7Om4vA==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=1w7lWPfu6xornFwEE_EA:9
 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-GUID: QhSNjKNr6bPguf_a4MhtcG-_SNO77zwm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_03,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

On hardware that supports BHI_DIS_S/X86_FEATURE_BHI_CTRL, do not use
hardware mitigation when using BHI_MITIGATION_VMEXIT_ONLY, as this
causes the value of MSR_IA32_SPEC_CTRL to change, which inflicts
additional KVM overhead.

Example: In a typical eIBRS enabled system, such as Intel SPR, the
SPEC_CTRL may be commonly set to val == 1 to reflect eIBRS enablement;
however, SPEC_CTRL_BHI_DIS_S causes val == 1025. If the guests that
KVM is virtualizing do not also set the guest side value == 1025,
KVM will constantly have to wrmsr toggle the guest vs host value on
both entry and exit, delaying both.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kernel/cpu/bugs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 45675da354f3..df7535f5e882 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1662,8 +1662,16 @@ static void __init bhi_select_mitigation(void)
 			return;
 	}
 
-	/* Mitigate in hardware if supported */
-	if (spec_ctrl_bhi_dis())
+	/*
+	 * Mitigate in hardware if appropriate.
+	 * Note: for vmexit only, do not mitigate in hardware to avoid changing
+	 * the value of MSR_IA32_SPEC_CTRL to include SPEC_CTRL_BHI_DIS_S. If a
+	 * guest does not also set their own SPEC_CTRL to include this, KVM has
+	 * to toggle on every vmexit and vmentry if the host value does not
+	 * match the guest value. Instead, depend on software loop mitigation
+	 * only.
+	 */
+	if (bhi_mitigation != BHI_MITIGATION_VMEXIT_ONLY && spec_ctrl_bhi_dis())
 		return;
 
 	if (!IS_ENABLED(CONFIG_X86_64))
-- 
2.43.0


