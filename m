Return-Path: <kvm+bounces-57753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FE8B59E16
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBF06482D56
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B17637C0F6;
	Tue, 16 Sep 2025 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="An/sSNps";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LDomMsbA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72357301713
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041105; cv=fail; b=uWRbJ6LwpLuaFPk3ylP7tlYQBNwdq8oZ7XO17r1Wl79Id0FrQ3lda+QPVgxj156+Ub49QkNHVQI8rgdBTsKaGMYw7FM3H180P3MhYXTUYH00Xf43opQ+6eBR5/QNYhD3icSffhHNjc21pLsThhcm2eGeTw22cTYRffF70UIqFGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041105; c=relaxed/simple;
	bh=EMbm4Dl9IiuEKas+9bMKQDYg70gdbzPoK5P6x93PUsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bw1vamyGI5iWH7D/toFAuZGP/1tCOBRpPGayIVpJaDEyuGaJOEakVU6a6wTwQKUuzHOO+Y5cVH+/BNtDcvEZblGHhTOwn5PyrH/JOO/HrxcGxqEEsBZsKB9aH7FR7zp88tFw/3OIXMhzJgmO0S+97kEzNfesgMxlXtxPxrFlwfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=An/sSNps; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LDomMsbA; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GG8wdr3523588;
	Tue, 16 Sep 2025 09:44:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=28S7dxqUVFyCAlA1NqvrD0FL0cbpON6tRYLp00gG1
	no=; b=An/sSNpsbW+QOorMqMDAeAAzTIj3e010ATgASRm3TIoMusOA0MMlICAS6
	VDS1EvWyfBZeihjUQFHDqUV1d/EhOYkDoEQzRe9PBwIf+efW4kl21BxvXZTLtdo+
	tcLsP9jK3exzRG3hFu3MhIoN+M9fRp+vMFNPfE0grQFX2Khf4+rhjo940GylG8a/
	dgmRwXja+8l35P7gP3TzJQf4HbIQy5qh9WyKvQvRUg94b/qv9d4j7RnLolpYhYMU
	2yfHHd3FDy4rT81whf0w/E3v3AvP3Ac2Es/5NIYfVjHu78+P/uhs4RDogo/e+Yak
	mCHdFTNbpYrg7EsWKo+ia5m4nRbWQ==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022113.outbound.protection.outlook.com [40.107.209.113])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pwxtsdt-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HK5D8DcTyNhs9kQ1pHG0yuo4O0GPIm68oZCDe4wXGSFAUrCOarktmoftaLb26lXUyxcxX1aa/c6ZVkdIKRnIHkIw+4D3r8CmDwYpyME/s0gf4tDrj+8dyW+VfTcf129qnecAMc7OGNx4tSb2VxtXZRkDTDGtzPs5xP5VmzPSeblxr30C2gRwsVR1i0af76EIq51RVS0SF5mGpdMsO8NlHmKiIJG6Z5K84rd02agEgsrUEUesUdM1IGpdS97xLSJvuohTm2ZokhrxJuhG+n1MUeoKQw5LSbgQz9I3NVP1vvRkq97Qn7OFow9s7MkKF/KM/E/FIsrwe/zGjRZZVdUkQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28S7dxqUVFyCAlA1NqvrD0FL0cbpON6tRYLp00gG1no=;
 b=IhXQvYsksEK3iAvRmBhKKLqbfKvsNnc9KkBZAlbIhEgm/dDbiGqbX+wSwCnkCtZsjVu3+sA++Brj6TJd17MqHOvrlIBmxodAqQSH1/TUnwHlchTbaertsMhOypeFW6WU+lF5Jbf6EeECLdRoUyuN4XEjsK24skOiHhubaqWFIMGc0poneXB2tLbYQJxpFRBSxuEr5tNuzaZplcjxQJFYIvkIMOvGMhxfvMNXcjGlNx6hBV10+R9TGgwfvZ/aCPqf+SUCaJnmjVIZCQBnR6ZLN23zwkDWy2/Z7YItEq8xRtINs08wqBfGv/fR5j6rdZ7EJSyy2yFY0Mk/+G0LgkBBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28S7dxqUVFyCAlA1NqvrD0FL0cbpON6tRYLp00gG1no=;
 b=LDomMsbA0pZsy4xUSLO5V998EE1rroU9uKA4Ijwf3vNbnaBF4FDek/gWyvcJqCAj5NEVD6uRtzWsaNOXESknhCLPX7A5gSGoqfLM1Ti3vjR7Ihj72bqzGY39KvVRAgjp7Oop6orVPTqL3cNALRTzksJv00zpd8opt/JRr8+o15ZZJ3BC2XVHmv9dzREInBYUmtBavyDr7yJkmcJuNLcKH0suEdk9Gal6P4+1OSaYgZpP0MiU3eraMaioAUiyuyRt9v6wDOVBzULOKrMK20uPhoYicTBsAZtCnwclUFr7MuXFCkgOsCQSSXDZa1Ey0Tx4zcN2++D3VZRSlmbilut1FQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:50 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:50 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 11/17] x86/vmx: switch to new vmx.h secondary execution control bit
Date: Tue, 16 Sep 2025 10:22:40 -0700
Message-ID: <20250916172247.610021-12-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 5539076c-ddee-4cab-a9f2-08ddf5405a56
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5UdFvBm9rwiLvQQ3/tfE6qTk6NveV8m4XD7co4YBlUuvO7BVLqRq+5Ks7kxW?=
 =?us-ascii?Q?xRGe4qObXcbpw4FzevKem7zK6ZtpOCdcXyif5V+AKlB3KC+TaxG18rWc0Cih?=
 =?us-ascii?Q?ai8gZfaawgbmYlG9F+o1gMuM44XhPzSgW9rEriu2aczvmNkCkHXJDZFabsLu?=
 =?us-ascii?Q?PiyIC75zoOOZVJDl5D633HRCYTZVdt6uuy9sGqIIveRdhVew2X070jGygURg?=
 =?us-ascii?Q?F+fpleMAV+vEbnmT99mLXpb3NxP5GA/xgwSJTDqkkZ0pwXniHXQr8hemeGpA?=
 =?us-ascii?Q?JXWE4aFlC6PCLYvSaAyT2ez9uEi6u/1cUeaBw/7sglvT147zqo9qJYv+yCbW?=
 =?us-ascii?Q?3lFGnmjn6muDww2nLBw2wT59sliOLSWb+ZUTFZ+Thcmyr2wHqeJgvBG22a3v?=
 =?us-ascii?Q?q00AsF/O0H4dyGkx233PY+8Ptdp+SUDln5KMjLyUmL9eT3DJ5EC1m6kt76Wu?=
 =?us-ascii?Q?QajURtyBvsCZOuYJ6nFzYMRbPEkHF2e6FbfXhgEdMNAMwnwoTonSL5yLiLbY?=
 =?us-ascii?Q?xDCWCtvPqQWWerM0Vmr/GXo7Ikf90LZ2tchqiHXfJ9c56pNK0mckLVzONEgb?=
 =?us-ascii?Q?mHSI6uYyZV+yFvIyioL3ezyHfjQiSnmaYf1awuJvosIq63w5/0V1kPJ9U8wZ?=
 =?us-ascii?Q?eSaBOyJp//haPAOBT+ctodBgqrHIuTBz/yS9P/plQadgNFm7dMQFoUCMVBe8?=
 =?us-ascii?Q?MJdvGSf62c36sfG2g/xg6P3Rh6u0EJQc9+tx5K3z2yKFDxk3vmFYLdGMVHnN?=
 =?us-ascii?Q?ckypfc3umpDpaMQyR5f41GiG9Xp6tSzvXucpizOl9+1SqkAeKKlYlYBIILWz?=
 =?us-ascii?Q?zt6OdggWHu4ojED0ttVceyKHIBTNWWtU8j8nIJ+wlqvoPjlN7BeaVQxUl1Qg?=
 =?us-ascii?Q?EVofiz4qB+KIvV3MNO7A/X7ft3mJVzCHJHe+wPaqukoy2xemA7w+IZ5BnACU?=
 =?us-ascii?Q?ogXZ5ABCYbclihiYJpaiLm8jAqG09/FAw8Vqwum/VDtGyMNE2OEqaOopKfVg?=
 =?us-ascii?Q?n8MhbBitYRc912zYXUQJtglgF93GmWv11PXzxitGsW7qB3li2wSLAv1wX8Ah?=
 =?us-ascii?Q?Z2zFPXTYJ06zzudo+jUYaRZ038Ugf+WI9UH1rQ26LJxovVS6YF91S92WcNAj?=
 =?us-ascii?Q?Y3+oyJhCgUrEGDSSf7tzfHawypdVDFnUd7sw9AXLzyVbUPi91yzb2o/S5y8y?=
 =?us-ascii?Q?4PHhfstPHr86+Ebx57ZbSNqyt5RV4EN5xWEWobzmzUD33G6GvClJfutbGSK4?=
 =?us-ascii?Q?SaAU9NNAX1iQf1JSpd7RZ7Qa4Yd122tDohsQGkbudIgbmGHMc4XjbaAN4F50?=
 =?us-ascii?Q?DL1gD7PG7cj74BP6ncE8DvrOLlfk51PXxunCiAFsTHjAp1OaI1ApuesUQnSd?=
 =?us-ascii?Q?17mRn/ij+tZB3IYmRRkPafd9E1ieFLinJOBIdY4kd1DPsHcZMwjf5TXZ6Abh?=
 =?us-ascii?Q?wVLAJM4d7apCETlNb1yY7amcSgStDFeO8jB8U6xjuJNP2RnHCOU9Aw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PxFRR/kO1Z7j6D3xLroG7tLJjwYxP4Nu8mFmSROoHQZWwGcT1fgTgnoOwvdf?=
 =?us-ascii?Q?97dEEOIchrucpwxmkJKNevGlgKEI/jHi9mogfbxywbZBpieaH7nQWWyHS9om?=
 =?us-ascii?Q?ceA1GasCUFnlrwyDNsNPmkXg4A+NgtkCZRtWxi45WdJWMmAACEqnk6CdMP17?=
 =?us-ascii?Q?F8vAXQpIvDLWbk7O3D5eX0N1pazDw2Pfxy4nwtldoOmGK41dH6QCC1pRJudJ?=
 =?us-ascii?Q?NI0n8rMwebpd8Vqe/gAaO+4ljEjKdNLjHFiC0rc/f7WSbokr2LzlBiTu+DT6?=
 =?us-ascii?Q?94r+6PwJAxdrTo7LKs/H2MF7L8fSZJJoY1aD66rymL7Ib1pPgqemt+NnElx7?=
 =?us-ascii?Q?D93bDwrqzCNR6c7zbw2CizymEPEnDDZIs304zYj3R+YxCJZhVcXbzXY/Z2j6?=
 =?us-ascii?Q?Fh3ZIvgIfzBbgnSTOqTQZGVIsZjrI5rJFIghu0Ay1/2ZUmqhMFzhx7eRpvoO?=
 =?us-ascii?Q?XbjqyfcwhY0IC1UcFsSz3IHtS6R0q36eIRhJQzA8abqXuVVO2iHZPAsnMsVz?=
 =?us-ascii?Q?112wn1FvLpOBwAlGj/FBy6DeJGVwjZsGv9/7xQLOEruf/mEuD/JXdZZErcz/?=
 =?us-ascii?Q?1IHGBfKC/QYw/SWL6Q4JI5alfQqmtS42cYdSsx3hPZ+qY1FQKrQwXcpVK7Id?=
 =?us-ascii?Q?2lWiPE74KUu9BW72oaZml0EJBT+BDng55IjuZ475M4qQbMd+UTah6WlqcDS2?=
 =?us-ascii?Q?q2Yd4JCLFWdcCFgqvvuJscjP5pFZlUaF2DW8E1Eua8nT+Zk0fbt2Y2C81/y3?=
 =?us-ascii?Q?3EpoqpEHjDLHmKJN7iXjMPBYePsEppE+JnFJsitZkxQ/YktMlUfOMUxfcAeG?=
 =?us-ascii?Q?VCIV9Y/11iG18OZV+UQQ0RaSH6g86ax9B3S/W2lQ6AARa5881AAxjck5J/2C?=
 =?us-ascii?Q?HPHEhb067TpvQfjc8bimZzpZhBCgMAbOPLb8eDDF54uLOu/TXgP6P2MMnZhq?=
 =?us-ascii?Q?qXKI3Jo7xHfpKRQhBKOvCjnjRd6Hxk3SXRS0fgPdptxF0O8IlNwg44gn6MN/?=
 =?us-ascii?Q?Wl2OrOtIRT8ya57RhBczAcLjHLJ5y+0QZuQcc58kIWIR+bYt14XoncMCcRGd?=
 =?us-ascii?Q?3qyHcRTCzKJOviyUbGnQ4xGr7ZyysKJZ+9Ai1n92zjZi+0AMGcKiKQgcTNOK?=
 =?us-ascii?Q?PtbZbt5K9btmy2T4hk9CYMNW6+DU5srlJTef0VX7dDMDNQLow86Bp0CEYZV4?=
 =?us-ascii?Q?7jmWoqWFtGiPXZgkLYwLGF3ttZ1liBjTsCw+LbEvz4ahghc9HO71Mbhop7wD?=
 =?us-ascii?Q?TFXIRKqUw8G03sDx74P4TUWW10J1BsL7BkkHGElwkeh85CMS82RdOhRhjrXp?=
 =?us-ascii?Q?Ibas/oMQFN4HDkMf5Ru4Et9/LaDqs6Shph4y4ItJB+rbujivUfhrEwpTZKsh?=
 =?us-ascii?Q?wRxLUi/LNJx61riFb/v0Oi4F0+GNjh42EQQpD+SIgLO7Psh8OpNE8xXxcf20?=
 =?us-ascii?Q?nNDzjEjMimUArdBe1HCeBjnFSZAi5k6RKweFFgrzjec/GrS97KzdGty+XPsI?=
 =?us-ascii?Q?LOkV06Unguhl6EnV3BCevva+AYry3ggi33BNoAXhSqTEBxJu+b2OBnuLiyb4?=
 =?us-ascii?Q?t3nURtrx4+4b3E2EWcapOUDYx4eUt6zixqdF9qzmOhx2AolY29RpCsqHKnr7?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5539076c-ddee-4cab-a9f2-08ddf5405a56
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:50.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cs51gAt9GqyDFroIADVp/kBPY7Bzx6IqsESSLdwFK9v6hFE7uo+QbbznxuXNY+2WwaebDJ0FMjO0Id6+OqyTVZdAqsIUuPXZoFxE+qzo0fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Authority-Analysis: v=2.4 cv=WeUMa1hX c=1 sm=1 tr=0 ts=68c99403 cx=c_pps
 a=PAagVXhlguM9sGT4qHQNdg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=VDcyZ7pip54GIliP5Q4A:9
X-Proofpoint-ORIG-GUID: H7jk9MI_3P3-4EMthWlj-7p3FUb0k4Kz
X-Proofpoint-GUID: H7jk9MI_3P3-4EMthWlj-7p3FUb0k4Kz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX+i7M3mZnBX8D
 85db2sPWp1azUAT17iNnQAIta/0haMJBDpum0/zSoXJDVg7wD9R2T6mfdcmYcAhtll7GxcnCFLs
 H0JwuXalAi/63J48/TywO9YivmhWGcKL/Gl8PElRpD+ejaT4PQLQyDEDcLfdRPEOAbd0lZi14bf
 MWw+x63FJaIoJKh6aUSAwTImFCDPovMS5d0HlCGhZeUN2A0DL3uHDx/r6ZlSO4izlzb1dleGXyY
 83IaM8pSS6nzwISr2BJb29f66v0mB/DaMBS4lb3v/CvxH/nz6/GS+JJIHYQrCN+nNFz4aSbeu3Y
 +QfjTDWmueyuQoOtCuJ+UqLgOwL4EvDsPo4Hk0RtwR/dmWjHdeqr02G8oDQrLA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's secondary execution control bit 31, which makes
it easier to grok from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |   4 +-
 x86/vmx.h       |   6 +--
 x86/vmx_tests.c | 102 ++++++++++++++++++++++++++++--------------------
 3 files changed, 63 insertions(+), 49 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index c1845cea..f3368a4a 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1107,7 +1107,7 @@ static void init_vmcs_ctrl(void)
 	vmcs_write(PIN_CONTROLS, ctrl_pin);
 	/* Disable VMEXIT of IO instruction */
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu[0]);
-	if (ctrl_cpu_rev[0].set & CPU_SECONDARY) {
+	if (ctrl_cpu_rev[0].set & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		ctrl_cpu[1] = (ctrl_cpu[1] | ctrl_cpu_rev[1].set) &
 			ctrl_cpu_rev[1].clr;
 		vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu[1]);
@@ -1296,7 +1296,7 @@ static void init_vmx_caps(void)
 			: MSR_IA32_VMX_ENTRY_CTLS);
 	ctrl_cpu_rev[0].val = rdmsr(basic_msr.ctrl ? MSR_IA32_VMX_TRUE_PROC
 			: MSR_IA32_VMX_PROCBASED_CTLS);
-	if ((ctrl_cpu_rev[0].clr & CPU_SECONDARY) != 0)
+	if ((ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) != 0)
 		ctrl_cpu_rev[1].val = rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2);
 	else
 		ctrl_cpu_rev[1].val = 0;
diff --git a/x86/vmx.h b/x86/vmx.h
index a83d08b8..16332247 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -435,10 +435,6 @@ enum Ctrl_pin {
 	PIN_POST_INTR		= 1ul << 7,
 };
 
-enum Ctrl0 {
-	CPU_SECONDARY		= 1ul << 31,
-};
-
 enum Ctrl1 {
 	CPU_VIRT_APIC_ACCESSES	= 1ul << 0,
 	CPU_EPT			= 1ul << 1,
@@ -689,7 +685,7 @@ static inline bool is_invept_type_supported(u64 type)
 
 static inline bool is_vpid_supported(void)
 {
-	return (ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
+	return (ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
 	       (ctrl_cpu_rev[1].clr & CPU_VPID);
 }
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 55d151a4..f092c22d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -931,7 +931,7 @@ static int insn_intercept_init(struct vmcs *vmcs)
 {
 	u32 ctrl_cpu, cur_insn;
 
-	ctrl_cpu = ctrl_cpu_rev[0].set | CPU_SECONDARY;
+	ctrl_cpu = ctrl_cpu_rev[0].set | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	ctrl_cpu &= ctrl_cpu_rev[0].clr;
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu);
 	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu_rev[1].set);
@@ -1051,7 +1051,7 @@ static int insn_intercept_exit_handler(union exit_reason exit_reason)
  */
 static int __setup_ept(u64 hpa, bool enable_ad)
 {
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_EPT)) {
 		printf("\tEPT is not supported\n");
 		return 1;
@@ -1075,7 +1075,8 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 		eptp |= VMX_EPTP_AD_ENABLE_BIT;
 
 	vmcs_write(EPTP, eptp);
-	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0)| CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
+		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1)| CPU_EPT);
 
 	return 0;
@@ -1129,7 +1130,7 @@ static void setup_dummy_ept(void)
 
 static int enable_unrestricted_guest(bool need_valid_ept)
 {
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_URG) ||
 	    !(ctrl_cpu_rev[1].clr & CPU_EPT))
 		return 1;
@@ -1139,7 +1140,8 @@ static int enable_unrestricted_guest(bool need_valid_ept)
 	else
 		setup_dummy_ept();
 
-	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
+		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
 
 	return 0;
@@ -1547,7 +1549,7 @@ static int pml_init(struct vmcs *vmcs)
 	if (r == VMX_TEST_EXIT)
 		return r;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 		!(ctrl_cpu_rev[1].clr & CPU_PML)) {
 		printf("\tPML is not supported");
 		return VMX_TEST_EXIT;
@@ -2100,7 +2102,7 @@ static int disable_rdtscp_init(struct vmcs *vmcs)
 {
 	u32 ctrl_cpu1;
 
-	if (ctrl_cpu_rev[0].clr & CPU_SECONDARY) {
+	if (ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		ctrl_cpu1 = vmcs_read(CPU_EXEC_CTRL1);
 		ctrl_cpu1 &= ~CPU_RDTSCP;
 		vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu1);
@@ -3643,13 +3645,14 @@ static void test_secondary_processor_based_ctls(void)
 	u32 secondary;
 	unsigned bit;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY))
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return;
 
 	primary = vmcs_read(CPU_EXEC_CTRL0);
 	secondary = vmcs_read(CPU_EXEC_CTRL1);
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0, primary |
+		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	printf("\nMSR_IA32_VMX_PROCBASED_CTLS2: %lx\n", ctrl_cpu_rev[1].val);
 	for (bit = 0; bit < 32; bit++)
 		test_rsvd_ctl_bit("secondary processor-based controls",
@@ -3659,7 +3662,8 @@ static void test_secondary_processor_based_ctls(void)
 	 * When the "activate secondary controls" VM-execution control
 	 * is clear, there are no checks on the secondary controls.
 	 */
-	vmcs_write(CPU_EXEC_CTRL0, primary & ~CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0,
+		   primary & ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_write(CPU_EXEC_CTRL1, ~0);
 	report(vmlaunch(),
 	       "Secondary processor-based controls ignored");
@@ -3788,7 +3792,8 @@ static void test_vmcs_addr_reference(u32 control_bit, enum Encoding field,
 	if (control_primary) {
 		vmcs_write(CPU_EXEC_CTRL0, primary | control_bit);
 	} else {
-		vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY);
+		vmcs_write(CPU_EXEC_CTRL0, primary |
+			   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		vmcs_write(CPU_EXEC_CTRL1, secondary | control_bit);
 	}
 
@@ -3800,7 +3805,8 @@ static void test_vmcs_addr_reference(u32 control_bit, enum Encoding field,
 	if (control_primary) {
 		vmcs_write(CPU_EXEC_CTRL0, primary & ~control_bit);
 	} else {
-		vmcs_write(CPU_EXEC_CTRL0, primary & ~CPU_SECONDARY);
+		vmcs_write(CPU_EXEC_CTRL0,
+			   primary & ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		vmcs_write(CPU_EXEC_CTRL1, secondary & ~control_bit);
 	}
 
@@ -3931,11 +3937,12 @@ static void test_apic_virtual_ctls(void)
 	/*
 	 * First test
 	 */
-	if (!((ctrl_cpu_rev[0].clr & (CPU_SECONDARY | CPU_BASED_TPR_SHADOW)) ==
-	    (CPU_SECONDARY | CPU_BASED_TPR_SHADOW)))
+	if (!((ctrl_cpu_rev[0].clr &
+	       (CPU_BASED_ACTIVATE_SECONDARY_CONTROLS | CPU_BASED_TPR_SHADOW)) ==
+	       (CPU_BASED_ACTIVATE_SECONDARY_CONTROLS | CPU_BASED_TPR_SHADOW)))
 		return;
 
-	primary |= CPU_SECONDARY;
+	primary |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	primary &= ~CPU_BASED_TPR_SHADOW;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 
@@ -3980,7 +3987,8 @@ static void test_apic_virtual_ctls(void)
 	if (!((ctrl_cpu_rev[1].clr & apic_virt_ctls) == apic_virt_ctls))
 		return;
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0,
+		   primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	secondary &= ~CPU_VIRT_APIC_ACCESSES;
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_X2APIC);
 	report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC access disabled");
@@ -4024,7 +4032,8 @@ static void test_virtual_intr_ctls(void)
 	    (ctrl_pin_rev.clr & PIN_EXTINT)))
 		return;
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY |
+	vmcs_write(CPU_EXEC_CTRL0,
+		   primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 		   CPU_BASED_TPR_SHADOW);
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VINTD);
 	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
@@ -4094,7 +4103,8 @@ static void test_posted_intr(void)
 	    (ctrl_exit_rev.clr & EXI_INTA)))
 		return;
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY |
+	vmcs_write(CPU_EXEC_CTRL0,
+		   primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 		   CPU_BASED_TPR_SHADOW);
 
 	/*
@@ -4211,7 +4221,8 @@ static void test_vpid(void)
 		return;
 	}
 
-	vmcs_write(CPU_EXEC_CTRL0, saved_primary | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL0,
+		   saved_primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_write(CPU_EXEC_CTRL1, saved_secondary & ~CPU_VPID);
 	vmcs_write(VPID, vpid);
 	report_prefix_pushf("VPID disabled; VPID value %x", vpid);
@@ -4247,7 +4258,7 @@ static void try_tpr_threshold_and_vtpr(unsigned threshold, unsigned vtpr)
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
 	if ((primary & CPU_BASED_TPR_SHADOW) &&
-	    (!(primary & CPU_SECONDARY) ||
+	    (!(primary & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 	     !(secondary & (CPU_VINTD | CPU_VIRT_APIC_ACCESSES))))
 		valid = (threshold & 0xf) <= ((vtpr >> 4) & 0xf);
 
@@ -4340,7 +4351,7 @@ static void test_invalid_event_injection(void)
 	 */
 
 	/* Assert that unrestricted guest is disabled or unsupported */
-	assert(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+	assert(!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 	       !(secondary_save & CPU_URG));
 
 	ent_intr_info = ent_intr_info_base | INTR_TYPE_HARD_EXCEPTION |
@@ -4580,7 +4591,8 @@ static void try_tpr_threshold(unsigned threshold)
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
-	if ((primary & CPU_BASED_TPR_SHADOW) && !((primary & CPU_SECONDARY) &&
+	if ((primary & CPU_BASED_TPR_SHADOW) &&
+	    !((primary & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
 	    (secondary & CPU_VINTD)))
 		valid = !(threshold >> 4);
 
@@ -4644,7 +4656,7 @@ static void test_tpr_threshold(void)
 	vmcs_write(APIC_VIRT_ADDR, virt_to_phys(virtual_apic_page));
 
 	vmcs_write(CPU_EXEC_CTRL0, primary & ~(CPU_BASED_TPR_SHADOW |
-		   CPU_SECONDARY));
+		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS));
 	report_prefix_pushf("Use TPR shadow disabled, secondary controls disabled");
 	test_tpr_threshold_values();
 	report_prefix_pop();
@@ -4654,7 +4666,7 @@ static void test_tpr_threshold(void)
 	test_tpr_threshold_values();
 	report_prefix_pop();
 
-	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
+	if (!((ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
 	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES))))
 		goto out;
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
@@ -4666,7 +4678,8 @@ static void test_tpr_threshold(void)
 		report_prefix_pop();
 
 		vmcs_write(CPU_EXEC_CTRL0,
-			   vmcs_read(CPU_EXEC_CTRL0) | CPU_SECONDARY);
+			   vmcs_read(CPU_EXEC_CTRL0) |
+			   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls enabled; virtual-interrupt delivery enabled; virtualize APIC accesses disabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4674,14 +4687,16 @@ static void test_tpr_threshold(void)
 
 	if (ctrl_cpu_rev[1].clr & CPU_VIRT_APIC_ACCESSES) {
 		vmcs_write(CPU_EXEC_CTRL0,
-			   vmcs_read(CPU_EXEC_CTRL0) & ~CPU_SECONDARY);
+			   vmcs_read(CPU_EXEC_CTRL0) &
+			   ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		vmcs_write(CPU_EXEC_CTRL1, CPU_VIRT_APIC_ACCESSES);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls disabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
 
 		vmcs_write(CPU_EXEC_CTRL0,
-			   vmcs_read(CPU_EXEC_CTRL0) | CPU_SECONDARY);
+			   vmcs_read(CPU_EXEC_CTRL0) |
+			   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls enabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4691,7 +4706,8 @@ static void test_tpr_threshold(void)
 	     (CPU_VINTD | CPU_VIRT_APIC_ACCESSES)) ==
 	    (CPU_VINTD | CPU_VIRT_APIC_ACCESSES)) {
 		vmcs_write(CPU_EXEC_CTRL0,
-			   vmcs_read(CPU_EXEC_CTRL0) & ~CPU_SECONDARY);
+			   vmcs_read(CPU_EXEC_CTRL0) &
+			   ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		vmcs_write(CPU_EXEC_CTRL1,
 			   CPU_VINTD | CPU_VIRT_APIC_ACCESSES);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls disabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
@@ -4699,7 +4715,8 @@ static void test_tpr_threshold(void)
 		report_prefix_pop();
 
 		vmcs_write(CPU_EXEC_CTRL0,
-			   vmcs_read(CPU_EXEC_CTRL0) | CPU_SECONDARY);
+			   vmcs_read(CPU_EXEC_CTRL0) |
+			   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls enabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4995,13 +5012,13 @@ static void test_pml(void)
 	u32 primary = primary_saved;
 	u32 secondary = secondary_saved;
 
-	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
+	if (!((ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
 		report_skip("%s : \"Secondary execution\" or \"enable EPT\" or \"enable PML\" control not supported", __func__);
 		return;
 	}
 
-	primary |= CPU_SECONDARY;
+	primary |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 	secondary &= ~(CPU_PML | CPU_EPT);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
@@ -6178,13 +6195,13 @@ static enum Config_type configure_apic_reg_virt_test(
 		virtualize_apic_accesses_incorrectly_on;
 
 	if (apic_reg_virt_config->activate_secondary_controls) {
-		if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY)) {
+		if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
 			printf("VM-execution control \"activate secondary controls\" NOT supported.\n");
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl0 |= CPU_SECONDARY;
+		cpu_exec_ctrl0 |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	} else {
-		cpu_exec_ctrl0 &= ~CPU_SECONDARY;
+		cpu_exec_ctrl0 &= ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	}
 
 	if (apic_reg_virt_config->virtualize_apic_accesses) {
@@ -9519,7 +9536,8 @@ static void enable_vid(void)
 	vmcs_write(EOI_EXIT_BITMAP2, 0x0);
 	vmcs_write(EOI_EXIT_BITMAP3, 0x0);
 
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY | CPU_BASED_TPR_SHADOW);
+	vmcs_set_bits(CPU_EXEC_CTRL0,
+		      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS | CPU_BASED_TPR_SHADOW);
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VINTD | CPU_VIRT_X2APIC);
 }
 
@@ -9696,7 +9714,7 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
 		report_skip("%s : No test device enabled", __func__);
 		return;
 	}
-	u64 cpu_ctrl_0 = CPU_SECONDARY;
+	u64 cpu_ctrl_0 = CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	u64 cpu_ctrl_1 = 0;
 
 	disable_intercept_for_x2apic_msrs();
@@ -10015,7 +10033,7 @@ static void sipi_test_ap_thread(void *data)
 	struct vmcs *ap_vmcs;
 	u64 *ap_vmxon_region;
 	void *ap_stack, *ap_syscall_stack;
-	u64 cpu_ctrl_0 = CPU_SECONDARY;
+	u64 cpu_ctrl_0 = CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	u64 cpu_ctrl_1 = 0;
 
 	/* Enter VMX operation (i.e. exec VMXON) */
@@ -10081,7 +10099,7 @@ static void vmx_sipi_signal_test(void)
 		return;
 	}
 
-	u64 cpu_ctrl_0 = CPU_SECONDARY;
+	u64 cpu_ctrl_0 = CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	u64 cpu_ctrl_1 = 0;
 
 	/* passthrough lapic to L2 */
@@ -10372,7 +10390,7 @@ static void vmx_vmcs_shadow_test(void)
 	u8 *bitmap[2];
 	struct vmcs *shadow;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
 		report_skip("%s : \"Activate secondary controls\" not supported", __func__);
 		return;
 	}
@@ -10402,7 +10420,7 @@ static void vmx_vmcs_shadow_test(void)
 	TEST_ASSERT(!vmcs_clear(shadow));
 
 	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_RDTSC_EXITING);
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_SHADOW_VMCS);
 
 	vmcs_write(VMCS_LINK_PTR, virt_to_phys(shadow));
@@ -10456,7 +10474,7 @@ static void rdtsc_vmexit_diff_test_guest(void)
  */
 static unsigned long long host_time_to_guest_time(unsigned long long t)
 {
-	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
 		    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
 
 	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_BASED_USE_TSC_OFFSETTING)
@@ -10801,7 +10819,7 @@ static void __vmx_pf_vpid_test(invalidate_tlb_t inv_fn, u16 vpid)
 	if (!is_invvpid_supported())
 		test_skip("INVVPID unsupported");
 
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VPID);
 	vmcs_write(VPID, vpid);
 
-- 
2.43.0


