Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9353D7CE931
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjJRUk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjJRUkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:40:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB8F9B
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:40:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IImuu5006126;
        Wed, 18 Oct 2023 20:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MT8r9IE/j2QO8KMFMG6Jop3KQrSkFsHETXKZLIQjDpk=;
 b=oWdizOCIkZ2UWehjvGBqnJmmHgRTPegqkThVzLKBjqchBuh9KSM2beTf5w4KLvF9RE52
 Rdjbl8QqhWSWUXaoSHVFc5N6GouCpPaR/D11U9/odDFzZW0NUdDn4jWvhoMPLdCbZIq6
 GT7KjC1sN+FEsN6ISLrCC+wbIzJ4QmEfvHya8fXmUw0CPjJxYtZTTt/59cbKO+OK7E2m
 bA7kGgnWQtzoaROHC07A/JQXy/DlSDDvz0N1U33S2Egc8RlhgTdMSKfLVxkIleezInXI
 77T7N4h1Q9U1vXgHAIf67JP4+qN+xSHv/GuwZXEozDFZNnXHtB60sV+lG1s77tT5W4IN hw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjyngjm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:40:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IKK0o1040559;
        Wed, 18 Oct 2023 20:40:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfyp9nk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:40:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGJQUKyQK0L6pCEPT4H7EU0138q7iyBYOx0sG7lV04aFfuasjDpFsxjXSdw0VhEy3I+xxxE0mda27Jlbktk5Hu8SS2aD+UGm0SXabeuKFzF60d+eYDGJZNKTQa/ButpiKHEj2c6bBuZMn6+MrMDWiJKfU1j/wEGN6b22wEENCqnv/MiECthBwnBZANiRsK4iWGqHW4a6abiqBRr127BdqbURXu49UBVdk5sejQzNOVKTE9HMwbfCNJgf5F9fltXBQPgSdGZK50y1P8QwxZ3TKPrJVno3nrvJFZpZCe9UUFYzsiLhKr9/xkgIt6ero7PcxMzeen3kfEB7+FZJRN4/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MT8r9IE/j2QO8KMFMG6Jop3KQrSkFsHETXKZLIQjDpk=;
 b=a29wq8Gd3hbuLF/Urn3RVY1Y8fXjk3sINJnHKzJp3hKI6XT/Z8GDdGicmX5GTLq+KqNOCYPHGnT9iM6CzoJ49pA15YrGjh/6EG2y/mbA/g8gpFyEaz7QZ0KG1+zyYotI1Tuybwtr8ZGpZMpLGgoXPy352izIytzcMxKEaXvgSUR6CxUiS5Wi2e/AOichwuIFYX+gGH/om/PWRwprXhQv0BvNwmep8g2wCsweEtK+5Poglg0wukH6b6cwmZ1f20sm8/R60BJ2G8TyoLE0ZlznSFQ2BG/IABjcTzT3HKReNnEGQKUAPo2knMTBDJqRtbnejRSHVmPkDn6vwfu7+7Npeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MT8r9IE/j2QO8KMFMG6Jop3KQrSkFsHETXKZLIQjDpk=;
 b=tgbDmoUs11kRjVupIsxUXRcVb1kU6fIZ0UxMg0IDigXWpI/NAKGsUZDRvvFMa6rpt8Zw/IKiKJCUa28UwbvLP1nhdbzNHuborfagKoABYgwyRdXmaSU2RQbc2O5K5zDcw/yaZQSJTCy/wNjokI4qHXF3SkeNbB06FI1fspy4ljQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 20:40:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 20:40:28 +0000
Message-ID: <889da8be-61a4-4dc8-b779-d977de07bfcd@oracle.com>
Date:   Wed, 18 Oct 2023 21:40:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
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
 <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
In-Reply-To: <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB7240:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fbcc50f-b198-4841-01ad-08dbd01a76ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgDhgeQc2Kukwv4m92PJXS3XlFAfkVNFJiPzXrT9HMa2ytsT7m3wgIWSOorl2IjJEbzWqxXin93pdssNIjb9FWAjHEBuf9HrpxgG5QGe1mKyRaMmWpXze2Z5n7yQ7OfnYNPuCgR/nWH52qsVOxpTiDh2lb1CrbxXg/AAUZ+VkaNB7PqplwG8UM9Z+j2XqCLweoFSU7GJUBjwgw6FYy5XP+bS4JMaWcNmvuRSxgFQq5D7ZWb+PI/m6NA610890eZfdebsp180M0Qp24pnNOGlmFlyHjSdWKHdCN7iDS8vplNlED/Zq2/a2bIPM0KJPwFMT2odE6TtghZIbhTr7e74uR6NSS9+1kEi8hFW1NruPtk/69llfqhHVNJIOjKRWZRjZrUUisEsh13S+D81Km0JFP5MQHmyY2nzJpZ2F3Wb+wWBEIaUzjiwq8cYmGWIifOuiL88AIsvCPnlA4x0tfUc6kBHaMugNwa8CrMlqRBBa3LLAlWXD/SNjG+K5fnfiibUnwgfnh+/Ok39o/BGLjh97SDG+/zvEOjI9GuG+YVJNJoKnw70mUNG80zhqGSR9EA88346INRr5vxCRHm4CNP/uaFr7TPocf3bdKhxV0sirVOTQiKM84yOO16JSmhXZKU4vb5veAMDcuUHCVAuYsXPA2vjyCGGXF9lNovnPXvlQnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(31686004)(36756003)(66946007)(66556008)(54906003)(38100700002)(86362001)(31696002)(26005)(66476007)(6512007)(6506007)(2616005)(53546011)(6666004)(6486002)(478600001)(2906002)(7416002)(4744005)(4326008)(41300700001)(6916009)(316002)(8936002)(8676002)(5660300002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTFVZzV5UEREVmRqMTJYbkpLWDZXemZEakxraEdZZEFEeVY3c2RDdis0OThE?=
 =?utf-8?B?L2VKTXUxMkFpWFNZZ1czdmJ2VjlXOEFpZ1BrNUxkWVM2dytwUy8vWHVRR0F3?=
 =?utf-8?B?VnF4UFpiQi84U2NrN2RJclVQTUZLVFdUaHZscEdaSmJtSTRRNnJHR3NOemRP?=
 =?utf-8?B?MWdMN1o5VlJMSW1OczVCVU5Fc1FVYkxXMWREQU5icStqZHBheVBSWENPNTNE?=
 =?utf-8?B?QzE0SUc1ZDNHRWY0bEQ2SExmanVYV0pvWHI2a0VvUWUvWitQR0UrbmpTSExz?=
 =?utf-8?B?Tkl5eWRJUEd2dEx6OENLSFdnSU9SVGF3RlAxdVhiaW9QelhHOXNrTW1BYlJT?=
 =?utf-8?B?TUY3a0d1cVVKQlBTVEZYQXZaVURnMTErdFRHdTY1VFV2Z3hESWV2RUtyWlNn?=
 =?utf-8?B?TE1xMk14R1R2QURCYU1tdm5uUldrUlVHUXBuVGJEZlZGdHg0WWZnZlJKMU1m?=
 =?utf-8?B?KzZJYkFxQzJqUlVUOE1zMFIwclMwTUVUamNUV0JKQS9mTTZ5Zmpjc1Q2Kyto?=
 =?utf-8?B?QThLWTBuaE5ZMDVCWFJELy9PK3Bvejl6L3YwTEVndWNGRnp6SkZUWjRsdHV5?=
 =?utf-8?B?dkRKSEpTV0czcUtvak9NWDVDZWNIK0ZPWm4vamtlMVo5T3BTWXd5U0VDQTNI?=
 =?utf-8?B?VVhFRTcyQS9oTUZaYk9zNmlCQkJYVWEwd2lDQjd2anF4aVhqb2p2OXNrZVhm?=
 =?utf-8?B?aVpRWVBteHJQVTljQXZISXc4NCtmdnYyc2hWdzRtZW5DQzNrUHp4di9pcmM4?=
 =?utf-8?B?TEZlVng4Y3R6TTQ5UjdDTTI0azRlMGh3OStmZ2hpZEZqZ1UxL29UMnBtZUVN?=
 =?utf-8?B?dGNvdWhkQ3l0akVoNWNDdnNENWJKYXR6S1VRVlkwRGVjL2NCM1o5MkFtK3ZM?=
 =?utf-8?B?bGtUYmZXVWdyUEtWZWlqb3hzdytpeFc3NWJMaHdCUG1XUll3aG5wcXNYYUwz?=
 =?utf-8?B?c3ZhTnhCd3N6TGF3S3NNdFU5Wjk2T1FISkZuRzEvWG8vMm1vdFRKelJXTmM0?=
 =?utf-8?B?c1Z1Tis3b3ZaL2ViZUQ1QmdjK3h2ZmE3d0ROdlhtcXdtdVlzdjZwdkxwUU12?=
 =?utf-8?B?Y2tIdE80UllEb1FqY292Sy9PUnRPamNpQ2Q5MmxUOHZ0NWdVQTZiRWluOFBj?=
 =?utf-8?B?N0hNb0p5eGw0RmtqbTV2dDVBWjRsYlFuU2d6K1lKcGlmczBTd2NKODI5a0xT?=
 =?utf-8?B?NkRaVE9Rd2hxa1hDUlJja20xUUgvZ3o2dXN2OG5ESWFCL1kyc1BSRE83M1R3?=
 =?utf-8?B?Mko5VUpoTHl6OEVRcTRlVDN3MmJWR2crQTlGam1rMnVTbDM4Y25scWJUaStF?=
 =?utf-8?B?S05iUTRiT0hjeTR2YVZVa09EcXFldEc5cTM1WFVET21uUldlaVNlRVdsYzZF?=
 =?utf-8?B?S1E4UmlJQVRJMVprcVlOL08rYVVwUE45eTd4TGltWVdXTUdqOW5RengrREtV?=
 =?utf-8?B?NTE4WmltRnJkaWxBUmtndVdIOExsUjdLbytjckZ3cWtGT3g3d0YxSS9YcmE5?=
 =?utf-8?B?eENFUzh6SE1vbUhvRExrc1kwdldzTUVvMW5PaDF4dG55MFZLMUNEdHRId0tk?=
 =?utf-8?B?a1dqd24ycjlndTFqZUxuZWJzcXFRM1duZGRjd08wSFZ1L3lqc0I4WjhMWFZH?=
 =?utf-8?B?KytWendSOVRLOURVYVhSOHFuZGY3dHZJTXdFMFZSa25JNlhydVdtTVlOb3dy?=
 =?utf-8?B?UVA0d3VUejZnR2pkc2ZyMERNbXJ6Si9pMzdnMk1JdUFOclVPamJXb2RMSy9X?=
 =?utf-8?B?UnZQTEhRd0NHN2h1eGYwKzhXb2Q4ME5xRElBN1lBWUg0ZWdDR1hJN3B0WGhz?=
 =?utf-8?B?R3h2RHQ0R0F2OGdDcytweTBjTmVZalRwUVZBSi9jOVRIWEVyM0hDUjNqRStP?=
 =?utf-8?B?eUhnOFp4bmFWTm5iQmNoR0ZmNmhMZUdQRGVEU3JFVHQvdVFNTERJVXRwL2Vy?=
 =?utf-8?B?K21SRXFTeDgzWlN3cmMrVXZsZmVLL0pMclo1V3hFek5pUGZ6WUpDYmw1S2th?=
 =?utf-8?B?UCtBLzhlTjZxYmRSdVhUOUJsRDQzcmdNZHZySTJQNlZzUThFbXQ5MUNZejhz?=
 =?utf-8?B?cllGU3Y4SlcwWkdWUE9Ud3Z6c3pWdndoZWlEdWRFaUVpZkYvU0VVcFZnUzdM?=
 =?utf-8?B?RnE0MjdzbERiU1F0Y0htUmx4NHhXbS80WGl0M2hMbDYwc1ZXVHVib0VPd2JD?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NEt4Y2gxek8rd3hSYit6N3A0UEpINmFKaTIrYjJ0VXRvZ2VrUmZqcTd6SXFC?=
 =?utf-8?B?NUNIbmY0YnNsNnM2aFV3bWE3UUR6K21HRmsydUY5M21YM04zaUhkc0NXb0Zx?=
 =?utf-8?B?REJlbm5ZaUgwNWtKNUhaeS9wK1NxS2R6Y0pQeTFWYnNHR3BZd1dJU0RlSGZ4?=
 =?utf-8?B?Ykh3WnhDajJqaXJLNTRSWFJmN2t6aVpnNEkrWkg0NFNzai9PR2hHRUxjV0Ft?=
 =?utf-8?B?SzRJU3hqV2dJa3luUHFpaTFOaDFacFl1V3NVcTRpZE5EN1hvOGZpQTk2OGxy?=
 =?utf-8?B?OC9OSXlVUnhsVEhkQk5vQWxTcDlKTUk3M2pYbEFOeEVyWUZROTRsWTlDc1dI?=
 =?utf-8?B?UHRhMml4UUxyYmxnZDBYT2FjVGhqTE1PKzRZN1FoUm1ZRnhSQ2taL0RLZnFE?=
 =?utf-8?B?RXJ2VlJWakhBMkVlTDJ6OTRFSTRzVGFVRTVKNGxsSXluZXhOaU9TY3BYNnZt?=
 =?utf-8?B?NnhYanQvQ0FXdkpBSHpTOWFsN3lQdVkzQU9SYVdQb0haQ3JmSkZLaUxkanl2?=
 =?utf-8?B?MEJpVktzbUpFYXVhYWpoVjBOdTI0ZFh5WHZ3NHJya1ZKYTdTSzJ2ZUdxTWtZ?=
 =?utf-8?B?c1c5bDFtMlZ0MmozaWFWVkRWVUI2c1M0bzludVpGSG5rais4QjY5TkFFQUp5?=
 =?utf-8?B?OXhTbjBaZ1ZSUEdUcXhhd1FSaXRoMzFXNm1YaTJDaENaK0VkZHFhRkNpUlJQ?=
 =?utf-8?B?SUhHZnlLOFUxZU1jTTMzMGRLclpkRG5JTE9WWEtVZmlha1NyV0V0NEp4c0Vq?=
 =?utf-8?B?ZXBtSHNzV0tic1EzOGtZQ2h0WVFrWmVOZCsvNThBMFZIZ2gzb2tWOFRnTU5H?=
 =?utf-8?B?UDVvNVNsN2tlcVFhMXoyMytuZ1BLZVp0TEVkb1ppT3JVMGNFekhQTTZ1aGhl?=
 =?utf-8?B?YldCZFF0YWVMV1dGdWdRYytXcENsOTNyVHJQU3EyUkNXUTltNWhaODhKZC80?=
 =?utf-8?B?T0NqWVhIYmg1NjZOSXJ4em80R1cyTHY4R01FV3RnQjZDYmRCSzhQSmxxaDRn?=
 =?utf-8?B?bjBnbGl5S28wenJUYjZ6OTB5b2g1RE4wZkpGSEVacHo5MTFqK2Njc3hNUGRl?=
 =?utf-8?B?UUdYMUFOZDBoR3NMQ1FEOWorQ25oVmJyRTlwTlhMcGo5TURrd0RDVWgzeU83?=
 =?utf-8?B?UWJLRU5vMTVvaVFGNHhFN0VZbUhDSnQwWDFjU0JpY2sxc3RsaXhvS2sveDFk?=
 =?utf-8?B?RDdQV0UvVkw3Y3hCVC9sNno1blZ6UHlSNEpuMjVXQ204MkVacHgxK2Q5UE9t?=
 =?utf-8?B?Z2lnVlBHZS83dlFvQTI4TG1ReDZjZEl1NWZ2U1RmMHNGU1VIOTZPS2M3T2ZW?=
 =?utf-8?B?OFZvN2pzZ0pPaXVvU3FmeVlHNGNtQm5mOGpUVTlRWWgrajZKd3MzMFBweTNp?=
 =?utf-8?B?M2NVMXJQT2VGZDAwVTBiTlg4WlY3Y2xOamljbjhZTjQrUWRRQjAzV1RPLzJN?=
 =?utf-8?Q?qiVROw8D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fbcc50f-b198-4841-01ad-08dbd01a76ce
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 20:40:28.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SlL8xI/jByx6+DtdvH13KCP+SRPsq/CJQC7CjcKZalTvVv0TBXixOQMpcrgfZZkH/WIcVEH/bM8C4ZvufT/PhHreWU4M5jBE5RxBEUyOTXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310180170
X-Proofpoint-GUID: 7CwxP9HYetYouSdxLDyb_QqGKPUvrrDp
X-Proofpoint-ORIG-GUID: 7CwxP9HYetYouSdxLDyb_QqGKPUvrrDp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 20:03, Joao Martins wrote:
> On 17/10/2023 19:49, Jason Gunthorpe wrote:
>> On Tue, Oct 17, 2023 at 07:32:31PM +0100, Joao Martins wrote:
>> We are fast running out of time though :)
> 
> Yeah, I know :( I am trying to get this out tomorrow

Finally got done; I think I didn't miss anything.

For what is worth: we could also wait until -rc1 if desired or should it need
longer simmering in linux-next. Or in case something is less perfect than it
should be.

Thanks for all the prompt comments!
