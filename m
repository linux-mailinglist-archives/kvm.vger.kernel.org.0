Return-Path: <kvm+bounces-41500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7A8A6952D
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D8413BFF59
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 16:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F831E0DF5;
	Wed, 19 Mar 2025 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UlxlPSd4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C40nnx2n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60190170A11;
	Wed, 19 Mar 2025 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742402313; cv=fail; b=smL9hRaEoWInw/drumN+U8fpjNXxuyEmldLMBU/dX3g9+LHDJS/D9POw1xB/BEHsNVSmFRIivO+5+92nCrZ+OJi0X6NGJlSSvcuTYQRQNLbLulLY+wp0ePExrznteNv2NEF6zZFgIIIGMDHQv9akVsYR3ncraqU8cf/wICbPUTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742402313; c=relaxed/simple;
	bh=1lEJhpuItdXZGMldiihGJ8NQx2WFje0AqwxETgOqvFw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K1nhJCL/ISOLtA3s2Se5CwQb6rSDv70+g/BTaQryaBhtsFUefgyE4jAe+It7Yq8qlvxdhkRCbq3rHiQ/7dU2+/01hczYzx/F2/1G1VWi/a/BdN8MpdlSh3faioNXRF9ngOVIZn2MTvuA8DKAhaXyCRGTyM59QtzMeAQauRt6/DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UlxlPSd4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C40nnx2n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52JGBmGc030843;
	Wed, 19 Mar 2025 16:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8zwjbmUnakMjqoXxDlQeaSVYzbRJsOmCCaCuOl4pqos=; b=
	UlxlPSd4V8zMy66Fd9oHN7JrXLcBt8NGHV+rm3HBsBK9OMAAavD1sDnvZEPMRqlw
	dw3zg8hTar3giXb0YbR9YFUvMwdrQAiWs/WvEILeQcBJdxHawVMgCVJy7dJnSAv4
	KstVf7O/S+KhCqglcFwh4jaAdbvE2rtgCixUzv82iNcCCNeH42bu71/xx5G4rzrF
	G7H7UkugexNCW0U76Aukd8V4jQvw91YJ87+cpUGZyprlojAfnH6jsj2EVPsFUm8m
	NqcYlESQGGEpYM7kEW93SfTiq9UlFL0NdE3tFsmqO63/+/szjVGVIqfJb7Wqh2Nc
	7LOrPVSeye899pGA/G0Tnw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8uxnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 16:38:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52JG30M0024466;
	Wed, 19 Mar 2025 16:38:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbk5xpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 16:38:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cWLpENIcL8T0L7eTv3BdmqzK6zGGuWU2nmO72VxeYcjeu3do7USjYqY0e7F9QeLp+IvvUgHuD6Ae/uc1Ou8fpHnT/5smrCUIt+9KTB4bQYp0OZU8qV5GAV7VrNJLDJNGfbpMv5OHBxutv/NbCVDz+u8/zpdZ9MCHA789XT2qPHANGMsoTtwtYxT/ZPulFJgXyThUDAaXf8ol2Xf7sradL/rCq1NTfNnHmBIpsI64YdrKbtw4TnbRRmZg3sIh1ak815VTNEjdDZuEw+QkfHID7o+uTCPXYcCGCAuvWKxGHjx/tDZ8j2kMIAKnVIh6mkJSICt0gTxI8Qk0gl8adXv9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zwjbmUnakMjqoXxDlQeaSVYzbRJsOmCCaCuOl4pqos=;
 b=Uz4WA6sTZKQGPR2vTmjzZ9tYIbj/XYDeLGsPN3EAdYK9dl043g80tfkLpDvfdtC2mPa2JIPf/8+GFIdvcGPmpTTjk7i3M2iq5Gm5+Nm6tMflSU44WkANz/N/+cRj6yEKRHE16LR8oOlnWdzIhTPC/TK1/oc6iEmNlNf3sVg0D16YFrSvW4xtzFU5TXRlwin5Kzhue/vFL7rrmxxriKi9ZHDylZqCblCzgbFXjDNi4nWK3vMMiFv+wfSsxgSXl6nWE1zQBplCvgG+/t9vktGp++1WoJlSkdXsS+iHnq5CK/koT1NYkzuFZjKO7l6HuAWFrNQXFjdHP9rg+Z3fwY9QCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zwjbmUnakMjqoXxDlQeaSVYzbRJsOmCCaCuOl4pqos=;
 b=C40nnx2ni9i9YWxsXx2c0zqtvnqokn/FUIM5eggg3nPuYdkFnYvSotYLLzpSWYep0LftzOF9fY6Kc7U5BzbsXUd1JkfaODpSqy3oRY0Jc1MeYs3FAOoX7ytSxNR0O8vMC7evayItWOi8MHIEFcc9CGw0LtngJm7sde1vWQV6PNE=
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27) by CH3PR10MB7713.namprd10.prod.outlook.com
 (2603:10b6:610:1bc::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 16:38:21 +0000
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b]) by MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b%6]) with mapi id 15.20.8511.031; Wed, 19 Mar 2025
 16:38:21 +0000
Message-ID: <93797957-b23c-4861-a755-28bfc506051f@oracle.com>
Date: Wed, 19 Mar 2025 09:38:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] vhost: modify vhost_log_write() for broader
 users
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-5-dongli.zhang@oracle.com>
 <CACGkMEtOsQg68O+Nqo9ycLSq7sN4AMZ92ZvLLMEF7xYDCA5Ycw@mail.gmail.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <CACGkMEtOsQg68O+Nqo9ycLSq7sN4AMZ92ZvLLMEF7xYDCA5Ycw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0877.namprd03.prod.outlook.com
 (2603:10b6:408:13c::12) To MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2079:EE_|CH3PR10MB7713:EE_
X-MS-Office365-Filtering-Correlation-Id: 316c9641-4b41-47e8-74e3-08dd670475fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXQxMGRablpsMmFsaUdKZ1hUaDhPeUlUSDF4YjdTeDFyOEFsVTNIWG1xVXZo?=
 =?utf-8?B?blZiSmRuLzAzU3h0V2V3eEVXckU0ZjBHekMyYnB1N2p4NEtqMVdjeHdPNFZw?=
 =?utf-8?B?aG5GQzZ6QkxTakc2bStxMG9KSFlBTG5mUGhSYVlVTGt0OWJBakdqc2FHUlJQ?=
 =?utf-8?B?aDk2aTAzVW95NXRaWUxQTU1CQzZNQkJtenJRNEgxNU1qU04ydkdPZUdLc2pV?=
 =?utf-8?B?eUttMEtyU3RMMEhxa3dKL0JHcU5NY0U3bVRmaERRUXZKYWJoUVBEUGo4Vmhq?=
 =?utf-8?B?dmxBcmhYeFVYTTJxNVlEc2IrdmJzclpMNG9YVnFzdU5BSVQ1dnlMT0plckFS?=
 =?utf-8?B?bW9HYXRWVVJ0YlorTWdWaVE2dmlObnlNMmtrUDI0WnExa0lJSThFbEV6U1p3?=
 =?utf-8?B?RjJ1TlRyRXpYOHQ0UmdTV3IyR0FoUXE0WnNsc3ArS05sYTg2b0w1MXhudjVs?=
 =?utf-8?B?UXJWQkg5T1lZVjJ0ODlNVDUzQUdVMkF2d0d1RStlUi9KR3J0RzVWWjhjcjN4?=
 =?utf-8?B?NThiNzlmd0MralVyeEtYRDZid0lnOEJwRWNzOGhlQmhOU0N3RktSSmVOMVNl?=
 =?utf-8?B?STNlNE1hMDk3L1F1N3ZmMGY4YVo2R0k4UHNCWHV5bUlrVy9DcDdEejNsaDVh?=
 =?utf-8?B?bVVsa1BKdXZmVmg2Y3MxdG1Yd082Y1hHalhXVG55YWdkZlJxd3VEd0FzQkM3?=
 =?utf-8?B?R1FZSU5QU3Bjam95SFR3UXhxWlpFWDh2dFNXUU03OHBGY3c5c1lSM3lZbFdV?=
 =?utf-8?B?OWpWNUNidityRStYUnl6Ky9HUEt3aVVmVzZSTnJZa3IvUTBqWHo1NDhnNitR?=
 =?utf-8?B?OTJsa3duUU5RNUVyMCtrckJReFpDSmpxUkZJMkI1Vnc0R2lNSWtvNnpQcEkr?=
 =?utf-8?B?dFB2bThyWTJmaGgxSXhsYVlVb2czN0FzYitOc2JycE9jM0ZvelNWMXVjdTMr?=
 =?utf-8?B?RVFEVEZQcWNtOXRDVms4NUdVUHByWmVWRXR4QzJMcUR6a051ZGFORjRpSU5t?=
 =?utf-8?B?bENUYnlwNFNyK2crcGkzVklmZUR6eWJnMW9HQVhaVVhIWTFYTCtVZTMwUEJS?=
 =?utf-8?B?N042ZGxtMXFobHdKMk1raWtZSDBRcVpUT2cwa1RuQXB0dGVvMndpOE1kMFo4?=
 =?utf-8?B?MlM1QXlHNGk0Zlg3Mm1sZEFlZFdyOEZpLzR5OEFEV050UFdDV2xmSm9Hc0o1?=
 =?utf-8?B?ODR2WWZHd1Z1TnpXZzRsSkNyZG53d2lFeUU4a09xMVFvMnpGZHF0Y29HWVN3?=
 =?utf-8?B?b0pRcEtxUC84ejVxcDVjRm1ubXlIN0tnWDZQQ3RYUE1aKzdGQU15N0FUNFNa?=
 =?utf-8?B?aHJFdnRqR3A2QzJLZU50VjNZWU5jUFFHUXpVb2g5MHRzWDdhSHhkWDk2WXNL?=
 =?utf-8?B?NFIveHNnNUJ0NGJnMFV2MHV6UEhXMnFmMDF5U0c2Nno5NFIvWGJGc294aUNk?=
 =?utf-8?B?Q0JzRmNqSGRWOW1UTEl0aG1aak5NRjh1QTh3UmxFbFMrQnVtdkJ3SmZTcnln?=
 =?utf-8?B?dVc4L3ByOXdXNHd6RC9ULzlkcHZoYXgrNlJFTWo3SHBFYnJFOW9mVXFXYmx3?=
 =?utf-8?B?MUNEdTQxY0liQWIybWNxV2krRXBEb1dtYlhxMEtyVUtYNUZMOW4xcjJYRWcw?=
 =?utf-8?B?K2VmVWNPSUVsb01LSUZwNUhKR09vOWpWMm9aYXZlSzZXaEdlNEszdnR6UmFP?=
 =?utf-8?B?T3o0VTk4U0hCUEJ0eW5kQ3hRcjdjYXlKMmhIVjVaRWNDRjRGeFF3OU9IU1pi?=
 =?utf-8?B?SGJEaEZnWjFIVUtRaStwMmwxZ2dSYkYxV09lSmhnQ3hyd2RjNk9ZNTRlMnBk?=
 =?utf-8?B?SXkwQ0M5SXI0Zit3Mk1vcTUyamV2S1VaejdpRkZnYlpLUkpNOGgvR1phOEVm?=
 =?utf-8?Q?t052ALMSpzgdj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2079.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTNaUEVFQjM0dVFydHFyZVVNdU9RcTZnT3NZNzV1ZkZVUXhvOTlFWlRqOWVm?=
 =?utf-8?B?T3ZoblFxRTFyOWpoemVKek1QRVNncEFuQWxnMDZZMktRL25Rb2NBaHlPa1po?=
 =?utf-8?B?OHlJL20wMllsWGVuYlZueXhNeEVkZE9DTlRCM1FmaVo5bS93d2pqbU05WnE2?=
 =?utf-8?B?UkoxVjhmUG9TSHhjUngvUnBqd0tUbnNqb2sybjhhNkFZYVVReVlVVlBwQ1pR?=
 =?utf-8?B?MDlweWZSeVdQTnRTRENvWnFIbDZBMkpEMWFBTGdzSmVJOWI4b0pFSjd6YUkv?=
 =?utf-8?B?eUp2YXNJNSs4cEZtT2d5L1R3cUtHSWtrTDdCVTFkNTRXOW1TRDhzd3NZR2Vv?=
 =?utf-8?B?MFUza3Bob2UwYTJnMmVYZkY5NzJIZVJ3bXdGSGJDbEl2Y3BCeXB2NVF4Tmcr?=
 =?utf-8?B?M0s5NVMvOGdMdWljVm40aXE2a2ZQejlHZ2g2bldXYmk1NTVBSWhkYkFlV1JO?=
 =?utf-8?B?K2d3V0E4L2ZQSmZCR1RBTHR0WGNpZ2JGTHJ2VkJva1V0dVEyWDZsRHVmWWox?=
 =?utf-8?B?UEFVaWJrZjEwZFlIbkVBa09RdnlUYXFVQy8wNnpWU2pvNHZJQUdDaVZVYXVC?=
 =?utf-8?B?VTZ5OGxDd3NBTXJlR1g1bVRXMjhWanUwenBSS1lJM1FNemZUSWM1ZE80YlNQ?=
 =?utf-8?B?bVJZa2VFWUZNek9Db3JLS2tLSUpGUnF2UkxlTVBPWjA1QjNFT3ArV1E2RHlq?=
 =?utf-8?B?bXB2SHI5QnBYTG9ITHZhVXFTVEE2OUFZYkpUckIvQjNYODlXM0tYRTNTU0Nk?=
 =?utf-8?B?dHZuTFNzbTUwcEUxdG9QMkFKSEZlN1k2ekdEZ2lZbitKakVwTHlLQ0kvMVVP?=
 =?utf-8?B?NXY4aGJnR3JPQ21malI5bnlmQlRmZ1U0dFBVS285TTZlUjVLMXB4T083Nnpz?=
 =?utf-8?B?Vk1nV0dzTXhrVjFvRzhCb0ZaZ3BySnhod1M0WHlkUUdiOUpnN3ZhMVAwSDBz?=
 =?utf-8?B?UVBraGtRMWpCci9YdUM1bTdJUm5pRFc3SmYzUzkxanVrUSsyb3dLVUtUVW43?=
 =?utf-8?B?NHRHWjhjdFZkYzFxMHlITWtaODl5YzRuSDV6MWpVbHVVeSs1QUc4QzI5cWhF?=
 =?utf-8?B?K2REaUk3MG1POWh0L3pnVmJVOFlBalNCT1c2TDJxR0k0L1QycnhaRjRrR291?=
 =?utf-8?B?Q3g5L0N2b1VRcktJdzRDbit1WnFkd0RrenlLMXJxVWxYUkNVN1FnVVlBZVF5?=
 =?utf-8?B?UnhrbXNjd0NKVDk5NjBTYU1zRm1PQlpya1RZMW9iNHpFdCtBSCtGdTQyaVFj?=
 =?utf-8?B?VGJSMEVCbDMxMDQyajJyMnpnVElXSXIzY3o1K1NYSG9oN2twRWpWR2NtQWRX?=
 =?utf-8?B?dW5BME1xLzVEQ1VJVHFnbGMyTlk0WmhwTStZNVhtcWorSWNtbm1Vd1JiU3By?=
 =?utf-8?B?RmhxWllFSGw3M0dNRVVOencxVnVHYW4yK1owZmRrcmtPZzFSL0ZwUk91WjJa?=
 =?utf-8?B?bFVRQzQ3RFhPaDRiWlNSeGo5WVp5WWhwWlRlZ1lrT2FkbXVEbzBySWUrUlhN?=
 =?utf-8?B?RDNDQ0FPWWFQVDR0Y05NVzdiOWdmYysra0Vya3ZPNU9tTWc0R0VudDJkZDRU?=
 =?utf-8?B?TTJSNm4zZUFSSW1waXBjLzJCRnN6aEM1eTN0SlZVeGt1Um8wdjBNOTVhUkRS?=
 =?utf-8?B?enY3Z0lzNVE3ZVc4blpLWW1salRiV1JHK09sRkpVYU1OU0FKMktNT2pHT2d2?=
 =?utf-8?B?dllrOE5kQzhEdmtodzFEV1FDQTNqdGo2L2UrTmdzTFgwOTlSR1Q1cGUwMmZ4?=
 =?utf-8?B?d2JtenZMV1dqWmI1dTRGSEQ3NmtFL2dFQlFpcFdLTzFwL0F1d0dzYWNjK0NZ?=
 =?utf-8?B?Y2RTOTJjeldyYXJJWFRoV0Zkb1NHQXQ1MkNGRTZQaUV6REM2TkpqK0NyRzUz?=
 =?utf-8?B?WXQvNFVyQllkVmd1ZGVuK280am0zQlRGVW5zWkFOcEZORTNiVStBam8vRXFj?=
 =?utf-8?B?MFRENGdqbjJ0LzRmOTNNWDRqWDR6L08vZ1RXRHJtZ3J1NWdieng3Q09TZnVm?=
 =?utf-8?B?eEYxUHFMZ3RoRkRiaHcxN3llWnpVbmR3WU84S1R2T0RYaGhpU25HbUd0RkFl?=
 =?utf-8?B?blRBZjRUellLNm5SOHhjSWJtMEppRkMrMVhtc1dBWCs5UlE3SVVyc2FjWkE5?=
 =?utf-8?B?cTBwMEVFOVlmV3gxT3pqdS80SjQ3SXBtR09XcG53WW4yU0FtY3M5K1BncGY3?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	viRFLLsTc5NykRaCqL0jkMUjI1uu8FnaQeUcYauVnmI9nWkHna34ZcfrU8DKw2J/y3vMNZ8oDXCyDokWpjZW48pX/xU7mlq+dv/fSyVVK/nBMrhdZwG553rxfoMY01SNfZKVIa8pXR+A6yxmYxXSiXhEUCIrdl0sf3p6aJzqHvZH0KqL8BH+9qTDkBrsMn4Csz2Tt3m7sa6eSsKfbh9oP1IAQzmYgEqcyDB7v8wp5mWe34DCpvGzrYVC3NZ5cIKPCY3C37yj3UVaBYN7+xjt/WbI2F+xhmpkaGHUlRgLCrDu8qlypa2jAtd2nL3PBtWpLsKmT144IMLM4jBX0Clok+uvQVJfynt1g4jG4Zn2RbwwNJTZkoB8V1wUB6OQZOeHOnaDgNPxaQ2z+cksVl3pWx1uHRVkBOd/8OUwvFi27OAxCzVgF7MRxSeMRl3tDcXKpSCLyi0jw5YE4he7BadguGmlfzW0LLSourOgj824xm+/1blMk6oZxEEw4rpU/3JeYg2YQc+a8ZiwhQWu+afeK58F2UV/uv/1rFHidEp42HAgflrx42wpzZufbSIVp8h3cU0TvefdmK0CtSrQUuSc0FwO28jI1jPCMm8nK+/nJa0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316c9641-4b41-47e8-74e3-08dd670475fd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2079.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 16:38:21.5847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phvWPegGXT8AdfMrnDJ0UdTNCTwXr85URYYyvOOyTFd1qhWl10w5lFAQ36z1SYk542MTJYwCaYEJWiy+45/1uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_06,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503190112
X-Proofpoint-ORIG-GUID: nNtz54NM1dhPcA-HIZ9oqTcqnWivrcAk
X-Proofpoint-GUID: nNtz54NM1dhPcA-HIZ9oqTcqnWivrcAk

Hi Jason,

On 3/17/25 6:12 PM, Jason Wang wrote:
> On Tue, Mar 18, 2025 at 7:51 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> Currently, the only user of vhost_log_write() is vhost-net. The 'len'
>> argument prevents logging of pages that are not tainted by the RX path.
>>
>> Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
>> vhost_log_write(). So far vhost-net RX path may only partially use pages
>> shared by the last vring descriptor. Unlike vhost-net, vhost-scsi always
>> logs all pages shared via vring descriptors. To accommodate this, a new
>> argument 'partial' is introduced. This argument works alongside 'len' to
>> indicate whether the driver should log all pages of a vring descriptor, or
>> only pages that are tainted by the driver.
>>
>> In addition, removes BUG().
>>
>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  drivers/vhost/net.c   |  2 +-
>>  drivers/vhost/vhost.c | 28 +++++++++++++++++-----------
>>  drivers/vhost/vhost.h |  2 +-
>>  3 files changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index b9b9e9d40951..0e5d82bfde76 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -1219,7 +1219,7 @@ static void handle_rx(struct vhost_net *net)
>>                 if (nvq->done_idx > VHOST_NET_BATCH)
>>                         vhost_net_signal_used(nvq);
>>                 if (unlikely(vq_log))
>> -                       vhost_log_write(vq, vq_log, log, vhost_len,
>> +                       vhost_log_write(vq, vq_log, log, vhost_len, true,
>>                                         vq->iov, in);
>>                 total_len += vhost_len;
>>         } while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 9ac25d08f473..db3b30aba940 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2304,8 +2304,14 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
>>         return 0;
>>  }
>>
>> -int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>> -                   unsigned int log_num, u64 len, struct iovec *iov, int count)
>> +/*
>> + * 'len' is used only when 'partial' is true, to indicate whether the
>> + * entire length of each descriptor is logged.
>> + */
> 
> While at it, let's document all the parameters here.

Sure.

> 
>> +int vhost_log_write(struct vhost_virtqueue *vq,
>> +                   struct vhost_log *log, unsigned int log_num,
>> +                   u64 len, bool partial,
>> +                   struct iovec *iov, int count)
>>  {
>>         int i, r;
>>
>> @@ -2323,19 +2329,19 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>>         }
>>
>>         for (i = 0; i < log_num; ++i) {
>> -               u64 l = min(log[i].len, len);
>> +               u64 l = partial ? min(log[i].len, len) : log[i].len;
>> +
>>                 r = log_write(vq->log_base, log[i].addr, l);
>>                 if (r < 0)
>>                         return r;
>> -               len -= l;
>> -               if (!len) {
>> -                       if (vq->log_ctx)
>> -                               eventfd_signal(vq->log_ctx);
>> -                       return 0;
>> -               }
>> +
>> +               if (partial)
>> +                       len -= l;
> 
> I wonder if it's simpler to just tweak the caller to call with the
> correct len (or probably U64_MAX) in this case?

To "tweak the caller to call with the correct len" may need to sum the length
of all log[i].

Regarding U64_MAX, would you like something below? That is, only use 'len'
when it isn't U64_MAX.

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473..5b49de05e752 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2327,15 +2327,14 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		r = log_write(vq->log_base, log[i].addr, l);
 		if (r < 0)
 			return r;
-		len -= l;
-		if (!len) {
-			if (vq->log_ctx)
-				eventfd_signal(vq->log_ctx);
-			return 0;
-		}
+
+		if (len != U64_MAX) ---> It is impossible to have len = U64_MAX from vhost-net
+			len -= l;        How about keeping those two lines?
 	}
-	/* Length written exceeds what we have stored. This is a bug. */
-	BUG();
+
+	if (vq->log_ctx)
+		eventfd_signal(vq->log_ctx);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vhost_log_write);


Thank you very much!

Dongli Zhang


