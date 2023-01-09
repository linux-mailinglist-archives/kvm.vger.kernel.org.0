Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010B066329A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbjAIVSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbjAIVRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:17:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC3C1183F
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:16:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309KxKNY000797;
        Mon, 9 Jan 2023 21:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3FO28PSIyf/O9cFZ7sLOfbVH1dNucRZyarOiGRDbVs8=;
 b=QJ6CSo0WrN8bGgrS1EU9uAAAd7Gka7e5BUeYmD1S9om+Ob5pRq1l7Tk58cWG+gxbwD51
 VRmjD/G4KLfBjtYo+nlQoaqXaMrudqPKN2CEFghTT7W3/+c4LMKHwxfCI9RzoT8RijLf
 4ZVRUKrq2xJnaPH/LSOdLBA9gYicJ39tfZVM+JBokYRbey4gLaCe+lPSAFzG1FqCCPn6
 XzbfWUGvG9Q8frokfR1gFa+sagZV+2IRgVot62c22FenpNLRYc7ewslDILy6ukTN3dg6
 BvWoq6qE1P3Gz1BrQUyv+IfBXn9sWZZZ04Ue5iGerSbmqZHzAn+hOugo9iZyVzC0jhEq +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mycxbb83a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:16:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309JaYuR004392;
        Mon, 9 Jan 2023 21:16:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6ajhsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5BxDDdgoo9Dlm02HMzsSWm3ycJOyr0EjLzSNxWUqg4kVhXDsKS53+9k1qeWIlAxkS6mJpujvAF0eMyM4AqJ3yr0iSbzPQ4rB7FEMbX74N6Id78MTbGyIO4BgVjpDCq0dvl6JO1OZ6cXHovVFuge+rNUrPuf8EAhclPMWl7TqaYSp7wOlMshsK6j419clHrOdopWD6R2cvLrO0ccH2HohbcY1ofGEnR1127H2DQvFkRz80Rrsg696WORsn1rANdGt+AOOKMgRk48LSP2ElN/9aG1CiK+AUrtsdUCOMQVvBOo8DD4OejYLUYoOcqyYn0AlE5hUXGl6AwveQqgmk3gBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FO28PSIyf/O9cFZ7sLOfbVH1dNucRZyarOiGRDbVs8=;
 b=CNU4a54BexoWSB8fT+Wmky8ZUHziitDi7RXlskU0MPqebx5QqqR1VehLppdE3phCds5LaS1cfy7YNHtOj1HowMdzzYFfnK0veN1zTn9fi2QLsiBnyhyNCGBh4v1LN2DmWMv8LLKS2HX5nSk7fbH7Jjn3zFu/Aq+bPUJt4gva/SWAslXX4WXa1+Snwd/NhK0pnVxK4HBToY4bcZTs2T+pHSeF8d6GKhiTUucB/9RGBILNqPZ89eeWRz3QYHENfCvNnYF6AgtoWnNgdfNhaoStaCpCTYzZr+PjqSn7TBX2XQOsu5wS6Y3+8Iz1TWcLvi8+jszVyu6BqoN+V2DtKN71Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FO28PSIyf/O9cFZ7sLOfbVH1dNucRZyarOiGRDbVs8=;
 b=HDYe/d1fKqlM/6dQV9bQG5NbgZuCtBb7perF97l1Q3YXq4GWsrMeTNYeNc0vcvNajbHYeGLMde/jnxadzjk/HofgpZpuQ6AgM/e4Syi/o/eW0bpvKQ7mZZYrpQCutPI1KituU60ocA31f3fkbIpmwstQDYV8VrIM9S/gcnerUtM=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by MW4PR10MB6300.namprd10.prod.outlook.com (2603:10b6:303:1ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Mon, 9 Jan
 2023 21:16:22 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 21:16:21 +0000
Message-ID: <5d91cc83-58ef-3c8b-c3c0-421899bb0bcc@oracle.com>
Date:   Mon, 9 Jan 2023 16:16:18 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
 <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
 <Y7SAA6eJKK91F6rE@nvidia.com>
 <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
 <Y7wcHg0d0ebC6h+3@nvidia.com>
 <25717799-7683-c39b-354c-0f6f6ff11635@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <25717799-7683-c39b-354c-0f6f6ff11635@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0199.namprd13.prod.outlook.com
 (2603:10b6:208:2be::24) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|MW4PR10MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 519bf5ba-a1f4-423d-0117-08daf286c1c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYM1FSJ/ZHKKIxrw9+b2Q+DEZ9nrgx1+7x8caj6s1cCGbZBAryD6xrVOAL2N28xKrpTmOE8bGwHlRKVt08Fn8vbLTyvyROtb4qRSuItExntkb5BXtTg77P69FqCwGl1E5X5WgVK9WO8nbLFGK90tNFjrhFTIJvTKnFPEZmlWU0B1y8DcvSRA6J9QTSzghFsx54yccBfFpszbyxBxC4JHqq9YiZsfqwyjlYF4CEHqdWnTCMMzikaFBBKkbXpIRBICQean8NKIKzHslHani576LQKNPZ7tx7x1gjLkZlHsqCl48u4tb29kJ7dkUTmD1KAsKCg4Ih27QuibL2C7zHU+Ex4y8EFq9hrkFr7lMSkTPHx+FaEAvHjU/RYZEyadLsW4cCkH+xo4KHm2w9zpazCrn8+1LbdDH3AzDvYM5y/P1La8ICPepODHfzN3AqP8OuojAzblISbHLJmBV6CRD2EiQ0t8yfmeRFCSWGZd5D1348FerR/5ipWMO+u+V4JlMK2pZ/OWC+4oEsovnWSVEwBRq3B4Y9R9yOlTR/GaaPgArCHq39yeoYWrX8NFQQTTRchnFkmfMFHxJJKcVUicQNSVllUrweHfQR8kJ0IlFbzDgAAhVOMtjUgvUs9F+ubVxhLCvAvWYAQwdAXVa9jzbK32fdti/D7g1Rq7zIGis8p2JupXrhmZTEis3PxllTq2vI+vsrasJfCeeVcjh4kPQ7ZHxIYdP8qsbPy54rPPh6RSdYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(6506007)(53546011)(478600001)(26005)(6486002)(6916009)(6512007)(186003)(2616005)(8676002)(66476007)(66946007)(41300700001)(6666004)(54906003)(36916002)(4326008)(316002)(83380400001)(86362001)(38100700002)(31696002)(66556008)(31686004)(2906002)(44832011)(8936002)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THhSbWYwaGI3ZjdZd0J2ZHBCOEFCbEZGTXg2TlRHVVpHT3Z1djlLaXFxaW1B?=
 =?utf-8?B?anZFQi9lMzFjVWU4TURCRnc0VGlPWGloN0RlbGZ3MThYb1JrVlExbm9RSlda?=
 =?utf-8?B?NUYrTzBQNndUSTZjZHR4dHVOUVd1T0k5WXVuZE9BU3BNQ2oza1Ric3k1aXNM?=
 =?utf-8?B?Zlh0ZDdZV0d4V2NLNHdScjd4bGFybFh6REpvMkYvZFZWUjE0OWFWYkpTdjQr?=
 =?utf-8?B?UDRwL1NBYnJ6SnJ3ZTM2M1hSSTUyWUxHZG9IWmhWTXZ0RWRzNDl0L2lZOU1V?=
 =?utf-8?B?dTdSSjQ2dFVrN29EOVB3VVpTdXNqelA2Um1mTzZIbXlUcmR5NUFyWkFrYlM4?=
 =?utf-8?B?Vm4vdGxZbjd3c2VGUmpjbm55d0h6NW1wZk9RM05HNFJZcTlLdkF3Q0N2S3Bk?=
 =?utf-8?B?enpFV2lkSFUvQm1OK2lTdG1WNFFMS2Y1am9zSHg4U01FUDI2TTJ0QSt0QlhB?=
 =?utf-8?B?L0RHb2lnbld2L2cxR2dNb2VaSmVTWUZJTUhKWFRIcWZmVkYxUVh1UEswLzg0?=
 =?utf-8?B?d1hwOEhhcmYwdkVnSG9DQjBZRWQxbFJLRjk4MHd2UHBxWHRLaTZ3ellBN2t6?=
 =?utf-8?B?bmg3ak5BenhKSGpqMlhqQzE2eG5NZTdsdDhMZWVSNkxOUDg5ejhtYmhnUGY1?=
 =?utf-8?B?b1RnS1l0OW5ub3RrZk1DZytOdU9VWGtETGZNNmRVVUtKYkE4R29JQ3JZQkZl?=
 =?utf-8?B?YXlCYnl0WlRkeXBKUk15VWMvNHVxMW1YL3hHNWp6K0FmY1ZGWEo0TVVoMkZI?=
 =?utf-8?B?bVd6TTNBU3I2OHliem13U2l6ZlZBdVYzc1V2NmZ4NWdkU3UxbExJeWNpN1gv?=
 =?utf-8?B?K0ZOZU5EU1l6UmtLaHR5MzNId0ZuSExYN3ltR2F5SFRTRkpaT3Q1RnZsV0R2?=
 =?utf-8?B?ZFJIZFQyZlZ2eUVkQjR0eCsyYVNiZ3p0c1JJK2ZpazlNU3kwWVpyemlQY3NT?=
 =?utf-8?B?L0pEZjVtajhVOFF1ckdOVFY4elFpN3BVVkRUdE9NaHBWWHBMS210bzVYTU0x?=
 =?utf-8?B?T1dnTjEzVmdtMm9tQWhiV0tGbUNUVWtRNE9QQU9vRUlXQ3hLUWNMV0I3WUdN?=
 =?utf-8?B?OTFZZXhmaGJSajgzNkl0Z2Jjd3J0a1BoK1VUQUdFb21PT0dzUHhlYk91dUts?=
 =?utf-8?B?aWdqNzJsV2tPMlU0Q0g0VXNqUkxZV0ZUK3lWQnRCajZuOE0wM08rZ1NqdEV0?=
 =?utf-8?B?aURCNGxYRWxvM29UcWphNXgzY2xJN3ZkenBPSHpiU2FCTnNqYmo1YzZQV2Ro?=
 =?utf-8?B?RDViNXcwelB4NEVnUzVGdU1VOVJ4MWFHanFKUzM0WDYzcS83TzcyYW1YQ0lG?=
 =?utf-8?B?OWk1WXkvWXA2Z1NqdTJaTmFkSU9IR0U4TnhnMEtxYloyQ2lpNHhMV2NSZURF?=
 =?utf-8?B?U3RFZGs1WGtOR1lKaFVhcnpIZ2JGSUFFNkt1Q1BWZm1BcUROZlU1MFVtd25Y?=
 =?utf-8?B?dWdlNStCLzB6UmlOMTdlMzhoTWlWL24yUnk2L252cDNRSTJUK01JZjFjOFhC?=
 =?utf-8?B?cDVYa2NjQWh4Zjh0dXR6WjB6c1p1bWlieEd3dTFDNGJUVjB3NXlPOEtsN29L?=
 =?utf-8?B?U2ZoSHU5VUZCNjF4NGp1Ymh3K1dRbUwybUs5YnN4NWVMcWFqeVJUUldoeEJQ?=
 =?utf-8?B?aVZ5bE5XanJZVmhLbmJ6dURVVHpJL1dpMnE5RXJZVDgwODlNUHZHYmc0MkNT?=
 =?utf-8?B?VGloSm9IcmhBMm5XYlArQzd6VGEvVXhKcHBuTTZ0TmdHM1BzeW1wKzM4dkJ1?=
 =?utf-8?B?TDNZZXVhV2dudnYrREc4YitnN25VajgwY2hQVERaUWJQaTdUdEdTWGxLSG5h?=
 =?utf-8?B?bVhFS25aWkxOQzFJUlg3UHI2K2Z6NDQwKzkrQjFJMzRTNHVtS09yRmd1dlFT?=
 =?utf-8?B?YTJmUWljZkNCRmNlM0JKYytPbmJXUG5ZcVJPblEwR1BZTlFrRDRNdzZ5bGUy?=
 =?utf-8?B?bEtqUENPbXdyNGJzSFJNdFovY3lpM2owbHNGamZibHNqalBHVWd4TEt4SGZt?=
 =?utf-8?B?bVNFR2NDMTJyZmZabmdGalNOVDV5UHh5cGlINUMwLzRBZStESGRqUVZmS1R1?=
 =?utf-8?B?a1JRYXZiYmQvbE93SUZ4ZWxtbklZNTF5eGovRUU5bjJsNlM1QmZnTzNGU090?=
 =?utf-8?B?ZmRESEdVRW41bTNwbWp5R0V2Mk1jVVlEMFowQnh0eWgyOXI0ZTRHT1lLMi9o?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 62nVay/0T4a1rC1WoGFCLkFHe+IZ6jfKbAJqLXN+R7TN6DPQQzWKBe//4pv39thGkmQfyUQUszm8ZIbFs237usbVRoydVB5wwqODCuQtf7P2hq769dOHbk+Uvo5G4GManK+Dr32V0CJN8WxkjXj9kJhvUVzkMz/MwtnreJO46cbyIVZ3OnRmgS+suhQ2ch4HxEywEDHmGJ0k3VYFma9dTdiCF1yao7Smw+Ui+zCoRpmAz0+pIglUzcLTGfARBDfsJ5Nz7OM/PUV/665SdhweNMVLKyAQb9HTh8CWbu/UXs6tl5bAKP1nmvv+N1Zi6FV7JTaFD/wV96FlABBbmNc39hM8e0mRsso0m2bMi4kzl95NjCZAGfA0uT/3MfReczdLTLEXYmVZTBCpSNx83GmQeslBij6SRXW7PogmhL57neRAcHF4UQaQkXcIPaMxxHF59++C8KHlP1O7OOujZOEOgXuPucZNhfg38nEmzeDvs2ZxcrxGcbv2n9v5+XfSeEhHTfY94FssQ9aai8astwgoZEuGlahn29OlKwZ8g80SkPyDz6PAO3uY6ofCfr3aI6AZXzFPRdcME64tgoqbP6a0635CLMmODK7O9fzcakMK7xSV1S0VrQWKZu3voFMB1LClKRgSGhdqjej5lfSHQRIpQxBdLjODCRUXo6Akdh3OBa2NqqWziAMEVvnirxytECbM3fumepztpHrLfpI+CIq2sw6Qmq2/XUh43kr68Sh1mOOFPJjTfe+UYnmZRLAVPz1a7sjw71mP+YrmCO8IxaV/GG2W3cgh5My1hlt25g3tCLkpbZgLzVZSoSSiskJRM7M6ud6XbOeLJuIJYobG5jPSJQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519bf5ba-a1f4-423d-0117-08daf286c1c7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 21:16:21.8336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3XzcvL/NxrBH1aIx67XF0M4oQXnJlgHpRhxfA0MEaux9K9ZLF3zBwplUSuZwkwkP1nm4ci/2hPh8Nd5WsxgaQ8oylX/8HAPrVlEWrNgXgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090149
X-Proofpoint-GUID: sALc7sUliuRr0yu-YtQApC7-b-OpJnRq
X-Proofpoint-ORIG-GUID: sALc7sUliuRr0yu-YtQApC7-b-OpJnRq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/2023 10:54 AM, Steven Sistare wrote:
> On 1/9/2023 8:52 AM, Jason Gunthorpe wrote:
>> On Fri, Jan 06, 2023 at 10:14:57AM -0500, Steven Sistare wrote:
>>> On 1/3/2023 2:20 PM, Jason Gunthorpe wrote:
>>>> On Tue, Jan 03, 2023 at 01:12:53PM -0500, Steven Sistare wrote:
>>>>> On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
>>>>>> On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
>>>>>>> When a vfio container is preserved across exec, the task does not change,
>>>>>>> but it gets a new mm with locked_vm=0, and loses the count from existing
>>>>>>> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
>>>>>>> to a large unsigned value, and a subsequent dma map request fails with
>>>>>>> ENOMEM in __account_locked_vm.
>>>>>>>
>>>>>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>>>>>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>>>>>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>>>>>>
>>>>>>> locked_vm is incremented for existing mappings in a subsequent patch.
>>>>>>>
>>>>>>> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>>>>> ---
>>>>>>>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
>>>>>>>  1 file changed, 11 insertions(+), 16 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>>>> index 144f5bb..71f980b 100644
>>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>>>>  	struct task_struct	*task;
>>>>>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>>>>  	unsigned long		*bitmap;
>>>>>>> +	struct mm_struct	*mm;
>>>>>>>  };
>>>>>>>  
>>>>>>>  struct vfio_batch {
>>>>>>> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>>>>>>  	if (!npage)
>>>>>>>  		return 0;
>>>>>>>  
>>>>>>> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
>>>>>>> -	if (!mm)
>>>>>>> +	mm = dma->mm;
>>>>>>> +	if (async && !mmget_not_zero(mm))
>>>>>>>  		return -ESRCH; /* process exited */
>>>>>>
>>>>>> Just delete the async, the lock_acct always acts on the dma which
>>>>>> always has a singular mm.
>>>>>>
>>>>>> FIx the few callers that need it to do the mmget_no_zero() before
>>>>>> calling in.
>>>>>
>>>>> Most of the callers pass async=true:
>>>>>   ret = vfio_lock_acct(dma, lock_acct, false);
>>>>>   vfio_lock_acct(dma, locked - unlocked, true);
>>>>>   ret = vfio_lock_acct(dma, 1, true);
>>>>>   vfio_lock_acct(dma, -unlocked, true);
>>>>>   vfio_lock_acct(dma, -1, true);
>>>>>   vfio_lock_acct(dma, -unlocked, true);
>>>>>   ret = mm_lock_acct(task, mm, lock_cap, npage, false);
>>>>>   mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
>>>>>   vfio_lock_acct(dma, locked - unlocked, true);
>>>>
>>>> Seems like if you make a lock_sub_acct() function that does the -1*
>>>> and does the mmget it will be OK?
>>>
>>> Do you mean, provide two versions of vfio_lock_acct?  Simplified:
>>>
>>>     vfio_lock_acct()
>>>     {
>>>         mm_lock_acct()
>>>         dma->locked_vm += npage;
>>>     }
>>>
>>>     vfio_lock_acct_async()
>>>     {
>>>         mmget_not_zero(dma->mm)
>>>
>>>         mm_lock_acct()
>>>         dma->locked_vm += npage;
>>>
>>>         mmput(dma->mm);
>>>     }
>>
>> I was thinking more like 
>>
>> ()
>>        mmget_not_zero(dma->mm)
>> 	 mm->locked_vm -= npage 
>          ^^^^^^
> Is this shorthand for open coding __account_locked_vm?  If so, we are
> essentially saying the same thing.  My function vfio_lock_acct_async calls 
> mm_lock_acct which calls __account_locked_vm.
> 
> But, your vfio_lock_acct_subtract does not call mmput, so maybe I still don't
> grok your suggestion.
> 
> FWIW here are my functions with all error checking:
> 
> static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
>                         bool lock_cap, long npage)
> {
>         int ret = mmap_write_lock_killable(mm);
> 
>         if (!ret) {
>                 ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
>                                           lock_cap);
>                 mmap_write_unlock(mm);
>         }
> 
>         return ret;
> }
> 
> static int vfio_lock_acct(struct vfio_dma *dma, long npage)
> {
>         int ret;
> 
>         if (!npage)
>                 return 0;
> 
>         ret = mm_lock_acct(dma->task, dma->mm, dma->lock_cap, npage);
>         if (!ret)
>                 dma->locked_vm += npage;
> 
>         return ret;
> }
> 
> static int vfio_lock_acct_async(struct vfio_dma *dma, long npage)
> {
>         int ret;
> 
>         if (!npage)
>                 return 0;
> 
>         if (!mmget_not_zero(dma->mm))
>                 return -ESRCH; /* process exited */
> 
>         ret = mm_lock_acct(dma->task, dma->mm, dma->lock_cap, npage);
>         if (!ret)
>                 dma->locked_vm += npage;
> 
>         mmput(dma->mm);
> 
>         return ret;
> }

Let's leave the async arg and vfio_lock_acct as is.  We are over-polishing a small
style issue, in pre-existing code, in a soon-to-be dead-end code base.

- Steve
