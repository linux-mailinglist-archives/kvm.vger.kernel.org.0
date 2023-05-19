Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCE7096C0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjESLsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjESLsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:48:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFD7139
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 04:48:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JBiWSX004952;
        Fri, 19 May 2023 11:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qKpzHwknt/M/VerneWFXjmm2PWcsXatKU9ftTC3MWtI=;
 b=r1D+wE1UR4SLUm93zPpW6dE1OTyIrnsocwmSeGhCHesnnFZPS44Tu0SJZYNuwrpVrdZc
 XPCgwMlKoVBd/8Mc3yHl6rrOGYBmUNm3nuZNNthWxSxKKZJLvntohBa5PXonOr0TZed+
 DIVXmlFMgKqDWMuRr7muBgkP7Wn0taVlWaTfH+4AFCGy07jWzseAQ5Rk+2wCRGdOEmOg
 Evhr42sO186DBTwehkUQM7kyg0itjxwhVNJhg7DfwKUk5xbs2oPFGe2hyZBos50P+2Jk
 M3/IVJjG0udBuE1Ash74Yal+AiaROa4wLESD+BzDH1zu4RiUsG0WN7BvRNZTR6K1C4Be dQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxwpmksd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:47:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JBiukN033842;
        Fri, 19 May 2023 11:47:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj108fn29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLc5pDv6RqdIXCC8JxMW8kwZB940zHIlu9inzJ+nLeNS8TIgD3e657IZQ1ffeS+0jVXrdLpwZ9CMOD6jdFABGrg/YXtD8tvERb/JaWOCn5u0S1mVHXSAm84B/u6e+9K9rfVUXRswqI1SmHY99tOrK9y4rxUEA/gkLwMA8WyHNYCH6V9/GrhbZpopIIGsWztYjIjT0wbbhjALz8BiPfgjwSv1t5/yjN73hLBBfr4Mlrw2t5QcMdvyZnXPQIkbUQmczEWGKuACmjf2e23E23lJ8gIYRF50mQ3MoTPp0bJm5AoVR9cQ5nU96R6X0LfxmXmNCLoTQH/K173QKvo6rXMQBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKpzHwknt/M/VerneWFXjmm2PWcsXatKU9ftTC3MWtI=;
 b=iXoUuEEmXz4cPwZhUshtxzng3bUpimMmVCN22xhHrVrbxmx0wxqW+jjL06M4EJqUmdBci/EiCYJd78IUNx53krrWJn92C+RC6tOc+vgJG9yoXKqGKLI+flGOittn59y4ohhBKYwsco++PBNPnmyXEVIvwLmigRPym4EsEnBCo49zONx0BnjBLD8M69yCGjPSthQmZfx++Prlzh4i95U0VV6rbix6433HcK9Cu8rSjqP9lcH9GkSzJSXIymsOTSZp6C504D1eSXKEjlpQ/fHDFKuzcIsJHq5wuAN9xYqeyL5et88WputUsraHc4lWUfCqaMGY4K47ki/SikN4ifpqtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKpzHwknt/M/VerneWFXjmm2PWcsXatKU9ftTC3MWtI=;
 b=J8DedBA5AY8Ft3depVS5IZVcLAw5cfErAdFYGy3HraezYwyBzJadJQR/6FGqNBliZdGrvSDssBTfzWicnMrH9u8QLaO62IXM6LQnHpd8fYRTuHfRzNSivH8nCTcpUy/1RjodrkklmYE9bLendjg5fwEIhd0+VlIcyEzf/7bhbbs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN7PR10MB6956.namprd10.prod.outlook.com (2603:10b6:806:34a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:47:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:47:32 +0000
Message-ID: <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
Date:   Fri, 19 May 2023 12:47:24 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
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
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGdgNblpO4rE+IF4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0003.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN7PR10MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: a0acadc5-0463-40e8-84de-08db585ed477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +K4qqoMGULG+H0rriwZObyGA7naiBuMslWON9y12/X7S15hFS/47RggAwzmt//M0byixWUYhWp9pfpP8oE3SOLUpaIHtI6qWz9NhUhr8eVEYRPVMm6UJ7kgCOxnOyJ38AQiN2ugchXEI8IC11MShuKVvmot1CNryzo16sNQT7NT4DMZh1JLpu8arwTuS8BZSoGxh2aL5UMKF8524sak2SdPnita4XFhy5K5TXERHHiwGvgu+zlzNCM9kRjQFhPw3HHwQBZbvX1kgBACfiTqUAaAwVs9lO7EMXYQdbtOsKVLaJ7ggQWZkMkdQbPnXSbQemOWiFbsx1zfvI2PlQkJIfSFqDAozfZuIXOrd0cEPQgwNG3+Q55Q7O91LPpGeOt2YkTHnIbTG/cXfR15Ieu9B9YqrUw+VUJ0j5a3aVo3t4w+5VRg5JnQNOADfhO60cYx6HLGFrwhXpqhNNFCXN/gmVOiRbXt6lQhSzqMCyBhA0u3xsibamyUfWYXkLj/dvyFBcyfYKBcqbTDmfx9f8TUOglYz1AiD0/mLDREPCw17CW32XjN+Vr4Sy5SCPz0Jwp/DyvCSLRwIkClJv75u6ucHTs4tlg1slQoR/3gnAo9vKPoMxnAbMZcZulm+c/JQkcI+TuxU7nOfM2iL2J2UNBMUwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(38100700002)(36756003)(86362001)(31696002)(31686004)(316002)(2616005)(54906003)(66946007)(6916009)(4326008)(66476007)(66556008)(83380400001)(8936002)(8676002)(5660300002)(7416002)(26005)(6506007)(6666004)(6512007)(53546011)(6486002)(186003)(478600001)(2906002)(41300700001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0hkNkJvR2FuWCtSSE4vdDN4aC96M2FSREFmL3hwLzhTMHFXeUthdGJrdjZo?=
 =?utf-8?B?d2FNS01zanVxdndLWTdzQzRJbVh2YUdKZFduNE9nbnY4VnIrbER4UnBRS0gy?=
 =?utf-8?B?WS9Zdy9MVjJscGNlYTh5Vm1yR2hyN2RsWEIyTlR5RnVuckFDSlhHbTVRaTMw?=
 =?utf-8?B?eng5aXg3aTRtRi9zajM3Z05RYVR5TjRhQXZoWFNVaTdBRDZwYWhrTmNRQzk2?=
 =?utf-8?B?QjFFU2tJMUN2VFZPVWtyWVRXUEdYZVJ2OWVrbXdxbGNoSHFaWkg1QzdLRERu?=
 =?utf-8?B?bG9zb2xzTE1GVitRekFMUlBxQzRmTFl0YWtiVzl2UjFueCs4ZW9QMWJNMS9n?=
 =?utf-8?B?SW5NQWZSOHBmQi94cXBmQ0o0UGRTVUZQVlNKR2cwb1FtZ2dFWWR2anBabGJq?=
 =?utf-8?B?bmNsMEtVMHhPY3Juc3pIL3pvMkg2M0ozc0MzMUxSODBUZHJ4TmJMWFY1R0Rv?=
 =?utf-8?B?eHFURklyeG41V3c5SnlzU2ZWU0FEYkQyMi9KZnNQUEhvOFBnNlBYN242VmtI?=
 =?utf-8?B?OVMyNjdrMExGaDNmbVdQV3h5Q0hUZkQ5UVlZb09DM2ZZSFJiVVFmSTRCSVJw?=
 =?utf-8?B?c1dVanplR05XTENpMkFuUHY1ZVN5YnVmTXEwSWNpL3RYYlJ0RHZRMDZhOUo0?=
 =?utf-8?B?TkFhSStzMC9RZlR6RVFRemNhQk1ydFBGNUNrZGtza1hRMW4wdFZwZ0JwT25E?=
 =?utf-8?B?UHR4Lzg1WEtrWmZ6WEoxSmJIUE5wakYrZ1M2VXVGM2NJaTE5aVljd0ZaZ2R3?=
 =?utf-8?B?THdic1NxYXMya2QxakxUeUpiYWJlYktYQWRiTHhxT0JrczFjVFhTeHlMVUpu?=
 =?utf-8?B?TzFWeXJ4UzA3T0R6ODNEcDVPNW9GNHcyUi9VV2l3cFF3QXREVnBJcnZ4MXBk?=
 =?utf-8?B?TVFlV2VaeWFOS3hXRmlhb0ZxZitLb05RYTNuUVFabHl6bXo1RmN0cHpSQnBY?=
 =?utf-8?B?NEQ0SUVCV0FXNDM5Szlrb0NlVDE4QjNsUk9RVVVqRmFLNHEyaU5SYzBLdTZI?=
 =?utf-8?B?VmZSaDZLQTJCNER3UDJEa0FYVEpEaDZmYzZyWjJhcEV0WksxTUtVN0J4VGl5?=
 =?utf-8?B?NU5rUmJuQU03MmVnZllPdm5SM3NsS0t2ZTRTMGJxMVZsNGdsYldzRFAxUTls?=
 =?utf-8?B?WkRVYk9mUlljc05qaWUxdnh0aTRXZ3VkUjJGSjdaaGwxUk5CTTZWQjhQZ0xW?=
 =?utf-8?B?YWV2cXVtVHBGRG5YUWk2RHRad2x1a2lKMnRoYUw2d1lTMXh6TXpwZVF2ZFph?=
 =?utf-8?B?RzBtVU4wTk1kS0FuYUU2SHhsZ2dKSndSQldqUTlWbU5CaDM0N0FsNGdnajI0?=
 =?utf-8?B?czdpOWllTm9kS1pHcU13UklnMWdLRU1VZnk2S0UyK1FmdDhmVGpsQjlGbE9L?=
 =?utf-8?B?Rnc2RzFvVThUMXlZTTRseUIxWHA0M1BBaHBhU200d1dmcWIwcVQ1QnhyRjcv?=
 =?utf-8?B?UlMxc3ZFWGRER080ZS9vMTdnazJjYndlTzg1cFhHakwvYkluWmswV3FIQTIw?=
 =?utf-8?B?M25FcGxLVnZudjNLamtyaWhpOCt4Wkc3U0hTbUowZkRTaVhodWIxcE50dFVQ?=
 =?utf-8?B?U3NTSzVMcGZCbkJZeXJGTmRmcVV5eHJBSDBMdmZNdHVuZDBTdTZDY2RxSzBs?=
 =?utf-8?B?Umc2N1lHaDdtL29VNnp2cDllU044VkdnRTJRTDgzT0hhbUJLMnpBQnp3Ylhm?=
 =?utf-8?B?ZUt5YzRaVVZkSktGREhaWVY1ZXZZRjJKK0ZhUG9NTjB3Wk9jLzNXT0ROZnZv?=
 =?utf-8?B?TWhJVEk5S2ZUeW5xMy9tMEYrUUllRjFmTnFDQ0liZzFBeXE1dmtEV2FRU1N2?=
 =?utf-8?B?bjQ0TVBrYWM0SjBKRmxlajhJb2FmVWNKWEdGM3JGNlFabWdyVlY3akVBUFFW?=
 =?utf-8?B?eDVvZlp4UFFTb1VHa1BkRkpiV05EYVlWR3dNYVBYMjhtN0U2b1dCcHpnZjho?=
 =?utf-8?B?VlZLTm4wUS83SmMvY01uK0ozZklrSTMxSXAvSld3STdiZGk3d2J0R0xxcjVt?=
 =?utf-8?B?VGVUcXJha3FCeFRSbnhHL0dSeHJJMDhLYjhXOFFxdWJldG5LcjMyUWxXV3Ru?=
 =?utf-8?B?TWtiKzVrYXBOVFlZZ0F0eXJ2bkN0QzlCODZxRitWNUthQjhObzY4b1lsRVVl?=
 =?utf-8?B?QTJocVNTc0l2Z0NKZDh5MXV0M3F1VGViSHY2VG53TnFKZ3h4N2pvQTVPN2hN?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VUpIRzVJTXJjaGMvUnlmTklnbUVoTDEvQ0dpUG9ZdFlWSFhmTUFMcDk1K3RL?=
 =?utf-8?B?V2N1V2JLL1o1eUZwYjBuNUpkUmRZOTBXenY4WWdNZWM0Yzc5Wmt6cjJJMEtY?=
 =?utf-8?B?NVRHZHpPK09LMWprWENaVDBCV2JNZGcxU1pkQ2NhckRMNWh1SWlIOUdzRnd5?=
 =?utf-8?B?anl6M2lRSEhzSXZvdi9SbTJQVXhiTHF5Qk1rK2JjdjFwM1NYSlFWS0xqaUNW?=
 =?utf-8?B?Vm1TSG0zdUdzQTUrcDU3em0xMWN3cndFaVRyY205ZlRMY2srQW9kdUs3NXB4?=
 =?utf-8?B?Y0xlcytGWDI4cmdaUEYwK29mMWw0ZWxPUzhwUmE1YzhnbU16ejRYbzNpNEd4?=
 =?utf-8?B?bmkxUzdHR2tQMElpemhTS29iekZHeEFmNkNHL00xcXptdm0vVTkrM3Rxc3lY?=
 =?utf-8?B?UitVdkVNQWNENURTWkJ1UThjREI5cEVraDNoQ1JGUklsQzZXc3FrTTFIWG9Q?=
 =?utf-8?B?SkE4SHpPclNwaHpObXFLNERYYlhPNmh0OXZQZXY0UXNpenVhTWJyWTd1VytE?=
 =?utf-8?B?UXd2L3pTVnNLYnRtbGtnV3dYWS8zQlZLb3pJbWpic2hId3hiaFk0TndDTkl2?=
 =?utf-8?B?YUgvNDZyc3dpRkQ3bnppZk5JWkFBczdSeHIyaFFpV2hzSEpUNldtYnJHZWRm?=
 =?utf-8?B?cS9LbHRDRHM4cjh4Mkp3OFd4dC9YWi9NRnFtaWJJc09BMkNITSsxbFRWTm14?=
 =?utf-8?B?NlNqakg5S2NjWE1iREd2aTdCejFGUnZQdWtLeXFEUVRBUGxWM3lhWmxzL04v?=
 =?utf-8?B?c2FFMGZGeURsaHZKWFhuRjV4ZVpLUUxCcTFZdFRKWDhhbjZtdzFIRVlRbDBk?=
 =?utf-8?B?UGpsaS9DZkFBdmlualc2SHJqcXEyY25QQ1FGbElMWVJpRWRUbUhrNXk4b3li?=
 =?utf-8?B?ajZoN0RxTlUvZXRnQit2bGYrUXgySEM4UXlXaFVHQXpsc05TOUZWK2hXQkkz?=
 =?utf-8?B?WVExOTQ3b1poR1UzcG0rTm16azhaSmJIOG9xRDJVL1VhN2E3Z1lhdEJiNHFV?=
 =?utf-8?B?a0JxYmY4MkZPSVdBRjhzbmpRZ3VlMS91aXltRG9ZdFlkQWEvOFRVbUNHUEgx?=
 =?utf-8?B?M1VLMkVkYVdtZUdndkNxTjh3UVczRWdRZXU5VStSLzFSQXRxOWNrZ3N2RnFG?=
 =?utf-8?B?Ylg0aHFVS2UvV0RqWmNzdzRGZkZhNC9haEhjdVdZV3EyaWFFa1R5bHltMkRi?=
 =?utf-8?B?TDgwclhlYXRsUEdZTVFINGFzdlR4S2FYTVBkSEdUQTNKUU5RVWNZWnlHSVdL?=
 =?utf-8?B?QVJlTWU3ZjI5TGpBNTNLRzRYYlg0VWFjTXA0S0JiVVNsUnE4STBsVWJCbEt3?=
 =?utf-8?B?c3BBaDJQM3FzR1RKSm1ySFFlLzk5WG9rS1NSWmtldGVXeE9ubVJOeUNSRkxj?=
 =?utf-8?B?M1hVY2dwNWJZdU5FWkdUZXRicEJ2U2J2VndKMVhKY0RTdS94WnVtZEpJSHJW?=
 =?utf-8?B?aitrRXNpbFBSU2xZbHNYOWg2Kzc3dXZyNnpJdHBRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0acadc5-0463-40e8-84de-08db585ed477
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:47:32.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYEbanejQtJZeg/psoFG0f+9BjizHd178ndQD/7wQRWWuRfrZrrItxNsb++GjVJPeIThv6XoDlrhd1Dr6W8fQ7p7SBNh1oexXes+cngcjnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_08,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190100
X-Proofpoint-GUID: h4ql4xgBX4somu-Fo7b-T1XLjaPWc9qw
X-Proofpoint-ORIG-GUID: h4ql4xgBX4somu-Fo7b-T1XLjaPWc9qw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 12:40, Jason Gunthorpe wrote:
> On Thu, May 18, 2023 at 09:46:30PM +0100, Joao Martins wrote:
>> Add to iommu domain operations a set of callbacks to perform dirty
>> tracking, particulary to start and stop tracking and finally to read and
>> clear the dirty data.
>>
>> Drivers are generally expected to dynamically change its translation
>> structures to toggle the tracking and flush some form of control state
>> structure that stands in the IOVA translation path. Though it's not
>> mandatory, as drivers will be enable dirty tracking at boot, and just flush
>> the IO pagetables when setting dirty tracking.  For each of the newly added
>> IOMMU core APIs:
>>
>> .supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
>> that enforce certain restrictions in the iommu_domain object. For dirty
>> tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
>> helper iommu_domain_set_flags(...) devices attached via attach_dev will
>> fail on devices that do *not* have dirty tracking supported. IOMMU drivers
>> that support dirty tracking should advertise this flag, while enforcing
>> that dirty tracking is supported by the device in its .attach_dev iommu op.
>>
>> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
>> capabilities of the device.
>>
>> .set_dirty_tracking(): an iommu driver is expected to change its
>> translation structures and enable dirty tracking for the devices in the
>> iommu_domain. For drivers making dirty tracking always-enabled, it should
>> just return 0.
>>
>> .read_and_clear_dirty(): an iommu driver is expected to walk the iova range
>> passed in and use iommu_dirty_bitmap_record() to record dirty info per
>> IOVA. When detecting a given IOVA is dirty it should also clear its dirty
>> state from the PTE, *unless* the flag IOMMU_DIRTY_NO_CLEAR is passed in --
>> flushing is steered from the caller of the domain_op via iotlb_gather. The
>> iommu core APIs use the same data structure in use for dirty tracking for
>> VFIO device dirty (struct iova_bitmap) abstracted by
>> iommu_dirty_bitmap_record() helper function.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/iommu.c      | 11 +++++++
>>  include/linux/io-pgtable.h |  4 +++
>>  include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 2088caae5074..95acc543e8fb 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus)
>>  }
>>  EXPORT_SYMBOL_GPL(iommu_domain_alloc);
>>  
>> +int iommu_domain_set_flags(struct iommu_domain *domain,
>> +			   const struct bus_type *bus, unsigned long val)
>> +{
> 
> Definately no bus argument.
> 
> The supported_flags should be in the domain op not the bus op.
> 
> But I think this is sort of the wrong direction, the dirty tracking
> mode should be requested when the domain is created, not changed after
> the fact.

In practice it is done as soon after the domain is created but I understand what
you mean that both should be together; I have this implemented like that as my
first take as a domain_alloc passed flags, but I was a little undecided because
we are adding another domain_alloc() op for the user-managed pagetable and after
having another one we would end up with 3 ways of creating iommu domain -- but
maybe that's not an issue
