Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D666677823A
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 22:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbjHJUhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 16:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjHJUhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 16:37:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F5C2733
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 13:37:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37AIcY0f013966;
        Thu, 10 Aug 2023 20:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=S+ur1CVpOWnd+02Tmutk+w9R+0mdP346TF/Jeruwu3Q=;
 b=A76DbRxSUklAxr+/8KvpG4/wOFiv5F5cgasRQPBfz7ziyePrkre7XNaPVIXextSXY++c
 03MFFm3f7cXijawIjk5eoj7uGWah2eTDQOBRTiuOocCP5Ajx1bdx/UU7MaHoVbkv122D
 ikugb/Eg5GmJL23Vx5B3FmR2c8vAzQrAUZ/s84d9ChxxOTtJP9Fcbs+6fVxJC7XScSYv
 rHW9v0JvQUpeCZqLjUDf9scJtJdyQGYfkYX0rASvuypBZ1yuMJpdpUarkbWo6O3ArmbF
 XR4B7+iOnpKAAdfKSpm8RGk9IyEl7W1+mgDUEXADZzGaxHhQTZxtfyvbyvnb9hHs4G1H XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9dbcc6mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 20:36:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37AJh6JE026035;
        Thu, 10 Aug 2023 20:36:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvfg9c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 20:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aq59PY74/ieVvdIux7kM+n74y/LuvPyn6qO+0XQPjzqjDXJNqMuUf/MlkQebT/5RsaFaHNdGcbbH+QgA3WK3su3kjdD2D9kp0330k5kuFAppzC8APHe8vMiOvaoXGCwd4pCfDVdLfWzqtNxxx8LGXL1oBFcwuHkVidHGW+P9Co++SqvSYNVDfdVBlGKLqCnPX53OVerS5lkvBnSFR+p//19tZFrmlpfmCpv0fvzzjj3vB+VXhMhGoFR8dMnoP0iCsqg50osDlnFFoMZIyJuWxY99ol0lkTP8wnk8/jHtHF88/Ofqj50aVVn9Drxwa0FuUCJluOEjyHv4qIEqHyCZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+ur1CVpOWnd+02Tmutk+w9R+0mdP346TF/Jeruwu3Q=;
 b=EpoaA4Gl2ft1nCTvFmtngLJrEXPE5nRStMwt/+K8jowP23xd1YtPP9yzmR3rNx47TxBMOLoHY3KvurJDQ/PXJoL0+Po/ngKT2vgnmNvs83Yzi2/OEBjY1TmPaax9BMZKHqSydLzyEoqJeJwaxJAkLYHVxNAXS1GRW8zHSONGC7YowLJ7OiL2mWSVDJ3zNHf+4kfoSUkHBAhqFfIE+d2RIDfGyfPSNUAKbeevxcLXNSKDG0k6WK77Tt5uzLhMN4yvgfpetpXk9aRfb76eYEWiYHpmWZxlKlzum0VLI7mKm04477kscMfzTNQs/eJJwYplokhadXesdvMZEkoJqz8mCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+ur1CVpOWnd+02Tmutk+w9R+0mdP346TF/Jeruwu3Q=;
 b=QJ+1Nx3jgCsM4k2NQEdfu2/0Lbfw+1QMh9aJlLRFb50zgH9S88aq+LxjTJbls3eZSvtstaXlBiBXcirAwE5VLFBRnHZInwS7Zx8xoQq+LZUVl62dJkBB7c5d3rnCYi6juFuwej78/vp5kdQOzUy39vgMPpV7QPV5IMSMbSZiAFs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5138.namprd10.prod.outlook.com (2603:10b6:208:322::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 20:36:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 20:36:45 +0000
Message-ID: <113513fa-ac9c-31c4-6d97-ca2055ceafed@oracle.com>
Date:   Thu, 10 Aug 2023 21:36:37 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
 <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
 <ZGd5uvINBChBll31@nvidia.com>
 <69511eee-69b5-2a83-b7b9-f4a2664e15e8@oracle.com>
 <ZNUymqfxICNh0pUO@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZNUymqfxICNh0pUO@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BLAPR10MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb9235b-296f-437e-5bd5-08db99e18229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayTtLkpecO+1F8d6p+4k/5h8G5uE0MyAw7L9P40/z0KlG+B9DUeR5jbze5kxtgZO5GVkU2RqFr6SUQGZk9s3uqUnBF2I4COImHOFU7XP16ujPTqhikj80KF/b7LJqaBU0WCBXxjh3SDWKDcRum7U/l6XAYyTG0ige8Q48p/CSc/3+g8mzPXhUZn6e0ZWzLUKqjJjDQ/2qBsaHDqqfAtpX5pd6uc6kFWi1BK3frnQ6tAlHe3F0luKq8ehbrQER8Fg0bgTcdX7Qk9Gn02lFWrNUPIQqih6poNL2xCUGD8AiV10ew79TPw/gerhvfY4KbtQq6B72Wzppo0DwOnYxmkTZdVUp2vz8d24jGWWq3oaPlVKqkx5m+IbLGHfNXnH+IDIyA1uunYeDsbPvwLuyfgUvpkGJH+kiifozkz2EjJU6CbgJt8eEvxyM22P2xolOQ+3ndUAooYojJtfZnUClDRn+38VkraB1fy8iY23dyOvp2juzdz2+KzALDkUWO0fGtxP7n/dPCtJzE7uaC+ztFp/Emx9Zj+jQDd1bwDIlldh9diGbjigV94Ed0VaSVWam41GrxAA4qXA1fLaFfnM0QvgWDw2jiG1CYeHjFvc5Vrk6q8gq3WztfArUhjT6TxgMoIu7ZQvjY8kIyky43wJfxrpKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199021)(1800799006)(186006)(31686004)(54906003)(26005)(53546011)(66476007)(6916009)(6486002)(6506007)(6666004)(478600001)(66556008)(66946007)(36756003)(86362001)(83380400001)(2616005)(966005)(41300700001)(7416002)(316002)(4326008)(6512007)(2906002)(31696002)(38100700002)(8676002)(5660300002)(8936002)(21314003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVKOEpQQTZ2dHFEeUxySUhFZEtvditxbDRiQjYzWURWOUpCWjBKeDUrZTFq?=
 =?utf-8?B?eGtCWU5QWWJldktuckx4ZHFYWVd1TjFJeVZqTm9tWFROUk4yK1UvSEpGTDFo?=
 =?utf-8?B?NEdUQU0xM25YOFdCMmVmMGltRTNlSk5JTHBhcUw2NVM5R0dMUVR5UFpQc0Vt?=
 =?utf-8?B?bjVvQ0g2amlNSmQ1b09Ed2lGd1lXL2lwaW1Eb2JNWllzdWxzZGtSRWNaRVZW?=
 =?utf-8?B?di9rRGVpeGdzSC9yUmdjYW9oeGI0cVBvZC9YY0pmbHdSVW8wM1QrejY2OGpw?=
 =?utf-8?B?cG1ydjVzOHZRcWt5MlJGQ3NSL0FpS1VSVmZFM1VFNERLckpRM2RVcTMwLzAw?=
 =?utf-8?B?VmxpQXpLNkEyWmxlWmJzbTlPZVZHUG9OT3E1Yk5Rbi9WOGtIL3VrMEF4bUx6?=
 =?utf-8?B?SXZPczJuWDVPaEdRSlRVTHFxa0ZraVZROFVFb0NOeWRhajlzWjd6dVlRazBF?=
 =?utf-8?B?TUdjTDArWElRUENqYTlXaDNJZndFYWNpN2F1STFXNjNLV3VnaUo0d3VCeDhv?=
 =?utf-8?B?VzRKdW05SlV2ZFFRTEFXWUJDVjhENy83bHhnWGVQZE8zRWxva0ROR1JhZVl5?=
 =?utf-8?B?MUZtd1o2ZTlUNkJWZDZ4cGo2TlVxeWZKSVp6L2dDc3FmZEJ2MHBQZUYra3Y1?=
 =?utf-8?B?c0U2Y3VpWnpmNk5iTFlOdDZvbmN6bkNPbzZXUFY2ZnZZbW1CR0FnTXRiQ0RG?=
 =?utf-8?B?U0pOcWlLbFNNWndPYVFVTncxcnB4VUxtQVBoeHU2Ky9IYWY3d01YTWRHcjNS?=
 =?utf-8?B?TkViYWo1SkFac05aZUwzb3orU040QkExT1Vwd0FBZkswZ3BpallYbFNKa1d3?=
 =?utf-8?B?VzhEVktHK2gzSHk0d3B5V1VNTDg4Zkp1TjduZjZQMDNsQzQvWFk2eGhxODZp?=
 =?utf-8?B?WE0xWVRTcUNLZDNYQ0N6OXBsb0NCRnd0S1VtZTBJV3c0TFhlOWlaMGsvMGpy?=
 =?utf-8?B?TVNWWmYzMjZLRkgvTDJNajJ4T3ZxOTBZQ1d0cW5neXl4WmszRXZZMFprR21Q?=
 =?utf-8?B?RjRCcWRxTkVLUXVIUU9PWks4TFNXb0ZvZnphVm9LNUZjWE4xMlE5NzV0TCts?=
 =?utf-8?B?dGlUOGJCMjM4OFh5VnF1WlZMK0NCSTZ1b0ZtSE5wWWY4QjF1Z0lqN3dYNThX?=
 =?utf-8?B?dmt4bWFxYkZISFk2bkp6Zm5XeTA5ZjUybWVOZGdiUVRseHpvejlVaFdZWC83?=
 =?utf-8?B?VUd0ZG9Td2Q1ZDYyNFRQdnpxWG5tNURTNi80aE9xQkU1TTU2WEUzbnltSGlS?=
 =?utf-8?B?YnY1TFJMVFN5N2JaSFlJUzg4TFRLRTgvYlE0TFByWVZ1ckhMQTR6WVNoclhG?=
 =?utf-8?B?c29ZamtVWlF6cUFpZmtqY3hDajNpUGJOR25PcER5VjV0VVRYMExKL0J5TWpP?=
 =?utf-8?B?SW1xVXFTOVlseXBIKzAvMTgyemJaUU02cWg5VGpva0tXeEJmRnlqdkdab3N5?=
 =?utf-8?B?Ui83aTVJdElCa1lCZ0VDblVQZUJob1NQaktRRXN3UmhWUDFKMVFwSmxjMXVw?=
 =?utf-8?B?Z3BGQVV4bmpNL0FJbzltdG9GWmN1M0MzYllma0ExcXB6RXZBTG93V2FsalZl?=
 =?utf-8?B?T25Uai9SL2xVQytGNHRubEtwdDJPa2ozMVhlS285cDBvYWJWd3J0MmcrMkNt?=
 =?utf-8?B?R1Z5bDcvbStnakI0c0laZ2hFdlI3eHJ1bS9GVytQY1FrcEMvSUh5bExTSFBR?=
 =?utf-8?B?Q3hTZFcyZ1RMaXp2NjczY1NuQXZrS20xR3FxNUJPKzdEMkMxOFFhdENhUytZ?=
 =?utf-8?B?V1o2NmxMWTZQM1ZjSW52TTZZT21GcTdrR09pNUtuVGw5OUd2RlM2aUU0bVRO?=
 =?utf-8?B?UDRSRnZnNys1UTM5ZUxhN1lmNDA1a2lCNmhRV2pZbjYrRGtBQ2xQTHJIVkV6?=
 =?utf-8?B?c0lEVXMxcVdQVzBOZy84Y1pqRjZWZlpNRVliRzdtTmFpQjluRWZYcWZRUlNH?=
 =?utf-8?B?VDM1ZWp3Z2x0ZTJ1SDVQUG4xaDF3elZidldsQ0x0WWJhUTZvRkJBZkhWRHBL?=
 =?utf-8?B?N1VNS1dRUkFDbmswckVLU1dsSEdrakJ5SXZvN040WWJGS0NtckdCUXUxWDNk?=
 =?utf-8?B?cU9QTEdzVXhsS2hlM2ZFa2VIdWRtdjNPRmhTZUtvREwweFVkZUo3aWlvbVky?=
 =?utf-8?B?cW1JbWJhcTQ1N1NHTHBlWWgrYTJ4Q0t3Yi82UlJaV2t5Z3pZd01FdjFWblQx?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Mk54S1BBYlNTd2JLY0s0RWJBR1hqa0hsaWF6T1lxSTVjejI0MFJyZTZpRFFt?=
 =?utf-8?B?SDB1RkY0SVpzUHdhMmZ0ekEyRG5ib0Nhd2lZSHNFeUg4NVJ5UTR6UUJmNCs3?=
 =?utf-8?B?ZkVhL0UxTERFWnJ1ZG5sQmFLL2pFZVpPdzk4REhlaWRXNUpDcVQzZVhici9O?=
 =?utf-8?B?SC9GblR3M3c2clpCbjBHMXhvRXdKU0NucmdUQVRieTYzWlBOVlllTWFhd2w5?=
 =?utf-8?B?NUZvVEdrakFhSWhWWGl3YWpQTFBKUGZpZ09UWjdrUWhJY0NnL3JpU2REcmVh?=
 =?utf-8?B?aGdNdGRrTWU4ajFUazlOdHYwb3JWL09yQXhmSlFRTE50MTcwV3BIcXlHSUZw?=
 =?utf-8?B?Sm94REE2UWlIYU94dnVQR2FjS0xXTWJmeGpjcTZ5dWpweDRsYjdaczEzOWZX?=
 =?utf-8?B?ejIyTFZ3Y2N1c2JpTWd5ZjBKQXRxNnd4LzRLcStRMytIU2pJUzc5b3NTc05R?=
 =?utf-8?B?U05LczZFSEg5aW9uZVVvUnlTbXFQYkQzaTh4Vmxvb2xJOUJnRldkV0FNeUcv?=
 =?utf-8?B?bTJZVjRrbTBwVk1FNUdrQnBVR3BjN0pXNHRFRThJZ2MxWWxtMHpoMjcyZngv?=
 =?utf-8?B?dE5yVmN3aDcxY2FySkoxeVovNUIvK0I3UDhWY2c1WFVQZlZnRnRjQjBwakti?=
 =?utf-8?B?QjFySFNzQnliMmZQKy9QV3EzcXEyNXlDQTJjVHA2MFpuQWQzYnJKNkhmVzlP?=
 =?utf-8?B?RzBsU2R3UmVjb1JBc0lNZlp5TzZrVU1tbXVlOVhwOWp5cTg1NmMwbFV5OXdZ?=
 =?utf-8?B?S1o0eWNyL3g3UHpGdXhsMDcxWlVVMWUvK20rSXhMUU1ySzBta2pjb1pGL1Rq?=
 =?utf-8?B?amxRd1g2SzNnQmdOZldLb2hVZEFOQnpmVUk0OG1XbEQ3ZldsdDFCeHMrMGFz?=
 =?utf-8?B?RXB2bmdQQWptOEZXcHlpblBkWEVwek9SdGJNQzd0NHNyY0pZQXFWNHp0RFJK?=
 =?utf-8?B?eHRBcFQyTFdTSGcra3grTlUrbHZRVUhtc3lPNXRYa3FUSlQyWFEyYlQrUHRl?=
 =?utf-8?B?NHhad3FFNjREZGNnYkdMeGUxSUdMNHhKOXVoR2x6WWVZMWFMTHViVGZ1SnE0?=
 =?utf-8?B?b1FWbGx3czNrMTRNeE9TSUdxZTdHeFdmZmd1VnpKSUJmd3VDOWtvQjhrTlhF?=
 =?utf-8?B?ejVNTVd1eFFiYVBGRTllcHVOdmFjQWVRZml6SUhXd3I4cnF1Y3BMd1lmcDl3?=
 =?utf-8?B?bXVWQUxMblNxNnZyM3d3VWpTdWVHUzhDUXNzdjFaZS9xRHlnb2tSY2JIQzFZ?=
 =?utf-8?B?NHVjWnJrTUJmMUVRcTl2WFhoQjhLajdaUzNYU3g3WHM2MGkxUkZJTUlWOTlo?=
 =?utf-8?B?Tkk0ajBPMDFQcEs1WDBFZDZYRE1Db25EbFJrUHY1VEtyY2h5N3RtMDhEWVY5?=
 =?utf-8?B?UEdlM0FYRHlJUVdmZERmTjlnWjI2eHFBdFpHNFpjWktGRGlwbVRjOFQrZ29T?=
 =?utf-8?B?SkRIWFNGalVLMk1hV1pGUkY5NjF5NEpDNUg5ZG5BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb9235b-296f-437e-5bd5-08db99e18229
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 20:36:45.2622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaFJLRdcynvfFdElwBb/I5Qrz0CbSoXvDgwQXaa/d+mJ6tavUkDbtr1V+KGmXYbkB0F3fA9IAKlBHRDOjQHxXO0k2APCnfIG9v2SifSxL+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_16,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308100177
X-Proofpoint-ORIG-GUID: LHlrfuzJo-OZAIoWNaMuJyCUl4paDqnd
X-Proofpoint-GUID: LHlrfuzJo-OZAIoWNaMuJyCUl4paDqnd
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2023 19:55, Jason Gunthorpe wrote:
> On Thu, Aug 10, 2023 at 07:23:11PM +0100, Joao Martins wrote:
>> On 19/05/2023 14:29, Jason Gunthorpe wrote:
>>> On Fri, May 19, 2023 at 12:56:19PM +0100, Joao Martins wrote:
>>>> On 19/05/2023 12:51, Jason Gunthorpe wrote:
>>>>> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
>>>>>> In practice it is done as soon after the domain is created but I understand what
>>>>>> you mean that both should be together; I have this implemented like that as my
>>>>>> first take as a domain_alloc passed flags, but I was a little undecided because
>>>>>> we are adding another domain_alloc() op for the user-managed pagetable and after
>>>>>> having another one we would end up with 3 ways of creating iommu domain -- but
>>>>>> maybe that's not an issue
>>>>>
>>>>> It should ride on the same user domain alloc op as some generic flags,
>>>>
>>>> OK, I suppose that makes sense specially with this being tied in HWPT_ALLOC
>>>> where all this new user domain alloc does.
>>>
>>> Yes, it should be easy.
>>>
>>> Then do what Robin said and make the domain ops NULL if the user
>>> didn't ask for dirty tracking and then attach can fail if there are
>>> domain incompatibility's.
>>>
>>> Since alloc_user (or whatever it settles into) will have the struct
>>> device * argument this should be easy enough with out getting mixed
>>> with the struct bus cleanup.
>>
>> Taking a step back, the iommu domain ops are a shared global pointer in all
>> iommu domains AFAIU at least in all three iommu implementations I was targetting
>> with this -- init-ed from iommu_ops::domain_default_ops. Not something we can
>> "just" clear part of it as that's the same global pointer shared with every
>> other domain. We would have to duplicate for every vendor two domain ops: one
>> with dirty and another without dirty tracking; though the general sentiment
>> behind clearing makes sense
> 
> Yes, the "domain_default_ops" is basically a transitional hack to
> help migrate to narrowly defined per-usage domain ops.
> 
> eg things like blocking and identity should not have mapping ops.
> 
My earlier point was more about not what 'domain_default_ops' represents
but that it's a pointer. Shared by everyone (devices and domains alike). But you
sort of made it clear that it's OK to duplicate it to not have dirty tracking.
The duplication is what I felt a little odd.

> Things that don't support dirty tracking should not have dirty
> tracking ops in the first place.
> 
> So the simplest version of this is that by default all domain
> allocations do not support dirty tracking. This ensures maximum
> cross-instance/device domain re-use.
> 
> If userspace would like to use dirty tracking it signals it to
> iommufd, probably using the user domain alloc path.
> 
> The driver, if it supports it, returns a dirty capable domain with
> matching dirty enabled ops.
> 
> A dirty capable domain can only be attached to a device/instance that
> is compatible and continues to provide dirty tracking.
> 
> This allows HW that has special restrictions to be properly supported.
> eg maybe HW can only support dirty on a specific page table
> format. It can select that format during alloc.
> 

(...)

>> This is a bit simpler and as a bonus it avoids getting dependent on the
>> domain_alloc_user() nesting infra and no core iommu domain changes;
> 
> We have to start tackling some of this and not just bodging on top of
> bodges :\
> 

(...) I wasn't quite bodging, just trying to parallelize what was bus cleanup
could be tackling domain/device-independent ops without them being global. Maybe
I read too much into it hence my previous question.

> I think the domain_alloc_user patches are in good enough shape you can
> rely on them.
> 
I have been using them. Just needs a flags arg and I have a alternative to the
snip I pasted earlier with domain_alloc_user already there

> Return the IOMMU_CAP_DIRTY as generic data in the new GET_INFO

I have this one here:

https://lore.kernel.org/linux-iommu/20230518204650.14541-14-joao.m.martins@oracle.com/

I can rework to GET_HW_INFO but it really needs to be generic bits of data and
not iommu hw specific e.g. that translates into device_iommu_capable() cap
checking. The moment it stays hw specific and having userspace to decode what
different hw specific bits for general simple capability checking (e.g. do we
support nesting, do we support dirty tracking, etc), it breaks the point of a
generic API.

With exception I guess of going into the weeds of nesting specific formats as
there's hardware formats intimate to the userspace space process emulation for
iommu model specific thing i.e. things that can't be made generic.

Hopefully my expectation here matches yours for cap checking?

> Accept some generic flag in the alloc_hwpt requesting dirty
> Pass generic flags down to the driver.
> Reject set flags and drivers that don't implement alloc_domain_user.
> Driver refuses to attach the dirty enabled domain to places that do
> dirty tracking.
>

This is already done, and so far I have an unsigned long flags to
domain_alloc_user() and probably be kept defining it as iommu-domain-feature bit
(unless it's better to follow similar direction as hwpt_type like in
domain_alloc_user). And gets stored as iommu_domain::flags, like this series
had. Though if majority of driver rejection flows via alloc_domain_user only
(which has a struct device), perhaps it's not even needed to store as a new
iommu_domain::flags

> Driver returns a domain with the right ops 'XXX_domain_ops_dirty_paging'.

alright, you look OK with this -- I'll go with it then
