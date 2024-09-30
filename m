Return-Path: <kvm+bounces-27713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5DF98B0DA
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 01:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F252EB21709
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 23:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB172188A3E;
	Mon, 30 Sep 2024 23:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BC/p+cCF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gzcTq9+f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134573E479;
	Mon, 30 Sep 2024 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727739313; cv=fail; b=ObCarM687t/55KA4gz1CcAZoh7ft/0YQVVFMT8LGg0YehNbU0/gg6ODgqGczqLckYZZ6UO9qp8dHGIKOwiYaHpoFamT+F5q8K1S2nrErCUUquw5u2NxzbzGe03phPfYvawObORPEuyuupUgnLlx5M/QJL4HHAJaj6YJhlXgvmkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727739313; c=relaxed/simple;
	bh=ttlcQXpakBNgdWSBDPvQXFCXpkT9jf3Bg8Xgfi5CX4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e4IBCovWUC1GC6kCl/S3stqJGxfZxDks8IiL0yunQkf8uWzE0VVBKg91RkcrvkPuuYyJ62Yc/ov4SiETwx0eXNe19w5uNQOlyxl1Vv5WNncyBOIVJJdoxjtJZzC+effpV/U5anS96XZG0BDzpgUJgI0ONBfmpnd5X2Chy5MkMM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BC/p+cCF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gzcTq9+f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48UMta1D020227;
	Mon, 30 Sep 2024 23:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Cs4v8GYve/ClJKgLPHbU8MPjXzCCLofZCuYeOGpi0ic=; b=
	BC/p+cCFuPPege1Dg4TA+FMFVUEebe0CrFeu9Dfz2UeIGfd9rwtFdhQxvOsrmlM3
	hxvGWcfUQ1UADQKOOIW+HVoUF/KpUDc6F3iAXE7yOuLzCMvi9+hikTmcAA0lTEPL
	GUS5WiauPltOGHUGbanYLG7+nqximlAAI0vFzk8ibwWY7B3IWZdEh4TE/ztdojIS
	x/aswZIMoqcKs3lZSC9gfLMUiwYvAaLv1x+BNWK9LiG63BuQf+CvcmvL0C3E79xP
	/s9kNKATN1VBsWCtOiljW/k53VFxNNqua/V36Dn+RR9hQGJB5k4aGtrtx4sQNWTf
	Fp70wYyvmdeF/NS7F7EDtg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9ucn2x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Sep 2024 23:35:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48UMEtmX012527;
	Mon, 30 Sep 2024 23:35:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x886g7k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Sep 2024 23:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bi8k82afrgFZSkFVmLlvE8QWnpnDrx19j9W4g+igI6xVDsIKbX9R5W/AmIARdl/5Q1U0G9z8hCL79jhicCwBpdGDA5WRJMYYmmqi8NRCkVHcfRvwUE6BPjY9pADYEk+GGkfDGLLRvgVe5CcJXoywhZmqmWSn3YXRTj292JK26LzAan7a1Q3o43IfdAjCQWol+VPyYk8faU6rGZiSyHq7lCV3O7w1t3gm7csuMP5RLT1Ipp/AvY6SWvaznp6QBZX5b2LXlRoVv0JFuJN5m8y+6k/z3DYQEBc17ad80ZAT3PGAzVll+rshYnqicCdXueMIBDR80GYDpnrgl48HVj2sLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cs4v8GYve/ClJKgLPHbU8MPjXzCCLofZCuYeOGpi0ic=;
 b=v1mfN26Di3r1zvXQHO4SnBln9oLJT8ly6ofmdrIsskRD7AJnXyLnKpwsu2wsEBJj1KgqDI1QzTdtjnrZ3DyWHKHMYOEqdF0lB8wrKWZ8FCEGc+QMc97u55s1+idZkNOoO9vWtqMfZBBKkss/YfRhCq1Dj6/FTNrtLaQh2/viNQaQgT507SFSEhUSThYMSbtK3IjZfX3sMVgZT8l5sOg7EjvzYxajwpMy+Ei+J8phGl9zlh6xvzSmdYxflMup+AykvTwROi2zZWVNilaHPG11wFMZow0MSssvpDCsC+WZg06I8/UqjUmhqz9/u+38cYSaf7umUXWFHEejJFYw1I3nog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cs4v8GYve/ClJKgLPHbU8MPjXzCCLofZCuYeOGpi0ic=;
 b=gzcTq9+fX3nOUt2zPWmRyreR2qCiF+6HnRnKab0pKz3hAlK64uZ5eUyaz4ab8AjlfZBFGgd9X8qHspeICAz+KluqThxyQLw0aC6S+LP2Sv6oE6BEC1DP2q9IwW6Fi1wsZFCsWKRUKBCNmgqum3yhg337Qf+YSe7WP0gzmkWxF+E=
Received: from MN2PR10MB4269.namprd10.prod.outlook.com (2603:10b6:208:1d1::8)
 by SJ0PR10MB5717.namprd10.prod.outlook.com (2603:10b6:a03:3ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.13; Mon, 30 Sep
 2024 23:35:03 +0000
Received: from MN2PR10MB4269.namprd10.prod.outlook.com
 ([fe80::f430:b41f:d4c4:9f9]) by MN2PR10MB4269.namprd10.prod.outlook.com
 ([fe80::f430:b41f:d4c4:9f9%3]) with mapi id 15.20.8026.009; Mon, 30 Sep 2024
 23:35:02 +0000
From: Eric Mackay <eric.mackay@oracle.com>
To: imammedo@redhat.com
Cc: boris.ostrovsky@oracle.com, eric.mackay@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Date: Mon, 30 Sep 2024 16:34:57 -0700
Message-ID: <20240930233458.27182-1-eric.mackay@oracle.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240927112839.1b59ca46@imammedo.users.ipa.redhat.com>
References: <20240927112839.1b59ca46@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:208:32e::8) To MN2PR10MB4269.namprd10.prod.outlook.com
 (2603:10b6:208:1d1::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4269:EE_|SJ0PR10MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: 59afff8b-e51a-4e88-c7e4-08dce1a88120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjFqWGlVbXZCdFNJcVNrODEzRUZ2cmluaitxZXlFRitrbUpHbExEKzZUMDNl?=
 =?utf-8?B?elZUTGZCNE9DTmUyVXNUVW1EL0FrR3o5dFNoRjhHNWszUFhGSnZ0Tzc2UVpY?=
 =?utf-8?B?QzUzNm5VaDk1R09vSnlHV1hnVTBVQ2Zvckd2dmZzZWlaVXk4OGwrM0NiWHZX?=
 =?utf-8?B?QkYwRUtVRXR1bHUxb2VCVmJyT2NaRXN6NFIvYnV4SEhlVEdwUXk1UlNiaVN5?=
 =?utf-8?B?bUhVeUhrdGgxVGFWZ0Y2dndoSW5oYW80YVFYU1lWYis0R01Ud2ttSnRma0N6?=
 =?utf-8?B?dkZCUFZrYkhMRWlyVFQzOVMzaTNwUzlnLzczZEdvdml4SzEvajBaY3hXWTV3?=
 =?utf-8?B?aThMTGgyeDFoQnlNenhaaWJWUUpqTDBQdDJhR3VYMkxVeGk0eGNsN2NYQUhh?=
 =?utf-8?B?MmU2SmsrTkJRWi8vYmllRHJnRm9BdXQyR2NMc1dKVHVnRU44UEVPMlhKaDdN?=
 =?utf-8?B?NkIzeW81Q2NHbEREOW5lN3pnN3RhaG5rUnlZdndKeVBsY24zZTdYaFJwYmF4?=
 =?utf-8?B?U1I2WGVPL0FVY1c1ZFcxbkJhbzMwdExBR0JEbUZCWitHQTBwVDNUekJ3aHVv?=
 =?utf-8?B?L3Rjdy9KVXpydTBKYmhLaHd5VEIrRDcyVVlXUFhiaHBHZTFHbzBSREduRXF2?=
 =?utf-8?B?dElqK2c3UXMyQWg0WVJmNUUvQWJJVWxKTTMzblgvSmhzVTZlOHVWNjJPS2cr?=
 =?utf-8?B?VUpGZUtNQ2ZPUWtQOWVtc2RtM2hoMEFycFZaTmlRZFFkSDVFUlEzUk5SQVlI?=
 =?utf-8?B?NFRwVncraTh1K3ZSaDRKQUU5K1lNMlBUTXJJVjUvNjlQWVlmK29ZTnZmWVZa?=
 =?utf-8?B?T3hmOEwzcktmZjNINDVRQTgycE52RTdLWU13SlZiRVdOcHZaRTgzWHZncEht?=
 =?utf-8?B?R3QvcitvZUJ3K1c1Q04xMnJCWkMyNGowbHl6TFdzWnBZWmRSTGZoNllRRlNm?=
 =?utf-8?B?T1l5UGpTdkwwWXBYWTVCenMzanh6bDFWeUlidjhNSWJoNnk0aktPUHBRYURx?=
 =?utf-8?B?Q1Q0NjlyejgvdTBoMXJJcFZWV0Z0VlZNcVNkSEJSUmx4eE01NHMwaUU1MTVx?=
 =?utf-8?B?OEFTSkpPam9raFVpUW9uT1FkQTVidnc2Y0N1NUJFTnpvTWNhamVJMDFaUzBI?=
 =?utf-8?B?WWlGUFZUanFDQVppVmpzSWMrVzFFNkNrSlNRT1FXb2Vob0plQUN6MFNrY0Qz?=
 =?utf-8?B?V0JneUdlZXZlUXN3WlI2SitKY3dqenpVVW5rT3hhSFZkOC9nOSs4cy9WUmVs?=
 =?utf-8?B?eHdTdGJZUzZ1Q2h1akdxczFld3N1NzZ0dTErTTFyM2lKdWZoOElFL1VreEwv?=
 =?utf-8?B?TGM5WlhKOXpsMjRQK2g5TzJPK3had0V0NzRwbFBaUG9IQlp5Z2QxZ2NxMk9w?=
 =?utf-8?B?aWM4SE9mOXNBYktVSmR6aUxaU0FXVHN4VlUzeUxHSVl6V3dPcW9PUXJJd21X?=
 =?utf-8?B?NlVnUXEvZHlDUHRWWE5GeExHTzdRVkpqcndPQTRHOENpdlZSWGxsd0kwUEVt?=
 =?utf-8?B?T1dVeUxWcmg4dTdzNk5lTFQzRHZoWFdqWjgrZFlRWFM0OGpnY2lHMWE1RkNY?=
 =?utf-8?B?alRvQUUrYjdXb3ZDV2M1MmxVelZybEk4WnFXRnBBQUNUc3dEWGhSZndtWVFY?=
 =?utf-8?Q?X7anOEmKGvqFbXXj5KLYHPQ9yGDhgx5X0TemvREM64+E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4269.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlAvUVZESjdnMWZ6RWVORUpEZlByQjVzOE5STU1HNkZYc3d0VzNZY3gxaWY4?=
 =?utf-8?B?RXBDbksvQ2FmWXYvbEZHMFpndE9IK2k5U2FTYVY5anV6blpxVjVzdk5LekZZ?=
 =?utf-8?B?MGhaQ1p5TXhrbWZCOTcrWVhtM1Y5akoxZGFUK0RzZXN6Vll1eHVDZG9DVlIz?=
 =?utf-8?B?My9RN3VZQmZMbHZXZTlMUGNMQ1BnVmQweUdQZVVoaStmd2hUZE9ZczVrS3ZX?=
 =?utf-8?B?RjE5cUk0cmJ0eVVxOTVIaWpkUzhvRTZjU0U1ZFVzZW03c0VXVjJoVkdrZklk?=
 =?utf-8?B?RnNMQkcwTmZMMFVYYWhFR3ZwZHNzWVdLZjcza2FZK2gyd1NCRG54SzNZc1Fj?=
 =?utf-8?B?eHhsbkZSRkNPVWRHZXdyalNGTGF2RzJkanp3RlEvNE0xNUd2Nm1EWm5pK2x5?=
 =?utf-8?B?RTQvMGZ3aHdFRGh5WTZiWnh0emNQRHFHbENtMm9DZnYrWnNmaGRXL0JVU1oz?=
 =?utf-8?B?NzRJUXAzaE1yY2Jwcng1SGxiUGMzeGJiV3NDbGdDZUNURHJPZngrcUs2eGhE?=
 =?utf-8?B?UXMxZjF1Uk5USTM3Yk54b09hOXNuU21UbDBFYjZRTlErVzRtYStEYlhpZ3R4?=
 =?utf-8?B?MDhqWU9RNEVnL1U5ekJWU2RldTM0Z05oYnlsWm9Ncm1PQ0tSbk1VRk5DVXB6?=
 =?utf-8?B?eDBSOVpDU1ZQbDJVeVcybUdGdmJuQWNUdjB0LzdXREZzZmpEUEZRYkh1MVhY?=
 =?utf-8?B?bGt0ek4zUXQ1cWxJM1JJTmM1VGFxdncrYXJYOWN1NkxmVU9TSjA5cHlYM2Ew?=
 =?utf-8?B?TUh2b1FUcUdkQ015MUUveVJWTGw3RGZaaUlaVHZuaHhhLy83UHNLczV6WmdB?=
 =?utf-8?B?dERXMm1SekZvNGFweE9BcDdmMklYRERIQmJoeEs4WUUza2I3YlB2bC9IM3Nl?=
 =?utf-8?B?WFhYK1YwQjlhTUQ0QUpyRC8zUEFrK3NFeFNWeWM0RVZNQzM5SDUxaU5pRFBh?=
 =?utf-8?B?RzJNVzJZZHN1ZjgyRWRpME13VHV1dE5kL2k1a1k3bVdid2FUNnErUlRWSVVV?=
 =?utf-8?B?emp2MmNIeHl5RU1od2cvYTVWZzZBTFU3aDViaHFRcjg5Z0tCVlFVaTBmNXY4?=
 =?utf-8?B?R3BHOS9LOGcvYm81R1p6RlpCTlBpVDRvSURJL1lIRmJzaVF5WnJmeG1OdnBa?=
 =?utf-8?B?NFkxVEhpcmczTHhRWGVEdm1rN09VL1ZkVUZqVXEwdUVBazFDQkJOMkFtMHNn?=
 =?utf-8?B?U1V0QlJFRDhXc3Q4NVhMdm94ZDBGcXVRc3Z4Z2JTcVdidGUxek9ST0pxeXpw?=
 =?utf-8?B?UUtQcG9DMEtCV2NKUmpOdWRKWkF1U1UzdDR3ZDVnZnZOWlZHMU0vRG43NnZU?=
 =?utf-8?B?U1U2d1V1Y0FpTEZYcnBMcTJCeDBWbHp0c0M4OS9oQzh1SzZ6b3pURm1nUUlz?=
 =?utf-8?B?c2thM1l3cWdxSTV2UXNnRDg1VjR5SE5TUldjUVN1OVN4azQ1UWdUUlRJeC9r?=
 =?utf-8?B?b3diQ09Id2RVenJFL2ROOHJPc1JnTFpyamJ2cUJjUWRMQzNtdDZhU2REaVlZ?=
 =?utf-8?B?L1RsS3ozNU5VUEsxZERKLzBKRnVUTElLWEQ0VE8zS2M3WFdBSEtsWThCVTY1?=
 =?utf-8?B?aFh1b21FNzlwMEo0UE1xQXNleHdhRm0wOTBIYVo5dXNvNm9Kbm5IM3lkSFhy?=
 =?utf-8?B?YkFtUHhNZFhHTU9MRFhQLytqMXZXUE41QjBoU05OQ0FQZGtGQW5GblhVMmpW?=
 =?utf-8?B?YVdiVThaQVF3bzlPdkxGVFZVRDhxOWljKzl1VlFVeWNjNzhicHZnMW80ZGdi?=
 =?utf-8?B?UEd1ZmpnM2xaUzM5RWJWNC9ZaENmRk1NbGU2MVhTakJ5S1JGVlEyZzBLZzUv?=
 =?utf-8?B?dkJNZDZNWXk0NGI2SURSeVAxVG03MG15YkJNRFQ3bzlYTkZ5TkVGaG1Rd25Y?=
 =?utf-8?B?MlY1WWdZRHovcjNwbzA0K0FFaTEwanRPaXgyNWdoeGpkM0JCb01MRXpQenBK?=
 =?utf-8?B?bVhrclEwUjZjTGxvY3diSFZMVi84ckNiRlhvSzVObG9WcVRGdUQwTC9sSnBZ?=
 =?utf-8?B?OXZuc25yUE1MTXc1eFdFSXF4MkFNRkhuZkxlZTM4Ui9QN25GUE5qbkdRWjQ4?=
 =?utf-8?B?MCtFOHRLbGxYZlVTMk5iMnV1WHFHT3JCQ1pQWW5yQUQ2bU9WeklZYTM1RjBo?=
 =?utf-8?Q?mYwACtfif2FmTb5HkNNqwSD3k?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJlSCalR1LWJDLWSzuDmNbDxA4RrmLh8pe9wcc42GlOA0ZAod1H9DeHh7IU3qcFPFQmPwywAbRmHgvziTWJV2dyapWItLIM8KB3JHgQfy/Dkv7Kqo7C4RJ3L+V/FHf7zstQu9LCR3eiwL+bS2cuXB3dOoweaMzxRE+JY0s12eQJJQYkSxh/Gx2iy/XR1kEq/wTcP438GXZ/Kpoqt/YBVU4B7lFHFz8+k6U9pWzCNquyIc4yJ55R2ZJeYDqXpkjI7BstJ8dalI1IrbljnjZp/Uy+a+Pwo21WrzXTJGTQVzNRSDFNVcZ4cO5PPIxdhO3EqOO15nvAlfy9RpEacGSHLqnoAUjGB+xFo+zOsbPvMGHetSZ579bnOZcGsYVRGgRkPy0GqMhaHwWWYlZ2ilaURuFy5dk9hj8dVyv9jqg3PrjOs3cna03N5AUjBK0w93Jwb6+4gZ2flkCTZJmkfYustGN1RyJRZz3Awa/g8CpLuYJ46MHdSh5ekQ2wPhSwD+PaF0bZaBIvbgDdd0W3jHlQRCT3jN6j7kCTixrObUoP6kcJVitl7e/Q9ajVDHtPRyiTztursYUt9486+tk48qkmpwK62qj0DrolHq07w4F5Z8Uk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59afff8b-e51a-4e88-c7e4-08dce1a88120
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4269.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 23:35:02.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tEKDlvS1RD99dzwiH/yDxFjdHCXUzCpQL9iSz4w6jG0GXfS9vf77sJmfQGO/1siQA6yOVhBygKaLXvtx4JwJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-09-30_21,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409300167
X-Proofpoint-GUID: Fmfg_D0K-gOsRpz2R6DPLot51upvYRI2
X-Proofpoint-ORIG-GUID: Fmfg_D0K-gOsRpz2R6DPLot51upvYRI2

> On Thu, 26 Sep 2024 18:22:39 -0700
> Eric Mackay <eric.mackay@oracle.com> wrote:
> > > On 9/24/24 5:40 AM, Igor Mammedov wrote:  
> > >> On Fri, 19 Apr 2024 12:17:01 -0400
> > >> boris.ostrovsky@oracle.com wrote:
> > >>   
> > >>> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:  
> > >>>>
> > >>>> I noticed that I was using a few months old qemu bits and now I am
> > >>>> having trouble reproducing this on latest bits. Let me see if I can get
> > >>>> this to fail with latest first and then try to trace why the processor
> > >>>> is in this unexpected state.  
> > >>>
> > >>> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call
> > >>> under if (!dev) in qmp_device_add()" is what makes the test to stop failing.
> > >>>
> > >>> I need to understand whether lack of failures is a side effect of timing
> > >>> changes that simply make hotplug fail less likely or if this is an
> > >>> actual (but seemingly unintentional) fix.  
> > >> 
> > >> Agreed, we should find out culprit of the problem.  
> > >
> > >
> > > I haven't been able to spend much time on this unfortunately, Eric is 
> > > now starting to look at this again.
> > >
> > > One of my theories was that ich9_apm_ctrl_changed() is sending SMIs to 
> > > vcpus serially while on HW my understanding is that this is done as a 
> > > broadcast so I thought this could cause a race. I had a quick test with 
> > > pausing and resuming all vcpus around the loop but that didn't help.
> > >
> > >  
> > >> 
> > >> PS:
> > >> also if you are using AMD host, there was a regression in OVMF
> > >> where where vCPU that OSPM was already online-ing, was yanked
> > >> from under OSMP feet by OVMF (which depending on timing could
> > >> manifest as lost SIPI).
> > >> 
> > >> edk2 commit that should fix it is:
> > >>      https://github.com/tianocore/edk2/commit/1c19ccd5103b
> > >> 
> > >> Switching to Intel host should rule that out at least.
> > >> (or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
> > >> if you are forced to use AMD host)  
> > 
> > I haven't been able to reproduce the issue on an Intel host thus far,
> > but it may not be an apples-to-apples comparison because my AMD hosts
> > have a much higher core count.
> > 
> > >
> > > I just tried with latest bits that include this commit and still was 
> > > able to reproduce the problem.
> > >
> > >
> > >-boris  
> > 
> > The initial hotplug of each CPU appears to complete from the
> > perspective of OVMF and OSPM. SMBASE relocation succeeds, and the new
> > CPU reports back from the pen. It seems to be the later INIT-SIPI-SIPI
> > sequence sent from the guest that doesn't complete.
> > 
> > My working theory has been that some CPU/AP is lagging behind the others
> > when the BSP is waiting for all the APs to go into SMM, and the BSP just
> > gives up and moves on. Presumably the INIT-SIPI-SIPI is sent while that
> > CPU does finally go into SMM, and other CPUs are in normal mode.
> > 
> > I've been able to observe the SMI handler for the problematic CPU will
> > sometimes start running when no BSP is elected. This means we have a
> > window of time where the CPU will ignore SIPI, and least 1 CPU is in
> > normal mode (the BSP) which is capable of sending INIT-SIPI-SIPI from
> > the guest.
> 
> I've re-read whole thread and noticed Boris were saying:
>   > On Tue, Apr 16, 2024 at 10:57 PM <boris.ostrovsky@oracle.com> wrote:
>   > > On 4/16/24 4:53 PM, Paolo Bonzini wrote:  
>   ...
>   > > >
>   > > > What is the reproducer for this?  
>   > >
>   > > Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
>   > > the guest, will get you there in 10-15 minutes.
>   ...
> 
> So there was unplug involved as well, which was broken since forever.
> 
> Recent patch
>  https://patchew.org/QEMU/20230427211013.2994127-1-alxndr@bu.edu/20230427211013.2994127-2-alxndr@bu.edu/
> has exposed issue (unexpected uplug/unplug flow) with root cause in OVMF.
> Firmware was letting non involved APs run wild in normal mode.
> As result AP that was calling _EJ0 and holding ACPI lock was
> continuing _EJ0 and releasing ACPI lock, while BSP and a being removed
> CPU were still in SMM world. And any other plug/unplug op
> were able to grab ACPI lock and trigger another SMI, which breaks
> hotplug flow expectations (aka exclusive access to hotplug registers
> during plug/unplug op)
> Perhaps that's what you are observing.
> 
> Please check if following helps:
>   https://github.com/kraxel/edk2/commit/738c09f6b5ab87be48d754e62deb72b767415158
> 

I haven't actually seen the guest crash during unplug, though certainly
there have been unplug failures. I haven't been keeping track of the
unplug failures as closely, but a test I ran over the weekend with this
patch added seemed to show less unplug failures.

I'm still getting hotplug failures that cause a guest crash though, so
that mystery remains.

> So yes, SIPI can be lost (which should be expected as others noted)
> but that normally shouldn't be an issue as wakeup_secondary_cpu_via_init()
> do resend SIPI.
> However if wakeup_secondary_cpu is set to another handler that doesn't
> resend SIPI, It might be an issue.

We're using wakeup_secondary_cpu_via_init(). acpi_wakeup_cpu() and
wakeup_cpu_via_vmgexit(), for example, are a bit opaque to me, so I'm
not sure if those code paths include a SIPI resend.

