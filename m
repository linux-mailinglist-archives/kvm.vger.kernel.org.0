Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C80B7B860A
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbjJDRCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbjJDRCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 13:02:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD69B
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 10:02:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ02n026772;
        Wed, 4 Oct 2023 17:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=U+Qlgx6Eh5LptmkEw4fbD9MXU/g1Zp9udt88KShef3s=;
 b=22atwx/oapgaDnP5N+4NBtAIxiyNkWCkHIrrblr2ZoN7ZjT65E3q/C8b/Yp9uA+F92cD
 QEuWfQdmwp0iE6DfNzWpDd9fmgiMNxCnoK4PSTLjbiragl4O61la1RfK9r6LC3Cuv2pr
 EzWp3jffu6yORxFsrydWMyojF5ly/QoGU5wINAel9XQtf05BN/a0N5JpVlaIgT1bdD8R
 ox7fs885LJ7yPl6GsgJco0o2lZf3UAibENFJp0qZEEoOZHKETrzDsGO1e51k74fs07n5
 ewlA90Ld/30Jk5UV8YNN9oKbaEFXWWP87d6GszAwKT8zYbBK7j37rwEUNvJ6cr4ZpTh3 Ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea3efkke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 17:01:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394GXRjT005824;
        Wed, 4 Oct 2023 17:01:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea47w6ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 17:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDAyRr3EFccihyjPehF/Qf7yTQ7gXTfoBtzj6gtv5riY0eGt8X7ptuijdoV+UO/VgofxoVZfZxiMEL5C18BRdLyi+ziJZkrIomFRDG+ekjvFeorFNI//kmPQcTw8V4sswreiSpLDX1sGJcVorubI1Cb+KMCgfxzqRCe+cap+v5svZZ8wcp62jeysElqghZpKTFmIVO9DppEFERXAIsdrqShIbGPDGuMNgzbico5lKenkqz83W9VZg8T5w+LSQq/MbY4/NcPVM1evYTkuAJ7b9cI+J0Z+r/ZhcjaCkqZxtPD+L2rx/CQvObCKCdP4uti33J6ARRDvxlesOKO2Y7o4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+Qlgx6Eh5LptmkEw4fbD9MXU/g1Zp9udt88KShef3s=;
 b=jGfGPuw6uyqFMAT1LRK7yHix4tH9NXRCe53b3mLExL8ElBrPX2ACKHECIqFWbGRdTp1iIfo1AeDAHxa1yS2lYOu0o05xPQW418vKu5cHjPFPQdjAZQZxkD2fCfmW3B1eoghoKUYhWfc8prMq/u3QZmScarK6bFkaBR6d6yOxpBhHkjwvq0uwPqPdwZ+++PWdBCoYLGHVwpfaBIh1VAJU00c0Nthv0WP4o7FLfQaVxATx9auS18j4IGEhUmMLr2kaGX5adwjAyCXv+7JrKXhORvghXm05g3k+7WqHzQCQtwp1fe7Wu68+qRnkpLjJy9U7Rvj35azeT59a3fniZ8lzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+Qlgx6Eh5LptmkEw4fbD9MXU/g1Zp9udt88KShef3s=;
 b=Uyyln+XLQ+Hm2fxSubd81VUZRinoDBKcYK4zxKrU1aGmdC+fjEFV72EQURPT2qaFo1pt6worow4SPnj88OZ67QB68x3nmNwSxSE5YIdHe0tbmNsGxL/Tof2n2eHsoXCCzZjYoDMmfiscPGBiYGqA2/YcqzKCySZoHLpmeN1Ex14=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM4PR10MB6718.namprd10.prod.outlook.com (2603:10b6:8:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.28; Wed, 4 Oct
 2023 17:01:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6838.033; Wed, 4 Oct 2023
 17:01:12 +0000
Message-ID: <3008fd62-7665-462f-9e21-91b53b7000e8@oracle.com>
Date:   Wed, 4 Oct 2023 18:01:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20230923012511.10379-18-joao.m.martins@oracle.com>
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-18-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0082.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM4PR10MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 246cf1c2-b5f2-4c72-1e78-08dbc4fb8360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F9qBB4pfLN1gDZ6AovahXMA1PWFh+Q9HOmEBOkj1Q4uCyltNkoYmWnYxxolk/xzwlhzsuhXFpSSSu+FOEtrA3KDQN6eNPttJXew7RD/PT+YzjvD0VMrBgzw1DMSgE7LJDHOWm3FQRdICTLVXeaf6xJz3aBMxh20UvldGtcX+M3bwsYbuK+md2OEarPPoK+ESR9fHzFKuZ7CZ1XLhHyVAWTWrDrHzM7/BmgxRcDXGO3Zru0uXclfW8ye/ki0JEQdOsD8GF37Hm77mRUP6dp1ewtwtqVYeMEvwx+zWlIVJCNKPtACIo02+8inuLydunYJrKo027zUHNInhtHew+QIdqYSjIgdT5ctfky0a2LzFpGP5B9UiyEyBHucuY7TEd5laOmpj3qAGoJ55SpVavQVOvQG/jPjkNlJswoLz5+KKNepcn8BGSC4+pyvecWfYPrk58+wbGEdRXHqCpNJfR5MZkmFz1AI4qocsG6izr9IZTOQMzlRdWTw92D3p8ttaE3ntxUpI+0cT5f06PtTVBxMmKmiQyyOIW1tpQKFT8UA/aU0ltcw5zIs7OJAbY1/Z7H/jcu/dwwCEWZVIAmrvKg2nW359P6+WpNo8kvlZaosfkNg4b5amScAEITfJ75LDGBW3dNesXjE73zEcWrDalfFr/RXHvLzFho1XX8kx1AY5JxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(366004)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6486002)(53546011)(478600001)(6506007)(6512007)(26005)(2616005)(316002)(6916009)(2906002)(4326008)(66556008)(54906003)(5660300002)(41300700001)(8936002)(7416002)(66476007)(66946007)(36756003)(83380400001)(8676002)(31696002)(86362001)(38100700002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDBaV0dZdkpENm5GRVlPc1Rjc0xYUzRuVmdlU00vNkh4dmJoK0NnOGFDNTJY?=
 =?utf-8?B?ZzB0eXp6UXRVVlVwQ2FKa2lLLzFKMGIxZFh3TEpCSFhrcHBISGpGb2ZhMWtJ?=
 =?utf-8?B?T3dRZ2Rmb1l3bDg3V2VSeHF2Q05WS2s4WVR6c3FpT0xXUnRDRWVPdXNLTk51?=
 =?utf-8?B?UUxHNDBXNmt4UXBQQmxGaW9RSUc0YTY5NlF6T1JzOU5iRU1kUFhFd3JQM1Vw?=
 =?utf-8?B?RlhjNTFZY1dWRlJXMTBKSmxBVHlDTy9QWUdNSE11NkZpeFI1RVZ2R0tTRXNZ?=
 =?utf-8?B?WU1ENW11dno3cmpxZjl4cHBpK3lxKzVZa1BuVUF6SkFhYXN1WmxleVBuM2pY?=
 =?utf-8?B?YnFhbS94bFFVL2t0b2xWZVhIOHRTcUx0aFZBY0RaRExBOTNxQ1FGZUtEY3NN?=
 =?utf-8?B?dFFrZVhQVHBRYUduYzlHZEsrZDY2YXNmcmJUUWt3OHpvV0ErbkpiRDFXRzNG?=
 =?utf-8?B?UUFQc1NlSUVOczVneExSbmh4U2ZBSXF5VUU2UG02bzBFUjMxVGk0TmJodGR5?=
 =?utf-8?B?Um1KM245THJuWGNmRHhZdnFiREtYUUNFTDc2RlFTUkRReUdMbUNOVkhlZmFS?=
 =?utf-8?B?VnQ2T3hVdHdnSlo4THBHYW84RVh4UXhKTmJMbGEyYkRuekJWekd6dTZONWJ0?=
 =?utf-8?B?ejJKdlJlYU1hTXJaK21TSXBSQWdFbDFRcVl3SER6VjN4Q1FYVDlmYVFBQ1NT?=
 =?utf-8?B?VVVVQkZrRzdPN2dtd2NoL2Z1MWJ4N0xRVzBoZ0FoblhhanI2aUpFQnN3bklw?=
 =?utf-8?B?T3ladjVzRll0cmgvYzJiS0RGZW45TW1KNFUvSkpmVnUycExKMUNGbmp6Z0VV?=
 =?utf-8?B?UWFPRGJaaVdZUG1IWkFZcWJWNVN2dTRSbXhMcDN3UjU0c0o0TUNpSDZndkxD?=
 =?utf-8?B?TGFnTFlNNUN4TEpGR3lxWng4T3NjYlhneUtDSGZGUDJtUFphWVpsbHJmdWR6?=
 =?utf-8?B?RDErU2grSGlsUUE0NFIyVHJSR2RwQjhTSW1VaTNyb3dkMjB2ZEsxN0xYc2ZD?=
 =?utf-8?B?cEpBQTR3K1ppajF6NlRNVWpZd1VPNDBON3hIejNHLzkxNElpZHlzdGMyWG96?=
 =?utf-8?B?UWt6dU81UCt3WGtHNHF3N1V4dGtsVVJaUnRvT2NLZW1wcHc4SFBzTHJuSStq?=
 =?utf-8?B?dHUxeFBSVDYzV0ZvbnowMHNoeVdJejVnUWdsOHBubk15TmY4TjJmNlk4OUVN?=
 =?utf-8?B?Z3gvRUplcjJrREZ3Mm5nZzJLd2dsWkxQQWZSUkJqNTc5VVZXWWtkbllhbkR0?=
 =?utf-8?B?Sm9JcnJoRTJoQ3dnNDdCQ2Yzazg0MWcrdlB2ZW0ySVh1K0RCZE9sOGxaZ2Jv?=
 =?utf-8?B?MWxIT05aN2ZPNDVxMnhIeWkyeGhGS2pINUEzMHppVmNqN1E4Mm5mN2l3RnRH?=
 =?utf-8?B?bG42eHg2ZVc4WlAza0xxcXhybjVnb2VhcXFVcTB5ajk4NWJoUFBnMU93VkIz?=
 =?utf-8?B?OGdkckhSY0ZJZUc1WktJdG82RVM3TGk2S20yaGxhYStqTnV1Zm9pZXhoemRw?=
 =?utf-8?B?d0hlTmI2NWRTN0F3V2RwY0ErcmRmN1RSSk5nQ1kwUVVjbTNPbTlBNjMzVHdX?=
 =?utf-8?B?R0dleUJCTnFPRm0zNFloSUFqK2NLMTc3dUlZOVBjcVZuMW5aTGgzQkFwVWQx?=
 =?utf-8?B?OWxrTUtuTGtIOE5leEg5WXNGVVovc0FBZGtXUmRhWm5nbzd6TDZZMmI0R3F2?=
 =?utf-8?B?Q2MzK3dzaS84b2xyNjNORUt4TFlVQjE4RGZsNm1Zb2xTNVRwcXhjOXFJNW1v?=
 =?utf-8?B?TDYxVGRmTERjNHd6WUx5VCs3L2k3UldwVU5JaWZNNnZRVFRjZTBBcDVhc25P?=
 =?utf-8?B?dFdZSEFBWXA2R21TUFlRN1VVZFgwSlI4S3I1TWF5LzIxZmkzZ1lCVWVDZHJP?=
 =?utf-8?B?SDJIVXRzeUplTHg3cndNcWhpSVoyVzEzM1g4clltNzNhU0ZjeHQ0cnl4V2VK?=
 =?utf-8?B?SmJmYjhOU3ROb2dZaUJxd3NVOHd0R25qWkZoMkZDVEVWa3A0eUw4NkdFNUIy?=
 =?utf-8?B?SHllSWhvcjZ1Y3NlbmI3RllPSjdrUTR2QXF4UjRPL1k2eGMvb21uWkNZcEFv?=
 =?utf-8?B?NmhjM3ZxNnB2d25ubHh4RjF6UFQwMmNVTFppeTczYjNpa0c2UEdiRnhPZkFq?=
 =?utf-8?B?RkV0QWVqSmd4MFBiWnZCbGltdFk2a2JxZEQyc0pYU0dKaThRSWNRMGJTZlBF?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SXI4ZTRhTUNVakN5enFmbENsQnFWcGx1UnlnRHQ4TlYxOFV4S05XbjMwcjgy?=
 =?utf-8?B?NUFkVHZGRmhtTmNqcDI0cDFsSUpJTHlUKzlLMXFJVUZBNmxxOExRbVRab29R?=
 =?utf-8?B?Qis5VFpvdW0yZmFqQ251UE5kc0pBN01kbmtBdVR1WWszek53cmo5bVdCNFMw?=
 =?utf-8?B?bTkxQ0FlSE1GdFgxa2NIT2dTSDAwK2M3dzZqN29SUEVUUzJOZzc3V3ZUVGFa?=
 =?utf-8?B?RGg1RVN3R2xMbnByTm1RdGI1RGlYcVU0SXpQWVZybzJUUjRsdG1LcFJqelNk?=
 =?utf-8?B?SlZvcUUxNWtjNTlYeXdvWmdHaEx4TGhkYWEvVUxBenhYOWhDNGhRcXVZKzFj?=
 =?utf-8?B?RHJnWDNkQVRybjVrMCtMYlA0K1FFQ3l0cEFvK0dLd0hhZlZQL0tCektkZkxj?=
 =?utf-8?B?NFpzdlVDWTZkdjJCdi9DS0VJVWZzVEh3NEJ1MzZvWG1HQVhselo3YWlBaWZT?=
 =?utf-8?B?ZThMam5XdlBJS1o0TW16WlFnVEFlYzlEbEhQQ3Qxa2tNbDB3LzIveW5UUmVE?=
 =?utf-8?B?a0UrL3E0WFBQeExUa1I5ZUFmYnRvdjQ0WmVvL09WS0dnZ3VlK3pIcW1UODFu?=
 =?utf-8?B?dnFFdGFXTFZYYkxoZnhuZ2xqTURQOGhjcStRM0tLRnRxZzFGWGJ1THVjSkxD?=
 =?utf-8?B?T2NWakY2c3F1MXRtS0lWUFp4UEtHVHZIcThiUHkxZ1lkaVRnckVVb093a2NS?=
 =?utf-8?B?bXYyQlJyblVhaHFkbFViQWpNZWFRQUdSVVVYUEdDcTNTbUVGRk51aG51OU85?=
 =?utf-8?B?N2M2cUh2OFFhTEt4VUZLOEVhMUFxdS9BTzdWdTNyczR6clpOaHJQdjlmOElq?=
 =?utf-8?B?ajZRUHYwYnRab1I5ZmZtMnNWTUR6eXc0MzF0Z2VlUHZsNklMUERiT3Q1S29R?=
 =?utf-8?B?elhZUE5mN01nRXFZWFNUQVRONjR5WDVWeEJhR3RiOFpFMm5COHh0RXlib053?=
 =?utf-8?B?QXNLRXdHWkozZkUxMzdFaVhXSkEyMzgwUFZ5L2tvNWEvL3BEWjJtd3FtYUhK?=
 =?utf-8?B?WEpHemxuM3A0R3JqNlMvUjFaWE1Fa2s3K2FLZ2ZUK3EzUmpoOWNWUFR0UHIz?=
 =?utf-8?B?V2J5U09mRnJPRGs0cVplYS9xZ252MEU3eVowUHNHQ3F2dFVkNyt1aml0V0dR?=
 =?utf-8?B?L3BRTWRrRmxaRjhVbjFaWUtGcUs3bEdxWHFwNVV2V3Zyd0lJVHdudkRNY3oy?=
 =?utf-8?B?Qk1oVUw4eE1zREQySVRBcHBUbk15aFZRNGgxdmhaOU42YTJXUWl5ckkyeXdD?=
 =?utf-8?B?aTdOclFkMFZkTkE1aWVDYlJic01VNjd5andsNldtSFZLa1EwTWo5dmhPODg3?=
 =?utf-8?B?clJPemZwNzRwZiszOFhQZ0E3Y3FwVVZOSjdDTnhEc3MxMGZ3MS9tVjRGaS9M?=
 =?utf-8?B?dlVCNGJVbDdCV2UrZW1nWWgyTGN6WjFqUitKUy9KNG44THMzOHloaDhxWmZ5?=
 =?utf-8?Q?QaU0+k7K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246cf1c2-b5f2-4c72-1e78-08dbc4fb8360
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 17:01:12.5423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbVO6JfmGYbvl0ly6AjLrx/eniiHQj5H8Q4i8vfchnRvZUpmtWivwHu8Lfwqon2eJxIuRmL+AuGwqmbbkYBG8IGJehKPGeMuzgreQ6PpREI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_08,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040123
X-Proofpoint-ORIG-GUID: sXC0m0XYEDiK8W-HtAGu2eIRT5aI6sLw
X-Proofpoint-GUID: sXC0m0XYEDiK8W-HtAGu2eIRT5aI6sLw
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2023 02:25, Joao Martins wrote:
> +static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +					  unsigned long iova, size_t size,
> +					  unsigned long flags,
> +					  struct iommu_dirty_bitmap *dirty)
> +{
> +	struct protection_domain *pdomain = to_pdomain(domain);
> +	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
> +	unsigned long lflags;
> +	int ret;
> +
> +	if (!ops || !ops->read_and_clear_dirty)
> +		return -EOPNOTSUPP;
> +
> +	spin_lock_irqsave(&pdomain->lock, lflags);
> +	if (!pdomain->dirty_tracking && dirty->bitmap) {
> +		spin_unlock_irqrestore(&pdomain->lock, lflags);
> +		return -EINVAL;
> +	}
> +	spin_unlock_irqrestore(&pdomain->lock, lflags);
> +
> +	rcu_read_lock();
> +	ret = ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +

These rcu_read_{unlock,lock} are spurious given discussion on RFCv2 and is also
removed for v4. I did remove from core code, but not the driver implementations
still had these sprinkled here.

Likewise, for Intel IOMMU implementation as well.

> +
>  static void amd_iommu_get_resv_regions(struct device *dev,
>  				       struct list_head *head)
>  {
> @@ -2500,6 +2593,11 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
>  	return true;
>  }
>  
> +const struct iommu_dirty_ops amd_dirty_ops = {
> +	.set_dirty_tracking = amd_iommu_set_dirty_tracking,
> +	.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
> +};
> +
>  const struct iommu_ops amd_iommu_ops = {
>  	.capable = amd_iommu_capable,
>  	.domain_alloc = amd_iommu_domain_alloc,
