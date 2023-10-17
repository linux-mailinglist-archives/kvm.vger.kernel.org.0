Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8422B7CC2F5
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbjJQMVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbjJQMUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:20:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA773858
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:06:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39H9eGRO014468;
        Tue, 17 Oct 2023 12:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PQu1Gx3604XPWwJFWLFrXCzJCPnBb4DYgY6q8oAQ6oQ=;
 b=rrd7uqb+dwrw1Kposi1rqGdoAqEXDU4oW/5INndLwnXPLxrLChnzyqbVR87nToWLYtpH
 a7YP7Su2IAZ1GmyKnIUdM3MtZAIIi4syHH4HelXV4eerhvOOG311T50tK3ZYy46HSC0g
 6E0/9EJtxF9Ak1pBhRrDDRZR89jTVCqPTlZYewRQiZFpwNrG3fUfbj01fW0k0fOyiPSa
 i8kMDAoCYcXRcOp/HbP4NRqCXyri8lkDqS3rtyBwoUCCk4swneUaJ/0houeQ1rbPV2B6
 Z19je3NICN2LY/95l4ka0OCc2CQBeiPgF5k0se3DzE+uC8LoUUFDrWv0U4rrRo0z8B4P Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu4ysn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 12:06:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HBPeMA040423;
        Tue, 17 Oct 2023 12:06:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfym6yqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 12:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBCedC89hPBxVxsAWIyQI3qweU4qsYN4lSrYsbI8L3m83SCzrj5ahmSf9qdNK3iH9p5GMbj8EnPN8ChqWDpRFnvM3YFQscYPVkvBhcrtZgXKJ3OD91H0tkdOvgaqZxN/BEiX4tcO9lo7C8fyMTtswL7FIi2Cueq8dfhbAwGZ9qv2YE2Ul7xdMvPl1NYBqxeuV2W89SPomTTdnNc5iUxDpKiA5wonF51XFbBAR6YAJCvNvNInK4MIvM0fdeWIqyiCyMMgmDw+IinZPMLg8dFFeGUPKp99aeMgLF8kSKSy4GEXAiYD8lT5ThIwMUcUvyC7slFaw60lntacus9F6pSQ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQu1Gx3604XPWwJFWLFrXCzJCPnBb4DYgY6q8oAQ6oQ=;
 b=d7wkYARxvzlVzrlVh8WQIgcIDE58sbCIBKiQVUYvkf/GbDG/CJDn3k3wuGgKn58NA6EcoHT5JhRIFCy+jR4Xa04xXws33qFpvr3ZOD2ioyrxZmV2ItHTi9X4qsf8wBOU+sCKyEK/ZU9oxERzML8Fe6xbqY+ukBHE8LveqkLkThtillTrdVLwqvsK3rGGWXpagLvj+IlfSBytGlE0qV/LUHuc77LwXsnMwWDhzZtxALDpWzGfjw3xYZ2pUj10J1xEbYr9Jqg9xlGhm9EYkKl2OO2UplCHQuiHO1DcyzAHDsMGWmNXtOMVZfH9Mpk3xdfYoquzNc1iW29uV/6Nk/1EOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQu1Gx3604XPWwJFWLFrXCzJCPnBb4DYgY6q8oAQ6oQ=;
 b=M37EGKooiXUGHxYRkL0Gd6RPFGl8F9z7U6ay6RxLT7PuBSZ8/FHRgMUsaQfZPdpTa6W/wy6UfIOAYIFNl9dctTp81epUt6egoy0+v3ac5HE6L4G4z4RFooRUwoL2fmYmVmCr3LFzkE0Ct3TmueopGkmx35qWWMamv3gU6KbPOwA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB6081.namprd10.prod.outlook.com (2603:10b6:510:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 12:06:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 12:06:18 +0000
Message-ID: <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
Date:   Tue, 17 Oct 2023 13:06:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
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
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
In-Reply-To: <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0094.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::35) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: e2325013-acab-40c5-84db-08dbcf09783b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0cokgDj71vjHn1uynvuoyy3GIL9G+/6Ww1hFJVpDx8kFZNep9EX8332iD352yJc/RzUNj/BTJZY13eeCt+TMnIKT6wQKQwEA3i9G41dc/czDi3Eg/JEcjUMGoJ8GrqS8hJKuEW2MEuoCmM4H9mBb/T2uZLEmQzMZp5kgyDLwKkwVZRacebmZkss0imJSMyeOvOVUTHxYxeJYqMrA8BEy/dx/1KjurCbwx90HIamn/Mk/5gT07flvE8zp1u4CDYgSfHjUu9nJNjFsK4wAy4kDa1X05PrVqmJ1I+CqscbfrFYv+JRE96earSG7A68HWnk2l965zonC6c40X3mUdw0yhQbz6LBMVYrBX9vD484TZuJ+zUgU+MSLUa3Y3/7bjeP+//xaXuv+r0XrvrD6Os3Qudw+kv3c/x3uS/phpazrRrymrZzkHgGcfhyNrhlViqoOFmzUJKAl7hYQUxgs2NzrUDB99oZBQT0CkKpTRvxq58A8AX7nd6N7DbhMcK+LCT72Ji1ZN4lSHdkrtd2zGFdRbxFNAZeMER7USMmaqC4UEhoRNyvrE8XaU1mUYUaMOyg8XYC1mC6OTXVAEeLa4cerFJnh+VcVZOYhonLYBX12ZFtkHLM5aN06c2lb+fPM3LHEqWnmVByNnCNkkcEpRN2bjm5ZYkPZakeqdpX06rAt9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(366004)(396003)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6486002)(478600001)(2616005)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(31696002)(6512007)(26005)(6506007)(2906002)(8936002)(8676002)(4326008)(5660300002)(7416002)(41300700001)(86362001)(36756003)(38100700002)(83380400001)(6666004)(53546011)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzUwS0dDU0ltNjkxSFpSWVBDZi9CRkNzYzQ1aTZkbnF2dWhmQzhMaU16QmhD?=
 =?utf-8?B?aDFXUy9kOXNwQjRKeFlOOGE1RTRGZzdvLzFvd2prUmdCYk9LL2Q4elo5ZW5q?=
 =?utf-8?B?QlY5RWtNSnVmU3R2MW9oZzlQVjR0NGtmWXVOcldnWGVBamk1Z3djeWUwRVVE?=
 =?utf-8?B?R0p5V2gxa3dBdkhsKyswZlNlNFZQblNNZVBESm16U25jU1E0VFFSYlgvQWpq?=
 =?utf-8?B?SktpTlNnem1jRUdUWFpVTTJLb0xoREU2a01qWUU3aE5ITCtWZll1U0lqekxS?=
 =?utf-8?B?SlJNdm9OZnJ3cUFPdDd6RWRtaXNDZDBjUWNMUGVrWHpGRHk4Rk8vbUtFR203?=
 =?utf-8?B?cmllZTBMdmZJT3RkMHhQQm9BeldZNExwd051d3R3UU9JSTYrRjlHUFlYczFl?=
 =?utf-8?B?cVY4VFNZVTlYQ004YmltaGRSaG5HSHZUQU84bEdvT0NvRmdtSVJIZ3RqeUVI?=
 =?utf-8?B?ZkxXNExXL0RDaStlSzdwWnBVZDZGWkJMSGFMR21XV2dESlNWWlo2Q3Mwem43?=
 =?utf-8?B?Mm9ubFFwTDVVaW05Y2pOVUIxeWJDcyt6WHBGK24wUjFZSTlTNG83cnBoRWFF?=
 =?utf-8?B?MjBxbW1qL2tTM1YxV3hSQys2dkRvVzlLTWNSbFU2c3hUMURjZDVDT1NLVVJs?=
 =?utf-8?B?eTl4OVIrWlZpSkp5dGlPakh3VmVPZDV3WEhldERmWE5NcVVRaGdxSnRUdHo5?=
 =?utf-8?B?am1aTHJCa2JlUkF2MzkxNTVQUDAyWkNlS255SFVSWHRNLzluTkw2M0laUTMw?=
 =?utf-8?B?VFhibVlYQ2lndk56eTlmcmIrM0JKRFJvQXoxOEY3VU9MNWxueERhWkdXVFhw?=
 =?utf-8?B?SXEvM2Y5T0NqcWNQV0ZYU1piQ0NpRVlyRFYwNy9ndU1aZTFRTm56M2FvdUNo?=
 =?utf-8?B?dTlqcXU4OFV0b1l1WTYxMHlRSEc1MGxmU29VeVJ0Sm9TSWtMNjBTV3ZjUDNQ?=
 =?utf-8?B?U1hPRUdlWHZGZkc3SDRicGVlb1pKN3RwVEZWaUp3dGpja0RGVUVjTTBlTEVP?=
 =?utf-8?B?ZUYya0tCYkNjeVgyUTdsbE54RmRPTzYxa0l5WjRGSTBXckdWWDRaKzJkT094?=
 =?utf-8?B?bERtdUNPM1dQbEl2NUM4QXdPSXBSYWd0ZzJtRXFrWk5IdlFkTE1rcHIxcW01?=
 =?utf-8?B?WjY0N3hmSmZ5T0JaUjlRMjViZkJFcXhXcUdSRDdvaGw3dXZ6Rzd6NHp4RS9r?=
 =?utf-8?B?QzRKN01sa1BZSS9sb3RqVnYvME9ubW9sclplNzFmUzA2VUpUd1FmbWJCeDMv?=
 =?utf-8?B?K2Y3NWlDYk1zNEZSNlUwc3F4YmJGT3BHYjNqd3VadEpNK3hZbHFUd1hrRmZO?=
 =?utf-8?B?SWFQdlA0WDJJZ1MvcWRVd2drMlRReWdSMStwK1ZtZFlLQ0NERDdzeFRhNUNC?=
 =?utf-8?B?ZzhuOTBvYi9qSCtVMk9ENGZyRWx0V2J1ZHkrTzFGUHhablVIRS9mQ3hFb0I1?=
 =?utf-8?B?ak01WlloRGNWUm1NK0s0SVBJSHNzdmhhQjVEakZqS0Vyb0JPSFdEM2k3dk5E?=
 =?utf-8?B?WHkxcHhTTkFGZ2dNWFNaeDZnN1JNck01ejN0ckhWc2Z6eDdDdDB6Q0UvalYr?=
 =?utf-8?B?S2VYcUpKU1h6aG5HNWw1T09sU01aeW9WMnl1NGJLOWZ0bVZzVHZRQ3lMUUt0?=
 =?utf-8?B?ZkJQOHF3UjNnWXpuVFduQTNrRC9pazJzVkZTM1V0RFFTd2trdzl6MmV5dXM0?=
 =?utf-8?B?Q1k0Rzd4RkdTNHFwTnYzaHZYanF1NjZZamY1WVV6T1RNKzl6cndGNEU3Yko3?=
 =?utf-8?B?SHh5d2lCc3RFSkc3V3dTZWZnSFU0V1BnbFNmOW9DUHZEYmZlVU4vQkFRZUhz?=
 =?utf-8?B?cXBFbnZhV0hxa291bWhuWGFlRUtSSjVmdkVyL2hGVk0vZVRHeFlTYVM3T0dJ?=
 =?utf-8?B?RVdsUnltTUZYcGkwNERxQlpsS3MxMGZTRnU2SDk5cjJONTVKRnNiWWpDWFln?=
 =?utf-8?B?ZnpuQkU5RDlscUw3U2RQaUVMeDdnUXNwbVlFMnI5U0NqM21yQVdKcmRWbVgx?=
 =?utf-8?B?QytkU1JyUVFLYlV4UHN4UFlVMW5OdW5NWm5LNitNMVRGMGRXYmRablRMUk1v?=
 =?utf-8?B?NXkvMXR0c2laSCt2akcxdWxUM04xY3RyYXF3OFpQc2g1cmNrUkVyUlZlKzBp?=
 =?utf-8?B?WWhnekhHUmhUQ2N2ZmtYRDhGQTcwRjJWYk5mNDNZVGNBNEw4eEoyUTRXR1F5?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?czAzWHc3NEc5Qk9KektNYWlZSVcvVnZueVEveWkxMlp6ckJKWnoxSWtUVU1z?=
 =?utf-8?B?Y2dtKzFZa2oyS3BoUXBkQXVxZ28xbG1uNUp6cnBPOHZkOWk4ekIvTUlmcjZV?=
 =?utf-8?B?ZHBrbjNqZFA4cjdqRkwzQjJBcjRNT3VYZnp0eEVWOTRzT1NFRW82MDhEaFJV?=
 =?utf-8?B?YnppZkNwc0h4VEdnQWdidS9Cakt4OFBUSlZPZXFmQURtTXpJRG5IVUM0TmlW?=
 =?utf-8?B?dk9zR21VMk52WFBSY0N0aGQvNy9JM3h6V0pTZ2VrTEtwSW1ZUVkwVkNnMWZl?=
 =?utf-8?B?ZmFybHVBc2tyVkpHWURDZnZHZjZZaWVIVHBoNGN5MmgzOGQxS2Y2a25nVVEw?=
 =?utf-8?B?WHZRSlIyb2JZK0EwSDY4UjZMSmk4Sm81eElZYUtkZDRVK2lwWjNQVDQwbzFv?=
 =?utf-8?B?bDh5bk9WN1FNRFdRWEgvQ0dxYWh0UkhhWlptdzhBMm1kMXRUMmpuVUdqaXJm?=
 =?utf-8?B?T1ZzbzI4djRCWnB4YWtqSmNFSFJDcUVLejl6V25xSHlXUjJJNGFTQS9DdWFE?=
 =?utf-8?B?TklHZzhUMTZnQ2xVRlBmSmp4MVljcmp6aVc1c2wxdUJHbE40MFFZQVgvTW5P?=
 =?utf-8?B?Wm0rNnM1UC9HQldQL3lDMklUN3VLbWdGbkw2T20wTE5xd3N0UXlPcE81UkJT?=
 =?utf-8?B?RTh3cEk1L3JaNXliQmNuM2ZySEliMHB1ek5OV0dKSFU4azdMaFhGWEkzNldj?=
 =?utf-8?B?bEo4MUh1WmNJZTZNOTRuVjcxNjMya3dLWXZpTkQ2RDZobmF6RHBxemV1MnlS?=
 =?utf-8?B?Z0RXV01aSGdIOWJEa1hHbktPazhYZnI3REVCbTZSbjZoeDhjNDhEY3Y5Tk91?=
 =?utf-8?B?N29Pb2ZiQXBsWHE2SVdYRVVWeDhSaUVKT25iMGJiOW9DNGJrUFJqbUozWmZI?=
 =?utf-8?B?b0w5RjRyV05Vd2lQL3gvandLSTR4c3FEWlJSQ3hROFdBNW5jd1NaVEN1ZEJO?=
 =?utf-8?B?YkFYaDc2d2dNVVlBaWNQMkR1Y3pNZmwyWjczRmVhRXg4enNHTXNtRlF1Y2px?=
 =?utf-8?B?aFlQZU82Q1RJWTRCR2ltS2pOLyttanFZTVVxZzJIS3lWSW1UanRlUFVFUnho?=
 =?utf-8?B?Y0JuYUxnTGcrakRRUlZhN0RLOG92VFdpd3BaWjBMQytzS3R6UVVJdVBWLzdh?=
 =?utf-8?B?ZEZTUmFuQjVLR0NXSGtpUW51K2VCTkxTMVR2QmJUTVJETXFFZmQvOW9Kb0w1?=
 =?utf-8?B?S2p3YzJ6QkQzVUhOVWk2UG8xN1ZDTzFPR2cwYWxrUjRBYStEaDJxa0Y1QkRi?=
 =?utf-8?B?QzdsdVNzQUZCbWdFSGNGdnVxbnRNdEQyUWw0R2Y4eHdWc0xFRUR0TzJ5TUhT?=
 =?utf-8?B?L0R6OGpJNGp4N2FUV3RaRXIrZC93MU56UTR1TmVTbW5YWEdTWFBFczFnU1Rj?=
 =?utf-8?B?NmdCeldoYWUwdE9TS1Y2enJhOENmN1oxUksxYy90RXpNMUdTTnIvSDM4VFBC?=
 =?utf-8?Q?k8NVeHf8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2325013-acab-40c5-84db-08dbcf09783b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 12:06:18.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5RIw8IHgW2kvEH32A0xCSDBgnMTtqmyMiclatjuGTCXyZwlHTsp6NWc8pcyowMK5/VqXJOjfM/nyb16yXXCtNu5owQU0Ndem7EIav/37n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6081
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=944 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170101
X-Proofpoint-GUID: PmBY3CyvssXO5UcfJPYOFfFkXqwO-VyT
X-Proofpoint-ORIG-GUID: PmBY3CyvssXO5UcfJPYOFfFkXqwO-VyT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2023 02:40, Joao Martins wrote:
> On 23/09/2023 02:24, Joao Martins wrote:
>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
>> +				   struct iommu_domain *domain,
>> +				   unsigned long flags,
>> +				   struct iommufd_dirty_data *bitmap)
>> +{
>> +	unsigned long last_iova, iova = bitmap->iova;
>> +	unsigned long length = bitmap->length;
>> +	int ret = -EOPNOTSUPP;
>> +
>> +	if ((iova & (iopt->iova_alignment - 1)))
>> +		return -EINVAL;
>> +
>> +	if (check_add_overflow(iova, length - 1, &last_iova))
>> +		return -EOVERFLOW;
>> +
>> +	down_read(&iopt->iova_rwsem);
>> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
>> +	up_read(&iopt->iova_rwsem);
>> +	return ret;
>> +}
> 
> I need to call out that a mistake I made, noticed while submitting. I should be
> walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
> area::pages. So this is a comment I have to fix for next version. 

Below is how I fixed it.

Essentially the thinking being that the user passes either an mapped IOVA area
it mapped *or* a subset of a mapped IOVA area. This should also allow the
possibility of having multiple threads read dirties from huge IOVA area splitted
in different chunks (in the case it gets splitted into lowest level).

diff --git a/drivers/iommu/iommufd/io_pagetable.c
b/drivers/iommu/iommufd/io_pagetable.c
index 5a35885aef04..991c57458725 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -473,7 +473,9 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 {
        unsigned long last_iova, iova = bitmap->iova;
        unsigned long length = bitmap->length;
-       int ret = -EOPNOTSUPP;
+       struct iopt_area *area;
+       bool found = false;
+       int ret = -EINVAL;

        if ((iova & (iopt->iova_alignment - 1)))
                return -EINVAL;
@@ -482,7 +484,22 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
                return -EOVERFLOW;

        down_read(&iopt->iova_rwsem);
-       ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
+
+       /* Find the portion of IOVA space belonging to area */
+       while ((area = iopt_area_iter_first(iopt, iova, last_iova))) {
+               unsigned long area_last = iopt_area_last_iova(area);
+               unsigned long area_first = iopt_area_iova(area);
+
+               if (!area->pages)
+                       continue;
+
+               found = (iova >= area_first && last_iova <= area_last);
+               if (found)
+                       break;
+       }
+
+       if (found)
+               ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
        up_read(&iopt->iova_rwsem);

        return ret;
