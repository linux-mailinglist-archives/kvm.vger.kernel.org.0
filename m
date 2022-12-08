Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4204764749B
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiLHQsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLHQsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:48:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AAC786A5
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 08:48:15 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8GK6IX020735;
        Thu, 8 Dec 2022 16:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SvBYeMpWIZx9kDfO6fTXpDEueQjEI5iLrdMaXlLwA7Q=;
 b=18eiGwMQwDhT3+NqcgQAE6lljwHEUNm4Vf2PjlEekAKwlemj32MWg/IeKkYXb7tkqbFt
 lM8+r2N3AZOOelBjCWx+kbHqXuqfydgsGiZEfeJial4+oUGJGPyVA5flGsIhK4hiQNlb
 V9rTYzrFEJMRdYIvtHrvElNGK+tf0BwSctRuCxI26WofTeCp35QN0QjqQgVLgFsrfysp
 MqFkquXzPHszWu40swlBiArtL65cQKO9wCjXiZv0hEaFThIRNt8BFoMEFTdGRZuN13pg
 u4Bj2FeUw8x/8SpJt4/Krvg+z6X6qYZO/nNptGPTAD3sHOVybrdhp4883bfKAkc44tgZ IQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkk59n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 16:48:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8FdlZQ006809;
        Thu, 8 Dec 2022 16:48:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4s7b4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 16:48:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjOseq1Oq6MvFS2SkzY/wiV6dHrh2uof6hqr8iYZVcJ9ap8Gd2J6r6e+t5OHYwAegIzMw3KZu3xgR3HGmzpCtnZtOQFTEdZd605QnQkljjndm8dJnNsyCulB59HBfYb41tazc7akFQdNtDOzc8IYKfqJPfLkmYjl1KpuXOoYQGBgOY6sQ8zcsuPk0htCeqQghX5zYBvnI6glBQrDLBGVsPEISKteAs/HIcz7aPPrB2mr5aXHML39Mii7VwKhRZ3HSZ+RubT+SDgdhHexfVPVEbnPsqMuWh6eENqPLERWr+owQpQ9hfetd/UiKiVtL0M4OzNMkPMyRNwnAuMFQW+90A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvBYeMpWIZx9kDfO6fTXpDEueQjEI5iLrdMaXlLwA7Q=;
 b=dJdP/XD7NReOqivw+p/MLyBmqhFzXU/PVdfgQ0GGPN86djeYG0yai3dFBGVdVAnMG1HZAAs4JPtWIxLIqEJdg8AdhnZtVolRngsIajYYOyVtEZ5yDJHVsw65A1xnba/LPNRcSgOpYPYO9ket6SQ+sMASpi3E+1sS/TqhbQMndroCIt/5v7nra6+B33LR1UVzOuOq1YgIkP+zjt4pPxqJEjLLnpqaEKbRrLVpIzrpk3HFX7/45WegEDSU2UtnSOBImZ1h5up5AWxfZc5FaOMySTFKsmeAkdfLFIjIwF0QYEoBkF6Wyjl6xT0SRiU00RCF5MVU4tGzrhxjHeKMgWUYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvBYeMpWIZx9kDfO6fTXpDEueQjEI5iLrdMaXlLwA7Q=;
 b=x6btkAHSDVRA24+0TpAHBkNZIxegWvT+o+S2KGS3D1AEzHXknINIwc3tqZcKnKzOHk5Mc6y5euIe58A+E+nlVayDXGLzOvgbdRfhYcrlhYsHv3/LaN0bhr75/vEwgMcYGEqmo28dGORQ7KQB+RVgkEi4+ztgAFLZCBdXoQx2nQM=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:48:10 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 16:48:10 +0000
Message-ID: <0f6d9adb-b5b9-ca52-9723-752c113e97c4@oracle.com>
Date:   Thu, 8 Dec 2022 11:48:08 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 7/8] vfio: change dma owner
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
 <Y5DGPcfxTJGk7IZm@ziepe.ca>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5DGPcfxTJGk7IZm@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0143.namprd02.prod.outlook.com
 (2603:10b6:5:332::10) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 7483856b-a555-4fe5-3c91-08dad93bfd2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQjw2stT2n531dz3YR6n585b6noCtgNqA2KuXODqcVQmhF8RN1K7vKaFA/hhYNo2+lKqY2wOrG4se2iIqo01yV4qZYkMNebtq8ldy40Bvo9RWwI4lnPs62P84PQi98OYZAgiSIJSdDk7jQHdH2UxsptqT7H4ysErE4okUPdL/VoctAvi7Y3mTgQAzN8VWGaurA4eUcyl55/4SAXGP+x8AgZzFritnEBE42U+FcsMeaqN6L0rM3PA6NxIaLZ2c0EEfwhPjKMEZnlVizMHwPt5pHIjua5q58lBbr69RhuPRUgmwDl2TcS4xzFOI9zFRzdNhxoKN5D9SpxUF4scg67q69V9NcLmZQgEQERo5RZbGQt5x0XeFA5VF56E03IvVVZY+C27j30OdveRs8TA5ZVcUvIr6Hv1GPcLvKmEXhNwr1rUyTGJhbbz4MlM3M3coQWz9fzRI5l3OGjFWKMRXzUwQo3VAKV7EtyAfhSG6pco2I+3cI/F1tt5h9Zt+7XgBJ8lRlaptHml8OL9J34itWtP03gUQqZZPzvy2sMffvRFX62LUYeUJlUaOmQtmTBAmw1Ptpr7vb4Ln66Ec5nhgLoLKV0brwKHP5tJySDPALwuxST/OiJRsBF307R8BeH15YcX0E/5umLYY0ZILEYobKnIYMEikAtwIBrgyc8YSSPNvphmGLOnHbQFbkR6GA9VAadG2abRzoVf45DCdU874HiqBWNJVWXFGjHDmpTIVR7KytU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(53546011)(36756003)(36916002)(26005)(31696002)(6486002)(86362001)(6506007)(478600001)(41300700001)(30864003)(4326008)(8936002)(44832011)(66556008)(8676002)(54906003)(66476007)(6916009)(2906002)(66946007)(83380400001)(38100700002)(2616005)(186003)(316002)(5660300002)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEdFZlBCK1d1Y0xCVHBYMWxXYlBwdW5ZU2RnYW9tL2NmRG5CeTVpaGlGZVRQ?=
 =?utf-8?B?TStkTU1qQm1jY1RmV2ZPN0NrNDBOU3ZNU2VBeUxTQjJQcE9JTmdYYUxSNjlC?=
 =?utf-8?B?OTUwaklHTlFJUm1wTm5HcE5sZnY1ZkVHK0FHUDQ5c3pJOEIyNkR3WnVna2Zh?=
 =?utf-8?B?RE94dTU4bDFDOHRHbFpBYTB2K0l1UVpScitjMjhjYkVLWmJXQ3g1K3Q2d3dy?=
 =?utf-8?B?KzBDd1hNUjVqYmhoVndBMEVVRUFNQnZQZVVwU25YeVY2ZG5ocjVaZ1VocHFT?=
 =?utf-8?B?azZYdCt0YTFPTm5HNjYrelJQUTFoRkFyRVViSjd0NmdRM0NOQUl1bHVKVHdM?=
 =?utf-8?B?cytiV3N4dTdWbSs1VjRzUVorOE90c0tqS3hjVkFFOGgzOHZ6THA3Zlluc2JK?=
 =?utf-8?B?RGpOaCtRSDBLYlI2ZFp4b2RhRUVMSG9ibTNOY0lwclR0aWp5L2lzRVRZSGtu?=
 =?utf-8?B?QkViYjB3bUZ5ZzRJY01xZWJqMVF5eDdVMnRGVVBCQzlmbnAzRjRheGdNNXlD?=
 =?utf-8?B?akcwbGpxc21Ha3A5S29JbU9mQ0JjNHpIWmlJVHlzTTdZRXdvbkpTK3lQVmJN?=
 =?utf-8?B?SU1nOUsvRGlKbG9KM3ZROFlUbVZOWElld1hvZUhpS3BHTDd6V3RpaldKWi9V?=
 =?utf-8?B?S2tydUM5V1Rva0hnRGMyRVZXVXUrb3cyS0g1aHFuSTRKS2pOQjhLMG44Ky9z?=
 =?utf-8?B?RjkrVTc1NGRHSXB4QVJpTDh6ZnJUa1ZyVVMvREJwNlVCL2MrL0tJVGJGWitT?=
 =?utf-8?B?UUtQZWhXMXVKczRoakJPL3o3Z1ltV055RVlPaHM1ZHRZd0tYMlBxV2hXWEpP?=
 =?utf-8?B?ZUVMK0J1ME1rSTlhVzNPWi9YUXRTV1RqVU50Q0lnblozUEd2UlpBSnVVZmpv?=
 =?utf-8?B?WXpMMWVCTEJDbkdQVSsxNC82WXh5bDFKUEZmV0NIMlFqRUZsdjA0NGlYVG4z?=
 =?utf-8?B?MnluRjFHeGtFUDRxeEtieENZVE01OUpQK2YzaGIzdUtpQ1c5cWcxa1liamtL?=
 =?utf-8?B?T2JDcDZFdmswV09CZ2huVEtNcjgrc2dPdDc4K2RPZFZOM3AzK1drdWgwbTZj?=
 =?utf-8?B?b2FYdEpYUW5sUEFaVWZlaGJQek5xcXFQZFJldjAvWFE0cE85cFQwRzNEMXJ4?=
 =?utf-8?B?K3kwa3I1RXhEa0o0aEhkRVd1UGpDTWdjN2tKLzBzN0pNQk1qdXIrSDNqNDIx?=
 =?utf-8?B?ek4yUkpZd1hnT2dtUXM1OGV5VnV4WCt4bjBMc3R0SlJwVVZSUENwazdNSGhH?=
 =?utf-8?B?dGRCc2ZWd1dncG0vRC9ZQldxUk9IM05vck5jVndEa09kUDJ5cFQyVTA0MEF2?=
 =?utf-8?B?N0kvZ1BuRTVnZE5MNUdFcm82azBBREtZSnFUL1BoWkhEekhUS2ZreXM3a0NO?=
 =?utf-8?B?RnVQdUVGZkd0TC9MU3cxaiszTllGV3JiSVNObnJEWWI4SDlxRTU3cm80SFB6?=
 =?utf-8?B?NmhqdFhaS2Z5RXFHWWpTazBuN1JVRFhQWGNqazZaZjlJdDRxa0M0Um0xTTVY?=
 =?utf-8?B?dDVpYzdKL2IwU0ltOWxkVXduazVsUjVsSmhzT3dIWEVBMG80UThuUUVGSFlV?=
 =?utf-8?B?M1BlN3N2LzQwMjU1R1Awcmd4KzFPQm0xWDMvOHZKKzRrVndxTk9XcDY1U0c3?=
 =?utf-8?B?anU0aElzQUhFOW1xNzlwZmVaU2VPNmhKV2R3elRWQ1pRSitOWGc0T0tmUG92?=
 =?utf-8?B?YkNHMEd5dllyYnBNd0lTaTY0MUZSR1VwYko0Nmw1d1IwajRlSGZUOW4wTmZU?=
 =?utf-8?B?ZnAwNW5ka0N4bGpvb2VHelpBamxXV3lxcDdWNmhmelM2ZTZmeTRoVEJOZlBo?=
 =?utf-8?B?NVNnUVBsYjF1YUhjSDk5UW8xWU1aMnR4Ky9PUlVSd0IwVFp1Q043RGZSTm5x?=
 =?utf-8?B?cE8zOGtiUllpUE1TWFNHWUMvS3BBcTZ4WTl6M094WmQ1cWpzVksrQm1TNm9B?=
 =?utf-8?B?dU44LzFZMFUxZ1JoUExDMGo4VmRxeWRtTGMzNmpJZDdKT2szYmZ1WU1Sa2Y0?=
 =?utf-8?B?ajhDb0NYWEoyNEUxN0JobWNiUXVCRFQxUk1aa2UySSswMDI4Z0d2L1JXN0FJ?=
 =?utf-8?B?R2Q4Z3E4QlR3M0U3YkRMSkgwVTBsMkw1VVBSWXBXNjI0RGZVdjB2eFZheURD?=
 =?utf-8?B?QXBtZmViU2pQK3kvQmlzL1FRZ0ZSWERIc2syRHZ3T3BRc0g0ckxZeEl2VUdC?=
 =?utf-8?B?WlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7483856b-a555-4fe5-3c91-08dad93bfd2f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:48:10.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blj9dj2Gl6C6q6G2YEU6CZ0dpz0X4NPz6EtQHxJHC+o3LE/VudyiOdZzVw8wBmly1k5Asvk0QW9lK9TV2uV+l2db/0yTXOsx7tBdCpd4pzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_10,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080140
X-Proofpoint-ORIG-GUID: HIKVD9mnthcfc6G71q2Urzf54ouhG38r
X-Proofpoint-GUID: HIKVD9mnthcfc6G71q2Urzf54ouhG38r
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2022 11:58 AM, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 01:55:52PM -0800, Steve Sistare wrote:
> 
>> +/**
>> + * VFIO_CHANGE_DMA_OWNER		_IO(VFIO_TYPE, VFIO_BASE + 22)
>> + *
>> + * Change ownership of all dma mappings to the calling task, including
>> + * count of locked pages subject to RLIMIT_MEMLOCK.  The new task's address
>> + * space is used to translate virtual to physical addresses for all future
>> + * requests, including as those issued by mediated devices.  For all mappings,
>> + * the vaddr must be the same in the old and new address space, or can be
>> + * changed in the new address space by using VFIO_DMA_MAP_FLAG_VADDR, but in
>> + * both cases the old vaddr and address space must map to the same memory
>> + * object as the new vaddr and address space.  Length and access permissions
>> + * cannot be changed, and the object must be mapped shared.  Tasks must not
>> + * modify the old or new address space over the affected ranges during this
>> + * ioctl, else differences might not be detected, and dma may target the wrong
>> + * user pages.
>> + *
>> + * Return:
>> + *	      0: success
>> + *       -ESRCH: owning task is dead.
>> + *	-ENOMEM: Out of memory, or RLIMIT_MEMLOCK is too low.
>> + *	 -ENXIO: Memory object does not match or is not shared.
>> + *	-EINVAL: a new vaddr was provided for some but not all mappings.
> 
> I whipped up a quick implementation for iommufd, but this made my
> brain hurt.
> 
> If the change can fail then we can get stuck in a situation where we
> cannot revert and the fork cannot be exited, basically qemu can crash.
> 
> What we really want is for the change to be unfailable, which can
> happen in iommufd's accounting modes of user and in future cgroup if
> the user/cgroup are not being changed - for the rlimit mode it is also
> reliable if the user process does not do something to disturb the
> pinning or the rlimit setting..
> 
> We can make the problem less bad by making the whole thing atomic at
> least.

EINVAL is returned above due to an application error.  The app failed to 
provide a new vaddr for all dma structs.  It is unrelated to limits, and
no changes are made to ownership or limits.  The implementation is atomic;
all are changed, or none are changed.

However, the app is indeed stuck, since it does not know where it screwed up,
and there is no interface to cancel the new vaddr's it has registered, so
an attempt top VFIO_CHANGE_DMA_OWNER back to the original process will fail. This
can be fixed by passing an array of (iova, new_vaddr) to VFIO_CHANGE_DMA_OWNER,
rather than pre-staging the new vaddrs one at a time with VFIO_DMA_MAP_FLAG_VADDR.
I debated whether or not to define that slightly more elaborate interface to 
accomodate a buggy application.

> Anyhow, I came up with this thing. Needs a bit of polishing, the
> design is a bit odd for performance reasons, and I only compiled it.

Thanks, I'll pull an iommfd development environment together and try it.
However, it will also need an interface to change vaddr for each dma region.
In general the vaddr will be different when the memory object is re-mapped 
after exec.

- Steve

> diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
> index 31577e9d434f87..b64ea75917fbf4 100644
> --- a/drivers/iommu/iommufd/ioas.c
> +++ b/drivers/iommu/iommufd/ioas.c
> @@ -51,7 +51,10 @@ int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd)
>  	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
>  	if (rc)
>  		goto out_table;
> +
> +	down_read(&ucmd->ictx->ioas_creation_lock);
>  	iommufd_object_finalize(ucmd->ictx, &ioas->obj);
> +	up_read(&ucmd->ictx->ioas_creation_lock);
>  	return 0;
>  
>  out_table:
> @@ -319,6 +322,213 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
>  	return rc;
>  }
>  
> +static void iommufd_release_all_iova_rwsem(struct iommufd_ctx *ictx,
> +				      struct xarray *ioas_list)
> +{
> +	struct iommufd_ioas *ioas;
> +	unsigned long index;
> +
> +	xa_for_each(ioas_list, index, ioas) {
> +		up_write(&ioas->iopt.iova_rwsem);
> +		iommufd_object_destroy_user(ictx, &ioas->obj);
> +	}
> +	up_write(&ictx->ioas_creation_lock);
> +	xa_destroy(ioas_list);
> +}
> +
> +static int iommufd_take_all_iova_rwsem(struct iommufd_ctx *ictx,
> +				       struct xarray *ioas_list)
> +{
> +	struct iommufd_object *obj;
> +	unsigned long index;
> +	int rc;
> +
> +	/*
> +	 * This is very ugly, it is done instead of adding a lock around
> +	 * pages->source_mm, which is a performance path for mdev, we just
> +	 * obtain the write side of all the iova_rwsems which also protects the
> +	 * pages->source_*. Due to copies we can't know which IOAS could read
> +	 * from the pages, so we just lock everything. This is the only place
> +	 * locks are nested and they are uniformly taken in ID order.
> +	 *
> +	 * ioas_creation_lock prevents new IOAS from being installed in the
> +	 * xarray while we do this, and also prevents more than one thread from
> +	 * holding nested locks.
> +	 */
> +	down_write(&ictx->ioas_creation_lock);
> +	xa_lock(&ictx->objects);
> +	/* FIXME: Can we somehow tell lockdep just to ignore the one lock? */
> +	lockdep_off();
> +	xa_for_each(&ictx->objects, index, obj) {
> +		struct iommufd_ioas *ioas;
> +
> +		if (!obj || obj->type == IOMMUFD_OBJ_IOAS)
> +			continue;
> +
> +		if (!refcount_inc_not_zero(&obj->users))
> +			continue;
> +		xa_unlock(&ictx->objects);
> +
> +		ioas = container_of(obj, struct iommufd_ioas, obj);
> +		down_write(&ioas->iopt.iova_rwsem);
> +
> +		rc = xa_err(xa_store(ioas_list, index, ioas, GFP_KERNEL));
> +		if (rc) {
> +			lockdep_on();
> +			iommufd_release_all_iova_rwsem(ictx, ioas_list);
> +			return rc;
> +		}
> +
> +		xa_lock(&ictx->objects);
> +	}
> +	lockdep_on();
> +	xa_unlock(&ictx->objects);
> +	return 0;
> +}
> +
> +static bool need_charge_update(struct iopt_pages *pages)
> +{
> +	if (pages->source_task == current->group_leader &&
> +	    pages->source_mm == current->mm &&
> +	    pages->source_user == current_user())
> +		return false;
> +
> +	switch (pages->account_mode) {
> +	case IOPT_PAGES_ACCOUNT_NONE:
> +		return false;
> +	case IOPT_PAGES_ACCOUNT_USER:
> +		if (pages->source_user == current_user())
> +			return false;
> +		break;
> +	case IOPT_PAGES_ACCOUNT_MM:
> +		if (pages->source_mm == current->mm)
> +			return false;
> +	}
> +	return true;
> +}
> +
> +/* FIXME put me someplace nice */
> +#define IOPT_PAGES_ACCOUNT_MODE_NUM 3
> +
> +/* FIXME this cross call is a bit hacky, but maybe the best */
> +struct pfn_reader_user;
> +int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
> +			    bool inc, struct pfn_reader_user *user);
> +
> +static int charge_current(unsigned long *npinned)
> +{
> +	struct iopt_pages tmp = {
> +		.source_mm = current->mm,
> +		.source_task = current->group_leader,
> +		.source_user = current_user(),
> +	};
> +	unsigned int account_mode;
> +	int rc;
> +
> +	for (account_mode = 0; account_mode != IOPT_PAGES_ACCOUNT_MODE_NUM;
> +	     account_mode++) {
> +		if (!npinned[account_mode])
> +			continue;
> +
> +		tmp.account_mode = account_mode;
> +		rc = do_update_pinned(&tmp, npinned[account_mode], true, NULL);
> +		if (rc)
> +			goto err_undo;
> +	}
> +	return 0;
> +
> +err_undo:
> +	while (account_mode != 0) {
> +		account_mode--;
> +		tmp.account_mode = account_mode;
> +		do_update_pinned(&tmp, npinned[account_mode], false, NULL);
> +	}
> +	return rc;
> +}
> +
> +static void change_mm(struct iopt_pages *pages)
> +{
> +	struct task_struct *old_task = pages->source_task;
> +	struct user_struct *old_user = pages->source_user;
> +	struct mm_struct *old_mm = pages->source_mm;
> +
> +	/* Uncharge the old one */
> +	do_update_pinned(pages, pages->npinned, false, NULL);
> +
> +	pages->source_mm = current->mm;
> +	mmgrab(pages->source_mm);
> +	mmput(old_mm);
> +
> +	pages->source_task = current->group_leader;
> +	get_task_struct(pages->source_task);
> +	put_task_struct(old_task);
> +
> +	pages->source_user = get_uid(current_user());
> +	free_uid(old_user);
> +}
> +
> +int iommufd_ioas_change_process(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommufd_ctx *ictx = ucmd->ictx;
> +	struct iommufd_ioas *ioas;
> +	struct xarray ioas_list;
> +	unsigned long all_npinned[IOPT_PAGES_ACCOUNT_MODE_NUM];
> +	unsigned long index;
> +	int rc;
> +
> +	xa_init(&ioas_list);
> +	rc = iommufd_take_all_iova_rwsem(ictx, &ioas_list);
> +	if (rc)
> +		return rc;
> +
> +	/*
> +	 * Figure out how many pages we eed to charge to current so we can
> +	 * charge them all at once.
> +	 */
> +	xa_for_each(&ioas_list, index, ioas) {
> +		struct iopt_area *area;
> +
> +		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX);
> +		     area; area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +			struct iopt_pages *pages = area->pages;
> +
> +			if (!need_charge_update(pages))
> +				continue;
> +
> +			all_npinned[pages->account_mode] += pages->last_npinned;
> +
> +			/*
> +			 * Abuse last_npinned to keep track of duplicated pages.
> +			 * Since we are under all the locks npinned ==
> +			 * last_npinned
> +			 */
> +			pages->last_npinned = 0;
> +		}
> +	}
> +
> +	rc = charge_current(all_npinned);
> +
> +	xa_for_each(&ioas_list, index, ioas) {
> +		struct iopt_area *area;
> +
> +		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX);
> +		     area; area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +			struct iopt_pages *pages = area->pages;
> +
> +			if (!need_charge_update(pages))
> +				continue;
> +
> +			/* Always need to fix last_npinned */
> +			pages->last_npinned = pages->npinned;
> +			if (!rc)
> +				change_mm(pages);
> +		     }
> +	}
> +
> +	iommufd_release_all_iova_rwsem(ictx, &ioas_list);
> +	return rc;
> +}
> +
>  int iommufd_option_rlimit_mode(struct iommu_option *cmd,
>  			       struct iommufd_ctx *ictx)
>  {
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 222e86591f8ac9..a8bf3badd973d0 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -16,6 +16,7 @@ struct iommu_option;
>  struct iommufd_ctx {
>  	struct file *file;
>  	struct xarray objects;
> +	struct rw_semaphore ioas_creation_lock;
>  
>  	u8 account_mode;
>  	struct iommufd_ioas *vfio_ioas;
> @@ -223,6 +224,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj);
>  int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
> +int iommufd_ioas_change_process(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index 083e6fcbe10ad9..9a006acaa626f0 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -182,6 +182,7 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
>  		pr_info_once("IOMMUFD is providing /dev/vfio/vfio, not VFIO.\n");
>  	}
>  
> +	init_rwsem(&ictx->ioas_creation_lock);
>  	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
>  	ictx->file = filp;
>  	filp->private_data = ictx;
> @@ -282,6 +283,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
>  		 struct iommu_ioas_alloc, out_ioas_id),
>  	IOCTL_OP(IOMMU_IOAS_ALLOW_IOVAS, iommufd_ioas_allow_iovas,
>  		 struct iommu_ioas_allow_iovas, allowed_iovas),
> +	IOCTL_OP(IOMMUFD_CMD_IOAS_CHANGE_PROCESS, iommufd_ioas_change_process,
> +		 struct iommu_ioas_change_process, size),
>  	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
>  		 src_iova),
>  	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
> diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> index c771772296485f..12b8bda7d88136 100644
> --- a/drivers/iommu/iommufd/pages.c
> +++ b/drivers/iommu/iommufd/pages.c
> @@ -859,7 +859,7 @@ static int update_mm_locked_vm(struct iopt_pages *pages, unsigned long npages,
>  	return rc;
>  }
>  
> -static int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
> +int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
>  			    bool inc, struct pfn_reader_user *user)
>  {
>  	int rc = 0;
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 98ebba80cfa1fc..8919f108a01897 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -45,6 +45,7 @@ enum {
>  	IOMMUFD_CMD_IOAS_UNMAP,
>  	IOMMUFD_CMD_OPTION,
>  	IOMMUFD_CMD_VFIO_IOAS,
> +	IOMMUFD_CMD_IOAS_CHANGE_PROCESS,
>  };
>  
>  /**
> @@ -344,4 +345,27 @@ struct iommu_vfio_ioas {
>  	__u16 __reserved;
>  };
>  #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
> +
> +/**
> + * struct iommu_ioas_change_process - ioctl(VFIO_IOAS_CHANGE_PROCESS)
> + * @size: sizeof(struct iommu_ioas_change_process)
> + *
> + * This changes the process backing the memory maps for every memory map
> + * created in every IOAS in the context. If it fails then nothing changes.
> + *
> + * This will never fail if IOMMU_OPTION_RLIMIT_MODE is set to user and the two
> + * processes belong to the same user.
> + *
> + * This API is useful to support a re-exec flow where a single process owns all
> + * the mappings and wishes to exec() itself into a new process. The new process
> + * should re-establish the same mappings at the same VA. If the user wishes to
> + * retain the same PID then it should fork a temporary process to hold the
> + * mappings while exec and remap is ongoing in the primary PID.
> + */
> +struct iommu_ioas_change_process {
> +	__u32 size;
> +};
> +#define IOMMU_IOAS_CHANGE_PROCESS \
> +	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_CHANGE_PROCESS)
> +
>  #endif
