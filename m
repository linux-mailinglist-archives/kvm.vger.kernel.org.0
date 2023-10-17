Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23CC7CC74B
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344035AbjJQPVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343732AbjJQPU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:20:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A187B6
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:20:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HF4eGf011265;
        Tue, 17 Oct 2023 15:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KObAgHHVD07EzJq1H6qINBv1Jjx2sWNH8C6Wba+oFWw=;
 b=DTfyWLYF9VsK7fSGkj6nmhtekN3XJ3M20psV+7ShzJs0EHDC3ArPoKOiijFPxYTg9OH/
 +kNMYOgUhi+a9iAhjLlBwwNmR4wENO/sBIYoayY0clo7aS/UGsaqvTuTFPZPqG5WleC+
 2/Hz3twyp8IozP6jCo4P1PHu5G56LDYe+lEEZHvtlRqMFgPfnCN6ABwQImGMrAGa6fiq
 IjVdvz+3oVW+/CmSdb4yaLbjmnAUl+vJQ7Nauu5IRowODBjle4nS0a9XGr51pZID2Vad
 yce6p2OFekVFuUqE7Ct6bUY3JurjsheUyhjKuaYovJRyaMgyEbCCkQ9/NTkKDkWTu3OK Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1den2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:20:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HE57kI027111;
        Tue, 17 Oct 2023 15:20:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg540h2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKX1rhHTlg5wBIVjSgzbb/ed1e8onGiq+Hnugpd9ZmwyZr3loPA0PR4LQSwy/FXgHkkIWybqMGQPh+NBz8lS6mcG85K+u3+emgBKpTnacFwp4sWJpj/drSQycsu4Jsww1lShU+VU5xzOvgetYMmOXnFuTjPiMD6tU1zy010NwoDcszeU3uXeMd5AK5bugFGcxPsdv2DnpVdY9c8C1k7rzDEGgFICbhIZmM8RotM+R6+LiirQJ1LLrs6Cio+06pak4sq2wdO8UO0x0X78Tj65ZPcRhd61/GBwRMWa7CTGZGzbtnezs7ROptq8aXZ0uRCXoDfl16Uafh6VwlU2JynHcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KObAgHHVD07EzJq1H6qINBv1Jjx2sWNH8C6Wba+oFWw=;
 b=fPUxfb2oi2Q4fkglc9xy+dwMt6hO8nLBQKIkUaaGx1erV93IE10MXQUB5vOfP+Ivd64pihdUSvoezn8anbMWcsK7s1aAogzjLEV77/6QOMvPtd9ZvotjDIu/0ekmj0A31cn3CQ7JFUxNuH46qbyBINCq3ijdjMQMZ1luPABJArBiDS2n8JBmeELWfgDfGVZEenJcEzfHXGI4boz7g0DV0cc2/0WkCYANeW7pLsnDcrZgUMX1ROqjuFAOpx6VkCQw2xkMcJjQX/NnDO/EaRzPvmlSpTHnHK3qunO7P2eeZ5ye2xdxTnHNHdXAf9VQkzUI7iLHTOzuIWtn7WektmobSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KObAgHHVD07EzJq1H6qINBv1Jjx2sWNH8C6Wba+oFWw=;
 b=x2KJnHP1lR36G0C5dKN9cr+rXbKqnUzcw7UQWAWGEi3GbMkNzBHhrnmr00RGp/HiExHgD4w00rfoaL/wC7hdwY/UUYryP901i8wchIBQFczd6jBjSzCg/zPejGSHF9YBnb3kXFKvEKAbnN3inOc/o7KwwU8KiJNn4GQcEZHqiqM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by LV8PR10MB7846.namprd10.prod.outlook.com (2603:10b6:408:1f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 15:20:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 15:20:29 +0000
Message-ID: <ee2fcf1d-3ab6-426d-a824-7547a98dd1a7@oracle.com>
Date:   Tue, 17 Oct 2023 16:20:22 +0100
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
References: <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
 <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
 <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
 <20231017125841.GY3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017125841.GY3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0377.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|LV8PR10MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f4c185-2e28-4cc6-1899-08dbcf24988d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eW6Fy/xgK97eA8Hc6zKlBY8g2ZtfHnJAWy7/I+qZx79rlu9xam//mfP1A9KXEEtLIHUNFIKeYxGEzspkoZpH+Ad8ajofthfxOik0+tYagMORNSnI/43JYAde/YckplszfDeHgKTNn4eUbCbAUhcBrvQf+PlAav5Xx5AMvaCPRtm/5LylaV8uvFMMCXodWLiNihyZiMjm/beK3RBBlnEtwgF2El/DJBoaEgoyyiQvim/i3wq5/bYuoP34hACrmOZnHcx8TwOR+tCUfV0JOJ6n75X5q0qhPIxlG7dSYTBcgUh299A5Kjp4kIboDmJhVJF2m9FrAR5Kr/KuPreReSsbWS7RGC1gY+wI3eTsIXHkivjg6imqo7kDZjcheM3HOegvLBBF/LuU68/ta5Kzh2lBrFFqILsS989bCE4ir0ae/s47lIRcwz4Kjv7UwIZjkoVnkJ61jTqmDAPiv9RKg9rVpjz4PTZMfbPIthjtAXn50kbMHqEmrCSf2Fh2338opL2Uq58X3CsYRKer99QTItZkGhsvR0GUFNrBexzietgaxbXQaoXDrl832hVTEspMHPoLfasA2tl/Mvp/aXJJCOyhYKnheIDvYiaroEyIs9CnhPLwHAewbvoNPPMXmpGIvhtkeOi6CTHgBo5wmWcBS4m7og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(26005)(2616005)(6506007)(6666004)(8936002)(53546011)(83380400001)(41300700001)(7416002)(4326008)(5660300002)(8676002)(2906002)(6486002)(478600001)(66556008)(66946007)(316002)(6916009)(54906003)(66476007)(31696002)(38100700002)(86362001)(36756003)(31686004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVFzM3JMZWwyMnNmYTA4SFgxcWN4bjhzTmNGZFpBK2xBM0NBeWJWbFFJWGRZ?=
 =?utf-8?B?OUNzaGg0QWYxTEtkNlJGU0taSjZpVUR5akorTkJ0WHIycFRVUzdZOVk0bWdG?=
 =?utf-8?B?Rllvb2R4SXc0MUtKVURHQkQvb0ZtTEtwUXNGbEJtbGdaMVpCYmFNK3VZUHFE?=
 =?utf-8?B?aVd4clBsTW5HNW9NN2FYOUNubzlwOVhBald4RDh5OXNSV2tKaDJZWnNCUkU4?=
 =?utf-8?B?bVgwNjg2Syttb2tIYlFRS0VXaTRCNFA0bXRaMjY2L2lPODY3VDdMRTJ2dEs3?=
 =?utf-8?B?eHQxeFNYYzNqdjIycU1jKzgwYVY2WGhOSDRzN01NdnJYOThiNHFFQUhMY2Uz?=
 =?utf-8?B?Z0o3d1U1WnFqcVB1azZwZlhvV1NqWi9pTng3dmVPWk9wQVpnVlF5aVJzWXhr?=
 =?utf-8?B?M1E1YTUvWWhCZ1VlTGpSR1JTWHdjTmZXc1owZ2pCMzJnS1B1cFJ5elZVRW5F?=
 =?utf-8?B?RXNNeXpaWGE5b3FrU0YrSzM2WjVwbnZHNjFVYmF4NUl6KzZsRmt0Yk0wL1ZT?=
 =?utf-8?B?SWx3V0l1SFJVdGU4NFNvRXQyQkRNRktPRzdGc3ZJTjg5YWwrZ3lIdjIrT3ha?=
 =?utf-8?B?eUhqRXFYbDhOQVFwNFpSSmpPeWFTQVR0eUk0MnRJS1hHMHlBT21RTDY4V1dm?=
 =?utf-8?B?OXU5YWxOZHNwZUl6SjNrNUU1aWhsSVRsQk82SXFjT1o3K2EwNXFDOEJQV3BI?=
 =?utf-8?B?K3JZNUJvZ0tLdnJ2Z2JMZ211Uk5xT1NnWVF5MEhJQ1J0cnVJWHVQdDFwRXFz?=
 =?utf-8?B?Umx1ZkRmdjNPRzZ1QVgwTmhGa3R0V3lWTW9GT0owOE9qdFRDYk0yTEQwUlFG?=
 =?utf-8?B?TVh3a1hLajdaNTZZdEdBQXhlSHJlUGJZZk9mYm1ZaXVNQlVxaXpiZk1RVWtG?=
 =?utf-8?B?Q1Rya0JjQmlzT25heGRXWDdNM0pMNmZWWmJwN3kwRXNXNjRtMVFGN2IyMnNu?=
 =?utf-8?B?dUFzdFl4TjA2WHdmNmFtdnJKbGFUOUw0K1dSL1pndXduMHE1SXBsV0FJa3Rj?=
 =?utf-8?B?LytKOXlZdzhiMkQrVkNtYmxaVlN6Rm9KMnZzdDF5L3BOeTZxR2RWSzBsVjAx?=
 =?utf-8?B?NHdOcEFqQ0R5YkhpTzgydEhOSWN4K016QlJYVFFzZWkrMkQxd0Vud2toVkJD?=
 =?utf-8?B?dXVzc2NTRmszOWhIeDMyMDZDTnM0TktSSC9iUkN4NktRZG9kM1J5QUlkUDFK?=
 =?utf-8?B?M0NlOTZmUzU2UDhDdGlYM29nUUVWZm01Q3Byd1B1cUh0OHNYTU5XcVVJcjE5?=
 =?utf-8?B?OTQ0czlnMXNZYU9DWE5RSlAzdjZSQzgzbEh3QjA3ZmV0RGxMajhJZzEyTkVW?=
 =?utf-8?B?MVgrZUJLMGZ5UEZ0bnJLM2hHeFFJdDJrcnhwbHRuYWE2U2NHWXYzL3VlNkh4?=
 =?utf-8?B?RnpoMXFGU2xNMndKaGhyWlgwalZjYWxxMmU5K1kyYUZiTTFqMXdicStSV1hz?=
 =?utf-8?B?U3p0NElRL3YvU2lHWFE4WFdZWFpxWnhJVXJyeXBRSnRqeCtUaVVnb0FhdWZs?=
 =?utf-8?B?ZWErQi8rMlFXUmJoQTZXcjVWZWM4WERtM1RVb0hqSHY5eVVQdXBZVEg0L2R0?=
 =?utf-8?B?YXlhOGtDNWNiM1FNV09jNFJFaEhpMjYwemI5VVBwZCs1czhrdStVMDhaeW8r?=
 =?utf-8?B?Q05RbzVsK0srM2gzQXh3QTk4eDdvOUU1eDlUSFJseUc1Vzc3M2svQTNEa21n?=
 =?utf-8?B?TUtsWldsSUtuUWNvYlFpcjAxZkozTkJ0ejRqS0dZNjVWMnpYcnZ6eTh6VXph?=
 =?utf-8?B?TWYyTVJ3aThpWjN6U2Jwc3lUT2ZxRTN4QmJFWkYvQktPdlhwM0ZJQXJsbzlv?=
 =?utf-8?B?a0N4V01MRlJmdjhJWnorRTNnZmhzd2RiTmk1UnhDMXhDWFRJalUvSVh0a3dW?=
 =?utf-8?B?dnFPc1A0TlB2QjZIYVU0eTdvdWJ1dGt5ZnBoSSt5WkFWQVZPSjRBVUJHQjl4?=
 =?utf-8?B?ZlBsRFhZRTVWakJpZ2haRXU1ZnRURGJiSmJmOXFjbW00eUJyMy9yemxaZ3Ax?=
 =?utf-8?B?MUp0b05ISHo3cGdndEtTT21qWDllYlNpS2JlYjVQOVA3SlA3c0MyTDN1N3p3?=
 =?utf-8?B?UCtwQU1wdldZUEpjdW5jdmNNWFdNd08rQm10U0F3d0dxeDJrZmk3Q2h4QU1s?=
 =?utf-8?B?OFp3Nno3ZTNWNytZeXJVdE1BSTZzcXNLUDU4V280UlFFVnFTZEl0Q2lTTFZx?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NHlKRWNPRWd4bmF6QmlyYUc0SEhMSXdWN3NHdE1WVlRyYzhSekhZNDFYQU9w?=
 =?utf-8?B?U3ZBVTFZL2J0ZURpQkRrQllwNnlFNGFZL01MZjg1NTVrTVdaMVRnbWdISjFL?=
 =?utf-8?B?Q1hXMFo0L1VjK09ZaDdIS2hQN1VCT0RwV3UxbmZubFlPc0RRTXBrNEhNZE9H?=
 =?utf-8?B?Rk9IYWV0QjBMVjNPS04vSGpjMmU2c3lOd0tDbG15VDNYZ0pMNDhHcjhWdC9K?=
 =?utf-8?B?VC83MWpQOUs5TFFxN1ZFZzRDQXJ4NEE4QWd5cFEwcXNpTzRQdVM3T1lsVFpa?=
 =?utf-8?B?cE9iVUNWdGNwN2VlUTlMaHVwOUJLZnZMMVI2YUhGSUQzSklLSlhPL2YrWTBD?=
 =?utf-8?B?QkljZHRHK1NxZXgzczBLbHd0d0ZEV0dpb1RwaDVkY1hXcW5nQWh3YjlDeFdq?=
 =?utf-8?B?OU1YWDRzRXQxcnJwR3Z1TnlRc2U3RDBrbzZhMXlKU2JieHZyM1RXbHgvanZB?=
 =?utf-8?B?b0Rod2I4QW0vYkpxcmNIN01yUkpCY0VsNVlNRUFOKzlCMGhYRmtVN0hXTEll?=
 =?utf-8?B?NGZrcG5VL045a0xOVHY1cGw4K1oxQ2JpYXVxbEtzUG5Xb2pxUzQ2dmJSS1Vn?=
 =?utf-8?B?VElta3RuRmw5QjVuZjVLV3RTaytCckNZSnZjWjRIOUlybG0wN2Y3RkFKRkpy?=
 =?utf-8?B?RTdOeHpOSHBiL3lHTUUzRzRNdVVLMXJsSmtTOVV6UGpEangrSXlBRFNQOW9U?=
 =?utf-8?B?dUhzWFV1ZzhsUHh5YldnLzRCanlzNm94d2k4QlF2Umloam81NUhmbytncEFE?=
 =?utf-8?B?c0hsNzVGTGIwUVovbFpIZkphWWpXNUtsTUNGZEVWZFYxaEFwR3kwZFRpTDJR?=
 =?utf-8?B?Mk9walE5dW0raFowTmNoL3JWSkpmbjhWWDVjUTRMZHNIQkN0UWdnM2licHVS?=
 =?utf-8?B?NU1ZLzRnMUs2bUpZOWdkRDBhL20wY1RxQnQ1UUJwbkZrWFU0UVRlcGo4R2lE?=
 =?utf-8?B?YUgxYnpGSGZhMVlqczNOWTVJcVh4UU9FOSsvejBERDh1WlpSdTlWLzNDTzd4?=
 =?utf-8?B?N3Z3WHNzOUxKSm9TNWpNNWlVWm02MHUwYjZMSm5qSXI0WFhOUElkaDRIaGFK?=
 =?utf-8?B?ODQ3eHpSSUhZc0JneW9oaTkwazhMSzdIWHk3YXZIMU1GZ1p4UTdQSUtGMmdG?=
 =?utf-8?B?bDc0VHlLL1RBQllyak9SWnpYQldzLzF5OExSdUZBT2lGT0Z0Y2R1MmNYUUQ1?=
 =?utf-8?B?dDIvejhpejdhVlFYS1pEYTZ6SkE1NFlTRWlnT1hQQTNhMGpMR3hNekYxS0ll?=
 =?utf-8?B?bVhBcmJlUlFTOUUvUVN6M2lDclM2Sk1Fd05IakZyMHI1ZlVLMSs3K2lLSURU?=
 =?utf-8?B?Sm53QlczbDNzTXZieWR1c2RWNlFiS1JuTE90dkxDMW1VSHJoNzZGMGZZQzlG?=
 =?utf-8?B?WEpqbTRyN0xuM1JuRFlxZmVLTnBTVnArdTZFTmN4eE1OeDRia09FcHNHSVFo?=
 =?utf-8?Q?fq3yQhcA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f4c185-2e28-4cc6-1899-08dbcf24988d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:20:29.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxiGfCYp32oVmu8zgchsxyVfcvg+X5+v4xgO4trGdbUuwXcR3zYpju/6fkY7JnIrl9VpLHT6Z0Mu8Ax7JH3NtpDL6pT1BM7CiD3TRSUipxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170129
X-Proofpoint-GUID: mae_NXdheEbUjI1iXGYWOxoz7i8u-XKi
X-Proofpoint-ORIG-GUID: mae_NXdheEbUjI1iXGYWOxoz7i8u-XKi
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 13:58, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 07:50:25PM +0100, Joao Martins wrote:
>> On 16/10/2023 19:37, Joao Martins wrote:
>>> On 16/10/2023 19:20, Jason Gunthorpe wrote:
>>>> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
>>>>
>>>>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
>>>>> well later in the series
>>>>
>>>> It looks OK, the IS_ENABLES are probably overkill once you have
>>>> changed the .h file, just saves a few code bytes, not sure we care?
>>>
>>> I can remove them
>>
>> Additionally, I don't think I can use the symbol namespace for IOMMUFD, as
>> iova-bitmap can be build builtin with a module iommufd, otherwise we get into
>> errors like this:
>>
>> ERROR: modpost: module iommufd uses symbol iova_bitmap_for_each from namespace
>> IOMMUFD, but does not import it.
>> ERROR: modpost: module iommufd uses symbol iova_bitmap_free from namespace
>> IOMMUFD, but does not import it.
>> ERROR: modpost: module iommufd uses symbol iova_bitmap_alloc from namespace
>> IOMMUFD, but does not import it.
> 
> You cannot self-import the namespace? I'm not that familiar with this stuff

Neither do I. But self-importing looks to work. An alternative is to have an
alternative namespace (e.g. IOMMUFD_DRIVER) in similar fashion to IOMMUFD_INTERNAL.

But I fear this patch is already doing too much at the late stage. Are you keen
on getting this moved with namespaces right now, or it can be a post-merge cleanup?

diff --git a/drivers/iommu/iommufd/iova_bitmap.c
b/drivers/iommu/iommufd/iova_bitmap.c
index f54b56388e00..0aaf2218bf61 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/module.h>

 #define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)

@@ -268,7 +269,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova,
size_t length,
        iova_bitmap_free(bitmap);
        return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_alloc, IOMMUFD);

 /**
  * iova_bitmap_free() - Frees an IOVA bitmap object
@@ -290,7 +291,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)

        kfree(bitmap);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_free);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_free, IOMMUFD);

 /*
  * Returns the remaining bitmap indexes from mapped_total_index to process for
@@ -389,7 +390,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void
*opaque,

        return ret;
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, IOMMUFD);

 /**
  * iova_bitmap_set() - Records an IOVA range in bitmap
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 25cfbf67031b..30f1656ac5da 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -558,5 +558,6 @@ MODULE_ALIAS_MISCDEV(VFIO_MINOR);
 MODULE_ALIAS("devname:vfio/vfio");
 #endif
 MODULE_IMPORT_NS(IOMMUFD_INTERNAL);
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..a96d97da367d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1693,6 +1693,7 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);

+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
