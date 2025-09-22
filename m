Return-Path: <kvm+bounces-58399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D56D3B92709
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 19:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 915E818991F1
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 17:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0D8314B83;
	Mon, 22 Sep 2025 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hjuTRFZk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oJ0nzR+0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F202F314A76
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758562307; cv=fail; b=pr3i8VlDbHLOynUqdzLrDLfggcEZHlCbeHHB5VhR7qkCpa7OK/VayOupHAAH2gsrqPvMPj8He0qS8HKIdqFnnkuRPqu1gzcnXKDCAL7x+gBVQXgH1GkrfUT9gx/trjb2doiDafbGLNLKcZjI+DiSodAulupgFZz2J3uSWisvGto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758562307; c=relaxed/simple;
	bh=srXPDJ8fSa165CDik4Jfkpv5LglIwZRuzMozAYwkM+A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NS3GeGqYnmYPsyYNEH5Ugw6Nlc4G8LV8gzfuM+U7LPFRUu4fdB3NpgID4eVKp1IAHNR4sdKPM/RfO/uiXzhqqXN949qGupH+g8V7aMBwOvC5jjQ9G0c3KVM/SanveWLxU1Ev7LjtPSah0dnQ9W0mqQIU40QB6xDttz7AOdGDFRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hjuTRFZk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oJ0nzR+0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MHNFqt009109;
	Mon, 22 Sep 2025 17:31:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QGxprtBpkzE+owLPJk/e1HHKaln7woPGYYvG7ykemDU=; b=
	hjuTRFZkkDEU5eCbxgFqzsIFFauY3zBPmylsRPToRZ9RB1vHLHl48JZGcHYweXhk
	h4JYOGwheAKOv2TsE+tBrhykjbt8NG0zayNp/eq76ktpavTLARFMQ0kxmFwOCQp8
	BmBEVKSarcJQ/oczqeyKQqEQRQC/rN/u7NRa2d//ULT+qahU82ifHkMiVj9DjjPL
	BBu4ne+I5BdxI//GNMm+FDZpIb3Gs8aBZBkJzmkishRx8PfUiCgi5O7a3FSRzqAd
	CQ2wencYU+TvBWyq6WKT+vCzMEvH9Kr5mYdjC+eUvf4mu2FGD7SwGzH37EK4kjGI
	IzU680YY7yzMehsKt10hZw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt2x5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 17:31:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58MGXPIP025290;
	Mon, 22 Sep 2025 17:31:34 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jq7babx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 17:31:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AD72pNFoU2m9RiCVErwsm88bR/FczpBgXOPd3lrDPpv1MBKEM8B36pkPyADNyCn/UbnYIzt56FoTu66G0sdQOdG6cNqpnsSrdriQMCnihIGdY+O5QcVcJB115KoK/Doc2Y39AnW8mBuCl28Ka7ImtKkpsN2+nqwLRHl7dvNk+RMFRuJq8sUoKZhX+F1blnHfveAn/J1vwKOQa+Jy/fkCDuviXSO9IoGydgqdg0NBcobILiQktQ1eGYWdMx+2lGjDS3tnKu05arvv/vEZ5NkmLQtKJOHDMzMsPypSIa7SIkTByxrCCfhghdiLHYYj2KwI9ee964tDE5P82lz/OargAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGxprtBpkzE+owLPJk/e1HHKaln7woPGYYvG7ykemDU=;
 b=lwMpJ9r3Z6Qy4P/Br3WJxVeI0C2VpfCEaXTYL1eIf3/TwGmGjpUQTjUxhsPf7KOuo1UMW1Yf4J+qoWtC1XLCjU0pJBGrwRnFDnqQHVbXBcJLiZ1ZDJ3IpdEYrWR66B2C99IY5oqj62S8diXMKL1kmqDecAL4yrFuKnUW3AI+hLV2iphrpL1fqCcZGr78ZOuHBxnnacYXYoOiotGOwfU5P5E/MdcLyg7kGeULF+QKI3gRhvz0NUXadnVL68Q2Dcv2Qy5sgWwgn4VNdtW++zrRZKc2pt8AvE5sZ4NhMyIGMpyHc1PQRz2l6nEa1GW/2VqhbfTjDOV1fzZ3Jytfc+WYTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGxprtBpkzE+owLPJk/e1HHKaln7woPGYYvG7ykemDU=;
 b=oJ0nzR+0qLCoWtvyL9EQfYEYCdzQfC1Sa8f8OWrbWmfwZxw+3AcOCRdM4tl33PlT+6wqpcGbAYIOh86G1xytxfvgMw+53crDOvuzoEPvzUhAmJQNPEfvl5k0D0paQcZBkNaeTQPuBQVT2hj1phw6E/+Ma3pCuhZrPyonOTJLvOg=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DM3PR10MB7969.namprd10.prod.outlook.com (2603:10b6:0:45::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.18; Mon, 22 Sep 2025 17:31:32 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 17:31:32 +0000
Message-ID: <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
Date: Mon, 22 Sep 2025 10:31:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting during
 downtime blackout?
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:408:142::17) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DM3PR10MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cefd7ed-d268-451b-88e5-08ddf9fddef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0NWNHFZdXQwNUpUN25XVGh1bzVEblJFdHlXWVk2blRybCtyR2k5UDl0Nk4v?=
 =?utf-8?B?ZUIwNlJtcTlTVnBXYUd5K2FUanl1c1Rzb1JubklucWFmK05ObUt5bXNvRHJU?=
 =?utf-8?B?VkQ1SjV2WFhzMHE5UDlYZUh0Q1dqWmJaWVVDcmVzSXlBblZzQkVqa29aYnFy?=
 =?utf-8?B?OXVWTW5oWGIwT09YNDltZHJnM1pUYVV1bjhBM1g4VGViMW0wN0xsTG03NzZK?=
 =?utf-8?B?Y2tTelUvQTZPeG9xaVoyVXE0Sm1ab3VBZlRaRGZkdzRZTGxvRmlhUkpsZjZw?=
 =?utf-8?B?Wml0OWJTendGZ2NkVDlyOHBYaFpza2tRN0VvUG9OQUdWam94YzdpbzFpQnJz?=
 =?utf-8?B?cmltUFNvaEFpSHU1YWw3dFJKNS9nQXRYbzBxdU1NdEs0RTZxMUxsNk1xRGVH?=
 =?utf-8?B?anhXMXJuclhFamFLdHUxbFRZN1hjUTlROTZCQzNMQk5uVnd6aDE2cHp3M1JC?=
 =?utf-8?B?VzR4by9QeUd2MkUxd05jRjdtRm1WdFJXNmpzNDIxaFZ6bmxkRmdqbHQ2N3VP?=
 =?utf-8?B?Q2JRMzkvRTFqZm9iM3hmRlhXWUhSdzdRSW9YeWhvZ3RwOHQ3eWYvc0VNZ0hh?=
 =?utf-8?B?Q082TUxadGhLbDlhTjlSTzQ1VERyWW9jbExOdjR3ZW5ZUGlpQnRLVzBXdnJS?=
 =?utf-8?B?MS8rMVRsOGVMdkE1Rm1GcU9rcGlpc0xBamxTc1k3d3BDZkJjL2I2dXc0SE9h?=
 =?utf-8?B?Wms4TzdFSVZWYmZuNlVMM3pqZXEwUm9WbG1QenRuODRod1VoTWhIbDFQSFE1?=
 =?utf-8?B?UXJHcnhMN2tkR1kzVVYvR01qdVRHSFFZczBlU042c1p5REh4WGtNT3A2MnFa?=
 =?utf-8?B?cC9sN2p6MXpmdERid2srM2MvV2F0dXYxdnNJRFBsUlp0VmJ6SzBESzRrYVho?=
 =?utf-8?B?cC9XUjRWSks5TnhXaUs4WTZ5VlhyL2txRVU4RFFIT01SS01LZnp0WmdQNkp2?=
 =?utf-8?B?OEQ0N1JZang5cmV2a2JoV3VUaTVvYkFQVzQxT25WRTgzMGlERU9vZlBsb3hJ?=
 =?utf-8?B?a1A4cnRaWW90eVAranI4Tk51YzgzMGdjL1ZWK0dUT2VacW56ZjR3Tm5MT3VI?=
 =?utf-8?B?aGZnRTIzU1NlNW5VOWExQ3owVVlGRHlXOWFCM0F6ak51REIzYnIyOFJxZHRM?=
 =?utf-8?B?S3BDR01udDBWd3c1OEZPQ081aHFaZW5hNDJxUktJNTAzeVlhUkEwSzc5K21L?=
 =?utf-8?B?WTNXOHUzUHo1ZFNXZzhMUnJnSElYUDVBckJscU9tQXRISFhISk1Wa3NENVFu?=
 =?utf-8?B?Y3lRajR0QWFjeS9GY1hGWWxEamhJUzA3aG04M3NKMVdNZFBmTVZFRVNML2w4?=
 =?utf-8?B?SkZWVzFnb2Y4eDNid3BXTjBRaFp0ZlMxbThHOHpsSjA3Yy8xY05ieGRSVE9W?=
 =?utf-8?B?L0FWVVBqOThuL2dnZGlvQm9RRld3dE9DWnk5WSs4WGszRTZPS09panJwSkNM?=
 =?utf-8?B?WDhkbFlDQUhQSzBzZzFuaVJGNUx2ZVBiaWVwNmh0Mk9YQWJ4bC9samJseFEy?=
 =?utf-8?B?cVowRHBzOEk2T3pmSThpS1R0UytQMGdnTkVaU0tzVjRzVHBXUUFPV3YzUWlj?=
 =?utf-8?B?Z0gwaHNpSDdzb2d1b0EyMHVZN0ZDM3JYYk54ODBxc1FVN1VmbHJ5VjF1NXFl?=
 =?utf-8?B?RzUwSjdubEczS3JjNmpLUTYrUDA3anlKd1dOOGxVdmVSVk85SDlsQm4wbitW?=
 =?utf-8?B?Tk9QUHJEWE1abFQzRm92T0tUOXlDWlJNeS9wZStRbFhZWGVhMFZGbUVMQitR?=
 =?utf-8?B?a2h2TzMva3NyZ01qdExEM2hrQUQxTG5URTJUR2l0NU5HYnA5NjJoejU2L0Yx?=
 =?utf-8?B?NmF0N1NkTjJ3czRaSHBRWUFmNXVXMldMK0RyL0krVVhZRWtKYTBKREtYeVZD?=
 =?utf-8?Q?dFvbiGAX/mkii?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1lNU1NzdDRPaXFLTDJkYjUyM3hGZ2d5MnUwVW5IQkVuYm5PSWF6QmFESXhP?=
 =?utf-8?B?OHVrK3JxdTdWRi9JSEthYksyNDgxSVZTR2RZa3hQYXJaNmdOSmZ4T2dZWDNV?=
 =?utf-8?B?TDh4OFBBbXRpOGRKVjhkVWlJVFhzUG51MmZZcll5NXZTTFRYbXNkOEF0c3ND?=
 =?utf-8?B?RXNPbzIyRnlVNlFtMnN5cWs5OTlJdGpHenF4RUVJd3hZbDJBeUcycloxZXJG?=
 =?utf-8?B?OTN4bkhlUlllMzVTU0ljWExIN2VvNmZJZ0NMN0dOanBqS29lMjhta3dyVDA0?=
 =?utf-8?B?Wk93QUR5NXBWVW52cjJqSlJOOEZad3JTVWdxZWxHZHo1QmUzMVkzaTJwdjAx?=
 =?utf-8?B?UWw1aDlEZHJZY0s0VHd2bDFCdkY2MFhsZ0Z1bU12ejIvZkpPeHpaOWFmZkFB?=
 =?utf-8?B?SEpEMnA3R2RSMDRMSk5RaVM0R0dtVm1ON3MvVzcxTi9WR1E1ZS9PODNoT2Zh?=
 =?utf-8?B?Y3VoQU5nUU81VTlINXAxbFVyZFB5djgydksvbng3bEhjc21DN0hPUFNmcHpO?=
 =?utf-8?B?S2Q0N3NwU3N0TzNRUE1CWUpZdkJBcXlodG1FL2JMeFJjaW0rTjlGcE5RMjh5?=
 =?utf-8?B?aThpOENTcFhGUlozdkYzcU1Tc2Z3YXJEekNCZ3RkOUJkMVhsWTRmUHRxdWR3?=
 =?utf-8?B?T1prQTJUVEN6YzFtRmwvS1I0YlNZWDZsenV3M0crcVZCbVBac1hXa3NRUzE4?=
 =?utf-8?B?QkM2bSsrbDRPOWlHV1Vib2xJdFdTaUVXV0lqaklvcFlReDl3VXhrZjhMbUk3?=
 =?utf-8?B?d3hZQWdmSHVZVVMybDVCMm5PUlZhN3k5UXB3akp0WFV0YUpxZHFUUkh1YTVn?=
 =?utf-8?B?dWFGa1RaSG90VkU0azdEQzFuMDFSdysxd2NjanFyZS8ydmliWjQ5QStycm93?=
 =?utf-8?B?N2YrTFdHY2FUbkZ6N3J1ZGpoWDBaOWc0ODFsVkovNHg4azlDZVlKWklQUU02?=
 =?utf-8?B?bjNUMUNUajVPWGZxbGs3a2IyZmZ3bmhIZytudWNkZk1lUk9RQXN2c3VuSlJU?=
 =?utf-8?B?djZscGQ1M3dScnY5Q3NRNnJMdVhkVmhyL0FZdWJLLzgranRUSTU3UmpTVXpN?=
 =?utf-8?B?MVR3OXNCSlZPcHBhb2JvUVpGTzBTb1Q0R3B4aHRhOFJnTE44TDY5T3U5K1ZC?=
 =?utf-8?B?VG1FS25tamZmc0Z0c0NhMDZKNHduOXNIZERua2pQcUVOYmQ4VDlMbG1MMnFN?=
 =?utf-8?B?alJ1NE1IK3YyeUxUQmcrdWduYS9UbjM3N2JGSWpTc25xU3NzazFsWm5zTXhl?=
 =?utf-8?B?VGFscFlaRktYRmpCdEFsVlBzVk93QXU0YkZtM3c2TEw4Q3p6dklCQ2FKYldU?=
 =?utf-8?B?N3VlSU1nVVBGaGZ2aU5zZUpzS2IyTi9iRjRPYmdGV212ZTEvS2JyR1JGc3l0?=
 =?utf-8?B?WitteHd6M244TlRONnhWR0lad3VNOUw5c3p4eUVyVHIyZlBseG9QcUliQTlm?=
 =?utf-8?B?OUNiV3gvNk5QWDJJQlNWckd2THhpTjNiTmpmT3pmd3pneUllYWNFSEx0aDJ0?=
 =?utf-8?B?bVBDR2RGTjJBWHBJOFZXYXlnMnhVdDl2K0p4TTc3NFZ6cy9WUzVKcndvdm1O?=
 =?utf-8?B?M1JpeTVNa1dXUDRha3FBQWhHbkR0MHR5UEtjd2hqdVZIYWtpOTFaSi8zdG5w?=
 =?utf-8?B?YzUrOFJRcGF6cTNXYUFCZ3NoRTk2MGlOY3NjNThES3BMZDFFSTJlMDB6UUVZ?=
 =?utf-8?B?RkwySUNJckprcHM4TTdNRVVWWndkSi9xaEVJeStrMXl3emtsbFcxam9lY0xB?=
 =?utf-8?B?ZWVtWUZocnE4WXArZlVGQXh6YUZCc3dwcTlnMENpSWJSR3JTaVFkcTlPenho?=
 =?utf-8?B?empTVTI5ZmpBalNoYW1RNnU5MFhWNElHb0dPbmZ3VlRSQm9WT1cwODg4Z1py?=
 =?utf-8?B?OXMra3pFeE9TRUVHcFNBNUVTbE5lOTVJMEtTdk8yU1FoTDlqaW93dkg2MDJ5?=
 =?utf-8?B?bE4wdDV3TFBuNXhiK2YvSFhnNTBkV3RpMnQ0bERCUjRJRDVqdFVKNmNpOHll?=
 =?utf-8?B?VVZhalE0Wm80YlBrcHlVOGpJZ1YvWjY3ZkZ5WG9aWDdJNjljaEwzNzFpRW5K?=
 =?utf-8?B?dHRrSjNhQ0ZONHpaK2NpaHhJVmdvdEtyeCtjTXNaSmE1eDlaM3ZXYis4ZGUr?=
 =?utf-8?B?djdrbWZKUy9UeTUyZ2drWEQ3d0hlakxvelRqbmlVRTZObkM2MFptaHVRWnNU?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dxPeoqDNAeOIoGTBCxgHT2df/aAKbSYX5ONObIz5LsfnM2NEkzxAejzEJzU3HoCWst8ekPpyDIkkmv7EpfNxhi6Bn2yNx9OvJUH6/fMs/cE3AVywJfuljzizHnT+PuWa97ocYFUkm2E5XjhlwhB+6D2PpXmRHRXcqhH7lfm2YgtC1sMt3zOmvgfPpDZ2lV9jha6gPJ7mKbruO6XB+KpdMfVnD+ij2OB2O4brWcWZczxJWHajbd/zhSoFxEcrLHEnu5wFn9ck5Zey/0r0hlpm8UMEJO5qse1dh1zx2isKhzFRRIJWOgNDnAnLdpTET/7FstBzd63jvOF0s2mMCDxjpdVfIrOcw2Td/DPCXxbjI0IA+wehkhtJScByMa8pYNIqw0vQ4Wxc4K4faHKmHmXmo/tEX15AKP3jkwld+uB17ODR8iJZWwm19J4j7bf1HY6l+2aSKQ8LtYVo1vnPZC0pHmv4y+AawGF2K91DXCw5IWXZHWYmlJShrLrJ8QYl58wYD/j6bXhkW//j5rlTF6O0fIfs+ldqdR0itkri9wUE0IWQ1iuLGRFz2p8+zo7SP9Mhm9IjzxadwkMWHV0gV5gSIYRv1x1LDOUYs9+oGdP/5QM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cefd7ed-d268-451b-88e5-08ddf9fddef7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 17:31:32.1410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYgFVPgPSmvxSlNqjsQsd6l/4vgjQutXwUkP9LOSyR9bTJ/hOhl6BMyKM64Uif09wWh0E14lrzbw450Vb0xVEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509220171
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d187f7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=Uo5hOzLPh7jremiIRQkA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: _9JG286SDJapxTQ1zqYpYw2k2LMSUwEH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfXwslFJQNPspea
 4N1lseLd6NRvC8B+wev51WBo1c6WI5XHdrzZQPqQRsp9Wbp6csRtU0EHUb0SwTLE3wp0a9JhZmP
 QBzCc5leY7+60yEnDzXYG81/9u9HCcxytUxmzdllwZx7hQRQGYLTiuNz3jR5IaAzYS9r7LINFp+
 13I9KaTHbXm/lhmx6oiHGrVbFdrIHuKjA1NbaMa0Di35thEtL3BrL3FxtKOTZKj5TfP1vtNvXA+
 gmevOE8/cBGN/8AbnlqYmiYx5rBOfICY2b1iWLG+fJUVLbOVTBPikKOvm+teeJvfY8Ra/UHMA6+
 b7eG/Tl+/T4hvIKT/ZKwc2IH0zOxl7mofGOgAdLVHPZNESrlhNO7rDprPMGX3tlxcCi63gaHMg9
 eSuHLwAn
X-Proofpoint-GUID: _9JG286SDJapxTQ1zqYpYw2k2LMSUwEH

Hi David,

Thank you very much for quick reply!

On 9/22/25 9:58 AM, David Woodhouse wrote:
> On Mon, 2025-09-22 at 09:37 -0700, Dongli Zhang wrote:
>> Hi,
>>
>> Would you mind helping confirm if kvm-clock/guest_tsc should stop counting
>> elapsed time during downtime blackout?
>>
>> 1. guest_clock=T1, realtime=R1.
>> 2. (qemu) stop
>> 3. Wait for several seconds.
>> 4. (qemu) cont
>> 5. guest_clock=T2, realtime=R2.
>>
>> Should (T1 == T2), or (R2 - R1 == T2 - T1)?
> 
> Neither.
> 
> Realtime is something completely different and runs at a different rate
> to the monotonic clock. In fact its rate compared to the monotonic
> clock (and the TSC) is *variable* as NTP guides it.
> 
> In your example of stopping and continuing on the *same* host, the
> guest TSC *offset* from the host's TSC should remain the same.
> 
> And the *precise* mathematical relationship that KVM advertises to the
> guest as "how to turn a TSC value into nanoseconds since boot" should
> also remain precisely the same.

Does that mean:

Regarding "stop/cont" scenario, both kvm-clock and guest_tsc value should remain
the same, i.e.,

1. When "stop", kvm-clock=K1, guest_tsc=T1.
2. Suppose many hours passed.
3. When "cont", guest VM should see kvm-clock==K1 and guest_tsc==T1, by
refreshing both PVTI and tsc_offset at KVM.


As demonstrated in my test, currently guest_tsc doesn't stop counting during
blackout because of the lack of "MSR_IA32_TSC put" at
kvmclock_vm_state_change(). Per my understanding, it is a bug and we may need to
fix it.

BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-configure
kvm-clock before continuing the guest VM.

> 
> KVM already lets you restore the TSC correctly. To restore KVM clock
> correctly, you want something like KVM_SET_CLOCK_GUEST from
> https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infradead.org/
> 
> For cross machine migration, you *do* need to use a realtime clock
> reference as that's the best you have (make sure you use TAI not UTC
> and don't get affected by leap seconds or smearing). Use that to
> restore the *TSC* as well as you can to make it appear to have kept
> running consistently. And then KVM_SET_CLOCK_GUEST just as you would on
> the same host.

Indeed QEMU Live Migration also relies on kvmclock_vm_state_change() to
temporarily stop/cont the source/target VM.

Would you mean we expect something different for live migration, i.e.,

1. Live Migrate a source VM to a file.
2. Copy the file to another server.
3. Wait for 1 hour.
4. Migrate from the file to target VM.

Although it is equivalent to a one-hour downtime, we do need to count the
missing one-hour, correct?


That means: we have different expectations from stop/cont and live migration.

- Live Migration: any downtime should be counted with the help from realtime.
- stop/cont (savevm/loadvm): the value of kvm-clock/rdtsc should remain the same.

> 
> And use vmclock to advertise the wallclock time to the guest as
> precisely as possible, even the cycle after a live migration.
> 

Thank you very much for suggestion on KVM_SET_CLOCK_GUEST and vmclock!

Dongli Zhang


