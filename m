Return-Path: <kvm+bounces-31091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 405AF9C0227
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B61F01F2265A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BE91EE019;
	Thu,  7 Nov 2024 10:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uvc1CkBk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="szww7YRD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD681E7657
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974912; cv=fail; b=i2wYn835ckReBs+2cckZm3p4PgYwPsg+ZMYpJwMNPcF7jRG/IN5KYffcvtmq9KHesjvt0Oq2pqfdRrwBKVBbNBBGLIgM2hkFoatFwyiiGjg75AtUMwjrSt39GxBpSbUfROvEekfEg8VxGw6fxxed3HlxBv8+C+0w80nuLAw/OC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974912; c=relaxed/simple;
	bh=szafWKNGGmuiqy2q+eLU33TjN2gTs0ASIBKuqhdmXvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RWrz+bFHL2VqYH3zcqZ1HOdus+6IJFizcVTg4nvxpJyK/dlIdTaCGlTjZsbK8RgDklNCooj+Poh9sYpdnuc6qd6aDX8vMBR55EBCsJZFF3yFBX9vfRSm8G07xD+vwBN+REGTnL0zKEe5XBLjZrTVnEVCa83Hu3yyq4z+/sKS9ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uvc1CkBk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=szww7YRD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fwNd026505;
	Thu, 7 Nov 2024 10:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GEW89da9mr5UnO1EF3nQ/iyj+HstLwvCpbUPEV66wKo=; b=
	Uvc1CkBkLL98EI8YPl5+lpTvsiA5+xnjJVgdLJXPlZSLXIkzTYgS9wIpGlbv8kFt
	L2ouy10kG0fpqIc75633nIfjrItRUzdzZ/ciEMv79VArPF3lZ+/mnMMQqhbXGGJ0
	VFHDIVT0V5kOLFpNG4q4IY3M9VMEBgLGFEF11Hq239BD6QoBxoqFm4LV2Xg5rE6I
	6BaaVQfC6IHQIG4OwkrMcFXSm5qNY44pPAkj8VZz1z6oKszN2wG633TXwdFRjZE+
	ivVuNlS2MgmtKbSjKt3Vzj7th4jxRj2Il+1iGXt9NVN7i1gvtyXDMI+VxDh3LgLw
	s/bPUWpcHWOdYBlh7irTMw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nav2a6rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A79xIGE036170;
	Thu, 7 Nov 2024 10:21:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahg4wbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdagLG8hgpixWjks6BgEGYuWcKedOfrqRO44/hzfEFweDgsePQ5DkuPjUalSF5JgXYl42wrdGuWOYwJETG8G6Fna+lS9ccWt2Wfci/MRyQ36wY4Isg2rcduNYYgkkRhP+K1LFUcCD19RlywNOWAGW66/qTRh00ng5gfyQY+orQwf5ZJqVpVEPA9d6PNGzjdHci4uWiiu4Z0DFa5uHgrv8mCJjrg3OoFpyegXlBbofIJPjkCXA4EENIWA8KKUI2D4Xx0jqDoGVFnIikE92P8QTd1fG2BQNbgNt8o+X3DzaTRGCYzK2htDeksGe7tb3IVcIPp7q7ri38PQLjGv1lqVqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEW89da9mr5UnO1EF3nQ/iyj+HstLwvCpbUPEV66wKo=;
 b=idL3G1R1fXxWVsAzKfbzi77d5+Zv8DuN6NBt/hEK/9+rJy1i17H9i94vRyTwOfAuuTO083mYA/wN9rEn9SqeBj7eRB03yyhKieXQtMzmV5qzYMzO9QVQbxW7tNC3wGT/H2iMBDlsu8VDOKYEzhSFWgR01byzjkmMSciH52ScH7FdRcOY4Oj9Sd4wdUpM+zVYzndiyUL/ru/PI/Os7y9PTWNXm9iu91TlX06r5SjNlD8q/UPdUG5FzpJJ5mQirMBwdlGTTxLcXcuWbHe0OZV32MC06lMermEtucvr6Wk3sp8E79uTZLNaUfMjQ/aUVtTPR3SB5IaADTuUnQrRjUvnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEW89da9mr5UnO1EF3nQ/iyj+HstLwvCpbUPEV66wKo=;
 b=szww7YRDugIXZ6ZrHdGsFX7RfYfHq3yGvDdXer4sRCHMMHghoy9LdAzG3tdLM2IBo3lXXr7fo8dvP0zUF92h3H2/CEAmxYLZ+Ies+Lj7SSoq9t+JREDPmSjGCAAQiWa8KxbWttoireKRZpF0UWHQ/ktdJS3JxY3pohxkABJ59+U=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:35 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 3/7] accel/kvm: Report the loss of a large memory page
Date: Thu,  7 Nov 2024 10:21:22 +0000
Message-ID: <20241107102126.2183152-4-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107102126.2183152-1-william.roche@oracle.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dec6cf1-bfa1-4616-c351-08dcff15f540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?97t+X+HCxZTRxlhwYqe+PBAIaFfJJfS3pt8g/dSvJHg6f5TXcFpOG88Y/i+q?=
 =?us-ascii?Q?HIdLPjgrj6Y3vygCn1vxQY8ZJbRISym0QHObHxs2vYfmoZL6iaZtDABs/aGt?=
 =?us-ascii?Q?j4eFBd2TylI6VpV0krm1/5P3M7CvZpCKZXnpT1RVtLpleruk9PDn4OVZ0fyP?=
 =?us-ascii?Q?Nq61JxNNFRb7PtTeLREz9jMkfjQCmCVdFjIRfElQB6ysZZlI3v82SjqRa46r?=
 =?us-ascii?Q?CQrQt7Jh55ztSYoSPaxPTOtHzTJFIU366lwthTlqByfDDMOVD6hfjf1W7qqx?=
 =?us-ascii?Q?oRNMlnTaMbKib16TL6ECwphuQbBGEO/NmtzAj31G8fv2UTukq/8gF3RrLP8/?=
 =?us-ascii?Q?SYcC6MJekZBoMAEPgV+2P/Jgck7WaYCeb7gzTK6X/0oTWPHA2oZJ0Gw86p2A?=
 =?us-ascii?Q?F30jqNLkcJNpXS8Nx15Fwpz+2nbXm5DUYfPDwvY7ZPb7K6b84q7plYFyt7Qe?=
 =?us-ascii?Q?Dm4PvRpfD+FzsYovmmqcfjuh4WlM63+AaUlvHm0mj234URcOP/2mpEMb7JfN?=
 =?us-ascii?Q?Cegux9Ymoqu+BZ/R9jVS7kaM3XQGiCRtuQft1SYyeH+0xuWF2uNvNY1xtEna?=
 =?us-ascii?Q?pHPao5/ct7eJf/KkUydjUXtu5d0kxs8YM6dE9ULsXc4iB1EhQ1GaifYqqqSl?=
 =?us-ascii?Q?xJ3GiTznbE2KhfNHb2/4FIOJYLUBex+Z5EqR/HXBZW5R9R3cT8GE+osuBK4O?=
 =?us-ascii?Q?sqmcwqTes9nR9akFBQc72WFndqG5uy0yj7HYpUeB/UG2Fi4VLrDWCT19HRNQ?=
 =?us-ascii?Q?AU/bbYtLRKXrbRNXxauMyl6X9Vvnx3XFGF7vuMclnbxUall8/NlV4No13N12?=
 =?us-ascii?Q?xtuB7VX58G94OVRwhMLkXzv36+4SIlZFkF7qj48q+YjupuIJ6wBtZgT33zub?=
 =?us-ascii?Q?xciyRgqspI2O6EykiuGGhBRVPAMtSAvprFSzRZNZ/3xVJwP6Kr0H8AXn1rDw?=
 =?us-ascii?Q?ZCnYrKymvM1uAe3gL/JbvwRgTTe/JIkGqep6iXJZFlzfjp24blZbHoYS7wuf?=
 =?us-ascii?Q?1kawieydrdbBahWIyibx64jWGssL0IPrSYfk/HvcYs+S4cXPPdXe4LeUfX8R?=
 =?us-ascii?Q?++vGEHsDbFcnGEAgZRcoEoFlr0YFiKQlkx2R08gJ9qwuy8fevShMC5UFypiO?=
 =?us-ascii?Q?KGOKqVIHpnyLRR2h/NnuW9aG6+0I4olg0NO+BApqsVVjOKHX6mgQhSX1MCMf?=
 =?us-ascii?Q?ZP8E+I4NdJH/wZWHWMPYQmSpoLOAirv/9tWaKiTjS5BLdd4OT2DBAeAejO/B?=
 =?us-ascii?Q?G+bqeZMHvW38KnDTouUVVTtb6IzDGKR9rUzhXuhidSkIrJKAMO/hEskE0EOF?=
 =?us-ascii?Q?Yv8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IEoP93QSaolUs2Ud+8U8X/NDMKtIoN3i5nU0qcdH+uiUQJvDZqUs9AeKM9nQ?=
 =?us-ascii?Q?8QYQ8+82C+o1JpDknITSSZsaV+5iigjxbNzxG6R0QLsZ+XAC+JV/7uKkL/RP?=
 =?us-ascii?Q?W2dCDBKS3Xxskyakx5gqweEFKToiX20P06NYilxRYicjYsxwHdYknpQNTh7t?=
 =?us-ascii?Q?gxn0P0mqPa+mrbVz9zS0wcapvzLyA0lwLV0McW3PLToLIraNA7Q0AW+/z9yX?=
 =?us-ascii?Q?suvVwRAHa+PSqT4R+A4+t/B3HNgeaOIMjNacULZPe/XIDm/6VwUmwhZY8EUu?=
 =?us-ascii?Q?eC8aRsOJXtkJHCle+j97u9hYTrVlhS74W1dVWwW5WE9PwZwVruWYP4uEKuRi?=
 =?us-ascii?Q?Zrj/TgsSVfOKh3z5HHhJN7c+nYwPl2oTH4RtApBRhTvsl9MypwiDD1w4Wvry?=
 =?us-ascii?Q?STmFaKJShYvpZfwPABhXylYbsVgmDv0Rkna8fG4piOpPGtgExpBznfZA3ivB?=
 =?us-ascii?Q?Wg/Y5HSnY27YDrZd1uFfAN17ZnDCKxLvGWmTtzY69/HhFPWu42AeQ55o82VG?=
 =?us-ascii?Q?+5ZXvaVuQ20AdCE5oJJz//4ikG53bADdZt1ZvSvYKwwCGca656u4mAQjYamN?=
 =?us-ascii?Q?bKU8uDweFT6sLfUv25cbnbz9B0/dIwMyWdv4FK2W5ZqIJwF0QdHEJa4YExZr?=
 =?us-ascii?Q?kcGp3MH8Bo5sjRC/zhzXFJ3SQB1eRkK5evfeugEz8lBhv523anwcA3QehehY?=
 =?us-ascii?Q?7NGEhTyhbBk0bBIilFoHkOMdMUzP6EFEP7g65umrHItIkHqAXwWWJ2tZ3f4s?=
 =?us-ascii?Q?n/9bJw5ENTThxIC0SVi6gN/T+xJ0ICxCs8NUbYSUdRRvLHB3XQ0wrkpHoiXA?=
 =?us-ascii?Q?gse0G+Kgw0UTmJeH2FCAkrMOKX59xhNQN8DWzMgumFLhmRbrQuUZBYVxfEoa?=
 =?us-ascii?Q?5tVjU9S6FqNkGAZSiDRYYi4hdNHWxkbURujxW5GK0lUHMAn9n//K45iz/QgK?=
 =?us-ascii?Q?ALeorUjuvQOkhauFNpDjThf8jYlAOqmH+q5IelSlrRvIlOItObfpia/Xt/4c?=
 =?us-ascii?Q?okZ5LvKlLI9NCwNujrgAl9yGrs3R1HAWwHnGzntzmF432A9fhjVt3s0FEjiu?=
 =?us-ascii?Q?jBCNzcWanGn7hfc3GSvsVua9WhzS0SI9k3YTOzPvCF7JDhNLR2dLDh5N2MTt?=
 =?us-ascii?Q?vpzEfNJiIcyzJdJ/95pKWAZBcjybckySsznjQKzJ2fzkfVdW2ef5jJYMvRry?=
 =?us-ascii?Q?IIbwHcGSSO2dC7R+VlA4o85jh1vQDZCxNIoH11NaJaJjUq7Q/P6rtQdk2QMp?=
 =?us-ascii?Q?lu1SBDJo0WIv4svALtMjH6vVhR57Zxz/WgUVpp6VN1nWuSqbNLMnJBhUYfd9?=
 =?us-ascii?Q?qSPpA6lJ1DGWWivp+HP4tBI7s0PVSeBiEKMk/ykWPlqf9uwwAA8oeZQs0pj0?=
 =?us-ascii?Q?TVyua2Yx1IYOaAuDuMzqUsTANW5sBBTdepS2fK41Sy2BgVA0ZPIhd2FjXQB/?=
 =?us-ascii?Q?PMwDrU0NmNWp3Wejb6g9ldUf8CPRibltZ9ShIWZBLx8oSKZLNXh7Q8ZibejU?=
 =?us-ascii?Q?zVa9qgZdRtuiM7R9cDKaasSLiFHn5DRJoPUsWjknRRUsuYHorGNP2XoQsmXR?=
 =?us-ascii?Q?GYc9NCogfl7iiMRU0Au436juFtd3XdfDI2WWNuI35xCqxfeqeTbueXfwwT72?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o2/YPRj9QOF8HRw7CLL9abQdVOVtgf2+CErE7CNaFkSmPUUrmL4klUJgC0EgY7zvEWeenFYed+DfrRjEL9kyUM7ptWXtYb+SrETsJuQCJYGKjtn0jEqFuju53GGPCJuLKny8gValgCJCEcXBXbpv4N1v4Yo1Vtb7/HbXAcQlw+sRqbXB3tDNC6osqUow0k18NAN2zYv5eaDLuKB3PS4qpKTfJQha7D3nE1IQdpfkfs4m7vbx8OXuMxdh/NBeVTWUvN840P6sOpyWvl7zWwL0XFEIuhqOH2KDDZcnoe60ZWlXG1HDQcJDF4IbHwRfTa6Jumn7Oe9OxkLMCCYNIZafGYERXjlTlEOwPbEUIPzNA5RdQuD8g1Q4PJZ5rYq8QuZWNLPVs2xoVcKjtZEJzHTyDsZtF++AXh/brjORnQg75GhBGy5ZD3+XYC8QftaLHxvp4rbqvIElgRcrQQJ62kyP+zSbW70DAsX7ZNKIB6+AMLn7avp61SKXkgCeuFaAV2GX2ZEB3ee16K+7Eegy4kO8mbgfDzTuF9NKSd3j20erRhMtOe+rGQChvbpeY48wp8YpM9jBJKf99TKCBzSGVd45TGVV1f6tHzs4RaaoWirOPRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dec6cf1-bfa1-4616-c351-08dcff15f540
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:35.5404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoNXaa6sW46nxudtd+/zKzmYNm4JP0okX1hp0aA3SZDTMkoJobtMGuvtIRsr4WziZluf03+eUOOjeZM6YOJWAZ4spvL7QQYN4IRAd67ZYrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070079
X-Proofpoint-GUID: ysV6_aSQbQrNnm1TU9BFzERmfideuWi9
X-Proofpoint-ORIG-GUID: ysV6_aSQbQrNnm1TU9BFzERmfideuWi9

From: William Roche <william.roche@oracle.com>

When an entire large page is impacted by an error (hugetlbfs case),
report better the size and location of this large memory hole, so
give a warning message when this page is first hit:
Memory error: Loosing a large page (size: X) at QEMU addr Y and GUEST addr Z

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c      | 9 ++++++++-
 include/sysemu/kvm_int.h | 4 +++-
 target/arm/kvm.c         | 2 +-
 target/i386/kvm/kvm.c    | 2 +-
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6dd06f5edf..a572437115 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1284,7 +1284,7 @@ static void kvm_unpoison_all(void *param)
     }
 }
 
-void kvm_hwpoison_page_add(ram_addr_t ram_addr)
+void kvm_hwpoison_page_add(ram_addr_t ram_addr, void *ha, hwaddr gpa)
 {
     HWPoisonPage *page;
     size_t sz = qemu_ram_pagesize_from_addr(ram_addr);
@@ -1301,6 +1301,13 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr)
     page->ram_addr = ram_addr;
     page->page_size = sz;
     QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
+
+    if (sz > TARGET_PAGE_SIZE) {
+        gpa = ROUND_DOWN(gpa, sz);
+        ha = (void *)ROUND_DOWN((uint64_t)ha, sz);
+        warn_report("Memory error: Loosing a large page (size: %zu) "
+            "at QEMU addr %p and GUEST addr 0x%" HWADDR_PRIx, sz, ha, gpa);
+    }
 }
 
 bool kvm_hwpoisoned_mem(void)
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a1e72763da..ee34f1d225 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -178,10 +178,12 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size);
  *
  * Parameters:
  *  @ram_addr: the address in the RAM for the poisoned page
+ *  @hva: host virtual address aka QEMU addr
+ *  @gpa: guest physical address aka GUEST addr
  *
  * Add a poisoned page to the list
  *
  * Return: None.
  */
-void kvm_hwpoison_page_add(ram_addr_t ram_addr);
+void kvm_hwpoison_page_add(ram_addr_t ram_addr, void *hva, hwaddr gpa);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f1f1b5b375..aae66dba41 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2359,7 +2359,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
+            kvm_hwpoison_page_add(ram_addr, addr, paddr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index fd9f198892..fd7cd7008e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -753,7 +753,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
+            kvm_hwpoison_page_add(ram_addr, addr, paddr);
             kvm_mce_inject(cpu, paddr, code);
 
             /*
-- 
2.43.5


