Return-Path: <kvm+bounces-26214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C629730C6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B8D61C23E70
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D15818C02E;
	Tue, 10 Sep 2024 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMFbuPYM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MDEi9zct"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30541188CDC
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962554; cv=fail; b=aUZ8HcYk40rFyhcSyytkKnbVfAXohmT2G6+boZ6zTXDycfCVedudGaWXB8PpUh93mbkKB8pFVxPraXrfo9W57bbwT1EaT8cNvmATdpcAnsqfMr/ckcRkjzLL+aq99aC9ir1eH5c3v2xJsrzD1B8JPZcR9GJa2YbmFoIdSe1HCYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962554; c=relaxed/simple;
	bh=m8diFqKEmIw0ITLplDi36KxhmN5TKJBczINomA9LIo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EIMFI7xSvX7zKwX/UyROAvBRSvRK4nn+UNcXCiP/VSiguODPkuyimYrtao7s3vqBqWJIDKJ+FSFW0/8jMYPmNyqGXpCRElFrKJbfFbHpbWe8u4ZRkL2KOReVd8r9cISgCeW8CdxBe6W8HCdON5mfbn3BwHv/fuHAzZODQaEZWlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CMFbuPYM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MDEi9zct; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QTZ8009091;
	Tue, 10 Sep 2024 10:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Vo2fFx1ohejTAXLPbUW6VkXu/DbA/g86PRRbuTEgISs=; b=
	CMFbuPYMx9WCrsV6S1qg731o1wDRllhaPJ5EaryUOWCUUKt8r5JH+wj+Wx0/OojU
	xqmEakLEQzqDVj7oq9J8c4yit1Y4+zD/Emudt2QGaXsw2TFuaiBgEcCMvM4VSmuZ
	2c6IgMypGjkuBH/RIdfMShAEGTvPK/Sbe/ovYSgm/af0jIxF6hfyqncUJPV6h89t
	vdtpohmx1IKKXwviBJ9GJwhsr7liet9AF9wsQqrCuGOMoOmmvXFFPEuea4OIiQ6J
	2UlVe1B/kTct1729Pt2dj2+jH9KQ8qZxXuMZqk6nLBSpqhX4zNp0zb4FsPTANHCL
	8Knshv9qUaMDgvXf+jLSLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2n4kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A8eATB034126;
	Tue, 10 Sep 2024 10:02:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd98u2nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPr3rn3jLbsSdn2pDf2NPV1CsDCyC9vrX7Lg14bxMNrsgUGJhG5zzM96b9dJfs88VanLdtKsj1bPEvFs5D9GYBLz5Hc06RcQKW9XgRwJgWQ7platwqf49lCpTN+Nx/D348P+qlLqKblREFHBUyT5wfVPLdu7RVJ4y1cTld7lN6Qo/crAm1tfzLRrCEaT6fex9wmtCZKv/pk7CKP20IfzKLyJ3dT8u+A3M6npmIcL4P7wn65SqrGVw2G+AIoBI7I7q09q6fIqsCKAA7mZZLiO7mnhkuUteLTazQqbufrMjHmT2VfJxX3xw0HLEL5/+vwBf77DJ5oUylKuuwnjsJgpWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vo2fFx1ohejTAXLPbUW6VkXu/DbA/g86PRRbuTEgISs=;
 b=obZPPasIlHLjML76ilNsBDBB49DI4XTC/FQBoKYQQIQyAlDAGfIkAJ+4SsrG1jEkfFnVGtl59w8N94+KgEo/hdRFpd09XHyIXphMiJ5I3aL0USqXXF9cQo1APyVN14mupg847xmkeazYFufVcof5TLlexsZZEHRL0JBslyJpc01Ygi73ioG/OuFmdXLdNHw+hw33pjI73aXWU4+CxcezSLx68zlFkJB6dpSGNi5xBRssa6vbz3ej/+u9oun6fG/ND+519zUI9f0vaFObU+643Gr9bmiMEVjEQb5wqy3iE+PG2QY0fPhujwxBdpO+b9TVtKgxgdrk95p0mc/jhtlReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo2fFx1ohejTAXLPbUW6VkXu/DbA/g86PRRbuTEgISs=;
 b=MDEi9zctHhpNEf06DGxAHANn7ymy6wdkR3fDR8mF3JlTru5mgd+I7mkxjjnr1wov0NHTtgOkzlhhq3pfeDrtwqbSv6/6bB6ByFcIefg2HKgakkC5w91o28Um52SuHf8rTGaqAM16aZq9WVejVn8zBDt06S377HforZBSiCZ4d3M=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 10:02:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 10:02:19 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
        thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, william.roche@oracle.com,
        joao.m.martins@oracle.com
Subject: [RFC RESEND 0/6] hugetlbfs largepage RAS project
Date: Tue, 10 Sep 2024 10:02:10 +0000
Message-ID: <20240910100216.2744078-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240910090747.2741475-1-william.roche@oracle.com>
References: <20240910090747.2741475-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0106.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::47) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d13ace-08c4-4848-7499-08dcd17fa7e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FrB82j+WAHMXSXQcWNm5SYY1XS+nHQiV0aiDXcikNed6j0XtzzIRyWkAKoNJ?=
 =?us-ascii?Q?BW0IjX/Gy/WCfXUyGZ4m62k/XM1IvWtSEboVuD4IPHA5Z1p4gpRWk5cG4OMY?=
 =?us-ascii?Q?9u6BWe5dr72nGHCja16gfB5l3M0ayMGiJOy6GkvEVyM63QU5WMGEGhqSDEAS?=
 =?us-ascii?Q?YI6ErMMWPnHLtXSVqNQYGVZAgKb/dgXuZbFwMiNZCEVDPZ/wusuBhHME+K2r?=
 =?us-ascii?Q?RjbQWK9fm7ylNE5IVhMVdU1hpq551tLWGfCa/sHsb0wa2hU9Q4DebTTGuA/J?=
 =?us-ascii?Q?56FbmxYhH4bVKzYKO/Ty2jpH9HaZYQCWF7IBjAIGyuUDVjhtcfBfRX5NFact?=
 =?us-ascii?Q?RTKxoo5qCgjZpwUwAaYatzDvIgrqgP9n/iJkaqWqHBa890uf56OwMf+eXQ2Q?=
 =?us-ascii?Q?AZFEuzIVqzfbLkqUWkOXlEfqwvNIu9q3q6lTY6gy4WvJdQcmhZGiwtHbjR15?=
 =?us-ascii?Q?LaJNv3F3NLb6xBxOr2sRVl0FNk0SxyeakkCOKYVaE2jU1zleBS85g63++Zns?=
 =?us-ascii?Q?h99wIaHWwP3Cf5aFXmCR42A0h8huWQt9GyKrLStAeAVOdjw/rEHglEyXKZY6?=
 =?us-ascii?Q?TkVZsMIAFeKr2ehyQOUKYSIhMqdbNDaCPgL+Ry0uSpm0ZWwjCcBp/2LPcGE5?=
 =?us-ascii?Q?t+h8FDRmjRRvC5ir8kNUyk7i7UWUo6370iTQi0rHey9Sh2FJEAs2v8VVUMSw?=
 =?us-ascii?Q?5KodvkXF3hOQD0LCw3bKC3yaMZmpYWTA8Sm5qgZ23JwOa+aClvajPfnkjqEz?=
 =?us-ascii?Q?af3x2mHQZzFIt4Vijrf6yGDRMWNUXbDKMGtOKNfT6QbJfZWlRninvTHzDLuV?=
 =?us-ascii?Q?P5LdIMM/RyOjtcE3d22FTfHPxe227VZAMqJfQFUIZ88+kff+BUYy5DOlAU6P?=
 =?us-ascii?Q?hguAcOezygKsJyaMUfy60J6hKrz2mvtxwEbVh1D1uYVz17Cu4ZLK09ln+bCn?=
 =?us-ascii?Q?I8n7Qa/TYnd52EqXmkxkyXua2wNi4xWvVXnSVuwHq+Vi2GgfIH8N2sT8QaPF?=
 =?us-ascii?Q?UxZgD/dEl0fQUWYzLH3qelVdkmid4y4R0kW56TicBiGYzCWjvtin6e05Bc8D?=
 =?us-ascii?Q?eXrl8HnuzXS+CmEMoD1Mak3a2FYsq8Dt3iD9n9fm1LntqCpExN1HiUe7mYrj?=
 =?us-ascii?Q?agMTMsjkS/NLF9q+kfVTTPSsO14DfHxtlrPTHOtV55v+TvtOXMEDWARhyYQO?=
 =?us-ascii?Q?O/ElzW2KBikIh7fU60Yl15QJ/NOxYSsyOMBNML7UnGMbWnWj5qmIvaiXxfhs?=
 =?us-ascii?Q?3oGJdWIi3nKnQlYAcax0BPnjKDmbW+bPzAiN4LLX4y1YDIWbhvZfDVqQuT/9?=
 =?us-ascii?Q?P299Wm3pbtg0kHZpqHmlIYTFy1aroJm05wYYZ16QvTXwX62k/dHwmzJ7I2us?=
 =?us-ascii?Q?8ZimFnLEkRjIDNrLAYr3a0T2EWqw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?80Koi3mDvOC207u+I0Yq3VrBaJSpXyF7ZM8pgcrXgimwEa37O57CGWBBQfFy?=
 =?us-ascii?Q?P/CsGCuI/I7ZguzAQep0kJj+ifcQ5pR12DLuRXuJ0A/SgQOkA7hRYhgvntkZ?=
 =?us-ascii?Q?kLKnqJpBMsCP/Ztuc6t377/4Wdb+t9bM+EVvyAiPxTGgb6kLExkHZzuxmWnT?=
 =?us-ascii?Q?r8KoQa1ypH/mw1vhQjOVVemiI9jHchzGIpEcxCDgUF4m4Axw/fYHciA+L6hT?=
 =?us-ascii?Q?EP2dtgH7GrHPzkXxsx0jZFhGGPcp5sksa7Q9bYQig4K5/1f5VF8gLaX+UCBY?=
 =?us-ascii?Q?1ITa9zzioNJ/AiJthiKSh3NdGmtvvfxYy711LgoK1ghKaUzlPgsFU1p3q+bx?=
 =?us-ascii?Q?qWdcJDd5tVhFAbX7KvUrwHJC78oPG2wXf44jBgIPJizU7tjeFazTOyqr/Ulr?=
 =?us-ascii?Q?jjD9ODYzZvJbG5VZFI5VXQVyBl9pdwpa6aQcHPUn78/wXw1GMg/0h9y9Dk8u?=
 =?us-ascii?Q?U1pNygICRZnaNe+wYOjZv8xGpYc2nbJHOjugfNyEu3nKY+e7cL9mrAgDeogb?=
 =?us-ascii?Q?UHizzxg7mREpchdDQZxFqVy0cDTXf02PGB1d+ca0OgcukMYWNQGQH/1rgohI?=
 =?us-ascii?Q?btjF9HaD1olKdxejgku5EZdpS6X8547N1ZGf2C9ePMXBbCCHiH2dMDbEJRpL?=
 =?us-ascii?Q?sCcZDh+dtS9lrXpQJwKb/DSSEfFphXXZtodG1GxHN91x8HpDH2ixVXeEJ6zt?=
 =?us-ascii?Q?bUKLHsqpwrbYkh4oa9DJ6a2M1j2TZOkd3aZ5sEu1H4AQbc9JYO6m0ieB7HZ9?=
 =?us-ascii?Q?UUWaLbzSd8mD/8oF5BUe2ITzRAG/fziQ1hbDEe9lbu1Ivarxsj5vwLK7E4Ku?=
 =?us-ascii?Q?ATTmbWcwILskeK3z0G/L4jDwPL+wlO8PgDXOk1W+LfiZ7uQEnW0Cse6IuRU8?=
 =?us-ascii?Q?BUJjgj6Pq/d9NyeHqYq6mgnbV3Z8Z1MLIpmmLNZpBackOaovfhj1yE65icNu?=
 =?us-ascii?Q?tT33dcDbDf9hP/4WPkoOJV2y2h5ODO9Rl8QhS+zrwbdvyYrlJejIJyc+KwYw?=
 =?us-ascii?Q?rgNa72j6UudFE3mFj7CmlXcgKZjd7n3VlyCh4kMYejR6YKf9KqCY/wNXsmKR?=
 =?us-ascii?Q?HO/bjmJzXlMAFIKcdZfnPR6Z38PbcHPyIJFXxQSw8pXhcTr8ztUkNNh4zA9a?=
 =?us-ascii?Q?8C86y7IJeOl8WZG+oZpdZYI5dcrEE0WrFYaPj/fYaTJC3g2djAhd86Ueagch?=
 =?us-ascii?Q?BqCnspZ6mQ/pw2ced3HSr1Pe/odM+xLdm/4t3UDs2MWt9XIlZcpvvtZNTB3P?=
 =?us-ascii?Q?mOb2OP3KyKrOAU9Gu5kJGDznK5ToWS1FfTgnlaT3f0ji/Jm/SH8fHG9WkrYd?=
 =?us-ascii?Q?xei7aSWnVNoWBZAIpD+G5AxkaX4LxbdycaxVG8qojaDHJ6/mgDptWTahCKs0?=
 =?us-ascii?Q?3/VPO9plPxc6aFoYcWZypAvvyb30lM/E0CVGLc7C+IeMDcnP7Pw5ps+UbOjL?=
 =?us-ascii?Q?VIR0o3NZYZC20OHh226OGOvzAZAjqAtbSdaGMy8CtnUxATIocAkIpoqAMbdK?=
 =?us-ascii?Q?4TONaAHjyKHfRFJLlNQAg6MvuJvqb4H4D9Q5s4o6xpeZPef0/UBo4J8Op6lv?=
 =?us-ascii?Q?YVFwVZjqQL07vrBZMkq/VO/N9dgQZrJ+kymkvWJf3SdbBERgLrL8AkPhcjLw?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3MRBgS125UwfB3xnm2ciz4pIQnG3bdobpHXQWSVpWneVQsWqVh26y+HTrVmOTAn2EbXVbUt9jBueB9A1b9ZJwgtD22WsItW4cg7G1lrhHd4c/34aBrN1qUvcYnB6qhkWUsz/40E4jC2M46x2rEp1TXveczUQp6adkLwk5vb/0K4Mg0IJVrSR9kLIG9LQs/JzY0smVLRirtAxEAYIXswZvZJIyU/u58hBBnrKBFbpatVgDs/l5F7lREQPuUqscAX+wX4kVG2Wn/PU94/YtGnwxFp9Rvrk5yNBv9VmI174Nco5LhgIFneXQmW66/wJugfbrg1vrNfHQNVgy+6MQZ35eSBeJUieyJG81YnM+GRzl2kHz925FjnDitgZHcWyhOcSGArwQmiiVV7zdRawFrSHSuTwgYY6TZ8R7BMFk6FNgxTUSo5jNHihAzfdjzHZa6K5b8x6WIN7zpwBhT5YyKTiKuC9clP2mhRLohjA+MMTPJh4y7xocxBgSWjjdbsqmR/twKpNqAIP2UQIfM/ygyfe/gUkM6e3VND/4A+R/iubGBnrJPZKJr7sikF0vkTQcUpfQU62pntQPlqALxKGNFWP2ryglxIB4OuRIUKgcRDpgtk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d13ace-08c4-4848-7499-08dcd17fa7e5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:02:18.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 566UtNvSQO62xG2qYLRbYeWkWg1Z2FswT0KqLrK/sHmOwgKSAjs9va3sJayC8/pEzYOCLXMnEp9O0AygSqV6Xb8vxzSe9xxL9n5Qsq9rUyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409100075
X-Proofpoint-GUID: 2Ru5X-FP9ye6OyShJlbrdtK0m2S2agKk
X-Proofpoint-ORIG-GUID: 2Ru5X-FP9ye6OyShJlbrdtK0m2S2agKk

From: William Roche <william.roche@oracle.com>


Apologies for the noise; resending as I missed CC'ing the maintainers of the
changed files


Hello,

This is a Qemu RFC to introduce the possibility to deal with hardware
memory errors impacting hugetlbfs memory backed VMs. When using
hugetlbfs large pages, any large page location being impacted by an
HW memory error results in poisoning the entire page, suddenly making
a large chunk of the VM memory unusable.

The implemented proposal is simply a memory mapping change when an HW error
is reported to Qemu, to transform a hugetlbfs large page into a set of
standard sized pages. The failed large page is unmapped and a set of
standard sized pages are mapped in place.
This mechanism is triggered when a SIGBUS/MCE_MCEERR_Ax signal is received
by qemu and the reported location corresponds to a large page.

This gives the possibility to:
- Take advantage of newer hypervisor kernel providing a way to retrieve
still valid data on the impacted hugetlbfs poisoned large page.
If the backend file is MAP_SHARED, we can copy the valid data into the
set of standard sized pages. But if an error is returned when accessing
a location we consider it poisoned and mark the corresponding standard sized
memory page as poisoned with a MADV_HWPOISON madvise call. Hence, the VM
can also continue to use the possible valid pieces of information retrieved.
- Adjust the poison address information. When accessing a poison location,
an older Kernel version may only provide the address of the beginning of
the poisoned large page in the associated SIGBUS siginfo data. Pointing to
a more accurate touched poison location allows the VM kernel to trigger
the right memory error reaction.

A warning is given for hugetlbfs backed memory-regions that are mapped
without the 'share=on' option.
(This warning is also given when using the deprecated "-mem-path" option)

The hugetlbfs memory mapping option should look like that
(with XXX replaced with the actual size):
  -object memory-backend-file,id=pc.ram,mem-path=/dev/hugepages,prealloc=on,share=on,size=XXX -machine memory-backend=pc.ram

I'm introducing new system/hugetlbfs_ras.[ch] files to separate the specific
code for this feature. It's only compiled on Linux versions.

Note that we have to be able to mark as "poison" a replacing valid standard
sized page. We currently do that calling madvise(..., MADV_HWPOISON).
But this requires qemu process to have CAP_SYS_ADMIN priviledge.
Using userfaultfd instead of madvise() to mark the pages as poison could
remove this constraint, and complicating the code adding thread(s) dealing
with the user page faults service.


It's also worth mentioning the IO memory, vfio configured memory buffers
case. The Qemu memory remapping (if it succeeds) will not reconfigure any
device IO buffers locations (no dma unmap/remap is performed) and if an
hardware IO is supposed to access (read or write) a poisoned hugetlbfs
page, I would expect it to fail the same way as before (as its location
hasn't been updated to take into account the new mapping).
But can someone confirm this possible behavior ? Or indicate me what should
be done to deal with this type of memory buffers ?

Details:
--------
The following problems had to be considered:

. kvm dealing with memory faults:
 - Address space mapping changes can't be handled in a signal handler (mmap
   is not async signal safe for example)
     We have a separate listener thread (only created when we use hugetlbfs)
     to deal with the mapping changes.
 - If a memory is not mapped when accessed, kvm fails with
   (exit_reason: KVM_EXIT_UNKNOWN)
     To avoid that, I needed to prevent the access to a changing memory
     region: pausing the VM is used to do so.
 - A fault on a poisoned hugetlbfs large page will report a hardcoded page
   size of 4k (See kernel kvm_send_hwpoison_signal() function)
     When a SIGBUS is received with a page size indication of 4k we have to
     verify if the impacted page is not a hugetlbfs page.
 - Asynchronous SIGBUS/BUS_MCEERR_AO signals provide the right page size,
   but the current Qemu version needs to take the information into account.

. system/physmem needed fixes:
 - When recreating the memory mapping on VM reset, we have to consider the
   memory size impacted.
 - In the case of a mapped file, punching a hole is necessary to clean the
   poison.

. Implementation details:
 - SIGBUS signal received for a large page will trigger the page modification,
   but in order to pause the VM, the signal handers have to terminate.
     So we return from the SIGBUS signal handler(s) when a VM has to be stopped.
     A memory access that generated a SIGBUS/BUS_MCEERR_AR signals before the
     VM pause, will be repeated when the VM resumes. If the memory is still
     not accessible (poisoned) the signal will be generated again by the
     hypervisor kernel.
     In the case of an asyncrounous SIGBUS/BUS_MCEERR_AO signal, the signal is
     not repeated by the kernel and will be recorded by qemu in order to be
     replayed when the VM resumes.
 - Poisoning a memory page with MADV_HWPOISON can generate a SIGBUS when
   called. The listener thread taking care of the memory modification needs
   to deal with this case. To do so, it sets a thread specific variable
   that is recognized by the sigbus handler.


Some questions:
---------------
. Should we take extra care for IO memory, vfio configured memory buffers ?

. My feature code is enclosed within "ifdef CONFIG_HUGETLBFS_RAS" and is only
  compiled on linux versions
  Should we have a configure option to prevent the introduction of this
  feature in the code (turning off CONFIG_HUGETLBFS_RAS) ?

. Should I include the content of my system/hugetlbfs_ras.[ch] files into
  another existing file ?

. Should we force 'sharing' when using "-mem-path" option, instead of the
  -object memory-backend-file,share=on,... ?


This prototype is scripts/checkpatch.pl clean (except for the MAINTAINERS
update for the 2 added files).
'make check' runs fine on both x86 and ARM
Units tests have been done on Intel, AMD and ARM platforms.



William Roche (6):
  accel/kvm: SIGBUS handler should also deal with si_addr_lsb
  accel/kvm: Keep track of the HWPoisonPage sizes
  system/physmem: Remap memory pages on reset based on the page size
  system: Introducing hugetlbfs largepage RAS feature
  system/hugetlb_ras: Handle madvise SIGBUS signal on listener
  system/hugetlb_ras: Replay lost BUS_MCEERR_AO signals on VM resume

 accel/kvm/kvm-all.c      |  24 +-
 accel/stubs/kvm-stub.c   |   4 +-
 include/qemu/osdep.h     |   5 +-
 include/sysemu/kvm.h     |   7 +-
 include/sysemu/kvm_int.h |   3 +-
 meson.build              |   2 +
 system/cpus.c            |  15 +-
 system/hugetlbfs_ras.c   | 645 +++++++++++++++++++++++++++++++++++++++
 system/hugetlbfs_ras.h   |   4 +
 system/meson.build       |   1 +
 system/physmem.c         |  30 ++
 target/arm/kvm.c         |  15 +-
 target/i386/kvm/kvm.c    |  15 +-
 util/oslib-posix.c       |   3 +
 14 files changed, 753 insertions(+), 20 deletions(-)
 create mode 100644 system/hugetlbfs_ras.c
 create mode 100644 system/hugetlbfs_ras.h

-- 
2.43.5

