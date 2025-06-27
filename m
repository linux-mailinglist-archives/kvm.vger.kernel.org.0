Return-Path: <kvm+bounces-51032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B54FAEC19D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C440D3BCB46
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 20:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7632ECEB9;
	Fri, 27 Jun 2025 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OXSUt2fx";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CKTcaQl+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD4B283FE5;
	Fri, 27 Jun 2025 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057921; cv=fail; b=hN3se6FZdoghz7l3OUaIQRs7+hP21ZUTrz2FgcZVB0d6EIz4ll+hEPcsrGeOJg4avorVJgD+4PnlDZ4D6J9nZl8Ppe4g9GynU2jCUs+LgyVK3BJhqE8MNKCN95ue1ICMgDUvMH340syaWsOc5RCgBBf6J/Vw4Bs5pWX4rX57KSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057921; c=relaxed/simple;
	bh=6ekc7ZYv2l5PyIfb6uq0GZWcWS51Rcjkwh/FHiAAboc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t2ULDGGNPEasmZpqjQB30MGXkcFG+VT0wl+JBrPUkKgBHt94xtWx3rmuMC2UYFkzdm2xxve5NKyUbQ+Oyfz4uMFMOY0zeeaI5mnUWwp/lM5U7U+Iy8pyNLLLhmPsHcjf+vNv6KUw5P6nBSn0L10y3ZJZA/UiAN7FthdTh9LwXi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OXSUt2fx; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CKTcaQl+ reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55RKvZsf016134;
	Fri, 27 Jun 2025 20:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bU5gAn5x4j+QfvSAHACaT867IzMGtffpZ9emRI6myWc=; b=
	OXSUt2fxb8hAcz7mczpnkqgpeCxxX7GMTOR10wuhq1yqUBNSikgQIsfNAl1KuX99
	YDCKfyZAVy4ymoNYlmG7pPa2dQFZQr1uH7/ZCFbddtxmEOQPJwfruH/PehQTBxVX
	YLaneZQyRN0RIadFk2vJqfIjM0W239Qs4gaZGjI3R5An48ivi94GinW+IuDDsL5d
	syPkdi727XXukE9Gb8I35I/Ravs7Zco4uIO4ig+G9bNkCA2ru1jcPwLx1IhsFrS5
	2vktRkM7fiw868A+Iygsbbsi4JY8Tjl4mZFpsImNNUbG+idmFxyzXUmcIOUlDB5R
	dKLKRDxg90qdVyT6KQadKg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds884q4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 20:58:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55RKVJhp017872;
	Fri, 27 Jun 2025 20:58:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehw1ua3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 20:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SWnRSqOzhBpoUXtUEvYQ8HzkUrwJ46c8Vs69Q3B/dtq6HuxAt04iJy5E/ERGYol4mhNSWgYJRTWMyPuU84F84xa/0b4709PCVqMivPUlZA4/W7IhGY8ywEVE6TPAqueUikEFvsB92/dJnV9n5WnKvbFJkjgPCClbQEzVnekAxYwD6C0YB54ZDKnTHe6/aGiRZi3tf3CPguGmkBKX051Z2W6buBwkugdkmV/gBtREbUt1DSTGzRDAfKeiS9ZXG7dHhnQn5Vya3sv+Fa3BpnoemT3xG8wWskMgDM+2Oit2Gr6YTR8SzmR1Z8W4O6sVtlXUFfWwZagQvtZzKuAVZAZsCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+NXn/HunF4lxS1ltt3fIFMP+8cSG013KyF0Jp8LCyQ=;
 b=FkhbYrstyJ1rlxKEpEjER5/4dHD9jLOSq5hAuJVBnahHQ/n/Q+dBr7bypsyBPuScEVrv/+4uD2iz8zEJ/PpeOtr+eAu5NIsVVnzd0c81QVx5UwlrHb8QBq+UB+uHCyhoWXeChUAOXi9A4T8liJiWrm/wKXXzbw3j9FiIh4POz/W+5o6lUIDusu0kzNSBW0c6RI7SqK/Iv+un3lDCMehbSwTYtriazlVdN7q2Zqt6p9Z1IUut+ZFwQz3YSOgL2j1xMgna2y+rXclFb5fwa2M/z+HQ6MUMaqs1vt0mA+BX98ynU0HJplDSNvl0TB9K7gmxWApbTQa/PpY67i0j6WxesA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+NXn/HunF4lxS1ltt3fIFMP+8cSG013KyF0Jp8LCyQ=;
 b=CKTcaQl+PetjFd0ElyZ8eaUQoFr19aX0ammSzhpudqO1FT8IgoTChkWMqxcSd+op2viuGrJRJPAtOgFwnq97gKin/3TryRsWxekAo7iCnGcWbrskTfAwr6U9R90XujEdW7+VPnoC2LofettM1Hxit6lqh/y0Q90EMT5ZuNWuagk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6028.namprd10.prod.outlook.com (2603:10b6:208:388::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Fri, 27 Jun
 2025 20:58:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 20:58:02 +0000
Date: Fri, 27 Jun 2025 16:57:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        x86@kernel.org, boris.ostrovsky@oracle.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aF8FwqaBpfvQ7dYW@char.us.oracle.com>
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com>
 <67bd4e2f-24a8-49d8-80af-feaca6926e45@intel.com>
 <61df5e77-dfc4-4189-a86d-f1b2cabcac88@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61df5e77-dfc4-4189-a86d-f1b2cabcac88@oracle.com>
X-ClientProxiedBy: PH8PR21CA0017.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d9deb7-3e9c-4d1d-a52d-08ddb5bd4e0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?bGG01rFzY080be2fcRPTCvw8YStvW+NoiiTtpvuKWVG/wG9GjGJ40kVgl2?=
 =?iso-8859-1?Q?cIMJm1+qmgtSfg19EFoVy3kPLPG8f6kvMtcAgTbhCKTVYs5fUjVNw7eVqU?=
 =?iso-8859-1?Q?jjkkfwsxu1S2nf3+gF+uWCY1x+hZSuBWAaQoAVK/YfsbqU1ev+SeXJ5sF9?=
 =?iso-8859-1?Q?L9laxoTxUkoGr2YgV5mGnghWy+AFLNkEHBQSgbIFIRaRwyo4g5wpfsxWQ5?=
 =?iso-8859-1?Q?DctOeUzcNqZIS7PgYYQM8ihpuJcL7Nu0hftoAZcwMz/TIE0/m5YACix9+F?=
 =?iso-8859-1?Q?A5aKl2gLwlF2CqC6KCSCTJYzVt1MiaNUTOHPYcSOmSQfniJur4/LA8lHdz?=
 =?iso-8859-1?Q?DRBZsZj8ISArz8fEaO5NWNfifFoIiRZqB5ZFxEHwQQRJ9fHXnHKzSOsIw7?=
 =?iso-8859-1?Q?R+RRdiT/QypJQwGdQebfKCEV1XdzKqUyWA7neSyk64tdbjLo+ASYIWadxt?=
 =?iso-8859-1?Q?pJZZLKcJaod96we8nLco5R1GFAYKocKXhsry/o9u/vCRm37tJPLMASCw22?=
 =?iso-8859-1?Q?9mxnVS0jRI+i8bkQozxCQJl4+nppBphQ/s6rb/JpMS9ooS6TYnkHph63Qu?=
 =?iso-8859-1?Q?rBINLH/kpYs6mkHEWcjvo8/kWYLEKgWF9vpJibcw1kJcJD7JwhdACiPA4A?=
 =?iso-8859-1?Q?ecAMwyJZgGjObETazXI6leaI2GWfX7lun2KkH7UeXGTCipLf+ZlY5XjQkY?=
 =?iso-8859-1?Q?C3M0Y1Wy+WD+adF1AH1BeneGX1Ktpx5oFZbQbl6lDlObHdpKG5bK7UjEpk?=
 =?iso-8859-1?Q?P1pSoFnL+lfb93H90yEyyohVGOKqWW84+uTUZXvGuKGjOWfWP4TKCSSfuK?=
 =?iso-8859-1?Q?xFMZlLOWTrGks+vTtiMuA8g3632K7cPNGcYr1NbH4zlyE7fkXjID8DHRuv?=
 =?iso-8859-1?Q?X6kEygRJ0Gids3QrzGW3QqOnv5bP9K4q0EPSU4JQJSbdUQRj6Cecllp4zK?=
 =?iso-8859-1?Q?mRYqkW+c+vLmblqwsSlaHHmYoxFiB94BkQfPpkxhmT9Eb1xA+3aOK0EiIQ?=
 =?iso-8859-1?Q?9gqOmN3M20qCzArrdQnPzRECcR5o3wbIZ7SNowxSmDfVNwcaMih/pJhw79?=
 =?iso-8859-1?Q?NeTaXDeJAOH0i6h7dHt+8p2vUp5RdPdxHuD6Ke3Q1SQL/JMRekPxHrxWoI?=
 =?iso-8859-1?Q?2u24zl88ZmM+RMT8+FBEuC+9bbKaHdLkRn1ushfxXDb1bSC/AOSxb8ld13?=
 =?iso-8859-1?Q?6PEsn3LmYr4USGGHqxA16fMfZAI9J3sEUvFjwhicyX9ZsXkP6WiHHStSMW?=
 =?iso-8859-1?Q?se8eYNXeyrvAuVFVSxGP9l2bMw84bXh4WL1T40YiCYTyqG9xpP3PLIx8+/?=
 =?iso-8859-1?Q?z1rvbQNY58mPThxF6Edm8GuFKIEcHvI0JaXcvA0MlEXJ72pTqEn7NRzQ3Z?=
 =?iso-8859-1?Q?+CxRUi/jzyRlJtocS9ZASO5rwUeGdQ6T3JE2jT/IjIv26hJDidHTbPvtgo?=
 =?iso-8859-1?Q?MqUgorOzS4r1HWFZdlUwZHhCUCmryKK+zmat7x8u57W7FzT+5gG6FA37Xx?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?cw4vp1K5esem024NL7hHBDQlqLYdeokUw+Gm3tyvSrb2rSZGCnWKNVk5VM?=
 =?iso-8859-1?Q?8AA/7A/fbMHsvf3O//JeyrtoD0GVWXrXOdUS7n27usM2uKQ3J1K1zzXpSs?=
 =?iso-8859-1?Q?SSCz1/FOEP26ohs42Q0xS5q70+TA1K3jhdUSqQbqI13XgjEPCRJ6dEo7XU?=
 =?iso-8859-1?Q?DIIejiKdI5Kg5mkZhS57GRI+Fj//Dom68Xydn44DTgrQwG3Xg5nuDqswgM?=
 =?iso-8859-1?Q?/227sN4V1uts9wdne3IAyB5yt1EplffkqH8hIYegoUXRlEZoMYaBp6zlnE?=
 =?iso-8859-1?Q?6rO89UT6Zdr4Grt6SmslxvmFsIM0iP3xBXtyL1xwXwsyUa02Wtrfq8FKYg?=
 =?iso-8859-1?Q?U5r2LfxE8P4oFTHFIkQb8UrBYTXqr4WmWQoo9oLVTnQj9YxN+aPGLhrS8M?=
 =?iso-8859-1?Q?sFY2nrtbIIjaUjZH5j6OKHLlTQzdvJ/bQsgLQia5W6+kHz1clJkBBrgN3T?=
 =?iso-8859-1?Q?DoSoiSD1Kv48OEu6ct8PDRV5THGsIV8cOfcsKtd+gg+jcHg624pFZDcgYH?=
 =?iso-8859-1?Q?eIyRJFTDWQxCOYOY1DYqLxgkKgx7MkoTmxMATSEMm+nDgzTBHwEdU6dAf7?=
 =?iso-8859-1?Q?90VLiMC0SXQRcjjyEsB200Rtn1DmtoY+HjGrK3rlrX2K+OlyC4K6pnpwTq?=
 =?iso-8859-1?Q?mPJszeMCffWLWb3uzlOLLO6B13+vRwWXt4MdJtUAwUkscheLgEec8tnD+P?=
 =?iso-8859-1?Q?9Zg+sqC0Mg0KgaHReGH5yNsQS34juVytU+QY6GbZeSa01A4yTuv+Easvum?=
 =?iso-8859-1?Q?E6kLd1JXtItbM8B00/zQbxG6ZILLkhV8PGUl2pzD2XTtSPJjPJtMnG6fK5?=
 =?iso-8859-1?Q?b/IS2A/ICi0+do5Gm1eT1bESwILTvm/by2zu0y4z8GuF+UHD1fUo1iRZfF?=
 =?iso-8859-1?Q?UWCxkMxXGkgPtrm/7ROF8Zt6HTKFt/vvSzIkxqSIkW7BL9sI4SDRm06hYL?=
 =?iso-8859-1?Q?aUJjgJpZE+gsqweMs0xvh72ZWXeyzU1mV7LtwP39alg2BSWbh0Y+BpV1zQ?=
 =?iso-8859-1?Q?Nfy8Obxm6/fr6NXi+DrZmM3ctrG4u2udr9ttZ/Rqi2mT8N8G54DSzYitJ2?=
 =?iso-8859-1?Q?d5cEM5cbsqvtG2E0idIEnp3GO74z66quf2gwfnpABcZ2wW06qU7qxgKeeo?=
 =?iso-8859-1?Q?Q0Kt8rd+AMUpMu8Mr/AtBLKYO+EapMn7d75q7UHVl7slc9v6zrgfBpcuqJ?=
 =?iso-8859-1?Q?C9hlj6rLvM9D/NjZg6mxHcDJSF3DFsT9a9aEiIbpwr6bT+27Toiz+XDfv3?=
 =?iso-8859-1?Q?VX9lRSMa6JDtOWWImaOxaY1wHtuADhQnYl2pOh9WmWFhZ0ebg9aZpojjGx?=
 =?iso-8859-1?Q?ZfLLFsHawEPByu4FMpKf3YrUeM/Q0RgLB1RuL8YXqSGWwUQ+z5Mu/N9xQ9?=
 =?iso-8859-1?Q?GaENi7ebNNa5JBR8kQsgTgqJ/T11DCyMUY+J6IO2DbGjfvevlbuL4Ie+K+?=
 =?iso-8859-1?Q?ZUPZXOJt5Do7JgIHp/OQflH6Yevr9TYmRIaydZuw6PnmlTMPfzKxqZFV3U?=
 =?iso-8859-1?Q?6oJqQZ0fzxlRBosZU4nn9UajADi/ZtRDKmjoJbbP1akzOhe81d0e0SgJzc?=
 =?iso-8859-1?Q?6xKFJL7ZaAmcXd39uKiD4PuMMzP5go0Fm9weWMRz7F1PDqYHU+h8CrJHm3?=
 =?iso-8859-1?Q?5rdmUfe5pqUddsibz3Xp3zPOwpwQEkrmLB88rEx6yN4qjJnNAqe5S5iQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W+l+cddvCdJJeMro5dfMmuMJKL7RxiZk0grIossqJI6YVU3oIWZuBLDgS5gLz9QIEHh2AnYvR+hNxDBpXxkeM1e/PTfYJcqIySj4chRgVajx4H+K8xPqAQOc3pHeadXj0muC+OBDgzaJbEK4N2jMW/0LgOcEx6gCJ6ioLe05W4+TogPnAGk0lgYauEsDpTfmaJBjYcE+6u/QfcTeCMQxpZOLehPlhzdR7a40/LFsc0+Oj44Ydbo4nkpKF0qwVPFVWwHk/XRR1hs9u0NJLcDX79sHiY6M+ZlCJfTazzt3iPl4Dv+3wuO60KmxcHf7hRP3W8UloUuy74k+4V0Cwo/YOLwEaN529mF5Cy6Ufyl2C6bhEB/J8btBkAd/TgvZq+rqQizTqYsCMu+Z2oSUylCoi9fDy10ys+TN1zNYbFDMGDheY4TmI7awq3d8TpXgYVfRqUxECp5R+q7T2wGzt93WQ6J2exevkAEKOMaK5SRIvNrMoTiG2N9YPTRzL6QWLsvFHVSrZ+53HFJyFMJ3oUUjq66gYY78VxJdf1Gx0UCh0xUXNiKVNB13MQr3jYPvV4WMepI+hbxEsqi5JXs0fgdQw9krvJl/KGd3dHVqG9DlIBg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d9deb7-3e9c-4d1d-a52d-08ddb5bd4e0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 20:58:02.0830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZgl/M+vvHavmxlY8UUxHLZgAzATRzvKTLCW7BHSaXDTaPSBVjOgsQ1Rq+2lEonUDGJW4vutXWZ5UEHkNNSkbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6028
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_05,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506270170
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=685f05f7 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=CM8ZFXFThYBCFr_Gz0EA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 cc=ntf awl=host:14723
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDE3MCBTYWx0ZWRfX6UjYtH0SlptZ Z8S0W1F/+VuXjhTBlgPWB5oUOyH2lU2mawDU6nxfQzwVj6h5deJDNPyYN3svMnlrHSgUa42FXje KupEPbnj41Llcy7VbwaFIkiZqUR8vgeofwH0zwGNE+9djfLKzWylpTPj+ZMCLMi7SQCWV39NyZ5
 O4l4YdpStD4r9y+fu3PU9ChNXuYoBqCyUI5vJdDhtHGeeFMfLiyq76MUxQzCJrZ9gLAke17qA6X eo31RU7kllr9cIG4InL0yc78ofH9SuesNgy1cG4TP8VJRUC2gPMXEM9pIS9dg9l/v5tw+JISlL8 LB318E5Deg3C4AVqIgJDRKRdm21fLnsNwhJVn4rS5yHjagfKUDy+HT1ZCGGWmfgEqY028c3CwDw
 g17LNLSimgZk1u9L88yrcNkwBeWdIlMqcHS4XayY7/hAzny7v24wVCQzFEdIzxgtZvzj8jU7
X-Proofpoint-GUID: Fcz37P5AccWB0EBgXfRf9OlTDGIj9gk4
X-Proofpoint-ORIG-GUID: Fcz37P5AccWB0EBgXfRf9OlTDGIj9gk4

On Fri, Jun 27, 2025 at 08:23:52AM +0200, Alexandre Chartre wrote:
> 
> On 6/27/25 07:41, Xiaoyao Li wrote:
> > On 6/26/2025 10:02 PM, Sean Christopherson wrote:
> > > +Jim
> > > 
> > > For the scope, "KVM: x86:"
> > > 
> > > On Thu, Jun 26, 2025, Alexandre Chartre wrote:
> > > > KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
> > > > However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
> > > > so it makes no sense to emulate it on AMD.
> > > > 
> > > > The AMD documentation specifies that this MSR is not defined on
> > > > the AMD architecture. So emulating this MSR on AMD can even cause
> > > > issues (like Windows BSOD) as the guest OS might not expect this
> > > > MSR to exist on such architecture.
> > > > 
> > > > Signed-off-by: Alexandre Chartre<alexandre.chartre@oracle.com>
> > > > ---
> > > > 
> > > > A similar patch was submitted some years ago but it looks like it felt
> > > > through the cracks:
> > > > https://lore.kernel.org/kvm/20190307093143.77182-1- xiaoyao.li@linux.intel.com/
> > > It didn't fall through the cracks, we deliberately elected to emulate the MSR in
> > > common code so that KVM's advertised CPUID support would match KVM's emulation.
> > > 
> > >    On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
> > >    > On 07/03/19 18:37, Sean Christopherson wrote:
> > >    > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
> > >    > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
> > >    > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
> > >    > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
> > >    > > >
> > >    > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
> > >    > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
> > >    > > > for vmx, and moves the related handling to vmx related files.
> > >    > >
> > >    > > What about emulating the MSR on an AMD host for testing purpsoes?  It
> > >    > > might be a useful way for someone without Intel hardware to test spectre
> > >    > > related flows.
> > >    > >
> > >    > > In other words, an alternative to restricting emulation of the MSR to
> > >    > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
> > >    > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
> > >    > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
> > >    > > RDMSR will naturally #GP fault if userspace passes through the host's
> > >    > > CPUID on a non-Intel system.
> > >    >
> > >    > This is also better because it wouldn't change the guest ABI for AMD
> > >    > processors.  Dropping CPUID flags is generally not a good idea.
> > >    >
> > >    > Paolo
> > > 
> > > I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
> > > but Paolo's point about not changing ABI for existing setups still stands.  This
> > > has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
> > > MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
> > > enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
> > > IA32_ARCH_CAPABILITIES is always supported").
> > > 
> > > And it's not like KVM is forcing userspace to enumerate support for
> > > ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
> > > while I completely agree KVM's behavior is odd and annoying for userspace to deal
> > > with, this is probably something that should be addressed in userspace.
> > > 
> > > > I am resurecting this change because some recent Windows updates (like OS Build
> > > > 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
> > > > just because the ARCH_CAPABILITIES is available.
> > 
> > Isn't it the Windows bugs? I think it is incorrect to assume AMD will never implement ARCH_CAPABILITIES.
> > 
> 
> Yes, although on one hand they are just following the current AMD specification which
> says that ARCH_CAPABILITIES is not defined on AMD cpus; but on the other hand they are
> breaking a 6+ years behavior. So it might be nice if we could prevent such an issue in
> the future.

Hi Sean,

Part of the virtualization stack is to lie accurately and in this case
KVM is doing it incorrectly. Not fixing it b/c of it being for 7 years
in and being part of an ABI but saying it should be fixed in QEMU sounds
like you agree technically, but are constrained by a policy.

N.B.  Also the TSC deadline MSR is advertised yet AMD does not support
it.

Looping in Linus here. Linus, thoughts?
> 
> Note that a Windows update preview has just been released with a fix (OS Build 26100.4484),
> but the Windows automatic update will still install the version with the issue at the moment
> (automatic update doesn't install preview).
> 
> alex.
> 

