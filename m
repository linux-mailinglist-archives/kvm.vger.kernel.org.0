Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930CE7CC5E2
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbjJQO0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjJQO0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:26:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC05F92
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:26:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEDr9h024287;
        Tue, 17 Oct 2023 14:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=f2/HIgNojsTCGPjK1395LNUVH4JLGpfb9aDGUV8cVcA=;
 b=MLoW+oy9ANSs2LKBgbyMN2g4qajWDcJyACYqIfgVQTPgvx10FwyMDsb4WqJKR758rC1u
 gjPlEkiascJhSU/GcTlxrhgDNASVBF+syt8finwRKfFgXfEVl/baaEMEmpQfj0i+BWGt
 uvxOrlgRBqQ2if8T7llEWzTkIv4BUCL+lg3EKcWShLv2WsWB5KRLQs//Pw8xVzlJEz/7
 34EeXf4FlzVqjJczx2z8Qt5zX7B8aeChL4U+xGWk/HH4lgmnQKlPHzrTYU9VzAr7agtR
 +skm2BaJ318zwbwsuOwa9CTNZnvFl8055vCtvvJmXmC9lbC5qecfo4GUb22iVvq7ITfq qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cw96t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:25:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HDmToe028598;
        Tue, 17 Oct 2023 14:25:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy3nfse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBG+Y8J0KkrAnwove/RZyh76UJ008jYrGioBRvjuKbnm8dG+8UUt2pepY9rD07z84KjZ5lzgNjxM6fOIJSfUf6W783cbO9WqjeazV73UXFI+is0XVxCZQvOXkTQcIsX11FBZxspeZH2lRr2LDalSUeqLtoxBLo4Fuj0dxMiJQZQlu5EVLZwxCWXzaCfa2qfIe8tN15So7ozRFh3I7VnOqZwBr04fo442Pe6ZuXIX3CREumEFf92iaA32OxtzwHN4gjMxlFyRCF0d32D9MaG5JLpOMnaT4pIVKLvO99RFoaak+Y8RKX2JTTE9EFQV0GNMbgfVuo2jwoA1HgtYy89j8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2/HIgNojsTCGPjK1395LNUVH4JLGpfb9aDGUV8cVcA=;
 b=X6Z6wp6GwTWSU2MXiY8OLnBsM9HNXk48ZQT1esXAFbu6omWWA2GYtSusDziaZaeYeysgHJICqfW1SnMadL1214nKZ3fMFHliqIOT+p97+H110kT4Zrpbm8ik7+uOEDXgvCYTBisrP5ELK+vDgSOmwhc4fIBufkhrTuPlrtORAvINLYS7/YmGhXTjmMQwG0riv6yl096vVc0iz5hg2auHVIhJZ0pWbu+THd1BWK7WZQvk8KjbcsOBNgXBDhz01q07udBx3o9T13QHe8qmuxuXDSyBraZV6jx8mrQih6ctFB9d5JHU7yPB5VTrlF6MDYhCubYT1onQV7M1nhDVUibd1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2/HIgNojsTCGPjK1395LNUVH4JLGpfb9aDGUV8cVcA=;
 b=Z5279pTMuoCAXMxCM6pMKfUDJU800Fea6JcKVo3a7HvhlSz7tqjkaVQM7xNgKzze7R4qE2GeYlnCDbBP6E3wIz1bGgg337p9DEqpuep77P54HuozhzsdHgkWfnztvDxeNMuiUKuP9hvp4aNLfYYRVXPfmCbw6ztmsYc2+aMAdcM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB6701.namprd10.prod.outlook.com (2603:10b6:8:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 14:25:42 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:25:42 +0000
Message-ID: <db5d7ebf-496d-47df-aa1c-3db2f12edc19@oracle.com>
Date:   Tue, 17 Oct 2023 15:25:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
 <20231016125941.GT3952@nvidia.com>
 <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
 <4cc0c4a0-3c00-4b29-a43b-ddfc57f2e4c0@oracle.com>
 <81bd3937-482c-23be-840f-6766ca0ec65d@linux.intel.com>
 <8e5d944f-d89e-4618-a6c6-0eb096354e2d@oracle.com>
In-Reply-To: <8e5d944f-d89e-4618-a6c6-0eb096354e2d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c62dcd5-df82-449f-82c9-08dbcf1cf171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XKkKdDxjUefsu3VLDnoZQr/tolZCRtxgMmTddy/Cq52nVK9Au5NaOrF46AHBzPfxIx58gD4y7LFsbzfj/NGiC2N/yPHQHOCrIDy16Ykqtbzdf2I0CgGIGyhlfFklyqAb6Qg0CkKqq86yMqVJNU2dTYZIPQg3IhUt19IcCvYIBh1CBUMUQUby5HBz+arFGviu9qa+ldQ1vFHOsUsPesXGY6JktKLLbfb4x6Nb3CxhGHHFE2LtXrix5nQ1cteJVFkeKOs7YvDh11b6fc8EJjF6beRCam7IRcHJDCrdXW2Przmga+KDp8c+08Jkct4E22ha1X9p1WZtaECdloCF/VMg3+QD2cBE4DGVuO91xs1xEBBXBe/AvS+p4v4D11JnuKIyOD2eN7WG27X/z1tvddEZyL3BVRrDQak9y5vzK2PB/7+8YLhX5Z1ok0BJ544l9faAtsjMmL6+qj1eEXKspYK9B1AAFfyep9tMyOxVKK+GhcgF9rEcOoS7zVxHVq24xygr7nut6dVJgVnc0Lkc/qPXgQTG5yqcBOBicNUad0GE2jqlwINOi20GIHBRNbuc/7Uh0oni0rAZOUtpSs/UOuizjW2mBe+GrUy9ZniSIByHbHoPqrQKeH/24PAQ2J9i9UL2FUAZSDxNVy5ix7gQsc0N/v4crdcLQ0GEJAEGrURkYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(346002)(39860400002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(31686004)(66946007)(478600001)(54906003)(6916009)(66476007)(66556008)(6486002)(2616005)(83380400001)(31696002)(86362001)(6666004)(38100700002)(6512007)(316002)(41300700001)(26005)(53546011)(6506007)(36756003)(5660300002)(7416002)(8676002)(2906002)(4326008)(8936002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0tCc1U4eGNJSW96WGpFc3RteHFxcldoZDQzMXkrSm8rVkk1UDBLRXpxcDd1?=
 =?utf-8?B?WkEvYjZybkFPdWVHWFJWMGVKcHdkSXlLT0Z2SjRFRHhuT3hRdmh4R09zNnVX?=
 =?utf-8?B?b0g4V0NHRUJraXFZZTV6T1Rzcnlqam9oV25lWUdjMEgzaHJDd29DdE1oTzJE?=
 =?utf-8?B?SmFDTS9rMWUxMlRJRjUxRldFODc2MitrdXk4d2xOeHdaYTNJczkzZWRlaS9i?=
 =?utf-8?B?RG5id3VhNjhYaFdFQmpXendWc3dEZHVERytRcGdKMkpMNkJMMDRBT1lwZHpr?=
 =?utf-8?B?S1VMUUV4UHRXSEt5c2JBcjdCQXlYU2RGMU9wbkxIL3F4MzR2ZXdOUG1ZYmVR?=
 =?utf-8?B?dU13ZEdRNmh0UGVDNzBHVjJMYlM3L2J0RDNSbTl4bkwxYXFZaU15d3FEekha?=
 =?utf-8?B?OFd1MGFYT3A3T1c1bmthY2NkTU15L2tVcCszQXVlYUhuc2Y5Nk1vZGlzNnlp?=
 =?utf-8?B?S25keEc2WXMyZytsQjBYTXNQUStqZ2pNVlk5UFpCLzdib21wOUphSTY1aTBJ?=
 =?utf-8?B?S1B1WVd0L0xjVnFWOVp6czlHMmRONnp5a2pSeWxuU3ltMFdOcXJKSmU5ckxo?=
 =?utf-8?B?NU9ZekJmQnRlRVFSTk04aTZsQ053TkNTRlFZSkJWc04vRE9pbnF4WGpsNExr?=
 =?utf-8?B?YWdlSWR5Yy9jdCtwQldYa1lLZlgzNWJpSitCaWMwdlZEamhvTWU2ekV6aVJH?=
 =?utf-8?B?VXA0bXRLNGNSTjJjOU15T3UycFZyODVJQllhWFQvaXJDdFM5eXE4bWYyWFRQ?=
 =?utf-8?B?RUkrV3RlMW0ydmZUODNBWFQzcC9EVllEWHY0ZmE1NVRYcTRZbHphTkU4YkE0?=
 =?utf-8?B?SC9uU3FuMjJYZmVkenJmd29Ga2k4MERpc09OZlN5VmVLdkFCeEVIYkF3Q05I?=
 =?utf-8?B?dU5NZ2xIWVBMZWgvcWFDM294ZGp5dERNS3l3MkFMaHhieGI4dlNqeTFPWW5I?=
 =?utf-8?B?aC9wOW14VHNjeWl6aHhOdEx6SzF2OHF6WGk4QTh5MG1FSHJHeW5LREh3VXJT?=
 =?utf-8?B?Y3pzQmdvc0RMRXZVNXlhWGdlU01pNHpiK0I4M2t0T05KS0dmQVlhKzJXZi92?=
 =?utf-8?B?aUVvdGpRRlpnQlpORlZoOXA5Y3BzUzN3VFNTWVBwejRzc2NmTXd2TXhEQjA5?=
 =?utf-8?B?RysxRkZXUzhLbUMyMUV1NG83K2FkdGhQUjc0L0xkUitLSCszMzNXcC9VMi9i?=
 =?utf-8?B?cXIvUjdlUlBqb1oyc1lIOTNHL01JNS92aUM0c3QzaHNycmk1ZGdFbCtHbk5D?=
 =?utf-8?B?S0c3cEc4WFpyai9md2JZd1I5Y1JrUkdqQ094Z2tRdy9DNkJvL3EwZ01vSndL?=
 =?utf-8?B?TGthWkowakJiTGllTWxJNTR3Y1p4SWhlZnBvd2l0R3V0OUVaVDFKMHdvcVdo?=
 =?utf-8?B?R1ZPQUkvMHdWczNna3lKWEpYK0hLYmNkQ2xZNlJzeS82S0RKdTRyRHBMRUFo?=
 =?utf-8?B?TU1xSW51L1FkeXhXeUZCckIrM1hwa2MrZnc1R3R5aDJCYldNcTNqV21DRy9z?=
 =?utf-8?B?QmtDQmxwcFBZZ1NSUTdRNmVEckliY3pKOGlQWldYeVZoWlNUMnVjWVAzN0lD?=
 =?utf-8?B?WHdaekpyamFzdW1DTDdXZE9TdC8wQmF1VVBBMHZyL2hTaUxXWU11aGRPQ1Rt?=
 =?utf-8?B?bkJnV2RoT1p5L2UyeGhkQWhYRnlWQTgyYmtxbFA4L2hlcU1KUjRwNlRwaVRG?=
 =?utf-8?B?RXdvYnJzb0YxdFVPQis4czNzMUtsdlN4RllNeWdVVW83STl0OVVKOVJOdHBo?=
 =?utf-8?B?bGI3Q2dGY1FyOWlpRkZpSmw1cjlnV0JvOHEvVTNNekRUMXVyRFFhRklVMHh5?=
 =?utf-8?B?RFZ6MUwraDF1T2xNU0IwWjdYUXlpRHRuK0RTcGVubG5TTVcxT3BBdTVvU3Rv?=
 =?utf-8?B?U2VvK0NsUWppcTFhSmpLdzJIaElLTXZJTkxlWVB3QU0vUllJZWVGS0RCK05T?=
 =?utf-8?B?YkxxL1oxUzB6RFAydVNkcFJKQmt1T0JFTTAxRmNJTDM3UktnRnROMXNuQTVU?=
 =?utf-8?B?QjBvSGUxdjNkblV2Ym9WMmRCV21zSUE5a09vWXd1L1prTjZuV0JJdWlCU0Q1?=
 =?utf-8?B?MUVOOEh1QncxclhRVDc0TUg2cTcvTDBsMTJNS2dIMGt1cnM4RTBCY040N25F?=
 =?utf-8?B?cFVwT1VvUnR4aFA4T1NCNmMyNERmUS8yaUJEV0trR1JhSEcrN0RrQURZWkZl?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TFlYSEJwTzRNbmVuaWtLV0creThqQW8yejRzV1VDQlh1R3B4d3VRMG9mRWRH?=
 =?utf-8?B?eFFGMHZlQ1QrSm04eWhPM3ZDN1RvZVdRNXp2eFN6MXR4dmpTaVhrQk9RUlVn?=
 =?utf-8?B?WnhEK2pLYzEvQjhuZHFCbW40QjVIeXRRRlVqb0FJc216MVlCZjEzekpsRTN1?=
 =?utf-8?B?K1NlNm85UVNxNTRPTnQ5ZGtqVHdGd3ZSNHJSVkVOdm42QXFYaTBsb2JzOUVC?=
 =?utf-8?B?NnpuYy9GYmtYVy9MVDRMaTF1SVN2ZWh2aDVpbzk1T0hkQXM1cVVob0NvR3A5?=
 =?utf-8?B?TzVFTU84Si9KRFZRaTZTbjFkcFA4empjT3VSUlZBbEJMZGJNRmQyL1padEFh?=
 =?utf-8?B?UmNDMUx1RmZQWE5ZNC9qUEJvUXFzQ0tIV2ZrSEpQNk5RNVNtYTRLd3BNY3Rj?=
 =?utf-8?B?andYMGpPZFU0eldmVHVQTCtyTUQ3QUlpWnhadTZMTStuYjUyeERhYnA2UktL?=
 =?utf-8?B?ZUEvRmpFRDZkL1NvWnlFSjZJZGJKb2RaR21yUDhBL1F6SU5JQU5idjgvUXpt?=
 =?utf-8?B?Qlg2NEVIemc3cUdCcTluMUdwVVdNb20wZy8xSzJzeUFLZldEdEJjN3hSMWFw?=
 =?utf-8?B?bnRnaHFJOEduVk9uVzdvaExRN1plVisrRUk1dEwxZGxvNVJVSHRRMk9QUUFv?=
 =?utf-8?B?Y3NHMXV3U2NHa241aHg2Ykhqb3ByYlVrdTNLSE9WNk12ajZUenZubkZYVUdF?=
 =?utf-8?B?TTJ6ZGw5TFpGb2xWUFd3NFIvZURnazVnaW5YazFhZVhFSEdiK0tYOENvbEFP?=
 =?utf-8?B?a0tjeXk1dmRDUnlUNUszM2E3YmFTMnV6Z3ZLVkFUaFhHcEJTQkFnY250anlF?=
 =?utf-8?B?bUFJUEsydmFMMTJ1MVJHbjhrOFRkdzNIZjRnSGplZWRIYSs0OVRVNERsaUJL?=
 =?utf-8?B?QlpndjVBcEFaTWh6UG84OFhBSEhGeUVDVmE2bG1ySElNQTM4QStMSy9MZkhU?=
 =?utf-8?B?NUJzdUlXYytlWTMvLy9KU3IyNndMbmVlcFR1N3JrUXRwZEJsdjlGWXhNbW5l?=
 =?utf-8?B?NzhhVDlONUVWQm55ZzdXU1NtMzFFSGxPUTM2d1ovT3ovRXZkSnVub3FndThm?=
 =?utf-8?B?Q3Back40ZlNlUkRRUisrSHZFLzE2SXhGK2JlTTF5THF1WnZxT0VFVStUdWFS?=
 =?utf-8?B?SllHOG9rZStCSUE3UC9OQWZhSmxlN3YxWWFtamVGbDVjWGxqcnhLV0lRUFBz?=
 =?utf-8?B?STA3dENvelpEVFVSZnlZTGR3aTZJUmZibUNkaWQxaXdDQ1JzSzdCK2lKR0Vj?=
 =?utf-8?B?MURBeFI3cVBpRWt4eFplczFic21TMStkSUd5c2dCOCsxUUhZQ2drb1JaOUJN?=
 =?utf-8?B?dTNnbmFBMWtLYldTTVMyU29GMTZDd05haHpCd2NEUE13UUk2bFg3MXBYTk51?=
 =?utf-8?B?aHRNWVlEOEJiMXhweTVTZnVka09xVVQySkFVVy9FL2VBa1laY0ptdlVTVW5B?=
 =?utf-8?Q?dK1gLI5O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c62dcd5-df82-449f-82c9-08dbcf1cf171
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:25:42.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hl27LUB4d0ThzqJNroR7wojFd9iygYCEXqgHo154flOJ1o3Mx68+EbX82tH2yBKyTrJmrUhbTd41VRAu+Aea9TP9No9AWZlC+7R8JQ8MrAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170122
X-Proofpoint-GUID: xihCU0egZgRxeiLDmX14d5ooPlnvCVbx
X-Proofpoint-ORIG-GUID: xihCU0egZgRxeiLDmX14d5ooPlnvCVbx
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 15:16, Joao Martins wrote:
> On 17/10/2023 13:41, Baolu Lu wrote:
>> On 2023/10/17 18:51, Joao Martins wrote:
>>> On 16/10/2023 14:01, Baolu Lu wrote:
>>>> On 2023/10/16 20:59, Jason Gunthorpe wrote:
>>>>> On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
>>>>>> On 2023/10/16 19:42, Jason Gunthorpe wrote:
>>>>>>> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
>>>>>>>
>>>>>>>> True. But to be honest, I thought we weren't quite there yet in PASID
>>>>>>>> support
>>>>>>>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the
>>>>>>>> wrong
>>>>>>>> impression? From the code below, it clearly looks the driver does.
>>>>>>> I think we should plan that this series will go before the PASID
>>>>>>> series
>>>>>> I know that PASID support in IOMMUFD is not yet available, but the VT-d
>>>>>> driver already supports attaching a domain to a PASID, as required by
>>>>>> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
>>>>>> perspective, dirty tracking should also be enabled for PASIDs.
>>>>> As long as the driver refuses to attach a dirty track enabled domain
>>>>> to PASID it would be fine for now.
>>>> Yes. This works.
>>> Baolu Lu, I am blocking PASID attachment this way; let me know if this matches
>>> how would you have the driver refuse dirty tracking on PASID.
>>
>> Joao, how about blocking pasid attachment in intel_iommu_set_dev_pasid()
>> directly?
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index c86ba5a3e75c..392b6ca9ce90 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -4783,6 +4783,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
>> *domain,
>>         if (context_copied(iommu, info->bus, info->devfn))
>>                 return -EBUSY;
>>
>> +       if (domain->dirty_ops)
>> +               return -EOPNOTSUPP;
>> +
>>         ret = prepare_domain_attach_device(domain, dev);
>>         if (ret)
>>                 return ret;
> 
> I was trying to centralize all the checks, but I can place it here if you prefer
> this way.
> 
Minor change, I'm changing error code to -EINVAL to align with non-PASID case.
