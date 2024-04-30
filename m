Return-Path: <kvm+bounces-16254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D338B7FDB
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA9A4281C5D
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984F81A0B06;
	Tue, 30 Apr 2024 18:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GQ2RK8K3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jbg5aqC3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1B01802CD;
	Tue, 30 Apr 2024 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502310; cv=fail; b=ldeYikuk3F9zGZO13hMUjZBW3atiVDfoDJ1eHnwxPPyO1nkqpPy/rSy3ADlFiKODBIWfYny7Ebi5pBxUKB/VS57ohNvhPMqNk2uZcavdnVBCMyv9drgzYktCDr1I+BTIJddSRURQP2UTa/FFGbEkhZAqgystBMn1qVqV5exh30I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502310; c=relaxed/simple;
	bh=zm32768gLL3hsQ1Irr21aBvcCBFahcMPqBzvHOlAx9U=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tJZnfuNGVSd8kYsfDSvpTwBpetI46Z62j3TyJWM9bEkEB5IllQWIICXaE36xcguPyJyY63DMtxEmUFtbOLNLTCKqB+5WHSRptq0xVQk4xLu66x4Nso13Ndpwg/WvR7Hx50UQrSB2/tcqZffKMDakDi/NQVhw1OW2JO6V2gXBuC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GQ2RK8K3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jbg5aqC3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHILek008971;
	Tue, 30 Apr 2024 18:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=cmjgbIlnxfv3DU8/l1cY164bKr/GTbhwMxnzzbg/u7w=;
 b=GQ2RK8K3yALUZArE3Z7RdmrlVbhnIoq461hzOfYwkPEQdB6Ej1luPAe0SwDa69ZIfJFj
 6jMN5Ce5o2rzfZ3HfkN3Jz98ha6V+o6MQUfIdudJUJET5foFCcBrhK00A+BIEyAHqFba
 c7X8AuTnR9YNZy/NnB9Av2N91SaKcRGb4WjE8MMqrqDmp9/4wTgWdJfoBW/pSj2kVLsE
 ioglBW0GaxMfz7Fx/wM7d0Rt0V6SiFujnZgCSCNbWpjw+HAt+K/TLokztVJpBjGxMyf5
 Y5C7iYQXZHIMB5Q7aS6KBdjHBZOY5TokCEXm132+hPPn3wnImIgABr1uDhwQjhuJm7K1 Ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsdentsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHdbKd033207;
	Tue, 30 Apr 2024 18:37:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt84r21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WT7zhHHOMNVGoMRiuC9SrATzINIKZy1YqCdbLOSc8u2Jnz/mKketiC6RTLz0WOzX+nAHHDcp71C6IqxkdyPYfOXxEGi38VREFuSrRNcoTeA1yoG2qWStA4SpFu/R4W+F8EsA+4u/45uruc7/2U/Nn04cceWZndHk2uBzs7kW2ZXaqGxNYZnLRgw70LoAoF8iSZiriS6eaqFwQYkQd44lmdw30hd8mD5orExiZMhBPKao+HoGnn6hzwXxuEmFbPrcl5R24e/Xmr4DwAq0FFH6bk0AP7+WK9KbI4ZCt2UN2emq6hLWfJobACF67KppDZLRCAhstiEwVn7YMXYWdjw9ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmjgbIlnxfv3DU8/l1cY164bKr/GTbhwMxnzzbg/u7w=;
 b=MF/5CO1kMkB2kd3Epvy4s5lGGMeY5Ec6S5+I4J3vPmyR7xvuHNZyewZe55fZCPevJhArKzPOkkRcoSSV1ZyuX7QXtTsPs405xRBH+K2tRJ2z5eiBVvX0qDDmoYB1HmAg7CkmXqV7Cfxx+oBzULfJlDA1ixJ7aPzs6jJDQHRYuY02jcnY9tZQo8pJVBjgN/UC8RK/wO6wVculJ0Q/UD+Lc3urSnaf9Lf4jyzYHLriuh79oXtXllfa12U4XRZxz1EjWaI9zqQPQJjlG4bapKbf1P7VwIimMiVc36NTBkEvRvnFnv58/R9dLj3M+PJFHhJHeZgLWQvHRWVsmLtymzwBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmjgbIlnxfv3DU8/l1cY164bKr/GTbhwMxnzzbg/u7w=;
 b=jbg5aqC3ovIKKgvxI4VtUyEKGGIm4K8VlVKBzyu9osLtGBo/lziS5ZjhsREK8LdmHCTj/0MMoi1eJmai/D8v5WwmrjpVCkC17FJsGLli/WWjMF3BvBIyr0lHi0RHRfvhOjmbdSsni5VYpKztvdRNCP895c9K+0JtcbUuA5gVDeo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB6152.namprd10.prod.outlook.com (2603:10b6:8:c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25; Tue, 30 Apr
 2024 18:37:32 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:32 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 0/9] Enable haltpoll for arm64
Date: Tue, 30 Apr 2024 11:37:21 -0700
Message-Id: <20240430183730.561960-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0145.namprd04.prod.outlook.com
 (2603:10b6:303:84::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: e940f45f-36b6-4d27-5d8c-08dc6944991f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ftuaPfQ3ji5pEsGoc0vspCGR+UQt3sO9gfVEnk4Jnfb6VdxyvRaVGPR96w4l?=
 =?us-ascii?Q?pQUy5urt7Uo6Z2NsZYpM+O4rwfQiGb/X0Q4tyZevR90kmIr2mBEVD+9rJLT9?=
 =?us-ascii?Q?L61DK4ejajnn3BTQg38iTeDTEh1wWbOZkhHUbDGlw3/hPJxraZRkZDOusWkh?=
 =?us-ascii?Q?9OniEebWjT37/4K0e2Cuew6zrW8gmdf/AYnGjsiOo6qL+Dp1nMGSstXdVPVq?=
 =?us-ascii?Q?Is+13Bakz9tDhg1VFjjnT2qPqZr9G38vImUKL00LBUlgXcgrkR0OPgxh4pUs?=
 =?us-ascii?Q?pZ8PWCLEq0Mi/wd2f7TfeSBr8eqQD4UuP3+BMUXd2cp5BZbxpxbhNT0IaTEI?=
 =?us-ascii?Q?2nfsp/Ff6iq7XQSC2/XaZct4yujfPEs7Y7phATLfEcNIDp36882HF9evROCQ?=
 =?us-ascii?Q?ME9zon0WwYkpNcQgCQx7ie1u/9z3x1UhyxEFMbMV3VGkXNMKo4idENRFGUrC?=
 =?us-ascii?Q?EsunjohD4vXp/l1piLLo6+gRugAE+eGsHYbwTPo0NF0QCSV4WiYqwiENSFU0?=
 =?us-ascii?Q?U5OmeFRBdc4hHIPRofoZsi7U1rgzENRYeiSvrfY+6vkxuQq9r6fuqA9xTBK4?=
 =?us-ascii?Q?gosQIMK3RRsXxKzS2vS15aoM8Y+6GZ6bOT9J4QFRkmFUqUPxHWWXe715BHvs?=
 =?us-ascii?Q?wQ48UIUji0TCWj7nwXIi2wRveUuAtviLEm4Tbw8R8Ol/esGnQZk700A7iVsy?=
 =?us-ascii?Q?yvyoytTuhh/l3wz36/BFD+T1Z2oYMtUzOq9/UKTfm2rj1ObnRRR6qskIfGsO?=
 =?us-ascii?Q?8RHkqHlFKl+NFxXYfuLFZNu/o53Z63KzI0xVIksivkrO2O+1v4Xpq356K+tm?=
 =?us-ascii?Q?i34YjzA3m2FQ78pMOf9k5PBDyQeaJN6qyyFN9boDGWhzG5EGiTbNQDTRtJBB?=
 =?us-ascii?Q?T1TMlXVzckVcSgK+59+vSTCcH/PhBbl7dClHl7K2Ky5ePLN0IewHU/M9BDEV?=
 =?us-ascii?Q?lm+yV+F1uV7qxC6bAemPAxd9EgElJ27IweJddizQhtolTi25GKkn7GRvykzU?=
 =?us-ascii?Q?kz4xFh8SqtA09pppLiRLQFzMt7xzEAmsyUbor5he0GL1HC942EcOW5BM1Ezr?=
 =?us-ascii?Q?jctyXRe6IqrLEeHPwevzZY/ep+ikds3psFF1V/gLsc/kv2sWBerRcugH/gUx?=
 =?us-ascii?Q?tUmPdh+iBcIkGfa8W4U89oXGDKlIZEjFoc3C50V0AWRtueFLhmCZG4Ci/oQY?=
 =?us-ascii?Q?X1YtIzL/ESWt3jUSzsRFFPskTaZGWNDlTx4CCS0elIFwItQq5MJKUgWDufX/?=
 =?us-ascii?Q?chZ8Z7jit31R/EZu9CFVyK9cs2OsZOzTZR5qk1e2Dw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4k8G4udiBoHd/SA5Yln7nFmq8Xh7gqhkqMQbuZLLlNaze4nVu7PI7K7UTXNi?=
 =?us-ascii?Q?DJTYVWyfWminQRja1Z7ecNWebgGZhvSW90gQx+on+AbRC2+mSd7mzG/jOjV6?=
 =?us-ascii?Q?yyYBmB3ei6M2MVpDoosHZQItHKBO37MPhRPO3tmtDJtXAnijs3HZ1j1FL4b3?=
 =?us-ascii?Q?xsBrKR7P2MAL6XclQj1pkI2BwbwPPrJ3l1twALMbc+UbYqTsWQHlUO6LhvXw?=
 =?us-ascii?Q?hrLNfwJD89Z3tkwWOE44XMwf3aNyMdSorlHvaHZ/0zpb3eFf22w5y6WyO/tl?=
 =?us-ascii?Q?xaCWcXL0OgCwH9/fi21gH9/EvLHPCkC6wYxkY7nwS9w4//w5lmAFhAg4vC2t?=
 =?us-ascii?Q?HMSt8IUTNqYsyLUsCb9a58Ox6Ve56Fyy1YNW9lWq2UeHsG6gPX3RetyW+ONu?=
 =?us-ascii?Q?ezXdCKwUtMUyprBTRE4506psVb37DhVEwLslMVv4Wxq6DMpzJUEMFeKL5XwR?=
 =?us-ascii?Q?u6I+P6Oaf9KIpUBtiawPkO3nl6x39v6ST81SVXyvgquP5ocsPHFNlUPcMJPL?=
 =?us-ascii?Q?B/Q6K/jWuHS9I54cnxSYkMX+IVSGMMh4zDwg58hY6UD2mkSmAzU+eVrcMD7R?=
 =?us-ascii?Q?g6oeUKNzwD4zZO17cQhgiY8RR8LRHyQUqKANNvQfrsX/sKsb8wPPyGNOh9G0?=
 =?us-ascii?Q?bmeEVSImS/NN70qIEgmNlCwcLxDS0eIBu4N8aCz+w1ITVD+3kBbWdafpxAuV?=
 =?us-ascii?Q?Oe2F3ohGx0oSQJWGYfym7xRqZLXJYulhVICECSCKy0KUMIqr5c2030hrqVyq?=
 =?us-ascii?Q?I7zmlaGqQLo27rgRpuejmAOfenfZu7pR819mSuodXylzfe7K0EvWYKDOHEAo?=
 =?us-ascii?Q?UWWseuYoo9kdRze8ZDoANCiaGEdNGO9J5JHi4UJlyKNbQnDKUO7SiVa1uuC4?=
 =?us-ascii?Q?HyKcCxMffsKqwqv9GHNEUNsBXk09WmOLWRBWPPCHPzxdp7UhnDG/Vf/tu7Xs?=
 =?us-ascii?Q?TF0BxBEajP18qFC4XTVJ+JdiT+lNr87EtMco8PAsB0HP0xxeA1v9bzOAZFFb?=
 =?us-ascii?Q?hKXOiIRl0D6r8o18r/868Nq2uYtyXQUlXpCWJdJIwZ0krFpv/st9HuyUbxnG?=
 =?us-ascii?Q?zt+YuNFf5irrC+SCVO2GXNgRn/GPWJon4upAEISacoJcoqippYmKXaABqzeZ?=
 =?us-ascii?Q?wAoYValSSdwAk+sLbv1enDu+sSYJQjP9Pc+qZFfPxsAu/zwpkltYPJfIhIMp?=
 =?us-ascii?Q?GBOQRNX9Elo8rpIWeoaZbpj5DN+WVCM2IK7suMd3osDX6uOGRJ1gq3xaf179?=
 =?us-ascii?Q?UF8UfzH8tW4kwFIgPYEBewpRyxRqAUHBUQ9tALsDaEfiz0Ko+D/lOGHtLhh3?=
 =?us-ascii?Q?SoGDXv6/aRwh0VvRO8JNTGQOh86OPMtPhP6RxmXOhB21MzuCr7NXeR2bOpqU?=
 =?us-ascii?Q?SatQyeO+1Nk3hPtb6c369WexcqK5DlFPlPQubGKSdgCM3bMU9l3N8nxevPcE?=
 =?us-ascii?Q?hFDvfpKJnbT7Grc0XRl/qbjLFnPtXiS093aYKsol8m/2G6zvbfgDZODo2ZZA?=
 =?us-ascii?Q?DcZn7714cv5VOlPM+VDxPOFNaAsJaP3dqr7U69peHK5hPyhWlJLSLN/XFEJz?=
 =?us-ascii?Q?G7RS9htk5uUZIXMyufx/2jrw4gUxtOgXRg0pqb+XwQ2tcB7mRACyopknQ6oo?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0+TGeZEXwlQbzee6pdXdfdUd955YTUAEkXPxGF51USJzY2qsRGgwbdUq0p07C6+Ej/4FQnpD4UW6RRcw3q05wVXEmbusXpPW4B42XHB4YEYpL55yByC32+jCHPADJY3rlErZ4tanE8pWnuiZUZA9LY/g+R8AkC4LTflGsGvXBRcj4MHQBzFwryuHV/YwaEN7x3tDJlOKih+bhm4dzH9UJNmbKOzSWuAyEfyvZVuIiOE0SHN9hg+wQq7c03r+6PoBKcWTzZtW0OqfoQ6hOdAEzvcCuc1V89KjAxjUc9GEE8cC9XCe+MAReUAjvxxzwxuGetfekGnysy3R9Lg5Ndv1q9eHmWUGYfo9UAxaU0Hl+2l3/C9Ew01m6n+LJnn0Td+Tv0XM5jXzPQ27/RrG/1z95TyiN03NVrrjRZPcuBX+kfJTtqZ+r52x+k6jj1BCEgFsphABgo3GeGCEXxJD99YEI/jz2Su7h0yMlwESuCOV3vI7O+5vuE2LuQ+Gif1xDaC+7lb1lXnCqKB1RHMmhSSR7rx8X3JJ2GpvYAgdd+AkKkw2FTEhFttR3IPGrRFnE38McgzLOZ9YpsPTJSJTw61rS3F7mfPZLwn4zvnbwTC8dyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e940f45f-36b6-4d27-5d8c-08dc6944991f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:32.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plPaDplt9X7tt3dy4sVoigY94+5yWb3P3JvvuUrilod8mg0g81fzU0spaxLlMig+vAIDTiF9+7W09VuhtKxM6XQ0s4rdGRt0ZXLcicFsn5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300134
X-Proofpoint-GUID: Ld_R-H3Z8LDNpnNnZiR0a7hr3sJtQDm8
X-Proofpoint-ORIG-GUID: Ld_R-H3Z8LDNpnNnZiR0a7hr3sJtQDm8

This patchset enables the cpuidle-haltpoll driver and its namesake
governor on arm64. This is specifically interesting for KVM guests by
reducing the IPC latencies.

Comparing idle switching latencies on an arm64 KVM guest with 
perf bench sched pipe:

                                     usecs/op       %stdev   

  no haltpoll (baseline)               13.48       +-  5.19%
  with haltpoll                         6.84       +- 22.07%


No change in performance for a similar test on x86:

                                     usecs/op        %stdev   

  haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
  haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%

Both sets of tests were on otherwise idle systems with guest VCPUs
pinned to specific PCPUs. One reason for the higher stdev on arm64
is that trapping of the WFE instruction by the host KVM is contingent
on the number of tasks on the runqueue.


The patch series is organized in four parts: 
 - patches 1, 2 mangle the config option ARCH_HAS_CPU_RELAX, renaming
   and moving it from x86 to common architectural code.
 - next, patches 3-5, reorganize the haltpoll selection and init logic
   to allow architecture code to select it. 
 - patch 6, reorganizes the poll_idle() loop, switching from using
   cpu_relax() directly to smp_cond_load_relaxed().
 - and finally, patches 7-9, add the bits for arm64 support.

What is still missing: this series largely completes the haltpoll side
of functionality for arm64. There are, however, a few related areas
that still need to be threshed out:

 - WFET support: WFE on arm64 does not guarantee that poll_idle()
   would terminate in halt_poll_ns. Using WFET would address this.
 - KVM_NO_POLL support on arm64
 - KVM TWED support on arm64: allow the host to limit time spent in
   WFE.


Changelog:

v5:
 - rework the poll_idle() loop around smp_cond_load_relaxed() (review
   comment from Tomohiro Misono.)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
   arm64 now depends on the event-stream being enabled.
 - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
 - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.

v4 changes from v3:
 - change 7/8 per Rafael input: drop the parens and use ret for the final check
 - add 8/8 which renames the guard for building poll_state

v3 changes from v2:
 - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
 - add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
 - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
   (this improves by 50% at least the CPU cycles consumed in the tests above:
   10,716,881,137 now vs 14,503,014,257 before)
 - removed the ifdef from patch 1 per RafaelW

Ankur Arora (4):
  cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
  cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
  arm64: support cpuidle-haltpoll
  cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64

Joao Martins (4):
  Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
  cpuidle-haltpoll: define arch_haltpoll_supported()
  governors/haltpoll: drop kvm_para_available() check
  arm64: define TIF_POLLING_NRFLAG

Mihai Carabas (1):
  cpuidle/poll_state: poll via smp_cond_load_relaxed()

 arch/Kconfig                              |  3 +++
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 21 +++++++++++++++++++++
 arch/arm64/include/asm/thread_info.h      |  2 ++
 arch/x86/Kconfig                          |  4 +---
 arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
 arch/x86/kernel/kvm.c                     | 10 ++++++++++
 drivers/acpi/processor_idle.c             |  4 ++--
 drivers/cpuidle/Kconfig                   |  5 ++---
 drivers/cpuidle/Makefile                  |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c        |  9 ++-------
 drivers/cpuidle/governors/haltpoll.c      |  6 +-----
 drivers/cpuidle/poll_state.c              | 21 ++++++++++++++++-----
 drivers/idle/Kconfig                      |  1 +
 include/linux/cpuidle.h                   |  2 +-
 include/linux/cpuidle_haltpoll.h          |  5 +++++
 16 files changed, 79 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

-- 
2.39.3


