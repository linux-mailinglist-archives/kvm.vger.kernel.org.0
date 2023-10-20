Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154777D0F28
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 13:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377242AbjJTLxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 07:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377267AbjJTLx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 07:53:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BDFD65
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:53:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KAi5ii021111;
        Fri, 20 Oct 2023 11:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2VBMsE6r9ZuAo+DoJ8igJHEkXinF26+KIfC5klCBVZQ=;
 b=gbi08R/w4peHRFUgtgOdxveQFvEiTzoeiqwyKG1PQgXBJnsg7C2KhCcV6crCz0NUKRUO
 kusIWw+6MDbHud24DsdJmzkmbxCT/JjCRK7pm7xJjebsqaDzNkylUu5Ghd3OACDl4lQx
 Ph6YYMVbdHr40M9XZ0XsNKB8WRL5x7AbDSKf9ad3m0jzbL5mcC8nXp94QkaiIhPPN5DQ
 cnTG43mMrvOxdTMxOHbyH/kENn7Rqr9NMOgL2EFSTDtz3GDyZNRKX5BL59Fj/ruK2+IG
 3C0Va2Q6joeRFrxxeVHRwUcHbiBq2lF+VXzpWQUT8MlSioH/5d1bXf2wglHdbxc714pK 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwb9ny7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:52:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KA08fH014914;
        Fri, 20 Oct 2023 11:52:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw5ykj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngV55myJEfgQencxKcbNXgXWHryrQx+2H47ddeAbNkYtN1suhwyGp6RK/kFKUtpfx3NSye9GlNxbgdfWsXQCtFuoXb0F16GvuIGjDdKegmGUosM/Nj7Q26C68C6xz9LAHO1itojwwquxw7MjRxxZg932RU0tqQKBTpKRT0hGjCIPC4bG5cXpR2szfpovzxLIww9ZaH59/D439wkY2iQ3W2Ax8pr3ed/ARXYWAutnlzF8nt69CPfoZc21eObOt+d0xFgPYr1ub/cx+JCV0TSvAibj2JQIvg0oHUy6giB7sdcbOFlIgg9efid0fekG9B4kMI67DuaHGB5ncx7+ZAgSYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VBMsE6r9ZuAo+DoJ8igJHEkXinF26+KIfC5klCBVZQ=;
 b=JLdFCHb+to5ydOjEhNgy/eHn8C4A1S/TjZgjIN3aMp8xyqHLzC45qvCnoozlJ/4j41EjvsotEZL+WqcGRIAJBuf3WnigY0t8vEAK1ICGNu+VaRo1k19fQbNBnsi9dxbqH6qbQGoVPlvT+hpxXOpM8u+w3fHXSM0dcII5WhHVILEg7hQJHaqiGZ8tUmICBGgFS1SM9h3pesm8pLxPmKRrSmvgW5EeDTuYaxY5EtlEBicVk4nqsZtuY2DQD+lOoO/HSIzyi6b10adyrr6cbaHj9Krj+d0ccHOH5u8i+Py693ulkER3oWp/HqjWr12iFJjSuu9JqX3kyDV5cj2V222QZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VBMsE6r9ZuAo+DoJ8igJHEkXinF26+KIfC5klCBVZQ=;
 b=wgNJ/7PD2GJIy+1eSjL++V/B3F6FhWnMVnJsWKL4NWjf+W2iCnZQ31zLFocmgceEzsGYmtEUieUztrgtvj6oLfkdyWO00WQn8fPIMLRsoceFTiS+ZrPCNxX6ZEDuoZgr+WueWtxo3MRVpoTAFUG/4ISnr4fBas3TmWKDr9iRnnQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5350.namprd10.prod.outlook.com (2603:10b6:408:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 11:52:42 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 11:52:42 +0000
Message-ID: <ab00b549-84d8-4529-85bd-1e080f9c7f88@oracle.com>
Date:   Fri, 20 Oct 2023 12:52:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
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
 <20231018202715.69734-9-joao.m.martins@oracle.com>
 <BN9PR11MB52769FC84C9241EF41D064C38CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB52769FC84C9241EF41D064C38CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f03791c-229d-4edb-bbe4-08dbd16310f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmWQLdPYKoWwQyvy+6EA3Y+wdZXeuFOnU0mTA4V3LDYRrg3dnAv+G9PJC9p2AwY3i2Gl2UyJSVvSkcRXvYCEIRxCaWpLoY4kKehrXd1lPKbzluF8TFawEO4++Ke8oLgelzuUL8QmaGUPME3hhOfhhCqVfKA7043ufqcRHT0Z6YguZswLigcLMf+QxtRP6H3gPhDac1N7W9ZqPbYW3A/KfDxe0LK7C/GjXzu36IL/3p+ADCgb/D6/ICqVCDY5OCb3v+eQoZcISY0ierUn68BB9r+jP6ebCYQmgvaLSEb/eQytQs5CksWgpJ45O0M4kjJHP+ix7vCRFaf0ygkk7DDCSZumETYuM0IEB3mpUOTh2OK6vqCu2sx5sgIadzoa9WQ01UmEO7ybkkPnXxb2ZRvhDL4hVTFvuRe9qCOIsUiXxfpPgZqBmIefKvFJ5JSt/cZDZSdtqVs+Amlvg6keVRR/irGA/chzBn47OLFT6guk46lbJnpCyzlCHGesDvKlQbidDYpVHocAkuyTk9PLwswe8CkCEtE3EHLX9RjCF6L1/Xerb0FHMT5isKaP0I0pGzwsDN0xwdedMC1xSRwBdW2DTqNLP9eYT26XCUVP9fYlhKmKL7l/ShV4yLvOLMe0yJXQcbcptlN1WdeKPv6JDb6UvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(136003)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(478600001)(6486002)(31686004)(7416002)(316002)(66556008)(8936002)(66476007)(66946007)(110136005)(54906003)(4326008)(8676002)(5660300002)(6506007)(53546011)(86362001)(38100700002)(31696002)(6512007)(26005)(36756003)(41300700001)(6666004)(4744005)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFh6NktCN2ZOeHNiTzYwWlJFcEhDbVpPa2l0UXJVWkNVMWxoQ2ltbk90RnZN?=
 =?utf-8?B?SHJ3YitsTXdvK0djOGpIbjM1VWo4SFJPRnF0Q2VwL05VKzBlU0N6czFRdmdN?=
 =?utf-8?B?cjI5aCtFTmtWVGxMWmJHeU8yS3hsWXBZNFNOZXBsZ0ZmREJOb2JYZGtFamZy?=
 =?utf-8?B?aEVmNUxsTnZwUWlZbzliekhlbzR2aWRtMTRjeTRDRnZWQmNJeTNuMGcyYTFY?=
 =?utf-8?B?ZnFJMStYMjNFay81blpvZGgvSEQ4cXhuYzhLTjRjWnBwNk4vSytReUFxOWQ3?=
 =?utf-8?B?c2cwdHF1TXFWclB5Q1dQdGdWdGVRQitWWUZ6TkIyZVI1ZXkvZEZ3RGJHUmN0?=
 =?utf-8?B?NmQvdnY3bnMxQkk5U1NDalJlQ3RUMDVrZTh3RXpYamtVRlBZcGdQWXBSa3RZ?=
 =?utf-8?B?bHROUkRaYW1wOFZqQjhidVZkdWJKU3lFRHgyNHdsWWlXYVAwd09EN0pLM1Qy?=
 =?utf-8?B?S3BzR212alNPMmJlR1hNL1Flc3NSQTBsT0JFR3NRVWpwZlFOY0pPZVJLT1R2?=
 =?utf-8?B?WE5nU0lqMlc2RjFPcGFsTU5LTWI4V3dJejlBOU84SDRlaFFFdXBKTUFiMHdi?=
 =?utf-8?B?YVF4b0lzL3c1b054NHgwWTEreHR1cXJLRnZOczhCSERXYVZjY3JPc0h3cGVq?=
 =?utf-8?B?VjJXcVIyaDZyYkx1anVkVGsxaVhjdmhwb3hZb1JGcGIrSGY5bS9GSWt5N3VG?=
 =?utf-8?B?NElOQThFVkdialZ6TGluYm1SNDZhUFBkZHg5bnV0MW1aK2pJTXpLRm1iZWJN?=
 =?utf-8?B?S3BSUEpoNzBiOTkyem5OZmVuSE1VSjdmSFFQUlBzV2pJWnNVMG9SSnZXVTZj?=
 =?utf-8?B?NDFWRkFHeVlHZ0pSZmMvT3ZLT1ZhQnJJUzlUblUxSkswNzdUU1NUZDRHcWRV?=
 =?utf-8?B?WWxrS0x4cTUrS25icXoxNVNhbXZGN0tKVEpkbW9RUHRpL3JvanlOQndUWHow?=
 =?utf-8?B?b1BKSmFXMzRpbkRycXBReE5jSDE4azFpWHdnbGhhLzZkYjBrQ3FqY2FrR3BQ?=
 =?utf-8?B?YzVuYTJpTlRsOFRZTWc3LytsYk9MRnJ5cm1peVU2VkNNUzFacXFhZkQxZDQ5?=
 =?utf-8?B?T01RWVFJRURFODArWGJ2ZnhBUDJibEFYRHlnazNjS0kvVExXVEdjT0I4S1lq?=
 =?utf-8?B?dmZud0VuRnNiTG1jM0E0ZGtvZTBHN21mcVNWcFZuRDdGNC9CTjRENzZaamw4?=
 =?utf-8?B?ajNBekV1Y0dBYlgycXFxaVgwc0h4NkU3UEJYT3ptMEZDYnJ2eGc1ejN4azdI?=
 =?utf-8?B?UUtlejB4SkJEVjhNQVp5bS9aaUFDWjVYR2lPdlZEVHdEN1ZBcVVFUjZ1Mm5K?=
 =?utf-8?B?ekpKL3YzUTZ2S2lPTWdlY0FKb3VZZEhlQUd6YlZpVDFvdW9MVlJTTEZvNmdr?=
 =?utf-8?B?Vy9USmdEV0JSZk8xTXVFTEs1elg1cW53ZDNvRXZ5bEk3cWNtR3ViRGQ5QVp2?=
 =?utf-8?B?ZzRDQW9DcmhydmNnTmZuYzBsVm4xMURzek1VVU1uaWNPYWRVVUZ1VlpBZ0Ri?=
 =?utf-8?B?UFR0RlZjaG5ROGF2T3UwVC9LVkZmeG9MdzVqRVl4T2ZvSGwzTEtNQ3BBMzZN?=
 =?utf-8?B?elJNaXBSdHIyUDJmOHdLZzljNEJVQ1E2MnFiVkhucHBuWjAxWENjRTRaODZi?=
 =?utf-8?B?YnNOYmU2WHgyWGozVDhnZjJqVDQ1ZFBLQTc2eWlRcjVNUzg0RWR3NnZoT0RM?=
 =?utf-8?B?L29pMjhERUV5eGFXZEQ5dEZHYmFqWDZJVVdLb2RkMGlTL0xDbi82b3Vmby9w?=
 =?utf-8?B?ZC9KVXFMS2k2S21ZamoxK1FhRkcrdWMwMFFrV0t0cEE4Myt6ZDY0V2VwRW5X?=
 =?utf-8?B?Rm9lQTdlTVQyWUIxdkZYSng0dndjZTNjQmJrK3libGo1c0FLTEN4YlVlT3BH?=
 =?utf-8?B?NTNYOWp2UEdSa1JCcjF3c1BUMVByWSt3UGdVL1R6T3RVNUJXWng5bkN3akF1?=
 =?utf-8?B?dWx6QWRUaXpmNFNMN2lSRndSNHdSVWoxOG5hZFBHTkRCVCs2M2tVMHRCenNw?=
 =?utf-8?B?aTlnenFmY1MvUHkvNWp1SmlNRlhoNklIWGFla0NBMnVBUGZSMm9VMHFGR0tl?=
 =?utf-8?B?NkFVenRZS1BuTVVhWDJzZWFQdTRrSUlwWGdYUGpWN0tXRFluVFl5QkRhb3Uv?=
 =?utf-8?B?dEdsMVgwWDY2WU45T1c3aHZ6OXlGcFZJVURsNnM3aW5wYlFaYzR0SUZ5WnBN?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MzcxSDV2TU9DYTl1dFIrYmtYQXFnb0tsbWdPS2VmU2cyZ3FXSW9PY3JEOHhF?=
 =?utf-8?B?ZEphanF3VGlURC9lQVBic1NKRnQvRjY3cllVZEowTm1UZVA3K0JLQWVHQTF5?=
 =?utf-8?B?c1dwd3BaandCaC96czluRzVPbnBNc0tNQXgwYjQvN0Q2cEtoOHpVZGVpdGE4?=
 =?utf-8?B?LzFHU3VxbXB6T2NTM1cxeGZEc09UcG5oeHFyTis4SDhyL1JPSVU2M0tTU3NB?=
 =?utf-8?B?R1BiaGJvY1B3ODJCY2dyQWRscTRFVGFnTGRld1pSVTV1NnNWNXRySEMxVkV6?=
 =?utf-8?B?TDk2VHppMS9xcXo2QTJjYTFZQmdFcGE1M0I0OW56STc2Zm5aeGpFMVZ6blda?=
 =?utf-8?B?Ny9tN21VaXc3Z29lSGVjYUxzVWlMM3pGVENJN0V5YXQvR3dtcjlTSVRvazF3?=
 =?utf-8?B?Tnhqdk1tT3UxRXV4R3l2d1dLRjBZYkRZZks1QWJSU0dsK3lGaWlqL010MmZY?=
 =?utf-8?B?ajhuMWd1a3lQL3RxUGgvaEJPTmFmM0tlNE14RVYrOUF3S2VVK1AyTEVyaG45?=
 =?utf-8?B?dnZzZGN3d2ZybDQ5aGR3bmlINjQxTXIrUFIyQXN3UkFGWjMxNU5LUkhaYTB4?=
 =?utf-8?B?L2tJUklNTVNnRkxISWZkYVJDbXdNVTYyd3NFV0l4U0pZMGxQaURnM1lIZ1Fi?=
 =?utf-8?B?YVhxTVo5OXhTMUZxaGtDam5oT3ppTXNYZDFVSCtvRk9qVVBTNDErMjA4UE9K?=
 =?utf-8?B?VHhrR1pzM3p2VEo1U2FDWGFWbXN2d0lacmxVU1VCZEVFb3FmSURlTW9KVUZ5?=
 =?utf-8?B?VG9UQ044d1FLQ3I5S1hEUmxHQ2FpVk1QWDA0b21GWUpvQ2ptbFVqeEh5eEZN?=
 =?utf-8?B?bGMvcWtvQ1FZZWoyQWUxVUtuRlRIUCtwaFZ4RmRsbGpQbG1FWGt3T21lMGtn?=
 =?utf-8?B?QUMxRFB1NUN2c002ajBmcURESkNQQWcvMDcyblVkNnVBVDhFTlZwYUF5RGN4?=
 =?utf-8?B?L1ErcmxnMHFwUUQ4WXFiaW1WU1prQmpZSU5UQnZBOUFqdEtzZy94cC9zb29s?=
 =?utf-8?B?S0RCLzFhdDFrOHZablNUTU9FTXFoekd5VFB2Nm5palhTQ0xaU2dHOUtKaEFE?=
 =?utf-8?B?T1IzL3VFWHZlWXh4RWtoMFNjaldIVGo3TkpXYUdmSEE5elEwM1RlemdWTUhQ?=
 =?utf-8?B?cmhwMkU2WEs1Q05uVk5tdmVKK0hRRnNvNFBUaHRhYjNWbmtXZGFlTHNGSzZ6?=
 =?utf-8?B?ZE1SeGVHcEN0Y2VHYnAvMjhuNFJTZnlmQzlYbTBPWmQ3eTFDek1zZmplZlA1?=
 =?utf-8?B?aGg1N1Y0em5UeXhJdDB1cmZibmtPcTNJd0tsV1ZtOVlkTUtxNmsreGxrVjJP?=
 =?utf-8?B?VVl3ZlFRcDNhVTM5WUFCNjkwY2xKUzBiVFNWZXcwVXY0a1RSTE9iVmJsKzBy?=
 =?utf-8?B?b21kMDQ4SCt6OTFjWFVtam5WVW1IcnBhVklwMmV5a2hlZ0pUS092REdHSmhv?=
 =?utf-8?Q?DgDJkNjY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f03791c-229d-4edb-bbe4-08dbd16310f2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 11:52:42.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHJPzeqeZIJdDDi/Sugfe5Jeea4lOG1FtNKATRVb8m8AczJQT0Ik9+rSAT/C8iytKWqcD4DF6ic4JyIfZzq9YZonTms9xNl6RzPwWQ49thY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5350
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200098
X-Proofpoint-GUID: u1jFg7r2ZKF8ulJrk9BCAvKN6taBmf26
X-Proofpoint-ORIG-GUID: u1jFg7r2ZKF8ulJrk9BCAvKN6taBmf26
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/10/2023 07:46, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Thursday, October 19, 2023 4:27 AM
>>
>> +/**
>> + * enum iommufd_hw_info_capabilities
>> + * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty
>> tracking
> 
> @IOMMU_HW_CAP_DIRTY_TRACKING: ...
> 
OK
>>  /**
>>   * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
>>   * @size: sizeof(struct iommu_hw_info)
>> @@ -430,6 +438,8 @@ enum iommu_hw_info_type {
>>   *             the iommu type specific hardware information data
>>   * @out_data_type: Output the iommu hardware info type as defined in the
>> enum
>>   *                 iommu_hw_info_type.
>> + * @out_capabilities: Output the iommu capability info type as defined in
>> the
>> + *                    enum iommu_hw_capabilities.
> 
> "Output the 'generic' iommu capability info ..."
>

Yeap, I 'generic' is important here

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks
