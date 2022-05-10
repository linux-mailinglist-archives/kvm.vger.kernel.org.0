Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2F152143C
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbiEJLzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 07:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiEJLzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 07:55:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4365C26FA19
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 04:51:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A9MpbF024483;
        Tue, 10 May 2022 11:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f0D3cLaUv/0CfFDoHJlD5YWi4xWYSX4u9D18PazGWGU=;
 b=emBMbv806t8aTlreAOXySr/OyYGSQ/qgt+t4zTtVMs5jx0IDolB6TavgprWTBIaj4n46
 OB83AL/Q8aDLrrW/UgVcNsFF+zquZFBepb3tKI5Q8iMP6Cxj9EqzCDgZF1PEiVSTHL1s
 zvl9UF/kEgT9T8TmhEEk3huwmFvftJmp7xCRtTfwrRhr0ruytqyaL3CjCNItz3kZ7TCl
 Z+z7QuMvhLi7tw3jWOpCpiFkzQsYGO8nKLmhGq9+HzgS+O2JdibO7qhs6lYTdn4YFRi2
 RbnRMDRkh/Nocyduno15wTkbtEhvlMUKfa54oyDlcOrmuEFVANArLxR0K0ay7Rv2E7DP vQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfj2ef3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 11:50:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24ABjkq8031130;
        Tue, 10 May 2022 11:50:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf72wmnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 11:50:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4CJLtMqd6jQt/nHSI3F5+gZmChsGGXTR6qCUEd0Yx0Pr9PadVBTAP5/668YqhF+9gdg1mM8QtmJHOG9IlrC0bhK9d/qrH4diIA/LM78PvOJsmTbolbeFhlwXFxRJoIoQX7ZtV0ezs2dB0+MU00tNStWUqnoz3/14JAMx/KzaZtNUHka8zUT103BxjsTY0jMC+qBHFHfusyS8lUe+PlPIVCQQLuUS47tl4fWM6x9hk99Ugn943dO9BuGuOdh07Pm0QUKioRg30Bd2T+UkjiIpcLeErzONwB6kNT6yU3l2LxBKTDed/k/zsbhQsvLQXoCMcMCICAExbzw2BDM/RNrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0D3cLaUv/0CfFDoHJlD5YWi4xWYSX4u9D18PazGWGU=;
 b=aDG+fV3HPKLVZuXm3OIXiYNNmQJNnD6Mqsw9iH2vuga0M5yuQF/zn33XPEJOpRe+Cz+LrIXhA6r5UgkPtAVqvRTkAF8/zij8DtfXjXeQcqQbopG7z37HymED2mulLMYLrCJ99dXC5vuoEDzDtibOCRWDdRIpwa0I+8RcQqPNVMvkC5NdyblsITX5LXsn9pwdiyvp8uZwxS0N+8V+3YuacZZ/C3XHiUqKniob3YEdDRLI3yDMOZ8rt9+B+0x56GP0YdJE8vy0xTgN6GydvJLs6SSJa3mzTArAEN1V52VEWQRZQ5BePbbP2SMrvvzHHLrt5VFkuZNI9ri5kBa/uggnsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0D3cLaUv/0CfFDoHJlD5YWi4xWYSX4u9D18PazGWGU=;
 b=P3biNXMWESpVUp8MiS0/hvbdFOFKMsnBpmiA5CtttIuDf42bike391ezTpFHsp74q99kRrSdaVRbjtm+bCFIZCgWoHWmog0Z59oeR01LtwGrO2W98qdF37qlSCS+WzJwxPHlwP2ZT35VeCPohdxrBshrr4qzaQ8O28yamHqcbaU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4064.namprd10.prod.outlook.com (2603:10b6:208:1ba::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 11:50:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 11:50:40 +0000
Message-ID: <c08528c7-a20a-0c38-0e7f-f51b8fade84f@oracle.com>
Date:   Tue, 10 May 2022 12:50:32 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
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
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220506114608.GZ49344@nvidia.com>
 <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d837526b-3f8b-4843-b6d2-08da327b4e19
X-MS-TrafficTypeDiagnostic: MN2PR10MB4064:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4064A18B07D7B1EEB1095C9FBBC99@MN2PR10MB4064.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrggtq2vipSdy3/x4xtIXZukoTG9n2RIA63YkJ6G/Zamg+7RHiRdjydaRVa3EpWqsUsmarxnMaywzM5PY6Mz3WwJTc9s8/zQD6e9uc6l1a9+GQ+cPrNL20/WFVmfq1Qb+lkeqjY7lgMkdhEIO3dl8+OnwHjeENDg+mh8GthADTqajP+o3CUCdZpXu0jZZaHKSfXNYOFb7cXKCJJpS43SC6KDj0PGIGSDk7pZDwl5SvTXVLWDoa61jdNJ209fCDo4Su09jqGJPArtGXYCiq/y2S+ZBH+9DoH4mc2NlxGkoEiMNBRkj13VSZqXdcmE043yp261ST2Huz7+9t62pfIrtLm/MbEssim8jVfnH6epRk8w+NMnjYUgfBExoHycre1Aj8ftZUtgRXncHcH4v/RKCVkk9cu5taC55+bBEuOYdoKFIumDsRXxfndUciRPeGgCws6imA87syqYgD2W41M2FeYH8OcYBZsu8Niwop5++/7tdjpLJEeRs8lM5j3+NfloHBc5i643ka/NVKYGnZhFsxFbvBDpCeDmOZxg6Zie9O6a4JSD0iP7BkTowi1+75dSHrnEbzJ6FyVI+T67Klj0crDUEaEoOWtaDXj9HXzlHhGJb8wM8dPDBFSm1xthoqb7zx4Cc/HqY7eKB8S09vJCCCpeMCsrmnjKekxodPTFOQ8OYLXSi1TGJFaWFGEE+MnYjzwtlT6Awxy2oPSbju805n2gp2F+6246r40U+m1EW+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(83380400001)(2906002)(508600001)(6486002)(6512007)(26005)(7416002)(31696002)(5660300002)(53546011)(36756003)(186003)(2616005)(86362001)(8936002)(6506007)(6666004)(8676002)(4326008)(110136005)(54906003)(38100700002)(66476007)(66556008)(66946007)(316002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTg1MGVObTVvaTdjRWpQblR6anROVWl1U0NFblZPWlZXS3M0SjNwQVoxcGpE?=
 =?utf-8?B?K2k1TklzcXBXWEJVYm84d2NOcVBhZjJKTnpGeHRDM1FkVjhDNU1tRVFBRXFY?=
 =?utf-8?B?VUtTSnc4NjhuVFA3cW15NU5iZ0xzVFNQandPRGFHUHZnVVE2QWhmdXJxcmZL?=
 =?utf-8?B?bFUyNWlPR1c4SFNOL1FQOTJneEVNU2o4NmlmZ0t1bWc1UVhBWFZxWllMYVhK?=
 =?utf-8?B?WDdHdVk2MENqMzhwb1M3aVh1SmxvMEUvZG01SjlZWGNsZUhvNUpoRThwdytC?=
 =?utf-8?B?dFMvbldVQ012QURVN0pqc054RkJzcnNVRmN1WDVDS2ZiSXk1c2d5aFJuNWZp?=
 =?utf-8?B?SU1OWHNsbDVWRWhtL2ZJaVlIVHErMlpxdzdxMCtQVWxRV3g2RDkrbUF1RjUz?=
 =?utf-8?B?Z1hYZVFZT2UxdklzdGMyTmRKUGNpR2xjdC9ycmFhNGhhc3lPQ3E5VmkrdnNs?=
 =?utf-8?B?U3JITUVvRXQrbkNqOWtEeXRPWldKaW5icFdEN3kzemRkTnIxTm5SNlNCZEhw?=
 =?utf-8?B?MEl4QjRhVmpXZXVQZW5RZzVpUVFlRFFRSnQyK2NtbXFYY09HVE9RcXFZWXhN?=
 =?utf-8?B?S2RONzF1WEloNllZbFRzUm5oYW9qQTlLOTYzRnRDdGEwNnRFRjF6Vks0cWdi?=
 =?utf-8?B?d1hQOTcvM3lXeUwrQ0pMdW4rbDhycTRaV3F6VmpmUS9KUTVJdG5ITFcxMU41?=
 =?utf-8?B?Sm9XaHJKR01wT0FsZERCZzNXOWpXeS81ZDZNK2FsWHQrOU9hSk9mcXVkTzkw?=
 =?utf-8?B?Y0kzNXRMNzcyeVNFVFBheWpvT0l1TGtUcTdsNy9pTmc5TEc1NDE0RnF5TWN5?=
 =?utf-8?B?YU5rM1ZTdHB6dXE5bEtnMzdoeTdJcXFWTDl2TVNhc0QrcjR1ZkVVQ2NscWh5?=
 =?utf-8?B?U1Z4VGhMRWlEOUlJc2ttOW1FNzdUUTVKbGJzWXJLdWlqQXBKSWQxSXNjdDBG?=
 =?utf-8?B?TWtmeStkYXZkZDlydWUxcnNVdzNmVVVMYjN0bDJZQURqUmVNcGZJV0ZITUZW?=
 =?utf-8?B?OXJyMzI3U3p1KytzUmxsOFNzdzN4V29TQXFjL1p4dmdweGNISWp4MjVnemg4?=
 =?utf-8?B?Y2cvM1oyK3RSTDViYisxdUswL29PWGJac1dTMmlsTmM4YWkrdDNrMU0xblVN?=
 =?utf-8?B?dzIxdEx4SHdsb2hycWFRRHExRUdlUmFLNVpvRkFKOGlvNUFUTFlyYXk3NVow?=
 =?utf-8?B?Q1FGeFZtOTRJUlZZUDBPcWk5eTY1cFcxWFl0NjRmSGY2cDJJSlVZWkorYStU?=
 =?utf-8?B?aUFUUXV0Tm5QZjN0UWUvaktkODNjVXNVOGhUMWRYNGdFWitpQlRtSGhLQU1K?=
 =?utf-8?B?QTc5UGVyMGZnQVdMNmZDL1ZiYTlPcnZLT2RDamFUS0JPZUxIMkN5N2U1OEpv?=
 =?utf-8?B?V1R1THY0WE1HRys2elBZTllxZ21HZ2IxZEJWKzZQb1JEZUkwd2luQ1RUbiti?=
 =?utf-8?B?SXczUm5yRGtPRjdtN0pSNWdmeVJxYUx3Z1NMK1h0UUJISzU3TkZnNWd1VXJP?=
 =?utf-8?B?elBDQTh1aUFCdk9VYWxkdGxkckxHMTVQRTZ0OXp2VFZEcHpMdFIrTHBvT2xE?=
 =?utf-8?B?TS9KbGpkb0tnbGpLQUplbWVUd0psRjZLdDlQaWFkNXEvQm1SeTErZENLL0Vs?=
 =?utf-8?B?UmFsOHpiQTNTbzUxVHUxK0JLN3hHTEFXQUVSREJnY2JoT3NpSGF0R3pRWGcr?=
 =?utf-8?B?LzNKS0o4V2JtdDJBR1FhRHFJd0FMMFc1QzJEQkJCU3NUSktGYWdYZTRJdlYw?=
 =?utf-8?B?S0JTNW03WXRRNDhkUFhCbXJGYkUyK0ZXaXdrOUpWVmZ1ZUp1OU5ZVWxpaVcx?=
 =?utf-8?B?aW1KczBOdk1GUlJzc3AyS3h0aVhPem5WOTVQQlVnTVk2eEJuVHpEWFcyUXFw?=
 =?utf-8?B?WVRrbVhBbWUwSWlzVTVrajcxUGFMdHFsUnFOZlQyL3kxbVpqQWVCOUhYRSsw?=
 =?utf-8?B?QXBzT2kyUWhmcWNwMEJwaTBxalo1RGRmemJ1NDZBYVdBVjhhVEFsZEJJbk9s?=
 =?utf-8?B?SzJPSGlKRWQ1bjVsTGs2dHl1MU12MnE2VjRJeVh4dnJYNUpBd1BLNzQwaGtV?=
 =?utf-8?B?NU9SbVcvMEtZL0l5a1hrcGNnQU1kY1FnZzdkcURPVEZpenFRMGhMME84OEZo?=
 =?utf-8?B?MkxUZytxeGtRQXBTMWdwUTZwY2x5V3lCMDc4UHZjM2c4K2RZZmZyU0kxTWsy?=
 =?utf-8?B?ZG4zY0wwbmJzL3d0UXVBN1dCTGV3K0hDNXB1YTBpWnhYbEwzQXdzYnU0cUhI?=
 =?utf-8?B?T1hSWldtcnhkVVJXNFF6Zk5qY1BHVTA1VjVYRGxIS1kxOEJSYlAvNlRZYjhF?=
 =?utf-8?B?L3lSMng1Qks4aVBtb3F6dy9RSDM0N1lkUDkvRDZzYVpudlpNUVNQenR5MXUw?=
 =?utf-8?Q?TvgUbIqL1C7VumfQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d837526b-3f8b-4843-b6d2-08da327b4e19
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 11:50:40.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGwpGz1yHC/oFFeEE2oqEf1cSzfWM9wKvAcREy18iitie09wGGSM8caTC7ufdR7/aC1B42UoH6qJqtml3W10aBcKdONO3uvBQ+kI4MQ7CRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4064
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_01:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100053
X-Proofpoint-ORIG-GUID: ZQ5L3DHlF4pZRqF7pepcfTfewOPoYcPb
X-Proofpoint-GUID: ZQ5L3DHlF4pZRqF7pepcfTfewOPoYcPb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 02:38, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Friday, May 6, 2022 7:46 PM
>>
>> On Fri, May 06, 2022 at 03:51:40AM +0000, Tian, Kevin wrote:
>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>> Sent: Thursday, May 5, 2022 10:08 PM
>>>>
>>>> On Thu, May 05, 2022 at 07:40:37AM +0000, Tian, Kevin wrote:
>>>>
>>>>> In concept this is an iommu property instead of a domain property.
>>>>
>>>> Not really, domains shouldn't be changing behaviors once they are
>>>> created. If a domain supports dirty tracking and I attach a new device
>>>> then it still must support dirty tracking.
>>>
>>> That sort of suggests that userspace should specify whether a domain
>>> supports dirty tracking when it's created. But how does userspace
>>> know that it should create the domain in this way in the first place?
>>> live migration is triggered on demand and it may not happen in the
>>> lifetime of a VM.
>>
>> The best you could do is to look at the devices being plugged in at VM
>> startup, and if they all support live migration then request dirty
>> tracking, otherwise don't.
> 
> Yes, this is how a device capability can help.
> 
>>
>> However, tt costs nothing to have dirty tracking as long as all iommus
>> support it in the system - which seems to be the normal case today.
>>
>> We should just always turn it on at this point.
> 
> Then still need a way to report " all iommus support it in the system"
> to userspace since many old systems don't support it at all. If we all
> agree that a device capability flag would be helpful on this front (like
> you also said below), probably can start building the initial skeleton
> with that in mind?
> 

This would capture device-specific and maybe iommu-instance features, but
there's some tiny bit odd semantic here. There's nothing that
depends on the device to support any of this, but rather the IOMMU instance that sits
below the device which is independent of device-own capabilities e.g. PRI on the other
hand would be a perfect fit for a device capability (?), but dirty tracking
conveying over a device capability would be a convenience rather than an exact
hw representation.

Thinking out loud if we are going as a device/iommu capability [to see if this matches
what people have or not in mind]: we would add dirty-tracking feature bit via the existent
kAPI for iommu device features (e.g. IOMMU_DEV_FEAT_AD) and on iommufd we would maybe add
an IOMMUFD_CMD_DEV_GET_IOMMU_FEATURES ioctl which would have an u64 dev_id as input (from
the returned vfio-pci BIND_IOMMUFD @out_dev_id) and u64 features as an output bitmap of
synthetic feature bits, having IOMMUFD_FEATURE_AD the only one we query (and
IOMMUFD_FEATURE_{SVA,IOPF} as potentially future candidates). Qemu would then at start of
day would check if /all devices/ support it and it would then still do the blind set
tracking, but bail out preemptively if any of device-iommu don't support dirty-tracking. I
don't think we have any case today for having to deal with different IOMMU instances that
have different features.

Either that or as discussed in the beginning perhaps add an iommufd (or iommufd hwpt one)
ioctl  call (e.g.IOMMUFD_CMD_CAP) via a input value (e.g. subop IOMMU_FEATURES) which
would gives us a structure of things (e.g. for the IOMMU_FEATURES subop the common
featureset bitmap in all iommu instances). This would give the 'all iommus support it in
the system'. Albeit the device one might have more concrete longevity if there's further
plans aside from dirty tracking.

>>
>>> and if the user always creates domain to allow dirty tracking by default,
>>> how does it know a failed attach is due to missing dirty tracking support
>>> by the IOMMU and then creates another domain which disables dirty
>>> tracking and retry-attach again?
>>
>> The automatic logic is complicated for sure, if you had a device flag
>> it would have to figure it out that way
>>
> 
> Yes. That is the model in my mind.
> 
> Thanks
> Kevin
