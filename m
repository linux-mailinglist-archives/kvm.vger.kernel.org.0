Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F80716D7B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 21:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjE3TZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 15:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjE3TY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 15:24:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB988E
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 12:24:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UJ8rWN026550;
        Tue, 30 May 2023 19:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ib4Z8/HroJZK/mp4RV6BAITX6ysNvj/PbwqjkBOmVrE=;
 b=MDZ37h9rewqsE7qsbJE6mzUyNMpLdGuMkAyXSRC9fowVmJUb7aSSNif75IK9vs7+WIdP
 oq/pGvVKAy+dVd21HnbPIj9eL8A1QAzY+sCZbNTKQQigEExKWZhuSxnrtQmps3MLevzK
 E4TGcGniefyBknOuQCriwho02qKfjBbHbkkIoQXIFkzU5EunVnXm+xok+0eMKrOraRW2
 ZebLVpMP3rdQxXa3EjIG+mU4dQ+VyrIk5JDG5WMdfc4/CXF8FUNjaThRAQbmOHUxA5gf
 Cir+gIlEwCiM3/vgADByWRHXmxEv+uVstVTAHitsPcDxfj7/B8DTHjJaBI7WKk49NYGT cQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwbm25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 19:20:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UHaREW030050;
        Tue, 30 May 2023 19:20:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a53gsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 19:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeQpspMLCCKKW4obbmLDfn1jKIMHFlJqQAkeo+b3pQiCzXpJt1MnmozlKDoxph6DugxmTX4WoOrpDe+AfxWu+D3fS7hNwpR+02EvuwtzlBqtkYqP8ZYrlyf30LNGtXa+hxojply1Z/I39ByNkJFXM0Qqf5VEsfl5x6Ne7Rl2jQui6z2UveIBBq9gpZL/Oamh6wWRjd+liY8f++7MOFnFYB7vjVCrjm7vFrDt42Da1w1fmCJbkxbGhXtdP7Xs76IvyU8RAcsXuTIkgfSXoIQeAIjbiv4GbBVwZReSUfL8ndS8f/vHzAQdEdPoc1nOI2fOzAYxi50aL4RpnrvmKUzSeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib4Z8/HroJZK/mp4RV6BAITX6ysNvj/PbwqjkBOmVrE=;
 b=Gfv3mbsD/5eIKaCRHjakGiVE1JrGQRMRvk4e/5rsrniSbnQ9uw50EPIHBEvx6uAxw30czarcMMP5r5DnXG9UYvJiXkFQAc5gxBfOBmM2ey0dz2AHn+ndrPLlaHjdLzYmmhXMNdPlchqayfiwnAkEOSHGwz7PAedIFoDlx1ldT0Mnj5xkW0RSN/jntPBf4MxDdjqJPNfMqClnfyW1Jm8jBkBffaGlKaMHBS41HQ/P/AsZNnQ9Rt/RJjVDdbf6YTbSabS2KhK/NpKDWqHCrb3vC6WsFsHLe02VslwRu6dSOXOWkXRMYwhWfZzYrwLm1BrmoXVlM6jTD1oD+5VgeS9kIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib4Z8/HroJZK/mp4RV6BAITX6ysNvj/PbwqjkBOmVrE=;
 b=fgtq8/aDNW//LBNBw2oHIZTOmGxioCeoGJYeos1INwphJ0UDprzKd4mMAeGge19PH9KClGZBfZJEvP+K9WpXM6s/IQ6Bpku4dixvMSMUa2iKoUepVRTK2925f5heHWjcpvCbWHYQBw96JqxDoKiJexqPp/wS3wE6tkIJ0MMObow=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 19:20:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%4]) with mapi id 15.20.6455.020; Tue, 30 May 2023
 19:20:05 +0000
Message-ID: <b42dbaa1-ea68-b0f2-a74b-95832413e44b@oracle.com>
Date:   Tue, 30 May 2023 20:19:58 +0100
Subject: Re: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
 IOMMU_DOMAIN_F_ENFORCE_DIRTY
Content-Language: en-US
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-25-joao.m.martins@oracle.com>
 <244a1a22766e4b46b75a74d202254b0d@huawei.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <244a1a22766e4b46b75a74d202254b0d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0078.eurprd03.prod.outlook.com
 (2603:10a6:208:69::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: c01a59da-28bc-421e-27b5-08db6142dfce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QKPRSYy/UwR6T41p/tvTdERlnn6QHNAgOJILUtEFML7ml9ZNEv8Zmc+ihqmtdR8pi8reT7IPQH7/+pwLJwlGY5xukdfPyJ2IKSN6oO/vBugeXLe6AiWafZ+mv1UZgCV/q5Hhri8NrLzJOLm/O5IugpeVRytvKzZ9QDRN8fEBUJK1EJ4X+WsxQjS8qdqefM7IKQ5fG6sf4MA2uZrCdBWytXDAXnnYTdJSYFwKK1gtmiqi/STC7UpiNVcXUGoD4ntsAvI/nSWBjnl8AtFP4Dtg0EjmQIDO72Ihto7ot94u/fT3HAsNvu+Pc2o3kPwjqytCxVsZecnloMX4QgQZYL/Swt/gQpDRlZ2M0lYl8aGRVY/iUiAvcKTjVZASx27fzSAhGQtUTqssDPwU+lNbaYCuKJBf9BN/LtLcWERvTnDN6NMTtEyKgFTwDnRvBz92X3yT3Km4aVurpxUt8mjxAV4FbGu3CTFlyvyLpV3uYQdPlFHQYb6irsmWIRg0mCyAbLr0sDuPn7OI1f+lt0GEWFqHe8+TECpDGUYMzzWwhSl6DwGjjn0034YGon5sLRiq+H6zW7tEnbIqcL90njT5BYFhVEH+8DNcBZAsJ0J2V0ShNMMIsWNtb6iBDxelVWk1OnqR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(54906003)(478600001)(5660300002)(7416002)(8676002)(2906002)(8936002)(31696002)(86362001)(36756003)(6916009)(66476007)(66946007)(66556008)(4326008)(316002)(38100700002)(41300700001)(2616005)(966005)(186003)(6486002)(6506007)(6512007)(26005)(6666004)(53546011)(31686004)(83380400001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXVJeGtPR0F5bmRFMFlWQjU0SlNmTytES3NjSzl1QzF3cHJhNUZ6SzlOYWZW?=
 =?utf-8?B?QURiRDRoemUvdUF0S1hFdHNWaWxkZTZvK2dqZFJ4U1JtU3hLNk4wdnZUd3ZG?=
 =?utf-8?B?QVZJS21NQURycTk4OUphVStOQU15WWo2ODcrSm9UZUpBd05aZ1ltejFuTEtq?=
 =?utf-8?B?VmRRdlFYWXFVdHNwd0x1dUtOUE5KNWFPUEZOK3NUbjJRNkZTcDNTeFk1UEpo?=
 =?utf-8?B?NDdocTRRUzVJZkxLM2poWnYrK2x4THc2WVp2MXRoRWJoeVE4KzJlS0hJeENX?=
 =?utf-8?B?d010a00wU3l3V3hmYVR1K0pZNTFOc0xhTC9BN0VOVWlybmJTMEhxU29iN1JI?=
 =?utf-8?B?SHh5eE5hb0s0VmFQSzU5WnJlMWdYME9DKzh1enZpYjNnSnJ1dDZkUThUNEcx?=
 =?utf-8?B?S1VjbHJwaGlZSEVvdFZOU2E5N2ppY2VvQytESXRMUGtIa1NXUk1lSjRsL21V?=
 =?utf-8?B?RWZKdDlNUUgrUTJldmN6YkpkT3dpdlgwbmsrQUZkQ2Z1RTU1NU40RnVXZzQz?=
 =?utf-8?B?bEtwemdEeUlIZmhFT3JXOVcwNEcyaHlzWjdZMGgyaFNqNXVhWm1MZEtLclRz?=
 =?utf-8?B?THh6M3VwcnNJdjdaS0tZdXIvNkRJQUdhdURaZmVtZ0RUKzYwNXdYVmtQOHFy?=
 =?utf-8?B?N254WEdKUjdIcnJhc2FwcVJLalRwdUZ6UThqZUxEYnFlUUhQOHg3NkplTEwr?=
 =?utf-8?B?NHJ4S3E2OW56b3U1QVdxcnhKc2JSdnRGenptOWRHdUVZOGpQSU4xV2plWEhV?=
 =?utf-8?B?RE1jYldsU1FFWGF3NmUzbFdhbDYybi85NTZITVlCRkhQNkJKUzNheUljUEg4?=
 =?utf-8?B?ekNSM3cyemVGNCs1K3hwODdiRFloQ2Znd3VsbWtuYXZPOUlleFFmdWVwTUcr?=
 =?utf-8?B?STJ4WXhZN3pRSXI2cjk2T3BIWXBFWGg0TFhyQlRNWDNqZXk5bExRWUtYNExU?=
 =?utf-8?B?VTM1cjFiYW91enZSN1R5UjhrTWZkY2N2VXk2K2JzVXRkU3JsUHBuUE5GeGJ2?=
 =?utf-8?B?VVZQOFdLbG1VRjRhV3l5VndhbzFhdnFHd2dsRTRrTkNhcUJXdTZHSWloQW80?=
 =?utf-8?B?Tjh4aXo1M3R0VDlYNllJVDJjcks1OHZCcG5MaGlTUTl6ZWo2cVRBY043Nkhs?=
 =?utf-8?B?ZnZMNEY5R0packJkdGVpTm1LbUJ6VVBwMW5KR1pnVU1YZ2w5TFFHSTBOSmR1?=
 =?utf-8?B?ZUViVWh4OUNjMWdScFd5dFNiMkRJSjQvZ2F0Ri9DUWF4aFFDa3NMaU5uejJi?=
 =?utf-8?B?YVgrUUwzVjVCOHhyODd5L054RXpuTFBQRDJFRVhTaFZjL2lWNEsrQk1xYk0w?=
 =?utf-8?B?aXgwT1hkOElpbnlmQWRGMjRKWXRod1BiNFVPUFBOV2Q3VmZwRG9EYTNzQ2pZ?=
 =?utf-8?B?Q2pvZHVTamFHeG1Ccml5SFBKazRUaGVldjVvVFZoN29wR0RmVDV0aGp0Vnlv?=
 =?utf-8?B?ekxqY1lZVzZJUlF0K2pSc2E1bnBPUG1id3FrOWJjaG43OE5kY1NkL1JuM0ly?=
 =?utf-8?B?SE9iOEZXV25lKzhzL2k3S1FTMWpGQTBBam9vYlZ3NURDTTBvMERFNGFiR3Fp?=
 =?utf-8?B?OE1LWkRwK3NFbm1HbHQ5MFUvbE13VTNVWE9FbWhsUjNhdUt5WE53NDRhTWRu?=
 =?utf-8?B?bGJBLzV0N2FxTjFNcVZXcHB1OGJKZkpQb1ExOXFhbXM3T0pCYWtSTk01OU5X?=
 =?utf-8?B?bUg5OWQvL1RKcXA1UUEzaDF2VlUxdmxqY2JoNG5PYnZMSHFiL2pMeDAwZ1RJ?=
 =?utf-8?B?TGFqR2I5cUg5eTY4T0lSNGtzWVdqaDgxZnJrSHgwYng4bVQ2SkNYQVF2U1JL?=
 =?utf-8?B?bHlYMUpjbTQrc2FndHZ0WlJUZjlncHBBeXFGb0s2NGxPOVIzeWN2MmZPNkhY?=
 =?utf-8?B?UDhNTnYrcng3aWpwRi9ZYzVpV0Y0OEF6UWdQUnVhUDloWWErTElrWW1raWtS?=
 =?utf-8?B?NTlBNEs2WlB1ZGh3RnpIM3pXb29KU0RTVWNNRk00YWFRdWRCdXBVM2hMSHhP?=
 =?utf-8?B?NXlPN1JlL3BCYThtTUR6b1RxdmNIZURTaG5nMVBOU0FiMk1jbE9VUUp3Sis5?=
 =?utf-8?B?Y0UyUVFJdjJkMWhmTUN6WUp1WXAzd0RYNHAxQWJyWDQ3WDhudGFqWHVvMDk1?=
 =?utf-8?B?WS9jdEM4N3dvMVlrVklPMWQ2TGZrMmxoazNmRFJJcDlGa2xkT3N0cVhQVkY4?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VXFhRUpLVHVWMjZpZVRCUDB4TFY3WkdMNWFldnNJY3pPbVFUZU94SHFkNHVY?=
 =?utf-8?B?V2p4R2JjU1luY0lxSXFReGJIZ09KVEdjTUFiM0N4MEp5K3BJRi81ckVvTDNS?=
 =?utf-8?B?bDZYd0FhRkRuU2ZjNktNUzRlRUhlVWdUeHc4R2I4YTVRYUo2Vy8vWVRIRGl3?=
 =?utf-8?B?WFkwMkViK3AyZm9UTmlzcEtuRTdaNXRRTDN6MSswdEZwMGJ5eGZ3aFRzWllB?=
 =?utf-8?B?Mm9FNkZQQW1kMWFvMzF6R2JWVzBGTVJCU0kxTDFOSU4vM3AzMVVWU2xKejNj?=
 =?utf-8?B?bytBbFI0UXh6OW5taUltaU5ZY2tFenFTV2pPbkJWcEcwY3BkbU9kaE1CNUhC?=
 =?utf-8?B?UGZwdUJDaWpWbk5BZ092VmtMUEZCMDBzeDc0VnFxa2lKR0dVaDhrek52L2Jx?=
 =?utf-8?B?Y3pGYTJma1Q5MlJCZStBU0xUdXJ1T3hBckNTMythS2Z1NnFGcThsUEI0b0ta?=
 =?utf-8?B?VWI0OHhONUVUMnJnbEw2dE9IWEdCMGVkVVJjR3N0SFQzbnR4NG5QdVZ1R3Jt?=
 =?utf-8?B?cXA5OUNaOTZSTlJ5bGhoZ3RoSGttNWdpMkVJWmFGTjN1TWlhcERxOTNXZ2l4?=
 =?utf-8?B?WjBFcWdIaEJocjIvQ05xTXhOSVFyOWVhS0FYclVzUkdPUVU0WGt3ZXZaV2Jp?=
 =?utf-8?B?YklFblc1dTE4RFF2eVVnMkgxQTFFcU5zTlBteFo4T1pTOFlGai9vYmp5Z0lj?=
 =?utf-8?B?MjgzUGZhR2xDNG9MNnVsSVhZaGpIbXNwLzBwTkZOZzF6N2dwMDA5aGkvSzVi?=
 =?utf-8?B?bm9CcHJXZzBGaDNiREY3VUN3cUtud0lxbVVxMlJnU3psOW4rQ1RFUDhTRnI0?=
 =?utf-8?B?VGVITUZMWjZHeWJpVnd4UFJrWVJKazE4bm9UVE81WWRxcU1HWGdzTjFwbG1u?=
 =?utf-8?B?ZWQxSDI3SEFWSFF0Q2lUbExneHl5eXd5cXdZL2JlR0ViUDFPcUUwaG51VU0v?=
 =?utf-8?B?dDFKWDVMUktQbVJlS0lNaWtya0k0c1hiKzJacUlBTjNGUFUzd1hzSDNoMFhR?=
 =?utf-8?B?M0x4RWk3eGZ1L2VZcDFtL0FpR1VEQ0tSYkxOUUhHY1lpaFpmWmhMWkRjVkFq?=
 =?utf-8?B?NjF3WWVVeU9TUUZNb3IvV2UwczlRaUVJY2VYTU5CQU1iT2t0cllNbW9FTXVs?=
 =?utf-8?B?dVdEamxrUndKQ3VFK3N1VkpEWlUzNTRrd1lDTkJ2NTJKeGZXQTRlK0xKam9E?=
 =?utf-8?B?SWk2Z0diV3JCWHBiWDJmREQ1aE9BRUNTL1BrYktseGMxS1V0VmpRQlZFSi9k?=
 =?utf-8?B?cDVudzIvOEgzYVdNVUlRckZnVXo0b0NLejZ3UmlGdEZoeWxqWmpxY1J5QjVJ?=
 =?utf-8?B?ckR4MXpSSzcwalF4ZkdMTmZ0SE1mMlRybU94RXBPemxrbVVUelEvMHBLbEhP?=
 =?utf-8?B?RHNveGx0TUVXZVE5WTQrMmFWYkx6UENic09odk1qWVJ1elJBemlzVUp5ZnR0?=
 =?utf-8?B?Kys4Z2RQc2Q2RG1LdWErL1NEUmQ0bkpWL1ZBaTN3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01a59da-28bc-421e-27b5-08db6142dfce
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:20:05.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yPV5pj6/1rBujxqOAAEs4eCYPggYK/q0jKju+4akIaRJXV3WOF48QGMW6it1U4uJI1IimR0BJr+Pq29ChIn5lpLpVHzDRtNQeKNBvUvF4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_14,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300156
X-Proofpoint-ORIG-GUID: r8FqiiY0VxPhvKjG335ZVO8-CQGTZQGe
X-Proofpoint-GUID: r8FqiiY0VxPhvKjG335ZVO8-CQGTZQGe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/2023 15:10, Shameerali Kolothum Thodi wrote:
>> -----Original Message-----
>> From: Joao Martins [mailto:joao.m.martins@oracle.com]
>> Sent: 18 May 2023 21:47
>> To: iommu@lists.linux.dev
>> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Lu
>> Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
>> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
>> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
>> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
>> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
>> Murphy <robin.murphy@arm.com>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Joao Martins
>> <joao.m.martins@oracle.com>
>> Subject: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
>> IOMMU_DOMAIN_F_ENFORCE_DIRTY
>>
>> Now that we probe, and handle the DBM bit modifier, unblock
>> the kAPI usage by exposing the IOMMU_DOMAIN_F_ENFORCE_DIRTY
>> and implement it's requirement of revoking device attachment
>> in the iommu_capable. Finally expose the IOMMU_CAP_DIRTY to
>> users (IOMMUFD_DEVICE_GET_CAPS).
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index bf0aac333725..71dd95a687fd 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2014,6 +2014,8 @@ static bool arm_smmu_capable(struct device *dev,
>> enum iommu_cap cap)
>>  		return master->smmu->features &
>> ARM_SMMU_FEAT_COHERENCY;
>>  	case IOMMU_CAP_NOEXEC:
>>  		return true;
>> +	case IOMMU_CAP_DIRTY:
>> +		return arm_smmu_dbm_capable(master->smmu);
>>  	default:
>>  		return false;
>>  	}
>> @@ -2430,6 +2432,11 @@ static int arm_smmu_attach_dev(struct
>> iommu_domain *domain, struct device *dev)
>>  	master = dev_iommu_priv_get(dev);
>>  	smmu = master->smmu;
>>
>> +	if (domain->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY &&
>> +	    !arm_smmu_dbm_capable(smmu))
>> +		return -EINVAL;
>> +
>> +
> 
> Since we have the supported_flags always set to " IOMMU_DOMAIN_F_ENFORCE_DIRTY"
> below, platforms that doesn't have DBM capability will fail here, right? 
> Or the idea is to set
> domain flag only if the capability is reported true? But the iommu_domain_set_flags() doesn't
> seems to check the capability though. 
> 
As posted the checking was only take place at device_attach (and you would set
the enforcement flag if iommufd reports the capability for the device via
IOMMU_DEVICE_GET_CAPS).

But the workflow will change a bit: while the enforcement also takes place on
device attach, but when we create a HWPT domain with flags (in
domain_alloc_user[0]), the dirty tracking is also going to be checked there
against the device passed in domain_alloc_user() in the driver implementation.
And otherwise fail if doesn't support when dirty-tracking support enforcement as
passed by flags. When we don't request dirty tracking the iommu ops that perform
the dirty tracking will also be kept cleared.

[0] https://lore.kernel.org/linux-iommu/20230511143844.22693-2-yi.l.liu@intel.com/

> (This seems to be causing problem with a rebased Qemu branch for ARM I have while sanity
> testing on a platform that doesn't have DBM. I need to double check though).
> 

Perhaps due to the broken check I had that I need validate the two bits
together, when it didn't had DBM set? Or I suspect because the qemu last patch I
was always end up setting IOMMU_DOMAIN_F_ENFORCE_DIRTY [*], and because the
checking is always enabled you can never attach devices.

[*] That last patch isn't quite there yet as it is meant to be using
device-get-caps prior to setting the enforcement, like the selftests
