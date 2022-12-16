Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217DB64EECC
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiLPQRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiLPQRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:17:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94FD8FE6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:17:09 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGFxIKU024823;
        Fri, 16 Dec 2022 16:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0g7vcXyujG6L0BhVCEWL73zbjetdDMt9sWTes8qqSow=;
 b=IbI7iGzCvtp8qW0clhXct5UwBLDN0fuVrsNf2sgjfJwHku0y5WpI68gLuFIbrr/p30Rp
 38WgJRELDftgljGe69EOyMroud0rQTkyo5MkJ2c2RrURYa0sHWma8A34ZoNqsQSJVuoB
 MSCdSXyIJgaARZhNmlLE7kKJ+HTV51WIf3PoPF3ZlO7FTcxAWoavFNLWZpyi9jMQiRHf
 pEtqBCFyWB/3O3lvXOax90F+/KpwA7xihK6SEcvs8qEJrdSQJurTcx23euytfyqKIIAH
 Y+TfZ73E2z77NkXSdG0UeF9qC5YI8BEdnLdYmuvd5H49dimhjJQ2QThKUU3MMl7Mew/p dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex7vt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 16:17:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGFviXm027809;
        Fri, 16 Dec 2022 16:17:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyf0hk3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 16:17:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqVcNSsEVUbWwFp0ifB+1KlAFzZpjAfmMcrP5QaBdQ8uh8tmroj4/jxUUMryr9gOccWaA+1oFseLEV/R2mT2MfOlif7C4n+oyky5rm9FT+3WxyYl1UU+/KCaievASZkNWWnzBw+PGIArfrOc4YP9n4U86DulsavDAQWrUeEAOffhJZlp5iSx55Ias5TceOntn9jVRtCwonlj9AIlkms3OrWxiZ+dYlwlzIbjmeuCZewJkWnnrSLIw9l0SAEFbDwjqZG60DjP8/ZaD1bS1+mryDq9SP0OysasRzG3R/02cfOmE9EPHS68kCTjg36+s9YAQNv81AI7Xvw8K/71NNvQ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0g7vcXyujG6L0BhVCEWL73zbjetdDMt9sWTes8qqSow=;
 b=IhkxhaEUZl6yQZbCP3uLQgUm7KCPgYREyVByKj1lXnSBF5tJMyrpzfEOGJN1G2PkSbJZzDUv7jODowMeWSgwx0L15zTy/DadN2F90GMv1YJ6f7WehkF0CXvBdzvrrujOK6+eOZaNSDzHmP+okYn+FSE5rbD1T3QYU9X0IqcXaFLfJPlXYZ1atTMTZ1yNE6qatWQAZcxU+JqRsjxYBacM5ZzrOKkM20yWDmxLJMzR06JD+pzQAx0zqzys4EAH5b/OlWpY23uhiAYgi1GUx2WeCyNVoX2hYGUcCSeU0PBFVbqHqiJyK2d/HUj5QCm82k3cmErJZeOOxdDI/zUD8Wo3Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0g7vcXyujG6L0BhVCEWL73zbjetdDMt9sWTes8qqSow=;
 b=v8i/O6fSW6IHJRZi3zuO6RXBjmoyevHyaxvlLrbpcTYhPUHhtYipxgUGiF3+/xx8IEO7XfwoFT/YXcLfrMC1ud7v0SsfTGnYntkTAfyQctKJDYJSzdXu5bOD4gEm0u+biSMor3+bpaQYBpmBYK++GKjf6Tla1/MTqo2ZzVfkkQc=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DS7PR10MB5216.namprd10.prod.outlook.com (2603:10b6:5:38e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.15; Fri, 16 Dec
 2022 16:17:01 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 16:17:01 +0000
Message-ID: <68cbc774-4c2d-c29a-41cc-fee24af89604@oracle.com>
Date:   Fri, 16 Dec 2022 11:16:59 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
 <Y5x8HoAEJA7r8ko+@nvidia.com>
 <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
 <20221216091034.4c1cac89.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221216091034.4c1cac89.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:805:106::21) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DS7PR10MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: b24a8cbc-dbb0-4535-7ef4-08dadf80f6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kbXaUBelT6u6owcABJmaXOyKpOsikO+aYP6INO4QRIS/QRcxqfMfvKAPbdaVFi8g1Jx2Fx3yG3C3V9/i4yTa/ysNZN/ZoBpwklJEjREFqdJyFn7byMjVIVtFL2ju935nwwhG3khPminypu4hhh6Ts0ojdwP6AjVNQ8zchmZXELF0v5ti1fzwr2+gQuNKJLOyA25N3AudyRv8HO+0YEirw9dR4a6lB+MQEN9vQoeGoUOf32VHk6SRnnoqs8FzyeReOdmkWaF8S/HrEf1t2N0hW0twFMVd0oAKv044nE6/4+BNivrPHuAWkSXbpIHJRpRQVgvhmnqgtH/u3pItV1zjcHrAEPWmvDgLR99uHg+81O4/7O6VqzwvouInKtbgKo+FbnwmJR+MfkXk6r8E3XLCu6vmIxDH6XDy2mXnuZ3C64iRK2puIdiBVmxr1uSyA0q0WsimW6frQMbd/07auBQSIorkqSfdlifbsyGo6gvE14i0SxelcGJRfinron3MePgzLXa1XgnGNEmDxaBZFiTmxIYB/shhvZulsGtqsgY7PDt1ceeUJQfcdD6LLib2aRc3zVQBp4Wb1zjlC0dj3NzJLOd08lqGjS8AQtEtOnehDcfhsLLvrW5scQLELhyvzSAZ6BSikM2Ew1kA3Tim98PfE1LKo2TtJd0VoIf7MMoc6YX9/4S4xOQTcWpyW46n03RJsYe/06Rq9+iuz2CY7MUI1WL+ByuBaGf+iiKDQkNWy2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199015)(36756003)(31686004)(31696002)(86362001)(6486002)(36916002)(316002)(478600001)(6916009)(54906003)(38100700002)(2616005)(26005)(6512007)(186003)(6506007)(53546011)(4326008)(66946007)(66556008)(8676002)(44832011)(41300700001)(5660300002)(2906002)(8936002)(66476007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmFEd2VUMDg1bzhxajgxek5EUFlsTnh2ZTdKTFllbVlJU0I0cUVUOVBEd1Vp?=
 =?utf-8?B?WVlGa29QL0xhSFMzb2JLL0gxSGFpVWdKMEh0dDNPaDRUNHE3NU9oQUV0aEQx?=
 =?utf-8?B?anR4VklMWXlJbzY4RHB1bFJQdHFkQlluUUhnc2N0YlZBa1JJbTlMckZKUzJs?=
 =?utf-8?B?OWhjOUhrZ0lFWjM0K3JPdjYvMFlFRUZOWmtib0tKZElBb2JNSmVHRUJrRWM5?=
 =?utf-8?B?SVJHcng2aUcyNy84NmtrZVVEMm9iUDhPb1YwVUZlbEptakNQUGdhTm1WNHox?=
 =?utf-8?B?aTNkNVBDVVpKc0FERjZ5eTlqaDdOMzRpdHpMN0lSY0pORksrNjBtbmtSdURU?=
 =?utf-8?B?dHQ5KzNFS3o5aGNjSGpFTmhLNVlHM2ZXbjlFQTFWUmxFZE5JRVVnVnF3YzBL?=
 =?utf-8?B?MlZxK2dpYktOYmJlKzJDblIyaW5GM0JNS2dTOG9sZnB0c2ZYNDIzYVIwNlp6?=
 =?utf-8?B?b0FLb0t0WGVTZStwWmlxNk9tbTAwa0h3WlA5NFVhTVR1dnpiOWZ5YzU4TE9X?=
 =?utf-8?B?QUJlYU9FdmFrTUhpWkpibHRuOGpGVkMxdGpqRlJKYzJMc05yRTc4eTFTUDFw?=
 =?utf-8?B?QUtqWkZUaEpOREF4cjRrV0tEZmR4RU15UDVJaTNKVnRBR09OdDc3b3Q4cU0x?=
 =?utf-8?B?MmkwMXhDYmw3eTdHTzk4NWVRSndrTGpiRUZvVk9qbDJvMXNCcWpGS0hhaDRN?=
 =?utf-8?B?WWVEQU5aMzBLdzZ2V1JZazhLVXJCc0hwOWZjZk1yblFmU2hTWmNoZ3IzNWNG?=
 =?utf-8?B?c09oeHFZUUpTRUV6TXR2WXhDTG1LbEF5Yjk0NTBqZnY0bTBKVGJqOWgxTjVx?=
 =?utf-8?B?My9CREJaWlkvVHZsUmpJR25jcklyeE5WZ3htT2lTYjNqdldDTkVudmhWNFVa?=
 =?utf-8?B?SXlqRHNZb0VYbEo5S3YwVG9YMThPZ0xkNGsxV3lqWWhhcUNVTFRoMEE0N3Az?=
 =?utf-8?B?bkdVMWF5bGgxZFkrZXpEdjR6bVUvT1FhbS8rYVNoNk5neXFMbHpFb3RVUVB1?=
 =?utf-8?B?Zjk4cFlWdmN5UW03VnNDTXE5M05ZMHViQmFwQ2w4ME1Wd2ZvTndMZThLN1R3?=
 =?utf-8?B?VDV1TEtTVm1SdElMSk13RytkSTI3RkNqYTRmODN4SEZwUUFEL081cXgwK2Nl?=
 =?utf-8?B?bkNkcTBYV2dNUVZDeTZ6aXFMOWdiWmptNDlRZXNZalh6VWRBb3pVOGlwRmdL?=
 =?utf-8?B?Q3NnR2J3blN5YmYxOC9EQmg1d0ZTY1N4N2VKQ0tvbVlHQS9WUXl1TlFUbFRO?=
 =?utf-8?B?Szg1bGN2aGMrZkdpOTdJSmZkSFROekpmQTkva2FtZzBVQW84TlhNYjhDcTNB?=
 =?utf-8?B?aFFMd2xPNVpRMUVCZnR0NGhGN1RpOFptTmZmN3BCTndtajUvMm5aM0EzMzVi?=
 =?utf-8?B?Y0h1a1NLVWQ5dTgyK3d5WTMzLzY3Y25UL0VNdkdTU25DanJpSnpDV0tUMnI2?=
 =?utf-8?B?K0xoRFNWd3JjamVCUmt2NkE5a1FXbGdrczdWa0tHQ3MrK0lJck1TNHJNM2lo?=
 =?utf-8?B?Nzl4SlcxNlJQcnYzUkJad0trTVFaS3l5eTlyeHJPT3ZhN0FRWkJOTHp0SldQ?=
 =?utf-8?B?c21ZWC80UENTNkNmUWdMcGxPa1R2RHhiTUIwemp2YUxVRVR3YXdSU2U2KzhD?=
 =?utf-8?B?ZXNVaTVENy83NmN5UEhyZlNMbUxBSW9aT2w2ZjNpT05QRjNPNjZtdkhCUlVs?=
 =?utf-8?B?cGo5a3p5MkpNZ3lLN2lWbG1MeDNuc29oZDN4T25mK09OeDBLL2xCeWlFc2RI?=
 =?utf-8?B?V1FQUGpzTURVUHpXbE4vRjdJQjJwK2pJSUVCYlpCZXpacUtrK1ZnSzhSRnNP?=
 =?utf-8?B?cGhwZU5kS1ZJam9KRUtyRS9vbnFIeGJTeW91Q3R6TCswYzNnRGtzR1FIQ010?=
 =?utf-8?B?dElzT0dhSXhkalNBcThMRTN4Nm55QWFRaVBqdG1ZU0xzUzdVeCtweUVaOGxC?=
 =?utf-8?B?b2RwTVNMMjlkbnh1Z3NCT3dMOUtCUTMwR0dxV2tDdktGYjNjVVBma0dNVzBr?=
 =?utf-8?B?dXNoU1JJLzlBdStYelpNVTR0Nit6UW1LdHVXamhJVmZwditEcDhBQzF5NURm?=
 =?utf-8?B?aDl6aTN4dGllaG9SUkFGaEF2aU9pZHZaQnZxTDlscU5USk9VaU1CRjRnOC9V?=
 =?utf-8?B?WGR2eU00TlFKSGR0dkw0anFmNklZSzlzUEZmQjF4QnBieHBxeitFUm1NcEhw?=
 =?utf-8?B?dHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24a8cbc-dbb0-4535-7ef4-08dadf80f6b4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:17:01.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyhqaVP5nNeguk9e30eSRU3e0tclzfqk6Jhow2R9ya/uAkXVWEfQTl82JL0CvSFfjr2RO68BueG2t6xOIpIO0CZuce4LCfBAxbc201H79d0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160141
X-Proofpoint-GUID: wz1PLL9iATQk2_KjUriRpz6R-VwZ9Cpc
X-Proofpoint-ORIG-GUID: wz1PLL9iATQk2_KjUriRpz6R-VwZ9Cpc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/2022 11:10 AM, Alex Williamson wrote:
> On Fri, 16 Dec 2022 10:42:13 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/16/2022 9:09 AM, Jason Gunthorpe wrote:
>>> On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:  
>>>> When a vfio container is preserved across exec, the task does not change,
>>>> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
>>>> mapping, locked_vm underflows to a large unsigned value, and a subsequent
>>>> dma map request fails with ENOMEM in __account_locked_vm.
>>>>
>>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>>>
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
>>>>  1 file changed, 10 insertions(+), 7 deletions(-)  
>>>
>>> Add fixes lines and a CC stable  
>>
>> This predates the update vaddr functionality, so AFAICT:
>>
>>     Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
>>
>> I'll wait on cc'ing stable until alex has chimed in.
> 
> Technically, adding the stable Cc tag is still the correct approach per
> the stable process docs, but the Fixes: tag alone is generally
> sufficient to crank up the backport engines.  The original
> implementation is probably the correct commit to identify, exec was
> certainly not considered there.  Thanks,

Should I cc stable on the whole series, or re-send individually?  If the
latter, which ones?

- Steve
  
>>> The subject should be more like 'vfio/typ1: Prevent corruption of mm->locked_vm via exec()'  
>>
>> Underflow is a more precise description of the first corruption. How about:
>>
>> vfio/type1: Prevent underflow of locked_vm via exec()
>>
>>>> @@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>>  	get_task_struct(current->group_leader);
>>>>  	dma->task = current->group_leader;
>>>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>>>> +	dma->mm = dma->task->mm;  
>>>
>>> This should be current->mm, current->group_leader->mm is not quite the
>>> same thing (and maybe another bug, I'm not sure)  
>>
>> When are they different -- when the leader is a zombie?
>>
>> BTW I just noticed I need to update the comments about mm preceding these lines.
>>
>> - Steve
>>
> 
