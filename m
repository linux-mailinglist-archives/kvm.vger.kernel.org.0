Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BF77CCB98
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343990AbjJQTD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 15:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344042AbjJQTDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 15:03:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D595BF0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 12:03:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HIwoRH019783;
        Tue, 17 Oct 2023 19:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3XxSPfMD7Pe/EaqeEdhKWrSYzcYbM6/0wjkGOTTzdHA=;
 b=KGP7HfP4USKj/LpFQjcH60ahSKr41G/HO5WZHlfvOX70aSD62xaVyzqtsKHmI0WpecRx
 WovWW3vHg5fEuYVx7QiMpVwLSUN0nwbL3xgIfl/h0TJgOqWrHFUlJCnjnG/7SLrBl7sl
 17uAnt/F5KMr+N4b36ZscMGg4Wpx2+bOBeP8VYhnUCOKCj64bjxiWAGRO/AUzcJO7KNh
 4T7NbGpPsJXmVfdtwyfbeD/1kvLnH/sr/rENzabZat14g6nQ7yKe+8rS9uDSYPEtPXD0
 ADbSppKWJISX/QPcmQs8bgt6goIUiU5AOUl9h6wWGX0eEnUYCFVuTgveuhvZrV37W0yr hA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjyndykv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 19:03:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HI1GbI021628;
        Tue, 17 Oct 2023 19:03:23 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg51f12m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 19:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKawYBi+7oZcvyZjYkvDoIfO6EU9SCPk8JwipxvHltgpCRv5MUn5mEp5DcN29km1IUdnN8BYlakUSgjbjpw6lCPeeSQ7LK6yY7EUVHUeHBou1sjUZO1OoDTFdtKdgUjOQ+KuCxqxiUgs2GOzs9mIJoVDhv/CBHDUoyQZr8Cskn7P5LswJjFiU/Oyu1je1B/KNFnDtVbZ2ltKGMirfa0z707JpukIoq6g5W7EYL9AbgCGyH0enj3H65JqJj2SbKcUKSS4EjIwFKbBTHgEiZnygTAWQubWLonCDzmEAzh6a+rZXOjvXc0L+LUMCSGDRPqz2pbBsgqttMcLEEWjjoYYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XxSPfMD7Pe/EaqeEdhKWrSYzcYbM6/0wjkGOTTzdHA=;
 b=YPZF8W4hsXaLCfY8fGo7WmpUeAceG7wz33k7s7lvuzOKR/0ac+rw0a/7fN2H/Mg9Z+O+rAA/YuuIzr0q1MH8josHiJqQbZfEpADKmgXp2ZEtH5kh+GWoKf35W6dx9A/CxlK2y31idULZBeIRawQ2untifS/LGtEH38tftj5ItEIR1bWgjLUhRW7DupCgmmujx3hPOMopjnzc5Bj+MpkfVOt9iuCkz0Mnab7Y2qeNQ0jzKaS8kHyjiUvjKCQPkz8fKteM9lArMjIk3Rc91sV281EcUAyEeumxgccXm6qZr97gzc3IlZpDujLQaoR/IIo5pACktcCVa7Hwvg9h1Mjnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XxSPfMD7Pe/EaqeEdhKWrSYzcYbM6/0wjkGOTTzdHA=;
 b=C3tIhU7gZHPEZcIhZVyiO8fYTSoTIdizUiHbdTNLUr38hgZTKFzzvlJeBIpioiG6PcxdeIF9KLx7yVwDMo/In8bvzQCnKpN4Pm88Q+VWOh2xyJK7axdGKTRz1h3y8DQXka5W4gT6u8B5NBzNG6Up5YoifY7TRkpuP3BWYORCkAY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN7PR10MB7029.namprd10.prod.outlook.com (2603:10b6:806:346::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 19:03:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 19:03:20 +0000
Message-ID: <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
Date:   Tue, 17 Oct 2023 20:03:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
 <20231017184928.GO3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017184928.GO3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0152.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN7PR10MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 222ac7c0-ca45-43de-fcb6-08dbcf43ba83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZ5www4HD/DBGmK5qvtUqOacSeI87HBcWkJssZmLA5ftpiZYE4FV9yt62xdlIdwCn3FpN/EPvSOPIoT4th5pFP/denKKI7UrGDqefL+yg8deHKE3nsmdSBA+D4fMT4rJGmnr5RtXn/KfRJUAObWeAgIUBBAbgkVH4ISZ68KgxWAraFetXzFU785aykfhS2GvgMTK5eLZEWoyZGhaoNrdn79iZmrkARtPztbT04Tp1O6VLI44lCLmq9/NLdrPASw5XXYvIkX/evpi6gvmO3z4cVsx+ERGZ18S7FTlQi4w3rDz0XyvUrUU/kiU6HVNY+ctFv3e1S1VgyEZnkKEYxlpvZIMh1JA8Css+7ZF99dUt1k2eqqI/RnHKE9CjA77L4ssMo3DTjDhG658oHJ4wlITlvUy6ddo6gb0WB5/XPRRawiDU5x9gr17oDpuGDocLx2mA9CLgj1LniEtZ1pD1NoWso/2eLkpb8CFX3t3iKTCbtvBMEqzWlUFt5EGPQRXZkAa5cShpEBMTIaQhoqW9Io2FnSlkAvOcABQgpBgGbe84XJM8i5VOyTCSNjImB1E7QmRsUxRVTZWwUoET0BQAIPOthzCuQ03QhioqqK4yJvhps3KHfAG11a5sxTt9p5HNycvxBk2dPZkKm/lnDOwIHYrX1bfHi1T5ytS7GsXvVWlDoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(2616005)(41300700001)(8936002)(5660300002)(8676002)(4326008)(86362001)(6512007)(36756003)(38100700002)(31686004)(6506007)(53546011)(478600001)(6486002)(6666004)(6916009)(316002)(66556008)(66476007)(66946007)(54906003)(7416002)(31696002)(2906002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHBwaXRmY0Y3UitQenpVTjQ3WDZrMTN5aW1VMFUxOFZrdUMzL1hrdVpocm9O?=
 =?utf-8?B?QXdJamNTcnZJYnpJTlVtbHZ6WU0ySmlWenM2cXNRa1lLeExGMlhNQnQ1K3A0?=
 =?utf-8?B?T0RJWDdJdUF4SmMzc0FRWEdIbklQUXNlMTFQSkc0cG9hSnNvTWh3dkhOTjJk?=
 =?utf-8?B?RUc5aytuK1lkL1VMUmVQZFB3aXlzSGwzdW9mdnVUbStZb2JlUlJaZk5sMFk2?=
 =?utf-8?B?OFpxdk1NT3ZGZkpKa0RzVGtjYzg5OEh1R2ZHWnhmay9mRVdzWHhRTjVuNDF1?=
 =?utf-8?B?TTF2aGFuVUhTMGkydVdBdk5jR1FZekFoRHhvekZPU05Sa1JjejVxS0dDeERW?=
 =?utf-8?B?RTkwMHdINnN2RW9RaHIxYzBObk9oTDQzbGw1K3pqbW1nQ2wvMHQ0c0psYmpq?=
 =?utf-8?B?WUhQM2lKVzUxZEo4NVZpZGVwTG9ZdzBoUnJPNFlWZjhWV2VIdnpCVDgraVda?=
 =?utf-8?B?TVJUYzcrMWt6bkFBLzI5VjIzMEIrSHF3aGxwd3NVTXo2WTkwcHJMMkx5cldv?=
 =?utf-8?B?bG1MOHl2dE9WTVJzY3VNWE9WZWtBZ2tpWkZWczRYeDRWaG82djBvY05kcldS?=
 =?utf-8?B?M3RWQ0ZQdHQ1VnlZL091cG9pQXZ0Q0drK2EyUXhIZWR4M2gvVUU0TXllMTk4?=
 =?utf-8?B?YUJHNnBUNCtLSEc0b0xNQnpvN0tzaDFZem5QY0NST1dCVEZKZVo1enhHTGRj?=
 =?utf-8?B?VXJVdjkxR3lueEFTZkd2bFNkc1BIQTRmQWxvM2hVeDFaMUxEaHVKMGt5SkJw?=
 =?utf-8?B?SjI1K1htR1dMN0w0L2dZa2VNUHhMU3ZBcS8zOTVPQlcrTTdkS3piQVRnL25G?=
 =?utf-8?B?dTNteFVKQ0huUEQ2VTYvbTRTRElJS1ljUWpYVGZFMHVncVBuUEV5RkpwTGFM?=
 =?utf-8?B?UHRnK2dmcUVaQUFRbjJYK2FzU2xIbFl0cGg1SUZ2VTFVY09tZ0NxUUR0Mkxy?=
 =?utf-8?B?Vm1LVnhjOWNYOVhmb1VWOWpqczZDMTlFVmFYa3ZSQlhGMTEyUE9MNTdYSmh6?=
 =?utf-8?B?NUpuN0ROa2llZXRHZHhMWEkydE42TDNWRHRJVnU1dlRTSWV3NThkVXFHVU5R?=
 =?utf-8?B?a0Y1RVRFaGlyVkN0dCtIQkQ3YVdibHZ5OUxQNFgzVENWT0p0VTUxTUk2SXB3?=
 =?utf-8?B?REpaMHhGNHdtTlZhNUdtSTZjS1o5eUdjS0xwTUJvdDBqWDJQM2w5WVgxYWhn?=
 =?utf-8?B?V25IcEFab1lmc1pMOU15VCtFQlJ0RG9QdnpKbVdsV0hEYUUwbWRCakZ4WmVK?=
 =?utf-8?B?OCtRaUNFMGVCSnk1Y3Q5ekcvZVJWMjBVZE9wYkZ3RTlSSnRCK0VzRjQzYk1l?=
 =?utf-8?B?d2tBVEFLTTNSelRhUGJYc3FZTlkyY1lEZmJtUnFQWkFwd1pOcVZCTWU3Y0xM?=
 =?utf-8?B?ZFU2WEZWZkljZ1BFeDExaVl1TlpVcnNsaVBNL044dGlKN3NZZTMrMjhVT1JD?=
 =?utf-8?B?ZXUrNnVYZmd0UCtDMjRBdmdGQVQyU0IxbWpzZUxrNkdSeUVLZTFUbUNsRHJz?=
 =?utf-8?B?VVM3TVFWc2JWaW9pYTBGbUpPbkdKc0NZZmtUZmZ0Z0hTUjg2MTVlSHQ0T0pi?=
 =?utf-8?B?WjE1eU41bUpwNy8wcDZoOVcxQ0s1eFVkcEpDWk12VWtaUTRDL0hTTXN6UTh5?=
 =?utf-8?B?N1NScjhLL1ZVdk9NV0JWK0RvYUdMNVJLeG9mQitTTDMrUm5yVldpV3UrVVRn?=
 =?utf-8?B?dEVXdFFUK2FxVXNXQWFjSnFUc25YeFh4QTd3WDFMVFlTeWJtSU0wM0xGZjJN?=
 =?utf-8?B?NjhhMjZTUFNhWXNJdHlxRTlaV05hczVBTVQ5bmlka1psK2hINWIrT0ZYQ29p?=
 =?utf-8?B?K0JKQ0RlQ0x2clg5NnBTLzBFMFRzNHBPb2NqYTZScHdrWGszSUxoY0M1YXNJ?=
 =?utf-8?B?dG1wSjFQM0l5NTNRbmxmY3dCSHR4aWdac0JFR3U0bGcyRnNXWFFiYXhLc082?=
 =?utf-8?B?eUZUUUtEUmpWKzZsS3d4ZGI4am1oZWNmb3Q5VUM3eXcxS2pUMnR3cGF2UHFk?=
 =?utf-8?B?cE02NkVrMmFjNzRabGY5bGFPVWFha0NKWWVFNVlaZ2wxT2YxeWtENVI4S2JM?=
 =?utf-8?B?dGNNY2gxVm9zS1JTU3dxR3ovU25ZeXoxQXpZek1pR2l4clBzdXpEL3k1YlpK?=
 =?utf-8?B?ZmhQY2h6SVFCU0dGNmhqZDlweks0RTVRVWFiZFBPcnB6MjlmcVlKbE9pNHlV?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V1hDb2Y2MnR1Q1liaWZxYzJubVdrWmtBbnl1QXRrcWZlWmduNWxMaEVNWWE5?=
 =?utf-8?B?ZVgxU05tSjFpelRKS0Z3MjFYTktaM1FJc0NIeGh2dUtJZnBzajdZQ2ZmeWZv?=
 =?utf-8?B?YUF2cjMwTEpDMUU3WGc1YXhETE5HcUhsNHRKVUZRNFdKd3dtOW1BNUFnc2N4?=
 =?utf-8?B?UzRjUUFWbEhHNUluazgrMHViQTFHUDRqU2NZeGk3alZZdkJWLzB4ZS9HMGZv?=
 =?utf-8?B?bzgva0MzbWpMMG1uZ2ttWE1vNFRTSHc0dlU0WnNZWHdKUWd0ZjMvb3ArVjlk?=
 =?utf-8?B?R0lRKzM0ZlJldmI1aFJrTU93dXlKZmlDM3hJTUNnZCtsTE5vUmxuMGQxY1Yz?=
 =?utf-8?B?WjRpMS9HOEdacVNMWkJxSXg5KzRVZEVJL0l5bVoySVVLSkgrRWhXZHNzQ3Z4?=
 =?utf-8?B?KzlrZmFHTE90OVVMR3hFRG8xK0kra2JkTWZEK0FaYWMyS2h0TXUvZmpSZ0FR?=
 =?utf-8?B?MkF2YUZmdERWU1ZtT1hUVDFYQkJLeElTUFJxUXVTenk0RGZmSWxjcThmTzFM?=
 =?utf-8?B?Wnh2YSs0Q2hqeGJIbHdyQUFxUGdKRHVSUkVLZk1pendtbzV2YlAzMWJTZU5E?=
 =?utf-8?B?a0FOUDQxTDJFcExrZDU2elRLa0xWMUJMdDdBUzZ6UXg2SWhPTEkxeDhtNXQ1?=
 =?utf-8?B?RXlaN3Fsc0NXcWNVamNtTFRXdi83OFFvN01IbDUwQ1BrOVkvZnRoTnlDZHh4?=
 =?utf-8?B?QXBUYWNmd1lPd0lDcSsvRUJKSUhPSSsvVHZPd0ZwL2owc2RmRmc2WHpqTFVY?=
 =?utf-8?B?RmxBOXkxcXRBbkFwQWtYV2YxVXd0bVFkckFPU0NudHV6NTFRcmdGbVdEOUJR?=
 =?utf-8?B?N1RHUWxvbVpoczVTbmx3dVE2cDV5OG1DSU05MTZlWExkRFZlRUl1c0lNYTJP?=
 =?utf-8?B?S0xCMWhPcW9qTjlZbVJKblRpWUdVMG5zSi8wcDh0WHc2MXV0bVo2Tk1hSWpG?=
 =?utf-8?B?NWdSTDNDeHJlbUlCdFQvYlFTSUY0SXk1L2p0SW91N0IwUndsRmxhM0RpVzYw?=
 =?utf-8?B?YUFvdldjZ3ZHRFFqSGNnTk9IRmNmZUswckZJSE9tcmlHcFNCWFAzZk1VWjRX?=
 =?utf-8?B?MS9VOTNLamE4YUhIT3cwKzdSSkZ1SXJiZUZLNHV3cytIZkxvTmVMcElrVURL?=
 =?utf-8?B?Tk5UMTB4YzJodDQ3TWNDVHNYT1ExU1dHV2s4RXlOSWVZVXl2YUo0b292OEVj?=
 =?utf-8?B?UTJ1RHU0WGppaXZuSnBOVldEcytYTmt5ZEtIM2lrYnZwQjdhdlFURDYya283?=
 =?utf-8?B?SHNhYzFOR0J1cE9kd2VMTGx4TUVGYTdFUTBrRkhjVDYzZVZ2dU9sZXQxbTBH?=
 =?utf-8?B?TTlRTXpBVERyT2g3OFJCWXRnc2xBaUJHTzQ1UzdySFVYdjVaVlNYSUV5NnFN?=
 =?utf-8?B?UmtPdDdjejB0UFJ3TjZlQ0dPTHcvWFNYbU1xV3BQcnpZR2wzdEUzOStPWklI?=
 =?utf-8?Q?pO9DIqmS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222ac7c0-ca45-43de-fcb6-08dbcf43ba83
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 19:03:20.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjXbj7AIr0M4J3KYgmpAMWDCX1lKc55z0GMPuDrd1FXelasaOQdr1bXB1DxbltWrfjLqHQA7kh6Sz0P3xeBGkEc9/Zd8Hlgg5OzGqhl56xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170162
X-Proofpoint-GUID: Op-183PAJR62Z8buFxXt3wsHKsNjkcts
X-Proofpoint-ORIG-GUID: Op-183PAJR62Z8buFxXt3wsHKsNjkcts
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 19:49, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 07:32:31PM +0100, Joao Martins wrote:
> 
>> Jason, how do we usually handle this cross trees? check_feature() doesn't exist
>> in your tree, but it does in Joerg's tree; meanwhile
>> check_feature_on_all_iommus() gets renamed to check_feature(). Should I need to
>> go with it, do I rebase against linux-next? I have been assuming that your tree
>> must compile; or worst-case different maintainer pull each other's trees.
> 
> We didn't make any special preparation to speed this, so I would wait
> till next cycle to take the AMD patches
> 
> Thus we should look at the vt-d patches if this is to go in this
> cycle.
> 
>> Alternatively: I can check the counter directly to replicate the amd_iommu_efr
>> check under the current helper I made (amd_iommu_hd_support) and then change it
>> after the fact... That should lead to less dependencies?
> 
> Or this
> 
I think I'll go with this (once Suravee responds)

> We are fast running out of time though :)

Yeah, I know :( I am trying to get this out tomorrow

Still trying to get the AMD patches too, as that's the hardware I have been
testing (and has more mass for external people to play around) and I also have a
higher degree of confidence there.

	Joao
