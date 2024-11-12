Return-Path: <kvm+bounces-31651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F43B9C6032
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E1052879C8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB33216DFF;
	Tue, 12 Nov 2024 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lhHtiBoC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dMKLlJMh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4838F21730C
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435476; cv=fail; b=eIK/T7Cgf7Fda0MG1PSDUAIiz7bxC/TE34Ba6xIB3r5lbQIFmoNUhp65g/bC4uNky+OSZZsPTs4oEsdZisiGoG7F876rnWHpFNZgjr/32Wk574SYMeszpKKb9uqLrHr2WFxQshjIafBWAciJc535g8FeFFB1UNWPcbsn+B65KUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435476; c=relaxed/simple;
	bh=M0BYg+zD5eHrk0FmBxXxjXOQOb0OJODyg8Z+KJHDTL0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OARM8+ORLMdBLYtqM/j+MMv4XIy9ZEBVPvJpL2PQqhWp82SidH9bgYTp4y44WIsjm74QArMooFEVkMLo4RPIMyhFgWulpi/TqmLUk1rqzUozXpXcKrx90erfhOagEbgsd365oP2VUWHNYmdRK6IlsTAPDDq67xGTIh84Pzi1GSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lhHtiBoC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dMKLlJMh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtbdA000446;
	Tue, 12 Nov 2024 18:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZtxWCWGV63Tq7yTjv0VvdxZbVT9InYmOJDBb8cdyV64=; b=
	lhHtiBoCKDyrWPdXz5HF8LZDoH9pUZsq1QtC7PHrLssA2qxGe7QCNO9abWKYmus0
	wGArzW986lQcLk6/HvEGtYn3T2HjcU4jjNH7ROgyP+m8T5C6/ksxowo/KqLc9dxc
	Q1/lDjrEVaBtLvt8yeJ/IbK1wrj9sHGHW8A8dGu8kD5WCwkNyqc/ZOTMHyDdELy3
	j/LfXI1vrRJTpwmFpHWcJ7v4L8xMLmKPqQwZI4tP2LtcubIHXu4RBuPUowMQrfYJ
	T33runiMjT6OGFBnxi4IeMu/6+NiEES68oZxSnq8Adhn2WeM5BhpBmA98r+3BFcd
	GwxE6UzWnzqlnSWvBv/zLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hen1cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHM3Gn035876;
	Tue, 12 Nov 2024 18:17:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx688ya3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6NqlaNaEhAOb00qXnDY6Jh1ktuhvrZn/Wn6mrZ85qVE6sdgGfBugaBt21u88HikRMBdQCeWzq8DCQ1hZHv2gaWd84bGd4npoUucTfDCN/q/2ac/ULrEb8e+bKOE0Nmuk/n1cBQyfN/rzjqXofS7YVR5Yyn+x9hz8M3c3sTUqCoKCDPU7kbHN9W161GTAs2JFJdj7Qfo+LKdDVhBi9hZFT8+CiSF5469EYDNedQWSCUjgNMDq+LyfhO0a1My28XKuN0vcLB9u+W4jbIlJfQIDCJDPWxu9dabq7YHZkUY2OerRpsqKw9RPd12xPzoo7efq9+BnA7eEAGu45Zc3NZXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtxWCWGV63Tq7yTjv0VvdxZbVT9InYmOJDBb8cdyV64=;
 b=Brn4aPFnB2DYF7SaBjKzg6lfeGiNeVgWshH4j+Nq7bOrO1WfvsGoSVMOHbssMvlXab2hgY7bxIapIHCfCYnwGRrD+MNEpNnERoFjaWULlMsec8+7v6K9BfYtEytKBvAnq0/cs1WPWQLf8gKtvLntpEMUEBsEDa0WnheyF2c0Nkux2BoVaeaugg7y799IDpXOt9OyOaVOeOJkQ5CC6oLIipvgZ8fP3RUQKfk1JR6u0LSqB97YO1VecnbohJ1BihRGWHjAsiGzPSdjMN6VPMUsjKZtSTG4oDNlsxtCcQb0Rq7Nhwt8qpC1dBrFcCzJolpDaXT00x0iDqiPtx84WW33tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtxWCWGV63Tq7yTjv0VvdxZbVT9InYmOJDBb8cdyV64=;
 b=dMKLlJMhseOPl69NgSqarAENZRHL4bNQAm6hmfk8tVMU/uBqtIiw8FxJHbVutZU213Ejj+IyO/8cOqUQTwd84KYWgvluK7vntV63B0DU+WxGMIbtVTCxwMPenZGnFjpuwqawZBRYnJskGkE+j36SbWeEaIajSYYrBwsMNMOwIaE=
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by DM4PR10MB6157.namprd10.prod.outlook.com (2603:10b6:8:b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 18:17:33 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:17:33 +0000
Message-ID: <a79a2639-a6f1-4ca1-9b12-d4e125d894d4@oracle.com>
Date: Tue, 12 Nov 2024 19:17:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] system/physmem: poisoned memory discard on reboot
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-3-william.roche@oracle.com>
 <b0e80857-b9cb-4e93-81bd-93e8dc4b1d51@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <b0e80857-b9cb-4e93-81bd-93e8dc4b1d51@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|DM4PR10MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be7f409-4a34-495a-4f45-08dd034646fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UExCMGMrQTQxSWcvWnh6WnFYRFdyR1h1Z0JoSDhYcDRsK2xjMGphVjcyUkVI?=
 =?utf-8?B?N25hZ2ZrdUpiMU43ZXdaVU1jUnpzZzZsUmFCM1h5ZW1vSjFFbzlsVUxuM3B6?=
 =?utf-8?B?aWQrREZ1am95SGV3d3E1SEo2OW5PalIzZzZ3WnFoWG5vamlKVmVYdWxvNXd3?=
 =?utf-8?B?aUVYdVNGQ01rM3g0bHdoWnpNVXJXZldzY2d0dFZ2TXhFc1A1b2drREdSaXVC?=
 =?utf-8?B?MUxHODJLMzBOOEhTT1d1N0w0c0JjTTU5MVlUN25CUVVhVDNqUHI4aHNzd0Za?=
 =?utf-8?B?VkloU3prelRmU244STh2STdxS2Y5elJDNktVOVRrMUNiVWFYdSs0MHdqN1pL?=
 =?utf-8?B?RmxvM0YwcWZwRktocTgzb05tbS82MVR3b09zbHNNS3RlR1pVZU9ZaXNWejAv?=
 =?utf-8?B?UXlDcnpWQngxeUVHbm5RK2FhMTFTVXBxRTMzTzFIZmQvOVNwQ0tmK25iLzN3?=
 =?utf-8?B?dGRFSGNZWnJscEhWSnRiUkF5aUx3dlEzeEc0ejJkVHNtYUFMUzUzMTM2Snla?=
 =?utf-8?B?OWFtVWZ5QmQ5ejVsMUtjREZmNTBUOXVvWjIwWC9lRSt2Wk5FM09iQjIvRE1o?=
 =?utf-8?B?ZStVVDFjMVkwN2I4Y0tBeXY1UEd4QXM4ZHBYSVpKc0VQQi83K2wzZ09xRU9k?=
 =?utf-8?B?QlpxQjJ4cHRMZU5aSVhlUFQ2R2VSYk81Vk1UOW9lejhMRkpacllkaE5iUFg3?=
 =?utf-8?B?L0pYVkN3ck03K3d1eWFwd0pqVzNHbjAvNWxRRUZiejdDa2VoYkFGZmpEajlX?=
 =?utf-8?B?NXk3TzJ1YVVFem4xYjhTVGwralFmTUFKTVhHSVNUdXlnUHFxaFhubEZVTDFU?=
 =?utf-8?B?VmhEa2NpZFF2RnlBUnF2cHhWSTdOMU81Q2dvNkFxNDhyV2Iwb2ZBb3ZKMTAz?=
 =?utf-8?B?cEhhMzUrbFRBY0lYRXl2RUtvZkxwTVpnejR3T2djQmlHNTZBMkNZQzY3TFNr?=
 =?utf-8?B?R3ExQ294dDg4Q1lZQTZ2Z3llN05EUzZKV0F0a0FaRm56b0JCZ3ZZRGpxRTNM?=
 =?utf-8?B?UllHajRiVFRSSXZiaG1Jak95cDhVUHR6NGhwUEwzbkljazRZRkNGeiszNGNi?=
 =?utf-8?B?b1NEbVo4aytueE02TVZLOUN0eE9KMTJzMS9FMHBvNmtsaXBGMUp5V2UrdG82?=
 =?utf-8?B?WGFrTE85NXVReEgrODIySXkxam1HakYzSE9ha3hGU2tyaEhDbmtnQlVHTWpn?=
 =?utf-8?B?UmQ3MzVscjF1alBDQzlCT2VoaWszZ0d2cUFDWStuMzZkc0h4NHN4RTMwaVJk?=
 =?utf-8?B?REdDVHpiVXJMUFIrMXBKVTJ1RUk3NGFtOVVvRlhmVVh0UVlCQWVYaElEK1pU?=
 =?utf-8?B?THZiWDQ0QjhGdk1HWEE1Ny90MEx2dTRLY1gvVGhWSEtGZi9aODRxdzY4OStq?=
 =?utf-8?B?Mkd1aG1YSm9vTEZ0dEpyUHhmSXAvd0Foak53SllIbTB3NzdqeTBHODZtSGJw?=
 =?utf-8?B?Q2VqNnVvOFIwODNldWFCbUovcDh0N3R6QVpZRlQzQlRja1o2d0lQZEZiK1k0?=
 =?utf-8?B?Wjd1VmhVNmZuZmtMaHpOUWRUb3dIRnE5UnFUenIxTzUrWkZXTVlvd1NaV0Zt?=
 =?utf-8?B?UUJ2RkFmMzVRRXZiYnVIVm04MEdJZEFlZmMvUHAxeUEwdzBvU090SVo4RVZY?=
 =?utf-8?B?RG5YWHVHZVlhakhWa2lxWXZ2Z251bWN4MHZ4WER4ZDduNGlmYjJJRkhsWWor?=
 =?utf-8?B?TU52SEhpSk9VSmNMUDlOUDNmdWdsNHQxaUY2MEMrTVZmV0I0TDN4OXM4UldW?=
 =?utf-8?Q?hHx+yDf77lf6x5iVPIhB+HzIe6BGmrQTNs2euHR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXRvTmZRa01hSHJwekxnZnZRN0FjU2pKSDJ0RVRXTGxWdGFucU1tdTVENGtY?=
 =?utf-8?B?bHgwRWNJZzhkUjNaY2YyNGVyN09pbE4wMmsweHcvWFExeEZHMERRMW85QXc1?=
 =?utf-8?B?UzlOVUloYU1ZRHZ2eUtWQVBSTGs2L0ZVOTEzVURKYnBvOFNobUVGaW14MzVH?=
 =?utf-8?B?OVl6VVp5TUh6MlNvM3hyZHVEc203WnJIdXY5Nm5HWXJFa2ZrMGFwQTVscTJW?=
 =?utf-8?B?U251cmRsV0lIQksvSTZrZlNSdzlvL0hzUkR4Y1Nnbk92SzhOS3U4Q3JPb29y?=
 =?utf-8?B?Y1YxRks2RWsveVNFTWE5V2Zod09ZTC8xTjZkWlp0TmR0eVUyT1kzT3JHdStL?=
 =?utf-8?B?MHdTREN0VWJTZTdRZHdONXdBSmhVZ3RhdzNQVGU4dUZ0b1RJRDRXNXFHd0VT?=
 =?utf-8?B?ZUtuZTNyamR3amsrZ29FK0xCNjE5aTRneWFBbUNaNUpUVitMRFpERkJNWDIx?=
 =?utf-8?B?Rjl1TkNnTXhiUGVvNFZDUUdJdzRaSlZHVk9Pc3NKWVp4M3JQU0NTUkI0MTlE?=
 =?utf-8?B?RjI3UnlzajZReVNBNnZRNzdSYjZIeXcyL2dZSzgrSDVJNklKNXhrY1FjTmRF?=
 =?utf-8?B?dVlHVi9MeStlajNkY0RYVVFhMENQLy9ZdlF4cGZXOXcrUlNBWGxaTVo2bDVr?=
 =?utf-8?B?TXBoVTI2R25wVW5ZZ0IralZRL1N2c1lhZ0gwZTRFdDVKVlBnVFJ0K2NibmxC?=
 =?utf-8?B?ZUZpMTBCNnQ1K1JoMFY0ODFVZW5QdSs1N2J5a2pnbDRnKzU5QWxaQTB0RDJY?=
 =?utf-8?B?TzljbWYvYzJPNFQwNEpYYXV4dFBZR3A2K09aUzZsejVDN3M5NkJDUWUzc211?=
 =?utf-8?B?TnUvWXk1ZzYxcVppOEd3UUU2OUlEdytpY2VUYVBFVlhQbitvdUJoZ2Nibys3?=
 =?utf-8?B?bitVa1VKdldKU1B4d0hJQ3ljcmh1TDVtOUdHVzYvbXpnaGh6Y2FRMjhTajVQ?=
 =?utf-8?B?cUdJR2hrV2ltQ0JDZVdhQ3BNUzJ2cUJaeis3eHp0SlJwL2tsek1USUJTL1Zw?=
 =?utf-8?B?WmxMRGxiMVZmZHpCUmgrVTU2NDdPWngzYm1mMWtrUzhERVJCM2Q0ckJaSmZV?=
 =?utf-8?B?OGk4YUZYVHIyVTRFT0ZvVUhPMDQ5bzhaTDBtODgwU0FKWWtDRXRKUXpqbWlD?=
 =?utf-8?B?aVVnNGZUcUg1ZHdlelNOWk1ldU9oQzJhNnhhOFFnZXBiOTRjbldDaVVnTlQz?=
 =?utf-8?B?Q2RtVVVneTFnSkJQOHdnOWl2SkZFUEg1YzhFVmE3Nm1IMmU4S3ZmWENVQXJP?=
 =?utf-8?B?MXZYSEc5OXlIZ1VwS2U5bkdJTkNyWGhwOHNGbkpsQ2lXTXAwblE3ejNGUGZr?=
 =?utf-8?B?ekpkam1wN1pDWjNacHdxUzUxZTFLNDNPTTNpTnlDaFd6UDZxeVM4enNqWWtD?=
 =?utf-8?B?d08ySVBjdVVjempZaWdHTDFLQWdPVWVFWnl6OU5MQnJ6RDg5ZDFNZ1BzWFB2?=
 =?utf-8?B?TldpWTR4aVZXTmllaGUwc3ppaVhmelAvOSs3aGExWjRndndGM2s0SEl3T1NX?=
 =?utf-8?B?REVKV2d4QjRuNkZ6ZWdTSTR6ZzVvY3JwYW5ORC93cHA2ZkFGaW5TRDI3ZW9C?=
 =?utf-8?B?L3F4UmV2VjlMNDhtVGRrT01YSjJqWFRPaDQwb0VZcU9yVVFCWm5pWUhLbmN4?=
 =?utf-8?B?MElYUGpXd1BBbVQ5Q2NKYm1KWFRwMXFUNHBaamZJc3IzQmw1RlVRbm94aWNz?=
 =?utf-8?B?cVZlTVFFWHFVa0o1UlFzaHBnalhkV0gzaENZVVZ5VzlLT1JGNFR1aEVpOEtr?=
 =?utf-8?B?ZlFkZURmdGpvcnNJYkF4Qzg1Sld6RTlQTVpXMWJUaTc5WmN5MFVFSEpKM2VW?=
 =?utf-8?B?czhGZ0dBdHowQWd4c0xxdjdTSllZdllwZ2FkbnVwcmEremU0TUVBMXZyRVR3?=
 =?utf-8?B?L0JNaGRtc2p1K1hWbG1iV0tCeDRlOXAzK3NYMnRDLysrYVhCRlVhYjFLYUZ0?=
 =?utf-8?B?OGVwVG5GcDVPWEQ2Wk15YWpwY2ZmN2x4R1hLeWVwMmF0N3lBamI5SVNHT1ZW?=
 =?utf-8?B?Y1JxU1Ztc1pnM1dVNmFTMlJacDF5QS9Ja0NIdm1UVjVtYjYzNW8rYlJMR1hi?=
 =?utf-8?B?N3o4MXAycWZSKzJPcE1LRkgrMWRqUlVRWFFUYjNrcVpsTlU0Tk94cjBuWGZj?=
 =?utf-8?B?WUNvT2xWTmYxdDZVYTlsUFp1ZThDKzhHWXhMS2RPdHBmd3ZGN0wzenlFc3Vx?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3cbAZQBYf02oDbBQTWt096ANChgg0PsKJon/1Crbx9LCGJ3ji+e7p9YlMeurYgpNV9+Zhx1nhEcADFIG7Uc4nVst5eX/n/Pj/0DlSfhJJ3Y4OsSj1KbRFLoUK6NUCeKjKwZQnYJ5nsgbZf0ptbe1S/IUdCQwQtG3v9GPnV2qUlPLi7tVVISQf9gGisAslSBcgcU58WNqe98aJL7mbEVSZNr4xBTFgCoZ58JfNQjc8qLnzQDG0pyT6qKXdQGxAS5mA/TI7NUL2Igr3obOZNxyhgNMUQRSP4gcAaTFMWlbGwlXkvMLMIthL5y4eiYTygpZlGVeptIHTDxKxANN8CN8gSrKFfc+tLLtWzBhh2gEjwuWLDFegSFPLApnUyA865b57/gPQLZGOjyne8YZruFFWz6PzFZnXASaACmmKN8hOZRqwhbKNpekaDvpz7xqOyPBEe3isH1VZVE/IltqQsWm4GHuQQO6Dci0WAmr+02RtJPS/+DZsFbm1sG5WVZh5hZIOD8aS1m1VOnVcxpc5WeLqLbSa9MFQpQe+kugqXS6BOpjOjKygWPwRaUtNlztX/UrbkkfQ3+X1ZxLRKqrxJvJDuTFI6R1pyECGs9F+3z3JSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be7f409-4a34-495a-4f45-08dd034646fa
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:17:33.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STQF+h4RvAKShNigSsZx5bTkLyWN5vKmNVsO4L/cxdJ/g+SJuiNHvIzezJah5yvRaTA7gaTAyvJV0/Ko4ccob3rgipRIP5BxqRUlvEOMMPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120146
X-Proofpoint-ORIG-GUID: bjcuJ4S4aMXe1TZz6GrqFT47ujssq-8k
X-Proofpoint-GUID: bjcuJ4S4aMXe1TZz6GrqFT47ujssq-8k

On 11/12/24 12:07, David Hildenbrand wrote:
> On 07.11.24 11:21, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> We take into account the recorded page sizes to repair the
>> memory locations, calling ram_block_discard_range() to punch a hole
>> in the backend file when necessary and regenerate a usable memory.
>> Fall back to unmap/remap the memory location(s) if the kernel doesn't
>> support the madvise calls used by ram_block_discard_range().
>>
>> Hugetlbfs poison case is also taken into account as a hole punch
>> with fallocate will reload a new page when first touched.
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   system/physmem.c | 50 +++++++++++++++++++++++++++++-------------------
>>   1 file changed, 30 insertions(+), 20 deletions(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 750604d47d..dfea120cc5 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -2197,27 +2197,37 @@ void qemu_ram_remap(ram_addr_t addr, 
>> ram_addr_t length)
>>               } else if (xen_enabled()) {
>>                   abort();
>>               } else {
>> -                flags = MAP_FIXED;
>> -                flags |= block->flags & RAM_SHARED ?
>> -                         MAP_SHARED : MAP_PRIVATE;
>> -                flags |= block->flags & RAM_NORESERVE ? 
>> MAP_NORESERVE : 0;
>> -                prot = PROT_READ;
>> -                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>> -                if (block->fd >= 0) {
>> -                    area = mmap(vaddr, length, prot, flags, block->fd,
>> -                                offset + block->fd_offset);
>> -                } else {
>> -                    flags |= MAP_ANONYMOUS;
>> -                    area = mmap(vaddr, length, prot, flags, -1, 0);
>> -                }
>> -                if (area != vaddr) {
>> -                    error_report("Could not remap addr: "
>> -                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> -                                 length, addr);
>> -                    exit(1);
>> +                if (ram_block_discard_range(block, offset + block- 
>> >fd_offset,
>> +                                            length) != 0) {
>> +                    if (length > TARGET_PAGE_SIZE) {
>> +                        /* punch hole is mandatory on hugetlbfs */
>> +                        error_report("large page recovery failure 
>> addr: "
>> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> +                                     length, addr);
>> +                        exit(1);
>> +                    }
> 
> For shared memory we really need it.
> 
> Private file-backed is weird ... because we don't know if the shared or 
> the private page is problematic ... :(


I agree with you, and we have to decide when should we bail out if 
ram_block_discard_range() doesn't work.
According to me, if discard doesn't work and we are dealing with 
file-backed largepages (shared or not) we have to exit, because the 
fallocate is mandatory. It is the case with hugetlbfs.

In the non-file-backed case, or the file-backed non-largepage private 
case, according to me we can trust the mmap() method to put everything 
back in place for the VM reset to work as expected.
Are there aspects I don't see, and for which mmap + the remap handler is 
not sufficient and we should also bail out here ?



> 
> Maybe we should just do:
> 
> if (block->fd >= 0) {
>      /* mmap(MAP_FIXED) cannot reliably zap our problematic page. */
>      error_report(...);
>      exit(-1);
> }
> 
> Or alternatively
> 
> if (block->fd >= 0 && qemu_ram_is_shared(block)) {
>      /* mmap() cannot possibly zap our problematic page. */
>      error_report(...);
>      exit(-1);
> } else if (block->fd >= 0) {
>      /*
>       * MAP_PRIVATE file-backed ... mmap() can only zap the private
>       * page, not the shared one ... we don't know which one is
>       * problematic.
>       */
>      warn_report(...);
> }

I also agree that any file-backed/shared case should bail out if discard 
(fallocate) fails, no mater large or standard pages are used.

In the case of file-backed private standard pages, I think that a poison 
on the private page can be fixed with a new mmap.
According to me, there are 2 cases to consider: at the moment the poison 
is seen, the page was dirty (so it means that it was a pure private 
page), or the page was not dirty, and in this case the poison could 
replace this non-dirty page with a new copy of the file content.
In both cases, I'd say that the remap should clean up the poison.

So the conditions when discard fails, could be something like:

    if (block->fd >= 0 && (qemu_ram_is_shared(block) ||
        (length > TARGET_PAGE_SIZE))) {
        /* punch hole is mandatory, mmap() cannot possibly zap our page*/
         error_report("%spage recovery failure addr: "
                      RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
                      (length > TARGET_PAGE_SIZE) ? "large " : "",
                      length, addr);
         exit(1);
     }


>> +                    flags = MAP_FIXED;
>> +                    flags |= block->flags & RAM_SHARED ?
>> +                             MAP_SHARED : MAP_PRIVATE;
>> +                    flags |= block->flags & RAM_NORESERVE ? 
>> MAP_NORESERVE : 0;
>> +                    prot = PROT_READ;
>> +                    prot |= block->flags & RAM_READONLY ? 0 : 
>> PROT_WRITE;
>> +                    if (block->fd >= 0) {
>> +                        area = mmap(vaddr, length, prot, flags, 
>> block->fd,
>> +                                    offset + block->fd_offset);
>> +                    } else {
>> +                        flags |= MAP_ANONYMOUS;
>> +                        area = mmap(vaddr, length, prot, flags, -1, 0);
>> +                    }
>> +                    if (area != vaddr) {
>> +                        error_report("Could not remap addr: "
>> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> +                                     length, addr);
>> +                        exit(1);
>> +                    }
>> +                    memory_try_enable_merging(vaddr, length);
>> +                    qemu_ram_setup_dump(vaddr, length);
> 
> Can we factor the mmap hack out into a separate helper function to clean 
> this up a bit?

Sure, I'll do that.


