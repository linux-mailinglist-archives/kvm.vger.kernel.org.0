Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C37C8C58
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjJMRc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjJMRc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:32:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C09BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:32:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGaDQ3032215;
        Fri, 13 Oct 2023 17:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XD2Ugv8jXd+nzS+sKf58/XwUpMFm6dvXhqK+F9+pb28=;
 b=yeKfu1ZW8atW88odp46ix0PjJ6yKd7CxY1/5iWt6c+bkrvNJXQ20OfWt8Mm0cte4+CGP
 ipzj6Sq8UNjFeT9OlGft/WOC+8ExVIWLpkx7q98nuYqxJaNEyfv32ICK/EktVQzA4rvx
 LVfxgWOL0JxWnLhdVXK2BW8LsmBOBEyYoPzUuFeqdKmNJTxUMHeDri+g1Kcm7UTxB666
 6kn52ek8pA6GFW+3R8Vj4q7bD49oiygNYmiBfTTi/rfbx8I7vkgmcSSs9zRMSQh6sZFP
 K2iCh3LvPViMuj+MTvxpD5zK2brNm1IoHnGBP0xkjLvTELONcG1Qd67+0Rz4XcWU2cTR sg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjyvuwgf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:32:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DH0xY9006017;
        Fri, 13 Oct 2023 17:32:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcsp6ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DY8EsP9G8JVCxwL+rEIHY+wWNH6Ro5Wo4M6tf8U+Ufk1DjPGqw4v7G7VGqM/k4vROeW9NqrlzeF2lVyAGqiN8WGlUSUpqa7YlPY1sISDzqsDc5lr5Bq9Zi3Enw1vAa4YYRh8s8dvmBECcO/zjJJu61Eo5OKKbdxhc7mNXo7fvJyATfEJElO1DbtCxMm3HxIz27MZJF0eFJETjDUUrkiFeIE3v4hg5BUJUeX/DOIFDraI8CCEbimAkFNeTskzLpQwe/YoD9AtYM1ilMnBKRjrwqOmZEOQ0jJPQtAevws/I3r7XFIIFuBbddawJ1jwubjVjf61bqVpCRuB6oa30bEVCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XD2Ugv8jXd+nzS+sKf58/XwUpMFm6dvXhqK+F9+pb28=;
 b=aZmx24zGFw/lQnlwYeSWNzs1Tao/+ehcqo5W2WZBcVabuBRi88LHv1MYitU0wOUSaQxRlSewqaGKIF9wC+SDRjkjx4fhsZWop2NQyOTwpLX9mheZSkh0oipC4KjsC8HPptbQlNmYclBNmiUyBzsUCIxrXbtNmRsz8bFjHcyBCPc12Blg/otTv1fn6a2TgvBEQg80KO5u59ngHNGkDtrtd8cLBfBbPuXCz/SjUk35kGFvqkbmVHkKoEobV/k6EtNoFzGw/H/3xDYbsWCIDNJ4tbrSLdZaIjN+vmZm3bAo5f2W+FHS5DRtuqaE/8KyYCIAm3B6XpPqTywtQGQPfWC84g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XD2Ugv8jXd+nzS+sKf58/XwUpMFm6dvXhqK+F9+pb28=;
 b=AR04w1BaEwwigwxT2ozOCYct52i+UHiY9av3xovQ7VKs+jPXR9mrJEOGEuOsPmWqgJTVaxvcjvtWrqsdPU6Di+cyGUHFTe17foScq5TPG7rhgt2bPny6jxL/vZ2MufnAp/UJU3Uod3qjAs/CGg1XN4w6VE9LT4T/DYPoYXbJzts=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 17:32:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 17:32:22 +0000
Message-ID: <93829a87-26dc-4830-b2e7-02c025008c36@oracle.com>
Date:   Fri, 13 Oct 2023 18:32:15 +0100
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
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013172849.GJ3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013172849.GJ3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::12) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BY5PR10MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ffc426-e60e-4794-8cd7-08dbcc125b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3M7s0ttPJY4FWP9D2Cqq5obGJJ2Xy2QAst6YPwSC5HuJIEsl78+cwIMdS4uUz2PJEGAFRh/BIhzMTGhkuZhKuY18qv0nwlFVUQrWEISBitCr4okAEllwraazES8R9fjby2pywNQ9STviS54t0Ic+/Mk1xWhg0JG8RkmArhWHCpd7Ongz4JBgLBdUOoywA09Vz9/0AY4TMdmFO0WEU00qQKWzLyXwAqmIEvc7XyzqJLzIiLfSEPo8FWRP1/RLkHlhatuLPcayjkmBfQ6SAhH+7Fn9rR6p4X6JYHIdf5BadTlLaCqCDVE/CQD/9RvgovhGkUb4pv8cla1T8Du+1qfK5wjwOWIhgBatpNIDUPbuCxAe2O5sf1wAi+Squ/wuQk4uy3a+D9wgJnbozMYlEfJTKLys5kkunMqkX9pYTdrv8cmblQ5YwZTWOsdEL4Bm5sXR2tVEEGnRZDjkAeBSt1o2dJqvrthX8XWbqA6rtZWQGWmpt7ifObsw0YiyXowhJw8t7SJo/tEGTjp34XfuHEyboo3Xq1hrC7gEeIhkn1jw3OxXM8Or6ajWodXGGiJpYomWAxKS35N2rvPDZf3TlKCofj5Jqx/4BD1SQ4SCaoOBl/xFFhvverTy6wg2eXDjkvHps/eR7sOaO2xRBiRqVIxlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39860400002)(376002)(136003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(6506007)(53546011)(26005)(2616005)(5660300002)(6512007)(6666004)(8936002)(66946007)(4326008)(478600001)(8676002)(7416002)(54906003)(66476007)(6486002)(6916009)(66556008)(316002)(41300700001)(86362001)(38100700002)(36756003)(31696002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG9ubGVzQlUyZjdESGhQeE9ybUJxTEdmSmV2YUQxM3E2ckdlL2JSbkxOQTJY?=
 =?utf-8?B?U01HRytlTkwzdC9XS21MRFJyeFNsUWtDYkt2dkFieUNRY3NGaEhTclVHVFN2?=
 =?utf-8?B?UCs2Ti9VaWJ3VXlKSEVsQ2lUb2Z3RzZ5c2lXWitiMHBYMnh4TC8za0g4dkh5?=
 =?utf-8?B?R09pZW4zd3RMc3REMGVnQUxpdkRjM0pna2NyTzIzMWhEb0JVMkRtUU1OUzRn?=
 =?utf-8?B?cHlJM0ZHL0Q2dTEyZ0dORXpiNlBhcExmQkVvQVJXTDBpNEJiM1BpVDRJMTVo?=
 =?utf-8?B?MGhud3I0N09LVGN6T2FMN2pDWEIyMG9uN3RVajZUdzdzdzBaVWNaamp6K2Vl?=
 =?utf-8?B?bHQ4Vi9vZU56Unl5eFdYelFDYnBsNnJ0RjVnMmtUaGN0Q09TN294KzZQQ1gr?=
 =?utf-8?B?Z0tic1htSVVnVlJjdy8veHZKTUx0bzNHN0hNRWFlTVI4WWtNYWEwTEpFRHJO?=
 =?utf-8?B?ak5Cck9WSEFiUE5ETjFjYnVNNHdYWUFIV3l5L0JTR3hqNzNsbGZjcDBSQnNv?=
 =?utf-8?B?SW4rOVBIYTVXUUd2bEwxMWQyUDE5Q2ZPMXJYYTBjQTk2Wi9kRWkyVGVVNVU2?=
 =?utf-8?B?QkU0eU5VTG1FMm1KN3lhdDdrZXFxMXp2d0pwL3M1aHlBQVJJNW1HelBXRm16?=
 =?utf-8?B?WkUzZWcwSGx0bDRtaWRvZzdjcUFFdEd0UThkMXhXTWYxbWs1WnNuZkttdWM5?=
 =?utf-8?B?UmloWjJtMTB1KzBCdmgxRnF0Tk5HVGdvaFgrR3dRVzBaN2dhcWF0ckVhOXd3?=
 =?utf-8?B?WkNNTGhvUXJPQXpvakhNeHdLNHQrQ01rOGhUR2c3d0Z0bWRYT2M5aHI4dStU?=
 =?utf-8?B?RkQzQ3NXUTduK0ZKckJkalg2WE9OZEo5bENGTHlDL2FESkQvWGpHbzdRZ3ds?=
 =?utf-8?B?MDJzTWE3c3NOUi9xNTNGMWlNUVlrWGNkdGUvWGlsM0doWkpuelNuZmE1VlpL?=
 =?utf-8?B?WlJVRFQwM24wVVVRWmw5c05jUkJGU3JlRzFkK3V1RDQwcURBSUVsdzhtZlVm?=
 =?utf-8?B?Z0xHQWN3YUd1SWI4OWozTjRaN2VETmhJdnZRUTQ3Z1Y0MEVJWjhIRHQ4Q1Jm?=
 =?utf-8?B?cG9iMVk1bm05dHlSTFlMZHkwaWY0Rkhsekd0Sm12SHRuQU5YVHAwL2x2Ymtt?=
 =?utf-8?B?Z3VFZlQ0aTFIVDVHVGhiWE0rYVdkM0xZUk14SmgvNHRLRUhWYkI1SGdCVWt3?=
 =?utf-8?B?WElWSC9adjRZZGU3NktqZVNpNnVKeDByZ0IwZTJGdHplYnN0VElLNmdTUjFr?=
 =?utf-8?B?ZFNxcXExNEcrMW52MWdUdklWRXRpVzlMUUxrL1NOTU1JUjdnNktrdmdjdHNO?=
 =?utf-8?B?U3FaQUV0THhpNE1RdEtiV2hsckhGUmlUSGdkNFlTRnFwTDk3RDRndUJyZWlU?=
 =?utf-8?B?UFhjWDZZZFJuMkxaT1NTMW5NL0JCTmcrdEZQWTM1OVVxQUs4SGhFSDJzY29U?=
 =?utf-8?B?K2FvRys5NkhQTkFaVjVxbVo2TTZid3dRK29oTGsvWUw0K2s5T0k4NC9CZjJw?=
 =?utf-8?B?ZkRUSFhqeXZqQ3dkbzFNQitSRm41c2gxTDBMUzBUZVc0TEFHTFVUYk1zWmtr?=
 =?utf-8?B?allVOVNoOTczNkNYS0hJK0hwazZqZHZkSm9DTmYydFJKMUpJWHltUkJjb3g5?=
 =?utf-8?B?cmQwMVg3dkk4VHNsV2J3elZxbTM2UEQxTE41MFFQSlhSTDRibVpJSm1PQTZh?=
 =?utf-8?B?emhyZWl6U1RuRWQrMUJxTVdXV2ZGREEwWnlYUXhyMGVtMndkSnZVVC9SUGlz?=
 =?utf-8?B?Z3ZrWlkvTDhJdWpJMDVTcTRYZ3hhM05RQUIxTUV2MG93Ulg5VVhYOEJyWlQ1?=
 =?utf-8?B?Nmt4b2x6amdWdXZVMVE2dHdBYnNCZW5hcVdiNUtmOFpheEY2bUdRS2xZeFJh?=
 =?utf-8?B?K3JScjJpdkZ6a2VTWnB1ditLUHdjbC9BK0RzWVE2M1AycGJDL0U0OEdmR2o3?=
 =?utf-8?B?Zm13UkhaaldxK0gvTjdYQTVnMHlTb08xN0doUkpWTURHbDA2ckdHRjRabEtO?=
 =?utf-8?B?UzYwWldmUTJNMUNFN0tGSlp1SVF1bDdhSEoxaUJjYUhKR3hnNWRzNHRUSmRE?=
 =?utf-8?B?TFNsbFh5NzVLZkxQcTd5QU9sR1J2dFczT2pHL01iaXNVV2NOdnkwdlphL1lp?=
 =?utf-8?B?dE5kaDRWdldsOXV4T3B0UlRSSXZFQ09HYnJQSVh4ZE5lWHVMV2RrYWpOSjA3?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bTJ5SjZacHdFeXorVFQvSjdMUWR0cXRQeERwajl3cmZVRGJIWFZPVUFIZklJ?=
 =?utf-8?B?UzBZL09wODR2eDVaUWE3TzlOSU1MQ0p5RFJsTndCZTJ4d3BjQVRBQWxhb3pX?=
 =?utf-8?B?Q3ZURnVLSXQxcWljL3BOUzFKYnlaRHdNU0ZmNXhXY01mcWxHUmN1UDBMQm14?=
 =?utf-8?B?d25DbW03VXhhSXFIKzZMeWFBL0VqeDZCN3lWMWJUTHFvRkc2WVhiWFJaNHJS?=
 =?utf-8?B?S3g0OFg3WUxOdGpMdE5yWGswRUhUWlI4M20xalFMcUR2NUNGaC9UMnA4Ukxa?=
 =?utf-8?B?U2JVaGdsUEw4T2tFdE13Q3Y1SDFPTG0vNnpnRnVSQ0NJMWdWQ0dhUjEySU9C?=
 =?utf-8?B?L2pnam5sMVhpaXROL1dRMVY2M3VKbGtTN1hBaE9UZDVDWG5lNktYSENtL1py?=
 =?utf-8?B?NWN4UStjNWxzejNNbGc5eitSTlZYb2pxeFI4cjhKakpsQ2ZLK1UwMTFpa3dR?=
 =?utf-8?B?MGdidGdIQS9vWEs2UTRxdlgxd2MrdmVWUEMwczVrLytmTTZwR3A1TmJpV1BE?=
 =?utf-8?B?TTE0TkpsTVp0YUtQL1c2elo1bGNJdHhHL0hZSzZQOWZpMVY3ci9VQ3JTTTBI?=
 =?utf-8?B?SUNVZWQxR20rN1c5cmJpZjg1VDJINjdEbnZvaXdSaXdTQmI4VkpjRVZXNURD?=
 =?utf-8?B?MzNSc1hIV1pFb1RKYUI3ZXd2ZHRQc3IzdjlNZlU2dGtlMmljTVh0S3Y4OVV5?=
 =?utf-8?B?cjcycEliT2IvS1VPenpWdmJSOVpRMzVGOUNqeGJicGdkWWpkOTk2bmZGb3Yx?=
 =?utf-8?B?OFFRSmFGZlBXNGNDYkZqN29DVnFQaWRsNTlhZkVxa3R3UkNSdC9KRitWSG44?=
 =?utf-8?B?TDdvVUdTU0luVUo5eVBmR3V4YjlWWG1ENG5aZ0pzNWlzaDJUWFo0ODZOekdB?=
 =?utf-8?B?NnEzMGpOZGN2aWtJR0pzdDcwYzBFY04rVjVhaVg1UjB0VmNjYmd4Wk1rUk5P?=
 =?utf-8?B?TVVUZmEyM2pvQ2w4VkpzOXBlK0g3dUY0L0ZURXB5R0Fab3dVZVVoZ1g0cHlP?=
 =?utf-8?B?dVBnczlJak5UNDBOa2tLRzZMa3JmcFNwc0hOVkhBVWtwYlIvSkdOWkFOUzhp?=
 =?utf-8?B?NnZoMy8rSGFQWCtXNlVIR2ZzT0U0Z1F4QUUvbHlDK2FnVmx0Y2lTMFRYY1hi?=
 =?utf-8?B?N0puaElaWnhQb2VUK29ZdzhZTUdmNTFmUTB2cjBtRkJreFpWUDFiMHNGMHI4?=
 =?utf-8?B?Z2lyTis5L2xTU01QeHphRDlrNDA2aFZWd2JnSjBOQkFrSm5uZG5tUTBrQzZM?=
 =?utf-8?B?dEVUMnRhdnpmTUdBVjRVb3JoRk5nSEV1YWd6WXVIV3g1Q3laNEZtZnlnZW5t?=
 =?utf-8?B?bUtjTk96NjBjZjg2S29UaFRFbURrWUQ0WFpudmRTMUczWTljWFZGYVlLY2FG?=
 =?utf-8?B?bWd6U2swRy9xNFZGV2FOZkIxclRYcVkxYTROd1BWeC9rVXBOM1FKODF2VSto?=
 =?utf-8?Q?4ikh7R5h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ffc426-e60e-4794-8cd7-08dbcc125b6a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:32:22.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL+BftRuifSVE33/MRLgznFsdBDeI4Aph07hjNfeM6d7g7HA4QTqm7tfpc0QYGfVLK89pzJy8NM4i3YDFML+nQ7Oh/iIzwb/EDN0zRkOReU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=818 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130149
X-Proofpoint-ORIG-GUID: z6Fv9COaENrYZKhgwDcalBjGudT8FFx0
X-Proofpoint-GUID: z6Fv9COaENrYZKhgwDcalBjGudT8FFx0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 18:28, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 06:23:09PM +0100, Joao Martins wrote:
>> On 13/10/2023 18:16, Jason Gunthorpe wrote:
>>> On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:
>>>> On 13/10/2023 17:00, Joao Martins wrote:
>>>>> On 13/10/2023 16:48, Jason Gunthorpe wrote:
>>>>>> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
>>>> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
>>>> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
>>>> essentially talking about:
>>>
>>> Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
>>>
>>> vfio_main.c:#include <linux/iova_bitmap.h>
>>> vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
>>> vfio_main.c:    struct iova_bitmap *iter;
>>> vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
>>> vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
>>> vfio_main.c:    iova_bitmap_free(iter);
>>>
>>> And in various vfio device drivers.
>>>
>>> So the various drivers can select IOMMUFD_DRIVER
>>>
>>
>> It isn't so much that type1 requires IOMMUFD, but more that it is used together
>> with the core code that allows the vfio drivers to do migration. So the concern
>> is if we make VFIO core depend on IOMMU that we prevent
>> VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
>> select VFIO_GROUP or VFIO_DEVICE_CDEV but not both
> 
> Doing it as I said is still the right thing.
> 
> If someone has turned on one of the drivers that actually implements
> dirty tracking it will turn on IOMMUFD_DRIVER and that will cause the
> supporting core code to compile in the support functions.
> 

Yeap. And as long as CONFIG_IOMMUFD_DRIVER does not select/enable CONFIG_IOMMUFD
then we should be fine
