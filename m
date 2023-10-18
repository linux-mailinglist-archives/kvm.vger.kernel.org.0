Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FC67CEC31
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjJRXjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjJRXjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:39:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53627B6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:38:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIpUcG018517;
        Wed, 18 Oct 2023 23:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qjON5XSQRPG2H0bXpZdSmG9NDVZ8/knmDd4XqXQ/19A=;
 b=iy7Hb3o4qYGLLTIcSryrDvqyVoKK6UCyWJx49d4rdGO+EC42Gb7eKwyj5KHP1g7v7TgR
 xZWhW3eP0h4nvBUBonJ0QO61I1qLaVsNmRye1/U29D/NY/hznh9YsukBdnSAm+uVnU/F
 M8uEEbbFDrw3EdXlYWyNGpkhRUSvGaLQObzhRHRJL4SVoU+cAcLif5uqRfjQrtsKH/vq
 1xRPO4d9XyUPMhvgfKOyzr1VAWp2xpvc8ZTdRs9WEMrb2KH/StjGRVeRX5S/cSSarXXL
 KNnCnbzOvG8n7z6SUWiQUk+56ZPVjLsSV4jq3LM6iPmUqfPPqgfl7fbw7Ep8xwBxjivN rA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu8vq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:38:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IMhKt2009052;
        Wed, 18 Oct 2023 23:38:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0pxmqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iU9xJd2fKRmXmLpncqwxGJYz0Om1adZmQnwp7AhH6z40PPD8mCnOYGg1IXpkQaPKpgwcVsNbK2xyDh93nz+4nukEAiotM8b57zK/Pn4r53ug6kCKbPlDFiDKk1HYb+H5Z6xm8+lu99iwKXwP58j3N5wNuBH2mFSXkARIAHMY3ApgNad8chP5MkIc+NKhmwyxchi6B1VIZFMfzGEGzbjQWHRP+/hAr/MXUi9PKY8GqKlBWIqUaQ+Yzjr5UTC+QbeIz3Cz6t92+v/QweEt8BDi1+dTTWLO16OkCnbKOCe95rqPPKArPQeAKVguyifFfUlF7kBkRBhr3j0gtPQ1Xi1Tuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjON5XSQRPG2H0bXpZdSmG9NDVZ8/knmDd4XqXQ/19A=;
 b=FqzoYSqTEM4DZrwOsLylw9TK/84EyA/soImjhzTvwiUjvGLy+mG3D3QcJwEZsfMSENCuYZb130hFgaWEYvBOgG0Nb0jwI0dBNzdpYQRaqE+eSkEj7susMbyQ9ojYWnDHWciZ8a8e/Ltj65utc9n3HT+OgabhyTly2PUTcNpTbC2Fd5obeLK5r0P73x/q3CnrHdgGT57CO6PSPLswN42t7kv5JD5zCxtuZGH5DqqbV4YRi+PpDoB/zu3Xv5oaTySoa4SMpY8vx9yxWikkxmOl06uWSyumpsQcXFXQzLfidmFYdFyKgwAM/6r4dfcmydLXLuhmEuDRPdE4ItNORUjoZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjON5XSQRPG2H0bXpZdSmG9NDVZ8/knmDd4XqXQ/19A=;
 b=sFHd8gfI3DEyVZRgs+L6E8cEoX4oQNC35U3ZM+BHc/yFK02cWB/CDwg4zFDQTZDHB/TMJpopik2WVCD1OOpPShzPFU3r/BSP//sG2FtkRiQyxhaXwyqlWSmeu5sPeuW0XfSN8E81SA3yJJ2jSPcTv/gKn0UbpBc8QbBmmGANL9o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Wed, 18 Oct
 2023 23:38:36 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 23:38:35 +0000
Message-ID: <0949e1b4-422c-4bcd-bcc5-96039690c050@oracle.com>
Date:   Thu, 19 Oct 2023 00:38:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking on
 attach
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-6-joao.m.martins@oracle.com>
 <20231018223831.GA747062@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018223831.GA747062@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::32) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS7PR10MB5344:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e8ba4e-2a14-47ce-fb55-08dbd03358e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pf6vbY0HmIC5iQftBJfTy1LXHdXuIWCOtWiuobOLkmrzGOsWrQkwnpMBMi5M5PHCqBbgEWMc4jYB+AKx6KgkyGrDaJ42qB6Tx5BTWlxmDWz0c5Y+3Wkg/e4pOPpJfir2hPwWXZEGDep87/P2zXPsXRDjLXF8XCSn4+I+qb1zRqNz2MwLYYtp/Ke2ASbUDnBZ60jUHqShUjGvwEqHR7G5pFIioy8Ap5Dm/6qchgfhGkZ1BabCjz9uFZvpALLBTaBHuKxBlXOqeIPeEOqtKaCd8O/g2gGx+bPI5AvX1R3Xr5BEspffNFc6o/YsLjCrw/zjkzYwZMTcjjrm2VG1WQnnwi+9YXnXzn6Z+E0fKFo+byg4i+DvHFgaj//RTnIjYAusT2oe7Z6beyrPzBBWJkEY/AkWwgB1lsYktHHxe2aJSZpKsoi03gFWp7dWJpqxJfG/s2NKcNVgvDNK5Yiqn0TUzkLPf5Z0zomM1qCz4hH5HbAjlxG6rXjGVG6apDA+PN9OCWNq5gb6Bt0xCxwTJHNikW1okJfLXjY91oXPbpXtCQeLGK9TF/5goaxYRh9TxKiL1FHjCAlCq+vjahRXSqSRLsW9QaHScynnBZew/fvrC0PrTct3HvCSSkaLKe+EyPadhm8efAJD0u2fkoKHFwglRV18VfRL/mI3acHTkhY2N8s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(376002)(136003)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(6486002)(2616005)(478600001)(66476007)(38100700002)(66946007)(66556008)(53546011)(6916009)(26005)(6666004)(31686004)(54906003)(6512007)(6506007)(316002)(8936002)(41300700001)(5660300002)(31696002)(4326008)(8676002)(2906002)(86362001)(36756003)(7416002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU5oa0Zmb0xRUmxjNEhUUSs5R0srWVNqNDNteithWHRqWCtPTVJiM3RnWmZG?=
 =?utf-8?B?dFN2VUU1bWkyVmZ6Ty9tdGZDQ3hza0FSUTNDNWhtdnBJN1BPdzFwN3RvME1n?=
 =?utf-8?B?RENEZlBZbTZIZmlVMFIyMkwyVjRvY2U3WmNNQVR4WDN5Qk1EdVg0TnorSDRZ?=
 =?utf-8?B?bVJOdW1RK0Nud0tRdEYwUTVGWUJRMis5NTYrTTVqUDJFcFRSY2Q2eWo2REdV?=
 =?utf-8?B?MWNndndVTUJ0RDVENjU3ckhNY04yNkRTUVlia3FHQjZlYTFSMFE2QVpWcG4w?=
 =?utf-8?B?S3pNYnVhRC95a2RQMk5Nc0pDVmNuM1B0eTBQMkp1d3BXUklwVkFIbXkxNm5V?=
 =?utf-8?B?aXFkTW9NbUdwY3pHdThHUHVxdjVHWmhrZW5mTzhMNTg1L1dnaHJmcmoyVVNT?=
 =?utf-8?B?bU9wTHNNVWpxdHU2K2ZjdUpOQ0o0SHBDQTZBTzMyNXpGd0t2dlFoQ1F2NzFW?=
 =?utf-8?B?Ni9XeG5IYjVpZ2ZUQitPUVd1b3hrNWVsR1J0ZTJLazBxK1pmOTVsek1RRm1u?=
 =?utf-8?B?WTZZOGVKOWt1QkFWWit2akdhelJXUTNVMnNnZ3F3RUE2L1ZIODc0ang2OGVn?=
 =?utf-8?B?dkdqazhkTmcyNGdRSG0ySDJ4UEJiYzdRK2Jzd3kvTVBtYWNjVmJvL3plbXhj?=
 =?utf-8?B?Uk95a2pZVDgrY2pOR25taFpjWDhaRVRoQmpYU0pyRHZSZEpCQ21KTkFCUTRV?=
 =?utf-8?B?WDBNWDBqS0tNTXMzVFM3MWhYTG84VjV0WEg5SlJOSHd2bWNtOWxXM0VHY1kx?=
 =?utf-8?B?S1RXRHc5MWVib0pVaHVZS0NKSDZjU0M1RTcrVFJiNjRrNmxOcS94OGlQcGRx?=
 =?utf-8?B?bi83U3NuU0FtUk1FKzZOb0VKTzRJYmZJT3ExTTQvMlRJdE95cnNLTVVGWGJR?=
 =?utf-8?B?Z1phVU1yRnBtN2dweVY3OFRzSUNraG9tNzg4S1RvWSs4NWJLQ0xrclBBVEgv?=
 =?utf-8?B?czF3bm9zbXZqRDZseFlGK2xHZ0xUVERIcjhyQmxoNy81TmpVWHJTTnZtRUd1?=
 =?utf-8?B?ZUZvQUVzY2hRMTlhT3RjbUM0MjZkdHJLUG5kV2ZTUzdLbUZkSjZic00vSHJp?=
 =?utf-8?B?VlplOXJhV1FjVng3Y25tMzJ0cGZUVmxvOEpjZ2tqK0xWNEFYVjNtOUdjTFc2?=
 =?utf-8?B?OHRWZ1JoeXBrZERhUDk0RkFOTmRGQ0RqcDc0VjJjNUo0b0dGQkFrYVVHYjFt?=
 =?utf-8?B?Q2NUTkFtRXR6QngwM1hNNjlSNFhXTkxxU1JwZG52VkZmdE1Pb0dIVTJWa0pX?=
 =?utf-8?B?RnRHWWROK3FQVXBBQzZPT25UblJuRGtSVCtITUQvRWJ5UHB1ZXplT3A2ZC8z?=
 =?utf-8?B?Mjc0VUxTdlNOc3dlMGh6TkV2WmtJZ3RLRW5zdU03aEw1Zmh5TC9lSTUyUjUz?=
 =?utf-8?B?WWhzekx6T1Jkb2tOclAwcXI2UFF3QWs2eGJKSGpRNFUwSWdqRTVxelVheGNO?=
 =?utf-8?B?UEFZcXFGQ29ma0cwYm1XUTJWTzRJN1Mvb2V6WTBYOFdyb3ZLaWZOL3A3cmI0?=
 =?utf-8?B?azFnSmx5eCtnZDBBNVdreS9KMW9yeDFpYStjdkZsMFBQbXZzeWk1SEc5L0tw?=
 =?utf-8?B?c2lpYzZPUVYxajVQTmlnQXIxdlh2OHdUaGZSbmV4Zk83RDk1NUhPK09XRDJY?=
 =?utf-8?B?MWcyVVJsbmNUNjJON1kzbGJuTEM1SVE4ZDhxWmxhOVg3VzF3b3MwS0pRT0pi?=
 =?utf-8?B?UGh4RktRZlFLVXpIYVk4M201N3J5TmJoVGRBUnZySVl2SzV3WjJ5alhEaHBu?=
 =?utf-8?B?VUY5Z2xBak5CVHpiQmlwZzd2dWVkVEpMVXVDSE93OTAvdlpRUWdTMENOeDZO?=
 =?utf-8?B?VGJ6NERsRUVUYXBhSUJkeWxMdGtkVENNN2xBcmlUQ3ZnWWdpUFNFRFFIS0pL?=
 =?utf-8?B?ZElZbURtWXgxMWlTYjc5b25Dd080QU5GUkVQZDB1Z2hTOHR4UDBJb2dYWDBp?=
 =?utf-8?B?RnhxUmczY1RhcFNGeGVIKzV0ekpOZm1Lb3FBby9tK2pNaHZVY1Vad2I0RlZ4?=
 =?utf-8?B?dCtRV1hTOTVZdUVJa2taQ1JvdGxPMzJicjgvZlFXdGgwd3k4bUNzUTNQeEM2?=
 =?utf-8?B?c2JoSDdhNCt5Tk5LNjNaalcwRWJwdnZheFNoaUZoT0RuQTRMM2ErVi9NTDlL?=
 =?utf-8?B?cVoxYXU5N21hNjIxdkdsbXZ3dTZ1WVMzRnQ1Kzd1ZDd6L1Y0Z3I5RHRhbnp2?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M0Erd0RodW5ITlBpZGJnNTFEVlp6dVJqWDlsZFJhTDQvYUVqMzJESWErNnNr?=
 =?utf-8?B?bHNhcFFOWkt1SmtsZWRhbnFpWVljNEdSU2xNVXZnV0lVWDViWGwzWVJaeHg1?=
 =?utf-8?B?U2VxeDhmVkRsMCtuTXZET1MrajZFM3NnK0RYallaQ3ZwTUNQLzVqa3JCY2p6?=
 =?utf-8?B?dkZlMnFjN0hDVlFJekFtWU4zckIzaXVZVU9DZGxjZkdqRjJLKzJVNjMwRW1n?=
 =?utf-8?B?dlVCZ29mQ1h6a1dDZHJ6NldsWFpWanE1N0NvdFo2N01tcFN0ekFXZXRKZTIz?=
 =?utf-8?B?MGE3V3B0dENHQndaTFpCZ2wyb1E5ZFhaQlR6L0VYVUxpUW1lK0tya1hkTUE4?=
 =?utf-8?B?UDJHS1Uxb3JlaXNDaWpGSG5FdXFMRkNTYTZ1blZrWmxRTWRDZ3FyWUZmWFFE?=
 =?utf-8?B?NEM4R0g0QUsyaG8xRlJaTzZHMXo0cjg5RkMyVlIyUmhWc2pKVzQxb0JraGNt?=
 =?utf-8?B?QmcrT2s4YU1GdHU0bXNZUzF4b0RiVTFjZUI0S04yWXJSLzQ3Slpoa2k5MHhy?=
 =?utf-8?B?OVppVThETXdsS2ZESXJuZkx2c1lsTG8wcnhoWHJveEhWN3hkRHgyWEk3ZWc0?=
 =?utf-8?B?Z2JYT3BOUzBYK2I2TExlNmE0alF1NUZEaWV6ZWRWaGRJb1Y1d2VoTWtmMnVu?=
 =?utf-8?B?Qjh5N2UxRk1hTzNLL3FEekZITGt5WXlWZzNtWmVqbzhCZ210cWdSYWVJY3Qv?=
 =?utf-8?B?QXBqSnpEOGUxK1dYUE9Gb2ljdllnT280RG1ZWjFZdENoczJXcCtTWWNPd3gv?=
 =?utf-8?B?M002WXZTYjkyOENZaHFvQitiTERTTEZDNnRXeDhBVmF1bmpXMG5uL3UwcFl1?=
 =?utf-8?B?L2hHMVIvV0xiS1VrS2kxUG5tYnFWbTBvN3F1SXV3b3hPWEJmVk8vTTdiSnNY?=
 =?utf-8?B?dlVjVE43V0dPT0JuYm43TlkySTZFR2ZOQkNCUzVPS3plbkxVK0tHWDVuSW5w?=
 =?utf-8?B?Z1FpSnEyTHlrQU5MMFgvTkVtb3J2RUxpUGsvZExEWjNGbE5Ncll6c2lLSnBj?=
 =?utf-8?B?UUNiTm93Y0N2ZGRCZjgrVnVkOVNXMXNjb1g5eEFuZ2hIRmF3QnNxQy9DbTR2?=
 =?utf-8?B?YmFIMVVxYzhjd0xSVmtZZ0dUQXIwbm04ZVAyeUpCK0VSWmg0N3c2RmxEclJE?=
 =?utf-8?B?TFNvUVhmNlR4UkwxOHg1TWVmNTBhRlczWkpKOGk3ZngvNCtpMjNISVV6MWpE?=
 =?utf-8?B?aFJESVFEMDVRS0JnV0NIVzBRWmtJcGRuei8xSkRXWE1ybnVzV3BybWptVkJa?=
 =?utf-8?B?b0ZmUi9BNVA0MHFCOHVyMlQzbnV5M2ZRU21BZ0xwSloySDNiQmp2cE4wV0Ro?=
 =?utf-8?B?M2Jjb29aaWRxSzI4cDB6aWVjaEZKeDNPRGlIOXFndzk3a1VyeHVUWlFyVDFt?=
 =?utf-8?B?a2RibEl0alFjVWVaaU9WeTFDTzd0OUhOelFNUFpBMTBsVG5MR0ZTZDl0U3VG?=
 =?utf-8?Q?8isCgAyH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e8ba4e-2a14-47ce-fb55-08dbd03358e4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 23:38:35.8657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ps/lOPiRgs6aghJJz9dJ8OP5YZkx2b+89dZYFQtXIYUNOp0keix+IyTp2evrpMBRTVC6t83yPIoz8lAuN1hYBSfeSg3qtJFaFQYsrXSKHSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5344
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=723 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180196
X-Proofpoint-GUID: KG8UNthGfK0d6XoA5yN5ypOW5jMmJRO8
X-Proofpoint-ORIG-GUID: KG8UNthGfK0d6XoA5yN5ypOW5jMmJRO8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 23:38, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:02PM +0100, Joao Martins wrote:
>> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
>> guarantees are needed such that any device attached to the iommu_domain
>> supports dirty tracking.
>>
>> The idea is to handle a case where IOMMU in the system are assymetric
>> feature-wise and thus the capability may not be supported for all devices.
>> The enforcement is done by adding a flag into HWPT_ALLOC namely:
>>
>> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY
> 
> Actually, can we change this name?
> 
> IOMMUFD_HWPT_ALLOC_DIRTY_TRACKING
> 
> ?
>
Yeap.

> There isnt' really anything 'enforce' here, it just creates a domain
> that will always allow the eventual IOMMU_DIRTY_TRACKING_ENABLE no
> matter what it is attached to.
> 
The 'enforce' part comes from the fact that device being attached in
domain_alloc_user() will require dirty tracking before it can succeed.

Still your flag name looks better anyhow

> That is the same as the other domain flags like NEST_PARENT
> 
> Jason
