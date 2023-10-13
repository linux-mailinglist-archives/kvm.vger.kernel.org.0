Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E357C8C12
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjJMRKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJMRKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:10:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27FC95
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:10:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGaBt6013339;
        Fri, 13 Oct 2023 17:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=NtGneIa9HqP2HkYpKqex3Iokt4XHkK0p3nKKxPAJpkg=;
 b=nMKmI/MQLDnNaPQcAPQD1iT7dRTqOzA/vFWQ8SOFwI7Usf2UJhuanVLtPpaTnY0DBuqm
 DoRGOwocSwUz4BqXoIS2SUJyOpCjtbXc21buI4rsadoo03B/SRlk5KSzmX9QMVsoLCLS
 otF2WieRJC98BlLM/y4Wl0SUPdnk+X4CT5SpOB5760ipOjOwhQRGu0ooTaIqrDiL4jmQ
 soLOzc8zUpTOHuTAAp32ewlOi7PZ3ADEAR52NirQ/Ncm2hAOBUXXRCIBA2EasdG0VS9u
 1qLURa0gf6ycYeWjJcFdaDbiMzB4eY/u/x5wXLJ8YKGaGkV3vhZS14kdUgaUMLaehgcG mA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjwx2dgs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:10:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DH9lwG020285;
        Fri, 13 Oct 2023 17:10:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjvdbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:10:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLD5YK09+EYYFc08XGBJzzGwChiSVmwiubDiIw8SvhpBIoThssw5LxBg/EZKE5cTD4OJqlEqAjXH3Vs3h4I8EI3bYPYYoOH33fujwhU1ELws6DhBsNFS9LRHAeg6KqmhH/a8dwryvi0JgpCkYYpNG6dvbTO3QvJH86CXOpDQNNDXrQ/z2HIp3qkaa25BF+DCaRa/ZayCOhwOBF5l85djFrlxvp0xUpLB4kXEXncUSo3pU5V3XI5EAIvmGDCDUen3viHxu75Kxs/y0GtKuyWJcSCnkVFDVQai6QcBW08ZzR9Nrn0Zs3FsqFhd09JHfU1F4kIVqtbqDD5EVPyMuQOY+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NtGneIa9HqP2HkYpKqex3Iokt4XHkK0p3nKKxPAJpkg=;
 b=EOApCtHv13/2B8NmxUERIFp8OuD/9lIfx62qAcULaWkxpfrTm68OzDzxpJulf2/9+YCYOPVrjyIHKVx9yj/ePMmRi3PGaX9uFqMJnWUYJ66/nFWzOO21ykQmOdKjy8YLzjWQXFSYyUXbpM8uFXjCMI5S/a7iGaQPpVibrF3ccVkmnU/e5FNq0OjWJve9WE+LWjw35Hi4zwnS4HkvFOQegB1j1SoiliydFFvnqzBWlFdaRaYHVQ0rajtlOtpWrFRCF8Hk8YWVsa0USlD+dp7o+ZXv59evQYi6ir3oX1g/HAICzyVAhW2KsRZxSjSvc2kOLRm9KcTBX6Kp873S43se2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtGneIa9HqP2HkYpKqex3Iokt4XHkK0p3nKKxPAJpkg=;
 b=vqMFjmUGPpG2a64wsjySB9T8rQmdqKVJdmkj6aaT0/aaOde3JomwabqzBwhEBN2ff9NoticSSGgoj8QK/TjT4R1VaWbd6CVrc6V8fzWOqEHcBj+lb4KYPPXOiXWoC5M2cQS0o4GMYAi1wcKIgRnCXd2x5uw1Q4Zb6u2n43BB7rI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ2PR10MB7059.namprd10.prod.outlook.com (2603:10b6:a03:4d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:10:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 17:10:11 +0000
Message-ID: <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
Date:   Fri, 13 Oct 2023 18:10:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
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
In-Reply-To: <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0056.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ2PR10MB7059:EE_
X-MS-Office365-Filtering-Correlation-Id: 57962194-403f-4aff-3d19-08dbcc0f422b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUAjKGdMTXKJMIjsP1h/0ax9uRaUKkKQH19LmzCUOfY0MlU+UP+c/rOo/wn3UdopEX186SMWuzPo0oBpsuE/2RdbnuqhSJC3oRzXHZVoyPguN/CG14XF4QM/uKsCp4mSOjsaUalehZZ3Yzj2Dk7M1KyLtJSbl3tFLIL1AIezwl1RqKyfTgxDfStupVa7awvW4o2KZYNf/wZF+EPbxB42tyaw1Bla6Svww2KF72GlrjR1qEvpChUxMk7NWnxbQKf+vFI6yUH8AjtnUEKuIv3Sz/ooymtvjy7JGK1QhQeHq33JIT7F6lQ8L/PYXVvamqZqP4de6WFoANdh/J87QQ3+rjWE7d6d8lbOhOIJxD+QRoSB3TdAtXCFtxUbQkJZnuWqgoDLCJCYnaYMFm+T7+wCeELH7lQWoJPjxnYs5mas+fbpAW8EUFzRRlPbNRHdYSqfCXn9BBiRl16q8+Fr5SIkHhoSolqmy0QDI7ZxKkzWrlpMSid0gRYSjJ8j2PnyfQal2WuYxRClLcoDntgIn8PYOuCTtnhrZd1gCD+HxtqgzmxdWYSrRYHLiS3pMd7IH1EhjTFPsTIC+k4yrazKVw0L5HhDEdMh+UWeKW2WNjKdk/A4DzQqpRP4TCZHI88K/bzLMaI6lgmh+HVulBGlOuMh7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6512007)(7416002)(478600001)(2906002)(6666004)(6486002)(31696002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(36756003)(66946007)(66556008)(54906003)(66476007)(6916009)(316002)(26005)(6506007)(31686004)(2616005)(38100700002)(86362001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzM3YnRmbXFDQWZpU3VxMXFhOGo1TTBjUkVqWUIxbGFiWDJ1enNWTWhUU0N4?=
 =?utf-8?B?Qkp3eGpXV1UyZU9xZTQyeGxRL3NqOEJZS1FkelpRdFZISFFVUEMyK005VmZN?=
 =?utf-8?B?azZBNnJ0aWt1NTVYZktUaGNsRzBNaVVvL2hpNWgwR0F2T2h1TFpHWmoreUVx?=
 =?utf-8?B?NE83WStIclljRnppTHA2dHNyZUtWbkJQcGFBRzlJZ1UwSk9LZzloc3F5M0Nh?=
 =?utf-8?B?WTFIbS9xdWpzT0pjaFhRcGUxTUM5UTIwVlF2YjYvTk9iL3NiRkhRQlg4Vktq?=
 =?utf-8?B?WGowOWlEZHFLUUlHazl6VmtPeUNhSFJPU2dOSXhxeVpYUDRCdW5PZEJHbG13?=
 =?utf-8?B?VjlvaUtVY3RBMTJWZG01a1Z6blFHYzJsLzVSMk9pR0hueXBvOUllUllwdzdq?=
 =?utf-8?B?cTc4Q2pPZnpuT0phT2I4dHNFL3NSOWNnWnhXbmx2WVk1MUVLQVlxZThGSlN0?=
 =?utf-8?B?aEp5VUtueEhhMUhoQVFTd21vVndkZ0NQU0llcnRmVHpKaFJrYzBzOXM4TU9U?=
 =?utf-8?B?ckx0a3hiUTBSZDVaZFEyMytiS1JMRXdZNlAzSm5qNXBlN0cwWkhka2tQd2xB?=
 =?utf-8?B?QzFPaS9rR1MwOTBTR2tHK2JDN1pNLzRCd0RubUJRMGdFVDhZUkN0eGEvSDI3?=
 =?utf-8?B?RXJISS8yYXFqendDN1N4T2M1MDdiTUd5WGhma2VxcXpZYWE2QjVCRXk0bW1S?=
 =?utf-8?B?WmVpRFROSHNZRTJBTlJ6bGpkSDRaT056MytuSFdybnRsN1FibmpDemYzWG5E?=
 =?utf-8?B?TU9GVzE4NjhScFJ6YkE2Q3hXU2xzTVdaWGE2WUZyWWhyejhPbm50bml4N1lm?=
 =?utf-8?B?dFRpVGF4Mjl2WWpYRnZCSGdNWDZyQThhbm5CNWxwNFFvK05kNWlTbjFVZmxz?=
 =?utf-8?B?VDFpRzJEWVVhYnRiRDF0VmtDcEFwV1g2aUJETGszVWFJS3pHbXFObTNKWUdv?=
 =?utf-8?B?MjNQWVEwWHBjTmR0bHYyWGRodHRyei9VeCtyMFdFcEtnMzltZytqQnhJbFha?=
 =?utf-8?B?Q2ptcnhZNHc3M2VSVSs5SjFLaWdDQ2hScEdRbklqSGVHKzhxRzJKYlRjWWtZ?=
 =?utf-8?B?VkJYVUlmbWkzR3cyZ005YWxqTzA0d3g2MEVyYmdTVG8yS2pKOS9jSGVQc3p3?=
 =?utf-8?B?aGVzdnNYS1Qza0FDQm9Ubm12akllQnZFZGdZekpJcEVUTzVTQldrenpSdHhl?=
 =?utf-8?B?WHhVZkl6dzlZUDVEdnA4S1hxMjBhOEFuMFNSUlVIdEZmbi8rUExJcWdKbU9R?=
 =?utf-8?B?TVIwbjVEaEpSOUQ5UVFraGRGUWhHbysvSU4ycXdIVFE5WmlrY2xXT0FFR0RD?=
 =?utf-8?B?d3Q2L1VGdDRwako0UEEwSUtOS3czWFloRUZsQVZKelBMcHVSbVpsMGYwcHNk?=
 =?utf-8?B?RkVVMkxFNDl0SVNUOGhFMndrK3BwUUVUMi90elFka09DL2pWRE9DeXZDbzVi?=
 =?utf-8?B?eGlNODBGcU1aYVJlQ2Zucmt6dFNjZ3NlRjVjN0FuTnJBSSs1ZGdrL3NyTXZN?=
 =?utf-8?B?WkxxK1ZDakdrWFUyNXZSOVRhVktjZ3ZiYjBvS25STlVGOHYxbWp1VWRFSGlj?=
 =?utf-8?B?NHgvU3Jka2U5ZVFLT2ZtVnJUZzlZZWFhYnVkV1VDOWVJeHpOTGVXRHQ4NzZw?=
 =?utf-8?B?NEtUTjE1YWdyTitVekdqb3VBcUE0bFZJUmd0aFRpS2k3MXNYWnhJSklOM3B5?=
 =?utf-8?B?REVVdGh5MzhweWk1T2NGdDQwYWowM2t5SkhMWU1LaHU3elcwbWM1WU5paFQ0?=
 =?utf-8?B?NHN6NUlEVzNjYXI1Q0hqaklrZXgyK1RIUDJGNUVjbnpUV3pLb1R0amUzRlVS?=
 =?utf-8?B?bm4wR1cyWmR3RWMrRHF4Y0FmYm9rb1VLUWFhRW16bGQ1QTFZdTIxRWpjazkw?=
 =?utf-8?B?ajlmNmE4RXAvR3NRTWU4L0JYd2tyUENmMTB6VXF2RkJHZmhKNWRDakUvWHUz?=
 =?utf-8?B?ZFVWOWVUR3hiNnJIZ3BZZkpSeUhyOUcxalJZREo5RlMyWEJ5M281Skp0VXdR?=
 =?utf-8?B?bU5Rc1JBa1lsZ1QwQ0ZKd1ZuQU1KeEttelJUbyt2QzVnSHJiOW1pa2NydTVo?=
 =?utf-8?B?aVhJSHVDQWhsVERhazhqbGxlK2lNWmh6ZkpWNFFkZjYwQVk5RHNkdWVXSnBD?=
 =?utf-8?B?THh4SGYzcXpNRWlZRVBLV1dqdzhkQ2RwNzFwZHdSM1FqSnNnaThjbHdGMmJ3?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cnhITzZjazVzcFdDV05JZE5rL2dsNG9YbG9Bc0tyTStUZVRqa1VDSlVGVUsr?=
 =?utf-8?B?NzNlVVBtUGJ2OXB6VzhkblZSVEFpaEU3NHhhMnFobk9nbjBiSGZpalV3bytR?=
 =?utf-8?B?THN4YVhsc3drN0Rpam85dzRDRlJIQnpWdlphWEVFM1J1dFhiWHVPNzdUMW5S?=
 =?utf-8?B?eEszTm9KQW9lV0dKZ3NHbThJU3VOZ1VFYlZyMkhaVFVFOCtiQWFqRTM1OTF1?=
 =?utf-8?B?SFlyVGhBdGppaFRhY0o5KzY1N1dsSHdwVHgzRDZiOTVvMVhCY3lZb0VJUmVt?=
 =?utf-8?B?SDRxM2dwZ2ZEY2FKZktDc0MvN0VTQjJhTVBkSWdwVVByV2cwYWxLdXdhNXY4?=
 =?utf-8?B?cWZhWnFONnMvdGxnTHhITk5nY29MbkVOMGJMbU14NlpENjQzVDZmaWVUN0Fj?=
 =?utf-8?B?MnpoOTlkUGxqK21sL0c2U29HVy90UWdBYVBiNFpta3BYSVZuSFJDWFlRNWda?=
 =?utf-8?B?QjhuZnExWU9iUlFEOTRsRXhpcnl6ck5DWDBXQy9kNm5VQjlwRVlYd285SHQ5?=
 =?utf-8?B?MkZWNTcxQmhvN0lKQm1aRm5oYTZzRXM0enlmNVAzQjZuTWtRMFowK1Zubk5Y?=
 =?utf-8?B?OWxMOGVHS1ZtSWlzRmh1SnFKSDN6MWVacUtmbkRJbUtlamY4ZFJIblRHMkJC?=
 =?utf-8?B?Z3FvR2luR09XM0JOSkhQcFRKUnRXeGlMTEJEWEJUT0pOQmttZ1IweFhnR1hh?=
 =?utf-8?B?YjFGYWV3QThPek1HMW83SmsxUDYwMFZZUDlxVGxuVFFmcmNJWTZMV1lwWE5O?=
 =?utf-8?B?MW91dDhzK25zcjMva1MyUk9GMVNHQ0tIZTRidDM4RE1rRWxRVUpvTEtpaXFh?=
 =?utf-8?B?bXVSa0Q3bG1yckRjcUlhTVF2NUszdFhjMEJBQnZSekw3MWhjTWhlREhuaUNB?=
 =?utf-8?B?OWJsL0cxMmdyMHVkVUgxQWxMMGpaVUZvaktBa1VUeE9SbExzZlVJVElKSlNF?=
 =?utf-8?B?UnhRZnFGQyswOGszMmdGUWh3VFNuV2pjSVdpWFVWVEF1UC82L0EvNUt6S3c2?=
 =?utf-8?B?ditmWGxoUVlFYTBkNGF6NDA5UUhkOTZMRko4djVLTjVTYnRsYlBDWHB3ejZ6?=
 =?utf-8?B?N0JJaVc3MEF4SG5DblUxd2ZPZmNNWkEzQ28yWXROVGRVSUpRc3dsOTZ5djIx?=
 =?utf-8?B?alI0bEt4dXBFazNudGF6NjVuYmVqY0RnTFAwN21qcE00T09jSUx6bGVPYU5m?=
 =?utf-8?B?ZGpwa1pwVnNzQTJMeXkzT2szZ29TbUp1N0c5VHI5QnM1K0lGcnlTa01jVnYr?=
 =?utf-8?B?V29mK3lWVE56RTRTaURYc1h5L2hxNmcrbUZKUEJ2cDJ5Sm1kajJuYTY3SG4x?=
 =?utf-8?B?VzlsNlEya2lTU2lHZGo2MzRqTXQwaHltY2o5UDRJV0JVSWlGUWlkL3lOTjJM?=
 =?utf-8?B?RzdhUmlvTGFFOSs5djk1WVZHNXphQmdjUzhuNHZzaWgyRGlKQWZIRC9sdENp?=
 =?utf-8?Q?W6qW2Dqx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57962194-403f-4aff-3d19-08dbcc0f422b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:10:11.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0mPxfm5St5NiHLxXqM4HwItKl+HAW31LeJyxdl8dbFcf+Dr6Hk+g7WBzMFxHUFZOWbqh5WYiGuOz5VqRP1zyOF/1kiIo8d6NVbWXhm172o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130146
X-Proofpoint-GUID: FOmU_dt5v9LzeqFdz4vA2N132l0oXzqU
X-Proofpoint-ORIG-GUID: FOmU_dt5v9LzeqFdz4vA2N132l0oXzqU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 17:00, Joao Martins wrote:
> On 13/10/2023 16:48, Jason Gunthorpe wrote:
>> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
>>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
>>> can't exactly host it given that VFIO dirty tracking can be used without
>>> IOMMUFD.
>>
>> Hum, this seems strange. Why not just make those VFIO drivers depends
>> on iommufd? That seems harmless to me.
>>
> 
> IF you and Alex are OK with it then I can move to IOMMUFD.
> 
>> However, I think the real issue is that iommu drivers need to use this
>> API too for their part?
>>
> 
> Exactly.
> 

My other concern into moving to IOMMUFD instead of core was VFIO_IOMMU_TYPE1,
and if we always make it depend on IOMMUFD then we can't have what is today
something supported because of VFIO_IOMMU_TYPE1 stuff with migration drivers
(i.e. vfio-iommu-type1 with the live migration stuff).

But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
essentially talking about:

# SPDX-License-Identifier: GPL-2.0-only
menuconfig VFIO
	tristate "VFIO Non-Privileged userspace driver framework"
	select IOMMU_API
	depends on IOMMUFD || !IOMMUFD
	select INTERVAL_TREE
	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
	select VFIO_DEVICE_CDEV if !VFIO_GROUP
	select VFIO_CONTAINER if IOMMUFD=n
	help
	  VFIO provides a framework for secure userspace device drivers.
	  See Documentation/driver-api/vfio.rst for more details.

	  If you don't know what to do here, say N.

... and the fact that VFIO_IOMMU_TYPE1 requires VFIO_GROUP:

config VFIO_CONTAINER
	bool "Support for the VFIO container /dev/vfio/vfio"
	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
	depends on VFIO_GROUP
	default y
	help
	  The VFIO container is the classic interface to VFIO for establishing
	  IOMMU mappings. If N is selected here then IOMMUFD must be used to
	  manage the mappings.

	  Unless testing IOMMUFD say Y here.

if VFIO_CONTAINER
config VFIO_IOMMU_TYPE1
	tristate
	default n

[...]
