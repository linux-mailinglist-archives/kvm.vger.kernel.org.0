Return-Path: <kvm+bounces-50877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C80C8AEA664
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CBCB3A8EA4
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F672EFD8C;
	Thu, 26 Jun 2025 19:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eSuFc16K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pG7to3IA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961BA18A6DB;
	Thu, 26 Jun 2025 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750965744; cv=fail; b=AAdpFqMypJj/WD/vZN96y7p+RXMxJzbWus9PPXcGjZAnOJ96rF3b28uov/1MHzE2gZq+1fJXLUaWZ4cjVjg3wC1J38WQRwNV8E/dFoCO1p1VeDB3F0tvw+Iw2CXJfAoeCfmjfT/ZkPlyQyq6tDPWKTLDcNNLmqeDvEjG0MXrto8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750965744; c=relaxed/simple;
	bh=jGMYuG3hJn+KQcH80HSdFkObKMhlBXDR3l7myXKiD0U=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TTe62pf8mf7NMxPKqkYGAXJvXMSuJAPU9IuCHCRqPGG9r7KwbH4Fl0NFAGYUbv5aYQbU7tZ25ySJZCNmkW/3vfPH05OBnIc199e3ni1zRp6lkjoH+Rcr7cg6MsyxfYGm9o3OUV27RN5RVQfVg3Jx1lv7NFWLNxn8Wf7SgnXlgPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eSuFc16K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pG7to3IA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QFu0fP009471;
	Thu, 26 Jun 2025 19:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cudb5GFVKR5Ts7THwMUgzeaVV/nPnIa08Z0E3P3cjbo=; b=
	eSuFc16KXhN4X9Ti+Z0RB2rO3n2g90Hz/XgjNssGeaGFLm5e4tUGDg+Xd3Vq+9wL
	hX7M+5hF/cA05cD23N8IPecYQ1AhWJwS+CKsTNTPks2sw0taKcK53LnEUb0/hw4L
	Y+4QMsIILxZjfNQroIyK4zzpb0pYkHLAVbWmstZ+s7d9iHOwjXpBLf5z/k5XKbVi
	33uT0X/cg/KtxPOAP0wxFTKKYri6MniboOVt73BkfQCd5TqH+UQIvH3h4S57nDJP
	Wct/5exS671l/9lAUis5IZzWvb4THHTSuBULWbAYg9wdKQPz2qrDPBjjdQUsj1sX
	3qXNfIXdZO0Uak5pHdz8CA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7heex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 19:22:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55QJ1CQn018018;
	Thu, 26 Jun 2025 19:22:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehw0er1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 19:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQTDJEI9ha0MUVZiqipZ23rdzxHq8B7tXBboE8Bj6Wx6/WcB0+cIvRZUVXNkn9I906tPdwNC7XaE0JseE5Saf/c55PV1dCNNQ7fnxmshm/0FGtIGa70gbvEWuectBHu885zx0lxOcRrmVZx43m2PNLaudVIe6BS2r/d2ez9F1nU8AqdHXpSmj0wLzaS19E4hhk3rFO5RS8Xo53gwxGvloTcSGmIejq4vucB+LYwvTGLn1uGoD5V0qPvBQHFN+hH7Eq9DO0R9TliuTzGjUCBpQ14CceE1iK2yiNBx1kGONLG6jGnrTpBqUiKze9tiKZg10IGPwTZrp1PY+sH3TKsmEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cudb5GFVKR5Ts7THwMUgzeaVV/nPnIa08Z0E3P3cjbo=;
 b=WVdGDc0SOepCpYssTUk+Z5etCU1q7eH3FeRZz4q5MEM1/eVhjGSBZLjZUpfY2XxXMv7TW/8NHq1+giBuxEPyKNwq8i918pvlMqc0BSQW9v5GiZ0T7AkP7gprzJjLddBGscz73dBjoRQNFOrWGJ+eYFVYDhEljjj6U4EdVXVoP6c2SmBTdLUrZoce9uzwMaJCGND3yHDlRykapSUTPTJ0w3pXvvTffeJB7f2NVqY1AI3yi9QtfxZVNARAOpa0Nrft0Yv+c0KJsHvkPPUBhoftropw5twMVlLJVFVJrw1iyJGVLDuWJ+ExN9g5x50JLUmp/0btlr1tPYCobzIcn7MDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cudb5GFVKR5Ts7THwMUgzeaVV/nPnIa08Z0E3P3cjbo=;
 b=pG7to3IAkpys1QXKJJWHzp3Gkz3nfzAHuhipulgGREeaSj6gAyAxw3MylgEfN/QhBNqsRpA3xfyS6HV7TYpC+j7Y1j4Be+5VaXiMbiZTr2xZecBqltfE4s3rdA0mc8/+3kFBYSDrqXNArabt2ZvSQ/SOWps62aLiDnTsZfOXkp8=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by MW5PR10MB5875.namprd10.prod.outlook.com (2603:10b6:303:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Thu, 26 Jun
 2025 19:22:10 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%7]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 19:22:10 +0000
Message-ID: <8ea6276e-5a89-4e8b-a18a-55aa7d007fc4@oracle.com>
Date: Thu, 26 Jun 2025 21:22:06 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com,
        x86@kernel.org, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Sean Christopherson <seanjc@google.com>
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <aF1S2EIJWN47zLDG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0029.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::18) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|MW5PR10MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: f8fb2520-b9e4-4ab7-0608-08ddb4e6bf59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXU3ZFdKVWFkQ3MySDRrd1hwS2VoRFYrTjh0cEtXNC9iTzNYK2xEajd0QzRG?=
 =?utf-8?B?S0ZkSSs2dVpBYm5ya0c1bmNHeG96bm9vS01HekR6TXZ3NXJtWTcwN0NUZXZi?=
 =?utf-8?B?VUhVMFlSbTM4bWVvZEdPVzljbUtNRGI2RmQ1NkgySmpwdWtoTWdOK0JFa2ds?=
 =?utf-8?B?KzlxcUJSWk1PVFQ1clJleWovRnI1emptc2k2emo4aTNtVFQ0aFNScWFWQ0V3?=
 =?utf-8?B?cXIwZ3BMVGVMQlFURy9EUTFnNExTNVNZQmRsdGVUUVR1aThOWXdnN1Evc3l6?=
 =?utf-8?B?bEFoTXBtaHFJWUNxTU5xaFpMZzJ6Q3pXTzRGalcwWitOWWNDV3ZYWUJyVk40?=
 =?utf-8?B?dlpnZ3JZRjh3WjlxNzFuaFVoRU9DMUpUUUNzT2x2RGxHOEFTRjhGaEhQZ0dN?=
 =?utf-8?B?MFFCUmtLdDl1U1FkcXhMYTlCRWxqNFZwUVRtVWNybFlUVzlxZXMwSDBLajA2?=
 =?utf-8?B?ekwvMHBIQ0xMNHcySHh3U1hTc3RqN1hVSmpKMWNkVksveEVwWWVlRHlROU9t?=
 =?utf-8?B?TUY5VDE5RGZ4VGEvTVVkYlZPVy9yYnNrNlA1WEpQQkFzdWNBc3BiSnVPenlH?=
 =?utf-8?B?MWlDSFJyTUJSYUNvcFdYb1FENThEZkFEelFmSDlTdTdVK05iSDgySlUrUGZW?=
 =?utf-8?B?VEhGM1VId0dFR2grWkhjRDdPY3ZldFVSQzloSnZJNUJ6WG9VUGZGWlVaWGVq?=
 =?utf-8?B?TmxNMURienVwSFNXN0RBVFNKcm9IMXZadTlwelFLYjMwMlBnVE1rSk1VY0dR?=
 =?utf-8?B?QWdlRGUxemI3YVI5L3J0YWFXdkNSa0dRMkp1Y0w1TlpJRmd1V2dNZlk5U01l?=
 =?utf-8?B?K2NSV2RERkV6MkZzdjR4V2ZSTG1vYUNkNDkyajNnSEJIdU1Mb3RDN0R1SGk0?=
 =?utf-8?B?MHZrdWFVVkNOM1RuQWdZaVRmREgwaEVOUjNrM1N0NmtBTnJwaUdvUlRtYm5Z?=
 =?utf-8?B?RUd4aUtaemZLZUt0WXJrcjN4VzdMQ2p5K0Vla0w5VTRBMlZxWW5ncTVzc0tx?=
 =?utf-8?B?VExoQ2pFc2NKZHA3aXlxRmJabHVuVDlyWSt1WjkxaGlhQ1pkQ1dEY3ZQMFMx?=
 =?utf-8?B?dUdXTHc3QmpqZTNtUTU0V21aajRXZzhpOGVZdHUvYmprTnFYZit2cGZWbUQr?=
 =?utf-8?B?ZlY5Qy9wM1p2SG9lS1hCSkMxeWhVSHlxaXNOTVJNSUtSQWVBbFNSWDc5VGww?=
 =?utf-8?B?ME5sanhSNlRSaUZQZ1lFY0NxOGE0aEI2NVprOFZHczJpSFVwUXFiaFE5QWhY?=
 =?utf-8?B?WjV6UTdZd29XeFljRnZsczk3K0lnUXE0cXVTUktlcHk5R21WU1JyL0xROW9v?=
 =?utf-8?B?anlQbHF3Yjg1SnRkTEw4d0pvK296QmRyVUlGamxvZjF4YjBkSkZpaVcwaDQ3?=
 =?utf-8?B?S0RrRGwyUmN6MUdHOEJGMnRvMk9YZTZCVldDdE5TZEUrRkJKaXRaWmVCNkxJ?=
 =?utf-8?B?aEVSUkllellCN0o3L1Z0QmFKZTBsTlMySGNOYjNHVjRKWmF0UklSaGd0ak1H?=
 =?utf-8?B?Z1I4UDh1T3AwZXlSZ3pyNzR0c1RUNEk3UzMvSk5IVG9XQVlKaUtSaXcwWmJr?=
 =?utf-8?B?TFU0MzJnQi9KcTMrTnh0Zm5qbjlDdU1iOVJYNFBIQTZXT3NNeUJ6dTNNZ1E2?=
 =?utf-8?B?ZGMxYzdvS0dOdHE0RDlCMHA0SGpXOG5JOHQraHhaeXZQQ25HQklCLzY5ZFFT?=
 =?utf-8?B?WU9WQlZmZEQydjlvQkIrS0o1MUNWK0VXMTVFS2cybDl4OHNTbmpEelNRRldM?=
 =?utf-8?B?MGg1MFQ3VWhWNDhZMDZIN3lPTFh3YjEveHBwazBSRVcxYlRqS3ROeG4vK1hw?=
 =?utf-8?B?cFErZHFYc0NvbUNSTlJVa2RGcW5MdThNUVBGZXNIclhtVGJhYW1ydFA1cnIx?=
 =?utf-8?B?cUF5elhsSmUreGNXZUFIM2t1K1FwWlFCMFkwWGpUbWdVT1hiQ3ZjZUJyTkZm?=
 =?utf-8?Q?3c6LlpjwCSU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUFPeWErd21NSEM0UGlnNmRHaEpCYUo5VHhoYjFDMmlDSy9DSUMrMVBDOGJp?=
 =?utf-8?B?SytRbGNIbHFtOEdpM3ozQlJUd2tpR3R6alRmSVU2bWN1QWRSRmM5anRvS09G?=
 =?utf-8?B?MDVxV2ZDNXJYN3VlL0lvWGtYaUlNVUhOTTB3Z0YyNkJMaDQ0dk5oakQ3citB?=
 =?utf-8?B?NVZvWDJ1SWhjQmRFSGtVcXVNNlc5WWpEWTdXa2xxQXdKRGFQVmxTUS91SHRi?=
 =?utf-8?B?SUhuZThKZ2lFOXNjUzRISjQrRHlkVWJOWVRNeklyVE9XWnJlazcramVtUFVY?=
 =?utf-8?B?bzR6SXg1REUyd2R0NEdPcHkwQzBNVzkybzZpbWo3bC9ZeW5TUittdU1EYUdu?=
 =?utf-8?B?VUozKzFzZGN5UnE1dXcyL2QyYTY1SEFsTWtnUGJCb3hBeXNIdkRrTkd2bEtB?=
 =?utf-8?B?VFlMODJoa1B3QkN5elE5aGlseWlmbnlCNHdWVld0MVV4aEdFNVRHSHBIM2tS?=
 =?utf-8?B?ZThPRHlKUlh2OE1PQmpIT1hVcVJTMTd3dXhtZzVLK0Y4b2hMVkxwUis1RUlQ?=
 =?utf-8?B?Y3pKUXlGQjRYZlJ3b3phbDY4cXRxT0ZnT2MzZ1RQYTZqRjJEOHhWWFVMTTdy?=
 =?utf-8?B?OGhpRmJqNzBtR2lLSlM0STdQY0hMd1ArNzluMU96eVBrKy9Fd2tSZlEzUllz?=
 =?utf-8?B?WlVpbkVhNzRPb2VsYllVa3BrUm1oaldHb3ZMTUtsclo3SENyclkvZkR3RGhl?=
 =?utf-8?B?R0loYysvZTR5U1lkckFoN3VkOXdUWHZNU3d4eEMvbnBKTkZmTGZlSWJ4eEtW?=
 =?utf-8?B?S25mYUdKOHdzeVg3TWovOFlLTGVXSTJISXVma2VSNkVOcjZzZlA3Z3Z0aXgw?=
 =?utf-8?B?TlJmT0VIOXhPRzVyMURlZ05ubkxpSGxwVTVDQ0tFVXFXK2h2eWxvVDVTMjRJ?=
 =?utf-8?B?ZlprNjcrd0hYWVpIZEwrQVFtYWZieVMreHFKNlBtUEtYamtuSk9uVUZtL05I?=
 =?utf-8?B?a0N3aGcwM0ZpRXJJSjN4QVFMZWpBV2JOUThWWkZRaEppNmxEejJDMEE0T0M0?=
 =?utf-8?B?WlBzRE5jNzgzQnJpZlRVbkFXaFI2VU1BSDArUTB4Tm9vTlBUSzdQK1QzbXFz?=
 =?utf-8?B?VUE3UVlrRkR1UElvZE5kNjVHK21wV2dzaWM4N2JsMElaeHlJcDFuMkJIVVU2?=
 =?utf-8?B?THdyVzhFbjNHZnhQMkdJamVDdENlWnI3ZVdZMit1REk3RVZkVU0zaDh5Qnhj?=
 =?utf-8?B?NzVDcitvaW9HZEFuTHVORUV2OHFTakxSejhzZzFWYXpRSWpFdFdhcDhMNjBK?=
 =?utf-8?B?N29weEcxM09UYjN6NmhqT0hHdVJNTExqb2g0ak5oV1JncWNPVURIa2ZzbDRH?=
 =?utf-8?B?NWVhZmEvMmVQRjRMWWVTODZHMmRaandLa3lOTDNqWXlxWCsvSVI5aEZ0eVFr?=
 =?utf-8?B?SVhOWE1jNjdBZVRiZ1M2S0htaG1UUE5SZTRYcHVXbUYvU0J5QTNZdVEyTG9E?=
 =?utf-8?B?L3FaRkxoRWNmRjV1RE8yV1BWdGd4a3NpYzVIaFRmK1J2QWdSWEZjdjhNYUh5?=
 =?utf-8?B?eDBuR1hMV3p4OU1ITG1wOFgvYUt5ZnF5dlI0amFtTW5tbjhEK09zT05meDND?=
 =?utf-8?B?WGxSVVpmYmpYdDk5MWlMVnRPKzh1T1VWYUpKaWhURzhvMUVybU1TVEd6NTdP?=
 =?utf-8?B?UW1SY2hhQURYZ1UwNlRaV00zWkl3V1BTTlAxWDRPcU1CK0tWeHNkVitrZmJr?=
 =?utf-8?B?UzFzQXB1eDljcnNhZGxoMnFLNUM2WlQvbEd4aTJCcTlNRE1wS2dUQjErVVVo?=
 =?utf-8?B?dDBNY2MvbGEvTU8xSU1mR1lnUnlyQVVxS2llMHQ3M21lUWdsaUFtYVJqZ0M4?=
 =?utf-8?B?ME5Td2ZDaCt6aHVzRGZ3Ulg0dWNRd1FaMmdOc2tOZEFjcnpkUzNJM0RYUUlm?=
 =?utf-8?B?UTJXSjNtQTJ2YUtQbkhjeW9Fcnl3blBzeFFSYkxJa3NaK3pXRkdDUTlIMks2?=
 =?utf-8?B?RFdXdkVuTlVQR3ZwMURmS1pSNFRYRWt5MzQ4WnBTcFlmS3A1VmUxMGhMNHlQ?=
 =?utf-8?B?YUF6K3ZsQ1NvS2kyNTM5NjhpQ2hPTlFVU3FaQW9uOWRCQU9OTG1xRjl3SHVp?=
 =?utf-8?B?eVRLVzRZUzZXYVlsQ2tYVUpERDdSdUpDdGFjSXpZa1NrWXdCVUZBdExIRmRa?=
 =?utf-8?B?K1I5SmZEVlpkclJoR3pkSXR5aFlmZ0UxN0pJcDJlQUxRdTdHVjhvL05hbE4x?=
 =?utf-8?B?aWJqbVIwc0J0MFBjYjRIaHhXN1h2c0M0a0FkZmxoeHlqTG5PRXNNTlhOYTd3?=
 =?utf-8?B?ci9BUjRQYTFPdGlIRnI2bHFCeDVnPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	32khzB50yx6z2Xq9Sq3BwktOID0LDjO0icAyJn0VvA0gP6qgK/+2wmLRP2feCqFDSgqb4Ccv2y/NbQu+MG7JMIk5noXJKHQ9TOsZdmzjMdQVcViJGjJ+QipPrAdrFWxAgrMzUuEJKX74CCxUYX2f67tIjacAawAn+/VlWj/2OXIEeOACbGC+ROqLoPU/QgmmvFAD+jAAkPiJqRrmYQjfB39y3tUXXSrubtyutifPWrdgMYvIliTecu8X0uBliNWIFrjSdP6qv6Z6LfrfSLZeYljjsM8bpeqk43AUvSEiJPFDfkDGqoL7G9U1vxmvdq/GdoRhFq7vO4qcqdDGxcUkIy+skHfRgA35Sl/cFvCbt9VDnb0ZprAiaEO3qmFa5dyo3tLQkN0Y0Ci4tfeJsBaXdbFU3Gg6A+4Ag0MyGKv1DneXBpmIYMNEctjP3SLxq2j0rBrA59LEqoSi5pVUndCjpvxUFH+collTpHyteWxx2jKB0oelInt0Atco8VI49K4aRj/dCp8frNgaCowtgE7DTiCORaahzHaY42JtjvUKfvU99A9YhjR6K38J0tojEJKHNUpusU7Ggmr52uSmuERiXIqY3vInergqa3cP0kTzvY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fb2520-b9e4-4ab7-0608-08ddb4e6bf59
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 19:22:10.4762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTUMYPXhALpt84PgT9kfuezhMk8MVfJ9ONK1dBDmSfjvSqbr099+T1OkpcvabEJ0XwCxWxFJL5p6xtC/2G8n5csI8qH7vNHBLDsAg11v+nQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_06,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260164
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDE2NCBTYWx0ZWRfX07phhGJUoYfp T4slW3FkP8ZVkFv9hAlV5HTauJaM28ogDMmpeKlmoo2KXFLC17aZkASbqe7lRePrsD+qxodfWzd XY2M+Mymaz8UajUP7p+VzquMq2Ls5fCgnuXXCz5Qo4Q0LlS2X4tdfy8zbbDYHI2/lrkQOUTyckP
 v3s2Zkscq1V5As3bbqE6woNZIAyK1271yXsoqAo2HSg++QD16Ay63C1ogp+EENVI/6SBx7/mTzb unjXUbg1h4RWcmDcV20urcinejfQTGanU7sJwVCHQ3ROoOxhc6A/ffFoe6trDDA/FZV/LCpfMKb 0jDSgZgB8xN7tbqe4PsXefEOZjGP4WeoJGEluiW60gSYBU1uJCMKN0F8WzERtPli2RyfCe7toyR
 PCdbWRoU+iMf35xYthThV/xD87TqlQxueJWGGUQUTucpU+ORiCQK9oQ7z+xkCvr0bHRXTfq2
X-Proofpoint-GUID: -97sXIdkq7RfneUb4R66f6jzb6qcsa2O
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685d9de7 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=QH-YIIke1X8NFttTr18A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14723
X-Proofpoint-ORIG-GUID: -97sXIdkq7RfneUb4R66f6jzb6qcsa2O


On 6/26/25 16:02, Sean Christopherson wrote:
> +Jim
> 
> For the scope, "KVM: x86:"
> 
> On Thu, Jun 26, 2025, Alexandre Chartre wrote:
>> KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
>> However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
>> so it makes no sense to emulate it on AMD.
>>
>> The AMD documentation specifies that this MSR is not defined on
>> the AMD architecture. So emulating this MSR on AMD can even cause
>> issues (like Windows BSOD) as the guest OS might not expect this
>> MSR to exist on such architecture.
>>
>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> ---
>>
>> A similar patch was submitted some years ago but it looks like it felt
>> through the cracks:
>> https://lore.kernel.org/kvm/20190307093143.77182-1-xiaoyao.li@linux.intel.com/
> 
> It didn't fall through the cracks, we deliberately elected to emulate the MSR in
> common code so that KVM's advertised CPUID support would match KVM's emulation.
> 
>    On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
>    > On 07/03/19 18:37, Sean Christopherson wrote:
>    > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
>    > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
>    > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
>    > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
>    > > >
>    > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
>    > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
>    > > > for vmx, and moves the related handling to vmx related files.
>    > >
>    > > What about emulating the MSR on an AMD host for testing purpsoes?  It
>    > > might be a useful way for someone without Intel hardware to test spectre
>    > > related flows.
>    > >
>    > > In other words, an alternative to restricting emulation of the MSR to
>    > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
>    > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
>    > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
>    > > RDMSR will naturally #GP fault if userspace passes through the host's
>    > > CPUID on a non-Intel system.
>    >
>    > This is also better because it wouldn't change the guest ABI for AMD
>    > processors.  Dropping CPUID flags is generally not a good idea.
>    >
>    > Paolo
> 
> I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
> but Paolo's point about not changing ABI for existing setups still stands.  This
> has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
> MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
> enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
> IA32_ARCH_CAPABILITIES is always supported").
> 
> And it's not like KVM is forcing userspace to enumerate support for
> ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
> while I completely agree KVM's behavior is odd and annoying for userspace to deal
> with, this is probably something that should be addressed in userspace.

I understand, no one likes to break ABI. However one can argue that any AMD code
(and even Intel) is supposed to work without ARCH_CAPABILITIES (AMD cpus never have
this capability and some Intel cpus don't either). Also if code running on AMD rely
on ARCH_CAPABILITIES then it's probably wrong. We can also imagine that exposing
this capability can induce incorrect behaviors in the guest like "the ARCH_CAPABILITIES
is present so that's an Intel cpu".


>> I am resurecting this change because some recent Windows updates (like OS Build
>> 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
>> just because the ARCH_CAPABILITIES is available.
>>
>> ---
>>   arch/x86/kvm/svm/svm.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ab9b947dbf4f..600d2029156e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -5469,6 +5469,9 @@ static __init void svm_set_cpu_caps(void)
>>   
>>   	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
>>   	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>> +
>> +	/* Don't advertise ARCH_CAPABILITIES on AMD */
>> +	kvm_cpu_cap_clear(X86_FEATURE_ARCH_CAPABILITIES);
> 
> Strictly speaking, I think we'd want to update svm_has_emulated_msr() as well.
> 

Yes, that would be cleaner. even though the access to the MSR is prevented by
KVM when the ARCH_CAPABILITIES is cleared.

Thanks,

alex.

>>   }
>>   
>>   static __init int svm_hardware_setup(void)
>> -- 
>> 2.43.5
>>


