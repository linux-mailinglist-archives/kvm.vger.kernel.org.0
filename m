Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776657CC5CD
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344085AbjJQOT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344080AbjJQOTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:19:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF01F7
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:19:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEDxvd024394;
        Tue, 17 Oct 2023 14:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3MSkh8aZBQEISZJ+7IExlXBIi+xQTB8xiamyds/H4Fw=;
 b=Z+m+KE8AWV1CUSc8anLDbstzzL2F82KItc7MPuHP3yrunBwLju5fcUOeVATJ8hTZeY2N
 8ej/jp9HFZSk/jXAOr2Cg0KYOfRIoRIouq0xhBc4KR1Q0QupCE3klnzHRdIwBG0zOdg4
 WT/lxXakgf+9zaXAO1cNPuPwZYcMk2fVMaclHilYR8vVHYZNrPVuaWhbr91KKhrb9pPK
 vAn2Q3qzkPCOUe5v8prc7pwINKSyfkLu7S8f03eiwucnxBrcNWx5bIt7LKhIcYhbJ4MR
 4i/oJO6Bk7kJ1zrnO/xDWWvHc8QtQUXPoQFoC/ULe9ZgyIpB1fAOoZsJ1v/nuZOcSNQa qQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cw8m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:19:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HDu4al021574;
        Tue, 17 Oct 2023 14:19:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg513bsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGxJ+UzlAtoGaEEQ64TGt8OmMkjtEa77Dvg95D1ESz4fD+wnMA7Pw8SurDI6+RdRVwxnUMNgjMB7VlHsFqQE9OQdKBmNbtgImMd//O2laMIMzwfLMWGAhWOKGGfejQoMTg9srJENGf5+pdGVYDEYkdDrQPJFjYZ6FHKE4McwR4OCpvqSH5/ttJXjycvKH+WZ8xyK8FvYUufgILVekSvDiFevMRbomdP57HLDJ5Urdt2xtG2w71t4G0ojIj2gj0e9ectHeHoMxs6i1IBcgI6deKe6hpo1IXJjAIgv4pBjr1y89DPZpt6TPMYI6CGVCdFlfmLg7Xhn8IGp2uK8RFc0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MSkh8aZBQEISZJ+7IExlXBIi+xQTB8xiamyds/H4Fw=;
 b=a6GJr7jCwnX6UAlfuq7Tt3PCSK84pKjDKVSifx9dK1HJ4WQLbvFip3J350zM5x0C7TBBCDgRYh/Oxm2vkzHLxRjmA0gdGGCnAZSUCvRpNsjpWWB0tLhxqu/U4OPUKpc3oWM6lYYH9kH/sb2Uwcf9Qssp63AWFz6FAmxyJ3DWhYs2MthD0s/JDB2bSteFDPMoybzlJ5X1q+htqIkDaA1Z5xaLXhXLysI8uplnEIH0Hz2ra5nWCRToPixD8umuu/VNqxOBWQVg5VIblzNFMCku64a53g0HVjukNhyiH314dv8snS2zUTh8Mzg3uAOmkxh1p83mYdsMSVGZx+B4/L6TpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MSkh8aZBQEISZJ+7IExlXBIi+xQTB8xiamyds/H4Fw=;
 b=mArZi7pyhtFTeaXtVVSwkKJ5NGAa6ppfrmthvtE1xRH/oGaCXoFAoZrid3dW6rPNHjCJKYl1mtBHLJJT2MhdJN/yXCRZpvr28IvwhsJOYbaRuIdgLp0HwOZUmjjEa5A8Wp/ys42OzOdOtlXI6bKs3XMGN3ONGRwyCzA2eGjVpzI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Tue, 17 Oct
 2023 14:19:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:19:18 +0000
Message-ID: <a48bd3d1-f4ee-4825-81dc-398549aa2cb2@oracle.com>
Date:   Tue, 17 Oct 2023 15:19:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
 <4b5cd75a-c0cd-c9bd-0d08-8c889861d48f@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <4b5cd75a-c0cd-c9bd-0d08-8c889861d48f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cdb07d0-69b2-446d-79fe-08dbcf1c0c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIo0oy0Ckv9BKG/p9LAsYpzQgoOtHnwwkbjj37jivXy70VDKuFNABXkRaRzFzcZ0O+CWgdyvnv4ogxo8LRaVoeISWVZO12uyQnnEdChkCri0Y+W5yMp6G9ILTcqhd7qZdLhE63qN5g52xA7QYZaww+IifpY2+r/xrGSPsheG7Y13Q6UoesZYVwMIvri6TxAzha48LxkFtuVjF7a/w+5bKRg9U8aN1TOhhzRGZCZSV6vu9NTem70O9mvJ2D1HMLME/QA8W7W5E2tLFG6YO7TSdEg7I5RlrbFGnpUE2weA7pwx1+VK9VUR7xhhGW6h4sO3eV6lDLJ8JLM5gziS123vSX3bGkA8m02GKMBudnD6JBEKttoUQPdc5K2zSxWVhTSfbuNAwmfOWIcgKSkBWEhsSuPf33649vXC+0Cxi/mgwpBt96jGBCVXbnB+pVrpWihSYKciRlE++/XbTqx2hA4jDk8c7xMueY+3Tf7PviPHpDGZmw2ysl+RV5W3GdoUnEdPHG2yXwPYYIDaIDk+r1pDWjEbA+wyuoQhM9y23nb5nC0jDaSA5YcvV43roiVgr9f1GL4qEu6z2WxrTnjqRAsjUWaEnF4It/LuTYx1S8pfVTe9/XpuxZUrflhccCbiPkezjaxsx//W6qtX1/Lsa1Fuqdn99jzBsZU2rjWxn0UM+A0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6506007)(26005)(66556008)(36756003)(66476007)(66946007)(54906003)(83380400001)(316002)(53546011)(86362001)(2616005)(38100700002)(31686004)(6512007)(31696002)(6486002)(2906002)(6666004)(7416002)(478600001)(5660300002)(8936002)(4326008)(8676002)(41300700001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1loOUxGMjQ5TDlCdURka0NhMEt1WlpVbkt4Z0tWQk5HVkdEMjBldTlVaFVK?=
 =?utf-8?B?NUhHakF2OW1mMkx3Z1ZOUnU4eDc1TkNMeks4akdwLy9SbGFNNFhJY1hDczZG?=
 =?utf-8?B?R0xTNURzSXBWQmFWYi9hK01XVUpxdFVoaW9qdmdBMGhnTHVOaUkyMkNtMVVT?=
 =?utf-8?B?Qm05UHJNc0locmRZblVEbVBBUlgyRkl5enBMcXhQNThBeGZaOUFzQU00cmNH?=
 =?utf-8?B?V2RSeXNKL2ZwYkUraEFxVlJ1UHRRSDg4bzdWUWs3TDZxdjNrd0JRUWJsdjNu?=
 =?utf-8?B?SWdMNUFBbTdOZzNyUWtLd3ZqMHlyYVZra1FlQmF3OElESktrWWdDNlg4YzhO?=
 =?utf-8?B?UEhXNTdBNEVlRHNKb1VMTFpHTTR5cHFDM3NUbFlrOXlEUWJNNVJiNlBFVHJh?=
 =?utf-8?B?aDhoekQrSThwY0xrYTg1cGt4aTg5R3RSV2RORkJGeDF2M3VSRmpJY0c0UzJU?=
 =?utf-8?B?NVQrSEZaZWMxV016OUVzbXF4bkxSU2Q5dCtubmhTMFpMWG9XVzVlNHV4S1V5?=
 =?utf-8?B?VWVjRWo3cC9WeEhqUXJ0c0hEZ0tXb3JRdEdCME9xWjk0dmcrZjRuZmlGSy9I?=
 =?utf-8?B?MnV0MEZSK2dxYUg4NDRqRjh6K1pPTkdLaFJLRXBZT1AwRy9lMWZ3YVZ4WDUx?=
 =?utf-8?B?NUdvUE15L3FpMFQ3REZXdFFMaVBCKzN5NitTSUxiZWN0THRiQlplSWsvWFBi?=
 =?utf-8?B?UWhOVHYwZE55a3hBeUlPenJyZ2RibjNnN2lhMVZ6VzVxRnJlc0RtZjhiWTcz?=
 =?utf-8?B?VWRLU2Z6MkdWcVRlTmxzUklzakFvSjJ2RnFXMTA1OEt4Z3RtWUR3aUs2cFpI?=
 =?utf-8?B?NlJNY01CS214VjVWS1lpM3NpVElxN05FU2ZpTXBNbUlHZTVvbm94c24zM2E3?=
 =?utf-8?B?SnZpUTU4bkYySnpJSGZKdllSaHFBMVBoT2txTWpFL3FOc1puMHBaSk52bjlF?=
 =?utf-8?B?VlFla3BWMU01UTEwWmxwWnhaZXBQbFBJeVIxakVRT2oyOTVkK0prekM3azVx?=
 =?utf-8?B?NUNRWENDUzN5WmwxdWtXOHhZNGZQQ0N6bnQvL24xZjBBbHEwemwzdGpkelNP?=
 =?utf-8?B?eFI2MEtPbW9aK2VSUG9qNWswZ3Z2emkwZHBuTGxrditjY2czZHlkcU52Q2d6?=
 =?utf-8?B?NElFRCs4SkN1ajN2SFhxVGhwWGRGbnpNUFRFRVNIczZJS1IrRHFJVmJvT1Ez?=
 =?utf-8?B?c3U5aGd6V1l3VEl3d29MSnhENXZzSzhLWVNjVmhtL2NGUVNEZDRQS2RQajQ3?=
 =?utf-8?B?WmlaajNGamNaUnhNZWpkMEdpaXNhaE9ZeUNyK1RnbzRMZStPa1JVZENYd0FL?=
 =?utf-8?B?QnNtdFZnMHd6NVFwR1p3Si8zY0VkSUhTcUVBcjd5cEpxcGs5NmJmdU81aXNQ?=
 =?utf-8?B?NlVBbnZOR2FnYnR3M0F6eitBL3lCUlZhNjJmY091QVhxYVVVUkxsclc0STZH?=
 =?utf-8?B?bmFETGlQWG9abEVvRW9pUXRVUUxFT1FHdVZ2bE92ZkhZUFZhMWZNdkliaVR0?=
 =?utf-8?B?SXAwbmJPVFhLZzlrV3lpTC9WWkVqbHdDZHo1aHE5dlNFUVpxRUFDb2o5RnRa?=
 =?utf-8?B?UGp4M3g0TDQzRDJEdWNLZmxVRHhYNUFNdUdrcmk4aStIM2JCYlhQQi9rSEdo?=
 =?utf-8?B?eGlCcjhNUm9tK0xuTnNGUm1IU0J0WTJzV3RiWHdYQTdBUUtLSVQ3ekREMnA1?=
 =?utf-8?B?eUVXZXNVTzRZZnUyTG9iV2tESG5pVVNPb0NpRVB0MDhZOVJHbVhYNVZpUnZO?=
 =?utf-8?B?Szl4Z0NUWHF4cjVSOFFqUmZvMitpeHpmSisxNjd3M3pVWUFXSVZRaGZmNkVm?=
 =?utf-8?B?bWFVUW9aRkFXaVN2ZTJyNEY2dkdITjVGNnZrM0EreXhYT1o4K0YxaCtTL0R4?=
 =?utf-8?B?M1JTVkpsMGhUNTBhNmlZWmR1UDNJYkx3NEE0a0VvS2pJOEtNTVlWVHR6d1Vj?=
 =?utf-8?B?cnhSc3pSRkkrSzMyWGdFWm1QOEprak9zRGV4MjN3ZmM1WEVBSHRyTldPTmc4?=
 =?utf-8?B?NGhJMWdWQUNyNXhSWjBaRnc4L2JPWEF5ZTlHc2ZFZHloblJXUkV5TmlEREtP?=
 =?utf-8?B?U3FmZlllWGlHRWpKNnZObjUyM2hvcU5ZbEJON2EvcXVET1Q5bm81anlrcHFJ?=
 =?utf-8?B?dFp4RjZGT0RvUGk4c005elN5WDIrNS9zY0haNVR5VzV5OEpjR3A3RDg2UkFk?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MjNSZ0ZHMnJvUktLQ3BSUVZWSGVzdWM1SjlpUS8wejJtKy9zT2kveXkwWkpD?=
 =?utf-8?B?WlRHb1oxTHhCL1UreTNKZFZleE5Sa05uMFRIOGxRT2FYVTVqKzFORDQ3RnZu?=
 =?utf-8?B?YnBrUi9DZm9wV1JOMHlHYnhZTGIzOEpBdWc0Q1ZiK2JtVkNrbjJrdGs0NW9s?=
 =?utf-8?B?ZG93TjFCR01SK1dlUHVRbVBncDZwUm5tREszK1RuT3RPTmdrejNuUE9wTjAr?=
 =?utf-8?B?K2s0M0VpN0ZyOGZsZkpLSVdWWDJRR3NjczNDQy9wVWNnL1R6K0ZuMFFYV1ND?=
 =?utf-8?B?WHNxbmhkbklDNkJhRUNSNDlRYWVnL1dHamdhOUE0MHZ5QmpNeE95S1o3QTZj?=
 =?utf-8?B?RFk1NHByZlk4MnhnOUhiR0NtNUFVanZDMzRmZzBIZHFnZGFZQzYyZVNZa3Z5?=
 =?utf-8?B?c1FnWGhGa3RibXVaMU1NeTdmbUlLMlFWZjJNL09kdHREM0lpVnRFMjRoS3BG?=
 =?utf-8?B?SEVVVUllV25sZkhRV0xBUWF3a3lKZ0ZzOWpkVkpPRkdPUjhVaG83MG1abmM2?=
 =?utf-8?B?QjZsZVRaUXkrRGtWT3BjTDJlMFhMZkw3azNFTGQxMVN0RDNTYTNzZlozMmgw?=
 =?utf-8?B?NXJuQnJuRDNjdUNBaWgrUm1PYnB6WUZiV2xVYStaRWJCdVEzanY1MWVkQkRt?=
 =?utf-8?B?TDJuTjQrQ3NYb3BhZzZhRzRiYXNNUGFUS08wR2dyNnp5b2UyanRxbUsxYkxR?=
 =?utf-8?B?OTJmQ1JZZEFhWFQ1QnI1dGtFdHJ3c0Y4b1ViTWQ1cGFkQlpOcmE0U0tvN3dq?=
 =?utf-8?B?RUxCNS84V0VtRHJzb2s4TExadlpWNDdVczFXbTRqV0poN1pkTldnaFVyUGFJ?=
 =?utf-8?B?QzZHZUVqYjZ0dDBIUzFaV3UzSGMxUTBtYzczOUhGNllMSzQzcUl4bFgvaXNJ?=
 =?utf-8?B?SmtsVjhFTnJBUGRkRGV1NmhteDYyM1lzSndLYXB3MUhDeWtWTkxwWnNoWTQz?=
 =?utf-8?B?Zlk5blpLeVFRRDFHdWdpSW1MZkxrTzNrUm9UK2YySkZmU0k0eFJheFQ0bkU1?=
 =?utf-8?B?RHJZOHRuVndURm96Ykxnc3ZQbnZndXFrQmdmdnU2Vy9mU0s0R2wyUmdJTlF1?=
 =?utf-8?B?Z1RpZGRUZ055TmlqYjVFcEVybG9peXJPeVM0ZVV0TmNPQnRIV1lScUtUb1Fi?=
 =?utf-8?B?cEovUzFNb1pzTHQ5OXphY1UwNDFPcVluZ0NLU0dCeXdUV2UyejV2dVlOdzE1?=
 =?utf-8?B?RWg2NThpZUY1bWNVK1QvOFZ4Yklvb0pqRDNGNm02YWZRMjN4UCtVVGpsZE01?=
 =?utf-8?B?VzljRFMzVFRzaXhYWE5KdmJlK2pWUnVIbS8za0hoR0kxMTB2OHRDcXpDM3ZQ?=
 =?utf-8?B?a3l1akp3QnFaQmdwV3hrb3FPbzJqdDdBeVBmb1JxaHltUUdqS25vaTBqRTAr?=
 =?utf-8?B?cWRteFhPZUwvM282dStseWFmY2FlSldKZ1JSaVJvOVhGRkpaTEdnZHVrMEo4?=
 =?utf-8?Q?5x+RHV/v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cdb07d0-69b2-446d-79fe-08dbcf1c0c74
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:19:18.0019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nz4ke6gjbJvYRZUTsoRZqbYVUEn96UJ8NrxQJWfrlckBL2g2V6lX/TexDrkdoMr9y58XyYXBHlt/HH7wfd/Qco1QVOkytgVAFh1GdcFmTas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170121
X-Proofpoint-GUID: 4h2s8mMfS-3q6XH1_7bbMj_iBlROGYLp
X-Proofpoint-ORIG-GUID: 4h2s8mMfS-3q6XH1_7bbMj_iBlROGYLp
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/10/2023 13:49, Baolu Lu wrote:
> On 2023/10/17 19:22, Joao Martins wrote:
>> On 17/10/2023 03:08, Baolu Lu wrote:
>>> On 10/17/23 12:00 AM, Joao Martins wrote:
>>>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>>>>> need to understand it and check its member anyway.
>>>>>>
>>>>> (...) The iommu driver has no need to understand it.
>>>>> iommu_dirty_bitmap_record()
>>>>> already makes those checks in case there's no iova_bitmap to set bits to.
>>>>>
>>>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
>>>> essentially not record anything in the iova bitmap and just clear the dirty
>>>> bits
>>>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
>>>> internally only when starting dirty tracking, and thus to ensure that we
>>>> cleanup
>>>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
>>>> opposed to inheriting dirties from the past.
>>>
>>> It's okay since it serves a functional purpose. Can you please add some
>>> comments around the code to explain the rationale.
>>>
>>
>> I added this comment below:
>>
>> +       /*
>> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
>> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>> +        * have occured when we stopped dirty tracking. This ensures that we
>> +        * never inherit dirtied bits from a previous cycle.
>> +        */
>>
> 
> Yes. It's clear. Thank you!
> 
>> Also fixed an issue where I could theoretically clear the bit with
>> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
>> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:
>>
>> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>>          return (pte->val & 3) != 0;
>>   }
>>
>> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
>> +                                                  unsigned long flags)
>> +{
>> +       if (flags & IOMMU_DIRTY_NO_CLEAR)
>> +               return (pte->val & DMA_SL_PTE_DIRTY) != 0;
>> +
>> +       return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
>> +                                 (unsigned long *)&pte->val);
>> +}
>> +
> 
> Yes. Sure.
> 
>> Anyhow, see below the full diff compared to this patch. Some things are in tree
>> that is different to submitted from this patch.
> 
> [...]
> 
>> @@ -4113,7 +4123,7 @@ static void intel_iommu_domain_free(struct iommu_domain
>> *domain)
>>   }
>>
>>   static int prepare_domain_attach_device(struct iommu_domain *domain,
>> -                    struct device *dev)
>> +                    struct device *dev, ioasid_t pasid)
> 
> How about blocking pasid attaching in intel_iommu_set_dev_pasid().
> 
OK

>>   {
>>       struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>>       struct intel_iommu *iommu;
>> @@ -4126,7 +4136,8 @@ static int prepare_domain_attach_device(struct
>> iommu_domain *domain,
>>       if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>>           return -EINVAL;
>>
>> -    if (domain->dirty_ops && !intel_iommu_slads_supported(iommu))
>> +    if (domain->dirty_ops &&
>> +        (!slads_supported(iommu) || pasid != IOMMU_NO_PASID))
>>           return -EINVAL;
>>
>>       /* check if this iommu agaw is sufficient for max mapped address */
> 
> [...]
> 
>>
>> @@ -4886,14 +4897,16 @@ static int intel_iommu_read_and_clear_dirty(struct
>> iommu_domain *domain,
>>       unsigned long pgsize;
>>       bool ad_enabled;
>>
>> -    spin_lock(&dmar_domain->lock);
>> +    /*
>> +     * IOMMUFD core calls into a dirty tracking disabled domain without an
>> +     * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>> +     * have occured when we stopped dirty tracking. This ensures that we
>> +     * never inherit dirtied bits from a previous cycle.
>> +     */
>>       ad_enabled = dmar_domain->dirty_tracking;
>> -    spin_unlock(&dmar_domain->lock);
>> -
>>       if (!ad_enabled && dirty->bitmap)
> 
> How about
>     if (!dmar_domain->dirty_tracking && dirty->bitmap)
>         return -EINVAL;
> ?
> 
OK

>>           return -EINVAL;
>>
>> -    rcu_read_lock();
>>       do {
>>           struct dma_pte *pte;
>>           int lvl = 0;
>> @@ -4906,14 +4919,10 @@ static int intel_iommu_read_and_clear_dirty(struct
>> iommu_domain *domain,
>>               continue;
>>           }
>>
>> -        /* It is writable, set the bitmap */
>> -        if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
>> -                dma_sl_pte_dirty(pte)) ||
>> -            dma_sl_pte_test_and_clear_dirty(pte))
>> +        if (dma_sl_pte_test_and_clear_dirty(pte, flags))
>>               iommu_dirty_bitmap_record(dirty, iova, pgsize);
>>           iova += pgsize;
>>       } while (iova < end);
>> -    rcu_read_unlock();
>>
>>       return 0;
>>   }
>> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
>> index bccd44db3316..0b390d9e669b 100644
>> --- a/drivers/iommu/intel/iommu.h
>> +++ b/drivers/iommu/intel/iommu.h
>> @@ -542,6 +542,9 @@ enum {
>>   #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
>>   #define pasid_supported(iommu)    (sm_supported(iommu) &&            \
>>                    ecap_pasid((iommu)->ecap))
>> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
>> +                                ecap_slads((iommu)->ecap))
>> +
>>
>>   struct pasid_entry;
>>   struct pasid_state_entry;
>> @@ -785,13 +788,12 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>>       return (pte->val & 3) != 0;
>>   }
>>
>> -static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
>> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
>> +                           unsigned long flags)
>>   {
>> -    return (pte->val & DMA_SL_PTE_DIRTY) != 0;
>> -}
>> +    if (flags & IOMMU_DIRTY_NO_CLEAR)
>> +        return (pte->val & DMA_SL_PTE_DIRTY) != 0;
>>
>> -static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
>> -{
>>       return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
>>                     (unsigned long *)&pte->val);
>>   }
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 03814942d59c..785384a59d55 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -686,15 +686,29 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu
>> *iommu,
>>
>>       spin_lock(&iommu->lock);
>>
>> -    did = domain_id_iommu(domain, iommu);
>>       pte = intel_pasid_get_entry(dev, pasid);
>>       if (!pte) {
>>           spin_unlock(&iommu->lock);
>> -        dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
>> +        dev_err_ratelimited(dev,
>> +                    "Failed to get pasid entry of PASID %d\n",
>> +                    pasid);
>>           return -ENODEV;
>>       }
>>
>> +    did = domain_id_iommu(domain, iommu);
>>       pgtt = pasid_pte_get_pgtt(pte);
>> +    if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err_ratelimited(dev,
>> +                    "Dirty tracking not supported on translation type %d\n",
>> +                    pgtt);
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (pasid_get_ssade(pte) == enabled) {
>> +        spin_unlock(&iommu->lock);
>> +        return 0;
>> +    }
>>
>>       if (enabled)
>>           pasid_set_ssade(pte);
>> @@ -702,6 +716,9 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu
>> *iommu,
>>           pasid_clear_ssade(pte);
>>       spin_unlock(&iommu->lock);
>>
>> +    if (!ecap_coherent(iommu->ecap))
>> +        clflush_cache_range(pte, sizeof(*pte));
>> +
>>       /*
>>        * From VT-d spec table 25 "Guidance to Software for Invalidations":
>>        *
>> @@ -720,8 +737,6 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu
>> *iommu,
>>
>>       if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
>>           iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
>> -    else
>> -        qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
>>
>>       /* Device IOTLB doesn't need to be flushed in caching mode. */
>>       if (!cap_caching_mode(iommu->cap))
> 
> Others look good to me. Thanks a lot.
> 

	Joao
