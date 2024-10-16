Return-Path: <kvm+bounces-28973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A559A0222
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 09:08:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 114191F26185
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 07:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06551B0F0A;
	Wed, 16 Oct 2024 07:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fdZ5Nu2y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IJQu3GfA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71536187850;
	Wed, 16 Oct 2024 07:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729062488; cv=fail; b=uz1D8YhNvMlejLJ1bKuVzBRipKJJ9lBKv/E44maN3sWgYJwfErtGbbFNon+ZHyy7X/8/ATVnn363ItYS8rqt+cVmX0uVV9U75XOotsPputcQDG2jIVXXIdr6mFjQv6DrFIsO5c7KZ038kdrmgQaO0KFJMWGJC8iosy3YbcNC5Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729062488; c=relaxed/simple;
	bh=rG7NRGFMpeyEaPqPtS3Lg9JWt+BIrjy7Bg5GvbVoUv8=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=QUbxRM8gSXgXfl+GpdELJfH0v4bLve3/L/bqNMzvHIE7DcT7XWIpcNqBOIoVxBFtl1VjuB0KpqZb8FBcYfDlHhW/pL0FlrkNSrzZIxbDuoUb6GR5Ua9JKc/f51zytN6SI9Xe1Y75WQ5e0i7iKDJ4/WQpDU6bKrng6l5eo8yWhJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fdZ5Nu2y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IJQu3GfA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2MbYE016582;
	Wed, 16 Oct 2024 07:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=cDGcrALv/BfhFgpH51
	EUh+UMW8HEQca38hbD7gmnK68=; b=fdZ5Nu2yD6uJ1wsNsWvEU3jZ1mK3a+tB8t
	GnpZo5L9w0jHyNmgUBF0f7UkNQ8Uerks3plnlfOii31mwQTWVhUJTjIsLnzNektP
	DBuJm1i6RJ11Ee54sXe2k32HeP8skaVzRWJhJ22sRE1xNBDcK4x16Dd2TWg5GsCL
	S24NfQCuyqnzJXE51QppWyDmfXFiUq0aIA4yVL2CsBs4QLFUvwrQJMvY9Dm/YVV6
	XFk0rw5m5KSrp6ckq+A5BQb122kslbdDWOO3CtXhyLbSMUIeh/Rljx/EgOoX2xQu
	WkE7nL9DSHlbebj/gQtJFXY7LsKzQQJQUrGk/Dn0OdbR8E/SOGag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5ckbs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 07:07:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G6F9xu013886;
	Wed, 16 Oct 2024 07:07:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj8ebku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 07:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWvF2Pkj8DBXVha9KeICXz1HJ85Ai5qRrqMIlNucK0EHB6dPZAQ8wjfrXQBZB4d8o3tbWIwbpNm7RFkOnoQbUG8Y1QlMhxid1iyVCxj1BmK4MkYVxjn7itUg0kgkL9drq3TvfP3C0v4WImElPUmktgQ1P+JWIfLj4pDwFTMpCkI2yMGYEeDwl8FjjRWOjOT6V1GhFECXbLBlrvqbgTieudyDAjE+NX4XQNm2OiwNmmE2f12nSt2oN3NGf/poEJay3DqZAY/kKgsl+T6za6pT6+3v+y1vPpGguUwbXWLQ2GS9CH9wcCJXk1wsoJwWwFemJ6x5jNBbZI7J8nJd1l9nMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDGcrALv/BfhFgpH51EUh+UMW8HEQca38hbD7gmnK68=;
 b=c/FUPtRcww1Gb1abcFjALfNBLg8zuW3Dh2GqHO6sbji4NTL3fXZ8LAcVbjkFUQ/bRA0awq9+2HAK+1XcTTShXEq0zA+k5SYHBm6+IpnBVYB6s9DKekMKBybKvMnZZcp3mqW+56XncAwtBKXGAKhKTCD3uMfG5oDoji7arlkFl2tAYC0ghkYGcVMXM5/jZHHRE4mhb7bO6MCbzbDXay+b0KR6wNZqG4XIGqi9w/9/UXsBwaaIOuT1e/KqwBVQHh5PvlSP41qLnBi2t0tfZhFR8a7Cpz+W2+NDmSliWaSydIKP0+WKtgYFpDTyZABkCw6YClLZl1XVWPvgT9LP1Z7A5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDGcrALv/BfhFgpH51EUh+UMW8HEQca38hbD7gmnK68=;
 b=IJQu3GfAfhStk2JmwYaon9E28ZVkcWsYRffKwsEv3HJhzk2a6lGwlIY2l5Lip9Aa2hXGSSfMevdqWUYdcteuvGYV5ApychIYTHjEeqIZjQiVky8hD4q04zamecKL5LdE20/RnPIetidKX+b0awtngi5jdIUYgLHhBqFLn8lBDjY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MN6PR10MB7491.namprd10.prod.outlook.com (2603:10b6:208:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 07:06:59 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 07:06:59 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com>
 <2c232dc6-6a13-e34b-bdcc-691c966796d4@gentwo.org>
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
In-reply-to: <2c232dc6-6a13-e34b-bdcc-691c966796d4@gentwo.org>
Date: Wed, 16 Oct 2024 00:06:51 -0700
Message-ID: <87frowr0fo.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0855.namprd03.prod.outlook.com
 (2603:10b6:408:13d::20) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MN6PR10MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ccde9b-129a-43fa-28a3-08dcedb11da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M7p8Uh1cdfCs2uuUjXR++WWj8zdIzZHyFNEJxNhzwcZIimbv9FStpQNuWMWL?=
 =?us-ascii?Q?ZRt1SNFp0acVzQbwosvp/GoLukBFtQJpfkGZA9DxDS/CXsmDX+g8Yj+0TDZr?=
 =?us-ascii?Q?z/BsjCSIb7Ik3ZOKYydh4W5tjDiMwzl3i0no7Z4EpKr4A82lBBG4Zrj4m2x9?=
 =?us-ascii?Q?vwOuA0EonLfBJmk8u9SBkP59B8uASJDW2Wn5egxvPHOHaJPxthcOKz5kKgit?=
 =?us-ascii?Q?rWIH0pp5Lrm71LysXqcmsiLP9bx9DBDV5NqFWuf/Otn0ubdJDauEChGEleiI?=
 =?us-ascii?Q?lWnT9C8BtDgFhRtcsHIUY+Fg1QezA+7NbLem9qfokv43EwMSC3woHqaNdwdF?=
 =?us-ascii?Q?UEn+YLDDV+6k5ZvcCG/dJm/sw//8+rUQolYRdnyAupEk1b+ijgxj4NIwWm9W?=
 =?us-ascii?Q?CxCim+90m92dVQhEXX1lZ0grOQ6NYtPaWlaHF3Dcw3NYwGNT6HxqV+Mz8rnL?=
 =?us-ascii?Q?PgmPDWIWQ00+db6gljUC8aX+drjoRrNiRUn1iTRlcKydzLkUgPTUnwZ5jh46?=
 =?us-ascii?Q?AanhR27M8ld1I8aF+hTai8xsGt8K4FFRMI9H/4T2sy4YyIlZt+dxhmUqyW4c?=
 =?us-ascii?Q?B6sE/t7vc4Q0TfRzqslm0jMfGtcL76rEEjM3QC5VFO7ZQ92y57NwdbhqVN6E?=
 =?us-ascii?Q?jfK8QBZSKAlCIxhoi9AaIk3pgPcMvvGu2pYx5OlvLC5iVxjELX6pCclhOSce?=
 =?us-ascii?Q?6BOXprwAKkkfIeYizdnMAtR72l5kR6n/Ofxlyu+krnn6mTXwm8UR8Cbo0ue9?=
 =?us-ascii?Q?9YQblGmuQFdgLPGhRs9iMTytf1gCgz6P5Q98JuUO17TPv16GLpGxeenqrbKg?=
 =?us-ascii?Q?HlFkuk9OQ+QUdDglM4UonV/U0kfgu8S4l4EPPY0KX4UdHKihZh9wtO8Xacgp?=
 =?us-ascii?Q?edj4L/wyygJ6uDhFek79qROQoD/UZ6etMppEQrmuVolWn5M/LA2QB0sK239r?=
 =?us-ascii?Q?JdK+8UKmwJB2bY2L07Wcgo5AkV1Kye3nEqwC2uH0wIVrH3Kg2ubyjNfAJgLe?=
 =?us-ascii?Q?u8YlSFKTYSLQKggfHspyHSLWPo4rQGeY+LSis/AKWE1txPOK9UqF0mvnxKsU?=
 =?us-ascii?Q?ZzScM8fqMt3OoFzhomoayDMmaWUs5gw6lB+n5/QP5l3k3kBwXRk/MqrF1pdD?=
 =?us-ascii?Q?dYEvaRHl7W7zFDMDzARKnIsXjQH8PGMQUym30H9HQ2c8rRsH7vvquBwfc0yz?=
 =?us-ascii?Q?eVLKbNIFNi9qVKB62P+DoypCGAhnv7EZeyOXJey15yuNGEij1HtmXNIrPicv?=
 =?us-ascii?Q?HolwWqt/+EnmwZpMHlGKsA5FlVn3GX6nb3gUkV0EXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uWLrc+W1mW+AqUm3ZWZPrNjKSasmXa+t4bRAJXMrc3xhEfEu1kNYTlUTj3zm?=
 =?us-ascii?Q?nK7VGaM8kVfjBri+APbcYgIC2XXJeHfXIG0EPYNU5yoNT5PX700txpUhQ/sY?=
 =?us-ascii?Q?mufjsM9tcSUB4aCRBoJmEWvojbDKCGNtk8mMnX2KsJNOWnIZdouB2BX4RwKz?=
 =?us-ascii?Q?3/jeRJDzUNTYfdRX+JBfamu4Zzrf0gabtoPpYy4BIxcZJCf6yKZnMBcwPwDw?=
 =?us-ascii?Q?X1VKMmY1uyyZzFJDqzXzMwVwFvWpfDYNhhrvmg70JBb7LuIj7O9UWPJNb4ru?=
 =?us-ascii?Q?8BWHsQbiin7aPFRoMFXjIuV57qx+CJ/LHeSiuBViclI6Va5rCz9bHylGCYv4?=
 =?us-ascii?Q?ocfI5kVBvdo2hvxX4RWdFIBHojywwdkixi6vi3uLTSPTsAsZ8X4DVPpqsXcL?=
 =?us-ascii?Q?wbVXz5B5PeQvNt7JzW94UNyGCVkibcN5ffONlq6WJkWg9f4gX+u6KP9ny18h?=
 =?us-ascii?Q?hV99xti5ddgyoEKdaRQa4R9xWMoIMs/k3dChRVTBdLJuXKJPWulcr3tziXGo?=
 =?us-ascii?Q?4zF8thhXjGOhzeREk7sjQ1/C75to0Wwa4ix/QyB2wvzfCM0owHygnjKPKRdP?=
 =?us-ascii?Q?AAzgeimPp+iq4kdxPoBxV1QU9KMyMssVN2j9g1L2QxbfGaXPFQ8rvr6tn0A6?=
 =?us-ascii?Q?WUZr+8BcQQKoRVaiBC1mats/RDmPRWAsVvOipKnCaRHxipfVZOfRbNBP17kA?=
 =?us-ascii?Q?4bi609RNaNUj/UsdhDRgDKPjhOCFdHJAn26C8EA2Li2X7mIE4juJh2b/8E7y?=
 =?us-ascii?Q?7X1lyox12Ks9gFVI6POL0uTfs0Kt26ODn+Zf/bZINVrI2Ta8bftj5yX7Z7tU?=
 =?us-ascii?Q?F1KSZf9cKkKtzFDcx9U0ia5/7IoKOv9KPNbt6wZFakUK/ejAcvaXiHkOD9b0?=
 =?us-ascii?Q?DKsMG6ya1rPXj48iGtwB2WC0GU79XK9IwjkKyorS5YNCVmkDJOB2oSlnHy49?=
 =?us-ascii?Q?dG1/Chlhv5mOQ08hKSiTHvhCa90pJJqJo3AfbWOWYWVHBQhp1UvSVyEoWwn8?=
 =?us-ascii?Q?XhSczoTnkVd33MdN1SBV28rT5Lpvc1oKfM+gq+IBOwWbZTysW45lel4eanGz?=
 =?us-ascii?Q?PglvNePR3grtNcnEdIKtOi6Hz85Lja+r8k1nceZVf4sn0KzIJowX7sUKm/fa?=
 =?us-ascii?Q?9QMmcG87pUbK594rNNNaiypmVX7PeiRg3E3XCsd0n66WmwwracZ1hOps19qz?=
 =?us-ascii?Q?5Hg033PhUyGJToUb3aWPZ1Z36Fjli+VGX8Q7u4kKk/2C1ejnWTKECS1n/Rps?=
 =?us-ascii?Q?N9gnufR4Vc6nyyc0S/fMxSqxqKx0hD9CEIK3pn+KzFa/gqcdG29tSeD9bXaE?=
 =?us-ascii?Q?RKVm0doOFYUJKL06p6nmQV/qs+NwQDJ55kuassqyB9TVepGRp5Yzs6oQQJ+3?=
 =?us-ascii?Q?JLYZ1CUCUNnFhqXW3A0c2tDf0ZDXMV2NacdlajbP7SF03DTi34qAd9nPJLih?=
 =?us-ascii?Q?z4NDe0yyT/+k4hRxQUyTce06wVMz2s/Se6emQ13KBi/GRaMxPHnIjRgUypIV?=
 =?us-ascii?Q?bnIe2m6ocuJVC8zqH2NN59R25fQDMsAdDiEDKj59sZvEdL4abkZ1UeAMv6Tf?=
 =?us-ascii?Q?mGRdDaV0Veb9E9IXUPAqELu23g8inJaM9uX4yy8yDZNLqZuDvtkGUduqAAsD?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U/I3if3ZQ6bGdVcIY4ZD3tvtW1GiFQDK8mPfoz2LjHr0tloiflBcL4RQ+H4fWvvNvibNM0tiuGSYorW8RlXZ3spQL25gBa9/PG4pn53g2GwyS1B4XxGruPMIjFm7phAC0g5HAzUXp7DRFwJiB4qMJFzVWg3FJrCpM85k3shRsQkBl4XFGI8BfNHC1iZS/i+JE5ced0YNlK0Oa+SgzBkK/M+5x8fCFHVXsHH5LV+cRfSd7HsMfnSW2uUCAI97lz/PKdcbuRkHBFuY5GZ9aGMt839CjE8kOimHqwDt/a904J2uYZ0f/QvBM4clm+c6D0R5fSqFmJjOvA7vjwoBF56jE8EoD1Opcu+XS0LKWwrw4BHpMkksJ3ls3tIEHTlIiVfxPg7x76I2OXnpYFmsetBg+Zcy11S7Y6SdJmgHT5l37RTEk0fmx8TPzsxNzzbr82XHdDARlQlA6bfTNT9F/c3XJR7uGhOXve3C0neJDJ0a/Hi9RcXIzi9rqvvgGjFqc9Q9qFEz/iOkg6pLyvezJnkiRIALHILN1be5Ojs0ilMPX+jB0S+WueaFN+1Go8vRTEmg/hZddlktw4tAIXGaklVWEef1i2+eW/xETD8LweIV9lw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ccde9b-129a-43fa-28a3-08dcedb11da0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 07:06:58.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pe/L0tXGq3wMqho13TOCb8ie/KlBMcj+H3UUjUB67PzyvbQcx1WCJQrQtjVcTPwUuN7ZdCMT/vU7ZgDHkoAoXQokwuiLMqzNXkrqPKXIoWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_05,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=839 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160045
X-Proofpoint-ORIG-GUID: LzTR-__4OO2eh16zTiDT7f0aOyRU-zOG
X-Proofpoint-GUID: LzTR-__4OO2eh16zTiDT7f0aOyRU-zOG


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Tue, 15 Oct 2024, Ankur Arora wrote:
>
>> > Alternatively, if we get an IPI anyway, we can avoid smp_cond_load() and
>> > rely on need_resched() and some new delay/cpu_relax() API that waits for
>> > a timeout or an IPI, whichever comes first. E.g. cpu_relax_timeout()
>> > which on arm64 it's just a simplified version of __delay() without the
>> > 'while' loops.
>>
>> AFAICT when polling (which we are since poll_idle() calls
>> current_set_polling_and_test()), the scheduler will elide the IPI
>> by remotely setting the need-resched bit via set_nr_if_polling().
>
> The scheduler runs on multiple cores. The core on which we are
> running this code puts the core into a wait state so the scheduler does
> not run on this core at all during the wait period.

Yes.

> The other cores may run scheduler functions and set the need_resched bit
> for the core where we are currently waiting.

Yes.

> The other core will wake our core up by sending an IPI. The IPI will
> invoke a scheduler function on our core and the WFE will continue.

Why? The target core is not sleeping. It is *polling* on a memory
address (on arm64, via LDXR; WFE). Ergo an IPI is not needed to tell
it that a need-resched bit is set.

>> Once we stop polling then the scheduler should take the IPI path
>> because call_function_single_prep_ipi() will fail.
>
> The IPI stops the polling. IPI is an interrupt.

Yes an IPI is an interrupt. And, since the target is polling there's
no need for an interrupt to inform it that a memory address on which
it is polling has changed.

resched_curr() is a good example. It only sends the resched IPI if the
target is not polling.

resched_curr() {
         ...
        if (set_nr_and_not_polling(curr))
                smp_send_reschedule(cpu);
        else
                trace_sched_wake_idle_without_ipi(cpu);
}

--
ankur

