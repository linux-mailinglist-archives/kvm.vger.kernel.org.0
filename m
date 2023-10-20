Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6177D0CEE
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 12:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376746AbjJTKNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 06:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376844AbjJTKNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 06:13:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0868410D0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 03:13:06 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39K6mmkG012878;
        Fri, 20 Oct 2023 10:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+PZ172scceRNMC7nnG/8SkGXEw1JPtBf6U8pE6aB57w=;
 b=X9MFYMsmGeefezGANZDpOXwz3grDe1W2WLlAWaSvEbcfD9CKJjv+Nme5zW5uYSjoG2GX
 Dh/zJIgAOCLp5t6Mgx+8wvE3pgX/gT7nhtEzhffU6IVFFDek2al+1tJ3FhEY/v0pRnuk
 wie4GVi7ewLj4e+kGqmEegoY2RwBVJjWG5YZ0BrSlZQyv+gyTfTjS0uWatkrpnP/a5Rl
 u0OgGC5LVrFkTqx4NVhbsusrsCchzKOsmnvJig/4j3IquzC8MCoGWBusuWp4gukEF7ak
 p6DQSQFAkLw4J7yxS9jbZtigO3bWfiTK4gQCNpeRHuq89DUpSKQ3d/zylnpiC1HDjGhi 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwd9h1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 10:12:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39K9iNSh031528;
        Fri, 20 Oct 2023 10:12:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdmx78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 10:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvak8GsdOE3BKfv/asaUON7oO0gaAjIEeOfHfp69ObLaD1aVl/aVnc8vyqHvHMfwDVW4umznpJcx2t+u8Ird/hVDmdbWKxDqjuWz5WplLXJNFIOKETByTxCDaEhszpbKcnrXwQ7DFow1LBzPdxL47FU8F/Gh9OPHdCOOmCDPvpW/RVmmaCOM4/xUaSZqukgAfTVse7j9uD36xx1h7u84n+Buz6y0i9W5y8iP+PlPptEoE53VVQ1XWcxkRhTA52z3RO8NRRtTy/8VJ37Pjb5C8H+yTgFfx9tX0MhE2fAH5KJpNXohdxmCRkSS62o540V82fP88fkHCMTgANEDVEYJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PZ172scceRNMC7nnG/8SkGXEw1JPtBf6U8pE6aB57w=;
 b=ZpeKMXW+JcsoJZC8Mo7vxbkxzKtOgjQ8JPfh2Z7uT46tT0R3ytIncn7mmKtFO9IN6zGpi7wjWyXsG3w5MRGXEteyGQ3KCBxbhgKxSJQWLFS3Nh5C5f1AsvF7WD4GZpLJxd5+HQUVzG+2o5uFOjl1UsaRKq+kFrGFq/qcz2x0mNJ6swmm7DV3e37IKczsxx21Nm8JUimmM+lv/huJjJyXCc3GD0IPoC3lOP2+4nEhOyx+YlOL9Kp1c3BphIMBLs84YBmJ1haimVuNAysJS0oeXaPCrP5j4nv4Xet/lVEj4dRjs2otMV3cFzZ4P3PiAEte1c40Ue16z/X375MIn/2FzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PZ172scceRNMC7nnG/8SkGXEw1JPtBf6U8pE6aB57w=;
 b=lD0inMNXZJNJIaZLFXm5xSSm7SZRNzseFgX8BnCpuKZYryKUqRFKt5SlET9g4rrUYSrIPyBmF/JiEqbWC7eAfVeITkVYGnOi4+b2psebpfbNYs6mRJyoromEj9kVyQwahw4We9KAfobmtRDF0nBoyubtTFIgu+erApF7M3ud2i4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN7PR10MB6286.namprd10.prod.outlook.com (2603:10b6:806:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 10:12:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 10:12:31 +0000
Message-ID: <9152578d-53f2-4359-8d69-bf8868fda131@oracle.com>
Date:   Fri, 20 Oct 2023 11:12:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
 <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
 <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
 <20231019235614.GZ3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231019235614.GZ3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0405.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN7PR10MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e47328a-0b15-4369-b996-08dbd155124b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/IdFr1P66oJ+WiVhnAxRg79psyH0Y0YITykbX1bkNLmzDvgpF5mOeNWrnfg7r8QIGTIF1K5yhD3lHS68FIyfeDYisly3cgY4WrPuY/CkQQ0ga0QbCpa5WASL2RWRGjn7Mm7mRnbbhK6kXN3Y2hL6H9L1IyoDdBE2k5xA7Lv3fb5MlCNVyJpoDDaGcQAOc0O10LdHeTgor774P+1Zx4tMB27Ols9tg/yIdLnLYmJaNWurpzT3SbqHIZ2iKIp1I2KAlFyvAz4QVNyfp2wddws1PT9xfSOED8G6lKkZz3F92uY7kP/3eCgtgFPYjq5Cv6SBr79fj8WKRxSKX+vDj1v84qU/39/9v8bnl0EavVgV2wtf3t6/w0QNGkgLfNnM3eR2MIxc6jmEIKQvAV7WH7D+dejWQGH5zp2Wu6bJaD/oH0nw+or8ZYtGlOHN/+MBgergmJOoPOL15cqDQvzAh4pYyKEutZ3gxK9txvxbgMUCaTIbN4Nkd6xZYflNoztJrc+z9aR8WPBO0oyOtC+kBtrLOhBwcbc1YkmeymGCyOLMhyo0t/AE2IwA988YA3paFZLU53nNRJ/M4c4J3mumB8/4s2zhhqi527hejj35VnFGDK8V3jTRE2N1wLGvuX1Q/m1/QxzdRcGXngOlbqC6iosSGSkp4f69lyo2XSoFxv4SVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(38100700002)(4326008)(7416002)(4744005)(36756003)(2906002)(8676002)(6506007)(6666004)(6512007)(53546011)(41300700001)(478600001)(26005)(2616005)(54906003)(316002)(5660300002)(8936002)(66556008)(83380400001)(6486002)(110136005)(66946007)(66476007)(31696002)(86362001)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGhSUjl4RXJyWXIrcEV5TEdsNGpnbWtUM3V5TkNXbmw1dEg5YWx4REYzaWZP?=
 =?utf-8?B?TVgxT2RhZGZTcUZSWHlMb3pQRlFYVmZrK0Z4K011TmVBN25JbWRiaFlDcm5X?=
 =?utf-8?B?aFBvdVBKVGFpaFpBS1VEclBtOEJqRDR0WGFlUFNFaXdjbHowdXoxMjFOZ2ZK?=
 =?utf-8?B?MDZhYWtKSHJ6RVk1UUtKMVk5R3hIeitWWGFra1oxQTNXLzlPWTdZNWR3aEht?=
 =?utf-8?B?b2FRMDJaLzl0TVFkSzd0MGthN3hoa052WHViTSs1OVl6dCtybmkvRmF0MEls?=
 =?utf-8?B?akFSNENCNmJiV1ozT1BsUXo4OFFuTXh0VzdWdGVhQ1ZSK3Bicks3bjd3ZWxj?=
 =?utf-8?B?VDNHaCttQ3NTeVNtZ3REYUwrREs2UStlcFYxaWJweENDYWdOTGxJa2dsdjZJ?=
 =?utf-8?B?VnVleVhkSmhUbHhaSmZrSStlc09TdW5rVFp1aWU0M3MyNElUVEFFekFFa2ZG?=
 =?utf-8?B?Rm5BeW1yNWJlNDEzSE5Temc0UWxITUpEY04rMTh0MGZab25YM3JJL2JXL3F6?=
 =?utf-8?B?N2FkTVJnRm5VWXJuOUJ0MUJVSUtTekdzQTUralgvS25GaGlpYzRPL2JZQURC?=
 =?utf-8?B?dExNR29nVjdTcDJDQko2cEpkVkJPQXVhc1FpOHY2akg0NVliOUtHZ1hUc2NR?=
 =?utf-8?B?dm85TzFZQ2ZTNFhtQXBJM0s1WnFJNnJJVFdmdjU0NGIveHFmLzNBSmpWVC9Q?=
 =?utf-8?B?UnhTejI2QnB0WkR1OUxQZXVSaUIyaFNhQlhNSXQ2SkFTRnV4bDdJUjBmekVq?=
 =?utf-8?B?ckxVdkFKYk9oYTgxci9RZ1pWOEU4YkFCUGg5VmxWbVAvRnRGaUt1U0lXMG44?=
 =?utf-8?B?VTJ0dHk5WUovcjVRbERDbkFEQWIxU214a0ZFRUNBdnAzeUF5UGthTTdHQkp2?=
 =?utf-8?B?cXRsMnVtaWp1NVZQbEs1VkhXTjdFUFlmMmR0ZTZyS08zMjdkeTMvdG1xUVFY?=
 =?utf-8?B?M3ZuRzJYa3ZTU25qZ3A3K1d4VTBHUGN6N0FJUThJU2x2RjNpODJhRWpRc3dX?=
 =?utf-8?B?aG1PaGxRNWhxWEVqZDM3VDVJNWZmOHBJRzFjL2lZd1kyRXRqdDRZTkF0aWZP?=
 =?utf-8?B?SC81T0FaMU9Wb2FHek1ZbzZhUWJOZ0ZURlA5TGcvQ2xGb2t6N25zUEVxOVd0?=
 =?utf-8?B?N0Nkam94eERmVzBNcmpWQnYzaEFwNnVqY08wR3Rwem1RRjJQQ2dBS1pxWk15?=
 =?utf-8?B?Ny9qdWU5cktpYUhzVEFzSEdrMVNmL3k4cTQ1dWIveWJsYjMvYkZDbmkxQ0pW?=
 =?utf-8?B?N1l5VmwxbVRhYkhLYnpCMFJZWmF2N2cyOEdwc21jOUJvdmZqdmhYSGJyY2J6?=
 =?utf-8?B?cTVnek9qUlNub2lmUUhNZHE5elhVSDRYU1NVWWhEWWFQbnRTdnBhcFA4UStn?=
 =?utf-8?B?V1g4YjdwTGp4OHhjWW1Fa3V1R2tUYmdqTTB3alh2WmFJNDFQSmd6WjZnQ3I0?=
 =?utf-8?B?TXd0dGNoRGZhQ2w3Y0VGeFJmdEY1KzZpbUJPRjB5aGJ0OXdOa1VHOWJSdmFQ?=
 =?utf-8?B?dEp6UVNZVHpndHVJMFFabTBEK28yQUxpOS9aT1d3cFRJank0Z2ZPM1dyamlI?=
 =?utf-8?B?VUdkK3cydHFkRWtGdDRtd2p6dE80OGtJU1ZDQUpNcUg1cU5GKy9RQnRJSmh3?=
 =?utf-8?B?N2M2a2lVYzhFRFVqVExDcXJtcHZoWTUzbnZtd3hzYVVGMzEyd01XMmJyVWUx?=
 =?utf-8?B?YkxGLytoajVhL00yQ1VSQ0lCTHpCVUFSTzk5QUQ4cm1PWXVBK01ZZk9OQUQ3?=
 =?utf-8?B?d0dJcG9sOUdJcG96MDJ3RktoMzhkUytzMG4zQTJqOGhVWHFjSmZhQllKanJ2?=
 =?utf-8?B?d2dkd2NSTDNiRVYzc2FRU29VNFc1eC9nK3dXVGpPaExSR1JMTm5MRXgvTW82?=
 =?utf-8?B?YnhSTDhZS1dsd09OVFIzZnk1UU04RHFZa1JmZ2xJV09URlRRVnNJQmludExC?=
 =?utf-8?B?VEdLL3dIellETzY4aXB4RHA3VEVFQjJhaWYvRDY4T05qd1RBcHpkU25LWGtt?=
 =?utf-8?B?WEk5U0d6UW0yb1F6TTJ5SWVwakxreG41YVZ0OFFVanAxYm8vdnN6YjhNQ2Zk?=
 =?utf-8?B?L004WUIxQWJTaXpZRTBZeXZUVUFwZHZyYk1Cd2dXWXNWaGhOWmJaYmhINklZ?=
 =?utf-8?B?SmZ4N3hOVkRxYncweWFPOUErdUFYK29GZ0lZc3R5eE8vTzdWbG1PU1pabGNi?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RVZjY3lJRHMzNG9saFRqdmFCSmNQNDNyc0JXOHo4VExzZFY0alM0OU9rdkhP?=
 =?utf-8?B?bCs5dW81bUFTN0ZIN1VjK1BZZURNdGJVeFZCbEE2eFExY1hxUVhpNDlScmNl?=
 =?utf-8?B?Y3dlTy8wdzZ3bmhnL1djK3dObGxJQTMzeEJBekxNdkwxUlNIR1FGL1Z6elFE?=
 =?utf-8?B?Q3BmVG15QzMydmgySDhDVTFweTZWOFIyREluTHZhU2VpM210QkdXSlYveTVm?=
 =?utf-8?B?SEpwV3FTSm1RUUh1S1BPRDN6UGY1T3NibUVQZHQ5bmE2Vjd4ekZjdFRtalc0?=
 =?utf-8?B?cWlzUFJGVFNnckpXaHg3ay80S2pyVHZxb3NQdTdTeTFiSkZKbXNDTWRQS0ox?=
 =?utf-8?B?NEtxTUoxN0lvMGRMaUFjY1pPeWNLQS9WaWhNaHdXZVJHa214ZmJiSkx3aXBy?=
 =?utf-8?B?anFFejNkK0ppamFEdS9qT3JuMkFmRTV3L1RBUmRVUU9lY21XTkQ4NFNZZlp5?=
 =?utf-8?B?M3FQTWNJNnNySCs1cXpLMmtwL0pWeWk1MkV5amNsNnFNZEtxUkF2c1hEUVBW?=
 =?utf-8?B?N3l1MW9uT0tDK09zQS93YXRyb2ZhMEhmU3E0UFRxMndnbi9WSWdITHhCTVNa?=
 =?utf-8?B?VE5TSnh3RlZpMjhoUGduekxtTzQzNitHaXIvZWQ4b3BBQ3pLdUZSK2EyOS9W?=
 =?utf-8?B?YzUzNU5xREROa1BETUFWZEZyZzg5WjJmdWx1aExhZGFzN2dXaDJrZnQwS2Ft?=
 =?utf-8?B?TWhFOEoxcTg0NHA0bkc5L1N1V2pyb2JQLzBKaWFlb1hVSHh0WTAyUDRoSjBF?=
 =?utf-8?B?VUJKWDNpS2hnRkdoNHh4NjVaNG8rY0c3akFodktoNEFyTEUwN1EvdWJwN1lx?=
 =?utf-8?B?Umd6OW1QaVVyMXZBU2lUNFJPSEVLQWZJNk9vbkluZWRtMXJOYnhpOXc1RzNo?=
 =?utf-8?B?TUZmUXg4RFc0WGtjeXIrUFhSTHl6QnF2NFBOWjVEVGxOMG5lZndFUWZwSXVC?=
 =?utf-8?B?MkR3akV1SUoyRkREbDNmS29DbGJpQ0xPNTYrT2hiVXpya3JKM055clBLZzdz?=
 =?utf-8?B?elRYdHRIYW43VDFyR2FuTTVzbExVTkFpNzNHSTBQSW5ndWRpenB6R2RDL2FG?=
 =?utf-8?B?dXk3M25mM05wYVRZeE0zL1NIbkM5RkNMbTV0elRHQ1NrUy91RVJyczU5ZUtB?=
 =?utf-8?B?TDZCSWJPQVpQQzduVEdEeE85ZllDaXhNSDBGYzdHT1NJNjVJczV2RUxuQkZz?=
 =?utf-8?B?UlpPTjZjRnhPK3JVcEtNR1pjSVBic2tkU3F3Wkc2d3NjSG9tb2hPRU9KREE5?=
 =?utf-8?B?SlAwUFMyMXhKNGNLRVdaR2VDM01aTHllemZMcnMrTCtDcG93NjN4TGx4ZXNs?=
 =?utf-8?B?VkpiZ1RFbEpTeHQ4T05zWjJsdzJBbzFhcklHcElmMWY3dSs3b3pZcjVITkhI?=
 =?utf-8?B?b0dyWU1ROWNpWWtYK01haTBHd1MvdHorTUJQeCt0dGNNRkhGdC9jSkZlUGcz?=
 =?utf-8?Q?swg3HozD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e47328a-0b15-4369-b996-08dbd155124b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 10:12:31.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYW23ZbxoGa8pqZEbJG3ZusVa18CERBRsNzASC8vROJPeca0NsS4+hfmEFapw56ETdtcQEfFm0wuEu46R9UwsDgareUOUeYecuBviQBx2vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_08,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200084
X-Proofpoint-ORIG-GUID: zuR4wV5XqOXhwenXLBEJsasRVCJ2NX_c
X-Proofpoint-GUID: zuR4wV5XqOXhwenXLBEJsasRVCJ2NX_c
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/10/2023 00:56, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2023 at 10:14:41AM +0100, Joao Martins wrote:
> 
>>> We should also support setting dirty tracking even if the domain has not
>>> been attached to any device?
>>>
>> Considering this rides on hwpt-alloc which attaches a device on domain
>> allocation, then this shouldn't be possible in pratice. 
> 
> ?? It doesn't.. iommufd_hwpt_alloc() pass immediate_attach=false. The
> immediate attach is only for IOAS created auto domains which can't
> support dirty tracking
I'm mixing the domain being created with a device that it can validate against
vs actually ends up happening right after (in a separate operation) which is for
the device to be attached to the domain via ATTACH_IOMMU_PT. So technically one
can set dirty tracking on an empty domain.

	Joao
