Return-Path: <kvm+bounces-45733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F52AAE4E5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D5D986E36
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F72328AB07;
	Wed,  7 May 2025 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="24gbbV55";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GTLghCcG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3252028A1F7;
	Wed,  7 May 2025 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746631950; cv=fail; b=hCecydu3Yh2/RxZnaoVo9+S+8ACTFHm7d8JxzUGoB+ACD2HVKJ8hNVXJPcI+TZyrvtC1iMbwod/vQCdFYyCiIQqi4aToFf+hPzSi/pJV8/Xvyo/pONHQ5IDK+s77cvAwQ3EzMUY5sEg7qNs1/2JyYDFftRT9Es+pnZijQvW5OvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746631950; c=relaxed/simple;
	bh=kKkSHJyEs6BluvhFeuBycUvDHf485n0udp+MTYB8Hgs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=J0fO8dws+yzrU8DWYPg5tUo5ygYucb+bPNSUGQuk7rd4g8ItyTgQ1dXPYBTZRAXByNjShPgcjELFn0NACA7iKjE6rgbNHFO43OI6RQeH6cDPjzq7rgKet7Tm4ZrPl6MmkHZCsqqaRoKUTKvuHJZCMnRZ6yBT39Mu8V0hSLb3WEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=24gbbV55; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GTLghCcG; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54785SL5025158;
	Wed, 7 May 2025 08:31:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=dEE//ImHiurOx
	XDPaluhxh4uxJnRe/VHtth62Y35010=; b=24gbbV55gOQ7OS5qjSOC0DIKaZ27z
	Pxdrpvv+/kANS9IULq25t7l6GQ3Ef1B0ZrZObIEzonWVacq4RflfJOB/u8TG/YcW
	TyJZS8fVI4+VAjzZumoghVVaDvzAzbOqPZ253m5rZoH6gh7fP2OB444acE+MgMk5
	Oi2u43v40K3K83ozeD0t/s8sVN2S9HYtttv9tuzJljXUV6Sj+6OTsrdpmzy49vkC
	sL1STR8TnKyNBElbf1XD3XpBLQZ8fLwtMcO0ODuF+NHvTJEn08rJeFx0EvbnIj8T
	qoCiefk3qe5yyHavxw6XpABxGg9FQMzMV9+6vK/nL/Hhj1UIC/qiWfoAw==
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46dh8j1d5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 08:31:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AqSN5/ABCaIvKu4UfhpbtRQQN+S3Kw+rNClYZUqKOQzYbgKESN+8Gmw6B5eSapXqxjQbJ77A/TZQE2u3VzJQRXYp70Zkr+NwggnOnQh0dk2YMcTWep7e9HnzLRIftszzZSadqpbq+o2YE6EG84x38tx/iyJnychxvEQmC/5xkfGUzu1rvH68nlz7QVgATRgSmDzjL5NAOhjUn9D6zMCVCDkYP7V7YxqfR4/WWK7Z46RvgnLAiIw0NlQfS5Vztbzly8fETZoBENj6vqwhhqdWkgJPT+tpcNGn3JBs0DJGs2UvC3jGxv5H7pofnehySidCHI+uW503tzsWepNLaONAEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEE//ImHiurOxXDPaluhxh4uxJnRe/VHtth62Y35010=;
 b=caKDpwnuYGjupS+NrXRjv/f9X5RPMGqxomfmLGgU//kG2VApjpyPpV+HBawa9o1dhjre8nTm01cKKvmZjdeywKyVQE3nvm/ngB2EyMMrRIRfSsCxPKU53TJ8JkA0OLjXjhMqithicVYCOYJk5ac9AtO0Jmo9xadPH8BmnibSv33xmcr308tKcBdGcBQvW5F9HlH/6KxIBZRcnWdBidyeL9GronVFcarzxOxg3/d9TMOtAbncZEcsHRddcwzkMxq0iHYfH9kfAEczZivP72dkvLLIFucx5AdmXS9aq5SNhZ3QsEVkoe+1kOutsFUuWMzFD2GKFHWTkIYb2rTyvnsbzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEE//ImHiurOxXDPaluhxh4uxJnRe/VHtth62Y35010=;
 b=GTLghCcG4QVpnhWC2n1c2vKw5cCTBcAAzuJc9X5WWS6URa2uaYZKfj12dEG141c3kWSHfwmugFqIVLDwpyXPYCZXYjHCnBXjoCbLFOyOv/RMIt1oVd2ZzXxDRgiWoc7Jcac+3kYtQGTH6qgv6lIgvZ8AMy9ursILunLy69Wey4EFt3ZmV4k8G37/MYKCaPtMqf5rAg43p92uy3KWr416vgGeudljMoI/hycZdIw5ZX4cAqPIksGYf121lVS5wsawO0TvLt0AnYAgXpYxkp7TbaNeznnmfTTHmxZA98xG7xc+Kz3FSKTw4mqOyY+/8oKa0ZuLiGoj4Q2y8PoqsYqr5Q==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB7365.namprd02.prod.outlook.com
 (2603:10b6:510:b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.12; Wed, 7 May
 2025 15:31:51 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8722.020; Wed, 7 May 2025
 15:31:50 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH net-next] vhost/net: align variable names with XDP terminology
Date: Wed,  7 May 2025 09:02:05 -0700
Message-ID: <20250507160206.3267692-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:208:530::16) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b0f8af-56af-44ba-04dd-08dd8d7c497b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|366016|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?46yVQQPf1PcHdlMlsqakOnw0Evw9B9ar2QNz9l16e07e+Vd+mHgKjSdot56N?=
 =?us-ascii?Q?k8sXOkO5TkHKc1orweMaFx+cNF4AeBgAWbHQPK56x9p4nl4r/yfLDh6Bgryf?=
 =?us-ascii?Q?EhH0zu8NHalPf1e6Hu04QF00mHGxqjKy0kZLAPkpEk+DVvC46L6Dkh2s/veC?=
 =?us-ascii?Q?kjIyyaaFmDy2NsskS13JzHKq0HcVZZc9DrPA3vdhb42jt4js6ONj/ibMQ25B?=
 =?us-ascii?Q?tZH062fW4FEiGZDGpHlJZXWv3sAM0j5U91IwF8Y7dXSv7U3oWu/RHsBjcgKE?=
 =?us-ascii?Q?dv7eUF9xAVBtOmkK64INH1LvZualJHq3SWbNJ3rHEUy+mkm6ajLF8RBRXrEM?=
 =?us-ascii?Q?eNrskdifojOaOPdkJRAemS/ME09qYJyQDUkmhE466J4AeESdrEbcLCMe0DF3?=
 =?us-ascii?Q?oX/YevbMo/HH3D8k7gwFiiaJQ53lsskCFy2mZPcu03vX0HLvtd/RYvGMwlp8?=
 =?us-ascii?Q?UMrzkCfRggnFRopf51MYxZBVoWUtjhddaixhygI3xgbaFufEy0042cQLFI7p?=
 =?us-ascii?Q?6L4TwDCySaDQ5I7P+6dL2AJY+420ByiI33dcIVdhGURdUBDuWo0l7/PM0IQb?=
 =?us-ascii?Q?37FqOMLTYB6ibJjDa2Fhb53qZROcSFnjzzTUBv/5FXq6CWZnLk59oaR7uXB1?=
 =?us-ascii?Q?JmnCU9unV+mljpp9+68xhZVidyNhKlKRSPE441rcCO0dnxbawL3aecxxRb58?=
 =?us-ascii?Q?wqLevB9yqg2AgKpd8RdUtO/YVPNnR2uga6A8NOLRACi5L29iyZhPidN/WynY?=
 =?us-ascii?Q?rxuv6R4VkXUnpLK6XoY68nZ23I4KNPAqCnVNn9yLzIAwyZ3VPB3wXrkHlQhG?=
 =?us-ascii?Q?ZeuGQNFfA7sEGBrNz+iVnpbetwjEuFybdGRfPq9wkO3TrU80W/kUfa/UrVox?=
 =?us-ascii?Q?wl0c+BmGApc0VIauxH4Vmm1op8yGhPddnxtKUjWtB+bfl35UBT4PhOny0S+5?=
 =?us-ascii?Q?M1yYFsdgsKL76wQxf1OsZxKRfN27h21zOZ+WRT84P9Iy9+dYkUKFKY5NUHyk?=
 =?us-ascii?Q?9HIUO7mmo592TbKWvdjIwnYzHrWI6IKejtMhAKdOERp/ZomatdC+RN4SGBNb?=
 =?us-ascii?Q?gXndaGs1p9XuV2A64ITPgSaU/x1VZe57h5vMr2uLLJ60GEAkyDGXJ7hUyoW9?=
 =?us-ascii?Q?EaZKYkPa84b8SGfLlt/LMNYqI4fljJAzTd8c4IOwn44s73DcMmDrg3lbB8NW?=
 =?us-ascii?Q?X0Q6C6HWgKKA3qSWnYn3OxZ08VnTs7cSmAjpzomOLlVLcuTBHbG0GVNahyfI?=
 =?us-ascii?Q?IuEK6MQgp3fSda8ZmsVOiWkZnQwe6l3qR2Grt8s4TZjBniLlK2oiZ+oTyhRe?=
 =?us-ascii?Q?XQkMO1YEzP1vQJGwnuCOQfBIi/50UJvalyupo1f2/t2c53C4EGAJy4MwORzl?=
 =?us-ascii?Q?EVrhyITY55JZQMBcqx47iHf8T69wpn79YcW5QJv/S9Lvnwc+//7PFZEqZOcm?=
 =?us-ascii?Q?qaWiYd0JwsAyZ9ZdxufRywi2wqSxHIzcyeH9XiP3m+wgxNH3G6nUPkTCcK4K?=
 =?us-ascii?Q?O+cclg4nuFLJdFI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(366016)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4VugbPerIR1ou75gPweMe6AO3dYTv5v0q1WC0gxpHbjZeK/1m3ZOPdRNSTI?=
 =?us-ascii?Q?tqXkdQ5pVLnp20h4RyAuaIEygTJWVibS654AB+UGmT6FrhtXI8ctOrmDGNIW?=
 =?us-ascii?Q?yCAd5QTrTgtnExnXSEyjff5Bsp+3TmRDVPDRH5F8vVMZaImDaqR6kuXM8kI4?=
 =?us-ascii?Q?C31s5qZUM3Qa2w8lOsaizV0XN+sDVaTTLObYeR70Fn3t8dETrKPlkjwM6bnb?=
 =?us-ascii?Q?YHEDtgaBtQnuV5i1wSAOjx3XZjswpaCo4bnd0BRiFwy9A3WUQW5nkjpl1GAp?=
 =?us-ascii?Q?gv+Nj/mn4xcFX7ObKMgA0jkFSQw/gmUusxoqEksRx2Sy6+d+lUn8taF3xesf?=
 =?us-ascii?Q?8JrcFrdi6lfeWNZp2Vn70S/D2LTbYumveGofILaQ0eVM9AvN6qVn028le9kQ?=
 =?us-ascii?Q?bEOEMtLyAeGjSFGpMmXayimaSCuTS5yLWzSTFTcCGLfTASLGFQk9SJhSJHah?=
 =?us-ascii?Q?j9Mv9ztq9ymg/2EW1md9gDGrRDHcrFD4H+v9o6AF4SYqiiu539jc2D23Uq4t?=
 =?us-ascii?Q?O1Wd2CB722TaPZT4iCWOFMGgIOO5Aj4Qg9fXSJS2VjyuzY5vfsNv5IZlnlo4?=
 =?us-ascii?Q?/9G4+8ZxSjFhbezFaojIv0brQAcXUccmM45zbqzmNAZYCpxy8zLKsAlNrlW4?=
 =?us-ascii?Q?Yo58uTkbH4cSEjuqWFw6DGduw69nONpOd1EKhVxS1ZjNqdFf4w1BUfgIzEGX?=
 =?us-ascii?Q?b68125zxarCzfhC8BbiF/YBacqayLysAnoOSF9w8poPljYGavxdma6B0o3Xx?=
 =?us-ascii?Q?u8R2NEKRgnf+cx1hq56M0yk+xqtysJD5Q94zDtFE7Ivh5WuMC+XcjFg2ziJB?=
 =?us-ascii?Q?4/JuhDN7PGLuTykd9R/cUzD+BBn7bkiybvYvD5oPggzhxu8Vg+U9dddYK6mw?=
 =?us-ascii?Q?m/yGUmwZvrioj3VidLYJ/lf8b2roFp/CVPWOcS9/T2Fp0XR4tpRwbwGpiEJ9?=
 =?us-ascii?Q?7NxX8YiuySg1KPQzoWg4X4dQ48fQRDOCx1sdIsg3SSugRfvzin+XV92mhPn5?=
 =?us-ascii?Q?YMlr402gUHdBACOH/JKHgGFlUiK8dP6QT+Hznsqpzr3cIGcXAqnj2OnNZUhZ?=
 =?us-ascii?Q?W6oWa1SXzSutnO5KhUi6uXRSMJNrYbGw7ctmqXPd2btFBAlNqPooHr6WJsI/?=
 =?us-ascii?Q?jVJ0qUwHs3vCy+5FGJhIPv8LRWG8X8ZblSH0rnX1P8JKe7StQjEyjhq0jgG3?=
 =?us-ascii?Q?zXOYJx7t0v2UXxs6C5JDbLYfz5CNiXWYP+kYQc4rojECaAt+beLVRmGNiIMb?=
 =?us-ascii?Q?ixJVnCExTaw3k5Kv8fL04Oop79rQDzbKx4+ygGrqH1mmA0AuR7NpLtA8n6yo?=
 =?us-ascii?Q?flh5wuVphRI85GNgFb7u9m0mxx3cCWoF6rZY/xrjm0qTD+C6sLMiHl/N/yMn?=
 =?us-ascii?Q?iaFkrVP/cNR2MdLXQmk7bfBw+vfXYaXYTW5F0fFOxY51EIs96Z8ZwFAum/zM?=
 =?us-ascii?Q?6UMaAjA3kLV7M5L99bwJ7VCJFnWwANfgV+Aya2UvrfgiDjEvNdM1PN/iWSEN?=
 =?us-ascii?Q?8dUVFeQv69ROB8jFayDbmPOwTTEIzLHwYzEhg/qKlYp+CkxkXje3PWURGzIY?=
 =?us-ascii?Q?lBIr5yZJMXRivP5K5r7rWotY6jq38pb7ey9ENh/Fl4a42NS8ySNMrDBp9sZq?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b0f8af-56af-44ba-04dd-08dd8d7c497b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 15:31:50.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LS780KXfOIw/MHzE/4qhTfLDfT+1KxCkLRJTnxt2Eeq5P210RAH0Fhq5w9e/o2ooJ+nUvYKBSA1eqKNTGKoZjkv64W0ZRhI3DuZ3nt1ispQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7365
X-Authority-Analysis: v=2.4 cv=B/y50PtM c=1 sm=1 tr=0 ts=681b7ce9 cx=c_pps a=b6GhQBMDPEYsGtK7UrBDFg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10
 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=jDBx4MJtfhcO1TTigScA:9
X-Proofpoint-ORIG-GUID: 8sbzHxemAkgzA6G_cXbxV8GTD6keDeNG
X-Proofpoint-GUID: 8sbzHxemAkgzA6G_cXbxV8GTD6keDeNG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDE0NSBTYWx0ZWRfX5NM87VaEAJNo nQew2wkYQPmoht/hCH8NYnYBzg1MJPtPFF0QmWWMtVULfhjob/wX9JeYB7Vrd2+Pvl/hE2QJ1R4 jL/ZllqYN32RC3uU1VAdtIqT3mG89hnLpk+He+3Pb9feDMw1FY0is6Eco1bubfSP2oIoe2lioFP
 heZzm+amigkxSRseSKQZfbkP2dGcBNkzpEbIoRjYlx0rMkZJ+WoO4MplgVTKpZJRKDD0qGROwKC TuE941o9y5jqUyPQ7XAP66pfHbW3LMRRJ82sNpzLuczsO1jxZ3bVScHYNA1BnXCi+aFBHvtanH1 o8yBnk3f+80nnrZ0MAeti/RMpRby+miMFTsGuHicxbruTa0+2lgj987Kj9rylElnCXEkL3O46LS
 6T+ZeHsFeYKXz59P4FoEwGi3Ew7AOQ38YZRey4w/Aa6xiFgBnSIxRS5k95f6uV5axHaD+1G6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_05,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

Refactor variable names in vhost_net_build_xdp to align with XDP
terminology, enhancing code clarity and consistency. Additionally,
reorder variables to follow a reverse Christmas tree structure,
improving code organization and readability.

This change introduces no functional modifications.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 53 ++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..86db8add92eb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -665,44 +665,43 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	struct vhost_virtqueue *vq = &nvq->vq;
 	struct vhost_net *net = container_of(vq->dev, struct vhost_net,
 					     dev);
+	int copied, headroom, ret, sock_hlen = nvq->sock_hlen;
+	struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
 	struct socket *sock = vhost_vq_get_backend(vq);
+	size_t data_len = iov_iter_count(from);
 	struct virtio_net_hdr *gso;
-	struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
 	struct tun_xdp_hdr *hdr;
-	size_t len = iov_iter_count(from);
-	int headroom = vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0;
-	int buflen = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	int pad = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + headroom + nvq->sock_hlen);
-	int sock_hlen = nvq->sock_hlen;
-	void *buf;
-	int copied;
-	int ret;
+	void *hard_start;
+	u32 frame_sz;
 
-	if (unlikely(len < nvq->sock_hlen))
+	if (unlikely(data_len < sock_hlen))
 		return -EFAULT;
 
-	if (SKB_DATA_ALIGN(len + pad) +
-	    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) > PAGE_SIZE)
+	headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
+				  vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
+
+	frame_sz = SKB_HEAD_ALIGN(headroom + data_len);
+
+	if (frame_sz > PAGE_SIZE)
 		return -ENOSPC;
 
-	buflen += SKB_DATA_ALIGN(len + pad);
-	buf = page_frag_alloc_align(&net->pf_cache, buflen, GFP_KERNEL,
-				    SMP_CACHE_BYTES);
-	if (unlikely(!buf))
+	hard_start = page_frag_alloc_align(&net->pf_cache, frame_sz,
+					   GFP_KERNEL, SMP_CACHE_BYTES);
+	if (unlikely(!hard_start))
 		return -ENOMEM;
 
-	copied = copy_from_iter(buf + offsetof(struct tun_xdp_hdr, gso),
+	copied = copy_from_iter(hard_start + offsetof(struct tun_xdp_hdr, gso),
 				sock_hlen, from);
 	if (copied != sock_hlen) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	hdr = buf;
+	hdr = hard_start;
 	gso = &hdr->gso;
 
 	if (!sock_hlen)
-		memset(buf, 0, pad);
+		memset(hard_start, 0, headroom);
 
 	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
 	    vhost16_to_cpu(vq, gso->csum_start) +
@@ -712,29 +711,29 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 			       vhost16_to_cpu(vq, gso->csum_start) +
 			       vhost16_to_cpu(vq, gso->csum_offset) + 2);
 
-		if (vhost16_to_cpu(vq, gso->hdr_len) > len) {
+		if (vhost16_to_cpu(vq, gso->hdr_len) > data_len) {
 			ret = -EINVAL;
 			goto err;
 		}
 	}
 
-	len -= sock_hlen;
-	copied = copy_from_iter(buf + pad, len, from);
-	if (copied != len) {
+	data_len -= sock_hlen;
+	copied = copy_from_iter(hard_start + headroom, data_len, from);
+	if (copied != data_len) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	xdp_init_buff(xdp, buflen, NULL);
-	xdp_prepare_buff(xdp, buf, pad, len, true);
-	hdr->buflen = buflen;
+	xdp_init_buff(xdp, frame_sz, NULL);
+	xdp_prepare_buff(xdp, hard_start, headroom, data_len, true);
+	hdr->buflen = frame_sz;
 
 	++nvq->batched_xdp;
 
 	return 0;
 
 err:
-	page_frag_free(buf);
+	page_frag_free(hard_start);
 	return ret;
 }
 
-- 
2.43.0


