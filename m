Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9344B51B1
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354215AbiBNNe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:34:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354186AbiBNNe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:34:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855EC56C20;
        Mon, 14 Feb 2022 05:34:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EAeOop017063;
        Mon, 14 Feb 2022 13:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xY0Lgnz7RfTC9gX5MrEAvS3FX59l5qwRDCNrpgTMLCU=;
 b=u3nxBe+jYczfTt9/Q5ctPIVkGfa8OMDVfyJhsFAV/8JMIGYvkHwWlbMdNekNlH58vnoj
 RNBEl4K6YXTgCqiS5WEsASs0lYOfUO6Jhfm6AJr/X1Gka8PdLK57IhXp3OefBwCsGfkI
 asnZ6H2BVzZ6z7FopEjblDDjgEeEoHZ5hrtgT8Jk73av8ywLdHitFe6R2/wXP33HG7gI
 tN2kpCfbzz6gb/7CBpCXEtaE5emTW16Ctu/LSSWZqbvAFqhtVKYWEYsgd6TJwGBuvuYt
 EE7zj0ThTf6RgvRXMqUh5JpMLYnEb+vSGF56i0epNakjhbC+meM2czoQFgXR6AsjNEkq bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt4fm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 13:34:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EDWPuH157304;
        Mon, 14 Feb 2022 13:34:26 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by aserp3030.oracle.com with ESMTP id 3e62xd3wmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 13:34:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9UcmY1zIwhR85XS6nohXnvShWZy3jOfVSSXopfzyYaCd8GS8vtVgnhFRdGjQJJlO+ti0B782Ocv6eQWL2GTaGBVbYr+9AAkQOULKwD4X5R711+i319UFB/2fSpshjAknnvT6UkKZ1Hz4B50EArEwtSODwGzE3lFpWs/JmH1LaZBOq+Wu+811JauSu6Grls4voYyUpc611zVgigKiHsxb6qJh6OwHVAzRoXwObjzGGYvUf25UnFbSpFD4xqBGGKJDprjzkV6wrTshn1AXQspebK2xVFzenC3UqoRUlSxGsAn/jFunGdG41EJWg7vFkHYcxChW/DKB6UNNbKz/llDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xY0Lgnz7RfTC9gX5MrEAvS3FX59l5qwRDCNrpgTMLCU=;
 b=V1YJ8Z/eQCdjv33gyscNJNj9aZ1u8IyQzrEU38iDChw9rLeK/NSNn06KR2/fAq0heWqzoJod1IJrfuNvJDJjrZKH/CCiJhba3NOmnRKSnjA+kigIETYnlch0oAYylUQq06Nr3q/es/VLbjXLVz0dYp/pqlob2JbXjRnhwPAQOmD2KtgBJMcZ08x7s6/No/al7Yan/Lo5YVAISaKKl9cs0BcC46T+pSMoqWFp/UslqxFBG0910rOGtqxpaDFlRd5Lh19qeJyQLX+Ka/SYtjONSWbTvVUaNF2SwY0txOWMkTD4XEbIxkxqFkpTNw4b5o6EPnrK80owuHVoq4iWlQmL0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY0Lgnz7RfTC9gX5MrEAvS3FX59l5qwRDCNrpgTMLCU=;
 b=ywgoEXrtBoSuNEhWIPRTEE4uW3HF5KVrX2wkwjuYDs4B828S7PQazkibjapagF1/N8btFJ7Z2k6LTtHd7AoZQ985eT4ad1oUNB0LB3jIpWm/r/K2z8GpJ0hQy2Wz98IRmNI1psz3RA9OYLxFiNQRP/CWg2EjJvM/7jIyutUhtnY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4898.namprd10.prod.outlook.com (2603:10b6:208:327::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 13:34:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:34:24 +0000
Message-ID: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
Date:   Mon, 14 Feb 2022 13:34:15 +0000
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220212000117.GS4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0281.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cfaca5d-e744-447e-83ed-08d9efbeb6b0
X-MS-TrafficTypeDiagnostic: BLAPR10MB4898:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB489839D59AC161F9917FC497BB339@BLAPR10MB4898.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzEAGT7LpLWIGAb7TqoonnXiGJjfcjDaf5bo3AVcHKlt6SKM2FIvsJxg5cl0zZMg/pHPRsVSKsmIesvyWM7kOzm5koSR5Hv3rJCHi0nEVss1lXlk2ru64SiBhmcOyNrOpH63Gv4KV4JvjL+oRGBwg/vDux2YneT6dkS0PzmZlV46t1U1kvB4YPrI1ycH+otLYAOc6oYi3JKhfiySGg7AX2cIex0zy3KU/QWWLGGJJ2WRCdbkOm7AgqxIB+uvBKgyeR6rFVIHeemmyOlcTN7kHjDgMUS7twAKHMmiylO12EQnPryM3qMIy9m5SZJuEikJ/aOGwEqM7Xwpqnqxe3uL+VmtzaE738H5e4erlJv0iY5Hq717yRPZRGxLlIzkD1pRVBwpcNvRAz3ZNwlP6X/P0FA3Xm217qITAuO6ZyomTa/E7768HsMgoKbS8VeoLavcfLSPsBe8tFkkiVheUXTEje7Az0QHbzVhwF2vKsYQULxVaNDYG3T4Hjf53Paqk9nVATno/KOh6rJlNZyRLRkl7PDavqVD3ge5DkRFBWHlsLRog2P6r/hA62Ph2m0SSOV/b0zpxaa3tEM6y80YxXKQZMmxs/U4srXZfWwr1kFOGSBi94KFFuIFJNbHH6l3MCzlxzAicUYBWDjU+2TVczZcxkTpWYes0LQbIHwYPQsfHZP2zuK8j72K4zi2ePLw5WuSArXHrz6TGZGGVFejc8ykrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(7416002)(83380400001)(5660300002)(8936002)(6486002)(86362001)(2616005)(36756003)(6666004)(6506007)(186003)(31686004)(26005)(53546011)(6512007)(2906002)(316002)(38100700002)(31696002)(54906003)(6916009)(8676002)(4326008)(66476007)(66946007)(66556008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGplN0I5aml1REorTGlQekhBUENYRS8rNmtKQVltWFBrTTcxUVJWek9TdXh5?=
 =?utf-8?B?eS83SlpNYVlTdWpsSFZFeloxREltZ3Fob3RtYS9TQXlTUldiNzU2RFNqUDkz?=
 =?utf-8?B?QzRCaEV0TkZIOFB1Q1B3N2o0Z3ppN2E1dVFUNDBjeXpLeUtlSHg0MWJ2a21y?=
 =?utf-8?B?aDVxYiswSko1djFxRUFmOVhuLzdQajZESjFGUkttMFgvSHVwUXM0U0kyNkNm?=
 =?utf-8?B?ZlBkN2dnMWVORmJWZFZsSVZDRGw2QkxDcVdYbkJlOHdmT3Z3UU02NHl4d3BX?=
 =?utf-8?B?ZE9TZ1ZlZTgwQitteHVLaEFQU3A0V1prcHZoUGdZc0NjOTdCM2lYTDRzTjZH?=
 =?utf-8?B?d0hEZzBWbDhRSlQzYjFPQUsrOGllN2ZUSFczUnpTWHpNdXJPb0JZVzJaNHRN?=
 =?utf-8?B?ZkxBalp5OFJYQjZjZEhFY0tBM09CVk1vM0JFQzEycGdRK29mZ1hFOUFtU3k3?=
 =?utf-8?B?ZnM5bDRIWno1cWhDcm1wN2swU2pqeFJmSjFZOTIvNXlXMG1sTHlaZVVLbjhC?=
 =?utf-8?B?Qmoyb0IxVjZQZk1WK0tzNWJZWVYvU3RtRTl0UlRVVVNIUDFUYzd4ck4yNGpG?=
 =?utf-8?B?dFpvRnpXek9Qa1g5em1IZkdNNHFkVE5iOUxaeEsxZmN5OUk4ZnFzSm9Ibkxt?=
 =?utf-8?B?RHd3M0pKVTZVS2pXWHh6MlpKR2Jid3NuaHVFOFpKU3JvYXY2ZkFxd3NFMkVT?=
 =?utf-8?B?VTFubmtLamREWjNqYW1ObXQ1YmZkbzRTNUJ3cTUrOEJjTjloMnlxWUxMZXVW?=
 =?utf-8?B?M1ZNRCsvTXhWSExraXp6Q3F2T0FFZGRCWXlvNTUvbGNWQkxjNUljeVBSTWpN?=
 =?utf-8?B?NmU0UHFaejAyWWZtREZKV1dIU2EwTU5sWXk3cWF4NEZ3RjZnNnozWTFyanZx?=
 =?utf-8?B?SXNMTzFvWit5UWdTb0F1TnV2TjNRUWRDcTI3eGdQUlBGZzRMMDcyR2FXdnlX?=
 =?utf-8?B?VmhsL2ZWTDQ4ZFdMbTRJTUlvSHVqMHU2OHJJS3lINW5xVWRYV2tEMnkwSDF1?=
 =?utf-8?B?N1RCcEw0SmVhTjNleVBndzdCTlNLa091UkxhU2h2N0N1OVdmaktQS1l1QlJ1?=
 =?utf-8?B?aklDVUNTa0FMeEs4NlhWYVJCR1cwbFBJbmNNR1dNWjEwKyszdDcxcUU4emUw?=
 =?utf-8?B?L21GdXdIY1oranZ3eTJaOTJjWTJvZ2VMQWFZcmVZd1pBbnFWTkhFckNJTHV6?=
 =?utf-8?B?dXJMbmNSb2JaazRDRW54U2hvcXBwemxDbkovb2R1KzdpQ1VURnBrSFc5NnVJ?=
 =?utf-8?B?N3BQUDhONktOMm9pYzN4bWk0bllOVFQ0dlc0djVoQ1JDMmJsdkluUzRQbkdJ?=
 =?utf-8?B?VVVvN0lqM0htTDR1UjFvbS9nZnVwdUh1blU4aVArZWs0cktxMGl1WnlKb3RG?=
 =?utf-8?B?aWcrL1oyNVFkcU16V2loRHdHQ0labk1CV1BBbU45ZmJoWGJoSnlidlh2eFJR?=
 =?utf-8?B?bVZ4RXhaOGJwcGV5amlRKzJzUlNDYUVlekRob0h4SThPUXdxUHllTXFSWWxq?=
 =?utf-8?B?YWdYa09nb2Q0LytPUUFzbWxocWNTeUlvbXFHQVl4RExUWHU2V1NwbUxXTW5M?=
 =?utf-8?B?QVI1SnlMaTNzYnNJOE00SmRCMy9ST2grSDhHREVZWWdKOVlQT3B5ZG1PSU9O?=
 =?utf-8?B?b0xZZlc0a2czQ1lHUzF1aGh5VFJ6eERwMTZ0UGhrTWlWdDBWRFdIanFFaG05?=
 =?utf-8?B?VVNocWJFcHpQYkxZNGNQOUhWNzhwcm9ZRUIyV2s0cXloOUVQcHhxR3dzRldL?=
 =?utf-8?B?QUJMMzhoUDcyMEhtQTFidG5nb1U3bm10VjVZMXd3dzNrbThsSVRXM0tReWhC?=
 =?utf-8?B?bUdPWHRVdTk2dGRjcFZydFlIbmFQU3dzSnViTFJoUFdXaDA3MExoN1NQUmpy?=
 =?utf-8?B?ZUNWbjMrS2ZuTnFyaCt0dVVraTFVdmdOOUdaQ3RFRnVMdjJHcUc0RFpUdjR0?=
 =?utf-8?B?WllNdS80elRaSnpDUWRNeHFySm1QaitUSlU0NG1LdDlJRnBFRnlPUmVjWXY5?=
 =?utf-8?B?RGlaUHlpYWo5dGJ2bHFkREU1T2J0dVNDcXlBeit2WmdOdmltQ0U5QWhGWGRz?=
 =?utf-8?B?SkhGYTUwVkdFelByWXBsTUVtbGVUcU5KeGY0WmFJUTJiSUF6QXFBTnp3L2xB?=
 =?utf-8?B?bnlNMnFCNlRIQ2ZPUmNkMlRWQ092WUtyZ1pIOGI3TGRocEJRSjAwQ0ozV3JI?=
 =?utf-8?B?OVdhKy9qMXVLT2EyRkJiVjZjYnhjckR6VE84Y3pmNnA5aUtQZE9sVGw2bE9q?=
 =?utf-8?B?OUtwclYreTdUNVZzR0NTTy9rS2h3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfaca5d-e744-447e-83ed-08d9efbeb6b0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:34:23.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNoPNzpMrGQaJjYkmDwG6KNlSFLYeGqGACB+qCZux7f2YERpMMmr4waymo2GOzrc+08tBvFr0GBb7hwPjhNOJdgN7Ae9EVaKCB1To76CklM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4898
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10257 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=881 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140082
X-Proofpoint-GUID: cISn_QsgFajWMF-SiT8vh_TrKqNUJAHy
X-Proofpoint-ORIG-GUID: cISn_QsgFajWMF-SiT8vh_TrKqNUJAHy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/22 00:01, Jason Gunthorpe wrote:
> On Fri, Feb 11, 2022 at 09:43:56PM +0000, Joao Martins wrote:
>> 1. Decodes the read and write intent from the memory access.
>> 2. If P=0 in the page descriptor, fail the access.
>> 3. Compare the A & D bits in the descriptor with the read and write intent in the request.
>> 4. If the A or D bits need to be updated in the descriptor:
> 
> Ah, so the dirty update is actually atomic on the first write before
> any DMA happens - and I suppose all of this happens when the entry is
> first loaded into the IOTLB.
> 
Intel's equivalent feature suggests me that this works the same way there.

ARM update of ioptes looks to be slightly different[*] but this FEAT_BBM
in SMMUv3.2 makes it work in similar way to Intel/AMD. But I could be
misunderstanding something there.

[*] apparently we need to write an invalid entry first, invalidate the {IO}TLB
and then write the new valid entry. Not sure I understood correctly that this
is the 'break-before-make' thingie.

> So the flush is to allow the IOTLB to see the cleared D bit..
> 
Right.

>>> split/collapse seems kind of orthogonal to me it doesn't really
>>> connect to dirty tracking other than being mostly useful during dirty
>>> tracking.
>>>
>>> And I wonder how hard split is when trying to atomically preserve any
>>> dirty bit..
>>>
>> Would would it be hard? The D bit is supposed to be replicated when you
>> split to smaller page size.
> 
> I guess it depends on how the 'acquire' is done, as the CPU has to
> atomically replace a large entry with a pointer to a small entry,
> flush the IOTLB then 'acquire' the dirty bit. If the dirty bit is set
> in the old entry then it has to sprinkle it into the new entries with
> atomics.
> 
ISTR some mention to what we are chatting here in the IOMMU SDM:

When a non-default page size is used , software must OR the Dirty bits in
all of the replicated host PTEs used to map the page. The IOMMU does not
guarantee the Dirty bits are set in all of the replicated PTEs. Any portion
of the page may have been written even if the Dirty bit is set in only one
of the replicated PTEs.

>> I wonder if we could start progressing the dirty tracking as a first initial series and
>> then have the split + collapse handling as a second part? That would be quite
>> nice to get me going! :D
> 
> I think so, and I think we should. It is such a big problem space, it
> needs to get broken up.

OK, cool! I'll stick with the same (slimmed down) IOMMU+VFIO interface as proposed in the
past except with the x86 support only[*]. And we poke holes there I guess.

[*] I might include Intel too, albeit emulated only.
