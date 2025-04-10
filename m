Return-Path: <kvm+bounces-43113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CDDA84FA2
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D637A9A2AD9
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E605E20E319;
	Thu, 10 Apr 2025 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bu4/zwla";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LujhilOL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F067AD5E
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 22:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744323986; cv=fail; b=FqhUVPSvEL2JEwzc7jB5K5K/pEPhfkIB8MVn85yMnm+bHY2jmJgwaxexdUlewA3IA23s2iuboVZ80EdYEYvHskhlrK7tkTmsiOxUVcV4cn7mz3Ff8dE0gsHaybRGAz/RJZV6lSB5dpal0O1Crh6NkEb8yI6ijZUy2Lb65yUDpig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744323986; c=relaxed/simple;
	bh=AdBk/BEC98LIoU2bYBiXKUTxHZABg5kZ2tZZBTnlceA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rsHTTNgkJM6oJ7yYyxdmsTcJyYKwiOZSSw8El7VXLdFKVWWaV96kO0t5aYqgKj7b5++5BUUqC/CYWdJGPCsQxWbV23RymHzGiz1UrMOeK5w4k7YTow0wQhpU8yMkAMnIGUz6iOYEEgWFkKDvHe+EpH2sFxdmhPVEhn85+46agzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bu4/zwla; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LujhilOL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AM8s6Z010493;
	Thu, 10 Apr 2025 22:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lQ+Q+pDEkNoegjMO1Bq8j3OzlqDzH2MiWZyJKDHyVnw=; b=
	Bu4/zwlacrijE0YOX2Oxe+2uXLMtqAULAbS2IEtm9meRXlF4N7O7UkULetoicQ60
	7363WD4jQE40AIkOZy/jUfBGvn1DF08MaWumDEfgdaJpqpk1ZdiO2L9ID2y5OGAn
	s+6DQGz4pOprPb7Buov4OrLD8EUFt4ea6tdjUTzL7qhbXP8DU0S8r+ag+r55zcsI
	0QmwEbMNdV7aGUwxfzsdAHgdvlToilxNrXIUSLEQSAZwvoAX3yD+KwMWJuSpxY64
	TgALzJLsd8sENT3LNqI4FI9CLd/WrguAH1bSWpPGwLjmyRa/+6r3i3gZnGPGh/B/
	0gE1A6SowPqS2BOjcNR5Eg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xpgsg0jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 22:25:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53ALMv1E001727;
	Thu, 10 Apr 2025 22:25:28 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010007.outbound.protection.outlook.com [40.93.13.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttycv819-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 22:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lh3jyIxHNx5pESFLY75mIfOg5K0TyN69EfhA4YYlr0yj49f8Z0BtTog+o3x7j8dYrx42e57UwJvbFQsFVRVnhMsFGPrFQrXW8yDUIs2jSCLlQdisJVDhLzovpcY/SgZF4JjD1A9EbyImlNkOcGGczxw9jtmzIUEd6TYJj2Jw+DkkThG3pqtXu/a8beqJg/lJHAmrtfHwh0sdAKNMf+5WAPXDT7FsxH9X0eKZ+lsC8kOd4kcAmnOyFz9Bu6kpOnibq6KeMJgg3PZ0hVh8dPqQksGBZMY+PGW8wq9Hu8PJUAIKfs30dC/NXN3Waw9FJGLLRk3R9KpH/CmdDzVE9n/TsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQ+Q+pDEkNoegjMO1Bq8j3OzlqDzH2MiWZyJKDHyVnw=;
 b=ux8/Y1eALmEoIy6QdkeXyHkUhMWLuWQc/GettxT6OdDkdn3yHTlLtzQqL8VI+EqsikPDBn21NEm7Iza6RioFhzrhIczYJ/DOaTuCoKqjfmOUM78Vf1aKJlRwDXudVPZNdqAMztqeMlqNdNvNGvIg+OVYd2EsXLEOuNUtppAoXrNUucd3Udu3d1dCQUiL1HDNuPepL2V8sH1wD/yEWcLHQOQWZ6yYYTw8BVsEGNDyjbIbv3o+7OqBLt2eSxwojEPU0VYVTiTgMDdw4cYXklryy86thS2z80r8aKGc+e68IW/GFEFYBx5R99b6BGGjBsSAv13J/KvvINDHTxNfuCeP8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ+Q+pDEkNoegjMO1Bq8j3OzlqDzH2MiWZyJKDHyVnw=;
 b=LujhilOLDsRtXl7T6RB1pTVMr4rMLX572Are0CV166A3rn5m43EVM4spaC59mVwKSD0jyiEn5Gvox2lYGqfuDFSPS+tuS5h1AD8ZHfeZDCGwdDEdnYCoNPZFmK4k24T23qtZ1uLOpJB0WFrbWCmuR1lklW3U7ctuXBdVMNrl7mY=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CH3PR10MB7234.namprd10.prod.outlook.com (2603:10b6:610:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 22:25:24 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 22:25:24 +0000
Message-ID: <9f128df9-a670-4314-8d44-427b3fcc1f92@oracle.com>
Date: Thu, 10 Apr 2025 15:25:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] target/i386/kvm: don't stop Intel PMU counters
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-11-dongli.zhang@oracle.com>
 <Z/eTRVSveNMwZBaa@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z/eTRVSveNMwZBaa@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0149.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::13) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CH3PR10MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: ef24a141-9336-4598-d6fb-08dd787e9627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bi9wRmFpUmhqWnozQ0ZxcloxTExIMmNFOUxKRmxOSmJsNGZRREpoN2hXTTAz?=
 =?utf-8?B?Ui9OOGNrL1ZSbDY1cmJjRWMxTVRydXAyS3pNWHltTk1CT0VwSUpBYkY2Slgv?=
 =?utf-8?B?WFdhQ1g5WnVnc3BweTE0enY5eUtTbUpTUFUxaktOLzFLM1JibnFzemYyajdw?=
 =?utf-8?B?aFBxb1h6U1JSdVRLeWt2VXg1VmYrRW5TZlhkbi9vYm1mL2d4dkZoeXVPa0N2?=
 =?utf-8?B?UVJaQjRwYXJuU3lHTXZkV204bDNmb0UzdnB0VjNvODBjbHhuUnNkZ1lwMndJ?=
 =?utf-8?B?dG9vWE1uY3B0R0pqTTQrQmxLTEdDWU5qTHIrQTVvaWVDaEw1eDBYOE9TTUZV?=
 =?utf-8?B?R3hsNlV0TE82VFRkQ3Y1bjBuUzcxZm9saStvQmN6SmRyOHI5Z0RzQmt4RU1l?=
 =?utf-8?B?cVdEYm9nMG5EZ3JvU2xzd3ArOWVVL0swaEZTT2ZTeERDYTQ3aklRS2pvOXFR?=
 =?utf-8?B?ZnIwajFaT0c5NlMwRWZtd2Vqbmp5VEtMQ0JqenlGSUNjanhnT0tDNG50eXN2?=
 =?utf-8?B?TE8yV1VaRVdiNDNNdnM5SDNwNVlCdkVEdDhPWjVtSk1YbFVCOFhIQlRPbWZP?=
 =?utf-8?B?ZXRoa01zRTRmajl5WEZkNERabURaTlhQazJKVnJ2MzE4WnM1N1lPU0tXdzRG?=
 =?utf-8?B?WnF1SGx4ak5uMTZ5VWdRdTJDSEJzdGh5aGUxek50ajBZQm9sK2ZPQ01ubldo?=
 =?utf-8?B?RVpsVWlVblN3RDdqSFFJM242TUNpVDdFVUZhTnE1ZEc3UjJ3d1NLWEh1aTdB?=
 =?utf-8?B?UzdJS1lxWHBaRnVVTEh2d3NkaVljL2crb0V1QzkvU1RPNzg1US9CYTZwSjQr?=
 =?utf-8?B?QTRCOVlXZ1YvYTJ2Z05TY2xtV0dBdmhGaXNUMUJlMGdQVy83UUUveGhVSkNE?=
 =?utf-8?B?TWgvcFcrajFCMENJV0xkNUJENys2YjRTWHhJeWNEa0laMTVTMFZqV0dpb0JJ?=
 =?utf-8?B?YnA0TUp1Q3N4bHNlRkZNRm5PQml5L2xWYW5sN1RwclBBaWZXOFpwWGU5ano1?=
 =?utf-8?B?RHVPK3JFVXliSVhFZGdvQWpOUzhkVE1wZGlQbDVnTENDYSs1T3FXMFRUcUow?=
 =?utf-8?B?Y0FiUUwxRmkwR3Z4L2gybkw3b0RvdzRsd1hKeStjNDY2dndTSDFWd3E2eFpI?=
 =?utf-8?B?WlMrQUY5RTZPMnF2Z1FkRTV2RCt2S21IMCttSVhRVjJka0cyQjNVM1o5UUdy?=
 =?utf-8?B?eVY4Y3JSdFdwMXpCOXkrOHBuMnhGM041QXBiYU5tdHc3U0dYZ3hjbzVhMFQr?=
 =?utf-8?B?cERLWDFMWWV5VTZMOUMzRFp1dEZ6VGlDTnU1amR5cFlabTE0NXZvZjJ2NHk3?=
 =?utf-8?B?dVQxbHo2MGZBdDd4RXp4RUMweDIrR0JvN1VjRGxVcFFnWE1CSCtPT3RBUjh2?=
 =?utf-8?B?T2k5NVU4cjYzRHdta1hPWHkwbFJKRnV3ZDNsNjVTQmF6VFdMQTlOTHkrSHJE?=
 =?utf-8?B?cm5TN1BNN3pwbTBUQUgvUzVmbDlwVmEwS2sxei92NEp5T0grN0tCR2xESUJ2?=
 =?utf-8?B?ZDJlbHRDSUxtLzhKeUxpdFdDWmc1c2s4WTNqN0x4eURVQ3lWQ1R3cGRmNzhQ?=
 =?utf-8?B?MmNrMys3WmJlbmJWTmhPU200VzBMa0pNWjJ2NjhqMG11VjNEZlB6VTllNTl0?=
 =?utf-8?B?ZTRUSHZYL3MxSWpHcWkwQVIvWGRPUFprZEVvZWo1SzBxK3lWNVNhMUt3b0hw?=
 =?utf-8?B?UDI5Sk1FOTlSeW16ZSt2a0JSZGFYZUZ5aU96SGxyeDNOSmd0MDdOOHdIM0E5?=
 =?utf-8?B?SDVLMUp1RHAxeXNlRmVReXZTKzVreGJOREt0c1BVV25SOFVwbFkrNU9jUzI0?=
 =?utf-8?B?Y0RVWllhbHNMQTlPSU1MTTNVL0JvcjBlSHZ5cDhYczh6dVd1WW1BNThLR0hu?=
 =?utf-8?Q?2W1xMK36Oldt1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGpkRG1TbjBWSG1LNjFqWURiSXQwY0lqdkZKSE5BMDhGOHFYclFaZUM0M2ZV?=
 =?utf-8?B?ZXNuOHRhWmVSa0RxTnphUjh6akhUcEdsK2dpUytGbUlPaXZRL1JsWW5YaTVF?=
 =?utf-8?B?cWU5cW0zZGJMNHFIbGlHazdNeGZ4OWZnNTFpbk94SUhNQXV1Nnp3TTg5M2FE?=
 =?utf-8?B?aHRoaW5JVDdKZTFtUW1mMDRzUDdycllsSmxJazVsNzZGTWlrZXRib09IRkkr?=
 =?utf-8?B?a3VMN1NlQjh0SnIxNE9hdXVJRExaYWw3NURjOCs4aHB4MEJRcTA3eXIyazFi?=
 =?utf-8?B?TThVSVZsT0YvSEtHdkRxN1ZIK3RSMFE2aEMvc0hxSi8vTHY2aDFXTUdNNGxW?=
 =?utf-8?B?TWVoK0VWZllaRlRINkN4bDFwSXlyWW5LRkVIdldEZ0dCNFFQWG9xZHVJTzVE?=
 =?utf-8?B?K0FIUWJVN1V3NDJEMmh0KzhJUjBUY0pkQUtwZWRZYkE1R0ZTdzFydkNZY2tj?=
 =?utf-8?B?NWxhWWl6OFhtQkZkTjVENFVTM0JuVFh5UEdZbmRBa3RNN1RTT0VFL2c5bEhP?=
 =?utf-8?B?T0lyTWM5VnFnN2luZWE4ZEtTeE02Y3lIekZoQnhZd0U5UnhqZmVDZElWWGRk?=
 =?utf-8?B?T0VJam1pblJqY0duS1E5K1lsd3lVdFNSd1ErMndDVlB2VlFNWm9tb2dJMUJi?=
 =?utf-8?B?cjhoT3hOY3FvdUh6YzFMYUd1ck9WOE80TVJQcS9JZTl1TVczOXlDaEJHYU5t?=
 =?utf-8?B?MS9CNFlFeWhRNThwcWl2U0x4cWlpdUpIS3FKdEt6NzJ4NGpVOSsyYm0wcTg2?=
 =?utf-8?B?TTJoU2RNczNkOFN5dXRmR1VZUEwxWHNjOHU0dDcwS01NYXBGakRsdStTNDJp?=
 =?utf-8?B?UW1aN3dJTEhEZXRVUXpxdGVkVk5MQ0l5QU12dEY4ZFl5b3hRNFNtc2twTlNy?=
 =?utf-8?B?SVY1cTk5dlZnOXVnYkdGNE1MVVBTSTBlMXdUUjA1aTVCYk5tOS84a2QyRnNU?=
 =?utf-8?B?RUlxZUx5WER6NmRwMjlYNXlkZ0c1NCtXaHphVHNJSTJBNXgyRjV2SzNydmow?=
 =?utf-8?B?QWhJM3hSQ3Z4YUt1a0t5NDFaMHVVblVZWFpHMWxRQjhnZmNqTEdndDlTayt2?=
 =?utf-8?B?VVhYRzRzTExLUGFYNU9qY2pmRjhJWDlodjNDYjM1cUxtb3Erd29rVC9pbTdu?=
 =?utf-8?B?cGlGU0k4QlVQQzhrWmVWbk5WaFNyUXdHOGxMaTFVTFR2Z0xSNXdTSWk2ZWs3?=
 =?utf-8?B?alFuNVhkOVVMeVpocDRPN0JSak9OWldObTJhOFhLbDRVcERHVEVGY29WeUlQ?=
 =?utf-8?B?NitEZnB4M3lROG5wYkFxbUZ0S25WZW92QTJ5TEs2OEI5Nkx5cjhrR3ptSGdv?=
 =?utf-8?B?b3QxYno4bExycTNLcmpLU1QrUjIyL2FEdEZZSFdrTWxvbG9PcHE3MTNrQ3pR?=
 =?utf-8?B?ZzBDWE5SWkNCK3ZpWklBMlVPdVRENHNKN01VeVVYejZzbEVkYUx5TUR3ZHVo?=
 =?utf-8?B?bnNsNWdOUkx5YUxqWUpHNjNQVE9YcVZTbmY5Rk1ScERmV2k5VEhmQUVUVm91?=
 =?utf-8?B?MjQ3SnVMRzI3ZnJTLzRSVmxlenBVTWpPN3ZUSXpzQlRlU3hXNC9tMUw2SWVt?=
 =?utf-8?B?SWVwTXBhRzNZSDZwTTdSamowYk12WGdQWjJsOUk3UnpaNEhDb3hrYThuU3pP?=
 =?utf-8?B?dzVCNG1UYkdySmJSaU0rWGhNY1lYVmRtRGNSWGVDZCsvVnhlS00wd3Q2QUJS?=
 =?utf-8?B?RTIrNVJ5ZnppTURkVGJaVHpvVy9LZTBDNnNLQTlPL3ZTOSs0SjNxWTJPa3Ur?=
 =?utf-8?B?Mm1ySmFHOUZyT2w1Q0YrMkNDMFord240emxHSDR5ZzFKaStFUm0zL1daT1JE?=
 =?utf-8?B?UnpZWnFTTThUZnJkU0lERGlqand6WnY4NU9KMGRJcml6YnZjWWkvOUJ6MEsr?=
 =?utf-8?B?eFUxOVhuTk04Vm15VG1nNXNSazJNU1hYRmpIK01SbGpCSlNKM01MUEhoTkth?=
 =?utf-8?B?d2oxNFBwQzEyUHl0aE01MzErZGNMc2FyNUxlK3REWjRNMDJvci9DdEMzQk00?=
 =?utf-8?B?Y2MwWng4Y3RrYnlFUnpVYnF5V2JQVUlsdHFjY0lpTG9YbWswWnk0TzMvZUlz?=
 =?utf-8?B?RTZrY21lS3kwYlcyRFAwNitpOTFyaGlDWDVacklXaUwzd0xDaU01eXkyMVIx?=
 =?utf-8?Q?KaUWK7q3faCtwaBI2Yf92AyfR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rwGCvCSPoZNgte6C1t47D4v1/2++/jQPOSIzZra7af7zX6aMoZqgKqMWFCuJVipP2drCQJOVKSUlGXSOZT3H6Hbf+KbGj2+OkNCb/AmbBCAQIa8paE2OlL2m/rXkBy2cKEZNFFHcIZ66JBoyEdhhSl0VyURDAzgtxopHazP/nx/o2X+bGtN71bLwzTIlTrzOv8JesFd+zLDPoys8ebtiIY8Lhf0uFNF9Vy6MHwETCNdNqPp23diIGMPz7KbY4/iOewPg2Yv9qDPpvUF5oGheSEk+aou/s+Qj8XTXnt2BCF+8Xdyc0D/gVV1Vka3cuvzD5q4fbJ5AhsyaOAGJLkgQVupI7Z2I0yzSE5UxoQXWrtlJRvuRCGjE5Dk6QWAf2AWMAj/UKB2T4xmBaPg2hJHU3gz1EWk1ure8HOvaPbJcPKAxmG7PpY+UerdZRJVcWf7/tns9xrK9h3b/zJgXS6hzLmXVWOIE/tpugOlQ9cWZy+TKXQqyHu+KGMYqjJ9OOKlJVKLECGnAmV/NS3zxwUy4/uwRmh9H50/+UszvAJMid+NY3htRm3W/GZg5pAyCdBW3HaLVBXUdSC4K7CyB0IV2o9AuOZOqqI+t3aeS7cPQsBw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef24a141-9336-4598-d6fb-08dd787e9627
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 22:25:23.9656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UmBzICEmyYBJ8FwqFUe8QKZPxIZGJfhfZp8j1J3fhSOG7IJ9Vg5UblNrmwhb004se7YhahwrkoNim2J1qUovpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7234
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_07,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100163
X-Proofpoint-ORIG-GUID: JAbyIM_RQBRrspP4NaB_EDq9wazvBkuT
X-Proofpoint-GUID: JAbyIM_RQBRrspP4NaB_EDq9wazvBkuT

Hi Zhao,

On 4/10/25 2:45 AM, Zhao Liu wrote:
> On Sun, Mar 30, 2025 at 06:32:29PM -0700, Dongli Zhang wrote:
>> Date: Sun, 30 Mar 2025 18:32:29 -0700
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v3 10/10] target/i386/kvm: don't stop Intel PMU counters
>> X-Mailer: git-send-email 2.43.5
>>
>> The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
>> these MSRs one by one in a loop, only saving the config and triggering the
>> KVM_REQ_PMU request. This approach does not immediately stop the event
>> before updating PMC.
> 
> This is ture after KVM's 68fb4757e867 (v6.2). QEMU even supports v4.5
> (docs/system/target-i386.rst)... I'm not sure whether it is outdated,
> but it's better to mention the Linux version.


Thank you very much for the reminder.

I will:

1. Reorder the reasons and put the above at the end, because now "levels >=
KVM_PUT_RESET_STATE" and "exclude_host = 1" (Intel uses atomic MSR autoload
while looks AMD supports a special guest mode) are more convincing.

2. Add the commit id that you suggest to the last reason.

3. Add your Reviewed-by. Thank you very much!

Dongli Zhang

> 
>> In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
>> excluding runtime. Therefore, updating these MSRs without stopping events
>> should be acceptable.
> 
> I agree.
> 
>> Finally, KVM creates kernel perf events with host mode excluded
>> (exclude_host = 1). While the events remain active, they don't increment
>> the counter during QEMU vCPU userspace mode.
>>
>> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
>> migrate vPMU state"), because this isn't a bugfix.
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  target/i386/kvm/kvm.c | 9 ---------
>>  1 file changed, 9 deletions(-)
> 
> Fine for me,
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 


