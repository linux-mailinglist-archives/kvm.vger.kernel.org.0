Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5951514F31
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376699AbiD2PZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241558AbiD2PZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:25:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD51496BF
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:22:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEDjq6032133;
        Fri, 29 Apr 2022 15:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0CvmP0YKpjZ6aQ9nfg2wHkfyZwCwk8QBcOG8aVEeKgE=;
 b=UVAL6P5BKI4Ck9IP9WM2YokFdsOFFKYnFlhwae82g/kbPCobT+pim91Kjlj0dDJ6+2Sr
 SVI4zAkGxmWxKQUL5LYsmQJxEBy8bBQ3wGEhcMWRU48GOg5oOf7m++IglIaYeZ5yp+qB
 TOgOuYzqFxWwYJV+sOkvRRELMHwIhQGqSsdUJTeOIVLJCLZ+ct4nC/N92OX1coIbd6xm
 eBYE9uhnohR7N6opOTu3ZPHOdvjHtJfQ058giV/CNrZfqQrAEQgcmjtrwH1P4M9jaRbf
 nzjZ6lfDgIJNnlERh0uh5ndtI5/bN8j6fD6wbvMKzPzNxZMTOyUyLa6i2lQv7OvFdwcN xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb106djv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:20:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TFAmRP000929;
        Fri, 29 Apr 2022 15:20:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yq9sqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReaW3Oy5RCpAdfoTRa6ccWFbdAYuV9vJCFzQOnHHIwItjrlBprdWE7SSpQ7S72F1ngWG8cls1bp8Ig8sPEijlcg1bsRcYoKFxQ1G+oKgytkWWwJ6Y8/I93HsxfTjpymHVJZCx8O2mwihf7rtvT2ZNWsQJT0TkGJ1MerMhPGwVIkA+NW7zGOUu59IXyqpw7AV28pjNeHUH0ACWATE1IHH7UCehMKe8bWZJja2oZpWtMoke0qYJsj4SGe5Zne6sR7s5ber6FjIKB2PUwpbZHlMkxmrz96wryyAS3M+aDb4pAVvwv45wOh88qElhUobvyZUH3nXXVflA1Z9t/LUbLJMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CvmP0YKpjZ6aQ9nfg2wHkfyZwCwk8QBcOG8aVEeKgE=;
 b=eRwb0hTOymLu5RpqaH6qkfTc4Y3ACxAonQW+7OgqXmJPclkTwGKkuXjSKExROLauT5aFFB614CsNgIs6vyJTDC6wZKGFY2kTDuzOgvxrrxqN5/go7NciBEjwpDfPAemlDg18iZApvEb+Agq9NyP8UT1K6p5uEYy9nfLXiuv6fIZ3rVKU1t6VS806miMdyKxI0JPop438Dv9cjdlD82dX1q8J/cFLHC2cAAVG+NCyLhHmk9oWonq45mLRX8E/5872EictF+2i0XGglkAEeyeb7fpJeoXYZY57ds+9l8LAJC/9laZMlH6GHcCj91fWX+ZKX6SPc0iYTF4SxBp7uzM4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CvmP0YKpjZ6aQ9nfg2wHkfyZwCwk8QBcOG8aVEeKgE=;
 b=PqSVOltk/wnoFxHh4a2/zqLzx+DUo+Q1l9BqEMDdGoG9mL6YcckNYmyp11lcvguoG+FFzln9JOVAzs/9pMXXDluOqI/H4FbIL7wbelFdSKthYPLIEz55MYIPWTp9ifoGZdEfA4eF3PFM80amvammeqhPbF/JArfSPJ+2dkh0h2E=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4301.namprd10.prod.outlook.com (2603:10b6:208:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 15:20:23 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 15:20:23 +0000
Message-ID: <1b6f16e1-7260-51ff-fac1-f8e16e783b1f@oracle.com>
Date:   Fri, 29 Apr 2022 16:20:15 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429123841.GV8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91ccb6a9-4d6c-471c-f979-08da29f3c7c7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4301:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB43014B5A9EB1EB4CE4EED3BDBBFC9@MN2PR10MB4301.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRG/S1xH9CbKhdob+ZEe4hbsY51iZkXI3zKu/yoRhIw5stu2+zoW0axz1Ke/9ajKOlI6BQi4k3EV+CFosCHQUmf4sqMDGRINY9lLDh/W7ha2g+2CvI7Mz67u6aj8tOowOjoRxn43j97TbK90rnyAKavM+nI69DyCv0MxvVcEBOqMBrFHuS1F3pVCQtZaEdTSszcXluSh++Y7X1a1IfxmcYra2xX/YrXJ2mflfdpu9D9t7ntvExiGtdi3zLmiqv4DkNAUBBDcZj+BPECmdzvvEds2MqoggKCPVSryi9q1bN2wKv4Ov5CeQ9vKUuAA6pUQAtgJjswwovsOYvVpt4Sp/HXjLrXJxhRYm7ksv5F8PucYm7n0M5L9HC4Yfx0q+CcacsQ6DyHPwBGs+yAAsXqloR2vuQshbUxB23NMvox4OYTIs001NJSFojotFT4Qlg9Ypa2WbAqrJj3lYf8pSLh8yEtjVTYKmWKS/Yd21chffydcFjtRLNaVuwI2Izb40Xb3tuKACPPe3iCnV4ebJfbouBaDm+2g4oV5ZxJGbgrjVmQWXlnYqXHMP8YwFClyGcA0KvQME/98YyZtQFzsllQGf4y4iWQuixK4Ypt1qhlndjY9XZ8bMK3suDw+3FL/5r6l9rjFUEnnHfKTXx7TF4sjNX+TU62/dnMMm08COKwW96r7qcbFHkPF27QPYWUDwKgzDJP53GuCn3JndRxCdeaHGZqPJNCUR4nIS/wPwOvaxo0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(2616005)(2906002)(66476007)(66556008)(31696002)(31686004)(54906003)(8676002)(4326008)(66946007)(6916009)(8936002)(6512007)(36756003)(508600001)(86362001)(83380400001)(6666004)(38100700002)(53546011)(7416002)(186003)(6486002)(5660300002)(6506007)(316002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlBWdlg0NWhMcmZxa2FsTGs1YzFSYW5MUXRBb3BVNGRpWE1YTUJSQkorS2FX?=
 =?utf-8?B?RWtJNEQ2L2lEVUZRdDRTMnZ5dnF6OWw5ZTRKcVhkTElnVmRHN0EyQVd5WE54?=
 =?utf-8?B?RUhOSlFhNTRLaWRuVlYvbVJJalNVUTJ4cW02dk9DQy9PVGEvc2ljeUduN3p1?=
 =?utf-8?B?UndoVjdsSVBzaC85cHVWN0g5dUU0Y0hMeTFoTjJ0WUtNUWthamVBbkJRbFpx?=
 =?utf-8?B?VzNXNU5OSUE5bStpeFRTYnc4ZjQreXZNN29IYnZpYlpKR1J6RUt2Q2xTbjhu?=
 =?utf-8?B?cUdWSTlGVDVhRFFpWW5YWEpSMzZhdCtOVmtwWmErc244aHVNRFJHYWRURjdj?=
 =?utf-8?B?TVowODhKalFPaXhZL2phWDhSUUNGdEtoblpleXV4aGJ1SGVFNHVBY3VlaW1R?=
 =?utf-8?B?RXQ3Wk1uODlwZHpyakwxQm9XVEtBTmNMRy91Njk0ajBxOTk3Ukx4Wmc5Ymhu?=
 =?utf-8?B?emZOeW1Wa0Y0TmVIcVR5UmRyWG9CbmtHM1hJMFNQQ04xN0RYOGRWcGhJZEVp?=
 =?utf-8?B?MGpNUUczTDdvMkxoWUpkcDFEcjdBYXNXWnhGTkhhaW9Xdkp5MTVkSDVtUlJr?=
 =?utf-8?B?VU5DOXk4ZmxLL0pkb09LOUJVY1dkdmpReFlrcmpUd1RQUk9yemVJTG80VFI1?=
 =?utf-8?B?ck1aTDc4eG5PcXNtTkpnSzRSRCtKL2Q1RUFScDN0bFJFemNRNGNjelpnT1Fv?=
 =?utf-8?B?SkFxa251S1RyTER3elA1WVd3anJQSERSSldzb0pibTVwaHBjSWlFTS9vTE9u?=
 =?utf-8?B?S0FHMGRveFNuVjlVSFp3YnVKV0tadTIyYmc2K1pJNzFXTTVsUVUyUkFsbWhC?=
 =?utf-8?B?b1YvRGlqRkEwaTMraXR2TUJYbDBOOGxXYWpObDladkN5YWt2d2NldC9LMFZm?=
 =?utf-8?B?QzZ4ZytEZjhKRklqSjJwTWI1bUlqcWkva0ZtVmdFY2p1SkdQOGJ3WUFLNEZY?=
 =?utf-8?B?ak1qWjgyQ25FdEtvelQ2QmdCc0tDN0R1OTdNRjRkZnFSRmdzRzNpaG1RU3lp?=
 =?utf-8?B?MUZZZW02RW10Nit2L3BzWUpNNndyUVFxWmxZUHN3NHc0cTdaanZTak5xdTFr?=
 =?utf-8?B?M0xpTU8yL29QTll6QW9mOElLMC9HSFgxd2VxNlpyNWVzalhkaHZiNU4zV2hl?=
 =?utf-8?B?SjRZMHFaaXBPNFJSOFZyL3U0SVg0blVGcE4wTDJrZW13L2V3S3djOXNvUWRV?=
 =?utf-8?B?ckF2Sm1ubDJGRFkwYVh5VVZhUm95RzR4Q3YzSEdBV2JIcUQ5SnNWK0ZFSzdB?=
 =?utf-8?B?SUE1d0FZNlZoaU1sOWJhT0h1c2l3OTIwb0J0bXliTXdjQTBHS0xOMFErOVZz?=
 =?utf-8?B?SVRucGd3S3FCNEpaMDFBNnhqTEJLcWF1NXhhS2pBTFN5Mkh1bEp1WkZIdmY2?=
 =?utf-8?B?WFlkVmxRNmxna2Z6RHVMcTQvRkw0OTBnMDkrZmlPQnZqWmpabDR0LzRtTStQ?=
 =?utf-8?B?TUZYK3B3OTBHWXkrTmhKV3JOd0dQa2grV2hranJrdUJjbk5hVXBWUW5CUnNy?=
 =?utf-8?B?N05MMzY2dWR5dVd6UzZGZGVub0FHUmlmUElweEJHK1A1eVJHMERkT0ZhREZV?=
 =?utf-8?B?QkNaZ3BDVEdiYWtGS2p0SEFhN09JbHRnUjVDdWJ2ajk2UTB2dUxLekJhMjRD?=
 =?utf-8?B?QTg4Y2t3Ni9ydHFkZ3lKWHgrSWo5U0NOVUw4NnRLbUhsSW5EcDg4Z3ZaVnJ0?=
 =?utf-8?B?VGpCYTk4ZmppNWJhMjdCdkVVRjFhbVJMMWdwV1pnd0lsVE1raHMvVXJRSFpV?=
 =?utf-8?B?em43Y2RFSm0rTlRMZ0x0ZXNrTDhlNFZFSEYvSjIzM2NIMDlkUWFYOHQ4Y3J5?=
 =?utf-8?B?UWNSUnNneGlZYStDTm9vTFBGZ1VZR2tlMUxTODNPUHhsOFh5TEJmbmJpMm5w?=
 =?utf-8?B?M1REUmZsM1JmUzZxd080VUpyZi8yTUcvaGx3YkFzUE96VDM5a0o2T1BwNWJR?=
 =?utf-8?B?OHdMWWtNYVcxbTJVUEdJSlRoZGErcDF0ZEpJL3NrNFFZTCtKSjVxbXRYQUM2?=
 =?utf-8?B?aEpPLzJ3ZkpyQ2tMblNZTWZJOHFaa2FrdndiUjRsS0dReWt2dm9lR1VXQ3di?=
 =?utf-8?B?Y01DWXdRdXZsajZBL3lkeTZxSDhONmdEck1wNlFBdHZWOWpMWCt3aHhoNG1H?=
 =?utf-8?B?eU4yaXhNTmYxbU02Z3QzYmZMbUdpQUZ4VFhDeTc4YnQ1cTQyZEhJaTBzU3dR?=
 =?utf-8?B?Y3Y2UFo5dmNFUEY1d2o5YmI3L3NvZVViVXpxdFRxWTFCeUhCcXFvV0k2c1o2?=
 =?utf-8?B?YXpSWEh4SGZ0RnZUc1FGOEJ6eDA1SGt3SzFNMlRUVk9BY20wOTJlTFBhMVJY?=
 =?utf-8?B?WllZTWFMOHNzbUVjQS82MllJVTdDQWgvemZEMHMyMDBvSDZmRHJSRjlDTmZM?=
 =?utf-8?Q?GW9X1Wd6zK7uKwBQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ccb6a9-4d6c-471c-f979-08da29f3c7c7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 15:20:23.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8U08UOUAPP5YNo/3cShkx3L4xsaGTE/WqxlVoRhWIdpBbU4S+tyIKR5K08knC/HbJkMmwuRZNyayb3oP/8+nY4YDZjAi+4w5BsPnPsOEDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4301
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=902 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290083
X-Proofpoint-ORIG-GUID: z7y7KmrGsvRyskMroJQlUBlUbWnCCQTu
X-Proofpoint-GUID: z7y7KmrGsvRyskMroJQlUBlUbWnCCQTu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:38, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 11:27:58AM +0100, Joao Martins wrote:
>>>>  3) Unmapping an IOVA range while returning its dirty bit prior to
>>>> unmap. This case is specific for non-nested vIOMMU case where an
>>>> erronous guest (or device) DMAing to an address being unmapped at the
>>>> same time.
>>>
>>> an erroneous attempt like above cannot anticipate which DMAs can
>>> succeed in that window thus the end behavior is undefined. For an
>>> undefined behavior nothing will be broken by losing some bits dirtied
>>> in the window between reading back dirty bits of the range and
>>> actually calling unmap. From guest p.o.v. all those are black-box
>>> hardware logic to serve a virtual iotlb invalidation request which just
>>> cannot be completed in one cycle.
>>>
>>> Hence in reality probably this is not required except to meet vfio
>>> compat requirement. Just in concept returning dirty bits at unmap
>>> is more accurate.
>>>
>>> I'm slightly inclined to abandon it in iommufd uAPI.
>>
>> OK, it seems I am not far off from your thoughts.
>>
>> I'll see what others think too, and if so I'll remove the unmap_dirty.
>>
>> Because if vfio-compat doesn't get the iommu hw dirty support, then there would
>> be no users of unmap_dirty.
> 
> I'm inclined to agree with Kevin.
> 
> If the VM does do a rouge DMA while unmapping its vIOMMU then already
> it will randomly get or loose that DMA. Adding the dirty tracking race
> during live migration just further bias's that randomness toward
> loose.  Since we don't relay protection faults to the guest there is
> no guest observable difference, IMHO.
> 
Hmm, we don't /yet/. I don't know if that is going to change at some point.

We do propagate MCEs for example (and AER?). And I suppose with nesting
IO-page-faults will be propagated. Albeit it is a different thing of this
problem above.

Albeit even if we do, after the unmap-and-read-dirty induced IO page faults
ought to not be propagated to the guest.

> In any case, I don't think the implementation here for unmap_dirty is
> race free?  So, if we are doing all this complexity just to make the
> race smaller, I don't see the point.
> 
+1

> To make it race free I think you have to write protect the IOPTE then
> synchronize the IOTLB, read back the dirty, then unmap and synchronize
> the IOTLB again. 

That would indeed fully close the race with the IOTLB. But damn, it would
be expensive.

> That has such a high performance cost I'm not
> convinced it is worthwhile - and if it has to be two step like this
> then it would be cleaner to introduce a 'writeprotect and read dirty'
> op instead of overloading unmap. 

I can switch to that kind of primitive, should the group deem this as
necessary. But it feels like we are more leaning towards a no.

> We don't need to microoptimize away
> the extra io page table walk when we are already doing two
> invalidations in the overhead..
> 
IIUC fully closing the race as above might be incompatible with SMMUv3
provided that we need to clear the DBM (or CD.HD) to mark the IOPTEs
from writeable-clean to read-only, but then the dirty bit loses its
meaning. Oh wait, unless it's just rather than comparing writeable-clean
we clear DBM and then just check if the PTE was RO or RW to determine
dirty (provided we discard any IO PAGE faults happening between wrprotect
and read-dirty)

>>>> * There's no capabilities API in IOMMUFD, and in this RFC each vendor tracks
>>>
>>> there was discussion adding device capability uAPI somewhere.
>>>
>> ack let me know if there was snippets to the conversation as I seem to have missed that.
> 
> It was just discssion pending something we actually needed to report.
> 
> Would be a very simple ioctl taking in the device ID and fulling a
> struct of stuff.
>  
Yeap.

>>> probably this can be reported as a device cap as supporting of dirty bit is
>>> an immutable property of the iommu serving that device. 
> 
> It is an easier fit to read it out of the iommu_domain after device
> attach though - since we don't need to build new kernel infrastructure
> to query it from a device.
>  
That would be more like working on a hwpt_id instead of a device_id for that
previously mentioned ioctl. Something like IOMMUFD_CHECK_EXTENSION

Which receives a capability nr (or additionally hwpt_id) and returns a struct of
something. That is more future proof towards new kinds of stuff e.g. fetching the
whole domain hardware capabilities available in the platform (or device when passed a
hwpt_id), platform reserved ranges (like the HT hole that AMD systems have, or
the 4G hole in x86). Right now it is all buried in sysfs, or sometimes in sysfs but
specific to the device, even though some of that info is orthogonal to the device.

>>> Userspace can
>>> enable dirty tracking on a hwpt if all attached devices claim the support
>>> and kernel will does the same verification.
>>
>> Sorry to be dense but this is not up to 'devices' given they take no
>> part in the tracking?  I guess by 'devices' you mean the software
>> idea of it i.e. the iommu context created for attaching a said
>> physical device, not the physical device itself.
> 
> Indeed, an hwpt represents an iommu_domain and if the iommu_domain has
> dirty tracking ops set then that is an inherent propery of the domain
> and does not suddenly go away when a new device is attached.
>  
> Jason
