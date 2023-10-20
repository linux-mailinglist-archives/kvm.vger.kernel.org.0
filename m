Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8EE7D0F2D
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377254AbjJTLyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 07:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377114AbjJTLyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 07:54:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3F1A4
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:54:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KAiAtU016497;
        Fri, 20 Oct 2023 11:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=RMs0opdYzkMcIKFXq0bzSQfrxhCSiCyEY9tVnldAEUg=;
 b=L829/9vod9u9EQGsOssLWcSQomag2z75WJCWITGGxVsKt+0kHYibyqu0GdOZqTktHfMK
 mDvFeJbquCvtijWcf6e9+R/9iTX4jvtE29vxlKro14D6bc2zjeVgqB/avAKmyRRL9dQe
 a6YS839GLwLDMQgaCMJimO1CC+svEUtRZHvIMc66Jbs13pbWph6ohJGWOFN5qOJb5H0M
 eyFf1EfQn5HOy3Ly+O/uSX2WsxpzudqybxZooebZl5MeZ5GNv3l1hTWIkzM5gwSsHlt+
 FO0yfStDp08Wq+eQXudKwPhd3FixV6OabAlC3ebx6DIVasXhDCMW4Hyt9XSB7ndYzeFc OQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwasmsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:53:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39K9rmJX038476;
        Fri, 20 Oct 2023 11:53:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw4qkbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m37oIMDukY2gsCbiiwXpIyrL3bENoGHdSZSG6z9vc4kPKVQynopagzUAtmCEH6wAGo0CysJNtbtaOlbGCcMyItSl0QI4df5C8c2u+0blIDQJFfYhG5tGGsctkHZqnF87Ugi6LYYBSBMHyQzKcdizOolybOq6NzK0zi2wtBoxxRdzIvtlwA3kqhYLbzqoqo2BVE0/AyOoTGVb/GFVWo6PPg9krrGGNBe9ddScXFednjvPN5zZA/lbJmXn6tkPTzNw7h1+WPs56Hhou9P9LrKbCkP4wbczXmU5m79HAqqi5Jq+HCAjjWiV7ST+WmjRe3vbXdMBI1LlefHz8bVv5M9ctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMs0opdYzkMcIKFXq0bzSQfrxhCSiCyEY9tVnldAEUg=;
 b=Syhk+XAIk4U5eite66rMy+gYYujyEBxRQPW4TqgjqEQgx2bzNagG/NXhBWIwJphgiS1J27ZPvmtJhBwv85shh7IHn34NUrOo9ZhHtkmGjHyH9pEDanFKEvbF69y5MgzU62ezj3nnYB0iofWpOaxMncbiaV7daRVBKw3Im3N7Ynp9Iy7FCDUX6JBOka33Kfc5o0KripkoCXN+z+yLrHxCSqIGEWq/epG/OA50PQ/UYe2fX/kOpdf6aKVzl3mySoPfZVZWqhG0OOpHpq2BAicF1miF1DAuyx3+/g2Tq+/YgFsqhwODGmzZCJWmCnoV/RTyfl1k5wr+Y+C4ifLLha37Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMs0opdYzkMcIKFXq0bzSQfrxhCSiCyEY9tVnldAEUg=;
 b=rJ23Ih7BSRosNhLdqgRUs7Y8W8Yqh2fyAPU32jScnyE4kzDMRHs5G6pZoh3Kwwz73UxqCom8Q84zU5qDYRuPE1Vidz7AM2VqD9XDp2Vl197AyRNbg0TKMZ8X/CiprerzseF+UmE76GeQ3dpRJFDWzgk8yyYPsq126LGFB7sme6E=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5350.namprd10.prod.outlook.com (2603:10b6:408:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 11:53:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 11:53:39 +0000
Message-ID: <cec5aba3-6e25-43e4-9aee-1342a369ece4@oracle.com>
Date:   Fri, 20 Oct 2023 12:53:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
 <BN9PR11MB5276E0546391A87457258D368CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276E0546391A87457258D368CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: 669003d8-0cd4-4496-d93c-08dbd1633320
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZNA+KcQ7GLUdz739AyQ3ts7f5DN1tJNk65d5KLeIMC8bql8AoRf+bq5HU8Ee5OTL7smopbxGfV1YhJ45EXCk+8jacfcJEtXGyx1laoV3pgaPVsmbfozRaf8hgmnlC7n3+el2Oh05bL6dRLhSliG+5TgRIuRqUTL/NnGHsfleEY4adNPx/zJFemMHNrJyYFelhO5fSl6yuqmYa5o8MYTr557iU0Ch+dB6qA3yb3CfAeMHIAFnU1trdFYdZMU0u1Eux7B9B5QtScsvzk6kDwlveWrFmZWFveLBO+5Cls9jUWSuwUWwBCCbpp4R3JrAwULkYDorNCG1lPfU1wxf3N3Mi7q2cBrARc6moQkDfWb9YWuIgiAsmM+fDUK33FMhGPuQf0xXGupOkNzUCv54nKawb033NCcdBlHJzzf7ecVGGihc9HHhtFwteme4qx+kp5Ru1XUivSO1FtCVIvl2+02HFSw1ikbwWpJnRYHsyJZ3QeIDBMUtfUj9xqZJDqHHCtma0e/O2DgYHxd8qp0UmGyrCKKUZJmwz+wbb9k++2qiFdsITtOMTcfdice+79bxydnndkd0aYhF1n7xnTYzUlq29zF+xj2vYbIkQcq5VdGdwEoYmX/B0vmc8HkdB2KuT8o/hIVxUdVXpZAvp5NaqH1X/bqxx9oPYKn2qHhlMv7C1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(136003)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(478600001)(6486002)(31686004)(7416002)(316002)(66556008)(8936002)(66476007)(66946007)(110136005)(54906003)(4326008)(8676002)(5660300002)(6506007)(53546011)(86362001)(38100700002)(31696002)(6512007)(26005)(36756003)(83380400001)(41300700001)(6666004)(2616005)(2906002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3hObHJZbjlZSkgwWVNZVGQyWUNTUTBqWnZjb29EN2d4NkNYYTFrVnBiRlJG?=
 =?utf-8?B?UTNNS1AxajgxQU8zZ2haQlo5QTZZQWJyQXBhUjhmT0JJbVhSWjQvRkhxc1NZ?=
 =?utf-8?B?RUJWRXR4OWpTZWVVdURwK0NkOGFldzFUVFZaYmYxRFUzRURobzVhRTF3THlO?=
 =?utf-8?B?RGVGSlFhSmJ4bDl3RlorcThKSndONmI5cHp2Z2ZBbDJkOFpFSmpEaG9aQzBK?=
 =?utf-8?B?QnRJUkVTY3cweVdSV3BXQkFjclVRY2JEaysxdXFuemI3RXR2bkdCZlFjTWdz?=
 =?utf-8?B?amNyTU42Q29NR1JpaFNKdEx1WEVxdWVFZUM0a3czemlWVHVIMzkweG5SeDE3?=
 =?utf-8?B?VlNEQVZiR2cvRjlrcTRVZ2xSUjBnVjNVQWFHcnZpUG5TcDNTRVo3M2hCSDho?=
 =?utf-8?B?d1ZETVdlMDB2RW9lb0ZPRk5vQXZPcmhqNm45c1NvTXllcW10eFpCRk1nRmRS?=
 =?utf-8?B?Rnd5bSs3a1dmNFQzeE1nVk9weU01bS8yQnRUL250QkJleFpoNEdXL0RLd2dp?=
 =?utf-8?B?QnJ3SGhlbVdvb3lqNEd0NHVsdFo4Vjk2cWV5VXllRXNiSjM0S0JCdFVFeWV5?=
 =?utf-8?B?MmhkOG5XNDVPVHF6eWFraXM3SUdza0dvU0g3UnNacU1IZytRTUFQV1c0RWxQ?=
 =?utf-8?B?MjdRaGNGYi8raHp0WmtDYnRWQnlrU1I2b0d2czRYbWxjY0R0cXQ0TW4xdTQ0?=
 =?utf-8?B?ekIzN1JCYkYvbUdFRVZzK0I0YWxrV1hGeVNLU0ZTaEVIRkF3bWNJK2hwU240?=
 =?utf-8?B?dGxWcUhaU0RERDR1STJ2K1ViajZKSnFlZ0tZUXVhU0hzcXlLcmlFdnlEV0hp?=
 =?utf-8?B?QWpFV3NId1krZTd5eUZabkpmNks3Z25ld3NMZlFsMmphYVVBY3lVajZpbjFX?=
 =?utf-8?B?RXRPVlRNcFFyUWllZ2I1d2tJR09qNTErT2dTMjM0cVNmQU1MaXBjYStZcFVl?=
 =?utf-8?B?bERWNHhtdm95Snc5UEhsUHhCN2h5dk5wT1ZvOHFZbmI4UzNhSW9FWDdQM3B2?=
 =?utf-8?B?WG9rTlMxNUJaWnZlNGw4WTR2WlRTelNkVkFDaldTNUdZU3hHWlB2MFNOMzhZ?=
 =?utf-8?B?WDBrTlAybnBMeEIrK1dITkx2eFdPbE9NSkNQb0VpeHJFM3lrWnlnbU1yUHZo?=
 =?utf-8?B?VWJ0cFZvUUdmTm1weTBtUUgwa3hPZi9yQlhHK21EUytOWVVwQXliOTE4Rkcw?=
 =?utf-8?B?d2JrV2VsS3ZzNkFsYkE5MUlFVHZRd1FGSHprbzFtTW55RlVBcWw5NTU3cS9t?=
 =?utf-8?B?KzZMRzNvY1pRWGVyaEl0MGlXRVh0LzJ3dTBBcUpUSlpBTzk4eTlnOGNmMmkw?=
 =?utf-8?B?ZXc1N0IrcE90OEVodTJDSWFjMkUwZHpvSlYxKzNPRzBEaWM0TFVXUERFM1JO?=
 =?utf-8?B?NzJ2NjVlRmwvYzlWajMwck4wY0hKMUZsQ2FoZU13dzVHMkRXTDVtbitFOG0z?=
 =?utf-8?B?WWJ0bG5iZkgzU1NRY3ZkNGp5aHZzWVR3RmFwZ3A4Y1oxNGpVMVlpeFZDaUVi?=
 =?utf-8?B?T3EwRTZnblVIY2NSR3pYb0lVTjJRSTNrb0pkU1dSZzluWVB0SVFhZ1U5aldI?=
 =?utf-8?B?NTNoUkdKMWV2cDZFSHlwZ2g4RFByWUFPSGRSa0p1MTdPeWc0aVc0dVhKN1ZN?=
 =?utf-8?B?UTZybkM1bGpZZkMxUWN5V1kxWEg0QVc5dDZsZldKdWFrU2xDK1B6YTUxQ1BT?=
 =?utf-8?B?L3FUU3MwcHl0eWlRSXVMUm1hcGVibEl3UVJxQ20xN1VKY0pIdTJVZ3dwZmZB?=
 =?utf-8?B?ZWJSRGhncUFNUmxaUFd2NGZCdXV0aEN3MmFGTUZSblVCZmd6YWoyWkNlSlBC?=
 =?utf-8?B?WGJaOTNPdEdZZjU3VFM1Z3hldisyWTJQUGd6M2FaN05qdEM4eVZ4MFA5WUNz?=
 =?utf-8?B?VVYyYTNma0lNbSs5cXEzQ1VXQTBSZTFvWlhJZEFkVVhPUDBCVkZRdjdhZWtx?=
 =?utf-8?B?V3pDSUtia2lLZy9qbFltS29mOFozcVZZdTBQREdvR0Q0TVFUeXBCRW13TmdU?=
 =?utf-8?B?VDRRdk0ycjN3T3k3UzdGaUd1NE9WdjlmcnE0VDBmSzN4RnVlNmcxMXM2TzY3?=
 =?utf-8?B?aC8xVmdkYTlOMllscmJ4VEd2cWV1dDZwNlhTdmJWUWNTcUcrK1BFSzRsMUFU?=
 =?utf-8?B?SFViN2VYVy9jRm42MVRZM2swRE4xMmUxTlpRM1FJZm5paGNuMW9nV3AyV2pz?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Vk42VU1FRVE4U3QwNjdXc1AzQ240enB1YjBGWHVRdVllWFlHN1M5OWdMbkg1?=
 =?utf-8?B?M0Y2VzBiQ3J4R1AwTUkyK0JEMXpmMU5xbVM3b1BTNTh0eitCdE5XMVRENmF4?=
 =?utf-8?B?R3BRYjhQaS9OOXgrUUtaTXZBMy9FRUh4N3A1MnpOQTBqaUQvVFlRRk16b0JV?=
 =?utf-8?B?clRTWWNPYXJSV2llK1RaN0g1ak52aExXYVJiUEVncG1aTS9LWjd3UGFoZmhl?=
 =?utf-8?B?emVxY2lGYmJwRDlxSzR3cm5KVWUwMmhvcnFyZzNtRS9CQkpPdWkzc3N4UWF1?=
 =?utf-8?B?eVdYY0hYdlRPUlFoTmhRRlVJMjJLMG9YS0N2bHZ4UGRVK1ZRR1N1eHhhQUZ5?=
 =?utf-8?B?RUZEdys5U0pOalJ3Y1gzelBvb0Vhd05BMmpmTkZNRnpGaTRPMlVwR3hDL0Js?=
 =?utf-8?B?UlZmN3B2cVlMUmFMWVhVeUMrRktoKzBNMU9iQ3R2bStLRVZ0SUJKTmk0MlU0?=
 =?utf-8?B?THpDeUtYUDVPTmgzUU5CbFdLM1E0ZkVxTUkxbEM5bmN5S2xoaU16bEgwdlRp?=
 =?utf-8?B?dWE3RkRnVnAzR0lCNk1zSjFGMzRZdVZycU5pYUU2WkdnYTdLcVZTQzVHWVRV?=
 =?utf-8?B?MExZVzdVRXlqdHdsLzJGZDFldUNUTEFPR1pESGl4U2Z6MmF4SWFwR1dqQ2h6?=
 =?utf-8?B?V21VczM4bWFHYnNlSUNucDMwa3E5V2h5b0pKOHNML2NnaDVwVEkzRWs0LzMr?=
 =?utf-8?B?RTVMTE92R0hLbTBmR3JYQ2kwUGRUQndBc2pUVW9vbnMyUDc1dm5Oa3FIdDF3?=
 =?utf-8?B?RGtvaFhWN3NrTGdwUDRyRFFneGk5cGt4T0JCbnQxRUc1Yk5FT3F4V2VTbjVR?=
 =?utf-8?B?aEZJSWhFWThrS044dWVidVlJaHlFd1Vud2pGWHJKbURCb3NaT1VsclBpcXM1?=
 =?utf-8?B?Q3NydmlPQmppOFhIaktYOWFsbFIvWGtKL2g4T0h0eGJ4dlV4dW9HNkF6MHRE?=
 =?utf-8?B?bUxIcXFGUlhZUVRJMzVBS0pSTldVQkcwMnc2WXhTaWxld05QWlVOTVYvaVpp?=
 =?utf-8?B?OTJFSFpNQ1Q0NlBlQ0VWamMwcGllOXU5SnJieHNtS1ZUTWxJYXRQZnIwdXlO?=
 =?utf-8?B?cVd6UDZBSjJxbXk3ZisrSklySFhBck41c00wdmZ5QXloNW1mTkpSWEhaamRw?=
 =?utf-8?B?eVhlNndmZ2dWeHpzcTJLZ1h3N2lIU3l3WEdWYmVISjFoOUFWYVMrdXlPaWhQ?=
 =?utf-8?B?OStFc0EzM2EzK0Z4bWgzcDBGY1VleWpQalpwUXc0QTB2TXhhbElwUk9oK2d5?=
 =?utf-8?B?MGhOY3UxWXJYSEdXM0NoUnNjN3pyT0haM2FIQUZjZlpsdXdYdU9LdmJMQyt5?=
 =?utf-8?B?WDFIQkMxN3l0TjhXcE5aOWg1ekpDb1crRHROK0JXK1hLSVBXTi94N3BVQ1BO?=
 =?utf-8?B?ZGt0SnU5UllMcklxN0RHVmNlL1BWd3YzMXcyMWxNeWkydENDU0JaMFN5Skdu?=
 =?utf-8?Q?B2YL4DI2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669003d8-0cd4-4496-d93c-08dbd1633320
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 11:53:39.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xZNF9Xj8fleYpk++Z0HlGrOQtx7UzWNRNyBfMYW/3nbucSHpFaWCkZFsBgM2UWo81BRUIAIuExFNoH8Nm3xHTUj3VFxpLBUSn0SlkkFsPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5350
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=993 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200098
X-Proofpoint-ORIG-GUID: K5IL1fxfpmXeF86QmgYuuY64-kEL_oTs
X-Proofpoint-GUID: K5IL1fxfpmXeF86QmgYuuY64-kEL_oTs
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 07:32, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Thursday, October 19, 2023 4:27 AM
>>
>> Underneath it uses the IOMMU domain kernel API which will read the dirty
>> bits, as well as atomically clearing the IOPTE dirty bit and flushing the
>> IOTLB at the end. The IOVA bitmaps usage takes care of the iteration of the
> 
> what does 'atomically' try to convey here?
> 
Meaning that the test/update PTE events by IOMMU and CPU must not intersect, iow
in a mutually exclusive manner. e.g. IOMMU hw initiates an atomic transaction
and checks if the PTE dirty bit is set and then update if it's not. CPU uses
locked bit/cmpxchg manipulation instructions to ensure the testing and clearing
is done in that way. iommu hw never clears the bit, but the update needs to
ensure that IOMMU won't lose info and miss setting dirty bits after CPU finishes
its instruction or vice-versa. But sentence this refers to the IOMMU driver
implementation and the IOMMU hardware it is 'frontending'.

>> +/**
>> + * struct iommu_hwpt_get_dirty_iova -
>> ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
> 
> IOMMU_HWPT_GET_DIRTY_BITMAP? IOVA usually means one address
> but here we talk about a bitmap of which one bit represents a page.
> 
My reading of 'IOVA' was actually in the plural form -- Probably my bad english.

HWPT_GET_DIRTY_BITMAP is OK too (maybe better); I guess more explicit
on how it's structured the reporting/returning data.

>> + * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
>> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
>> + * @flags: Flags to control dirty tracking status.
>> + * @iova: base IOVA of the bitmap first bit
>> + * @length: IOVA range size
>> + * @page_size: page size granularity of each bit in the bitmap
>> + * @data: bitmap where to set the dirty bits. The bitmap bits each
>> + * represent a page_size which you deviate from an arbitrary iova.
>> + * Checking a given IOVA is dirty:
>> + *
>> + *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> 
> (1ULL << ((iova / page_size) % 64)
> 
Ah!

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks
