Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6D7092A0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjESJIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjESJIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:08:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535461AC
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 02:08:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J6kBCD003734;
        Fri, 19 May 2023 09:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=giZSx/AUeShBUMO9I65ABr1UDyFkX1fjK3ptBmq/LNk=;
 b=LOljNUYzSIQdcjYQAoA5aTjmSkCZyTZrbqbRNFvbH1XOP7N9Iw1dTD1aUyD7B7kjNDXn
 KfNJ+4GSQH6X5K+BAm1oVbbFNai8XUOKB1z5s7joasqrYrc1SkBNoIIyv/INiveJVKKY
 d0mVyoe6tUCjrp/OLXD8XtnQ/VbFDZeEZnBCOoFuAgFQnbXJRGB25lc/tyP6gctC4cqN
 9UM1nK4u7Dqro26WziJ96KRv+HbvbxVTV2OcqlFdyTZWTt9il0dcDgNvbqb5GsMHHoG5
 vlomeXdP3WA8m12lbMLyGQuiBx+AYufgVa/Ig4ELuVUJR/Nf7/tQT77Atw/DMCJIgMr3 +w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qnkux9y1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:07:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34J8xiWj036702;
        Fri, 19 May 2023 09:07:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qmm04v9e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:07:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnESKSQBEGOp2cih1KBy+Sk7B091N0y0dZNwL5A24U2viNtf9rNgUjmeoj6JI5n1oHE+bTxcEIxb4lqkEzTt/La6a5R7VJgsomShJBSI5L9o9z8VJAP3OpMGNXALUhtjYATsl5x9GOU/SokFksYzIluftEaQOhYvySAKhCgWAosx65EDKxvSf0/A8tzDYRojrWlPAIJG0l44F2oiNZ50aDt98ABPdym/vY8UhGqFtvQrocLmBJrs2XKPYsRLCTJgnZiV5dswhXB9vcyJ7mb0FnaIqiK9uFu2c0X4Qwu52g7D6w/NKvpX3eP+ZFTjEORleyHeb9AyU17ugx0FVPQn0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giZSx/AUeShBUMO9I65ABr1UDyFkX1fjK3ptBmq/LNk=;
 b=ZfDXjcV9ZEZuIeMoPdmbtOxHtifCVnyBkLbQL6vU88cpS+h19FJbJhlcBNrdjCqYu2+xoaUuFqzbA1ZhMlQ1u8HbL/v6KYnRatDcOI1j/W1oFoVwyUkH1j23Bb9M8un07RfI/04P3lqrZxzCqj6WieM+1jthvyjAxD2rygjNs566I+roijYHmLoRtD10UCmYOfAUSBr617oM5IT67+EPwl4dUm9Z848JvT6J9hzfKe2H9vjsoElvPJO6Xa/F4OB/fLuQYv9EsYVtD5Ekh5D3Io8Tt5HsZTxrQyIt9AhMSvfsR6cJpe4XSq1+15gQoxYKi/XLz1a0L609lxVXeOdM3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giZSx/AUeShBUMO9I65ABr1UDyFkX1fjK3ptBmq/LNk=;
 b=MH5sv+PPEHjxKrvnDiFovLTyEL4t4XxY9WB9G30z4+lPdkRZoYLObP9MYPiwLc+J2BkX7NR3qHnLiWCgIaDMl1rTVM0SRNxQBVYXPXeA4NEjujfQkFx7E4cav5kKxBKYuyyy3HnV6TKQPkC8ecI5XLLmorsD/tCualeechLdfKs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5271.namprd10.prod.outlook.com (2603:10b6:408:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:07:08 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:07:08 +0000
Message-ID: <d1675455-6ebf-2938-04a7-651854e9a5c3@oracle.com>
Date:   Fri, 19 May 2023 10:07:01 +0100
Subject: Re: [PATCH RFCv2 03/24] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     "Liu, Jingqi" <jingqi.liu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-4-joao.m.martins@oracle.com>
 <aff4b4fc-ea22-2455-7560-01445ce31d8b@intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <aff4b4fc-ea22-2455-7560-01445ce31d8b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0477.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac1aca9-a1b2-46a3-6579-08db58486c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: klJO08XXYntTvmRMoU5MsLtZTnV+rqntV1o+IGAr8zVW5ljQcf7gvAeT3sgnRBq9/jnyq89ZnJpSSsUxtkzETiXJ2XTCKIN/nxJMTLyMoA2Bc8URjv8lvP4+eRMCwZ1alPHqvQMmbVLhKFeU/YCbBf+Jh/0tWIFXEMXhIFTxmwj8q/6uCVQ3w8hJ2gfG1Qhg5nvmU1pQpLiaJDKEhL8CyMJ72kbnpZxZgCMUbULiMTbqYAx2Cz4tQybH+uQ2e93mntpER8C0iso61zh25iFBEMjedaHn8aD7OgwWttbFYTAI4eNKy3IKt2ksPWLF3mxPtv4+fqLZbO22Cdl6DxVbOHEeXif2fmcGEiVT34rwZQXDZjzE7i6cZB3V9LH7rL9Hau8Ot4gtbesrDI60+jhvvAECe0kokseXwmVXZzZphC8q5JVd0EHmr8Sp3xYS8gFZ0hdG9QzL1vme2in1+Uf1dCEwXZECTzlAzfBscd50yDImhgL2PdYhPMJ/iKB2UU/0Y2BiN/lz54bO9wP5EB9uSaXjmkMcC97B9gP3FnbP35VqktIrg1Pbo76QvGZQiTYrCUF9jJwCpPL/bmPoPVBW5QHb9uQHVT5KQIwAnlNb0q9LKlgwxRm8Bxjf0SEIYbWX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(6666004)(6486002)(41300700001)(38100700002)(26005)(6512007)(6506007)(53546011)(5660300002)(7416002)(36756003)(2616005)(186003)(558084003)(2906002)(86362001)(31696002)(8936002)(8676002)(478600001)(6916009)(66476007)(66556008)(66946007)(4326008)(31686004)(54906003)(316002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmQ0NUptNEc4VkJlZk1yQmNRYVJqR05TVHo2UWs4YXJpL2E0cTM2YVZ5T2xL?=
 =?utf-8?B?ZUZ0bUhlb2d4QUpCVFkzeUZpSHpLenZWMTFGaEUzb3M5TkJwalFoQXlYNmNm?=
 =?utf-8?B?S3lEOXlNNlJDQVZ1andvdmkzdmp0NUVsSDN3aVcvYWtkdWswTUNxU3I2cXJQ?=
 =?utf-8?B?Nm0yQXhHSXVjZU9ueXlrdlkveXJGaDFMeEh5dEw0M0ppdUJXb0xidldzS3Mz?=
 =?utf-8?B?YVp3TmFraUMzTys0VEJLdU5pTG44MnhBdU9mSHp3L3RpUDMvS1BoU2F2eVZ4?=
 =?utf-8?B?NTM5YnVLT0N1YzhNSFptVHNjYkJRNlVpd01VSlZwZmxRV3Jxb20xNzlqY1hZ?=
 =?utf-8?B?MDY2eDI5Syt2ZktJN3pCNzVPdTA2a0NpdW9odHk4Mk9aRzVJQTRFRUs1Vk1B?=
 =?utf-8?B?dU1GaktPWkw0SVlVTElqK1dpdkJpSzR3V1pjWC84SXFuOVh5WTVrMjVhbDIw?=
 =?utf-8?B?Z3pBWkFNZ3RvRTJnRDBaY0tWTEtxQXg2OWlpdVlUZkorMDZwMytGV0R6SVZK?=
 =?utf-8?B?WUhDOEVGSHJnWmttYXB3aHhRL3FKTHNCSWRvUU9OTk9OTU92RFk4aHZxdVdD?=
 =?utf-8?B?WDdUTFU5dXlIRFFaNGpkYWZydmF4d25xSTc3RnBZRWoraHQveDd4M1NDcHNG?=
 =?utf-8?B?TWdWaTRHOTV1NVN4OWF1R0F6WFdpQUhxdTBnVEhud1J4aFVZaHJWMlFPUkU2?=
 =?utf-8?B?S052M0V5bGNuNXBiM1hNQXV4NWE5V2lIN3d0MlgzQk5MbXM5Y1VvOSszNjEr?=
 =?utf-8?B?bzcrVlZJZWZ5Y1phNjUxUFVQaG1wMHkzVi9EYnNZVEFXWnoyOHcxM0M0eDNo?=
 =?utf-8?B?WE1YZ2lXUktzK1hqU2hnSVlxajVwRmFaQ00wYktuNld6NGFTMlhYaytJZGpi?=
 =?utf-8?B?OSs3VmYzQS9aOW9uOEVDT3g3SUtXekdtWXo5MWExRDVSR1RHRnpCVGc1ZlNV?=
 =?utf-8?B?eW91YzJlSlk2Z0xtOEx4dU1TdnUyM2pYOU1xdmNUbnlvQjN3VGhsK1NqUHVm?=
 =?utf-8?B?UCtUWSt2QTdvT2JjTXMyejB1Y3lwQk5XSWszblhaMytscDNrMjlsZ1RhTWpa?=
 =?utf-8?B?Q2VUay8rS1ViZk4yMXBhM2g2ZUg2MXRvWFJVVlAvOVpsNkYzNlR6THBxYXJu?=
 =?utf-8?B?WmpkZUF1a3lOQTB1UkFCUzFmdW9DYXZHUkhLWHhNUHBVK1AyZ1ZjN0dtTGJM?=
 =?utf-8?B?VUJlL1FkZ1htVnhTYTYwU3ZlUnN4K2tibjZiVmhsSHhBYjZVSHBSam1EUXNH?=
 =?utf-8?B?aWtqS0pZQnlnOHFraWt1dG4xL3VXcGpxcFBZZGtkUGRrVHErNnB6ZkIyNytG?=
 =?utf-8?B?ZkdCSjVrRkNBNU9DWCsvWlRuaUZqelpnVE1CNTllbFE1YVR4MVdwLytkei9X?=
 =?utf-8?B?QmNFY2VmamdTemxJNUZkNjdrb25vMEY3VHl6UDZaRU5odW1VcDdhU3FZcEFY?=
 =?utf-8?B?NzlRNW52RFBoRlM3S2I3aldPSk8wRWlmVmx3VmE2RXo1KzBlaEJsMHlhQkx4?=
 =?utf-8?B?WnN0L241aVhSQnlGRzBnT2pKN1BzN1FpQ3hGMlAxbUl3T1JkVHVoTGwyVmU0?=
 =?utf-8?B?LzROZUN2TUh0Zk5zcW0vNUg4U21kbmRhZ0JqdWZCQVNOU05OWUNDRTdzYnJE?=
 =?utf-8?B?ZDd1TXB3Z1VKemx4VXNsVVJQb0U2Z2l5a0dMMVJCZWUvc21rb3pncWd4VHRH?=
 =?utf-8?B?c1VuZ0tVa1VhZXFEUGxJdXZqbGxPZXN3UndialNWWlZGcE1KZXN2TUh3ZTFN?=
 =?utf-8?B?cjdmZVVkS3preWdFWTROdngrUUREd2Fvaks0dkQ3cFV2YjdiVU5DZGRjSWR1?=
 =?utf-8?B?cGlsNFJIYkZBSEVKbjJWbWZjR3JCYXAvai93UldIM1huKzlOY3MwMnZ1bU1k?=
 =?utf-8?B?bldiT3BHNGVMSjJCcUNqd3hxUUhvaU1kUEoxSjFIanFnMWFwWkhyWm5saVBw?=
 =?utf-8?B?ck1jYVdTN1JQTmpXRFlYTFgyd0NzUHNEMHBNMFpqQktwamYzajBUcU5iN0pM?=
 =?utf-8?B?cmpoZUQxcnlSbk1tRTg2T3c0NDdCVDk1ckp3OFI1ZlQ4UkoyMjM5V3BWWFd4?=
 =?utf-8?B?UjVRaFFQNlZsd0VqWUVQaEpNNkMwVnU4MGVCSTl6STBPS0RoVkdleEYxM2ti?=
 =?utf-8?B?bVhKZUk3YVloYURZR0lKblhjUS82NnFjK2k1bCsydlJ2cCtjNlRXZ3hXQkxm?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eTJ2blBxdzVveHo5VGxSUmFQc2FWT1A5dGZwVnczM01NWmZNMExhNlloTVdh?=
 =?utf-8?B?OExPbEtpaWdUYlFLTWhKcnp6K1ErY2U5U1JxNTVoYzdOc002MkxKekhPUkRK?=
 =?utf-8?B?Ym1hc2J6L2ErN0c2OXZ3RUJYdDhqSUFhWHBxcnZwNE9jMmhOb0dQS3VlVE11?=
 =?utf-8?B?MWxGMCt2MmgwbC9CN2dzK2g2VzhCTG5LeldyZXByTmZBSC93ald5Ny8wMVo4?=
 =?utf-8?B?a1cvNUVzSE03cWNKREVRNmN2c0UvZ0xoRGI0cE5SQW1VQkdHbGs0aFczNW5V?=
 =?utf-8?B?SGFLOVFKZ281dCtkdXBRU1lmMEJ1R3pLWlBTSGpOLzEvZzRnM2JMdjRZd1VR?=
 =?utf-8?B?SWE3UXl2NVRWWDBsM2VobW5GQzdxRG0wUE9yUVJRK3k1emxTamplUEFyb2Y3?=
 =?utf-8?B?Q0hNK3AzZlFleVA1dVVYNGNIeTVHNjl5WkM0dnZJU28zUXRVMTRzYnpjcU4z?=
 =?utf-8?B?RHp1Ti9ZUmVueEpxN3g3UlY1b2ZBbFNabkJPbldMQUlDOEhmYy9sdUJvdnRa?=
 =?utf-8?B?Mi95Kzl1TzcvL1o4cWdQYzVid1hIbzBvdHg5SGNNQ1VBYmtJYVZKN3hLcUpt?=
 =?utf-8?B?SW9INmcxZ2dJdVZLQ052dVljM0dNaUM5Q0lIYzZmU0ZVWXVzZmx6YjFNZW9q?=
 =?utf-8?B?TEtWU0RXUW9xdnE1K2MxcTJ2NTFoOExSWS9vck9PbDVaaFE3ejllTmdlQVkx?=
 =?utf-8?B?RjNTN3FvRFZOcFMxd3h2TU1TQVVSdE5vV3ByM1NldlR3N1c2NHA3bytEdnpU?=
 =?utf-8?B?WTJuQzJjWWl4S2FxMWFwOHpjR1VwZ3k0NFdLTVNEbkJ1TzB2emNObFcveU1y?=
 =?utf-8?B?SjMvcGR5VXFiQ1VPZnpVSzdmcVlvNVA0OVB6bDZJTXpySUdoVXNMbHY1VmJP?=
 =?utf-8?B?OVJqUDJnT2RSaS9nTDJLUGxBSDAxYXZvZ1NyV1d3NGIxMmp5QkJvUVJtQ3Fp?=
 =?utf-8?B?VWROZlBlRHl1eFJkay81cjRmalMrNWZDbFRRNDBkLzRSM29kNzZNeTZwL29h?=
 =?utf-8?B?K21ReU1JeG1sY3diUWR5QnVZM252TXJaTjFQVGhkZzFSYmlsazFLZTlZTkhQ?=
 =?utf-8?B?bnVoVkZVcHZpTjZyK0hMQjh3TURwNFNCUWlDUngzT3Nub3Rwb0daeWs1STd2?=
 =?utf-8?B?WXNVZ3pLNFhDOXowWFdGMVNBUTZXdmhFMElCOEFHSWY4WFJocy96OXNLQXJ5?=
 =?utf-8?B?dTUxbnlneGN2Q1hzN0ltYW1mSHdJY1FJVHVDeVlNUVA1QVk5UVV0ZFRZRFI1?=
 =?utf-8?B?ZjhLcmZWMnUvZTI1dytNSGREaTRvM0dGcXdaMWk4V0VlKytHL05SSk91aUxT?=
 =?utf-8?B?cW12ZEhGbTR4YjhoRFVNVGVxMDYyVDN4aUNXdEpnTUQ0TzZlbnNYaUIwOTFu?=
 =?utf-8?B?UkVOdXF3QmluQ0hlMzh4b1lGanFId3ZubWU1TThRNHMwNmRwbW9ZRFBaQTc3?=
 =?utf-8?B?YlpaZlM1Vlo1YUN0TnZTYjljOFQvMzdiK2ZjUE13PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac1aca9-a1b2-46a3-6579-08db58486c82
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:07:08.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KI+1wu7MSQgVqt/zHCfNLvRXq7WiSJ3kKrxVAA9SgiHfvnpmEAgH7i1Cx1tE4GIrMTU4VNYtGsZAoBioNjQf9bGQm5tp4A8Ck4NGzka6wUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5271
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_05,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=807
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190076
X-Proofpoint-ORIG-GUID: gW-45LkAyL2NgC7hl62Qd_UTrNBGG_kz
X-Proofpoint-GUID: gW-45LkAyL2NgC7hl62Qd_UTrNBGG_kz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 10:01, Liu, Jingqi wrote:
> On 5/19/2023 4:46 AM, Joao Martins wrote:
>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
> s/move to/move

Indeed
