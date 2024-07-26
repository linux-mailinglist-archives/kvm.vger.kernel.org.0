Return-Path: <kvm+bounces-22352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A44E93D99B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB8161F24592
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EEC14A086;
	Fri, 26 Jul 2024 20:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gTZ8n/0Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UdDEyEQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009B0146A8A;
	Fri, 26 Jul 2024 20:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722024902; cv=fail; b=LMtFpQt3sddcizEQI2aF4ocnRUZK4RcftgWrWj+gtfUyT6/Mak3qqFIGeAdeVCSYMk4NwHyzJzu6OJ2KUJzY4DEmW3JPsubpTtGo/XKw4SXf+qYCu+pHpT/X6v3WOEFQ5FgjXHmKxZ4HHm63AL+YwJ9sL5spIXdgAhQWMiZBvPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722024902; c=relaxed/simple;
	bh=HR+nvPtfvYLZPK6ySgLLzkK9ap2BhiTVDG8FJTtEnr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q4VK0+GovhwNQs0Un6JuMgfKH2+2jLwQMQ5zsviPE8nO3w6bOGhlJbKPt/qMYY+rm0KFXH31uYtqG6lDOIVKQQ7UsncFTC7TaNd/saJB1fvVbLVd6gOsaqHNPKIJ/snjjAbWw0FKFnXxO2h6WCTHy7nakengg33tNJe7mIvHyIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gTZ8n/0Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UdDEyEQ9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QK0sUl009764;
	Fri, 26 Jul 2024 20:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=aoyWqPSKiDqf5o3M6Ag6M4Rv1F2lpwQF9ASKFidwTD8=; b=
	gTZ8n/0YCgK4+E6lyWUiJy/SHPeroZLwLrgF9hgRvba9QNz8j648jZ2ZuwGvTsfO
	F5tz10Af30z9gIDLzvSeWBxW2x2btvuMywLIkZ+BjODiX5oQCyRUO1HtSHKP3VIS
	CTvtZOUN7SJb9PZTaBwI6CLwvKgyMDRyg6XUvQ9zu8wC4TUStERAX5Wc18oM5/NU
	dBH4lGcZTKuD3Ht0IhUq6ACEHAWYWDyt3MrteykiqBjCzhRuH3g4x6THUUW77ggs
	Y2itCIFZsge0DGyT79tXFAIaYyZei50/L2gNMfhG8qI9VrxFBE5Bqn9HCt8u6HLO
	s2OHHLKZZFdrPxVe3SPzMA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hft0p9j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:14:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QIOjJP013515;
	Fri, 26 Jul 2024 20:14:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a645qs-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8gwzikSzeAjLYhX4wo8SRaKH8lt/fOWIcHaDlWVtWAoYzVtdNQZ7QvnuTFCP2+BiP9qSzIbhfdaOXlCw2jSIWm/meiAtdv4ESkO0eq6amX5tOc8eaLl9m/b3JUGF1uFjDeLBALfDT8UtulTISwMddtx50yYSQAd642shZ+JVAyUb5SRTZWpGlYCgBaKBam6oxWdLF1C6rfcjv62NVCOkrD2AGFAiiMcoFhXnNEIYNmQMuj1OGqFSKvF9aDCv2CWzYlQUUxRJfZTLKvt7oodoDgbPs29MJsB2pVJPU2j8b3bwFJ1gp5CJvTQmACn6jPUfLmF83lwBOLVFKpaTvYL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoyWqPSKiDqf5o3M6Ag6M4Rv1F2lpwQF9ASKFidwTD8=;
 b=ofdWKOl31wpT83I1iJUDsPGv/Ebks944E97aXDSJxmDudhNeTVAQvSiF6EObKHaeqEfwaSwOLmEFgYi15iPoJY87hZY1tbhgRE3jX3p6j3arLMwVQ5KlYYQzabz3Pm8KDkMSUqPIGJH7DCFgn0p7oS7Q00brDxPuAKW/AbyzhH3enakuknv/Aw1a8crUX6EzWtDKx846EgW0a9KXpFwRc1xhjA/6f6GgQGs6QMLotV3nL1jRrBtVVaXofOYTqij7KCMtn0OegLZORWWuYnRkt0E3jmnuWjOyh6DQzBZjmiPHfcUtif3fTn9vPJaHKPWQ7jpHSOEPEemv9fD/UaVd/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoyWqPSKiDqf5o3M6Ag6M4Rv1F2lpwQF9ASKFidwTD8=;
 b=UdDEyEQ9ZvkgsI5cdprgArTTuugp8VaHjc52rVwgFyUnj+KeX60t3Gy2Yw1i0IiaVZB7nbstdJRv2JnKz6GZufSjIKZjt2aTaQds7qOgauVbWbVijUy+elgNrcaGpfcHT5pv4ZF1En5NgXlJ2PuG/BzdWfDkCMfPvF1pASny5oU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH3PR10MB7715.namprd10.prod.outlook.com (2603:10b6:610:1bd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 20:13:39 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:13:39 +0000
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
Subject: [PATCH v6 02/10] cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
Date: Fri, 26 Jul 2024 13:13:24 -0700
Message-Id: <20240726201332.626395-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726201332.626395-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0062.namprd07.prod.outlook.com
 (2603:10b6:a03:60::39) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH3PR10MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e03474b-c240-4f57-cb47-08dcadaf7052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QklIwywomBQ77HpMIiax+TZT147U/1RLfM1FB035L55pybzICnbMf7zVfd/i?=
 =?us-ascii?Q?ACWQdbJsFL2xny8foh5kV1gBLtvW2An1xRUCfAcceyE6Jc7kbo+3t7CqOJeG?=
 =?us-ascii?Q?ikoXErFrFS9sTWUBzA1Uk+L+LUzw4aW+T8EiiHaiiB7iJKoef9NiOvfmmFEm?=
 =?us-ascii?Q?j5DPHYuwg2I17YWdbATfLfUVO5PLxp/ABQh4yN/b7AuF5/CqOGf6ACD/ytMf?=
 =?us-ascii?Q?hZ6Y7vSzhMJunxESbxFd46Gp5GsukC36bYz8PULgNYUj+lg993tayWIr9ktj?=
 =?us-ascii?Q?nPPiGdWXChw+YGlGrmPh3d3z5sKRIBFUddSIUZ0Zqer3pxTMWxyCxsR1StkO?=
 =?us-ascii?Q?tndAwCIzwP7K1wvQDt0OOtNyzEs2Ss7AfO3YQuYm0Xu4qyrabbDa2PfjjIqt?=
 =?us-ascii?Q?r1PC4LjrjtflLjQC5TjJO/1K76dT5whYAYnZnjRnN0LwuceXDRUeW8ATPo1R?=
 =?us-ascii?Q?DmJjBZqEO8ZPuOpWTYb2SDpSaP/Glxd2lFHI72lSmlvQBbTG+kByqFxIcoIB?=
 =?us-ascii?Q?xahfiZRmbuElp6ztwEbxnrRXJAJC9pC1/EmRr6EXjEUD3PTfHRPzs8ud230S?=
 =?us-ascii?Q?LbtLmRNYngQHUU8II6If7NB6L5pwE+e+UisM9EHPicDvJ7KBpDSF9qTcbXf/?=
 =?us-ascii?Q?IgD00u0oF7ntvUTti33YS2d6sCodBJluZLfyjraxan1LFGPUGeBhHHrciZtt?=
 =?us-ascii?Q?/hYwfLYeHD4bcKMGyFGiTsP1Vsh2REuRRU8rniqvBTw9LvRcrJLkqIOEuPjF?=
 =?us-ascii?Q?7KkHJrzkCFHt8vsujdR0mKzrPC+slQ/W1KzZygirX4pcqxTvJSg6sJjEX1fr?=
 =?us-ascii?Q?bFhhO1qujicGP9IJ4qOMj+MkNs5cq3ZmrE3Ed8ijkS0UEvkiLNfEJLT9ImKg?=
 =?us-ascii?Q?3mPbwUeDG1dKLT2+GrjhZ5M5bmhJ1Uo7ATvhX2apbEPE7yJjrDU3DtGpDz0V?=
 =?us-ascii?Q?L67X3veL4Tb9BX46N/BSeE4Va7Q7WXj5C7zfNGuFpxS1P7m9BAW2zy+WiuCH?=
 =?us-ascii?Q?V+U/RgP0E60iZF6wWcV6d108ErmtNkqsBAiEaBYva1h9k2oCwW4m7L5qnm07?=
 =?us-ascii?Q?nLm0wHze8gAL6itdrIH0uajAri8rH9tnzH/VHHNlUsVL0Nz4rGZh+SYgyKIR?=
 =?us-ascii?Q?f/K35TptiwoxBTOplBjs1uwaJvcYMC8j/oQga71Ix/wZRsZ/5uj+l7YCsSzB?=
 =?us-ascii?Q?PyDrx3e1rTfv2TKheMaH0u3mkHFp76A8m6zD9mmejZhPhaxajS5NypmG1qq+?=
 =?us-ascii?Q?hNbsJAUJ+INhLiP97io0sXbMlmZrwc49vVzwhZeCbnfRkCik0jXkPKHiVQ79?=
 =?us-ascii?Q?m7tZKZiYTh/e1Vtz0cHVPLrq19/HY8+dUaTaCAUjOhgp7g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o7/zw7EgJObKuL6sViXXm6O+dbvDY6G+NWL32hDhIM3nAoY3hA9LPInBWdFf?=
 =?us-ascii?Q?sFHh/wyVAoqu+z2+Epx73QsQTCXs+E5ieJFRF/JQLd33rjzco+gnImwKzu0z?=
 =?us-ascii?Q?PY8nA9By1qJFQ5qM9jFGruNMU6RK1iMw4iOtRTR6BzXTFfV23dVk58aECnLP?=
 =?us-ascii?Q?PYRZ3DEJQP6X2HHQq9FHTreffoQllV8E6/Z+oHUevoVrvABIe9/E8Mte75wc?=
 =?us-ascii?Q?9ngDqK2BAR7Wk1bn3kjNUwpC4zGkxFkoEbJSN8Uwi5/SWjeY5Fri1Ifo7UIk?=
 =?us-ascii?Q?FBVOXBrlCQvSy5Z6GrpcTLSdGQ703I1b1kiZLjlnw4zaIx0samdaSxlo9v9I?=
 =?us-ascii?Q?qx5wn+2ZNDjPcRL4wcJU/5rIi7Ejd+YhX4LOiz3PC6BHpo92cTSyg+6x36HP?=
 =?us-ascii?Q?bhYOldG7epnvzf/HrhO4HsJ+fcZPGJ7L7x6qzyRqDx6kyNMkx5yYyUBWrLzL?=
 =?us-ascii?Q?NlXd7p24gmjzS7fjyoEuPsAOMXdibmoYw1YZh2z3eNA22GE25H9KG2mbyADT?=
 =?us-ascii?Q?VQNJCl2WfrXJ816Ii6QOktDDyN171iboG4xOXRQDCW/g7eIwJRg0lEUUJ1yE?=
 =?us-ascii?Q?gnFqFzcREhItEUCkD9NaqBY6QtCKgG7R/s7tAwy0MbLdITA1CM3rWrI+Qhpn?=
 =?us-ascii?Q?snlBnliMjP+TOBT7zaJNMvCiKUUwR+MZpjOFKA/KMiEItuDQIigKI6O41vSV?=
 =?us-ascii?Q?p5OPj9z9pje/h64tINdwjRNngJkyT8tSJE47hS+QaiWbft0dzJePkRrIUJSz?=
 =?us-ascii?Q?RjE8RtzlNcfyaMUS5D5PVlJQsUIpK1J9LhNkRmgoNFqguWGrwGbLnhtOczaz?=
 =?us-ascii?Q?7g8NOBlpAbEQcyk6TTzFyoaTIlnhht/UP4sUTeBLDBeXcpxZQHRW9exO6tU+?=
 =?us-ascii?Q?TFg58uzql0WCQSmQhCFxHe9dwQ0nVvLleNIUOMUXfbqw/TW/6bgtjxdpqEM4?=
 =?us-ascii?Q?MMEkMXeDsKp/xu/yioV5TPlQKbZwNIYYmaInZJAj/E7hzLW5WnHgXSV8rv7z?=
 =?us-ascii?Q?szMA4lhvlanE8ZY1drELtKVRVNpnF456Rd3Q2/JlSdl8OcTm1n3y+89Pxf95?=
 =?us-ascii?Q?OXc9twuWNRUDvq9sfWfIYQZhclJHJSG28e64yak0inGJfWc2+zVqDKBbXlo8?=
 =?us-ascii?Q?FVx9j57+J6nf0Ry4f9RINlDzw2y/f3BncLuJ8cLWjyhEOhwjSkFB00CPhIdP?=
 =?us-ascii?Q?iDS0LbtYYj5tndAQLHByl8y4931Bee5bB1nyBFwJwDTayZTT5NRXJvGgXkNU?=
 =?us-ascii?Q?lxRsTPD42sasALRWiF4cJk5hrizPNjpjw6vrijrlTZ9dQ5TpJsaEouDfH6F/?=
 =?us-ascii?Q?7Nbi6qDmuuJTzehzqfEnu7Ged1AF25PkzlIeyVkcNtJAPfwKgyn2kRhtWPWD?=
 =?us-ascii?Q?DP/a+MSasdJO7gesDGF7Tz41AegTor7dGeOtAo4C51jkw0OscP1DosoE+mQa?=
 =?us-ascii?Q?puoEfzM3/VhPZeFVfHhXEPj1vcxygI0lcmGKnMybm+k3lXMx+1W5KptyLNNP?=
 =?us-ascii?Q?88sRI+nEqNA9SClWv7JVIxrcnHCObE7uD7YJFOfeTi1NuY06/WWw7VZbdcXZ?=
 =?us-ascii?Q?lR5R03xL7VX/KTIZdqsWBnTvYVhzsvPU65+BMs+88dBTooDiJYwAoT0loQwu?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fsFTWKCKfg68glMWQpqhBloGPqFVkwq8/G24CqjrUTxITimp8dnfxuj12jJyhy4cFVShutA5SuCHSUn1vZJ7qDzL0RjnPYbWAB117nWqZal0C0RixUY8LI5n6LxmUL7I7rcrWdJb2lfVbPTlAKj1fAkJE7bwK27tCGFSXQz6sQxRllu2mkcbJq2jDW+Y//0OlTj0n9cC02jinP5MVu30NBpwCgMtLBMCb05K1LU6LhACHSUWjK18HVwfvr/WwnAgqHMZ+H7XZXYPCuIAT0mUFY9Z1Imgfa1UEITWldvjPm9yhsXAHmG5B5KIv9gOKkzHkr8pjIe099Izutgd9o7/9PqgXp3FrRf329Q/AymQHW8xqhgzk7s+p+vjvx1YZoo+M5Of4LGCC1bfg4ITzjrjr7w4A6BR0oP6hmMgoONB8/RgeVmuLDvY50C741r5TjwZJBCMBTZK9EfpbRUUA10rw2qLIZn5bkCYFiNw4jSSvaAHEMnohV1c6+AnVKDRlp5lDKCIBFBqA2122dv0lpE65I6FKr+nxNE3P22cUtlhj9JaHGdT9eRLl5yKd9QWKGujS45i3TJJBphx9s+maf4MasuvhgEqtN6CFTWZR8yLjxg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e03474b-c240-4f57-cb47-08dcadaf7052
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:13:39.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTNRmD+vxATPskRFDpgnSWDf62bHBEzhRH7eYP6vNAv06eqaqTPCTKSN8zoPJHWpLpPohTVJzjq8oOVw2jajLH1127iO+JpdFvvBpiWuyjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: QxlJRlzr6QLPVBNIDrvH8h8zrd81cvNo
X-Proofpoint-ORIG-GUID: QxlJRlzr6QLPVBNIDrvH8h8zrd81cvNo

ARCH_HAS_CPU_RELAX is defined on architectures that provide an
primitive (via cpu_relax()) that can be used as part of a polling
mechanism -- one that would be cheaper than spinning in a tight
loop.

However, recent changes in poll_idle() mean that a higher level
primitive -- smp_cond_load_relaxed() is used for polling. This would
in-turn use cpu_relax() or an architecture specific implementation.

Accordingly condition the polling drivers on ARCH_HAS_OPTIMIZED_POLL
instead of ARCH_HAS_CPU_RELAX. While at it, make both intel-idle
and cpuidle-haltpoll explicitly depend on ARCH_HAS_CPU_RELAX.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig              | 2 +-
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/cpuidle/Kconfig       | 2 +-
 drivers/cpuidle/Makefile      | 2 +-
 drivers/idle/Kconfig          | 1 +
 include/linux/cpuidle.h       | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d7122a1883e..cf78da2ba8fb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -372,7 +372,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
+config ARCH_HAS_OPTIMIZED_POLL
 	def_bool y
 
 config ARCH_HIBERNATION_POSSIBLE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 831fa4a12159..44096406d65d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -35,7 +35,7 @@
 #include <asm/cpu.h>
 #endif
 
-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL) ? 1 : 0)
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -782,7 +782,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..75f6e176bbc8 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..f29dfd1525b0 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_HAS_OPTIMIZED_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 6707d2539fc4..6f9b1d48fede 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -4,6 +4,7 @@ config INTEL_IDLE
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
+	depends on ARCH_HAS_OPTIMIZED_POLL
 	help
 	  Enable intel_idle, a cpuidle driver that includes knowledge of
 	  native Intel hardware idle features.  The acpi_idle driver
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 3183aeb7f5b4..7e7e58a17b07 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif
 
-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_OPTIMIZED_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}
-- 
2.43.5


