Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD57CA629
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 12:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjJPK6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 06:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjJPK6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 06:58:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7C7F7
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 03:58:09 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39G6n0Gh017488;
        Mon, 16 Oct 2023 10:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Z3J6GaZj5vIL1kGe8YCYgpPegQLSuez1pShF8e+woz8=;
 b=3dt6pOz2tOaLN3EWK0R+MmvY491r9GRyyCZ1vMGSMYan0VPHrQ5ZTqLOAVhtyPRuTwex
 0vB5PzPi4pdUTG+YyDe5nTBBeegD3kZbeg3xQKVUraamnAtl1ijsmQKe2YKMMiugesyd
 zi4o11F6RU5/SVVZZuo0Ys1Vdd55iXgw6f9P1XASLuFvYVW9ue9Mfl6WFuQstiFQcrde
 MiWfbaPc0nEgPtDXVQqRqe+Q5f782nxtJb8pDw+GhvYES2A3UK5B4WAONHQpyeLZIvUA
 ggAp19eN1W3m5qIW03kUjic3UmzPpcZFSJAeFlExMhrSTu8qy6MkauDItWbDgW0X9VTo fA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28jf7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 10:57:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39G9HPXU028611;
        Mon, 16 Oct 2023 10:57:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy204p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 10:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGEFWVXKiK4zq/MkQEc6a+MuZuTCjinqvjsRrLprCxddAetqqspE31gPJZBdXRfLW17Fc78Wc1d6ZWrzZ/itrszmG9oTe/r3C/mNuTh0NXx1hzjCM7LWpgQGKzwEl0YyWbmfOL4+OpNRRR6KjNehjbzYd3B9RxdELl5OvBJLEIyAPDodfBj2ztbWJq40GCT3hCmhefz+l2vJHbPSvdKxNrHFkZ/Ozlk0QmHMxtbPtjPoCbgJ9GWCoiuHrXkrGRIyfoHeMnoi0Gob54IXACkgXFnAR06c6U5vszanH8VMd1szTLOfMX9oNMw3f4ZtVmUezc18RbzAcRroekmYiiyXVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3J6GaZj5vIL1kGe8YCYgpPegQLSuez1pShF8e+woz8=;
 b=hfYYZ3P3KB5+7U7GmdBFDsj60A+aACA8b0i1rhfIllKiXcWYfrQLQ4OqIZbr2CsjwUTshu2IOHr3ZeOFtafpwxkGLOb+GDvXjH7bLZu3nTHtknx7++JMU4Q1iiL13E4avPdR636hATilEDnqidCdjChzurWjwSTa0nV8E9YUNnA6qPX2dL5vvz352m3fjGTwYGXOFxQty125XEB64wZoZ08EwhWz+2Axo+zo9UFpRNXmQrdGiJJJrI3SumFEoPk1+eLjEg0Ps77WsEXxT6/Cs0CA6j27Fw8TVgA5e8yiFc3EBCRXRgsypZonWahtfg1Kv1YSvSOpZiHDUWEfmMHPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3J6GaZj5vIL1kGe8YCYgpPegQLSuez1pShF8e+woz8=;
 b=iiGxNcNTK40WyA0jH4QIiF+JiuwuwrXivUvX19mSTWehvR3xt7pvE/Bo1Lt5UZsOB+Ic1d6Oc1ueifbc2xX7FcwaIdnbr7SQhqlpeM42tpE3IYDQbZfHKc/sCwcIkb2WBc8BcFwCZveykpbe0SuVv4ZNjPjXzx0bfg5oTJfmbTM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Mon, 16 Oct
 2023 10:57:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 10:57:41 +0000
Message-ID: <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
Date:   Mon, 16 Oct 2023 11:57:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0647.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a78808-e99b-47d6-2feb-08dbce36b80d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcfP0mxVvBoWkjIOfg98zzqZc+Ni+5peHNsRILwI/RwANdlxO/8DK5EeUtbJOzvzSRdcD4ukQwV9OSPazdYVb3q4aM6rM8eU/5TVMXJRF/XKw6gfC+gwwjTqZlKif35U8Seeo8Z6C+8qgALSkKSw9Rl0aQyVEPGm56mYxM2fA0HkdgDEJbJHGxk9MQh7gbbVc41DNMaNhGzZZxjEiJdxFRhKJDyk3q3E996OYwA2A2zXsDuawj/KwEEddq81yeVAgy9e/AGk3yGtN7z9/ZUsErmTmtfQd5DgYrRpPCiUwrgFVTgoYWZtAjsRDaSKurQ8oNAf2cgThVol1UYVitlgfs1xLGsKRiS1TxQk3L303t5l9fB1v5g6nl4eDtUO1bGmCDkso7FM19cWzzXdhh1sPUygAa6cPqCDr1YNyoTrrqgTVbZdl37PqhEmEeLtxG4owdxQ2WmQtiWuJuJ2crMz0Zc52I8whpXBODcMuLHZAUTlgNkswi7tu5oGmtk9KA3P1k4a3nNvxqySsv7UNM//fBBKAQLJFajGJatVaQCyg+srYL/sikRjU3KFhyGHdscA7gjfXOPOcLA0RgiW8tLZHoh0DUoay1TGaNcJw3lDjzMcCUhAfbNuItc0xdrD08KKpYMKp6WqVms4jjRFl29T8EwHwOijfdZmuXPWIrAmmDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(53546011)(8676002)(6512007)(38100700002)(26005)(2616005)(41300700001)(478600001)(8936002)(6486002)(5660300002)(7416002)(4326008)(31696002)(86362001)(66946007)(2906002)(316002)(66556008)(66476007)(36756003)(54906003)(6666004)(6506007)(31686004)(83380400001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2pESWJRb0VvMUtVNHJIR24zOHJ4YytSR0VGNGhMd3lsZFREUlBDWS9pZisy?=
 =?utf-8?B?MTYrU21xOFg3Sm5jbGtXNGtVeU9tZS9EMnRyVGNmZ0JYTXlZWDZSNE1leVNH?=
 =?utf-8?B?djhwOW9sUDIwaEpUZ3Ira0JWTENweERqRjA0dE5ObkZyeUgxS2ZYelhoUjI5?=
 =?utf-8?B?eTkyVVFCMS9icWpOWnhZZTY1SWRSVkVaOWVJNzlpUXZKSllXajJvdEV3cUMr?=
 =?utf-8?B?WFVRcGhZK2MwV1diR0IyelNIbThMRjNEeVFVVVB4YnVGQkNsUjhjY1FxQjZy?=
 =?utf-8?B?eFYxZFpwbWFJR1I5Sk1sT2lxUzNiSCtoZVBtL2VyczhYTnU4cGZWSU14b1dZ?=
 =?utf-8?B?TEhZR3FHQngvRWtYbUhGNVZkMTNta1hLRUFMRXdqZDZyMUpyOTVmOHFvLy9U?=
 =?utf-8?B?QXY1YWhBYklDMmJ0Z1I3Syt4Wmg0czdpV2J1V0o2ZXNkeFNUTkwvU0ovZFZv?=
 =?utf-8?B?UjFKY0l3NCtyRGFweVczZkV1TDlQa0MrNXdoUDZjR0RWcFFsQ0toTm5OU00x?=
 =?utf-8?B?a1o0VDYyQ2ZNL3luRk9UK0twVEp5dmJpUEs3cExPNnBHL3RwRFl3V1BNK2Y2?=
 =?utf-8?B?cDBzc1UxeHh3ZkR5WTRTR0hnMDdOUU84Ujl6ZXhhRDdzajN3SkZ0Z2NyaDk3?=
 =?utf-8?B?cDBDeUNDVlhMWGl1bGd0c3FuWGx0WFN1QTRMM1B5SElabTRsQ0U0bjl5Yzdj?=
 =?utf-8?B?eHJONUpDbTNZRG1BNmpnWnV3UTJpL1FZZkhMSStNcW9YT1JBbSt4c21sQnh1?=
 =?utf-8?B?RGJHLzQ0N1VPZisyRktXcHNia09MWnNTRE5EV2NwZkxGNFU2a0tPUi9iZ1ZD?=
 =?utf-8?B?MjBjT01ESXFMSGIvWWRiSnJoeXVyVzdrVzk4a1RPeE1QTDAvTVpCejZtYTZB?=
 =?utf-8?B?bnVLRis2eFgwTHRudDl3d3hPMGxxQVpFUFp4Mm5yZ3dQZVFpSEJ6TW9vVzd5?=
 =?utf-8?B?MDE2SDBKY0RlK0l4TWZSSHAxU0lhNUw2U05GeTNNc2tTRlFQMHZQM1NvNXIr?=
 =?utf-8?B?WWkySEx1b0FBMXo0a1dYRHg0OVp1U2dNWlJyb0RsZFhlZ3RWY3ltbmYyZEsr?=
 =?utf-8?B?UVZNYUpBd3V4Sm5nK1pQZlhKZVNiczZjYml0Q01BUHlSZUk0Q2srcThkKzh5?=
 =?utf-8?B?WThLT1ZFRzcvZXU5UzRsMHRCMjczWitMZ0RqYmVLVE16Y0RHamxVanNtbVAz?=
 =?utf-8?B?RXRHR2l3OFQvbkRYMjBLbFVwcjVUOUdzWS9XaG5YUFNKMzd6QWNXTzArL3Zm?=
 =?utf-8?B?d2JpZEs1SnNSS3V6cmdoK3IxVHVWVkRkSG9iMjcyQVdPYm0zWGREZ2NwR1RZ?=
 =?utf-8?B?Y2Q4SlVuSW91ZU1oUmYxcmZwTlN0S29WV2Q1TVNGWTlQcDBIU0pqTlZ1NFZz?=
 =?utf-8?B?ZjRualhQYS9zbHI3dCtrcU9sMTRkYThXTmFDVnJ2SDZhRWFyKzRobVRDL0tW?=
 =?utf-8?B?T3FyOXVaRHljOHh3UXZQdFV2aVJsOWlPVXJaZXhmLzhYVW1sWWNPU1h3VzRE?=
 =?utf-8?B?MEE2bXpzMjQxeVprSjZHaVF0NnRkMjI5T0tRcmJqMXRNTS8xNk5KM29iVVVD?=
 =?utf-8?B?R2hPR2d2c05YVm5YMXlrRk5aOVF6NUw1RHVyYUFWVHZraTZjNUxwa1BBQS9o?=
 =?utf-8?B?cnIycFJhSzlsL0lTWldaK3B3bExLcEszZUxYT2lIbFZLWExlaFBWTVd1T0Nh?=
 =?utf-8?B?RHZHczlmcUJUUThBYUJrNkc5eUF6Z0xXeFFqMTJCUWZPVzlYUkRnSjJmbWcw?=
 =?utf-8?B?RkZpNncwVGh3ZUErMFNiQ3hlMkJYTDZGSk1nTW90ekhRbDZWbkNkaStBdDZX?=
 =?utf-8?B?a2twUDYxS00zOGY5TFh1b3IzU3RpNm0rbFczYXV4QWxjaktkSDlWVGE4amsv?=
 =?utf-8?B?MEg0TDljaS9zM1lRRnhndEJrQWwzMFN6R3BOZy96a2xWS0h2UXNnWFcvUWgv?=
 =?utf-8?B?RFdZTFNnNXpLT0xoYUpvU0VFVE9Ic21zR1R6WmluQUJaeEpYbTFNOWxFcUVQ?=
 =?utf-8?B?YWNGbEtoQ2ZXNFNXMytSV3dMbFcvRkJxUzFUWms5TEFaWUVUdWU5aUJjK0ty?=
 =?utf-8?B?SWdCYktrdzZqbmdNUlhzd3B2SGFiQ01WVm95NExXNkR0TmpQaG1rZlU4QWlt?=
 =?utf-8?B?ODhoeUY5Q3BscStWb05ZRnlQYjRvKy9UU25tNjZSejJ5RlFEK0hVYTRENlZj?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?U2h3alFGK3JQNU5rZXlETHJtODJpUTBjZmt3L1Q0YlllRXV3M1Uzc0t0WGVO?=
 =?utf-8?B?czRCd3lTeWVYN2lKVnNRMTRsSjdCdDBZZFJudHBNbUpBcG80T1pBRzhhNUVx?=
 =?utf-8?B?cktZVVNtTjdIVFBKVklXRUhFNkJ2amJLa1J1U241YVdJTHhTYUlTMzJrdDBn?=
 =?utf-8?B?ajZOSDNqM21kczZidTJmRUpnVy9RTjU3T3oyWFMyS293ZnJRdWVMMWFPU1Vi?=
 =?utf-8?B?Y3B4Vi9vSlJhc2ZrSHNEa3lsQ2QzVDIvZ1Fnb2FDSzI2QVJqSk0wdWxLRlI1?=
 =?utf-8?B?WjJScFFoRkJ1QkhwZWhlZG05SnAvcUFOemNzRUlMV01DUXhQTEh4VEt1TCsz?=
 =?utf-8?B?RE83RmcxSzZSQWxoOHg4SkNRbHNSZ3FPUHVTR0FtOWZZWDVqWHZ0Ty9xZDBu?=
 =?utf-8?B?RFB5U25vWnpuL2ZXbForNEo0WDlSekNrZlhuYmVyaFZLanp5dGJSaXRnREt1?=
 =?utf-8?B?RlZyOEhsM01Qa2FidE0xZTE4ZUZuNXIyNnFqZ2R5VnZqYWVHNnNyMlhZR0JB?=
 =?utf-8?B?OFFQL1pSdWwzUlcyN1lvMllvOEloaUNPM0N4aHNmOGo5R0pPL3lob1NINlk1?=
 =?utf-8?B?NVJQQ0RBTnBqOHdqY1Irc1NKQzNLUnBhS0FWcDhkcWhSZEZHQUVQb3pEYms2?=
 =?utf-8?B?bVF2Y2wzdVE5YTc2SzlCeUhZWGdac2FCZ0xUVmVRS3JPZTVOeWxQQjd6WkVM?=
 =?utf-8?B?RDZ0Y1lwY014K3lzSXRWaUprS083Z0ZUQmRmYmdFZ1RFT2RNbk1uc3AyOXo4?=
 =?utf-8?B?NW1CcS95R00zbXdJYVp3bGs2Q0xZcXR0cm56b1RvanF2akFocmpRSktLTHQ5?=
 =?utf-8?B?UDZSMlpjcDJ1MWpJYjV3cUh4aXFkWTJXM25lM1Vhc0JRVEhNYW1Ya3I4Q2ZE?=
 =?utf-8?B?bHE0MVZSYjJub0RIQkozeGF1bWZ0SnJscVdvUlR3bXhmdHN5eVkrL2xtOTRS?=
 =?utf-8?B?dDR6bkc1SjRmOGNmbEM0SnZ1dzR6Yitud3FVTHF2OTdDeCt2TGVMbnVHWk0x?=
 =?utf-8?B?Vmw3SGpQYW5FNDFRUmttTExtMSswc3ZSOUlzVjhXMjcyTU9raGQzZXZuUzRx?=
 =?utf-8?B?dlViVTVpWlBCa3dWZnc5emhlY2tQVnF6NE1DYzh3THdEODlsa2RVbHF5aFNH?=
 =?utf-8?B?V3hzcjBnR0VkY0dIRnpsb0VTNVV0TThqVjBkMGdWUDhFRExGMjBmY1NmUEwv?=
 =?utf-8?B?MlRLYlRqMnN0TFFwWXZTYTFUeHNXa2l6TXEyZWJtZ3BZbHNkMnI2STZsSmRB?=
 =?utf-8?B?VXlGVlBmZmhjelBsRjdud280L2JvaVBrclpFZ2FQZVBUekxrdWtWeWdVT3Q3?=
 =?utf-8?B?ZDVhZWJRZFRnN0lQZG5NejBidWxqQjZTOEt3Z3U4WHl5UlNCUGd2MnNIMDMv?=
 =?utf-8?B?OUxuditIdjBocnBMN2xFQmV2dEJ5NTBoRXdOV0RvZ2ZCdG9jaVdVRVRlVG5V?=
 =?utf-8?Q?eVEZJu7U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a78808-e99b-47d6-2feb-08dbce36b80d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 10:57:41.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iB64BELzNw16LoOdzkuuSCv/RabXEwG+Qj7NezDQGuUTrm6EOUKU9TVLAY3SYsjRrFGvxttHmWzStXF0U3bmmWxg8m1XemuFohWxwmYfQ+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_03,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160095
X-Proofpoint-ORIG-GUID: QupvxFLmaU_Vfnu4p2QhTSLnqskH4ODE
X-Proofpoint-GUID: QupvxFLmaU_Vfnu4p2QhTSLnqskH4ODE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 02:37, Baolu Lu wrote:
> On 9/23/23 9:25 AM, Joao Martins wrote:
> [...]
>>   +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +                      bool enable)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    struct device_domain_info *info;
>> +    int ret = -EINVAL;
>> +
>> +    spin_lock(&dmar_domain->lock);
>> +    if (!(dmar_domain->dirty_tracking ^ enable) ||
> 
> Just out of curiosity, can we simply write
> 
> dmar_domain->dirty_tracking == enable
> 
> instead? I am not sure whether the compiler will be happy with this.
> 

Part of the check above, was just trying to avoid same-state transitions. the
above you wrote should work (...)

>> +        list_empty(&dmar_domain->devices)) {
> 
 list_for_each_entry is no op if list is empty, so no need to check it.
> 

Though this is unnecessary yes.

>> +        spin_unlock(&dmar_domain->lock);
>> +        return 0;
>> +    }
>> +
>> +    list_for_each_entry(info, &dmar_domain->devices, link) {
>> +        /* First-level page table always enables dirty bit*/
>> +        if (dmar_domain->use_first_level) {
> 
> Since we leave out domain->use_first_level in the user_domain_alloc
> function, we no longer need to check it here.
> 
>> +            ret = 0;
>> +            break;
>> +        }
>> +
>> +        ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
>> +                             info->dev, IOMMU_NO_PASID,
>> +                             enable);
>> +        if (ret)
>> +            break;
> 
> We need to unwind to the previous status here. We cannot leave some
> devices with status @enable while others do not.
>
Ugh, yes

>> +
>> +    }
> 
> The VT-d driver also support attaching domain to a pasid of a device. We
> also need to enable dirty tracking on those devices.
> 
True. But to be honest, I thought we weren't quite there yet in PASID support
from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
impression? From the code below, it clearly looks the driver does.

>> +
>> +    if (!ret)
>> +        dmar_domain->dirty_tracking = enable;
>> +    spin_unlock(&dmar_domain->lock);
>> +
>> +    return ret;
>> +}
> 
> I have made some changes to the code based on my above comments. Please
> let me know what you think.
> 

Looks great; thanks a lot for these changes!

> static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>                                           bool enable)
> {
>         struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>         struct dev_pasid_info *dev_pasid;
>         struct device_domain_info *info;
>         int ret;
> 
>         spin_lock(&dmar_domain->lock);
>         if (!(dmar_domain->dirty_tracking ^ enable))
>                 goto out_unlock;
> 
>         list_for_each_entry(info, &dmar_domain->devices, link) {
>                 ret = intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
>                                                        info->dev, IOMMU_NO_PASID,
>                                                        enable);
>                 if (ret)
>                         goto err_unwind;
>         }
> 
>         list_for_each_entry(dev_pasid, &dmar_domain->dev_pasids, link_domain) {
>                 info = dev_iommu_priv_get(dev_pasid->dev);
>                 ret = intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
>                                                        info->dev, dev_pasid->pasid,
>                                                        enable);
>                 if (ret)
>                         goto err_unwind;
>         }
> 
>         dmar_domain->dirty_tracking = enable;
> out_unlock:
>         spin_unlock(&dmar_domain->lock);
> 
>         return 0;
> 
> err_unwind:
>         list_for_each_entry(info, &dmar_domain->devices, link)
>                 intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
> info->dev,
>                                                  IOMMU_NO_PASID,
> 
> dmar_domain->dirty_tracking);
>         list_for_each_entry(dev_pasid, &dmar_domain->dev_pasids, link_domain) {
>                 info = dev_iommu_priv_get(dev_pasid->dev);
>                 intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
>                                                  info->dev, dev_pasid->pasid,
> 
> dmar_domain->dirty_tracking);
>         }
>         spin_unlock(&dmar_domain->lock);
> 
>         return ret;
> }
> 
> Best regards,
> baolu
