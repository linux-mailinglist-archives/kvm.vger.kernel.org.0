Return-Path: <kvm+bounces-51984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E76AFEEF1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 18:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B090B1890E37
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021B3221275;
	Wed,  9 Jul 2025 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EyVsuEar";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dbK00VJm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4536221D3F2;
	Wed,  9 Jul 2025 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752079147; cv=fail; b=MEy0O/AQ8G7vW4YY0erYCg8hAagt4mxFFUWiYPWbxdJi8O7ru+745vE2V66OAvbzJehwB67zrlvSs73RJ5J5ByhEIaMCqrjcPsteVbZ/txJwUiJlzwm9cz7c+N/xuSdNDo0WSzIiqDu/AxCYfIoBjEPeQIBtqjpoHEYWwLeJawE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752079147; c=relaxed/simple;
	bh=WaJ32NuiPpG74Cv7Wh24LslVtcSfRzhG2GlweDhA9ck=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YU0/ErFbUvzL1YVS/E+DQiF11BKEDlvJLGaUvyfLZDoFy073wEpvEw9q/0Q4HztOFgJEePN2yrLTYO9vVTdlmihM4bEYoqldqNJ8E4HHY9zb8HDFQU15hc5pI5+YhwcYfKQP74V//VFL3Bd2/Sy/fWL2qQXqwYEMOvBWbldqY6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EyVsuEar; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dbK00VJm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569G25qT014292;
	Wed, 9 Jul 2025 16:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XGIY3WAa/AQOvxQeX/2ocsdoCJeDY1Q6HFwBRdDzEk4=; b=
	EyVsuEarrqdwYAIGTLPDSkcmNzuz5MF+ovCU93/dfEWwfVtx8YahWo3GXzFImgWo
	1QyPuttkjJOLrmWDDgz+gpVwuod9MgYyUynJBG4dvmesu98p1OYqwq/GMMG9l1bp
	TVHxxUaGNZ7d2gtz3gqenbzH3aJa57qcfA7vZH8gG2993v+4JktZnxLNuqknJkj6
	B3zrti3CR/b14Nq9v9vf2YogzFNSxAl08Tr7C973dl/48/ahWeeCWTHVgH5ZknZm
	nIsTBx8VhK0qgDu+2G1HxM8YLXAy3yF5GK7tRZvO90K8iQxxOIntL36qrKVNxDlm
	arbRjAs6ovsEuQhjDuQrxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47suk782ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 16:38:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569F5b06014299;
	Wed, 9 Jul 2025 16:38:57 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgbyegu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 16:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOfiiBD+Sp1ko4+pv+PGIoysTuy24xaQPLV4WInQAD0zOZaWYEtPAx8bApeRy99MrD6lXVsQKxqxT46WYQ0xkWC6XeJCoGNkUtoF1FPrkLSDoEPR/JYP/tMp32zT7HGgbRkIrLXn1xozPWQYWCBKgdsvxZ40uG6qBmaOPZrDAsmUKIri9hZjiwnTVjQy5UdbITWxS2JHPtAy5R00R9nb7ZjVklgNYAv1RL3fEinkbnBcfgYoZGMTEI7KmBuA4lsCvCp7qNJs3NMHI42g+a5uDj7i51k+YRe/atwTyqdf7NqqxiXpFTkx+wjC1Kj1vmQrnueW9AWq0XUM3XUlyAEprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGIY3WAa/AQOvxQeX/2ocsdoCJeDY1Q6HFwBRdDzEk4=;
 b=VebkLz6nodvooTUkrMV4rLOZUOPnIvaNQMg5kizyY7Ck7RDWOLiByeaT0Ks2b7DbmwIW0bWOnoE2G3MS+DGVI9hES8Dmu6Q7YmL0OI6XZTtAmUPrSpCShelkZQCW08FuIVCYj3NcbfE5WzPz43Saw26LdYm19bvS8jHLROGswFReq44rmnyiZKvfX6MGJ2iSs+FjikezHHHUWyKsoDfpj0IP5Wzc2hb2jc43L1fvv6b3vURP+QRQlCsrXcCQABC99HX55Qzs38cQ8LuvnsXD+xkrZeh9ED3QPw7Eq8E99fBGNoGITftyunH7kIm8CR0dHvIOur45w1xN10zeg2dvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGIY3WAa/AQOvxQeX/2ocsdoCJeDY1Q6HFwBRdDzEk4=;
 b=dbK00VJmwbB6V82zRq3w9Lyw8cawFLXnA7kgR2dGkC9PXYrXxFwXlYY5OLDfTcpjw+0KzvB7qyAMkO4WqRiWe24okV2HJi9LfSdlWtVgD9iDc0XE37wPi916GWhFs8t2Q4gkoLY4uPxP/XR7I/LJfCSW98S9sIINdq+zTCYFvdA=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 16:38:54 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 16:38:54 +0000
Message-ID: <57a0dfda-3f15-4056-9434-35d07d3e0c27@oracle.com>
Date: Wed, 9 Jul 2025 12:38:51 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/2] vhost_net: basic in_order support
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, eperezma@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250708064819.35282-1-jasowang@redhat.com>
 <20250708064819.35282-3-jasowang@redhat.com>
Content-Language: en-US
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <20250708064819.35282-3-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0172.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::33) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: cd47f9da-aa7a-429b-93ca-08ddbf0717ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHE2cGlGSFd3eFZtQVdQbVJCeGI1MFRVRGx1eVUwc3UvQ2RyQWpKR0JtWmov?=
 =?utf-8?B?Y1RseFZwS1EvVkdzUUF6Z214OWpHcmt4RE50Q29lSFYzRkRtZWlWUmZmVW1w?=
 =?utf-8?B?d0l6bmdLYnNpTTJaZHRJMXY0TDAzdXc3bzhTMUZsMjMrTmpJOE1lSm1Bdk9i?=
 =?utf-8?B?L295ejNKMFk1RlA3TDZ6OTlMdHhSaEFEaGdJb2p6cjJUeW5VdDB6a3NMdkFN?=
 =?utf-8?B?U1N1WFozQUx2Z3V2UjdEYUVPbllZZGR5cW1SQlV5Nm0xOWIrVHRsOXZqbUV0?=
 =?utf-8?B?UnF1cU8yUHlDc29IMVBMQ2JvMmRKb1pmUktLRXNhVHRySm5uOW14V3pSZTh6?=
 =?utf-8?B?Y2lJM05SdGpRc0NwendLaTZFV2wxeUYxdDhLSDdCd010QVYwVmRGTHYrSjEv?=
 =?utf-8?B?V2lzM2FtazVRdGMwMDN3MlZmNE1wTlhyMGJYTFBLSWRiV3AvYVBDY1FKTjVG?=
 =?utf-8?B?aFNZczY3RXh0bkxPM1lrS2duYXdLQzRkZmN1K2tubGVXdTVLdUZIZWhIWllO?=
 =?utf-8?B?U1kzK1liV3NidW9JdE1yMG80OVRDUFBtS3htM0l1NnJoalZvTTdzb3hzWWd1?=
 =?utf-8?B?L3R0NFIwUXVXc3VtQUM3cjBObWpuTzZYZXNwUFE5Q0hZS1oyYThRaEc0dk1H?=
 =?utf-8?B?QkQ1K1pSTk9ySmdqa0lYdHlkaWl5TngxQnByblBac2RzeDN3bW1pMVVwU212?=
 =?utf-8?B?cnBWWXU0eUZTZGE2TWx1dGlPVFlpemdOUUlEbHh6UDdudVBQWFdTdDZsWDJP?=
 =?utf-8?B?c3ZRZVc3aFJIbDZRVmlKamVsWHkyY1NWL1lsZ3Z1TXpYaGVuUmZ6bytmTTVB?=
 =?utf-8?B?N0pZOU80VnFSMGo1Z3JFby8zeEx2NjB3QjQ5MG1PWHFRaENmTys1SFdGeXdv?=
 =?utf-8?B?YnI4NHIwSEdZdlRobENscXA4aml5WEswQ0xXOXI4Z2hTYkoweVlteVpxRnVN?=
 =?utf-8?B?SjMwc2ZmQWplWVp1cEJWdDZ1Z2I1ald1UG1oQ0NIWU5JQ0lhSVRMOTRRYmYz?=
 =?utf-8?B?bjJZWTd5WXJTL2ZvbTF0ZmxuUzJzMjhaMy9wMm5ycW90UytXUkJENlNaMDhM?=
 =?utf-8?B?OTdiNkIyM0FQMHBCQzBvKzRuaU5xcUZnQXMxQml3TmUxbkdybzFXeHlST3hT?=
 =?utf-8?B?ZlJKSXFHMEg0RU9PZm83b3AzTzBrQUtFUjZBQ0pQWUlNZnh6Zkt2VmEyVFNp?=
 =?utf-8?B?SXVIMFFpelJqRWRRdC9OeUdzMzlpYzN0TStMcEJsR3ArQTBrc1dIZkRkbXJN?=
 =?utf-8?B?aldxYUl4d0tkbWw3YS9MR0x4OUttRVErNjdCdEp5TFJYVmx1RTZuOXRWWk9s?=
 =?utf-8?B?U3ExM1FmaHBUVDlSamJmempPbFlZb21PdWtyZzRsZGd5SEdZUll2U0NBTTV5?=
 =?utf-8?B?QXV1SnVrV1JveitQZ1FPbzY4K3hVSnFMMU92TEtJdU1ZbFpGcysvRzNENzNR?=
 =?utf-8?B?S0hvZHdFT3NQa2g5ZDFKMU9saXQ5MFFZbzF0cHpoMC81VHE4Mzd0aUFUbXJq?=
 =?utf-8?B?SEdXOThCL1FKb1pjM2E0amJoMUpMOWI5LzdvYk03NGhFdDBiZUkyZWtNNGtx?=
 =?utf-8?B?M2I5aElDT2NzdVVsdzRXL0NjMjF2REtNR2lRbGRNaG5BdnF1S3U2ODluQ1lX?=
 =?utf-8?B?VFF2SjN3NGROM0d6Wlg2aDAvYi9UeURveTR3bzZrb0NJSkNxNEtFaU1XZFRO?=
 =?utf-8?B?VEVEbU5HQnZNKzFLS0lqcXVRQmpTUmtmYmpldjRkNjNnTXNXUGVZaS9jc2lo?=
 =?utf-8?B?dEI3dlJrTlpRMS9FVHZZd20wWWpUSW42REd3ZklUU0ZITHZnTzkxcm04Vnkz?=
 =?utf-8?B?ZmtyQzdUVmxXd0JKbURncnk5Z0hCZ0szTTJMMVREYkJFV2xxL2kveEpXUlVN?=
 =?utf-8?B?cHpKZVozVGgvd29FQXJWWHhYbkllSC8rcUhFei9GdXJiUkR0b1d6VnArV3hz?=
 =?utf-8?Q?Bn8bZI+aLTg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1JxOWlDTmhYR3BBYnZMUzRYZ0VWL3dHKzFlVGkrZGM4OGxVN3YrTkpkaFZt?=
 =?utf-8?B?dXVsdk9XSm1YOVQzbzhMdHdadTJyYlZpTko4WTVWazRYbk5NbGVSdWh0ajZo?=
 =?utf-8?B?cnhFSVNWQ0h2K2J3elYraTdoRTY5SXEvVEtWMlk2ampRUXR4aytwLzhSK05E?=
 =?utf-8?B?OWRHME95MkhMQUNySnlmTjYyUmZNT2NNaW9tdEVVbUdVaVpVeU9CWE1QWEI2?=
 =?utf-8?B?Y3hteUlwZmFqbnBxajBRMlNIdW9VNVlXNjFrOUF3b3dRRGdrMWhHV2FXQ1RZ?=
 =?utf-8?B?THlMR2NCT2M1V3pSeVlpaGxQVXowWDVEYm1WUVdHejlrRE91bXo2WHFSMzBj?=
 =?utf-8?B?OEx3WWQ3ZjBwYXN0anVFZGJYNFR3TTh0V25lUHFIby8rN1lzYU9IamZ6STRa?=
 =?utf-8?B?UUM4Q1pXdzNnWEQrSEo1NnFZUWRCMTZ5UlBhMWlKUkoxWGtxRkhoM1FpS3Mw?=
 =?utf-8?B?QXBEL1FsdHQvVkE4UXZ1dktqazVJMFhtTEJ0cnI0T3Zjck45MW5QREtMdnFv?=
 =?utf-8?B?VjhNWFFYaEZEUnc0ZHR1SnBwOHlveFk5TXltZkNPQWpDeThtdmRZNGM3Ymg5?=
 =?utf-8?B?S2J4TUFQdGd0aVlNOWxNR1c2UmRHQ01DNnljYmphNWtIQkg0OEJMeVp5R2RH?=
 =?utf-8?B?TnBqV3pQRDhlck1YS3NNTXl0MnRRRGE3cTVKbGVUYXY5YU9mUko5cHpnS0Vn?=
 =?utf-8?B?VExsOHgxS1d5eGFHYkdvaTVDNHdRM2xVQlV1MmxBdnh5WDJuU3JQT0YrT2c3?=
 =?utf-8?B?QkhkdE1oL2Q4REhQT0NpbzNOYnZncnZmWUZvRS9vNitRVGVucDhZemJMWjZa?=
 =?utf-8?B?OGNEU0owZVV5b2UzUzBKSjFHUE9nWXhET0lwK0ZXVVJwUlU5YUxDbkFYaG1k?=
 =?utf-8?B?VXhPOVMrS0ZsM0hmY3FlWW91OFBVNzEwSkJHeVZKNEdyZ2MvMDRBS3NTNGkz?=
 =?utf-8?B?NzdueDQ5SFJoM1NjRXlRaURBMS9LbURpVzdETmFDdkJaaWIrQ0hjK1YxSXQv?=
 =?utf-8?B?azBVeVpxcVp0M0Q2aFg2a2lHcUZ1SndFY3UwYi9jcHp1QmoxN3d3UmtqTWZD?=
 =?utf-8?B?OWVsRTVueWwzaUJjc1dZNnIwUnlSSGhXZElWbVBhYm56dEk1QlZESnlobjVU?=
 =?utf-8?B?VllWVFN3RW15Vm5WSlRCSWpZQ1Z5MWN2dGRDejJZNmloSndkdWpFdEEybEw1?=
 =?utf-8?B?eHRuczcxajVHQW0zM0lmWWNmUGNWaUZBRXUzcVhpdzcvZVZmSUVpbFFHYndT?=
 =?utf-8?B?YlVjeDJPUXhNM0NxV0E2enJCemtFR3k3YVNCdzNlY1NqMUNJaXFsdEUvN1JW?=
 =?utf-8?B?Sy9sTXJVYW1rZHRCaUZQT21HSDludzVkM0FMMTA3cm5iQjVQQm9zeUxTK3hz?=
 =?utf-8?B?Rnh2NEVDbW5rNmx3L3hFVUYyQ1llNUFZN1JmQmlnV2ZLY0VqQTJCK1lwQVFo?=
 =?utf-8?B?dnJGM0RMaWFnNTJnVVFWSzVIYnA1QVlqaGxHL2FtV0pzbzFoUzhEQ1J5M0dp?=
 =?utf-8?B?cnJEY2s1RGZwSTM2S21jNmhla1pjQVEvMlV4empvVkp0T0lFeFVEb2IyUG9u?=
 =?utf-8?B?MzJnME0rdit2RzBBR082cjFDN3N5MGhXcnlVcVk2a3VSYi9GanNPSGM3ODRN?=
 =?utf-8?B?MmZOajd1c1kxNHZsMk02R2ZvNDF1NitKem5BRDU2T29iS3llcklwUkJHV0o2?=
 =?utf-8?B?TXlQZHFIcHpxcW9KWWJTM2VZc013aEcrQWhWZHNzRldWNWk5M3g2eHBaamta?=
 =?utf-8?B?NisvazdJN21vOEx4MG9jclVXVU1ndDhQUkRMakhBR3ByYk9uTHNoUllxT2ZH?=
 =?utf-8?B?YnRMOUV2Sjh5aVFWckR5N3ZUaFM5VnpQbFNZZVRXSTBZS0VVblhzcXpkdzR0?=
 =?utf-8?B?Um4vc00xZ1loY1d0VXJzSjhMaTZBR2FMN1hTZ0VETG9ZVG5yQXY0UDU3bjJN?=
 =?utf-8?B?aDduVHExQXBRQVNjWFpidVJUK2N2K29VK2ZPWXNaRFY5MU5iNVBjTmxKY1d3?=
 =?utf-8?B?RmcyejFpN3RhMW5ZUVgxZHVJQ2ZmbGtQUDE4eWFjTDkxV2Flajl4QUNDcFFN?=
 =?utf-8?B?eUNXcmpyTzF5dm9YVXBsMmlOd3AyeWhZRUw0RDJvZS9hcnQyTW9oWWZXYkNu?=
 =?utf-8?Q?6ASEhYRyar/QRFSVk9x2tdJf/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ysWGp6Fadjv+XQwSwBe/BpIjCD2DaGRweUidVy5BE7JT+xWIzv7Rga0PDrVPEX8qTD2cCp3mB6ocVKkX8vowWhwGZFuxrMy3lGGYeIbYeU3nBTvqdPqzz5CscgbFUILJdlNGk9jTDRXPt6bzqqHmLLIvQyUZersj14cUevDVed+Ky3SfO6vgNbNAJHPIa9vXdyMms2YIeb4MlVcdX9bPvBCbsOEiQsUTAo7qdhNLecpFH2wSfKnipVFttmIUYei3iKaRHRRdjCD3E1kF0bbEUuj4mx6LjT3/QZTc6lsK5Zd3MCO72JMZ3s0OJ0s3mSj/oFqp4LoirRWc5FZcnSn7ZDUGv9mUHy7muGc9IajUl+tHOXjJ7Uu8bEbNEDdJ/dNxyh6QKoK3g00MB7PhbQPb92RDFxLq265rqCPRAflKe3EMhnes1Ps8XrSBYLJmOZAN3fDsl63B+V9QuLP0CFUNLSPRoAF7ZtRTx88T7sO/A/K5muUjGkTwh9GHPNOqFUXhmyUPIv4bW6yR4W0WsE6x5tk/vF8BOVuqvR5sSofO4yxt582zpfvEtLv9wwi3PXpK0Wasmw8idpQHeEFcITLgFKNSpJyYwwTTmGUlw80+3nE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd47f9da-aa7a-429b-93ca-08ddbf0717ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 16:38:54.0990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PW9WIde9Xy2mxPwlr0W5ctWtqQ5XgizS+eND4amSDVJGZ6X/MlivYR2OG8YSjh/Wl7FdqmMZD5snJAX/78Utw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_04,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090150
X-Authority-Analysis: v=2.4 cv=BK2zrEQG c=1 sm=1 tr=0 ts=686e9b22 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=BbRPZPdb1_T6TDDNkpkA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13565
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDE1MCBTYWx0ZWRfX98I3kIykW/Eq kWG/SppsC3qNvrx9xLJgXH3JR/TBFrQGIqSARU4UGJehiTPHyp83k9R7g3/TacyJZg5xe5wcnuF nUw9Vjd3iqGiUt/uiEZ9i9JLx6x7BxdrBB0WD/o2atl9NGemOuirKL87P7bX8Y9m+MS/jZPULaq
 wPhftyvviEuEv8HDqgeuTPEzkYGBOhW9cDjixZDWpwBJXK6VgPW/n71XTvxVfaMQH0TOM73zdhX Q2U42fmy8df3hOm6FPbluz/lkEjTiZ+rQAAfYggbfF0ET9pK2PXOFbMfo+SjZR/j20zr1y18J28 tWDsUJdXEU41J96OWH9lWtgA1gpFbq+N7LIz5MhCF9z0jkg9mKOBh/gtaRTEE3SOje1aF5nrvfs
 ky56OTUTV1n/1tBZwl8iPDYd1wgs1a3LmaUUkVNJEMnoYr6BATitmexI5JKx6drJw8nGx3fp
X-Proofpoint-ORIG-GUID: Kkkz-uIyr7hLbttv3F6dtfwAzdvrU2gk
X-Proofpoint-GUID: Kkkz-uIyr7hLbttv3F6dtfwAzdvrU2gk



On 7/8/25 2:48 AM, Jason Wang wrote:
> This patch introduces basic in-order support for vhost-net. By
> recording the number of batched buffers in an array when calling
> `vhost_add_used_and_signal_n()`, we can reduce the number of userspace
> accesses. Note that the vhost-net batching logic is kept as we still
> count the number of buffers there.
> 
> Testing Results:
> 
> With testpmd:
> 
> - TX: txonly mode + vhost_net with XDP_DROP on TAP shows a 17.5%
>    improvement, from 4.75 Mpps to 5.35 Mpps.
> - RX: No obvious improvements were observed.
> 
> With virtio-ring in-order experimental code in the guest:
> 
> - TX: pktgen in the guest + XDP_DROP on  TAP shows a 19% improvement,
>    from 5.2 Mpps to 6.2 Mpps.
> - RX: pktgen on TAP with vhost_net + XDP_DROP in the guest achieves a
>    6.1% improvement, from 3.47 Mpps to 3.61 Mpps.

Acked-by: Jonah Palmer <jonah.palmer@oracle.com>

> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/net.c | 86 ++++++++++++++++++++++++++++++++-------------
>   1 file changed, 61 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4f9c67f17b49..8ac994b3228a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -74,7 +74,8 @@ enum {
>   			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>   			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
>   			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -			 (1ULL << VIRTIO_F_RING_RESET)
> +			 (1ULL << VIRTIO_F_RING_RESET) |
> +			 (1ULL << VIRTIO_F_IN_ORDER)
>   };
>   
>   enum {
> @@ -450,7 +451,8 @@ static int vhost_net_enable_vq(struct vhost_net *n,
>   	return vhost_poll_start(poll, sock->file);
>   }
>   
> -static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
> +static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq,
> +				  unsigned int count)
>   {
>   	struct vhost_virtqueue *vq = &nvq->vq;
>   	struct vhost_dev *dev = vq->dev;
> @@ -458,8 +460,8 @@ static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
>   	if (!nvq->done_idx)
>   		return;
>   
> -	vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
> -				    nvq->done_idx);
> +	vhost_add_used_and_signal_n(dev, vq, vq->heads,
> +				    vq->nheads, count);
>   	nvq->done_idx = 0;
>   }
>   
> @@ -468,6 +470,8 @@ static void vhost_tx_batch(struct vhost_net *net,
>   			   struct socket *sock,
>   			   struct msghdr *msghdr)
>   {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>   	struct tun_msg_ctl ctl = {
>   		.type = TUN_MSG_PTR,
>   		.num = nvq->batched_xdp,
> @@ -475,6 +479,11 @@ static void vhost_tx_batch(struct vhost_net *net,
>   	};
>   	int i, err;
>   
> +	if (in_order) {
> +		vq->heads[0].len = 0;
> +		vq->nheads[0] = nvq->done_idx;
> +	}
> +
>   	if (nvq->batched_xdp == 0)
>   		goto signal_used;
>   
> @@ -496,7 +505,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>   	}
>   
>   signal_used:
> -	vhost_net_signal_used(nvq);
> +	vhost_net_signal_used(nvq, in_order ? 1 : nvq->done_idx);
>   	nvq->batched_xdp = 0;
>   }
>   
> @@ -758,6 +767,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   	int sent_pkts = 0;
>   	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
>   	bool busyloop_intr;
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>   
>   	do {
>   		busyloop_intr = false;
> @@ -794,11 +804,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   				break;
>   			}
>   
> -			/* We can't build XDP buff, go for single
> -			 * packet path but let's flush batched
> -			 * packets.
> -			 */
> -			vhost_tx_batch(net, nvq, sock, &msg);
> +			if (nvq->batched_xdp) {
> +				/* We can't build XDP buff, go for single
> +				 * packet path but let's flush batched
> +				 * packets.
> +				 */
> +				vhost_tx_batch(net, nvq, sock, &msg);
> +			}
>   			msg.msg_control = NULL;
>   		} else {
>   			if (tx_can_batch(vq, total_len))
> @@ -819,8 +831,12 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   			pr_debug("Truncated TX packet: len %d != %zd\n",
>   				 err, len);
>   done:
> -		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
> -		vq->heads[nvq->done_idx].len = 0;
> +		if (in_order) {
> +			vq->heads[0].id = cpu_to_vhost32(vq, head);
> +		} else {
> +			vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
> +			vq->heads[nvq->done_idx].len = 0;
> +		}
>   		++nvq->done_idx;
>   	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>   
> @@ -999,7 +1015,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
>   }
>   
>   static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
> -				      bool *busyloop_intr)
> +				      bool *busyloop_intr, unsigned int count)
>   {
>   	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
>   	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
> @@ -1009,7 +1025,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
>   
>   	if (!len && rvq->busyloop_timeout) {
>   		/* Flush batched heads first */
> -		vhost_net_signal_used(rnvq);
> +		vhost_net_signal_used(rnvq, count);
>   		/* Both tx vq and rx socket were polled here */
>   		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
>   
> @@ -1021,7 +1037,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
>   
>   /* This is a multi-buffer version of vhost_get_desc, that works if
>    *	vq has read descriptors only.
> - * @vq		- the relevant virtqueue
> + * @nvq		- the relevant vhost_net virtqueue
>    * @datalen	- data length we'll be reading
>    * @iovcount	- returned count of io vectors we fill
>    * @log		- vhost log
> @@ -1029,14 +1045,17 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
>    * @quota       - headcount quota, 1 for big buffer
>    *	returns number of buffer heads allocated, negative on error
>    */
> -static int get_rx_bufs(struct vhost_virtqueue *vq,
> +static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>   		       struct vring_used_elem *heads,
> +		       u16 *nheads,
>   		       int datalen,
>   		       unsigned *iovcount,
>   		       struct vhost_log *log,
>   		       unsigned *log_num,
>   		       unsigned int quota)
>   {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>   	unsigned int out, in;
>   	int seg = 0;
>   	int headcount = 0;
> @@ -1073,14 +1092,16 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
>   			nlogs += *log_num;
>   			log += *log_num;
>   		}
> -		heads[headcount].id = cpu_to_vhost32(vq, d);
>   		len = iov_length(vq->iov + seg, in);
> -		heads[headcount].len = cpu_to_vhost32(vq, len);
> -		datalen -= len;
> +		if (!in_order) {
> +			heads[headcount].id = cpu_to_vhost32(vq, d);
> +			heads[headcount].len = cpu_to_vhost32(vq, len);
> +		}
>   		++headcount;
> +		datalen -= len;
>   		seg += in;
>   	}
> -	heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
> +
>   	*iovcount = seg;
>   	if (unlikely(log))
>   		*log_num = nlogs;
> @@ -1090,6 +1111,15 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
>   		r = UIO_MAXIOV + 1;
>   		goto err;
>   	}
> +
> +	if (!in_order)
> +		heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
> +	else {
> +		heads[0].len = cpu_to_vhost32(vq, len + datalen);
> +		heads[0].id = cpu_to_vhost32(vq, d);
> +		nheads[0] = headcount;
> +	}
> +
>   	return headcount;
>   err:
>   	vhost_discard_vq_desc(vq, headcount);
> @@ -1102,6 +1132,8 @@ static void handle_rx(struct vhost_net *net)
>   {
>   	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_RX];
>   	struct vhost_virtqueue *vq = &nvq->vq;
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> +	unsigned int count = 0;
>   	unsigned in, log;
>   	struct vhost_log *vq_log;
>   	struct msghdr msg = {
> @@ -1149,12 +1181,13 @@ static void handle_rx(struct vhost_net *net)
>   
>   	do {
>   		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> -						      &busyloop_intr);
> +						      &busyloop_intr, count);
>   		if (!sock_len)
>   			break;
>   		sock_len += sock_hlen;
>   		vhost_len = sock_len + vhost_hlen;
> -		headcount = get_rx_bufs(vq, vq->heads + nvq->done_idx,
> +		headcount = get_rx_bufs(nvq, vq->heads + count,
> +					vq->nheads + count,
>   					vhost_len, &in, vq_log, &log,
>   					likely(mergeable) ? UIO_MAXIOV : 1);
>   		/* On error, stop handling until the next kick. */
> @@ -1230,8 +1263,11 @@ static void handle_rx(struct vhost_net *net)
>   			goto out;
>   		}
>   		nvq->done_idx += headcount;
> -		if (nvq->done_idx > VHOST_NET_BATCH)
> -			vhost_net_signal_used(nvq);
> +		count += in_order ? 1 : headcount;
> +		if (nvq->done_idx > VHOST_NET_BATCH) {
> +			vhost_net_signal_used(nvq, count);
> +			count = 0;
> +		}
>   		if (unlikely(vq_log))
>   			vhost_log_write(vq, vq_log, log, vhost_len,
>   					vq->iov, in);
> @@ -1243,7 +1279,7 @@ static void handle_rx(struct vhost_net *net)
>   	else if (!sock_len)
>   		vhost_net_enable_vq(net, vq);
>   out:
> -	vhost_net_signal_used(nvq);
> +	vhost_net_signal_used(nvq, count);
>   	mutex_unlock(&vq->mutex);
>   }
>   


