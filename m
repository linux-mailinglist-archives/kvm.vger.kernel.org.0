Return-Path: <kvm+bounces-41328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B44A66352
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A74303B7478
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F773FC3;
	Tue, 18 Mar 2025 00:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J8GWdzyY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Unqynva6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CDF7E1;
	Tue, 18 Mar 2025 00:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742256312; cv=fail; b=p5G9+NEKIdqGl2qqQ7ZfeZptTIZDFXg2ZWPQNNHsMk2QNMfpQlEUeiwDOIcGF6KW5tIyUs18Xyhi7M4+MjRKzGemhLV8I95qheXfj27OJUmi3OvwqeggJuw7s2zuoNeBV6FBKrNZqgEMfL04TBYuUyDKANuwt3QvgAH3uxTLRks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742256312; c=relaxed/simple;
	bh=10Rdoa/I+CXHLbXz/zj1u3OvmqFsMqalmhDRtXXHLpU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K5RjTMeMZl4IUXx1h1l+paXip1pH1pS5nuJ3Vk084gF0IZX3rx6+1vvMHufrbP+hobNwUuueb/8urW7xEkKLdAmaa75ClI3tSNEDC/xDDkYAHOHNwfNTtlfqoSWSIpcLH0faNJFkuJ3Xpj9cmLHvrUzU9liQ2JjR0BATsfEQquA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J8GWdzyY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Unqynva6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuhVL029836;
	Tue, 18 Mar 2025 00:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Vy/XBFz3gO/I0K1ceqrmYV8rK5VCdOqcW5JcJW+uv7Q=; b=
	J8GWdzyYgeq0mbw0L4eiOKr/xLsGAFoBBEukeOwXSEFs0ailmA22JYreBLvax/aI
	G1hRzM/KlW3ZWX6ok5O91q6+8kV+wq2U3luWzPbyVR9znkyPgYrwtsP7A/ETSxfu
	OJe/d6uZft2OBDN6FF3+ScCY1le5ZVddr8+wtRTbePwsSm4fw0mEHKfBfEs+T68/
	bnKnw7BdGsTHy4O1i7Es46afWCut8uUu+RM5MBbPhb5HBb3yLwH/p0EDILGxWnzn
	7B3CtQcHyyZAL5nx6Q/907hdez1zsYvkr2qUJpDTds3TEEp4qrtw1poO0nfh7FP/
	4BHqqCpCRWwdjirBrxQf+g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23rv3c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:05:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HNDGNI022484;
	Tue, 18 Mar 2025 00:05:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeem02q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:05:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnkfTCEpoDIXHDfaan6i5LWJ2VzIUf0F8rAtufHyyJKeMkAf/sX+BvH/HmNoUk/mbigXoRN2z8/kxS9MluwANY6Y/9F3eR6NNh4Dy9827iC0ups2NuxEhXnUo+gy8Gk/woT91lRy1BjqSk98O/4+lFjhgNEwQiwoXMslKM39OAENtWtxKYQSqKJhkFWnyQqR2ekMcmW4egAhGL+aQSLqKaGr8yC8yHkq+IDOFXE9MtjEJk6gNQRgXIz2p2mPbfxD1ko7oPK5yDd7n4bUGlq35ghh2MGcs7BQD6/+2P1sqsPKZFCBtipuepGitUhQsF2+B/VWJNQBAlYByMpPye0fGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy/XBFz3gO/I0K1ceqrmYV8rK5VCdOqcW5JcJW+uv7Q=;
 b=ozlVQUV2W+oHkhr2XarFfYbnjE7bJiK8bX5pXZEPv3wOorY3AIgf38yKDZJqn7ejoqG6KCllzU4r7c+pLMWHVLJLwRWvAT4/WzFRSN2QnBcTfJXx9ylhkA+eOYLiv3c+Y/pC4a3+SLiLYUUameHfRlghz6kDLJn8MdTyEtn89cb1uRZCw7hThVxETfQAWYNtjgwM04kk8u8i7c70BJpXvHYfBQJ3BzBNwiNfq8py3eQretJcMybSdoiS5mqbAea70okUcDJazODqhq8Fq5J1+eo6gc3QpCxcie6/Nwe6oHZOMhK6LnMCunhUtWXacdpi8W+9KhFUMP4fvDTEVOTs7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy/XBFz3gO/I0K1ceqrmYV8rK5VCdOqcW5JcJW+uv7Q=;
 b=Unqynva6E8xdypbFI0VSsQ6HZMocPBi4ZYkHOktr8FFdwJ/Noi7mz1QApUtiXeGPBcbw61fu8NjgEyMDVnaQbbHPgjeFMMgkJHQ7I7kVQkL19wPokZk/RMcXalCqIvM159x/jbsw5DpaDTltgwhT98Qn9XnhGi1Q5MYznRhGQMA=
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27) by PH0PR10MB5593.namprd10.prod.outlook.com
 (2603:10b6:510:f5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 00:05:00 +0000
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b]) by MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b%6]) with mapi id 15.20.8511.031; Tue, 18 Mar 2025
 00:05:00 +0000
Message-ID: <80a47281-d995-4499-a4c8-f251ca309450@oracle.com>
Date: Mon, 17 Mar 2025 17:04:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] vhost-scsi: cache log buffer in I/O queue
 vhost_scsi_cmd
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, michael.christie@oracle.com
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-7-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20250317235546.4546-7-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN8PR12CA0036.namprd12.prod.outlook.com
 (2603:10b6:408:60::49) To MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2079:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: f79b834f-8c52-47dc-a4a9-08dd65b08630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dm9IanVUcy9leE1OK2t0UVFlczAxaFVlZ0NTMkFQVnM0NzJVck4yK09INjJR?=
 =?utf-8?B?WFNqWEZnNDhTd3BYVXg4QTloYzA4NjYyNmE0NUxGWUFYNWNDMTN1Y3Bkai9p?=
 =?utf-8?B?S1U0OHBpZ1AxRi9oeGZySHZUODh2MStUNDV6VFp2UDFORDBmdjExUWhHVGI0?=
 =?utf-8?B?T25pNHZ3dWhaMVorQm5jTlpvUTRyTmhXVVgxUFdqZ3NtYWQrWmdnMmttYWU3?=
 =?utf-8?B?YmpQMGRxeU1LNk5va0Q1WnNTV3ZyUHNTYTVXUnRoOE1DKzR1ZUhtdjZXcFFk?=
 =?utf-8?B?Qk9Ka0JqOEQyU1dBekhOTUJCbWVSQUY2ZndJREZyd05yT3VOWmx1aElWUXZw?=
 =?utf-8?B?Sy8xWlNVY25VLzFtZTBpb2NIVko4ZGNlemFCekdqZGRwRkdiR0JhVkFWY0Vj?=
 =?utf-8?B?akF4NVAxUmFBdWExYmF6YjhlWGNkSHFTcGo3eVZMNXMyZ2pYR0FqVlVqQnVI?=
 =?utf-8?B?UDhsc0hnWU9kOTBhR0xrMHAyZ2ZlYnpEUTN0VU1CTDNHUHJxdFpTVTg4T2RY?=
 =?utf-8?B?dllyOFBhRDlwRlo3Vk9FSitxTVYyaGcvZHVDRExDbUpZL0NpaXltV1pjWFVR?=
 =?utf-8?B?Syt5V01OZGQvdzBkWW02V2phbjJicm9qVUMvakFhNERsT3FOcFRheW12WlBh?=
 =?utf-8?B?MFpvOXZVZ3l2MXRlbm1VZWQzR0VKQStwWDhFUUZsZmRJOEVxamwrTVE4QmVu?=
 =?utf-8?B?ZVdPU3JDRHh2YURhZEtBUnJkdjNrb3NabkpHdWxrNFVTaW4xem9EUng4NDBF?=
 =?utf-8?B?bmRVN21uRjV5Y0hpeCs0OUN1T3AzTDE2R1BGYWpWbDRHUVNNUU1zN0J0SkNH?=
 =?utf-8?B?aVBEZVFGTXBKRUc3SVlPZGxxbG9PVnVZeDgzN0dQbmhYREcwWjRkbzJ6Qzg5?=
 =?utf-8?B?OUlvK1pjYUlVY0VqQm9Kd1BrbVZVdjJkcHI0SklvNGZVYWZLNzV1WEhndkdE?=
 =?utf-8?B?eFgvZUFrUkRkVXptU204cHhMa3JvbjNFdkE3Tm5yT3F1b2FvMnRXcWhUTmlO?=
 =?utf-8?B?L2d0aXVMMzQ3ZXZ1OXlMd2g5cVJTR1M5TEVvTXJrS01Kazh2NjVLN3JWdGxo?=
 =?utf-8?B?Rjg3UWtKYWcwZnI4bG1WK2pKR1hsRGFPeUF3QmVMN0cvVUZDN2x5S1lIR3pk?=
 =?utf-8?B?UjlFQURrV3M3RGI0OHNaNDYrWWw4NW9ZcjBPb1h5MlhibVcxQllrMVczblFa?=
 =?utf-8?B?QkIzTXJwS2pNUGNDNnM5YXUrMmZnT0tJNVgwcGRIMFJxcmJ4WWppTjUrdFRl?=
 =?utf-8?B?ZlZlRWZHYTB4UzN2N2x5UnBWWlV6d3hHR1ozZFQ2ZUhRZ0tZSnl3YytYQUJi?=
 =?utf-8?B?UzBXbkVyVVIrY1h2U3JFTHlWaWluL2s4dVhoZTZCV25jbzAxQWdEcUt4eWhK?=
 =?utf-8?B?WHJ1UlR2VHJ0aXM1WS9kUTZtWWJWbWlkSlE3UEwwRGF4K1lMait2cTY4cVJ3?=
 =?utf-8?B?MmpkVUlxNEZQUzMzdU1LMkpVd0RYOU9VVithakdmenpWemJleVVYZmM2ZEh1?=
 =?utf-8?B?ZzMvTzZNRVpFWDJkZWNUUHFQcStHU3pxN0JqZm9mYTZMM3FrOHRvRDQ0eVhG?=
 =?utf-8?B?cGZMbEdVZXNXa0pXcjBGc3lVZnFSNU1ETkQrRUJVUlZseE96VzJNb1E3ZzZa?=
 =?utf-8?B?K1RRYzJGdzBRdkFuR0kwSFdLcTZEQmhEVU03aEtsT2pvSTFWRmc5RVJDRkIz?=
 =?utf-8?B?bHN4dlMvRnEzdElkRGliKzhKbU5EeDdaTEd4ZS82d0JOR01sRDIzTXVxdzRw?=
 =?utf-8?B?N2gxdXd6ZW5qMGM2RDVIOUpzWGFsVUl4eGpLOTZYalFjSVBrL1pHWkRzMU1y?=
 =?utf-8?B?YkRZaUpqck04a2xxbUtsTjZzUi91bGtpdlU5UWpCQW44QWUrWURJSGY4bVlK?=
 =?utf-8?Q?qDskjjJo6DsE5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2079.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3Q3aVYvNVlhUmhvSUpJUHdLQjMvWS9qTk82V2FwRHlOUkZIVGJ0cDVTOEMy?=
 =?utf-8?B?cTZ6TGRUdzBMZCsrSnQyRkdrc2ZiT3JwRFZtYWNSWVJyZjArK0hmSmVvOFVv?=
 =?utf-8?B?Q21NRVJDS3NqT2R1UkphUzVIVndwS094TDYzdDFFTVd0MVUwYmoyczc3bVRX?=
 =?utf-8?B?YUtWOHcvNE5nWTIwbGZEOFB4ckN5NVVESWNrT2hvL3YvKy9jOE5KT2lnU0pp?=
 =?utf-8?B?bnpSMy9sVW5WcXhMdEFtSG1Ud3QzWGhsdDQyRjQzU2FmaE5XZThVdVBmOU5B?=
 =?utf-8?B?cE1uTFpaMmlSLzI3OGE5VUdyMHEzUFpRajYwTk9PQlpNd2gxc2hIWlg1ZXgw?=
 =?utf-8?B?UFRPMlhyT01nS1VFZkFsZ1Qzb05aRWJKZVV0N29OeFFDeE5iTnVObXV4M1Nh?=
 =?utf-8?B?aTNXK2RlNVJNQTZaQ0N0M1lCZTRjMW5iZEhyRXpBUGE2Q09KV3hWU2NYSXo2?=
 =?utf-8?B?SGxBM05jbnJZTGtyN2pERkY1dWgvSS9hQ0hQbHV1eUZ1ZWJxMFlQVnR4QjAv?=
 =?utf-8?B?TWtCMXBhTjN1Z3VnODBLU0hDU0FmcHFUMXM2NUZRelhRMituQ2lRNVVTN1JX?=
 =?utf-8?B?elZWeHlweVJ3cUZSanhyUHoxTmM0N0tMNnFIZnpJRDBRRXBLbU1FY1Jyb2VE?=
 =?utf-8?B?MUFYN2pSemp0TSs5NWpJOUFvTktKSExhdVVoMVgwT004WFIwUmJuZU1VeUdS?=
 =?utf-8?B?SitFQmZ3RlRzQVVTZFNpN2xoa1FLZlh0bzBmRHhVZXdESmtQc05IRFR0dG5B?=
 =?utf-8?B?Sy93ZFBQYXB4aGUyalhnaXI2ZXhuN3hMbmdQQVBxcHNpbkM2OXZpZFhoSnNE?=
 =?utf-8?B?ZGM0ek1Id1o1OFZidnpxSWdDTzZ2eEdqL01BSEw0aDdkNllDam42UG9iOWlp?=
 =?utf-8?B?V3QxbnhCcGMvNmlyUEJCU2ZFekt5Z3o1bjcxVG1NSmhoVytCY1JPbFdCYjZV?=
 =?utf-8?B?YURqTExQVm9OZzZWbWp3SndkTU1PaEo2aHZ3eU5ub2o2KzVrM1MyNTRGRzVq?=
 =?utf-8?B?dllSazNUZ2h0YzFQQTlnS1UzZnU3UGR1OUQ2OEdzUmlBbTI2cWRmdmNrWFlx?=
 =?utf-8?B?dE5idWFSY2ZtWTJrMkdVSXI1RWZzejdFVXd3TVRHTkNTcFpxTkpNUkJLSlcv?=
 =?utf-8?B?ODJFNXFya0liMkN1ZDBNZWMwayt0UVJQdHQ1T0IvYSs0ZVdhYUhzNkJIaDNC?=
 =?utf-8?B?dncySlNucWhkRjFSVmhWNjZPcTNyUm5Jd29sZGZQV3VSaEVTUm53WVVUbU1i?=
 =?utf-8?B?SEhDUjlyR0JydmMxR0JlNUZveHk5blV1YTN3Zk9xYkpMM2FLOWNwVVJlU1Fr?=
 =?utf-8?B?MStUMmgrQWV2RmtFeU8rcXVOMHAwSjc3V3dYM01hNDNWeENyWGJqKzRHWk9n?=
 =?utf-8?B?UUNMWXBIMW9PaDcwNXIrMkhTcGlqUUdLckhmelk2UWdMZ01kV2FlZHI1ZzJh?=
 =?utf-8?B?QXEwdmpLcTUvc0Uxc2ZEcFBqanhXUk5FZ2ZRNkJvNWlreVBjNHdVcXZ2d0hY?=
 =?utf-8?B?NURPS3pBUjBDSjREVXZpTVV1b1Noa2xidTZGYkZGbGQ1UU85Zk9uc0g5RXE3?=
 =?utf-8?B?NGlFYTcwVGFGSVg3UGNuK2cvNElSS28xb3NxTDlhUElEVWE3MFNZQTBuZ2xE?=
 =?utf-8?B?RXZRbXdiTmVxMXhXWDF4R3lOTnFUMDJmeDE5OUQ1VEdzVGkyWkxtUGVieG1z?=
 =?utf-8?B?MmRaRFNMTjdyd1N6NkFscDVYTUtKTVRPTUdnakRIZmhjeGZ2T3FudkdzZ1R4?=
 =?utf-8?B?dERqRmxnbmkydjZERG5wVzZ2cVpzMlZMRHFoRFpYN00zb1YyekV0bmFnRDli?=
 =?utf-8?B?by9WUnM5Tk41SUViZFdBYnQ4NEJKa0NTTlBzOGVMb3NPUm56VFQ5TXRIeHBB?=
 =?utf-8?B?RERFNGI5OGJoTW0wSVZUV0lWZlpPZndHeWJrUjdDaFlOUFpPL3Z2Qmh5bTFp?=
 =?utf-8?B?Qmo3azd2blR4cmNWZ3ltVVg0TlVZZi9LMVB3V25ZaHU2a2xmREVqOFNJNGlB?=
 =?utf-8?B?RlIwWnhFb3BNRnh0THIzYWJOc2xpQS9QYUl3TFdXSGVHeXJMUDdVeU9qTkdX?=
 =?utf-8?B?Vk9LYm8rNFppeVJxS3NmSThBcjFiMURwa1M4d0cxSW1ya2ZDZEluNDZvYnYv?=
 =?utf-8?B?UkZGcGpGdW5aMURxZTZHbnFPUS9HVW1aR3p4VWlwczJXb25GUUxOTzEwVzhp?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KCrkn4b4NeSiuDgRfyW/j28nusdq7Xw02n0IGfpga8tPQJobTniyH7OjNRlkKQ0jmBqVBfpX4c/smkB2c0uwLVPdg1OjmQt9bjenk0o8MCYCa2n0ZCI2HSy8JXQ5Ee1jXsqJ+J3SnRefeHeJiMxcaQz/hP4WNV/S6twSyjb+bzTYmAF97QH72OSASAg0bVSI0BZggS6jOMEC7djj7f9pQvJT5C2c3DUC2klwZ7XEUNWiakuooBiblgIAA6k9VXP/Qm+0dcZ3UeJaoEFz6bakxGbaxvgR6cRER8H92INt65gxNFH14e1BgY422s1jOaltshGTNcb15eZ7PrDVmTT4nkuN5MxmINWYW3rqnJ2olz9u4IKIGzVcA2Arfmns8bXWKyPA1bWeG2A7S7pp4wVHVsVhXgZKluZis0BmQePquhhKTkeNRTesKMQCfb2Nkslxsp4makW4OWJEGfT1VXqZLgcbdhOiDEvv2nQgz3MKcCIsKKvX26EXEEuQQun5wPzLntO8eYm9GabaComsViTsvd1R+Q7flBPBF0mnUalp3HQe9hmKAnxtowUL4ZEvroWx2OIZkGKJpru7pRU1pXktwAvJLAz6bBsKejCoRNI0D6A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79b834f-8c52-47dc-a4a9-08dd65b08630
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2079.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 00:05:00.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kNGG6eh7zP0zs1Vd4lVhDj5fuKl0ZwxfCf7ebGhqsPEFbwi5qcuuj2lAr/F8NRs+zJIPa63IBxZdnz8qglXLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170175
X-Proofpoint-GUID: -h6RdIpJqi_7N2cLaCP4l_aEn2H_-Sle
X-Proofpoint-ORIG-GUID: -h6RdIpJqi_7N2cLaCP4l_aEn2H_-Sle

Hi Mike,

On 3/17/25 4:55 PM, Dongli Zhang wrote:
> The vhost-scsi I/O queue uses vhost_scsi_cmd. Allocate the log buffer
> during vhost_scsi_cmd allocation or when VHOST_F_LOG_ALL is set. Free the
> log buffer when vhost_scsi_cmd is reclaimed or when VHOST_F_LOG_ALL is
> removed.
> 
> Fail vhost_scsi_set_endpoint or vhost_scsi_set_features() on allocation
> failure.
> 
> The cached log buffer will be uses in upcoming patches to log write
> descriptors for the I/O queue. The core idea is to cache the log in the
> per-command log buffer in the submission path, and use them to log write
> descriptors in the completion path.
> 
> As a reminder, currently QEMU's vhost-scsi VHOST_SET_FEATURES handler
> doesn't process the failure gracefully. Instead, it crashes immediately on
> failure from VHOST_SET_FEATURES.
> 

We have discussed the allocation of log buffer at:

https://lore.kernel.org/all/b058d4c6-f8cf-456b-aa60-8a8ccedb277e@oracle.com/

This patchset allocate and free log buffer during
VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT.

Unfortunately, QEMU's VHOST_SET_FEATURES handler may crash QEMU if there is
error from VHOST_SET_FEATURES (i.e. -ENOMEM).

From user's perspective, it is better to never start VHOST_F_LOG_ALL if
memory isn't enough. However, that requires change at QEMU side.


I have another implementation by combining PATCH 06 and PATCH 07 in this
patchset.

The core idea is to allocate only once for each cmd. In addition, don't
free log buffer unless VHOST_F_LOG_ALL is removed, or during
VHOST_SCSI_SET_ENDPOINT when all commands are destroyed.

It returns SAM_STAT_TASK_SET_FULL to guest when allocation is failed.

-------------------------------

[PATCH v2 6/9] vhost-scsi: log I/O queue write descriptors

Log write descriptors for the I/O queue, leveraging vhost_scsi_get_desc()
and vhost_get_vq_desc() to retrieve the array of write descriptors to
obtain the log buffer.

In addition, introduce a vhost-scsi specific function to log vring
descriptors. In this function, the 'partial' argument is set to false, and
the 'len' argument is set to 0, because vhost-scsi always logs all pages
shared by a vring descriptor. Add WARN_ON_ONCE() since vhost-scsi doesn't
support VIRTIO_F_ACCESS_PLATFORM.

The per-cmd log buffer is allocated on demand in the submission path after
VHOST_F_LOG_ALL is set. Return -ENOMEM on allocation failure, in order to
send SAM_STAT_TASK_SET_FULL to the guest.

It isn't reclaimed in the completion path. Instead, it is reclaimed when
VHOST_F_LOG_ALL is removed, or during VHOST_SCSI_SET_ENDPOINT when all
commands are destroyed.

Store the log buffer during the submission path and log it in the
completion path. Logging is also required in the error handling path of the
submission process.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Don't allocate log buffer during initialization. Allocate only once for
    each command. Don't free until not used any longer.
  - Re-order if staments in vhost_scsi_log_write().
  - Log after vhost_scsi_send_status() as well.

 drivers/vhost/scsi.c | 108 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3875967dee36..6ae4d7de9a5f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -133,6 +133,11 @@ struct vhost_scsi_cmd {
 	struct se_cmd tvc_se_cmd;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
+	/*
+	 * Dirty write descriptors of this command.
+	 */
+	struct vhost_log *tvc_log;
+	unsigned int tvc_log_num;
 	/* Completed commands list, serviced from vhost worker thread */
 	struct llist_node tvc_completion_list;
 	/* Used to track inflight cmd */
@@ -362,6 +367,24 @@ static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
 	return tpg->tv_fabric_prot_type;
 }

+static void vhost_scsi_log_write(struct vhost_virtqueue *vq,
+				 struct vhost_log *log,
+				 unsigned int log_num)
+{
+	if (likely(!vhost_has_feature(vq, VHOST_F_LOG_ALL)))
+		return;
+
+	if (likely(!log_num || !log))
+		return;
+
+	/*
+	 * vhost-scsi doesn't support VIRTIO_F_ACCESS_PLATFORM.
+	 * No requirement for vq->iotlb case.
+	 */
+	WARN_ON_ONCE(unlikely(vq->iotlb));
+	vhost_log_write(vq, log, log_num, 0, false, NULL, 0);
+}
+
 static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
@@ -660,6 +683,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");

+		vhost_scsi_log_write(cmd->tvc_vq, cmd->tvc_log,
+				     cmd->tvc_log_num);
+
 		vhost_scsi_release_cmd_res(se_cmd);
 	}

@@ -676,6 +702,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct scatterlist *sgl, *prot_sgl;
+	struct vhost_log *log;
 	int tag;

 	tag = sbitmap_get(&svq->scsi_tags);
@@ -687,9 +714,11 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 	cmd = &svq->scsi_cmds[tag];
 	sgl = cmd->sgl;
 	prot_sgl = cmd->prot_sgl;
+	log = cmd->tvc_log;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sgl = sgl;
 	cmd->prot_sgl = prot_sgl;
+	cmd->tvc_log = log;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->inflight = vhost_scsi_get_inflight(vq);

@@ -1225,6 +1254,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
 	u8 *cdb;
+	struct vhost_log *vq_log;
+	unsigned int log_num;

 	mutex_lock(&vq->mutex);
 	/*
@@ -1240,8 +1271,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)

 	vhost_disable_notify(&vs->dev, vq);

+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;

@@ -1390,6 +1424,24 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			goto err;
 		}

+		if (unlikely(vq_log && log_num)) {
+			if (!cmd->tvc_log)
+				cmd->tvc_log = kmalloc_array(vq->dev->iov_limit,
+							     sizeof(*cmd->tvc_log),
+							     GFP_KERNEL);
+
+			if (likely(cmd->tvc_log)) {
+				memcpy(cmd->tvc_log, vq->log,
+				       sizeof(*cmd->tvc_log) * log_num);
+				cmd->tvc_log_num = log_num;
+			} else {
+				ret = -ENOMEM;
+				vq_err(vq, "Failed to alloc tvc_log\n");
+				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
+				goto err;
+			}
+		}
+
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cdb[0], lun);
 		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
@@ -1425,11 +1477,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		if (ret == -ENXIO)
 			break;
-		else if (ret == -EIO)
+		else if (ret == -EIO) {
 			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
-		else if (ret == -ENOMEM)
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		} else if (ret == -ENOMEM) {
 			vhost_scsi_send_status(vs, vq, &vc,
 					       SAM_STAT_TASK_SET_FULL);
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
@@ -1760,6 +1815,24 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		wait_for_completion(&vs->old_inflight[i]->comp);
 }

+static void vhost_scsi_destroy_vq_log(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (!svq->scsi_cmds)
+		return;
+
+	for (i = 0; i < svq->max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+		kfree(tv_cmd->tvc_log);
+		tv_cmd->tvc_log = NULL;
+		tv_cmd->tvc_log_num = 0;
+	}
+}
+
 static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
@@ -1779,6 +1852,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)

 	sbitmap_free(&svq->scsi_tags);
 	kfree(svq->upages);
+	vhost_scsi_destroy_vq_log(vq);
 	kfree(svq->scsi_cmds);
 	svq->scsi_cmds = NULL;
 }
@@ -2088,6 +2162,7 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	struct vhost_virtqueue *vq;
+	bool is_log, was_log;
 	int i;

 	if (features & ~VHOST_SCSI_FEATURES)
@@ -2100,12 +2175,39 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 		return -EFAULT;
 	}

+	if (!vs->dev.nvqs)
+		goto out;
+
+	is_log = features & (1 << VHOST_F_LOG_ALL);
+	/*
+	 * All VQs should have same feature.
+	 */
+	was_log = vhost_has_feature(&vs->vqs[0].vq, VHOST_F_LOG_ALL);
+
 	for (i = 0; i < vs->dev.nvqs; i++) {
 		vq = &vs->vqs[i].vq;
 		mutex_lock(&vq->mutex);
 		vq->acked_features = features;
 		mutex_unlock(&vq->mutex);
 	}
+
+	/*
+	 * If VHOST_F_LOG_ALL is removed, free tvc_log after
+	 * vq->acked_features is committed.
+	 */
+	if (!is_log && was_log) {
+		for (i = VHOST_SCSI_VQ_IO; i < vs->dev.nvqs; i++) {
+			if (!vs->vqs[i].scsi_cmds)
+				continue;
+
+			vq = &vs->vqs[i].vq;
+			mutex_lock(&vq->mutex);
+			vhost_scsi_destroy_vq_log(vq);
+			mutex_unlock(&vq->mutex);
+		}
+	}
+
+out:
 	mutex_unlock(&vs->dev.mutex);
 	return 0;
 }
-- 
2.39.3

-------------------------------



Thank you very much!

Dongli Zhang

