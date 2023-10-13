Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9EB7C8B7C
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjJMQYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjJMQYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:24:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E917B83
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:24:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0iFo019174;
        Fri, 13 Oct 2023 16:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Gvsk4dzb6Zpf899d/zxOh8wGwDn8TYJ43CLVRbLPdj8=;
 b=X4Rt+2EKSjYzHTUg8wLu0iF0q1gTNgqVvUwtvAYQOCquGjutNOsmYf+XdSR623jedZL0
 fnig9OjqPl88uTj0PeNnDsu6BlhFxxatLL/fKqpYO5GeJl+NmI/E9rx3OgjR97eAsE1M
 nsgTW9lEEfh8d096TpqKcrcyaWpeQKCEziAxMxMjLPJnM273a9prQ5WR+6pwhA79XlkD
 T+wmCATmwbriNAGcs27QBltnRK0AMSb/IR4AmASPNxdujUiXp/YY41tDB/OWQYXJ+gCu
 7KQJ4CbmATaYUDJOEEAdRWh99zj/E/J8mT1Qv/y8PBFiABBVs8Vt6ai2Srl18dPL7MqY pQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh912pw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:23:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DFDIJU022031;
        Fri, 13 Oct 2023 16:23:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tptask7bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/tI7b+Zp5vwKV1oFJr+qpLed6Ftfe5msOFT3YTlKUeyI1z6J5VxYzm0tgC7yW6i1aDJyi8IWM8KBfrUZWTUPWXI1CJ64ZzWwsAC/4P25/mjRFX/p2DQ/NbGVyrbTNEvBFLYTccs1IAlAVPqQQ9rXELf2ptONQe3GA/taPAtCbqZtkXOmb5N29yxd1kbo/Xpo9ow7LzUaV/5qlvOPi2uf5NN19/O+8xAW8RKKGSdjNrjz+TjYQhjPv23GiDAdSSVp9OvqbLkxBkm1D5bGjMXgdOLAfkW62Lhs7U5hU3M0/hdMIysZtBLHo8RBMYEx6s8a3qD5wff01e6HpSPHxjRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gvsk4dzb6Zpf899d/zxOh8wGwDn8TYJ43CLVRbLPdj8=;
 b=L1YTfY6d1ov5YRXN4ZEmN8wwgXynOwEadd7uIGElNB268i4rTsSNnW5UmWCKz3VthUQ1o+t13h3H0FXvQwU8SzzqNIg1hO8yINN4Stu8ob3ji7UHUV34h3HOcCupn8fG70+UBTbdoZ7XBiQt5sKbbRUaSQoIrjcNhfGHv878Om1HMHGMXIkUQ7v+nsapeJ/AAPU9TsUN6JI0PBdZAf/mSrenIDsyPf88k8D4Fe3CFmhXVajhVmlrjke++oJPiJeqCthogZBY+WBdcCDOH0iE4H7rDkLor2wsoUhAAvVeGluBlqkNCdHAtlPF7ZmVAxF1MP2e7PhhCoeX3C9BO7oJZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvsk4dzb6Zpf899d/zxOh8wGwDn8TYJ43CLVRbLPdj8=;
 b=nQh5vwW35VMA4LBpPcBN/1pJ8L8QsknVIneaXm6c4SM7peFmq/YMNNUXsdHZxO9YfXdt0wnF5K3BaALDHIibbi8a1p+Rcy8Qj2Mb0+bl68NI81iYPQl38/ag4XIfNWVWCrjJPMDzMJH8gupcynuakzdgH7nWImBIZ1gxFIQAMHw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 16:23:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:23:40 +0000
Message-ID: <3ac915c7-0268-429f-861e-09a060d83281@oracle.com>
Date:   Fri, 13 Oct 2023 17:23:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <20231013160409.GB3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013160409.GB3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: cb398d95-593f-4435-7bee-08dbcc08c2d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwfb76HQmg8nPejMiDfRJGx2VCAafk/KtDIkuZ7u4B3Tchvi0Hw6lv7AzWLSN80oWgNZ6Vc1wijlCT3qs8M422hBx5UGbFQdGdPOWlXJ/Yc2FOf7V0AEL2qzSS6g57ddq71JDDx25cw1iy0E9DAEVJX5ptJrl0toZZLtYuwJsc/QvgR3r7g1LCYb8O1e+oaoGWAWBBB8kpjbI7MB3mpaZVLA6dhO8dHLEAyEXLVhno+rnnmwO/t5Cl2Ojk089Mv3KSM1BIhJc5xVdoLRQhMLwN1so1koVAP32dM9jPabf9TMXK9chdoBumCphbpxPpGPEfgfcqZpU3FecflvWdqf3XezhvcyTfp5lm9R1DbsbMAmhK8E7f+/HhGomHYqf93rxp+kMejcccgtfz7ht/krOlYoIRmsEHFs/xaVCdX1NnnBJd94ZpkY8ZduinZ8TEoE6HDZyneVhEgKk+O+OukbZlOk3F5+GbnzOhzQk4bRPxWdUFGvI3CNmbkQ6Zd6vSgQJNnLZni/K8jpp9l7z4IzTJmidJAsNKOJIPtbyKfrWhBbR2hiYDV0jSqxyoKy/rvDt2WyeZILzn6a6oUgY3bNcCiYZooztzcsScwGlSlvP4Q0Q7R+OwBT6NbA0ANIHSFnMG7F/lVWgqfHAYzX8IFxAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(54906003)(6916009)(66476007)(66946007)(66556008)(316002)(6486002)(6666004)(31696002)(4744005)(86362001)(2906002)(478600001)(7416002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(31686004)(26005)(2616005)(53546011)(38100700002)(6512007)(36756003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1Vuck1TQVBwVHd0T24yT2M1Tkc2Y3BQNlN4enJiTFA0VmhTSnE1b1UrdHBW?=
 =?utf-8?B?a3lDUFEzc2pGdzU3TzJpUTJSRzNOLzV5Wkp0Zkh6QnVPWUxMQzdpWW9LVi9R?=
 =?utf-8?B?ek8xdnd1aGJiUDY3RzR0Z1F4S2FXNmdvYnZJdVUwNDQxZ0puRFlad3pTYjg3?=
 =?utf-8?B?cUFHSGlIL0VDNjZFY2R0VVNmN3pPeDdmSTJNZDJwejVTTkZNUEpTZ2Jyd1NT?=
 =?utf-8?B?QTZndk1Nb1lUT1BCNGR2TFFZQ0lkNEduWXAwQUV1MVhYRWZHeTFtb1hLMXRn?=
 =?utf-8?B?TUxCNDFkYWFZSU9WVkR1ZEt5ZFh0bWdHTGx1MjRYRGdkcnRQVDVsOFRVaFov?=
 =?utf-8?B?ekhGb2VraG9vQXdERWc5bHQ0RCttUFM3RWRyV0V2T0VBaVI0UDFXVjJrUWxO?=
 =?utf-8?B?cVFla1RhOWZaQVNjVHM3L2ZXa1IrT1hRMzFTN3ZSaUo2MVZUckhZYmJBRG96?=
 =?utf-8?B?VVhUTHNCcmRLYmpqdXlqV1c1S0hZRXNqRmZVT3djV25kcVpHUzM0eUpNVzhJ?=
 =?utf-8?B?UHVhNlIzcHYrenBRQWZzZEpFTVQwUjJnY1JhRFhPV2l6dlBFaHUya0pRUG1Q?=
 =?utf-8?B?M2JxR0trMXJhNXlVblVkQmd0THdpY01pMGhCYmR1OWE4a3JJRWNiMk53bmh2?=
 =?utf-8?B?dXlYRlF0QStYNmlLOGM3azRDa2txQUN5SVVKM0FEZFAzcGthUVQ5MDZaQXVR?=
 =?utf-8?B?UFE0ZjljNzZsaXRsUmduV1k3RWM1amxWS2FBNU83Mk9udGUyaEZ0djFncmZF?=
 =?utf-8?B?eXkyQXg1RFplNUxmdGdLVVdHZU9sZ1FYWFROK0txWnZFNEpSbW04V2NqaGNF?=
 =?utf-8?B?K29hNk1JZHhWVDV6MUVMQ1lGaHlLaUtXLzBmSFRuMkVuclhRdFlzY3JubVlT?=
 =?utf-8?B?N1dWeUNRSG92ZExVc1pqNk92dkE3YTF6SHgyLzQ4R0g1RDB0bGppSGJGZFlu?=
 =?utf-8?B?MStpSStIQkJrd2VKNk9oSmUyZHRURm1VY1BJMXZQMk5yOTBiNWRWQXZtZEwx?=
 =?utf-8?B?T1UxTFFLSi9najgrQjNQL0I4ZTczcUF2RFRBVWw2dlVaNkFiL3c4TTl3NjJa?=
 =?utf-8?B?OW5tV3UxYjA1T29BQkQ4UXNyeVh5OXFlbm4yQ0dndWc5enhEeStMekZYV2Ey?=
 =?utf-8?B?Qkh0U21jdm9nbVRoYXRnOGRJeXVuMksrVHlPQnNYVlh1VzVhLzl6MFU1ejJh?=
 =?utf-8?B?RkcxQUR4MG9uaU5MMGxVd2c2NDd6ZFpXUFdVSTlEbVF6Yys3SFRxbXM5eUFN?=
 =?utf-8?B?UGZlMGZhOGpEdUtzNGY0U2JTRkkwVFQ2VWxHb2tlc0F0RjZsdEY2WC8xWFYz?=
 =?utf-8?B?eExoMDRYcElaZFFpQzVBOVNqVFZRbmt2UjhwVVl0TE55TklBSHNNVlVRYUlL?=
 =?utf-8?B?b1ZucjlVZ2NrWWYrNHMvRWJJRGtTMVNMM3dQZW54STBQK1BDeDhvYTJSOHhD?=
 =?utf-8?B?OUdveVFBK0JYcVhoNllPVHhNV2kzVkZsUlY3QlVMbVlNeDl5N0RNUWJCSDFG?=
 =?utf-8?B?YlBHRWVIem96TklvRDByelpqTkdpS0p4N0txVU5DcHZ2aHp6cEpaUVhFN1Ry?=
 =?utf-8?B?cFNzSVFZc1JPYmxMRUNyZGFOK29CWW5LUDUwZndHdU5pL0RUNUExVTFBSkY2?=
 =?utf-8?B?amRxR0xWN1VPWVJIV0JlYThYaGpzNWkyWktNNDNlSThLR0JxQTA0eFdXNEtU?=
 =?utf-8?B?M3NqZlpsWlQxWE1FYUNubzB1MC9QeXg3VWRsU0NFUzJiSDhyWE9yVTJzbUtD?=
 =?utf-8?B?TmhYWTJpMXdvUHZpb1EvbmdMYUVaMk4wTUtCS1AwMEdpV0J6bnpickpRdXhi?=
 =?utf-8?B?UXRKMjZuaUxZOGhvSExROVlhNU9WclVRU3Y5V2NraFA0K1RROUlRTUVYV2k4?=
 =?utf-8?B?cTZBWGV3am04RFlPV1FJMko5L3l2ZVZnR05sREx2cW11SXFYM3Y1MjZkbEZH?=
 =?utf-8?B?cUM4dWdPQ1NvM3BlWGpUeGFhODZvaGt6dmRHT01kclptQUdGWTlvbGtwb1Fu?=
 =?utf-8?B?Z3ZWTUlzRDh2MkVxRWdUdmJpYkpwQjE1M292QnFaZHpwTy9XTVdZL0piY2Zj?=
 =?utf-8?B?TjcwSFVYYjhoQ3BydUhNU2I0NE0rZ1VuVVJSTG9pY3k3VEVXUC9Bb3NZUC9S?=
 =?utf-8?B?UGVqcktxc2pYeDJER1M4bG04VG9EVlB1cmNPZnB6amNOMVdSbHhhR3ZnMDMv?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d2o3cGpKV3I1VGNMMjMwUjlRMGdEZ0x2WWlVcktiSjZHUnBGZzlDMlpMMHQv?=
 =?utf-8?B?MG1UNG5OWDcwSThRakw5YWJ0Mm1Vbmxvam9KbjVnOTl3OHRDNWhzcWdaREor?=
 =?utf-8?B?NFB3S0orbkxwWWNGRE9hY1M5OFgzSlFnRmFvdUNXbTcwUE1Jd1BUVURjdnZx?=
 =?utf-8?B?RGNhN1BlNS8za0drWkpOSlo3NGlod3NtTS9MVGYxblNUcXRoaDRCU0dibDJS?=
 =?utf-8?B?MHphNGxHakVZUmtKWEMrQlRzbmMxYnZWSDlZMnRkMHNoZktCMWRGRFNPbENi?=
 =?utf-8?B?am91NmpqUGQxTXpyWlFGTzdSakZXYWYvcEpxdy9CUXgralZlWHQ1S0tSK01X?=
 =?utf-8?B?MVRRak9HNVhSUW1qMG9nSlEwMGxWNmcyQ0JrSVVsdHlWQ1NNNUtvQmlQUE91?=
 =?utf-8?B?KytjOEZKWFFpSWxoQ05qNnhXZWQza1R2dk5Vc3JlUC9TYmVSTlRGQ1lTSlE2?=
 =?utf-8?B?T1dZVlZ6QW1IT1ZhTHdhTHByK2NKd0gwSVJ0SHF2dFAvSWYxUDN4TFZkM2dt?=
 =?utf-8?B?Um9xeTM5c05EUk9DWXE4K3ZUQVU2UHRBQ25zZUFIaUJNQTRBcFcwRXJoNTJY?=
 =?utf-8?B?NnRQRTNDdFF6ZGxoRDlUTkIzbytzWEl0V2lzTU1RVUtQMlN0aUp2dVNJSVRa?=
 =?utf-8?B?aFNJMEo4VXZySmRKOW4yQ0VQQTlyRVhRd3hKdjBlQk5ZV2RMSEZJNUJOVWw2?=
 =?utf-8?B?cXVHa29ma3ZWaWdMRGt4NExNcWJ0WFRqR2IxanNNcW1RdTBidDV1T2p4UVVR?=
 =?utf-8?B?ODc5VDJRaEhyc2xSY1I4OUI3N285ekxCRVM4VXhrOS9nTGxOZVc5UitYcCs0?=
 =?utf-8?B?YXZjUWFPUnowbWk5NzBUSDhCOTZza3dBeE9jeVNpTlBtZmc4dW0zbEppK2Z2?=
 =?utf-8?B?cytYNk4yOEF5aUlibFlmL0g3aFZLTS9USS81Nkh5L1JycUdWcU1sektlUWF6?=
 =?utf-8?B?a2M1S2t6YnZnWnFqNTFycXBYUEFERUtMajR0SW9xeEsxRXgxejFqVFRtTWh0?=
 =?utf-8?B?Zi9CMGZwYzQyTlNjeGltSnVZRzJlaXprYURQcmZtTERUOVVuM3Vwa0ZZd1E2?=
 =?utf-8?B?QVVpTUExWHlZT0t6OGR4emZHSlJHZmVOczF4WFhhVEFaS2J3U2JsVmxCTmJs?=
 =?utf-8?B?VzdKeWozb0lqQzl4ejlNQWtCWkhRNEorVFlSdU1qamdGMUc0K2xHOXpsY1Fw?=
 =?utf-8?B?enQwTUk2cS81dC9WTG5LalVpL0llRG5rd3lOekxFenJKLzd3RnlFU1FjMWF3?=
 =?utf-8?B?SXBRd1hGNnBtTjJmemI5RUpEWGdDeVo2V0trTGNQeVpUcTJVNEZuWVJBcDFv?=
 =?utf-8?B?U3h5bC9KN21DWWlSUVhZVDFXOVBUbUJiTTZHZFFESjFkZTFyVHRocTIxdWhN?=
 =?utf-8?B?Z3lVbktqRHBqaGpxVUh4L3UvZDF3MkthaWtUWHRBdk5XREhoSnZkV0Y2dlFU?=
 =?utf-8?Q?WfMVqx2/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb398d95-593f-4435-7bee-08dbcc08c2d9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:23:40.5471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMixPSITwbh/rZ4d3Nfko7IbxxqteRGVcM3XNTZHiuSiBp1WTKocmNkHaOGN0D9Ls3+XyBTkGvHqD+3BRxe/ER3iWDyNYI8TRMSJd7saoL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130139
X-Proofpoint-GUID: F_FOFVshWtVnvorr5JWdfNdGL-XlmYpy
X-Proofpoint-ORIG-GUID: F_FOFVshWtVnvorr5JWdfNdGL-XlmYpy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 17:04, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 05:00:14PM +0100, Joao Martins wrote:
> 
>>> Later when the iommu drivers need it make some
>>> CONFIG_IOMMUFD_DRIVER_SUPPORT to build another module (that will be
>>> built in) and make the drivers that need it select it so it becomes
>>> built in.
>>
>> That's a good idea; you want me to do this (CONFIG_IOMMUFD_DRIVER_SUPPORT) in
>> the context of this series, or as a follow-up (assuming I make it depend on
>> iommufd as you suggested earlier) ?
> 
> I think it needs to be in this series, maybe as the next patch since
> io pagetable code starts to use it?

OK

I'll see how it looks like
