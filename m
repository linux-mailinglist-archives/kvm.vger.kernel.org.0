Return-Path: <kvm+bounces-45525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA335AAB104
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC31E3AE4E6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B82C32B280;
	Tue,  6 May 2025 00:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YYiS0TxA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u3f4sCpG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D289F2BF3D5;
	Mon,  5 May 2025 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485310; cv=fail; b=RcTbUIPYyaMw4i48GSFbzkMG9dtaw2IKxmq+aEFl4MQBQ4G8CsWJLBXrdVjo69/7QYCp4hvLWIv+BrTULft882CRsBJoV+N/2XQs7D/ZfzSjlHJywfghXM0DWZ5oN9+DmjFFOj74zPCQz5vhZZ/kZR7n4Pzjx5IXmb8gfCcGBG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485310; c=relaxed/simple;
	bh=uG8JhJnk3Rk3RbSJ+Co8Xp3EYXvz5rsRZwPEQI/CUGI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lm1r8o/HudLwlA3nNbLAzrkC0HpDjNxZY/OR30hssB5RBTMKcC10DyZUkvGTLKBSDbPQEEOV8N2i7biL1p5/QpFyElx2eUNn0OzcgMd6TAONMOD/cJTsLDGU0zmcsWqowrj3Fo4cl7EY75l8fwRXOjAyr76XKX9aBWPTskVnsk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YYiS0TxA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u3f4sCpG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 545MiMGa020625;
	Mon, 5 May 2025 22:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aI0jjH/Lh156lLmu6NgRPysaCDIloVspj/a9ckFH+zQ=; b=
	YYiS0TxAzQ8/Zec1LOk+QHieDPir0gYPJdV4yY3RSWoClSA+5XvXbWQSh3LiXN8W
	E+I40QPPTjqnn1vTHqaU4DCitPd5UdCcS3MzjRV2DdWaHu6/4hkcWpBdzJelxTNW
	gx8axGMcWfJN5rttPMrq3YZ9+Zb6GP1lKCSIkzYDDV5Td8pC8Pz8/vw7ndNyEZj4
	YOo9eLIG9R3sr7OyrwKZ/dD3cIy15X0iuf9objVe1ZulbbV/Ofyf+TMi73MZ+6ni
	h+Ye55k70f6WnDFbGNP7VYTudMFgGzGSldj5eoSzQR6TG1p3J35oFo2wTUn8tklK
	dxfkkiZK9qbwwsnhcCdZGg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f6at807v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 22:48:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545KO3Bt025076;
	Mon, 5 May 2025 22:48:21 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013076.outbound.protection.outlook.com [40.93.6.76])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kegg3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 22:48:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=enoi1IQsxN7J4sGAdjRJgoxoBIbOoF4r14w/hK4xx+ijxDGFxK3m2qNzSyY4Kb751gSLW3HnQuc8FH/zx5HWBYD0V0yXC6zhvqiE/99mIaPPq9EFEUn7tnyBN/zWtH7Qn4Sc62Z5Y/w2He4yg21y9RsRy9WYf+7koj9q8gvXw8cf0THzkgkuqNIpxUUphHotHjw1xnMMBpnjC3swd4OGTfDnawDVQ4Q0I1IN8u/oICVOiAIUx96A1sPq9pSuQPZGraFIgqDOG1Bwe1h+lYmS3x8I+9dJAAqh9zn7c5WrGWgdjkWcK0XdATzanNXyCPINYG9Zk/smjHdINYpcmFXb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aI0jjH/Lh156lLmu6NgRPysaCDIloVspj/a9ckFH+zQ=;
 b=lSsNe1Z7BcCmEd21LDt1UvfQtjcArmIAOx2/Y27l0dhVIzD/l1LSEKvtmxh4fnmUsNbQRcCrGtMawetLn+orxddAO4OmqinFJSJ8rD+sYiWhDnO7OhIUDDtml4cj5qqBiinCKYsqlh02MBwY/pbNlL2kpMbjz8p32Artjt8OfIWdanBCPp2uNqsM7Mswx2ergQJDjQJQu0nJFb+GJHK8BH9p1dNs/Ki4VcWi8004N/0NjApLVYnEAdvr4+Rx7C/bFcay8fWHlJbl3JDDo5E94wnQVWRDTwBBnDfmKZAnJM7Jm5/RCaMIR6tar9jkva1SG5SIwj3EiWsEbtqPWcFaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aI0jjH/Lh156lLmu6NgRPysaCDIloVspj/a9ckFH+zQ=;
 b=u3f4sCpGIn3kuQZAVEQjr0lVyKRCSmdkGKtz/LRx1e645l+VUkeb9fAebg21mSJ6YptUTk4i7X4v0hhjVnu+1quG1u9toaAbFh/NdW/Ktyo9IOq0wv2NX+VIhkKCBMZLJyt0hdRiYL6Xcaitmr6o6OzxN+i9tW2/dB/LIoVYI6c=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 22:48:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8699.026; Mon, 5 May 2025
 22:48:17 +0000
Message-ID: <00a2fc0a-91e1-4449-a9d3-6a10ed502985@oracle.com>
Date: Mon, 5 May 2025 17:48:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.14 330/642] vhost-scsi: Return queue full for
 page alloc failures during copy
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, jasowang@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20250505221419.2672473-1-sashal@kernel.org>
 <20250505221419.2672473-330-sashal@kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250505221419.2672473-330-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:8:57::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 5916881f-d68e-45f8-6bae-08dd8c26ecf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXE0SWpGb1FhOUVwQ0lKaFZDSDlURGcxdXMvZXN6enJKWENMS0ZhWUMrRytC?=
 =?utf-8?B?UVZJSjJwSE1YcHlEem5vSVlQME9pNDlvMXpsdHpKTVZjK01lSCtnMWYvTVU4?=
 =?utf-8?B?RlpBVFFSVHpIQVhKTklRUVI2ZGo0SzRmWUZPT2ZjOTVkbEQ1cUJBdElHQ0Va?=
 =?utf-8?B?SjVaZjFkeVNZTVZSNVhyY2ZJNGxqdVI2bHBMeTkyVmhSU2Y4TjF1Z0FJVmhq?=
 =?utf-8?B?cnp2M0tBRStXLzhMOFAzbE5MM0RqOFg4MUI3M2FUNzJjb05vR1VORnBsb2Za?=
 =?utf-8?B?TWpzYmNuMWlaRzREeERDU2x4M3U1bytSSkcyMTVYbnJBZVdqcHpHd0JiaTVr?=
 =?utf-8?B?NmVzZTFNZVdjYlpONE9tcm45NFl1VklnNGFLWVQ3M2dTZFN6U2kvWTM3dGls?=
 =?utf-8?B?Rm9PRVBaellWbXBJbUdFYjQ5cGR3aEdERUtlN09jcnVkdEtITHV2MVFVc053?=
 =?utf-8?B?SDh1MHJHS0ttSDNGR3c3WkFTNDMyTmtYdlVMVWgvOWh1ajJqUzlsU2dsOTEr?=
 =?utf-8?B?MlRlWTYrKzArcUN0bUdhMjBSNzZSS2c2WmJnZ0FodEdTVzdiRzI1d0IxWWdE?=
 =?utf-8?B?TVYxZ1lMTjlFSkw5OWdLOWZXRGJvVWVLVnlWUEFaek5tOXk1T2ZERm5IM0F4?=
 =?utf-8?B?b1ZrNjhVZnRSYldVcnhRNEdUdFBoUEFKRjJsSE1HRzdGYi9pUFUrZUwwRklB?=
 =?utf-8?B?TS95dkQzRnJRZGhOVnpsOHlxQWJKVlhvUFdZV1pOWGVhUVN6VnpnL0owN3Bu?=
 =?utf-8?B?MFI4M09hVVNHL0R3TmRqaE1EbTMxLzI5ZVpOT1d4dzRVY1JhVkp2MDhIbDdk?=
 =?utf-8?B?ZDVRK0JianZxQ2tURXdySW5DM1ZvQnhPRDBSR0U3OWRObm91VThoSlFzZUdC?=
 =?utf-8?B?c1UyUEN3dG9RcmQ2cUJnRkVDVk41UG50cHdCcHBHMzhrUXh1c0x3UXl0V0RD?=
 =?utf-8?B?KzM0UjhpV1BmNkFIVDBiUythNGlYaTRqL1pESFRSb1NrMnpHWlBXS0NhMVov?=
 =?utf-8?B?QTBEQTIvelJuT1l5WXgvVDZLdnZiQlNUekowRjhzeXhFbWQ1WkptZ2xBY1Nw?=
 =?utf-8?B?UlcwdmpOeE1OQzZNOW85NytmNE5NWFBCSFVYemRRWEl4bDVWN1l6cjJpbVNr?=
 =?utf-8?B?MGtWMkgxT1lnMHJyRmNIUjZ2UFpUaklucEJyeFVROTdFcmlFeWFNc2FkOEpM?=
 =?utf-8?B?Nnd2SmFuRmV2Tm14Q1ZjNy9sL0oxcGFxRGdZUUdWL0NTQ3NuSEMyOVdJNHNv?=
 =?utf-8?B?azhNYWkrRGhKbFdjMlBhU21jZEhLM2dGdUVhU0NHTmtWbjczZjJ3TWdOcGVM?=
 =?utf-8?B?LzJNclBYdVVnQUNKRGNqcEpTOGZocEE1djMyaW0wcytFaXYzNWFxQXRVbE93?=
 =?utf-8?B?cUs1SlFUVEF1TG1vVk1NYVA5M3JTZFIxUUtPSlhCWThUOUIzOEp2UUNRYVY4?=
 =?utf-8?B?b2h6UzJhSTB4N0t5K0pyMXprQWFTRGowcFJIK2V3dDlTVjBaNThCWWxVV3pS?=
 =?utf-8?B?anh6cE42MmE2WnVxYStpOHBtOC9ZWmtmcVBtYUZmVnAvQTQvUkIrUzJWRFV3?=
 =?utf-8?B?MWw3a0tsdEtscmI5VGo3TStPMFI4NHNSZllZRzNvMVQreHM2QmVoTEd3bHZy?=
 =?utf-8?B?Zjk0ZWxweFlUSjdqWGdVbHBpRTZYOTdpeWNGMWdlWnVFTEJqRWtLUC9paFZZ?=
 =?utf-8?B?SHlnbnNaMXdwTjNVZURxUHF5MXFIazB5OCtzQmpDY3YyWnpmNllSWVpjdHBC?=
 =?utf-8?B?NTI5Tll2YmtQU3lVWlZGQ01vejJzUzVXNU9ib1hDQ0kzRGY1UFhBUTErS2dH?=
 =?utf-8?B?MXdyQktMV1N5d1BsNmlNVWNtZERnZmNGdUoweE9NOWowYmk3S0Nzb250Wm54?=
 =?utf-8?B?YXhTa2hJNTN0WHJsWUJaSm50T0NlcmNDQ2ZTdjlsYWhmM1A1dFJ2V2tTVjNP?=
 =?utf-8?Q?BQUjKOUhqzk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkVGYk5EbENJemU4YWZldEZKMFhPWFB1Zk92OFpLa3F5cHExUU1QWDB4VHpK?=
 =?utf-8?B?RVFyaWZwSSsyeFVXUDVSQVdocllaU1FoN3dVai93aUxpcTlYQnozUUk2U0Vh?=
 =?utf-8?B?T1FWZHE2RXhLVk45NWpsb3l0RFdZV0dpY3Z5NWNUN0tsSklWcGJBWTFxVWZx?=
 =?utf-8?B?QTQzWmpDRkhDVjcrbmtad2pzYjhSWnhkcEVJUzZMV0U1cEJjVkJTdytTamtE?=
 =?utf-8?B?L1JZZTNuK0lSSHI5ZHNPdHI0SzV3NWJVQmZlZlliQlBhanRtQVJ5Vjh0U2sx?=
 =?utf-8?B?Vnk2bVdsdEdaVmg1SjBEUUFFQ2YydG9hSXN2MXRrS0l3NVJSejZIN2Y3VE1J?=
 =?utf-8?B?ajZwSGhrYlZMMUtrVWdQRWQyNlFDU0g3NC9zTFhBOWhiWnMwRGNDL3VFVVFW?=
 =?utf-8?B?Wkc2VEJqOXd3R1RVejlyUGVWYmFRdytBM1N2Y1lNaHZCVTJEdVV2QXIwSFh5?=
 =?utf-8?B?TXh0U1BtYTJlSENaTHJ4NDZDdEIwaExGYjh4ZnEyblVZNVpYaU1idjR0VDlO?=
 =?utf-8?B?TE9kRVRnMHhneE1xanlBdC8rcmc1STZXUEJnK09UUTlzMW5qNGZ2NTJBQ201?=
 =?utf-8?B?RVQyRnJZV2NCd0g5NXhYVUMxTnJhRXV0TGltUjVvUUVCcXBrSlpBN2xQd1Rw?=
 =?utf-8?B?SzRUMUg0d2V3Vzk2blYyOGt2Z0REZk9IdjR5RzRZNDZFMUQ4TjVLOVVrdXZk?=
 =?utf-8?B?bW9iZU9ncWh5SFo4T09rRE9ESTduY3ZLbkpjNFc5R2ZhRktVTkY4ajMvSGx5?=
 =?utf-8?B?bVdkK3F5QS9ZNGZhRDRWQzhyWFl2dmJkUWdPY2wvazVNZWdyenRhUEpESG1U?=
 =?utf-8?B?V05QaGNSM1dHUVk5WGc0dW9iakpqSDZMdm0ydkxiYnBWajFmSStBcUN0Vm52?=
 =?utf-8?B?UlFvcGtxL0xJOWRNdHdYZlRtMkRFV3ZJaHNELzl4WitmWEx1ZjlUSmwwRnRm?=
 =?utf-8?B?ZkVrRGRLRkFrejNKS0RYMXQzSStURGxUTXkydm1MYmxadzkzbURwYUpLeEl6?=
 =?utf-8?B?OW9TekN0eG9lakNRei9uVDBxWCs0Wjg0SEhiUmluUVpsK0traUgrbk1udFB6?=
 =?utf-8?B?dWwrN1ViM1dscWwxRW5IQkFPcy9WdTNEbXRneGQvRmxadFJYUThXOW9jaWto?=
 =?utf-8?B?eCtubXo5byt2c3hsdm9UK3BMOVhQanNLdTZJUGJ2c1J0NzVIMXhZckIzK0Zz?=
 =?utf-8?B?U284bzZBVWFrdGVvZVNSMDVxQzc2R2l1TWpJeEdBZ1M2a1VjUnY1OGpTLzRo?=
 =?utf-8?B?TW0yZ1V6TTBlOW1PRVN0YXJWNXd4d3BaMlphUFg5RmptQ3pEeFNpTTI1ZmJB?=
 =?utf-8?B?RjR0R3R1M2Jzd0czMDBzclhKZWJxcDRMc0svNzdiUWtmY09BUXRuTk5LbjJG?=
 =?utf-8?B?eXhNL0NqZEF5c1dBODdReUZhWXJ3bE84c2c5amdGVTZLZSs2MjZPOGxqUmYv?=
 =?utf-8?B?TFJNcmphakxSUjV6SlN1V2pKVERhRW1JZXhlUngwV3h2YUFqZlRaazBYWHlJ?=
 =?utf-8?B?UXlNTWluYUozNWMyUDE2cUlaMHora0JnT0tFVHlIdU4zd24vWEhtODREWlcv?=
 =?utf-8?B?bmFpZldlL0t4MG5yQytpLzJuaDBaWnh1dkxVSG9TcjBYRjZ3cEkzeGNSYkl3?=
 =?utf-8?B?TldTQ3M5V21nNVlzZHBvcFhld1ZXMmovMFhxRzBVNC9CakxaWGVrNVIvV0FQ?=
 =?utf-8?B?a1grMjUwTUU3T01CdEVESEdHNTQxSDNRL0J2OTZXWU9oVTBlc2oxSlBzbmNo?=
 =?utf-8?B?OXBKZTg3b3Npa0YyTUpUY0VSRHJ5TWdGcEdhTkpYeGY4dnV5NG9BQm5udmFK?=
 =?utf-8?B?R2greDNqUmtDVFQrTmFtVG41MUd5V0lRVmkrdlg5TWd0Nkp4MUZUN0orRE9q?=
 =?utf-8?B?SG1pbWFJL3o0cmdIYnZ5NFlvclRBMEErcmlOb0FoakhQNmpNWHpkTXgrc25o?=
 =?utf-8?B?czJ4c1FGUm9PcCtBRTdoaHpBSGNOdHlGQm5YWWZuTWlFcWdIb1cxbWVBQ2V4?=
 =?utf-8?B?M09PZ3ZKTjVLTXVNb0dmUEhRNm5WRmgydHBIdW5hRmF4MWZ4ZXVqYzNKSGdw?=
 =?utf-8?B?eWZaSEVDZ05sSWk0NlkwUHdOeFh3cWVDTk9wMEd3cU4zREFmaktKM1NHZU1U?=
 =?utf-8?B?TkhiSktXcTd2eGN4c2tRWU9lYTdrS2llQW5SdmtZb1RpUUlpRlBqTzNLZU81?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YVybeNDCrDD4boEcI3zB4B6uaAutojv3h2UpDz6I8YAE8bVKH5KP6svK3VcNAvjMUYljwC0hExLjg0kOIo6C/XM3OSmFIKBl3waKXdag8BD4Cm/+D0qt7YKAsBoVCoDj06RUpeJnCCZgyG69apKd4FLdG6tyJC2iVr6bpGOk+ppZ/lIVhQ/Xbr4Mvm6BfvgqKTh7v9NSJngNCXM2qm8jMbc5UkQv8/t7wcgN8LG9ApMPXG0MTSNJUSzCY+8fn5eyl6/sHxFvT1VLv1o6FImRmk0whKRD9CM8aMu9cmMQAlJsTzcpFgv5R8USZRgOUY1QgYYGGyErum3OFtJPZXCxFKLTBMuQylQ05rHmfQ2mlcAJ5GPXR1BHNjZSzbsY9RqFHGx61c7CTYS1bI6AR2NQDU8WfaOWYV5C69lk6Lk+q+XcA3Rht7EJysJH+3G+CkGNTeDbmD0G+XZE0BsepQfwsu13xzUL4nCzpNR15LiuEORHWbmvbAe0QTOq8fO4u3xqcT+L/VfChavRuI6mqUXoqnU+Az/J1o4q+w1ARDAtC3LU4wTucPIz1xY/bPd8bQIsesUduTScvbC4mwlcvEPXInfwpMGBbDswE18avH8iAuI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5916881f-d68e-45f8-6bae-08dd8c26ecf1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 22:48:17.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJdzZV3fTxiymzizA6FEO3sSAAwXbc1D+SfhjMqgq1tWivYlkpxdb39o4ZCOMhKVg5yUSPtF/mvXwWbDS401Nf5ZpFJ9s7abLmEW7TbyJZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_10,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050215
X-Proofpoint-ORIG-GUID: NhG-6zbT1dWU19E7S8DMFFjN2FDwaEY4
X-Proofpoint-GUID: NhG-6zbT1dWU19E7S8DMFFjN2FDwaEY4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDIxNSBTYWx0ZWRfXy411ufpnGMLC /ycBZYT+LdX+1S+GmfDAEC6nsJfjyZy9oYdtRQ8d9klGsy5zVeEGV9OqRenp+U/aOk3qu4o7Mcy DNJ6X3DX9IDSBoyMFPW2rN02JCTN+ynNfM5uiPNk8r3dU4ESL91CBBVclEgKjMsa6TELfTPP5gZ
 q3CoJXjFoT7G5M9+9ECFR5+AuPnd7jtmERqKAqBzbU4T+y942i7IZskiZA4r2EWO+clHvrdywab AEV4f05GEdSpz0ysv61YsaL45XnbGYWZ9rrHH1UyJZ7tAtzrww6sDfH2gJDYqZ8C53c0JOB93Eo qzxiFY1qWZH1a1iig7u+C0DZczhsoU6Qkswckd7fw8In5Ck0WwpyLzqqc5i9EstLiGGur98FvNN
 Ov/XNEm2iD1U3yizJjPU2Y/lNSgNxIOHfePc/k/FvVnXWNN8ZKiLYZwJmjxunxiPIm1vL5QK
X-Authority-Analysis: v=2.4 cv=Q7bS452a c=1 sm=1 tr=0 ts=68194035 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wzvYgz4xyPozM-7F5z8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129

Dropping netdev because this is a storage patch.

On 5/5/25 5:09 PM, Sasha Levin wrote:
> From: Mike Christie <michael.christie@oracle.com>
> 
> [ Upstream commit 891b99eab0f89dbe08d216f4ab71acbeaf7a3102 ]
> 
> This has us return queue full if we can't allocate a page during the
> copy operation so the initiator can retry.

If you backport this patch you need this one as well:

commit 891b99eab0f89dbe08d216f4ab71acbeaf7a3102
Author: Mike Christie <michael.christie@oracle.com>
Date:   Tue Dec 3 13:15:11 2024 -0600

    vhost-scsi: Return queue full for page alloc failures during copy
    
    This has us return queue full if we can't allocate a page during the
    copy operation so the initiator can retry.
    

