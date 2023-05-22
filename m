Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FEA70BA4A
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 12:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjEVKoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 06:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjEVKn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 06:43:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCFDDC
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 03:43:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34M8EIpC021376;
        Mon, 22 May 2023 10:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DLh9gJjt0xhxo/LIJE3AHtPKwkS4jMY1Grw9tvtzjLk=;
 b=OEOLPG2cFfl0L2K7R0xwGhI+dz4yfc7nziSXacp98LFALBRMwh0hv6prVGqRFxteW0j3
 LdgisUzYpTwTF02NL3B3GyjoIAlmQdwnKGSs7iQNIy3t/ktjhP6KSYpt+xjKfqkOHyHI
 qO+Wp2RXeKYi5jQ//ad0eg+jjiNo2szHZOMxuBTGfl9VFotqc+xVzjBN/xaql14Xp/Qa
 ehDjFgn9vBwyMp8ZubsBMZpK4iutHOzxv+wSSiKF0+MOljDVWLsdn3TN4uB/t7OVS+qk
 uY7xcTAAtIzNYD2Ezu76hqqlj1IBC67xxo1I6LynoJXI1UHJ12ZgjcI75f26wPg/tLs6 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtjcbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 10:43:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MA3hWM023583;
        Mon, 22 May 2023 10:43:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk8ssc8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 10:43:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr7FHNrpqBbg16E7lfG/AgMJbST3zVTJSmtdLa/gDXIwbHO7j1zrrEMhpTDCR4IkA9j10tkj8NDEQ9i5GQhIFAu6e3BMyQXKy7Jp+la6ccmBUc2G77qJEGVpCyrDw+XJjtyJT/KJQqpwHmDQAcpfzqPxIyxWwJ0zlfSA7Z/NL9YBmbGuABUY3dYIjOR+mmiAs4snYQCmo8d8YxpMHbGJx5R4Nxra/4euGy2EUXPV/xkkoycZtq+Vvr3IlkrImzHsFLNwh1Cz7qsjFL1BEPZjtKs9mReSiHs1q795rYrD6CmClI2HCawZJUvjbFwWJBDYU+FnfL60PFYc1bEADIgQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLh9gJjt0xhxo/LIJE3AHtPKwkS4jMY1Grw9tvtzjLk=;
 b=I5VCf3Ez+mp/Eo/KZLv9vm/HjjwrT7MGBKVh6ChX4ZGOH9C1DJd0ov92R1F7ezdcUyqRoMCtk/HyzEas/ihi200++YQlr+W9VGS+dZTkdk2jrBdr2gsdZ2tRRWK2bHbq5kwzdw5pYbpqVtVfEt4QCk3kdIulN2hIQjlJgB7VehWUjse4Nh2oIATa1ApxtrUmSYp6d+r3U1eqV6uegmzuH0p71J7mb3KxJ8/aAG4Rno//4QG0yG1SMpvvZkTZs5BnoFeSfpcboBaaPCFisppRRZCSDRMqsNjat23cuYifDs7GRif4Y8R+HzndPvSl4N5UlfWNksx5v8iXtKD+9067/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLh9gJjt0xhxo/LIJE3AHtPKwkS4jMY1Grw9tvtzjLk=;
 b=bGDfyNySIYaRuZ0y/k6nu/oROk5l9GGLKP5B4blEtGuRaf4xx3f3yu5prCaC1IxGVxfao3uBJUc6S6S0/oYhJ4ApW7jhxbZDPDmjKmBgvl3srJsxHV+q0KZhDX50irgd7mG67ceiATFG1DrHMbYGR9KrMN7oJKx1BQZzRtjP9As=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5100.namprd10.prod.outlook.com (2603:10b6:610:df::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 10:43:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 10:43:17 +0000
Message-ID: <e22772db-e432-c42f-181c-e7055aeed553@oracle.com>
Date:   Mon, 22 May 2023 11:43:09 +0100
Subject: Re: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for stage1
 with io-pgtable mapping
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-22-joao.m.martins@oracle.com>
 <e16e35b399044e4f825a453e1b325e40@huawei.com>
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <e16e35b399044e4f825a453e1b325e40@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0016.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB5100:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a8d439-16bb-4796-70a4-08db5ab15a5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdWAQN3rfuO+tJnuUYvvOP7Az7ut6SJQUAk/r3mirkOnB2o+VU6fUy+p9ucIXgoZmf+VCMRFUbES/cQUC3FWFRGDAztWRonp+bFGAqRCk8DxPOotZ0S59SRkuNU868VWqPDIDJIWOybkGlFCr3bvaqS2PzzNAfchWxWU/j991X0kch0TvF23o4WSTf/Nsl+gvmspOaxYtAsga01d33mqhLeRpP6f8D7aK6OeujcnMrFKy81NlQsVivZhnbVZecLdzIZXcah873qyJnq88tMX7AI0PKwfthdq64rhGYtgnmuwLQBFITntJrhis1FhlKzImXB2L/fCoDyhb+cj4I1E2mmaJF996oNcAnhjo5+o/pfcJmkOdr/BjgL2w4LdN0idIjwLNBkD1ixUCG/rqLhx4t6jfejPXPvhpMrTSL9sQXxs2y7065kFbROgXc+vVgaEEzaj+8BeNpIYa7X0X/PFIJxQq4aLDU6cSf1bn9jNTY/5rvVV0jnWVDB4Sb7uv7hzsvnXZ6hTGZYDtuZhkIgFY2ckrBPajSjGFQThRUNj4zv+ub8ltJX1GdnbIBeg3wv9sb62Z1cDtbz3ryJIwhFCSGrVIgLGTRWDbMB7gRw6jA4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199021)(38100700002)(31696002)(86362001)(36756003)(53546011)(6506007)(6512007)(8676002)(8936002)(7416002)(2616005)(2906002)(186003)(31686004)(54906003)(478600001)(316002)(4326008)(110136005)(26005)(5660300002)(41300700001)(6486002)(6666004)(966005)(66476007)(66556008)(66946007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3NNWVFXaC9IWmdHVWpzN1RVRHFsZk9paTJ5dXZ0MGQ1aytJOHRsbUgybDRw?=
 =?utf-8?B?eGxyYWs3OU9UZkUyS2hWWUphMkRqQjRMVjhNUkpxTzlQTHA1d2wxR1l5cjVR?=
 =?utf-8?B?RUNmelRoSERoTmlxSUkzblRzWk13YzgrK251OHVTLy8rM0V6cEMyVFJtVHpv?=
 =?utf-8?B?NlhWbVdDbXBBSElCRGNNbmNIVUhIZTV6WWRhS2JMMEY3WmVpcTZRekRnbFN3?=
 =?utf-8?B?cVFDOVFtSzg4N0tLU1doazl2NDMvZG5kVm1QS1FZRjVWaWFkR3NhY1lZV1hQ?=
 =?utf-8?B?UFVsQnBETTAyaDFic3JCZHc0UTk0ZjBKK3V1U0dqa1F3QWxXM0JNQXRBSXV5?=
 =?utf-8?B?TGw4ajc3R0VyQUpaU2NoOGh2VVBWcm4wWXpUNDM1QklFWkgzRUxLakUzcTYz?=
 =?utf-8?B?dXlrbEZySWswa1lVSFRkUU14UFRpajBUZXNDRHZXQTRPNXovY1RxZzFFcHJQ?=
 =?utf-8?B?SG9yV3llNGZ4T3VDaVdxN2RjK0VtRWM5VGhNaVZKUGNKRUFiYk9xa290U0pp?=
 =?utf-8?B?NEZKUis0b3VtcEZKM2h1UkxlSUFrWTJiaGFsV2xBOTFHTjcwTi90SHVmZllU?=
 =?utf-8?B?aWJRTnc4a2hQQ2ViaFBaMGFYb095TEJsNFFUN3FpVG9sUVk4ZHh5a3VRQUpF?=
 =?utf-8?B?QnpEaG40dW5aTXdkMzVrSlN4NGN6b3NpNGdIazZRY1B3V3YxUlh5eWZVZ2F5?=
 =?utf-8?B?TU0yMWNwRTBSbWlBVTJUL1BOZFZ6OU5UN0txOGh3S3phUEVzSHJWYWk1ZGtz?=
 =?utf-8?B?RUNnYzhJOWgzRDc0MlhUQ2lDKzU0WlBPTnZ3R2lTQzFvcjJaWEJzN3hMcVlS?=
 =?utf-8?B?TzdTaVJyR0pmMXliTlNxQXY2OFJJYU40dDRSWVVSeFJodjdPT0taZGM1Z3E1?=
 =?utf-8?B?QjkyTE5SRk8vTm42eXkyRFQ1UTdWTnZ5NHppK1crcDNOeUoyb0pKK1hWZ0VH?=
 =?utf-8?B?RnpVM2hIcENWaTljRUFPUDFVVGp4SUFlZjJiSVpYWlEzUU5FT2o2V1lET2Ex?=
 =?utf-8?B?YVhUQ3dWN1F6NE5FZk1wV29IK0Z5RTN3bTExMWEza2ZqUXpySEJMTWRRLzg3?=
 =?utf-8?B?WjRWLzlpOXVLMi9GUlR2OGFZaTdkU0dSTGhIa2g1R0xVRlpta3FhR3FjUldD?=
 =?utf-8?B?Z0orMnFvc3pRSlEyVXZ0cHplL2dHUzVtWTQ4WVpWUk9DdFMwWTJrbG9YYjcz?=
 =?utf-8?B?eTdwNHNQeTFpb3c4S0lKSTVxaGFQZTdqRmVxWmN5cEFrazlZODdFRkVHaW9D?=
 =?utf-8?B?QjJUUGF2emYrelNleFpDQStoWEFSSDY0SDBrQ05aMXY0M1BRbnpOT2laQmk4?=
 =?utf-8?B?eHd3U2FwMjMvK1F0dDdZWXhOMWRhZWlBcGVuak4rQUMveHNUd1Erb1JIMDRt?=
 =?utf-8?B?MWwyTzIyUG1IRE1jY1BHNGtLM3c4bmpMOVI5aFhWQlVROEtaMUgyL29uZjRI?=
 =?utf-8?B?YnMvKys3Vmw0a1AwdlpUdng1QjBJaEVBeUtRRHRSWVRCL3pZaldRSzUxY1o5?=
 =?utf-8?B?azhUU2lKVmw4czlvN3BqTkFMVWI3RlpYZFVrVVF4T2xkR3lRNUtLclJRK1Vp?=
 =?utf-8?B?WjR0Tk04a052aEZxRlRGUWdhbW9JSC9CV2F5Z3dKclZXTWtyc2ROU0pDT1dN?=
 =?utf-8?B?TkE2MUc2bWtycStZL2YvYmNvQjhCWUt1ajNIOEhQS3ErbFoyelc0UkpHay9N?=
 =?utf-8?B?MjBpTkhjbmhuQUtEOXlnR0VRK2Jvdm1EYTM5bUVKdng2R1l0Nk9zcnJVcTFk?=
 =?utf-8?B?RUNCbk1XQS9jbUpkaGtWaHhzZzRLUWgzNTlUcGM4LzQ3MzBBOTFYbVRvQUdn?=
 =?utf-8?B?SkRKWWRpWVQwUVJtRzRVZDByMGkvdlZNL3hxUEc4N0dhWDFzWitMTzZoN0VQ?=
 =?utf-8?B?a2lDRjdTS2JzU1dVeXZCMWJGRm1YQStRYjVrR1pkemFvYkIrdjVoZlBuQ1Fm?=
 =?utf-8?B?QThqODExQ1YwMm1GZ2tvNUlGZVd2WDU1T3FIeFRKS3BGWkZUMG15V1g3WkMr?=
 =?utf-8?B?cFFkeEZURUxwQ0VSN0xHUWhBZDdLcGl2cEV0Vm9qbFpkVGVnLzZBUnJoWUFG?=
 =?utf-8?B?WmFnWEdGdDArRlJpdkJvMGpJN1AreEFMTE55MFF1ZmR0WnVaSlhsaDFIb2NX?=
 =?utf-8?B?Z0NBZHRITlU2ZlhwQlpGZS9sTjZBSHU4SEllRjljQSt2NThBTXZPUUxFaWxQ?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WHFPaTcrbnEwYUFaQ05lOWtKZFE4MHdvdEVabmNBbkN4ZnFTQkQzZnh6bnBV?=
 =?utf-8?B?R1N4K09vQnJNWHBncEs5ajBtaWNheWk0aGw0ZnEzYlFEbWQ0a0ZZeDF3S0tE?=
 =?utf-8?B?YWVuTW9kaFhlajNjSHQ0WldtT1k5cjJxSW1hN21VdlFBMlMyMy8rK29pTm9w?=
 =?utf-8?B?Y2RuWjMwZGVybkQvRUJTOHNqdWo3dUZkVG1sYWt4dXhDMUhnbi9zWTRsOS81?=
 =?utf-8?B?WTNHd3BzNGxKRFk2dktKdjdhYW1WK2lKY1R1UXRIK2RtemVXbENhNWVsVGc0?=
 =?utf-8?B?aGZiNW5MKzNHNzRQeGg3RVR4TS9ienNTK0loZ0RZQTVYeHJtcUU5alE3QjVY?=
 =?utf-8?B?N0N5MEMrd1FvMlRwVm9SOVI5WnphQ28wbXpsLzVmM3ViUkYrelA4bTl2WHVa?=
 =?utf-8?B?TXc0WSszOEpKSWczSWdwcldqbzJ0R1pRSzZzNUZqY1dyYXNhV2RQMzRjanNT?=
 =?utf-8?B?RFg5SG1LWFBHZGl2cmJpSWtJTlYvMElnellad0hGemluZDdPR0xoTzFGNEJx?=
 =?utf-8?B?Tmd4eTU0ZjJlSW5lTXBKamtqZkc3T3BRblhQY2ovQUZSZjg2NkVTSXR5ZDhr?=
 =?utf-8?B?cXErUmUzc3ZNNU1RSzF6RzJ3UDErLzkrUjlCL29hT0lDeG1YZEQwNzlwR0hw?=
 =?utf-8?B?aDJRT2d0NHV5UjBlNjlLV3hJT1p3cTFzVXlpWnI4bzArSHMxaVI2WENGTTI1?=
 =?utf-8?B?Qm9DRWpNSVF2MnplUGxnT3VtN3hIMmlxYWd4QzlBTTBqU29lMnFLRzZDMkJ2?=
 =?utf-8?B?dVdycjFZRzB1VU9ldEFRb1IwWDhpN2M4eFZvWGtqZ2hxVm1MaGNYVWlQK2Iy?=
 =?utf-8?B?SUJaTHdycGE1MzZxRHBoN3kzT2RYZ054WHB6ZzBLZ3d5a0VMYU5vblUxU2VG?=
 =?utf-8?B?TWliL1c1UWpMNURVVG9WSUtDTndNQTdRaXNlaTFWVXFzZmxLcFNUcGdPNkc1?=
 =?utf-8?B?ajFtZ1VoVFNDUVJ2UUNOTjd0dVQwSTR2V29qWFhMQ2MxY3FwVzB4OTBUdE9k?=
 =?utf-8?B?bCtJREs1TlNHdXlOcDFMWHQ0c1dhcTRYYU9BaXIyd3llN1pFTDRVaHZ4a250?=
 =?utf-8?B?YTdKa1JFeUxPendsdDczbktUNy8ydm1CR1d1L2N0dDBkcE9yeVlONXhzZWIx?=
 =?utf-8?B?T01NbDZ2eWQ5V2V1VkZKU0c0RUNIb3BTNmN3WnNkTUpyT0xKQzJreEpzM3Na?=
 =?utf-8?B?TVZROUh0T3JHZHpsS0JFdTk5NjhFbmJ2a0ZiUFQ1aUpCbmQ4VzIzS1RFQWM5?=
 =?utf-8?B?Y3JsVW1vV0tnUzhJSVhtWGRCVDR3Sy9wMm4xbk81OWo1Vm5zQ09MK3dRZC8v?=
 =?utf-8?B?R2lNK1IrdnpLdXhFQStWOVk4WC8vNmtWeTA4VTZPaVVZVzMvUXJzZ1VXVzQ1?=
 =?utf-8?B?aUpydXlCYk5GUEVCeHhrQUlRcE1JaFozSUp1UUhEOTlIUHBwdWM4d2xUdm0z?=
 =?utf-8?B?VFhtaG9xTHdmTjRSYVA2bzcwaUk2dUlLdTNkc3ZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a8d439-16bb-4796-70a4-08db5ab15a5b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 10:43:17.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Z19Hs3eTs/EVT3ie9alpKXd8NKPGURxZr3z24fmf+3WTDP2wUk8S33J5XXPsmzbStL9PI3MUBIJ8d1/EvaaCg5uGBERuuE6gXUgql1FH6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-22_06,2023-05-22_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220091
X-Proofpoint-GUID: JTqcKHEJUCMk5nmhKlIumvqXMo-RRJHI
X-Proofpoint-ORIG-GUID: JTqcKHEJUCMk5nmhKlIumvqXMo-RRJHI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/05/2023 11:34, Shameerali Kolothum Thodi wrote:
>> -----Original Message-----
>> From: Joao Martins [mailto:joao.m.martins@oracle.com]
>> Sent: 18 May 2023 21:47
>> To: iommu@lists.linux.dev
>> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Lu
>> Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
>> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
>> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
>> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
>> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
>> Murphy <robin.murphy@arm.com>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Joao Martins
>> <joao.m.martins@oracle.com>
>> Subject: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for
>> stage1 with io-pgtable mapping
>>
>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>
>> As nested mode is not upstreamed now, we just aim to support dirty
>> log tracking for stage1 with io-pgtable mapping (means not support
>> SVA mapping). If HTTU is supported, we enable HA/HD bits in the SMMU
>> CD and transfer ARM_HD quirk to io-pgtable.
>>
>> We additionally filter out HD|HA if not supportted. The CD.HD bit
>> is not particularly useful unless we toggle the DBM bit in the PTE
>> entries.
>>
>> Link:
>> https://lore.kernel.org/lkml/20210413085457.25400-6-zhukeqian1@huawei
>> .com/
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> [joaomart:Convey HD|HA bits over to the context descriptor
>>  and update commit message; original in Link, where this is based on]
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++++
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>>  drivers/iommu/io-pgtable-arm.c              | 11 +++++++++--
>>  include/linux/io-pgtable.h                  |  4 ++++
>>  4 files changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index e110ff4710bf..e2b98a6a6b74 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1998,6 +1998,11 @@ static const struct iommu_flush_ops
>> arm_smmu_flush_ops = {
>>  	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
>>  };
>>
>> +static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
>> +{
>> +	return smmu->features & (ARM_SMMU_FEAT_HD |
>> ARM_SMMU_FEAT_COHERENCY);
>> +}
>> +
> 
> This will claim DBM capability for systems with just ARM_SMMU_FEAT_COHERENCY.

Gah, yes. It should be:

	(smmu->features & (ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY)) ==
		(ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY)

or making these two a macro on its own.

> 
>>  /* IOMMU API */
>>  static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
>>  {
>> @@ -2124,6 +2129,8 @@ static int arm_smmu_domain_finalise_s1(struct
>> arm_smmu_domain *smmu_domain,
>>  			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
>>  			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
>>  			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
>> +	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_HD)
>> +		cfg->cd.tcr |= CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD;
>>  	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
>>
>>  	/*
>> @@ -2226,6 +2233,9 @@ static int arm_smmu_domain_finalise(struct
>> iommu_domain *domain,
>>  		.iommu_dev	= smmu->dev,
>>  	};
>>
>> +	if (smmu->features & arm_smmu_dbm_capable(smmu))
>> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
>> +
>>  	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
>>  	if (!pgtbl_ops)
>>  		return -ENOMEM;
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> index d82dd125446c..83d6f3a2554f 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> @@ -288,6 +288,9 @@
>>  #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>>  #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
>>
>> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
>> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
>> +
>>  #define CTXDESC_CD_0_AA64		(1UL << 41)
>>  #define CTXDESC_CD_0_S			(1UL << 44)
>>  #define CTXDESC_CD_0_R			(1UL << 45)
>> diff --git a/drivers/iommu/io-pgtable-arm.c
>> b/drivers/iommu/io-pgtable-arm.c
>> index 72dcdd468cf3..b2f470529459 100644
>> --- a/drivers/iommu/io-pgtable-arm.c
>> +++ b/drivers/iommu/io-pgtable-arm.c
>> @@ -75,6 +75,7 @@
>>
>>  #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
>>  #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
>> +#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
>>  #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
>>  #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
>>  #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
>> @@ -84,7 +85,7 @@
>>
>>  #define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
>>  /* Ignore the contiguous bit for block splitting */
>> -#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)6) << 52)
>> +#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)13) << 51)
>>  #define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK
>> |	\
>>  					 ARM_LPAE_PTE_ATTR_HI_MASK)
>>  /* Software bit for solving coherency races */
>> @@ -93,6 +94,9 @@
>>  /* Stage-1 PTE */
>>  #define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
>>  #define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)2) << 6)
>> +#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
>> +#define ARM_LPAE_PTE_AP_WRITABLE	(ARM_LPAE_PTE_AP_RDONLY | \
>> +					 ARM_LPAE_PTE_DBM)
>>  #define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
>>  #define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
>>
>> @@ -407,6 +411,8 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct
>> arm_lpae_io_pgtable *data,
>>  		pte = ARM_LPAE_PTE_nG;
>>  		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
>>  			pte |= ARM_LPAE_PTE_AP_RDONLY;
>> +		else if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_HD)
>> +			pte |= ARM_LPAE_PTE_AP_WRITABLE;
>>  		if (!(prot & IOMMU_PRIV))
>>  			pte |= ARM_LPAE_PTE_AP_UNPRIV;
>>  	} else {
>> @@ -804,7 +810,8 @@ arm_64_lpae_alloc_pgtable_s1(struct
>> io_pgtable_cfg *cfg, void *cookie)
>>
>>  	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
>>  			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
>> -			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
>> +			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
>> +			    IO_PGTABLE_QUIRK_ARM_HD))
>>  		return NULL;
>>
>>  	data = arm_lpae_alloc_pgtable(cfg);
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 25142a0e2fc2..9a996ba7856d 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -85,6 +85,8 @@ struct io_pgtable_cfg {
>>  	 *
>>  	 * IO_PGTABLE_QUIRK_ARM_OUTER_WBWA: Override the
>> outer-cacheability
>>  	 *	attributes set in the TCR for a non-coherent page-table walker.
>> +	 *
>> +	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking.
>>  	 */
>>  	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
>>  	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
>> @@ -92,6 +94,8 @@ struct io_pgtable_cfg {
>>  	#define IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT	BIT(4)
>>  	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
>>  	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
>> +	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
>> +
>>  	unsigned long			quirks;
>>  	unsigned long			pgsize_bitmap;
>>  	unsigned int			ias;
>> --
>> 2.17.2
> 
