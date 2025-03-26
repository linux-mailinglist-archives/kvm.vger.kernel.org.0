Return-Path: <kvm+bounces-42078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A82A723DC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:22:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 131607A4FB2
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95667263F2F;
	Wed, 26 Mar 2025 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AqPpagRB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wH1BEcNF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043331A08BC;
	Wed, 26 Mar 2025 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027744; cv=fail; b=rgf2FZ6lWDMqxlBLiDlStUxYFLX+bjqkcBzzMrU8cQvodMm6zL0VygxLEe9b4Wq65tjZ/xgykwOR+aLUWiQGcvmQEaF+vymFSf4ytb7+3/xbnULe4su/bMpJGHibRwZdm0+6v0iEvfkcR4i2M7tSnTFIlIyhNk13u/AtQ9bVmr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027744; c=relaxed/simple;
	bh=l7oaTGeqGQ+vyzBC6dy72UettR6sQXHsuA/buAmksi4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N4qs4yY2973UCjRPjS58/OD7GPKRs/jHJ0reVX5iRJYynJ6d67hbMNMso/ZkCHo2xzxMC8/gc4IywqtPiVSvcHsPBvMHypBWgZCrzm7bWIFeQJgkKBsWlYH0BbL3Djx0muUTNNNwsaAVdYB6n2Ko7YzIBEKrTgu143R5Yryi5PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AqPpagRB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wH1BEcNF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0efS014324;
	Wed, 26 Mar 2025 22:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=O/qKaG9nVmioLtufO/x6gmdhmGHQw9eiphf6gCqY+2A=; b=
	AqPpagRBiE8E7sMxTHWcjpuF9cXOBuy45IH1gZXjTV+o4tED20/vVSOCbR+lmODL
	059ubvJNeibgrKz0R/Op4DrY1lDApeYSACFzZkBslLlo45qNuhZTNpDltAl5eDEg
	ghRoBWC7vNLO48ZTS2rpkxUw7PAhEx6/7w4GxHM1cY8IZ08xpNdtYmAYqGqQJaaR
	hCCRfgnUmPvG6f093wirwJtSDHTJI8j7YbuXqUyIGVpYTgfiWBJu4HiTDKSESkUa
	VR3dEAUxbBzP7wDmUehldVkbf+TL+ObTOlQ108Pm7vWnwPc78ChtFx8K7GFn5i2p
	/39VapiC50oz5EVhUJkZiQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn5maymv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:22:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QL2718028750;
	Wed, 26 Mar 2025 22:22:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6uk2w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:22:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+RkR3HUnWVUejLRzaxFUOrJQrGLO10V9KPN2Q/WHGOqLny39rf7s6qgMiQeuVjx85adskkZwBC1aRyAyw1aV3unygB3LULRTZ5ZivT9K+Pw7zIVgWSY1vzGcE7q9SgdNofM7K5yp6LBRMdwj/Xl8zkOIH3Y4op+m7GtLrfWhCi9TClzqLjrXA48roqXqCT7l33qqXEZJZ56qAuVQNMW/pAU2ewwXkJ5eIcnCs5R7dicJej+ldHnJyf8d9Qq4lsD8nAh+bZ9CZqsiC7mpEX1A5AGiK5UC55XOJZhv/vnhIqPrTsglR/QC3OIQ4DN2fYaSJd4QhrODCY1Xji4uEY/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/qKaG9nVmioLtufO/x6gmdhmGHQw9eiphf6gCqY+2A=;
 b=qEj0XLlfYoFlPbqngfH2IFtkQlZKO5+uPexUdmQc0CoZK0O4V7vjyH6H98iA1DmK5IXKQV9RrDEXFYPZgYlwiuSlXdWOHyZ/e4iralbuDyLVBh1nflMGMZTXTIg5vb+BvOIqfE33MVd3FOw+cCbWa243tdD08yoytTjql5XN5pR3tQL79Jm7lWH89Z4ZeRsaYDxl56WMEyA3UoI1eVDgr32lmYH9tXEm6UVUzTprzvQUUzx+9lp/0ZsT6fd1BhJ//+HohHU83VrjSIbGRjxXKwGSn2kZMA+GbrPYRXQ/AB0WLVGMgdONOuTYt13qp3SzAg8NPROKECOLH0DX6UB2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/qKaG9nVmioLtufO/x6gmdhmGHQw9eiphf6gCqY+2A=;
 b=wH1BEcNFhDbyv6IL0fwkNm29RlDReF8xU62Pj9r4eozUK/ygGZoQS8LHpjg4q5L9LbzA/WGQh8tf7NNU90dRp5P7JIH2ncg+/aH58IQVtmNfB7wWjE1o7H3vtWv3P6196+fdJXvKtoofKwKGKdyUTzleAMhR3pXJ1Aa+lVm9Md8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB6168.namprd10.prod.outlook.com (2603:10b6:930:30::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 22:22:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 22:22:14 +0000
Message-ID: <2f2e1de4-7c24-4851-8816-c27d162fdb53@oracle.com>
Date: Wed, 26 Mar 2025 17:22:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] vhost-scsi: protect vq->log_used with vq->mutex
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-2-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:5:333::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 785f33d8-9d10-46ff-026f-08dd6cb4a8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlJZaDNaUGFxNGFLU2R0MU5xNjI4K0lKVmdHMjk2YVEyUVoyMEpXQ2p1M1Ez?=
 =?utf-8?B?Ykp2RVRKQW4yL1pRT3NUU3VlV0hJVzBYdzd0YlA1bUtxcnVIVWxaMnN5MGVP?=
 =?utf-8?B?YjJGd1JXVTc0MmVWMHFKM1ZPMFhRMzloUCsxRFFRNWZQbENndnR1OWNtKzQx?=
 =?utf-8?B?UkdaQkdxSy9RZ0xLN2R5MWlnQzJmYWdtZU42YTlVanpiVG94RFg4d2Y2M1pu?=
 =?utf-8?B?R0V3by82TGhVbkwyeXdvOWE5dVNuaDR1bTFEejJURlFKQi9ob2JyVVo0VGZU?=
 =?utf-8?B?OXhsY3BrZkVnMFZkK3ZrZStSb0ZtY3NwS2F6T3JoeEVPTW85d1VvQ2lNUWFt?=
 =?utf-8?B?cG5LaHNCNnJyMEVYYWRlTndtOW43blV2SUhMbG5JbCtYbnN3Rkc2K3Zma0dx?=
 =?utf-8?B?UUEzaGViWnJiWTNEdGs3VnpzbHowM05JSWlwd09JTmd4VndNUXpnUjAwcGpm?=
 =?utf-8?B?ZHcycFM3bVpremlGN0hTVWx3SHlSYmhFL3hlT0xLM3prejdXMWJTVlB2RGp3?=
 =?utf-8?B?N0REanFRNGlkSVFLK0l0ZFVoT0piWmJvaVhpRjRNWURVbWN4VWlSRnZncXNu?=
 =?utf-8?B?SkNYaVdVSTVFZ04vQ2lEVXFQcXFOL01TWEZoU0xoaWhYKy9ReDB5eGx0aCtV?=
 =?utf-8?B?cG1lS05WbjB5MmVWaDlZMnBSaGxGcWFFZ2FTUzNuWGZrYmdlbm5HVXIxbnhB?=
 =?utf-8?B?aTVzUG9nSmsyK3ZFeXd3SEdFQ3lrSXZUbHFySFAxZW1pSlJhdlBXNzBtTkVU?=
 =?utf-8?B?VXlBTm1vbGwweXBkRjJBOEt4S0tTa1ZpdmlqemJ3QkFBRTNwSXo0Z3RmaFZM?=
 =?utf-8?B?SHNIbkl6clozbUdwT0dkUm5NNWp6K1dPZTY2bzVkWlB6TmRkREhqNko1eEl5?=
 =?utf-8?B?MzZBYmFVUDhUb0p6R2g4a1dHdmQrM3RHc1A1dkFoYkNqaUg0bkxKdDEyRVg5?=
 =?utf-8?B?aGxKNDc2eXlMZzRNV1lmQzR5cG1iNW5JeU9yNE1EdW0zZzVJMGl6RGRNNHVZ?=
 =?utf-8?B?QWxxOE5wREs0N1ozMGNMaU5HZlkwc3luaDdkN05sR2VDR204d0hKcFFha2I2?=
 =?utf-8?B?cENoSWRLTElDZDd5d3NwUlVLOWRORXE1YjZPdVo5eHQ0RFk5WGpQTmhhcGFk?=
 =?utf-8?B?UFEwa1hzWWRLMmd4V0VtTkF6SlA4ekVMVUNXSVQyS01rR05WbDc1QlFuOWlT?=
 =?utf-8?B?UFJ6NDlHUUM2L3ZPc0VGa2RPaU83VjdhL1dNOUlJSDMwSE02NTJsRnhLNnA1?=
 =?utf-8?B?emdRTnBaNVZiTTJqYUg5eExmSldWNHBzSTdpZWZ1NzE5Yk9qMDJxazY0Mlh2?=
 =?utf-8?B?ZnlRenlIU0lLRXRoMGFqN3dHYTlRclp4aDVoVUpyd1RGQS84cFEvNm5ZZFpo?=
 =?utf-8?B?aklHVFExdDU1cElaVDk4aVFyeXcvUGZnd2VKWmhNNVlnTGRXQnRSREVzN1BL?=
 =?utf-8?B?WlV3TFRxUTdIaml1N1FVTkY5OVNQRERISVl0ekNnbWMrV1JpSlZvWFh0Mmc0?=
 =?utf-8?B?dHlrazZLUjMxN3IvL3MrM2NjbGZkSHBiMUFCaFBPcXVuWDFxTjdpSTB0Z05T?=
 =?utf-8?B?V2U3M1lscjJaMlkvbmpNd29LMzRCcThQMHFnT2t1UDFXVGRqWm5xVE5pMGZ3?=
 =?utf-8?B?VDR0eHljVDN1NXl5azhhSmJKZTMyVC9DeEZCeEQxM3pESVBySlE3dE1XTko4?=
 =?utf-8?B?QjAxMWxGdngyVnA1UXhreVlQcE1qcGZZNW04cXUybWkzS1pCeVd6bFFxeXI5?=
 =?utf-8?B?djFqQ0paUUhJdTkvM0EwRlVYcXFMaEtadlJtUHhrVHZHWDFqU25GWjU5RXFo?=
 =?utf-8?B?YmlPOWpGRnowM1VXMDE2MzdPTHlWSDBHZHhNRGVBVElmV01TM0ZEVVZmb0c3?=
 =?utf-8?Q?+lnudZEL95cMO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTlGYWh3T3BuckxNQm1SQ3hiU25wajZsWFFLRDdIZVM4Qk9SQTlxUzR1enpm?=
 =?utf-8?B?N1Z4REszZUhWK0pmN3NObk54ejRYbVcwMUhuc05JNGd4a2RMcEVsb2VnT2ZE?=
 =?utf-8?B?UjNiNEt5QVk5VUVxdU9FSXVWMkt5cjFRNFRpbi9lZEt5NnBFbFpTYVBBOFJB?=
 =?utf-8?B?SHlPQUNMd3RhYTY4OHdzRDZxdTdhbjhLa0xldytSYzYrdXp6SFF4aEIwVXRH?=
 =?utf-8?B?ZEE2RjFJbUtDYjlKVWk1NlJWaXlRWjNvLzN0SXFzMkczMjJJRzViY3BaT0pH?=
 =?utf-8?B?a2ZwalBPQitIMENjdzJmVXlCSGlBRkQvTGtYSkJYSi92STBUOWNMd1BsU29u?=
 =?utf-8?B?TnB6cmdKa0FaK2I0MHBZRi9pdGxEeDNERUdZNWd1b2NSa1ZMaHJHak52MHht?=
 =?utf-8?B?WWNHeGlqVEpwUEpyMmIzS1daTkpxTEkyS0w4RzNqZTFscTlocGhjeFk5Z2E3?=
 =?utf-8?B?ZXYyTnl3eGdFSmpXN2JkSWZOZkcxc3I3d3hPYStXUGYwb0t1UnhGVXU1ZXd0?=
 =?utf-8?B?dU54MXhqdTNHZi8xOHpRT24yMWJVM1Fmb1htV3I0c201emhSQ3ZiRUlHYXlo?=
 =?utf-8?B?TEFiVjFha3dsZWFhbVNseDZUZCtwZHMxOWRDQW5lVlNvdjY1WmJhajVjdnN2?=
 =?utf-8?B?UlZham4yRXI2cVNrMm5MUlhhMHFjZEVkbTBZL3JzalZmQVFyOHcwQURnYWgv?=
 =?utf-8?B?OWVPZWxPTzBmdC9hVnE0emM5MUNic2g3b1RjV0Z2TjBNUmxFL2ovTlFCWEd2?=
 =?utf-8?B?NWRFdFl3ak5JNkxnYXJqR2V4SEdacFBMYkhuSnNNS2gyblhQTStwRk9JamJP?=
 =?utf-8?B?bWlBQ01FVFQvS0c5eGZSTnoxVXp1WHVZVGJaYWRMVXd0SjZBc1k3dUxBQWtu?=
 =?utf-8?B?YzdFRmdBdGkxdnN4RkVON3pURmRBQ2ZMMVFQZzlqVTFzYXViQ3d0NzQ1WCtk?=
 =?utf-8?B?Yk8wai8wWFBPdU52N2ZpdGNtTEdTK0dQanRLMWxJZGloUHg5bUo2V3lBS25Y?=
 =?utf-8?B?WTNQZnFldWpzOFpyUkxVanlON3Bnc2ZGd2F2T2JZUGpXUGhjSE5mMWZRdFBa?=
 =?utf-8?B?ZDNYdTVzeHh0a0ROSGliU09pWkpxRWd0ZEtsSGlGTUs3K0RSMTE0VCs2SU5s?=
 =?utf-8?B?a1V6TU1LbXpNWkVwWjRXUWl4MjZnV0RUUTZsUTkzcjlWMndsQ3g1cW45dGdW?=
 =?utf-8?B?NmVBaUNuV0JYSzB5TGZsOXhXVkhqdkdyZWg3a0lNcG4vSVlzZXdPN1RxaXBj?=
 =?utf-8?B?cTU5QkEyYThhL0RXWmZwbXF3Tmp5Wi9vZFFqRTdsdXBudWpwVWxFMUZadFdn?=
 =?utf-8?B?SmpXY2JvWXBKbjRrbkZTU3VGUkVwREY5WUlHM0p5bzhkS3Fyd3FNc1ZPUjRt?=
 =?utf-8?B?cmtoZzFFV1dSR1RHcWhaemdKcUdLYjNZSUswS1VVTTc2enBDQzVMa252TW11?=
 =?utf-8?B?aWEyQmNxeGVPa2JuZ2hjNkVuN3RhMmlhWllmb0NIeGlkbGoxRE9LSXNjZjFi?=
 =?utf-8?B?V0l5cE9sNHQ1QlRpakh1NWVUYWtsT2RLU1JpQTdFK0RaOWlqR3hOVkV6Rldv?=
 =?utf-8?B?UlczVGQ4TlJrdURNU21LYytzQWJFS3hwbWtOT3IvVDhWZXl5a0VDYzVVVitW?=
 =?utf-8?B?UHlpUmJ1V3ppSXZIVlJBZ0svSno4S0NYcW9abmczVzluOThyNG5nZUNQb0xE?=
 =?utf-8?B?ZzhjZS9YRFFmWExtUGxkZUlWUjZXVDV6anVNK0N3K3Nsc1lWUkUvblZITEFL?=
 =?utf-8?B?dzB4aVpubHFFeXZRRzR1aklDM3ljN2U5TS8rVWd6TjFwSnIvSmEyd3VLaVp6?=
 =?utf-8?B?M3BQbDZhbU0zR2NFMEZjVTZDYkhWbWNYRFI1Y1djNDEvVnFrakFJd0dRS1dL?=
 =?utf-8?B?TTQ2VVpPMXlIT3Q0RGFlb0ROYmo4cWcvbUU4eTRZMHRvd05idUtERXpnN2gz?=
 =?utf-8?B?dnRheUtqM2VjRHNmamlIQzlQNzRMQXJKb1pTdkVweEFWOHhzMi92bkNQL2dK?=
 =?utf-8?B?YjhJUndLVDU1VzdEL1E1SWZ3OENkR2VuaGNOS3FSakM1V3drUmk4T3FaTm1Q?=
 =?utf-8?B?b0o4aUJaMFJZWmNXMTBVMUY1TzlXcUxQOVBrbUVCWEd1K2l2ZERNUEN6emlU?=
 =?utf-8?B?c0lzZnhEQk5uRUtud1Z6RHNJL0ppU1h1bDFudzN3SVUxd0Vmd2w4cVA0NlY4?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D89KggbyIOHBt4KZyWVNj7GOum2ZI0RPEFA7SogYUaFj2l5oYhBmhbQmEBpYUYp2w/CFZF4zCV/q4MVsNitHdV2miNa7B7b6K2gaXzFzrE08UnjIFdgCPCenxRAvzRbq2r+Kr9ZIJF3VKUkJAysmWBIbxjRETRL64n7CZ2jVFoX3OtFKHL/TnR3mhoHAW5BXMUmVH2EV+EpFw0dM2xTRUrHKJGuc/pNdkrvs/MIcHcGEEXaPvnMlF3n2P0aHfZe0PsRiOijRZTYQ8Dz3tes3nPjyKmhmqBkRHOeut0Nt1UFW8Fp2KNkCi9AWBPcsgo7g3xwm4c/rU0NP+aLl8cT4bP9PZsZRKygw89ziykHPtkERaB4EHJSooGsSVkfXu1A4mV5xJTbDuSrbdUEyvetHvr8Z5hVEe0qjTD9Y9lZGgsiUfeRI8dvFPreuhes9XgeykK45jGTuzObd/tRpvK65b6kKiaD/5HjBosYEkOHkQbe6lSqTOvYUe81P27nvAMMbOFff5WiA0HRfBnZwlMd8vM5HhpuUb5JqYNR0UBHhB3Z6Qp4nR+/fYlNOPV12ik2CQ4rPNeCc5U6qLWt/BXI6PpAVPUVpYF9KkdYEE5H5EpY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785f33d8-9d10-46ff-026f-08dd6cb4a8e1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 22:22:14.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxYV74sz63Tw5TqN0Jscwf4MY8+Fr51AfUJ3YGnG6R0lse8vmcXFXYW9QhzEFVFHzDpMsyCC58YBkR44fsP5Ak8F7OOMtR2lIUMjTJuHWrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260137
X-Proofpoint-GUID: _dyWWn6oRdm9VjZHsTS350FZN_scBedz
X-Proofpoint-ORIG-GUID: _dyWWn6oRdm9VjZHsTS350FZN_scBedz

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> The vhost-scsi completion path may access vq->log_base when vq->log_used is
> already set to false.
> 
>     vhost-thread                       QEMU-thread
> 
> vhost_scsi_complete_cmd_work()
> -> vhost_add_used()
>    -> vhost_add_used_n()
>       if (unlikely(vq->log_used))
>                                       QEMU disables vq->log_used
>                                       via VHOST_SET_VRING_ADDR.
>                                       mutex_lock(&vq->mutex);
>                                       vq->log_used = false now!
>                                       mutex_unlock(&vq->mutex);
> 
> 				      QEMU gfree(vq->log_base)
>         log_used()
>         -> log_write(vq->log_base)
> 
> Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can be
> reclaimed via gfree(). As a result, this causes invalid memory writes to
> QEMU userspace.
> 
> The control queue path has the same issue.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
Reviewed-by: Mike Christie <michael.christie@oracle.com>

