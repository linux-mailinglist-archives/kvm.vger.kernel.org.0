Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B227CB223
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjJPSPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjJPSPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:15:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1B0AC
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:15:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GIEQwE013190;
        Mon, 16 Oct 2023 18:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=HWQxkjrkdiaSWg8vKdlaDLyBs4A/nzLkQjgKor97LC0=;
 b=ap3HCWGZb9yU2qfUMfDdhPFkD49CluhfOVEcD1+4yPpar1SoAufNx2oYhuo1zY2EoFGL
 1mqAVbVP54ZPehDqS6KAvWuoL41TFRNOGbR7fYrpTGH/lE8dgmfMtMW1XBHhAAIb28Um
 mCO/O8QtNXCAZ9/okZmOiE4t3Ia9K/vBcNgrsNGqSa162QSCcpiY2fYwewd/qmqFACHE
 YPLNLVouBmwtfi5yJ0jRoUqy5SFg/BzM9YPci68p42L4GS5UxxS362kacTouXioo4tv0
 6QVbjy8QDgiWBDU+gOUkSJKG6ZTw8tS4fr9cPOfFgbFZM1eXUp4zKTV4y+ww1/v9T2m/ Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jkf0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:15:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GGkxnN021964;
        Mon, 16 Oct 2023 18:15:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg4yy8q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:15:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+SuqAd02QBe+Z9YTS77IHhsC718Sc0vbmqHSayXt8HHX6QBiiTdJUnjHXeJ7attM2UESB14rcVFHbnCJpYliyE30bpcokjO6GL0+Mh2PSoUIXPKdLoXW866JESNsWCSoH4YRk0sqONoPV3055nJaaZv0dfSfic8kHyoZWm1/XX8LNzFsvdfDVqs0S2ttiL5GgzNTrvVicUVfWgV9fn/kypWPD9e3Jyd7DjWjkRAgd876E9ecXeM3TkCmZ5xHSsFSeg4VaEqHdcnD5VYwbfH9Vpr7XvtWK/jR1/vHgeWhlCoUj60eyCzbqU0PCiE4akNpzJoydyErNQcB4GvN4z+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWQxkjrkdiaSWg8vKdlaDLyBs4A/nzLkQjgKor97LC0=;
 b=V6ZXGoDIPQ4LflRqL6qgYhL0VlEenV8SxXrSPWA0HlxHfSr5YA2w/atoMGONd7eHsibBmzBwAo/fT28n1Pb5zuE7e7a7qB08/7zdfgksCp87EJtyfYXd9yR/ABxY340ltxnOWmHqOV2LNnaC9rd6MR/v2e5JRwqsj9bwnlWd/iYuNszm/f1rsKSPXQux+o3AtenDGonWn3oB1bU2c24xR0SUv8qDdRn4y/AvtRGhZ6tMxdS6V5kNy66ARcqp/Tyn6A05yADvF90avSfLaPMfuWty4ma+7bBgCFYXDMjWlYhRsV7ZOlCKvbTptV4u8PMNCO+6sMv67RmcaGikEnq/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWQxkjrkdiaSWg8vKdlaDLyBs4A/nzLkQjgKor97LC0=;
 b=aLOhhXHdnW+BQRBFuTYqa0WEEhUFp+gXN3244h9hGL2i460nf+NYpDqI/Md4ny9ctMH9/8Y2hIU1DvUW3/Owsm/Kfeq+BppBnEkvUtNZiQm03Nj5KLO5BQtGbd8TC3+lfvP5csGMoMhfbtT4G75SHnjZs6ofD7ZMb4EfCoL0N+0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MW5PR10MB5852.namprd10.prod.outlook.com (2603:10b6:303:19c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Mon, 16 Oct
 2023 18:15:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 18:15:15 +0000
Message-ID: <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
Date:   Mon, 16 Oct 2023 19:15:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231016180556.GW3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0034.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MW5PR10MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: 68784181-bfd0-4409-ec1b-08dbce73d8ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AI6/67aoK7Rx9JYLQDYXU+4vQTs158l3ov6lvWvDFRvwhtSfUrJ4yD4NMD8zlu6xb1UWHkCbbFonqlSaEaI0yw38jrXv4aPNmR6gqAiiHrXhijKdOXDZxjmu/jCgaYkJ28p0MHj/AOCzQIrAlw9Ni1hfJBMR4rT/GelmfbUlNT7rU0Vl4G2+tPvv8emNrf/pOBm2Mpxd6DAHZxEY+q9s4yh5UsXdQ/p3HUCLOUJwHAaz2w6UJ0sizYOwU3v8TFMLqS/DjcC24timOPxeFVQQZCAGox7Fxb0ObQd3cdLgQVIe/61kSvg8oqnQCb2+fRs0iGD6s0HrM2WvT9uM2VZI0ewMwBnLHUYjhdbCw3XP19GvmqGzJDmrEIDAGb+ngtIyPwGP4x7x+YifP1orEbL4bsXzp3PIxWasUu85/dyXwLTm1UYwEhtqY7qN9fMf1Z6Uc6ACut3hKXUwb/kOAM853GmLXA9xNq+KKcaKI3yNciBinMaauEhhPCBlSCwxRupSLcOmJQhlk0kaPO6/vryruZWni0HqhXoObSHqqtw3cD1cV5NSiL/mprQqcWu0QKkwBccglmzurWVjv7OcETcTdetD2OY3MhDNTknNzI87WY2OmssVvItWpt9MeIZYDzQ4vWE0uU18pOIUpDsocQrWvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(376002)(346002)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(54906003)(66556008)(6916009)(66476007)(2906002)(2616005)(316002)(6486002)(8936002)(8676002)(478600001)(66946007)(4326008)(6512007)(7416002)(53546011)(41300700001)(6506007)(26005)(5660300002)(31686004)(6666004)(38100700002)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0lUUEptU3pzNUVSTkNvTGxRZVdlelloUDNxc3c4VGZpWTRyd2FNdUZjOWZo?=
 =?utf-8?B?QjVNMGx1UFJyNmozN2t5eWRNOTZrWSttQTArWnhoUm04NEJUcm9nZ1hCQSt5?=
 =?utf-8?B?TmxZYlFnMDVCNG4xelFnT3Q1eWU2d3FjRkdxV25hcWs5RU1vVngxZkdIN3JD?=
 =?utf-8?B?Q0xidktCRGNITktQS0g5ZFIyak1WTjlXcHB5UXhrQnlWb2FnT0RrV1hIaEVs?=
 =?utf-8?B?a3NwNnNLZ2YxU0x4WDZ4VkpscG8yWUFWRTZxQ1NmRmtZdXZjWkZTL1phTzcw?=
 =?utf-8?B?emxQQkJ2dDFoWHhPZlVYdWxFNFBIbGRXZVlUSkh1dFFJQTl1ZmlOTGVwR0Ri?=
 =?utf-8?B?a0hFaVBGOEJJOU1hNW9LY0VWWDA2azBEcnlCV1VvdFliczNESGUzcnhRNjIz?=
 =?utf-8?B?d051OStsTXZ5UkxtV0NSK2RSSzdYNkVnd0xkRHRicWxhWEZnYmpvMk95RVVC?=
 =?utf-8?B?b2xVcDA4ekJkL2JTbk10RUNNc3hnallaRGhFVkxYRzFsM2tpb25lOHRLNUV4?=
 =?utf-8?B?dEh0YnZyR1Y5SXlFUC83Si9wS3NVYWdXWFkwdi9rL2srMjBqR1hCVjczVVgv?=
 =?utf-8?B?eHJBWmw3VFkxYkFwN3duZ1JZQTA1N2xyYW5RTTR3WmFwTG9UYlhzYUpNSkdr?=
 =?utf-8?B?aDYzcTNkY1NTcnVsOW1zRVE1dXBtQ3dER21lOGNWdncxY1dYODlwNG5Cd3FN?=
 =?utf-8?B?RHpFRDlyVG0rcENna1VBWG5URlZCNFF5ZU1rbS94UEVTejQwVURLVWZ1bENQ?=
 =?utf-8?B?b0o5WGxxdkd5Q1FPQkdEQVVzOWdQeXJScVZCNTFkNVdPTU1SL2JMbmlYd0lS?=
 =?utf-8?B?N3JBTjJkZHh1UFdLRjZKZU51N05Qb3BlNXJaNkllbU43OExnMHB4bTRMT3dG?=
 =?utf-8?B?cFBqUEdsU1RuMEU4SHJ4dndhSnBKaEVmZHlUQ2t1THBTMnVqQUdpbnBrTTdQ?=
 =?utf-8?B?WGZHNFJQdjNXYVc2M0piTnREU2VMQTFUZ1E5M3hpWXUvR0pQYVp6SHlhdVRv?=
 =?utf-8?B?SWJ4Q0pqcy8wR05uNUNVSlpXSWZ0aGkyL0VSSHpwaUhDdUY0ajRoZkJMdi9W?=
 =?utf-8?B?c0JER3RiN3JEVEh5enV5aGZIaWpUMUR5T0MwcUxWdDVQVDByZHJXeERUSnJM?=
 =?utf-8?B?VFdhQVVmWmFjbC8rcStBY1lVdDZXMVdFeHYwQXFSUCs1MTZVRDdmYTFzVVZ2?=
 =?utf-8?B?WmtaWlJZZlByNVlNejVUKzRjM1dlU2FKSUtzT2g5OWNlalZNRXdEaG9YdXhL?=
 =?utf-8?B?UXhBMFBhdE9UK0ViYkN2L3FYTFd0OXd5UWFidEszVm9EVC9OODc0SGFDcG1n?=
 =?utf-8?B?MVg1cmJGN3VzQkhkZWdLZXQrcC9vZVIwSXB6aTIvdlpETUYxN0RLQTRCOVlW?=
 =?utf-8?B?Ym94U1RmQ3VlOWUvalh5aXArd3o4Z1hHMkxHVEk2WS80NnJubndWaGV0UTRv?=
 =?utf-8?B?bHA3bUQ1c0tsSHpxeENPeHAvdlNCY2NQSTBRdWhmU1UvQmxVcUFMeE42cTJt?=
 =?utf-8?B?Yy9FSW5oSjU2NFlJbGpxWW1nRlIxZTJxWkxJMG50Q1EzODVCVGxURDdWQk4y?=
 =?utf-8?B?YngrZHJObEJ3OGlRbnBtT3ZMVnhxMS9pU1QzRkx3aGRsVlZjUEhZMndDbE14?=
 =?utf-8?B?SUt2Y3NPMU1QY2NxSTIvMDgxUll5Yy9DUjd2ejNhWDBJbXpOWE92aCs2OWpJ?=
 =?utf-8?B?WVdQYVljL3JoRm1iZW42TTVPNkhPZ1ZSNGUxa1FET1VicXVDU2w1SVBOcmVq?=
 =?utf-8?B?dW1GbGRFbk12d3ViK0xaLzZBaEFtUXNheUFhYzJWTDB5QVZKSHU3ak4vcFk0?=
 =?utf-8?B?cnA2Q1lWTVM2YnhiM3luMUp1RkRTMk9yVmlHWHIra2c1R2ZmUzhpMFR0VkFW?=
 =?utf-8?B?Rk51bHpWK3FXV3FJazYzWWtYZ29QVGxaRTBOVE91NlViUklnZSsrV1BWRWJM?=
 =?utf-8?B?OGVjV0hpeG56Y3JQNytPcGJ2Ymd4dHFMdFdpMDcrV0VoeGE1elJNN2E1MHh5?=
 =?utf-8?B?bjVIak44MWphcUtaZm1OYWZYdmozRTh0M2d4cEd3eUU0OW9PRThoQzBGb0dC?=
 =?utf-8?B?aWFZY0FyVC81bkJwRzdsUkVleTlGcytJMlVFOHhjcTFzV1ZUSEhBRGx5VWdG?=
 =?utf-8?B?QlU0WC84R3d5MXpPN1RwUGpZZlRndHRLcDloWkRJYXJ6aWJsMEE5SnlieWRI?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Mnc4WW1LSGhNZ1BObWtKd2IwaVZCOWd0aVlDTS83ZE9RSU1aWi9RelNQeHdo?=
 =?utf-8?B?WnZZMitPa1hYeU1wSnFMVTlQdllDTkV3R0I2eVdnZHZVa2dMemZBVnNxNSt5?=
 =?utf-8?B?YTY1aldSRG16S0xvUFlnUC9tRnlSNHR1ZUhFV1pPb1VhQVM4TkJUaGl5Y1Z0?=
 =?utf-8?B?Q0hGT1d6TkpISWFEcVAybVg0MFRGTUdySFRSbmN4RWQyQ0h2cmhFaUVhM0NP?=
 =?utf-8?B?anBhWjZzUEsrQ2kxQ2xjY0xUZzR0UElEZ0FvRUN6T1B4M3F5YTRDN25FSEVG?=
 =?utf-8?B?Q1J2ZWdJR0FQTSswTmJwM2xqZlRCOGIwNHVaMzhXUGF1UmxMbUloa2ZaNndq?=
 =?utf-8?B?c2hROXJ1M3lTSXgwZG9sR0pIN0N0R2EvaWMvdzloOHpaaEdrTis2NDlHZHVk?=
 =?utf-8?B?YXh6RVdSQmZ3TTJJZ1RtenFNTTU3T041Y1JhYmJFZ1k5Z3M5MzUxa3lucXlG?=
 =?utf-8?B?VDFPVU5IaVhsNlJlUzdtWlh4QmthNHRYTVQxQVJsZmZhQ3VmMlVyTHkzVnow?=
 =?utf-8?B?b2hzN1ZaTG05YWZQNlZzdEUybnZKTDNuL1h1MjRtRHhaVDg0dkJkMGl3dmJl?=
 =?utf-8?B?NDdseDlLblQrSE0zeERxUDZEbmJLLzRGM1BuRk14N2R2TitrNG8vYjBCaEV1?=
 =?utf-8?B?R01QL3BTaFV6Vkd2VG54TnIwNlp2YS9jdGQ5MWVzMUVMUEtCSUxuaWJYSVBl?=
 =?utf-8?B?Zjlld3dUQ0FUdW1XMEpwdUxTS1k5c3dGYkYxVjlSck11dkNVOGhqSjNVWTJG?=
 =?utf-8?B?UmlxYitEY2lzOXYzclMxeW1Cb2V4M1NsNytVMkZUdU8rcHVvUlQ2aTdxUHpz?=
 =?utf-8?B?NWdPZWpQRm9EL0E1OGszd1V4aGg2RXJCL2xNbUYyMDRrRnBKaTVFaUZaUlFK?=
 =?utf-8?B?NzlLNTNUdHZPQkJDK0VEVzE0dSsyR0diNFJPUGpiU1RyZ1VQTlZwSW11OElz?=
 =?utf-8?B?SFVRN2pkTnpjOWhLQVdvWVNwazZYdzBZTE1yVmRQN0haQ0UxdFI2Wjd6ZmVL?=
 =?utf-8?B?Y1A5U2VGZ3NwSlNoN3Q5MU15dnNCL3J6NzF6T3dweEgzVnJXQm9XeU4zMmEz?=
 =?utf-8?B?cmMwdGtoZDhzVGNpWHp0ZjhWUnlJNjNHb3kyd0RPQ2ZPb0wyRUExOEhGZllE?=
 =?utf-8?B?SXF2eUVtZzdjdGIzdi9qS0hDYW9uQTJjcGhVV1p6N3Rqd2hiZ3NoYkJwSnBT?=
 =?utf-8?B?djVWalFJNVR2QS9La0ZBOEpKNExYZ2E3VWQ5OE0wTGdRQTlhNnN6VWsrcUlK?=
 =?utf-8?B?RlhVQ0l1b0hNOTVUaUo5MTRFN05qeGtHU0xHcjM3NkF6V2xJK0ZHN0FTNUtH?=
 =?utf-8?B?QnFrNE9iMTVZVk5jUWp1UmdFMUVYc3cvOXdDcURIbTlPWkdhZVRMZDBDNkov?=
 =?utf-8?B?RFhxTU5lRDZhRHFkaTVGdzVObWU5eFkrdGZJZkZuNlNCYXZxdnZvdjhGY3Nu?=
 =?utf-8?Q?5A0IhcPs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68784181-bfd0-4409-ec1b-08dbce73d8ab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:15:15.6660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coOMuWldoi2kkdmaft39I8KdzMampUUjq/F2YR01ql/RFAnsB1rjLii37M/bqtRaPSCzfX62bqa9IW63i1GVZHDHOGQuoElsyrtgudQennM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160158
X-Proofpoint-GUID: wdUdpo5ZGSBIDJ1Bbql9npy7FRgo75SX
X-Proofpoint-ORIG-GUID: wdUdpo5ZGSBIDJ1Bbql9npy7FRgo75SX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 19:05, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
>> On 16/10/2023 17:34, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
>>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>>>> index 99d4b075df49..96ec013d1192 100644
>>>> --- a/drivers/iommu/iommufd/Kconfig
>>>> +++ b/drivers/iommu/iommufd/Kconfig
>>>> @@ -11,6 +11,13 @@ config IOMMUFD
>>>>
>>>>           If you don't know what to do here, say N.
>>>>
>>>> +config IOMMUFD_DRIVER
>>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
>>>> +       default IOMMU_API
>>>> +       help
>>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
>>>> +         drivers.
>>>
>>> It is not a 'user selectable' kconfig, just make it
>>>
>>> config IOMMUFD_DRIVER
>>>        tristate
>>>        default n
>>>
>> tristate? More like a bool as IOMMU drivers aren't modloadable
> 
> tristate, who knows what people will select. If the modular drivers
> use it then it is forced to a Y not a M. It is the right way to use kconfig..
> 
Got it (and thanks for the patience)

>>>> --- a/drivers/vfio/Kconfig
>>>> +++ b/drivers/vfio/Kconfig
>>>> @@ -7,6 +7,7 @@ menuconfig VFIO
>>>>         select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
>>>>         select VFIO_DEVICE_CDEV if !VFIO_GROUP
>>>>         select VFIO_CONTAINER if IOMMUFD=n
>>>> +       select IOMMUFD_DRIVER
>>>
>>> As discussed use a if (IS_ENABLED) here and just disable the
>>> bitmap code if something else didn't enable it.
>>>
>>
>> I'm adding this to vfio_main:
>>
>> 	if (!IS_ENABLED(CONFIG_IOMMUFD_DRIVER))
>> 		return -EOPNOTSUPP;
> 
> Seems right
>  
>>> VFIO isn't a consumer of it
>>>
>>
>> (...) The select IOMMUFD_DRIVER was there because of VFIO PCI vendor drivers not
>> VFIO core. 
> 
> Those driver should individually select IOMMUFD_DRIVER
> 

OK -- this is the part that wasn't clear straight away.

So individually per driver not on VFIO_PCI_CORE in which these drivers depend
on? A lot of the dirty tracking stuff gets steered via what VFIO_PCI_CORE
allows, perhaps I can put the IOMMUFD_DRIVER selection there?

>> for the 'disable bitmap code' I can add ifdef-ry in iova_bitmap.h to
>> add scalfold definitions to error-out/nop if CONFIG_IOMMUFD_DRIVER=n when moving
>> to iommufd/
> 
> Yes that could also be a good approach
> 
>> For your suggested scheme to work VFIO PCI drivers still need to select
>> IOMMUFD_DRIVER as they require it
> 
> Yes, of course
Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
well later in the series

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 99d4b075df49..4c6cb96a4b28 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -11,6 +11,10 @@ config IOMMUFD

 	  If you don't know what to do here, say N.

+config IOMMUFD_DRIVER
+	tristate
+	default n
+
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
 	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 8aeba81800c5..34b446146961 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -11,3 +11,4 @@ iommufd-y := \
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o

 obj-$(CONFIG_IOMMUFD) += iommufd.o
+obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
similarity index 100%
rename from drivers/vfio/iova_bitmap.c
rename to drivers/iommu/iommufd/iova_bitmap.c
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index c82ea032d352..68c05705200f 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,8 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VFIO) += vfio.o

-vfio-y += vfio_main.o \
-	  iova_bitmap.o
+vfio-y += vfio_main.o
 vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
 vfio-$(CONFIG_VFIO_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index 7088edc4fb28..c3ced56b7787 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -3,6 +3,7 @@ config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
 	select VFIO_PCI_CORE
+	select IOMMUFD_DRIVER
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
index 407b3fd32733..fff368a8183b 100644
--- a/drivers/vfio/pci/pds/Kconfig
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -5,6 +5,7 @@ config PDS_VFIO_PCI
 	tristate "VFIO support for PDS PCI devices"
 	depends on PDS_CORE
 	select VFIO_PCI_CORE
+	select IOMMUFD_DRIVER
 	help
 	  This provides generic PCI support for PDS devices using the VFIO
 	  framework.
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..93b0c2b377e1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1095,6 +1095,9 @@ static int vfio_device_log_read_and_clear(struct
iova_bitmap *iter,
 {
 	struct vfio_device *device = opaque;

+	if (!IS_ENABLED(CONFIG_IOMMUFD_DRIVER))
+		return -EOPNOTSUPP;
+
 	return device->log_ops->log_read_and_clear(device, iova, length, iter);
 }

@@ -1111,6 +1114,9 @@ vfio_ioctl_device_feature_logging_report(struct
vfio_device *device,
 	u64 iova_end;
 	int ret;

+	if (!IS_ENABLED(CONFIG_IOMMUFD_DRIVER))
+		return -EOPNOTSUPP;
+
 	if (!device->log_ops)
 		return -ENOTTY;

diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
index c006cf0a25f3..1c338f5e5b7a 100644
--- a/include/linux/iova_bitmap.h
+++ b/include/linux/iova_bitmap.h
@@ -7,6 +7,7 @@
 #define _IOVA_BITMAP_H_

 #include <linux/types.h>
+#include <linux/errno.h>

 struct iova_bitmap;

@@ -14,6 +15,7 @@ typedef int (*iova_bitmap_fn_t)(struct iova_bitmap *bitmap,
 				unsigned long iova, size_t length,
 				void *opaque);

+#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER)
 struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 				      unsigned long page_size,
 				      u64 __user *data);
@@ -22,5 +24,29 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void
*opaque,
 			 iova_bitmap_fn_t fn);
 void iova_bitmap_set(struct iova_bitmap *bitmap,
 		     unsigned long iova, size_t length);
+#else
+static inline struct iova_bitmap *iova_bitmap_alloc(unsigned long iova,
+						    size_t length,
+						    unsigned long page_size,
+						    u64 __user *data)
+{
+	return NULL;
+}
+
+static inline void iova_bitmap_free(struct iova_bitmap *bitmap)
+{
+}
+
+static inline int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
+				       iova_bitmap_fn_t fn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iova_bitmap_set(struct iova_bitmap *bitmap,
+				   unsigned long iova, size_t length)
+{
+}
+#endif

 #endif
