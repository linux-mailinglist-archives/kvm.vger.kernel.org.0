Return-Path: <kvm+bounces-22358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB7D93D9B6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C28451C213F4
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86C3153BF7;
	Fri, 26 Jul 2024 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aflmNA/q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uoEZdvDg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8FF14B07B;
	Fri, 26 Jul 2024 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025349; cv=fail; b=Q/82w+T1YxZfgJwZPPDaNfdS9kOvrERZUq8JMQ4ze9Jg/5fuaypAL00QdY9WM2T4Nqt5gF3a8/9paunsBEDjo2gqkvhY58bsrfYkVo05F/atRAnjEnN24mcRDsxRBp7J+MzYbypy6ykBS/b5aENcl15KVPeErUntvz7VU3WH8lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025349; c=relaxed/simple;
	bh=G1EB51mc7WEC6aeP17DTZqrTGwkiA8it+MyTC00o3kE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E/odu9UNDhzrhnKJ7fm/WaylmK4uLFKCf1KWh+YkGfiWV1NESHgA3WrIdWzmLhGYrk98aErF7WtzJ+U2hIxWBFIeZz2yuHGAqZ90z2hEBIw0XvK4zZ30Snq+f82SuAT83nPLuyad3ImLdMCBpN3hMwsjabv/WuNruM9fNJsbIaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aflmNA/q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uoEZdvDg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QJjvIY018752;
	Fri, 26 Jul 2024 20:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hzptKXz9W9c9WZCb7zy3uwikGyU3kBX6eeGGRRqMVXA=; b=
	aflmNA/qBSH7qh4PxNLq3eJMuFUsQcSlT6uB3PJ9/WV4YQPSRBOXZUGBBWlMyi98
	9ULzVIAN063FFmQm1MDaJgf6DCM3y8Et7B4htk/jLvmu9Cqas3WWMCLhNKUwapm8
	RiGUnBLyZis8xpKWpqp2vy7xVdjZiv2eEGVGNBgl6SxqIkiyA28N3r6IHznHZf6W
	kEF50UYct6I/Eb9gX3C1y3lbD90F6JLkNAyrhAPoZqI92rr1Yese90Z4Ak4pCSRH
	1CbDB7qiJE/HpM0J5SvobqroMe7Dafy9lB4SmkZNG3STFa1c5SJlSWc3+iFMXFSh
	goyi2///r8Iu4qFmBkSidw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfxppjgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJGGUl038916;
	Fri, 26 Jul 2024 20:21:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h26s48n1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YoJT/n5IHake+URNR12r09uYFcFt64ZS5/ZzS0+N92mtTg2sePjSWNHkkXUW8EHAdWWOUvbU7qydF6JfPvPEgnMMPmH1JyyBfQgpG/MQoNXtcTFNHVcroDUxetq+vkSceAK1M/BURIHRw/qxwgd+fSFgRFTKNrjSilWL75++RuQBxRjfisKYJmU5C4BeRpdSLRWayU0bTnc5wTgIKTmhehoYXzex746EdH6QmtV6cG9cI9VoXNUOpZKokKAiecSLrDrEaXzomtz1N4rBRkTkT6OG3jN7NLdCObsBcOuScivHpSnZCfV4L0KsIlNIvztD1lGsKcizgzwW8hY1LF1xMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzptKXz9W9c9WZCb7zy3uwikGyU3kBX6eeGGRRqMVXA=;
 b=H6QHZoVz8H1uxkoxnNXXsHrlhHMrd7axbij4Mj1ZSiMaz9QY+LZ8LtuuDVYbek7/MVgjKFBbHjxXGFbeYDTcxCeY58kkWDNMGYCgILcB6QovXJ+cYPVzo3FUT/ZeHbPA/3mnaMIdIqbcblZbGMsWNZYzPXdyWZ8H0qS3GFnNbqCYlZujQOiUKvlHCYOSeZr24xoxTPouIQXcyJ+3XK0h2XXTj9Bm3vIBYajQiBiN7GZTNXCyEYKwavYcbAHioGUTa1VbL0SpKFjBC89zyPepboSvljSDlU3gsrKekL3RASPB+UEouWJqkpcSEvpsynotdDgNhUeuvPt6azJFDwk1GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzptKXz9W9c9WZCb7zy3uwikGyU3kBX6eeGGRRqMVXA=;
 b=uoEZdvDg8dgqBJnMKZX/4tfa1aa4sbfLWGRPp69i3py4ePO4Ab5wQq+3GieA1jwX2NgNm37Ph+O6myu5jcu+wdfRDoq/KhUbQ2nIRw9wfmGCs2lblUzEeAxs9jF5w2mG+3rm24SufmlKundQVSVgjWA0uhtsAKOED4wpQo37GT4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:49 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:49 +0000
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
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 07/10] arm64: define TIF_POLLING_NRFLAG
Date: Fri, 26 Jul 2024 13:21:31 -0700
Message-Id: <20240726202134.627514-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:303:b8::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aafe9b0-e1aa-40e6-4240-08dcadb09435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BgPMWV4RWlwaT6zYcV9Und9aw4vum2lfHT4ITVyKELRraW7VwSKcoEM0FVdg?=
 =?us-ascii?Q?yjssa1EOdqvq3mnTANkgCicXjFr+ngn9N/baPnBhsPsav6oIi1pYNzY61cEc?=
 =?us-ascii?Q?rGK6x+wt95y28Fk7NnuOGKxeWI9QuwaFpupVM/0UKvaz8ufYTEtnEWLGVK2+?=
 =?us-ascii?Q?uUpq5inekdO1Yben58r9XAcq3+TYE7AJlktOwKrUYn5fYStF7UDz56B3nwL8?=
 =?us-ascii?Q?DGFL4aqOUbQ1mUVh72uLASPpsUo1Gru4ejrVjFmOXnsLssk3Q19Se8BbLKjt?=
 =?us-ascii?Q?kQ2agGZPZcexh1eNKGZuq+olsQphPEN8Eg8XAgIdMSwsvu5EUValJ6oD7XkE?=
 =?us-ascii?Q?BjS7iyX7SIsoNTjn9vuJrlssY20eAeRkgxyQa0tpxkmQ4Evi3LJ0v+AKRE+2?=
 =?us-ascii?Q?i7shNup4+cuR3kJ7rtVpAkS+MGp+IhlBISYtLCPFP4SfsZm9oNuyu82zGK4R?=
 =?us-ascii?Q?M/dMkmdTI4wITnb5nACPIaYqhz6p1uOtNQ9B2IqT+86g6dHS6qw/1Uh7krpK?=
 =?us-ascii?Q?G/DGwpuBjUqwVBh0xg0nrgl1fr4ZzmAAYQayatrvndeonXg7ENykAIUvUdlv?=
 =?us-ascii?Q?C3PEDhtkY9YVfnwgfTBg0gpvfLT/JEQ6frC5W1aYyKF74dl+jylTZj+whkDZ?=
 =?us-ascii?Q?EcqOo/LWVljSs0nM02vACcDSj7k67NjoGAJo9F4g6ouDzqbbQT72+XVtsSbZ?=
 =?us-ascii?Q?DqURMlayala1iJAm1/m1Jl8tN8NAAtKVXac9BhdL192TgiFv4oXh1piqmz/d?=
 =?us-ascii?Q?hsZGVCEQFchycdCdeeo96cokq2SrJ4j6DDHxbVSIGD22xBAN24db0Q8spYvY?=
 =?us-ascii?Q?LhYB2rWPk1N4B8+40pt/Ske/mwaU7SxtLAJdU4GYgdkYuOHtxAPSAu2zTj48?=
 =?us-ascii?Q?+qB8hrjictFqz2I0V9xaDHDrh8D6yn3478gex9nF8qkLWB5N0jsBU9kY/2s4?=
 =?us-ascii?Q?2xuOXdBlkRBzaD4fBRwIYbgi7n3RhBuAAd5TtLAROhnEJMxI5IyUdlUiSiTv?=
 =?us-ascii?Q?sJwmerueLzc2nlezU9mBpIXnExj0Tz2KX7HG614/sIBKklwePE4sJqFOceNV?=
 =?us-ascii?Q?/MEGWKri/MQsJyJ3bX1nWZi83o2D5HZ7oJ5GobeefcPQuszKgYnsoQjfZOzo?=
 =?us-ascii?Q?FdJJcG0YpfvdVGdGVreOyvsEN2DRVSLsMd3B9VmVD/0tgZbi/x+e0NNpk4Na?=
 =?us-ascii?Q?QybAp2g2SF2t8R0hopNmNxzawqCx7EnTEIX3gT53r5xe397dxYnaowin6eDz?=
 =?us-ascii?Q?TMcE6VPn+EkwE5xDVi9o9JUp4sttlArWNKZmYn7ge2jL02xCc31QPzjje8Ed?=
 =?us-ascii?Q?+O31KUNQPqrvzH1h8lmYFmD06WwsqTRMivn0o8DDC91/DA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wCy2U8YYayHw9DL30elUKIkz/XydIOJkwD0LxccNOlkS5uHSXeoJ/L4KMF85?=
 =?us-ascii?Q?73F01fLSrwa2Nb9n78q2TYIXsmIX25B2eq+aEC74/51Pi/+Q+aHt5NLPpJo/?=
 =?us-ascii?Q?4ObA49dLo8yeupr2TJ8bfXwzYQCUQOXNdQ2aAUxG+SwpdgjVJRKJGuMwkWBN?=
 =?us-ascii?Q?utHHRyxEsnSGxGZ3AODtU5Kdeif4XA+/5ALx4EjdP66I5gfUoZGXckgZqAcZ?=
 =?us-ascii?Q?JAgllMdJeHVJZBDbjHlTTB8inJyjWPeUL+va3RcykKMgKFo7Tc9MhixR7ETb?=
 =?us-ascii?Q?1/gRL309aOd6ir21KDlPznVqsjZPYUnaSDOJpAlfUdl3YgKrgFtzS+DWvLXo?=
 =?us-ascii?Q?UH7meLnxQa0XnH+4qcbWRnnMdBonLcGyuoumNvenMWO0ivorWg424S94sR60?=
 =?us-ascii?Q?8JYjaSUK1Jtd5eC8AKKKA6BWOB/ZJu9aLrFHF1a1ADe90YKuEQzeXVCp+mly?=
 =?us-ascii?Q?mZ5aLTOmPfPIGrhlZXZgWhHUTIQ48UMF1xTXE2G/Y6zL3nCMYxL5pS/ZzmWP?=
 =?us-ascii?Q?0HzEwI89O3Jb8+CC9ib7ZnCyMmmn9yUJdrffCGz77MvZ39vhG8FCwRLyuVOO?=
 =?us-ascii?Q?W+S9osZMn9uweVtlk3Io2H1G6i4SZuKfVkguoFp6uSjDkX9YwOzptVWz3pS7?=
 =?us-ascii?Q?Va8C/Q4X9T1rigzkGUjTVbfSgm3h1IhiAtyXYrOXN8IFSGvPSPUG9vKTAZcJ?=
 =?us-ascii?Q?eYvHaqXorjPZqTVCnnXHZUhLJ4JMTq6EBahQPQAINdHTvYPnOyrR5YsbKnHU?=
 =?us-ascii?Q?121fNq/DJbM0yKFqyG7piwtTFhZAdKwhkhcUy8E3v0ZdY8A0H4QLMoRiA/Xa?=
 =?us-ascii?Q?aIy9Yv6h1kp7ootMykThPrUXwnKvh3mvdE+SguHAr/2yO3FCPl7s5SbcRlOX?=
 =?us-ascii?Q?SVhCe/1LO2WiJ56/1H7fB1uHLdwKKhMjVyyVl2t434XcDN5S2IvRnJl5nDPC?=
 =?us-ascii?Q?VTznz1YTrom4nFON70gmF+sIr1D7hUtVBjAVYpL0whmyScGM+VldvWVqd6W7?=
 =?us-ascii?Q?MewE0ugn6BlxTO+st1/ky5wf37mEslwah4R1OE+tkJmSxHqEJLO2eAIzHIzY?=
 =?us-ascii?Q?Sv7K3J8hZYWgCtiO8KnI3zBV+Y1Ar6nGvN1/5jIZ8E9PeT5gM5V2gHb3oFh9?=
 =?us-ascii?Q?zpN0kws74QN7ONy/aZcWC2ZRI3n9A4KwN/XbuZIm7PmWsyvW9ZMKXkTOrkSe?=
 =?us-ascii?Q?bDamPIVdKG/3/z2pdlvNDpu89eY1s85DyDn2z2z7LM8mGsWu+6X1D2tUwccR?=
 =?us-ascii?Q?IqVWdnXW8eIfFg0Nvn01VD9OAOSXeyJHPn+dfylpCInJ7msql34tt8RZJIqn?=
 =?us-ascii?Q?jm5P+SOrETHifvA+vOdbdlnELxPEn1unfDU8L2SG4McIs3IXyBCqVxGy7b7n?=
 =?us-ascii?Q?unh5mxF1Lc9m0lr44Mg79g+M/TP8Bo0oXpcspPXDDtAXGB7vGQs7q+WMK35m?=
 =?us-ascii?Q?NJ9wZDh5GOM3quHZqE6yFwOZPEFZdd2GLr2zawkq8wwOK5Tv3lDjk+8eWU/f?=
 =?us-ascii?Q?+5IvVpFNb4llTSLA4yVH2oFkt7/0jz+sdWVVUxL9ns2QjluMz18fh32P4IK0?=
 =?us-ascii?Q?ZYLg1jpKmPl860kxaAi87yUpbe9gJT+xskRWlkpfkOxuKGMX/obxYyECzzW3?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gEijss3gKgZT1xgpEqbrHIojRcG6DQ5nV6YX6TyOeoxwKS6ttWexGnXpiVOoxVDQyz2fzHxhb3bVC2Y00/A+Unh/p0/6tdkkUsr7yzGDfI0RBDOUydeAfCWmSRX4niVNVlMJxVqkEraifofgZYJbi6cPETNxtA9Nu43pCixzDa5TZZeHKqiVltdelI4S7pocT1+rUldbaUoeIF9i7yQ0jzhHP5s4QSxkK9z3W6yNpwJU7m2WbL28RLUPX2bvPg1y7s48zBGjAvAqJ6jm0Rb+hpv+iN8EkuCFbyNFHj1qUlyE4a9ZU0qyQKDYPo8X09mDiDExbq/nxBf7HPOniKUj4uc5Rv6PWInxCJyzwOv2Sm8/BjcPOgVn9/uhw+dO2bV2rOqrWzfC3Tq5uJTA6J0ze/BT7zaQsF8J3Cvt9wGkGl/tapJsWP4z+lqH+ESjDQX2lrMbkwtqPT2Loc4bNZcnEW3jzHgzoXPOat1OfuyXqHz4f9ufIYrB4Yk879gEf1wAFVSrQiPRIox/AFMXMUdv8JXWz3SFrk/UZZvhJ51W5Pp2CWUE+23epdPCELFS8wzM/xUvxXZx4BvoMKq3NKjFZy+z9PEpj2BMry3vnNgoOqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aafe9b0-e1aa-40e6-4240-08dcadb09435
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:49.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSHoCrR5VuxPf7dJyckV2gH+NtYnJq6uLfR73UPuMN/5TGL7SFCDTWlN7fKhkCkoFW0TeHvQB96kRmyhwiNNEWL3k256Sw1YM0vtxUSbTxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: ozDLU4OUXYKSOjqjmV8l3Ksa0JLkRwmM
X-Proofpoint-ORIG-GUID: ozDLU4OUXYKSOjqjmV8l3Ksa0JLkRwmM

From: Joao Martins <joao.m.martins@oracle.com>

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
cpu_do_idle().

To add support for polling via cpuidle-haltpoll, we want to use the
standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
polling.

Reuse the same bit to define TIF_POLLING_NRFLAG.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e72a3bf9e563..23ff72168e48 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_POLLING_NRFLAG	16	/* set while polling in poll_idle() */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -91,6 +92,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
2.43.5


