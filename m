Return-Path: <kvm+bounces-41003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A77A6023C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C77F219C602E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D211FF1D2;
	Thu, 13 Mar 2025 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UKBSfAw6";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CuLDaDas"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE41FF1C8;
	Thu, 13 Mar 2025 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896668; cv=fail; b=YMDOVKrO1SPpLBZ3hIKRAlQA4HJPCFpKsg2aONszGuxg32HzSZZwaqJIBXSTTCwdQkbsFQxWKmII8fooEavN+u9YJVYKAyDuLEg7yeJ5kWckqOPSo9vym+6KoidTCSwknVgY0UCiHvkkpbUKMk+SF9XfFgZCM5YY7ZuFxWrAnIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896668; c=relaxed/simple;
	bh=f99cX+EhE/Fdsi7SZLpFn0ol2oHKrgXKFv+eio4SuVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k34oxPLTO/WvluiuYGMZw7hNS9p6toEiFICbaWKddYU64CZ79d8FcMldTNZ/5RwcD/HEBbqdwhzdc3Rxu8ORSJ6dAnaJRGppOgqHMhnwKoAmeFsEboTCybQuNZdBoPK+zxcZUGe3lZTvUV4cnrG5I5O7APEF7qgoWMiQmvlZqRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UKBSfAw6; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CuLDaDas; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DExieF011767;
	Thu, 13 Mar 2025 13:10:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tu3lmTL7dcI5NcKYuOjj8f7c4QoAe3Uy2duIOQvSB
	2c=; b=UKBSfAw6Y0eaFlPHb90lyxmBGLnb5ElNIBCdE+7q85az0gzgnoztEkmOG
	GZvxNOfntWHuRwK2e3UVtVN929PYWsTiBpK1VNkKDVSvIzUNvy4mBI5uhqIjnjJ8
	/VpGz+TlwfYuWWcIlf9+HxVcphUTYRhITTyIjJXUyjDsbme7/nsy799oou93WHbE
	8UweDPcCf3bhxBm1hCaCTBY75TrTRiuHNZmicIYpMPy2tGw4Sti9WehM7gym3F+P
	qMC095qTrQDaJtk+m9xTWyphwD5HF/tpmheY9S9WsBnCwdeFrhRDIlH6E+aXKOzA
	zfZ9Ek7w+XcPwiXR/jhYRaSJwmO2g==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge781-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gS/WGdnkFtTbcyM3VrK7mvhVvb2iTgeU6VesSf2BzZvstj63vEWRoY6iilw9npLovf6TPUocaRzmmZrb3Rm2GE2IRxH9Ei34oap3QZqFYUlCdKsxTRKj4mIAX7GqsnWBDh2adALGb7NH1rLd5h9HCWQpyWtiQyU/ZOPDMtAWybWtSDMzc9t2xR3Ws4qi0ZZD3lzlXHrI4RWUyQ0Y0oux8n4PzlCEssdtNev8c4ccHxEYAtcECNoxMZIHbprHkL6uOKCjHszushcubB1XtUYYEEO1SYl8rMszK14rfYTIh/Ogm/GQ+MdDYtcyqeP4rPli0QnkEuseKuhwIetTJfGkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tu3lmTL7dcI5NcKYuOjj8f7c4QoAe3Uy2duIOQvSB2c=;
 b=MmqBF7j0/zmU1d76dFr3bo6caAU4vzXGtqZ0v2vnPIpcaPwhTKB64GvFBqlIURvED6vHdg0FpZTSqqcEzJtjB6eEHXYrVEamaNM9HH6JSSI8c7sWF5QDLaMl5qEeDdsnNIsR/cyKDjfufsFJ9kYKFkxP219eM/bkjkPWfaBHYSPt8XDG1tOgk2wmP1mX8BC2rWZIQHLoOGGsXwcdk0yCkk1NZl0B2Ksq8ANdjBd0NFk7LgxyYnuDDV60nA+2UFlsvCitMjV0ZGMO/7q3yXTzK4lWIb7XeqMiRJTNpm6QGCUtvNM4GsxzBBMHUuH/ujZobFdpURAsHIA5u5ojDTMdXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tu3lmTL7dcI5NcKYuOjj8f7c4QoAe3Uy2duIOQvSB2c=;
 b=CuLDaDasfoxw/zg3ptTKhi+cHHIj6c0UaoWUGz02IhUJg9CYhZp3mu6Zf+vYOLvhWSUNd1Bpvcl1VXj8+f7TduhI2ZNmd7lfH8R7fm+LGPG2hhp/X5uULk8pVQCOBPD8mqgnx8Zw04qN87dSEJfwT/emc4GS30TkGcZ9yvQVNzOQhQHRyoYUTa9GbIbKF5HF+A2RB7OHCX+ysyGs3ZbRl3DYn0wf5Aoce4Aop6PHdsx3z2brfGzCFGjHWSqPwyXEm9aPuRuSTF0LSqzN3UVou8SooI/FL2HJ2EJgk+KR7ABwsKC8Ko5IRAqF8S/0B3wZmidnVo6+DL1fTgaKyN2/XQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:47 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:46 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 18/18] KVM: x86: Enable module parameter for MBEC
Date: Thu, 13 Mar 2025 13:36:57 -0700
Message-ID: <20250313203702.575156-19-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a05ed9-d71c-42ed-ef2f-08dd626b2446
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rW3vvbI6wN51F75VGB/zc3HKWJXq9Pxx8vbiNc8cmP5SvwXUlEw92lBi+bHM?=
 =?us-ascii?Q?zCCfjXB0Tq6jhWAOF6VScm6Y79KwLQ1XFliaMwoALwjsi36ibBGoFsl/+Zln?=
 =?us-ascii?Q?WTRlDykMmUXXSF+L+7nOwhqY25nNkjHqVOTJdww3uUJqOjvd+ZcLXYsu0dkE?=
 =?us-ascii?Q?HFiGP3XxVQt3cuEOulDbtg5irz+/QKuA1Sa/BBSim+mQyxzDc3OlX3zGYekQ?=
 =?us-ascii?Q?dBPrvJeLwQvR97wwYvtTq472D6DGan21itHoEb/5IZKfJj/nGIlNbf1genKH?=
 =?us-ascii?Q?pJ/rnMO0/kFwJQRjDbILXvfk4qE+5PGGJ1tp4jsOVGGS6L0ndhJd9TV2zzEC?=
 =?us-ascii?Q?9n720kUJUEiaPPu3sV2FjsOM0HlMDhgdN40iKX9jLbtWIUNPCf2a0fEDmJJw?=
 =?us-ascii?Q?1Nm8atbBpju88Cv/dxAuaSd/CM14x5L1Xy3CG1oIViqk85LJhld2WiyoZo+W?=
 =?us-ascii?Q?FsrBNKLWA3kVKg/QmNDUMh+SnZhx10MKA/xrMEf0tZq3zXjaEWUUBQOj2wb7?=
 =?us-ascii?Q?+wEYxtkav2K5oh3nzdHz56hjp8wJ3I4NJZmI+3CYHuIXhy69PI1VlMTrBHqQ?=
 =?us-ascii?Q?+UjTWo+pbQfocIbrLHnp2oaLrQPxcIMctn0+haqpw84XvulA8SxF9jp/9tbO?=
 =?us-ascii?Q?kL5yMUN1vGP6+R7EHNB+gD8Pc5sKEpdjGxe2+m9vvlOY8Z/r1srfhXmTNjnu?=
 =?us-ascii?Q?l9EEFJeR7mwMHgMs0Q/6u9Xb2q6iQ54sca7Q4OOHSTP6Jho5TpAyvKh5WSM5?=
 =?us-ascii?Q?g6OH+RIjjFwiIpMsT3jt8uDbz2nDTSerZkr8VNAb6axZkryBW8j7ZUr4NZDc?=
 =?us-ascii?Q?RJKuEHfu/7YwKhte8eZlKg37+VJUT4GwkcEb/Qndyvvfku8Ys+Y2o0Ul/+jv?=
 =?us-ascii?Q?aqGs4VxWf63JUFTHDWIg8fGrJGgdgSuYDuor6Axfkj4ymnMk/Xpv79hPDZ6a?=
 =?us-ascii?Q?q7L87ftomBY/fdjDLrP+/Tg5ACmeKCfg0o2jpDkiynNMGbd62N91mow16n31?=
 =?us-ascii?Q?FXm/c1Tgdppk+FPs+b8K350PsXChKjIIxaAwfQQDIatNQQ+9QJJGJ3Nsw6ym?=
 =?us-ascii?Q?nk5Vr4HsjJhPxi2wa0t4OrHtEwrxZlcIrfiyFP7tUIOv56nHAkhn/QUqqibf?=
 =?us-ascii?Q?/XF75yqpYp/UZvjDKlDuvZFzn3ULaihLN88T3b2cYi5/x6+GtJZqm8ywssK3?=
 =?us-ascii?Q?zog2aMNnGWORzePPFQhMxP4PZ4icFNYC+E34/eC3KcFZezuRciwBTNuUIR5R?=
 =?us-ascii?Q?lX8wKrYwSSfl7mAwyWZ7rQEaDFVuoJcfTk9AmPoFsQAXcgcZYYjLgAkzVoIL?=
 =?us-ascii?Q?SnZiDF3rkooAJL+1Lxe8niD2pMYCSdnGvPhsQMtxxo5Q6QqdMO3iAfMQemKT?=
 =?us-ascii?Q?88XBgMze5ijLyriYGdhMp/cYh6Pd2SIYX7rylPYVByJzV4Ms5vo/a2llamJD?=
 =?us-ascii?Q?CjlfUk9IMsmVKp1GpYkBmZXzX6tZrZUDVwYBsrNSY6uzVurLdGz1LA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ctgz5OiwECuUoFcv87JhZ7r8N/Xqf/opSKnK5x+DpN6BoGJ+jBFzZXUvrCA4?=
 =?us-ascii?Q?2elTmtbLRF7obIRi1ykvFmLFmbH2vqbye0wgdnSCjxXy5ESAYavCSwZJBKwR?=
 =?us-ascii?Q?KGPV39W9TukkH2iVFTAG2z2O3Ewn2vNb3SYkDpBC0VTT3v+JX8f7ywJntljh?=
 =?us-ascii?Q?cYfYVxGvesGHIp5Zfdmxagvyg13d5F0pQNLSjDAfk6xycdfLw2/ouHaiPmxp?=
 =?us-ascii?Q?PhXXpCL2e0ZTtSILGM4a8wZg605zGUJ6w5qGuvPlKrnRPKm0nW6v5sxZqCKx?=
 =?us-ascii?Q?VLdySpPCbCU3JuK7VeMkTSz29Lkykdgy5gufO8c3YtYxaWS0AwkZmbtg0oDl?=
 =?us-ascii?Q?DSCi6dATDhBYnGVxNTQY0WEpqQf+vSB+WdqFKvwnFzi+R9Gp9Db8sPZVt+Uc?=
 =?us-ascii?Q?C62d+C+bLRsGkjzKxHpvgYvKbMsjRaquWvMUm2QEK6dDjZ15qNLC/mbCRJUa?=
 =?us-ascii?Q?4FtZVb0joVa0D33zak/o2yBKPmF8WKicLe5bJBc9fQ7d/EPSZ9O1LgFCqPEZ?=
 =?us-ascii?Q?nipJrJFLPvckffEbDvUTxYtTZoSmN5ExviQgnzhgAJWO70qbQ0R3n24F1vky?=
 =?us-ascii?Q?JOI5g8AobQfZ576E/lYGYcrl6QxMZ90FDKfaoCqsJIdokgEdh3eJt5eaym1q?=
 =?us-ascii?Q?60oG5lyUt7bX7gfi8zbC8dlIRRKuUg4fL0ZQbdAKBSoIfvtDvr1UJy8JKdPG?=
 =?us-ascii?Q?yl3dUXM/oOfwevPrsIEmgXfAhLLSRdRqHo+opXRsGjEp6mdHGR5KpfHaWb4+?=
 =?us-ascii?Q?vHyuO2JspEFR/J/ltUre/BvDGClMV/0gK/470UUy0Q1TORDq73Vj8AAx3g/F?=
 =?us-ascii?Q?/Fht5L2kdK2Zirf/NVOo9btaRKYFgpb1IB2DNPr5jPDwwzfEOP/kknIb2Bfs?=
 =?us-ascii?Q?8c1M4tcF6op0Bwkekt0YC/H55+F01tZLM01pF/UxfCaLM8uwRAvVFVj5Pczf?=
 =?us-ascii?Q?qPeHR2az++CxQab/uG67hQEFD6/lPclBvb0pRN/HMDMZ8e8iIOYwec5pJLgc?=
 =?us-ascii?Q?nt5nPNUD/ContSKiATAqEpUTgDpbmW2t+ruEHAtvzo45qCYlV+hbtpP0QrOo?=
 =?us-ascii?Q?fbM+fnTK33IupSENFzlma7ikjJxfCGEsXloud2lboQDz9OaQyAQVRQ1stj7F?=
 =?us-ascii?Q?Zxl70PY2FbMKzcL6KSeBKZSq+JWyfnCFTNQSuAB9TMVvFaYQEI9X0yW4azJm?=
 =?us-ascii?Q?CBrgwnkO9gb6QwGPOi0DPCcTuDo7DE6ZtaJ77RmXnbKmgP88/qU/5DJseaWk?=
 =?us-ascii?Q?ot75cyvidsOzLQWZsBH5u0GyeZzWAV8TkM3WGdYZ4CIurj2U6EI8SEJaGeAq?=
 =?us-ascii?Q?JVs3CZJD+Q3S8pjdcPs7+euLvdR653D1Z/nrEyRLaGYV7yd05QkxUGw/sNlS?=
 =?us-ascii?Q?xLyaCzm8oRQMJyvImGI4xQ/4PCT9cS1KidXDc76l5IbGtFX7/NIC26PO4uJ6?=
 =?us-ascii?Q?8bVDjlIeihJeraB8WVEib+YBQWziuCCYnPvwcPCZAv9I+7M4XdjkgGU0Vqkq?=
 =?us-ascii?Q?lP4xyCjCg4L5xsNIKc2w/84dX9iOUOu72tIpzaeb4RVpkctNosWfW3vTu2fD?=
 =?us-ascii?Q?w/59qzPuYHpM6ukGaILSqcIl/ch1g/aJksYaDcx3vAHJ/6Epd+YiW3ikQOwm?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a05ed9-d71c-42ed-ef2f-08dd626b2446
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:46.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euVoJYtP4Oo5Mg0Rk4v3M3w4j8Pj5PsEYFnnogJDmZarqTLVNfQ42FTpwFGd6Tflgf0wudbSGMLxZ2FTJ/giCBGjPbkuUYflPamoQ9cpuI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: G-Q1dyFxgKG4hVMiR1xOEsSalMC4uJuS
X-Proofpoint-ORIG-GUID: G-Q1dyFxgKG4hVMiR1xOEsSalMC4uJuS
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33bc9 cx=c_pps a=LxkDbUgDkQmSfly3BTNqMw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=Dj33CgfsmlbFo73ry38A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Enable 'enable_pt_guest_exec_control', which will allow user space to
control enablement of Intel MBEC by advertising secondary exec control
bit 22 to a given vCPU.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b2fbb9088ea..607ed2142ce8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -197,7 +197,7 @@ module_param(eager_page_split, bool, 0644);
 static bool __read_mostly mitigate_smt_rsb;
 module_param(mitigate_smt_rsb, bool, 0444);
 
-bool __read_mostly enable_pt_guest_exec_control;
+bool __read_mostly enable_pt_guest_exec_control = true;
 EXPORT_SYMBOL_GPL(enable_pt_guest_exec_control);
 module_param(enable_pt_guest_exec_control, bool, 0444);
 
-- 
2.43.0


