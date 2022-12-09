Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BFD648888
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLISkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 13:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLISkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 13:40:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A559FFB
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 10:40:38 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9Hx7da019785;
        Fri, 9 Dec 2022 18:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NTXB4GdI6pxjHjDX+F4ZRIHNwzcHbK/FAqYnWAMLIvg=;
 b=WNaSERvZU1XdeANOmfrEhCCv8YWbd03b7X7Xwv3ooFzrYo453JLzQmwdwQ3e/B6xfZEF
 i8pACoP7VbEBhq62hBD9erIBYyFZ534MppW/sWSuKYdIDKNVMvknG8vKOQCUXZbtxfW2
 HuYqp1SsCp6wDZF1kOkJxtIVzWvk4otFgpVHg1UHOCIZPVpBsOJ2LjsaVEcTVv3ZI3wh
 5Qwy3tbUrEbbGiu+H2gH4agBjkj4dcHn83mezffuLzJ9BcZrTaYNju6jd2UBKlD/oV8W
 mK6egWr2fcBg8KHbNfwjukvF3LNSUBSVXG9qebHw65krmzV4khWr1r/NFTBwEBW4VAYn 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maxeyw233-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 18:40:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9HUetb034771;
        Fri, 9 Dec 2022 18:40:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4u8few-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 18:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjhH1+YrTuF5tRzEhnMeNlQvcg2uxd+snqj83aMMd4j7LF4pEk7SD/JB8u6cDjLC4+7KnsMrJcn9COYVslXXWpCOIKu7dZLsdMAZB/dADXWRt5O6Mn510oK0lf9+b47VbBX5Ly8ZNhr+pGX8IgtQb2hwtHKegmaT7DjnDF1QaXhdzvxSANSyu2p60YmX9Wd+Z3UHRNBvn45TD30Hba2xOsRUD9R+0uJVk6X0YYJQ8Gua40vFiV6ZCJi6cQXnYJ36aTyg8r3bzCAED5dNhnxFuoifijrvATxTrZfGiPcEKURL8d9+xWTHP/GANMPukNVYje0Hh3cICgDPr+h3YHxzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTXB4GdI6pxjHjDX+F4ZRIHNwzcHbK/FAqYnWAMLIvg=;
 b=AfuNGsfLjQlfmGPrCsw/Ncur19s+bsi3PP2vW1zSgC4XqvQyVvts6Pq2VSJh0OiRPv3x9xwq+d+YkcSIYETkLOnGdzbjkgyq8yuVEfoC6WC80mxFE8J2Liaf8X8XOfz1adU73JPWGVtiY0bEztfOmNLLWU1/vDiDw4W/ke3rzt9DflLN4zYc4djmDW/hDyp/Zrdx8xEF813C9tIDOb21Rtj3FI/EOyGi+NeKJvUsqEk0uvsTPqUy69TmTxoFbSYu6vYchf2jxWrB0cgWJbvFfrH9lnKpXrSH+f1gOXsjawRR/LJ4A0dyOT2xqhco0ogl6iodBmc1V4Yfc30RTtJRew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTXB4GdI6pxjHjDX+F4ZRIHNwzcHbK/FAqYnWAMLIvg=;
 b=T2GIErDemXHBV7izRX9zXM53LbXAfbwz5YORjJWMRjprR3cbO6/1KD6xYbGFa6ycYwg7EjEK354xTLqSdmqgTmilAzeGll/V5xHD7hONvGUHqJZZxhWmnJGCqr1CwNSH5XYR1tduFUHbGjwVBIVRjJgn0TFGnikSQirAz+xfQAA=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 18:40:32 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%5]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 18:40:32 +0000
Message-ID: <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
Date:   Fri, 9 Dec 2022 13:40:29 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221208094008.1b79dd59.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::34) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|SA2PR10MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4aaeef-1aaa-4b35-fb27-08dada14da2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dvy18y4BZk2IZw7UIKQYoI89ISO4m/nxwAAtzPwKbyqqphRNH9mVnBmsHxhf3zwBO29w6KTEqmDtdXA1yZG0tkO4VjDi5tUCjk9p3GUeNLSdbzFmy1Aqc8MJMvMc1kY1R35ndwy7UyHgGrsKiv8/c3OZq0srPwh2/6l3LolPTDR2H8zn3gEI3PcPisdCkkBO48t2atcgbb+6B9aapJzTfjraKvBA94ZRuwUNg7Bke5WQq4/3PNMlv0qMwJ78mDWCjgPUzuqhuqOIQLSnDUOfgIyW15HEFNuFitJFiulTXCgp7u8i8pyz29vvbI7s5yvQeqIDpTm/Mt4WGYVaQap9zNJxe2fa055wtDauBI171NiNSBTLqFQfDu4v/cMHMRO0Dg6jQBr4NvRJBhKmfBoDTCcN5JQuXZ9dMAzwamehfwFOU/Dz+WDTui4ihpV079fUV3ZFcwaEWRdzR7sBnlwLaCz7cyKwoII8cV2Bjf4epcgwp2Je2I6JWXU36aSq3MaBtceYAYXu0TtPdnE2mvFYxbcbrJ6X74JxB/u5uezNRRB1LXXHyQBiH0XvuqlFSb7teXE9SHmS0sXTlRynfo2KXZBDUIVw2/K0+x+kUYtcB3d1GVh0wwPQ6W6qfAIkhptaehyKPwtK4Xv4RdeoW8UvfSw/jwPs5hGWJ1OKnKfXdSeLgz1p1afQqblng/tz9JDwuOdqJSvJ8rmmKQ+dJdNBfATkLWVuVLgZ1t2IR6rXJXa7EQaDoidN8nzapZWetBl8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199015)(31686004)(83380400001)(8676002)(6486002)(66556008)(41300700001)(66476007)(4326008)(15650500001)(2906002)(44832011)(8936002)(86362001)(6512007)(186003)(26005)(6666004)(6506007)(53546011)(316002)(2616005)(54906003)(110136005)(66946007)(5660300002)(36916002)(38100700002)(478600001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTBiR2o3WDc4WkUyUE5DT3VnaWJ1MTNac1AyaVBsTkJ2ZDN1UGhoeWhPN1hH?=
 =?utf-8?B?REU2SE9sS0ZkYkd2SFM4QTRvRldualBRUmR2N096Yjl2aEgySkIxbm1QT1Z5?=
 =?utf-8?B?Z01DVmpoLzZOa0QzTXR6dlhRajZna3RsTk1yT2szaFVHVkVQcE8vYy9hL2hG?=
 =?utf-8?B?ZnRxL3pKVEJQZ1N6UGZzR0FKanRCS1pHVjNzUnFmdC9qNnZhVEhoMU5SRmlz?=
 =?utf-8?B?MzFHNytCZEo1dEhLMHhDMzU5RDBOMlltYjcxMzN3aHpMVUF2LytHK2VzYjc5?=
 =?utf-8?B?SHF5M0tRalFkYWRsR0xLK0tQTDdRSVFUbGdMVTY5TjNBTnhsSHhEWU8xWWtM?=
 =?utf-8?B?K3F2cjRjSVQrK3htMTdUWmRSaE9YWk9ib3hsRVFLL2RLbWJkQUNhckdvWWpU?=
 =?utf-8?B?YUJZRG4wUWd3RVZlb0RObnZEMEtCdWRMODRjc0N6YTFvSGRxVzBxU0VFSXRG?=
 =?utf-8?B?NjJXRVFXRzBDVCtXREFEVTU3aVJDSkdNWW5LWmoxaUQrNXpuSnFTK3FWWmk3?=
 =?utf-8?B?RzBSMlQxTzVmTXlrQmRYV0RWKy9BcGpkenFzdDhzbVM5Q1FsaTdwN1R6S1lM?=
 =?utf-8?B?OHl2dHFqNW1SN3hDcDJ6aGR1bjlvQmEzT2oxVzFFQUtmbndnWEtBR1ZxdWZ0?=
 =?utf-8?B?cHBDZHlqTUhndm1Pa1lnV2p4K08xNW1uQkR5ME1SenBpVkwybzVPR0pCTVhB?=
 =?utf-8?B?NUt3K2E2TGRJMWVRV0hNa0ZEVm43Sng0cVNDaEw3YnFqWng1NGkxbVdocDRm?=
 =?utf-8?B?amhqeFlya3I4WFVqeHRxcDlhWVRtQ05nVEY4eVRJRlhoMFZNY3JiSEJSWmtI?=
 =?utf-8?B?Z2lsMzBJS0lXT25JRktqU0d3UCtML2h0Nk10aVUxOEN5bHFDcnpZTFF6VGF2?=
 =?utf-8?B?aC9YMzAzYk5qd0VkUkpaa1FZRTNZSkpjbStlVzNnUzRSbWNUL2h6V3l2OVNP?=
 =?utf-8?B?VHlTcjBRVENsOHZ1WVAvV0NrcTlMTUo3MXlRdWdiVDJzbGFCTS9xR3NDUktx?=
 =?utf-8?B?dzBlU205cU5yV296eDcrQk9mV0lUWlRCWXBZYzBaanRlc2JwM2MrWUw5VEVz?=
 =?utf-8?B?NnRRclVmWmRFKzBYMXJsVzZ6OE9acjczbzVucFJHSTlUV0lVekhLTFRqUDBF?=
 =?utf-8?B?VUxzbllGUzlzLzA2UlBmN2VacjJicy9iSTdhUXpqa3dLNEZrVy9zelNzVHE2?=
 =?utf-8?B?NGsvbGs4V1UyTkNKaVlFaDBhejR3aXJNZTJlalBuRklrWlViVlJ3dXNWUVhD?=
 =?utf-8?B?bSt5TTRROTNocmFON2tJVWY2Wi9wOE93YklDeGU3RksxMUJEUzh4QzRUSm5T?=
 =?utf-8?B?RldtTTIyOTdLbmJDQnlJUktDaFN0QVlycHZnZ0ZFaUo0UnRzVFZNakV0bFg1?=
 =?utf-8?B?NzVCQ1l4S1VtRTcxa1ZtbUhKY3VDY2xoZVNaNjIwanZOVnliNGhzNlRDbWVW?=
 =?utf-8?B?djB4VVN5SHNSWm1JK3Fxd1NCYWgyZ2IvZlVxTXlZVThxYUkxdlIwRndETHBR?=
 =?utf-8?B?WjF1NEdLbm40VjZaNEFPVFUxRk9BeWlxMFdXL0ZDTkNuSEpqTkgvRVhrejN1?=
 =?utf-8?B?cDdGbnVCZ1JyRG5yVGlKZ3FZcTBiaC9odkZYWjdJQnlMaTQ0VmJIaW9IZFFT?=
 =?utf-8?B?MDRQZ3ZlL0dkbjNDbXlBN0hlZFVabkcyREIxMlU0cnI2T2Vmano3NGNYL0JD?=
 =?utf-8?B?NTFJTGhIVXpRT1FDYWtXeU96WUtYTlMxekpnM2M0bGVNR2RKL00vVEZXKzB3?=
 =?utf-8?B?cjI2V2J1YU5JcHY3WWMvckowVTV1eW5ic3dtZzcvSVBLWTJwWVJVWWVPV2Nw?=
 =?utf-8?B?aTRyVUt5NmtUa0dpTitIaVpnV2txMjU3Q2UwY0hDZjdNdG5UWlBRb3lYVzZt?=
 =?utf-8?B?Z0J3K1NCU2lhenNPRXhyOXY3dmhBZWc2RTlBQ3loS3FsSUpzWHVMamg2WkZS?=
 =?utf-8?B?TjlxbFlpZ012NXhhSUhkL2NvQzl1UFhLSHpjem5LVXFjNGdVYUVkemgvOXkv?=
 =?utf-8?B?N3NpMnd6VmpsWkNTYWdpYk1lU08xSytRQ0N4WmYwY251Y3hJL0ZIT3B2RXlX?=
 =?utf-8?B?Z1RQbU1PaEZXeld0K2VDenRoTmFURFpCRjZ2bGsycWFwL01RRjd5Zm1aUnNi?=
 =?utf-8?B?TERrR3JZNXVJTFN0dElzM1Z5NjFRYm1xWGcxNW1WMkZEQjNCL2p4UHNzc2dG?=
 =?utf-8?B?eGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4aaeef-1aaa-4b35-fb27-08dada14da2e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 18:40:32.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gobY6leK/z9Op+dLOMI0iSdGJhKIj8ucQvI5dNBrkC6bATHSZpSSIdsO9kuH00I/z7fonbgakh0V49YUtT6KRFf85XmzptGysBiV9gLr+y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090151
X-Proofpoint-GUID: BSLaMhWxj0syCVt6lN6wI5EUEc1RAmE7
X-Proofpoint-ORIG-GUID: BSLaMhWxj0syCVt6lN6wI5EUEc1RAmE7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/2022 11:40 AM, Alex Williamson wrote:
> On Thu, 8 Dec 2022 07:56:30 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
>>> From: Alex Williamson <alex.williamson@redhat.com>
>>> Sent: Thursday, December 8, 2022 5:45 AM
>>>
>>> Fix several loose ends relative to reverting support for vaddr removal
>>> and update.  Mark feature and ioctl flags as deprecated, restore local
>>> variable scope in pin pages, remove remaining support in the mapping
>>> code.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>
>>> This applies on top of Steve's patch[1] to fully remove and deprecate
>>> this feature in the short term, following the same methodology we used
>>> for the v1 migration interface removal.  The intention would be to pick
>>> Steve's patch and this follow-on for v6.2 given that existing support
>>> exposes vulnerabilities and no known upstream userspaces make use of
>>> this feature.
>>>
>>> [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
>>> steven.sistare@oracle.com/
>>>   
>>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>
>> btw given the exposure and no known upstream usage should this be
>> also pushed to stable kernels?
> 
> I'll add to both:
> 
> Cc: stable@vger.kernel.org # v5.12+

We maintain and use a version of qemu that contains the live update patches,
and requires these kernel interfaces. Other companies are also experimenting 
with it.  Please do not remove it from stable.

- Steve
