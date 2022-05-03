Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DE8518374
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 13:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiECLuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiECLuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 07:50:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBBD34BA7
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 04:46:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2439R2cH019152;
        Tue, 3 May 2022 11:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jo1zUj0ZNLCzEGbiqiLiAt5bLXZZSCQAlM0q78Zjcsc=;
 b=AgiTY1p03bcuSRpeewj8UFh27h35lH2fZ9zXjUKg/uaoZo6e8m24Y2eGUanVEIjnxPKs
 ywj5gjjy0aIfyW7NP9kOxJe9x8L7U/8jo0eZ2cZf2KM8cY5u9BqyoQai9DGeqQKZd5FK
 MVzwlWwvnSGNA0aDXLaZNRXB1neS5PUwt07bMpebOMi+FU3H2Iz0TS9m1YETqfg2T8Vx
 Jx8Y5SidCW0RgYV/gZMWQrCaN4MNJFeTgNe0jFOTuIuJgkAnNBc85j0g6tkTKDuybT8+
 njpjjsEK43VVrgQUfIQHRUbcXSqeeE479GcGsasQD3V8Q09elNCU4NQRAycdURm4l7VR gA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0anbn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:46:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243BelbA032666;
        Tue, 3 May 2022 11:46:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj2ad2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:46:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5UEXX5rqHm3NKcV60W/FfSKxJLOn05Dh2a/9w62E60n2QqVp0CeUKTF4DhBr8GwbCusRcPZtUXEh2ssFd8XcAvduaA6M9kh2vojhilGfYtEhfc+4ZLVZtkgNGoNJHHTOgPlqf72HLtZt31bOtqjBZBpxmpX/6cgZoWCN65JirDSc51mnADMB3kAL7+Lg2bdHK+JNoNdQyjKhWeZZNWkDehKlHyp5MzQQg0IOpoesidLJN9jJGMz0Qa67kVFB5yopzdMfFzi73zqhxnwG9motUxr/aBX7N6qQo4nho43WaHonYM5xVWRi8/8/CLr7P4269U/ArrRKaG/vro2xnID/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jo1zUj0ZNLCzEGbiqiLiAt5bLXZZSCQAlM0q78Zjcsc=;
 b=LuPYDOWteQvKF2W8N9Lmz7PjaZqAY+XmpQkA1YrALsYoQi/U8bcsF4KfDOLOrV5nPR+QkQD+51+n5CJksdZYneeL6tVpo6UMaMCRDjMksUO8G5pgWiwQFM8YmGfZ2TunM8OdjRhf3I99C90YPNkBGasoid4CwqthdpPNE58Q6kxmtgJLRBilDVQvbdO9+bHa20S38Dz9VKZXXCSZB8xe5cPpSb8vOH3t8GVdz21QTLA3jXUJgmTytEQaKic0cUcty9Go2+O84F2t/Str/99Kr3gIUzK7YJ2xp8hGTfJPNjOyxoQMany3LnPhxB6v+shAEGOihe2prZlhg1CcLqum+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jo1zUj0ZNLCzEGbiqiLiAt5bLXZZSCQAlM0q78Zjcsc=;
 b=SHzJy8RG1ADilM8X0pmQ6QkXRr3Ju8MBDT9GvZk5qq39EB1OpERMlqBLtIIvf3wrE+aEk/1Peb3BoLFadSLgardApXSfUgvOcLUoNIYuhz+Yc6SnvuQJAbXq5fBhqfI162hwjgTcQQvNUz4F6DBiX1T6Ysti1Xii//gfR9qetEY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB2487.namprd10.prod.outlook.com (2603:10b6:a02:b0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 3 May
 2022 11:46:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Tue, 3 May 2022
 11:46:31 +0000
Message-ID: <abdefe0b-61f1-02c5-1689-4727f97eb0a0@oracle.com>
Date:   Tue, 3 May 2022 12:46:24 +0100
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, eric.auger@redhat.com
References: <20220501123301.127279-1-yishaih@nvidia.com>
 <20220502130701.62e10b00.alex.williamson@redhat.com>
 <20220502192541.GS8364@nvidia.com>
 <20220502135837.49ad40aa.alex.williamson@redhat.com>
 <20220502220447.GT8364@nvidia.com> <20220502230213.GU8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220502230213.GU8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0482.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43a002a9-8ba6-4709-a0e6-08da2cfa90ef
X-MS-TrafficTypeDiagnostic: BYAPR10MB2487:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2487EE582C838ACBA36C224BBBC09@BYAPR10MB2487.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YwnBw3zVUWBhXFNG3AciPTr26wxvUSjvAqSDcfnNyf50iynBuKDOO9sAUDrtaKE9fJOeEJgAJ6s3QY2Yj5rJSXj9ZQDWVmitWnZtw/wmbXmkB+9YSX3AA9dsdmaMm6kSVmgunXDiTQCqWEptl+T+VYzH7hq9WFLIJI0rak5g4nvuBmMNMisBZTVLP5j6bN+rsxfXubOQ7vrPj6O/ThKMXP4Swjar50JhiC8UbxsX+t/J9d3vagomgktA7a5DfTpa4/tqKuVsXWSrR6FZLDCCpCYNgl3uRsqlABUKok0aU5sUaWWJ3ZiLheDrlIquQyDo05jCPJsuhbQgTX3mZLDs8aRP3ksQRhaHAMH0LDpGqJN+EyKHPAUDS27S5EKy+Z8RHPNkavkE2MneqCnDc/IxXqmZqzrdDPJsITxqmUXext9ES/gfRFx6fZM3azr74Bpx1SzsXNWB8xKfXfmzyfW7+OnA+/SKuSzjIsvcKHHMPVf0yTQZIFoHqQ2GDb532Pg2N+7azELcn7dfOYnmmZilmLthEjykwOJaGdTX3B+QvmnsfD8S6/JSF4+LKwd5Ua8KRuwPpOID4+Bn3W4a3GdKKV5SWBk8N3bw/z0ceL3TisbuPQC8OR5hWfX5Qr2VpdDCRzUDnO29cfztUXMgPe1zyyT7+GOsvzVEsoslrODx6YdP3EQ4fSlHELYBhXmW8G6PMIjN2XHykEHyrK1IElqLGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(508600001)(53546011)(36756003)(6506007)(6486002)(6512007)(26005)(2616005)(186003)(83380400001)(8676002)(66946007)(66556008)(4326008)(38100700002)(66476007)(31696002)(2906002)(31686004)(86362001)(5660300002)(8936002)(7416002)(316002)(110136005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SENDd3NMWG1MVzFROGlBOGpCc01kQ0h3RXhiNFpwWHlJUmdxY3YrMmFMNkw2?=
 =?utf-8?B?NEpOODQ3SldMU3NYWlh6MmRIalVqTWNaVU4rR0U1bm1xemxlSU1pNmtUTkJs?=
 =?utf-8?B?cEREUmZrOCt4Y1VqTnQwTlBmUmhyRVBKdzBXVXFZZHVtNktya2Y2VTIvVGoz?=
 =?utf-8?B?RXROdUxHakNSTmFXTllZUHMrU3h2S3F2NkEwcFRXVTBYZVJyM29ybUJqQlov?=
 =?utf-8?B?dWh6MnAzU0pxUHE2a1kwam1nOTl3WEFwTENiSE16YlozOC9LL04wOXFxNWV3?=
 =?utf-8?B?NHpPa1ovTFNiMTFNSUxUdUl2WnU1L1dncmRUQnNvUTNRcUpHS21VMDU3UFRY?=
 =?utf-8?B?dWkzMTN6aXlQdHRlVERJbDBKY094MUhGdVpvUWROMnB6Q0tBZFpLU0VzV280?=
 =?utf-8?B?dzhlZmpZaThZUkhuekxlYW5JYWZaVjliRG1kaG1VcjlFd2JheHhOVEROK1VC?=
 =?utf-8?B?K2dTUWFSaktBSWF4eHBqUWdCa0Jici9MNEVvRFB5ZGkvNEZFQ29TLzdqZWUw?=
 =?utf-8?B?VDFDS21yMTFobHJrb1NUZVRmT1N5dEZvS0RpakVNUWVWZnpoSVJFbmRXUi8w?=
 =?utf-8?B?eUtRWmpXVmc0d01CZkdxdkcrRThHeDErZWdpTXozbUNnM0NiN3F1d0hHRkFN?=
 =?utf-8?B?aVRDbmdhTWxkU1drQUp0bCtsZWRvaVBGcUlmVHdVYktUTnpIa1VXQjdRbzRW?=
 =?utf-8?B?MzZYbDVreUcyL1Jua0kyejRPSTU4L2FGaTN6VHkyVmI4WHJ4azNJazhDck9v?=
 =?utf-8?B?d1N5WVVwMm9oTWFsYVpxL3hMVVRnbXZiZnhWRzBCRVNjL0g4VEVLenM2STBU?=
 =?utf-8?B?VHh1OWZpYXk0SVZYK3BXYlc0T0s5M1FudFJWcmJuUGtCYmZVYnNONWdzZTVk?=
 =?utf-8?B?YlJoRXh1blhITGI0ZFV6b1lSUDc0b3A4ci94eXFEZkpVRjZwdjZ6Vzk2Nmpk?=
 =?utf-8?B?MWR5aWJybnVEQW1wbWdESUhWODBneWJYR09MVXJWL25rc2JMRVk5RkZkcW1r?=
 =?utf-8?B?cWthMnpsVW43WG9ZREdCM3NQcW0wTEIxblF0MUxSOXYwYzN1N3hlZzk2VmE3?=
 =?utf-8?B?VjN0ZmwzSHNLY2ZHT09VMXhQelIyTWxPK0I5R1lHRjZFN2YyS2JOSElZWTh6?=
 =?utf-8?B?NTdrVFZidStJVFBjQlFlc2xtQ3lQUUdzeVpHbUJXRHBEUEVBRGtpT2V6cGtF?=
 =?utf-8?B?L01KY3lCQ2h0dUdWM0Nkd1BNZk5rdE4xM3pEcGFTYUdxMGdBVnh1b1A4dS81?=
 =?utf-8?B?eWF3T2VNaWdWTVBMN09EYmMvSHBXc0h4ZlZ4UHhvb0kzcDBaWkh3eU1VdG1l?=
 =?utf-8?B?QlZkZUMrYnFrOGNEVFlZTUpURjU1MktDeDhvdVVoMVkzTjlIaDFzbG5hR2Iv?=
 =?utf-8?B?VTNFQmUyTGpwZ081U0VvbEczSGptSGJJSFJUajFrVEY0U04rQi9DbXNNM0Rx?=
 =?utf-8?B?ZEJHcDdVWDUxeXRBRlE4Y2ZWTFA2U2JVczkwYjhlTDI3c2lMVXZTK21sSmFn?=
 =?utf-8?B?OU9DM0xNR2lEZjNzdUJPcnJHanc3WUs2SXpKT2IwL2s1cmlLbis1c2VnSTAx?=
 =?utf-8?B?UUFRNUJhRjZ6RnFIamdlVTZuNTdXcmJ0YklLTWQ0UkdZQVVNS21ESHJvRjZS?=
 =?utf-8?B?RGR2OHV6b0MvaURidWV0QmdoSWd4ajFCY1FSTzB4MHVqbmxYOEUxVGpjQnc4?=
 =?utf-8?B?RXkzYU5sdUFaNFFoRjd1dEk2MllBSnMzbEhQVk9NamtyOW1mU0w2ZWdjUjZ1?=
 =?utf-8?B?dFNXSE1Ma1RPZEFoY3ZOSzVnZmpRV1RxaFpVOVMrSENzbGVNc0dlekEzazNw?=
 =?utf-8?B?dkNoTE9YZGZjR2ZHV2hyV0dQRTdyWjVVMGozZFUwQ1hKSDZjYmVhU21SNzgw?=
 =?utf-8?B?SVJhelQvYlJFcFVXSFNqeWtmUHQ4VDZQWFFEdG1oZHNXTzZKZ2xDUGpDS2pp?=
 =?utf-8?B?YzhQdlBNTTJGdldvTWpSS2J1V2FUWXYxRG1qYjdjdXN1M3VxWC93Tll4dno5?=
 =?utf-8?B?a2xJbThzaVl4OEg4K1ZmdnJ5OThqelNXbDVMR05YaWlEQURkT1IrbnJuMEZj?=
 =?utf-8?B?SFJhcEdkTHRqamZwVnZWbFRuTDByMXhlNE5JUFp3a0MyVU5pZEZ5ZVVFOWNm?=
 =?utf-8?B?ZXdWczlzQU9wdnVlbm1zdDBab3ZqUW55c09sRzZkNkp5TjJaUUJmSDd6KzM2?=
 =?utf-8?B?WmI4NEZXRnVzd3dZWHY4Y053cVpCN2RkaTFTazVmY0lrOHV5b3hWZ0lVT0F2?=
 =?utf-8?B?YmRDR1MrZDRSRnM3WkhrMS83cWxWRTcxMkUyY0JXbVh5SHMxNGgrQnM4ODR6?=
 =?utf-8?B?dklKaW9NTnJoUklkS2tHQnhjTzFRVmZMNldtc2hXSHM4bVhYNzBXd2s4Tkww?=
 =?utf-8?Q?dPmupBlnJfhXTRhY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a002a9-8ba6-4709-a0e6-08da2cfa90ef
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:46:31.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpKJ1C6LRhYOyNR3XbSvL7JqIt6KpUgC5bZvgBFwXTyJyIjfAuBIhLaD17SssZ963noYike+SkkIRXo5q0F2NgBRO2WjW0UnOeovBCB7jxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2487
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_03:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=857 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030087
X-Proofpoint-GUID: zTs3yAJqAUF3hLu5w2KXbCNbl4m4T95w
X-Proofpoint-ORIG-GUID: zTs3yAJqAUF3hLu5w2KXbCNbl4m4T95w
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/22 00:02, Jason Gunthorpe wrote:
> On Mon, May 02, 2022 at 07:04:47PM -0300, Jason Gunthorpe wrote:
>>> Ah great, implicit limitations not reported to the user that I hadn't
>>> even guessed!  How does a user learn about any limitations in the
>>> number of ranges or size of each range?
>>
>> There is some limit of number of ranges and total aggregate address
>> space, you think we should report rather than try-and-fail?
>>
>> I guess total address space and total number of ranges is easy to
>> report, but I don't quite know what userspace will do with it?
> 
> Actually, I recall now, the idea was that the driver would sort this
> out.
> 
> So, userspace would pass in whatever ranges it wanted and if the
> device could do only. say 4, then the driver would merge adjacent
> ranges till there were only 4 - and limit each range to any device
> limit there may be and so on and so forth.
> 
> If the result was unfittable then it fails and the only thing
> userspace can do is try with less.
> 
> So, if userspace wants to do 'minimal + extra for hotplug' then on
> failure it should try 'minimal' and on failure of that give up
> completely.
> 

Is it worth classifying the range as present or not, say a ::flags of
vfio_device_feature_dma_logging_range to help choosing what to aggregate
or not? Provided the number of calls might be undeterministic?

> Then we don't have to try and catalog all the weird device choices we
> might need into some query function.
> 
> Yishahi, this concept should be called out in the documentation, and
> we probably need some core code to pull the ranges into an interval
> tree and validate they are non-overlapping and so forth
> 
> Jason
