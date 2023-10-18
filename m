Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2E7CE14A
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjJRPfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjJRPfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:35:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AB7119
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:35:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IFT0a5011917;
        Wed, 18 Oct 2023 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GCu2im5UGfU7XqlgEkZbQgcZhQ2rPI8rJZBUgMYVlEs=;
 b=cqQ91w87bLt99kqBR59+nscDD1c95DMKXobcBpZw/sTYkHDrHq94TnrnMSEzgF461Ics
 +MGZWXYLaSiq2HNvlcOl0FMjSPTXKrYeoHJVqZy5acWIcRSblEp+lnU9/CCGs1g3jr4e
 kCAaVDEQeg2zffxv/CsnOspZRyax3+04CcBEJP9odRsan7z6jmTaLgGW4st3t0kRu9Bu
 gVtJw8+p365Sm1tFyJMMkFHHF3zeZni5t31FtASagxzdjvEOGpuKXokSaoM+Nd7j5Guq
 LZLZGv/AfW7v1jF5sD3pGNuyestdC0UaD6WO5M5cum2AIXdNVvPQcHUGUY8GpeqBRCZO dA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cyw63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 15:34:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IF3QX5009668;
        Wed, 18 Oct 2023 15:34:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0pdtpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 15:34:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1Nq2r7rR46fZn6TpSMTHm4sTsElwSTlBk5D4XJRAT35AsQ2o8KO9GSipY2sn/+lOSIfvxBvBPDcaY/lV3bzKG5T1KTkzC3WNhn1HrvFVSktIjnQCfssTSg5Y4EtUA3SS2ryApYjHeH+3bg4lMp3vZazBKKgz6U3INTrGSPjkgtl8HgbjCELSuYu6p52v01NrvybVNHCTuCKbPAliKl+rAOZZWI2eXx275vcA0uRDcRUZzd6FoAQx0A6RKyMbJkHWNBTy0pyMCaolIo8lVd9ID2RZt68wAviqN+k0cny920DcQhCtLFF6YGKmu+eWNvtPU6Nd82trjlH+koPrPZ7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCu2im5UGfU7XqlgEkZbQgcZhQ2rPI8rJZBUgMYVlEs=;
 b=GvjkNTltu/wgFRWOk2M7rSiNcQNqbevZbkosRTSyuGunwGg3aNpPPmeI0kTaZ8XXk42VRIqUm98vXwivZ9MEXu+sdUcrNCVEhWb+P3JKbvklqqsMeMro8nT5zIgWA0CCV5RmEZFklCeWQAmWx2NlUd3ySL4I/CBswCvslR0R/9T+AHXN4cCO0CxA+x3cA9CuKyYD64xcbR6eXHL6a00AcJzMR7wmGvIfJ0n9yVZ/e87UjZ3WeJElVFiSsf7lIaIwj/HFC7CdE7bXta3GNvV67ZhA89X+LjBOt2dzdLIwWnvHBd+SvWYaDdiZN45j0NKr1SNgibbmAStI3Q4vGYXXAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCu2im5UGfU7XqlgEkZbQgcZhQ2rPI8rJZBUgMYVlEs=;
 b=N4A4A8ixb0ybmSicH8bPHV6MnD5ki7KzDA4CTB9RKZMKQxUwSEm+rcoASd0ssMKft7zlYzF9TYgVWrFO057xgmlfbqhVgYj2JF/6y4/Yv5e5uG7C9PTrZdPg2FV/6kzWKe2iPI1Gol5Tyqf04SaBEcqywkZVYbE/iJAyPkZdfnc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7988.namprd10.prod.outlook.com (2603:10b6:610:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 15:34:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 15:34:22 +0000
Message-ID: <aea127a1-3bf6-410a-8ec9-bf131ed1f4e6@oracle.com>
Date:   Wed, 18 Oct 2023 16:34:17 +0100
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
References: <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
 <20231018120339.GR3952@nvidia.com>
 <c8cde19b-60e0-4750-8bdb-8a97be26468e@oracle.com>
 <20231018142309.GV3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018142309.GV3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7988:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c71847b-4718-46aa-f109-08dbcfefb3ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9Kel8QDNQRBL4/1lecT6X4adNB2+RX0+2eVo5Qql4ovaY53wZ72XFMYzTIpfxbSzPlTt3JEu6LpLJQE/SiAO5Q04ksDl2WNkoSYgkO9kPW/mocJIypvmedIe8VMoAI5L62NrjAB0KUQofINQQuW9He6sWtMYvFW2on8FHmDkUT4UdLuJfgEKOIJ2Z6eDGm3gyAlFHke1m66MUYpPfUMgCdYznpe09P3BBlubSeB7zm7LCqiCPcwypNQF5y6znO8zv8F/Zs8YRjPmvsYwhZJXmyPjEw4nITwJYRz/vb5XEdvO4jtBBYQ306QsYtVitnBJgt2f/waw+LH+hNrUWKOUvjcnjrwnDGgvNEz5961tn5S947+kKVu2LBs1S37VCrAXa558hZyslrRzE5AYvm+RUtqWCYvIY5eTNQx89++6fZF4ogjPpxSuMizdKfCmIHNVclR2gaYWH/szJD/2ZjWjfn/DHIJ7G/BiSVyX1mNYEQExV01oKGRmyrc12QZT13cinwm8gam1HySeCzdfOkQJQiQEK0Yf9aGg0z8YPUAUIIg/mAzfrqCKnGXFJgHzaXrD8v+TiUBfcZbxhRNg2d/ZMhUrvLBD7+gjnqltvOPwuOZb5ZAlWORphQb3jy22+yvsX37+rbZbwAG2YGX6my3PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(39860400002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(5660300002)(31686004)(66556008)(316002)(66946007)(54906003)(6916009)(66476007)(8936002)(478600001)(8676002)(6486002)(4326008)(38100700002)(83380400001)(6512007)(31696002)(86362001)(7416002)(2616005)(41300700001)(36756003)(53546011)(6506007)(6666004)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bktlOW9pYlA0U3NXYUJEUEEzVU1xeDdKYzJiTUhpdURrV1FXVzQzdnk5amh1?=
 =?utf-8?B?dnp5ZWNCZWh5ZWFObjA5ZkR1YVUrSTBham93WG5zTXU1MGZDZVNzblNHSDc2?=
 =?utf-8?B?YzlvMHV6RWhmVzZVZ1E5QUF4RkxsVUR3RDRMQVNocUJaRGxWRlJDcFk3YTY3?=
 =?utf-8?B?QmlxWUJ6anBianV0L3dQaHZWZzJ1SHF0bkNsdmpFRmJsTDJGNUZWWFRaSC8z?=
 =?utf-8?B?UCtGRUdVcnZuMFZONDQ5RVRLZEZNbS9yRFZQQkVnWFQxTDFFY01rTmhpb012?=
 =?utf-8?B?aFpQc1FOOHhZQ01sNXllaWZmbzN4YzNkS002Ly9EcWNuUDVrMEg3eEk4b0dt?=
 =?utf-8?B?cUljNHB4WmxRZHVDbDRpY1QyT25tVEVxY2l6MVlJakxJKzNIV3RTMlUybndQ?=
 =?utf-8?B?UVRVYkgyN0dDM2IzdERwOHdEN2RMdnV3S0VJdTdzQVZLamxQS3RpbGt1WXB5?=
 =?utf-8?B?NnJtd200US9OTUNWcnNhRk44aldZRUE3T09qUEt1VnhLeHl4WlNVQ2hpOWxV?=
 =?utf-8?B?U1FUQ2cvc0Ixa3I1OXoyMjY5Mlp0YUFkdVRjZW5QenV1dG5OM1pSd0JFNXhK?=
 =?utf-8?B?cHRrc2wxbTI3Q0drVGorZ04zdlVKb2tzOVdHU0x3QUh0dGxTSlB5V1pBVGhv?=
 =?utf-8?B?TVRlSHRLUEZQWERiZVYvWUFkazVXWTBvdXRVY1ZuaWxCVW9BU2o3UjZzMVE0?=
 =?utf-8?B?eDZuYzh2ckNhWWVsM3ZrNksyZ0pvSlJmSUpaNk1NQkhwK2hnZVFSYVBYZlhI?=
 =?utf-8?B?V0N3MzlzRGZCem5sUmpBRmk1b0JMSFBVVUEwbklONk5UT3JXT2h0NUhLNDEx?=
 =?utf-8?B?ZWV5aXpUcDlkRUdjSjNXS0FFMHFZVUhCeFg5Tk9KdklFWGtESHhWcDBJdVJF?=
 =?utf-8?B?b2dMeUVkQUlCSUlxRkNHRmZvL3VTeE5BRi9HL3kzbDFFWVgvSXF2SDJEcjEr?=
 =?utf-8?B?cVJuV1NINVlURE1xSEpPTGVHVkNzUXM0TlFUQ3ZqQmNXQSt1N3ErM1FBcFlv?=
 =?utf-8?B?NktpQmRnM2ZPZVhVV0lJTXJhYXcxdFQvNUR0eXkyZlJJdjEvYzBNUTBwc3lE?=
 =?utf-8?B?SUlmcFgyby83anVodWxzRG9wdWpGU1NrSzZ6aTQwazN6c3p1S2dNM0lhZi9o?=
 =?utf-8?B?NVMvbzdZenhLM2prTHc0eThvczhNQ1lCM0xlaEs5aGhjeHBYVjFiYkloY2JB?=
 =?utf-8?B?RWZoOW1PVkVZelA2cXF6alVrVGNTTmRqL3JGRWowVmkrUTZZN1BSYnlIaUVs?=
 =?utf-8?B?NEtId2JlRVNuZkt1VHZJVUNabWYxaGRpdHNhMHR6bmNhWGN3OS94N2VhcUVR?=
 =?utf-8?B?dkhBSnl2eHZxUHNuTENYTWEvZVlCWHRJUmhCek5ma2lZbjlMeW80TXB2ZnVq?=
 =?utf-8?B?Rk8xSTRvaHgvL0hsc2hxeGIrSWRxOSt5em8weGVLQVdJUEdBVEpHUlI3N1Jk?=
 =?utf-8?B?VDNsckZVUU9yUVZlRWh5NHNXN1RtdlMvOFFpUlhHNU1icUZxcWtCZzRxUnJC?=
 =?utf-8?B?T2NXMURjaTVXYjNFZmRxM0RLT2V4ZCtRTWRCcUlyOE1LUGRWUEJxU3F2VWZo?=
 =?utf-8?B?R3lRMm9BWEg2c25kUk9mMEdkNTNMdGY2TWgwYk1JQzJjNHJtekR1UERRcThH?=
 =?utf-8?B?SzVRWm5xcm1EZWh0d1RKRjAycWNRcHp4bC9XOFpsbXBudlF5b3dJZjJIT1hl?=
 =?utf-8?B?UTRzU3p1a0lpUWJjdFdYNVZXVzNWR2JrTlZyT0NEZ2pzdDE1RDl2VGZwMDhq?=
 =?utf-8?B?aFI3Sk9Fek9xc1RnZEg3Z3lwZVdwSmJuVUNmR0NNUFZDa0U0M2cwcmFqTlA0?=
 =?utf-8?B?T3pObThHMDRWL2FWZ1BETU1uQXN5SFc2a3VQLzRMNWJhMDdKa2JJOUdmdDkr?=
 =?utf-8?B?ZGw0bWhQYXZoSjY2ZzFnR3JybnBucVhiR3FGTXlsbU15SFFVZXc0K3ZMVVJ4?=
 =?utf-8?B?OHptSEppTHNXaVJEcEdqeEd4bFlWT0hEYVlmSklvMWQ4YS9WclNUclBCNGhr?=
 =?utf-8?B?ZGFVUTRSaWY2TytoZ0t3TlNOQ2ZjRDMzRUl0NC8xSXBsbDdQVlZlTzYvWEEy?=
 =?utf-8?B?Q1lZUjBRL0FKam9Ma2JyYVBncTNxQzFEYzBmMVRZcVFVVEhtdnZIZ0xOUG53?=
 =?utf-8?B?VkFINlc5b29IR2R3MEY5Mm5LN0p0ZWZhMXNwWDFBTFd0R2ozZDNlWjRTSElU?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cmxCMmtVYzNmR1dmMmYwR2x3UGhEQnM2bWdmdTVxajR5THVhVGtNNWlkeE5E?=
 =?utf-8?B?Qm1FOGNzVnpDOVduVjhoK3JpdmpLN3BJNnkwTWdqZlB1WmdzMjNCSllLa3lZ?=
 =?utf-8?B?MjRjdUU3RnhxUGZKU0I4ZENMemU1UHlQZXJQaVN5VlRGN1o0ci8zZjdGT1hV?=
 =?utf-8?B?VlluSVhHbURDL3M1NUk5Zk8zelRQMWdYZ3lXeUV2SW4vQnNtbjZvdjFiSnRj?=
 =?utf-8?B?WUE5bThnTTNHMTk5MElwSzlaSW5WTW9aY1ZUcEtoYTdMc29ETWFNbDVvNUdF?=
 =?utf-8?B?YjJMNEd3ak9SOXBRdDdyRHY3amM3bmM4VTRZYWJLeDNlemloNlorZGh4QnYy?=
 =?utf-8?B?akYyRHNDcUpyTXhMQVdRbEZLTnJ2d2J3N3JHZXh5OFdmaVRQYWl1cnFnaFMy?=
 =?utf-8?B?RWZlYXZkbHZoU1prVXZBQzQyVFNBT1FidFpCUTFzS1A0UmJHc2RjNzBNa2Jx?=
 =?utf-8?B?S1RoVnN3TTRpekR1a2pYbWV6QUEweUoxVFk3bXdnTzZNSC9KbDRUWUVZY3lX?=
 =?utf-8?B?RkVVVVRDU2dkZXYxTGFjMjEvZjIvTmlTRTZkYkdTdlc1bnB5Z1JpMStTWUJq?=
 =?utf-8?B?YXhPWjVZekxOVVF6TW5RRlhWOW9CaWhNdWlUM1Y3UHMrTDdQU1RIYXJVT1ZJ?=
 =?utf-8?B?NG5OVG14cFR5aW91MWhPeFRDS0FWWGpTSVB6UTdETi9BdkhLUUUrVHdBQXMv?=
 =?utf-8?B?WlE4RGdHbkhFZkViMkV0a2JFYlRJdS9TTnJ2MmpuYW9aQ0hjRE9tK3VHSzRk?=
 =?utf-8?B?VGsvczVPR0dMTE9oOXVJcTVyODNNRTI2VDV0V0pTOHVyM0N4VHorS2gvYzNq?=
 =?utf-8?B?TlRzbzZrU0kwYnZCWnI1Ky8rSTE2UTFyMUx0OFk3M0VHK3pwQS85S3hENzBC?=
 =?utf-8?B?N1R1cEF4NzB4ZG5rTnNJZktNQUQ5bmJkR3Bpc1l3SHh5UEpuNTRXdytNYWU0?=
 =?utf-8?B?T3hpdlVGMWV4cCtQWmRzRXd3VmxCZ0lmb0o3WkxENnJueDMzYkFFaEtnM25M?=
 =?utf-8?B?a09WcGNWalpNMVpmZmF6bmM1UWVtdTJHV0VjTm9YcHhUd3gvMjU3OGw3cW1R?=
 =?utf-8?B?ZElCTXgvN21nVkFERWFzMlJEenU0ejJ1dzFDNXptdkViL0Fvemp1SXpWclRo?=
 =?utf-8?B?eTZyMmJiRHloc0IvRU1Id0wyY1dZcEExdGxJdzVidEtyM1g3TUQzNXc4aGg4?=
 =?utf-8?B?c0dUTVZSeHZuWmUvQjR5T3Yyak5ZMnFLNGcyNCtrSU1Tb1hkc2dkanBacmM3?=
 =?utf-8?B?WXRrSG0xSyt3WitERVZTQ0U3d1NGdE9iVzluaEhFSlFWVVV3MmNCSEFveTRR?=
 =?utf-8?B?bTRNUDZQNmpNaTRveTZYYm9KZnpHQ1NOaUwxMXk2SWNRYzB5aTRXNU5jN0ZS?=
 =?utf-8?B?UnhSQVFZUWdYZVAwSSt0YllXS1JLbFpPc0hxMmFMU3NMM3hwL3hrcUVTMmJK?=
 =?utf-8?Q?bpCpO8uH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c71847b-4718-46aa-f109-08dbcfefb3ce
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 15:34:22.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: reuIb4c48yP+UBgKDBNNIqGrpFYXBbxBKj97x1VeK6UFMpuRoBTqgDe1yQSzRBf0ctW/8zILpPYAFsoIqz7chhYPhSsayL9IToGGCuclIJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_14,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180126
X-Proofpoint-GUID: 0JQewOqYq-squJkZUrHIy_UsvDTWLHfd
X-Proofpoint-ORIG-GUID: 0JQewOqYq-squJkZUrHIy_UsvDTWLHfd
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/10/2023 15:23, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 01:48:04PM +0100, Joao Martins wrote:
>> On 18/10/2023 13:03, Jason Gunthorpe wrote:
>>> On Wed, Oct 18, 2023 at 11:19:07AM +0100, Joao Martins wrote:
>>>> On 16/10/2023 19:05, Jason Gunthorpe wrote:
>>>>> On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
>>>>>> On 16/10/2023 17:34, Jason Gunthorpe wrote:
>>>>>>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
>>>>>>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>>>>>>>> index 99d4b075df49..96ec013d1192 100644
>>>>>>>> --- a/drivers/iommu/iommufd/Kconfig
>>>>>>>> +++ b/drivers/iommu/iommufd/Kconfig
>>>>>>>> @@ -11,6 +11,13 @@ config IOMMUFD
>>>>>>>>
>>>>>>>>           If you don't know what to do here, say N.
>>>>>>>>
>>>>>>>> +config IOMMUFD_DRIVER
>>>>>>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
>>>>>>>> +       default IOMMU_API
>>>>>>>> +       help
>>>>>>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
>>>>>>>> +         drivers.
>>>>>>>
>>>>>>> It is not a 'user selectable' kconfig, just make it
>>>>>>>
>>>>>>> config IOMMUFD_DRIVER
>>>>>>>        tristate
>>>>>>>        default n
>>>>>>>
>>>>>> tristate? More like a bool as IOMMU drivers aren't modloadable
>>>>>
>>>>> tristate, who knows what people will select. If the modular drivers
>>>>> use it then it is forced to a Y not a M. It is the right way to use kconfig..
>>>>>
>>>> Making it tristate will break build bisection in this module with errors like this:
>>>>
>>>> [I say bisection, because aftewards when we put IOMMU drivers in the mix, these
>>>> are always builtin, so it ends up selecting IOMMU_DRIVER=y.]
>>>>
>>>> ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/iommufd/iova_bitmap.o
>>>>
>>>> iova_bitmap is no module, and making it tristate allows to build it as a module
>>>> as long as one of the selectors of is a module. 'bool' is actually more accurate
>>>> to what it is builtin or not.
>>>
>>> It is a module if you make it tristate, add the MODULE_LICENSE
>>
>> It's not just that. It can't work as a module when CONFIG_VFIO=y and another
>> user is CONFIG_MLX5_VFIO_PCI=m. CONFIG_VFIO uses the API so this is that case
>> where IS_ENABLED(CONFIG_IOMMUFD_DRIVER) evaluates to true but it is only
>> technically used by a module so it doesn't link it in. 
> 
> Ah! There is a well known kconfig technique for this too:
>   depends on m || IOMMUFD_DRIVER != m
> or 
>   depends on IOMMUFD_DRIVER || IOMMUFD_DRIVER = n
> 
These two lead to a recursive dependency:

drivers/vfio/Kconfig:2:error: recursive dependency detected!
drivers/vfio/Kconfig:2: symbol VFIO depends on IOMMUFD_DRIVER
drivers/iommu/iommufd/Kconfig:14:       symbol IOMMUFD_DRIVER is selected by
MLX5_VFIO_PCI
drivers/vfio/pci/mlx5/Kconfig:2:        symbol MLX5_VFIO_PCI depends on VFIO
For a resolution refer to Documentation/kbuild/kconfig-language.rst
subsection "Kconfig recursive dependency limitations"

Due to the end drivers being the ones actually selecting IOMMUFD_DRIVER. But
well, if we remove those, then no VF dirty tracking either.

> On the VFIO module.
> 
The problem is VFIO module being =y with IOMMUFD_DRIVER=m because its end-user
being a module (MLX5_VFIO_PCI=m) which depends on it. If IOMMUFD_DRIVER

>> I would like to reiterate that there's no actual module user, making a bool is a
>> bit more clear on its usage on what it actually is (you would need IOMMU drivers
>> to be modules, which I think is a big gamble that is happening anytime soon?)
> 
> This is all true too, but my thinking was to allow VFIO to use it
> without having an IOMMU driver compiled in that supports dirty
> tracking. eg for embedded cases.

OK, I see where you are coming from.

Honestly I think a simple 'select IOMMUFD_DRIVER' would fix it. If it's a module
it will select it as a module, and later if some IOMMU (if supported) selects it
it will make it builtin. The only it doesn't cover is when no VFIO PCI core
drivers are built or when non of the VFIO PCI core drivers do dirty tracking
i.e. it will still build it into CONFIG_VFIO -- but nothing new here as this is
how it works today.

I could restrict the scope with below and it would avoid having to do select in
mlx5/pds drivers:

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 1db519cce815..2abd1c598b65 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -7,7 +7,7 @@ menuconfig VFIO
        select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
        select VFIO_DEVICE_CDEV if !VFIO_GROUP
        select VFIO_CONTAINER if IOMMUFD=n
-       select IOMMUFD_DRIVER
+       select IOMMUFD_DRIVER if VFIO_PCI_CORE
        help
          VFIO provides a framework for secure userspace device drivers.
          See Documentation/driver-api/vfio.rst for more details.
