Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A32728942
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbjFHUQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 16:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFHUQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 16:16:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83380273E;
        Thu,  8 Jun 2023 13:16:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 358IoWUK008528;
        Thu, 8 Jun 2023 20:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mdhoyti+J63lmwFbsjZ7TtZLt/mMblgVnJI2KW1s5sg=;
 b=im5wVe3Jf3qUekkcJnNwEpsrxVZyBMEm2ucNwgz68TjmgRGHbZkKJyiuVgnKw3ewl4ay
 RU4z3btKFtwG3VwYow2/+sZYL2h4u32Og5lidS/tRjqIrdxS/wH+HY/dXqm9O5nBCDVX
 5/Wb6Ve1Ufo9bOV14aojUTKYQilSP73jURk5OAYsSfiTaZSx5bwdPG59UbJYC+GUxxC7
 8M+NnUoUga4Ig7ebVXI+kOxJ+dNTClMclErNCb9SMLH4yfbxVNMJfXMQKAWT/r8tn6Ya
 mPw3l8ax7upCoZau+Wh50Bz5oV65+NPSikfdcGCpvhowoaLJorml6lGkuI3gjTSsXNf6 TQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6ud1wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 20:16:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 358J5iej035890;
        Thu, 8 Jun 2023 20:16:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6tc5an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 20:16:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4z5dZLfcSwTUo0cjBiP+QSUkRTkkHcRSbh9NODsQ/o0fCpDQfpNYGdl2kusSHb6e+MXeyr6dSXdsrB1cUJdR/P24NZlzpElsQy9OCrX/JSwVrJdwC0hH9IEIPzgc/eqgiys/gaX09hvS/HNnLX+7LGbRUI9UKMbvio2bPSP7McHyvl/17BpqfggPh/QK1s5V/PuqDhQ5WX2P9hdsG1FLwRNA+GsWH6HKj3i2DbOTKZf1pHMspGTgfhFV3zGP7rPjuvln4ZuUYf4k6zdmR74kCpmPb9JGUAtw0kmiXjWMP6cxU9+kWDy8GSU1WRB67chDb/OQUs70f5jmq5aebZ/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdhoyti+J63lmwFbsjZ7TtZLt/mMblgVnJI2KW1s5sg=;
 b=JtQCul8J8iOU9sNMXNslVsEFOD4Nm8Ay/EI4ShRh9AhBk/hLOOW0EREWAg14bMi3ANweCIDb6m5ONMm7jOBPWQJ8z/uogYkv1Cmop9u3ieOkl603DsIc9q+ETV+cLtgSijqgLftKZ0sddvRDO4bFoFOdoMZvRMQo0DYsoFxENlLeYh/NmMM7ieRWa220vWvW5VI+fQeWmSQfqLiKcjVaWhtXtzE9GM5lpgwNR/NE9wdjpmSQiq1iOZjkzCUfRrrVX7gqNZYkaxOES3V5SZLuAABazSEem7ZYseuiFj9zD1ugRDTTZ6KcGmY/0usRELE1N3E6tXtx81zWnToHXnlJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdhoyti+J63lmwFbsjZ7TtZLt/mMblgVnJI2KW1s5sg=;
 b=JFITVQlhd3ioZbyAYvbyX+uWuDKl1kZed+Z0ST76BP8JGVTwnbjYd4MKaIsDFvubxN1EoNBTYGvCBpdiF7ni8LM86I0tbFhCCiz1krWCZhr0zVL36OgG+ywXulSHf6VSggMyONkdOnRbKSfXWkXPh22C0nGVm89WwHnc4Nh1FwA=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by LV3PR10MB7771.namprd10.prod.outlook.com (2603:10b6:408:1b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Thu, 8 Jun
 2023 20:16:14 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::d9c0:689a:147b:ced5]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::d9c0:689a:147b:ced5%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 20:16:14 +0000
Message-ID: <8bf63ad2-43fd-41cd-c3dc-0507701eb5c1@oracle.com>
Date:   Thu, 8 Jun 2023 13:16:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] vfio/iommu_type1: acquire iommu lock in
 vfio_iommu_type1_release()
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        khalid.aziz@oracle.com
References: <20230607190752.216801-1-sidhartha.kumar@oracle.com>
 <20230607134037.6d81e288.alex.williamson@redhat.com>
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20230607134037.6d81e288.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|LV3PR10MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f64f52e-1f8a-47b7-6d38-08db685d35b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BDdscFSbwWOvRRmOESEzP86ykJ01ssT6PLdxRq7qSpW4P3xOeGabrlZU7a0zotE1o6N9kYcTtc3WHYHQt3txI6GewVt8txIeMZGC89nViwUpqxPyH33OGhK8vOtYZ73i9J7YT2RB8R0te0gXnSYA8rFTpUk1GcTI8dGlA4UKVqXXDj2rCv1hd+NRgzlr6tkDGas16VCm9TcBz9SSqRuESkhET9nP/+u8kPzYFQTXDFCVBt5R3Z9W9DT781m3S1df1JU+TtBLlYshrX/M9jvsvkvejyavCVkWS7X8Pxjz/4NADJwBtS8eZpMz6uGauNZilcjMeQ3iSoFCZ8BbDgXMiEGfdxpuhuqo5ZaKsqvaCvN4YeUi2uGPVmnGORJP3Z5ULCimuT+eLF8xJuswLYxVeuDYnxQDfJXE1XBUdrHyff/b+VSeq21KRmAX7ccKe/b1Umcuf4WKvrS9YODPz1jyK/dxafW4N0kYELCXFoEUjJa/wvBZXkAZglF4w6EcHspaFGPhSOikacLGeM7BRhnBNyh1r00Nt2f3ljJhZ5kdNdQNHypL2WAqAwxIosw+TxDS+AlGvGSrn2FFGn2KVSyWm878tSisa8gah+5VftOTucd5aqWVMCOIoCZfxrATWZ/EKwP9vVSLfZ8U6MLeBbGcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(2616005)(6506007)(5660300002)(8676002)(53546011)(38100700002)(8936002)(6512007)(26005)(83380400001)(2906002)(107886003)(44832011)(4326008)(66476007)(31696002)(6486002)(66946007)(41300700001)(66556008)(478600001)(86362001)(36756003)(31686004)(186003)(316002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmpJc0htQUtGWXJBNVk2MjBGWktvWXc0dGFHbjhzcTBLN0dwOThzL1dEc2pw?=
 =?utf-8?B?UzBwbmZiSHpFUzZVVkZmZ25KUjMwRGxQRlZNVmpLYmRiMlk0VGV0TUh6ZUhs?=
 =?utf-8?B?b1pwU25WdmV0TzFCcDZqSUZTdXlwK2NudUNqWDhMUDEzWVF2TGxJZlo0UDNx?=
 =?utf-8?B?WGYyQjd2b0VwRDR2NFVCRFhCbTZDNXlLU2FhM25vV3FYLzdEQXplaTF4VTFz?=
 =?utf-8?B?TGg0bFBiMGhreisvcUw1TUROWDY4YkJoVHp4TWg0Qk4yZlhiYmdxbS9HekdS?=
 =?utf-8?B?WFN6b2dsMENlZ3lwdnVmZTRCMjlUaFgrRXFsNkYvUk12U0x1SnVEVXAzKzB4?=
 =?utf-8?B?QzZLVm15RzBvVnViNzBOM3RjMDgyaDNyOUszMEF6cU43dWtQUUdoK25JWGFB?=
 =?utf-8?B?SUxmVndSMFpEWEpjd3Y0Um5yanBGWUxPaUpISnFMY1dsNTJTcUdULzc0SkQ5?=
 =?utf-8?B?MitIVlphcHZTN2NSeGV1bUFVVnp6Um1LTlY0MmhyeTM1ejVzakNiM3Y0dGJC?=
 =?utf-8?B?cDJZYVdmU21qM1QrMDA4bTZKZ0FjSHNxVk92TlFYcmRoWUpCS1E0NFVuK0FF?=
 =?utf-8?B?cW1IVVE5WWxkYVdTK3ZZYTdOMlVuT01RNStKdWgxcjdkZHFBZlVPYnVBS1JO?=
 =?utf-8?B?Rms2SkVWb3JhR3owY1lXUE9UM1JjeE1xTmxHZW8zYitHSlYvc3BVSVZCbEhR?=
 =?utf-8?B?U1d0cCs0V1Bqdjd3cldkakFYTEdOVkEvNHgwMGNoblVBc2xLbnRzUng3d0JD?=
 =?utf-8?B?MGUxTGtjNmlKTUtjZFkyZUxET05HcndEQXFibXk0b2dab1BJY3NqSUNMeWZi?=
 =?utf-8?B?alhpR3grM2diRWxSdWpsK0dQcUhDdHBXZTR2OHRZeEhJcXkwTmdVb0VXblhO?=
 =?utf-8?B?SnRISmJKZm1BdVpKZWpGeTFmb29UUHNqZ2luczVjdkE0SnBPRFBnSmc3NU5m?=
 =?utf-8?B?ekZnalpoNzRaNW80SStTQUI4TGFMTEIwUE1QNzcwQUkzN2JqaHFTTUExejdy?=
 =?utf-8?B?VzdjNlhZM08raWR1RXNOQmZldjNlcDY4MmY2aEs2Zno2WmYyZS9xZGlGWTNj?=
 =?utf-8?B?MVNSMjNTSE1yVE8rLzg4SW43MWZkSkkyOXAwckkvYnJ5L0NETEZIcC9CVDVI?=
 =?utf-8?B?L2RkOHZ1MTBablFpMlpHUUlmdlpoV3Z6cFNyYlBJbkVOWTVLUmdiSkNxVC82?=
 =?utf-8?B?VkZwZ05aUjJZbTZ2bVg4SGxkWFNzZ3hXaU9XVklyZGsweGpGNXBSU2VUS0ZZ?=
 =?utf-8?B?ZGlYbVJOenl2aUwrWkIzdy9hVDZ3ZGtqUHM1SnArS0RXdXlQb21NY0I2VGM5?=
 =?utf-8?B?L0VRY2hFOUVMZmlYWVM2UzJVNmhxbjhuaWdxNEZ5MmliMlp0aWRyODNXZHYx?=
 =?utf-8?B?a3ZrVWVlbGV6eUZOcEFLYjcrWnc2R2xWeURFa2dPOG53TWFNZS85ZzllRGZ1?=
 =?utf-8?B?c3NURjJ0Y0tHV0ZJVGdJL0NOTVl3Ulo5WkgyOERXSzZYSVlrT2hjMWhIdnlr?=
 =?utf-8?B?VldVdWFOU3RyWUs5RTJJQ0Z2QkdBVmpNS1hCaEZSR3llWGRLTmJVVXZhVW1a?=
 =?utf-8?B?SnViUXROM0tlU0IyL0VqWFpVdWJXajJMQWdVQnpVczVobTFOYm96Y0cxbkdN?=
 =?utf-8?B?MnlOd0hNbXc2T3hhQStQa0gyYW8xSnJWT3VpY2pWRWFVTDBGc2RaTDg0Tnl1?=
 =?utf-8?B?dEJYdXJNT1JzbHBVMXB6VzJubFU1dVhHOXM1ZEZnemJzblBEeWh3ZXA4U0Fk?=
 =?utf-8?B?NjN5S2hyVkNNV1NrVk50NUErNjc3WHBuZWJHNDJCdlRUVGNSYWYwT01SR2NL?=
 =?utf-8?B?NGd2U09nV1JvVXhwQU1pcXp2SFlBT3A4MlRLdHVNbTcrMWs4VldLSXdTSEVj?=
 =?utf-8?B?WlBUWWJEekZPajgwamFmU1dJU2dFRkNSSmd0VTBCU2o1SGJyZWdyNG5iNXhS?=
 =?utf-8?B?eWdmdFdtWFdSdi8yRWFRbE9ZcVE5V3pGYWZiQ0hrcU5COXdwR1hKNjA2MWRR?=
 =?utf-8?B?WFNzTXFuK0E3RHpBMnZKN2xKQndQRldYMkdGYW5GVnlERlpCbCtoNjZ5YUs2?=
 =?utf-8?B?RndxV0NsRHgzSW9xOFBVV2JmTVh4ZEZjK1ZGaU1TTFI1MS85UWdQc3RNb1dy?=
 =?utf-8?B?ajh6NW53djJ2cUgwejJjRVBZU0NRbXR2azRuaEFjbGVLS3ZuTlpnNm9qZGI5?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q2eHLcI4Q0YoHr/O88EngigtDqO65JjaXF6+4u5RCDgCgaIYXce2D+R2ZVnfIWH9ciejuWSBtALHowmJCmRJW856jHsT2KuCaEiz7T/JINeGRA5L+mksIJlro01UK8+vfFXQ8ZQatAnXSjtE681zFBxAqWULdxATK0OVn1+oqIBoDHwukJ+jC/1gXwI/kY2x8O9O7FB1geAWIyV/rUK5KpKY4UuyfT5Ll6NBSANZsY39eMVF5MEt5KluDNUpLMjHKtJZF2L1SkDsTe9iiqwkx0XoHYSrbzIL80r+sSWLxbvKyC4AqMRHDtPaHTT4PG4b7gqSwSd9Yd+VrN7kbraVvH6kJrRIC32WSIEUQU0NxB/YGzBNlAmsGvXvckoYEUr7N1Givt8N1gscwF7LQZLPTTEsJm8uTVaeJkmN26TYDMEUCD72ZOmC0szZSq7wfsCrtPGfbGgMG8czrFBDrGya7AIpzdvxzGbey6oJOJn95zf9ZXRBxir++45oumNvTMyj1/l4tlPe/KdtBFjDRM1sWvNXoO28y00DUX58FO+KrP4YSc0I3tkM/ydjIt5iCQahbVw0QK1t/NrdzsYLZHQHseAnD0pEaLrI+qvb4l6vNzQ5Sw9vM0/Hi0Fynee7vATL8zC8MveZaY9rDwOoFTqyAc+g/wLyMXzajbJFnWdvT0cQFDaYy01ciWmD/zFWkRYT+CUTVzJ3X88Sa26Xdatz7Tsmb+2Q76bdHyg4pe2hVH2mn1nvOCo7gE1I2a9V9kpEPXunGk5r/HxVk7vYBPlovcv616XZXfv+/etxE9Ra+LE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f64f52e-1f8a-47b7-6d38-08db685d35b7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 20:16:14.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +F9yeSuaCE/T/syO4U7P/tFjDR0h4h2Uft9ck9dW59QN/BeYWcGuxN4/pqi8mHkzxMUWlCXibULWa5PrT01B8TPHOmJJTVoVT87wMc0HBsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7771
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_15,2023-06-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306080176
X-Proofpoint-GUID: HTl0GXnyeqOWzdQLYvpHIzwQ1_X1mzKO
X-Proofpoint-ORIG-GUID: HTl0GXnyeqOWzdQLYvpHIzwQ1_X1mzKO
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 12:40 PM, Alex Williamson wrote:
> On Wed,  7 Jun 2023 12:07:52 -0700
> Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:
> 
>>  From vfio_iommu_type1_release() there is a code path:
>>
>> vfio_iommu_unmap_unpin_all()
>>   vfio_remove_dma()
>>      vfio_unmap_unpin()
>>        unmap_unpin_slow()
>>          vfio_unpin_pages_remote()
>>            vfio_find_vpfn()
>>
>> This path is taken without acquiring the iommu lock so it could lead to
>> a race condition in the traversal of the pfn_list rb tree.
> 
> What's the competing thread for the race, vfio_remove_dma() tests:
> 
> 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
> 
> The fix is not unreasonable, but is this a theoretical fix upstream
> that's tickled by some downstream additions, or are we actually
> competing against page pinning by an mdev driver after the container is
> released?  Thanks,
> 

Hello,

In a stress test of starting and stopping multiple VMs for a few days we 
observed a memory leak that occurs after a few days. These guests have 
their memory pinned via the pin_user_pages_remote() call in 
vaddr_get_pfns(). From examining the vfio/iommu_type1 code this 
potential race condition was noticed, but we have not root caused this 
race to be the cause of the memory leak.

Thanks,
Sidhartha Kumar
> Alex
> 
>> The lack of
>> the iommu lock in vfio_iommu_type1_release() was confirmed by adding a
>>
>> WARN_ON(!mutex_is_locked(&iommu->lock))
>>
>> which was reported in dmesg. Fix this potential race by adding a iommu
>> lock and release in vfio_iommu_type1_release().
>>
>> Suggested-by: Khalid Aziz <khalid.aziz@oracle.com>
>> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 306e6f1d1c70e..7d2fea1b483dc 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2601,7 +2601,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
>>   		kfree(group);
>>   	}
>>   
>> +	mutex_lock(&iommu->lock);
>>   	vfio_iommu_unmap_unpin_all(iommu);
>> +	mutex_unlock(&iommu->lock);
>>   
>>   	list_for_each_entry_safe(domain, domain_tmp,
>>   				 &iommu->domain_list, next) {
> 

