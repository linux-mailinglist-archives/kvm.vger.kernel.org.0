Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527D87D3F92
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJWSxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjJWSxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:53:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94252B7
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:53:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NI0Guw022097;
        Mon, 23 Oct 2023 18:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=F+l5tFVCXXM27Sml5QfR0G3PCUSdb+Q5k9xcCntO+Go=;
 b=3HvmJQGU3DFVowoPps0o4WLa/7VuqvO+DYOzvoM7gBO2E6nWzLhzOD19Rp4sTzOjVLHC
 uKaUTtrVM05+jU4zMAp1SvbVKOqNshZEOUu6prAnAtTdcIubAo3uHp6X6NpPQHD7c9Yz
 XHg7wWJHuhVEoXYsNh1TdSNdFXNIPw1yf2HpQtr8X0By9UjPb9TwrJQQDZeNtgV83wK/
 eSKy2ibQIFPIdoPvvdT9h8br32k0qIXtX0Z1/MPFIroTYSFtBA12BwN2qRL46l1gNaw4
 5oE/KbmboeQq++y5oU57FOQ9oQigLj4Oomnbg3sdDDCAKXa54qFibfkFJ6porqHWai78 eQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6haks7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:52:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHUGj2031109;
        Mon, 23 Oct 2023 18:52:40 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53av3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:52:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxRqBswfl0UCVcMffeIC3IyXE+mJOfyByclme951u49/vCM8qRDcbv1hCc9gdrc5bFR2HVCTcE7DoDetdqoD86/FVrbgAi6w2fTee5QsdI67QjR5OBqMLBQN7eDL32llnBblJTyGbmaDu3/p/VCzPkvtwUomYBm/eTtRCsy9qZhQegWRnZBmM9nfSXb2364MA+KpyRz/dAmRSQCdZORTP6jkLPe8FAIu/o9B63iTmOUupxJ+9HkPGKYRL7zc/1S+fSAj6apIIhNIk5QXy6TEnTC6aY/xi3Z2wImctn95Sfu6iEWFuXtK0bD5g97WMl2VppPhllrwcK09FPtrqhOCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+l5tFVCXXM27Sml5QfR0G3PCUSdb+Q5k9xcCntO+Go=;
 b=CZNNW/FiEfPDVBq7WpDKEN9f9PjtymR9tO9n9gkk7J6Sv/1ojQzcVasaqTPDIEMqeHAICO3Jnv1nE3c8Mywi+ZBgeEUBU1MGC/UJyNeiwhxaafDKmSH3BxhihTfqUGZjQCDlNGhfrGsuTJlzhw5WJtL6Xtoy8+iDurMngRA9Em4fYJklM4fK4lRJt/GGNZS/BEs3dO8/UJENr9KagmqvDA/4YjzAx6fUUBJWKXiDf1yIZc2keA8kCNKXiEomh6PPJbhW9R93b1hsASlQ5LJ3tnCOX9KC2kJp34FyUwUeyb4EtnYU94h65GDcHSzuSmfKIsJVKgxHJUFsSa7inTdlgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+l5tFVCXXM27Sml5QfR0G3PCUSdb+Q5k9xcCntO+Go=;
 b=Fj4hgEAJkDtVMaZYdYx9iqwWtWLQyClr4y7KVdSij0746mye+JjSJ4WUFpKtuWC2W8JztaRcIZo1flJXwx72ne52T1P7AT1G9TnmeSqZ345yNGbgrMeLmTjoOR5NECfAoemkR6xXJqM2dAPTpr2UdLEPLHHULQXSE1X8bWnMCr0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA0PR10MB6428.namprd10.prod.outlook.com (2603:10b6:806:2c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:52:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 18:52:38 +0000
Message-ID: <131dbce0-2cb9-43e7-a0da-f3ddadb4af02@oracle.com>
Date:   Mon, 23 Oct 2023 19:52:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com> <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
 <ZTa3n+1WQWRLrhxo@Asurada-Nvidia>
 <f9178725-5706-4d56-b496-5f1bc1c48ef6@oracle.com>
 <ZTa8QO9zmdt/bfcj@Asurada-Nvidia>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTa8QO9zmdt/bfcj@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0100.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA0PR10MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: b16642f4-8ae5-4dba-8a75-08dbd3f93a11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3PmcvuGJ8QG0owgXvOHAC8X599ZzGp0wa3Ocrc+6dAXL5zIW5B8pPaFPf/hvbT8/O0X1g4IMKR8Ni4qFgLph05wB5SbuFHULTE3GAU63Tj+NRSiffydLf590skkytu92WZSTxLpnLnfUx3Th79I7G7X5m7yLE79PTE6HUDgWXBNCjIulusYSbIETYn1Ploq5plln7eJ4Yh64fLMv0oQaFl3DzpILoBglzpYZVUzc14porgVR0RYNB/GqtL39bW3Wp1N1IBpEh4O4tGgMO5qbHCADp6IIUGtxpJcwXtqs20N7C6+iaBr+xDqCWx/xhI9uAl63WyicO8YPlBzYpirhNfieGVT8r91pse09wFQiXIjy0n0fNNf+oPTch4Idncxv1h/vRs+JfKNoNG5D6BRHr/whs4SHEa3WXnfAbpGtMUx4LoIWJAd5ZmYH/MCVlcPcGYFPBS7Zi3WUCh3N4lcQBwzRTUh/wQwGjpC109kyVbZfgOEkOi8vrKJe92yTY5CtJUXjPI38ZjPFl1AH17j8EpamYCt2Kzfsj749px8cm32g6+DHxIkivv4uZs86N1WdTEH9hwIfTd2wLIqsK8s6gl6Aw9a0FE/OkAK5DmkkOAAEvsK2GlJlG7NLV442jIcrvDBiduxUFwSHa7/GsOmUi1R7XoN+emvrvlNxLnQJy+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(41300700001)(30864003)(2906002)(38100700002)(2616005)(54906003)(66946007)(316002)(6916009)(66556008)(66476007)(6506007)(478600001)(53546011)(6486002)(6512007)(6666004)(83380400001)(45080400002)(36756003)(7416002)(31696002)(86362001)(5660300002)(4326008)(8936002)(8676002)(26005)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzNhWTM4SkdheHNlU2o5Yk5jVEk4dGIzeEFacjVhdjVtMlJ2L09zWW8zTlpH?=
 =?utf-8?B?bWdRbnZYcFdIb0x3WmFsbmRLRWpNUUgweTI5RzlDVkRZQ1l5c3JiSy8zY0R0?=
 =?utf-8?B?R2d3SzRMalZTeHhST3pDNGhSMnhXRGdHcnRCUGNEU2VhRzMxNCtKUDVVZVNB?=
 =?utf-8?B?aFlkSkRuM0xwVFFMQVI5bjh3NEhaVWo5TVkwamdQS0VNbkYvTWNRN2FVV0tw?=
 =?utf-8?B?TUlVK0RqR3pHUHpnYlN0cFdFVXR3U2oxZnh3cjZkTlQydGxCdTcvaGFjZEYr?=
 =?utf-8?B?TXFWU3NFL0V1ckl2OUNVcFZGOGNpUisreEZSY3YrT21lbFgyaGM3WVd3Z1BO?=
 =?utf-8?B?eW1yRHpZUWtVWHhGYitONlQ5VGt3T2hhUVZ3dFhHTTFWWTl3WDJ2RStic0JT?=
 =?utf-8?B?YnVKVUFBblF2dEtydEFKNkpIbUxCMlBtSnR6T1gwdDhrNklEeDVSaUJnVThu?=
 =?utf-8?B?a3NPUU1rb25NSWZTWHdGemR4aDEvREdPUk1admNidU5qdW4wQ3Ezbkd0aXRa?=
 =?utf-8?B?OEtFMmRqWFJ6QlFVSDZteWxCelJ1UEd0dStycXpLU1Nhdk02V3JVdncvdWox?=
 =?utf-8?B?QVdTWXRjYlpCc0JqRUJuL295UXlSc3FNVENJMExQeUJsd0ZWUDYwcHppemIv?=
 =?utf-8?B?SnAreG5sNnRWUVhMek4zcTRDUk1YMnJhRHc4ekZqaGlZZHBzTVVUeVArbE00?=
 =?utf-8?B?YUpDbmlaRFBjdkNIQ2FyNkNYdm5vU2tUczQ5MUtIQ1hkT2U1NFltTW5saUNX?=
 =?utf-8?B?eElhK2V0SGRiMUlYaStxOUFTRm5pUE9oZDdHVHdSMG4xYVVxTHVBa2pGYUpH?=
 =?utf-8?B?M3ZVcEZuMTdnREVsOWpBUm4xTXJVMFMxYllFeUJKZ0hiMndzUmdHVHpDU2Fo?=
 =?utf-8?B?eEo2dkdnK0t5OEdOaHJoZ1dXSXhmeVUyTW5OM0ptRVJUaVA2Y2hkaCtaYkl4?=
 =?utf-8?B?SU1NRktlam0rSTlUMVRhaFV0L1ZYaGhhc3VBdkJyTFNxVW5GcVFiT01RU1E3?=
 =?utf-8?B?bUFEdEU5N1hsY1ltRTJUaEpidC9wcC84ZnJLUjJ2YmxFZWtSQ0p0VDIvK3lK?=
 =?utf-8?B?NXZQSU55eFlRMVhVdFA5YnU3bjVKNFBCNDlWZlpWc0ZCT05pNkEzamU5alZC?=
 =?utf-8?B?RFpsUDBkYUE0bjFuelh4SFJyMFdiNWRNUldqcGtaTWZMekc3elB3Qmd5c1Bp?=
 =?utf-8?B?L3NiUHJrOTdtVVlxNHFZSHFITE5oVlY3NjlnOGE3T2h1UHUvZGNQZzR3NTF5?=
 =?utf-8?B?S1BlbVIvUWdqU0MrTHV2OUU0MlVOS04rdzN1djR5b0dNcVRpZVVuWkJsRUJt?=
 =?utf-8?B?Wk5JdkxER0N6ZGdKMUVCZ0hjbXJaaEpYdjVrZk5VaUZPaTdCRDU2clFqaUxE?=
 =?utf-8?B?QzBPUVA0ckNmNEg1YjRqSG9CZEE0NUdYQUVac1Vjb1JIME9GSDB1TjU2VTVE?=
 =?utf-8?B?dWw2d3JDWjIwcVJzN2ZvMHVTQTVmK3ZYKzYvWXBUU2VETHBCeFFCVlE5UHNi?=
 =?utf-8?B?ZjBMVG9NY0duTklXQTFIN3VIMlUwZUJRZFlHWXJJY3Nad0swK1BDREx1Ymcr?=
 =?utf-8?B?MG1VQnBGcEN5M3BvTThDU0FHaS9RRWQySHhGQWRHbXpIMnJyUHprS1RFL24x?=
 =?utf-8?B?akcrSlNMcUo3dUtqZmo3d1UwQkxmdHkzNS9GamYwUE1EK1hEUWVONnIwM1d0?=
 =?utf-8?B?UjB4VjU3R3lYUkhVWmVHL29Yb1dxaE5XUmhYOHg5K2lGTTcrb1ZBbFlOZmhj?=
 =?utf-8?B?eG9hU0NtS1RpVDdFNGV3RGRVMlhJTUp0SnZnOHhoVGpHRzdKRjlLZzU2ZTFu?=
 =?utf-8?B?MjNRUml6Z0xJZXBWN3l0U0lLaFRSL3MwQUpFS21INEpFRUxZaElDUWpPaS9Q?=
 =?utf-8?B?YjlZRU1JVFI5OHBKa0Foa2xvMzNWUWt3MHU5RVFQWStCQnBieDFNanZIMDkx?=
 =?utf-8?B?bUJPWFV3akNSaisyZmMrZ0RDWTluUXJCRjZ4Nyt2eGwvM1J3bUtQbHVVMk5y?=
 =?utf-8?B?d0hEODcrK29hMFd4QUQ4TTdqL3A2b2Y2N0NLMjBpNEloT2xoUmtxSWNzTHJ2?=
 =?utf-8?B?Tm5SbHA3QjA1Q0pUVjVVWGd2eW9DUE5uUkZLc0VqVEpnOEUxcW1xWjBpbDVG?=
 =?utf-8?B?dG1rRnFZbVVuaTZJSnpESXVtbWM1OSt6TEQ0REllTjJlMXBiOE9jeEVJZ0VB?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RjNHUG9YQVBZdXpRbkdVTS9pZ3RNMmFOalFaT0dDNDIzMUVpbUpydGxyY2hP?=
 =?utf-8?B?R0RnVDAzd0ZhWi9iUEFqV3g5WjM2djJiUDFNYXAxYVAyNTVZdUF6WjI0Qmsy?=
 =?utf-8?B?eG10QVFxY3BxRktFcVZxL0UzMXlXWW9TWlBsNWhFV0VDWWgzZTU2UXBBWnhP?=
 =?utf-8?B?bHQweTh4ZHhrMnA4TnRqcXlpVHBjMDBzVW5hZ1oyS2JUNWRXSnA1ZW81bDdh?=
 =?utf-8?B?dkxhRTh4b1NnbWhXZE96eGI1a2ZmcVpGTjR4RUovZ283a0g0SHpHZDkva1JF?=
 =?utf-8?B?c3UvdU1QejZ6cDNTTEVpbGI4UUJITjhtVUxaWkN2Vk1kYm1RcERDNWUrYjkr?=
 =?utf-8?B?VFE0YWV6aGdBQ056UW12WEJqRXVBaEk3R2lPaUY1S0I4ZlMwa0ZJci9wT0JP?=
 =?utf-8?B?UWsrcVlvd0NmOGdSOTNqQzcyNHEvTlVxNnk3WjhQZk1CK0lvOHlrZS85Z3hF?=
 =?utf-8?B?RlptSmR6VDB2Vkd3cnlWUm04MUVxaXFPWW5CYTJKcXZzVDdUZUxDY29BMEd1?=
 =?utf-8?B?QmRHUHJoaHBlYnNBUzR3eU82MGJheWlsN256dnUwbS9TRTgwUEVmVHQxOG5H?=
 =?utf-8?B?dXNEZnphbWFaVGVNZzQ4aTk2U2NRY1hTanBOcWVVcko5VUhaNGY3cWd4VHR3?=
 =?utf-8?B?akhwaHRJbHZkbDVJaXJvOThqS3krU0ZHU2tWb2ZrektoYXdLL0xVbFdJNGhz?=
 =?utf-8?B?dWFiMGViZTROWlZQNm1UVmM1bnNVYVVKQytMdHVzalZHcTc3ZEhjMGsxWlZF?=
 =?utf-8?B?OWFOYXJlZ1JkM2E2T3gwcGkvZnhRZHBjVEczdjlyQ2lOWUp3RkNwTE5kNmNu?=
 =?utf-8?B?ZkhzenVpdHdjQm5OMDJFalBvdnpIQnE4WXdHb0V3bTZkOGNDOG5oenRCdzEz?=
 =?utf-8?B?Q2NFUGIxZnlVL29FSjg3ODBMdGlYTW5aYjlMOEgrQjBac0M3eXdhZk9uL3Rk?=
 =?utf-8?B?cnZpZnhueFl1VURQK1MwcGQzQWJ3akdpSUM4ZkhtQndHdEpkdDF2d3BtcDBo?=
 =?utf-8?B?d3RMTlRzaEU0YW1KSmh1dHhLK00wNGR3U0FVQyswQ3VtbzhPcmRxdEhDSmtB?=
 =?utf-8?B?MUhaZC9kQlRtWWNJL29SckdXcXl2aUg5RnBKZXBkY21qTDhKNUVISzVzbjZK?=
 =?utf-8?B?b0grSGRoL2tvRndlMUFxcngvRUIyT3QveFhCaGRnT3NreVNjOTlKclR1M25q?=
 =?utf-8?B?UWdaUlpsbjZvS1NtVzBPZk5VdnZsSTlhckV5bnZBTzRFOTA0QmV4aFFSbUdE?=
 =?utf-8?B?QldlNUNCSHR6bkJmaXhoRHFPdTkvNlFRTks4dzhWdm9sNW9sbTZnb3Faa1ZR?=
 =?utf-8?B?bEp6R0RxVm1OY3VXYmNwbHVlZGx5dWtHaUIvNnMyeHFXMytuRFhKRDdMelJ0?=
 =?utf-8?B?ak1SK29tWk5vT1RwK3FwUHlVYTZJQUtEZWxpS3VuaWUwMWR6Z1ROOUZuNmRj?=
 =?utf-8?Q?Gy7jMXM6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16642f4-8ae5-4dba-8a75-08dbd3f93a11
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:52:37.9661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHDE9hPmksAjzIaCMDbxxabOKwpOqF+RerL+w5zsjzXYk8kZFHivOq6NpCw/RZKd4EDh1nLt3XK88UhSrh7LKN/6ahx32GqoeZF/O0Yps40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_18,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230165
X-Proofpoint-GUID: 3vIgVWVFywjT4GqL6ejY2RO8tT699J9P
X-Proofpoint-ORIG-GUID: 3vIgVWVFywjT4GqL6ejY2RO8tT699J9P
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 19:32, Nicolin Chen wrote:
> On Mon, Oct 23, 2023 at 07:21:09PM +0100, Joao Martins wrote:
>> On 23/10/2023 19:12, Nicolin Chen wrote:
>>> On Mon, Oct 23, 2023 at 12:49:55PM +0100, Joao Martins wrote:
>>>> Here's an example down that avoids the kernel header dependency; imported from
>>>> the arch-independent non-atomic bitops
>>>> (include/asm-generic/bitops/generic-non-atomic.h)
>>>>
>>>> diff --git a/tools/testing/selftests/iommu/iommufd.c
>>>> b/tools/testing/selftests/iommu/iommufd.c
>>>> index 96837369a0aa..026ff9f5c1f3 100644
>>>> --- a/tools/testing/selftests/iommu/iommufd.c
>>>> +++ b/tools/testing/selftests/iommu/iommufd.c
>>>> @@ -12,7 +12,6 @@
>>>>  static unsigned long HUGEPAGE_SIZE;
>>>>
>>>>  #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
>>>> -#define BITS_PER_BYTE 8
>>>>
>>>>  static unsigned long get_huge_page_size(void)
>>>>  {
>>>> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
>>>> b/tools/testing/selftests/iommu/iommufd_utils.h
>>>> index 390563ff7935..6bbcab7fd6ab 100644
>>>> --- a/tools/testing/selftests/iommu/iommufd_utils.h
>>>> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
>>>> @@ -9,8 +9,6 @@
>>>>  #include <sys/ioctl.h>
>>>>  #include <stdint.h>
>>>>  #include <assert.h>
>>>> -#include <linux/bitmap.h>
>>>> -#include <linux/bitops.h>
>>>>
>>>>  #include "../kselftest_harness.h"
>>>>  #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
>>>> @@ -18,6 +16,24 @@
>>>>  /* Hack to make assertions more readable */
>>>>  #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
>>>>
>>>> +/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
>>>> +#define BITS_PER_BYTE 8
>>>> +#define BITS_PER_LONG __BITS_PER_LONG
>>>> +#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
>>>> +#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
>>>> +
>>>> +static inline void set_bit(unsigned int nr, unsigned long *addr)
>>>
>>> The whole piece could fix the break, except this one. We'd need
>>> __set_bit instead of set_bit.
>>>
>>
>> I changed it set_bit in the caller of course
> 
> Can you confirm the test results too? 
> I am seeing test failing
> and BUG_ON since this commit:
> 
> 1d2ac3b64486 (HEAD) iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
> 

I always do, in my case all my newly introduced tests end up as below output.

But BUG_ONs() I never hit before. For what is worth I have trouble running the
whole test suite so I run my added specific fixture. I hit this one specific issue:

# iommufd.c:648:access_domain_destory:Expected MAP_FAILED (18446744073709551615)
!= buf (18446744073709551615)

-- -f iommufd_dirty_tracking logs--

# Starting 25 tests from 5 test cases.
#  RUN           iommufd_dirty_tracking.domain_dirty128k.enforce_dirty ...
#            OK  iommufd_dirty_tracking.domain_dirty128k.enforce_dirty
ok 1 iommufd_dirty_tracking.domain_dirty128k.enforce_dirty
#  RUN           iommufd_dirty_tracking.domain_dirty128k.set_dirty_tracking ...
#            OK  iommufd_dirty_tracking.domain_dirty128k.set_dirty_tracking
ok 2 iommufd_dirty_tracking.domain_dirty128k.set_dirty_tracking
#  RUN           iommufd_dirty_tracking.domain_dirty128k.device_dirty_capability ...
#            OK  iommufd_dirty_tracking.domain_dirty128k.device_dirty_capability
ok 3 iommufd_dirty_tracking.domain_dirty128k.device_dirty_capability
#  RUN           iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap ...
#            OK  iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap
ok 4 iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap
#  RUN
iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap_no_clear ...
#            OK  iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap_no_clear
ok 5 iommufd_dirty_tracking.domain_dirty128k.get_dirty_bitmap_no_clear
#  RUN           iommufd_dirty_tracking.domain_dirty256k.enforce_dirty ...
#            OK  iommufd_dirty_tracking.domain_dirty256k.enforce_dirty
ok 6 iommufd_dirty_tracking.domain_dirty256k.enforce_dirty
#  RUN           iommufd_dirty_tracking.domain_dirty256k.set_dirty_tracking ...
#            OK  iommufd_dirty_tracking.domain_dirty256k.set_dirty_tracking
ok 7 iommufd_dirty_tracking.domain_dirty256k.set_dirty_tracking
#  RUN           iommufd_dirty_tracking.domain_dirty256k.device_dirty_capability ...
#            OK  iommufd_dirty_tracking.domain_dirty256k.device_dirty_capability
ok 8 iommufd_dirty_tracking.domain_dirty256k.device_dirty_capability
#  RUN           iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap ...
#            OK  iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap
ok 9 iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap
#  RUN
iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap_no_clear ...
#            OK  iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap_no_clear
ok 10 iommufd_dirty_tracking.domain_dirty256k.get_dirty_bitmap_no_clear
#  RUN           iommufd_dirty_tracking.domain_dirty640k.enforce_dirty ...
#            OK  iommufd_dirty_tracking.domain_dirty640k.enforce_dirty
ok 11 iommufd_dirty_tracking.domain_dirty640k.enforce_dirty
#  RUN           iommufd_dirty_tracking.domain_dirty640k.set_dirty_tracking ...
#            OK  iommufd_dirty_tracking.domain_dirty640k.set_dirty_tracking
ok 12 iommufd_dirty_tracking.domain_dirty640k.set_dirty_tracking
#  RUN           iommufd_dirty_tracking.domain_dirty640k.device_dirty_capability ...
#            OK  iommufd_dirty_tracking.domain_dirty640k.device_dirty_capability
ok 13 iommufd_dirty_tracking.domain_dirty640k.device_dirty_capability
#  RUN           iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap ...
#            OK  iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap
ok 14 iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap
#  RUN
iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap_no_clear ...
#            OK  iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap_no_clear
ok 15 iommufd_dirty_tracking.domain_dirty640k.get_dirty_bitmap_no_clear
#  RUN           iommufd_dirty_tracking.domain_dirty128M.enforce_dirty ...
#            OK  iommufd_dirty_tracking.domain_dirty128M.enforce_dirty
ok 16 iommufd_dirty_tracking.domain_dirty128M.enforce_dirty
#  RUN           iommufd_dirty_tracking.domain_dirty128M.set_dirty_tracking ...
#            OK  iommufd_dirty_tracking.domain_dirty128M.set_dirty_tracking
ok 17 iommufd_dirty_tracking.domain_dirty128M.set_dirty_tracking
#  RUN           iommufd_dirty_tracking.domain_dirty128M.device_dirty_capability ...
#            OK  iommufd_dirty_tracking.domain_dirty128M.device_dirty_capability
ok 18 iommufd_dirty_tracking.domain_dirty128M.device_dirty_capability
#  RUN           iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap ...
#            OK  iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
ok 19 iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
#  RUN
iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap_no_clear ...
#            OK  iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap_no_clear
ok 20 iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap_no_clear
#  RUN           iommufd_dirty_tracking.domain_dirty256M.enforce_dirty ...
#            OK  iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
ok 21 iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
#  RUN           iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking ...
#            OK  iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
ok 22 iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
#  RUN           iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability ...
#            OK  iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
ok 23 iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
#  RUN           iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap ...
#            OK  iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap
ok 24 iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap
#  RUN
iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap_no_clear ...
#            OK  iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap_no_clear
ok 25 iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap_no_clear
# PASSED: 25 / 25 tests passed.
# Totals: pass:25 fail:0 xfail:0 xpass:0 skip:0 error:0

> -----logs-----
> # ok 133 iommufd_dirty_tracking.domain_dirty128k.set_dirty_tracking
> # #  RUN           iommufd_dirty_tracking.domain_dirty128k.device_dirty_capability ... 
> # # iommufd.c:1577:device_dirty_capability:Expected IOMMU_HW_CAP_DIRTY_TRACKING (1) == caps & IOMMU_HW_CAP_DIRTY_TRACKING (0)
> # # device_dirty_capability: Test terminated by assertion
> .....
> # # FAILED: 151 / 161 tests passed.
> 
Thanks

> -----bug_on-----
> [   29.209521] BUG: unable to handle page fault for address: 000056258adc0000
> [   29.209771] #PF: supervisor read access in kernel mode
> [   29.209965] #PF: error_code(0x0001) - permissions violation
> [   29.210155] PGD 112975067 P4D 112975067 PUD 112976067 PMD 10e5a8067 PTE 800000010973b067
> [   29.210446] Oops: 0001 [#1] SMP
> [   29.210594] CPU: 1 PID: 857 Comm: iommufd Not tainted 6.6.0-rc2+ #1823
> [   29.210842] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [   29.211267] RIP: 0010:iommufd_test+0xb7a/0x1120 [iommufd]
> [   29.211480] Code: 82 a8 00 00 00 4c 8b 7d 90 c7 45 98 00 00 00 00 4d 89 cd 4c 89 5d 88 4c 89 75 80 48 89 45 a8 4c 89 95 78 ff ff ff 48 8b 45 b8 <48> 0f a3 18 73 5e 48 8b 4d a8 31 d2 4c 89 e8 49 f7 f4 48 89 c6 48
> [   29.212131] RSP: 0018:ffffc900029f7d70 EFLAGS: 00010206
> [   29.212348] RAX: 000056258adc0000 RBX: 0000000000000000 RCX: ffff888104296498
> [   29.212638] RDX: 0000000000000000 RSI: 0000000094904f49 RDI: ffff888103fa23c8
> [   29.212928] RBP: ffffc900029f7e00 R08: 0000000000020000 R09: 0000000001000000
> [   29.213214] R10: ffffc900029f7e10 R11: ffffc900029f7e30 R12: 0000000000000800
> [   29.213501] R13: 0000000001000000 R14: ffff888104296400 R15: 0000000000000040
> [   29.213786] FS:  00007f485e907740(0000) GS:ffff8881ba440000(0000) knlGS:0000000000000000
> [   29.214072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.214310] CR2: 000056258adc0000 CR3: 0000000112974001 CR4: 00000000003706a0
> [   29.214592] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   29.214882] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   29.215171] Call Trace:
> [   29.215265]  <TASK>
> [   29.215358]  ? show_regs+0x5c/0x70
> [   29.215496]  ? __die+0x1f/0x60
> [   29.215638]  ? page_fault_oops+0x15d/0x440
> [   29.215779]  ? exc_page_fault+0x4ca/0x9e0
> [   29.215923]  ? lock_acquire+0xb8/0x2a0
> [   29.216064]  ? asm_exc_page_fault+0x27/0x30
> [   29.216207]  ? iommufd_test+0xb7a/0x1120 [iommufd]
> [   29.216435]  ? should_fail_usercopy+0x15/0x20
> [   29.216577]  iommufd_fops_ioctl+0x10d/0x190 [iommufd]
> [   29.216725]  __x64_sys_ioctl+0x412/0x9b0
> [   29.216823]  do_syscall_64+0x3c/0x80
> [   29.216919]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [   29.217050] RIP: 0033:0x7f485ea0d04f
> [   29.217147] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> [   29.217593] RSP: 002b:00007ffddef77ca0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   29.217785] RAX: ffffffffffffffda RBX: 0000562588e29d60 RCX: 00007f485ea0d04f
> [   29.217982] RDX: 00007ffddef77d30 RSI: 0000000000003ba0 RDI: 0000000000000005
> [   29.218177] RBP: 0000562588e29038 R08: 4000000000000000 R09: 0000000000000008
> [   29.218372] R10: 0000000000000001 R11: 0000000000000246 R12: 000056258adc0000
> [   29.218567] R13: 0000000000000000 R14: 0000000000000040 R15: 0000562588e29d60
> [   29.218772]  </TASK>
> [   29.218835] Modules linked in: iommufd ib_umad rdma_ucm rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core
> [   29.219117] CR2: 000056258adc0000
> [   29.219216] ---[ end trace 0000000000000000 ]---
> 
> 
