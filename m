Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483E77CD784
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjJRJGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 05:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjJRJF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 05:05:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24283101
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 02:05:57 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39I73u8E029108;
        Wed, 18 Oct 2023 09:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=poxdsCzEL7h2Zeh23BUOHRV+VAYbhHRaL0iP+C5TwIw=;
 b=bSqhoxGJMs56AisK7ohE9qPzBqveVYLYqk/K84wZrN1OcM/Qko7WqzCOEVzZayyEjEUg
 lUMSVUpcKmjsKXgxlIvgOYOT0G7c+jbe0xKKFCdDedVyXl1lHf20b5HCI+O9pcN9nlzZ
 N/rmF4GhNoL9qrIKmbnca1ddnQLEbpvvRJLApdImjK3C6gaM8fQFF6dwLcmRS0v/zopF
 ETmQrmVeGzz7aVGLhyoIJGy3igGDml+YG+dIJ/cRx0u3dkfGBZeiPLtP+IRxbw6fkGGH
 mj3rvufeDOEtC8I7T3yoHJs2DLnGWw3nXYd163MhhlNpm9UurI28UwtEH8JB+T5Cjh5W 2Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cf5km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 09:05:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39I7d0FP015288;
        Wed, 18 Oct 2023 09:05:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1g6wn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 09:05:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZ1RciTUfed8QYhtiPCd2ofLdLWEBgdR+1pycXFlcv9PJB+8cFyYqFf67YyvwGxMgBKEUBL8O0RosaUXd02T2vzxgNzMAN3JYXo11xAKKXkzCgE3GydSsyIiEmGgSo6+pbjuI5DHBE3vlhWP4Q5h8jyM3aK3+2dTz0Db+Hd3afhRv+ptRCgu2GL/9y7ia8n3SgAzHCw4muYUKiEdhcLbYqFILXkkTVEybj0m386lN7clCcfHjnA2lmf6J43jkzFNpkwtdnuHJ4lfhaCpvZBRsuslXnV1eSLiX1tIAgTwMWInjQlLlFC94i6n9BToGC00efg+toeCGOtTLlAlo6SyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=poxdsCzEL7h2Zeh23BUOHRV+VAYbhHRaL0iP+C5TwIw=;
 b=UxhIxaLRLws44iYiQpcrPQX73hrcXdZydJfd1SSW5w1SvpUMrPF2EzgTqJsUFnBQeXYeDWAq+HaTAvunpJLf54qnK6k4Ga7ikxCrH+5ndtFf+lQ8d/+Myj7MVUsDnt84+h86w+eU0NLWrxMmYaf9Xx7Uig/Xj4x9O02n6ISiW6yRgusrEufHF2yrOQQcQV/w/v+JMLts0Tp9rwEMlHBTfxQe+A+hUBcM8Gz/Sp2XPABVr06cR+rPtZnuRvrj4esYbNmmWis7TOBqP9Fc5HUQkGkipelzQQZgim5KyaGbpUb/4wMXNoDKBbwf6v4tSK36q5ytz9frCzdSl+lV4llQzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poxdsCzEL7h2Zeh23BUOHRV+VAYbhHRaL0iP+C5TwIw=;
 b=eXJHnbUs4FupGv/5cCh/8krD/RfG2Kh604roy/u+u+ygfvk3M4quTLi2FFukRsDsV1P51yDvGnWmp90n2iZdjxzIM69+q6GJp/xMVKD+bnltDfMLo7toUT2Tnu3EmekuuUfaC2jyUVFM7i/e+1bny/TbuC4S7eWsgU/6V6QV9aQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 09:05:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 09:05:29 +0000
Message-ID: <2c988c45-b845-40d2-851f-f080a12b1047@oracle.com>
Date:   Wed, 18 Oct 2023 10:05:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     Vasant Hegde <vasant.hegde@amd.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
 <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
 <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0027.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d91ba4-2082-4cfe-cc69-08dbcfb96036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQPi9cgvSJH6jaLsooImGhhHtRO2RHTMxh5LVDXTV3OXUkMJWA5IEYhRntSnCIfoeYA3IM/Y8/6NQ+mi+/zFtL1DmGt+Q26G6YkiTsYeiRVcraGdyHrM7VcKuRRf3UBdL5j8xDuybmIVSR2YncJKkX9WdVuB6jreJGitnCnD6IE0uhl0lc1DB3+kzPtCEVxm13a8cRQcVcXDStvOL3bEv2pJtyGWANxmFN32IYpheexYhIJoxHMbCbEoyYW1xx9iL2HyiInwX7KQEoJH8mYXvlpKbMYmvKZlGNi0JYviQSob5pM252GpADzYFu3HmLe7s73+XXBXrVmJiMl//QKkCd6vzSFpJmPbih19aYsLGgdEc4Ivw9RrKvuceH9g694mAsij6rSnHqwduQgE34dbSAo+HVWGBwAGefP+KdKvihcjk3HfQKOHJCL0yNXtS7PPx92cBHgGPtrjXq0eh5w1vWxCamMt5oFmI34FZ1VNe0NYGTN+Jd4E2rDH6T/BEt8OOCLPmwa/bhuheL4ZP32lo7Yv1MoBoCwK5b+FOser1KtzXy1LRVxV9qwevz03JTf72BRiElZrCwKd1ReTgx3qknYvW+Y0VawwE+1cyWyMqwD5jtWOp2cETQAEPAhayDSVCrh7iZmRYa3CCmE5PJfN9NILcVZNagG5A7xnAk8Zh6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(136003)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6512007)(38100700002)(6486002)(66946007)(54906003)(66476007)(316002)(66556008)(6506007)(478600001)(53546011)(2616005)(26005)(8676002)(8936002)(7416002)(83380400001)(2906002)(966005)(86362001)(5660300002)(31696002)(36756003)(4326008)(41300700001)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2U1ejZ4dEVYTS9kRUovNVZCTXAvNlVra0ZJb0FFbWhsMDFXem5sM3FFZVpr?=
 =?utf-8?B?bzZnV0VIbDJOcldjOTN6Q09URFNLT05IYlNISUU4U2UvYVVXRWpzNVNkNVRj?=
 =?utf-8?B?REFBTUpnQjBxeHNjMlZEUGk5ek5JR0JaZTlQeHBJM3p1LytSYlF1eEhmRG4x?=
 =?utf-8?B?dVlzay80SmVzMnRoTTJwUTJnWnRwMVptUkw4SjMyc0xXWXVKeWZwemxaZ0cw?=
 =?utf-8?B?d3pGV0NOVXFVa1hwWm5Zcll0VmYzYUJzTGpoUDJyOFdyUXR1K01PWDg3UGNy?=
 =?utf-8?B?MHdpWlFvTm5OdzdQZkdNYng3Q2g5ZUNGQkwvUGM2Y25FK3ZpTml5VmVLaXZk?=
 =?utf-8?B?ODIva1l5ZXZ0enh6VHlUMTNWZTJvZ2thS1Mva3ptR0ZzRE9CRWdWNWM4MnVF?=
 =?utf-8?B?b3dOZVhuRDd1RGdacWRZSUlHMldtMmYrZ2JXTFpCQTNieDNibkNxMlhjZnU1?=
 =?utf-8?B?eDdaUjhVd25OTUpCSWkrTHU2Um5jWG10bXdFWGNDLzZOb1JkZXBuUnpKa0xO?=
 =?utf-8?B?ME90NEFqZm93NWk5TzNZdml2K0wvT2dXdEJWRk45NkgwU2t4LzFPMFhLbGE1?=
 =?utf-8?B?S0crdkgwT3FnZldpVXlPZDEycytscXlBdDJVZ0xsT01ZbVY0MFZlOTB0UFpn?=
 =?utf-8?B?Vi9MMEZZOXdpOGJlTWJMOW5UTkFvVmJlQVp5RjdOVFR4RGY5M2tkdk5aOEJy?=
 =?utf-8?B?WndUaDlFTGc2VFBTWkVjTzAzWU9STG9BVWtLcXNlWTZpVWVSeEpwbDNFL09y?=
 =?utf-8?B?bkwwcHQ2WFBiUDV5OXhRMlNZOWZweUJmYTFybzBXbkR2emtJaE85cTlqeGhU?=
 =?utf-8?B?WWp0WE16Y0gyZVhVSnFHd0N2dXNzVDhOQldlYzFYUG1wYlJYcktoZmx5ekl2?=
 =?utf-8?B?SU15MGdhYWtsRXcreU13SjFxczdsbm9tUGZHWWRNbmw1UXV2UmQ2ampkYisx?=
 =?utf-8?B?SXQ0ajl3Y21BZUd2Wlc0U2pTWDVXOHB4alVyN3lUQnFUd0RQbURPUDhGSFQv?=
 =?utf-8?B?SWthMmVlQWwrMFNYSHQ4SmkrZXVRSlh6UXMyak5hRUlyOU5WQnNidjFXU29K?=
 =?utf-8?B?T2pacEFORlIvb3lsOFF4UHpGYVVGeWZMNkU2bmhvVnZzSEZicHhqV0NERU5R?=
 =?utf-8?B?SzFVMkY5clpoUk9VWjRGTkI5Vmh4K1V5b29IbDdSdFRJWWpkL1BKNXlnUFZJ?=
 =?utf-8?B?bFVNQ0dycHEwMTFrQjlzOGhDd3F5V0pjeDRPeXBUNVJISGRtT1NCRU5zc1pB?=
 =?utf-8?B?dmJpckRka0RRU1dqRExJSUxaWFJFL2RZdVFYRzRRNkhrMytjUUFoMzA2b1dW?=
 =?utf-8?B?TlFUSlV1cXJscVAyYzJQaHZCbUVDQjJtSmNzMnJPa0RRTTNMTWoyR2ozRnJ4?=
 =?utf-8?B?RjRwL0hzdEl5eFFIcGRpZXdRbnBmSTJ1VVVRR0hOZXhuWHVGM0pwUjR4M0Nv?=
 =?utf-8?B?eEhLYzRMZ29rcHVPengrS201b3Z4YU91UFdtMkIyVmpPdTVVOG1mWDZtdXZx?=
 =?utf-8?B?Ti9hZmlpeU0yN01hdGRGZ2ZYZitMYlA3Mk9YZnVITERwaFEySnFWeU02N0xq?=
 =?utf-8?B?NW5qSU1YbVdBVEFrTU50L2h5Mkh3Qkx1M3RqWTN2NEpBbjJHUFVXQmI3NEVU?=
 =?utf-8?B?czI0YWpvTE5VRjNETzZUTE1jT0hMWkJ6YXRuVm8vTjNoQTM0WmdOQ2RUWGM2?=
 =?utf-8?B?cGc1T2VDdUdjK2R3cWp2QjVueU9wSnl5VmxwcER6OWU0c0JBZWpEOXU5WFVH?=
 =?utf-8?B?c3hWRUYxa0Z5R3R2Ukk4K2VISW5KUEtkUzYvbzNjR2doNmVESmo1bHpZQzZt?=
 =?utf-8?B?WC9rRXNFcVE4SENvVy9DbnVoU0svUzR1ejM1VzNIclRDWmR2eE9TcXRIUU1H?=
 =?utf-8?B?bkNLRHQ3RHZhT3J1aWRLbmw5MjVOeWY4UFNiYUY1dkF4dkxoU1hRd2xQOVli?=
 =?utf-8?B?ZkU3Z3RjSlNsYWQ2Q3N4VVFPM0tpd0ZvN09vaENuOWhlSzJKUXJ0MGpzN3dr?=
 =?utf-8?B?b2htbGszNzVBa1RiaWtRdTVNYWVVQ3ljRnBNL2N2eHRlZG9pRG9KbEhLQU5h?=
 =?utf-8?B?ZlJVNE90U2hQNktHYzFGWXErRVlCc2pXM3QwUE5pclhyZEh2dEVqT1pZangv?=
 =?utf-8?B?STYrUWtLMmlVbEc4QUhYdkVRdWZsOWVqNkVyUVNLOVBuRkhVR0F0ZjFubFZV?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bUNIeHI1NzdDSFpIdTFLWFc1OStISnp4aDNjLzJSRmVFVG5QRjVsYUxGVTVE?=
 =?utf-8?B?dzdLb2UzSG9qS3VNQW84amtSSTVIQUovcDUyUE44SEMvU2YwVm41d0YwUW1G?=
 =?utf-8?B?UlRMV09ia0J6dW4xckNkcWNWYUt0b3NXUTl4eHpQK3MzWHNwWHNKVDFmSXdO?=
 =?utf-8?B?eWcwUGs2Tzl4VXFOUm52TlRLYzZPQ1ZQb1RNQ2dLSlV0Rzh2NGVPMFdzcDlx?=
 =?utf-8?B?RFZqNEhOLzFqZlE4MHhoZ0lKOGNzeEFLQ2FsckRVY1BhUGQ5M2tTYVNKV1Ft?=
 =?utf-8?B?Tlpua2VJYmNGdUVUYTkrWWdqMlVMcjdnZnVvd2E4bVlVSHlIVndTeDgzSUNE?=
 =?utf-8?B?aVNkY3YyTnlTODFmaGN6MzJPcTRKVHJLRlg5bThGODMvUmhIUnBjaVZkRW1O?=
 =?utf-8?B?NVNTdVBMK2hrTHFhYWo2Rm1SOW5DalBzT1k1NjJFa2NnbkZaWE82L09wTW1N?=
 =?utf-8?B?cFV0S2RqTzEwRU5qM2IxazhqRzlvdVhmcko0OXh1RStpUmpaQXJVb2FUV1pQ?=
 =?utf-8?B?b0JnaHE1bXRXNDNMWllVZlpML1RCbm1Sd3k5bTBjOU9XRUVwZXZCNDhRdCs4?=
 =?utf-8?B?VWlaUFU5SXg3Y25HU093eitadno2UFlHOWN1U1VVUzBkMkNZMVJkZDlYSGQ4?=
 =?utf-8?B?VW1EUXBMcGlxa1cvbHR2MW1jTCtETjR4QmZIOXUrMjRGNUxuWjZ1UEVDOWdi?=
 =?utf-8?B?MjBlbDhvSVdvMTBQb3pWeEg0d3BHd2FCUUVCZ2hKN1FKKzdYbWFNb0d5eFJM?=
 =?utf-8?B?VWtEUHVTVkZwR0thNUxoUXk0SVJlM25aQ1o0a0ZJWE5MTFgycHMvOFVlYlNa?=
 =?utf-8?B?NWVTUFhUYVF1a0Jva2o3OWo0eS9rTUdpaDN5UlNjTUhLZ3I4ZUxzd0N5THl5?=
 =?utf-8?B?UVByTXRRenJMS3lLV0IyUkQ2YW1QVUlOOUU2K1dUMVdTY1BMc01lRGtrQW9z?=
 =?utf-8?B?VGZvZVRrM3dzWlhwd2hCZ3JnV0ZiRmQ1M05sMVlOa2VIY2V0azdRa0tHdXd2?=
 =?utf-8?B?aURYbU4vSXhSQVNhUUExK0JhOHVRTk50a0Q0UXVvQVo0RGZ1NElaSWcvQjRx?=
 =?utf-8?B?aDJyMjk2U2JzbE54bFRjNFRVTWhZYktRQTFYZVRGUGlMQ1pZVWtzTzhtdENH?=
 =?utf-8?B?aksySkdNNFBNcHpQWTFPdXFhRWFkSTl1T2x3RlBOQm5LcGREcDVGMEVjT21R?=
 =?utf-8?B?bXVKdFN0ckFscEsvQlVnK0xkWHAwWDNRVHZzbTdMOFVHak52NmZzN3JGRllk?=
 =?utf-8?B?MTBrUFhEVjN0ZDE1Mm13YVBaS2RPQjdhMWdYKzhYRUx5Qzk5Q2o4QisyeTNW?=
 =?utf-8?B?QzJHTUJoRFNYbis1VGFhWWIwRU9SV2ljblNrWlJ1R3YyLzN4dm4xUHpxbFBo?=
 =?utf-8?B?R1BPRHJKYmVtYkxqOHFCeWtLeThqcE5nbmx5U2RXNHV0ZWVuOUorV25Tbmpt?=
 =?utf-8?Q?sT6SAr+0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d91ba4-2082-4cfe-cc69-08dbcfb96036
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 09:05:29.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FQj61XimQVnnvDB+v26Nnv3dY3zYsRDxX/LAxX+pQXj5/0J2uqc811av2UFE5ZABKrjxMEu/EoiYRCX04Rp3GpImOWNr7mJclrYwAayGiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_06,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180076
X-Proofpoint-ORIG-GUID: 6Svt4Llqg5aGFJuP5ZbQaXyU4hrF0Tva
X-Proofpoint-GUID: 6Svt4Llqg5aGFJuP5ZbQaXyU4hrF0Tva
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 10:03, Vasant Hegde wrote:
> Hi Joao,
> 
> On 10/18/2023 2:23 PM, Joao Martins wrote:
>> On 18/10/2023 09:32, Vasant Hegde wrote:
>>> Joao,
>>>
>>> On 9/23/2023 6:55 AM, Joao Martins wrote:
>>>> Print the feature, much like other kernel-supported features.
>>>>
>>>> One can still probe its actual hw support via sysfs, regardless
>>>> of what the kernel does.
>>>>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> ---
>>>>  drivers/iommu/amd/init.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>>> index 45efb7e5d725..b091a3d10819 100644
>>>> --- a/drivers/iommu/amd/init.c
>>>> +++ b/drivers/iommu/amd/init.c
>>>> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>>>>  
>>>>  			if (iommu->features & FEATURE_GAM_VAPIC)
>>>>  				pr_cont(" GA_vAPIC");
>>>> +			if (iommu->features & FEATURE_HASUP)
>>>> +				pr_cont(" HASup");
>>>> +			if (iommu->features & FEATURE_HDSUP)
>>>> +				pr_cont(" HDSup");
>>>
>>> Note that this has a conflict with iommu/next branch. But it should be fairly
>>> straight to fix it. Otherwise patch looks good to me.
>>>
>> I guess it's this patch, thanks for reminding:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/drivers/iommu/amd/init.c?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec
> 
> Right.
> 
>>
>> But then it's the same problem as the previous patch. The loop above is enterily
>> reworked, so the code above won't work, and the "iommu->features &" conditionals
>> needs to be replaced with a check_feature(FEATURE_HDSUP) and
>> check_feature(FEATURE_HASUP). And depending on the order of pull requests this
>> is problematic. The previous patch can get away with direct usage of
>> amd_iommu_efr, but this one sadly no.
>>
>> I can skip this patch in particular for v4 and re-submit after -rc1 when
>> everything is aligned. It is only for user experience about console printing two
>> strings. Real feature probe is not affected users still have the old sysfs
>> interface, and these days IOMMUFD GET_HW_INFO which userspace/VMM will rely on.
> 
> IIUC this can be an independent patch and doesn't have strict dependency on this
> series itself. May be you can rebase it on top of iommu/next and post it separately?

Yeap, pretty much; I've removed this from this series.
