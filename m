Return-Path: <kvm+bounces-36702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FCCA1FFD4
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4028164EF1
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899001D9337;
	Mon, 27 Jan 2025 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GZG3Nh2R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m3CXXKgu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B81D7E30
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013516; cv=fail; b=Cs1UhzZRMp2+ivJsjBLRnHbeFBghSjmaQRtOF5KoGOIhUsUMtHFZ4vGMzR9MkaQTdsWpRyCA92cHl7bWXiZfZSqIzCUy8WwrH+z02TErh2PqWnUVoDW0xOkgtxLhIjjk/dg+q2c/TZfMCqnkirQpsbizfhp7qTLUVutEVu8A4is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013516; c=relaxed/simple;
	bh=Wa17K96WHsG+UwDL7GtcB408PTs+VpOZQSc9ceuddZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TG+/ngkO6WowmuvrSh8pa+67TeDSGTbLCst/TQ/fdhDka+3rDpr2M4BJDDfPYGPVrPudwHFSXUcz4loXBCn12YBdesjGybhaxWKcGMk0ZgNEZv9+CpuT4GuE7ou5Qaz6fVrLMHR8Goh+Upzc+dDuD4PcZJzjNO/AhWiy1ecd3Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GZG3Nh2R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m3CXXKgu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RLR3tQ015041;
	Mon, 27 Jan 2025 21:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=; b=
	GZG3Nh2RHzg6tHmzRWVAG4n23U4aUtgXsp+hECSkatVxp46KVmuzMv8fNkp5tnve
	E39cVhlujhpiQYCVaAD/rqSb2PnGWBIo6hk/xAPoCqgC35mEWYoY7px7qprBBPQ6
	dNoYUj6vYaGRxGm8G0ZG35T2R55XDa7unHsNaYO0ozG3yGVKiJKWhKw9ley3fupo
	Bw1Bt+Tu5CGCSPnsH/hcqrFVcEzlN5fRmvmGhqHaOqUcBMWe7jUqf9OQKyki0tlt
	WcED09R4A5muqQRNfHJZx2woSQcvHNzEPglMNIM/ix1bNAvsbx5Yfij03jk3uu5t
	F02b4j0ck3aCOd+uIpzBUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ej2j80ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKSlri021979;
	Mon, 27 Jan 2025 21:31:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7hsp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uDNwyy19wEbMYLPmlJTZ1zEaCIeHU4jJZHhXdXuvupDKinggA+ll1ga0D44yA9ofx4rfqUsmi0aH0+Cr9Lw7SuD637MTW8Q9jN0l3nBZEUpE4Pan+VS7kYGnUHyuJT6QVJI5ao9Vl3rfKS/z03iAMgVJqq21nlnXd10m+/2vZN6fS4r9rdrfd8BQYgT1JHV4wByx3OFAUuhjbhoSVUH0Vkn+r/x8OAcjdBVds+7C0uFevsrIaV9uMs+E0RfFaGHIWfguWENeqkYeFhbj18+rS9ws4LwRzKPgIXv6PH1aPTyDUihc4KtFokPVyqimXVC14GH4v75SqEEyOO29mzBMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=G40L8Co5qxr6DAFetL/imVD7Yjbyhp93eTjF9Dl6lwsClQVMUJSY/usPdxjeQJgT9Z4hKCD8Y6VhuLspy25ExSBDxFyHa27Vd8U40qzR6Q5Z00lqu8QUeyFU1wK4dNF1cUVKl2YKqW2YFmevwx/aIkDZcgePHQJLMwM4wAGVptBK/EEJbmi/MfFRYyrR2g/FiFtf4Re1pcuRyMDKOKP97Ilfk01W/nuXDZr6jFp6DOXjy46Ehrd1q507FCm/ua70pcvnSdF6lVU/h91bIoo9rccfwL2VQxHO1r+wo69JssID8Oj3OFRZhDDJVBkqjL/cMtIT+1bLZHkHRUTMUAVNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=m3CXXKguQK72i86RHUIOkFJpW81WwW5SBRzNX/GoYurbBWaRl66RPYmoDanYcOaJNpYHDHKwMOi2JzoaG1zAo+cQSEFNktNtS/UcDRvJPm7IN2pcGQNjNN7LBBqYdu16fnIPgQNThhnWR0w4DnDjagIklO4hq7SfzcUNkFDNVqI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:36 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 5/6] hostmem: Factor out applying settings
Date: Mon, 27 Jan 2025 21:31:06 +0000
Message-ID: <20250127213107.3454680-6-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: f92cf85a-65fd-49bc-5b42-08dd3f19fa23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DYmrAqAiQrON74/04wLzNRiaxusdbbbHx3ZvkcqXBUh4+69o6satBDkgkOLm?=
 =?us-ascii?Q?cyll5y23QxrcmCU8WAQDYCDKTD6jZay8V/8zhlJtaVwkKQb6CEZ1y+ouFwbY?=
 =?us-ascii?Q?zXaGFg+3dnZ4Lh2+IWsimOZIBQDa6AhbN1/6PXA1+CAf67fKRaSfOuwgBIDB?=
 =?us-ascii?Q?kFHvd0zAGBemTWswHZD5EYpB3SNwack2im3f8pYgrrY+AIQn3RlTmm6yr5/v?=
 =?us-ascii?Q?FPyyOcFSXH9IL+wIP3YBe1xWvoRHXV8ygF2Zv0Rx2aWPP3iNaUIO0sENuyB8?=
 =?us-ascii?Q?VWwSJ9X2g6wisqtEI10BM1V4AvmUOe3ZU1BHSGU/inyKtwzUpcL9C4sqnRY3?=
 =?us-ascii?Q?Eh6B5E6atDnOqftvhlZc1xJjS5aIOwWiZoiplT2JRs9BlTm7Cx/PiY+AvfbT?=
 =?us-ascii?Q?8DcP7iBQGTkjrDIEZ4fFGpeOnPURJJ60nnXrjM5csNYqZgylkGYG573N+a8J?=
 =?us-ascii?Q?3qaLBkIdZWMncI77WkVfTA2YZhbuHVAzQ5m5f11ZWFroOR95mDLRQgtvOhSR?=
 =?us-ascii?Q?9ldWfg9xCTkUn9mNXl6UUCmCdvBb5LKOnURsj8B3q4gb5LzcmHCxj2yyj1kF?=
 =?us-ascii?Q?4f4LTwZEkE+0YwmmsT5cV1mivS5ONmx6tgZqCP49twbLAGhco5cAVueHLQA1?=
 =?us-ascii?Q?3Qi0LDhZpWiL/qHFbUSeOFFOLKnUPpPTWN2Y900l77bTnR43CL6uSGoIRhng?=
 =?us-ascii?Q?7gS+Ts5M/7OOS7pD/SwZvy8tjN7QQPIOiGOFrwh8q2dKKf9UI7BwknciwexG?=
 =?us-ascii?Q?5tdOjq3QtO+WFbjHC01SEkePVc455RsBKFm/9G5W4ej1rFQTHBUlihE9zmH/?=
 =?us-ascii?Q?j6HH89dzcHXzimhBOQTTmT7keK1F0ZCjPmFh7Tfq5s7z+VqPTvAQvi/sKvuP?=
 =?us-ascii?Q?+npKhx2n/GGUUw//JuXuACxTDjrSveHtxg9hCrVNVXapk10gZVksWqMfaSBq?=
 =?us-ascii?Q?BgOhgXhrCIhzyWzU2rds9PgB3M5fLLonhUSPO1MXgjm+xTxMHhAVj/QsyyJI?=
 =?us-ascii?Q?iA8NI5GX5/iX9c3bsILvz8aS9OVt89tkxdrpInHBANTYOWyg7ZAxWZ04m1pk?=
 =?us-ascii?Q?mKJdd6jdR84R10Xqg3IX9QGBa2wsV2sTGsyFNZHSy/GP4+8EAmAnHkByo7mr?=
 =?us-ascii?Q?w96Asr1RkiuZRsY8PkSCLP1Lbl6NroAkyACi0zFiQJhKlqRejMfzFj+C5oiF?=
 =?us-ascii?Q?13167XjcQ9kykfeiWh0/VPVTqvR1b83cOrhuNlQIhq2q4JyYNtHIuxaX1ngn?=
 =?us-ascii?Q?rzLHsGMngemYEuPewGbByFdYH1Le5nIr/kgiJhVis66c1F1cuaJjae5nHDTo?=
 =?us-ascii?Q?ImNe7H7bZJrFL4ng0Aq21dlYIAIi21bvyP8D/nGfbfmhV1rs+5cDdGQPLHuh?=
 =?us-ascii?Q?qb528y85h/bXc8e3dvZrShUOxMdF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZUbC9YU0O2gCkFZ0CFLNfHvFKAi9gEb0haE5UL78mnhnPgaX+xSWTCv49YEc?=
 =?us-ascii?Q?VuAzpkYTV1d4yIDRWvBlrVHumC1DRHQGYZGR/Tv3JpyLn+yB53ykkGoNEnWz?=
 =?us-ascii?Q?ngNJNoOL8N6l92GWA/rY1Ydb0l5EhrOjDTmJ9AlMUGQy5qJwqkoTHQk8/VKX?=
 =?us-ascii?Q?vhhWMEITYq4wI5pGm5EVmkbFeG7XO1aX+fGZ9/CgtftGSg1fNez2WxIjNjKa?=
 =?us-ascii?Q?N2hYSdMASuTa0W2WicnkJPRJgRVruIpICAsLZiuEC1U8icNwH88Fi+tLeYiy?=
 =?us-ascii?Q?Ka4w8nvda6+838agRodzVbVKX1hXc3HqcgqBdXy1NHGlcu2gnK/nwBQ6DuwH?=
 =?us-ascii?Q?s2nviBWzKWg/Pe/qSNVp5jTeRc+eD2aLT4qHZoO2sDi0R0VmlPtVdqy7iDju?=
 =?us-ascii?Q?lIWYZLQrBZdwm4nl5nd9DieL6iyLb5BwOgXmb2kTcoS2Lqbuoo2BwrjWVkjT?=
 =?us-ascii?Q?g4QFclrF7QLII/TDRF5+7FdApHlUmBR+WqHAjU3un2HaYWIT99zooaH2GHsg?=
 =?us-ascii?Q?YrQJRlcilZlgB9cCnXC3ifk298aFfpSdx/Kw3vF9gphWb86SEkM8xmOF9kzP?=
 =?us-ascii?Q?P4kw/Vc94ToDGjZi1H1sYVLKz9l7Zx7nh0qJPcxLjQ6Tf6Ve1WDKFw/TqB0J?=
 =?us-ascii?Q?3R/chEqXsCF+4fvLXulK7Q+ujgjoQSg0GFN9ptU6sts/YsXphllvnZB1iGtS?=
 =?us-ascii?Q?S1WGgK3Hk+xP2r3Zy2KcEUbaj7J8uDBH1kffZdd6X0Sk2PalMYRlqbCzBH5q?=
 =?us-ascii?Q?WREuv4E675Wqe2YF8Fo+r1Cr7qzGbKO1+0j0dAIEkGq4vQccOuSFqzKJ24J+?=
 =?us-ascii?Q?1Nn3/R5igAfWpCBHrvA1yVAMPCHxKSCzGC39xlLSbWu3MpXdTbo5FnP3upDj?=
 =?us-ascii?Q?lozENjwj7aSoHYf5U+8uMA1gcODlUP10ArxhIe5NF+pTGtt9i3L/t2re7ZBf?=
 =?us-ascii?Q?U7FBKz/2ohgI9aa8WlwnFTt7Ziluyg02RcOBQQ/FKY1sRRejim9G1UXczSkn?=
 =?us-ascii?Q?cnQcAQY6S76GM+A5E4gzRw0YutqMRGCZ1PdyAGpR1cT+ZBgQUhcqUan7fFsJ?=
 =?us-ascii?Q?wEDvyMPdBg7rphuT0cPsVIA/YLSzbcZCuUUGZj+Cw9KRvCgTL4FZxsXcDWSJ?=
 =?us-ascii?Q?bH61mzTGVhzUZk4j7LU7BsN68mRH/LvxryjS6maqbeOw/ftw7RUkW1fUeCm5?=
 =?us-ascii?Q?3N4LHVJEnWDoRB6NyKLp5R6EWzH+uX7Pdyzc1Xieqy0lVX7q4YJWKSxQ0+Uq?=
 =?us-ascii?Q?YSTWT/KkKQwuFNAX0eRwXIe9Ys4xN2TH7dIBVl3vqQubbHOeeESPjoabf7QR?=
 =?us-ascii?Q?Ch146Td7Dl2KhmZgB2wlRDdWuI/hdK8GgBXR0kYlL/eM1EuCukJRkuQTARX0?=
 =?us-ascii?Q?E5GgjTiAqQuI0SbZWSKiN29Iuekw50OPLZ1vmbtLudVExGV2zqhiSb1uGhzY?=
 =?us-ascii?Q?gG+a4N0MiWAJ4bdvVbelcozEHGoTI/AyH77eSrzB9rltupSHwMFPRKJLxKV2?=
 =?us-ascii?Q?V2zQD3qmxCBMFyAbKsP2qPYM7Kg9y8FsFynO7ytcPNkgjvpASpdKO90JikRF?=
 =?us-ascii?Q?CJxw+pGvX4Iiqrj8hFccUMuieyjAzbCSWpKvvo1sDyBx7NZSHU9STvkWRO6W?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HQ5+aYjaA32W3cOR3kAsg3oz1D26gZZ0rZD/qXGUyyao6wmilY6VQTU2usqGuZ1K02DxDB6b7saWrszl4k+TATkP5Nvk7w8MVhPaVYIraOkZXIb2RTCpUt5Q+41w/WznKPh7lu/5gr8iJhK5koscT/lz1QS53a37553UWlzDxyFoOyvZXI19rUkHl4H5uVQhfl1mznw6WTUw8CAl5aAEs+ALGqcFbLL/35j3FYxDUjpf/fje3CHTbnb3mKIXMpCawhz/6G9kiEkHBkHwhwMWFsWsZFdNqffojhZicYIQj3j2qba2rFaz0ivtID0qXVCIk5hczcxzjzrSoi9iCNmeG+7pKJTuwN8+GrnMF1ZNkOA0jA58ySRiKOwrNIe3vhz7ejpHn3m38oCfOHJ0CaLf05qZK0ZaRnB4Xl9fkG5iNGMP5D7fx5vRKMbMCLH0gYjTdwBcw+Sy6TnpA8meY/lyAGVMdZ+cQMToUmJmrb4CY62pDZrxUEdWaRQpJL2Qi2aG5WZ5FcuBQtoDnkEwPjGZt9po9t8VPrsNtXGDkDrbL13UtjCatdtcdPzaYPYiBHGELeL2rPhUd0yJjTFH5H3ymBW1LDplM5yFD8VyvN6GrIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92cf85a-65fd-49bc-5b42-08dd3f19fa23
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:36.2265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5NX2DRDshRwyg2EumwgDfF/eiCw46PUW7fjsYTuIG+LHm63o+QC1IXXvwhmRFtJUAB75JhR9zShu9uv46W0lhLKnnmdMf/bL50KkUnNy9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501270169
X-Proofpoint-GUID: gK5Ji-Pn0n4AL86-YuUZcoO3k4SvzgIm
X-Proofpoint-ORIG-GUID: gK5Ji-Pn0n4AL86-YuUZcoO3k4SvzgIm

From: David Hildenbrand <david@redhat.com>

We want to reuse the functionality when remapping RAM.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c | 155 ++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 73 deletions(-)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index bceca1a8d9..46d80f98b4 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -36,6 +36,87 @@ QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_BIND != MPOL_BIND);
 QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_INTERLEAVE != MPOL_INTERLEAVE);
 #endif
 
+static void host_memory_backend_apply_settings(HostMemoryBackend *backend,
+                                               void *ptr, uint64_t size,
+                                               Error **errp)
+{
+    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
+
+    if (backend->merge) {
+        qemu_madvise(ptr, size, QEMU_MADV_MERGEABLE);
+    }
+    if (!backend->dump) {
+        qemu_madvise(ptr, size, QEMU_MADV_DONTDUMP);
+    }
+#ifdef CONFIG_NUMA
+    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
+    /* lastbit == MAX_NODES means maxnode = 0 */
+    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
+    /*
+     * Ensure policy won't be ignored in case memory is preallocated
+     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
+     * this doesn't catch hugepage case.
+     */
+    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
+    int mode = backend->policy;
+
+    /*
+     * Check for invalid host-nodes and policies and give more verbose
+     * error messages than mbind().
+     */
+    if (maxnode && backend->policy == MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be empty for policy default,"
+                   " or you should explicitly specify a policy other"
+                   " than default");
+        return;
+    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be set for policy %s",
+                   HostMemPolicy_str(backend->policy));
+        return;
+    }
+
+    /*
+     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
+     * as argument to mbind() due to an old Linux bug (feature?) which
+     * cuts off the last specified node. This means backend->host_nodes
+     * must have MAX_NODES+1 bits available.
+     */
+    assert(sizeof(backend->host_nodes) >=
+           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
+    assert(maxnode <= MAX_NODES);
+
+#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
+    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
+        /*
+         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
+         * silently picks the first node.
+         */
+        mode = MPOL_PREFERRED_MANY;
+    }
+#endif
+
+    if (maxnode &&
+        mbind(ptr, size, mode, backend->host_nodes, maxnode + 1, flags)) {
+        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
+            error_setg_errno(errp, errno,
+                             "cannot bind memory to host NUMA nodes");
+            return;
+        }
+    }
+#endif
+    /*
+     * Preallocate memory after the NUMA policy has been instantiated.
+     * This is necessary to guarantee memory is allocated with
+     * specified NUMA policy in place.
+     */
+    if (backend->prealloc &&
+        !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
+                           ptr, size, backend->prealloc_threads,
+                           backend->prealloc_context, async, errp)) {
+        return;
+    }
+}
+
 char *
 host_memory_backend_get_name(HostMemoryBackend *backend)
 {
@@ -337,7 +418,6 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
     void *ptr;
     uint64_t sz;
     size_t pagesize;
-    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
 
     if (!bc->alloc) {
         return;
@@ -357,78 +437,7 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
         return;
     }
 
-    if (backend->merge) {
-        qemu_madvise(ptr, sz, QEMU_MADV_MERGEABLE);
-    }
-    if (!backend->dump) {
-        qemu_madvise(ptr, sz, QEMU_MADV_DONTDUMP);
-    }
-#ifdef CONFIG_NUMA
-    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
-    /* lastbit == MAX_NODES means maxnode = 0 */
-    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
-    /*
-     * Ensure policy won't be ignored in case memory is preallocated
-     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
-     * this doesn't catch hugepage case.
-     */
-    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
-    int mode = backend->policy;
-
-    /* check for invalid host-nodes and policies and give more verbose
-     * error messages than mbind(). */
-    if (maxnode && backend->policy == MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be empty for policy default,"
-                   " or you should explicitly specify a policy other"
-                   " than default");
-        return;
-    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be set for policy %s",
-                   HostMemPolicy_str(backend->policy));
-        return;
-    }
-
-    /*
-     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
-     * as argument to mbind() due to an old Linux bug (feature?) which
-     * cuts off the last specified node. This means backend->host_nodes
-     * must have MAX_NODES+1 bits available.
-     */
-    assert(sizeof(backend->host_nodes) >=
-           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
-    assert(maxnode <= MAX_NODES);
-
-#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
-    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
-        /*
-         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
-         * silently picks the first node.
-         */
-        mode = MPOL_PREFERRED_MANY;
-    }
-#endif
-
-    if (maxnode &&
-        mbind(ptr, sz, mode, backend->host_nodes, maxnode + 1, flags)) {
-        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
-            error_setg_errno(errp, errno,
-                             "cannot bind memory to host NUMA nodes");
-            return;
-        }
-    }
-#endif
-    /*
-     * Preallocate memory after the NUMA policy has been instantiated.
-     * This is necessary to guarantee memory is allocated with
-     * specified NUMA policy in place.
-     */
-    if (backend->prealloc && !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
-                                                ptr, sz,
-                                                backend->prealloc_threads,
-                                                backend->prealloc_context,
-                                                async, errp)) {
-        return;
-    }
+    host_memory_backend_apply_settings(backend, ptr, sz, errp);
 }
 
 static bool
-- 
2.43.5


