Return-Path: <kvm+bounces-37065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08481A2480E
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 102CF164E5C
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AF114AD22;
	Sat,  1 Feb 2025 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MtSyUtht";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MdXwa5y1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED8D2B9A9
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403871; cv=fail; b=K/qPXrcVqPGeIzskfV6mgi0cMB2/rPyoXlRdejID3KKkClhGN9SGWikyGzLz516JqRdogAcfgSN5hCDDH6yAYNmw+ifYKPwwJRsdlhq0po+uGzJteGZNbMhzMThXQpO5tPIqb78JrVEfFnzTAAKYF6AcQqFusCY8DT66YegsulY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403871; c=relaxed/simple;
	bh=L58q496luvmHNVBSaQEl04GAnUXNWUwwxhTs1orWQoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oMbkxHEVO5z2sHSJfpVNju4iBTGp/fU3bsZSC8fGlTXzD9qeRp4qCNzfFKe6HmqsCbHcztGNasvVHV5xPAdsbjaEEZ0C98g5exwBB9DrUIIMIfLt8YuuGDeA2LBP2T1AqVy0P/68+zBlV78UfXbM8Tm6jnujkhmdxjpj/ZU46kI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MtSyUtht; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MdXwa5y1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5119far2012494;
	Sat, 1 Feb 2025 09:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tunOOa1ZpwSILBYIjJp42S90vtYmRyYVOmjGwUydsdY=; b=
	MtSyUtht8u8nJVOGToakkeIuUJGfgfdphTLp+yDSqo9pPUNu25n2KGwdJLFWimAG
	EQGqNOC6I6n/vxbjd3P/cit6y7ZiCcoIA2nZ63R1CGmiJoaqkNTpIh3DR7hPJUwN
	S9cCLY2IsyDu/g/1XKTAeXPzYbZTSLSvcffy2pE8v0dYzLeq9P7+VPvyeUG3udUf
	pFhxgZkCPaGBLvmLaPT/B3W1I8Ud2WgPevx0GC/dGimGgs05eqP8Oj/eLaV7yxRx
	fcS7o3aJ/ruk8e7i6sG07ThpNVBfPt8FzPny3TInG2HQ/AFuLkMlSHEwtoOfe24+
	vDJd2deL8CHXJCHg01trJg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73g072-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5119XDCR033195;
	Sat, 1 Feb 2025 09:57:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44ha2byd9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBeZxe4sUGHPOVpmJgSZngqP2zWpD30rn257paU+NbGsEuwIf1Dbbq0MxVzxdsmW7fNNV0OoXJ69EbOpFSbMrJqqyhWPCZoAtJC+63dSSsu7OQSxYeGSC2HDHLzqqmmUDkW8Elvo7Q7wY8N6g5CE+TzOk1906YLZCUFJe18TqLY97+hb0JSgKRa2O9V2FRUGdjl6t1cmYlXKVnmdLggvhP2oJhOEa+vbM7jYjl3bhk3x0gDGzwNPa1/RIGsq+otPf7XqToYoR8basLDLyciv0eE4bK2DTRVST3g8KPrW1nMQpLW1JQD5WrdgDn8UcWjo1gDURqWSYhjumyCr4wjm1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tunOOa1ZpwSILBYIjJp42S90vtYmRyYVOmjGwUydsdY=;
 b=JYKi/MN9g0jYFZFDIHbd05Fiy4X8fRJ6Z5LSNZmKC7u9ruwuSE5Z9xqdLZinx86K1I3mAjpJ2eX1P4RbOIBSG3QVVPyI1RRUOE2syLxPFxXWU/zmTVFcAF4Q9DfjkmeLjUZaMnRjC51e1e5m1zs9vg8nqZRoPOlt38457Ow0e+h99c8UYdtsWjuHXGZbqCbuL7skWruYCIcYk4WWXo+zk+kQJEw4YPrQ31WSGjTxtvGmclfLgTYCzeKFCCPCazj0hgW5+LJtToprp/KA+veCRWYV4hh/OR3f1oGjbRW7lgL9VmJzttYat728StnvkFnWHzw1vs2h4IRyCUQ/vE/y2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tunOOa1ZpwSILBYIjJp42S90vtYmRyYVOmjGwUydsdY=;
 b=MdXwa5y185HydnA6+ZYOwphuwpxbjuxSuwSXXdl9Dapi7mOYjR4/EeycCdwcC7W7jIWcTJZlJILDD8gvQ6YYyKyXq8joIDt+u1cDV4XW9g/dZRTABp+Ll3KaXncLhsrnLmzh1PjKpa9xrwLNgJfhe1Mos/raEJgchJdLytidmk0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:34 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:34 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
Date: Sat,  1 Feb 2025 09:57:23 +0000
Message-ID: <20250201095726.3768796-4-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:40::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b614496-231c-4f1e-6184-08dd42a6d9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4Ze5Yse8LbepAe5WOm3zHt4viBcKqngGQwsaxn0R9FUFxPrPa7iTtn8sKAvT?=
 =?us-ascii?Q?GpQ0KatfUXVaO9wUO9xtB2jL+lk7JAFyI9Vqs1t2n3Tdj9BwW6ZqitB4G+uY?=
 =?us-ascii?Q?m4zZjOZUfwAp0z4zlSBoVuX9ppdLUl8Qz3ccDp5wSvlih0/pOZlWC6k2bahQ?=
 =?us-ascii?Q?jS9zFOoM3pF2cnNiDBB6q4zDlrjnkonUX+yJxTBu/EGkUydzJghGtABMmfk8?=
 =?us-ascii?Q?UyUW0Dh3QqUb9a8zg1yvM6dafC6Nif7ZiLxSESL/vY9EarAQnBRRWxUDNJl1?=
 =?us-ascii?Q?1lp2FMQcGMOYo+OJ9zEqYe5t4ox6AV2Ni0UmjBoe2OwAoNKBsVmfh1z7MKrx?=
 =?us-ascii?Q?9WucqZ5X4nmJhtV5wWpsKMR9sonJZk9YI7Ipr8kWSZNFKVk41jmiAzDzATMl?=
 =?us-ascii?Q?DDUTF1udsZFWTzCRNohnHD6RgzRmnvl6TxUswp+nZgkuL7GDDVg/FcT3u/dz?=
 =?us-ascii?Q?mz0+j9ydrWWe69PM1RawQWiwbgDn2f9RI23B+EAyuSPoep5MInsiiZ2GJs2z?=
 =?us-ascii?Q?1jg74Yi8Tf3Bn1GZIlathH+5FLuED+lFCp1klrPVKf9b1xIOSBI5a1tzelSI?=
 =?us-ascii?Q?AaDdrfEC1JxFeacr9RvqWp/LbCe+69gwtNLg4JJTFhtFMmnf1XDgSp1CASu1?=
 =?us-ascii?Q?PK+5EDSIHklnbGUv948BTPzuwHJHIgQ1CXULD1l5K9rSUc5f0O0JtT0yakJW?=
 =?us-ascii?Q?Ye3svCAbQzI3FKwmbopoQ5EeRUhGJYZhZE5nWM/lBvOVr9MW9v5Vt0dMfiG2?=
 =?us-ascii?Q?sXXr1vp+r65SVhBM2kHVLiwXayMeshLGNpvawL7c4inbq5DM7v2vuWh8SJd2?=
 =?us-ascii?Q?1W+9EgvYUBe8hsizr7mNyXs9u4dwR/XyDDV2pTDjMIszPX8UEFrWQdry3IH2?=
 =?us-ascii?Q?cLeECRIiawy6nfjw5DP0WvttlljH15cp8rJNnhxNL/y0h5QqGZGc/QK9r5A2?=
 =?us-ascii?Q?d2IW/23in5er+MMVdN4u8dFgoZO9yeOCQDl6IeeDDVkzP+8jw1ANC07HgIEd?=
 =?us-ascii?Q?dJcTVg/ckQXP9greOTaHmQrFUy8yj/nx/fniXsPf6SrqX32XSgLLJCpYIJ9X?=
 =?us-ascii?Q?4P9tVHvNi2W6NbaXF/fFfxSAdko2iVtMLvlSzJsq9O6tiRqzSHEx41CTDcgk?=
 =?us-ascii?Q?M9TPBcwGivtvAGq7Ay5b4yuG6ZUJ+ijBJkTKOt+Fj2IO6fNUK0Z5ZTYOszrV?=
 =?us-ascii?Q?90pIavFEjw0DNxs6XxAukmQSXjCXldNjE59q7OYzayMFZ7cOphcehFqBnXST?=
 =?us-ascii?Q?QPxiEaP3VhKaBRHvyz6qPrle76H923EnrLcBlFQ4SauKUlu29PHKujs/AR0o?=
 =?us-ascii?Q?GwMUT9kRH2w1PcPGM4YZyby6Z7ks1sLcaupaSDd/mmLYaj1+L0x1mJGkTqom?=
 =?us-ascii?Q?1i8DkixUwcwmkRJ/FTD2gPkFTlWO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q6M8vzmBYI/DS8OzBi9OrPyFLDVOsEQ82wlUqpFFLElg6bsRqUmgfI8Xho98?=
 =?us-ascii?Q?iJ9ugdaJEI/jqhX7acNl8i6JpwksfYpMACrF5eGW4Pv3IVF6ZNn0FGH7+q4s?=
 =?us-ascii?Q?oEZV6CPMQpIYHj5fDa038mhhC+2isBPGrTKvcAlAnJWCyNxLvl6hWtodotyE?=
 =?us-ascii?Q?i2o/GUPINEKfupuG/cfctD4hKWEm+FcztSyq8uJdkFxhWPZsAkKb5nMZim7Y?=
 =?us-ascii?Q?cWnzDQBIpijp3M5FJqGZZpDxfa1vwwRBVW+yLLJZHfDZzCKzWldsPCGKYqMs?=
 =?us-ascii?Q?NXkVg+fjvbtuO8rK4T+s8zcVzdkSii5M85UY6O/ufj6k2vQQD3k9Z+9sr94a?=
 =?us-ascii?Q?xo6NB9W9EUxhBhDf8G38aN8Yz0UF01bfxc/mwHylQstZ6F7EQf3oaIZ5Q53F?=
 =?us-ascii?Q?CLpvlWblk78/DnBFqPdm3oftKCTEM5Xok9uhX39zC7Vyy07CUKyiRWK4/fa4?=
 =?us-ascii?Q?8f8A7p5ey0yA7mZiE1rnmOeKrkIZCjPoTiHlWihIYzyXzWkF0ItyW1unmrJC?=
 =?us-ascii?Q?ISu+h3RKektJjEbB2bSRLafbYxauZaSF9X9Gt6uHqxkwAmsky0mRwdR6iwXX?=
 =?us-ascii?Q?N5j2z4viTaeTHXB0Iu7MYd9GxE245UQyUzrPkHMhdchSoCAObuSnEO/+kQO5?=
 =?us-ascii?Q?+Jjev7lRbkBVdIYOKepQarp8dm4NWF81kE6oXFLS/6P6/dH7nBR+2XP46tcC?=
 =?us-ascii?Q?c+SHKSgSp3mSHVnWwxnvstXV1ysGwOvMxjO2HO1erhkgA02uaqs6w+t+Nbf8?=
 =?us-ascii?Q?ampF6CLHM+jEqVBrHOZIACRz5uQAMCGTpjrvBWGVlIetakAjltPwjc4u2IhL?=
 =?us-ascii?Q?Ltf0QmnrhQJyRjZq0AG0ehYp9wGM5BP/5W30ZDOBCmOToQJ0c0ij3TK0Svyz?=
 =?us-ascii?Q?+4z5ErauuNx5BTR1hq9RxYGrit9OM3/U6weaTH6mKnGrJqe/GVhiTdTwJAjY?=
 =?us-ascii?Q?RmDyVchnrcl1PlcIXztIcQIXKCn5XNzGvw+pjPuNJoAibweRfl4WUnn7cUO+?=
 =?us-ascii?Q?sXlB+4OpgyK0LFYIRQNI+AScP45GGcFgBVOJGp2zVTIrjeUV7HlHjhhLF8PX?=
 =?us-ascii?Q?+GEYudUZyDEYwJ0l+yuCFsUtiWvzz7svfnb83slJmoFbWBRP0ZOgS/LEyNED?=
 =?us-ascii?Q?n13lKzHRIu2l7zIP8eaAIXlYJdfkwV8vUJkg3nFF5K2bt3OeM2Y9T+9tv5d1?=
 =?us-ascii?Q?PDSqm0T5P3tiymCUz8K52xn9pThKh6ADpBXuueiCSdXOPW9Pc64RzcxUAk6Q?=
 =?us-ascii?Q?YpOw3J6QaBfgmSiZQxPNJo/44SdtdFWM3SnIzxe9MUqPP8wa8xiHezWKD3GU?=
 =?us-ascii?Q?aQ6TF4GpIPtxKpEPe6MGLVyK7a6uOZnBuHAvSc708O3ZER/ogPYmzyuBGUjJ?=
 =?us-ascii?Q?IcCnPYa1qlBYbNz8xoyOLAkk2uwf640LpZScwZV/v3SUKqbkQoYF4zxmCPWt?=
 =?us-ascii?Q?nEkxUPXcn/2AG1YNl4X3JQlPLSlKg1bWt647H6iD/LwaVkVWZ92uDAnMuwYk?=
 =?us-ascii?Q?XAjM6Y/JD036/ZA3JFmDBBHmtmdqClX9ngD9rZZ8pLdgc3oys4ESkAbHS8uY?=
 =?us-ascii?Q?uIEI+nHfvfch1cMl9FrpT193WVFIAmuQDnscveSNdi7SjDdgz1DAKPFdn4dc?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6D6DbDN+6JAkmzxplKH3gTiPkHWl2tHw6trUuJuVNYFnCo/Ih+ArMH0QUgi1G3wl+yE/5QrmhdL9vWUD7OlaiHkZVz1EitWQQMaV2mPLTW3Cka8v7PsuxyVJjjZQ2+uBM+b5xqYd5KV1cIT9ImcYrgrNnQR6eRnaYtrKvWmnjITYMwsF0cLwlL9vlvztf6/BOYFEZwq8LQd8W6HPlun2UFKHqXagNyaIVqmhkE6Tbbe30uluyP6PyVNJtkorsW4miGYyRV3wibZaHfBHqPOmTTnLSey45GUTN43DeFDfxQ/orNGdJshDNPass/unuJCiWCITxT3ehplH/O5IY5Ap6nyKBFx5QUXwzMrxBS3j++xkeK1BhBcWUt3/+1lPr3k/y+K5VGctI2K83xDJi2WPJhVTB1Y6ZybCnQR2wrbYNoYir0zNS9eWFeRbthBJGA9hg6fJOS8cjMTY3Jkuq1aWehJhRBOoFr8oa29GE/JHkxiK4ZCSjNNmnKTnGupYpoWpLsrYRzsa2b52m3JA/rtjuu0+5BTYc/8HQjSpo3eTuurmkfJ5DGvcQXz3627QwCsDql/xFgu871xIxqy6Ul71H39XEdXYcuXSMpBoRwnn8W4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b614496-231c-4f1e-6184-08dd42a6d9db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:34.4589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvn3dLh8h2qFaq7AlZ7GPDEvExgUH1LTNHIALrbV+qEVSHVuZVJYO6HbcghdqJnrt7MX8z7c2zyo3cZBvneQ7smZOzrAWaKPz+VS5/3w8mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502010085
X-Proofpoint-ORIG-GUID: fKtpGoi5UVfxK2vd9Rx-SMCxN2COAv5h
X-Proofpoint-GUID: fKtpGoi5UVfxK2vd9Rx-SMCxN2COAv5h

From: William Roche <william.roche@oracle.com>

In case of a large page impacted by a memory error, provide an
information about the impacted large page before the memory
error injection message.

This message would also appear on ras enabled ARM platforms, with
the introduction of an x86 similar error injection message.

In the case of a large page impacted, we now report:
Memory Error on large page from <backend>:<address>+<fd_offset> +<page_size>

The +<fd_offset> information is only provided with a file backend.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       | 18 ++++++++++++++++++
 include/exec/cpu-common.h | 10 ++++++++++
 system/physmem.c          | 22 ++++++++++++++++++++++
 target/arm/kvm.c          |  3 +++
 4 files changed, 53 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa3..9a0d970ce1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1296,6 +1296,24 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
+    struct RAMBlockInfo rb_info;
+
+    if (qemu_ram_block_info_from_addr(ram_addr, &rb_info)) {
+        size_t ps = rb_info.page_size;
+
+        if (ps > TARGET_PAGE_SIZE) {
+            uint64_t offset = QEMU_ALIGN_DOWN(ram_addr - rb_info.offset, ps);
+
+            if (rb_info.fd >= 0) {
+                error_report("Memory Error on large page from %s:%" PRIx64
+                             "+%" PRIx64 " +%zx", rb_info.idstr, offset,
+                             rb_info.fd_offset, ps);
+            } else {
+                error_report("Memory Error on large page from %s:%" PRIx64
+                            " +%zx", rb_info.idstr, offset, ps);
+            }
+        }
+    }
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 3771b2130c..190bd4f34a 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -110,6 +110,16 @@ int qemu_ram_get_fd(RAMBlock *rb);
 size_t qemu_ram_pagesize(RAMBlock *block);
 size_t qemu_ram_pagesize_largest(void);
 
+struct RAMBlockInfo {
+    char idstr[256];
+    ram_addr_t offset;
+    int fd;
+    uint64_t fd_offset;
+    size_t page_size;
+};
+bool qemu_ram_block_info_from_addr(ram_addr_t ram_addr,
+                                   struct RAMBlockInfo *block);
+
 /**
  * cpu_address_space_init:
  * @cpu: CPU to add this address space to
diff --git a/system/physmem.c b/system/physmem.c
index e8ff930bc9..686f569270 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1678,6 +1678,28 @@ size_t qemu_ram_pagesize_largest(void)
     return largest;
 }
 
+/* Copy RAMBlock information associated to the given ram_addr location */
+bool qemu_ram_block_info_from_addr(ram_addr_t ram_addr,
+                                   struct RAMBlockInfo *b_info)
+{
+    RAMBlock *rb;
+
+    assert(b_info);
+
+    RCU_READ_LOCK_GUARD();
+    rb =  qemu_get_ram_block(ram_addr);
+    if (!rb) {
+        return false;
+    }
+
+    pstrcat(b_info->idstr, sizeof(b_info->idstr), rb->idstr);
+    b_info->offset = rb->offset;
+    b_info->fd = rb->fd;
+    b_info->fd_offset = rb->fd_offset;
+    b_info->page_size = rb->page_size;
+    return true;
+}
+
 static int memory_try_enable_merging(void *addr, size_t len)
 {
     if (!machine_mem_merge(current_machine)) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb23..d9dedc6d74 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2389,6 +2389,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 kvm_cpu_synchronize_state(c);
                 if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
+                    error_report("Guest Memory Error at QEMU addr %p and "
+                        "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
+                        addr, paddr, "BUS_MCEERR_AR");
                 } else {
                     error_report("failed to record the error");
                     abort();
-- 
2.43.5


