Return-Path: <kvm+bounces-29111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D12E9A2C49
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 20:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C042B2849BA
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26E61E0B68;
	Thu, 17 Oct 2024 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OIP8Hums";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zPbEKvqw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15C18C919;
	Thu, 17 Oct 2024 18:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190261; cv=fail; b=NQKAjh66gAwIxLIX/oh+RctKmYdvzZOr3dwMs+NpMxSQ/APCiK6dVWrvacSa1ZptYS/tnHQ3wHEhx0wl5n6Rre7P6nFwkpOzhJcnyz3oWTknYHdMhbp2YEBM5TnJ1NJF9qWEeyz//EvwBrKK7GG3HtL8gNDIf2Z9chGMm6OjdBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190261; c=relaxed/simple;
	bh=cCnSwD+dpd2RqxEfDA3u80lPWG8q+up2FrQkKm6wu80=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=tPHZVAS40LcrxLLNzZYerOMRPmgSbXiHzf2Cmp3EUHs8OYKXwoVKBijWKz7wkjxo9LHnP3ob/tw9CubTB38nrCaAoiJxFzfNFaAvBvfb+iUZ5lEeADWgNx86buWQfEyguo4/NTlcZ+OPYUBAeEs38jcHfKfALMLfkRklaLEgVg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OIP8Hums; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zPbEKvqw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HFBerC025106;
	Thu, 17 Oct 2024 18:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=tz8HlIv4wJH89jeX5N
	0hzYF30lT1+Br1sUBnKfTnoB0=; b=OIP8HumsGXqTMTP6zVo95CJesul1IXqfm5
	LIpesgvcnHBbvwlHnpdNJxSCOfy8kTWhwxrVZ7/5o9olXxKrC9uJhUWb3RB1TTqe
	f0T6buW+yrwuVSyrTjx+CXccyVCsjEiDHZVT5CVDu0qczt0CmJFCeiSrhGfsJ8uj
	QvglurmqgxRzYX/bVmbS0yDLisP8TeMaIAHNVyGc8S0R5/cj5NStCVtkYwZMVsyT
	lBqllmpsBsBDqVarefc0k23TjQk+lEeNqW1P7wdffONNeiM405ChaaEdIALra2p5
	8WDaepOqye23wepG35kj7UwG0W1bJ5c+p1pZjYNzMq7/DaogZgGA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1apxqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 18:36:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49HH26CT026314;
	Thu, 17 Oct 2024 18:36:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fjamwmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 18:36:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiTfU+i8sBJWbfjAAX/48rlmUWklfari1C3xDDjgvjgsZeffLu+Tbjy/ZiRm3Jm5m05roBHL2Jkf5pnGQ+3tlyg1H4yFxlIFlrwrSB/6HQEf+jYi3ASD8rje+DbvschAk8ux62lF0K16dBN5Qg5GBXPA8pCbd0+snFIodeMUYg3OUAYlfIVt29YwjGi4rcwdp29HEJ4Xp1OmRpp05idiUgapTloNRSzXrjOEx50LnsozZq5dbkc4M+sVOfC/96umSMnEVgiH1y0h2bWfIUGDeTzdYMTZPIuYpLOWvbOmvKqJvzmAWZ/VqLGVLKE9bULxH2CMhhJIP/pbjl9nvSAwdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tz8HlIv4wJH89jeX5N0hzYF30lT1+Br1sUBnKfTnoB0=;
 b=Z3VWQ7R/nyRqKP1wqrGY3MdzzlHUucgdgkGmE/IvAVUdxOGTq7iHYBySe6vVKzey8R5nmSz0sBuVgpdOUPy91hkqL5LxAc/7tYJMO7mFtVWTop0w3JNK6n/4P2PLENs7Igv+lTkbQckJ6ol3+plww3ZQC/RlM+kg27l8lC7DD0VTuXxmADBLp1CUeY815iAmkEvZeYYj0/TwekOj/bC+SGUrbmG7fGiWcKvhzQ0WclLUX7kSK9RcuNMn4+BVKkrdToTKCn2dtxN34iVOrlZNwDafSGiC5HDeMIzjEUZOr0nGb3MWLOJWpU8bq+exvhJNrw0AEU8UKBXEWDVB6jjGFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz8HlIv4wJH89jeX5N0hzYF30lT1+Br1sUBnKfTnoB0=;
 b=zPbEKvqwKd0ijLLf2sWIi4wHHJsE+nii6X93dYz6ZWqbaq4c0uJrevVDI7vmlazC5Yr7rOXyrTZiQGENvMKHYtns9ClbYSFGkrxifJsxa4fLuc8hoE9h5dMLI9iIcOe6fvGQ2+cwVvDd04qyekd+URQ6rpZIYrvqAqeHFoYvWmU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB7323.namprd10.prod.outlook.com (2603:10b6:8:ec::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.26; Thu, 17 Oct 2024 18:36:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 18:36:46 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com>
 <2c232dc6-6a13-e34b-bdcc-691c966796d4@gentwo.org>
 <87frowr0fo.fsf@oracle.com>
 <a07fb08b-d9d0-c9cc-8e03-3857d0adffdf@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        Catalin Marinas
 <catalin.marinas@arm.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com,
        maobibo@loongson.cn, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <a07fb08b-d9d0-c9cc-8e03-3857d0adffdf@gentwo.org>
Date: Thu, 17 Oct 2024 11:36:45 -0700
Message-ID: <87zfn2o9tu.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ed3391a-a837-4e65-a06f-08dceedaa7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bTJlXQT2WSaGwtBRcB18Fmeyg72kHpbq0uzG204YR10cbW2KhiHbxwyBQEU8?=
 =?us-ascii?Q?HqwGquBznwfxDSCc2mawOSKu9+4YwPOGZorIHUpzK6oKBtthHZIr4EhbrHFp?=
 =?us-ascii?Q?Fj1D70OazQr1IDjwvWPoiPLR/b7S9Y7F0lkBW/fzlQUJbLHLZdoS6wKGyuEJ?=
 =?us-ascii?Q?8AhVZE4aMpTu/2fLY0eNm5/Q0TD+od7jLWJWHTc1iTZmBSK+2nk2RMG6IdwF?=
 =?us-ascii?Q?Fpmwtqmc5EXVXcQ/17Du9aqIHTUO/9OdzgjU8kE9ZsU6O+WMMWmlKswkF62R?=
 =?us-ascii?Q?sDlrs2x1sqnwuMvCqY8J/Qkd2lZm2rzhKbgkvA2Yxtbrl5dPBjR/7RJCadO/?=
 =?us-ascii?Q?QWY5mLu44Vs+x4qWhaZwqxMtSu2mzrQn7/oW4dMWDjd9UWdxxE70apW9FhlV?=
 =?us-ascii?Q?rJ6cDL/4dCxaCywhNUQx6jlpvMWVwTRx8FOVTQTu/a0SmGyXE8JkGTAJgW/e?=
 =?us-ascii?Q?BJqFYvwtEoiH8OgEEuQLXned01VW/ZiDz+shF8pW2sg4vOoyA+nPaGrT2PR9?=
 =?us-ascii?Q?6StRXarJcQdClOfAu/NlpnOvfqPWr6vU/ct1gCzRCmWZK4q6ClALMLdJ2F6G?=
 =?us-ascii?Q?4oDV4HeWEm7S+D8jVzgP5wl8Jb7teaXz7xO1cb8rqGESwzWb8esqUuhzIZGt?=
 =?us-ascii?Q?6j1MdelN0+wUlfEDSVOZ0EQ0ebnDzQ3paE6pFXdU5V2CtM8dwMuiP4HTLmuR?=
 =?us-ascii?Q?GzISKTAYgOo8StUE3e8+cYKsbBi7RogJ4aynACcY/WWrQP5+bop6YMmnp+tX?=
 =?us-ascii?Q?VohsTNk8HS/+NqBsKsu82qXuvet1WcBX2H8NCtHKLTeEdPL/e4m7j8x69dOT?=
 =?us-ascii?Q?V1I+VC4pDYCLl9hNLSGCkVBT+xka/kZekx2m07FO3wN9GaIch+USPpFjGxfh?=
 =?us-ascii?Q?h2tCpAAgFW5BQqwwvtkR5gPbqeocDgo0Ng5izdbWIOAymEY8PdBPZHWH10FK?=
 =?us-ascii?Q?S9ElZyHSCDDOofFAy0o/fygAqj3jZJu3fP+kJ/vVPzn6Ym892pUUAUIK5XD7?=
 =?us-ascii?Q?CBxq+SfrfRE/HbAgYfs4pXQ5jc1WkaPxhC9uPaen/x6j9tSvwykhiN8wF3EZ?=
 =?us-ascii?Q?kHdRzXOmVHNKGQjhQxeuvmtkQ51TblQ+T1pcdwBpDSPujEBZZ46L4/TMpJBw?=
 =?us-ascii?Q?xxiFTwuTBK3fAAln8vc9cyuB0dqe+fUa8HHR/Nzu2D8IegMCuWLfFVXj5Gax?=
 =?us-ascii?Q?fwAtVCiF3irNGbZPQbvd4w6KihsIC8tjeWL1eoHo3lnMjNtxETccuM6DnjV1?=
 =?us-ascii?Q?FrV8fiOz2S3AfjEKF2oWviY6mnFcXfTjiCx7vRckcIcBMtoM/EzFmZ+x8WFn?=
 =?us-ascii?Q?+/fKatZY9OqcNTK2/6yMCxaL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NsVrVQolV5Kh+UPSTwyWLbIB7wbERJ4nvJR6yo0esuzSvs06Mse9xkR+4MzK?=
 =?us-ascii?Q?yRenY7aYvWjsjt17UCSS9gH4Iuef2NIzzvRwbEKlc0Z/4yig/elVLyP3WZ3P?=
 =?us-ascii?Q?N+TGc7wlYB+IfMe57j2xqFJfyNaby6q6lq8zrWhoBYBsEML5EHjMykrAyr6a?=
 =?us-ascii?Q?hpBXo2bwf3DkMztEqvE9zEIEkr7ll8iuDQLisz20/igLCV6CJp51jlJ3jarz?=
 =?us-ascii?Q?cZFv8Qr3veEPrHs+SQt7lPfaN1FVX4H6hTloBr+OPmF9dt8DZ1Fraru3rVQE?=
 =?us-ascii?Q?lfJvCbZBnffWUvTx6zIRFJ1L9R2AUH1RyCXEWacb+j6qqwGT8NeJrKLM9WR/?=
 =?us-ascii?Q?k94y2k/dPRKe1oOnZbGb2kwRzsNTKLRe2JRGtJDgkcTcrLHF6Ok1PKMFmlpM?=
 =?us-ascii?Q?Jwl3tvkjzU3+gyLeptCz5EDIJBIf898/2CuAMwvgafyUyKXSykkZzawm3a8Y?=
 =?us-ascii?Q?eKKJbO7TPi6x8IClXvBJM75VMEfPPcQofBFkDpnxDtFNLyu5LO3tYqY+bW1D?=
 =?us-ascii?Q?03izqo/YBhooQ2zgRl6uHFjmaxWvFtSb6kn+UOsELPYc3zJ+DT6AKyQnrzqO?=
 =?us-ascii?Q?zB34HHWVJBsKfRmouI+ln4x3ozVKzKj84mkKa8IODOb6eX7fg++GMTMReHrL?=
 =?us-ascii?Q?mgf447I2WJeFg/c9piDqDWyoTlg4KID05f/BiQmTTLpzC0T6ISfg9W7o0iIt?=
 =?us-ascii?Q?sgSIIoTuKqsbD0cmXhn7UZoNd/C/3C92ME4iQ0JS6pqz/+CzfWCwcfoRyT7p?=
 =?us-ascii?Q?Z4alRtMWB9auuUYf7yESmds0xpeVMuRnOcc8u/5i1+YZHwGlEwpu5/1A7rfh?=
 =?us-ascii?Q?i1lxhRFC7ZcVr82EA3vp9/YfLgCM9juAlRzPpWrRSGvNrX4Pp99VADZIN9YU?=
 =?us-ascii?Q?F+g82yywBwt/4Gb87QimCPxRoBNiHcDmBexe0lXHK+7yyoD3mAfteT/sR/V6?=
 =?us-ascii?Q?LK1RBovbrMVr3rhtha9Cxn2O/lpxp482dgzMZQs0kvT6mOnG7bqYcyNokRhN?=
 =?us-ascii?Q?tV4y0SCA7vSM09D4wTt3Q6gq6ZhzTiBbOwa8oFFtxWf7VEhLNTQ6mPb4HVTL?=
 =?us-ascii?Q?xJpzAWee6z4AAVUZf4az7uYPOor3WPTCKZ5Y8U1XzquZqHaVMJR7fPfV4q3u?=
 =?us-ascii?Q?7Tj5zkGu1uE2EUNKWPC0OxgsEg8gHND0H/zK22sZIw2lnZztKYF1v2eOtfxa?=
 =?us-ascii?Q?BSdpojloPbViX2WelHfpu0++GP+IQUWgq+hAC2gMzTnj8EUfTNdPjN74Xr43?=
 =?us-ascii?Q?havj0V5bxxf1XRvqS7GfzenZavEOvjXRbVye4sdFmClkslGcK35Puddz5vru?=
 =?us-ascii?Q?gYg5FYh3Nb2MISrbzo4H+Ptd8kG9VJ58blwj1rbhzNfIHtIiaFGBCGLXkrfz?=
 =?us-ascii?Q?SaClz1JKhfrBj0dps3VIbloz8FK0s2VdCC2QVXXZV0aRL1Vn/6ErrOqazNWI?=
 =?us-ascii?Q?cKOiusXO356kXX1eQftwAYGfHqY6GGAcc7m0aYm5Ryf+c+pWiOcx1/jowT/F?=
 =?us-ascii?Q?YfGrXQX9wR3TxsYoNQDumAlOXCfKuDeGX4B+AQNcdHIYN2v/OuLu4Iix29TO?=
 =?us-ascii?Q?TLSMnKgT72Co0RtgVWmVV1Y39tOJICVIu3r5Gz/H?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IlsDOfvRWJipysdp3sRqgso84o8Rb9/boos+V3YWkbjV5F1hVdXh0Vejyg94tt0BEwulQ+OAWjSZH/QccH4+l6sUffWebhwJMksI91uZ+AmTnQwJpYNF5ddQMMNsddsFHK645pgcTk6wL1xLMVlB2eb+zoZ1n59LrXMsSNsXxI/5YDJhuuQ5V2NBal5vfHANDwuMr328syf1FxiWD+zrqi307Oxi7UcNfMUQ8Vs+kWzPXu5cz+nbby9cjN16qWmxPDPaw8OhGPi4b7eUEcAIkv+ZsUT4RVFwE7O7PqJf+4JJpoHH3aCI3rtNv8+QnTQv1BxKQurTVWrHK/CqIUblw4KVTPIiY2IGWwff83p8Z0aTtBHfwEL/pbMAxOSMzcr+R0/nJ9FeGonFTLePGbWefFkojjtrPImVg8TdAIrRnQndI4rlZbdZLxy2bwFWHGzi0yat1P1buVgFbzsb0/h8LFLQ5Ej4lUMCjKSRw7V4mcRAXHJWw3O21wFM3hU+qrWMouuZDlucBPx9SDCy4KMknrUKIZFNFKO2lL9xGT5mGuaEJ2Slot+DS+TBSF4ARDO0iF9wp5FCXvsMynFpEuYcLBM4Uur52RBvS1sRiFjDXNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed3391a-a837-4e65-a06f-08dceedaa7d0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 18:36:46.6824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZcnWOI+dOtiJpsyUNrpm2hV9eSnEIHqYA40fZOuyyfG1oYD8N6sYVovqcg7u4i+Tf3ICiywSIZc7hGNgmtlcG11+UncrMTG3gX7BQS/m8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_21,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410170126
X-Proofpoint-GUID: UvNgXcL609wtTSNPwP2xmtS7fWneHPCe
X-Proofpoint-ORIG-GUID: UvNgXcL609wtTSNPwP2xmtS7fWneHPCe


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Wed, 16 Oct 2024, Ankur Arora wrote:
>
>> > The other core will wake our core up by sending an IPI. The IPI will
>> > invoke a scheduler function on our core and the WFE will continue.
>>
>> Why? The target core is not sleeping. It is *polling* on a memory
>> address (on arm64, via LDXR; WFE). Ergo an IPI is not needed to tell
>> it that a need-resched bit is set.
>
> The IPI is sent to interrupt the process that is not sleeping. This is
> done so the busy processor can reschedule the currently running process
> and respond to the event.

The scheduler treats idle specially (if the architecture defines
TIF_POLLING_NRFLAG). There's also the sched_wake_idle_without_ipi
tracepoint for this path.

$ sudo perf stat -e sched:sched_wake_idle_without_ipi perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 5.173 [sec]

       5.173613 usecs/op
         193288 ops/sec

 Performance counter stats for 'perf bench sched pipe':

         1,992,368      sched:sched_wake_idle_without_ipi

       5.178976487 seconds time elapsed

       0.396076000 seconds user
       6.999566000 seconds sys

--
ankur

