Return-Path: <kvm+bounces-27507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECF9986991
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C81D2844EA
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA96F1A726A;
	Wed, 25 Sep 2024 23:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MYWKVjxC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gxw4Tx8X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A961A3A81;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=qAe5Eij74ZGBHeIF1THnnhPAbrhFhceFbv/g6ksI8y55qVar9wN3yhs/FSQAVYRwMbFzE4Y78I8k8vsG8TI5ht6XxJgjSqdxwIQVJ8OvMTGci8IZ4VWhpSvICMEPqzEXcI8BcMuwS8/4UvyOiE3Qi7c3OACJzfboXl15jKvkTt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=L6SnH+xB8NM1+C1fI1qkqow/lTdGFhcfjGFMYxe1H6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OdU8PywHQERBQFjFT2O4PV22KUb+r6g/e3NVK7Y4CI44HqGlka1sTbZSB5n6hMEP55kkygLkOAxx/Wg3rVNlhCXH75k71ohSXKibyeS1DbecUy7kcFsE6GFkQ8HwhG7RflNlnHSyG8w8KZicdroG2VOsaDN1UV6sGYbFckCTFCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MYWKVjxC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gxw4Tx8X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnMb5028904;
	Wed, 25 Sep 2024 23:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=HpQlGVX5cSWYd/aQV5y/5lzFvzcVaEGLju/Oz9ou9lc=; b=
	MYWKVjxC/9w7o9jJWjy0OjFEf3iJN1CfNlBPYTnbiZjQbaD/lJMhH3ECFivU1IX2
	Npsc6Outysceo8n6EFNrmnvlZ+odz75rv2jaQtr4M1kVJzBsKyYFCkt+5E3dV5i1
	ygkSsT/ZWc/y0U4y9+LG2/vxl0cMrSigTCcbrwKiPAma7/8BgHBrAl6FHAMTsibt
	xN0ZlpeRg0aeFoLdfnQWIMUcN/xfA7h+n0H66TodLhhbkwdjDA+UUvbrVxwYt4al
	7I9HFBbLWqyCmjZP/Izg0/9T1O4kqvP7JjkrJX3AGjjhnNg+p5LIHzDtUSIUHifP
	BBuiFptLPWTCBoSf8vSc1w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1akkv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMUr1V026114;
	Wed, 25 Sep 2024 23:24:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkban7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vS+G2J1VxF1QUHwFZOG4a++Y23Nua16NAMQGNy7NTZKBGqaYNzmhFFHZ1XFCDnd0XJ4rZzp/Y2ihugjaPh+pN/EtBFUIWc2BVO4KyyurduePug+0q3Eoudk/uwQNfvSDYGtXqnxghjpN3eFwNpRLjZzzVC6UMyCJgHE1wJpgsC9q4esR/JAOo6tfhJC200ndzXwH2LxAKgZ8W2cG/7YTvCn6q/urGcvr5cIWOioJGCKIQgVwjMXweGdLnCHKwRbnWQgIkZ8W/PTu/RfxOGGEoCOBjX8scJlsFmSV7iW99NminOjGynT3F6TRnVOgIcGwMGAGacKzTC6Wl6WzWyXdLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpQlGVX5cSWYd/aQV5y/5lzFvzcVaEGLju/Oz9ou9lc=;
 b=pY1shfq49Ap8PKZMIJEWVLZBGuybTHV2iR1OQOqjnnOjZ9swCmE+U5Fyyww2uNSxAxQFzllWKLxGL856/08z/xBjrbrtBYZoLl9TZnyaOqRd1KqMmmdKwa3cIJqn+yyTfHAtOXQLxAweyGAz9iAnbQeQqPRGB1K6BvJVBTeVdBPey8PMS9fzV19Hgs9ef+JVp2zzMDPzr3/aiYfpdDBn+kCdG6axuD9zviYNbuxPB7CML3du/ACQjBLErYnyTcEyBwfeUT15q414PLOE/Ic5hBiLVU46hE1jngcI1FD15H6bLO0kVpOOp/hPUJR0DPUMWQMpNL01xSz6DbjMQywAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpQlGVX5cSWYd/aQV5y/5lzFvzcVaEGLju/Oz9ou9lc=;
 b=gxw4Tx8XKuaUKgmQo4HM5qt6tyiESLPLBKGJs7a51o1Oq55DTpdYT57D+MKQxUu/KVMaDVSFSf80piR5HmAWxfl44HsvrcTgsC1MpRPajRFInhybcWhZRt2WqZShQDAuGiFOW32Wpf3aUf5ATHlXhWbvwsx4D8geVksLI0xzb4Q=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 LV8PR10MB7943.namprd10.prod.outlook.com (2603:10b6:408:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.20; Wed, 25 Sep
 2024 23:24:55 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:54 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v8 10/11] cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
Date: Wed, 25 Sep 2024 16:24:24 -0700
Message-Id: <20240925232425.2763385-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:907:1::42) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|LV8PR10MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: d173fca9-f558-4387-0de4-08dcddb94326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jpOzDQ70Y5ePSEASeM7qAw6KpDh8R1CYNouzP/mLIwfi18bIQM/Sfsdtne/3?=
 =?us-ascii?Q?tAXDjpN1YYkioge5l8dvv+QTvZmtATO0rmtTUqEKXtjOUb2Jn1AJGyAuQ8Rd?=
 =?us-ascii?Q?jA8+fWLrL5SQe2iHrCBwqegGuYwdHusRXhL1k1RW2D0vVFOzeI90k/a6/7Hj?=
 =?us-ascii?Q?WfRgVBa+ZmtRoryylF/eELlucqj19PU3wkPU4psCdFTgdc3cX4i160ak1FRE?=
 =?us-ascii?Q?YTDcrCPR3SgU32Jl09uS2jdB8ZQWuWsAwGPjmGy8nQHm1YSughK9wEx67+WM?=
 =?us-ascii?Q?iyay68AJD8eLAxW/VyzjDxtM/ofG+hrftKVc43i45xMkMDyJjnyUhin8RaIf?=
 =?us-ascii?Q?QerxMqWxaYUQENo719YHqe5/+J0VrZRVeGMJL3miQgqyJgQVv1HDVinPyfQm?=
 =?us-ascii?Q?Yw8bH9e3yGO3uDumMvSbA6JIMg+4BY/Ss9U4IOvJESSWN+n8zN2Y4C6jAhSM?=
 =?us-ascii?Q?oW5vTd8X0lgOg8KHbwXG1TD8ggZJSjCtHh8HDAlhFbN3TmwIGPf2elzn9pkl?=
 =?us-ascii?Q?3zqWWNMb1ur1k79w359YszN/wiIPn38/P0Zm9fELsx/rHBWoOKvyrVAk2CZo?=
 =?us-ascii?Q?4OeJegtphGlNSskY0Pquq4q7Pp5HjNoOCEHm4WomKtXGfVWPpLKX4DxZKDaq?=
 =?us-ascii?Q?7of+ll+SKLeCk/Uv/2Z4NOX3mYP/cGhMKVv8TDkQtt8QymeenAOE7HP+VcxE?=
 =?us-ascii?Q?jxQNT69RL3gVwfXL1bATfycU+nYdf7dNo6/BWO2LYkXShFbq5/QMkZDC9IhY?=
 =?us-ascii?Q?wdA5Kc500yunr4WYfbJz0gvrbAzV7jt+CI423c5e47QiOBeUsq5aDpJLUBUP?=
 =?us-ascii?Q?yzjwTJoa9YJ/fyCf5/lS8qb0EJS1+ns4YHlu2g/hDcdOAKLDilRetDUd+Hlx?=
 =?us-ascii?Q?h0+MMigInKIilXdy/QGCa2XTZk6Z/EQ70OlPVC+oww03e0iPhcj1PwjrxamK?=
 =?us-ascii?Q?3REX2wDj8C7UBCODi6yg20HgNjcfvJz4OG3ZOSTmpmS7fdAJkaNqMkakcmUz?=
 =?us-ascii?Q?3Z3W3qnrvFFPqOdP2VVJoFAHXzIZbBOeCtbHosqdZMt1MPakxXwFrHijfP+y?=
 =?us-ascii?Q?WrY6Jw4IhLPgrKGnwG1C0p9t47jA7gesrbkurHl87neD+YdGG4N2VxtcCole?=
 =?us-ascii?Q?rjXwIBJBLrzWywFzv2DOe9DG3Ft/A+phyVXV/1wS1N/9E6t4KVtJ8XWnyWqg?=
 =?us-ascii?Q?5JTCHiUNc9n38wFXhw4+3gCdrHZOHldNcCVvQ0R3W7nHDeL0tZKxSePAOtmf?=
 =?us-ascii?Q?GqVh3rXmEBcO/l0ELyn5BUj8jwzz7pLa8kEfFApVbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DGV/5HpowfORnn/kUTUTB+U0GUVHWBB6y+Li9eKUahv36v8x+D/BvUBzYnlD?=
 =?us-ascii?Q?/jmTSQVgNrqUcJ7DzZX91TG43KmCrE6hgCGjKqz6OOM+CgVfxoVjw+QyOnbl?=
 =?us-ascii?Q?bhlji2VJpABi0N5OL4mJPEfgP1PolHiqutrPZqfdvgDo1vTTkOW4V2LD7zZn?=
 =?us-ascii?Q?lRn4i7hywah1eUd86uyy+IxeuAfHoiREK0v86//6dZ52Lh9X651Gwv9n6CXF?=
 =?us-ascii?Q?rfPR+DS/ABLDCI3sXXDLzfrh6U79DgVzX5/ZiLsM9IuBHb08Zipfe4wHwr8n?=
 =?us-ascii?Q?V8ZED4wAwJFDR0DuKVUe9ga+J4RO75aOK22vk2MLpLIW452oiAovFCtLjEPP?=
 =?us-ascii?Q?3Bvi34F0ThA768n8TzzidcN0VzH2J9gipk3oTRnCef1zU5+BhIySAzH3eTiU?=
 =?us-ascii?Q?gyxRO+01Bva+YXrqhEOKOcLD/0nthWsMMXohYljVsx+v0i3yKTGY7i0KyPSp?=
 =?us-ascii?Q?cr9zmIZZfElzfSncOHilUDdv8yUbKO7uNuaGUYbo3dI5nM7GxgsTcdUztd7f?=
 =?us-ascii?Q?2l2GV1mZ2r8iBCY7l4IJJsDm+H2jqgsLChu0ju5Uletu/HyHZSxy8napUw5X?=
 =?us-ascii?Q?GNp1v09S+CRZhLk5b4nCZdKMFBy6FmLa696j5q/6v7d1fNJ2TxLK/JQU6Oju?=
 =?us-ascii?Q?n85dcf4VVgBA6YNFRa4ikzbBjw+3bdJ/oay83o5ZE5SF3VWdKSv+MUF/8V59?=
 =?us-ascii?Q?fLX09qJ45JPQLEXqHnrszLA3JVZW22QuvYjrn521N+81XidfnU/wbDBJMdr+?=
 =?us-ascii?Q?/ZhB2288qVWoJQgdsGgkVlAPDujq6JCS57rczHgheXOIDAkWGyBa0kY/EWXP?=
 =?us-ascii?Q?y2e7GjqA0e6Ag9e9NhQBd9siMnoLN3PX6H3IKfVSieVGBu9+Ee29HhXRMZDk?=
 =?us-ascii?Q?iQr70LN1ALuIkjvUd7IhXm6Ph0+x7aGuM4rIVgMiBhL7THaGClJsBZjci3Pb?=
 =?us-ascii?Q?k7ioqK8FODFQoCwn5XttSlK8QMWnMHRom+NGVPrqeDB2XzKK0va5dceZE2dj?=
 =?us-ascii?Q?4tFuegAeNzyJMIU/M7295gbGPMEAVkQBK8rVBcl1RyC7+XUjUVSrwgaAprCc?=
 =?us-ascii?Q?HtObjiptg8tQxP25PCQoJqvThofQN8ahAHV3WK8MIiMt7Y9ealmuTiiOHr6t?=
 =?us-ascii?Q?CGO9Hb/fhYo5KslPFw2eaO2CgaNChDOhjvXnWLVoGNWlwjrESdslh8ObMGwt?=
 =?us-ascii?Q?Ju6NELWhBsU6CwZoxfIIFCIsOC5Hsm7nVDLrXGROnnmrS6gTcEG+vdXPAJDp?=
 =?us-ascii?Q?B87shR+53+DsR9D971hM6ZxEX2KwxHwJH0pNpvWeBa6oEsTVQC1PFxnk0W/5?=
 =?us-ascii?Q?K5umCAgvnkc2vUy6hZRT6lahWFxkz1hcjlV4aT9QJyRc3wNqBtiw2jDRcbHm?=
 =?us-ascii?Q?EPY3w8VjzdqY7lHGmf2nThLuU3TN7OqCAi5x81+O0yXNb7HJv+x+brid4eku?=
 =?us-ascii?Q?ePh255UrKbAveCBpICWluzpiC0xTUYKQ7AO+4N/N9hEBrNM3rpnJ4P80S+c2?=
 =?us-ascii?Q?3bU+0fk0suXvQOFKtfYNFx7zVTnjtvtuteNdouM/VKBca1+9mJXOu6ig0ZDd?=
 =?us-ascii?Q?neSMeOSJyHuSryENlueCr/qvOAvwbm7sG90dYP7v6Cuecm8vs3w8Kx/+ROzL?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1GnALJbNmfSvzIcwKs11dTfH4xqVfwkN695z/EDZS4D8JVBgh1ak2b0inCc75Bc0OMr946N9y+bZGjvRDqYzzAbUx/On/r/HXs7maBI9wqejN8g1MOaHahRNGsUJHFfAi1SyBuOGqYKymte1CxVnfI+smDvvFIc5qop9k2qC6owPEAD4VVDTqKBTYtntQ1VBFIR2HYoNjJr5n/mFnZB/AarryK5qwbNMDzGUNf9vveVLIjrgxQal16TA+KMXTVPP0lldDVafZstovcfNvZhCIMvp3P0OlDLWwaNEWdq9Bgwmje/KIYKAY8e/CFbNzqp0qdrfaGAc8woE9pSUY8wyej5FDPxIJGpW01X17fNDxE7P63FszAzP6AyLaTlyQfd6bNy+IPWxzxTtHuxUvA8X1/6hbPwrcvcInaCzXM+SIzAAqgiOdxwp6W7WjvLR4QPUNy73U0tGfueXA6N0bKkRgTKpeP2aKnMPajBCnXZ6VsdoPv2R55+IHFWIEaqScEtvPYTxhjfrV0RMdKSYnLsvik6GIh2cyhrqaeQgfTpmg9SQZG1Ywbv2eLoQTp168/Rk2lxhU5orDi7A4douLu16hEIjHe+h9otaeoIB4RePFkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d173fca9-f558-4387-0de4-08dcddb94326
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:54.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9ytTZSA0YpfkM9FHxOjCucaG9x6g0oTI9/a+jy0ijgrYUJxSWcPauhzCxeAZe/vISBOjV/RSTDfVoUbw4D0Q4IXhWkDKczXaChWfMpTEiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: vf_4HxHQhXNezCUT64Q4CiXZ-VpikQYB
X-Proofpoint-GUID: vf_4HxHQhXNezCUT64Q4CiXZ-VpikQYB

smp_cond_load_relaxed(), in its generic polling variant, polls on
the loop condition waiting for it to change, eventually exiting
the loop if the time limit has been exceeded.

To limit the frequency of the relatively expensive time check it
is limited to once every POLL_IDLE_RELAX_COUNT iterations.

arm64, however, uses an event based mechanism where instead of
polling, we wait for a store to a region.

Limit the POLL_IDLE_RELAX_COUNT to 1 for that case.

Suggested-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index fc1204426158..61df2395585e 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,7 +8,18 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 
+#ifdef CONFIG_ARM64
+/*
+ * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
+ * while polling for TIF_NEED_RESCHED in thread_info->flags.
+ *
+ * Set this to a low value since arm64, instead of polling, uses a
+ * event based mechanism.
+ */
+#define POLL_IDLE_RELAX_COUNT	1
+#else
 #define POLL_IDLE_RELAX_COUNT	200
+#endif
 
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
-- 
2.43.5


