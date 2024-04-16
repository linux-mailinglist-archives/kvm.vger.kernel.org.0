Return-Path: <kvm+bounces-14738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E23468A6651
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10DE01C20AAD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1481583CBE;
	Tue, 16 Apr 2024 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HQh52zTH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lwVj6QZY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B29A1429E;
	Tue, 16 Apr 2024 08:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713256958; cv=fail; b=Zg1dAYtzSH38siShGmQXdWIB0S9nlWSBWPfohuu3EiaIN+zfH+z808lg7b0s7STiy1lhCMETu0HtIWI9KYRt1Zc0gsg452UkOWykyPx0yvJ2XaAS1shLbvX7MD7C2NfKlodwcYlI+iW//z9EfHJnroQUbeAHhaVieiEMHJVFC+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713256958; c=relaxed/simple;
	bh=GoTgsZ1W0DlxPqdoE86RyGaOyKzSENAFNz+PgATUrl8=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mJd7BMlmw1YT09PSwK5skp7+eDCU4jb+5D2bzN5DUm4CheDJfKIHhz3HBUdWE9MeZqWZ3FVNqDRNAYPXltpv5pJDMJU0TEqHJf1TxlZN1E0PxIzUS8qKcef6nykeZSGg9wnrqvxP/40E3pghBZveMqrdigCN5qRkNQYsX6trd4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HQh52zTH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lwVj6QZY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43G5FUiI028006;
	Tue, 16 Apr 2024 08:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=9e72djZd2DrFRYJhwskkadP/FH0o0k0eUF6mTQXyJSE=;
 b=HQh52zTHvLLTs8Y25E8bZXYgFbyAfKZm6WlK0cs/SCrVcEN9kUQFpIQGdtD+56u5u/ce
 We2+IIiirpOI0zJMHzoltdFANFcMTSKqeZq3Aamtww4LEkZB92RXu5qwuKEr0yDU2XQl
 Y8+dqNV5kfRkeKkHoyUL8Doy/BC9DuamFnhJnOhb2GXx/B8R6sf/L1yavFocmnOhCDNL
 48Z8refhRvET8/nwTSokihR809uhoehqPdG1TONNxfiOGLs3lf5edbbvgy+dF0hsBA6j
 Wblydu89SFnH/dMJ5WjvyQgIblWln+zw3toadcPcXsqTchnPke6d3TdnR0J/drXG5npv Ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgujmrwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 08:42:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43G8Ncfv014292;
	Tue, 16 Apr 2024 08:42:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggd61pb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 08:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4W0SFu6v3QBw4Dl9aNSmRyRCRQtgm/wga1Wl5qBmy1ajr6QBPzxtIRkc4vOXbFV2SXBPvHhS8F5LHUrshg4PSrpcUmgEfoJfk9OMgimB8u1vv1SKvdo1Mdl9TElkh3a+IbHgNQvLGMjO8IjgY/ov3xEE6NcqHGLiIsVvfU5sBZd/n23tLr4bsQqcnAZkh4+bArV32cXJfvBxm7HvGxAltFogmawuMDNJlpcRgpsDz3ILUoLKnzG4irQx06e8MI6uE/e4e0a5LO9sr9v6TMWzeghfQ8+FYzOaRQrTJdza5mKBVAnxSqnosm6bJoLrlZALPy9GJDuviPSWV87nnAh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9e72djZd2DrFRYJhwskkadP/FH0o0k0eUF6mTQXyJSE=;
 b=eMsWWp+m5QRu33aL14Flb98y9P7TPAyEElaPLdCWxeR3km0FLU6dip4SSLfB7FSL/T+bF+oKfY5un/9syYoeUZKOQR1DwpyPhl9Y89BKbTb2dTx4LMXm+d0MRGWVNCNQuTu/P2CXqL05klm9ySw1kWxTM756ZiD8yH8xRWsM0l5i2VCG7PytWZyVdH9mSPLhMXAvm896wGRq6sS7uGki1WxPAW36KVo9vUobH2RDaP0P/Rtk6MJ7hzrbwSXl9VXVj6CsKTfhDphdFVZKqosfxjLwnmWxenO/AusZhYItEKc5f7pekpkPtkUaowCklyt9U/4s3gVwlUldg6Z4bBNreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9e72djZd2DrFRYJhwskkadP/FH0o0k0eUF6mTQXyJSE=;
 b=lwVj6QZYMYqnf4uZf5215RZxmQSIl/4BvjFqINhYHUqvoq6tt2FPpMzK4PIVS3kEIkUDRoWzVuZD+Fij9JzIeyrL8UfVPIJaExfNpdwQf21FqfdYRXDVxKaLlMRIAXP+IeOs2pcTDII4GDg4EzkHGB6TRgGVIOl1t/kcJHDGgNk=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by CH0PR10MB4923.namprd10.prod.outlook.com (2603:10b6:610:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 08:42:03 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 08:42:03 +0000
Message-ID: <2154b190-9cd1-4b24-83bb-460a708a45a3@oracle.com>
Date: Tue, 16 Apr 2024 10:41:58 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Chao Gao <chao.gao@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
 <ZhfGHpAz7W7d/pSa@chao-email>
 <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
 <2af16cb4-32ed-4b91-872b-f0cc9ed92e59@oracle.com>
 <a8af757b-a40a-40dd-a543-99a39a0fe8ad@intel.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <a8af757b-a40a-40dd-a543-99a39a0fe8ad@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0070.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2de::20) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|CH0PR10MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 547288de-c29e-48a5-2c5c-08dc5df11720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	u5uE91GrbLqAD4oZ7R94AnSQ8GpYcXXauryrhC7Wv4XE7g78lJ6gSvfYTichWkqPw6YsqiwOc2y8zoy2D3NHMh8+OTvV0zn9Yg+msHDdRS4PJwnaBLhPic1zIIxFA7OdLjpd2inmrBiA9oH1mD9F60RpzLWhoU4gGTWfkwDSnny+/d+KBBLoLIDYm3UL2H0kT8hUZqv09zitm+zaq3/8S+M4lWNevpFjl+PteZrnmS3khbksI6jsMcUE7wiFDpeNBEPzJgPwU9Qunozimf8duiACYAdnK0V0cAgFrc8/6M0D/ipjRKAqPz5nypf2hd+TGHYLvfBFbLnOdzZWzGA6Gd9u5yYRyOnVXzcsPvRL9q/1ukv+IDYeHeYboEQzZdDfIOI8T6/aNQVITEerwSsuKLFxSvFFeFU0CfhyAuitOvLDwYvSUIKw5i3fTY1HbSzJa8xZtX1TgyxcvOaX0Q0ZZCKNe7RWDj7kQE/x8L4Vfie3rYZqOeGZAn003jozlwEWtyigbsjiVrppExmfdxLT0YPii2livLovAHOjpSHJ4yX8I8hFkRHFcVGd7EJi2nexigDJdbQjR2r/gcFgtelLqymg9N3eoGkV7rtb33BBLwiIn1j4T3Mm8WKljATZzbI1VUP0SgqBHlnd8IdRiNard1NRsJt7QMBjh5F/5AiMX9k=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZXFJOExzSEo5R1FnZmtUempQalgrb2FoUm56dHk4Y3NnS0c5U1FWTzJTZnBP?=
 =?utf-8?B?Ymh4bVFZemxxaDdqVklHcDBBUGt2WllaL29mcjJaY01QZTNxZm5oNUVZYTRm?=
 =?utf-8?B?VDZaVFNLQnJiRW8xQzVzL05JSFVmZE5sOXJVSTRBV0tPSXlhbFhheXF5L3hp?=
 =?utf-8?B?ZXRNMXllekw5WStTbWp0WTc1TjhQRUZYWVdSQ1loMDgrNHZrOGxxRkpudFNQ?=
 =?utf-8?B?bHg2OEt0N0tMMlpWbFcySGVxeVVQMHpRNHZFdjBrV3FPNjZ3aWRBZ1BxVmJR?=
 =?utf-8?B?NGVtb09zZ0JmV0lPNjNZR08wL3pyM2RDeDFZUFZqUkNTVk41c2NUd3BUdytF?=
 =?utf-8?B?bjB4a1FJbkk0bGFLVmtHNE5YQS94VnRDYkJNTjM5UlRha0hWamEvSVFiV3cr?=
 =?utf-8?B?UUwzVVhOTCtFUThuWmE0aDh5cStpRkcxVlRYVm5XL3NaaEk2SDJVZVp3Tk4z?=
 =?utf-8?B?MnNpZlk0RW1TUWJnMHJQR1psTHdhK2xKM1dzY0UycjFDWHQveWR5ZkJnZjFN?=
 =?utf-8?B?czM3Zm5rSndhQnpydEpYK0oyOXdkM1grTHhyNm03bzFsWnNBN0FHM01nbFhJ?=
 =?utf-8?B?QTdveWVobXVJNHJNZThGNFBHSGpLeVFyT3A4OWdwVHVDMTcyR0JFNDNKcklk?=
 =?utf-8?B?VnZ4V3h2TTNHUmFiRHRCVFdETW16M20zQ2d0NGRyTWJyWDNyU2hiL0RpNCsv?=
 =?utf-8?B?Q1I1bGNrR0tRMW44cEIyYUV2U0lLdVNvUytaRW1LQytQMDdvZzBEa1J4Q2xQ?=
 =?utf-8?B?RDc1VDYyb0EyVHhHVVN0eTJqZzluWmZnV3pBSEdlQzAxcU1vU00xR1VpT0FK?=
 =?utf-8?B?VkFQMU9ycGlSdStkMG5VcnBYY2hFRmVnb0VMdDc0N3lkRjBGY25iekJyQ1E1?=
 =?utf-8?B?UWhocktWaDl1MHR0aUVrQzJkQmF6QXZRaDVQMmxhL0FqOVNmMk1jNVR3Uy94?=
 =?utf-8?B?SXVWNWJLTUNKZlE0T0xKUlByWlBjanRLTWFzNkZRMjB1OWw1Z1RUa29vS1Jz?=
 =?utf-8?B?V042MlFENEJvOHdDWGJKWENKYk1VSHFXSk5ERDJTdlExMXFvc3o2SUd6U1lV?=
 =?utf-8?B?MU1ZdWZ0MFZwcGtKMTFsUnFnM21INVRla1JwT3BTRS9kQ0orajlCSGFPR2dv?=
 =?utf-8?B?U0VXTHVVWDVCbnJoWEwyZlBPTys3NTh3TWFBL0RxSjAyT2NVM1VHQkpYZHBq?=
 =?utf-8?B?WXF0TzltVjUrQmpPRnNlRWRVZ1JrMnVib0NLZTdCTGI1K3hCQlBraThobTFM?=
 =?utf-8?B?cGpEZU83RmxBemRaMXRMQ0luWnhQRVJmL01mRGY5UkdqVCthVXUzNE1lb3JU?=
 =?utf-8?B?cFhpVE9UTE12Z3ZmZ0JvNm1DSm42dG5ZalRSNGJxdXc4UlRROFF6Q1oyNFVS?=
 =?utf-8?B?T044OC94VGg5MThUMnFMazVGK1c4YTZxS2M5cTc4bWdQOGJDNVh0VW1YTHpn?=
 =?utf-8?B?dkZQc2h4dDNTQUNsejhCekZWK2ZsWlpVUTJSMkMwbTNUR1M0VWJhVGlwUWgy?=
 =?utf-8?B?b2RBZXZJOVkzbWNwdkNTVCtIYmdRSVJlUzFHcDlnZXkySXVSeXlBZlNPTWJh?=
 =?utf-8?B?Zk1GTkd6VFcyd3A3cm1ocU1MdWpNcmZiMWtnQk1aQU9RTit1ZUMvUFFhZnp5?=
 =?utf-8?B?aGxsdnhhYzVuRjBvdDFjVGtMZFYrdzF1cHRRTCtMczMyT0ZsN2V2L3FNY0xn?=
 =?utf-8?B?VzRuT3lzQ0E5YXJaMGtESmFXOUEvb0w2WjVicitUa3BJVUtBeE9ZWWE1SGkz?=
 =?utf-8?B?ZDZoVm1SMkthZ3liaE4yQXlVWTN0TjlVZXVzWUdoc2NyUGVKVXZ5aFhKV2lj?=
 =?utf-8?B?Z2k2Ui9uTXltOXRKVXFyRkd0ZXpkWDVZdUZXRHJ3T3ZaNVN1NWJBanovWDRB?=
 =?utf-8?B?aGNoeER0OXRnN3AwbllLb3owQ05PZ2M1dHdLNDRySndHdnJvUlBpVkxESUdp?=
 =?utf-8?B?YkErQXdHZlBFcXFIWGI0UmFrQTl4YTVJVTZRQ1dlVlJKZEYvSEdOdE1GQy9v?=
 =?utf-8?B?NEVCNW9JMDZTcjB2S2JZUWExV3R2Q0xLQ0RveHVySnJoN1JjUHpCdkl4d0I0?=
 =?utf-8?B?OEttb1p6a2JyZDVQMkgrZXNUaHIxYnVuMG5JeUp2VVZPWFNOQjBDMDZDSWpi?=
 =?utf-8?B?blBVUitvMWxmNHVWZzlDM25jNi96YWhaR2pVbjVHcHQ2Uy92VnJCcnpYVVdR?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7/8cZvrnq215svJCWbEPLUC5b+QKwSCIN7Kfzq7UpDTw3K3NLk6qoIIIjcCtO0iOfXhkOZzwOepA4Zm74CIwmT92v+VUZJtze042S44woL2Wo55UoSjT+Rujhskxn7ecZK2D3raRWGkKKarh0g1k0xQsc2y/RA+TWn9PXBpOyHLcEdlF4qMvGzZu/CWgjZhMo+b4P7WKMx5/aHJWhvRgKL0yy4TwQU5QIBDiWjtq2Zv64DZHu5CNR7o5jHVrKpReZ+DhInsdbmgHvK2qVoPTUJNkc1bRlrIStfn39hZ6dNiXIS9G3jqbqdcqrT4qOMGrd19Dobb1qkmyQ1wGx4SRnCiUIDkzHZ62hArMdiRPJEmC1MlTT+QRUp8Eswf+VSVlAcXL3ETzDTCQSC/lZzJWr2uQXmHkghagbAFgpktvgFWMZ0QWvo/2hKbeVyoE8/zwp9gQJzxzMngY0/t2QNiAOVNH3ewPH/ZPY4yTjeNbO/OSysE4zoEp1DuuQIt1tuQrHgMyIR/sVszeW9G7sgkKq22vhzlIIV+Da5o8dZsOZyn9c/dfAjU/QfNZRB0qNxrsPlC4wldw2f0MGFRUjjZIAthoN6+vytDUUj+GJrhxg4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547288de-c29e-48a5-2c5c-08dc5df11720
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 08:42:03.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSBAgvx1gVliBK8cU2PfeFqvnz96oooh+5Tvj6IpaU3GlZ1iFSUd/B85FYudOHU7Z9WQ2Uq3Eho/zdgkHkqB4GM/GTgrvKzj3g8Jykp/eXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_06,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160053
X-Proofpoint-ORIG-GUID: bK9JvDHSLXjHmGBkyy5VbPSmANRqoldY
X-Proofpoint-GUID: bK9JvDHSLXjHmGBkyy5VbPSmANRqoldY


On 4/15/24 19:17, Dave Hansen wrote:
>> +       /*
>> +        * The following Intel CPUs are affected by BHI, but they don't have
>> +        * the eIBRS feature. In that case, the default Spectre v2 mitigations
>> +        * are enough to also mitigate BHI. We mark these CPUs with NO_BHI so
>> +        * that X86_BUG_BHI doesn't get set and no extra BHI mitigation is
>> +        * enabled.
>> +        *
>> +        * This avoids guest VMs from enabling extra BHI mitigation when this
>> +        * is not needed. For guest, X86_BUG_BHI is never set for CPUs which
>> +        * don't have the eIBRS feature. But this doesn't happen in guest VMs
>> +        * as the virtualization can hide the eIBRS feature.
>> +        */
>> +       VULNWL_INTEL(IVYBRIDGE_X,               NO_BHI),
>> +       VULNWL_INTEL(HASWELL_X,                 NO_BHI),
>> +       VULNWL_INTEL(BROADWELL_X,               NO_BHI),
>> +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
>> +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
> 
> Isn't this at odds with the existing comment?
> 
>          /* When virtualized, eIBRS could be hidden, assume vulnerable */
> 
> Because it seems now that we've got two relatively conflicting pieces of
> vulnerability information when running under a hypervisor.

It's not at odd, it's an additional information. The comment covers the general
case.

When running under a hypervisor then the kernel can't rely on CPU features to
find if the server has eIBRS or not, because the virtualization can be hiding
eIBRS. And that's the problem because the kernel might enable BHI mitigation
while it's not needed.

For example on Skylake: on the host, the kernel won't see eIBRS so it won't set
X86_BUG_BHI. But in a guest on the same platform, the kernel will set X86_BUG_BHI
because it doesn't know if the server doesn't effectively have eIBRS or if eIBRS
is hidden by virtualization.

With the patch, the kernel can know if the CPU it is running on (e.g. Skylake)
needs extra BHI mitigation or not. Then it can safely not enable BHI mitigation
no matter if it is running on host or in guest.

alex.

