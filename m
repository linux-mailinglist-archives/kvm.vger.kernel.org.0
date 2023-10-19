Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842577CF56D
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 12:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJSKdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 06:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSKdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 06:33:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3674D119
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 03:33:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7OFZG010771;
        Thu, 19 Oct 2023 10:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=N8C7jxcvbYWChZRCjdMImpTy0idAXuoHZvq4hXBrBwg=;
 b=uZSIaMwrQp4tnVoW60za4qkCPRUcbV8cOUovwG7S+KNB6CGPrikPf+QCln78t0a1rdi4
 JsXawEu3yKfil2FrLrvSk4h9KgMxjZydq1ljj4w7m6d9QTWsYiAhtAbKnVqBJLG/22kv
 iRABZJVJWCc99VSKW3aoWDpGb3O3CGlXdkQ8IEeArwDsMX/qVVMd3PsGkyDEbOE4W47O
 LdzBLY5ftQPrybgU4HI/HOTMIZ58lxklWQB/raEbj9JXtc6c7LiFUIbkZ0epLfID5C8e
 qYBBGE5q/C7Br+ZVIpf4DzNmNJ0m/NFopoWk2LsAILY679LXDvrCpL3Fo/SKesoBGKPz 0Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1j9nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:33:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JASErF027127;
        Thu, 19 Oct 2023 10:33:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg56jryk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGL3zzyF8V1UH+TtS+r/zwSF7kLSLLDR0fPC2ihBnQh3ZiLrADbcM3+KjWO9KvpsU4Nr0HVgmeGcEw8+ksB1WikeZ1vx0jHHzuhAlpXt2ivcRGvWn9M5f77MDL+ZyLRZqihNVxkMVbysJR9L+ngQHJvoWRK7zbep++7Xi445cpK3fwB2fWxzFTwkTB63Dcu0z8bsbZ2BUX5v9LhhkJRdecqPijvoUwRZtQ82FxUN+MHwNL5peKyFciBBnrqIHb5QdWRJZZc39KgnGbDzWBPicVwpD2Mg34rp4OTqyeSnJyQ4yMGVazcA9a1nt6L6eW+mJ4NOtUiunZ5voEHSr9mtIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8C7jxcvbYWChZRCjdMImpTy0idAXuoHZvq4hXBrBwg=;
 b=SYL2fOIAYmeGD8Z+23wQihpmtV0MjFq/ixkEtAsDB/bLMucrUNZYqv/v2Xn4XdwiS4Dbiai8QPLe2NffemD/p5dBFyvk+2DqBFEujmJSAHJGV2LN/zJnW7k1A20Nuy20uXmUGQrP/IUFeJPaT/n/Es09UAZ1/azR29WwMbsgfxwXWadoojG1sBuu2YX2ciiIF6VyydB35Df64kNEO2/0uscAn4fOhsBi+Jh8+WZqg+XMkd2W3rceS7fWKwdPjowHX8smu4AnbXvnLIJB4UIaqph/X5IzfVJu0lvgkXA4JW1N+uwuz8kVRe51iZ231JLGMa7aqfjrhOukODJU6nE71g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8C7jxcvbYWChZRCjdMImpTy0idAXuoHZvq4hXBrBwg=;
 b=Idnp0JaPtqM/l8u5dqkjxJghfKHV0AV/O5VWAQU2RrL5OJUWHvttwezc38jPVST5y7XDP8YAmhT5duJgzp9eiGhYB70kgDwLVkizmPq+nR/oAzh2oy1nvNK0MruYL43fJ0DR4D4Fl6L8Vp5k6K8wpGy4peVZBadwwn+E4uGF2Rk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Thu, 19 Oct
 2023 10:33:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 10:33:16 +0000
Message-ID: <6fbbe400-fcf8-4860-9113-c534c3d46f5f@oracle.com>
Date:   Thu, 19 Oct 2023 11:33:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
 <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
 <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
In-Reply-To: <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0031.eurprd04.prod.outlook.com
 (2603:10a6:208:122::44) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee0bfd3-eb1a-4119-77b6-08dbd08ece2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TznxHe9YsuU9kydJOejb0YYDi7xBbLo0wHSI7ezdfx5AO+41LMIqDzuDLNj+KWY6kfv+PjxUQQSn3YxrPCr8C0qOOTVmeqGM298AcU0wazCAxRXNmJ1lRo3GsoYfyv5Tl7pSfqe/AkLoBwFecaXQGtoRnghvJIA5+g73BAbuLmVleCrqHjijibQk7HsQOnYK2McpER63chB067+VsmEnrsogQvqeni2kpvIUau/6Ms5b6Z5QrKMRW0Xs82c3KDkIjk7aisE0DBuYg1y7cp8dG4BqYEGjP07SmDGvUOjhhLGhoCcuMycPLwTLagBiw9QLoYYZnhAgwZC6v9AyNICO7irxNxjdxxs9vPZlGMco6gH+bSZvI8/ENxyVkXg8IAJFIf5jUrlvvnaw4O10es3Fpf563byuKAHon29fgP/6a2QOWh4XZvbSI6uvqfvp+VCSozsFelRcIGLvj3FUQUWE4DJgz4zqpHaug3BCP8qKGpXVvE7eYs6NiigxozNEwQiHhtizosQXxIY/E15uzb3GiEayhV+ebsC0fCQFFejTJjlPjf8b0cADhRHygOiTiIJrJqErAv0LKEksHfVN+LuWc/x0V2b9cRKYG8aaFUA1OIhnwswTeEHGRX7OE+P5Y7c6Mezrhz1scqp5wFOuHNj6vBjaS7K3tl9mMGy50cCCf4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(2906002)(53546011)(6512007)(31696002)(6666004)(6506007)(2616005)(54906003)(316002)(66556008)(66476007)(66946007)(6486002)(478600001)(86362001)(83380400001)(26005)(38100700002)(7416002)(41300700001)(4326008)(8676002)(8936002)(36756003)(5660300002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnBVUkMrcEwzSm0rSUIzdFUrekdlRUtrOGhGNVBtRnhGMk1qZlZwNGYxcWJy?=
 =?utf-8?B?UlEyMUNEbGVJSFV0QlVDK1lyZ3lVNE9DQlJXZzdValRXaTkzQ1BURjEwRmI1?=
 =?utf-8?B?YkJRTEJ6eTl5OXNtTTQyT3V4dUU0WXgrdi9YVGxOQ3VmakxsRXM3SXlCSThJ?=
 =?utf-8?B?SUIwZDhQUWxkd2tXdmFlb3JQYytnUmdTMi9PZzdmSDVtcjU0dnJPOCtabmkw?=
 =?utf-8?B?SlNhbzFJb2JDWlpkQ0dqcnovNWk5Zi9ob3owUkpLNlpEY0pEQ2JTc0JHbXQz?=
 =?utf-8?B?bTFrcTJVMkN6aDFWUUJIaFg0Q2JvbCtBa0tqLy9obVlIcEVTQXU1a3BHWmtC?=
 =?utf-8?B?VXZhU25vWDVJejcvU0h4NmZnRytnY2k5SmdCYitBVWZqQ0FiWHA3RmFNUlBt?=
 =?utf-8?B?dFZ4VURjemtBMDNSZUJTWkpncVJhb2NRV3dNL1BweG9QeVVaRm9hK2p5Rml1?=
 =?utf-8?B?cUpXTG0rY1REdXFNZ1g2aWQ3N1oyRGw0bWhva1F0WmFhNzAxRm91Z1d3LzRH?=
 =?utf-8?B?RkQzNDdPaEhUWXdCRTlIOWhSU0ZNVVMzZmViQW5HY1RDeUF5OWM2MGhQUWVF?=
 =?utf-8?B?ZXN3RFhrV0VzUkJXcm5XMzQxemkvdHd5ZkpvT2E5QmpUTDFwYkVGczd4ZDBP?=
 =?utf-8?B?eWMxMUd4MDZReGJlRFFySzVEdDVyUkJlNDVmc1hSZ2ltQnlTcVQ0UVFRNmZG?=
 =?utf-8?B?d1lTZ2RUS0lqUFNobHJRYWhJSkRWTnVEemxweUNSc0FmMVFPbGtwRVR1bU1r?=
 =?utf-8?B?YVNUMDJvdXNIUlpodjRYd1ZtQXhnTUs5VGgyY0ZoWlN1NDZkWTcyRy9NTnpZ?=
 =?utf-8?B?MFpVRkIyY1cyRHRnb1NjUCtLeXlUM3l4dUdhaUhRMXR4Y1hNbytxdW40N2RG?=
 =?utf-8?B?UGY4VGRsd0NqbThkS3cxMCtuMElQQmVJRDJaenJ6MjhYeGx3ZHVnakNNakZN?=
 =?utf-8?B?SVVIYU8yRXNrTklqOXU2eU04cEtaVi83aUlhS2RmTmNjNGYyaC93NVVGVCs0?=
 =?utf-8?B?bjlFT3FjT01aUVdRR3EwTTdUYXRSRG1ic0k1OU16cGNJS3Iya1pBKzRxeHBF?=
 =?utf-8?B?VllRWDlXTHJ0VWhYbGVkQVUrT1NBTldmazF5MnpCZ2VGSG9ITHJjM2hhcFJF?=
 =?utf-8?B?R2dNQVBtTGRFVkFYRHNXa2xVKzFMd2hxUHhZak92d1RvbzVIQ2JkSlY0aWNC?=
 =?utf-8?B?cG4yQTVHKzdvUzhqUjhtMGRzbm93blF6SUJFZXFYMHVaV2lRTU80MFVYbUtN?=
 =?utf-8?B?akt6cGlNbVo3Y1ltY0xQWC95N3ZPTVgwU0EyVER2b0xKc09rekk0QnFoYm5z?=
 =?utf-8?B?N2xQZjFYdm91QUIvTXVMZ1c5bzI0OS9Ed20yWGN0eDduSUo4cU9yc25WNnZv?=
 =?utf-8?B?aHBXeVVOY2pGQTdkeXFIa3JaS1h1V3Fuc2RtSzcyYVNERThIWVlObGxjVUlq?=
 =?utf-8?B?OU9FeGFuTUNwZHBoYXdEKzRKT2dhYlZsSmtvNHpLL0wwSTlyUjZ4L1ZrM2R2?=
 =?utf-8?B?NWJCbkxzUjZNd2pjZGp6NTIzeGVTdWFuaU5ZdnZMVmN0cXo0dnZpeGM4VDZ4?=
 =?utf-8?B?RkZVTWFYUkhxUDEycy9ScE9DbFk1U3RCaGVZMXVWQzNmTHhHRFF6T1d1K1Vt?=
 =?utf-8?B?a0s3UmZkaTJPVm9jc29UdkVLVnluaFg0V0JYZlZpcVhZK0N6NVNETkhCZmdi?=
 =?utf-8?B?RG1SSVNqWkxHWlcxUzB5c1JmOHFralE3MXBnLzNMbnRvVzRuMjJzWjNKUkVM?=
 =?utf-8?B?U3hlNi8yODcyRnZaQnorbTd3alNDR05BcFBhS0lBNXJIdHBEb2pSOFNFWnov?=
 =?utf-8?B?eHl5Smt6c28ydmtXa0ZXNkpxRDQxamNsQ3hTVEZicTNPR1I0aHYvT0FaVGJj?=
 =?utf-8?B?elR6MVdrZERnaHFRc0lqSVR4QUhkZkx3dThCak9LdmFmNEhDOUtiU1RsNmtC?=
 =?utf-8?B?ZC8xMzZlMG5SL1RZNTlpNGQ5QVBqMHh1YTFmZG1KRFI5TW1IQW9BQlJJcU43?=
 =?utf-8?B?SzJ0TmRyTXBlWVZEQnhwc1V6dEhMeUFFc0tCL1pMUHRMcHlpWWFHY1dpdGNQ?=
 =?utf-8?B?Ly92empzeG90b2ZZdlBVOVFlYUVGaTRUUUw2Vm53ZUoxNlYrV0t6a2lOa1N1?=
 =?utf-8?B?Ny8rcGloNklzYzhkc3NkRDJpM21MRnRUNTVob0FEMWlCRm9FWEtraFYxNWNM?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?a0c5Zm1ZUERPQ1V1UTFzN1VKb0NpUzhxcW9hVTVsclpHRE9ialpJZEVoMTY1?=
 =?utf-8?B?YU5Ebi95dmpySyszZENXdnhnaVF5SW56VHdRcTJLLzl5WkNlb0t0eWFOaWZF?=
 =?utf-8?B?VmNjMERtSitHdGt2MDF0bFJaTEhIUDZqK0dweHZCTlZRZ2QrN01hQkQ4UTBw?=
 =?utf-8?B?ZG92YTYvNWF0d0R3R2RoTC9FNVZYdlpiR1BNR2JDYkZzV1o4TCs2cndMMGdL?=
 =?utf-8?B?WklwaXdSQ2ZxYVdaVTFxVlNEUmMzUHlDK2kra1hnNFIwTWF1dGsvckhlelps?=
 =?utf-8?B?ME1KMDJRS09neVA2K3Jkb1FqTW9hOGozWit1aVBuOVczSTFNdml5M05Celk2?=
 =?utf-8?B?WEI4MlpxTWkvNzMyTmpsUUlyd2orNjdlWm4rK1Q5L1pDWU5WZ05oRDFUbzNv?=
 =?utf-8?B?dFRMVFVzazl6UXF2OHU0VUR5ZCtqc3NtSTZ6OXpQNmtKUitLMk1vL2F0a1pa?=
 =?utf-8?B?UDhqa1dhZ3dTay9wdEhSZ0pjQUIyTngzRjBkcjk0b21NZFVHOU1pZlQzQ3kx?=
 =?utf-8?B?OHkxMzFHRGQranFseThHSUZlYWFkelZnb08rVFlMWTFuSFZpN3hOMWVWb0c2?=
 =?utf-8?B?SHNVUEJrdXFjOTErZ0V0anVkYVZIVHRxeVd5d21qaTVKaU5pVFloSHF5ZFhx?=
 =?utf-8?B?Wm5QWVdkMGRFdndxOCsyMXlpR3l4S3UxL0luclNHUzNsZEkvQmw1L1lZVGU1?=
 =?utf-8?B?YWNqdGQrckxWUUxNbm9zdjV2aWtBZnNaenRseFVFTFBKalA2OHNhOVRmMlZ5?=
 =?utf-8?B?OFdjYkI4dDM5MitZSkFwUmk0cHoycHFVSHJ5R21Dbk1CSjBaSE9OdUJvTTVY?=
 =?utf-8?B?TTJoRmhGZkEvZnp3K3o2bUs1NUMxZTJqSUxQQ0YwbE1KMzQwRjFFMnEyVDJk?=
 =?utf-8?B?K2cyYXhpYlBWc1NiN3JEVW5KdjZXU2VaTEczMXdZTUV3dllNK0JOZk9HZnQr?=
 =?utf-8?B?WE1yTXQ2TlJSbXkyQlB4RWdESW03M2E5aWZpT25RME1tb1NralpVTk9zSXVP?=
 =?utf-8?B?ekFPbWhmT3ZwVytYR1UyVFkxNUZnY0lZUmExb2p6V1g5bWNtNXQ1RXpxRGlq?=
 =?utf-8?B?bUs0NXpSNXNIZDN1TWNHakVJOVpmbnVhTzREOHBMN25UbGFBVTh2RUVXOFhD?=
 =?utf-8?B?K1FzSXA4Q1dJelRkSHRNUmhmSDlLQmtkNWUrNXo3dHlpNnpsUUMyTWF5dzl6?=
 =?utf-8?B?azZrYnVYbGg0MEVMZ3dra0FBblVYbFdkSzVocDF0YVNFSE41K1dyRGU5L3Q4?=
 =?utf-8?B?TlFtUlpxUUpqR21VMHRkOWhCaTdGZ2lQZ0ZwYVYzUFlId2VzakRBUVlCWXVP?=
 =?utf-8?B?NEl3MGdyYUhQWUd0Tm9FZzZyS3hJZ203T3AvSjVKVDliS1NMa1h3UGVPamJM?=
 =?utf-8?B?ZnhZTnlyYTBnV09uNmNuVzRVOElLZEU1VjBsTGVUZ0FPTHR3Z0ExTUZNa1Zo?=
 =?utf-8?Q?bmJ13Ao2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee0bfd3-eb1a-4119-77b6-08dbd08ece2a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 10:33:16.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5WRHQKPTU4ECSCl4A5rP9VyNAzWrQBv0B/dj36LVt0Mx2CQRus4WDU80V+/88kbmdpCVeiPCT4+WB33Yh6LWT14pe1G814c4wWwkkdJETo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_08,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190089
X-Proofpoint-GUID: ChDF_75p-WQmF7n8GjhoMbNyFQ37UKw9
X-Proofpoint-ORIG-GUID: ChDF_75p-WQmF7n8GjhoMbNyFQ37UKw9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 10:14, Joao Martins wrote:
> On 19/10/2023 04:04, Baolu Lu wrote:
>> On 10/19/23 4:27 AM, Joao Martins wrote:
>>> +/*
>>> + * Enable second level A/D bits by setting the SLADE (Second Level
>>
>> nit: Disable second level ....
>>
> /me nods
> 
>>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>>> + * entry.
>>> + */
>>> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
>>> +{
>>> +    pasid_set_bits(&pe->val[0], 1 << 9, 0);
>>> +}
>>> +
>>> +/*
>>> + * Checks if second level A/D bits by setting the SLADE (Second Level
>>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>>> + * entry is enabled.
>>> + */
>>> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
>>> +{
>>> +    return pasid_get_bits(&pe->val[0]) & (1 << 9);
>>> +}
>>> +

Adjusted this part a little better:

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 785384a59d55..deb775d84499 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -351,7 +351,7 @@ static inline void pasid_set_ssade(struct pasid_entry *pe)
 }

 /*
- * Enable second level A/D bits by setting the SLADE (Second Level
+ * Disable second level A/D bits by clearing the SLADE (Second Level
  * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
  * entry.
  */
@@ -361,9 +361,9 @@ static inline void pasid_clear_ssade(struct pasid_entry *pe)
 }

 /*
- * Checks if second level A/D bits by setting the SLADE (Second Level
+ * Checks if second level A/D bits specifically the SLADE (Second Level
  * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
- * entry is enabled.
+ * entry is set.
  */
 static inline bool pasid_get_ssade(struct pasid_entry *pe)
 {
