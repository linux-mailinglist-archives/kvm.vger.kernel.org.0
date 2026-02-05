Return-Path: <kvm+bounces-70360-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKMrGIDghGmi6AMAu9opvQ
	(envelope-from <kvm+bounces-70360-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 19:25:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6413F66D9
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 19:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C49BC3010BA3
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 18:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD1C3081B8;
	Thu,  5 Feb 2026 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IQx3v52R";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IQx3v52R"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013022.outbound.protection.outlook.com [52.101.83.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B95308F3E
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770315897; cv=fail; b=YxUCdnZbkD/RnXU3M/iElqJ1/ugu0Ya4QQnmJOMW6wwxT1T4h7ePYKpV/puK545diFyTMntU3Sg4y5Is56Q+S/sI/SadS8ql8VJENneU+BvoS4V4zf1spzsSZ2RsDRyFH0z91W4VaIeHxFXozRrTF1Q52FIUf/ME23IjPzeXRYE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770315897; c=relaxed/simple;
	bh=/56MIveYP3VtnBKb3u6WF4Fq7KFy0lSI6AWPsXcNGOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rt3rJl6/RCKnGM9mXriHYgCyPB8UM2wXXbVsxtgwiu3qIIRUOW+/DgHExVHVCeGqHCjLBIfp+sheY3vEB28Di4m77ViTn+djcsy4T3L4iG15bPUcICNEt+kmzJAWz2kaOyOFvV6V26AWi/79dPdHURH+kc82LkbjrNYrwHqoC3w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IQx3v52R; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IQx3v52R; arc=fail smtp.client-ip=52.101.83.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iYVSpaiffZaFBFlKoIYxLIIVlgXGRUFJBpl4D52sXgEdi//V3dzElbx6j/GUVD3XwRP4ebsHjQ6iL03eisKWY+V9DkH8fZTNVEM1x6kc4CX7kWZDjj16kJ1XKpZo1EBs+VDoZqIoZcLSITZMZXTy3Iq8UGxJp5MvjlgyJDheLZfLz7hBFdmzFXZ02SqQ856GXJ5Hy6l8Fq6geQJh7WqjAKBClIQQHZTOD7HkVgNXI88+s456GJreuW/xIae7V3PPw/EiQEqL/OmBuDGEB3PPpvKHIss0dwKka9hO1Bbe0iymel3/0wpQfMb/dnZ6rRRHPg8bn1WabbbooJd/j8lJRw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/56MIveYP3VtnBKb3u6WF4Fq7KFy0lSI6AWPsXcNGOA=;
 b=TQ37HcX/GjKfAHrZJkZrdpanjGFLrWDDNkF+imZD5icPU9Vqi6ssC/It24vNRP/p6wP5QcpyGn7wtLqvcoYGMZKqKA0l3IiJyFeitDGO6IDSlW+ureS1KY+kS71BCsLH6EXC7Q3EwEGAreLDm8rkmxxmZoNkMiCrOVZsyRKEiPYtz5TVUWAtVc/PhSxFfRmSPGsy0f6cQIRg9ShSXCpmyNovNMn7laLzGx8wyL4F0IPuvNhl42gyqS8vFpNIwVowRY3vI5zkjqwaMRMGox6ParHi1nwIxOpILtW5IVVo9c5btVvPbKn4KFH3KEBIKhiiMhxBDpY3D3xvTm4YQyUsZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/56MIveYP3VtnBKb3u6WF4Fq7KFy0lSI6AWPsXcNGOA=;
 b=IQx3v52RDhZ+dwREkW9QPboAetqglG3/Gm8w2dx54LOop4/m8YGBQpFJq1YtWstZ1EDpAZS1LxXrXVYhHkkvP4CplWRABvCQqyQiMZq/HnUvkPJfjWqwQAVep4Ro0EdZTrTmgbpOacQPgej2dN6GrH8w/mL96dUO9K9PtCEc06A=
Received: from AM6PR10CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::22)
 by VI0PR08MB10582.eurprd08.prod.outlook.com (2603:10a6:800:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 18:24:49 +0000
Received: from AMS0EPF000001AA.eurprd05.prod.outlook.com
 (2603:10a6:209:89:cafe::8f) by AM6PR10CA0009.outlook.office365.com
 (2603:10a6:209:89::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.14 via Frontend Transport; Thu,
 5 Feb 2026 18:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AA.mail.protection.outlook.com (10.167.16.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.10
 via Frontend Transport; Thu, 5 Feb 2026 18:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fT5Ds85R7anVJWNi/4bsbTWdAmRBa+Lo7NmWso+fwY9RUpxdFILsoVDo82AxqdOKCr8/cJC0UK7r9ZLzCIuTJcENrTd1gok3Umn2HMVejA11NFw0Jga2VmbkVoBvV7B324g3gv9s4TloQljyA7fr0oxRzHTkRLBEO9rmVcmj6oBdgpxz6ei2NRb/2SWBg0fz8s62dZdNspRPdnsSl6Mz36xbPRWHYM6qhhzXKu2lj+1mFSIneqXuMZ5rIBqQRnSVDBb3tXW8mUSDHpl/SfzY6SrAK07A0xHATwpMD+P+kd+lpZ7O1tPJoixs70Zo3lQrCybGZRx4dxt2Z3f9kxe6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/56MIveYP3VtnBKb3u6WF4Fq7KFy0lSI6AWPsXcNGOA=;
 b=bSnaerDyRUZNfNGsTGIPBaW434Drd0EScQ145WEWkfa8TSh8lUPDi/YUAnMy7lfXKLHltRfjKjByVbBRWoOF3cp2eo2CcUU08HdacAWpQF/qpUn5cyjnFq5+NuInX8PVbEWloFWw8pbSHiJUh2m8WAiPcYCjLFJo70t97BH7EcNsThDgqRjHes+hgDrt1K2VnMiiIOdyB2mHq+Z7VgnWIEcCpo1JRRCMj/vl+my2S2vDmpCVWy3JfiwhD0F09hVGpuymSA3EjIqq5CzVDRNfgMOAAc9Su56YUSgUiJ2jjy8d/tXcJ5UZhZpmMcEl/glViovobai7lL1TNil7dJCq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/56MIveYP3VtnBKb3u6WF4Fq7KFy0lSI6AWPsXcNGOA=;
 b=IQx3v52RDhZ+dwREkW9QPboAetqglG3/Gm8w2dx54LOop4/m8YGBQpFJq1YtWstZ1EDpAZS1LxXrXVYhHkkvP4CplWRABvCQqyQiMZq/HnUvkPJfjWqwQAVep4Ro0EdZTrTmgbpOacQPgej2dN6GrH8w/mL96dUO9K9PtCEc06A=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DB9PR08MB8578.eurprd08.prod.outlook.com (2603:10a6:10:3d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 18:23:46 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 18:23:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "tabba@google.com" <tabba@google.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "will@kernel.org" <will@kernel.org>,
	nd <nd@arm.com>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
Thread-Topic: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
Thread-Index: AQHchxWUk08/e9r09kyClrbSyi16srV0DneAgAB8foA=
Date: Thu, 5 Feb 2026 18:23:46 +0000
Message-ID: <0015e5ecd6e9170184ae7309c48f09ae5d64645f.camel@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
	 <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com>
In-Reply-To:
 <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|DB9PR08MB8578:EE_|AMS0EPF000001AA:EE_|VI0PR08MB10582:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e99f75e-ab58-4ddb-cf70-08de64e3d8d0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?R3lOWVVkUHRuc0JrdHVWZUl5Uno0eFljamppMHgyWEJpM0tjN3k1MWt5TFNG?=
 =?utf-8?B?emdEV3lMMEtjc25KbW1LZ1dORFdPU0ZUaTREVnF6c0JaM0JTenJWdm1XY0tE?=
 =?utf-8?B?dWxpSXE3UEExemhlYzlscmFkU1F0YjRVenNvR1VOc1MvRW0wbEl3bnZ4Tytq?=
 =?utf-8?B?VWgyNEJEM0U0dnRCSU5qV0pvZHVrbXJGMlM1N0VTQmRacVVPTk90bUpzWmZa?=
 =?utf-8?B?NHhFNnFHVFdrREhYY3ZGb3diU3ZqSG9xYVgwVkxuWUJNMFlOVng1eWtiRDV3?=
 =?utf-8?B?c1hQclMwYzlkYThZdWl5aDd6YXpEbXVzamV0amRXNnRyN08xRjQ1TysyZUN4?=
 =?utf-8?B?MnErdWtsYzA1V2VvRzZHUCtlc2g2U2Rha2JnVWorUzdWb2ZnZWorRlVvTXJS?=
 =?utf-8?B?cXY3RkdRZ0xab1k3aUl4akdocHpVNU5KT203MUhnRm5mU0RYVG1vQXRnWStD?=
 =?utf-8?B?ZFNNVytMZHdDdGVRcGlxS2x2UUdHMGthOHBxdDBacmpYcVh3UkU1NHBET0hW?=
 =?utf-8?B?WVNLQUZ6akdBYXVkM2J4Y2lHdDk0SjhHSDczU2ZCWUN6QlNvQURMRExtVi8y?=
 =?utf-8?B?VThZeThsa0VObXlJZWVzeFhqTDZLcndEblQvQ0NhdzNQczdlTUc2K0ZibTZQ?=
 =?utf-8?B?dmo2RXVhMFNIZkZxcFBpWGpsWlZ2R2YrZ29hUlQ0WkhLNjIwL1liKzZ3SE9r?=
 =?utf-8?B?a0t2MUNkKzEzN2dBRTVYU3ZCNUpMUUgyMmFpSE5TWE42ekZNT0xWMU1RWGZI?=
 =?utf-8?B?TVhjRVBhV0pOWm8veVRrb2VhRVRxbnBseS9ySHdaMG0wSjF4VEhFZ3lhUTRN?=
 =?utf-8?B?Z2t3REJHQUVWWktaNFdxa0lVNHIybXJuU05RUWZJd0pUMzVvVGw3emJCcFBr?=
 =?utf-8?B?cXE1aFNTS2JCUThqM3F0cmRGY2dOckEzb0pUMCs5TlZYV2x1cXhKQTdkWnJJ?=
 =?utf-8?B?WHRYeGxQU3JPUU5Xa0VFK2J4THF3bzgwTHhFUjJGNG9PSDF0MFRxTitNUDJE?=
 =?utf-8?B?eUxxTEU3cmREN1NPdnVyRWlnNC9oVktnNGFjTDlPMm5ENkI1WUVIRWZhaFJ5?=
 =?utf-8?B?SHpuZktuT0czbGh1cGpKUFlVTzlnWkFRRUkyYzBJVnQ3Q1ZKWGpJVUltaE1v?=
 =?utf-8?B?Sk1CWDJOR0hpbnl6Z0FvbXFLb29ML0o5bnQxb3pkVmVwRVJOcFlTUEoxWHBM?=
 =?utf-8?B?OTd5Y08ybnpybmY1a0ZaaTRkL0FubGF2VUFnWGtheUFpZ05hamsvSlFQUE56?=
 =?utf-8?B?R1NBN1E2bjlxaDRpeE9BWUxnY0l1UUpWNHp5d1hZcThKYktOd2dJbU5SY09G?=
 =?utf-8?B?Wi9mODNLQWt6MUl3cVJzNUxDUEV5cXlkRkdOMlNvL05ZcjNhZkIyQ0Zrd2lP?=
 =?utf-8?B?K2d6YkdSbzQ5MVhZZGZicWRQR01VR21BRVA3RFZUcjBWN05sRzBHakFGbDBE?=
 =?utf-8?B?TWpua25BUkFCR05hNk42MlBIdlhmVi9PQUdKdlhiWm9TRFR4VDNLTVl4RDgw?=
 =?utf-8?B?Q3NyTEluNkNYUWsva1kvRFo4TzlyTFVycjhhbmoxNmVEaEJBRUtFNlRKUDlX?=
 =?utf-8?B?bnNyeno4LzNycFFYbHpiZi9sTHhybk5NeFdLUHFFaXdtOG85d0xFTkpoeG5E?=
 =?utf-8?B?ZTF4b2FTcU1UWWp1WDAvdWhYWVI3cG5mQWpKVW1CYkhRWmU0WG9pRENFMGNk?=
 =?utf-8?B?ck9DbS9oV0c0QkVlSnRKK2kwNjhMa01ESGdVb1I3a21BemE1eE9GTDBSRnJD?=
 =?utf-8?B?dmxHbDFZYklEbHVZb3dHQnowZlFHYjFBOHFuRVJxNjJDUHZ0czZjeWhJc2Zw?=
 =?utf-8?B?WndONU9nRE9TeG0wSk9pTkVaU2lYNlBNbGZmaGo3am1wZWNFMVFaTXBXV2tF?=
 =?utf-8?B?OFhkdU9oelVwbndzbSt5TkpYeWJ0Ulc2RnFzUENCUmtqL2hFUkw3QmJiZGtD?=
 =?utf-8?B?Ti9vSjhRdWJndFZZekgwWlcrUFY0YWw3c1JFaVBRbFlvQUFDejFSRVROUGdr?=
 =?utf-8?B?Rmk3SWRpaEQrVEQzMXd4SFNmLy9RRGIrQ0lIa3JONk5QUU9IVkxHZG1Ydkpr?=
 =?utf-8?B?VGpVbGFsOUFZMDNuSnd6cXhJQUlHOU5rY21xK25LNlVvOGw3anJKK0FaU3Zm?=
 =?utf-8?B?UUpZaGlIT1Rxdmp6bC9jdzVERDdsTERJamxNQ2xDMWR1cW9XQmgxNWVURElT?=
 =?utf-8?Q?/mwYsTNlAj5MuFEqNQD8ClJIF7VLJXT0/vokzOvUtXeJ?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF4A058B483720438EF375B2515AF365@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8578
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AA.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ec60d799-2f95-4799-2865-08de64e3b359
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|14060799003|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1BGT0FTeFBROGRpMHRhaDBFQ1hjU0JVY1REMndVKy9XdXk1Z3A0WUhQeUxW?=
 =?utf-8?B?SCtVVVMyMmtRZ2tOSHd6UUNnY3VEaFY1eUw4eDJMWEkxRUE0NGJhOGR2b0VB?=
 =?utf-8?B?MklZRitLN2p6YmFxajJTb01KbWtuTEFlZGNuRVQya2pPMmthc0d1S3kvWkp0?=
 =?utf-8?B?YWVQcERVZFk4NEpFdzRVbXorRjh4ejlxZGRxWms2UXFRc1VhYnJ0cUc4R2hs?=
 =?utf-8?B?N2tMNzBCY01lYUgxbHh6bTFZZ2p2SFAwalRlTEZGVTJLQ1RlY3BWaDBhbzlq?=
 =?utf-8?B?K0xLNlR0eXJjcnFyMy9yUUN6TWJDbHRFMHZqeHBmL1hUQWk4bk45OWZPdWtH?=
 =?utf-8?B?bWV2ZXovMkx2QWYyblZIaE9lWlBvTGtZN2M1ODI1UkJ4RitQclBwcG5WUHE2?=
 =?utf-8?B?TENpTEhhN1NmczYrbC9GejJ4bVdRR0VXYWFhaGg0djRVRTkwaFJpWklyNFVS?=
 =?utf-8?B?dUpJa2tBTjYxZFZMNWQrcldEcU5qR3AveDFONWdpWCsrSGJjUDYraExTdzd4?=
 =?utf-8?B?T2JHZ0JVcXlib2haRlQ2ZlNoUG16SXp5Q2Z6UFlUNGc5MVcrQzVEMHV2c3F0?=
 =?utf-8?B?ZW41RXk5WXVUa0drRmNsK3JtRWljNDIyckhPTjFTVThOcTkwaEdzZzhWMS9R?=
 =?utf-8?B?RlBlZ2NIVTA1ZUFLUExKdmRrTFE5YnZsTUVoc3EzeVRmTnk2L0l2cUU1WE1F?=
 =?utf-8?B?L0Jib3RGMnl1YnQyTXhwK3hsNEtGaDB0R0hVR05Mazk3TTZGWlJsTzJhdnRW?=
 =?utf-8?B?Vk9UbUNwS285cVAwVXNmZ2JCSmZiYVE0K1VYS2pBMjZIQ1Y1bE5KU3V4YkU3?=
 =?utf-8?B?Y1I3ZCt2YTErUC91SEtBVE5jYmtncHZjakZpSWNvK2l1cWZCZWxVRGt1YjEz?=
 =?utf-8?B?WlpDYURsUXl5YnhHdFc2c2t2RDY0d3ljbHgxRE1JSndjU3prOE52MFBlRGg5?=
 =?utf-8?B?S0tzN0dNQ0RkRnFKMDBITVRvQnpnTmVLenBORUl4SDlwb3lWZy9xckZLN3Zl?=
 =?utf-8?B?Y1c4MDVzekhScTN2bDRUcDVGV0d6NmlOVWdlSkdxamg5VHlkZ2w0ZS9DaTRn?=
 =?utf-8?B?Nm43bCtMN1JjZmhjQU53M2o3Y0QrTDZLUVR5TEo1dlBPdThUWlVCWlhEQnE5?=
 =?utf-8?B?WmNMTjQyQ2ZGNFBMU2orQ3ljcXdSQi9nU2NoWGdTMXZSL0padm4rQmEvNU9w?=
 =?utf-8?B?bWxscENCL2RtaElLNzJKSkh0aUplZnJucEl0WEM4MkRKbzd1UlBvQzBqaEZm?=
 =?utf-8?B?bU5aSHAySTNTcENaZXpUaG85dUE1d2xQVFY0UEo0b0lXS1hYZ1ExdmxmaEJL?=
 =?utf-8?B?eXQ0VzZWS1VzZlhnRjlYT2JiTzh4aW1aVUpHckVjOWxhcFF5K05DTWhTUTl1?=
 =?utf-8?B?MnI4WDZEZlAzNUc0OU0rdW5TUVU1UXJFZStCejRhV2sweEZEaVg0ZHhWOWl1?=
 =?utf-8?B?VG1FeUhnc1hwVlpXZTFPdVNXS1NiNFJKOWthY2pNb3RqS2lsejF1ZVFkaTRW?=
 =?utf-8?B?dG0wYmtxL05ha3hhR2tuRnlYWSt4ODI4d1lHZm5aMUM5NWRoVnFGeVNlL2Y3?=
 =?utf-8?B?bXNLSXVwbU4wemtEbzdYbG5yQ3JsdW1vK0gzVzBZNU1CYVpLdXMxR3lmb09m?=
 =?utf-8?B?V1Ewdk1YWk9rRWVZdHEwZUgvdnFHZnhKS3lIY0M3MXV2SWVkaU9TN2lybExk?=
 =?utf-8?B?Nk90RHlZUXpDUVVVQzB2Y1lpNHE1ZWUvMTFyZjVDL1FLVnQ2YTRTSTFNOXlI?=
 =?utf-8?B?NThPSXJYNjVmYWh0MW16NUhXWE1iVEZienNjUnhGREsxWElHV1o5dXNIZVhx?=
 =?utf-8?B?WFg1QjljTWxnQXNzZmdhUkc4b2paenpGR1JOdmpoWDc5UUhjaFVIU0ptb0Fz?=
 =?utf-8?B?aFlXM0lYdk5TYzNQWk1KdWZIaG4wS3gwUWYvSkdoOGNhRVprN3ozWHNCcS9u?=
 =?utf-8?B?R2xtaEZiMlRUbFFNU0VqMWhUSlFYaFVpN2Y0Q1NVZWgrUS9mZUJzRkxreHd0?=
 =?utf-8?B?Y05UU0pKbFE3OHJLRXVDTzdHTldmY0Zpb3RwVWZDQkpyU2I5NHNPd1hvNDc5?=
 =?utf-8?B?ZWs1UHNGYUVkUXpUbnZzZ2djeEhMWmxVSytuRm1pOGtOZlpRRHhBQnY5TFY5?=
 =?utf-8?B?MkQzSTFJbGc5Wm5qZjR6VXJjdTNjaUVjRUE0c0o0U1JkenhvV1Z6TkRxaGts?=
 =?utf-8?B?ai80WFhyVDNIVjVFc1A5U092eHpKQkk5RjU1T1dYRjM1bkNDYzl2TGd3Qjg4?=
 =?utf-8?Q?v4wmg54LI+EXD1yGRvYW16Ot1BPo2t/k7zR+EdeogU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(14060799003)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gqgKJF7PDqkclz23vzuALJV/E7rTmIpnDjk5hym7h3bkVY5a3cZMIym8Xbw2vc8vu/s9X2tgHN7D9R9jGB+HEkXwaqgpcp0J++Lp8XNX0A5ET7ircfFfmBR6mQ/GJVheYCizAV4qCGO6B3M1N1L+kn2QKoChbKBgPdAw6hVOkkJ1KnSrlPFJcIoWQFGMVT9DgKk/QO7o0/fJvzKsgsmUCcBPJf/JcbMeZTx5I68OD4XRA7ccqMs512cE+TRYbJRzP3H5hpnfJIOa3Dxbt49Fi9yaXdLE20GtVmMeIGzV1I+2HqQdmUS4d5KskEns2HHfS9/Nv3OJuXj+WQJpm4VsiqPlWT8mnDd/L+HC06NegPzuiIKdsRVFYSztrE6ner+ehDvaf6YCcsO87sGI5veG2awmARqMoT7V+o0kXKnPmcTt/sm4hCrUaUvmhDlpZqlW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 18:24:49.0134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e99f75e-ab58-4ddb-cf70-08de64e3d8d0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AA.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10582
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.linux.dev,arm.com,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70360-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[atlassian.net:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: C6413F66D9
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTA1IGF0IDEwOjU4ICswMDAwLCBGdWFkIFRhYmJhIHdyb3RlOg0KPiBI
aSBTYXNjaGEsDQo+IA0KPiBJIHdvdWxkIGxpa2UgdG8gcmV2aWV3IGFuZCB0ZXN0IHRoaXMgc2Vy
aWVzLiBEbyB5b3UgaGF2ZSBpdCBpbiBhDQo+IGJyYW5jaCBzb21ld2hlcmUsIHNpbmNlIGl0J3Mg
bm90IHRyaXZpYWwgdG8gYXBwbHkgaXQgdG8ga3ZtdG9vbA0KPiBtYXN0ZXINCj4gYXMgdGhpcyBp
cyBiYXNlZCBvbiB0aGUgbnYgc2VyaWVzLg0KPiANCj4gQ2hlZXJzLA0KPiAvZnVhZA0KDQpIaSBG
dWFkLA0KDQpUaGFua3MgYSBsb3QgZm9yIHRha2luZyBhIGxvb2sgLSB0aGF0J3MgcmVhbGx5IGFw
cHJlY2lhdGVkLg0KDQpJJ3ZlIHB1c2hlZCB0aGlzIHNlcmllcyAoYmFzZWQgb24gdjQgb2YgdGhl
IE5WIHNlcmllcykgdG86IA0KaHR0cHM6Ly9naXRsYWIuYXJtLmNvbS9saW51eC1hcm0va3ZtdG9v
bC1zYi8tL3RyZWUvZ2ljdjVfc3VwcG9ydF92Mg0KDQpJJ3ZlIGFsc28gcHVzaGVkIHRoZSBteSBs
YXRlc3QgdmVyc2lvbiBvZiB0aGUgY2hhbmdlcyAoYmFzZWQgb24gdjUgb2YNCnRoZSBOViBzZXJp
ZXMpIGhlcmU6DQpodHRwczovL2dpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9rdm10b29sLXNiLy0v
dHJlZS9naWN2NV9zdXBwb3J0X25leHQNCkN1cnJlbnRseSwgdGhlIG9ubHkgbm90ZXdvcnRoeSBj
aGFuZ2UgaXMgdGhhdCAtLWhlbHAgbm93IG1lbnRpb25zIGdpY3Y1DQomIGdpY3Y1LWl0cyBmb3Ig
LS1pcnFjaGlwLg0KDQpBcyBJJ3ZlIHNhaWQgaW4gdGhlIGNvdmVyIGxldHRlciwgeW91J2xsIG5l
ZWQgdG8gb25seSBhcHBseSB0aGlzIHNlcmllcw0KdXAgdG8gYW5kIGluY2x1ZGluZ8KgImFybTY0
OiBVcGRhdGUgdGltZXIgRkRUIGZvciBHSUN2NSIgaWYgeW91J3JlDQp3b3JraW5nIHdpdGggdGhl
IHBvc3RlZCBHSUN2NSBQUEkgcGF0Y2hlcy4gR29pbmcgYmV5b25kIHRoYXQgcmVzdWx0cyBpbg0K
YSBVQVBJIG1pc21hdGNoIGFzIG1vcmUgb2YgdGhlIEdJQ3Y1IHN1cHBvcnQgaXMgYWRkZWQgdG8g
S1ZNLg0KDQpJJ3ZlIHB1c2hlZCB2NCBvZiB0aGUgR0lDdjUgUFBJIEtWTSBzZXJpZXMgdG86DQpo
dHRwczovL2dpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9saW51eC1zYi8tL3RyZWUvZ2ljdjVfcHBp
X3N1cHBvcnRfdjQNCg0KVGhlcmUgaXMgYSBtb3JlIGNvbXBsZXRlIGJ1dCBXSVAgc2V0IG9mIEtW
TSBjaGFuZ2VzIChHSUN2NSArIElSUyArIElUUw0Kdy8gUFBJcywgU1BJcywgYW5kIExQSXMpIGF0
Og0KaHR0cHM6Ly9naXRsYWIuYXJtLmNvbS9saW51eC1hcm0vbGludXgtc2IvLS90cmVlL2dpY3Y1
X3N1cHBvcnRfd2lwDQpUaGlzIGxhdHRlciBzZXQgY2FuIGJlIHVzZWQgd2l0aCB0aGUgY29tcGxl
dGUga3ZtdG9vbCBzZXJpZXMgdG8gcnVuIGFuDQphY3R1YWxseSB1c2VmdWwgZ3Vlc3QuDQoNCkxv
cmVuem8gUGllcmFsaXNpIGhhcyBjcmVhdGVkIGEgdXNlZnVsIHBhZ2Ugb24gaG93IHRvIHJ1biB3
aXRoIHRoZSBGVlANCihidXQgbm90ZSB0aGF0IHlvdSdsbCB3YW50IHRoZSAxMS4zMCByZWxlYXNl
IGZvciB2aXJ0dWFsaXNhdGlvbg0Kc3VwcG9ydCkuIGh0dHBzOi8vbGluYXJvLmF0bGFzc2lhbi5u
ZXQvd2lraS94L0NRQUYtd1kNCg0KUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBoYXZlIGFueSBp
c3N1ZXMsIGFuZCBJJ2xsIGRvIG15IGJlc3QgdG8gaGVscC4NClRoYW5rcyBpbiBhZHZhbmNlIGZv
ciBhbnkgcmV2aWV3IGNvbW1lbnRzIHlvdSBoYXZlLCBhbmQgZm9yIHlvdXIgdGltZQ0KaW4gZ2Vu
ZXJhbCENCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IE9uIEZyaSwgMTYgSmFuIDIwMjYgYXQg
MTg6MjcsIFNhc2NoYSBCaXNjaG9mZg0KPiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3Rl
Og0KPiA+IA0KPiA+IFRoaXMgc2VyaWVzIGFkZHMgc3VwcG9ydCBmb3IgR0lDdjUtYmFzZWQgZ3Vl
c3RzLiBUaGUgR0lDdjUNCj4gPiBzcGVjaWZpY2F0aW9uIGNhbiBiZSBmb3VuZCBhdCBbMV0uIFRo
ZXJlIGFyZSB1bmRlci1yZWlldyBMaW51eCBLVk0NCj4gPiBwYXRjaGVzIGF0IFsyXSB3aGljaCBh
ZGQgc3VwcG9ydCBmb3IgUFBJcywgb25seS4gRnV0dXJlIHBhdGNoDQo+ID4gc2VyaWVzDQo+ID4g
d2lsbCBhZGQgc3VwcG9ydCBmb3IgdGhlIEdJQ3Y1IElSUyBhbmQgSVRTLCBhcyB3ZWxsIGFzIFNQ
SXMgYW5kDQo+ID4gTFBJcy4gTWFyYyBoYXMgdmVyeSBraW5kbHkgYWdyZWVkIHRvIGhvc3QgdGhl
IGZ1bGwgKldJUCogc2V0IG9mDQo+ID4gR0lDdjUNCj4gPiBLVk0gcGF0Y2hlcyB3aGljaCBjYW4g
YmUgZm91bmQgYXQgWzNdLg0KPiA+IA0KPiA+IHYxIG9mIHRoaXMgc2VyaWVzIGNhbiBiZSBmb3Vu
ZCBhdCBbNF0uDQo+ID4gDQo+ID4gVGhpcyBzZXJpZXMgaXMgYmFzZWQgb24gdGhlIE5lc3RlZCBW
aXJ0dWFsaXNhdGlvbiBzZXJpZXMgYXQgWzVdLg0KPiA+IFRoZQ0KPiA+IHByZXZpb3VzIHZlcnNp
b24gb2YgdGhpcyBzZXJpZXMgd2FzIGFjY2lkZW50YWxseSBiYXNlZCBvbiBhbiBvbGRlcg0KPiA+
IHZlcnNpb24gLSBhcG9sb2dpZXMhDQo+ID4gDQo+ID4gQXMgaW4gdjEsIHRoZSBHSUN2NSBzdXBw
b3J0IGZvciBrdm10b29sIGhhcyBiZWVuIHN0YWdlZCBzdWNoIHRoYXQNCj4gPiB0aGUNCj4gPiBp
bml0aWFsIGNoYW5nZXMganVzdCBzdXBwb3J0IFBQSXMgKGFuZCBnbyBoYW5kLWluLWhhbmQgd2l0
aCB0aG9zZQ0KPiA+IGN1cnJlbnRseSB1bmRlciByZXZpZXcgYXQgWzJdKS4gQXMgb2YgImFybTY0
OiBVcGRhdGUgdGltZXIgRkRUIGZvcg0KPiA+IEdJQ3Y1IiB0aGUgc3VwcG9ydCBpcyBzdWZmaWNp
ZW50IHRvIHJ1biBzbWFsbCB0ZXN0cyB3aXRoIHRoZSBhcmNoDQo+ID4gdGltZXIgb3IgUE1VLg0K
PiA+IA0KPiA+IENoYW5nZXMgaW4gdjI6DQo+ID4gKiBVc2VkIGdpY19faXNfdjUoKSBpbiBtb3Jl
IHBsYWNlcyB0byBhdm9pZCBleHBsaWNpdCBjaGVja3MgZm9yDQo+ID4gZ2ljdjUNCj4gPiDCoCAm
IGdpY3Y1LWl0cyBjb25maWdzLg0KPiA+ICogRml4ZWQgZ2ljX19pc192NSgpIGFkZGl0aW9uIGxl
YWtpbmcgYWNyb3NzIGNoYW5nZXMuDQo+ID4gKiBDbGVhbmVkIHVwIEZEVCBnZW5lcmF0aW9uIGEg
bGl0dGxlLg0KPiA+ICogQWN0dWFsbHkgYmFzZWQgdGhlIHNlcmllcyBvbiBbNV0gKFNvcnJ5ISku
DQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IFNhc2NoYQ0KPiA+IA0KPiA+IFsxXSBodHRwczovL2Rl
dmVsb3Blci5hcm0uY29tL2RvY3VtZW50YXRpb24vYWVzMDA3MC9sYXRlc3QNCj4gPiBbMl0NCj4g
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjAxMDkxNzA0MDAuMTU4NTA0OC0xLXNh
c2NoYS5iaXNjaG9mZkBhcm0uY29tDQo+ID4gWzNdDQo+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWF6L2FybS1wbGF0Zm9ybXMuZ2l0L2xvZy8/aD1r
dm0tYXJtNjQvZ2ljdjUtZnVsbA0KPiA+IFs0XQ0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2FsbC8yMDI1MTIxOTE2MTI0MC4xMzg1MDM0LTEtc2FzY2hhLmJpc2Nob2ZmQGFybS5jb20vDQo+
ID4gWzVdDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwOTI0MTM0NTExLjQx
MDk5MzUtMS1hbmRyZS5wcnp5d2FyYUBhcm0uY29tLw0KPiA+IA0KPiA+IFNhc2NoYSBCaXNjaG9m
ZiAoMTcpOg0KPiA+IMKgIFN5bmMga2VybmVsIFVBUEkgaGVhZGVycyB3aXRoIHY2LjE5LXJjNSB3
aXRoIFdJUCBLVk0gR0lDdjUgUFBJDQo+ID4gc3VwcG9ydA0KPiA+IMKgIGFybTY0OiBBZGQgYmFz
aWMgc3VwcG9ydCBmb3IgY3JlYXRpbmcgYSBWTSB3aXRoIEdJQ3Y1DQo+ID4gwqAgYXJtNjQ6IFNp
bXBsaWZ5IEdJQ3Y1IHR5cGUgY2hlY2tzIGJ5IGFkZGluZyBnaWNfX2lzX3Y1KCkNCj4gPiDCoCBh
cm02NDogSW50cm9kdWNlIEdJQ3Y1IEZEVCBJUlEgdHlwZXMNCj4gPiDCoCBhcm02NDogR2VuZXJh
dGUgR0lDdjUgRkRUIG5vZGUNCj4gPiDCoCBhcm02NDogVXBkYXRlIFBNVSBJUlEgYW5kIEZEVCBj
b2RlIGZvciBHSUN2NQ0KPiA+IMKgIGFybTY0OiBVcGRhdGUgdGltZXIgRkRUIElSUXNmb3IgR0lD
djUNCj4gPiDCoCBpcnE6IEFkZCBpbnRlcmZhY2UgdG8gb3ZlcnJpZGUgZGVmYXVsdCBpcnEgb2Zm
c2V0DQo+ID4gwqAgYXJtNjQ6IEFkZCBwaGFuZGxlIGZvciBlYWNoIENQVQ0KPiA+IMKgIFN5bmMg
a2VybmVsIGhlYWRlcnMgd2l0aCB2Ni4xOS1yYzUgZm9yIEdJQ3Y1IElSUyBhbmQgSVRTIHN1cHBv
cnQNCj4gPiBpbg0KPiA+IMKgwqDCoCBLVk0NCj4gPiDCoCBhcm02NDogQWRkIEdJQ3Y1IElSUyBz
dXBwb3J0DQo+ID4gwqAgYXJtNjQ6IEdlbmVyYXRlIEZEVCBub2RlIGZvciBHSUN2NSdzIElSUw0K
PiA+IMKgIGFybTY0OiBVcGRhdGUgZ2VuZXJpYyBGRFQgaW50ZXJydXB0IGRlc2MgZ2VuZXJhdG9y
IGZvciBHSUN2NQ0KPiA+IMKgIGFybTY0OiBCdW1wIFBDSSBGRFQgY29kZSBmb3IgR0lDdjUNCj4g
PiDCoCBhcm02NDogSW50cm9kdWNlIGdpY3Y1LWl0cyBpcnFjaGlwDQo+ID4gwqAgYXJtNjQ6IEFk
ZCBHSUN2NSBJVFMgbm9kZSB0byBGRFQNCj4gPiDCoCBhcm02NDogVXBkYXRlIFBDSSBGRFQgZ2Vu
ZXJhdGlvbiBmb3IgR0lDdjUgSVRTIE1TSXMNCj4gPiANCj4gPiDCoGFybTY0L2ZkdC5jwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMjIgKysrKy0NCj4gPiDCoGFybTY0L2dp
Yy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDE3OQ0KPiA+ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tDQo+ID4gwqBhcm02NC9pbmNsdWRlL2FzbS9rdm0u
aMKgwqDCoMKgwqAgfMKgIDEyICsrLQ0KPiA+IMKgYXJtNjQvaW5jbHVkZS9rdm0vZmR0LWFyY2gu
aCB8wqDCoCAyICsNCj4gPiDCoGFybTY0L2luY2x1ZGUva3ZtL2dpYy5owqDCoMKgwqDCoCB8wqDC
oCA5ICsrDQo+ID4gwqBhcm02NC9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oIHzCoCAzMCArKysrKysN
Cj4gPiDCoGFybTY0L3BjaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
MTYgKysrLQ0KPiA+IMKgYXJtNjQvcG11LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHzCoCAyMyArKystLQ0KPiA+IMKgYXJtNjQvdGltZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB8wqAgMjAgKysrLQ0KPiA+IMKgaW5jbHVkZS9rdm0vaXJxLmjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoMKgIDEgKw0KPiA+IMKgaW5jbHVkZS9saW51eC9rdm0uaMKgwqDCoMKg
wqDCoMKgwqDCoCB8wqAgMjAgKysrKw0KPiA+IMKgaW5jbHVkZS9saW51eC92aXJ0aW9faWRzLmjC
oMKgIHzCoMKgIDEgKw0KPiA+IMKgaW5jbHVkZS9saW51eC92aXJ0aW9fbmV0LmjCoMKgIHzCoCAz
NiArKysrKystDQo+ID4gwqBpbmNsdWRlL2xpbnV4L3ZpcnRpb19wY2kuaMKgwqAgfMKgwqAgMiAr
LQ0KPiA+IMKgaXJxLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHzCoCAxNiArKystDQo+ID4gwqBwb3dlcnBjL2luY2x1ZGUvYXNtL2t2bS5owqDCoMKgIHzC
oCAxMyAtLS0NCj4gPiDCoHJpc2N2L2luY2x1ZGUvYXNtL2t2bS5owqDCoMKgwqDCoCB8wqAgMjcg
KysrKystDQo+ID4gwqB4ODYvaW5jbHVkZS9hc20va3ZtLmjCoMKgwqDCoMKgwqDCoCB8wqAgMzUg
KysrKysrKw0KPiA+IMKgMTggZmlsZXMgY2hhbmdlZCwgNDE2IGluc2VydGlvbnMoKyksIDQ4IGRl
bGV0aW9ucygtKQ0KPiA+IA0KPiA+IC0tDQo+ID4gMi4zNC4xDQo+ID4gDQoNCg==

