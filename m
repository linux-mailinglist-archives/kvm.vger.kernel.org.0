Return-Path: <kvm+bounces-9332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFA885E3BD
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BD301F253FF
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F2A82D9F;
	Wed, 21 Feb 2024 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UF5qrZub";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q54iaxlT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60183CA1;
	Wed, 21 Feb 2024 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708534221; cv=fail; b=VXLN3DHm8QyKzAt1pW8hA8OxwqPtMt7WTSV7eykYH9t2EJfVRSRtR4z5urMhhj9pUByqQXGo+9sNifqL+OBwIPYo9ZrwPgVwGrS4WbmvzGofUzQz7TKwOpOOkceQ7M7jLPkrN+q8ZQVyGzwpuKMylY2/rye+ts+ebgSf1CahKHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708534221; c=relaxed/simple;
	bh=TI2i2/vaDereIwvTbZWwgMpndBRE587lDcKTRYIJ2q0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jo57KN48YHy/2kDpy6WTebkwDV8WkDkKU7sf7q8c2InCrnkA9PS2LacvErW02eL5fEvMhViFH9/mlIsUi/qp6GZeamDXj4ZHu9LyY6WQ4mDQ/8uls8tQpkOnZb5ttse1YVlpSlbjDYGLL+2eWAiGV7R9uxfMnXfM4MrdOF8ZeTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UF5qrZub; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q54iaxlT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41LDioEw021259;
	Wed, 21 Feb 2024 16:50:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=j20MkO96u2EmMxyn9yFjzHK36Z/Kag4cqvmspnml+/I=;
 b=UF5qrZubDAkx07GcZKeV/EQnwgW7VdI9+oRtt8bl9rzIlE1mgtkVMLKfG18T1uRurNxU
 loP2ewtZULCMXxn+5T9RIe7fZGckEkcNmJgD/PKMlY8TmZ7TR/POfraKkXUoujm9oDpo
 YlI9dOGXOcWTG2TPZ5or+lxFZmJWLCHgRRGjbJzrecUPPvDR+FvVN/lRIrKWhZTciOvD
 icru6mk8Thy0InoIrc2WiX4TNhF/NNYjE+L4Yd7Q9QMHu2/UMzrQ8k4c4XMEp6kneXZr
 yNqLWvjKgQ8+GKJxNDS9bKTlPZZWv6/QMic6RuiOBMdtfudmee5uAblUnRNRk55S7O2s 2w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamud2ct7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 16:50:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41LG9lDi013008;
	Wed, 21 Feb 2024 16:50:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak898n2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 16:50:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8czAhKZqgRYGJqZaxfawhEfq3pPl04LuvmJh7rmN4yQ6MbASFPQx1iuRlwsI/AqFh+TGrF68c1uSwZRFAfa1o/RLH2ZPSsfxLu+jaiwf1FSWo04S8/lwScsUnz6jaM9v9UNUaBswGRTivH9ZAdk+DTpRqNfuny18lnroUjyG1x3zUf9h3fK/sxknK2JWqmTPBc2Wpzr0SiQABAeycXkf3FMgaPnVrGjO0iTxqzSDmMiloaq5fhWhrYVPkTwrnh/lXaWWm6qTEdImnC4vCDNPH+mnSG/ZgOQaQBiwYPg6m3l6TyJ6ZdeZCLXBhhg+0ECMDsEerDYNq4oFpwJHipmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j20MkO96u2EmMxyn9yFjzHK36Z/Kag4cqvmspnml+/I=;
 b=OqvNFmwKM8Sx6Lq5JttQ+0EDcC9qs++4AG2Bj7RHNVHQ4/EoE9Q7S3hh9OkQHvvgLKEPJEjP3uSLm2KstwjCVXMaDozzzMOPtHswya6d40lIvNHXvl6AmwzDwoAwRerLNl+ANkMZxCEETEwtc8iWMb/Hw3Hf88Etcg32nub9hppTsI8YfrhlUTuEajzuMYkWpR4tHSrj5xwri4xdejrWkmdfsMfv8s5doymCL4iEBgTOAq4hiOkglXw5GZhOLyV9hxtybC3N420748+b99dPvEBrxvY3JHZnsN3zxrIw2unCwBDEB0+781yXob2zKk4XWJmHPDYh2fCLOZv9f8imnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j20MkO96u2EmMxyn9yFjzHK36Z/Kag4cqvmspnml+/I=;
 b=q54iaxlTqgKrG2QvdYXo++AAwR7+OWvjqis0ivfDhtLtDPOp56WFVSJWs7qVUu1huCSPdaAcujuOuRdZcLStlmmY9V4C1on1W2ucPop+CRaTXQheDjFtZkrKu0IkP5OS67mcyRGH/4TUODJwgDjmCCBu9ZJggajsB9WUvRz83YM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH8PR10MB6412.namprd10.prod.outlook.com (2603:10b6:510:1c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Wed, 21 Feb
 2024 16:50:08 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 16:50:08 +0000
Message-ID: <0c8f3f2d-11af-57b9-c922-94755001b973@oracle.com>
Date: Wed, 21 Feb 2024 08:50:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/3] KVM: VMX: simplify MSR interception enable/disable
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
References: <20240217014513.7853-1-dongli.zhang@oracle.com>
 <20240217014513.7853-4-dongli.zhang@oracle.com> <ZdPXTfHj4uxfe0Ay@google.com>
 <05571373-5072-b63b-4a79-f21037556cfa@oracle.com>
 <ZdYaIn7xwqTPdofq@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZdYaIn7xwqTPdofq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0157.namprd03.prod.outlook.com
 (2603:10b6:208:32f::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH8PR10MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b0b20e-569d-41c0-da07-08dc32fd2968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ISA0ulsg9PtYKcTB5l1gfJ+ogs+/ucSuG5HUcCehhjgwDexnb1iXF+e/y1bHNC8J/ZlRSnXYyCld9sWPXrsTuNN68I2dra7f1MvenQ/TLnez6y4x2F09BaNGdbsROME3bQPVttdsyvhsn2qIDecPfASrwibRGMQHZsxHbhixBF3fVUvdaWC2vk4sPKHgeTo2dyNwBMrkSh5nf7B//UqBtDPJ+0Y4fOMoUem8E97NS7wflnaQXFGx49Pt9hejhxhVXI52J0jx26G0++OArkq+UD93u3B9KVw38jShAPVZlBhFJPbqauoZP6634rdaw3g4Kiv7/YGTaLRRaMc0T7tmdddmzJipGMfzwMN5URqfRVNLAGZ7zCPnX45b65Tg2y5Iyny3ByGtnKg6LgjUBlXp6VzdFCg2gptqMJacyoUZ/49Jp2jsfqscLhcjKZRfFjXHA/aP8+5G/FPUaWfgU0E9iV6iIxOTmR71nmVwL4d00gKBY3heMZjDo/ZZg2TJJBnnUeOq/sKf6Qh3IfbpWoJy9j6wQ996jCAzGpTPru6mTRI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NUI5V0hXbCt5MC9TQ0ZRNkMzeGxkV2hwcnNwS2xCRm5HbSs4MWx6enRMZW4y?=
 =?utf-8?B?UG1ySEpqME9oZ0lIN1RxaEpyVEV6NjI3TXJZbS9IdTVCdiswRW4vN0hDWWtQ?=
 =?utf-8?B?d0dVOFVRTGJXM1pxM1kvRzlOREI1S3dCTk5oOG5hZi9DRi9NWFkvbHFtSTRm?=
 =?utf-8?B?c3NMdmJpWFUvUTYxZDk2RzhnUnBsSHhYYzJjK2kyUjdsMGxqNTVOWE9mOE4w?=
 =?utf-8?B?OVQzaTFDZFlMME02a2NadDV1ZFg2ZzlhbzM2N0l0THNkamJRN2t0MkY1RS94?=
 =?utf-8?B?U2FNenpEWGt0UjM5S2dZRGQrS2ZSblV0dlZNTnNaOFAydEh5MkloWHZCRXho?=
 =?utf-8?B?a0JZTXdSUjA4eTA0dVNmNEFaenplNGx1R1NHaDV3MWlBQitFaWtYSTBXTk9W?=
 =?utf-8?B?M0pON05ZTTZPREE1a1A4RG03QlNCckQ0a2J4R29wRXVSemp2UDJUaFduZldX?=
 =?utf-8?B?cm1id0tCSVpMcDdjeUlCWXlJNHB1SEJNMXk4ckovbWZNRXVxbzFmajlsdEhU?=
 =?utf-8?B?Vjd5Z2h5b2lCSmZ4cWhIN3Nrek8wYmxiMjQzdnlSZWdqTGsyUFdkcVNEWmhN?=
 =?utf-8?B?QlRoaHFoT2RYTHhCL3VFak1OdGErNGRuMmRudHZCM3V1U3R5SGxhZEVITlZ5?=
 =?utf-8?B?Ym5HOFJBSjhUS3ZzYitCYzVoOFFGQnU5NFErZWlVNVdEOHlpV0kvVlBCYzUv?=
 =?utf-8?B?MEJSOVJkQzhZTTZ4NDRoVUpuSzRCQ3pJc2lxdzIraXYvNlh2c3A3UzQva01l?=
 =?utf-8?B?SGVzQnpCdnRKbEFaMWhVaEdXd2c0L3dhbnAyZWRFYi9aTXBNQm9Xc2EvSFI5?=
 =?utf-8?B?VVBsQ25qSFg4a0lzdGtYa21YV0ZNbGNZZ0RERlVoUmM3eS85NTFqQVE5MHAv?=
 =?utf-8?B?ZkhNb2JqQU1reTR6WGJRcmphdFM4MDRFeXRRczJ2MndKZlBTUXlsc1ZybUNZ?=
 =?utf-8?B?RUdQUG1XeUp0QzMrTUxGL1BTckhoZ2ppSG5pb3A3bng5aDRiQm9xZUNyd2My?=
 =?utf-8?B?bU9oSnRMckI5c0taUThsTVVVMVhPSGpxYktLOERQcjVBdzNYVlFHTEp6NXdk?=
 =?utf-8?B?NnJVd3FKalR2UzhGZEFTSE9DWXNqeVZrZ3QzU2RROVZJbDJ5U09IeW94aitB?=
 =?utf-8?B?VDVTdmxXU2pTWVVPTDRlM0FKN1dVSVlmbXd1TDZlREY0RGNsUnNqK21OS0t2?=
 =?utf-8?B?eTBGUVNKbi83eUNOeHNKd09BL0ZnbVRmNkVnZFkvWXhhREJ6VmhyMGNNZkdE?=
 =?utf-8?B?VGlTUFZ0TForbE42UHViUCtjZCt2anNQNXNWSC80S3BZRWQ5ak8wMXAzY2lN?=
 =?utf-8?B?ZnNLT0pUTk5QdHUrVDNQbkdJMHcwYVZZOWg5SVc2OFo1VFJ3d2s5aHBPd3Bi?=
 =?utf-8?B?emtXYk5wZ2tvZHRSKzVHT0wxNnJGblBLVUU1blZ1c2tyclZlWjg3bEZRY3pF?=
 =?utf-8?B?c3A4aUx4SHUyQkw2QjJjWU9oNC94QVFzVGJFOVkyWU13N2dFb0NFWnhBakFR?=
 =?utf-8?B?WGNZTUgxSWk1YVl0T3JxNUY3RnBuM0xPcjNYT2VkMG5EeEFnQUNYOU52V0sz?=
 =?utf-8?B?V1AxQWxnVWZTRStNM25IUGRoQk9QeG8rTWR4S2IyTTRsZjlyWmkwV0E0QzVV?=
 =?utf-8?B?QXB4NlRhZno4aFg0RUw4Z3RRVEQ0Si9Sc0QyemFXeUI2QUtjYU9UNjlGaVJT?=
 =?utf-8?B?NlpZRWl2SkwrbVpJNlNXVHlpbWZtazVrd080RDBDTFRYdTcrSTdqTzM4bmU5?=
 =?utf-8?B?aTc4eVF1SGg3NXBjaTJoc2hXYkxnWWYvdWduRHhydTVUUnJ4WE0xRWcrSnli?=
 =?utf-8?B?TXJkQXFXbkVQVjhYY3RUNFZBQ21BdHBtUkxQb2R2cnRvZTh3TVVvM2JtTDNo?=
 =?utf-8?B?ZjRwbE9DSFgrZXQ0cGNZUzhwQzRSeFZMUmd5VWdUTTduZkNPQldCa2ZoTzdL?=
 =?utf-8?B?UU9CRTVLWDhyWEErdWRTejM0RUc4OExMTWF2bWxITGl4Q041RkRFYmI0UjV3?=
 =?utf-8?B?Rm5ISzZRY1FHZWduOTJ0WW5sbGhyWkh2OWJPZlkxdCtib21kYjFBdFhrUmcr?=
 =?utf-8?B?TlRoemo4SnFkMW10ZTgrZ0RkTTdjVk9oMFBUVjJiR3pHN2Vnc1FPcWR0ZDJt?=
 =?utf-8?Q?uz3pYqris5YsgoizW5DGHKzfo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6+urZHnRUePSppORM/IFrp01iD9mGIlOmpDiZ+CajFAzozdBWzCWP2naFxXsIE5T1gi6eddNlXdYnG3yzCvSNoDyNYTWkA0NdGpg2JKYRRfYSfpTQ/f2kKZGMee9aGBOAk9tPaK/ldPXGAzb4wzkOcvVJEIbZ3wI732ALo5lA7+ezBlHtne3F4kA7N7fcZGlOXZM66YMy8tzB50cIAkDnguOjLDP7kUJZUgf8a8Uj8QnG6ugvLR2C07IGPVDw3rZqot6pvjd++EZp8tt76fYb0EDzESzJTzpr0RPaf6cA3JBFsbNBlF9mGVuAu4S3JZ71jRCNsuXu2+HVttp4WnW9gVPJl8nvi5cAQ5Vc2WndxCqQxPX/P8DtfQr0jTpfPdigmwvbTwXz0ZbstrnNMv4nK2yY5qqdcuiavJQVkyQkO5VBud0yoTwmgds4jTI3wwzEFCSyjngdXEz2pEX7AahSLvKJm9FUCF48ymw+D4hTfAyv+oMYY/wkJy4WJut/Zmqx75+Hk+1m1nSIk+u7BtiZ7RbId6r2ujPakhpwy/1BFa1p6/auuhevpQUy1h1/vYccZqrIWODJFia49vLzRNHwAmvRqeBG3x7l/cjzeA73ok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b0b20e-569d-41c0-da07-08dc32fd2968
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 16:50:08.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zE23aJzHPX+DKKCmm0fMRZe1nkIi/C77qC3+HpRrv+NOkA2ZmbeYvwbyliilyge7pr6izDL2lNn7G9HNsUnXEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-21_04,2024-02-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402210130
X-Proofpoint-GUID: ApMURgN-KF0YXfom1dCpG3bCRosi23KX
X-Proofpoint-ORIG-GUID: ApMURgN-KF0YXfom1dCpG3bCRosi23KX



On 2/21/24 07:43, Sean Christopherson wrote:
> On Tue, Feb 20, 2024, Dongli Zhang wrote:
>> Hi Sean,
>>
>> On 2/19/24 14:33, Sean Christopherson wrote:
>>> On Fri, Feb 16, 2024, Dongli Zhang wrote:
>>>> ---
>>>>  arch/x86/kvm/vmx/vmx.c | 55 +++++++++++++++++++++---------------------
>>>>  1 file changed, 28 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index 5a866d3c2bc8..76dff0e7d8bd 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -669,14 +669,18 @@ static int possible_passthrough_msr_slot(u32 msr)
>>>>  	return -ENOENT;
>>>>  }
>>>>  
>>>> -static bool is_valid_passthrough_msr(u32 msr)
>>>> +#define VMX_POSSIBLE_PASSTHROUGH	1
>>>> +#define VMX_OTHER_PASSTHROUGH		2
>>>> +/*
>>>> + * Vefify if the msr is the passthrough MSRs.
>>>> + * Return the index in *possible_idx if it is a possible passthrough MSR.
>>>> + */
>>>> +static int validate_passthrough_msr(u32 msr, int *possible_idx)
>>>
>>> There's no need for a custom tri-state return value or an out-param, just return
>>> the slot/-ENOENT.  Not fully tested yet, but this should do the trick.
>>
>> The new patch looks good to me, from functionality's perspective.
>>
>> Just that the new patched function looks confusing. That's why I was adding the
>> out-param initially to differentiate from different cases.
>>
>> The new vmx_get_passthrough_msr_slot() is just doing the trick by combining many
>> jobs together:
>>
>> 1. Get the possible passthrough msr slot index.
>>
>> 2. For x2APIC/PT/LBR msr, return -ENOENT.
>>
>> 3. For other msr, return the same -ENOENT, with a WARN.
>>
>> The semantics of the function look confusing.
>>
>> If the objective is to return passthrough msr slot, why return -ENOENT for
>> x2APIC/PT/LBR.
> 
> Because there is no "slot" for them in vmx_possible_passthrough_msrs, and the
> main purpose of the helpers is to get that slot in order to efficiently update
> the MSR bitmaps in response to userspace MSR filter changes.  The WARN is an extra
> sanity check to ensure that KVM doesn't start passing through an MSR without
> adding the MSR to vmx_possible_passthrough_msrs (or special casing it a la XAPIC,
> PT, and LBR MSRS).
> 
>> Why both x2APIC/PT/LBR and other MSRs return the same -ENOENT, while the other
>> MSRs may trigger WARN. (I know this is because the other MSRs do not belong to
>> any passthrough MSRs).
> 
> The x2APIC/PT/LBR MSRs are given special treatment: KVM may pass them through to
> the guest, but unlike the "regular" passthrough MSRs, userspace is NOT allowed to
> override that behavior via MSR filters.
> 
> And so as mentioned above, they don't have a slot in vmx_possible_passthrough_msrs.

Thank you very much for the explanation! This looks good to me.

Dongli Zhang

