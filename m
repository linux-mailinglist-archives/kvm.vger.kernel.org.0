Return-Path: <kvm+bounces-58948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F18BA7712
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 21:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED0CD179024
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 19:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BB726A1BE;
	Sun, 28 Sep 2025 19:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VgC5vZFO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d6yPa8h8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE0EC8FE;
	Sun, 28 Sep 2025 19:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759087945; cv=fail; b=XHHz80ucHrW+bL2emsQlQc1DlYcWeyYMErUDk39ZtCagZK3R0WKpsewj/787DWmQtG/EFb0XCs9JXpxokPW0zO03LDfVmHDOe7XFxRN44lNdqVwlzqVBpmDFcwS4f7xph3iDqqYylvhfCHMZJ4hq1HiKaxyTmHeajhFtUzSAKwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759087945; c=relaxed/simple;
	bh=eJPj3wnLRseg3rBrVUeqKRfVTBW76KGGux5E3HLsiE4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s0E8X5Y3QnoEZN7ywqdGiY31ulknPR+xRbPd5YwJiRjRL9CJjRucml5s4OZDGEXyFoJ9c3vX78DUQuRYf9sQzb7ngU/4kVIvAFR746kNztz/15Mkzvv3c0wA52nDVwPDSA9SFwe5olwbZL3KzttOxxNKwciprEkkaINKsAkLc/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VgC5vZFO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d6yPa8h8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58SIxWn5018411;
	Sun, 28 Sep 2025 19:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BOnEA4cUvfQ2bJD+C7uoKrM3IWZZePZAhknlKn/ZEik=; b=
	VgC5vZFOWNk+CJbFyWTjTnJ8OVdmU11AUmwMsK6KCDeJB6+mWos/R1M5LhhEuX/3
	8IEPK0tro9nJU/mtRS6vLGv5nm/2xMetTy5B7vO6NrW6e3dgjvUQxGQBCIBMKq8M
	kkPGXJHWGg8+5QaVvsBCGTHdGV+tJQSQxIOgJKXnFHz7La3jp+j1ve5TaZXdGdr9
	+TXfCxYUm+VoGfYqIUAg0vk0phfkQYSdBR9zrpSbLl4dGLkUcnQCHpdYF1mQ7tDO
	Opny/WfxZctRXnwvhhm7zcRZC7jbPYgbPqL65MrtfwlpZCs3oNB9+n+9V1fi5S6M
	szrX11IHyKxAkfTbYdTbNw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49fasg00eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Sep 2025 19:32:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58SFqFQJ000581;
	Sun, 28 Sep 2025 19:32:05 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c5mx8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Sep 2025 19:32:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Crb9/6RS7/8UMs0/PvAC6khlkkeuRddrEnjXN3OrcBixdZoWn2zbnEqSYKEnSTN6OC+sNGyLFnApufMVEqACLzz4Ba5fRSmRsDlbONrA1s+PesFNAh1jgCJLcFqj5iXozPIAYPL3RZUKxhdQnigOTA70xxkRzSb0VnoImYn89jDdMCiyNbHKJscuSBfFGOn2xzNyKmcrBsAoHKvx2sv34Er7I33j3WwwJ+DTE9gG9eAApeEfARzEAGSxdMfQv0aeyxs6zTssWNdr3sXNXi+Bmx5hhsjXeUQJNr4g9RNJ/pcv3JGiO+Seg3aEfn87xZ6Ta1TJ/j3oKudQH0SWipQVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOnEA4cUvfQ2bJD+C7uoKrM3IWZZePZAhknlKn/ZEik=;
 b=QMocRAfZMZ33Lmp0GJu9XA3t9fOV5sZQatZyoDuX+KbE+n+WrHuqE9RgAxgXFU3P1XNozaJ5P03kLfxTki/fZeYGfE04e7a/t/x+h18u4+ieCN58/7AcFIqAJjrWTpWxiF4eaT1Uu4veGTFkwv2hEO5MW1Gfuz3RU0Vt1HUej1xeMd02Tak/KEX0ZAyUfglXafHnsmo+IUEeZTNHomIYZbyDvxUVQKpOH7eZFcKSwjIgtajotwXMcSeX92OgiUUsunPkxnJS4IG0D9oGwG0S01Dq2r8hFunvq53+JKIj2tdgy0SYE207Bfkp8UMGamufI2RWwaKYNgmnuGInaORMWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOnEA4cUvfQ2bJD+C7uoKrM3IWZZePZAhknlKn/ZEik=;
 b=d6yPa8h8Xo4x+10clPqX5cHnTLwx5z9anTzMaMxTBIy7+w2rs4Yyri6IU9UBqEsMjA1wewVYBIFvZMWhnphWh5PZW9CyBfgoXjTyxlcc+USobIxhoMO35Fmrin/brByczSoBMb3EVcIsOoDL230tL1ugixzrAjU1lxpwKqPUY/o=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by IA0PR10MB6747.namprd10.prod.outlook.com (2603:10b6:208:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Sun, 28 Sep
 2025 19:32:02 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9160.008; Sun, 28 Sep 2025
 19:32:02 +0000
Message-ID: <89643477-b713-47ed-861f-e5fd17989745@oracle.com>
Date: Mon, 29 Sep 2025 01:01:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] RISC-V: KVM: Transparent huge page support
To: liu.xuemei1@zte.com.cn, anup@brainfault.org
Cc: atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20250928154450701hRC3fm00QYFnGiM0_M1No@zte.com.cn>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250928154450701hRC3fm00QYFnGiM0_M1No@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::20) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|IA0PR10MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: 308d4b7a-7562-4bd6-2538-08ddfec5b301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjJPa05zajFyQkoraEZxTDFXSm9rcXhJa0N1czRNQUZ6K0krUno2NUxHbHY5?=
 =?utf-8?B?REg3M0NJQTRoNHR5VjZHR0lMMksxQTlrTW9CQ2NQV1NoZnN2RWJZRmg0ekQ1?=
 =?utf-8?B?czBTUmJ3UWUrdzcwOTJaTzlUUG5mM3dHbnN4aUo4QWFNZXprQWEvYktmdzFu?=
 =?utf-8?B?SStIYzI4RUZWYUhIRzRVTmZGRjd6Z1M2MVpnNE9zL0dzM2p3UEZZZTUydzM0?=
 =?utf-8?B?R2d3NDl5RWt2aEdLTzVKdlUyZVlrU3lxVFg1OW85cXBudGE3NzVvRTRBRHc3?=
 =?utf-8?B?eCtpUUtzU2Q1K05IOTN1d2FrZWxmQWRFM0RuM1ZCcmlGNCttVHRXYStUZFdF?=
 =?utf-8?B?dDZRZjg3ZEpXSHBFWUFacVhSM05ZMmtYT0ltc1JkWFhEaHdsdTFQaWhiYnZ5?=
 =?utf-8?B?ckdkNW5tMm1XUjRhQTQxbVp5UzUxS1JlS0RlRHVaODkrRHhQdVhsYjBoVGo2?=
 =?utf-8?B?Zk5reTBsT1YvNzlRZjZQaWdHVEtXVnhIMVRtNm91bnJLcEl4RjJ2WnhNQkJH?=
 =?utf-8?B?MzZIVUJVMHVZSjNUOE1BUENTWkpFSzJKZWZRMHdqMnJIZDlIVzAwZlA0M1lL?=
 =?utf-8?B?S1NZeGVTY3FZU2ZCb0w0RGNKTDdkVjljYm8wTXFhTCszd2NxOHIwZnRKV3Nq?=
 =?utf-8?B?WlppRDFmR203dXR2Uk1nSi9KcWdOd1YrU2xjMDBzMFBOSDdxcDZoSmlQUDdY?=
 =?utf-8?B?anBXT2Y0WVVmSlhlbXdlM00vdng1Z0pSY1VvRXN2Ry9oZ0EyaytSMHF2aThI?=
 =?utf-8?B?eVJ4NDVSZVJ2dXhuWVNya1V6RktYR0FseVA0aXRyMDg2YXl4bU1CYWN1MVk2?=
 =?utf-8?B?MVhjQXhWL0xwMmNXNlA5Q1AxU0p2UVcvVkp2L3JERHRueHc5Mm1YQndaTG1T?=
 =?utf-8?B?R2NZUGJXZUtHRXpnWWZvOE1hcjJBa0djNm9mTjVGKzZpajBqQ1o0R1pSZjd4?=
 =?utf-8?B?YmVjOSt5Z3JDYmk3L1Zwc3FDYmY0MVg5enVtVGk4eVVVcE85NlowTzhQbGhT?=
 =?utf-8?B?WEd5VWZmcyt4RU1iMFBxNHhwNjZyK1hIcHpqUjhJTmFQTlBUZm9YRGJsaWt4?=
 =?utf-8?B?eVZVcWJkMGxiZWJQRUNPQVEwbEpOM1JWaDBWRGh5V2dIdnp6dmdxUWkyL1Jj?=
 =?utf-8?B?bHRqbndSQUM0dUhCQnZRWWFaZWJra01iMHJhekE1d2hvSTMvaWVheHhqMXF2?=
 =?utf-8?B?b0F1N25jRE85L2FibHVlTzJLZUlzQjdEU3Boa0JhUU1LV1lZajU3S290ZkxO?=
 =?utf-8?B?R2tlZUZUVnRiWll2ZjQ5NUdyZzJjZjVDM0ZzZk1WWEVLTENxMlRSQVpDN3J6?=
 =?utf-8?B?azdJYmR3TlpTY0FjRWlkY0N0L095OWRsT2pxbVpscDRUKzk1cUZ1VVE3R3dY?=
 =?utf-8?B?M3MxUkUyNnpyWXNTeXBPbjJyUEt0N092cldFcGE3OEx5Z1BXbitsZVNLUGpG?=
 =?utf-8?B?aVdYbmhCMnJmc0lhOWZBTEFwbFp1cS9aVW94UFR4TzZBSmVrMDBBRVE4ckN0?=
 =?utf-8?B?WEp4OHhHQzBTQXFNSUU2d2psZXhoVmZVNzhieC9ISDZ1UGM1aCtsTXpqdVlM?=
 =?utf-8?B?SGkrRG9jNHJkQUF2RkhTdkUxU0RMOGQzR0xyN3JPMGhlL3VabnFKSk9qRGRz?=
 =?utf-8?B?MU1CR09FdDlWbU9hUDlxYWQzZXl3VXBzemlRclFiTTVEZFVGSUhwK0U1c3pS?=
 =?utf-8?B?UzdCekNwNGgwckxBdkdvT3dQd3pKc1BDNEhBYVJ6bmZEak01ZWtpcXJLbUo2?=
 =?utf-8?B?NEs3TTE5N25SWTJrODFBTTBKVWN3OGJ3UE02NlYzUHBqRHpNZEdXaDN1bGkw?=
 =?utf-8?B?citrWWdqTWh5Wnpxak9NQWlQN3l5VnBYQkNXY0k2eWdQeTI1b29OaERuMExh?=
 =?utf-8?B?Y1BPNldxclpvWkl6UnkzVzNUV0JoNmI4RGhzUm1EYUtoL0VBZWtXa2laUU5F?=
 =?utf-8?Q?+dI2jft7nT7R815wOmX/ZV52nUUzP31e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVxWEJ0YTJWUEF4azhSZExyUWpydTNiRDRpSGZtVHlPanIvajB1OXc3RWJN?=
 =?utf-8?B?ejJuTEgxZzk1SERGWDJjTE9BWkhBMnJGYlo3SGxOcTFDR3dzZjNSV0YyU014?=
 =?utf-8?B?bmtvN1VvT1RvQ0U1UFVkTWI4SXFzZGpnamJQem1KdEpEUnphNW9nbnRWWkRI?=
 =?utf-8?B?ZVBEYTI2OE9hdUdENUhyMlorRUhob08vV1ZPMmxkZTIyY1hjZFRyQlBRd3dK?=
 =?utf-8?B?VllzWDV5WHVUTm0ySjg3OTdObS9YSzdNQmVjVWNEK1dkaHoyZXVrTXJiTjlj?=
 =?utf-8?B?LzFrVjJ0bXBabEg3M3ErTHdFczM0MVp0a0dqVWpVdGM0aXpTU2VZM2txU0pX?=
 =?utf-8?B?Ly9LV2lMakxKUUlRT29SVTJvc1FHNFd6L2c1Um1Gd3A4QUZhMzVIZGRtcFNB?=
 =?utf-8?B?TUVyaUIranB2aFhMV0ZVdXVWbzMrcGJhUXAvbVRHM2xpYTVGN2dmZUY5K01x?=
 =?utf-8?B?S2g1bjJETndDVDh5clpKUkx6Nk1SMllnOHkzaEdTeGJ5Unh4RmRpZ0cvRHRE?=
 =?utf-8?B?ZXBmU0JwU2QzZ0xzK0FzWVg5bnVMMTVCWFYvL0lab1NSQ0hrWUhta2pGT0RG?=
 =?utf-8?B?NzM3R1h6R0dtRFhkL21WSm1YK0FHc1dpUExQNW44OHBDSDBsUWF3NEdBc0tn?=
 =?utf-8?B?SkJUZGt3K3lzblVJU04yZ05SNStZZVp0U0xRZHVDMXJJS25mWHlkNVZ0d1da?=
 =?utf-8?B?UVRESVBCQnphTkFTZFlQczVrNXJlM2s3MlErUWd3OHRYZ2w5d091RWFYWVZT?=
 =?utf-8?B?UVlaM1JDUXBqV0Q5anBPelJJZXg1cWtKTDM1MEcvQUpabVRWY0NQcFNVUDZZ?=
 =?utf-8?B?YzFBNjdjdlQ0T1NxaUZjeURqcDIrY01FWDFueFh2VlBQTWZuNnNNT3BtZHdi?=
 =?utf-8?B?eEtpQmprZjJWZDZmR3c0dzZ4NXVLbGg3TlBJbE9GZlNQOVQrKzcwcHE3bzc0?=
 =?utf-8?B?REQ4YnlOajl0a3R1YlNVcG9lT2x6Z2Z5aTRjZklsck9kR1FmYm1XVGFPQktm?=
 =?utf-8?B?NHp2cFJINytscFh1UWlRbkFjNTQzdkJQaDlGZWxPd2x4c3lBNnZQZTEzUnNT?=
 =?utf-8?B?Ym04ZEovWHFFeFAxamhyc1dnMnZHTzZxWUMraXFrb0lKUFEzZFpFdVFZMUZY?=
 =?utf-8?B?amxuVC9lRnRwdDB6WEkrckh5WUoxZUVwQlFzRFBIWXFsSzNucHRFS2xVc1Zt?=
 =?utf-8?B?THJINGJpdGJ4bTI0YjRJOVd0OWg2N3JYUHdxS010T2FSYjVLQVdwM1AvVjBI?=
 =?utf-8?B?VzlzWTNDRENubHZ6ZjhkSHZxcU5KNzZIbnhJNXQwMDY1YnRmRHpYRDFmTU1y?=
 =?utf-8?B?Y255V3pIZEI2WWtJWklYZWdXVHFFNEhxcURqL3A4VDJWblZYTGJiTWtLSDR3?=
 =?utf-8?B?d2lOdFJXT3BDempCbklld1NLQlJMRm9ycFY2bkd2cGRXTlJLYjFKWms4OWMx?=
 =?utf-8?B?MEswc1NSNWRvZzE4c05xaVorano2akxJanZTRW5TdnMwYS9tS1ltYmdDZGJj?=
 =?utf-8?B?UzM5YllRSG1jVnhFeXBQWHhFc1o2NXlHTlhMT1VCQ1hoTlR5ekU2WWhGV1Bm?=
 =?utf-8?B?WnJQM0tudlN5YkJmZG9zWkJoWEVhbXppbGlaeERPcnZ6Q3VUMHNKVlJhVDBm?=
 =?utf-8?B?ZWlBOU9Zb09xNmd4ZXVWNWswSnhPQnJrSUx3VngwUzlLM2JncGJYeGhpM21M?=
 =?utf-8?B?UEZKNFdqenZkVmlKV2M1R3ZtbW1JYTJMWTNHQzN4M3Avcko0SHVzalhocW13?=
 =?utf-8?B?NXhrV0ZHYU9CMTlGYnBtWm9NMHdERktyOXg1UU9hYUZDUEFNd25KS0oyMTRs?=
 =?utf-8?B?c0JwQVJwaUhGV0ZvZzd4eEwvdmhWY2llNTczTUUvdXU0RkZXNEVvK2E4dG5s?=
 =?utf-8?B?UU1CdWZUYm5QUzFvZitabkpKRjdxR3N3b2pmeGlzVE0vVWFyZ3V4VnN6OThs?=
 =?utf-8?B?OTI1SmI1ZnNhZVdoL2pTamdGMHkvblEzUlY3RUk4TUhOa3Y3djQ5dTQ0b0NR?=
 =?utf-8?B?aUpPTGdRd2NadllEQzRvU1hEeFBBamlwUWpJc1BBbjFoYWNueThXQlBTS1Ru?=
 =?utf-8?B?NzQ2Q1ZVZ01jempLK3JDbysrbzRpR2lnR0hmdzkrREU5RnlPS0R0b04rdGZU?=
 =?utf-8?B?ZlF4ZVdQVTZCUElZeUd2MEU1WUN1bk4xTUh3SXVIUUF2MjBDNkNpMWFzUHhh?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	haahnAMlF1rNirK0PrTqS62sioqzPHU0Tx64LqdDsVIas7hEWqDgFEj7gmxa6KljP94TZiZ5hJArw4eNhTUi3JHsKLkprbOnHH4JFS+nhQV8MUIGSRKVihCc0JMd7HKjHqEIFYju9gNd5oUt/HUZcXQhraXlxwgvVzThtccayLbaQ99JKz9dezBpmCLSyrWgypJSu6ppW1BoleIjdwz6c623TYu05pv+I4QQ9zjs02HuGFAChu12fej1YLYDXrJ9SrYmlsVpCKlR9ps3MqiMsABo/+PMxRr/l9bVyJLXzN2fz2oCXlxRDtbRplUVrwg4UBXIPEOwJ7tlRW9GJROjZ9Lg6Dn7D3weoJyd6cgrYRnUd5XJquxkSkZJyKar6VqR4zYWfHEwBde/bOq+0kuP4kKUElko0t4GW0/nmC0CkUT6ut3tp0goo3+opb6Gql78JK65+A8q0/iNI7zbEIT8XsZienB17wrl4hbTkvRkE5BejTB0xrX7rkiuUN7ZnqXw6Kb8TFW9YsqV0vqJBgiewG5H4vdc3N/UBLC27nW4dCY8flSrVL34dbQLE+IFUUSJLGtSJXSqsGCxTb2Qw5hMUMfiqZPk3wPi/aXiEwlASX8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308d4b7a-7562-4bd6-2538-08ddfec5b301
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 19:32:02.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EROB/1a+jTGpMZMds2yuwDQGbvvcXiMim6H3nrW9HJB2qBZzqh93TFUuDjb1PJZSuJ0XnAijg+M8pQ/47BhEoh6wtG2PapSU+48j/mkZ6Oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-28_08,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509280190
X-Proofpoint-GUID: vQ-MVtjVUgvKKnsm_N4XlfyBlXMYxexe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI4MDE4NiBTYWx0ZWRfX4GYmRqh3BD2C
 CnDqRAbm9AkBYATbWqefID+eYlvvlhdepLX8DCD2AoEHquueb/G5djiRLHJb5c4YSxEQwPJHV3i
 0KLXoROZLBt5j/17NQEb1ec/9Xc9PCyvwIPILU3rQOMx+SDN1U1SjJWjN6fe27hnH+oz980UxUt
 n8fQ5SmHKG5TAO64d7QFXga89q5AKvxaIzHIYiZOtMrjSr1PdD6p2cZL2P7svGYw14LrvjD37J/
 jSISBuwjsX9TRrR4b2+EbWoSAqlkrHb8oa8QLjZ+3bJxemQxnil8MKVxJA8xLT6ZzfdjRt3rrL3
 /3dUWhqGM7KT1NhFqxP6Az0HJLNzt9c7b+dMev355W4xGWXFbDeK3qh7GfIXnydKl7kNePPXH/0
 z4scxLhnC2hmlqmUtnbrnjOOpcWM3HR8Nn5TZ92Aa+mnzrc7oxw=
X-Proofpoint-ORIG-GUID: vQ-MVtjVUgvKKnsm_N4XlfyBlXMYxexe
X-Authority-Analysis: v=2.4 cv=OuJCCi/t c=1 sm=1 tr=0 ts=68d98d35 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1RTuLK3dAAAA:8 a=miCPuyuPU83LgrXPzbcA:9
 a=QEXdDO2ut3YA:10 a=kRpfLKi8w9umh8uBmg1i:22 cc=ntf awl=host:12090



On 9/28/2025 1:14 PM, liu.xuemei1@zte.com.cn wrote:
> +static bool gstage_supports_huge_mapping(struct kvm_memory_slot *memslot, unsigned long hva)
> +{
> +	gpa_t gpa_start;
> +	hva_t uaddr_start, uaddr_end;
> +	size_t size;
> +
> +	size = memslot->npages * PAGE_SIZE;
> +	uaddr_start = memslot->userspace_addr;
> +	uaddr_end = uaddr_start + size;
> +
> +	gpa_start = memslot->base_gfn << PAGE_SIZE;

looks wrong why << PAGE_SIZE ? typo

> +
> +	/*
> +	 * Pages belonging to memslots that don't have the same alignment
> +	 * within a PMD for userspace and GPA cannot be mapped with g-stage
> +	 * PMD entries, because we'll end up mapping the wrong pages.
> +	 *
> +	 * Consider a layout like the following:
> +	 *
> +	 *    memslot->userspace_addr:
> +	 *    +-----+--------------------+--------------------+---+
> +	 *|abcde|fgh vs-stage block | vs-stage block tv|xyz|
> +	 *    +-----+--------------------+--------------------+---+
> +	 *
> +	 *    memslot->base_gfn << PAGE_SHIFT:
> +	 *      +---+--------------------+--------------------+-----+
> +	 *|abc|def g-stage block | g-stage block |tvxyz|
> +	 *      +---+--------------------+--------------------+-----+
> +	 *
> +	 * If we create those g-stage blocks, we'll end up with this incorrect
> +	 * mapping:
> +	 *   d -> f
> +	 *   e -> g
> +	 *   f -> h
> +	 */
> +	if ((gpa_start & (PMD_SIZE - 1)) != (uaddr_start & (PMD_SIZE - 1)))
> +		return false;
> +
> +	/*
> +	 * Next, let's make sure we're not trying to map anything not covered
> +	 * by the memslot. This means we have to prohibit block size mappings
> +	 * for the beginning and end of a non-block aligned and non-block sized
> +	 * memory slot (illustrated by the head and tail parts of the
> +	 * userspace view above containing pages 'abcde' and 'xyz',
> +	 * respectively).
> +	 *
> +	 * Note that it doesn't matter if we do the check using the
> +	 * userspace_addr or the base_gfn, as both are equally aligned (per
> +	 * the check above) and equally sized.
> +	 */
> +	return (hva >= ALIGN(uaddr_start, PMD_SIZE)) && (hva < ALIGN_DOWN(uaddr_end, PMD_SIZE));
> +}
> +


Thanks,
Alok


