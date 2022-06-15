Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC01C54CAB4
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355472AbiFOOAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355512AbiFOOAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:00:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB4A4A3F8
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:00:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FDvMBL013333;
        Wed, 15 Jun 2022 13:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=r5pwv3s3jrrSmU6ATFm7CvGsLuJe44D8Rv8s3w+Jb+0=;
 b=EUJKX73Id6iGTYbb/EOZCStHHk2KPqdeN7h/8xgT8XPgvBO8SVR5kbBAUXucj/Hz5/BD
 j+HMSrQtctW62Qq1WqDHYnErYT1RYsuxQLnyb+YWQgGniJMYuqIEc0pZ2f5j9dvNWvZU
 EWQCphSGbqZdtrkYRthp+FuggRhiDsJZf7w46JcX3KnxsCiJ5ICLSB/o6s2okLJilX7z
 mYFF4duOEFbPk20wLSiN44gAjNswHJE4x+Gy/ju9ZAAKtHqNs8OJIOozZJeiVz8/m9Yh
 e1xZXPwtxcg6BuwfCrIumjhKR7VYnrPmZy3rYuMZ/JylNnYVUKBMRV/nE6bWDbQopOyM oA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktgp7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 13:59:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25FDuMSU004285;
        Wed, 15 Jun 2022 13:59:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbrt9w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 13:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWKOaeJYrMYfZowNTcr1AcCFLV6vdXcFkkTtrGs6HCJ9i3RVr1ws3nERQR1e6QO7TWA4ta2RzShl3HCwqOAIrlZMTQ+SOI2e2uxtrPw44e7IYws7PQXPjGjZjKUx2KlF0q8JA8nT3oLJtAhos6APGpzXPRPjCm517XWJ5L2ScQ35RPRQ1xJ3vp6U1g3JVYBVCSUK5K0dH8oOsRITux3UU0fuaEsy0tl8q3S6ZzQstDOQ/aVcyghyJNH6AC2e4iF9XstEC8PLZ5O7qlKEq61UOX/WoDduubP+bngHhBxFzpt+q92YVsQpFYutGd1yNfQPFvIYkbzS7he3bK69r0TsZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5pwv3s3jrrSmU6ATFm7CvGsLuJe44D8Rv8s3w+Jb+0=;
 b=SoPJuyM9CUOPKn5OTdclkwkaBTBjssFkGdDAy7EfwpO3eXcJJxeQNeVFgEMoBPTQ6X76SPKDAAdH2p22gRPuZoKtXrCx2mlmvH8B3/rLOprLa7KVLYfJepQVpVYzoF48WtCJHNJNQTYwxcCpNP+7reBzjeolVnji8KurMvtxLw1pLakDLueqwjIWFjD87pvygYUttHE++mFl6leP+nt6Y/xDOxoUFH4enMABCjBdjeec/AvUtWZ1Re2BX1D88YUSfP5UxVDOwbeApNsEynft6/O4NYzdN8AZJ/8S5bIGwo29mrWcukrEsV9M3cj+vGhVG57yPUQFo5TpkFcKg4RqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5pwv3s3jrrSmU6ATFm7CvGsLuJe44D8Rv8s3w+Jb+0=;
 b=QmQFfrieNV6zq/mUCWKfWnHWqWhDTZ0wNyXdjHE47XBsJsFVpQpB3813vrFTKs03pI1kyClPnx10Jmbhzuvo8CZ9v6nv+LZ/KKPeScdCB23a9tdK4xdPMUxBdhMDAwPIPiiVZMvvSLVbk31/AkCR8ABv6w2cS2dY+gNK0nB2k6M=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4039.namprd10.prod.outlook.com (2603:10b6:610:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Wed, 15 Jun
 2022 13:59:53 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%9]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 13:59:53 +0000
Message-ID: <c9ecff6e-6822-095d-24db-afc3227d4c8e@oracle.com>
Date:   Wed, 15 Jun 2022 14:59:45 +0100
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     jason Gunthorpe <jgg@nvidia.com>, maor Gottlieb <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, idok@nvidia.com,
        linux-mm@kvack.org, Alex Williamson <alex.williamson@redhat.com>,
        akpm@linux-foundation.org
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
 <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0509.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd078426-9af1-4718-70e5-08da4ed751d4
X-MS-TrafficTypeDiagnostic: CH2PR10MB4039:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4039D71F19A0316CF47A2C52BBAD9@CH2PR10MB4039.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gc7tVZaurbFWIYbC9Xh6neAiveAuucd7iSWRf5XQxC/ZmTOKSdSRz+86YljGMlxweYoKnZ7METKrLzfPvGS/g9pYkv4um7NlaytT1F5woobh5yPG6l0KmDCl9If+BG14C0mvsgkXfkZZQ5q0OvMc0/jEvsI2X15iWl7Jrig2n79LeBoQ+zzf+xLSriMUbbWOzU37qi84m75D1bp7TraaFrhTxpult9UaMkEtwcFjOb784+KN2JYPGJPK9zB1rbTfFF9DgP+F1o1UuYK9JCYaVM6RDkOfNOtzi2Gg4C2Ysobyppi5nHmGj48VOLOlgSefUXeTLreStsVUyoXtuGssHBC3BOQlLk+Dlp7KZyc3m+ethxQuLJXF9HZG3umuk9zJ3bGNfQbA/VHQs69nnWg3X5lxQ1A/VS1CxhtvCy9FZ9ZPf8EkQqKR3ebKkM6LONEomC3sWzt/xohqvkl1emfUARyncy2YR49gsDvVZfmibNXQ78zRDxd8P5yKwSk5YcrgekXoCW9gswop+u3ID9oL4hHPTUtHsnxGkCTWA95eZTvtUYeWu4cjVPpRSlBp61/9EVXLTgBR+wC//C1ZVAdt1cMkHV4KP8+4K935QXn74HhILGCu2DmVvGfxHAduuPmagYX69dAilCs+1eQQZZM2rkc8Pc7+7v7OSEOrCNuxADVwcS8fCf44Ah8W/fze797RTvpq9G+OgeNxuA5UG57E7tlnx5yVEcoamvZ56fxcCA0ZCcuym+9U0nqNF/zZtLMlj3cQLk59vCOtlqNZPvTmRCVU5jem1xm8uL06i+9A0FlqM0t2CS0ucgyzahx3x7VddtfCbeJ7QE4D9xe75vXU0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4744005)(8936002)(966005)(6486002)(83380400001)(186003)(508600001)(5660300002)(2906002)(54906003)(6666004)(53546011)(26005)(6916009)(6512007)(31696002)(6506007)(8676002)(66946007)(66556008)(31686004)(66476007)(4326008)(38100700002)(86362001)(316002)(36756003)(2616005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDBLQUlGWUlTWkJoSkxQQktpV3Q1SkE0RTNJRUZWa1RGS3A0VjQ0c1Y3QVd5?=
 =?utf-8?B?WFFLbyt4YWhJei9xZHFDN2E2WkRxRG5lb2l3OURsTGJlNGRwSnA3aXhaR09K?=
 =?utf-8?B?YmxmYXR4L0pSVm55YUVwK2h1YlFiMkVCbnBqZTJXVUl4WmFZM2dJMzZiTG1C?=
 =?utf-8?B?WGZnRHNHK0dtSlJ0dStHNXdJUWxpY1dFRURLMHkzUWdNdC9oYXlnbUFOL1dM?=
 =?utf-8?B?dGM1elN2aEhZWjJNbCsvMkFQK0QzOURxb3NRdXcwS21WTVlqYVc3cmovVDVi?=
 =?utf-8?B?c09IWGN3aXNjU3lKUmpiSmRvQm1YdU9mNSsyTzBJdnNlOGU1QytucThtdEVl?=
 =?utf-8?B?SVROT0NCOTA0cmQxckxGTytBZXNuSTZnbmUyd3FMcG1yME10UWh6S3crV0FT?=
 =?utf-8?B?MFprZmNWWGpMV0VIZllxdCs4RTFJazhucUt2MkRrSTdpc0RoQ08vMFhkaFda?=
 =?utf-8?B?Njh1Qi81WjB1RlFJUG5ZMnp3TDFiWndqdEpSTmhHdVM2b2dYdmRpOUtOV0NB?=
 =?utf-8?B?UmxOMVh4am1qbks5NWF5MXA5L29aU3dEQzl5UklJNVBUeUlzRDVOT0QyNXZt?=
 =?utf-8?B?N0w5TVJoV1UySWtTVEJWbFIvOEUrdWVFYWRjTlRrWE8vang4WmZUZGszSFBB?=
 =?utf-8?B?bXlhQWZJTUxMVTIzemdMOWRCRFhkOHZ6a0JJSHhMRVU2alByRFltOTZHbkFG?=
 =?utf-8?B?M3hYeDlvUVJsb0lMQUwzb2JvKzVmSHY3RWhsdHJ5SlRzNEJuQS9BSi84MG9V?=
 =?utf-8?B?d0Q1VnlXcXEwa2M0ZGlyTC9oUi9KRldBMENsNysyQk1nbzBWTTFhaHJzZHNI?=
 =?utf-8?B?c0pWd2pPNTR1SVNOdWFWZCtQc0RxL0g5aTZHYTQzVG5BbWxlSzBGOEZrL0lt?=
 =?utf-8?B?Yk0wNmZGcTJzRTlpbkUyc21kR1RVTjZ3UWJlRFJNTEFRcVRXNjJvWW9CZXlx?=
 =?utf-8?B?MytLdEl0S0dhelFjbHo3VllwOWJqSytqSkdCeW4vYUl1SDl1cVJxNXRYbTBY?=
 =?utf-8?B?c1lrQ3hQOHVQUDMwaTdVdUpoNjZ0ZWp1L2tYb0MrNE9ySThPcjlXb05JOGYr?=
 =?utf-8?B?RFBZVlp0cExNWHVIb1RaMG1NeTg5bjhxZnhaNGtWWjRIOUZjaHR1czRyZ3RW?=
 =?utf-8?B?WVpzdjJ1NEswOUFrRDVyUDdjYUJWcHpxUW5uaStmR09XWmdPbmlyNUhwKzFn?=
 =?utf-8?B?ejVaQm9PeDhJbGtQbko2SlpVMklXZzNEQzl2MVJ0NlV0U3Y2U1Z1V29uM3Jj?=
 =?utf-8?B?SnZudEFnVGc5aTF5TkRDeW0xMkF1SSt1ZWxUQVNjcDgzSDRBWHVFVWFsM0Ry?=
 =?utf-8?B?NDZWaWJWTTcyQlZLK3BvZXFNREVQZW9RNVdYdXdneXI1eTg0V2NKeDMydlgx?=
 =?utf-8?B?djJLVHNTRHh4THZQVXZ0UGhTUUJ0eGhWM0taRnlQeXFwY3RzUzhmbUhuemFU?=
 =?utf-8?B?M1JnVUZjYWN0TVZTdkpNSDRZSVZBN0kySHJ5NjRYYkhic1VnWlZ1dGVwbTVR?=
 =?utf-8?B?THdvdTRvM3dxbGhEVlhENzVNcURRUG9oNTZHdWE0QTZraVI2blk4b0k3VUZV?=
 =?utf-8?B?YkUybXJZVjJlVnR0Rmo5SjNYQVZ6dWlXekpubXJ4dllMMVVxVkptRUpYYjNT?=
 =?utf-8?B?TytvUlJqWFZLN05jVFNXK1ZEalpoaWgrMUhQazh5YnV1b3BjUTVyZFEwYkVP?=
 =?utf-8?B?Tnd6L0lBUFlpSUthalU5WFlkQVI5QW94eHFyWUJZZkpjc0xZakFBQmhoQXRN?=
 =?utf-8?B?K0FMdm9OZ0U2UUdub1BGSi9xUTEza3pMeTZhYTJZU0FTaGR6N2tsOE5meXQ5?=
 =?utf-8?B?eE9CNXJ4Qjg3VCtQcjFJOGEvcFhpUTRBZlBjV0VqTTlZelE5NmhSTDJHc1JK?=
 =?utf-8?B?MktYczNNY08vS2xLQit5QitOMjg1d004QXdLYUpMWnpJMEZkK0ZVN1gzQ0Jn?=
 =?utf-8?B?ODRrZG1lR1pWOGZEOEY2M0kvQlp2U1dxdmgydmJTMGtOVGVzQW05aURrTVU2?=
 =?utf-8?B?ZzIxdGdZUi9FMnF1bGYyQnV3Uk94VEkyWGQxVlY4V28rdVpGYlY0azRObC9i?=
 =?utf-8?B?elJ0bnp6UDl3UU1GVGY4UHRjVWw1RmxpVTBBWlN5RXc1Qm1XWERsOEliYTBo?=
 =?utf-8?B?SUlzdHZJdzQ1RUMxcjNlTG00VHBUaEs3U1NNOVh2cVJsWjl5ZFZhcndPYWFI?=
 =?utf-8?B?Um9BUzl4NjRSWkpsTDdzT0NyVGRvTWRFVFAreVBhQWIwQWtzQzJIOGJKdTIz?=
 =?utf-8?B?eXVaTGhLYkpXQW9pUW0xOVZKQ0hva0x2d0RlSW8rM1V6MDRqQ3d4M09vdThC?=
 =?utf-8?B?QUd5MWZjSFlyTjJ4bFdLM3UxSjBOWWRKZEJEQnNPekxuTktlY216QllERm01?=
 =?utf-8?Q?wbR48HcDxhFj02mA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd078426-9af1-4718-70e5-08da4ed751d4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:59:53.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NR5dIutIYLHhkIIWSe38p/qgpaOoLzBc2HH9FUclMgntwfmcebXwi7uJuTI27OM95sMMx7aLJGwU132ka3/6NQnBLPFwDnYXlpCukO+cjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4039
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-15_04:2022-06-15,2022-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=881 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206150056
X-Proofpoint-GUID: IFz0FxjxFie1sWfZbnDXsQItuYVhCw42
X-Proofpoint-ORIG-GUID: IFz0FxjxFie1sWfZbnDXsQItuYVhCw42
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/15/22 11:52, Yishai Hadas wrote:
> Adding some extra relevant people from the MM area.
> 
> On 15/06/2022 13:43, Yishai Hadas wrote:
>> Hi All,
>>
>> Any idea what could cause the below break in 5.19 ? we run QEMU and 
>> immediately the machine is stuck.
>>
>> Once I run, echo l > /proc/sysrq-trigger could see the below task 
>> which seems to be stuck..
>>
>> This basic flow worked fine in 5.18.
>>

Maybe this one:

https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/

.. but I think it's not yet merged for v5.19:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/log/?h=mm-hotfixes-unstable
