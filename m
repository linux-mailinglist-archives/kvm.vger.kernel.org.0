Return-Path: <kvm+bounces-18075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CBA8CD9F8
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 20:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F08C2B21940
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 18:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D5F83A07;
	Thu, 23 May 2024 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NhY71Cux";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oopJjKRw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7706F80603;
	Thu, 23 May 2024 18:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488897; cv=fail; b=GBMIV7LKSOCuk2rGXCoaj49qd82G4wAjX05lwGq2o4ucCinzzseZwNfupLm12RYCTi881BER+gAsVOj3s8MDoJzsBds8h30cQ0Dh0oZtfoiX1rBci+gctJoMQKzgKu7BuUwXow8rgRuUeeurW1d+Letrzo2ytFP5z8NGGiohrl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488897; c=relaxed/simple;
	bh=zWT7ZWd4/x158EPapd/vDQ3gk9PQ1nIah4OaCntqrZo=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bGTkATyMZqOYVvi6wBOrefI6dE7tOKOPFu0+zFrR7YJvEnVM4EvfX3xLJATK5VPjcwxAYEH3Q5CXSDGF5dRw2FpNekFa8L7WfTjszlP2JN294i9pOPjtpz3306SMDgEPVCDSI0Fr+yZMSjURlXuH7IK+0heNrWlMAt95Y7Aqtz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NhY71Cux; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oopJjKRw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NI7i0l014860;
	Thu, 23 May 2024 18:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=StJ925MUDGiKebspKdYtk1fxVH7chLRRl9SU94kBN+U=;
 b=NhY71CuxzHyxANCQ7yH0HctopghCX/ukgzj31CUpPC28NuAvklpjvdZIe8/WNzX8nM6b
 fwnuZK4Vk27x2kSdUfr2prgtjeJd1EnOA/giYB2z22So4Kka/4mGEaYEzybeKBUYOcpO
 R/f5hIzxk/8TPqZLF6H4vMU3mzDYa48ZJ6Ea5eL6MbcguSPPGJ4LBdcIEa1uoYb8CVd8
 C/brte3nT5RHTtWoZ7LHgxots5kZyPGpzZrtBsRzhen5d9jOlxqwBoNAo4CcCguMaJ3p
 Pa0EZuEURWGyJK9j/VW837Uj5T73eLZHwt36EGTh+d5QFW4a4P32e7Lzr5JI+Rzp5Gl2 Lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7bahr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:27:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NHxZoT038956;
	Thu, 23 May 2024 18:27:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsgybbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNI4cRJhDuHl8TlSei5l00MANkUYht1YsGTMKcCWY4plWGYuIE4O2u5kOoDbMkTTqLSQ3Q39WuRIL4jcmKnTGDw+xa5gzC9g6tyIFAaz6/9cTUA1JJBQME9gZhT+HxeN8as51CV0NCb/psTBIz+EZRoVxAdemJqyRjmioXcIprMIfymRglJ1YBval3LalcvSkgNQEwSXDB78cSB4IImkaPg/n3bnxHdFAEJvdG78rC6PcX0kq+hGMUcGMo6E+J8yoJxf21G1xHlIc87Sp8+CSVd6u6gmOJEnxl3ORPi+YUwuoGlYG09Fy3FSCrMjqnFYse79/IdAI7vTQWN5Rh2nvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StJ925MUDGiKebspKdYtk1fxVH7chLRRl9SU94kBN+U=;
 b=GDcXxD9NtBRRzVzpAVdTRN17Wr2lLAXNuykPsE0dLU8VKmtGjJzG27rkjurqw6jfb/oi1uuUyFlBO3oNxrVCSaFaQiGdF0v0c6MA6vQ84fWVIah+CNZZ4jrtUxRxSO50uon3Xygtm0OL8K38VJFYuO4bbBjYi53aW7n9+h6WDI5CP71O+W74VrQKHiPF8qdXrhKHfzTbNmmrPinjPfIb8wy98ZO877R5dewrpCeJAImAgHOm/XMDgT4Rwu/amZovEYwn60hT/KPAB+uRAGeIKvm+q9JtleVTic/v6CSE8NEbGQyxgS5PmVpwOA+v3G1tIZqCKmeC+p5WSitUqVTckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StJ925MUDGiKebspKdYtk1fxVH7chLRRl9SU94kBN+U=;
 b=oopJjKRw0tVh6/srwh+S0WT0RwPY3eyyXHXwqVlWlpuoxrpC3EdDR2dp9afx3dVrtsBT1pywlA2fx8nGWNlVhdOZHXtN3EcEYHhx7Z5lgWZuL8SJJGYVoi2bNU840oYXPjrmrR8TRIRhcoOOS1Qtrz+xsRSmdtYokAuWFRZzqE8=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by DM4PR10MB6742.namprd10.prod.outlook.com (2603:10b6:8:10e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 18:27:40 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 18:27:40 +0000
Message-ID: <d9f5a2d4-9c73-45c5-9de9-12a4d1d9ee99@oracle.com>
Date: Thu, 23 May 2024 20:27:34 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
 <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
 <93510641-9032-4612-9424-c048145e883e@intel.com>
 <5ed7d3c8-63c3-48f3-aaeb-a19514f4ef5e@oracle.com>
 <0fcbfcba-9fe2-414c-8424-347364fcbf35@citrix.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <0fcbfcba-9fe2-414c-8424-347364fcbf35@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0407.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::16) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|DM4PR10MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: f1cc1cc1-2a14-4af1-fe84-08dc7b56076b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NGtMUGlldDkyQzVTZXRpVzN4TDloN0JjaHQyeGxhRG9keEs1OURWNTl2TkNT?=
 =?utf-8?B?K2dOTlp0eTlQMG9PblN4WnhZVng0WnRQYlhpR1gzZytQNDk1UE9Oc0hIbkNi?=
 =?utf-8?B?VE5DZDB5R2N4aFovYnpycTZFd3JQQzZ5ZkJNN3dBWE14Q0ExQWdhcTlvcXhs?=
 =?utf-8?B?d2JWbzVYbGhRSnU5dG15TmdkVGZhYnF5WWxDNExiaVBFZWhuRjBNZ0RyWXl3?=
 =?utf-8?B?MDk5TkF1b3YzVWRaNzBhWGVQLzZBMjJKZzQ5TXQyNCtnTWU0NTB1SUlpK092?=
 =?utf-8?B?aHZISUNSL1VlVDhOMzkvdlBGN3ZYbzMwRU9Qby96eC92QTNaWDE4R0JLaUNE?=
 =?utf-8?B?RlhHcTBPelRNN21iSXJJM1R4MjJhdEJwU01FMXVteDlnUmZycldGa3dnV0pL?=
 =?utf-8?B?Vkpubk5oQkxyVTc5bCthdFV0MUFvQXBlSDhab0ZlaFlpSjBDdVJyUVd6M3gy?=
 =?utf-8?B?ZjdpVnZhMDVkVEFKSy81VXFrOTVON01USWVGcit6QUJSZjBrMHBwZmpjVnQ3?=
 =?utf-8?B?bHkwZnZyaUlOK3FpVjk5VVVEVFYxRTA5VzR3R0d6V2VwNGxXbVI1aWlvdEdV?=
 =?utf-8?B?TDNmNTg4RlpRTklkenlvUGdRVUYvTFpMSzdVazVEWFp5emxhUkJlZVNkU1Bk?=
 =?utf-8?B?akRBRmllenJ3NTVSN1NsdExNRkRaZGd2c2EzTVBLSG1ETTMrQjVvRUFFOEZS?=
 =?utf-8?B?aDBPMUVLSjRZR1EyejFEU1F6RnJHRTEzT1V4Z25DMUxKYyt1Q1Jtbm93NE0x?=
 =?utf-8?B?eU5BQjllTUhPcWxUazhYdmU2Y1VVaHV2ZTRrOE04emJ2dmhPYVhZVG1pSUdS?=
 =?utf-8?B?aFh0VXRZbGcyVUZCSi90VWpwZVFNSVlMTUlZdzlzWnNIRXYvK2c0dnpud3V5?=
 =?utf-8?B?ZW91V1R4ZVRLb2xnZ3ZzbnFOaHdYbG5OK1pZSUprb01Rbkp2dFlGRDlaMHM1?=
 =?utf-8?B?N0hJQ1ZNdmcrdW5RbGJ5VEliR3RXS2NkQ2J4TzlLdEkwcVNWdjZ0bm05NEhQ?=
 =?utf-8?B?ZUFGempsTjBSSXBiTlZnaTNrdnVtQVFWSlZxSURhUlNRR3Z3c0FYcnEwVUVk?=
 =?utf-8?B?c0xRM3NCVnZwQ3BST2NjMEFYYVMxZ3BUM0RXb0I0SEZUa3B1Q29lZWY4L2FL?=
 =?utf-8?B?RDZaZEFYSkRnYUtJbWxWZHljaFJ3RnZyQk45U2MxbzVETEdTYTBFcjdRa2F5?=
 =?utf-8?B?SDlmQ0pyQnNUQmJNQks3YnFjYWFoWjc3U0VRNjZ1SU1PNjU1NC85c05oVkZr?=
 =?utf-8?B?Mi8rRkJqUFhoSlJDV0c5cnMrZmFwditxM1RzR2prU2dLTTl1a1dDVlYrMmxt?=
 =?utf-8?B?Z1pIREJ2SlFsa2pqRlZJbWxBSHpMUVhrWG5jVmc2dDNSOW5Yakh0YTh2aStU?=
 =?utf-8?B?M3lJenkyL3VZcWtMNEZXZnIvTnRNTEsxSG91SWNPMGlTZitGQmV0M3o2dUx0?=
 =?utf-8?B?VVM2dWduMVlkcit4aFZML0dlRXlyZ3pEQ1JwZXN1SjFSOUlTRDFrc296emk2?=
 =?utf-8?B?cHJ3N3Z4RzFRQVZTbDcwR1A5YW5SaS8wUnl1UFZGV0ZLdzN3ZDZOMHFnU0Vt?=
 =?utf-8?B?NDYxdlcxUk5OV1RXNFk5V2w3akVBaU9qejU5N01RL3p3bU9ka2Z2VytNanFG?=
 =?utf-8?B?MG44MGg3WmNTeVdJTFdlRnBvQ2syakpwRVUwMVBuY0NZQWJIakZUZWZ5dFNG?=
 =?utf-8?B?bDNrK0YramdPeUVzenVQZ253YW9HRGxCaUZ1ZEZMMDg4cjFZWTBNVjN3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?STh3Mkl2VlNteU5BSFV5TTIwaURDcjR1QTl6dHRZRGJTK250RFJMYUQxV3Vq?=
 =?utf-8?B?anVEOFllK3lYQ3VHQ1JIZG9BeGs4UXFvdjlvUXBBd3JwbmRGbzdZR1JoVGlU?=
 =?utf-8?B?Z1ZiR3dUVmxLZGhxbldENVpkWURIdVNkWGFHSVMzUVVBOHN4WGsveDU1VkIy?=
 =?utf-8?B?Y0FBUWtIeUd4WVYrelk0dE5xUmd5ampNV2xaUVNybURFbVM2blNXSVdtMlly?=
 =?utf-8?B?VTBNbTdRa3RzUk9mbDVNV2F1Q2htNmdoWTdORGdMWjJtZE1IUThwdnpya1gy?=
 =?utf-8?B?dTlyNk94OEZrNy9NbFJWcmxGdzZJSHpaNmxZbVVOdkpseTdnN1NwbnU4allJ?=
 =?utf-8?B?S1lsL1BqUWU0M3FRRG1URkhSQXZTbWJJQktYRHhNRzVPdTdxK210TkJ4T2dk?=
 =?utf-8?B?QWJYeHgxOUVXNC8vUDQxcGdhbVZ2UnlFdk4rd3hBQ081Wjh6aWt5OW9kWjEw?=
 =?utf-8?B?MGJEbUYzK3A2RUpncXREN1R3SFJ5c1RJczlDN2ZleG1hTGdEalFsVDZyMFhB?=
 =?utf-8?B?bThsanJJSXptVjZBQmI0WUpTelBudVMyekZXNXhKTklKNERlK2t2aHBoYjF6?=
 =?utf-8?B?MktQa1VEVUFBTHZUN3ROdHpNTGlNVjN5b28xOFpFYlZsT0ZlbXE2UXFjNEtY?=
 =?utf-8?B?VzZMVlBhdjZkVk5NVnc0M0loTXBuTUhGamZtbGllWW54MGg0eTM5dVRIelM2?=
 =?utf-8?B?aCtRMktvN1JkR1drcEJHUUY2SHR5akJObHB3bEFmaUZDMEVBaDNZekR5ZE5k?=
 =?utf-8?B?SUluR2ZjYTJaQVJWM3NkakxuOWN0QXJ1YWdxSHhvc3p1QTFjY0JZbVRYUGM5?=
 =?utf-8?B?cVZMRXZoZFlxWjBtVDVNZ290Nk5QVnZpRXpNNlFCMHo3TXBQZFdZMDYxYjRP?=
 =?utf-8?B?eTg4TGNQRkl6S1VWc3E1MGR6QUF0SzhtMXVIc01TcWdiajJWRFgwNHRqZlBR?=
 =?utf-8?B?b3FMZmJEWjNBaVJaeFRGZ0tXNis1UGRRa2FXU0NIQm9GTVVzRjJNdzhnZDRu?=
 =?utf-8?B?WEhlLzdUUStTTUdqT1pZSnZPU2xjVkhpYWtOU1NrNHY5SDdTWlZLdUR2V0JX?=
 =?utf-8?B?cGUzbytyZWxEeG02dlY5UXZJcGRiTTBCeTdWOGIxL0NKNEREZzloWTIvcXBs?=
 =?utf-8?B?NTh0Z1JKNzRuUGN5NU1BdmZxOGVFYnZ5bWR1YUEzL2txWUxybTJJWGJGcEho?=
 =?utf-8?B?dXFaN0pDRE9mNGRFRHRuNlF3MGhaYU1PQysyVXV1bStnZHAvVWtnWVNpUHR6?=
 =?utf-8?B?QzZ3ZndCV0QrMk9LVDluSUp4c0x2MHhkc1RoZ0J4d0RsOTJQTXI1WDA5SFhK?=
 =?utf-8?B?Q2p0SytSbUg5dDVOOFh0WXZBb2lCamdGN0V4b045aDl2NndFRTdKdVJVL0ky?=
 =?utf-8?B?ZWRSeDR5aDllU3FlU3VFOFRjQ0p2dFZVYU1pZGJMb0ZrcVRWYmliSmlXTzZJ?=
 =?utf-8?B?eVh1TUVrZ2FtRWdyMnpMZGpNT21uTUM3OFRzS3N1R1FsRjJMcHViVmFVamp6?=
 =?utf-8?B?SXFBWjQ3cWNZVURLRzFtWDFGVEpkbnZ5aFBGRzVZK2tHSmthUmxNMzh1Vlln?=
 =?utf-8?B?RS9Vb2NXVkFEOUVoUnhsZFNBemR1ZWdGQXU5RTA0ZUEyWmswTzRZT29ITFRQ?=
 =?utf-8?B?Z1B3dXhSQnNSYVMyMm80NWxtcUZaWmcrSitPWXh1NldDREhEZEQ5bkRMRUtZ?=
 =?utf-8?B?WHVZb3d3bkxDMVJpNmlTT2pGUWYxN1VIZnZJakVCQjdUcTZUeFZKY0hpeG5D?=
 =?utf-8?B?aUM1VU53bXAyY1E0dlFCdFNpRDd1ZzJLVzBpTWdOeVhURDRjQ1BKRmV1SUw3?=
 =?utf-8?B?RzNyYUMxSzdpVCtqRXVxc09oR0szTGtxWjlscEVQU2NHSGdtRFBTcS93d1hp?=
 =?utf-8?B?cjhCTTZyMGozV1NOSjBvRjNoVG10b0EwcURHOVVVUXBGNEMvZDFaYTVrdG5P?=
 =?utf-8?B?c00xYkJ3MUoxc05jY3pmY1BhcTI3cFN3S2tJaTVjY3EwNmM4aXNyajk3eTFk?=
 =?utf-8?B?a2VvelN3N2RNc3NaeVpVY1hxWHVSelJ6STRBR2VTOHlkQ2Q1TGMwNGI0cUZY?=
 =?utf-8?B?UTJ2c1E4L3FsemRlWDZFTU0wVG84c2hNTEFSaEdHNFlsakVzYjNFNkdHVitl?=
 =?utf-8?B?Rjh1VjBpMkNmWGxMdVd3ZTQxcVRYTkdkZy9IZmVXWU9BZDc0ZlJJb1lpSXdL?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eGSGD2Sc3Uuj7s+nZs0AkfMr1/OcEVTLbHTBuFDo4Xv0uvjNZjmNOMu0uhe+Zg9+QZGjdzoq4pbN/GoV5wVxqszriMBw7X6re+TImuPhYpZVwdvpuM9RRvoKpGsVyaKMFZa3/pMERpXMj/W32TPzC88u6038m3iKuu7tRdfXSXsNqk5kkpUD2aE32Qkqgm5WS158nejWSrYPl9a6M2SsDoNtnr3B8KkpFgZXsLUakeEdJwMc4sGuQd5JCLNCfwBFiryxh72m0oQ3Ah3udASIc6vW6dKkLQZlwXtQMrzF5eMzgCKUOAywP+R7567b1R/XSYPfjTuaq36CUNfnzqImm/4I/zaVI3rp323ajz1UImG9jWhMMwOnVLGVzfDlQsG/Y40O3BiEiL1gh7XFAZzpT3Y2gnQ0ZxkVB58N8kexBHdWlZiGh5sC/xh9RIa+EWKeBlokK5j8vQlgQF62SmogPo6RxLMqZjmYkyobdd+COIUj+Jif4thITOfi1kHr+v2yH1c2KvjD9XOLhYNPoKry/scY/Cy8ayzIpP5/tnzWMgrwdmGdMyfUtn7roTD+NIbzFX2foKz6B8GxiNsDZ710Nq4BJ4MSmBXmc0W10gvPH+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1cc1cc1-2a14-4af1-fe84-08dc7b56076b
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 18:27:40.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIi3AWnDmQLI6V3BqxL7Gm7Hba3exXeUNNBEAOy+oQCxoVdt4ubNa1JjWeGmCvCJdIQdVs+dPesuo9idjL4RE3tt/WZBF/GVtJfzvn6A+6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_11,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230128
X-Proofpoint-ORIG-GUID: YC2FsNS1is_UWYkpqkeDbiFnUPo7YPYF
X-Proofpoint-GUID: YC2FsNS1is_UWYkpqkeDbiFnUPo7YPYF



On 5/23/24 19:53, Andrew Cooper wrote:
> On 23/05/2024 6:03 pm, Alexandre Chartre wrote:
>>
>> On 5/23/24 17:36, Dave Hansen wrote:
>>> On 5/23/24 07:52, Alexandre Chartre wrote:
>>>>> Should we wrap up this gem and put it with the other entry selftests?
>>>>
>>>> It looks like tools/testing/selftests/x86/single_step_syscall.c tests
>>>> sysenter with TF set but it doesn't check if the kernel issues any
>>>> warning.
>>>
>>> Does it actually trip the warning though? I'm a bit surprised that
>>> nobody reported it if so.
>>
>> single_step_syscall does trigger the warning:
>>
>> $ ./single_step_syscall
>> [RUN]    Set TF and check nop
>> [OK]    Survived with TF set and 26 traps
>> [RUN]    Set TF and check syscall-less opportunistic sysret
>> [OK]    Survived with TF set and 30 traps
>> [RUN]    Set TF and check a fast syscall
>> [OK]    Survived with TF set and 40 traps
>> [RUN]    Fast syscall with TF cleared
>> [OK]    Nothing unexpected happened
>> [RUN]    Set TF and check SYSENTER
>>      Got SIGSEGV with RIP=ed7fe579, TF=256
>> [RUN]    Fast syscall with TF cleared
>> [OK]    Nothing unexpected happened
> 
> :-/
> 
> What about the exit code?
> 
> I find the absence of a [FAIL] concerning...
> 

$ ./single_step_syscall
[RUN]	Set TF and check nop
[OK]	Survived with TF set and 26 traps
[RUN]	Set TF and check syscall-less opportunistic sysret
[OK]	Survived with TF set and 30 traps
[RUN]	Set TF and check a fast syscall
[OK]	Survived with TF set and 40 traps
[RUN]	Fast syscall with TF cleared
[OK]	Nothing unexpected happened
[RUN]	Set TF and check SYSENTER
	Got SIGSEGV with RIP=bb44b579, TF=256
[RUN]	Fast syscall with TF cleared
[OK]	Nothing unexpected happened

$ echo $?
0

The program runs as expected (but it doesn't expect much than a SIGSEGV).
It triggers a warning from the kernel but it doesn't check if a warning
was produced.

alex.

