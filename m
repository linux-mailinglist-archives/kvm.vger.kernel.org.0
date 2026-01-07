Return-Path: <kvm+bounces-67253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A52CFF49F
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 64D3B3000DEB
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 18:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B9B343D7D;
	Wed,  7 Jan 2026 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRMuh+CB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CyvKx+cX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A613385B3;
	Wed,  7 Jan 2026 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809263; cv=fail; b=OHidnIy5T68FlpoNgctYOrZXeTvVaWKfHJyrRFpiAP+4LaEiIWc7M9NAI5AB72l96rZil2NnGOYiL59p1p4Lir7GIrmwseHGD4DC/Ia90pEkywB8v4mdaTZDsVn2mFuydQ2NRlMNscUYtLZuR4UdW1zHTC7MXnu+Yc6OLzhXzN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809263; c=relaxed/simple;
	bh=CISM2Ve0ocyEPJL0h02cwMiqrtbb3nsJuE6suHqXbfY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BwMTxDzCV80GNky6papz6KzdF92UCsJuWmW9A1qjil+6/F8R1VVmzWrj5QSxMVLROneQMTqpyNlZFvjaCTnM7lp6J7nVleOptpPlZOD+8P/kiDHHQxZvxZWYW7YT5NDsN/Tq837jHxpgKj5E5C+7bqhjbmLdANDo1e183lsMjq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HRMuh+CB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CyvKx+cX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607GPQjC2876006;
	Wed, 7 Jan 2026 18:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dqknIzLwTfllWR4AYCkrjfQ0aDGS3ShYdwcIQcU0QV8=; b=
	HRMuh+CBZl2Z1q5ehu66Zx0UBKUUA0wokDsi4UusHZzm+9EskJZ6q5kNdISGKfPE
	HyH+xOOETrsgwmcwOuObjuP7jidzYo+oPLUD2ukO5q0gJRvjxIWEJXYXjLnFlVZJ
	RYy7pnLgKyggN7QoVOITZby4XYnyoO9zBzqRODJ5kUGITqm+mxMaVcOlquoOwGuj
	Plv0jG4gvP6ALjMFhWws9zTQ8QQQJJii6Oz69alhtL/f+pfmaUY8Q3KJmGVFggTv
	d1v7zDKQL9ANC/icA72YJkeQOFikBDk8RZabQzTecDdFjA1wQHXC+vA/zA69iOfh
	D6eod5+XgtfqxN6wmucRrw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhu09r5b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:07:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607HrCnk020398;
	Wed, 7 Jan 2026 18:07:29 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjm5j0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X98dtHVS3hJnFNpzrV2wcCRJFPpxK7p7Ax2AwwZe3EuD7OpdBiq/cW6lG/xNPrFYWtxznxMu6jpMgZ+cEN0NDpsKD21nIJOlXEEwqpeAtxQqMh6vjkA5oJmqYlwcc2zFzuUoYxVQcfABHQ6Hz3rpVmsqiB+EY823itZXvz7tdc1Jo9pdX3VScn7vEcUvs2bCUOONBBFT7ylVrstZqt+AZcd3V+f+gobPy2NGVKlrZE2590USaZVXUsaxLL+oesc02/RxTUuOBM2GCe+cV2YYFRtIaHu3dw3F2C3liTQurAHq/q558RIdlh/bec/k78w4cb9ftxxREaaqBxwr/mCItA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqknIzLwTfllWR4AYCkrjfQ0aDGS3ShYdwcIQcU0QV8=;
 b=eDgdyfDxTLKlOWLIJdmJp+q/TyVFmtkM5xcnr5/qTOKIPtoDxbbVysLKNiYQaal6mXPbDNlUuWjlBwNlY+P5A1+A7znywa9YtpYmW2yKpqoubQL3+6oRwtJB6tDSLXIJVPSmgBtHSohuMPiOHPzHuB1rf0VTErivFVDXDyPMwhqyPV3Wl+YV4X8iiRLtsUC/rkj7oFb9a9zb4faRAOc7NQ9WsxQxOyNl1dpraiggJ0gv7+rqVTg4mvsVvfXriDrItFclWBVry0O5m8G0v2Ls8HVsNZSbdbszI8DEnmKyUN0vaGDvzQCN2v8Q/WrgU1LxXCvob8tBPtmuEmGsHDTiiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqknIzLwTfllWR4AYCkrjfQ0aDGS3ShYdwcIQcU0QV8=;
 b=CyvKx+cXHbQZOFZJUmm1ye77TXDUejCogToEPSN3Q8tkOP1y3SmshGKhwF1hVJilGEllNwVA9fiwtv2q7JXPMBxoHGo4QwC42NQbDBqjwwY2/FzB+ARUiLAGLUroHhkNuPL7g64E9J9NHMcWFlmWezPaT121vwu2ZtYzTNi2rrM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6844.namprd10.prod.outlook.com (2603:10b6:208:434::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:07:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:07:26 +0000
Message-ID: <a71abaa5-478b-4fb7-9015-abe5f10909ef@oracle.com>
Date: Wed, 7 Jan 2026 12:07:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] INFO: task hung in vhost_worker_killed (2)
To: "Michael S. Tsirkin" <mst@redhat.com>, Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+a9528028ab4ca83e8bac@syzkaller.appspotmail.com>,
        eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
References: <695b796e.050a0220.1c9965.002a.GAE@google.com>
 <20260106014632.2007-1-hdanton@sina.com>
 <20260106024033-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260106024033-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6844:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2b4ab5-9a71-45fd-fad2-08de4e179d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXBtdExNc3hZVGRMc0JQd25YWWlSai9TdFV1N1dsVmlITkNNVmY5T1RDR294?=
 =?utf-8?B?RVhlcFhsUHc4Z0Z4U3BNektyR3JxNExKWFlFcytEdnVoZjNWTVd3N29pWUxB?=
 =?utf-8?B?MFpNbytOejZXNWpXdlp3LzZBYXhOVGJORC95MU0vZGJ2VnV5alN4citDSEQ3?=
 =?utf-8?B?eDYvVHlmMSt2Y1FVSGJrOEwwS3Y1dSt6UE5IeERXa0JpTlB4dkp0QkgybnA5?=
 =?utf-8?B?SFlRRG05RmdVRWRKM1V4dHRtSFZMU0IrbFJZdFlZaDBJMkNlRFN0a1RLWklm?=
 =?utf-8?B?YlVjUzBGZ0dmejErdHd0dnBqV0lwelY5a3cyUFNzTlBZRm9XbFA4aUdnZzl0?=
 =?utf-8?B?N3R4K3V6R2x1WWo1NXlzVGQwSnMvRDMwZ1RqamgwYW5GTVJ3RUJ4UUxiT2U0?=
 =?utf-8?B?SGpnOWhnZGYwMFhYQ1I2djRHMGtTMTFhRWRIclNDcG8zNWdCcWczQUxucHdp?=
 =?utf-8?B?QTZ1VlYremhjc0U1bzBZUFh2eVhUZXlqQndtWjFkc0dJNjBKZ1k3QXRMRXlk?=
 =?utf-8?B?SE10dS82YWxpb3duSHB6djNCd3Bud0tLbDFCaFpVOXE1cmZYMVp3eVR3Z2Jl?=
 =?utf-8?B?TWdwOVNBY2Z4VksxdXNhbzg3WVVqZE5ScGQxTU82SDZWeEhQblNjaEh6VVdi?=
 =?utf-8?B?eWNvSWFyTkhoY1Q1T2FxeTR5NytWRi9pY2FMQ0Nqb2tuZ01HY2pUMGN3eWpq?=
 =?utf-8?B?c1BacTlLNFFWOUFneEY3dC9wd2hWU2l4UnJQWWZNT00xdmViaHd4am91RXhv?=
 =?utf-8?B?QXVrcjRjYXU3aDk3TTN0Rjl1RUlyOEd1blFXa0FnWGVlUTB2cndWYWNyRDVn?=
 =?utf-8?B?aDVPd0NuaEhmVWZib0NRdVh1aGNsZngvRE9RSmU2OHdiajE3Q2NLd3BLZmlJ?=
 =?utf-8?B?QUtZZVh3R1ZMdnBzTTJadXpST2gvV2dRYjBRYzFFTkVscXErMzlYeHIvV0R0?=
 =?utf-8?B?cGE3Ny8xOTdURUFCamVwdWY0dzNGSU5HOWprVHpvZTRHOGpZRmFLTzN1U3lk?=
 =?utf-8?B?Z0R5Umhqa3ZPZEJFbzU4K0JTT0FXdGFtOERHMytUK3V5VEJEZThQWFpEVHkz?=
 =?utf-8?B?VEVVR1NJLzhzSjhHcTZINFNCRnNxTFExMVF3K0Y3SjlRR3FUSHNKNnlEMzBa?=
 =?utf-8?B?NnZPSlNML3JubmxrQUl3MnA5MDVSKzVUdVVnSnB3V1ZiYjdGRjUxRU5xZ3Nl?=
 =?utf-8?B?ZytLWnJvSFloRGZ3czZIVmlyZTd1V2gxbHJZUWpGTU0rRWFpUmJBYWRyUURx?=
 =?utf-8?B?YWZvV0V5NU9JejNRQXhoSXdUMlFFeEIrbkQ3YjRuUUhBUUwxWWxBL09hSXpi?=
 =?utf-8?B?czF3bkQ5WVJ5T2xVV09xbXBJc2hxMlg1UjNKOEgwQVljQ0N4dDJzSmQzZEhT?=
 =?utf-8?B?RlBqb0NsZUxzRlJwTXI2SnRVT0ZIeXloVFZJSjcxZGNXaFpBaUNXR0tnUXdx?=
 =?utf-8?B?MVRzWHpjMTFvU2F3WEVOSmY4UDJqY3VwTGwrMlBFNTBKa3cvaXRRZTlMQXlV?=
 =?utf-8?B?eXFjNnBTQ0VWejg2dU9wWEJQVGwwVCtzQmxGaDRPSUJOc1VIQU8vekxPcXE2?=
 =?utf-8?B?SEVBVTRzV0UrT1lFUDVINGRGUytaOGJjdlBHUjVrcXZMRUN6UUlWeG9Hbkpa?=
 =?utf-8?B?Z1RUN3JUaDV0M2NrMGd5NDN3MU9MdXQzRjFNUGRZNjBsYTZRUWh0a05jRXhn?=
 =?utf-8?B?bzZqQUdWcTQxelJPeVJJMThkMVl5UDFqdmExY2lEdUlsYUFjUTNVTUtQUjdQ?=
 =?utf-8?B?NWdqaXJaaFNjQ1NPM0lRWXlBY3FHRmFzbEhJSDlYVlByNjFTTDRtWDduNjZY?=
 =?utf-8?B?dFRqSmd4eXFQdXdYN2dzY0tQMFdSaGZ4RmxIMW9ONGU5ZmpnYVYrbW9Yb3Rp?=
 =?utf-8?B?RVIwWHc5c3lnMG5MRU9hdlhRUHdVTDZkZTlNNjlUbjQrZXFMTmRCekxlakZu?=
 =?utf-8?Q?3ohTAnjYq/RSa9K++2OEatwHMkPuxAUm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NvMkZOdEFKeDg1eVo2V28xSkxya3NMclZESUNzZnV6VDNzY3Zsc0kzRis2?=
 =?utf-8?B?UXBOUjB4dlhWYWdXK1YzVzBRWkQxSGtMRGh4eVdiSkpJT1o0K1ZhdTJ2NGxF?=
 =?utf-8?B?ejN6SzRqMnZ6UmZGSTNYR2JWM2UvWU5VQ1dTcE5qNCtDV1c1a2gwa0NyNUJX?=
 =?utf-8?B?OXRYOGZ4bWtKR21QOUNyY2tsTnkyUS9WR1BWZGhFc2xuWUxaMjZjQlFJL2sw?=
 =?utf-8?B?SDFyS25aaHlVcGV2QjVaeEZWL3gyRE5xMFdxNXN1aC82VW9CaStyaUJBNjhI?=
 =?utf-8?B?OEdzRXpEQVBsYU5wdzl2ek9kR2pLWnJIZVFBYW5vWmllN1pPUThOTHprb0Vs?=
 =?utf-8?B?TWNPaGlCcC8xU2xCeVc4dEdySC82Z05JV3A0b1NPZ1ozSVRrSEtlMnpTeldw?=
 =?utf-8?B?TytSMldXV1ZlRmF0WStiL3dySFNvV2N0cGc3L2ZXblJQQy9rUlFjellBN2ZK?=
 =?utf-8?B?L3oyL1ZidmZCVTBHenMzbDdPNitSU0hONmhia1lNZEJGbU1TQ2UydkxXNWV6?=
 =?utf-8?B?TTFaRkZPWUd6cWJZMGUwa2hnT3N6bnlhdGdocUhNM0VOd3pqaEE5bDFKNDhM?=
 =?utf-8?B?bUFOSnFjcURzK1RGQVlpSXJxdkNLWEQxODQ3OTFOcFN6QzdMM1pDeDRFSkZR?=
 =?utf-8?B?My96UVNZQjF0UmZ4QWNCcm1SS09Hd0IvUG9xejJ3OThKN0xOcDlPTDRzZ2NI?=
 =?utf-8?B?ZEpTY2xTUyt4ZHdFdzZ5S3U3bWFreDdMZ1l2cnlpMS9vbGpnMHhBRXJQOFNq?=
 =?utf-8?B?SE1nTFo5a01penNadzlNdDhUMEg4WURSVWkrRFArVElkMXU1ODRieG9VdWdB?=
 =?utf-8?B?WTFpSlo1Qm84M3d4UUhpNXNOZk9RZDA0T2pGMWJ2aU5CMmY3NW51SVpVYmtK?=
 =?utf-8?B?T3BFTzFDZU9KWHV6ZTJVYjAvTzlCZDNPb3B5a0xBNWxQL3FVVUxoMkVzRFdh?=
 =?utf-8?B?bE8xTEY3eHplYkFZdnpEdjhGSzlSZ2FnZmNXdlduNzMvYklRa1c2VXRlS2RX?=
 =?utf-8?B?N3hYMWMvU01iN2hsdzFndnBheWY5V0c0azhPYVRCT29rbXYvUVRKa3VkTnlO?=
 =?utf-8?B?UTNNVThkbWF6aWladGpVNmp2YzdTUlkwRlVTcHVlbE9wcWVBdUxMd05CWEtP?=
 =?utf-8?B?K3ZqTEI5cDk4N2E2UWJaWmZ3STVlaVo1UXRnbStOTHN1Z0VaSE1vWDZSNEp6?=
 =?utf-8?B?MWEzaWtjWlFTT3VOTFVxM0JZZ2dBYi84bCtwbERCdk1wL1JKZzBHT29rY0hj?=
 =?utf-8?B?QlNBUEh5MkJNVjk5cUxwUFJoOXh6ek9Ja3ZFMTFSU0t5dkt1bTdpOXJpdE45?=
 =?utf-8?B?dVR2NkM3YXpZUlRRbGU5ZExUMHQ1cXpIZHpQUXRTS1I2NzI4cFpqV1FSaU1B?=
 =?utf-8?B?VGdHTkRoV3ZrSEg4enFDSTZqdWpGZFhYWWFKclR6WEMvdEhUYkN5TVdaT0tu?=
 =?utf-8?B?TFczbnNrYUd2QWRCVzNEeDJOcldjSDY4eG4yeTlYTEJ3M3YyZm5pOWdjWHdq?=
 =?utf-8?B?ZUNJK3ZLUXdReGtBVmFndWpkRW9DMEdjYlBCSVhlZ1ZLQ0JqWGhoZ0w4S2pu?=
 =?utf-8?B?Zkh1aTFWbjI5VGxQUFpXMjdvRCtyTlhJR2RvU1RVdnkxSm5KUmJndW5GNk9F?=
 =?utf-8?B?MWs2citQR2ZxY0Z4eWxFWElFbVQ5d1VZRkZZTWVSZ1BGNjBoWXpQVkY5SERS?=
 =?utf-8?B?UFJUWGZoWUlqdTFmOU95ZWVXSFZCdTQrYVY2MXRYK1llRDdzNG1SQlRXOVBu?=
 =?utf-8?B?OVVBbjJkZ0wyMnFYVmw5OUdJczNqU2ZrMTRRTDRTcmdkUlcxemtJcjZjcmFo?=
 =?utf-8?B?RFMwWklrMU9YdmFnQXIxYmxmMnVSU3Q0dUF4V0tTeGQrWGpoMS9ZSUtCdUtw?=
 =?utf-8?B?eWFHcjVYQ3lsZThWN3BVNXE0U0lOQ3M3Q2FvMDRtWnNtenpKQkxTb3piV0dQ?=
 =?utf-8?B?TXZoWE4xSzcranV1ZTN0N1NPejdCL1dpc2Vrcm1JdlpaeDUxTWFKOEdjRXpz?=
 =?utf-8?B?M0tZemU0VGFqN1JyeS9SY1dzb25FeHpRdUJ0QlBaTk9VWXE1ZnlxY0FGSi8w?=
 =?utf-8?B?TGtyY29KZEZqWnhrOUtIMTFDMDZNaWExZkUybXN2WmxCL1dDeUs3UVhjQ3dj?=
 =?utf-8?B?M1JvWm5EVEVoVUZvZHRpU3NnUGRBc2xjbCszMUsvQUh0b3I1MXZNc25QTjUz?=
 =?utf-8?B?RDV2TVV1Z0pzVmI2NWhKeklDaENuMVZFdndvVHN1WTBYRzFjejJwNWtHeitF?=
 =?utf-8?B?aGtNTjJJR3Q0SWk5OEM0WE5mRmFnb1EwZWFzZ2xnRHlxWXRQQWw0cWtXMDlv?=
 =?utf-8?B?OGRQZGZRQ0lPTlVWSUc1QVRNNkxtMndJRkcvNVpua0ZDNExkR3JHNEJLQk9B?=
 =?utf-8?Q?MW2a//RTsQzFswJA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XnbZaoYaJDSficuB3f+nViEOx9PLDWK07GWlHRBRcbbyMLMoS1U0FL7+EW0lJqvaS4ICsucGRO99SjqKM1s7MgG7xuAWA3QiPw1D2q0dFKSLt6ywJZnEPgybM0f8WL+W0K/I7pzm8yHThIG3oiZaqqsv/OpjDLjeZBJtCg+my0kRO6M/OyR8Nht7qEWj0/D3b+2/dWMG0s2HH3FAjL7LVF/HfHUfyFJ1mYqNvoRDMPVd2l45CTCkmfYRVR4TDiIRNiCgq0XMvBqfAk2EVoiU3oxwrdfRHpz1SIQSD6JXMmveov7NzYCdbE/uN1jkdGM3UIZP6ial2Suxug/6fz5YO2Ni2x/V9RfGuWRfgPDEgSLVpsLwpyVMvs5TnPZ9dl5emDpDNzXdfXuZnj+N3oqeZ3knP72SXGK3F57/ILiv1Nue879Q//EorLGDw89SoS90ocV7wSlewUSJYYqf6QryGV+WEJlj0qaXaGRym+TPrfhj4/bkQtwqLgJC7JZ0mQZgyI/d2ME75jysI1Y5spM5AEe2H0iO7tsC94MfvUNdlvHHjU/wVBhjJbjNA3ioSxO6sdxe39ltrglCWCrsQcE8lgMXwC2tBra8AWqU+VPBJLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2b4ab5-9a71-45fd-fad2-08de4e179d23
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:07:26.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNwdgJ0HbgSikNGLdiZlAxx/H858YMTOrAm6yNrTOqBvbzRRUXt5mqf/19QrIXxWD+jWI1G25MYuhh81ZfLCJT0UaEdz5v49udoRvbT/7MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=687 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDE0MyBTYWx0ZWRfX0RF8IpMEBM4j
 KdDsxgBR0uQsOPOBoZCe4p5BpqazaKaQ22ncnT9qL9vlR0qYTM5diXKkdcdV37Aj2hJXKckjiMg
 x7DJccpIV7fCDx02wD758/2uja3p+OCHyTZkcZpOMUaV5sTuv1kJ3V4gzVcfpks81GbUtxBigbp
 7GJfgLLQ91LUySgm861CMGkcH4zC0hkQj9ExHV9POaokX+vvSDDlyMnnehp4EQIQHsqW/vYNKUO
 eUkaxlYIPDtxjU6IFwfa+DUd1Tk1GciT65dnJoswbAtZHqC51hRqVywBNOp/Bd1aVppqvnno1CS
 GzlkburnsGEKaW20PQlH782njgtBUzdrkIH1bXuqrGjXLhLljyvWyU8YrVsLgzUi7rKtDQfBS5E
 2th7NZ6XLcxwAVlSS5ozsWJnWybUQzgp61Bfbu/OMeiPia+1AgzAhq9A8LsTXouQzKYVryJCQo0
 P6kYekxo/6SuIMO7dTY/lW3hHLAeA0y01S27YoZE=
X-Proofpoint-ORIG-GUID: _Y_QsvbGTy08SjsKpSFuB_zgxFNgzsP2
X-Authority-Analysis: v=2.4 cv=PfPyRyhd c=1 sm=1 tr=0 ts=695ea0e2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=9bMlWX2x9XXene6MKiAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12109
X-Proofpoint-GUID: _Y_QsvbGTy08SjsKpSFuB_zgxFNgzsP2

On 1/6/26 1:57 AM, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2026 at 09:46:30AM +0800, Hillf Danton wrote:
>>> taking vq mutex in a kill handler is probably not wise.
>>> we should have a separate lock just for handling worker
>>> assignment.
>>>
>> Better not before showing us the root cause of the hung to
>> avoid adding a blind lock.
> 
> Well I think it's pretty clear but the issue is that just another lock
> is not enough, we have bigger problems with this mutex.
> 
> It's held around userspace accesses so if the vhost thread gets into
> uninterruptible sleep holding that, a userspace thread trying to take it
> with mutex_lock will be uninterruptible.
> 
> So it propagates the uninterruptible status between vhost and a
> userspace thread.
> 
> It's not a new issue but the new(ish) thread management APIs make
> it more visible.
> 
> Here it's the kill handler that got hung but it's not really limited
> to that, any ioctl can do that, and I do not want to add another
> lock on data path.
> 

Above, are you saying that the kill handler and a ioctl are trying
to take the virtqueue->mutex in this bug?

I've been trying to replicate this for a while, but I just can't hit what
I'm seeing in the lockdep info from the initial email. We only see the
kill handler trying to take the virtqueue->mutex. Is the theory that the
locking info being reported is not correct? A userspace thread is doing
an ioctl that took the mutex but it's not reported below?

Originally I was using the vhost_dev->mutex for the locking in vhost_worker_killed
but I saw we could take that during ioctls which did a flush, so I added the
vhost_worker->mutex for some of the locking.

If the virtqueue->mutex is also an issue I can do a patch.



Showing all locks held in the system:
1 lock held by khungtaskd/32:
 #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5579:
 #0: ffff88814e3cb0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x449/0x1460 drivers/tty/n_tty.c:2211
1 lock held by syz-executor/5978:
 #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
 #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2b1/0x6e0 kernel/rcu/tree_exp.h:956
2 locks held by syz.5.259/7601:
3 locks held by vhost-7617/7618:
 #0: ffff888054cc68e8 (&vtsk->exit_mutex){+.+.}-{4:4}, at: vhost_task_fn+0x322/0x430 kernel/vhost_task.c:54
 #1: ffff888024646a80 (&worker->mutex){+.+.}-{4:4}, at: vhost_worker_killed+0x57/0x390 drivers/vhost/vhost.c:470
 #2: ffff8880550c0258 (&vq->mutex){+.+.}-{4:4}, at: vhost_worker_killed+0x12b/0x390 drivers/vhost/vhost.c:476
1 lock held by syz-executor/7850:
 #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x36e/0x6e0 kernel/rcu/tree_exp.h:956
1 lock held by syz.2.640/9940:
4 locks held by syz.3.641/9946:
3 locks held by syz.1.642/9954:




