Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA87CE1DD
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbjJRP4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjJRP4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:56:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09CE128
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:56:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IFT4sa009891;
        Wed, 18 Oct 2023 15:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7ITZu2Wt8FO0/bwtfuMKMQenZDSJvoZmKd/nWvPHC2Q=;
 b=OV3RQJlP8Dp/jjTce2367pXlodPksREUKt+Wg5Yep7FVJm9XoSlOdzGc94EEDQ381Sme
 cStwkd4mbF1YvWUq4DXN+5e097AZoPJKqeO0OZIELNBpdFLuSf5Hv+iHwPfxUt2J15j/
 N5GmEc6QTlK99XmjAKxKndmeE1jymFQBMXGDM+vYLcoEHz8DmIiXK9u6JqgKrOKMAIqt
 +zKTo65qvRxvhvBZtve0wEzBsmn35rt/oLaMNW/M4SLelUedYyXSGffdSIDo1S7Fpm+1
 +ZnT9IQqj2fsOVYoA/+hZpyxcjpvbuEuE/vni1UWCO8Dr6LuLnyvdOyAwHZAsvwic5x1 Vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynfy83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 15:55:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IF6P10026887;
        Wed, 18 Oct 2023 15:55:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg55g7rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 15:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCOaw6J3UiylMQbtqzcwDvIb26M+uIH6man5LR6VEBCezsQXcPpiGfA3jujpAUNwHs+bu4CCgJVRJ5aPU3J882AYg5PMxfuT6pKNT+YiTpqV+4Rcw8SgRKscx86+S2ZaqPWcZe3Mfo/7fHMU5AwrS/n8xHmVbncBd9JnekmRaPNQDWshRUKzcZ+E6N5p4G2/gcAPCMmtQ+IWkWC9Fl4SGEbi9UWDoEmZjLt0gVFWln6QaN+gzsE46sSU4Y5D6f77iW87RCus+tBmSSjNVqY8rLyhou5nr6jarv+p8NGnHaoq3nMtsUb2Bi2DQiLVmJfJrzi+kHaFLHxS2cN1nOBmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ITZu2Wt8FO0/bwtfuMKMQenZDSJvoZmKd/nWvPHC2Q=;
 b=Q4qFWt7+Bc9yrGepjLIFma8Ot7R+G/O15fSvPJzKFOXKlfsmokbAcbLdWtey30qUnQCP47tQEUlBAyr9guEHWf4XejJx6Fy3eakeIQYWPes+Ptrdk8jlZBzxHdHQyVu5sUORusAxPCeknOUPh4Oqsfk6MMn95QUO3p3TC07JyvUF2wE76ZIpXfOnun7J05Gs5EY9gtb+makl5tC5mkRW5BrY4fPYUQknMtSxIQSXQN+h2LFR7+TqFVCS0waIgghgDIhkLyl/huYvu3RZQ1ZzUe4p4zkdyw0C7CE2Bin3+1sOs5KWXhxATU3q7o1exar17Li/2w0CDaalM2/o8mgolA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ITZu2Wt8FO0/bwtfuMKMQenZDSJvoZmKd/nWvPHC2Q=;
 b=SNpPidzectj6zlD3QB6apEe8Q1WpOgi0OPEeGfEdu+nuh1Ua2QNimg+ZFo26eawe2wrZlbbjo2ohMQVKOTXehoJPfGrlJcFb1x/0Qc1AgJCU5oiRUeAvIS5angIFm+HlJmSLrxB2tYzoO5YPi1Dr00SFewolFtCn6NAUTo1l1Ok=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Wed, 18 Oct
 2023 15:55:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 15:55:39 +0000
Message-ID: <7f44cd33-5a8b-4624-b1eb-1d06f7cc7b1f@oracle.com>
Date:   Wed, 18 Oct 2023 16:55:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Vasant Hegde <vasant.hegde@amd.com>
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
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
 <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
 <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
 <20231018155242.GY3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018155242.GY3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BY5PR10MB4161:EE_
X-MS-Office365-Filtering-Correlation-Id: d9be0562-16af-4525-f07e-08dbcff2acb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uQ4X9VnucjpsxHAiuNKEqsHNTWSgGWy2p+lJPSn/uI+iWklP5xsMzRt71xk2d9rKjvlvFRQzw6waIu8loW5LYaa3nuD4AgWTfieCi7MNCnH3MZHGfU7qhk15q24UZEDzYXKGct0orR3secUOlFvv5ktPXFSWrsb3lth0AfAmoaoafRYraRs4/vhU49fPYw1pkDEHL8dMgTtC5+r3wlQKpjS6iqKAnQJj/XhskKrknecC+t5AyXyklSkZZUOI55Xry1ZHgzq4i0AEK8+ef4Ni00ksQlVBrelsRe4ivJQkc+68z+geB1METX3c2KGVUO2CR1iM83oQ/ejY/cbI7hsC6fS78I4LKhZIESSbdR7DdvV0P7dD0ngyfw8lHprjAwpkFeIqvKOCUhwxC9USkCODpFqw+nF9QIpCqjfwC39IbtnqJPOQAaBZr0Pxr64uIM6EOa/yoqOLVMtblANWNISNbz36RWES7J6QMGABs/81p3YlieitIYKHZQAYqD14K9W2XXeU2rWY5q/ebRTxChf38tqvQ3E2UvuxLHElQH40BuY4Ws3ABdM/++4cJ5Zji3eYwtbCuAVSi98lLMoaOzSg81IzMFR7ZkWd+8lyi+uKJp5UC1P7rmrzXX/35Ern2HgjMM4rMIf9BIj5TW+RTIz/TjuFuoWOGzxGKLUl/hWizA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(396003)(39860400002)(136003)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(26005)(6666004)(6506007)(53546011)(8936002)(6512007)(2616005)(6486002)(41300700001)(7416002)(5660300002)(2906002)(478600001)(4326008)(8676002)(4744005)(54906003)(316002)(66946007)(66556008)(38100700002)(31696002)(110136005)(66476007)(86362001)(36756003)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OC9NMTB5NERIMm43MHF0VmptTjVZUzdXV0w3a3ZXZnBjdE9CQU5zdk9Ja0JY?=
 =?utf-8?B?enVLcnZFNDBWNEhKUGRpUnE3aFF0dXNUZTlBcFdVT294Wm03QitpQlFGYlFR?=
 =?utf-8?B?Qm43Y2NqVC9DVlBOdUR6dldHc1hmdXd1dXZJVHJvNmZJOU94Y1RkK2FhVHNN?=
 =?utf-8?B?dzQ0TWVyMENYZzZ4UDI5YnhSUTVvUlg0dU9HZFR1MjNUTVgxSG5neWZhYTk3?=
 =?utf-8?B?TmovNWZyN3RibEtqYURxS1ZCN2krOTNFNVJOOHNsbjJtQklFNFEzRzg3TmtH?=
 =?utf-8?B?UDZ4cjQrRytuRDFoNWFJVHlsSWFOaEN4Vyt1SXNKNEFpSzRuRHZ0MnVNTFBN?=
 =?utf-8?B?Mm0vSWNkRjY0N29pOFQ5RWVOTGhtQzdoVTgwRHFOdkJ6dmlSNjRNVlJFRUlD?=
 =?utf-8?B?RkMvNTVVK3owc0xVbWxxUWMxbWF3MGFueUVvUHZHMWhGU0JWREtRamRTRy9u?=
 =?utf-8?B?WmQrWE1wTUNmT1NLVDdXL256OU5XVmlCM1NGbThDMVR4NlBncVlGYyswWUZj?=
 =?utf-8?B?U2RzRDZaRjJveXlBYUdrUWYzMGh5R3FaS0U5NlZ0Y25jSVhITlZlcCsyWkpw?=
 =?utf-8?B?dGZob0gvQ0g5dXZXMW96eDFKVzEzZi9peDBYbkJocVpjZzZwK29xYTBKODhp?=
 =?utf-8?B?MmVrYUYvK2ZyKzU5SHRuSERwVW9CYXpaMWJVajFFSGthZ0diVVc2ajFOaUsr?=
 =?utf-8?B?Qk5XQ2VhWDB4T3NGU09yRjFBT0RmcG9ZUzN0RUJ2TUorcDI5bnhrR3FidldF?=
 =?utf-8?B?RUxBVy9qVlRMOEYzaDNQa1FPWkpsWktXZEhqc2p2aU5xWGtnQzNTVFRLaVpS?=
 =?utf-8?B?YUxJaTIyUFJrRXl1MEduamlUdG93TmV0ZDVFelF3T3ZITFI1ejBvSER5cGdO?=
 =?utf-8?B?V3ZRSmhtTWVjRXlIdzl0UWZIQytJMDBBTTJwNGY2VmtBT3lOQ2lyMjAzcmxs?=
 =?utf-8?B?WVpHUG8vMW9GTzNJZGxlMVVHNHZEb3p1Vk00MEVWY0hBRXlqeWhqeGVJUStC?=
 =?utf-8?B?VmNLbkJZTUtnY2phOUk1a2IzUFJOTWx2OGtUUHliQ0FHVE5wVWJQMU5xWlBM?=
 =?utf-8?B?ZFFPUEpmelp1RmdwMjh1dyt0bUN0anZ3S25Ld0pmRWZoRmZHL1M1YjNXRXNV?=
 =?utf-8?B?V2FRTzdEcUMrbmNOQVR2dVgySndvMnVab3d4d0JXV2NVWG9QakY2eDRUU2hJ?=
 =?utf-8?B?KzdJMDhhVlVlREpXQ2dLRjJNMlNFaHFod1ZXRGdmRlFlNEx4cWJsYURmYkwv?=
 =?utf-8?B?MGlqQ09ocmxYT0wxUHdwQ0wvQ2YvaUtZTDVPUGZPVGoxQ1dsZThZUkR5QWln?=
 =?utf-8?B?S2lwYkI5SkVDNTFUUUxsS2U3SGRzMER1cllUR0d1NVRYbFJ4K2xVTkdwdUhQ?=
 =?utf-8?B?TGIxMlNSSGZqdkh3bnlPT0hlOUJ5Y3M5SXRCTjNlZGZ4RllsNEhiSmNEZDBR?=
 =?utf-8?B?THg2NnNCZmpxbVlMMGwwSEdCRUl2aGYwbnJxUzA0S2pxcnNJdDZMQVNJY0kw?=
 =?utf-8?B?SGlxcDhYSGswcUFOUmRkaFpid1MzN0loTjBQSjJ6MXJVY1lxN0RhVjIxNkpk?=
 =?utf-8?B?VGVLTEtVanc0UVhFZlBubG0wQ3YxNXFZOFVhTmswNzRINmlPdU9mRTNaRkZ2?=
 =?utf-8?B?cWVtNHV3TEpiS1JtZTdDNlgxZ1l0Z0N3MVA4bCtQeUkzeHplNnQzcTRONDVW?=
 =?utf-8?B?RUNVWEIxbjBabG9WTzU2Mm1UaUxZU0FHTUpUK21HSks5QWwyeTYxRUFFVFpX?=
 =?utf-8?B?L1JITHdHN29FLzM2NzllQlZ5bWlvKytmNHdicm8yNW9QRXExQ1p4UjYrdzZH?=
 =?utf-8?B?bXpyeE8yNmtCMDk3TXduZVFKck1NZDdOazh2d3FIcHlaMUdDaG9UWkMxODlh?=
 =?utf-8?B?REVadS9vMU94bVpVOTRpdmNiODNpT2pZdWRNRGNST3JXRncwRHkrWDl6YkRn?=
 =?utf-8?B?eHREcFBiUmY5WUc1bTJURVgyNENWTVdZRWlzR0EyNVpYU0lES2dBc2k5TTNy?=
 =?utf-8?B?akp1RStteWp0Z0RNOE9KM3k4eS9VQXM2SVdFRkpJa1BNUWM1bmdhbEl2TnY0?=
 =?utf-8?B?NlNnYnBLbXl2V0RmdUJQUkJDNU05RHFmRjZ2SFFOWTJSYXFoNnUwR2p2eTRp?=
 =?utf-8?B?NkU3T0Juc0xtK0tUWE5YZjAyd2t5bFhlcStjaHUxVkdLR0ZBTGJMREpWSGQr?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?djExL0xRV2E2TUsyMnYxdkZHTmFVWmpVU3hpV0RwRldvUHp1c1A3UEVzNzFG?=
 =?utf-8?B?eWFaRmFpc2FZcUtYeFVsT3VlanBLRGRlaExWTTh1RHpUdnpicXZoTVlteXRX?=
 =?utf-8?B?VGZRemxxcHdjOTJ3TWlnUEg4aVVwR21EREUvUEFGS2kzZytSdkUrT1l4OTg5?=
 =?utf-8?B?K0M4aFRmVnVzSkJnbE82dzBrUGgwVDJhb2d4SFFvZFBUZWwrWTNkNXBlUkd5?=
 =?utf-8?B?RDJGN0szbHIvT200MW5xMHBJVEpKWGFiOGRWWXhzVjVOQmYwWnR0L0FyTGQ5?=
 =?utf-8?B?NFBqQTZYblhzMjVDdWtjd3RNbHRsODIrWW5LZkZ6eVkzbDByL3FwOVNzMy9p?=
 =?utf-8?B?RmhBSHVDRU1wZkhNM3E3dU9iVmdLckRaSFM0MlhTVTZiMEQ4L051YVBkZEpj?=
 =?utf-8?B?dFZkdWYwUG5jYlhQODF6ZFVCYjN4M1A4VmVITUJCQzFGZEt5VllUc1l5aEgr?=
 =?utf-8?B?cGN3akQzbTUyeUdCTGQ2bUxMMzBnRkx2NDNmUVd5MG5vbXVSUkNSTm05L1dk?=
 =?utf-8?B?VUFNM0hLdlEzVm9tcEpQWUxOOVJyWXY4VlhJSXozQVBBSWhmT3NWTWsyRWZX?=
 =?utf-8?B?cFVUUzhSTkJJNnFsUjVsSDhNM3UwM3hydVZhZlBjSjlRUVdYb3BGcUF1aFU3?=
 =?utf-8?B?bXpoTEdXWWFSM2VwQXZGdmhDMk5BNytkTy94YnJpajJZZjMzWThVL3NiUkVl?=
 =?utf-8?B?cENWUGV6b0lVbDZ2WExxckp1cmQ3SmNVWEYxTjJFTDNFcTJQbUpXVWRVcW9m?=
 =?utf-8?B?TU8vSFF6NVUxRmErSUZVSitCK24vYUtMZnJGeFFWNnplK0l4TkllMm12SG42?=
 =?utf-8?B?eFZIRkt4d1M3RnVqQVBrQkY3N3E5SGNIaGxXTHZZWWVLdVEvUGFLbHErNTRE?=
 =?utf-8?B?eitvMkk5U3pOci9MM0djQW5mZ1dscG1pTUNuaHI4SnBtWCtLSzZtU21GZkFo?=
 =?utf-8?B?dWRqTTluMEtUeHlHY01ZRnpGWDZCQk9hUnowdkl0UzUzY2VhUWpGc0MyZFcr?=
 =?utf-8?B?d3RJMlFnQk8vaTloeDZWL2Z0aVVydlZXc215WUNhbVJrZXNDL3BQSDRKMEtF?=
 =?utf-8?B?bDBxeHQ2eStzZmFjcG9QelB3VllFRm8xM2JQeG42K1dWTnhVU0dqc3dveFpw?=
 =?utf-8?B?SHMzVUlkdEVHdkdVOWpyUFpkT3I2R0JGOGwzNEZHaUlvR1BjODh4NncvSUNh?=
 =?utf-8?B?ejNRbUJXTHFqT2FrbFJ1d0tRLzhONUdyLzdQQVFiS1hhbnBGZzlXbVdRZWdq?=
 =?utf-8?B?UGM0dUhCNktqQWNZR0tiRExtdFYwdVNoaGVhd3p0bWcxM203b1ZLZXFyOFd1?=
 =?utf-8?B?QmRtOWc3VUtVS09YU25IU2tQV3U4R2ZwMmRzcktTcDV5UE5sS3VmbjZxR2JZ?=
 =?utf-8?B?ZkpiekdFY0FXT1ZhemlEQW1IbTNUdXVPQUdaem1xaHMvSnlIRWVxSGVoYmhK?=
 =?utf-8?Q?dylBsBMu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9be0562-16af-4525-f07e-08dbcff2acb5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 15:55:39.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juY92gucRYNoodMBvBlxFegorjI45+h0+KwRh+BbkUc0+TZDhoTTyNgaFk4ERQf1CKgs5OIz7KldS3zPfLLVnnFirmkMXxhvD6GAU9fkas8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_14,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=769 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180129
X-Proofpoint-GUID: u5jNA3YgkeLhyf887ttOPZyb-l46OdNQ
X-Proofpoint-ORIG-GUID: u5jNA3YgkeLhyf887ttOPZyb-l46OdNQ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 16:52, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 02:33:09PM +0530, Vasant Hegde wrote:
> 
>> IIUC this can be an independent patch and doesn't have strict dependency on this
>> series itself. May be you can rebase it on top of iommu/next and post it separately?
> 
> No, we can't merge it that way. If this is required the AMD parts have
> to wait for rc1
I've removed this specific patch from the series, and was aiming to post to -rc1
when the dependent parts are settled.

It really it just printing 6 letters on the kernel log. It's a tiny thing
really, and the rest of the series does not depend this at all.

	Joao
