Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82F7C8B3C
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjJMQaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjJMQaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:30:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A67E4
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:27:51 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0wBE015918;
        Fri, 13 Oct 2023 16:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ssT82n/+XI4C9jqF39IUMEQsZyDRpOQ9kgoTLRQt9eI=;
 b=V/CAPIz5mRyfJNTUtGsFOOPxJp5V+0lA8g1KOqExKH+rKus0l/WFpDV9QvwnlGmFAIq1
 XECyR3XkUUKXUFGSLdHWim/ZMzwhNcyG3JAUL3VCTRfoeeNN2FizhnL0yrp4queT0dyX
 KsVzv7+z9KepIElvIujgm7FrqTcc0KSVrVnYtotbXeQ2z4suiUoOyxV6bYm5JnJkQp8h
 TU5JTu9cli9/P6Rr2DNjvXd+1oeqtKU1rpUvnSKqrrRgQwS2E2hKrX6Mr/VRb5OkGiMI
 vg8rje31ucfG3Tr/614vizwvW9ybNWgTNMZ6J0xOR6P4XtN1xHuvnkx51qBvYxHzc5TQ jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx8cnf9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:27:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DF6GZP021377;
        Fri, 13 Oct 2023 16:27:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tptaskdmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qw79djeTgGnKlllTx7WAOEMY2MPfxH9LnMuNBu6MeLx/YLkUsPbuNwX0ab5f1o8nt2l5mEt4+OvrmB7+K+/XuNHaLZfJMBcT0AdQya3nSfutMM4TOjfOZBCszbQwVy8HWkUimzMamDZ+ioZbyR/QfN+E4FH0EPj3MJvP+qUQogArNzhurTt836K0XN9idLY+TMk8UQdjGuzJlwSDFeMsdYdiJG4KFzS4HJHaOuaHi+AUV0b2cEc6pQqR7eefR3swiTUbTku3/3LLU6xV10tu/aGZJwUrM/XxRZ1A6yKeam+Om+FzCqm/iFTyplahWJzWpmHRRPWXc6a29Zg8RtjRug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssT82n/+XI4C9jqF39IUMEQsZyDRpOQ9kgoTLRQt9eI=;
 b=Fp4zJVRJquf1VKZcZUfgs9oO5m1urs5z/Ss4fmp54EFcaAX1FY4V8sVX0FHeu6gXGGLCjF0n72OVqvvFcePfthjMBXiRBRYd43wTejaEIZSlyGZY+/C3ZyBI16nQMP26NN9UYhqMu2n5F0rhkKCqbwbYoYV34BAJyzOmqJqXE13yYXiZP4GGTdmPMNK6hJ5cqPKamBYqraQg8YVihIDNlZTIj1ZI5XrX3LhdOqViyMp47qxoQhL9fjMLoC9QPGVM5oEHn6N5JRZ/LAlrAkdon/7E/viyB+R85OYElmUuKyF6OdfVGtLp3R5pNdOMXzqJVknMoyXSmZGp5PS7tlKgKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssT82n/+XI4C9jqF39IUMEQsZyDRpOQ9kgoTLRQt9eI=;
 b=WfIhltvOUW63YlsdtMJ1t+kpbTXvCxZucadY3IIx89osoDikwnJbI7a6JCmHSVByRKv80Pqz4z0TsQkOVjpal/QXXIfHgNu9TS3PEtiAgQvhF96emZ+Cw+4AgDRewppw0ky0wIAzWjUuShi00KbUGv1pc3g9l0MqW91p2aXit1Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM4PR10MB5917.namprd10.prod.outlook.com (2603:10b6:8:b1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.45; Fri, 13 Oct 2023 16:27:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:27:21 +0000
Message-ID: <53212f01-4ee6-498b-a233-5c5bc693992b@oracle.com>
Date:   Fri, 13 Oct 2023 17:27:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/19] iommu: Add iommu_domain ops for dirty tracking
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
 <20230923012511.10379-4-joao.m.martins@oracle.com>
 <20231013160533.GC3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013160533.GC3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM4PR10MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e707f3c-69c4-4f7b-d55d-08dbcc094655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sop1E4eDO9wjPzedYyzwjPI6jVL2j4HfRtgTIzhdfQI/4+7pNiC66H3QdbIjqjc9Yn++XLH3oJDpCGR/CLQQrAIb0XeSyuMK39/qgYZWQOWi729rFP3F4Lgr1eD1rysR/IKlxqgt38Duwp9NeUn0CJbS0YcEPV5WTxVexewDNccIFsaFN83RRlsM0Td6vx/VVIRHzLlPQXIidilyPf9v9frLSHDyc1haNu3eFPqX1Xjz1h2dKcYjEryZU5EbdX/oPtavh5mG6od9oINCohNyQvef3bMfZ0DIcwPDBVrYDTbiggKqUVf2B80VrEk4W5YqFjE2k0a1vU2bVG0og0OlLy5NHVU0I5rP8IIyz2pr77aSfE/AhybS8lm1ASwGHxOggOTpHqSUiZasTRrsn3Fz7IFtO0wPJyXUxScEfs0t+HheuBULviacYj9ULRQeI55KWfmtbb2mHIx5WE8ArGfYUFRfC5uUxB3CfPit3unu0Wi/ceokXcIcFQBrHLL4at+Y1Uk1Df8/1FlwhkA269nhmjEurh5EetUr5eM5+axGM6yyNND4PUkMZyi5VLQKQq4vQvKc3sEk4HTsa/ivTsfRFcq0HYbkLtEYSmp5Tyes925jh5RElR/TVEuqN4z+BaFH8hOxhy91eEsUQcT18xFgte7QA8P7LlOa1Z9D+qQklRw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(376002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(7416002)(2906002)(36756003)(86362001)(31696002)(53546011)(38100700002)(54906003)(66556008)(66476007)(41300700001)(2616005)(66946007)(6916009)(26005)(6666004)(31686004)(6486002)(316002)(6512007)(5660300002)(6506007)(478600001)(8676002)(8936002)(4326008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUxabnY4WnNQY0wraEZydkVzUVRLS2lndjl5Q2VBa0Q4cDgwekFmQkxGR3Zy?=
 =?utf-8?B?RUM0VitxblpDNGhrcDkzM055MzN1YklVVEIyQmFsUi9kNXowUE9nQXJleDVG?=
 =?utf-8?B?aXkwRThvN1VyL0VSN0lNWlJieWNkQ2Z2VTF6M1JYWm83THZvSm9zdk9wTXlC?=
 =?utf-8?B?K2RXbkkwUWNiNlB2dm9hR2VUQU80SVhUUm5LbTJGTC82SEY0bXNEZXVCQVp0?=
 =?utf-8?B?STJ4UTl2N2NaK012VHNqVUFPcGZNajhvbkJ0alB0aWszWDRMMFlWN2xadE9l?=
 =?utf-8?B?dEFTSENrT1AzY2syOURkenBSbTRpUnV2Y2JwZDExRkV3cy9IcnEzMWwxZHlC?=
 =?utf-8?B?WlVNalk4dU53THc3TENJV0FiY2xQK0p4Q1pGT2tBNlRQTlpEdDVweFkvWG9X?=
 =?utf-8?B?bkhLbkR5OGtIckVqei9YQ3VFRnNHa2VlR3Q3VWNpOW9kNmNtZWxiYXJwRmVH?=
 =?utf-8?B?Ym1uRDByZWw0NFJMQS9oazhRYUxXTXRPSW5yR0tYVS96dDJhTEg2cEFyOHc5?=
 =?utf-8?B?aHR1OGwwWTF3UjlvSFMrb3ZUQ2FDQjVheHhqdHpCR0p4emIzRmtpV2ErTHhu?=
 =?utf-8?B?di9FY1R0aGUwTmJlR1BpZVQza0FjZnFqakpyTjBmbzJPMlJnTVk0ZG9Danpi?=
 =?utf-8?B?RDFyUGRBM1FUWFBOMXljaXoyekNKVlo4T3BtUEQ2Ukpwcmh1Qzh5SEE3OHRL?=
 =?utf-8?B?RWZxSE1KWDdpSVJzZURUeTFJZDVWZmRMbm1UeWloQlFYaHZRM21XZ0JIaHRp?=
 =?utf-8?B?VExKRURGZnZNenpMY2VwUlNHam1qMGNUWlpQRUVtM3ljakpLOGhlWVZ2T2tD?=
 =?utf-8?B?Y3Nrd0Vja09vNVZHQmxyVHRGWCt2b2l1Tzh5c1lWQjNGOFFXVG9BbE5VeVJK?=
 =?utf-8?B?Vnh3ZFVzRHFtb29ML2tURUE2Q09MdEhHTDVwMDVFb05DQkIrejFXWTNVaVhC?=
 =?utf-8?B?WGt4dHl0QmlVRHVwSDBlRE5uT3NyTFIyZTF4MGcvTWNJMm5CTGVqNVV4K291?=
 =?utf-8?B?emRoU1hEM3ZLODU0aGNZUHVyelZRNEdoMjhvRjVNcUJpMkhkS0xSVi9WanBo?=
 =?utf-8?B?TENYcnk3UjVManpoTHhZOUNnOTJ0c2dUNGtUZzlsZG85b3lqaVd3Y1h2c3pi?=
 =?utf-8?B?akh6REptRXYxR2lpaWs2cC9GZUxkUHRIdUhaM3Rsc0tDbm9PQ2RuUlI5dkJr?=
 =?utf-8?B?WnlrUVo1aEppckhnRFpTNlhuNzdVZVBpSEN6akl5WU1sdVVFM0VRZVE2RUdE?=
 =?utf-8?B?WjkyQ0R3SmlVZlVLdnJqVElEdHd4VWgvN2xJT1pQM2VnMkpmSWpIWmFDcWs0?=
 =?utf-8?B?QUswdldta3pITTdxYUJnSXIydFozUUNheTF5eFhPUElMbG1sd3ZjcDVIeEtV?=
 =?utf-8?B?bVA5UWk0bWU2YUZzUG12d2pTWHVVcUVJYXZ1a0NZcHdDN3p4WmtaTkQ2Q1d1?=
 =?utf-8?B?NmVsb3NLb3JHcnc5b25NOHlTdTkvVHBOQ2pMSGJRRFYvQjZHRjhVeWFVcFR0?=
 =?utf-8?B?a296WVJKWkdHVTlWUDFkWXJWRXhLaEZyREpDM1BKM1lvUUk0akkxUkJiNlVB?=
 =?utf-8?B?MWQ0UncyUWJZNVZST1ZxZlB5eml5WCtKd25zTEQ5Y1BpQ3NVR3JOWnVGbktV?=
 =?utf-8?B?ZkVZaTI0VVpId0ExdkNXN2VFVkYwdmdES21rZzI3aXVwVzdQc3pWM3RLOHJa?=
 =?utf-8?B?UEhZKzdROEVMSUlRdzFmRXFvRmcwYTYrVVBVNkRGWTM1cklmOC8vb0RBM2Nt?=
 =?utf-8?B?VVkvMitWVVR3SWxvMVoycDF2eGJmUnVUZ0xRemg2OUdqRU14UmNoTW5zbC83?=
 =?utf-8?B?dmRUOUV5WEpuU3dUcEVvL3BVZk9MT2hGZndGcWN3K2YzNXlVcjlqSUtJSE1I?=
 =?utf-8?B?SEV5am1mRkdTeGxzVXNMTUR6STcvNFIzaFhzb09MdVFOcXArR1ozVTZvT1ZT?=
 =?utf-8?B?bUs0Y3o1eDl3bFIzeDhnQUd3d0dpb3pVeDQrU2hLYXIrY0FDVmFXT012Ym5G?=
 =?utf-8?B?Qks3MzJaNlZ6WXhzeDJGd2VIVjR2K2NlTXFBemEwb01pTEs3NUlxOE5KeEdp?=
 =?utf-8?B?NktZOGYvNmdoa1UveWNBZ3FCZHFXT2hNZU5aL0RQOXAvMjJVWHVqSDBUZHRz?=
 =?utf-8?B?dmw0d3VKck1hL2liQXZ1U1l6OVZOaVhlbG5aQUJTSDNMTnpUdjVneVg0NlVB?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cFRheTdPMWhTZVA4SkE0ZVVWVy9tRTRBSFo0SnNzM0Yvc0hrM1ByU2dJVytI?=
 =?utf-8?B?a0lCRkpyWUZKNzZjV1JaTDJzVVliWERoamlvTVIyTCtLaUpiTGJWdFhXUmpW?=
 =?utf-8?B?U3FKbWlDWlV0LzlVZ3IvclFhWEFJR1p1VUpqTVNyMENYN0RpOFk2cWJndTAz?=
 =?utf-8?B?NDh2akZ2dG1GcHhvMGpHb05TRUtyWVhpTzd6ZWYxcFZMTUtnR2NYeWRzcVJK?=
 =?utf-8?B?d1VhYVNZeHQ0SDcxZ2o1N1pLRWRCOWZFNTEwODdBTGFvWTBTSE1lUGVvZmhk?=
 =?utf-8?B?NGsycU0rcWNTc3cvMXVMYzlFejA5aFBjMTA3dGJwZkcxWkQ4c2tQcHVRdXlm?=
 =?utf-8?B?K2s3YWhUa0E0WHlES21HejNFak5JWktWNytpdGFEU1N2WXhFT2h4RWNkdE5Y?=
 =?utf-8?B?aEVhNnFDV1FCMnVsZS9WbitlUTV4Zy9ZWXlLQ2tFbWlmbFU4dldoUVVCSDkv?=
 =?utf-8?B?QXZGWURSdDRxTXBYbjRDQWdEb0hKTHJ5eWR0WVFITGdpSzdRSTFEMFc2WU50?=
 =?utf-8?B?YlFINmxuMXMzTEx4V2FYVDZkQW00b3dkR1VCK25EcC9wQ0R4UUV3QUlreHFD?=
 =?utf-8?B?UlY5VnlqZzZsLzg3UzBkYnRUWGdmQUg2Tms4UGJkUzNZSW9pamV3dUp1a3Iz?=
 =?utf-8?B?VUxCcDlkWDNzaThHS2czUENkbmlrRTduWnEveVBGeWp0eXJubE5pNWxFR0VJ?=
 =?utf-8?B?WkFOdlE4ZXUyeDZwNTJsYk1UODRzSHkza2hBRW9La0RwdTlPV2JHYllTTWZV?=
 =?utf-8?B?aUxua1RpN3ZRNVVGcE5vK09LQmdRODlieW8xUnRsUEszZmgzakJSZjdLNEhr?=
 =?utf-8?B?L2tpdm5jcGljWFp2OGc2WEVWdVQvMHhYQ3FvTWMxVGpIMTVLUHI2R3ZsTGh3?=
 =?utf-8?B?clNyaXRWeGZyRGorSFFmNldXTUxGMWFnTmtHTTFYTkYrY1hmT1ZaY3lCNk9i?=
 =?utf-8?B?d3NwaEk1Vk1IRGljVGVBMzF0eDNXK3RQc0VWYTI5c1ZLb0crRGRneG1hTVht?=
 =?utf-8?B?WTlvd1U2U3NIaEtLYXRLMDdtV29ZdEtaalpUZFBuQ1hCODloNEMzQy9UREQ5?=
 =?utf-8?B?ZHlKc2lIYi96NC81V3RkeXpYaWp1Z1kwYXM3S1NrZVRUTGEybUQxTTBBM3V5?=
 =?utf-8?B?cjBwNzFURTVmRk9CTjVXSnA0bS9meURyaEVmWFM1YlN3bEp4RkNuNGFCWmQ3?=
 =?utf-8?B?M2hKVlZlQWlXakVNU3ZLVitXaEcxV2NkSjAyTTVQazRSNVhOYmdTRkVWem9n?=
 =?utf-8?B?elFEL0ZXQnJWOWJIcVRLZkE3dnBRcXBBU1NtQlZFbjFhTlAzMGljc2ZGTlVh?=
 =?utf-8?B?SnVEVHJnUFVISmZ0MGpZZ1BodWg3NUdhOCtJby9WRXNDdUdyYlJnSWtTdXY4?=
 =?utf-8?B?N2czYVRGZVZ3c1gxbldTR2krd210eGdMd0xPekZid3gwYzl3V2VscG1yYVR0?=
 =?utf-8?Q?Bujwk9LO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e707f3c-69c4-4f7b-d55d-08dbcc094655
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:27:21.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uxp18vlF6g3pAznZrqOd6lb4mtjL2rGABma6zFqo6bo54wEh85PQgd40ePGe4hWDxGDeTXYX8UrG9heMrzm4CajPTuewPrsQE63IymqJFVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5917
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130139
X-Proofpoint-ORIG-GUID: w3bORMB3pn8UKt0TikcpiemQ85a0Qgza
X-Proofpoint-GUID: w3bORMB3pn8UKt0TikcpiemQ85a0Qgza
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 17:05, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:55AM +0100, Joao Martins wrote:
> 
>> +/**
>> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
>> + * @bitmap: IOVA bitmap
>> + * @gather: Range information for a pending IOTLB flush
>> + */
>> +struct iommu_dirty_bitmap {
>> +	struct iova_bitmap *bitmap;
>> +	struct iommu_iotlb_gather *gather;
>> +};
> 
> Why the struct ?
>

...

>> +
>> +/**
>> + * struct iommu_dirty_ops - domain specific dirty tracking operations
>> + * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
>> + * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
>> + *                        into a bitmap, with a bit represented as a page.
>> + *                        Reads the dirty PTE bits and clears it from IO
>> + *                        pagetables.
>> + */
>> +struct iommu_dirty_ops {
>> +	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
>> +	int (*read_and_clear_dirty)(struct iommu_domain *domain,
>> +				    unsigned long iova, size_t size,
>> +				    unsigned long flags,
>> +				    struct iommu_dirty_bitmap *dirty);
>> +};
> 
> vs 1 more parameter here?
> 
.. I was just trying to avoid one parameter, and I wanted to abstract the
iotlb_gather from the iommu driver, to simplify it for the iommu driver.

But honestly I was quite undecided with 5 args vs 6 args sounded like stretching
to the max, and then the other simplification sort of made sense to consolidate.
Is there one you go at preferably?

> vs putting more stuff in the struct?
>
This I sort of disagree as iova-bitmap has no knowledge of IOTLB -- it's
serializing bits into the bitmap

> Jason
