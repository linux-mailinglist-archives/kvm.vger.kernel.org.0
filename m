Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A94E7098C3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjESNxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjESNxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:53:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521FF107
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:53:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCifIL031366;
        Fri, 19 May 2023 13:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=QGZhMMrMmO7Bz1Jb8YC29xPOFSYsF7WQJnxM5sYv+cw=;
 b=vvCpjY65fxa2V5cwqlTyJV10jDfYVmqQvOad6ogF+ivQV/49qgjL0rFtRomM0wQyBjgx
 wv2tz7oNCh+9hkYBwWX/aS0nHBTAb0zD3MeDICt7UksA1zJshPCP8/aHrywx5+SuBdSQ
 ol8EvVpC60lftDk6cPCidY16ZRFidCJKS9se5rSF6gDZSBJcdm0e/HV9kN8BAKnc6vMl
 RvB+GJNaFb9zKL7G5eKXlynzTNPNu8utjgIXnUWXwgcI/1KJJQ4yk8MgZLomzw8/Hhx0
 r14w2drtZJCbrAgGvnec+c+CtsD3tquICuU2Zajo00X/0odRZcL1FF+TNy3jCttNGgHQ RA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0yea4t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:52:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCaXIY040018;
        Fri, 19 May 2023 13:52:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj107v42c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:52:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqTKJ6eBnCiJtA0JkdX84q/FPeS8jeU7xcrLcGqmVkU1BfMQuilrl1EUNf1BFzMpgL8xX7AHk/Sg/cwbm7msT7ZlRM1u5y0R5foACKMR6qcUKj1HLcvD8VeKuzSG33RGPkYdDDRfurzQauQ4EgpV1tKQBxwhXmOLcsNaxXS8R2OJ484GhkZXq5DpwFIiWb13BqIEFXwWccLM2/pGdnr1gRr0mchwAPtyOfjq371WUjYXv7w+egxQI5kOUh2h0unJPgDgRA4081WfQ4fRY9VQVnh2BQOPzadzuVKwhY0ti0gyMBb1GFjVEUDSMhgUohCocoIhsv3RgtBt3qjj6CJDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGZhMMrMmO7Bz1Jb8YC29xPOFSYsF7WQJnxM5sYv+cw=;
 b=XpIGzMmCI7QORSh+/Fae32GvGRNw5NZ4YUUYgtkFDYJQIyRgI1yTQ3gaPavQ6HbZ1Ne97z7jAPV0d/oaanYhQbee6TU2V6+2Hfe6XwTOyL2miOOXByno2eVc4hJM6uYWfalHR+9z1JyLLTC0uj6jtqZx6xkTJ2lD7BVFtC8HGzh5bnIc9TrILAajXjbkAbcXadFojEeYXO/R1OU9hbvV4/Pxlpjr8UP4KQZ/ef9QNWDI4GrreQY4tFufgakT0dRCdqkr/yRwhsLwyEW0yUTyUrIHweGXy4A01WCTLhjkiuASA1Qn8l9ADHi5EyOzYKcdr2G0GxyZwdTIfNzMsXIQiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGZhMMrMmO7Bz1Jb8YC29xPOFSYsF7WQJnxM5sYv+cw=;
 b=A5x0tgWMgkghpSvTQmJ3dhoR08Aax5PrHSvyfur0Kw5Jba88N6yDKB5T/cta9EpkZVKv89lu9PBOsws5mZNSisBrEiC5LpNlQs7Sj8ImCDVc3s8mqC74bB1sQv6P0yTebdNhUjtqDcWwf5wBkzq0FFPl/v/+PRbN0m02OkrCqaU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB5658.namprd10.prod.outlook.com (2603:10b6:510:fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:52:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:52:31 +0000
Message-ID: <e2be6c92-59a8-5dfe-9969-eaf3e91256b2@oracle.com>
Date:   Fri, 19 May 2023 14:52:25 +0100
Subject: Re: [PATCH RFCv2 07/24] iommufd/selftest: Test
 IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
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
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-8-joao.m.martins@oracle.com>
 <ZGd7MzUiESbzeLeg@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGd7MzUiESbzeLeg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0024.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c39c75f-ede2-482f-dc8e-08db58704aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2T8Bp4ypVT+ZlIr+1XrBp/lFKa+eW6nxejMf31czbt6akT7L1814jiomvGnQ9a7VMfRvYQv9vM/44kEga+W5eqA69bEv6lit2PKSVkyxtq9AAm9kx92iqt//NKRqnUPAxDC/B1mrGhtFF3+ChRVScUZVwTUWfAZ1Cvvx2o242sqOvJVbkefZ5SW5MdvY+1eYeLNE1uYH11w9a72Fap8+an40U/gWhGvb3zU3nnrKdA5ZxsCi7ZU953PW23hkpJksDbfTv44WwVbECYMf9ZQh0eoI3XP2TeXid4GK3G7zrw1fzWu5UGd3Cg+6ToAHvzny7CGSq7QgjZXXgg6KTaTQibt8LYxHMXN5In0JoOZgDJGnqznbtV1H0nOUiE495BQm69a8UndQD5yLRHsf5R4fvAYmHkuzyew1GBlofxeyxh4eCBR2KJCJGcTsdZIt+bFKJOBxnOxhzKgwXQLeKG1wksYAVxoObAlA0YCLEp/nMWy9/G1OlO+oKfQzhXCVNUT2ReeaEREeB8BtzNtngczIHVHPamMnBR/T+SvCBnJ68PtCSfAoy72emtvt+nuH20U1cFFXOT3z3l340FIcpfLRXIZ9XbQtSb244Nj0pahKZ3hIsPV4XfIQCA8g3JiqUu/qbbwaBef+isKr0ri4sfkcng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199021)(7416002)(86362001)(8676002)(8936002)(31686004)(66946007)(66556008)(66476007)(2906002)(4326008)(6916009)(4744005)(316002)(54906003)(5660300002)(478600001)(41300700001)(6486002)(31696002)(38100700002)(6666004)(2616005)(6512007)(6506007)(36756003)(26005)(53546011)(186003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVB1Rnh5c2d6MWFEbmsvcHBSZ2tENFFXLzZTL1VENnhPclBZdHlFOWZmdnhq?=
 =?utf-8?B?MEJDNGdPN0dkbGFaZWdsRkkrRWhEeWRhR3JsNitqOUl6MEFRRTEybEhmTUgx?=
 =?utf-8?B?dHhEcnlpaXpTM0pxM3ZqY0I3K2hVZzVJMFB6Ym9BYVFtYUMyM1lYVzY1Q3NE?=
 =?utf-8?B?L2I5M3FERUxYN0hENEpLWHVUeDBrRktWekpYOUdHczlpY0wwOVNaWUwrUHhG?=
 =?utf-8?B?WmVwNzBXVEc0dUxlRzhORHBOaWlxY293Qm94WGpLWkdXZW9OaGY3RVk1RG5m?=
 =?utf-8?B?UDUyTitaOURJL2RFdkcrM055cis1cDIwMEVpN1ROTnRVL3FydDFReDBnbmww?=
 =?utf-8?B?dlVydWR3SWN4OHQ1MGQ1OHpCcEN4aC9aM21MS0RxNURTNWtHTHVQRmt4RTRu?=
 =?utf-8?B?OStPUyszRWxWUHdsMjk2eEJ5SGxWaUxRcm0vbEpjbTVEK0dSZk91QVliaTZy?=
 =?utf-8?B?UUcwYUVjbnlBMUJzVXNXS2JDMEJ5d1RMUzV3Slc4Z2dUczJUSEIrNE56UlYr?=
 =?utf-8?B?QW5sU0t4bVNBUUFYcDVNZE1pMUtUSFR1eXdyU1VPN2lSOXd1ODZFWWtZdkds?=
 =?utf-8?B?UzJ2RTFGVGJBaW1Uc0pDZHJzeXNaOGliamhPajdNak5vdUFzVE5wOTRqZ2g3?=
 =?utf-8?B?aG5wdmVIRVltbVpFbUpZb2JEbEhmcm1aVFJ0clJFMVV2N1ZJbjNDUGdMVWg3?=
 =?utf-8?B?NjN6K1FjQ3ZIL0pPQThxeW1YYkdoVGs4NDUwOTBQQWZETHM1MDlEVDBPMnZr?=
 =?utf-8?B?WEYybkVzK2Qra2tGcndTdHY2VUNKYTVIcU9IcWJqUStleE1BcGNZRkRLUGx4?=
 =?utf-8?B?cXAvOStBRU9MelNJT1orb0N2WVVNZ0VIL2x1ZG5YRnpzSzhqWmlhcXhmeTJG?=
 =?utf-8?B?cXhJYkhERFFpb1JycldjMmNTSjBJY3QwaDJWdHpkZk9yVWpkTzRoR1RIYW9u?=
 =?utf-8?B?UnprbEd0NkFTLzVnWjBNVmpuVW5sSWRRRDdJc1Joa1pnQkpyaXFsWkNEalF1?=
 =?utf-8?B?UnU5SHhLTjVHSUJxengrVFFnMjhJbVlNTzhGeWFtaC9VV2t6ZkFTOUxYd2Ux?=
 =?utf-8?B?S0gwTnlJU0dub2RTYnc4TDREelNZVzgwUEtNUWZaK1F4YWVMODJVYVFzUXA4?=
 =?utf-8?B?anFBMHZaQzl4bWRjNSt3U2xJMkdvRTZiVFhrdWJ2a1EwUmh2ZU9DZEIydXBK?=
 =?utf-8?B?THZjWU5KNThsV1BvNkNna1NaZVpaTkRnc3FqcllaQldJQWQ1Z3FONG1KVWN2?=
 =?utf-8?B?R2FvTmZHUDJ4VUlJSXdwWjJRdHJ3YzRxMitXTDdSY2dpRENkNFRxU29ZSVZB?=
 =?utf-8?B?ZjJ6OVhxQ09hQzcyR2hlUnlFUlZ0RjFyaG1mSnUxY0k2ZmttQlhpS21GQjJj?=
 =?utf-8?B?NFNPVm5YbWJoMjV2TExvWWh5cW9GT1dFdzVLaWRNV3h6Ym9Ic21memppZGZJ?=
 =?utf-8?B?T0owbHJQMnNXbXZ6bHgvUjBiWlh6VFlOb0ppdldJcUVLTVFJRlBUMFNtSmxJ?=
 =?utf-8?B?VGlCQnVXOVFsa254bzg0RWE5OEQwcVRxMDg3SS9RS1c1WkdqVU5wbzczWTdn?=
 =?utf-8?B?SzdMTHFzYjYxc2V5VlcyN1JwVTk3TGsyQndOUzdaamFqcktqRUJyd0ZERHpF?=
 =?utf-8?B?bEpzVGF4NWNOc1ZqaUZScE4vdG4yZEVHekN5azNDUVNHUVl3VmUvdkZyZDhY?=
 =?utf-8?B?eGZNbTdnOCtGeFlaTDdyMVYvSEtTVkZod3RoS0toZUx3aW9sV2k5YkhNRGpO?=
 =?utf-8?B?UDdJSm1UZFJnSjBDTTdDZmRhMDJMQmtGaE94KzE0VmFack44RkFoUjRYTEFn?=
 =?utf-8?B?L09XNlIvZTI5Y1Rmeno5SUpSdXdGS3hVbVhkVmoxNHdOa20xTXd4cDk2SzY4?=
 =?utf-8?B?cHlHQTBtSi85cDJmcElObEszTEswZS9qbVRSYXVqZll2Z1V1SzZsNmY5dk04?=
 =?utf-8?B?OTRtcXZ0a3ZEbGp1NkJDbU56c3pUcGJWMjBlRVYzOEJnUy9lWlYvcE54Szcr?=
 =?utf-8?B?R2RwbmxHaEFQenhINmpqY1IvcE9lSHF5a0xHd0ZpZTVZT3dkT3NqUG1yNXA4?=
 =?utf-8?B?WlJ6N1NVZDBNSjlwVHBxVkc3Z1M5cDJMYXFwUndENDczS3dYbG9EMmx4Ulc3?=
 =?utf-8?B?M2MzNEtzYUhwWTEvQ2hzdXNJZEZPTlErd3VDUDBSR0JzbWxNc3QxN1JCNFp2?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QU81L3JoQnNxV0VPUEtMdk9JRXJJdC9QL3o4dk9XbnZJNmhOTGpmbTI2ajU2?=
 =?utf-8?B?ZlRXOCs0Q24waVdTUVNXSm1qOXMxalpLQ0FXRDR5R01LYVZNOXlDTWhWR2p6?=
 =?utf-8?B?RjI0K1hUVnhhSHgzYlF1dG1zZlQ5Q05VaDd5NEJURWY5Zk5NYnBNSUtRMXFI?=
 =?utf-8?B?SmE0cHBhYkhoWlhqOHlLTGRyLzJrL3Q2OWpHUHZmOTFUb05JSGhvM2tPZjhs?=
 =?utf-8?B?RlMzUkErUFZ0Qzg5d2RFZkpHS2dRbXJhejJrU1djTmpwVFQ3b1JNN1ZlSVlT?=
 =?utf-8?B?aWZlY05mSlJlWFFoa0JxQnZ5WThGenlFREk2cDBXdHFLWW1FYWFxR3YrZlQv?=
 =?utf-8?B?VjhxR1QyenQrZTViMno1SHE1c3pvKzdGem1xdjBnU3U0LzAvZkVGa05MMU4v?=
 =?utf-8?B?NWVUeHJCNU9xTmdLTDA4Vkt3RkZNZWRyV0t4dW92OTI1VUpkWVc2eGkxbjgv?=
 =?utf-8?B?QzJVMjl6b1BGUEtBcXl1ZTRRb1doalRkeVQ4bmtzMUZOejFRZGJ2WUJLRWhS?=
 =?utf-8?B?SWZwVEROd293MFc5OXVKSHJ5T1pQMjNGSlR0a3RqWHlzYXBpUkcvUVVOYlpT?=
 =?utf-8?B?VEJVcVpPakFOOGZNMlZ0Y3pQYk1SL3ZNcWJJZTJBR0UzWE50UW43T1M5NDdv?=
 =?utf-8?B?MmhYL0pUM3RWMXRoWWNDKzdQZlNtWkJTL0VTcVlpUndJRjhHeUpYbEJDblNU?=
 =?utf-8?B?NWtlY1VMMmJtbXdnWVJxTzB0OGJNY1c0YTJNeHJPN0x1NlZHVi9KQWNneUkv?=
 =?utf-8?B?L2lYTVNjNUVQY1M4dGNYaGtVRGROZTBrTVJFdlJTS2lWT0xKdmtqemJ0VGpr?=
 =?utf-8?B?NitUSDN6Y0s5K1BxQVFYT1kvYUp0VnMwREd2NkRVdHBoNUlqVXBQa1NkY3RQ?=
 =?utf-8?B?SE9XbjF1SVRLYXV5cE1zTTBjZEdobzFUS3l5dWpXVjlocDB5N2hDVC9BS0E0?=
 =?utf-8?B?dnFoWTg4K0czT215UXNXSFpkQ05WUFdONmhrNDVFZmIwUmU2ZlQweXJ1VHJV?=
 =?utf-8?B?aXJiL0psUmFEdE41NTk5bDZCeENHbm52d0hoU2ppQml0MnFXc1NmbUVTc3RZ?=
 =?utf-8?B?dW41Q1NWN1pLUDNrZFh3NmlKUk9pMlhza2hzTm5QSy8wU3BxOEpyb2hDTnI5?=
 =?utf-8?B?NzY1WWRyR1Z1TDdSTTJoenhweTM1Sy9aT3p6UkRYWlFzWS9FVDZBRWgzbi9v?=
 =?utf-8?B?VjBnMWUvRGxEWUlNL2xFT0xIWlVMU3hXOEoraHc0ZVY3WkhqUFQ0dUpETk95?=
 =?utf-8?B?Z1hESXNTRzQyWnlBeWJTY0NBNGFWOVl4dmJHeE5rNWNYdmlKcWZzVHQ4cWU3?=
 =?utf-8?B?SEcxRHUzWVR3NGtNQmhaVXRCMmU3azlJRW5ZaVAyT0R0TSttQTNLQkxzdU9D?=
 =?utf-8?B?QVVtYzhVenc4cGhaK0lpVnRXVjkrUGR1K25JSWxMK3FESmxBYlNXK1V3Mldw?=
 =?utf-8?B?dEpEaXdpaEhKUUo2MzA0OUw1bWFTRUc0MDlkTFFRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c39c75f-ede2-482f-dc8e-08db58704aab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:52:31.8153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSJjjliv58p1Xxd/Y6m8aCyrCcfZ544gYQB+iofRq1NeBo/9DSYPV7ZJ3xfEo52kA/+sPoI+xX5xAmm1tn83hTWNewqdse6baXyt7Puu9vQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5658
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=988
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190117
X-Proofpoint-ORIG-GUID: NvnJ_s4UL92fpRp-zwulQUJENnPNsMs6
X-Proofpoint-GUID: NvnJ_s4UL92fpRp-zwulQUJENnPNsMs6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:35, Jason Gunthorpe wrote:
> On Thu, May 18, 2023 at 09:46:33PM +0100, Joao Martins wrote:
> 
>> @@ -50,6 +54,7 @@ struct iommu_test_cmd {
>>  			__aligned_u64 length;
>>  		} add_reserved;
>>  		struct {
>> +			__u32 dev_flags;
>>  			__u32 out_stdev_id;
>>  			__u32 out_hwpt_id;
> 
> Don't break the ABI needlessly, syzkaller relies on this

IOMMUFD_TEST was quoted "dangerous" in kconfig so I thought that ABI was loosed up

I guess I just add a new struct here that extends struct mock_domain inside the
union.
