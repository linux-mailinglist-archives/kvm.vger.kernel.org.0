Return-Path: <kvm+bounces-27512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 737E8986996
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30DF528475B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390251ABED3;
	Wed, 25 Sep 2024 23:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mdc+CxkB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lBSwyJzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAFC1A4B99;
	Wed, 25 Sep 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306737; cv=fail; b=BfYXN+nMNp01zv/kyv79ogfcufhVkoyX1tdR2DHLcRrCcW8KbBx6oSCSLqxGbR3dPxo1jsKnm1sf3LT6/QqEG6fn6h0mPBggjSPgsDph8D6ZhePZJ5yH4Vh4W0ykxnRG26ZrPCyd54u4AaEVyhfhxMrmFQ54uL2bW26LcfEE3MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306737; c=relaxed/simple;
	bh=YJUP/CvbgqsBWS0W5UQOOAeB7eZwKHtEVSabMElkljk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p30b1MESYhpxCnmjtcHGQ+XtiOgSQ6W2g8c60zU+OK6YuqZ2/vV4cLtLjLirYqqOAvjwaM0Ml0I7wyl959P+g9mEvHEImG5YSsiqB4G59JExYYhaSI/28WPzs5Pho/ovE0o0ey40afTa60LagdkKIiwlE/Wcp8cp1JdRyPL3tsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mdc+CxkB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lBSwyJzJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnnqD029312;
	Wed, 25 Sep 2024 23:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=MVGa+3B4OhUxsLpz/bL0vKB8bOonKBM03OwaToGp684=; b=
	Mdc+CxkBKcDLaUCQWnCOUXRCSmL+ngnlI4gTiHCbNznRA6h6y7sZyaDuOUnM3bVT
	6qOX9A71C4vOGxb3EWN+gM37k58tcH56IV1K1p4JOh0sUlQkhuTiX5B6kHcv7LfB
	P0OQX2Igld0+7tj8fGrUjd87XQIPWugvv9sjfxUhC1BAdv5PSE1aSeRxCEzOJHyj
	PCtwc751O0u6xvXL08NNrbuQfChuRRpCd7iCNfdfD2SMWJqaX2OMDLJSq1CcSyuO
	B9QvuO2ak1cVgfp439xuqCV0+CqOLowptipXxImhHDQjvAtJHBItBkVBp8VGqXNH
	9uNiwhnLgB65aCRdQ7hbjg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1akkuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMMvD8009787;
	Wed, 25 Sep 2024 23:24:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkb2khk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSzt23wD3F6LDoY1eNh+GyG5OlMRwX3fc5ZX+jBUEg5KRKQHsVCPhtl/IKZ4BI20podmeL0x0vabwJ5147gB4M8D3Sfu1yRedjqUPyfX3h/h7Mh4KqZH9pViKHCWUq+4ErthvECljrE9Siuva1pgRlRwPOqTTXGWgabmlPY80DxAtCN5AfO7MifgH4xAOWSnRFols3qtghIo1G3GvSui/ynD7DQjBgyGKdVx26MZWJgvG9l8655DJVTj8/PUVZJ1jRkIIvxaLQepB0OJ7P6cju00ugLMsPYJEn7sVKw25RBU+7Pa81BuvUe/R6SdzvFVJ5URAlcw2VU6cqXIge0n4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVGa+3B4OhUxsLpz/bL0vKB8bOonKBM03OwaToGp684=;
 b=n6kyp4NDN796Til4iOoz2CBeke3rNXS2Oj5nVrhEuEFEBPwjbuyn+NoBDLDYkkq9ZIBCGbVeu0JhEem6HaMjXYyDRUAySZMSvb3WGIqsYG9HWDWKXcSIrAn1BSD9Vxe876+0BISUBF7a8ax70k0gboeimxMpfYGBD6uGYGKaASEta6NT0nZzXroFsQK5H2DyHIQi7AHMQsB3s+ZFmmXA/ne2PrzzXg6Xg7r9VvuGOudXrZaf8C/0CPdMmlw+X9lHX0MvowWAeYjlO9wxC4YmbARvV976jWoMvfigCeceZWzx42eM6uCFPvyndUxSfRfovhYc/qbO6hyIh2xvBkpLag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVGa+3B4OhUxsLpz/bL0vKB8bOonKBM03OwaToGp684=;
 b=lBSwyJzJp0UZJhkzRO3H+KX4l0UVF1hucmfNnu9TULYQ9uoKifsBx1egqJdH9Mz1tsj1n5aTabSauxOCE5nFU8akb/jKGKqrQrRVN8anKoWpM6iKdYCby12ffbYmN0PaeSFcMTLd0PQLE/6qlMaaRhuFl1L9RJVRqiaa9jdzwI8=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:44 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:44 +0000
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
Subject: [PATCH v8 06/11] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
Date: Wed, 25 Sep 2024 16:24:20 -0700
Message-Id: <20240925232425.2763385-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0069.namprd16.prod.outlook.com
 (2603:10b6:907:1::46) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: e9026ef9-81e2-40d7-82fe-08dcddb93cdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0nn4wKI0gNYvtBgSb50aWWXoSdCjZPGO0+7oUY1wWGTrRw8C/pX5uzjaJviJ?=
 =?us-ascii?Q?ewTdEqsK8mQE4YIS810YuOq5/4dRIn6hlALCM7dK2uDbuxJm14owi94ngXy4?=
 =?us-ascii?Q?X5hnyW43RL7ALaVgQ5Zmk9Wh5Djw1PNoph/VOMF8ZsduoXkXs8QPOifKvPfS?=
 =?us-ascii?Q?9D2hFz010PYnvjMd9rQmbl3eL8Ri1aTOwyRkd+UeAJWxen+hAKxzYVGfgiXx?=
 =?us-ascii?Q?qGc3xqFYVTDFnI6pUpsAkf4qcj47wh1HKB/8NHoWtUt+6DT06aZh4Jk1G0X1?=
 =?us-ascii?Q?27TyodgFXTbxUjXZO0t9u0BvFmLMngNE2ynvZiILHDVmXeopIsrg7nz8nvVz?=
 =?us-ascii?Q?UPEsgT6i2oIVK4OzxgWBSvGJJEXENROmERDET7krbnyiGdf9HU7KgMUyFZMA?=
 =?us-ascii?Q?i+SpSJnesxPrVzKf5kefFf+HZQCnSU2hX0D+wg3twDlVYMl7y6ejR81w8ywx?=
 =?us-ascii?Q?zzFKkvawp0CF41BaDhIuOlwfW3+O2V+6QCFEbVkzR7uTD5Iu83qC4W2MCIwM?=
 =?us-ascii?Q?dZb77eaBEOA7UZGRsC9CcEadLcDS7RqbUvBD5Q19aoIi9f5ZeweR3aHEZ0Ft?=
 =?us-ascii?Q?/s3e+ramK99p91eZfVZWoVvAROzS3mxaggxrpCSq2MzvfPsd7uDR+VgHQtEd?=
 =?us-ascii?Q?Kn1Nmoo/HQZBXodFjfgEbQ8OMuAb8HZwum7S0Ay28rSBeN3ZR7lq7S+Q81Sc?=
 =?us-ascii?Q?3b41BJS6UkTpclJ/nmhYqiO0ewvNrWsVhjreZOOvUN7vDV61TCIbHCMupC+q?=
 =?us-ascii?Q?v6gEOB3eK7wh4fJe8mxN6sNARNBEQcJFOr1uPoq6f2w9EvLdDkJoT4riK2HK?=
 =?us-ascii?Q?wiWuhpvCIZoE77lxbSk/xGb5JaZ7+gNX9SH9SRNts+jDGc09R0RTNV5P/pal?=
 =?us-ascii?Q?uPgCtAe/ZfvP+DTA3XyIXKSYvLIM05B9tGWCr9TI09jJtDeMZvhJdqV3PkKR?=
 =?us-ascii?Q?IRYXBrAFqkFK5onqOcRQA/uW7oDpDceCYycqe9FOaArYDC1a9ev4gm8x4BBw?=
 =?us-ascii?Q?fYDhWJV/y1jm9hmI6IHOtlFnVNYqem9Jdk27DboPhA5Z2cbWDwrGE5w1fFpF?=
 =?us-ascii?Q?W+W2eUrarbQY41FxSfgX4sZ/rI9wBKaBn2FKMpVPs3AMjAdtEV99s1kSOsKS?=
 =?us-ascii?Q?Cv7foxZrSA+JRIhZ4YsqFpYzke972EkKO5JdfKUL/CvwCtcIc6AAT0CDhF2q?=
 =?us-ascii?Q?LyHWkOQxRUxDBodAKp72usoHrq4eHJHgKsva/Vs08yqQuqi/v6esrFqfcZhz?=
 =?us-ascii?Q?/M4+dGOEhxLu+FqEZyOHdWdZiOqzV2hY9BIOgQKfbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nD2qttx4P82y1dMmy/21119FTOmrTD4ncgncdPywz6rgMLrKHouskX/ZVaXq?=
 =?us-ascii?Q?UfCkU3RczejzlXKgREnO0RKCcsFvkFbNROWSeG4KNTBTpujFFi2NhN9ZsSjz?=
 =?us-ascii?Q?CTtVbDj8mumIOzO2lyD7GZyDnHCwJ4Aln6OFSbPhe1nEpPJvkwSJqLyZzTOZ?=
 =?us-ascii?Q?AcQeX7y0cFbmOVPNgqw5sxacnNj5sanHaky4cuU3DI4oLtY8aTt/tRrloh1g?=
 =?us-ascii?Q?8Wg9BYfnHZIF9+tzdgiCEEQ5tdxLtaFb/Ke/UTgKxC7hwduMe/gz0Aa+uPXa?=
 =?us-ascii?Q?v4bNuybgQ58q7LX9TCyIKRy3O3I+NJCmnUcOuS2wUAVJlRjBNoCvy/jZBJPb?=
 =?us-ascii?Q?7D9wwNTdpJ7/wVlmaNHK+hwHeFX1Rfu9uSnDWFOemKu3tUYUh2/Fnhdo0b6U?=
 =?us-ascii?Q?GHO00uVeFqD7t+Qy4OrpvE25WxrUwCcc/MoYqBe0CBSJf7tOucwEJQdC1NK7?=
 =?us-ascii?Q?K/qKaNT8v7rVFjjvPyCEcqy7e5Cf4Aui91U1OIGbdsAoRjIcmrqfCAFx4QOw?=
 =?us-ascii?Q?BAK13ktdrK3nrFTcuaIoxkXMv+Mcv2K7z9jIq84PYRfjQlCXuZiaJdg/bZfS?=
 =?us-ascii?Q?ZVUrOeJSJ2sYEiDKA2Pjz4jaMCligsENLu+UlTZAYe/7peRw1IAEnuafxpQ3?=
 =?us-ascii?Q?7rIS5PBHcovYqjMKSnJp/nzErpBEqwnZQGW8RxO7luTEx9DF7WZH3+hL+BMg?=
 =?us-ascii?Q?YCLCwvf7GptY2uzO2hntkAa8HrnQ1XRjEEY9NXluuroiOArHBjG76ABaoQnn?=
 =?us-ascii?Q?Nt4HgkgpUHCHxw/G6Mg99SHWa3x/L79PGW021UoXdPU655jcAr6X6+U5HOY4?=
 =?us-ascii?Q?Rm3qo0KifJNuIGXWUtsmElJnvhMEtsyImuIi7fwFJMBORA0/8SpthGgLSc/0?=
 =?us-ascii?Q?rcs8b6CgBQpXi62NCBfP+p4CRP+QxDVpd8UuU9gbMW63xTH6x0tSmnGIPgEF?=
 =?us-ascii?Q?L/JwVjdkv83c8iqspArCBw9X9UDi3yK0nf5OL2lkl4vD4X1KcxCGs2TLuW+U?=
 =?us-ascii?Q?Utjp9ebzbVouE1r8BI3LriaB1VNiAoGQd0Q5TPZN7HD1YYH3iJhSqvR4eqif?=
 =?us-ascii?Q?SO9uLxAVYAZdc4BYDQdmVs9UP9JhE76vWeqM3zkDJuvQbx/YRihUK1qGs4ez?=
 =?us-ascii?Q?NZcoYOUE8SLFFt0YNQw6T2Lu53Nb8aqcXetOjeH1Bs0cdu2iLHXDmy8njeXy?=
 =?us-ascii?Q?Hlbo+xIKm/MnIZP/rwySj5pwh8qgaO9SzU+ouajmsH50srGff+IC5Ibbkg+Z?=
 =?us-ascii?Q?IkPN8n/AXu4d/zsi+jOTaRuS0+wYRF1M2wpyqjzlv0l5zl/f8Esm1a1o5Jmv?=
 =?us-ascii?Q?tt+wAmRiXMvZlo4Z5j8DJD+LMYHzaLXzYl0CcTZAxU3SljcM89s86VZDwjFq?=
 =?us-ascii?Q?9P4FDuVVi6gkHE3LMJ3pnsKMRNZh5wku156+JJyhdnsZXjBEYxTDEPaC/lnF?=
 =?us-ascii?Q?ab0tmtDXyK6Y+Iyd9lHY5v9O/BnyvXAwbJJ652t86FvundX75N4oNlrwZgFe?=
 =?us-ascii?Q?ZiW7gH3VhTPv1Ecw/SF7Mvn86+CPNL5yEXl1D/h5pWi2fYefbYighHG4r9zm?=
 =?us-ascii?Q?ICzjhTGujCmcYE5+czxgINknqExCSs2W7I1ldcScdLIRKlFkpSfTmVV6Kbjj?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mVC34rDHvquHohsZfiI5X6hb8rcB5d5c1uvB5E/dEatTSlLyccRuszMG8CAd/FFoLvGXOkD/2jLca6tBtqo86cfZp5dD3rfhrVlY4h3fx0swHlVNT3+AMvGtt36g1rh2W4ttt4LzbaxzKQaNApWA/7tn/YAu5NID0U0Sg2ER6kd7h3FULt9hJMZjJMUx17x5f31xv3Hii8NxhFGj2A1mkl1YioqNOOcUqf1vjHJFSx3JD/2dIpqXoeJ6DQB2Kr2rmglD5V9PV9on15CcLpxH9yBtuYoEk/jEf2AqLGDDycLneDWJI7MS9l7fAf/WxxETXgIq/XKRNXb3Gd4+WVH4YE9KOqW8SNZhaqM6fhipchE7cXd5G/mnpO1nzavxeDIKB34/r8dV6mhlI21UB+5+ofNLtuCtn2QtHEuufY0sSg27g6xSW7uofjXB33Kkn53q3YSxKaYwwI6BnHMzV0ZN657OsklEFBhAUKQxYgKVI47I2wITzSupcYm2Y6aVRGcR4Jhk6zsVOPI0gedIWEXMo9TuBdaN6XmPXUAFKRXCDCfwdDJ/A9OoiSprkPE1VW+kJmHO4ZuZXQODPtzPRcpv7ea/v05ZBscf74Ouzh15iv8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9026ef9-81e2-40d7-82fe-08dcddb93cdf
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:44.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmkOSveYFqbXY9WOtT/eDxHeuyfsASNkXBLJOTmGAAjgcE9Nirsm41x/FlLtQEi5b08rfmzQYXUdNSJjz2/tNwokxFXSepJQL1MRPFVCwfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: BLkK7CZHBrcHl2lbt3tT6r_J7YH4tXp5
X-Proofpoint-GUID: BLkK7CZHBrcHl2lbt3tT6r_J7YH4tXp5

The cpuidle-haltpoll driver and its namesake governor are selected
under KVM_GUEST on X86. KVM_GUEST in-turn selects ARCH_CPUIDLE_HALTPOLL
and defines the requisite arch_haltpoll_{enable,disable}() functions.

So remove the explicit dependence of HALTPOLL_CPUIDLE on KVM_GUEST,
and instead use ARCH_CPUIDLE_HALTPOLL as proxy for architectural
support for haltpoll.

Also change "halt poll" to "haltpoll" in one of the summary clauses,
since the second form is used everywhere else.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig        | 1 +
 drivers/cpuidle/Kconfig | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 272ec653a8cd..cd457400eaf6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -844,6 +844,7 @@ config KVM_GUEST
 
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
+	depends on KVM_GUEST
 	prompt "Disable host haltpoll when loading haltpoll driver"
 	help
 	  If virtualized under KVM, disable host haltpoll.
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 75f6e176bbc8..c1bebadf22bc 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,6 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -72,8 +71,8 @@ source "drivers/cpuidle/Kconfig.riscv"
 endmenu
 
 config HALTPOLL_CPUIDLE
-	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
+	tristate "Haltpoll cpuidle driver"
+	depends on ARCH_CPUIDLE_HALTPOLL && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
2.43.5


