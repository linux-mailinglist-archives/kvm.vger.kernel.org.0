Return-Path: <kvm+bounces-39763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66821A4A1BF
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40B63174C38
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D00B230BE6;
	Fri, 28 Feb 2025 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BG2hcEgv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S4vwFx09"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EB3230BD0;
	Fri, 28 Feb 2025 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740767718; cv=fail; b=JlDY9gsl3vvNVYIo2FK4kvMiJDFrlv9MaUNVwKx2kFVgpYIPFlOdyBAtey1hnq+Po5ABOUP+J4VEd5Rzcp6SZedUY4bHQwj/vr//Qu+9hn99SLj5FfCv4LYEfcEGQVAuJ8pTQt/44V5hYa62NRYzcI/zzPs9+2eDl0mMzFTcRkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740767718; c=relaxed/simple;
	bh=pdgiHLBWR4BiJuG4QPBUYIs8T6m8pvY5A/vckH1/v9s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Th+hC1/2fyCgVimJY8pOn67JhpwuVK3XcBg4jJWA2cjaFtZpLc7bFZSOo9MhLdTCj31NgP8cI6x3wx3O1LHKa7AehzeURlGIT8SE6KEBNHvAeNnJCGaX+e/5ryhwSSP+dh3Pdcbzd1Xf75fJHyYJKG145WT075O0/R1bqVdqZtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BG2hcEgv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S4vwFx09; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51SEGZv5004581;
	Fri, 28 Feb 2025 18:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=r0GladK1WZ85gX+DGr+9cxe0sk8JDB5xR8tWxvbwQxg=; b=
	BG2hcEgv4CoSxDrBQO/P6j+2qv0Wjz43zXLY728XxCWGbZ6BJ9ZBS8Oh4DuEcVmH
	MX8yF6PL91txHwmT3ak8cFQYrpWRuwg0tcZA7vbTa9Q77i2EMioR2IaQaPNomle3
	YRsfYUr0FLbfLOaCU3c8opTLnqyO0mhskUYXKi/Flr8LGa2+pzx4gs9H0vEZPxt9
	ZfIr4jM0jQKYpqXOe0wj71qaVcQmICz+ykyRtQHQiOKNy86nXwkcjhB7Uk6Mbdj+
	R9LoTbYKJbwmryh89B419tHcXXH0Z32BsP018no8KLUXGDjZ/cg2EFWg9OR+p0ck
	PCmAj64Ib0HOpDq8LZc0sg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psf6759-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 18:34:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51SI0Y6e010256;
	Fri, 28 Feb 2025 18:34:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y51dpj7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 18:34:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXHZHTltoPhUqk4Uv/GzzI8RGAxsWCJ3F5Qdg9Wu7Y083vH5ZuzCqdPRISdXhsPmdawR0ZLqRSx08Y/8+qoc9CmQe3oW8UE5FT4TPGVCYonX46P+2m9QLrvd+SGg06wU050wZVMoDRI/H2Rn86fQpAe5i+PbVh/rZpJeeDs9nx1gHfMAcWE5Mf2RBmvcduom+x0Z52W7RPpM59lA9uGXzdeUmg8vYItnhipvdo1qBqwIG/dAhuNMHvLY0vZdu08drcsTs9e0rGEKX5izHq6znniU+raOxesB+3P5G3Ybisi93cOh2FjfNwTkWGEkWhIBsmN3TxUMQWesNy0k/68n9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0GladK1WZ85gX+DGr+9cxe0sk8JDB5xR8tWxvbwQxg=;
 b=Pi2/tuEjYgRlEaTPDEdEKVpo6wlixBtxoGh7kk7mgbnPJVDSop2QOQwY2BxONWXL/PjzkLlHB++fWG8DFBN/H/vDjxWXhotH9exVoF7fu4Z595ZUjDjYfKqjgqKNmpSA4OvzKclzXeuV2xTDDY4JioNYsr63LpEkPinWBnfpL4QGZ2xxtdIFKw7XqDnmZt0lMl6EbgSNwrB2I0pCLD3h99HDEXyG2pc8mL0RTlMsv9n5MmtSFgNa6K5dp/AA9BbSQw+w7GU5IujJaznYMdYQhJ1PvKlUo2NiC2jazzRwGj6Cam84hRlT6D8wnzIwsboy6qCG6U2V/7NhpuBMiznOJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0GladK1WZ85gX+DGr+9cxe0sk8JDB5xR8tWxvbwQxg=;
 b=S4vwFx09t3jdkrSOVz4D+MpuiY4N4fYz0UhSo64eo/FBVFmmhpIobRayp/YC/ZWltrzCq9AIrdvtxiolP9bP32Xk63VxZ/dXxQOPUi5LmjleYuXfOs9hQjFSTnd0l9TUX+RPE8pDCSfxYYyQFipunDHCDgN5RUpI3iYFY4fVzAE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7331.namprd10.prod.outlook.com (2603:10b6:610:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 18:34:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8489.018; Fri, 28 Feb 2025
 18:34:56 +0000
Message-ID: <e04b172f-f137-4d9a-a99d-e757088df4cf@oracle.com>
Date: Fri, 28 Feb 2025 12:34:53 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 1/2] vhost: return task creation error instead of NULL
To: Keith Busch <kbusch@meta.com>, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org
Cc: leiyang@redhat.com, virtualization@lists.linux.dev, x86@kernel.org,
        netdev@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20250227230631.303431-1-kbusch@meta.com>
 <20250227230631.303431-2-kbusch@meta.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250227230631.303431-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0312.namprd03.prod.outlook.com
 (2603:10b6:8:2b::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: def125c7-51a0-4bce-dd1c-08dd58269982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzhDLzE2MGoxc2xsbTRSM2t0aXlZK1JHNGFpUzdBZVFTckJ2RVUyMC9aSkM2?=
 =?utf-8?B?ajEyODRRNTc2SVR0REJWMytrM2szZStoQS93MEVuUDJSN2RvZHVvRGtFaDVD?=
 =?utf-8?B?RkdDQk9KMWVyKzFLNm1qRzd2U25JalMvRm1PcmJTcDNoODFsck4zSVR3c2ho?=
 =?utf-8?B?MnNoZTZaQU1MNEhMcnZudS9vUjlIVzJyUzVycTg4YUdvdWpybEtCNGtWbXhO?=
 =?utf-8?B?UjZxcVozWmlXT3h5N3FwREN6MWJmZVlOZHgyZjQweGloN3Q2UVFoUlRvdmli?=
 =?utf-8?B?cUVEeDYybmcvaGd2d0tydVl1bFRwS1RWVll0ZWtPS054eXRucnRwY3pQVjBo?=
 =?utf-8?B?c3RNS2FoMnNRZG14RlR3QVZ0U1FINnFUeDFQbDBMOThqM3dJSEVRWDhlWi82?=
 =?utf-8?B?andWa0d4eWpDTmlLNFR3ZWp0anFXNFpKaFVYNnlQTUVhUEM2bVJQRUNGRCt1?=
 =?utf-8?B?T0lpL1pMRFdlMHI3R0NIQmpMZHNNbFNZMWpHTzgzbXEyYThvQnJxQjNWL0VC?=
 =?utf-8?B?SFVXMlV0STBDSmZNS2drNDNHVzhNaElNcGpxcHVpS0Y5VFZVajk4dDlqWFhi?=
 =?utf-8?B?emlnT2I3aitzRkhINWtEeWp4Mk5ONGdhUksxZ3l0NTBGTDlpemI5cldYT1lu?=
 =?utf-8?B?VGNOL0kvcEJEblpLSlMzUUZkRFBLaWJvdHEzT0Vvbzl6cTUyWG5tb3c3UXd5?=
 =?utf-8?B?bk9tQzZDbHBLbE9zb3RlL0V1RHBUcjlWWjFrUnZBeVY2WmpYVzhBeFNNVC83?=
 =?utf-8?B?Q2s2UkRZNFZ0WDViNE8rMm5jWldsWnhRcStmRGwrdk9XSVFOTjhqNlptbmZl?=
 =?utf-8?B?QnVUZlpVTHh2YnZxcUVzSjRxNTQrU1U1OEpPRkxVMTVjZ1l2b3FFbUhqcEl5?=
 =?utf-8?B?L2pHcm1GSVRubm5wa2gvVzFiaDk2LzIrTHN5VEIrTDI3WGw5bnRpNGIzUVRQ?=
 =?utf-8?B?UjVVaGxIUEtEc2hEaW1lUFZlS3FVV3V6MEl3TXV4VEc5VGFBbWVXM0RIcWZF?=
 =?utf-8?B?R3dVdGZPakRvNWhoa00zaHNuSUk2Y0RVOVJObGVjWTFxY2x2dlNyUDVubXk5?=
 =?utf-8?B?NTRWZ2JmTld5U0dsWm5hZkV0QmZzeFo0L1MrQURsanlhdDQ0enBRVTNwNEFx?=
 =?utf-8?B?R3ZwVmdLVC9KT3Q5WEt0K3k0OEFRRzFseis5SHI3YWVhUTZxQk9zZkhhQU53?=
 =?utf-8?B?WTZnbm5ZV0UxRkJTM0REbjUycW5MdGhaV2NHQjBtVnFjRmVMb2N6aDhzM0hs?=
 =?utf-8?B?S3RST0haRVB6dkp1aUpGZ2JjQ3VkcHliNEFiWkJobm1rUGZnMDdDM2RYekI1?=
 =?utf-8?B?dGlsWXJGb29KWWVaNGJ5aURmbTl6bW9KNm9RY0RSZW1OeFR0MHpVTHlmOUNu?=
 =?utf-8?B?QkdFdjFPYkpTSVp5bDMrbkJkMVAvOXdtYm1DbWVhK0ZBcHZqU0U5Y1dZMjZC?=
 =?utf-8?B?TnFVYWdMZWxTd3YvazhXWXVtdDRDM0owejd3SUdhR0JLSmdqSUV2TnlvWnhW?=
 =?utf-8?B?cTRxQnhrbFY5b0k3VWt6dHBMR0VPL1JPdG41SWZuSWxjaEZvT1JpZmxnMGlo?=
 =?utf-8?B?cm94VjBZQ0tPeUFuem9IMUV6WmVUL3ZIWllJTGNhb0VqWStJd3phL2pXQWJO?=
 =?utf-8?B?RFIwaFk2NkpTQmlVMmtCeG9JbGN4U1NsM2RuOFViTW1xRUR4S2hVZXVuRk8y?=
 =?utf-8?B?em54SG5QbFBOdEZjdlJyeVBhRkMydTc1MXNNZzBTbWZucGhOWHc4dTROS1pq?=
 =?utf-8?B?Y2U5UitXNjJhZFRraHBYQTdXMmloMC9LRytoRnhYWWZtRHQ5dkNtNWNPNXdP?=
 =?utf-8?B?dDRSSG9xQUdqQmNRSEJzbE5LeEhjQjRqQU5DSHZJZjBUSndHbWJyaUo3bXB2?=
 =?utf-8?Q?8SfqRc+I4+e0Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHVzc2t0VE05U2pMR1I5YWplbDI5Mzk4enBUVlBTcSt1aUp6R2ZnU1ZBZ0xZ?=
 =?utf-8?B?NzUwZGhoU0VTQml6cDFhUUhKOC9YLzJTOEVCWnVDMGZSZFBobW1McjM2UHdj?=
 =?utf-8?B?TzdaTjRSTnFGcDFXOURqRnlNRUZuVUhLYjI0MENJUzdSSnJlTGhqTkZkUXRR?=
 =?utf-8?B?UWlKSnllL1l4QkxUNzVJWWFOalp0dnJMbFF4SGRUQnFBR3BPVEVWdTlTS0o3?=
 =?utf-8?B?T1pVUWFaK1lpMHpvUHlzbWt0SjVWYTlVd3puUlRxR2EzN1NyeXArcWhUdk9G?=
 =?utf-8?B?MmhjTDBaVjhNaE5rR3hudXVEN1Rlb0pRUEF1dUJ0czNzQ3NseEY0SzhSdno0?=
 =?utf-8?B?cUFjNW1jekFtbGcrSEZ1ZktsVnBIUXNHbEIyd3RqTlJCQ1QxdU01RmpvRWJ2?=
 =?utf-8?B?eXFoQktZS1A3OHRMaWpjTG1vZE44bUpoNU50R00ydElxUmtLVWdCSmpqQ3Fk?=
 =?utf-8?B?d2pzTWk0RHhUSDZwcS84MTVxYnRmdWVFbkVMOEdINm1TL3NVTUFpazl0SUZx?=
 =?utf-8?B?M3hzR2N2WFlMRzNkYVdPSjhyTUV6bEpMSUxtbHRTQitOMHU3UStNSVQrQkd2?=
 =?utf-8?B?VThDbm04N2JjVUZxUjBRQUltOTZOT2NmZDZSc1JNaFlXbUVPNTBPam9LMGdz?=
 =?utf-8?B?dVdkd25ndHR5UHBzV1hKY1hZb2pXblUwaHIvVDd2alpJbXRzSFNkcDZPRWdu?=
 =?utf-8?B?NmNTNDBKbjYwQjhYWk1PdDJ0WDNmRnNvRUJHRGdZU21RNHpKalExcVRISW56?=
 =?utf-8?B?RFBBcVkzYlFzbERLSFBpUlBJbk5SVFVjVWRlSFFWeTlXa0RsUUJyaVN2RU8y?=
 =?utf-8?B?eHFRV2tPa0VUTytHcGpmNUNjbjFWRUpucEhIcFh2S0t4QXF0bkk0Q09tQXBK?=
 =?utf-8?B?cXB0TVdTcGxJeldaRWliZnB6bHhJbjNXcXVrNTFsN1ZJNS9HbG0rOHFydVZ6?=
 =?utf-8?B?dGJiY24vSXNSZmhJYW1XaDg1MzF6eHVZNzVQMXVUSzVicmpBSWhtVXhjVmpj?=
 =?utf-8?B?SWxNNkpKTjR5QWxhOW9PcEc3aDNVcGpvd0NIdFYyL3NmVERGK0RrbFpiWHFR?=
 =?utf-8?B?ZFg5N3B2WWhvNmdUVTY1RFJZTWlrcTZsTzlrTlJZTDIrcFF4TjEwcldPQ1o3?=
 =?utf-8?B?YW9qeXNaS2ZiTDFyVzZNNUZhOUNDVVE4cTlxdTR6cUhnWkNXeFR2TmVBbHFB?=
 =?utf-8?B?dkFkL2c1NEg4VTFmWFdpWThOdkJQbVlCS1FSclU1TTBYU2J4dDlqSlYrbzVI?=
 =?utf-8?B?M1YydjFrSitKTEtlc0dyRGtkNzQzKzk4SE1jQzBXTE5tZ2lENXZwUDl3RlAy?=
 =?utf-8?B?Y0tRRGhyT1FXMjYzNFNrR2RqOHdpcTBvaUU1YkZneW93K003SVBxNDRDR0Q0?=
 =?utf-8?B?V0tSbk9kdExheHZEbGNlTGVadW1yakI1eGx4S3VnZEl0NmU0emxVekJFMUJs?=
 =?utf-8?B?Z2dqaFU2TDNIRTZLWlV3dWVoaFUzOWpqMXlGVm5uNHkzMklKZFhnQllSVW16?=
 =?utf-8?B?TVVKWWh2MXFxd0RJRXBtQ3NzaEt6Ty9meEI5Vnh3clY0cW1iL2Juc0xlTnJU?=
 =?utf-8?B?aUlJd0RLMFo4cWNxbTk1RTlTVkxBZHlPNEFwakpuSXRZVlJUUzduc0lkQ1R5?=
 =?utf-8?B?MlhUR1ZVWVk5cXpscFpzbnpwbFlNeVhqMlNjS2JNZlVqdXAveEw4ZlBEWGRV?=
 =?utf-8?B?ekM4RjI5YUJ3YUFPSFhyeG9KTE1kMjJRVVhpMklJTHNhdVJrTGFKNUdrMVgx?=
 =?utf-8?B?aWxHb2RnY2lGNFFDSGlEU0VjYlI4QkdmRjBmNldZR1pJQjIrUmU4dVRRd0hv?=
 =?utf-8?B?R2JNcWo5Zkt3dTA0MkJWN1F5WlVVV0JsZ1I3UWhnUnNtT1p1QlhSWFlkckor?=
 =?utf-8?B?czJNTkh0OTJtU0ZzYms0Wk1XcVRwanlUUGcxR2FQSGE2OHY2R3ltSkw4RXFP?=
 =?utf-8?B?T3BZRVRreW8wdVUya3UzVHV6eERQNjJUckR1WjFydEpNWDQ0a0tRaTRPZDBI?=
 =?utf-8?B?bjN4Rk91ZFZwcHR1enI4elRVMnNQRkdCWVQ2MkVvRmNlL3BSS29yR21YbzFy?=
 =?utf-8?B?SEFKSlYvOCt1UGNTYng5M3hmcXc2bU82YThsQklFL2FFbks3UVlucFN0c05Q?=
 =?utf-8?B?a3J3OHI1cmxValNhb1pueHB2Vy9abjN0dGFaSHM0SytIYmRIRFVJM2ZQQmdC?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bsTLz3cwHvH8EkHDhF78sCkXuWfgVS6dxyfM8jnDuMl9NNVNeM8RfZqHKJj8Zg32lQRuuh9zoW/gSwCewTByOEATAYjzzwCLV3Wz8Z27CH/YU5Y2G8VxKXVcgaC8uu68vlu9qRzuWMKr+gYfBGVKK6UDHHifD9AMJoXILTVGF8slrL7xqlVAbD9OC7kgOSG/AK9jl63am10bL6hLBMGSTpUtdfmzWcmbdYLM1U1MzGhmnYekPuKQkYePQcyd+kYC4SbNb7GPH57RwirsCXunWdmUChOsFNmg//GlP7EW/bV8VWdo+p9GOm6eVW83dQEdZmgEDFXoQFnhZj+C3PU4+BH5MhJ0AwJVopkCJ1LxxajXQiWEgDnvzM8SkCq1PFA74bCRsL8pd48S+0uEJXpFkzz7HrSkYnOvSHvANpjkuXifytJsf5dcWHg9Iz6HRw/m28jhtMzzjF2hGPBdm9yKlVJcLNGftEaWkwRBxNcRfgL2jRZ3IbfsXdGitmJVyk4yKmIZEr2zEMU1XlQ9XXmqND75W4xHGo49L6qo79gWWw/1s3UYDCggGWawwwjyY1MzhnRWRVKROd2dpAEorphCeQmB+4XQxyQ9hYy0+ytSnto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def125c7-51a0-4bce-dd1c-08dd58269982
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 18:34:56.5072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6byYpFq67L9U/EcLXz1Hfq1thcToSFz6A8WAUxdVxIve93Woi8ML/BWAd92q40JnKpsWXA19xhZJE7upPQ/0ImhRkyhz0RunGo/Ry02YZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-28_05,2025-02-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502280136
X-Proofpoint-ORIG-GUID: kBWnHiaPAE1lNv24So19k8bUQbiTS94E
X-Proofpoint-GUID: kBWnHiaPAE1lNv24So19k8bUQbiTS94E

On 2/27/25 5:06 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Lets callers distinguish why the vhost task creation failed. No one
> currently cares why it failed, so no real runtime change from this
> patch, but that will not be the case for long.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  drivers/vhost/vhost.c  | 2 +-
>  kernel/vhost_task.c    | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d4ac4a1f8b81b..18ca1ea6dc240 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7471,7 +7471,7 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
>  				      kvm_nx_huge_page_recovery_worker_kill,
>  				      kvm, "kvm-nx-lpage-recovery");
>  
> -	if (!nx_thread)
> +	if (IS_ERR(nx_thread))
>  		return;
>  
>  	vhost_task_start(nx_thread);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 9ac25d08f473e..63612faeab727 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -666,7 +666,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
>  
>  	vtsk = vhost_task_create(vhost_run_work_list, vhost_worker_killed,
>  				 worker, name);
> -	if (!vtsk)
> +	if (IS_ERR(vtsk))
>  		goto free_worker;
>  
>  	mutex_init(&worker->mutex);
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index 8800f5acc0071..2ef2e1b800916 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -133,7 +133,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  
>  	vtsk = kzalloc(sizeof(*vtsk), GFP_KERNEL);
>  	if (!vtsk)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	init_completion(&vtsk->exited);
>  	mutex_init(&vtsk->exit_mutex);
>  	vtsk->data = arg;
> @@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  	tsk = copy_process(NULL, 0, NUMA_NO_NODE, &args);
>  	if (IS_ERR(tsk)) {
>  		kfree(vtsk);
> -		return NULL;
> +		return ERR_PTR(PTR_ERR(tsk));
>  	}
>  
>  	vtsk->task = tsk;


The vhost task parts look ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

