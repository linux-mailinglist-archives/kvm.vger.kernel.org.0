Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE217C8EEA
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 23:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjJMVVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 17:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjJMVVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 17:21:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70601B7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:21:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DLJCkk006567;
        Fri, 13 Oct 2023 21:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Le/EFpVoegpZCc6Kd9gMhKOD58CBR9wKPS2o2sEqJg0=;
 b=bpDL3TWKJWzzX04qs8WlKU7bDuEjzmyU5llRlrYxvlqvjNFEcCHw0pL0fnAO5BQVhSft
 PbuDCJB4vLv7MdvJpJGYmAMzj7CBi//LgRvIhvnGSoJ8EAG4dg/oHmdrjXHtH8UI0ZNt
 Am2qmr4neZdtHKstB90fNAgFtXXCKvSCOnglwQU/15oId8/1jPwaDAhWj1gKj0KM1LKy
 Y5n7kFfsmGBTxczhWBf2IOd6qo30cHeXzaMOqTG5xLaWFEKX+qYTIdNHvEWpMoZffbUP
 a5UyeTjxLioQhDaYDYklj4Jsw4XlCRiaAEdR20tpS3su+v+nsKUSI2iv9gfbkQjixENV Ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh9138n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 21:20:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DL3wp0040080;
        Fri, 13 Oct 2023 21:20:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tpteb5vpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 21:20:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M25rmExfNIpu6rrEeKt7dGuQI3FUFcqwcMVdVhlmTxBi7jyvxpi14j76DFkrxtAF+D1nyWodbrKBefB2EoCLStb4syRJL+S8Saeybu4jFpYm1KOHT6SFauP7bIyRRRTO9reYi0Bimbybwpwt9QRtW3M825Zy8UJEmkqt3piNDVYcSXM+Q4avDpauBOO5kVHvYoLYTf7z6dz0x/GwvkHLPFgJt4qxSbLv0pNSagYpiPRFOlzqAxL3DOtCamH/2vKvsrpUN0ZPqxHDDtDqh59k0V0e6wFl0nF+miTZaZDafsN7RpUjX5aX2flgswbCCdKurfqpSylvrwP7qzn5/mg2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Le/EFpVoegpZCc6Kd9gMhKOD58CBR9wKPS2o2sEqJg0=;
 b=H2ELJN19WwM2TKNtjRm/XIq9/weBCm0tM9rWiVTuuObK3WTPWyKOFfrjfoD4qDEYSiV17wq0LIPqPmLCCgNFG40gVvfyBgkuU2baYm6lcI4Bmf+WY5YnLwCMArKnqnAg0EjR3XPChsIMgcOZmo6F36CKJA6/IVPTinze6md9p05ji6BgdKrxS+OR7ZVEn6yMAg5jIpAR+axU4H+hQgXkG81wD/6Nus8EopFPaUQIbBtzp9FKo1U2VPQ99NH49UXGr6r1f4z9eD5k/mCz7SN67Ml0+CocMT3zcIdLBAcvO7WhzCruWsd/XXUcem42ReZnzSxvqmEXUO9Qp6g6C7MkOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Le/EFpVoegpZCc6Kd9gMhKOD58CBR9wKPS2o2sEqJg0=;
 b=uzhVbL0eLXihAOJJTz/59HDIianUg/EAr7EC+xJ7T+f9UAGRpXTuxMGfppdBFifarTkuuGId1J33nfWEm/u554OcdPnl6AjlA+J2C4USlHGwlfYdfvWq627SSj+iEMBePVcypdkrjFBy7/4Bzes/YLYGt1laSoPE0cbY+MzD6qc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4359.namprd10.prod.outlook.com (2603:10b6:610:af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 21:20:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 21:20:39 +0000
Message-ID: <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
Date:   Fri, 13 Oct 2023 22:20:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013144116.32c2c101.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0286.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:370::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH2PR10MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 446da574-e22d-4c7e-cc02-08dbcc323f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVbsMMdFkSMDIQ2XU50kVjaSxwjq3ngNJ8gvTv6tiMd9Jm/vq1DMRcwMXF/6IcAGj9X/qa/yYNSrUNoaM/OrELa9nqd7sogsqwMYffYC+jt34j1LR9t9vDEZYc9pcnVk+ZjV3oPnO2UpccEybX48SEOm96nRN+HIF4p/2//EdNnNsdrTKuxtBoUR2pZGdoIO2CnApwa9cxC3cibs+r99DteY811zRE84JD1hPqC/myR00BTo3s50bGC4t2U9lTwzCFGTxOnVISMfZEsdBOUrWMzFDUY0hgRzSlYJqwQ1/GKjLWHW7Zz+2VCGU+ktzu9ghaTM0VcqN/tkIUJ7khnCKgm/0VX94OAhd6ylpKhHlFEIcPqiEMrgLSn1LMbOiBW7oVxUcRj1ID40qBVn+2bjIvXipA4KK5K/D2S3m6NTuaFvJUfJCkRv7MoSv47ennIdzqrKjoND/aNJXR1v9OZK1zLphlj8AeakJYcId9vNCxcrOA0JHnF6DqccQt5BvPlMqfmiKHray3ktcBdle9ixHgx3TBZaIUDP/1cAPYCFiMM+7kZwlCuWwF1uxE2B/X5CXSSdmatj67ANLbH5AFBOUHbTEiQj46eRIRV54C/hEm13zLI8ZWV5+xhQFwlQou3zk7UguYf9wCw1jdAaWpjGNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(53546011)(2616005)(26005)(2906002)(7416002)(41300700001)(8676002)(36756003)(8936002)(31686004)(31696002)(86362001)(4326008)(5660300002)(6666004)(66476007)(6506007)(6512007)(966005)(478600001)(6486002)(66946007)(66556008)(54906003)(316002)(6916009)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEZjYVBBcXhGaG5wTlRScjAreXV5RURYZDJRV3dic3dBMVdEZ1hLRlh4RE1Q?=
 =?utf-8?B?dUxSS292VTJSazdSUE15MDYzWHBsSXBzaEZLUmkyYVBhUHZqV1FDM1MxNDk0?=
 =?utf-8?B?bWNuVGNHYWJ2NnNkSC9GWlo3SnE1VUZ4L2VCclkyekRDSTY5SWRNLzJ0bEFW?=
 =?utf-8?B?S2lBTXVTVkE3Q3pYZXp2UGdSWHh2ZEE0WW5mYmdsb2ZDWmptN0Q1Vmt4Zndo?=
 =?utf-8?B?d04wWkh4S3J3VFdLT0lhYlZvR3luNkRENXlSVVhhYkdBKzNIVXBPa0szV3h6?=
 =?utf-8?B?b01mR3BPUmZ3dXJ3QVpWN0tEV2I0U3I4aGRXamttV0Foak5EMEYrY0Qvc2Fr?=
 =?utf-8?B?b2xMRkd5MmQ3cUNzUEZXNndsOThnMUROd3Zrc0pOd1hNM2xwc0taeEdWbjAx?=
 =?utf-8?B?Sjk2ZTErUlYwc0NVVGtTbW05TllmSkJXdGZyTVJINWZTS052NVRDZS9MeDJJ?=
 =?utf-8?B?Nlg4Zm03L1JXNE1odnFxQVZPU0FUT2VXVHZyY202aFQ4S29CakwzRkJLTGhv?=
 =?utf-8?B?bTdLVm5wcTFPcTZUU2RZdi9WTjBDNGg1aEhyZEpKdEhHMXpINjNoTTh0OEls?=
 =?utf-8?B?U2tlaFFiMlVlaDdiaCsvdFcyWkdXdXlndnFRVWJLYkwrV3RhL1lyZ0ZQL2lr?=
 =?utf-8?B?RitISkdsODczamIzWHllekQzVTUwakNoYnJERzhOT3dZcU0wcUxtNHc3bHYy?=
 =?utf-8?B?eWRvYTF1M0d2TGtQaXpOVER2RWlhNDJ4Y1d3bWx6b0NpNisrUitDQWVVQ1pR?=
 =?utf-8?B?cE1IdWRXdkRlV3N6b1VjK3p2U2RwRHFTVjM5NkczTDFueFhUcGV5Q0prZ2xy?=
 =?utf-8?B?aHY4L3dLbkIwSnhlSDVLQ2xuZERMMDA0QTJlQ0tDckFGN1h1S3owaDl2aWlG?=
 =?utf-8?B?OGJ1dmtNZWxDN1czeG9oUEFlMmVaWURHQ1pjc0tUZHJKVkYwaGRIZGxNUThq?=
 =?utf-8?B?MFBjcjg5cmQ1T25pcnZvazhqSDNHajhxUVY0MVA4bVZOSm9iYXZMbXJyTVdz?=
 =?utf-8?B?c09RM0MzeGFjMU5lNmtoeXdKY2p5eHNLTG1mdGJ4MHR1T0xabmdaa1FuZ0NR?=
 =?utf-8?B?YTRIQjNkaDlMaDg3YlJrNEJyYmR3S3cyVXN2b2N0QU1TZ0pQRGc3RUs4eW1G?=
 =?utf-8?B?eGRDaERhUVo5OGlpNzZ5VnNTOTFJLzV1YzIyWkV4Rk9kSDJqZ2UyUnNoeVFS?=
 =?utf-8?B?MmRJNVFieXFiOHVEZ2RiUTlTdm5kY3QwTk9HdkVZRFNVSXYwWVFqK1JBbEZK?=
 =?utf-8?B?WEdxZFh4cnl4enYybGFlbm81TDBlZUhBOXVsUmhPNDhDU084OUFSeHlrWENN?=
 =?utf-8?B?YUF4RksvZmxmcUp6S2Z6V1J2OTRyK1o4ZWpwSGIrSXF0bDZKOUhFK1F5VG5C?=
 =?utf-8?B?b1ozaEJxczdENjdEejhEaEZwZGhlbER3OFhYSmQyY1ZkL25pcWpwQ1ExUnlS?=
 =?utf-8?B?R3VmTDUrZC9oWmpsOFF3TFRCVElnSnBMZ2lyRHY4OGQ2ejEwVnFCM2dVYjhp?=
 =?utf-8?B?UE1IOHo3Nk1YMnQ0WFdLZXFMQUVVUm9aNGZ2d0pjN1ZZTnVKSWJzbmx2UWR2?=
 =?utf-8?B?ek5HRllXVjI1cG9tWVlxYlQrT3dGWWtFRCtScG5tczAwckZidktyUmJQblA5?=
 =?utf-8?B?eFlTWFFFV3hmSTNZaW9lR08rd3FNR0hvbklkTlBSYkdIUVJvdEEvK2FKRTZT?=
 =?utf-8?B?YjJnWGNoYzNGTW5rR2M4RDUrRTI2bWEyK0pmQmNqT01SeXVzOFE2Y21JbU1s?=
 =?utf-8?B?WWovNHNRSVJuTjB6dkdrTFRQYm5TZ3F3ZTFKVDd5VlhDcUxXaDNJY25GTytG?=
 =?utf-8?B?NDlRV3dNSVg1K0JjQ1hPTEFKczU4NUluYjg0UUJFSWZkeWpYcHk0WDcvcmJV?=
 =?utf-8?B?WWdDVmJIOWF2SzQ5TDB0SXl6andUb2lIM1VaeiswWDlacXhKYmlCYW16VVlH?=
 =?utf-8?B?T2V2L0JqNE5MOEN0MHhBWG02WVovQmJmZFpzNG5xM29KNHQ2elV3RkNZczdF?=
 =?utf-8?B?bW5ITXhheGZ0SC9DOTduYTN6MEx5VUovNnVrTnBnM2tvVUhDVGlsNmdxbHll?=
 =?utf-8?B?a0JCM0d2VXpGSS83SHJNU25tOGFsMXRpeHl0bHZJNlpiUUJldmFYL1hFSG9l?=
 =?utf-8?B?SE01UUw5MEFCeWMxZ2Roa2dISmRiZlZwelR3OWU1cUUrMGUwaHFNbitIc2p6?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bzVFR0Z4VUZSQ3JrUzlORzVYZEFzYm1RQWZOSzFUcnVCOWcydlRTdFZPQk9M?=
 =?utf-8?B?OVJlSXZ5WHh3SDlpYlVrWkhSa3JsV0paTUhGWU9oQklFYnF3ZVA3VEJjTEZH?=
 =?utf-8?B?R0pnQTJlajhSWFhSaXJudjZOakpFM0J6c1lzVUxSd1hBM280Lzk4T05nTFZk?=
 =?utf-8?B?akNxVGEySDB0QUZlZ284dDFZZ0lBZ1pFdjBLREczSUtERlErRUlzNEVFNDgv?=
 =?utf-8?B?dGwvc1pHZHJoNVlIYUhHSjZTWmVheTl1TGk0YWlQdExOVmhNRW4zRW00YVhW?=
 =?utf-8?B?QUVNTjg3SlRxRHF4VEJWVVpOUVZIKzZoRVEzN2JqVjkvVmRPRlVwdzhncUVv?=
 =?utf-8?B?aW90dTZmOG5VdXJwN1RSaVdyQy9VSERJZTQ4S0xpTktPUG1TNGVZSlROODEz?=
 =?utf-8?B?cmtCWTUrUy9LaHFvYnp4a0V0cVV0bXFwQTlMSDNpeHkyUmRWVHhlY3p6R0FU?=
 =?utf-8?B?RkZpRENXalYvR3hoN0J4bE1zb2FaSThsRi9iUHBrYmNPNXVUbW1TVERWcTJi?=
 =?utf-8?B?MFJtMUJJMncwWk5QMUZWUjVrV0hFV0xKRmFGUHNtUDNBQjZZaGpobEdNbjlz?=
 =?utf-8?B?K0dSbXZWSjg4bVlHbzhPRW0zTk8xV3ZhNlhXaHI0UHk4TDMrN3RPelkzRXBK?=
 =?utf-8?B?N05qalZwT0hWbUwzOGZ4TDFsZEtVbStDdk5ZVUszNk00d2d6bXVPNkpUc3cz?=
 =?utf-8?B?dnQyYTBFUkhtN3NOdUwvbUxPMXl2UFlGR21VcXRpTXNDMTVvZWhKeDgwM3Vi?=
 =?utf-8?B?Q3NTakcrY0ZLS0p0OWxTTU5naEFzaWhpRytVYTNTUE1aQWdtV0loNTN2L1l6?=
 =?utf-8?B?a3JTNkdGQVlnUkpBeGhEOWZLZVBGSklBd3plNFZ6c0ovY3VvOFlST3ROejJI?=
 =?utf-8?B?RGNyeFFYZkRNTWpyZEdtNGZhNFBCZWIzMEg5a0lSNUF3N00zcEowQWhndzMr?=
 =?utf-8?B?Z1UvdnA5N1BML2g5L1loTlVtY0FXS1hmTm9ENENrQnh4WkVKbUdqWktkcWd6?=
 =?utf-8?B?VzBiSGtZOG9RQ2xLSkFUOXFvaEluSElkc1IxS2RRSkxwTnA0eXA0RWVCNCtr?=
 =?utf-8?B?aDRBejJsUVB1Y00yNFE4Z25hSkREZlRXWXJ3aXI0TWVjeEg0R3dETWpISnQ3?=
 =?utf-8?B?Mnpsc2x4eHFrNlJJUTdBcEZCcWVLOHRidUFsL2gwRkVIeG53OE5Ec3RjMGVu?=
 =?utf-8?B?U09YQlFVc1JqWVp4MTBvaTVlRUU2MEF3eUZsdmNuVjVNRkdUWGl2SXJHOE5P?=
 =?utf-8?B?eThoWlZhREEzclVnWWJjNGg5a0sxYnZUMHRuWVR3ZDBySTg1WHU0K3JBY1lW?=
 =?utf-8?B?WmpCNDRsa1dPMCs4dGNUTjRKdTNya1h4S0tkNGdxNTQ4c0xPc2d1RXg0RkVW?=
 =?utf-8?B?TmtDM3RsTWhmWGVwTjNXMWcxTlc4Mk5PTXkzRWZ6WnU5czM2VlNjc09Ya3pu?=
 =?utf-8?Q?56lQemFo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446da574-e22d-4c7e-cc02-08dbcc323f72
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 21:20:38.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNy9c1zTjMJACHO+y2HjB23fPmCQ7T+0M07qalSYQ52Uf5jvQT7qw/NZh2/yBCyUyrRf5TnTkDgoAn93A69EKZ7ktRZzli/J1xO+tz8ieJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_12,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130185
X-Proofpoint-GUID: fHrobr1-C3RD_a6RGzLFYxN9nswQZ53A
X-Proofpoint-ORIG-GUID: fHrobr1-C3RD_a6RGzLFYxN9nswQZ53A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 21:41, Alex Williamson wrote:
> On Fri, 13 Oct 2023 18:23:09 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
> 
>> On 13/10/2023 18:16, Jason Gunthorpe wrote:
>>> On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:  
>>>> On 13/10/2023 17:00, Joao Martins wrote:  
>>>>> On 13/10/2023 16:48, Jason Gunthorpe wrote:  
>>>> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
>>>> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
>>>> essentially talking about:  
>>>
>>> Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
>>>
>>> vfio_main.c:#include <linux/iova_bitmap.h>
>>> vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
>>> vfio_main.c:    struct iova_bitmap *iter;
>>> vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
>>> vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
>>> vfio_main.c:    iova_bitmap_free(iter);
>>>
>>> And in various vfio device drivers.
>>>
>>> So the various drivers can select IOMMUFD_DRIVER
>>>   
>>
>> It isn't so much that type1 requires IOMMUFD, but more that it is used together
>> with the core code that allows the vfio drivers to do migration. So the concern
>> is if we make VFIO core depend on IOMMU that we prevent
>> VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
>> select VFIO_GROUP or VFIO_DEVICE_CDEV but not both
> 
> That's not true.  We can have both.  In fact we rely on having both to
> support a smooth transition to the cdev interface.  Thanks,

On a triple look, mixed defaults[0] vs manual config: having IOMMUFD=y|m today
it won't select VFIO_CONTAINER, nobody stops one from actually selecting it
both. Unless I missed something

[0] Ref:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/vfio/Kconfig

menuconfig VFIO
	[...]
	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
	select VFIO_DEVICE_CDEV if !VFIO_GROUP
	select VFIO_CONTAINER if IOMMUFD=n
	[...]

if VFIO
config VFIO_DEVICE_CDEV
	[...]
	depends on IOMMUFD && !SPAPR_TCE_IOMMU
	default !VFIO_GROUP
[...]
config VFIO_GROUP
	default y
[...]
config VFIO_CONTAINER
	[...]
	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
	depends on VFIO_GROUP
	default y
