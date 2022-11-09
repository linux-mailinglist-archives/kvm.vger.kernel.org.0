Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87178623437
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiKIUJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKIUJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:09:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847DBFCC1
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:09:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9K92Xj030048;
        Wed, 9 Nov 2022 20:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Itp6uEZqMmbzp35QjCftzxN/JzydA/gG8O/L03poWsE=;
 b=RpfXBy10Y3H19rBsHFd4ZxWkk8xTNiD3jnkJV7Li61VqPGjIjZv6QU6EyoP8CyRH4A++
 ihSZQ44jKo8bIypIlLO5Q+/aLkgm0BQ6W6pMgmnTigsIKeFev2trgd5X6WvAjhDA8WHq
 ilNjkAUN7DRM4zKuCsC68yD/AaBX8K7hqhlVHZM/4cvFmsMmf1/uj6JMx4xzvG5PBCYI
 1VwFrYrqftUy25WjfdsHOelVD4n/UPDyMboOQwaGTrmIXJ2/iUZWE6vx7rzD0+gIA28o
 YtJ6iMMQjjBCmHUK5UXRQ8PyM5tLpF/1TL9zAMfYxakxdoovx21WwQuylKRJ1vSch8bQ ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krj5qr4pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 20:09:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9JWgmH040490;
        Wed, 9 Nov 2022 20:09:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqj06fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 20:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzPZ525s98wFhXZ9r+uXbxrej8hRogpO8klB2GLIhfLq2HbA0prNkK2ojYthFoEKRiEPEbG2KSu/snBpzCBqIMSw14v7S+IgQuWSBFFMdoeeHqvvDnH8y+oy966kS2tgO780pLxFxsQsF3gn38Ib0UeQ2iRiSIUAOCuwyLeq2/gPkQkn85d0WrVQXb98PQY9v+ucvhQPAqByxK3nKxf/8KrdETvF3rz6JWYWGvMpjGd6J+pspkCjg1QVqU+l3J3vjI18Kx0oz2yvT1zCOYl4v+1wzE7d2tnrmSDkdbMEFCrKw8sz/o9OYJM4zyLb3gcjgdLTPH8gieFvKYhWUeLiGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Itp6uEZqMmbzp35QjCftzxN/JzydA/gG8O/L03poWsE=;
 b=UHaMr6aGk92jvYdUixzE10sYm+pe7POeho/ZiPE8Ww93FaD5136ATGRq+ltDvPOruLeGyeeDK6ueGp43GNoHqfrPIIkiXClChReizhM0Gl0bFIUIO0HFj6M/3qUNM7F+mk4LRz3cAHhbjMfKfITCjWtBdBjsqOaOxHadTRaV+MCgSCco6dbKgfy85ij2aD7cb9b5xDqBUn9cy8xW5fTzVjDerM7pJCY4v+qhjJ/aBzXrAchcKh7QedvKg0PU8jMEjP/HgdYyGm5fGtBwl4ZAgEkt0/t1452AcxeHs6sdhoQOz2U7eRTWy0S7aXbsXqFLKqAUAfVMX6V8Yq1kgqYLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Itp6uEZqMmbzp35QjCftzxN/JzydA/gG8O/L03poWsE=;
 b=qAF3Nf2c7RPLs44Pt+pVtxt5bsNNo6lDStVfEjUWgUxm7ambYzCl3eaXMagV6mc55t8Gi1T+FFNSGkdrvKEdVg77F850AmG+vq4TzRLL/F4xv0Dprct6KTMhngBzsWR4q3ZZQXE4xSq8CirFBCM1liPhzvIfM0/Vp9WqbbG23iU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB6083.namprd10.prod.outlook.com (2603:10b6:510:1f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 20:09:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::29f3:99bc:a5f0:10ec]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::29f3:99bc:a5f0:10ec%2]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:09:17 +0000
Message-ID: <37ed7542-6b65-acd3-fb9d-91f6562e3216@oracle.com>
Date:   Wed, 9 Nov 2022 20:09:11 +0000
Subject: Re: [PATCH v1 0/2] vfio/iova_bitmap: bug fixes
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
In-Reply-To: <20221025193114.58695-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0009.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::12) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB6083:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bb2d23a-8b36-4bd0-f12e-08dac28e47e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/K74Ike0U1QVDjuHcLGkL7wmC8mp0Ynk0W1Nj/N41JL0IehuZ/xeGDZjKJs/XKR6Ycn85MHbxGRv6p7/CI9VP8C3O9njOSc3O9hJsZkbTF+i0DoDtot3EcJBGcVESRI3BJniFhRccqFLC2a/6GRUsI3eBgFvu2LhoEtcj78PMl/WeSoCdTdWu+CpSvV+4Q4NZM07NoXq87S3xA/qm0V9/tsdk409Cr46iHnAY6PjfZNcBXzx6KAdmI0PbZmH+97dN9Izjxn5hSyhdyYpNTp9CbOB5yUzNosBgMoVNgcNzfLk56cNlyLxxRGF9/UN93NwHALly01aBDmv0/bPdrSZGWI+P7slVxYgsZBDJpeivF5hdsYLWtLbusExNeoHrRpXLV1AOtwFtDZBDm8z9o9TdTL3YQfEg2qrK14PpGCUlte95TY2iFOrlphUserz+bdSLW7GfBWevxeG3ZSuVVPjz9SHSgoKNn6lxiJKmVN4v7z5NVkdiF8C/M7TUx0vL/Jy7v7TVud3syK/Nses584dbDR5dg7yu2xWQi41l9Acp0aAUmiff60OE9AOkXTZGl8tYjZRmRTJF5avo8tKPrBuRjoIFJSCUUTIQBXphXJHjrVVpnc33JQN7glDDZOnlfDv0qhAgaY0utK7QHU7YJoWtOo4E1iaEOSwFUrTFu1QIm9R6gNn9mVOU9mQqYyqCPzA3oC2RnsV35HKvsuZLJxyi1R2QxmDeDBgD7WCnBs3P2lVv4YPrCCXgPuHGkt59Ce
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(83380400001)(38100700002)(186003)(26005)(6512007)(2616005)(53546011)(4744005)(5660300002)(2906002)(6486002)(478600001)(6666004)(6916009)(8676002)(4326008)(41300700001)(8936002)(31686004)(6506007)(66476007)(66946007)(66556008)(316002)(54906003)(36756003)(31696002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGZaWFAxcWdsUTBEanVWZi9lV25IN0g0NDV0cDNzbW1TbzFJYVZjWXQzcGVr?=
 =?utf-8?B?Tkx4TXpXU2piUDZxL3AzVEhOWHRUUHppdnVvUkx5OGlRVG9nYVpSeEJodUJP?=
 =?utf-8?B?RnFOeHFrQ2JVVTlHbXpwY1RlWGgwS1ptWnJpNFB6SStGYnVEYjZNWlMzRjFi?=
 =?utf-8?B?WE82Y1VIUGpBeTBwR1A3alVTZU9wZDgzMVBoZWM0VHQvdThTNjFtb3Znc0Q2?=
 =?utf-8?B?d0d0K2p0bDhmRitTWm5tYTl6ZDVac0hmczFqbmFJaDcwLy9PbG43bW8wc3VN?=
 =?utf-8?B?RG82dHB3Uy94YUtsZXFXZUFtRElpSU5xODNPdzN3TW9NdTRoT0s5aVlLNkNH?=
 =?utf-8?B?MVpKYllOUEkzbTZVejJXa0xxY3ZHVDEyY1UycTNteUs0QllwNnRzemtiSGU4?=
 =?utf-8?B?ZjF2NXpDRzdpM1h4SDExRGxuNm9uUEZpTGNDaTB5MDVaVHIzUHVzQW1SVVc0?=
 =?utf-8?B?dVZRYUJ2blUyUmtROWRCYXk3MTBLSjQ2ZGpXcHIrOTJMZmlwcTJLaDRrcVFX?=
 =?utf-8?B?SjNxbi9JNG5kWjM1TFVRKzdINWhsQjJQdEdabmo3SC9ubEo4enFWVFNhQzVQ?=
 =?utf-8?B?aHBsK2lSbndHdC9VRDFOWUpjUVIzcDZ3T1NKcHRKTHI1UmVEdEpTZTF6dUYv?=
 =?utf-8?B?N2lyV2xDSUFFdEw2dVVUNlZac2ZIUGpvdzE4S3drbXF1c1pWeUtDQU02VHdP?=
 =?utf-8?B?ZEZwZE9VTjdpbG5qVld6YWg1b3pFTlVKVzRqdTlMR3RNQTh0Z0g3dkpvRlY5?=
 =?utf-8?B?WW1NQ2NFSG9sYVgrZEJNbWdpelVQb0pIMDJIOW4xbWVDYkNOOC9NT09QZWM4?=
 =?utf-8?B?Z1FQaFhTZlIrTzNvQ3cyNXRuL1M2cWtKZTJkNWI3RlIrS0JtNDM0TTVpYlB4?=
 =?utf-8?B?TUhGSmtFL1BoNWhKbnkvZW5HMDNoZnRTV2htWjI0T1RNdnNXdEdrRVNDZDk5?=
 =?utf-8?B?d2xQc0FNY3MwZWJFVmRnUS9tRzc4WnBzQXdQSXdUQnZPSjAzOVBGUFVsRFZY?=
 =?utf-8?B?c1Q2R3JDTEZROGhzNStYeWZhMlp4R1g2S1poTnFjNGFDTGk5ZDA4OUFLdHZ2?=
 =?utf-8?B?ZjI2dExRS05BTDB1REpqSll2VHBrT2o2eEJZTXRHZnVGM0wzQkV2aERxb0Vx?=
 =?utf-8?B?SmYya05oRHZwejdvWTQ0OTNGN1NRN1JqeVYvcmlNZW91d0diem1NSVVGdFZ5?=
 =?utf-8?B?bXVSVjhYU090VlBtU0lhLzhXL3QvVWZna093Z1lvUlp5NFRMTVZ4ZWk1N1Z2?=
 =?utf-8?B?eG4ySGE1d1JYanZreng2NWlwYjQzMWZlcjljNFgxR24za0M1eDhHMktiZ3cw?=
 =?utf-8?B?NzJ3TDF0T3RHNUpUa1ZyaFN0bDZTakU4WEtWV0Z3Y1VGTURvaFlXU3RJT3pT?=
 =?utf-8?B?RjFIK0pBK1VLcUNHaGV4RjJuR1BJaUxPWDNDMGRuQnB4eHJBOXVxS1lxKzNQ?=
 =?utf-8?B?Zy9SUHFRbGRoMHg5c2NNaUZFRnRycjM2YWVVWndGVWx5V3VjbmYzZlg3M2pL?=
 =?utf-8?B?V2pKS0FJb25aelliaWFHN1RQaURPNlR1Z2ZsOUJRUVZKQ3hDdSszVjdrRkRC?=
 =?utf-8?B?REcxak8wdmgwMk1kUDZXU3BGbXJMaTVrTVZTQ29sUUo2M0gzL1ozbTBwMWo0?=
 =?utf-8?B?MW5ZUHdhQjdodmowU3VmdVBRVkFlNkl4N21GYUZhcmlCYllZZVlqalVMZ1ZK?=
 =?utf-8?B?WHZCTXBCa2lTQXB3cmxlM1dUc05RR3Y3L1JsWXMvdDVzSy9yZEtPT0g2eVQ2?=
 =?utf-8?B?QVRQc3U5K1ppdy9EdU55NkpJakFXQjFnVkhwdDA0VG9LOWp3S0RZTUtMM3pC?=
 =?utf-8?B?aFVhcnVlTjZLaUphRWVCRHcrdndTOUdPdEYrdkkwY09tM2VzNlZzZHZIaWtU?=
 =?utf-8?B?Vmt5ZjZZc3lsVEwwZUxvdGxheXlwM0Q2b2MvWnlrU0tISU9QMW5jeE1pZS8w?=
 =?utf-8?B?SS9ZamtoRUVMTkNLM29NZ2drbGRlS3M4enFpZUhVMTB5ZWZqTTlsNTRXWDV3?=
 =?utf-8?B?SDVCNEVGK3c1aG1Gd2NaTmhYRnlBL1BLZUZyUXY4dFpwRmhHZTBpcHcrb2tv?=
 =?utf-8?B?cEdvR0hCYWViT3kvK3A3RjR4cEljMzBIZjJ1bnhwL1BtZlhLK0lNbDRocWtV?=
 =?utf-8?B?eG02ZkIrRWVPWi8xZ1o1VTJ3aFVXVEFac1hxVWZ6RHJzTWRDcnE1WXRZRXps?=
 =?utf-8?B?Qnc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb2d23a-8b36-4bd0-f12e-08dac28e47e0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 20:09:17.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNDKT+LRBQjMKC1RTCZy1dKQwx2cCMeqneTTzJWS64d7EIGJr0nVQquZlT/1dm2RzGkrHq+axdEKcXmtaNtcUAcbXFHEZb+E5N2h9WOZny4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090152
X-Proofpoint-GUID: xnbbhs82qbdBmaCrvVBvcl76iqCIK9aX
X-Proofpoint-ORIG-GUID: xnbbhs82qbdBmaCrvVBvcl76iqCIK9aX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2022 20:31, Joao Martins wrote:
> Hey,
> 
> This small series addresses one small improvement and one bug fix:
> 
> 1) Avoid obscurity into how I use slab helpers yet I was
> never include it directly. And it wasn't detected thanks to a unrelated
> commit in v5.18 that lead linux/mm.h to indirectly include slab.h.
> 
> 2) A bug reported by Avihai reported during migration testing where
> we weren't handling correctly PAGE_SIZE unaligned bitmaps, which lead
> to miss dirty marked correctly on some IOVAs.
> 
> Comments appreciated
> 
Ping?

> Thanks,
> 	Joao
> 
> Joao Martins (2):
>   vfio/iova_bitmap: Explicitly include linux/slab.h
>   vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
> 
>  drivers/vfio/iova_bitmap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
