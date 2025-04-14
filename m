Return-Path: <kvm+bounces-43255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1A1A888FC
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A9DF179A4B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFC7289343;
	Mon, 14 Apr 2025 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U//4uZBw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hsFZr3Ha"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42818AE2;
	Mon, 14 Apr 2025 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744649536; cv=fail; b=oS87IPa7d3uAUmPJyXd0bcBhyVKnxv9OyoNJI9ACJhN+f4WNuup1QH/GKxRIrif7Jstq5V5HI4/ACnpZEo7n7+ubK8KA7aBIlpoDhUJNtV1HA2/Pmr0CkByhNC5whdqoj+Y1pdxd7qZdB1hJpC8RpYZNXqeVPCWptlJ97loSVUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744649536; c=relaxed/simple;
	bh=mnYoQb7BYimv8CQ8fcj+2oe0+MjzpLiOut8cwJxu8fg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tfsyW3t+Qhevoz+4NfmQiEI3GR4utGTjv1jGqZk2w0vzY1ycHjFomafmtqF9I3YqdEIl/zj+3ZMIfeLaU6mDXXoYd2CwFX3m3TZAn0fofyJY93OOEYwGtad85dInhQVz9IeOx7qWl4rzdTZULIEuZwE1/fcD3La5QzUjB2tb7oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U//4uZBw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hsFZr3Ha; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53EEqDfQ020778;
	Mon, 14 Apr 2025 16:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AuerIYTusi3rdrtpNFGCQwcB8cTNY3wf9D9mDwIDDFY=; b=
	U//4uZBwzRVOeOevkEBfGP7MrkkrakgubN1IxGIfFgse7x7ipeT8002mrBo5K0NZ
	OoYURVCoTX8yyBjRKc4GkdQC+VZcK01xNNku6Z5CLBm27ZfssR80FujPWvc8EJDZ
	80ymzZnDbnLzPn+yXOJORTp0tUAQYUifB7137aCSTqgC3vcDiDOTw09CF/68x1Fk
	kERW9ovhEKJ4WPls0CNoZtveM1mw2bodQyzZ+Te1sIG5ldixaCzF1TIrPvu2OSMu
	7v8okDHTOWPse/4RUn4Djb3BszR7zJjjBUC5nd43/hkkROO2JiYnuSqiV8ZMt/V4
	isP2PZz6QsC5pi8Jwn1eeg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4614gf092t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 16:52:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53EFUP47005705;
	Mon, 14 Apr 2025 16:52:08 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013063.outbound.protection.outlook.com [40.93.20.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5u0x8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 16:52:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqEd09sSarmjrVM015jGTK5novaqveo0QHaVFbD5Uocmxd5ui2f/bguXs153gLTwxP6gIG5m4aKXa105srpakUgXr6+TsKrBPD3yUPC0fYo8+p7NFI4Og+8kH7zokL7DeyFNttvi6jVwBiVouM3FeMj51c8t5W2MIuNHWsuSDJ30w3NcGDdDbeyyvEt43tINZ6ptJultxNwIAXky8nL6EyTdRfvanRffPiBTJLtq8lNTP2SCkHJnbeeFIMxmCkixVeIj0Gs13B81V2FtA9l9A1TV5451t96njwQnoY8ZOMyg6VQ9XcRvFhGmvgT1uBRDckYMeJYdktJMAEdjlU1v8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuerIYTusi3rdrtpNFGCQwcB8cTNY3wf9D9mDwIDDFY=;
 b=e8dtPCiBFraWhnnWeusOCF52ZwEjScJAwr3WfzyVLR8MPAjurJLX8A4xOuboW1lsk0jy5Aj8Hf8iPlHr6t+fWrN3iZa4UDmDcfIjwzMFL0shAcWKxlZH0hwounXHkohzkhvT5c8PGnVUsshjGErEiqpDofg/CTcy90fSAujPOilUlS205+/EA8qDxODRMai45IvhqrXARQtPMZgMmqxNPiyYs97sSI7Y0ikGPxB4ewGozXLtqgQQfHWBnIgNDs/icD9Xd0UL8srSgvWM1niHe6b3EwCsjZKiNT7PtxavVf5APjWWLRypqpg6XmDxUxPWfwRUNXv6/6VfmlmfT4v81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuerIYTusi3rdrtpNFGCQwcB8cTNY3wf9D9mDwIDDFY=;
 b=hsFZr3Ha0DTMWZAPbgiWQWvNWY6tYxcDILPv81OU0TqIePTLOFce95wDIEDTkNAHTuOmdPXIvk449JiCEE1PTbRaRuGXHC3QQ15fyQZvvBBst2WEEmQH9imhRwuM5B6hm3a7WeflNhJyNJh8FHJotcq7OhtrCFsAo0mIu48bSII=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA4PR10MB8519.namprd10.prod.outlook.com (2603:10b6:208:55f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.28; Mon, 14 Apr 2025 16:52:06 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 16:52:06 +0000
Message-ID: <e00d882e-9ce7-48b0-bc2f-bf937ff6b9c3@oracle.com>
Date: Mon, 14 Apr 2025 09:52:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] vhost: add WARNING if log_num is more than limit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jasowang@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, joao.m.martins@oracle.com, joe.jin@oracle.com,
        si-wei.liu@oracle.com, linux-kernel@vger.kernel.org
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-10-dongli.zhang@oracle.com>
 <20250414123119-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20250414123119-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA4PR10MB8519:EE_
X-MS-Office365-Filtering-Correlation-Id: 871e7b0c-c79d-46eb-96a7-08dd7b74b038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2tHR2NsLyszWHA2bVQyQkcwMUZiZ0VGMDJMdlc0clZjMGtlaGdwUldvamhX?=
 =?utf-8?B?Q0dsQzNsaWhGUXBwOHFhNEZNbGxkVDNUK1RnbHl1Q3BZUS94SWUwQXY3SUdE?=
 =?utf-8?B?S1dZSzRSRWFrRW4xRkxCYjRTTzJjOXNwSy95ODJFMTkweGZ0MmZWNzFMV2d3?=
 =?utf-8?B?dmRncnFocjhOMHlQbGRPY21EbWFpM0M2cThwZzJuQnpBRlVpcVg1UUhuMG1T?=
 =?utf-8?B?cGVJait0d3RjS3dBd1pBRUJHMFl4UHo5aDNkU05lVnhMRE80bUJQUTZBWXUz?=
 =?utf-8?B?T1BXeklFMklJbUg4MjFpUENtYXRlS3JNUGNRMFBTRDVqdy9EVVViNXU3Q2dm?=
 =?utf-8?B?eVdjbkRaMXFMdFlPV1U5Q3hkZE4rRFlKeXV6cGNJS1JUQjVSMCtERDRacTZC?=
 =?utf-8?B?aWduSWsxM2dHRDROU1o1NUlrWUc4YkxYTFNHY2xiQlhHZ0lOQ2VZVXg3UGlP?=
 =?utf-8?B?UnFTSmNHRHQzOWNQcW4vZHBJR29Oak43ZE8wTXk2OUVxYXhpMDZqZ0EwTloz?=
 =?utf-8?B?ZnJrTStseXVsQmlPNS8vNUR3YW9NejNSTSswZWJvSVUvL1pIMGh4S0dCMFVv?=
 =?utf-8?B?bmtFOTdpeDl3RmZVakkzWmJnMldsV0c2bHYyRHhsSUZOOVdpOFc4eHlhanJG?=
 =?utf-8?B?TFN3UzYvVmtuMzlNMGd4YUozZkZCWU9jbk5vMXZJb2VGRHlKS3VzVytEZkdG?=
 =?utf-8?B?ZzlWYjVNME40b3F0WXAxRWhkeStmWWRRdCtiWTdKVlNaWDYwOGk4NXAxUE05?=
 =?utf-8?B?U25ZZGRTdUNiWm9hbWM4ZzVnWGVzUzFYZ0xnelRyR1JrRTFTU3IrZGZ4WDJH?=
 =?utf-8?B?V0JqaGpyQVRvb2xEc2Q1OFcyeklTaTlPRHN6UWxVajV0M0t4aS9DNG4vYXM5?=
 =?utf-8?B?ZHlqYXdzcWtlMUNrUDhtbHMvY05MMytMSUVudlphUHZKZGE5bm50N0xiNmJr?=
 =?utf-8?B?SXZTZmJNOTFubDZlaEoydEw4RHY0ZEt4RWVJNTNBakx2WWhjYXd4SzJIWjll?=
 =?utf-8?B?SkpDSTkwZlR4c2luZjJNN3o3V0RMVnhYNkVLTmRkWWdmSVZyd3RqWGx0V0p4?=
 =?utf-8?B?YTNCUWhYL1c2KzdEaEpwTUZ1SXBYS3Zud1dVbVhYcEpwSWJYVDR6c3ZWMGlI?=
 =?utf-8?B?QUMxdFZXREVNSUE5MExJS0tzamozaHFGQUFjYlEzZG1OczlibDNXRUdRWFEx?=
 =?utf-8?B?TlM0VnVjNThTWEFTbFViTEdwYTFOTDQ1K2pwM21PZnFIdGFrZ3ZHUFFUeWxV?=
 =?utf-8?B?dFdoTnZYMkJEQlQrSE5FeDhQMGw4SDNYdzB3OEVUeDV0Y3ZsU1RGSDlBRHhx?=
 =?utf-8?B?ZCtrREZoUTNPbW16YW9VVHJNcy9xa3VuQzdBVDFIenJtQmU1b2N2TDVHeUNY?=
 =?utf-8?B?a2pqdVdFRWRvbTc4emVNeU1yS01HWGtBM3RTTlgyNFpOWlVtNXl3RU4wWDhU?=
 =?utf-8?B?SEUzRFpPVWRSR0RoMldFclN6QVk1dzJMQlJFcEkyMVhWajBER1MrQXRUNmVr?=
 =?utf-8?B?M2FxS3ViRkFqNEJCajRjSlEvY1hIWUhLZEo3SjFCRGdxM2VtUTl0b3BDa0xS?=
 =?utf-8?B?NllvQXBvekIraWovVkV5L0RRUjhLZ1BnYUI4QTlwMS8zQXNLcytnNURrQmZn?=
 =?utf-8?B?WmhjQlRJWFcyVUFoSnRFckNyMXFaempxR3g4a1Zjcmx3OE5VQXNESkwrOGNs?=
 =?utf-8?B?RzluQXNJSEZaOU1LZ2ozaUhmR2Q4d2VGSWpETjhGT2c3cDdwWFpwdUppWlR1?=
 =?utf-8?B?VXQ0cWpQeldYUFJTTkN1b0MybGwrb05HZ2Fpd3dUMnVqZ3pmN1ExNVBZVnUr?=
 =?utf-8?B?SCt4Qzl4TUcwcTVtS0xHZGd0ZXdIZ0RlTWxvZ0VueUN4aU80RGFCQTlielVF?=
 =?utf-8?B?UjFDNFFPdUdMU0FEbkhOVUtGc1BXazNGWUNmNmcrWXAxNmo3bGNqR0hURFJR?=
 =?utf-8?Q?poXbKFSjyoo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SG95VlNkYmtpZE9ZNURacDg2c3hZT0w4S09uMkVoUkErQ0sxWUllLzdJR3Mx?=
 =?utf-8?B?c1hWTWRiakJKeHpvUTNvam9mbldqTEJwQ1ZwUlExTzAreW13bWVqSkd4RTNX?=
 =?utf-8?B?cEI1K1lJNjBDRGpha2ZRbUhPaG94K09OMzhsT1VlTytYaWZYRkZvblpjNzJH?=
 =?utf-8?B?QTk3eDYxS01mdDdra29zOCswSVA4TjJpQzlWQnA3R3BnQk40czNxV0NwU1BK?=
 =?utf-8?B?bDhCMkVsSlJTK3BaWE1OV3Z6eUxHMHM0dExaYWp4MTFHVkVONG9pVlp6NzRX?=
 =?utf-8?B?MHJVZWVXY2Z2TGVwUThDRUU5QXp3aStwb2J0RGg2NGx4NGhna1psNnorRita?=
 =?utf-8?B?dTRKRGs0NmNZUzQ1amV6UUtkR3BlT2kxaE9DMUI5bGszeEthY2poTDQ3R2pU?=
 =?utf-8?B?VlpwbXlvSEVNMG9kSTh1aHF1Rmxqang5ZnNyRGNmS1R3WUhpUVFPRlkwZHQ5?=
 =?utf-8?B?aWpzZEF6ZkdrUm05c1JBSVVFOHF1VVpmMUNIMHkxTjB2cVFGL2pMQkJTMkRx?=
 =?utf-8?B?YkhEa0luQmhLREhFUzdFb0JmWVVOcjZBd0pZOG1WS1Job1V4b1BjMzczUnVJ?=
 =?utf-8?B?a1hvUnVFWHBlaEsrUXJsY0o3TUViNmlrWjZ1V2NIMWw3aTZMREF2eVdqSmRz?=
 =?utf-8?B?ZE1TMGRxY0tBbEk0azFLNkxuc0k5Ynk1RzFNdkZySWdlZS9WbDBHbG80c1BG?=
 =?utf-8?B?Rmthc09hSDV2RnIvb2VnNlo1eG8rU1FrT2htTXM0V1JHT2xLTlJqS1ozVXFW?=
 =?utf-8?B?bEY4ekNpT0xIN29KNEJ0b1BVb21rZ1RGOEpQY2lvOHl5WDQ4TTFIQllRU25q?=
 =?utf-8?B?NmRmeEt5SUpJVGNFdUtEelZPNXo4czJsY2FpTmQ2a0MyWW00ckJCbmMyZ25l?=
 =?utf-8?B?UXhySDJLK2k0S09RZVZhSVBOaGNFZmVKSGRud3l1d0o0b1lrOGpyUFV1RW5W?=
 =?utf-8?B?ejg3ZEM4QTI4ZnMxM3JiOW1TQjFNVE9rODlzOEhUMmI2dGdmOFVLbGNxQ2ts?=
 =?utf-8?B?Tm5ZRGRMTjhZb3dyUXdXSWtEUFVlYnRFNTUrUTJLY01QOUV3TEhDT3R3KzB6?=
 =?utf-8?B?a2RNMHlmcmdTakltOXBiRVVreWVIK3hFeDVhRGNzSDRTU2pXRGRSZUhtU0lu?=
 =?utf-8?B?bU5PNjZEaUp0Zi9DcjlZSHcxSXp4NC9DUWc4WEtxME9Ia2h1eWxWbnJvOFE5?=
 =?utf-8?B?SE5EaWVsMzkxS3RCa1d6bEdrMVEwaVhWMnNnS0p2eUFMa1cveWE4cWxlQWFv?=
 =?utf-8?B?MStOTU0yNnVtWExuKy9GaktUVCthU0l5MEVLeC8wTGZrVFZpaVZJSUkyMWtB?=
 =?utf-8?B?dG9NNDFlcjBDckY3SGdxbmNhL0g1Nkk0aTM1WGxaTW1iOEkwTkVNQlhLaFEx?=
 =?utf-8?B?bkNxQlhNc2xINmVMWmdETFZCTG1vbXNrVVBXOGpDODJIeGtVSFl5dTlFOE8z?=
 =?utf-8?B?L2tTMGJJOW93VUtkWEUydEZmV1drQm4xRWFGR1NrUXRZclpYVVk0MWo5N05W?=
 =?utf-8?B?N0dSZWNWNzcybjJ6dkQ4NStPalo2UE9sckxnakRnYUJ1SE0yblhKUDZOdjFX?=
 =?utf-8?B?aVA5OFkyK29GRXZNSzV5UmJEZlFUZDBOaHJlR09RL2YxYXNYandWdzArL2xW?=
 =?utf-8?B?R1BzeXRYRTI0K1Y2SkU3bk9GdTAvOXltWUVZL01jekp5ZXBFK1VGUXJQRzY0?=
 =?utf-8?B?eHl6d0gyUzB6dm01THJtSXgvZUI2Ky9TR2M1cWlCUGFsOXpOZ1pHLzNQYkxo?=
 =?utf-8?B?TnhXTkZHRDFJdnlBdmhTamsxcXVMd3lyUkNGWmlRd2ltSGlYSlhYeGRUR2Zr?=
 =?utf-8?B?RmhzVVBKQWkwNmUzWnJ5TEFaVlVidEt6enRZMCtQbnh5akh1V2hUMkQ3Ymsx?=
 =?utf-8?B?alJXSnM3OXNpbmJlRlFpWjhQanh0UTJHc3RJd2tGVUVaSHRPbFl5MVpNVmFr?=
 =?utf-8?B?ZlpvcytndVZVNWJjMW1uMEp0VWMrRHdtRXg3cXlvSDVaY0thY0FiYjdxWWdI?=
 =?utf-8?B?b0dzbmhXUERlbkRTQU5PZzFUMEtYQ0Y1NnBsRTZFcG8xRytnWGJyU3hyZzRu?=
 =?utf-8?B?cXVQZ0IzN2VTUVJPSlJlV2w5UEhFY0NlUGh5aVhKN1pIN3BMdzRZdXpiN0pY?=
 =?utf-8?Q?9/XGgMtxrVH/G2P7rF8C0/GY+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4GyC47vFP08jigppjsPQ2mkL3D4X0yk4nH9AQUbMLzYqSL0BiZ7fCp0SvmZ14Ps1fxBQd/FlKyo+t8ekewvB5WcKMKDcV0boaHl6unzcEg5bA2VCzScCB8bh9D1ZrwVNYmUWetZLu5JzPm6N9BBNsAcwI0BP4yr7uIv4dQqB7zpuoy17uUvkM+y9OQLEhLI5RiL4aTYUqPU543kbHh3yDqCxbYlicuMN+p2VDZd6OOK4vbaw6vyOevXidOwm81JNBr3GWuGhyTl/a9kzSC1oTUWuFdoiS+etmHUd/p5IHarSAVE0Nu/ZZuga3syqd8u15uYANGcyd/p7h97XrNn3ab4KuRdKDbJ+oDkYxlWzpdI+5Pk1h0+ekdL9B3Kbb89CYfBNang9THUVU3Qg91zo1T4sf0rJCGQDBP81H/rHzPV4oOYnSntYSuG6JyluQH8xDH4aliH8MJSrf53SgbB50bUZbOPd4rN8nN3Rk8tsokw1EtR6mNDCjl/QVypRe9bZKXFh4tdoST1oGZnQW7v8Xj0metJ+ReO22dJfQgDmUBbYT9DopAHyNLpFJgmQBx21wuXTCLOF6ERCkEwgW37D19xj516psLzh53t/qiGjgOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871e7b0c-c79d-46eb-96a7-08dd7b74b038
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 16:52:06.1812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mf3zQOnGK1VbXyMoxWKi45heLQ3Xl7ZIuxSmyxxDk45biParjuTNIIHB3wKfjWnbCkcsyaIemKB+SWifG8OfSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504140122
X-Proofpoint-GUID: DPYoIGFWp_Is821WCPtX5IAKQVlTS6IJ
X-Proofpoint-ORIG-GUID: DPYoIGFWp_Is821WCPtX5IAKQVlTS6IJ

Hi Michael,

On 4/14/25 9:32 AM, Michael S. Tsirkin wrote:
> On Wed, Apr 02, 2025 at 11:29:54PM -0700, Dongli Zhang wrote:
>> Since long time ago, the only user of vq->log is vhost-net. The concern is
>> to add support for more devices (i.e. vhost-scsi or vsock) may reveals
>> unknown issue in the vhost API. Add a WARNING.
>>
>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> 
> 
> Userspace can trigger this I think, this is a problem since
> people run with reboot on warn.

I think it will be a severe kernel bug (page fault) if userspace can trigger this.

If (*log_num >= vq->dev->iov_limit), the next line will lead to an out-of-bound
memory access:

    log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);

I could not propose a case to trigger the WARNING from userspace. Would you mind
helping explain if that can happen?

> Pls grammar issues in comments... I don't think so.

I did an analysis of code and so far I could not identify any case to trigger
(*log_num >= vq->dev->iov_limit).

The objective of the patch is to add a WARNING to double confirm the case won't
happen.

Regarding "I don't think so", would you mean we don't need this patch/WARNING
because the code is robust enough?

Thank you very much!

Dongli Zhang

> 
>> ---
>>  drivers/vhost/vhost.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 494b3da5423a..b7d51d569646 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2559,6 +2559,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
>>  		if (access == VHOST_ACCESS_WO) {
>>  			*in_num += ret;
>>  			if (unlikely(log && ret)) {
>> +				/*
>> +				 * Since long time ago, the only user of
>> +				 * vq->log is vhost-net. The concern is to
>> +				 * add support for more devices (i.e.
>> +				 * vhost-scsi or vsock) may reveals unknown
>> +				 * issue in the vhost API. Add a WARNING.
>> +				 */
>> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
>> +
>>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
>>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
>>  				++*log_num;
>> @@ -2679,6 +2688,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>>  			 * increment that count. */
>>  			*in_num += ret;
>>  			if (unlikely(log && ret)) {
>> +				/*
>> +				 * Since long time ago, the only user of
>> +				 * vq->log is vhost-net. The concern is to
>> +				 * add support for more devices (i.e.
>> +				 * vhost-scsi or vsock) may reveals unknown
>> +				 * issue in the vhost API. Add a WARNING.
>> +				 */
>> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
>> +
>>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
>>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
>>  				++*log_num;
>> -- 
>> 2.39.3
> 


