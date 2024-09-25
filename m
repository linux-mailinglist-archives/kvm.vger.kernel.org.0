Return-Path: <kvm+bounces-27513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBCB986998
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6BE11F2812B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CED1AC8B4;
	Wed, 25 Sep 2024 23:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aN2LZRlr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ksj+ivEI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F41AB6F9;
	Wed, 25 Sep 2024 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306739; cv=fail; b=E013leDilG/L5V9JtX6WDACaxY0tqGUgsfUbwAp3etkh1tgeS/YrJTCHrhrqRceEmBVmlGhmgytrIaCTdtGAqelZhc4Pcges0QjDENDfDW/WqcVBmqG1ZmjBCzeHXgByZEjRbGW26VMI1RHYXrr8y4Bv14K2teKQHCKKycbhxI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306739; c=relaxed/simple;
	bh=aTzaefCaEwR2s1g5HPtSie4lM54qCmuKdheqjxyIIbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BTX6nBZyefL4iNch53Vmoak+NfIxH/lz86vTiq9kxJ7THNQJWCT3L/fP0QiKx0IN1X75TVIxK3qITjBA5TfmwdtR0t/WIDVbCXSlNFR4H56+PO0oc687uT80IX5oCuzfu78FNmom9VEOglKAP3ioCIEK7ELvFQTD3mRT+cZPXGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aN2LZRlr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ksj+ivEI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnJkk017210;
	Wed, 25 Sep 2024 23:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=7reVVYElkOeJMuk4+zxOqkcajfgv/vNj5UiDIAk/8OI=; b=
	aN2LZRlrbW3sl6ntvKZjFfRpT57GwUhOJnJQFsdgjXDG4NZnl423DNp9PpJ7/5wX
	2AfgIcA37ecun79G8BHQYbfeERigRi8jw9ZdZO3LL/ylIvcaZu0X22h3NikhVksc
	BV8KoSUy3QMX70lf8gJvuZqCml3kMBTXpD8gqhMTrNF90FxlRoMAjFb+G7aGp3wi
	/fVJuY24Y3UigBrxyiKtWcWcY6RnbYFolK2QnUaLOKBLhmBa/Uy1pSl7U17cx+I4
	gHB61CFVfWHoFUOaHsMc8TWVTsgTXkXF8G0li/vtZea4nU9t4eaBQzAtm79fX2Wn
	RyJiahKVGTYoxBxjOOMF+w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smx39a3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLtpo1032872;
	Wed, 25 Sep 2024 23:24:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkhnpn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSLYMTAHq4iKbg3mKq2TNtUBX1/ISI5mEGpKBnTPGAj+XLq7rvD73xQRaF3nQTY3S+wyYsYC0bnE8gappkeGUpL3Ph8Dfr21Sm/LcJxfXzq7jXeZLjnXDB+ynIbwoBH/RVBcg4FXgF6GShkiX6wWwV7Q5/5QXi57JFWrtIPyaM9jMAjXE1DpYLARM0WxmliDpe55IWcRKI4PSPgnDgEw+PSn9Px9JHnVuLQ/YV4yjr6HhtVqXFz8WbzBZpw152vjA2rG/+7TOEhr0rIAMIWhs/AL60FPl+HzEqeVNvJTbv675l1Hk5unJLCMei+mqxFbP69pe60kWsStiNTDsKd4fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7reVVYElkOeJMuk4+zxOqkcajfgv/vNj5UiDIAk/8OI=;
 b=YjspQ5PW9YYM6vEKKC8L0l8cwu884JEgLof+m64tZ1IqrhoI72EhwoGxYL8wxYtmsjzZtQbKE1Bgo/UTnE9e9N9I2B37/qEK9/WXFka88LT350m1SoJ+PB5DsN42qJ9LRH2ez2YilPrA2ErzDQwaKEuYhKtfKJIN1/RugwtYdyQnmRl3H2tkPfCDIKgLqroR6+11oz10FGhKyQ/7sPcujQ/oe0T18eDJxF9Uwud48NHXP3pKpEcNn8rlQ/qWw2L9W6sLuLm0yTGR4d+IPh7wH3G0GaUXeGivlM1N7u0H3ALtnNlraUmrxN1pyX25U8bqDApvyv1BpJ6E7D/oOc6ZdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7reVVYElkOeJMuk4+zxOqkcajfgv/vNj5UiDIAk/8OI=;
 b=Ksj+ivEIS95YZEs4oEeX387FWRd2xK2D31CZxDPPNJJP0xw9SFtQvpeYzhLB05RfE7Uz2WRTZkD0YR+OWXzli6INuZpiFBQxreNSun158C71ZHTIAB8Dj9IRIUcMUPjXCKVNBkFnP7/kMKNImoiHL3kUcfOE3upik/rCm3BwHp0=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB4509.namprd10.prod.outlook.com (2603:10b6:a03:2d9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.12; Wed, 25 Sep 2024 23:24:52 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:52 +0000
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
Subject: [PATCH v8 09/11] arm64: select ARCH_HAS_OPTIMIZED_POLL
Date: Wed, 25 Sep 2024 16:24:23 -0700
Message-Id: <20240925232425.2763385-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:907:1::29) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: e26a4a50-c7a7-46fa-1534-08dcddb941d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B7Mm+mw4DyVYzzflFIxKeRVkmoiq7tZ6PMnROO12nk/PP+PuZfUkP3XaUFVp?=
 =?us-ascii?Q?cqSGJFS/UTBQ9BZFAsuXr7hp1nIng+mxVNvEw+JRkjyV9fG9v3IklgZiGuB2?=
 =?us-ascii?Q?rVd+aOrTnXQjC9BAlXfByI+WYr87lK9UHIWrczNzqXef8bGo8YLB6UtA0qyD?=
 =?us-ascii?Q?Octqvjr6xAUEvk83zRQVZzkUkqwW2bezuO1lmlpMqxqA9C+aaCjMctm7PeAz?=
 =?us-ascii?Q?DrDFvYbMTQV3GGlaG65Nc+1bp5XAoCYeHyEbUoIauZJbONUUgGlHpY8IrXEO?=
 =?us-ascii?Q?8VHqVoZEYT65K/mOy+DHlmV6JKqlmlcnTzqu7WoqFIQWI+PKC7Vo1h8MhniM?=
 =?us-ascii?Q?95cAGcQHztLyioCrxxjocGcoCgXofeW/FgWYZR6aiDldYfMPj/GBzUw2EqGL?=
 =?us-ascii?Q?/1ip2D2BqOqqVYLndg23GIFpbS0TQGLz1O+dqQ1Xf+upJnjotiu8SWfKvYGK?=
 =?us-ascii?Q?1xZOsCkQvtFG3s4nEgfKaL/yZfVulHmc06RSlp14g10xU8lCPW5OJli9p8dZ?=
 =?us-ascii?Q?XCs5rWSHnw6A2R6t+Y3J2ym+dIx+mGCRzzJV+Tg00Pyy8MEE1JpgJ1lLGYak?=
 =?us-ascii?Q?abiKQmeqMiYXBsu5Jz4p72tzT9d8HN1U/bdEyhOkDgcCrlUIgbgNtSQ78vBw?=
 =?us-ascii?Q?O2rsHIUpzWfIpMsaDGJkRzs944WScT4OiPAnmXvxh10ixm3xgkdo+o7FQTBl?=
 =?us-ascii?Q?UIPMjdmzFTkKyMtNLzt45ymhjuGIyi7zYufQQaoIyQ0+lbjG0m8XfBwCuF6f?=
 =?us-ascii?Q?mFCbXYts2Yf9sW2jcR4iiFNR1JOy4w6hVmVG5ZSPLCmIgMjp7BSJfag0qOuB?=
 =?us-ascii?Q?OivHTnMNSZcbkfzOmpEA7MBXEohXsXHfHN/IpOJiAjuljMylaM3daGCCKnbl?=
 =?us-ascii?Q?4XKF7EBr5TY7g1+WpRp1CuQOIQBHLWBo1cCndanB5t0KqywQ+7BjP3FUimm7?=
 =?us-ascii?Q?9+hzuGGcLvdVcnLkNm53pZCubTZakaOv0gYFzMQVNIprrUtekQ5siKt0e3dD?=
 =?us-ascii?Q?HVFpjdgv2c3i77u5a4rwc77Fz1ZCigsJvei8TwOxAwAo+1DuT5Z2XYG523+S?=
 =?us-ascii?Q?dq0fztYdwzAPfXQ8YRpndurth/zFlMmaTmMmKW7wCCi31rljsMKQkkhic0cj?=
 =?us-ascii?Q?d7LRiQSwZZeUT3mj17vk7HUhWUGJieKYDgrvioc4EePZNaNthtRgWPYV06H7?=
 =?us-ascii?Q?DQLSOusSr0AL2DJHt2hUKgMtQYqZxMmnEsuvAgnorE/Tay/tAWUz379SxqP/?=
 =?us-ascii?Q?RWIsPlLhTg9VTsqT1JGM3xeNLZ/GQP//mOUWjhbC6wIwQ9jY/WYUuCR3fvtb?=
 =?us-ascii?Q?uwGI2SVEYuQ1m0O9+64Pcxbf5XUq14dGAxNFMnXozZRl0w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JQ6myRvqeV3pmEFw31QBpBemR4C7mucM4WMNMBAEmY0TpJHn5O6o3pc0GF04?=
 =?us-ascii?Q?pQmKjmJFMia0sQWS9ySJpAo3qLmRQUZ5rL5o0Ox45CJ7LMHJHM7n4qkJpDGs?=
 =?us-ascii?Q?2YZj58R+iSHqUzH2aYk+zMe1RG5f0IrRwkY57ivVYn7j//P95QbWYMIEDJoJ?=
 =?us-ascii?Q?YrZWPTmN4nY28eTJXKRFbRyovdmFGLNM7ci+xNQwMAIzDeIwXUG2szErdpe1?=
 =?us-ascii?Q?0/rmSIIqfaQKKR0a7FIHwyZjzfhOD4BHVDw0k/7riHa3Tw44P6UOQzCf+yi6?=
 =?us-ascii?Q?ZF1P/vIOokuLgQdXrFmPcmtCWRRZEXkH2yR0PfkX2+gxPlf3tTjSMGKci7l1?=
 =?us-ascii?Q?2haCkWO/xYCXQ5/yZs9Pj32SYrVP8Y9WMV9/52S+/QS3NDWSZIy2aPMYvRN/?=
 =?us-ascii?Q?KKWOy3b39pboczh/9SSpIpvlbsQ5rIoxviz9rFeQheACijviUGE6Q+ye5q8C?=
 =?us-ascii?Q?utmKVIixo0kLn4u4/QGAmwPNaYhH1PDO6+Oc8LILoUtVevGCqDwj1StBv1rN?=
 =?us-ascii?Q?BPrC2Toxu8uW+PFuLi7Cf2YhknXCs8GByZVI2OC6VF1WOerLBU+YwS6sT4G6?=
 =?us-ascii?Q?ipa3oL49yI0kPH8GXDIhlDNbUKrSUSESmVsNDNIadHUyTyxrTH/R3TJR0H2r?=
 =?us-ascii?Q?3zdtpx+ByRg03aTr6rlEoiXJDRqfFFfdFE/Am25Q09esspgvHkTTjrV1HD9Y?=
 =?us-ascii?Q?mMA51Bxtu7AIHrTNi7ctfMPljxNYjy5zuuGlTThYjAVrXFnZvssm+KB2DF/A?=
 =?us-ascii?Q?w5yEShwOkxf+J5zmQvGheKmdnco6mwM2jcP/ub2rIAbO+3B2I8m4A/u7THOT?=
 =?us-ascii?Q?7+pCMTZd89Oi3KWC82HxlE67XLSZBdamzD1/CcVAcbq6u9w0L5OJH4d9k8MB?=
 =?us-ascii?Q?Z3fjEbYSpWvEwtZUYAkKFeSzJVNs679BhAaGCTJncSj3sTFkqW1VGX+F+smb?=
 =?us-ascii?Q?Y4Tf3dDG3x8BrAqNxwoN0lCaVCxT8njGB1kQB8Pd/TFYbSlXSKM0beDzykOq?=
 =?us-ascii?Q?6Q9DCSLrEZW2OwH/B66qFrWyJMKXoRtHCU/oAySU4oki25KKmK1lU1YlgV+K?=
 =?us-ascii?Q?urCK+M+470Hp18s2I+Ta7EDsowXUN898oKX30XLedK/LkMVzB1cNR7ivWYUU?=
 =?us-ascii?Q?g9F5aLwJw+wsppJDxa44V2C7N/YbFWVMjdaoXs2xE2rKMTTfM1Ko+5WEEphk?=
 =?us-ascii?Q?pyYqPDsJnuEhq9Uh4zLkfiMVlQ7cqjnTuvo2WFrXMmEQbHZOTWHBsFdJG+8C?=
 =?us-ascii?Q?RvEyOb2S1rg+/nkJS7ByGi6wiy9KKA6OwiwEhU06sGLtFtG6kNHm4II7dJZ5?=
 =?us-ascii?Q?TRuFif+VjeuyAhsjTJUKxXGHKNrPFHM+fnx6o2fiyNzdrFGyb/WpWVblAN5X?=
 =?us-ascii?Q?aGQYGmvSDoYY9k29IAFR5tVMUZmouEcPazcn213y0HGqoPnko8MnhvsXM1ut?=
 =?us-ascii?Q?/ihocJ927fnez3aGj6UFyeb3k0y0SJ8rX5BV42jDIYRY4eJ5MRpHhIP5E9xm?=
 =?us-ascii?Q?kJpvz7imgk5GEOuhXU3Dx3SmMI78xj/bk1g4LmPikWz3gWYYDtpRDHuBpwp2?=
 =?us-ascii?Q?Vmvi3QPkR3SydiSQSLvtX5vQacBgh9lVpkNhS+kAoeSiuQU4VedQXkDJVxIV?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ldZszEmG3kEgXcaVe2dSAFaiX901xFJ8Xz+DPyntRWROJP7f3EkYTH0wEs8/TIZlBNToksAyNkif5IWQrUtAtt0fGDaTBszKuGb1CNtkSmuGUX2ZAqv5L0Hdi3JxzGnYn37woLzkFsuM5/KT+P1PSpK8bXMhZwRc1Ne7b79x6J05KYDzYkmFKZqyuutL3Pq7A8l0g6CSIMISGf+K2BWMgq5krjPCegvSjzEurCl98q1VrC0hnvbkR3NQBJLfoptSMMoWxSCQ50yAdIO8ehlJmGrAlHmyOBledjHS3AH7kxWjmBf4RXqZC9chWzKIowcV+AHC7WCpfyXrCD95EWoHNKtxH9CTFL3Ycbs+Zpo4O1AcM1jUixG3Hyd5rDvfRG4CGq0MiOF9AVLrsL/cKI2wWsYL+eJt/KOG70nzI99kV7H6Y63umc2kXFJ+Ef/B1lJakYY3qdcMsfcfZbE+C8EWJrJlw1nzX6aDbkFG0vjner+QPZAS4vfoh9k5FjdkZiOtPJr9tXm8Ek94h0sBq0ezrpnS3BJhHzk1RTlJR2NVQLj8gifjLFQVkaYhzS9zMO/PJ6n+WJwwYi6Bo6ZotVVe8SdsjICNjOh9uDjLXZUiZ1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26a4a50-c7a7-46fa-1534-08dcddb941d2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:52.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+4W21BKh2WhND4GodIp7XZY6YMDA2BZIzAeESKckSY4XSv+lnx9srKBHuafYSqkrZwgEIl42UG6Lvp7YgORD/LUjmpnIoZlQLS/CpXIDD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: oDsw8ZuX9-QiuxtaiMoIGFAu85NBms4X
X-Proofpoint-GUID: oDsw8ZuX9-QiuxtaiMoIGFAu85NBms4X

poll_idle() uses smp_cond_load*() as its polling mechanism.
arm64 supports an optimized version of this via LDXR, WFE, with
LDXR loading a memory region in exclusive state and the WFE
waiting for any stores to it.

Select ARCH_HAS_OPTIMIZED_POLL so poll_idle() can be used.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 49f054dcd4de..ef9c22c3cff2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -38,6 +38,7 @@ config ARM64
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
-- 
2.43.5


