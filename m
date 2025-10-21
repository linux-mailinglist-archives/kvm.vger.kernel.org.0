Return-Path: <kvm+bounces-60718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F18ABF9091
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1242188FDED
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF119299950;
	Tue, 21 Oct 2025 22:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dVbFr7gl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xPKgBJuy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5AD26980F;
	Tue, 21 Oct 2025 22:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761085288; cv=fail; b=M0w+3Zh1Chf5oVyi9wkIGAw0NUopybQnKOt1TLsdHcOCwT10FKvbDjGNzGq1eRyKq46ClT7t3yC++Hqc3M/wZ6Syh9Fo+XgmCHOAIrNrm+1AMhqlnfeyJ+fkYuTkVWQYDwqCI6y1Nob7S4CCS01mQ2VboFbcEsTdZi+/dWFSV2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761085288; c=relaxed/simple;
	bh=+RzbTYdNMhbSiNdmsEkVwUxNJahKiB5MqRkRCwIW0hU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mR5FnmwsV1rkWEapFBowsvP1b4Sbj2sQoO/ub6hy274G8hPWEWD6kbkzv4w94upK6l17JUlr/X21bM5W7VHcsMssNZfcGaJu1NQE1KbmYLYLeCeqmA5JB0YqIXXFZ/3RxSAJFXT7rXFFaQ2cuxQDH7BJye/OVCN7risQiACJ7Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dVbFr7gl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xPKgBJuy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMCZ4I013881;
	Tue, 21 Oct 2025 22:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RknqsBFzm5ncgkJWU9OKLmx3kEQ514HS9PglluIr1eI=; b=
	dVbFr7gl/w95g1NmFo7ToykUnu/HXoEwiaqqFNBZedkWtUdT0FAZaEb/RkvITh2E
	b0fb//FrvdbMPIPMTdH/Zvo8UqA4e0VzfvcYYIYYYWehJGBH1fYgKoA+9FCGMeS8
	XxY6EoasqWCnB1IdcGHt5vqMneTNUypRcwICJASt43oTZhocoU+fuTORxVaThlV0
	wliLhC8nfEUvB1nGbTXr7yAuAyCMsQUUuB0DVuU4M9+K7+v5AVrtWmM6Wb0asRbL
	gsbOEwPtmTZJDqH5+8h4mCpyBu32LW/5yS0q8xyJzaKouLlkJHwkw9DOCSV7ZUQR
	8jmY1+Y560BmUc7G10+wjA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3076kgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 22:21:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LLEffZ009374;
	Tue, 21 Oct 2025 22:21:21 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdnpha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 22:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYKrpxhUUVos5OdsVrw+NiO7BDufuixtkl1nfFHpgUfQeAaDJU284NQN5IahlJP4ixT0I+OQBmRB+1XACw5828+rDcHfh8bLNuLBhEPtBNILMbIRf8Edu+5LNt0KYAgDP0OFM3bBphAIpu40Ss9UXWA95eCqybJPGS94sIopDevuW3m6xJB7Mg3AiUCN341VtbtwBKldVPdnUhAhwlx15bRSDCHodH11zAvXzInKfhvFk5uGusTxGJOH9kfboWzmISFiU4MpWl221ZnqXr0CTJCG1qtYWibDn69WRXn+dqmCcEs51BVfmL/s0mJ5rX1KUzq07Zny+gL9wi3tiN2RDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RknqsBFzm5ncgkJWU9OKLmx3kEQ514HS9PglluIr1eI=;
 b=aZGogZQ0o7DqxHP6HmdLASJrCeewoPJ2MnsWYYTmNVfj+4bvktu/oLeggJ1AYuZKxfL2dAKWrPLE3tThDWOrmqMUG73raa/OCvqD71/0vpuOzSRcg3mXZplhMNJN8B2qTpDP9VsP0Q5X8KPJVWqGkjCF0ENMM5xYHFgVD2w0U1j4MrgnngV4jzEgCyWuzJce+nJHJBILupTtczwXaQYUbhOrIckLPzaAZ1BTFrdj6/2lyKFEf0y06CTqqLo5BB7808RBsCTickOL2i29svWMZa/u9RRXa9TjAXtPtXRBvy0HJeTkp6u02getJkpyZvmEdirAG2l9e6i6WkuQejA+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RknqsBFzm5ncgkJWU9OKLmx3kEQ514HS9PglluIr1eI=;
 b=xPKgBJuyQJxR+26cbP+jcqhT5VqMchJADc/jT5lyKW3gc4J/wG6hn2K/HIK89pSsfOY2b8+hCAWq9ZhpNnQ3dsbFRSGoOHwUCHdJUMghqulLgvsCDtIH8Kx6ByutB8K8Jex6EcARimhKfUFvFysHDPkY/Cw/6q6SC+Mb3kBJPO8=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 22:21:14 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:21:14 +0000
Message-ID: <164d9ae1-34b0-4ed5-a882-d1552ec3310e@oracle.com>
Date: Tue, 21 Oct 2025 18:21:11 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
To: Alex Mastro <amastro@fb.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH5P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::16) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ae4ffd-06a2-46d0-26d8-08de10f025e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUNwYms3VFYzVjhMRHhCd0dtcGVrT0dDajZqS3JhM0Z1RGZDbW1hbnhmSzgz?=
 =?utf-8?B?R25sVHBIMWN1SkpRdVliY2did041Vyt4aW51VXpoVmNCc2hhWi9UQ00walJG?=
 =?utf-8?B?dVN5UVVBYkdRbjRIOHVtbVZRQk1iZzF0eUZYNEQwdnBlWTM4cEJISFRCdDM1?=
 =?utf-8?B?dlY2ZkhKOUxsN1dDUnJ4bndzbDZMYlh1c3ExN2xzcEVjWUpBZGl1SklRdm1r?=
 =?utf-8?B?ZDBZTEFObnZTRGNjYXdUa2JSaXh6MTFQVE1Oa2tzNG1IblFWajYyWEF2T25U?=
 =?utf-8?B?Z1lJRWRCTkkrTmZsbHg2NUZubXRzUlhiMWtpVjR4RjdTd0I1aGM1UXRFM09Y?=
 =?utf-8?B?MjNQM2huYU1nNEtWSkkvSUpBRXhkYlVCSGFPNmQwUWIrVUl0dHQ4WWZ0T0dp?=
 =?utf-8?B?blk1bWFoU25xVUFFOUZqYkhHWDlkRzg5MnZTS1ZqbFNWc3U5Y0EvT055OWl4?=
 =?utf-8?B?RGt6RWlnUUVxR3dLZ0VCM2ovVzJYWEE1TlIrb0I4OGNFdnduc2R4ZE9oTmdw?=
 =?utf-8?B?UHhrNDZYZmtOQ1BrN200Z2dqOGRDK3p0WGZER0s4cWdvNWdpRGNhYXpveHBY?=
 =?utf-8?B?THpiZC9FbE02bC9acTFWaTZCV2ZNeWFTOVluejc4RTFQNUVuQlVERllEeW1Z?=
 =?utf-8?B?b2RuSVY2S0ZjMFZXVGRaQ1JObHpnQ3pKNW9LZ0V1OTMzeDVDRm9FelpKaXBq?=
 =?utf-8?B?NUhnMTFXL3gxME83UUREeGk5MCtPRjU0bTZDMDAyUDRIbCt6MHhrVzBwWjMy?=
 =?utf-8?B?aWtrR3d5OXJ6djZ2aHo3QmJNd2tqZnd0VHYxTC9JTVZqMmlGMjZRdTZIWkQ5?=
 =?utf-8?B?T2hLek44djM2Z1hFU2d5M1RmMWhTL3puS0xEYzd4T2U1VEpsWHB3c0FGRHJ5?=
 =?utf-8?B?bXVNd3JRTCtERm5EZWtWSUcyUmdncEZBV1d5SUkra2NnK0JMNWR4MmkrdGo3?=
 =?utf-8?B?YkdDZEw0S3lYdTM4U2l0blUyWGxmR0ZOTGswQTYvQi9idjB1bnhkcTZlTitZ?=
 =?utf-8?B?SEZkY1A3QlBub0cwd3VrSW43bDBoamRGYWdzN1htL1ZYWUFrY2c4M1U4Q1dx?=
 =?utf-8?B?NHZQYW85WnU0QnV2ZytObUtBZWZ4MjM1QzhUSWd6V0ZneHRNV1RkRmc4Zk1G?=
 =?utf-8?B?Nk5HQU1JTytSRkIzalgzRDAvOTNFNTFoWHZFRGRDTTg3blVaSTBzcXVrdnps?=
 =?utf-8?B?MjArREpMcHhZYVRTV05WUUZ1QmhpQ3pvSEZHRXZyWW1vc3lzTEFjY2h6VzRx?=
 =?utf-8?B?T25LTjNjK0JHTDdCKzRocERTNk5BWXZSNFZRajZpQ1FCbnFDaHltVDNSdnIz?=
 =?utf-8?B?QjQwc1o1dW51elU0MGxBclp0cVI2STVtUzQxYUtIUGIxOVI0MHJzMi80eDNy?=
 =?utf-8?B?T2xPZ0tKbE9BOUppUEFJRFcvRE5heWQzZFFRcElmUzBDYS9FazFkVTVDUjRx?=
 =?utf-8?B?aVRHNitESFZiMlJtaDNnWFpmNTAxcWZkY3ZOYmN2NnF2WndBT3dqcWxDblNr?=
 =?utf-8?B?SE9wYkpkMURkMGZqQW52TGYxaU9ETm9INHdIcFBUdE1mRkZUMTJabHFTc2V6?=
 =?utf-8?B?OGptaG5ScVRiZURaSnZGeDQ4YmJIaUtDem1mQlZjeU1NYmxEeVZMRm5hRzdZ?=
 =?utf-8?B?dXU2Z0dBc2VCSHd1YVBjR1BvSnowdys1L1dzUmhXZDRoT2JPaDFFSk9tMzZz?=
 =?utf-8?B?TmttellFMFlSTmFhMFBsT1hkby83NXlpeXhxejU4Q2lVWktLRjdrbVBHT1dI?=
 =?utf-8?B?TkhVV0ltdzNEMGxlZlpOaE9aWS9vR2c5TGFyeERaYUtsS2pnUFlHWDJWbDZ4?=
 =?utf-8?B?R2lsaTM3K3FhNlVMcFdxbTRUakY5SXY1d2hFRlAzRXhLL3VLcG1wMjlzV3gv?=
 =?utf-8?B?YVJHSVRJL3NWV2xybzdpckoxRVJ0cXpQVVJUaTNqMHFpTG9iQXFlZUVyQUwv?=
 =?utf-8?Q?xiPpQNSKGXMt6fhALJQ0okTzF4W4tk0p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUVMeVhmWmdzbDZhdFhOeE93akVvNUdZeStVU1o0clVBRXhMSkMzdHVmeHVm?=
 =?utf-8?B?WXVmdVpNNlRNa2hQaDV3TlU1Nm1vMVVXemFPV1ZXaXJqemMzMG9RV0RPMzJa?=
 =?utf-8?B?NG01Y21Ic2RwU01ld1ZFd1pHN3kzdmZqTVZUNEVyY1VXV0VBZVgyUGlpMm5U?=
 =?utf-8?B?MmdGenZwZXhueDh6NGh5ZlhwY1hWR21WMmlxak43L24vZmI4czlGTFhCV24z?=
 =?utf-8?B?aFNvU1p1bTUyRkhTTFpDOHEwMkZuR1BOcjArSjlhZXNHbStDcVpMaUU0QUJ2?=
 =?utf-8?B?b0h0bG5EL0lrYXNzSldIOWZXVnFaRTA1OWFwb0FjMlFLblZTM2YvcjRDZ2h1?=
 =?utf-8?B?SGhhdzduS0VGd2VnRnQzaTluN2pTVlF1OXpRYjJSeWhmMGlxUml0Y21yL2RZ?=
 =?utf-8?B?U1BzcWpaWWUvTmlYR1hqeGdUd3JYV0ZxRHV2S2ZHZGtqZnI3SHRjTXEzOW1a?=
 =?utf-8?B?MHVkdGo3WkhibEY4bnZiRWwwVFlvS2NzTlhBWS9aYzZaS1NsMnRuTkVtMDNu?=
 =?utf-8?B?Y25aQlh4TEYyRkRqdW9YR1hiOFMxN3M5SGJBTmFoNVJWUGVIM3JaOHVPQXUv?=
 =?utf-8?B?T1hWVjZJaVdtQ09DZ0wxYU95TzFGOXBpRTFWb3lIUHN5OUlXTFFGVEN4MDk3?=
 =?utf-8?B?Q1QvNWJ1ZFczQXBwNzlab2txSHpuOWJOZ0RzdThEdDNhNG1pZnlKbzFCVU44?=
 =?utf-8?B?VkxLbUZSWnRlMGJSZUE2NEw1cVdXOHV3YVBsZ0Vsa05mNmtGRlM4ZXM0WWtQ?=
 =?utf-8?B?M1BveUJHd2RyVlI0U0pBdE03bXh6eS9QVFNqUkQybXZ6ajNYYldLNVN5YXBF?=
 =?utf-8?B?YzRpZmlYcW5leFlySllQNnJSYTBFcWRoVitudmFqdkhtenZkT0dGREJkZDZT?=
 =?utf-8?B?REExeHYzUGQzQUUyb1F1NHRWWjVrREFBbzIwTHk1RXZtcXB2N05JUjhIWXFZ?=
 =?utf-8?B?UDJLYjdKaG5odkRGNWpiZmNjNGtUemdocjNWTk4ySGQ5cGpOSG9QNnBTZlIw?=
 =?utf-8?B?K1kxZElONjhaRWJUY1FnRU5oYVlOVUthSWl0ajQ4SG54NlNidW1raVlSSXlp?=
 =?utf-8?B?d2RCalBxR0ZDSGRNMHBtRlhqTjUyM0p4aC9WWGl4SnMrTDIvWG15bmthbkg0?=
 =?utf-8?B?YktTSThTbTBwVHc5ZWtLejlhZ1BDS3dLdnVNSXhKZjhjU1VBV3dsZzZ4T1h6?=
 =?utf-8?B?MlV4U2h2bkp6eHpTY0VxUEhpYkd1TFdaUzhlck10SjFneWZnZVd6V2xXTnQw?=
 =?utf-8?B?MFRhYk1MZk1PbTBIQXFrVC9nOEF5dFV5YkY1cDN4VklaUmZpU09Ydmc3QUhY?=
 =?utf-8?B?UDRvSmFvZm5zL0YxK1ZyTXRrQ2xBUzV0Vm50QmljQzdiUEpNZ1hLeXJwV2dM?=
 =?utf-8?B?RVpReXhIdk1uZ3ZaWnpSYllDcjBvdHFvaU1xbnMvd3RERzdlTUxuckdxdVN4?=
 =?utf-8?B?RXdhRWpNZC9BRnEweTF3cnN0SmpnSkI1TjZkTXBvdGY3VW1kcHNCMm9YNTh2?=
 =?utf-8?B?dWZSZEJQMDc2UUVJekpjWUpsTVhUZjN3TndRaHQ1d293WjR1d2dTc0VZSjMw?=
 =?utf-8?B?TjhTeUlZeXI3bmZ4OWhWU2JSL2FpbXRVYitZd3FXNnR1WHBjNTlEUEN5ZTFB?=
 =?utf-8?B?VjVha0hnUXhQM2ZITmU1Y280NVQwb2JLQ1pHVUZvUS94MUhQWDQrV0tjUU9V?=
 =?utf-8?B?VTNTRTlGbFdycVR5L1B2MXFJeWtrL0Q4dEZ5Q2ozU1VtVkFlM0RDenBSVEpw?=
 =?utf-8?B?RGJHUjFLd3VLT0NIQi8xSTByQzFNLzlmNXBhckFBUWZRZnBWUGdlVnpMTmNW?=
 =?utf-8?B?a1ZJelptZ1djYk5FejVVcUVYb2NwaVZzeG5UczF4eFpXY2VkVkNuQlJjU2tT?=
 =?utf-8?B?eVZrZGtMa0tZMnZSMkJXdTJ3Q0tHRnUxRW90NkZ2dElpaTRHZGhuZ0NNb2h4?=
 =?utf-8?B?RzhMeGpoVmtpRGRRa2VhNWh1NjViWkp0Tm9JK2hZSGw2aDlIZFZiWEJkN1ZC?=
 =?utf-8?B?cXJFUnhpdFozR3lhWnpFMVBqRUdzL25hcS95Vm1WS3VTbktDRkpZeTdnTXAv?=
 =?utf-8?B?QndUejlrRGlBTkxqYUJueURiTzBaNkhRNHU3Q0E0WGVhVGpDdHd6TnczWmkr?=
 =?utf-8?B?Ym9LRHdTN25YemJnUndBRFZ5by85QmhYOFdWWEMzTW5TTXRGRnZaNERSajgz?=
 =?utf-8?Q?mzvby44Htrks1sk+5odZkH8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZSN42MfhtQR0CptynQqq8BvSnLpMZkjtX4EYQxoVR9mzfi6GwBz2YzF17gRuRvQW5k7IHUFSyub8HhyBspEgtQW9tsSE2SeXlrLUbF2YfAW3neHMnaG1jl6ylqIy9+p6eW2+qV1d0GwDcCuBjc3kjbLv9aMhJJJFcF4VZtjGoH1z/CNV/tUop1Xd1GcWPfyMzGDoWm3xxbjkl+avlnWhq3xpQZuTs6yhY+aHi1O9zMRHZUTqxiDPbEdtrgLpD/LEevEYLRwDduubVItQ2y66d0m1elNv3MXksGN9gDyR25K0/AE3Alo8GFwG8cz7d73mgGsW/xLkkPH3MFZYj7VYgcjjtnFaAataSs31vQzlWU6w6KdMjPrmiI4s3z7yre3kh5ADSStesWDH9pGSQqxSE1lAY80voOcIxdaDT37eW497A37FFqmwDKWIWSMrXVis4/gD80NbfNCm7O6ZELIHLPGOxaAeRanCB+rxUpJIeKYuIzytX5HURjJPp6E9AUBsHSyDC3ODRWMkFpghDY54U5zfm8XaxaoQ0vBdMnCG2HKcwfZh6fxTTMqzbj/D3b1FtPCYDLliZvQHNqe+jmT1/KLK83aCfPKsAmVPWBX10jg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ae4ffd-06a2-46d0-26d8-08de10f025e4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:21:14.8467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X+did0h4m+R9l253zELd7mYjuCqtzQY9E3qOwtCK9PDcVjuQ39ixfuMLM8CuUJGQ+iSgPSkzfELbbtqIqbvPmyggAfa6HlplGK+o7tV7Wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210181
X-Proofpoint-ORIG-GUID: N1ZBUAyFwS8cW2Jf6I_-hAETcmocOdx-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXzWIy3NodM7Ge
 DSRZVdVDl4yiqK+5QTJE39dXi3rWN8v1BhoiDxBiBZ0dRiTKOykyogGJpkc7bMC5y9j0nJP0g2O
 tHjafshLkZxw7xugWeoCSoWgUBaUo6iDySWnBDjhFk0pfSqnCs2IpEFz67oP/Xo+1jxVL5zd/2I
 YbMSc/RINWbyGlqG8x8RvdOh2sCbWIO33Lek9zk9mE7k+9OS7lp3VmFGu0ch1SikSn/NDHpU6VA
 /ne58TA8cSOuQoFtqu3m7CxH2ze/0mpAT2a9HsEVTwPwdUChK2XDYgVq9Td56xDxlLXbYo8Bmc8
 tv5ieskxQeOV/1o9pfyAt/0DmpzLNsAqij/N/mv3+N6EJYwaI0D7/i5VyyoNkb7rkzJLwLzxpL7
 zZ9Q6Na5HEpEq8UzH/IwLls6j26tSUhVgLROWgLj44oaTBVyBDU=
X-Proofpoint-GUID: N1ZBUAyFwS8cW2Jf6I_-hAETcmocOdx-
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f80762 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=_59OTBGtHu4ubVKIjV8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12092



On 10/13/25 1:32 AM, Alex Mastro wrote:
> This patch series aims to fix vfio_iommu_type.c to support
> VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
> ranges which lie against the addressable limit. i.e. ranges where
> iova_start + iova_size would overflow to exactly zero.
> 

I sent a reply to Patch 3 with a small nit, but regardless of whether 
you chose to make a change or not, the current changes look good to me.

Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

Thank you,
Alejandro

