Return-Path: <kvm+bounces-50691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47095AE856D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD511BC0A61
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5134D262FF6;
	Wed, 25 Jun 2025 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AN91ktkI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q2DsiNQr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41721547EE;
	Wed, 25 Jun 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860044; cv=fail; b=guYshloesQcQXdHm9vw35GR9hUj8LQDlvsSguZE/qneiCbXK2cwFfTOR+epfF/g4yt+idtAdcL0ZTw8IGMnkg8ff58mnB8l0j3Au3kCNXymVniO4SkrUQ/qRQAJrFxcWQa7d/wMC9+V9WMTiGZMIOBQT/ggX45oNAVb4GLMGmRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860044; c=relaxed/simple;
	bh=3Fo9D0FrUXK6Qu/vImYXBPb6La81OlDt900025y9edQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oGTR/bJPfW6SKBsnF5PWTvHvNGQa/QmHXVihyA6UHBhwYjbHbgDBHRjBG9c0OY8bQLG6ufMDTeKNe8oNZN4x3vs5VjgYMTS+sRr2+E9mnM4aKVnXuZuRD9Pw58rQgylMYFhzR30MMw5htc51LF6HcEKYYDpbzsSKvxHO9piTe3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AN91ktkI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q2DsiNQr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PAq4pC012440;
	Wed, 25 Jun 2025 14:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gRCq+D8yqM1zDr3Lecpvpy5ik4i12AK2l2LUKXr5xxk=; b=
	AN91ktkIafl3sYAon1oZVaav5XbN2+xU5wmyHObxQgfYQrSPIY5PDwu8OMCYvZFJ
	2gvPLy9Hi6F90WdK7c2d1W3vjuWT3p6B0Vz1cr/g4UrvRopZa6xHGvPi3eodj16Q
	ewj468YspUJlefR+0HMHlHuw/Ov/RaBGDlZlBAT2/CweYevMQthY3QiFulheQMII
	FpPdTf0qFNa4i3i7AQ0n+zioHAUP69I52lWLv4bgMEpQnvxuUj0gL00zdJfxmhSr
	V+4VvLjpLKnanu1YEeu1Y1pYr0dksjQ4Mh/R9CRfDncuz7R2nI3BKJE6yYNJ3lRL
	68RvkT++xSFsgQgldCddiQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7eegv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 14:00:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PCr4mQ037806;
	Wed, 25 Jun 2025 14:00:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq54m7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 14:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPMVHS5EXnOSINM0LfQxCx3QPIpz5mVsalZp8YfW+yll/uXvJGY0dnw0xP/+QvQcMJVoyUaC0ksd35+LqgfuH9GJKvGYH3XLvkk7cgFRhaAzq2vCQPrMKkEFc+ugE+1KG/1IJK33oP0Y3YWlkXJzn8pq8KuxM4G/FtPk4E14LfOClQc+gm5RsY5Ntr5O0r/IrovjEX+L+npcqkV8IeuOCKxOP/7eVsU7wNRHOuELdzn8J9P9jg8a3jnK3zQwuNt6VN8VHgiac4sUyN0+yaImP+ovpYhY6ufhfv5eqReCJHfRbd+q93Nk8QePEfP5v27UFFBWgU+hvy/dVQoBXbxt/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRCq+D8yqM1zDr3Lecpvpy5ik4i12AK2l2LUKXr5xxk=;
 b=m47EBmIHXpRuuJQo+RGqVPDCVeXcJmY40ht65TvV0i2pFLH6YRXm1v0bUQwan/8jM1rbwxYEKHYmLSoKJtl1VSuGcWyZNb1RqpQpt0maG+9wQvw/k/20LFMjQM4mQGDetrsyml74z0S6B8Vhd217RG0m3bGuXFK6tbt1ToS3yfqTwzSiLFrq1SLrJFUHTp9sRaS8l4zhROmAH2sFpHxlsddGUPxUgZW0nmBWsSToyH8h5V86iA/8XgirFxU5L28ULkZOz/YQ9e11sG1YMRam+UQeBHCD/x7AnUAoDR6hlPAs2Uj8iWPehcuBMvNccmqlnjwkzZQDOnc9nB19nTjArA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRCq+D8yqM1zDr3Lecpvpy5ik4i12AK2l2LUKXr5xxk=;
 b=q2DsiNQrJBdgTDXoZXBUc/Bg0iqfM41gUN+dy8/hLuL0T61G+8JO+j8rCOOIA72fsDDw2H0tDcOta0eu4Mynz+BBIq0Z/KQv4UJ1ccn28MmUDrlk/nFLGnKq4WFiwG62X4Z0mfvdl7kdB2VQWF8NSHGKlXQXIfv4SgmLi31QhPM=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SJ0PR10MB6301.namprd10.prod.outlook.com (2603:10b6:a03:44d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 25 Jun
 2025 14:00:33 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.8880.015; Wed, 25 Jun 2025
 14:00:33 +0000
Message-ID: <18e6c0d1-0ee5-40fb-b445-504751df10de@oracle.com>
Date: Wed, 25 Jun 2025 19:30:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] Documentation: KVM: fix reference for
 kvm_ppc_resize_hpt and various typos
To: Bagas Sanjaya <bagasdotme@gmail.com>, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
 <aFniQYHCyi4BKVcs@archie.me>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <aFniQYHCyi4BKVcs@archie.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::17) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SJ0PR10MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e1d5eb-e749-4f9a-ee9b-08ddb3f0a67f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVd3YUtWU3dKWGVhUnZiSm5vUExLVE1kcDBMKzh2a0c1NzhmU3Q4eTkyZFo0?=
 =?utf-8?B?SGxNWGtQeTdyaTdrRkxEQ2EyQUtPL3hlbDJlQ2ZoZnhDV293QjIyM2JwUGlP?=
 =?utf-8?B?Y085SjlsVU1DNk1Vbjhmck1LM1Q5d1FRMGFBZWNkVVJGR1JGVmhFQmtNQWhB?=
 =?utf-8?B?Y05HWmJjQkJnUExuNEU2Z0FZNFloOStuMDdjZHNnbmdCRXdBV1ZVV1dDc0dl?=
 =?utf-8?B?dDdJVGNBMFVqOUUzWVY5NWRiaTdZMDZIaWZWYnNPZlMyMUdJMEVsaTBBRnVR?=
 =?utf-8?B?SVFsRWl6Qmt1cm5LeGN6aWpJUll2S1ZBelNqdjl3NnBiaUhISGZtVmsrTisz?=
 =?utf-8?B?SUJZQ1VoWDJGVnpwNUk1blhrbkliNDR2dEtjS0hQdzh3L1JFZC8yNlQrcER0?=
 =?utf-8?B?VUEwbWFJUjU3dkFjdXF4ZVVOYzgwODZEbGJxeHMvSTduMEpwMGZNQno4aTB5?=
 =?utf-8?B?Nk9DOGhGL2xUanBMdkdRdlpnRXZKbTBBQjdoRXNUb3NWeFk0bVZaVlYyYitO?=
 =?utf-8?B?MFh5RlFMai9td0ZBRi9jVFB4NHdwckFycFpLRXlGY0JvMDNFSDlDN2IyVjg5?=
 =?utf-8?B?R3dLamsrN3hwR2hhOWJlMjJRRTdzR3hPb3MwY3dpOG5saTlLWElUUzg4V056?=
 =?utf-8?B?UmNodEFodEtjSmt1akFUV044MUo1WmFWejhjZzJ6ODJueEkvSStybE1sczhJ?=
 =?utf-8?B?MDBlNjZjZElzb2xVaFFKSUxhdUFydlJiNUFxaUQxSVVhTkVJQllCMWllUVFo?=
 =?utf-8?B?SGRZWkcxV0tpMit4QUZ2Znh4OFVBT0xScC96cnV0MnRxUW5UYkhQVW0zL05O?=
 =?utf-8?B?dFlIVWwrczZDY1A3N0VsOW1ubkVUcGJKQnpIRlNackRxWTliMWkvMmRGS0V2?=
 =?utf-8?B?RlFpaXRKYkZuQlAzcEZtV2NRekZ2QlhNNUlLbmRzRlAwd3QrMVgyUUZ5QkpT?=
 =?utf-8?B?V3Y1cVd0TGJUYWJyblh3UjhHQ3lYSzZZeEZ1VmthbEJTcWFLR0NJajNtNk95?=
 =?utf-8?B?RWtNY0JmWXpoaXZoSkFWemU0L21OQVJpSFlZOVhCYmc1WDRXL09UV09WR3cz?=
 =?utf-8?B?VXZyUWZQMmZQdzJ0US9hVFJPSVBJOC92MGNhT2ZtZ1FrQXRmQllab3ZKSDBp?=
 =?utf-8?B?N1IxTkEvdnJWVG1yZnhXY1lzdXRnYzdVVk5VSHFuczVxYzJsb0FTTUIxYXl3?=
 =?utf-8?B?dDVMUnZHRmdFazhNMmFETnRZMjYyMWhCWXFhRjVzbHJRcU5jdXlpb011bllB?=
 =?utf-8?B?N0htTll3bVVMUzNEVnlqK0Fmb25SdSt0QUJoeTRRejlLQlc4dVlobWphd25m?=
 =?utf-8?B?UVFCTnhpTG16NGk1Z2RoOEp2eUFoYWNsSHBVMVJnVG04NEo4N0gvQ2VMMzJD?=
 =?utf-8?B?TGNlOUthNDVKYTBGaWcrNnR6Y2MwQUJJZWdtWld1cVdRR0lUVmdEdUd4SjBP?=
 =?utf-8?B?ek1XblZMWTN0RTk3T2pkYjBQVXpnaVdNYk9rY0ttRG8zb2g0VDNRcUx5V0F4?=
 =?utf-8?B?QmVsVVBMWHFpUzhDYzRsZ3M0NUJBSERyenYwRkowSmRKRXRNTktsK1VMempa?=
 =?utf-8?B?TUZsRXYvRnV3aHFXdzJ0NG9LdDV0OUtMZGIzUUJpaWptdHhHNjdOeVA2ZXgr?=
 =?utf-8?B?bXh0TVRxZ0lXSSszdE93ZkJkNG1ybTJIRnd3VEs5NkRVK0k1UU4rczdHSnQ2?=
 =?utf-8?B?QTZ6VXpEYlhCU0Z2OWZwM1V3YnViRzlnZjVSVm9IZDluZm9IZHhpalZWaVl0?=
 =?utf-8?B?WU5Ua29vQXF6YnBSV0Vtb0dNU2YzcGkrWVozcVdtZ3cxbitjaUh6d01YRmZB?=
 =?utf-8?B?OVBFZGlVVkxOMWYxWXYvUFRJWi9LUExUTXhPTUZkUElSZUVpQ0VwODZCV09x?=
 =?utf-8?B?ZCt3RVUyRTRQQVlRK2hURmhKcFVlY0U4STQxMkc2T3J5YkJiazYrNzdFYW5i?=
 =?utf-8?Q?lw/7l4mmC50=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlZnMlFJbnNVSVFCV2ZuMjEwbDg3NkwzMEI1MHJtSUZuMlEvVytCMVE3YlE2?=
 =?utf-8?B?S0ROU2VzZDY2eFhYdjFOOXJuTEliSTBuUWdWZjY2OEJ1NmViV3QrN3JoeDEv?=
 =?utf-8?B?RERTVGxSSXJkZDNibHEzSEh5RUlncDdieWNYbTQwNE9ZWFZJVXpwVFF4MVZo?=
 =?utf-8?B?TVRqU0YzMkF3VmhWZktUZU5KSWdycEh0RlJYb2xmbWtkK3VpZnNSNEtTOUFm?=
 =?utf-8?B?TWMwNUlPNmJnRUtYSFJNOVFwdHFvUERGbkRlcm8wTWJXYzhEdWN3ejdSdFA4?=
 =?utf-8?B?SWN4eTM0YnBlRUg0VWtXY0pmb1ZvclhWc2tVeHFnb20rNUVaRUpPcklOTVFS?=
 =?utf-8?B?bFVEbklvRDBFR2tZWEZBaXIva0FSV2tRbnVhaUNadzhJSVBiMWJhMlhnNGYr?=
 =?utf-8?B?bEFDdEpWdjBxVGppaUpzUkJMcUhWTjBRdXRnR0YrVjVVOER6N1F4eGVKRW9D?=
 =?utf-8?B?NGRvMkFpOWVocHBFcDBvV1p1VG80ODFwcThhRzRJUFJabm8yM1MzWHE1UzhO?=
 =?utf-8?B?cEF6UEducWczWm5VZXN1MlhINmJGbm5TMzlRckNtTjVhUjBrOUtJYVBxNDFB?=
 =?utf-8?B?dkdnYXBsZmhqUk5sdTFGZlNhc1JVbzB6QzNFVEszTUVSOW91YTlGR0FvZ25s?=
 =?utf-8?B?SUgrTXRaVEx5Qm42L3RWOW5DR0llbXJ2NkxLQXFuZGlVNkF3WGNFOUNWYVNt?=
 =?utf-8?B?ZHFEdE9veE9BdEJoVDBWYTdiY25FL0h6ZlZVb1F5bXpIeDNXdU9WeXBXQUJj?=
 =?utf-8?B?TUJ6RDJxZUJ6a0xxakt3alJVcEc1a21HQ3pES2cwbmNNTElxTjJIV0k0ZmFT?=
 =?utf-8?B?Nk4rdm1OK05rVFZ1S1JQRU5taTdJeWZzSllrUEhDL2pYLzY1bERYek9aUUZx?=
 =?utf-8?B?TVRidWtqbVQ1NEErcUJyY09VeEo0WUJ6Yldrd3AyMlp2MUJndGlteFAwZzhV?=
 =?utf-8?B?M01ubms3RkdyZUhxMHBhMDZZako0UVZnczZYVE1md25IWk1sb1h3VnYvaXZ5?=
 =?utf-8?B?WDh4WUcxS1FZcFpwZjl1RzVubCtLUi9CMk1GTFhpY2cxQkp5ZkFHK1NGL3Fl?=
 =?utf-8?B?Smw5U3BEL1g0VVNoZXNLY0I2UXFkRnRhaENQSzVBSUtnQjA3OC94RlNvU1lU?=
 =?utf-8?B?ZkVaTU1BZUhKUjVXK3Q3KzZCcEZydnBHcmdaeUNNMnBzcTdNcDJtakdGUFVN?=
 =?utf-8?B?RWh3aDI3am8vV2JLQlJqQWs3L2Y1NE9sbzFLdndZam5XWFM1R01RenlMK2lK?=
 =?utf-8?B?VmdpM1h1a2RrT0dORFJXbFNqQUZmVXBCdFRWQk5HY0hVS0ZFamdYMDVZbzIx?=
 =?utf-8?B?MHBUaW9Cb3dFd3BvYUJ1MEI1MFAwVXBSMEJmVldJNUhDeENRZ1RwaExJbHNq?=
 =?utf-8?B?S1ZqNzV1NWd4UDc4a0VLK3M4Ky9HaTZScm9XVWxXOUIyWkh0TnZxcDZnSElx?=
 =?utf-8?B?dFpkTysyLzRybFBLYmdKU1RiWDEyajB2UmN0UXJMdUxRMkFsNkJJOTlhQmZp?=
 =?utf-8?B?eDZyK1cybjdJR093VzArN096UGVWRU40QjFQc0lzYVRqL1VScmxaTXJXKzJK?=
 =?utf-8?B?cTBrY3VSVWhHdnFRa0xKcFpDTWkvbjVLei9pU1dhQzlROXFJTnFPNmJPaDRV?=
 =?utf-8?B?bHk4M3FYR2RITHp2WlIrS3djNnRPYnhNV09za2s1QSszZGczNVltOHhYU296?=
 =?utf-8?B?Z0pTaFR3b09YQ2RDSEdEUVFSSzVOd1FGNVRpVDJtRUh6U29aMXZ3cFR4U0hI?=
 =?utf-8?B?bU5yYm9YNmdJRjFwYkdpMjVZSHJHZ2U0QUNTVGh0NXpMRTRRNSs4S0ljdWtW?=
 =?utf-8?B?V1NzT3VaSlZFNE4rMUloNWVIbHdMd2JCUmVWMklqZWVVSDhhd1d3MGp2ZnAx?=
 =?utf-8?B?L2RjSjhtamZQMGprTW80TGxZT0ZRdzdFZk82aWc4RER4cUlyMmFMSWhHaWtn?=
 =?utf-8?B?eWs1Y0lJYnB0UGhRVDdRV2NOWW9EbEJYSHF0RlJkU01Ea3V0d1lBVjNyd1dR?=
 =?utf-8?B?eVNzNWxyVUNxVzBmLzBIOU9hdWJUSWpyYnB5M0tXVXliRW1DY2R1MnN6VjB5?=
 =?utf-8?B?VUpYbU43TzFnK3VCNVlaUGxGYzNiZjVnWUNuOG5URmJHcVVKM3B6QVBlRUpm?=
 =?utf-8?B?eUM0M2o3TXFaN2pGNnZhS1ViOXRsZDAwb1phQ2dJVUg0RGl3Z29xVlNnWWN6?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cN3gAFvfVnfKlhJdvQyiRsREAPSWQp2esPVhJ02iHMnbSl3MQjSb5+mBTp2woyC/NFYnYSlM+k+1f/tLpIQiEhhQCD5Tle4pE39apz/0rfpYbfKt2Iu01BIIXJYW4KAEN7HhNidM3u3CyDwtBG1JrG8r8KB14vV/JerhBDKXbjR7IvUmTPeAnGvjycLmvsHY/k3SwY8PqgnWlef9gR6iar3jMv+rl2WOdVEqn1cQGsEsUMfA9ZRDSYJVl2OdUD7QcW2Bl7HPrO8GIxAjuNQk5nYTZfpfqWYUnD6rGxHAy+0lOuchPcIa4+uIdoiZciuyqTk+Q7PIsNuvuhzl1ECZJ38LmqVTuQvFyFwGkuACJrD19/LwP9/BILUiN3M0oHJ2+SrFug1pOAe/2Cj1QRMimDay0jZ1mUfhG0j3hQ1SfukwB76qznSsvuGHk9HweRZZRlyRaUQr2jS5BHtsdDbjNx+Q4oNiaO7kGPnADEO/EFwproUpQSEqtiR/QacThH8zdz8HF2gCD4CuCEJjJdrKxp4sEWoOhqJEfpkVKJTwyf4lIaDR99ynFbyP3NXgDlcH5hf1vuQhq3S4icOsvACrhueKvz5T5ex9Y6lCgiT+TKE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e1d5eb-e749-4f9a-ee9b-08ddb3f0a67f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 14:00:32.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnWHqQQln7s69VPjcupMLxoNxz1oO+Hs6SRYagggITdjb2xtV/kkRHFdJyQHYT5+GrrAidnz6NseEGZ3rwZ84JbfZoQ8uB61buKMQK5UaQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_03,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=685
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDEwMSBTYWx0ZWRfX56Ceosm05c1L jlgcElbHOh9nwNg8AmAiNq/ZlWhVdxcCfIvd7OT+Rbf0TgzwuvatQwqb7l89VWpFeu9hq17ms0K x0p2106FoytHovdm6BhYKJ3Y9ZqSFiSwhNnw+r/yV+N9j4nQlZMn2mS16OSfhgz9rYDY27nXbr/
 agUB5NOzKuGPaSgdQ3fcno81gpaJfFRmYCJlEw/oy0gv7wEvH+/6wnm8t+r3fQs29ZdLNa6Ij4G 4j4SjKc6rwob/9ci+DjnEerK1KmGVCeJBx/1RufI2NlHbN0O0iEMG3k2ZGgebe3Kdzt+6adAmA9 yMCn11kNk3qPi7lxG7Rki0NmIXeaxLpYafLogHxipe4JGP94tAo+r8GYVrDbeFMLwkd2PkIXKXz
 z+5b/G2KjI8zBl0rXVGzsLtimjoZp1sWwvR+dNCSov4xgqReYWwfy8nzzbOQ7tTYHVfxQ2TR
X-Proofpoint-GUID: sB-RbtWOEdV95LSY48Q2osTUXFnUyPT-
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685c0106 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=ID4705AuGncHtKYxaWMA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: sB-RbtWOEdV95LSY48Q2osTUXFnUyPT-



On 6/24/2025 4:54 AM, Bagas Sanjaya wrote:
>> -This capability indicates that KVM supports that accesses to user defined MSRs
>> +This capability indicates that KVM supports accesses to user defined MSRs
>>   may be rejected. With this capability exposed, KVM exports new VM ioctl
>>   KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps of MSR
>>   ranges that KVM should deny access to.
> Do you mean accesses to user defined MSRs*that* may be rejected?

Do you want me to undo this change and go back to the earlier one?

> 
> Thanks.

Do I need to send a new patch?

Thanks,
Alok

