Return-Path: <kvm+bounces-3935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B0A80AAC8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2BF3B20B7E
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80A53A264;
	Fri,  8 Dec 2023 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFAxL39b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FCsZ5yXf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D747710DA;
	Fri,  8 Dec 2023 09:29:57 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GfHN3009524;
	Fri, 8 Dec 2023 17:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=rGGpksg/FI6qUmreqOd7EEQDs8dOCgilXeog7C4dM1k=;
 b=bFAxL39bRb77zroCectRqaObo3NVbO58RnAIzosxsee/9msBSmBjoZSIy0ShDmWS8j3Y
 ZKqCAir8F1qrUKJ13MTb/tbyEORno09U8jmSOrFQtjF6QU+gxhlH0dkQymjxWBK/lT5P
 LuaS7rg5k+kn4rwjERj7ArYgScsPiKK2Tv2NAeE3UqwTUEo24i7Iei9fBmnGPwx81aOm
 F0mLmUPJUKjnTxRuygMNAEGb+1YVG2nQbireLg1HvU/PG1coCSawdt6RORDgZj+n/HcM
 yKSRVRy8ltWzmljN9KKDiDq7k4VfLblbeXqkjY5oxLP4u44vXfhYkk0wuf/a+WwZQZJu 6Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utd0hpcn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Dec 2023 17:29:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8HKMhp012704;
	Fri, 8 Dec 2023 17:29:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utancew50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Dec 2023 17:29:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYfMjB14jf3ewCF91+td92Nbzul3mo5ZxQKABRFppPHkbW8XHMKs0DmoGkEJzHTTiIkSABbobyB7dBUySJFdQXIchXLZx1/0gW1js2e852nJxpH9VT8OaXW0Lqb7Fk05BbbPJ1CIozS99ZLPBfTwrrermNvGPV7vb9wmFkqRQ0PPGvXffFtJLec+ZPrVVJ+LkoMILUiDemx6JwjgPgnmGwRfXorVENbU349Te8kDBR9+YLlP+qd2nZ4hCuCVdod/EUgxXarNWvtc1z9sbv+aS7WWx35y5o9r/wKf6LHurnKB93WPf2fGGHucrGIqvZMPnZ6HtvHFRLj3GFGEPX0ZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGGpksg/FI6qUmreqOd7EEQDs8dOCgilXeog7C4dM1k=;
 b=T4jR5OUTWAtvIF1Y+YXHb9Ceq3ZrGHQC022eVCbQNTK3q9bFp8i/01vG4/ObJcXxXg1xg+FsUx7cbvxSFHLMS/muGuZlnffR8DQC1C5QBp86xKd1nsi5esnqnE66QD5RnE8+1JOeMeOwoT69ggy9HMows5Gjk4eePASjAm+ruUmL87z+0+EfLPzXoaWbznOBybJmem00CCsocpJsy4nVJcHegIblQoEXIu8Ieya0LxqFia44ty6C5Lpohp5/aRoR1h7LrMWtfZdwO5+bGyI9UpXgRpFGmXhbMLp4K42bIvwJHT1GGq8VgMHZEXFX3UM24NlEEubWosbjTepP7QQHJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGGpksg/FI6qUmreqOd7EEQDs8dOCgilXeog7C4dM1k=;
 b=FCsZ5yXfvPVIW3a29DCmlxXSYK1/Arl7xkqxXxi9yav2kefchXHSKKKt6Bfg1GLSY1T7nQMyGMaMbyB3LOSFBkl8o72ek/+mXJ8cp58T4XuNnw3XXFyyU3AkdkfFZZWdmw4I34xGHZb/hVgJPxDfQfgh4+ZjJow46w6YpU2afvw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4642.namprd10.prod.outlook.com (2603:10b6:303:6f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 17:28:59 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 17:28:59 +0000
Message-ID: <9b69e534-73a6-4ac7-af92-808c985f82a1@oracle.com>
Date: Fri, 8 Dec 2023 11:28:57 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
To: Tobias Huschle <huschle@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>, Peter Zijlstra
 <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        jasowang@redhat.com
References: <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
 <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
 <ZXLgwLehNbaHy3yb@DESKTOP-2CCOB1S.>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ZXLgwLehNbaHy3yb@DESKTOP-2CCOB1S.>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0043.namprd06.prod.outlook.com
 (2603:10b6:8:54::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: f4d8e547-0d61-4020-75cb-08dbf81329f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pvSO8HQ6GM0zmiVKWozVtgpQUMlvVgAzw8HLM+KPYeL3N+rzhdv7bzzIkOrBnQ0znROd2xLLDvgjRBvr/Gn8HI7pYkT4X2zylb8JPxIYFr9GBm3N8yju39cab4ZHX26pTvWLp3Z3Z2BRZJucg6OHWY9HMXQibokTTkIQFDePNyKXJOXpwD6rsWSrPvXTuIRLlwcLaaGfz1BE7FSjXzmgEGlApBiiBmZfGUMEs2STCsbSgz+ZUB3W9RCDLRMcmuI7znzEJsUVuKZg6QTyW2I/hDXW+g+NOCMaw2MZL563SRcv9fvlRi7W5c53vuUErdfg+hdqrTNQ25tP4oDq2W/3pBogPU7XHDvpWkek1s/LFDifJfGcC+D/gdIM7saV3Cpj1qbLVxLd4K24F/D/L5DjJlZFuKWm/RRAToYvBwxp3ICCooGs3qmcyRvBAKe2xVjzthU0MgQPMwcdpR9x1CMaVbHxfgky/eFEMO34v32XSSbgidYsojov7GBPlAxHS+33VTofCAtrFIdDZ716WTAx/GpGIxj7AhiiMFIRg1YFBmo1Tv3ZUNyGmP1tdQRy9zYR8icx3QJ2QykSnoUaguHxWrRgxGbuU6boP3ZTJmw0X8VNiS14EUkhD+zDr9WDyPTCHwK53iYXtWBkxc65pHAX4A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(366004)(396003)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(6506007)(6512007)(53546011)(6486002)(478600001)(83380400001)(26005)(2616005)(2906002)(5660300002)(41300700001)(316002)(54906003)(66476007)(66556008)(66946007)(110136005)(4326008)(8676002)(8936002)(31696002)(86362001)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bVJkZG4xZ0VNdzlOMi90ZmR1UVZ1WFArS0tUd0R0L2NpdkpsUXRla0dQZU4y?=
 =?utf-8?B?OVpyL1ZyWFdPeElGVVl0dTNhblZJTEloZ2JadWlHTkFYQUpianE2b2ZTWVdG?=
 =?utf-8?B?SHd4RnpMZTdsaFlZZjlJN0RXaTBHU3FkMlNFdmw2VnpWL3ZkU1d4bGhxc2Zs?=
 =?utf-8?B?Ty94UFZ3emdrV25MUytmRjFyUlptL3lGYWZMcGZkb0hiZGoyenNuM21RYzhD?=
 =?utf-8?B?bWhMbk91MmdBK2dPckpZY0ZmS08xa3p3YytDeEJwOHhQM2pUOEZwTDBtQUdv?=
 =?utf-8?B?SU9YUy9ETzN2SnlOU213QUQrTWdQakFINXUyRi81U2dJclQ4Vytjd2dHZ2Z4?=
 =?utf-8?B?eVNuZkpCYzAveXBZL3NCMUc4VFdBZ2M4R1U3c0V3cmlUVU1HYkc3K2xXTDJ1?=
 =?utf-8?B?M3NOeERzcGNDeDI1emdNRFhuNzRNK3gzdlZHUHdKQy81VHE5OTBOU0ZobzR1?=
 =?utf-8?B?MXpUY0pyemE0MytHK3ArYXVRQnl6L2grS3gwbGxCNHZJV1dlRFg1K1dic2gy?=
 =?utf-8?B?Y284NHViYU1CNVBwRU1rZ1J5Zmd0V29aRC9SU09ld2hLNG4zTVNrZzQ3RkRP?=
 =?utf-8?B?dmkzbWZ4dHVoVEFibVA4Z3ZqWDlLdjd0bVZMQ0dCQTdVSE80UFdodGVIdXYy?=
 =?utf-8?B?UVRxc1ZmdWE2WHdhSFVWRzl4ZGJqajJTcU9QeUY0eVhFLy9DR1NvNEtsVC9G?=
 =?utf-8?B?Yzh6aEdwekVDaC9TaTgwZUU0S1V6aXU2MWhhdld0SnpJTzMvOTBJT2JWMEhW?=
 =?utf-8?B?akM5UnU4UDloMTdNTll1cHJCelM1VFY1TjZENHA2SWJLTGV3UXJEaUlkTyt3?=
 =?utf-8?B?aERWUHgrdy9kTk5oMElmRkx3bUxMZDlNYlQyTEhVbllsTlgzZUxzTVZZbmVF?=
 =?utf-8?B?d1U5dll0VHVCMlRuaEFTVkN2NmRGNHp6MGJqZ3I5UFhVTG1mejNGVThJeHBz?=
 =?utf-8?B?RmVBb1BLZTZrM2wraC9HOVNOYllQaUZpMVNtODc3N0xucjQ1NE04ZWpSSFZI?=
 =?utf-8?B?VTRWU3pIRnowekVRajFRNm9KQ2ZDTlRxSXU1T0dIRmFlNmdPeWVTQUhUSnVT?=
 =?utf-8?B?aVFsOG1Cb3dMOWY3R095WC9hUG16dXROZ2lqQVU2eHBqUCtZSmo4YU14TU1M?=
 =?utf-8?B?Sk91RnQrbGhzNjJTWFp1QWFzS1hORHl5b2tkRVEzcmQzWlR2bXFCTEsySTJB?=
 =?utf-8?B?MExwR0FWTVVXTE1RSHZYMTBieGdWdzEwNURoWkdaNzdzb2EvVFdRaVptUUlT?=
 =?utf-8?B?MDF5blpaeDN5WnA4bXNpSlFheVF2V1EzclppNHZoWHBKVDFPNElRYWpubHhM?=
 =?utf-8?B?VnZ4WUhhWGRxM1gzZTRHZEJmYWVMYnUvSnNXQzl4QnZrRHhlTmNDaG9wckc4?=
 =?utf-8?B?eGM0dkNYMTNuTjF3dW9hMjkxM1JUU1ZycXFZUUs0bGduQXNaSW1KMDRiNHhJ?=
 =?utf-8?B?cFdZLzQ2L1FwS2hKK29HKzdiam0yOVZ5cmp4ZmhhcTYwa0MwYkUvT0tuekZU?=
 =?utf-8?B?OFV5a2xQaktha3BGbzBNMjVoTS9WSVJkNTk5UlovYm1Fcyt6NnJHM0xVM2dR?=
 =?utf-8?B?YjRqZHI0R3J1aTVOZFFzeXp0YXZUL0djdTE2MmFMUEljMy9HWWFVTmRBN3hT?=
 =?utf-8?B?UnJpb3BibHRsdUw1Y2lwSUVDODdkdHRuaHMxYXdyaTg4UEgyMnFiczd3enBH?=
 =?utf-8?B?elVqTmJMY0J0V01FWXRiam9DSmY1L0k1QzFlNForTlErWnduRjNIaktsUEFh?=
 =?utf-8?B?bklMdmZWOTNSaFNKR01uSVVFTW11TUJqbTNpbzhGeVVMQWJ6eFpWbWRzVWVM?=
 =?utf-8?B?eW85eE52NVFISFVKYjRkL3dTQUxoQ3lWMmhheDJSWXNTT0puK3paSSt2WlBJ?=
 =?utf-8?B?eWtIU0dLdnk3cERORzZZSGZqRWZJNEFnK3M4YWJsU3hTalRxYkZrUnAyOFZ0?=
 =?utf-8?B?UWZzRXNWSW5uVmorUHdYbzJ4YVVzZmg3a3laNmNDMDJnZVJTQnFmSUgrMWpL?=
 =?utf-8?B?ZkdNMW0xVzNZa2lVK1RiSE5LYnJFb2YrQlZTMXpRVml4L3VwaWVFZ0N0WWR2?=
 =?utf-8?B?TFIrT2daR2pCRkRGRVU1SlkzLzhwOXJOY3k1TWNkSDdyREFOY1pIM01JcFJ3?=
 =?utf-8?B?aXRQanJCWVgrUXBFa3FlbUVPSTlpT1Azd0RJZVhqRzdpZDFubVhBQVNVdTIx?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?S284SFBYY1M1TUtVUVdwUzNKQ1IwK1p2YnZ1TGhDMDJoNHM5WWNrMStSQUpP?=
 =?utf-8?B?MVZEblhBdSsvOUVjWHRrSTdOL3lVZ0RHQ2VFdkE4SlJnVTJhQlc1LzMrekFu?=
 =?utf-8?B?NU13WERHOUxhOWdTclJVdEsybHNrZWxiRVJYZUJzVDhZYjRvZHFOMWkzdDEz?=
 =?utf-8?B?RSsyemVaeW83c3lWL0ZPY1BLN3hTNzVhYTkvSG5ZNmdWdlJ5SkIwdDVISU1z?=
 =?utf-8?B?dThZbnU0Z1l0b0hCb2o0TDVNeHp4TGJ5QWp0STdHTEtNNEMyKzNXQ3dqWWp3?=
 =?utf-8?B?clJaa05RaGh6Um9sUk0yUnNWcHgzWkpwS05pSWVlRXdoS1R0YkRlbVFLT1kz?=
 =?utf-8?B?SFhrcnFHSFhVcGZicTM3SnJSYUhOZ2pGS2VJVzBpdHZTQVBRZ3BLdEVpUDZ0?=
 =?utf-8?B?R05YK09HbFNFbXZMdC8zejY4RUh4OWRraDd1NWVMN0JvbC82T1dkVGpSSEhM?=
 =?utf-8?B?NU9Pdm14dDVETVJXNU1RWk1OQ1hrL2RoTHRSV0JuOGFvYVZkT2x2b21jd3RW?=
 =?utf-8?B?UDJ4STZMbkF3Z2RwL2xPbCtPTG1MbkZUUUxjN3ZEdXlBT21ZSUdwZVJNUGJ4?=
 =?utf-8?B?SnU5ejZyRTFxVXBiRTRIalpBV09zWWthcEN0OFh2RXVBdHgvVXM2V2F5QTFk?=
 =?utf-8?B?VE1lMlRWZVRadlNucEkrNlNWd3BMRmxoeWs1dEFJd29pV3ZqcndxczZuZ2Y2?=
 =?utf-8?B?Rk8yaVFiVm5GNGlreU5PUjhyR3N0Wm5SSnFSOXNZR3dxZ1VDWEhZM2FPa3h6?=
 =?utf-8?B?RkttQk5LUFFFeEdEVjA1Z3JWbXpXRFJZYUFLcE15aE40eFlHaWJQOURIR1BI?=
 =?utf-8?B?TGZIbXoxRytLMXgzb0ZmRkxua3pXSWdHWCtNTndodkJaVWsxcVZrN0VYOFp2?=
 =?utf-8?B?VVM4WHBrYmhFSjBMN2I3SDQxRmk2eGhlSGpycFRTTUhOeU5Lb2o3bkN1UkxU?=
 =?utf-8?B?UHIvckF1anQ1Q0tJUWd2SnNMc2F0aVdyR1paT3RxSGRHSlFFRkRXdXpxcEJ3?=
 =?utf-8?B?NGhlNStkblJQRmRrZmJacHQvenFITmlISG5MSFRXbkFHSGV1UUFybmVFc2tC?=
 =?utf-8?B?NVhBaFV2VjdwZUJSL201OWMrM2ZNbjlFeDlxd3VSRGRnbFJ5eWRGQU5WaVJM?=
 =?utf-8?B?M0ZjREtWS0JpUzVuTDNlZ2ZqSWxndjVPZFV4UzVubTQ3dy9nd2F4bkdITXZ0?=
 =?utf-8?B?dDFUMEVyOEJRc0FHcTlpek1sMGZ6RnBjYmdrL0l6dklsMFdPT3lNckQwbEJk?=
 =?utf-8?Q?uYdhl29N+KfVn6N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d8e547-0d61-4020-75cb-08dbf81329f1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 17:28:59.6373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSHq61pjP+wgSypSlY3UiDptakVKGuao+peFeNjIgnc3XimsGAvwjzefWQp9NUjPr5VZcNCtk2sCr7OBvdQO7g7UMBNmY2qJMADUSLA0o18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_11,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=957 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312080145
X-Proofpoint-GUID: zkOd4bG3_igWeeuTOPhWoBjf-Fmhw0Rb
X-Proofpoint-ORIG-GUID: zkOd4bG3_igWeeuTOPhWoBjf-Fmhw0Rb

On 12/8/23 3:24 AM, Tobias Huschle wrote:
> On Thu, Dec 07, 2023 at 01:48:40AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Dec 07, 2023 at 07:22:12AM +0100, Tobias Huschle wrote:
>>> 3. vhost looping endlessly, waiting for kworker to be scheduled
>>>
>>> I dug a little deeper on what the vhost is doing. I'm not an expert on
>>> virtio whatsoever, so these are just educated guesses that maybe
>>> someone can verify/correct. Please bear with me probably messing up 
>>> the terminology.
>>>
>>> - vhost is looping through available queues.
>>> - vhost wants to wake up a kworker to process a found queue.
>>> - kworker does something with that queue and terminates quickly.
>>>
>>> What I found by throwing in some very noisy trace statements was that,
>>> if the kworker is not woken up, the vhost just keeps looping accross
>>> all available queues (and seems to repeat itself). So it essentially
>>> relies on the scheduler to schedule the kworker fast enough. Otherwise
>>> it will just keep on looping until it is migrated off the CPU.
>>
>>
>> Normally it takes the buffers off the queue and is done with it.
>> I am guessing that at the same time guest is running on some other
>> CPU and keeps adding available buffers?
>>
> 
> It seems to do just that, there are multiple other vhost instances
> involved which might keep filling up thoses queues. 
> 
> Unfortunately, this makes the problematic vhost instance to stay on
> the CPU and prevents said kworker to get scheduled. The kworker is
> explicitly woken up by vhost, so it wants it to do something.
> 
> At this point it seems that there is an assumption about the scheduler
> in place which is no longer fulfilled by EEVDF. From the discussion so
> far, it seems like EEVDF does what is intended to do.
> 
> Shouldn't there be a more explicit mechanism in use that allows the
> kworker to be scheduled in favor of the vhost?
> 
> It is also concerning that the vhost seems cannot be preempted by the
> scheduler while executing that loop.
> 

Hey,

I recently noticed this change:

commit 05bfb338fa8dd40b008ce443e397fc374f6bd107
Author: Josh Poimboeuf <jpoimboe@kernel.org>
Date:   Fri Feb 24 08:50:01 2023 -0800

    vhost: Fix livepatch timeouts in vhost_worker()

We used to do:

while (1)
	for each vhost work item in list
		execute work item
		if (need_resched())
                	schedule();

and after that patch we do:

while (1)
	for each vhost work item in list
		execute work item
		cond_resched()


Would the need_resched check we used to have give you what
you wanted?

