Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8937098A0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjESNqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjESNqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:46:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7434AEE
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:46:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCjGVi008945;
        Fri, 19 May 2023 13:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=6QGizm3TL++3OiZvNzop5Df5Xn3PNPUfm/0AJsEytuU=;
 b=kbCTUdvDzkB/ZU2wQDx1IwuEWHu1XUyDfvkxqA4QHYW2fPczuwOdoJRUh974uqXKqzq4
 l0l8Le+1GoRJx151HgCmaNc6xICCD3q5Fdn9VAepO4iJdTdFZdiDYU8wEB91bYl6ZcpR
 EK/ppgN+J21lxKUOBMhQJ2g3VWRPaJci6cgIkmtVtqdmNv5a/5X+QrQFxWmkuvHr0jrD
 NwWm8BmDsrtrMT3cqT9ecMGRFc0ol0mS2gs1FPB+GU8gyXnH41ZbgKBn87td21gPjkad
 /8ISG7htHKU5fkHSy2GpDlQuZCaca1DdduhDNlWTKszMqB1+hwLZtZZ+/4z79zdaRbB5 ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j50ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:46:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCjduJ004154;
        Fri, 19 May 2023 13:46:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10edv64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbaIZnXaAdTO8AP34+JhlUVfkmGKiUEgeSLFooZO9PV6SZLj96Z6jiajC+fiYRz+CaDt2CVHlaV9mjWmJEl50yeQM8RW4An6xgGbLWX21eclOmdzKDkSZobnttU8V71R2LbB/OsDx13yktGGpw2vPgzOqqws0lWw/4JlbhU7tLIJJvyLbCygx48bYVxY7TxkSI+kRTmI+2u14RrZ5jCuepSFqKiG1rixyaj0Cn57tIg8qEUS5QQ+Q6SdAU39Y/40oFQWdLKjT6vcWbzyMWk2QpWANrasKlSc7lld0apbK97MuB5RJU2H9cnG6MZerKTMeAKRkZ0VvNJbZjdIRpHu1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QGizm3TL++3OiZvNzop5Df5Xn3PNPUfm/0AJsEytuU=;
 b=LEWBKL4deDmbm97Vm/3KC6WOXp2b8rfMl4625yAcZ95SQ02AZ3G/HX7NptG2h2qi4BGthtqk7wYY2H+Vw7+B/JWnJzSxhC4Xa9eNLYb1QM8MntzVB5CJ6L5wqxAE0lwfkRHd1D57oU8bez4usEeixZUmR7xOkjXbRwHv1CT+ovqvS6scg+tsi4NMxGqs4pgIdbN+lIdYuRueQ1hiKAU5qE355a3Mf53hrVTq3Q4gK5e154sb8cQl7Gh1Fum2CQZTDCWDV+8G2xrK0VVza8Gemvg7QE/Cr3pGCjxv8ttKX3UV2HEGgKBRnswnyV8yTmvZSJearhhEDLL6CRP1DXMo6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QGizm3TL++3OiZvNzop5Df5Xn3PNPUfm/0AJsEytuU=;
 b=Iseu+CPC/c7B7xsucd5yQcO0EYJQrg7b0YUqw6PrIR3X0nD16bURCOOgHoEL0/gNstT1qJSnW2FTFD53RQFvwLtNW4SBrC7LdQss3l+X8pV2JD8OvgQA8vjlThSqZCnBMs0nSJdoZKDVmoRpwhmGjYDwbxAvQPJotPkWEihbbJk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MW4PR10MB5704.namprd10.prod.outlook.com (2603:10b6:303:18e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:46:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:46:09 +0000
Message-ID: <5f7102d4-4a22-2a21-9f63-9d80d975d7c3@oracle.com>
Date:   Fri, 19 May 2023 14:46:01 +0100
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
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
 <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
 <ZGd5uvINBChBll31@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGd5uvINBChBll31@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:208:1::35) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MW4PR10MB5704:EE_
X-MS-Office365-Filtering-Correlation-Id: ea4c7ee4-3fe7-4aed-ccf5-08db586f66d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jeBPeIc1uIJylBzbQzaU9MIijQhdmb6wki8KKiHx3nE2ljNsK+uIyYBnFFE7OX1g7AQjEIFFAhh32tWobR1J350uo4ES/B6niOBqmYTWvYFoaz66hnG+xSyRqkHDbOgdEjDOmBRF++PcyZ2suLGdtSS9ynaFFCTYlySMXsi/Q0J7ajX16kKRwduLhuVNUP9tuaxfjc3iyOuf6gK9/K6zPCm/kCOSsdwM1EaxIebRXjIqAd1BRbzy4Kl7hcR/MO++mKZCB7RiAJVQtamqMrqSs1JDtL4cijmOlJckVMm5iWWWBkoJFsvm8Zw7UfhI2TtH2aJn7R0i/12vEOGNtdeicWMofLqDOwOMxOzR7N65hUd2ZcGS0D7vsdciFhbjhqEF7OVMzQAmTzWt5CF9uzZI52ukvTDCiICThG0zzwr/Jg6/grfB81OsL1Z4GnzmYl9p6KZcC+7clBx9H8PALMowA9HlbZBIziHSFP2xXMDl4U6wZ39QRzNaYIbbLUUzq0MEUBogLitWKn/XDr59+8aM9O/vcbn+CcWwSXqKxMR+rwVXQn8DZ+YOQFAyzIptkv/EQqLSBgpkHMgs+h5UbCxMMirwj0T3IrBd+WfjCkbWV4BPjtP6POabWZzTmf1FVSqMl7oUHvRVmNwtvYx/ysr0wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199021)(6916009)(36756003)(8936002)(8676002)(5660300002)(7416002)(41300700001)(31686004)(66556008)(316002)(38100700002)(4326008)(31696002)(86362001)(66476007)(66946007)(6666004)(6512007)(6506007)(26005)(186003)(53546011)(2906002)(6486002)(478600001)(2616005)(54906003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STRSSDllMVAwNGhRd0hVbE9GNmtDbFRGaGVKK2Z5WXZVQ3VESHR4QzlPVzVR?=
 =?utf-8?B?Wm1wajVUVjJjWmRhMk5ISndlbXAya1RuMTJNWTg5ajlpL2dMM2Nqbi9ReDc3?=
 =?utf-8?B?VlQ5RXE1ekhuaHdhbGZrMVUzOXJpSmYvZmVzdXVMb0NDOXFZTzZuL2tTaDMr?=
 =?utf-8?B?YlYxWW1Da3NENm1jZUJjVm9hdTdIRjY4a3RrVVJianJ2L09IMHlGNzAyVHpF?=
 =?utf-8?B?Tk51c1dOVWF0L0hNaHpjZzlIWDRMQjJDUkJJT3l4N3pLa2MwOUZvSE51SDNH?=
 =?utf-8?B?ZGVrNE1qWEtweHg1d0ZRQlR2enI0SDAyNDZ6MFJYc0M3T2JoZVhESWMyb0hz?=
 =?utf-8?B?eUloT0w5cGF4cld0Qlljck0raFVseGR2RlJIU01zUHZHQkFtS21sYzBEaUxm?=
 =?utf-8?B?MkVhQ2IxOHZIVitJNzU1UU9jc3dPRXRhbjlyWUtMaDhEL3hadE90ZjMxK1NH?=
 =?utf-8?B?b1RMdmNYNEsvOENMVUJZY3YvbFViWjRhNzZ4dkRyeGRaS2dCS0dTM1F0anUw?=
 =?utf-8?B?dDNkYVlyNlYwZ1VybjVsSk91WldiRGpqUjNJcG81dWlsNmpPQTkvTHZvUmtN?=
 =?utf-8?B?SldhSUpMWmVodGg4ZmIraW51OUQ1d1o4SVFvdlM1UkV5Vmh0RWZhaTE4amV5?=
 =?utf-8?B?dFhYRHp6emxjVDc2M3luWHpNcUQvSmQ2d0JBd0xBUXd2V3crWlFjV1ZaOVM4?=
 =?utf-8?B?QStKcC92NDJSRG4wOURQN3RRR2gwN1dvWWhOSGJobTNuRkZaa09BaFBlYmIw?=
 =?utf-8?B?bUNrUGd1Rjl2MDA5bkcyTTZ4ZFRVUXFaQmUrcGIwOW80Vjgrc1JzdWFTL2wy?=
 =?utf-8?B?STgwY0pQL1gyUStWU1UzOVdnVklVVWppbUtpeWVicUFaRnhDOGF6QTZkNVcz?=
 =?utf-8?B?SVlwY1hZTTJoSDVqd0xER0s1Wllxcjc0eDk1VUpCaGdNT1YxanJpbEx6QkUx?=
 =?utf-8?B?Qy9ZcVNmeW8yb0FVbXNsamlNZW9leWg2VTNLWWxIOVZ2YzFjSVJlanV1ajRC?=
 =?utf-8?B?cUlEVG1yN0dnU2hEa3VZa01JaC9UT0pDZndVTXpDVVFka1U3WWRpcEx0cjgx?=
 =?utf-8?B?L0hlVFpiTkRHR2JTU2NDVU1scytUNkV2Qk9wRVdYVkhUKzMxaXhjMGxjM3Nz?=
 =?utf-8?B?aXJnaGp1THcxQ3VqWVo4T2IyVThnUDY5TGZKcEtoOFdiSnFlWlMvYlVUUGZs?=
 =?utf-8?B?Sis5NWxnYzFMUG5pdEdtdWRoRFpTWnVkWW50eEtjZ2NIeURVSnQ3S1hGTllF?=
 =?utf-8?B?TjdVRW1vNnVkL04xbGFQVFlpTjdvdkhCZjVMN0gwUzI5TUpYR3B2TVFIR3Rr?=
 =?utf-8?B?dWc0M29ZeE5wdzFjclNhUFdTZ2ErbVc1ZEdCOG9VdUE0WjZocDl6aTVkNmsw?=
 =?utf-8?B?ejJRTHN5VkxtVnVYeDJQYXlTLzA1MHMyV3BJaFE5Q1NPQnBCOFZEZWROaEd2?=
 =?utf-8?B?RGVtNDJlRVUxMFljK3NIU0NBMTRscTFqSk91Q2hFNERYb0FsZ1U0WTc5VFp1?=
 =?utf-8?B?NkRpd25zVVpTeXJXNENIMFc0NHBZZm1Vd0s3d3ZPTkgweVFhd2YycDU5ckhz?=
 =?utf-8?B?VkN5bWtvNzlOdk5ISVd6c0JjY1hjR2xSZVFJU2IvUmN6QXZBNDMwRTlDTEtl?=
 =?utf-8?B?cC9MZHhzanVSdGd2c1RjakhoWFNVSUNiTU8vbWxGSWtmSHNkUkNMSmRsUGMr?=
 =?utf-8?B?aHpHV1VoK3Y2aVFIV1R3cWNSenV1akRudHQ0b09FWnFKcGdxNm5YWHpSZW9X?=
 =?utf-8?B?ZUhoQ0ZWZHdQeDRzTGNDRU0wWmxDQjJjc2R5VGh6ZnRJTzhzRXEyaDVheC9h?=
 =?utf-8?B?SmlsQlJNUVdIc1NidnMxbVZ0SkNzdldiWGxPNzRCam94d2N4U2M4SzRvRjhP?=
 =?utf-8?B?ZUJhYVpSU1gvRTJZQ2lKTUVOMG8vQ3RwWXE0UkgzS1pIbCtmS2xXeUJmTjBI?=
 =?utf-8?B?ODQwZVpZVTFSZVB3cjFYWEhtVHNtWWhpMnhyM29wTUNydXJjSHptMDJPcHBS?=
 =?utf-8?B?TTZVc0VuRjI3TGxvbTRyQ2R2b09MK2s4U2lsTlZkYXFOWEkwZGxFcXpoMGh2?=
 =?utf-8?B?SDNiaTVxcXhFU2sydmhmVGJwS2sybVhvaDlucENEWXUzOGxFcXNQaHNZUFJ6?=
 =?utf-8?B?TFNXQlJSMGE4ZkRPb0dyelRYK1o5dEFQcUtRQ0dnRUF3YWZDV3lVY3Zxd2FJ?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZVNYQ3p0WXZMdmZ5ZGhGVkMzSE9mU0F6S3FIUjhobkI0dlhkaldTcnQ2TWFN?=
 =?utf-8?B?RCtzWER3aGpmZmJDZ0VRcndKQWR3RFV1NFVVSVNLNkxVOUt1dEdZYnFUWFJL?=
 =?utf-8?B?OXRycnJ3M1l2ekF1cFo2MWFPOWl1ZVFuT0lITmkxZ3NSWjcvclh6MkJvYURh?=
 =?utf-8?B?WDVoQWNKdlJCN09TZUcvQjN1aG1pb2dOWWc3WUswWEg5WEVWTXBHK2h1VmxE?=
 =?utf-8?B?QWpGTFhiYXVVY0xLY0hldEZoVDRGcmo1czBTOTFkLytJQmZWMHU2L0p5Y2Yw?=
 =?utf-8?B?UXIwZStUNlIzenBqVC92WERWbVpka05OLzBaSjVqTFpxTEptbTQ2amFMUGxR?=
 =?utf-8?B?WnN3c1dCY0lHa2dmZzRaU0hBOEdxTi8zYy9MeFdmT3dSamx4R0htR3N3UWlO?=
 =?utf-8?B?TGZteXcwNFA4UTI5Y1ErNFFha3FlYWJiREFiRXZLQjQ3OWVYd0RkNXduR0Z0?=
 =?utf-8?B?K3h2WmhlTzhoU1hVSE9mMnNFNFdOK0RHQWc5V3M0dmVUNGcyVWVFTkhucyt0?=
 =?utf-8?B?dXUvSFJXR281dysyNm1iSWF5WDZIdzV5cDJwT0VMc0hkenJSZk1mVlNGaEhU?=
 =?utf-8?B?cjUyYnFKeTF2c1BpcS9UMWpoVXNNOEEvWlQ0aE1IR1ZqQ1luKzdleVVXLzRk?=
 =?utf-8?B?N0ZsbmpwdDA5UGI5R2taSk9DeWxiQlRPZlFkZHdqTlQxSDY2WkNPTjQ0emNN?=
 =?utf-8?B?cHFXM2pGL3lObTBtdjEvM3VNc0E3MS82U2p5c0sxM2s0dEMrWWpBZ2RlZlFt?=
 =?utf-8?B?MVVEczZPMmdkRTdQUkxzMmU5U1pIMmJiSnlmUFZKcWFNdlZ6a3dKakNNZTVq?=
 =?utf-8?B?S0tGOEhuMXJaNCttbGNQczFndEJGM2lPQm1DdWo2Y2p4cDU2dnpEcnpUVFBm?=
 =?utf-8?B?elIrVElnd2YvTVA0SmtxZ2d3MEVLejMyK2s3Q0F6QmRNc1YxTzNmY1hFNVlL?=
 =?utf-8?B?N3hjR1lVa0tlY3A3S1BrQWJVTkNhM1lTa096cDh5ZWh5SWQ1Sy9wYzFadlZD?=
 =?utf-8?B?Vmh5UjRia2c5RE5PdHM4MW81Q1gyREF0RUtWcHBIZEN4RFF0UFVOVjBxUnlW?=
 =?utf-8?B?V0NBL29qTGJVMkFZTTQ3V04zcmQ3NHJOSXBCU2ZuQzdScWRVaGVxTTExSDhh?=
 =?utf-8?B?dUlhN28yR1V4djhrckdUNk0rVUVhUEx2Umd3Y0U1aU9jM09ZSit0YU4wUm5s?=
 =?utf-8?B?ckcyem9yQjc0VVFiSzNJUFNPTG5nSGdzSVBCWVR3eHMrSTNieWdhN040dFJC?=
 =?utf-8?B?TFlzVnZ4cFdYNlZ5dkF0elo2eDBuZE1iWGpjWWUvWU50b0Z0OGJhS0xHQ3R1?=
 =?utf-8?B?cHJhSVQ2Qko1eTRsSW1oTFJSdE9qMkVua2ZGRzFaQUE2c0wwdUFBN1NlOUFw?=
 =?utf-8?B?eWV6cWtIZkVoeHJBTWF2VXdQeTFORkY5QTNGb2V6Y2RaMUptUlZlTllhUGx4?=
 =?utf-8?B?TldhLzBPNmFJR01OV0NZVGltT3NjZm9ld29tYjB3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4c7ee4-3fe7-4aed-ccf5-08db586f66d3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:46:09.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBeOwul9unJ7l2H79nkCTtrXHjvEDMctwr4srMOn4BPFo2sUULNTWdogRBGfmqsXPj6falDft1/6AVHeWwXBD702XHqgf3SVsUeetGC6A08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5704
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=718 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190116
X-Proofpoint-GUID: mW2JQg0pzJgUhFVLl-Hei0MN5xoqrvSM
X-Proofpoint-ORIG-GUID: mW2JQg0pzJgUhFVLl-Hei0MN5xoqrvSM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:29, Jason Gunthorpe wrote:
> On Fri, May 19, 2023 at 12:56:19PM +0100, Joao Martins wrote:
>>
>>
>> On 19/05/2023 12:51, Jason Gunthorpe wrote:
>>> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
>>>
>>>> In practice it is done as soon after the domain is created but I understand what
>>>> you mean that both should be together; I have this implemented like that as my
>>>> first take as a domain_alloc passed flags, but I was a little undecided because
>>>> we are adding another domain_alloc() op for the user-managed pagetable and after
>>>> having another one we would end up with 3 ways of creating iommu domain -- but
>>>> maybe that's not an issue
>>>
>>> It should ride on the same user domain alloc op as some generic flags,
>>
>> OK, I suppose that makes sense specially with this being tied in HWPT_ALLOC
>> where all this new user domain alloc does.
> 
> Yes, it should be easy.
> 
> Then do what Robin said and make the domain ops NULL if the user
> didn't ask for dirty tracking and then attach can fail if there are
> domain incompatibility's.
> 
Yes
