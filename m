Return-Path: <kvm+bounces-35114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5523CA09CDD
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17A2D7A1F8A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B9E216397;
	Fri, 10 Jan 2025 21:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VsRhA6VS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BaSWbQ7q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22882080F9
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543682; cv=fail; b=VY0n+eABgYa3JzA9EvfiYeBje6N46Y/8z2f7JoEqOwKkQHhvrrY1v7ikkBVEsvZwlYFq9kjVjkolKafbDyJnjjY2SYmh4DA7+KVgU23sPC2Vs5DflTFQv4XNtS+sjTrg0XIwhQnwOTc+DAZMNwqVW1TGb3oxNslkdUjsUfgVUkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543682; c=relaxed/simple;
	bh=TM+2KOHAsr/AuNPU34degQRHKHKaOUPdRtwXrzBmaj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=imv4fK5D6VsSox/XipAUqwKZlnj8Q90nOSGqKIpZHCoTW70ltzowooTWEiqXD5TA4sWwqWIQqwNTN3B4P+HNzbVDer/s5ePqSmQAadBi6gVpH/GTQQHNm6YyN9IuaQbEZM7NhSOyMOqsIXrnWQqDI1aNQZ4WgXyQ9mVPL0iwoNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VsRhA6VS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BaSWbQ7q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBqgJ014729;
	Fri, 10 Jan 2025 21:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PvHVdcfbRsDvZ6fElXJcKdsNlxg56dZulyNAkPPQhCE=; b=
	VsRhA6VSM8uz6Dewx2SHiSAi5454+4YXP72LlpDx+TCZV2CRKSCWWN0aeYsnwiSZ
	KBpygz0XTGobKwKreCva1ubjD1SGQ7UWEQ+qWhO2Pu3RXkyQqA0WYRXXp7ZZI9u9
	m7f0eIwH35QvMFaavdn3CD3S0RZdwUjpESI1moIaw0V7fp+r9TIdfaNfEzGepVdn
	L3ubmvRlHFjR5G9eUIm3o5ZRAR7PyhhgFo4Fn3JOtNeRHK0JYMzYfciOxvDr20dd
	qsjcya3WobfTEMN4r3MSgRwfGUKaWhhGv2dde5efI3kN3Qa7KbPjftMjLPqvJB7n
	qvQ4N2e20+W3lsh5hJO5sQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442b8uk9ww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKIpL7004868;
	Fri, 10 Jan 2025 21:14:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecwpwk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OItWILeVZ12pEeqXHUQJ2npkwaY5kJawmnd9h8G2V7gz46Jf7NtwFuc/H2rP5spQuiHS7813iSSAb5aUFg81noMoSUSz6aiTHYcZWs/tqhW8hs82uOssk6YDiR4Bonk+/UfRhiEdX/RLog10dt4WJU53tTR/1aKTZ2BciJkm6OaBx7+i9jcsZ4mcoIWRLm2/Ko4coCupo1qjuqz3F7EKfbMCPU2sxG1rHBuzrKhqTKWdc+rhMEC9QzsWvNMMUGhH3th5KFujJ54HdmNE2/ZVWs0MTBW5UoCo6wrELDe304n2siltPG+jcpmT5cRTQbCA46ZdBsAGnB5vuhVELydd+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvHVdcfbRsDvZ6fElXJcKdsNlxg56dZulyNAkPPQhCE=;
 b=Wh+Nz6JM7BvCnXaNy+mi4jHWOSJo2tltcrk+qqTZbE5m35w9fFDp4uYIwWWSU32tir+PojKeHBURXSVHB124DtH2E2mmtqN6Ck6F/WvfclCsQfXwgneVpBiDEf5TeOQ3ujpA1sVDb1jwhCxdmzItTc9/DqdgqhCelJyQvj6KQz3TVG1G9uobtJRYULxzdygV7PMRUcGpcF5vbKmOEM6oK/AV1428p62tK76QbQoPa0jEX3La4tlhKTSEPye41zaITjrExyqOizqNdpiAfYQmSDtM9yUNiKfbjjqgcon6wBq0MeQBOJwZ4h7pmGNtjy1Vbi/BiRopGd86K7xDepIJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvHVdcfbRsDvZ6fElXJcKdsNlxg56dZulyNAkPPQhCE=;
 b=BaSWbQ7qIuvR/vtn/3qAgfl7UtaQ7hUmKkgqg7T02MeM7IDSJTT6X9LUvD097U1Eg3G7Y5a/OdxQk9ilm9LGQPUSm28BpllgpxzSoqyaS8WA8QUGz+CH5FxzjmKTAADDcqLwZuUppXowkomgCnMPMUpOoydR3hzxvoqvtuLwoFs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 21:14:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 21:14:18 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v5 1/6] system/physmem: handle hugetlb correctly in qemu_ram_remap()
Date: Fri, 10 Jan 2025 21:14:00 +0000
Message-ID: <20250110211405.2284121-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250110211405.2284121-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 3419cb3d-0dea-4a63-48fa-08dd31bbbec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KjHtK3rrW0x9Osz60XBCJ30cesQb3JSLVoky5fcIUGlBhyFJDoispO8LdQKD?=
 =?us-ascii?Q?bdmi/VbcBx8yaGcu7J9mw1MNDEVJI39e6w1uD6iqFvasEB4p+0b0mfPAIsC7?=
 =?us-ascii?Q?9gv+HNHAbqHlQrFIQM3sPev2Gk4Gxy9k1aru2udXUQCK0cC4LnxFk/zSNpY1?=
 =?us-ascii?Q?h/TTVTtgUD3MuDSf/ZkLdPxsopYW2ThfJPBmn4DelQUv1OxEVCcAvClr9Rg2?=
 =?us-ascii?Q?zvv0T0VodPg/FcyZSFiuBtmUICO+nlcOIAkgV1HDiQ0Oah4shbV5DMsvkYde?=
 =?us-ascii?Q?/LR1kavcSgbDLDPrex7GAe85Z8t2/TvXkSdn8M417ZgHBBjn/Ne+kDWzmDyj?=
 =?us-ascii?Q?M5WFY5f+L95KLgD/TMg/mMRwxVFuFC8o4J/JKTbxO3O8VCDvfDWNvlC0Wjk8?=
 =?us-ascii?Q?C9utyswA8f4UlnZ47hiIGDVSDtqvZFKVUeC4ZQg92T6HI+8to/AUPLnq0v1Q?=
 =?us-ascii?Q?bK8K16tHrIpvvVLxN3MfQpDeEZeyBZ86V5KYudNxPBLiKgw7abE/pU5KK6/s?=
 =?us-ascii?Q?WBgMCTgfeIzaoM3bhnTu105yaz8E7b0xIRk5tYj/kHX/thuQGwUrT7++p/6X?=
 =?us-ascii?Q?dWzMbxGqYKUjbfdXgYn903cSMRfUYJcGzrIlg36atgMu6ZS7RAfGoNIImy4n?=
 =?us-ascii?Q?mlcmZCDxRob6Wr79nrY6q85lJlFJtq+3ZAV31m3pn4WgFgJ+B6XEsNWPLa+l?=
 =?us-ascii?Q?/VGCCzQfYr43C3n/L3XwdKwv0NtEhw8rd5NTmLiXq7BerbInHmgZ/fz7Y4xP?=
 =?us-ascii?Q?tlxZA+YnXCnvgMh3isVC7owKoOhvbQSE9ZH9YrFYx9ud7i9n1G1ixn40UYkW?=
 =?us-ascii?Q?rpXBSDFc/xA1/DdLQrhMQFjHbeabgqK5IZ96fgfo7Wtt8x6UvYYX2gPsFqbl?=
 =?us-ascii?Q?OZqcPl2Aj/mfG70tO2SD0HDp2a1Hp9XrUx3+1ZI+T0ds778u2ChrmpOp+ni3?=
 =?us-ascii?Q?e0aS58C6pdhUsCyvYVzym5r4lRXP7Ylu8/mQSr+aEn8HQOCUS581IWppkwEl?=
 =?us-ascii?Q?z5wqtwfpf/ArxeA17/gDulH1XtQaJ3liRjKsu1dPO2yvsGeN/5wv4MsiVmY6?=
 =?us-ascii?Q?thCzMvkboOPiL6Rc6lWMd/3t1vrT857MgxxMA6Wn78brL0GOSMYWrZnxtT76?=
 =?us-ascii?Q?AwpNVHNmTruoBnwupa6KMSlcJBuYmqIXPsW9F4OCsevRPQ8Qi6SBxS0g7FH7?=
 =?us-ascii?Q?Je5i+CK+7z4LVg4p2YAxa4p2QSFOMbnfGtHsQ8Ar6Pji/N4y4CtQx28OMUoN?=
 =?us-ascii?Q?tsWScjMyN2r3Pt6zYGxuJ3LY+RWa+jdXSBU65V7qBM2hqxQCx4Y5/keYYeOr?=
 =?us-ascii?Q?l04RdHlxoPa+ds2qDY6Bh2bab56cyQo3J2Tth098K12ijSweoywIrMUvAK+E?=
 =?us-ascii?Q?ACo1XFZLMlpBnHBMWsXF6e3Vzzv1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lrxsSaRWtUYiWvu9DyW0XLqdTX/5/DUdK6ooEcSBw1NUuOjbhqxFV4NxabzW?=
 =?us-ascii?Q?iM4TI2+FGB52OStK8LIuWU61CHXfeaoNzSjv6r880ydjMCT8gfldqwI/2dxK?=
 =?us-ascii?Q?QUTs/khNAtBIiH1+nWMtOFNUfhqq3kEj57w44DHRVJeaiNi4I42q2LE7Wk10?=
 =?us-ascii?Q?J4xZhdqLdoJ2wJkuNfOts60sv4u3jbMMAf9PwHdjUqRdIQDqwXfBQzrhsNV/?=
 =?us-ascii?Q?hW+Uc8IYxVJxRZ0JDWGqUDSY+HHzsc8C6xUa7ngvcFmAIz+l3AlHTSj84QO6?=
 =?us-ascii?Q?/7OQTkaSxNUp0vx4x6jsCeIToXAXpF2aP49kIIORxGuOX5shJY6C2sztVj3f?=
 =?us-ascii?Q?R87yRvbKGDz7ZvxW/42YOUWyjA4ifUbzhIQ9piE32J8sBZMDq4+LMVoXVk+M?=
 =?us-ascii?Q?bDV8ddp47JW12nuZy0KKvJpDB3bWgRYbVEUvF7F+gqUnZLeqWruVpVGsPgkR?=
 =?us-ascii?Q?32wtFnMBxd9zyMRWBBD+hXjThlhkVWrHvQHhOqyw8dFixu/3EQIAT73Yt8Le?=
 =?us-ascii?Q?kxsRtApsaJC4E5cAxxCl8gmXepEtmIDqmRzvBdq7gtt2fu+KDz/jN/0wokYM?=
 =?us-ascii?Q?PFidqmpPljHoBRcoF8QOtB9lvk5Yp7xINnpSOBWou29vPnjAr1r0txTrb5a8?=
 =?us-ascii?Q?4CbFDIyFRtDHwoX+ZnOZwbe0+gQIEKidVG+p+TRDGbRhoenB8kL2vFc50ibk?=
 =?us-ascii?Q?T2pjG6nnAjpOLGII09fxvnCFqKwzE8RTXDKHcVIlDVepS3UazxCpyrcJhqh8?=
 =?us-ascii?Q?N7ufRqPhr2hhuhliObyhmxi+qUs4P4DTeveTzhweIFhOjWvSdiYX9d7e/eiH?=
 =?us-ascii?Q?c55/Y9PWfgVpvc+Prjqmq0NMmLVn+rJqGOhqOraXQ4hFhYXCfb7ZRG8NKF7C?=
 =?us-ascii?Q?yYXvdaUYvd9BFNOxxXEwl6biom6NtCGctCb0etO6RJXHK0FZtfEatZP2hUqi?=
 =?us-ascii?Q?xXJs2mG0ub3uspUkVRVx7Mdgom3LTNF2h5zUQN2Fsh+6NtTWYTdVzsIu7x5F?=
 =?us-ascii?Q?gkcRTEC22n2X534ZElu6NWU4Oezrv1CcH1Yib6ob2UQx1gHNrGPQ02kvte0n?=
 =?us-ascii?Q?znCbuCdXvrMeOdubdXkSx1hjlWkP6rt39UrLKoOlDKN7FlHhp31jfp0LgXxV?=
 =?us-ascii?Q?07cPfze+AMfsCjBzXIRuIpLMQNDKa4xevM1RxVgC6vUx642wkSr28kKbOCzu?=
 =?us-ascii?Q?c4jenBGRLJld4CY2xgwNbdgcg5mJMDrdbYIarJySBSYVpTvRuLduN4woA3kA?=
 =?us-ascii?Q?iSQdyGsejCzhma4C3g1I8pyH63+RU7Ann2RgXxn4GHrVnN91qNbQ4L1qRqcz?=
 =?us-ascii?Q?uSmALIaF4OlF+xryDf4FFbjjXQPaQjH/nWNr5z3kxkwS+jkjmXSMWwIxzJnx?=
 =?us-ascii?Q?XQU6bJ79m4BxfJyG0qMTDGHVTJeojBQg2UG7BVGx+D8V+liDHZaOs+tEspOM?=
 =?us-ascii?Q?lkm5W3ZnSMyJIQLvHb+Nawr/pcUBzHwnVIx8zGgXl0JvQTzk+KP1tOmYfsfZ?=
 =?us-ascii?Q?NJiC8YJVD5gmh4I2DeGLpIW93PKjAlWS5xt5wtfxAW35t7uo2l4hbMhv4OCm?=
 =?us-ascii?Q?qWseY8JrEOMIhcAHwz0jEihyBwmITrzFrZQcH0APOf3TURU84aqtGmLGGZMc?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w318+fbGIdi5PE9PesBTYFWrPut6NMhgbDSz84elPztv5UjejvznKpAXXQDXMW46NaUDHsuk9dWgvBxUaXoMUaVg11m1M9Ymp5RVKunI/F84fTE/2KYzVJay7LXhDHUhfdiJ6k+t6WBZBuq+n+dD5ZjZQp0lqxFUP+hSwoqMOXKT0uPLrtrJBEDJRX4ZJEK25xns3zAgN2yJRc3aPhsMKhorVaXhgszxBx1YXgWG5vQwlKJYqiCWFryf1+H1p5seh5W8qV6JoT+1lXFZf056NZr8+/B+6DB13Z3h6cNuulPV0n854wbk+RoqjIwjynzwllUF6utjRoPf3iw/rCNT2+DDYL/ceSW7Dgj3J2vPPcwloppxYYsiTgCIk04KE1KCthqWBTb1MjYZDDgIr6qClitZHzE6S7/NDbiygUj4OJwyNKm4nlm2eLXc4E/fEdgxvt0P4XDdrlIBMs23VfLWDHlT+4WrMAj6XrBq8Q+KRvJjwlKjptrsjpjMuVvOdJO3fR/5fpnx7BrEME6FwtaO2X3MugHKsZfzIFQJSNwfp/JvZv9oLmrcJmSUtQnNI1o4KhwLXS65yzebzlg3g/AiuINZVtee9uHVS5ppUH2kY2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3419cb3d-0dea-4a63-48fa-08dd31bbbec2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:14:18.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cL+Yk0i0PNMk/Y04qN3JxfQikGoM9spRMjkhprSzXuvX2pqGKLQCD9SxSfFxmgIbkkx4JtZm+YlL3Lzlu/C1v5l2dUnO1b70JJLyndulljQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100163
X-Proofpoint-ORIG-GUID: 7dS2BJGREEZ-yTPMMTBiMhcdIzFVXPq5
X-Proofpoint-GUID: 7dS2BJGREEZ-yTPMMTBiMhcdIzFVXPq5

From: William Roche <william.roche@oracle.com>

The list of hwpoison pages used to remap the memory on reset
is based on the backend real page size. When dealing with
hugepages, we create a single entry for the entire page.

To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
hugetlb page; hugetlb pages cannot be partially mapped.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       |  6 +++++-
 include/exec/cpu-common.h |  3 ++-
 system/physmem.c          | 32 ++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433..4f2abd5774 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1288,7 +1288,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
         g_free(page);
     }
 }
@@ -1296,6 +1296,10 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
+    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
+
+    if (page_size > TARGET_PAGE_SIZE)
+        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index b1d76d6985..dbdf22fded 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
 
 /* memory API */
 
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
 /* This should not be used by devices.  */
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
@@ -108,6 +108,7 @@ bool qemu_ram_is_named_file(RAMBlock *rb);
 int qemu_ram_get_fd(RAMBlock *rb);
 
 size_t qemu_ram_pagesize(RAMBlock *block);
+size_t qemu_ram_pagesize_from_addr(ram_addr_t addr);
 size_t qemu_ram_pagesize_largest(void);
 
 /**
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea8..7a87548f99 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1665,6 +1665,19 @@ size_t qemu_ram_pagesize(RAMBlock *rb)
     return rb->page_size;
 }
 
+/* Return backend real page size used for the given ram_addr */
+size_t qemu_ram_pagesize_from_addr(ram_addr_t addr)
+{
+    RAMBlock *rb;
+
+    RCU_READ_LOCK_GUARD();
+    rb =  qemu_get_ram_block(addr);
+    if (!rb) {
+        return TARGET_PAGE_SIZE;
+    }
+    return qemu_ram_pagesize(rb);
+}
+
 /* Returns the largest size of page in use */
 size_t qemu_ram_pagesize_largest(void)
 {
@@ -2167,17 +2180,22 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     ram_addr_t offset;
     int flags;
     void *area, *vaddr;
     int prot;
+    size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
         offset = addr - block->offset;
         if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
             vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
@@ -2191,21 +2209,23 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                 prot = PROT_READ;
                 prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                 if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                 offset + block->fd_offset);
                 } else {
                     flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                 }
                 if (area != vaddr) {
                     error_report("Could not remap addr: "
                                  RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                                 page_size, addr);
                     exit(1);
                 }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
             }
+
+            break;
         }
     }
 }
-- 
2.43.5


