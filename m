Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653BC7CBE95
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 11:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbjJQJJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 05:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbjJQJJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 05:09:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8671AD
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 02:08:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO2k7011029;
        Tue, 17 Oct 2023 09:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BJkjPb5UB9QN5HWgFfmjlLHzBLdW0yI/28GOKkq8Vq4=;
 b=xT/G9l3ppem43NSyH9RghvL+iWsduf6xphWFZbno0oS+WsPGbILNXEAYhNeFMPj86zr6
 bqcUqywN7JVMfELPisUVB1mph4yNNbYCpsH8xS/6H+AyX9BDYkQx2h+jLBsBxHCkKUQR
 WwbkcCkdXonAUlmQCBaKeeEtWOo2jxDIvGUpD7XwvmVUKhEzFpzyIApT18nMtRxGkC/A
 1DbcGzDF/7HzDpzzHv4qDeVhXPoqOBkXSUCfbjdRJZSQkvG4/2Trc+utzhaq2a9qtY8Y
 zQb6BmceKPiNoxHaYCNtcopxgHq1M0WkC0muY6uC0xvy+Q84yN2VYCsqp+B5/UREZqzB QA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynckyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:08:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39H7csJp027187;
        Tue, 17 Oct 2023 09:08:24 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg53jek7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCMGwUuQTU1FgYv0seHYYmssyM9g7WfxWmypZlxIslnp6yAGGa020lv3bS0mqLvs3FHOmwXUBc/FO3l7VMUDAAQIGofQF1uJpyYMUGh4WHxWxmJ5qy9VL+BCBLNEf4PTVwtORr083Gs6LNnF0WF3TYcm4vuFpmnT29e0a0BSA0hyosZBwU7B130jDFToI8oDYt5IpmTSfQPf7LKQyT1Ie21fDC98ystU+fAhIetXCJyPEW2sUsqIEAvWa+csj54yrYU2cQDgqmQ3csu8MKoW0kBwOGPOc6q2B8LBvg0S1dcEZOJnbNetlGQQNaU8gxfusdozt0MFl0pqVT33lpisUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJkjPb5UB9QN5HWgFfmjlLHzBLdW0yI/28GOKkq8Vq4=;
 b=HB8Is1BNKYgJI7FS+cYbZvuPmz2BUCuJIHGUG0RZ/P8eX4tbIWBYOwbNQVYx7bjlu39NdSeKsMGdmQrw/iWLWdxg0ikIgPoTvQyslhUM3s7YuRwaRKqnD3FTygbW4aS8l0mr5iWEjEN0JTddi/3qSNrmonCp9nHKrJsPo4/8PzD/D+llPhKkS9x5EPI+xBjLzH2pP3gaYS2MjRviWm7tXyuCHFRL3fUDVW8NEat8WWEvi2G/awDt1ujbccVucp2MzeVKk0ATxXKh2ORFADkcBqvQcp2Puwbz75FE2A8HPqxcCYSVoMzWb4tHSzFBcZju5HnWjvQwz37TPZoIVTd6uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJkjPb5UB9QN5HWgFfmjlLHzBLdW0yI/28GOKkq8Vq4=;
 b=AlGbyw4TK8F61qI7e8YNwoO2t3u77VYozFiUGKbKSyIRDPb7PXBKchZUNLqD/NDUVO/abbQY4ObyXE+ae22s3+u2aD3M6o275WMU/OdwjpxwYRyEIAx89Th7aCTbHlVQAod+EChCuHESZ40TlLyZC/PcgzJA895Del796tEQvQg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB5723.namprd10.prod.outlook.com (2603:10b6:510:127::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 09:07:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 09:07:54 +0000
Message-ID: <2afa8c24-8873-4329-81aa-ed4f057ef5ee@oracle.com>
Date:   Tue, 17 Oct 2023 10:07:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <8a74396d-9b43-057b-fe88-3f58ec8eeea7@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <8a74396d-9b43-057b-fe88-3f58ec8eeea7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0112.eurprd04.prod.outlook.com
 (2603:10a6:208:55::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: 93f16620-87ba-4955-370f-08dbcef08c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lx5u+hzfJpo34yzi2KcOhaBmt/el4ySLYN6hCNpW4qAksacdwHtMHjQda5ZS1o9J5h7//enGLh02XXHfs7MUZfg6psCnoYV3c8rFX4PqQZp58n2+0IdhjF9jMC233UojlQ8LMVfmNMX3sH/Z8HSrRrpH4ViUhsLfMs+SPigAhRjE/mIgz2GtKTdDXMSVRDVQ80XrXFQ9sMIQmr/mvq/4nBfkw7cDIGgrS+BNYjwVilQiz1vYMREet7CwxGI0wH4Lm+AaB8xaeOpaQqm9tJpHlOjzGIBDF6mGY8AlXm1qhaKgdXmg0V8nqZfV4tEYYyWtO4JbAZTWDhP5mTc7cE8Zrn30r/4i/o4KDWiUUvJ2tlECDnF6CrHkDaVzL76cpbn/lWXD/JUcAzCnqh6V/BniXz3hG4mQUPK6ZaxCB2Zg2INnbhXpa2qv+hxSdu9fnpQqVev7A5nnNAQoINfUk5BW9gOA4vkvGHdoOhBtD7Iq5wFUv47LExNmJUP+yoQgJsvO8FBSfj3Z/L7AQmW36RAw4pPUZndjmimBZ9/QdveOl/4czgVZ5nkTWStq/x6izTnMPmxcHBdyXKQNANFKOHFpn44kxYOmYqWpY9wlAoQ9E0WKeCvQ/bmpB7aKWDEDmS2iXt6B7ew4Cb/UkOxwI4qHp3w4hBciQjX+FvS9pSxfWNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39860400002)(346002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(31686004)(6506007)(53546011)(4326008)(26005)(38100700002)(2616005)(6512007)(4744005)(86362001)(31696002)(2906002)(5660300002)(8936002)(8676002)(36756003)(66946007)(54906003)(41300700001)(316002)(66556008)(66476007)(6486002)(7416002)(478600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ykp2NVpTWXZMaTErb2oyblhUYURZdUJQbFM0UWsrVER6OStDY20xdE41Sm5y?=
 =?utf-8?B?THY2QmxQTTh1akFUejlDbGtkRm9hSUtRdEtyRStIcVNPQzdIU0hlaFJDbURI?=
 =?utf-8?B?YVJiWGhaTGtERy82Q0doMjhyLzRzQnBqR3Bzd0hselVxNHVEaW5SUE1mSFFt?=
 =?utf-8?B?Nk1pc1RoaGFzbGVmTUZCZWRWRHlXTVl1MVNScDhUUjdnNy95NEt5Y2QycjdG?=
 =?utf-8?B?Ky84eVFISjR2WDF6TzIyRWJpN05CN1FjRFZPY1BTakVYck83SEFlK0JPTXB6?=
 =?utf-8?B?dExSVTl6ampNOEwxYlR4TUVTNFJiTkNBYStoc3YyT1Z5Q2drQVF2TzVVQTBE?=
 =?utf-8?B?ZStiL0sxWFUrSWtqYVlxOGtpSWZNZVE1QWZ4bEdIdGVtcFpaUjVKZHFpNHhz?=
 =?utf-8?B?SUY0Vlp6SXEvNXhNY3NBWWdXZFcvZHg5aElWZkZ1NjZqWnR5MjRpR0wxNnc4?=
 =?utf-8?B?ak5HOTgrU2pxSFBlUlR5VUZiQjJiaVRkdkxDSWt3dXAwYy8wME5MYm5NZzBl?=
 =?utf-8?B?V0t2dDN6WnR4eDZ6TmF6aHlvd0JTKzA0R0xneG9mNk00NXdEZGI3ZE9jaG84?=
 =?utf-8?B?U1l4ei9qZ0FJcERBL0Rub01rMHlKQWY3RWRvdlpabXpzVlYyWGU1aW9nbEEz?=
 =?utf-8?B?ZVBta0lJdUNSU3REMnhmOHAyTFVTbmgxSXpEd1BIVk9MSStKUDN3TXVyb3l1?=
 =?utf-8?B?a0NzaFpyaUJvWE5XMWlFeVRtblBUUERrZ08yVVd5Q3ZqcFB0eVBRWkI3Z244?=
 =?utf-8?B?aGVHTi9nZkhhTk1hUWxScWhSSUdlY1AvMG5HNXd2YUVnTDRZZUpvTDJ2cWY3?=
 =?utf-8?B?ZEpDVGVUMnBTMXluRndDY3E0UUltdG1wQ3NaS0lDSUZlVWgyRDdqdCthS1FD?=
 =?utf-8?B?cnpqNWtiVWdHdW5WRXQxc2x3SUpPb1hDejQvTlAyTXdPRno2cWxLSHdBcG1z?=
 =?utf-8?B?c1V1by9KeWZBLzVScmU2WDlvT0RibDBIc2VxU0M3ODd2QUhEVTBqV1d1cS9P?=
 =?utf-8?B?Z1lVeWt2aEFPdGVlRmVTd0hydTQ5NDJpVmlKSnAxY0xBWmtGZDlwZlpxR3BV?=
 =?utf-8?B?bk56QmZ6ZWdoWm41azk0S1gxU2RuNE9Rbmp2eUoyUk0yUTBiN2hXNjg0VWRZ?=
 =?utf-8?B?WGZVenV1SzFnd1dLUHZzT3hkS3hRL1lwUFdCZzRoWkllUENScWQvV01VeFU3?=
 =?utf-8?B?ZFdQSCszTmcwMWM1a2F0YytpbG5QajRIOEhlZ3ptUFB6SXNTakMwbnd6dThO?=
 =?utf-8?B?YUk5L05oNVNyVkJmOWVDM2ZnREpTRVBTVzVmZDJDVFhNZ3NuL25vM1I2TnNF?=
 =?utf-8?B?ZXUrbWpwSHBiZm5DUWpTS0ZqSlpxMjZHVis2L3RUTzFsTUEvekVNc3lrTVNF?=
 =?utf-8?B?ZmIyQlFrUXZraXM3eVpzVzRBMXF6WmxlbEZkQ2x0di9sbStoemdEcXVvcU9S?=
 =?utf-8?B?cnhzYlE4VW53TjN4ZlhTVURYZkpnNmVjcTJ5aXZvVUlacjRzeXZMYXJ0RFdV?=
 =?utf-8?B?djJtSjJVYUNBeVkyM1pQajZWZGpOSm54c3ovSHJxb05SZUlFQytMbE11NUkv?=
 =?utf-8?B?NzBKWk94Z0kzRHdHRnVGbnNCdlJNMXdyU0lJR0tnMElHdGk0K3RWVWtzQ2d3?=
 =?utf-8?B?eVdNRVV1QWVEeEZaVHJQSkhSUlgybU4xUS9TRHh4aDdaNStBcklERmhpWSt4?=
 =?utf-8?B?cm42RE5tRk5JcHMzUWhyeDRtMzBhdGlPVkJZUXJBVTQyeWlEcEVySFF2UjhF?=
 =?utf-8?B?MkhzVHY5WnJ4TXB0b2RsbmErckZ6cmhuOVVVNkliZUY4aHAvOUZ4aGhvYTY5?=
 =?utf-8?B?ODJ3aHVMc1pKVnRncjVudjUxVThJbTY3M08wY1BUL3Z6d0lFcTViRHdNQ1Jp?=
 =?utf-8?B?OEN2NjVZMDlSM0lhSCswK2s0Rm1KUjBWM0JRem1jNVZ4bW9SVG9rOEpXYlIy?=
 =?utf-8?B?aEdFVG5LWDBaMHpVZkhRUnZCT0tEZ1BSMXRlRk40T1p4OVYvWGtKRnFvMW9s?=
 =?utf-8?B?VHVQVlh2bEV0czdHWVFjcE5wYU5sTldEK1RaejIxOVovRUFyQjVXaHBra3B1?=
 =?utf-8?B?V1RUUVByaWwzanhpQ3grU1ljclEvRWFlZkp6bjlrSUZ5ZWpVRFFUZGoybmU5?=
 =?utf-8?B?ekptVENPSmFpWFNjWHNVUllzaW11OStKSzQwSkhYeDlwN0tMS0czblYvajhn?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Nm1yRjFWVUcxYUU1V1Z6aWR4cE5XdE9POGgvSlhJUlVSdzRvL0cvaDJmMUhR?=
 =?utf-8?B?NTJiZXY0N3V2dUtHcnJmU1R5OUlpMFlSd2F2aVEwQUJXQll5ZWRRMEF2WkpC?=
 =?utf-8?B?VVNsem44ZWM2Zk9vNmZjS0hHdXhpbDRyckpOSEg5aW9TSVpXM1FqbzRMTkFH?=
 =?utf-8?B?ZzBZWXRrb1U0MXhCRXNIS0UzalJDSGxNL1ZzelhIZUU1L2Q4ZVcvTUdYbUNa?=
 =?utf-8?B?RmF4aU1qRkhEd09PYWQ3WTU5OTVLQTRxOXRGaVFzY2xKdUZBUU14THI0S0tJ?=
 =?utf-8?B?SzVtNDk1T1hrWVZoM0xoNy80UDE3RFFTODRjTWdRU0xjVkRLYm95clJBRHdh?=
 =?utf-8?B?TFFudzgxeHIrWUpuMkZORTRSMXR1bHFSS2hyM3hEK3NjVDQ1RFBYUCtvSGVj?=
 =?utf-8?B?NTdkV1EvL2hreW1tK0IvVHhVVEh5cUhoUVVBWEZVcEZJNm5ydEV2UDI4bkFX?=
 =?utf-8?B?TTBJcUxZNUJodnNJY1dhdWRDM1hCbkxOc3gyNTBPYWlMbUNWNkd6allGWTNn?=
 =?utf-8?B?Sm04MTlpMG01S2FqMGhxWlQzdFlHNVB4SEZYQVcwQzAyZ0RLanZ5VmxMWlFC?=
 =?utf-8?B?Q29lVG5EVkkzNWdjZ3BzaThMSTJiZXlndm5iU3VVOGNVSGp5OUFjRjJEaUh3?=
 =?utf-8?B?NG1LQklOWHhrd202bDB6ZnZIYTJydlNweXJkY1JmM0R2TUdvODJUMTl1R1ly?=
 =?utf-8?B?c2FIUVV0S1FscFJUVFBvUEY2UlE3a3QrV0FMbU9aWFJDKzlJK1lQZ3VnYXpu?=
 =?utf-8?B?L3JaK0dXdGp6ejlEUXFaalFtT2g1NGlGeWVKOEFlUVp5cDJPZmY4RFNJcEpI?=
 =?utf-8?B?ZFUzcFVUblpHcWlIVU90cmJ0bWZWNkR1SVIwTXRVUDI3UGRXWkFSUUNTL3pl?=
 =?utf-8?B?SnNQU21NUEI1MDZLTUUzRE5JeStwNXJIU05xK1RuWXhBRWtld0MvSTExMXhw?=
 =?utf-8?B?UHFJbjlWc3VmRW52dXlvNDJJNGU5aEJIdExqVFpkVENqRjZSbUt0Z05jRXNV?=
 =?utf-8?B?bkpWdmg3UUFYK3hFK3lNYmpHc2J2RldML2JuRTZjNjZUblFiVWhFSmdreGdO?=
 =?utf-8?B?SWFUQ3Z3bmV0Q2xicDVUT3FCRFFCZ1c5RE90NWlnVDdNRW83QWtLL0xHSG0r?=
 =?utf-8?B?ZXEzb2pycjQ2U1BrdVJxRGZDdFFyb0JIb0Z0RFlhajdGVzFaczhJU3FGSUNy?=
 =?utf-8?B?MGpkckM4dTY5TnR1aVdBZTZXUmExSkEzQk1kMi9wVlFBWjZHWlZQdkhuYUFB?=
 =?utf-8?B?SHJ1RHBVMFhHdjY2ZkxtdFFwRndobm5keEp2WjkxbnRhSEorSTNZUjdjUEtq?=
 =?utf-8?B?N3FlazAwbWpnOCtaRFhJNDJpM0tlU3lKYXJPdzlFSU5aK0pQYmZBVEhmTktz?=
 =?utf-8?B?VWVmenh0UDRlMWk3Vlcva1ZHbThGcFhJWU9ma2tyRnd3cmRBUGhmcVhTNmlG?=
 =?utf-8?Q?VXD6A7nZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f16620-87ba-4955-370f-08dbcef08c6a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 09:07:54.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2Wk88Oxs+R4rclat6BkE4hvnqjlCXn9E2t3U/NCwlA8Zsx6eJUfw7dunZ3vmip6skA5CEcBH33VHxru0D58xN470GZvZ0g7VKmeVcjkp38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170076
X-Proofpoint-GUID: 1p5t-kYPwNiEcZQfs4Kbo_9ppxdS8sRp
X-Proofpoint-ORIG-GUID: 1p5t-kYPwNiEcZQfs4Kbo_9ppxdS8sRp
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 04:48, Suthikulpanit, Suravee wrote:
> On 9/23/2023 8:25 AM, Joao Martins wrote:
>> Print the feature, much like other kernel-supported features.
>>
>> One can still probe its actual hw support via sysfs, regardless
>> of what the kernel does.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/amd/init.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index 45efb7e5d725..b091a3d10819 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>>                 if (iommu->features & FEATURE_GAM_VAPIC)
>>                   pr_cont(" GA_vAPIC");
>> +            if (iommu->features & FEATURE_HASUP)
>> +                pr_cont(" HASup");
>> +            if (iommu->features & FEATURE_HDSUP)
>> +                pr_cont(" HDSup");
>>                 if (iommu->features & FEATURE_SNP)
>>                   pr_cont(" SNP");
> 
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
Thanks!
