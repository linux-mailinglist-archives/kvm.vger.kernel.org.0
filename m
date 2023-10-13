Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D617C8C38
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjJMRXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJMRXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:23:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70820A9
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:23:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGaDnB022132;
        Fri, 13 Oct 2023 17:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=6SKNtVzQi3sO8B+fwEQkWcKQK2k3TwrkBREk/AKJ2QI=;
 b=w07sJDAvWpPFZPZ1flBoYGtRVFmh74vS3Sk/4e38cFzWP/SXBvErOqWyYoqtK4jKQT+3
 n8gHXvGHii7D17siQYuZYr1nH2CR3+arjzfpz4UKMCQW28Mi7LXuj3mh4t/jNWsgQSP7
 KHxjLMDicI+mWJR8WO6YwTDWQv6xD7l4ec5oGqbQQtJgyfms5RBy4KFjw8Su3a34ENDS
 vzxIxuRFxaEpSw+EzrMs/xMaNGDnLmHlQAQ37Jma07i6dXrsrvtqYmohCPrZtep5BiL+
 yTqhVFi7KgBP9g80doF7GbuCeK7pt0uYPRfhymWrVXTcbJNrP0fU/XctJTKOKX4sDl1U 1A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh912tqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:23:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGtt6h020228;
        Fri, 13 Oct 2023 17:23:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjvwdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:23:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJKgBJ/xXJHUDFIrWulzVidiwbR7ojqfRfUC0t3ZJmzBSFbW7f6Bs9R30u8i37Ureinilh29NYX1IJNabHphD/5EG+6dLyWL4uT+ngOR/cFnsdDznvy6ysokbyirXAKUZHCQJGhnVW2u3U98tXXx2tHize1q/gdSC76KP2PVWnVtFxyPSKTLnagnjBx4AM+gMEEvCBEzc4pHjSOOXEEZC69qSLjLFoAEfff6di/4p4vxyJZdC6UuaVT0ZHFnVc8Lr/ateldYCE/iNlaQESemwF6ZEGDcnm1NNOhvzR1eH+OqEfpAlD11bfLGuWzMk0pHEEfLZJP6Dg5gQWdP5MYY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SKNtVzQi3sO8B+fwEQkWcKQK2k3TwrkBREk/AKJ2QI=;
 b=JHGyPbIyGDxF/n0hIJGUX9HMz0VJcHpd7ltYTMlds+lbuZ98jA4qHvy/WZ/hD2b1AyXFjcO4rLvDEE2tycjfq1+h4c/C/XeZ/0II2WFHq79fYbUGN+9GvFvy5w+AVyZVjEJgRjeebshobN+SEqG8fhwviSxEfucXrYjXYvh2PL2JIqg4F+wq6+3W4sD/0Te9Jc6/QctoXzTltsIqjumrV04DhIdHmeunRuPkeqtn2EY8EZFTEfddsKdC8/ut3fngbXtRnvpNWVV/4/B/cl5cMbe7FT9b9b4z9g0Oq+jgySXEm6U4265rwYqWC4ULuxu6YbFQ9xjxTxPEZc8urYLS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SKNtVzQi3sO8B+fwEQkWcKQK2k3TwrkBREk/AKJ2QI=;
 b=W/ULXZAzXBdpfFfj4tsdsM0lVqYG9Ts5NgKYjlkWHZ67CugguwFln6HwvDH8FLMWon5VGb8nzDtFYiKyXNJ/iiRcAZF9y20ksHEIz3+5mj0LwmsMXMtG9gUacDnbLKb7rbaMMTESyOp7YoAw2AWngxS0nWuaLhDKRLNV9PbL958=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH8PR10MB6385.namprd10.prod.outlook.com (2603:10b6:510:1c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 17:23:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 17:23:15 +0000
Message-ID: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
Date:   Fri, 13 Oct 2023 18:23:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013171628.GI3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0013.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH8PR10MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: ff67a77a-f05c-4413-5b27-08dbcc1115ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMYK1tckvSv1kwE2bjGbhBfH84O5BrVI6iWVNRf55GcUIpTPnKt6HWJIkLTtOLbaFYUfYYevtGKPU4bE+WCGj4TTRKKNizEhCrHk02mYHYXq1LxkVV65CMF/kIGNcHnMXVFhwMsD37GuTmrWAfUmfQgwNEv0Eao//uNqO1JoHjEQxWXibSyU0ZWINugl27NQoFVN2sShCglJNqjP9iY7DIAD1twROYGOiXwqaWvmtNftoe7ZuXbBJ4ZC+zu9gv1d6qomr2ha69mpGLWh3BAJG14rWPK8TySJ+q70ViKRdAT6NpoJXJZ49UPu+ng3ycbSAGIYfejoXsg873nXvxelIAzqhPsbwtG/3sHSRfkYBkRTtOPErraxeO7RCb5gphwGVzUEuK/BpJuS4DD8djkveWrt6I6tYE1P17CBU4OEOky/qXr2zngA+kMq5aLFHW0+lRF162UPDRVE2uvRpByeSbHCHlJhI9xobwOoC3HR/5y2RVW5aIJoFtvbK0j6UJHi1XWfz7ZXAJuRxqsu7ROSLN4bbV2Giwr18hMPFDxhiEHw7FCuyeeLo0xw0dTffb57Tqr+X/SY+XZxwFtunORwvXBpWkrhA2Q1tps5jb/0H3bIynO+wRgCmreiQgeqyiy7psCVKxhHLNMI0LzUc3Hn4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(26005)(36756003)(2616005)(66946007)(66556008)(66476007)(54906003)(41300700001)(6916009)(6666004)(6506007)(53546011)(478600001)(316002)(86362001)(2906002)(31696002)(7416002)(4326008)(8936002)(8676002)(6486002)(5660300002)(38100700002)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmdRbW9ZU3NBejFkN2JsWDNDRGxvRWJEYzNaQ2dvQ3R2RS9Pc0Vtb0V3Qm42?=
 =?utf-8?B?MytGSjE3WmJOYzF3cm9hU1Q1bHpwbGdBYlhGSWYzQ3Q0cmJTQmZtUFpmQ0dD?=
 =?utf-8?B?eXBkOFZnUjE0MDBkR1lzdWJIYUtKNStGZGtNbEd6Wm5UY29yRnpKd25DRVAv?=
 =?utf-8?B?NHZCM0FCSHgvM2RYV3hsK2luVXhUQXF3WFNqYkNQU3ZBaTFIRktrVTc0QVlq?=
 =?utf-8?B?N09MVWtZMmlIV3J4WnBtZklCMVVHdndZZ2JkQmRTQTQxaW0vOWNLaExiTzEr?=
 =?utf-8?B?MG9hdDRMUXNhUmZNS3dCTDlKN2JPMWJKbkJyMDBna1B1dS9vb2FOQXZsM2FN?=
 =?utf-8?B?TGJJK1l5NnN6N2dHVlZYNjNjRERBM1FFWmFhU2tGMGEvekdJbTdEM2hyM0FS?=
 =?utf-8?B?R3dYWEtqY1NYeGFGWVdlQm85SXY0d0N0djM5bmYyb1I0K0ZwdllreFBiTGlU?=
 =?utf-8?B?b2V3clZRdndUS0VQTmhxMUdNMlBsNDVaODlVa1QxWUlGNFlhZllRWS8xMUNj?=
 =?utf-8?B?ek5veVRmQXlwQzR3YnVKdksvcS9nRUE0c2pRbnFGcWNOc1BDNS9aUkV3elBi?=
 =?utf-8?B?RUJnZ0dQdU1iQ3VFTElrdUxjZHdUaTgxM3o2TlpYYktBQ1NqcVJoUTRCalcz?=
 =?utf-8?B?UktnQVJmTU1DUzZSckZFUXZSSWVRTFA1UWVha0VjL1Exam80V3lESkJMY2tN?=
 =?utf-8?B?cVlCRDZrOGwxdXJDb1dDbTR4YWFIUHZwTnlSa0dJUm1XMkZ3My9pWW55NkFu?=
 =?utf-8?B?d2hFU3ZjZnJvWmpwS0p0aWtKTHVRdTl4UnZzQSsvQUJ1UzF6dElpWERQak9Q?=
 =?utf-8?B?WFNONzJVTk5GcjVlYks0Zi85RHpXeUZBM3dsVHZiWklSU1VuMytJN2V0QzM5?=
 =?utf-8?B?YmhoWmhldHMvYkZpUFE3TjVBZUNlRVpSRHIwZmtTSGxvYTdYMWM4bWozcEtm?=
 =?utf-8?B?TStCMEIzT3h1TE44Y094QVU1V1lIa3dXb1dCRWhhUFA2OXM4T1ZrcGRsMGpX?=
 =?utf-8?B?enJOQlB4QUtlYjY0ZWdYNEovWUJzaE9iNVk0VjQ4NHdTU3ZGVVVJS1Vlbngv?=
 =?utf-8?B?TjNyN0RBMlREZWk4c2VyU1hsTFRDWG4xU2RvUzN3L3hRcFJhK0pYWStDZW5L?=
 =?utf-8?B?VTdTK0RTU1N4NjRhQ1g0RGt2WU45TlRWeEljQWlIYm1WcnV4QitJV0ZQZW0x?=
 =?utf-8?B?cjE5YjVnUkxNNGt6am96N2ZLVjREQjBNRksvNVcrYjMwY3Z5cmNiOGl6WFVF?=
 =?utf-8?B?K0VJMDd3YlhpbzlIN0ZoYVNrcHdEZEp2cUVkaGYzS2kxR0ROTjQ5VzFqZG1B?=
 =?utf-8?B?VzJYRTNjT0hTVDJUd05kT2dPUFliOTk4Q0ZkbkE5VkczT2xNbUg2akFDNGNa?=
 =?utf-8?B?SGoycWdVRlRnNE9qMTd0WHhoa0ZiYmdiMjNGVHRzUkUyc2ROUjVTUDZQV2Vr?=
 =?utf-8?B?a1BSNFpUeVdrRXhmWjk2WmgwTWtmRHVCN0IrUmxhdTdydk9mQTZvcmZ1Nm5u?=
 =?utf-8?B?L2xXazdHR0tvS2o5aFVCYlhLODI3Wkprb29BMHRtQnJEeVNLOTV3Mll0ZUdl?=
 =?utf-8?B?bjhDbzJrdUd1T3ZyNmxlUnZqb05odUdoNENmQlpBRVVONENKc2gyWEU1enFx?=
 =?utf-8?B?aTFGNzhmc05UcmxUU1NUbDQ2ZUNGQUVJZkNKemxiVW9GdDN6OE9qUnZQMU5i?=
 =?utf-8?B?K3JEUjU5dmhZUEljQmF6SmhvRVcrUXhNMWR4cWlOWFNGWmFMTUQySjdtbk5o?=
 =?utf-8?B?SDJsbkdCbkt5M2FuRnc3YXlpNXBFMk9CZjhVaW5VQjV6c1Y3WUhlMW5VU0Z1?=
 =?utf-8?B?U2hKREVWMEh5c29kUHpmTGJoL1FHb1dNNzdtaHpxY1JUMzNGdG9EUXN6MSto?=
 =?utf-8?B?VlNlemIvU3NLM0ZoVVo3cjdPSTdPQWl5NS9hL0plS2xVUWMyVit2U2NYemJM?=
 =?utf-8?B?YTBBZGRFNEV6REIrbHUzMUVSUzBHOTNMOFpGMnFFRVVDemcyY09TcW9NL241?=
 =?utf-8?B?a2toVER6SW5BT3g2YTcxeFdBRWt6U3cwSU1KWVZWK21PUWVoeVMxUkNMQmp3?=
 =?utf-8?B?cUxPTktEUGVWbVBySUVSWDM5Y3VscW1ZTlp0Kyt0T2c0Qml4c3o0NXRpNVJh?=
 =?utf-8?B?QmVpWFhSbU9PVTJka0FvQ0N4b29tLzh6T0hqTXd6bVFzS2p2N24yUitnbm5a?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YkpWcllCRXZLSU5CS21uVEF3KzA0Sk9RcSs3S0xLZ1dhd1Zjbk1kZmVUL0pD?=
 =?utf-8?B?d0J3RmtaenQ3eHdBU3BHYTNjQm95WFZJRUFaTTdGOFlBYnNyY3FHbzZoZFFD?=
 =?utf-8?B?UzA4cWVBV09DZnJrcXVpNmZiMVBjZW8zNUFjOHhzNFBtQmtPUDNSbXRyYi9i?=
 =?utf-8?B?a2ZYa1BDWm5WVW14ay9NN0dkckpFMzYvUng1U3FtcG1FUVAyQUdTTFVVU0FY?=
 =?utf-8?B?d3R0VkQxeklxc2dDaE02VW93cDg3T3FQbHo1RHAxSEtOVWF0N0Z5aHNSbGZu?=
 =?utf-8?B?YW95NHBFbXNXWTBvQzJ1bGV6RnRPOFFzUU9kcDAya3VIbDhaMEVFRzZHOFpr?=
 =?utf-8?B?ZGFSa2JEYTdJWm4xUUlPczBYU0NXSjRwSTRQTzVadGRsMWRPNW1YSEd3amVG?=
 =?utf-8?B?SWN6UlJjdWdZaGthZ1ErN2N5N3ZvL3FEVTltVHZVU29xQ3VnR2VqZURIVFhn?=
 =?utf-8?B?S0F6ejRRZHFkWU5GV09ndE01VlUzV2dvYzJIRURVWlBWcUtyRDR3T2cxSkRE?=
 =?utf-8?B?eWdNZFNzVWxRRitRK1FZSk5SLytwL0VJR1h3TXpKYmt1Q3pEYUJPS3M3aFB6?=
 =?utf-8?B?bWZqaFNBaGpRUmhXTGRDL1l1c2k1bVZzYTdWaXFsakhScit6V3BrazNLZ0sw?=
 =?utf-8?B?K1IxU3B5MlRsMnVBQ0dja21GYytqQlNzc1gveFdXRVdMOWN6Q2hWNGZqWnB6?=
 =?utf-8?B?ejBIbmp6QmNPSVV5NkVvd2xNNGhjRWw1YmxYbjVWT0V3eWZqUXk5Y2NKUEFl?=
 =?utf-8?B?WjYxWmRzRXlKeEpuTjhra25WbmVVcFFyTVM0eGZrQUdkTFdjOS9lNmdBajFB?=
 =?utf-8?B?eEs5djRkek14LytsRFJDOHpjYmMwSWRhL1cyU0g1SnFYNExBamR1bkJYQWtB?=
 =?utf-8?B?c3UwUjlJSnNvc0NDZlB5QnI1YU8rSS90SkFhb3RROGVrR05vWWIveTFOV1dn?=
 =?utf-8?B?emRiK0t3cTVjeGpiUHdUbXNXamdzZFVNdUdDUy9BSkk1bndBVVh2OVh1RzNG?=
 =?utf-8?B?Ly93K002dVUyeno1ejJLK29yUWtuUk9PZ1JEY3hQZTlPWlBVVkh1K3JHUjNn?=
 =?utf-8?B?MFNzc3VLQ1MvWnA3WlIxQTNpMC9reVZHa0NBbys5Wi9PM21hdFA3NGI2ZzE1?=
 =?utf-8?B?NWdKUGtKNXNLczdNMmIrUWFvV3FHUW9HYnJEZ3JEcVVZalk0SGhXajVPMUU1?=
 =?utf-8?B?NS8vYzNUM2F2N1VNY2lrYllQU2JiN2JEd0YySlljSU5SRU9EbllKeEdZZGZX?=
 =?utf-8?B?SVFDS285L29UdzJiaHdGK2Ntb1BBTy8wWENqUVI5THNaSkt4djdZM1B5NlJ2?=
 =?utf-8?B?QUtMY3JsUFY1RGJFZ0N1U0xnTzhscWVCRm0xaDdERWFyNEowdksxTlYyZitz?=
 =?utf-8?B?WnpibkdZaGtJdkZsWk84eUcyK0dNLzJObThkQTVOSVBJZ0ZJRzdIS1lndHJX?=
 =?utf-8?Q?wzQdJkUX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff67a77a-f05c-4413-5b27-08dbcc1115ae
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:23:15.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcXBLZ26pGwgC843vAQSs6U6inmqgHt3kOpNOfWqCOfBOMwTE9fp7aK+/Uo7w264Nz3Jl1P0spJdxgNhgKRRTpyJgFrj/mJOJ6K3pcPgP0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6385
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=897
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130148
X-Proofpoint-GUID: YiAvhQqL38Yny0BfTM4ZubDyfnljliaN
X-Proofpoint-ORIG-GUID: YiAvhQqL38Yny0BfTM4ZubDyfnljliaN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 18:16, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:
>> On 13/10/2023 17:00, Joao Martins wrote:
>>> On 13/10/2023 16:48, Jason Gunthorpe wrote:
>>>> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
>>>>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>>>>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
>>>>> can't exactly host it given that VFIO dirty tracking can be used without
>>>>> IOMMUFD.
>>>>
>>>> Hum, this seems strange. Why not just make those VFIO drivers depends
>>>> on iommufd? That seems harmless to me.
>>>>
>>>
>>> IF you and Alex are OK with it then I can move to IOMMUFD.
>>>
>>>> However, I think the real issue is that iommu drivers need to use this
>>>> API too for their part?
>>>>
>>>
>>> Exactly.
>>>
>>
>> My other concern into moving to IOMMUFD instead of core was VFIO_IOMMU_TYPE1,
>> and if we always make it depend on IOMMUFD then we can't have what is today
>> something supported because of VFIO_IOMMU_TYPE1 stuff with migration drivers
>> (i.e. vfio-iommu-type1 with the live migration stuff).
> 
> I plan to remove the live migration stuff from vfio-iommu-type1, it is
> all dead code now.
> 

I wasn't referring to the type1 dirty tracking stuff -- I was referring the
stuff related to vfio devices, used *together* with type1 (for DMA map/unmap).

>> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
>> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
>> essentially talking about:
> 
> Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
> 
> vfio_main.c:#include <linux/iova_bitmap.h>
> vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
> vfio_main.c:    struct iova_bitmap *iter;
> vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
> vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
> vfio_main.c:    iova_bitmap_free(iter);
> 
> And in various vfio device drivers.
> 
> So the various drivers can select IOMMUFD_DRIVER
> 

It isn't so much that type1 requires IOMMUFD, but more that it is used together
with the core code that allows the vfio drivers to do migration. So the concern
is if we make VFIO core depend on IOMMU that we prevent
VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
select VFIO_GROUP or VFIO_DEVICE_CDEV but not both

> And the core code should just gain a 
> 
> if (!IS_SUPPORTED(CONFIG_IOMMUFD_DRIVER))
>    return -EOPNOTSUPP
> 
> On the two functions grep found above so the compiler eliminates all
> the symbols. No kconfig needed.
> 
> Jason
