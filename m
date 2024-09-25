Return-Path: <kvm+bounces-27511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 948F3986995
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 228601F279BF
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDB71ABEC0;
	Wed, 25 Sep 2024 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pr1y1kUe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UmoxVms8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473991A4B6B;
	Wed, 25 Sep 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306737; cv=fail; b=Ld8ae3xw0IO15YDZ6yUQsfekMXBX4FH4ZA/JErck1xZep8RDY15elM8IymwFGIKa7tZ3j5JlU3w//SvEMO//foWXkAv6wjIc9zr0cauoY6/IJabTDR+n/rg3WkhnmcSwi5KeYdGQAwVsaNS2TlNcbvZ3VpYzj6B5/WvdSD617FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306737; c=relaxed/simple;
	bh=DVVhYd/WrhOtb8aUDHlylIdNS9AATp/2thz35KUD9e4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aibKHmsGEVmQMJaLHqbDWDMvNIff/OGZX0DBtoa4Y/PJOrfXnUhZInQEnH7ur71+MVtMgAsAjyzQDEwZsWE3uV1nW4h/+zHsUwnIHoHgycvuuVPSuiUavYoNHa1fsJZczHIVp2EI78FCs+RE/5bKoQ7C6Fo53xmtMDEItonZGM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Pr1y1kUe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UmoxVms8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLn46Z024321;
	Wed, 25 Sep 2024 23:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=; b=
	Pr1y1kUePTVu1zdOIuAz1oaJ81dwIauchT2pIk3fVThwJzWXp8UWj4ogY9DLNfKD
	ZrzmRSVpYOsPI3iT0GJP0JrIaPpPd98q3qmfontlUDaSqNw5PKplbwvvsaIvAJuE
	dMezpE8s3RD39lFlTH/Lm2u4ozulkDXXQ3JhvLCU7ivUy8ovQA/LzU6kZBYL/+r+
	aE1FE9kRWYJupdDVPFpslAtmXkgNqENDdU8jD9zz0Ang/DEIpWEk3jjuMMHlrfGn
	ykcNfAgp7BdeCVfgrhARTz/AGFU5yD5LuxE/Jq+Qz88Dr73rrg118zC8uUf9Z0AB
	p/JCXmxzo7/jmOHP9FT6NA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sppubpuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMMsFD010115;
	Wed, 25 Sep 2024 23:24:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkb2kfp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqCuWlO9tPh3uAPRRG9w3JUImjFqHLU9QY6tL2k9zU7EAvSnT/CIM0JS0JzDTAGC3M4IcNkMg61ntfdjg4e31r2ZtWMyrXIXI4OettkipGToAHOnVqhZVZhNmC+xceiNUNLrxwqmd38tNDGpbmAnXua1ZAABhXN/vMZNJh+r4uTRqDWaNNUGKvVyG5SZwoCLeEOUj8pG1slgYv6YYyMwijq0HpCxGVYUA4t5AQdbXiczDxyVLc4/+gaIR/HbRiaf/by4mq1ug4pQFr8BotiVHJS/UW7UDmJs2vM1LsF8P63zX2pXgxH4m98jw2ju+IsMt3CTxXFhCM/we5AJUGSjow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=y8gGHpjukunu3kBH1zAkY6GuTW9CQvMOZK8A9udnN2b4zy8HGZxqa7Peuy+YXFKwfsAhuGOsjLembG9Kqm3jNnj4gNpFOOnAIT7I101BwzQIEaJOmOW92ZRk0ayIXw3zWLhT97X9tjKxBgC41lvasE9jxUW4NIBucMZa0lgqxwVLQP875kvAb684jbUBVLETjm3akxFTf3BR7G9duGb2KTgLAFspLJ9q7xtsibvA63NoVAWBfPo0UZuSugaZwp4IJBZ2PF8of9bfH41vMJEpAc/lVwa4ycwZxGdiZaTjMfD24voR0BKeobFEEOdQCDEBQeKErbhG3jLHIWH3jhs3gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=UmoxVms8/bH1+WquDMAgYpaPixY6epVL5bViMd7iA4Q/7cIiQuuVlaAVf4kMPoPI6r0bgCl2ddcX0fpuKtDwib+TXl9bNJ344OCwjf1Bi8l2eVP3EJ7Hapk+Ncj0TJ4W8N+UJCCt9p68RKGn0FAnJIdUPdPokfBgS+TWC9fWsk8=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:39 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:39 +0000
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
Subject: [PATCH v8 05/11] governors/haltpoll: drop kvm_para_available() check
Date: Wed, 25 Sep 2024 16:24:19 -0700
Message-Id: <20240925232425.2763385-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:907:1::31) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9fc7ac-fa57-4d9d-5e0b-08dcddb939ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SQ9x5B+Ql3E6HSnRv+YEmzgBU5mhws2WsXgUhlpJr6VcOGHky94UhpCd+i7b?=
 =?us-ascii?Q?ocpYgVKJmyDCvta4HDpLIvZYDIsxG9h7opbRQGmASPYu45gK05KvdErNQPWE?=
 =?us-ascii?Q?e7HOya10pOn/HXoq3BecavIeJCFNg+wNqjk0NZ3Pvdu6GxmqgqtcFQufCkHc?=
 =?us-ascii?Q?8T0yhYHpv/2UaCQM9GIrgX/uH4hYfaspMxKmU8jOlqZ6+OBSJFlr9dnKM2OG?=
 =?us-ascii?Q?7FNc+VV6QU2caPakDBNdCC9CAc/SI8NDsKpFC9Mav1tu037sEqnJ6ZTzCXvl?=
 =?us-ascii?Q?dTYgkwSxaQGcvGN8LpWerGojTkr+vLepnDthLvjzd1L9mAbOOwHBds2aNAcB?=
 =?us-ascii?Q?De9tmi0rwMIIu3HYSwlzJ423uXjSnwOZpNAomaRvISF4E+CV1qKugg0PUrf+?=
 =?us-ascii?Q?iThBSfBiigv350qb2bmYohARQWMxQ48e76E66Wd+exTX2YzMzX1IQTyL3vrk?=
 =?us-ascii?Q?OZVfCJmK2dxiw0j6m1vIRnS+JkUhy+cDsj4IWgy2HC4xm76/eI+GLq9yxHji?=
 =?us-ascii?Q?bpvFbz0sAAIFYTS2daYn/OnUK7yaCKkAmbE6SdUFcq+iftFygFYMMIpVw51z?=
 =?us-ascii?Q?cd9lzqzZ3hvhxHPAxLEdFyPloyjlXgD4c8J9OZoZL6UnfK3fvYzEj+lRcLNn?=
 =?us-ascii?Q?1i42QVXNVgtjpxmRsxlB72+QxCBeodNVd+tR2FKFozqABKq4EgZh5xRQtw0B?=
 =?us-ascii?Q?6fUr7SslL89KAadiWpPVkepuvaOGHekEJx1qp4FYXATQ6vwQY/Wk00yaKKex?=
 =?us-ascii?Q?DnDmQfxYgr+TvbKHfKqvlt6q14HFmaq2+SqLlL9nb3K58tWGZI3m394xMJlM?=
 =?us-ascii?Q?K3m5vUvckaR2X16PamZvJfLPvdYMvwq502B/SfX57+ciymhOG8sAGCRNtlX0?=
 =?us-ascii?Q?H9WSHlaXtmSnhbSPoPWZ0gG0ycUEbhcVe+yBdBi/8JEPWVEXMGEpxEd5xME0?=
 =?us-ascii?Q?V/jTpfULObf0r/RH4P/XfEcJTxATCW9ekwFKtAonnYoVrB97tFDYhRDbyHoG?=
 =?us-ascii?Q?1NZlJfJjN1b08YxH5r2H4INt2UMGkp2wZEZASSKJ39Y9JHf46gKdD82x4jzL?=
 =?us-ascii?Q?bAHcC49AzYB6hqO23/I8W3U5gC7vmMlskCufxerr5G0SFhDZDPpcp3xyCF5A?=
 =?us-ascii?Q?cb/mpWG+DfsHGEFG1vJV4O2VLhPAm7nBEmAHhiJh3PGaoxjrVNsqzT61HDqG?=
 =?us-ascii?Q?4f5mYAa4d3QIyIJImGkcgpK7Z3D0xQ+0RRGQNBcFFjHy5r0co/BjDWeornAK?=
 =?us-ascii?Q?vDXWTVhMnw1gG4h/XMkZt0hquqWBmrfuvX73wEKytg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZBZPqFmXH6hAeH0WzCHcTi7okgRZ4nTKuT6Wgst6738/HDI9AzrlK5vRgtNI?=
 =?us-ascii?Q?4z7brn9ZTnw9QfLHfTFlid9rDDez+mMgOwdML9Tr5ovVE01kyQzJa7zCNu/p?=
 =?us-ascii?Q?wXH7QiXOyIfEJqa18uHKXwrQCK8GrUhmynTEf2+PNSwgi74fR3iasfbiSMpQ?=
 =?us-ascii?Q?oa43p+1iOAB5PR8XIViaO2PjkenwJEk7xXPrgQc95fNEajbtuEY49HC5b6y0?=
 =?us-ascii?Q?gWIiHmNslV7hWvkufkqgc7j1A24nwwi2pyOU0RzpIAgkEIZ0eRPqreW3PVwh?=
 =?us-ascii?Q?yL5aQwY9prJKrz/My9YqF6PC9F/160HWpyNO2WZQm9Iox2Pob3MaxFOT4ZuQ?=
 =?us-ascii?Q?MkU+oPlFld6bqTZcO4veOLNxgQZot0R/7eMksCUuNo+bJru0ICJ8prTVKsCS?=
 =?us-ascii?Q?I8MZHa9gLl00B67Dx9ers+Jnn6qPOool157OEue3dzRkNwdvKz05H1n+aJ//?=
 =?us-ascii?Q?QnYONTr2bumxIQ7JtCC88eD9v9vJfLspEY6LYY81oion+qAjIyTP3IM/snrr?=
 =?us-ascii?Q?RNWsgsyOTYJiXLDAoe46xq1FUHxakRzu3JE8BVcb1/+LMW98P4PHEa9/jYqH?=
 =?us-ascii?Q?UikWhV1CxqRqwGCzqkl6qN4pJ+7al7HZRk0ebidKggzUGJUvfXFom83cPux/?=
 =?us-ascii?Q?0HNHn4l8p+59y7ldZOBbYBA3kFBjy3RgWVkuDtDP5+pJPaD8RyCt01KZlHY6?=
 =?us-ascii?Q?ZREpll+YLuc/CqvtEroGgL8J0rhXhikWgHmtjN2vZXy35FoZsGWBwN2V2eKi?=
 =?us-ascii?Q?krncWgSu2+YAILF1PRoSYujKl4wly0xLJ0KGfBCyvUVam4qioHdEoIzG40vu?=
 =?us-ascii?Q?WDYQulHNmczTjJOLhYe7Hf7i6h15kVD2VBumPJ+tc6diSMO5G8QirtNYvu9Z?=
 =?us-ascii?Q?RQiC1kzMzS3VO3v68PTaLPEHZATvy6IBNhxsNC5F8YOWE+d6lIp3iuCC/iFb?=
 =?us-ascii?Q?FBB/U+xBbmLRNTMTWT7FYhVad2A2T5PA3KdPeSEJqn4E3llCykVh2ZY4yreY?=
 =?us-ascii?Q?wDGF0wpAW9Dy/MZ5iAGQ+RZgpKFBw1sudLByvN9jE7MqsOXL9dbcdQ2rWl2v?=
 =?us-ascii?Q?QTb6Wk9WUVFQmFQPHRdB2jteOj3w606JHgLyAduimhUvlPZxb7sSG+WWM1wI?=
 =?us-ascii?Q?yK5Pk5iz0IEPfMlk3wnrMBYLSsv9KQ/ZEm9AF09eSPVwizT8MpkksKJk4UAP?=
 =?us-ascii?Q?/4uh0/G8uhyRLMr3IWm8FrRuJktfFmghho6pKDzL7UHABm4faisbw/3N2OS1?=
 =?us-ascii?Q?HKp6c8VTm1hXWwy2PUFFSWu2DvxwWgX1vArV4LFzWzTCQH2RNzRv/XIUHLWI?=
 =?us-ascii?Q?/HmIfbQmiXaGpydnu1VepW36HCUvGBELHA2ccv6ACZn3NBIVelREGI+Dht0A?=
 =?us-ascii?Q?KviC43sn1UYZgh47WMIOFft9N0Drx1I4FwbdWbqfEqT/3atovu26i7OS14Am?=
 =?us-ascii?Q?Nc+lIOo8V67za1ZRfPugQiNtdKyGfzcbKZhXk3KcQflu43jFeCHKl+tIXlP7?=
 =?us-ascii?Q?ksR7vHtibMMC9R5sLVtDAwHZMvktscLVkPcxNhxyo8ozXiBQ8lnRcq7QuXfw?=
 =?us-ascii?Q?ggXmIitJuTsQZULFaR+E/+WnbrNJ/umeaxBU7MKZLud1ysbYO0Lgmzrhv9Hq?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qaQepZ29eHf2whyHbtZQPf2eCN4pbrGTtVudrBC44z1uGKbj1YZfiYnw0QocV1iJxuoXVGjgBqhrSlc5XF4jCj1psqda3pi0y5cTAgs0IIA6HJBnee2y7wtecvFUgAROHc2UzLqAWJfFsu9/wWGzmNy4m4YCJNsoFVmnD/AZuOR0tv9gTVbPb2U/F4yjAADdlFtQdw+KDirsgIPMGoScNm9WzV4tVDzT9cviVdRoXJXx9581ltEtGZAMFKXzw7ZQBOLAiXn8Bu36ii/NJp6B17yW17Q8J6opERBp3I6pu0HcKBkvR20ArrgRMZmy8qnfY/0V9IBOonCDw4MGcZr4hTUJpL3vE7b7LnTaSvZ53GGYKBMeDWqpSW+uubEhs4yipo3oxoXjpaA9loui0Ys9rb+hHYRVI6o+EZXdG/WE5qKsHZzwW/hA/H6Xqeh5xQ3b7lZWwM+1qbjo6ws9Es2SIfhvYADtaQBLhDZBXYO5obheVkwzixRTc0Usg2r7g7jL8ojxqY28mpOORthYN62vOa175dT/2YieZ2uz9to5M/vs7W34k1x4By4lOhpjxUafEa1HBfOh4xmfv0hc83FyCn2mlbEthzRWk3/vn5/e8FM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9fc7ac-fa57-4d9d-5e0b-08dcddb939ec
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:39.1646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g93q5qFDgjrB15jUsbARilukUHjBK7xJdf+KlSF8RGZ/MlASmqLV7sXYjEDgHcI7/9b23aYM78M6ERmu8yTI5ovvX4M99YDd3KEp0+O/Y8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-GUID: 0ij7JiJ6Aq1YDVUgEnRLraiRhdnv41Ae
X-Proofpoint-ORIG-GUID: 0ij7JiJ6Aq1YDVUgEnRLraiRhdnv41Ae

From: Joao Martins <joao.m.martins@oracle.com>

The haltpoll governor is selected either by the cpuidle-haltpoll
driver, or explicitly by the user.
In particular, it is never selected by default since it has the lowest
rating of all governors (menu=20, teo=19, ladder=10/25, haltpoll=9).

So, we can safely forgo the kvm_para_available() check. This also
allows cpuidle-haltpoll to be tested on baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 663b7f164d20..c8752f793e61 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/kvm_para.h>
 #include <trace/events/power.h>
 
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
@@ -148,10 +147,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
2.43.5


