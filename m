Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186CE7CC5AE
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344031AbjJQOP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344025AbjJQOP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:15:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144B2F9
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:15:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEDshb006320;
        Tue, 17 Oct 2023 14:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wZdhhqaV5RJmdxXlQHhgKfxvaO1DrCJb2vBm5hBoVy0=;
 b=TaGA0tuet55BCv1MEXZnalA7KFMltJgdsUXOsNJQdBZOCr8rC2ZEWj+PocS5RYbnzXjo
 IAVfXKSV1DMnquhcLn+hVeuvzwSRnMKMOiqgse8LU2NSDzt2hRFg6ZbYZcIxoGoWexuP
 tO/gAs2HM3x/1Bk4mHdhNUMNlDY+l1xowoLZXNlt64LHS8IYB+rrFzS9lkQuBpCweoPz
 oEitqYgZWbxXZ7/JOmqSRpO+do/Or6Dghz736PB0O7hPJxrkVJdMmGq5OYfU4eIVGskc
 FPGpBe4AMrcWWlpSORn0W2HOXnTK0NCxl5k5RasLW+0KjcKqD11CXdKyzM2OreUKG9KZ uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynd8dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:15:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HDlOTD015340;
        Tue, 17 Oct 2023 14:14:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1f3pr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:14:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGbJpxAE6XlP5Aa+B1ApypiIkcEj6DLovErsn9Jsncf1ClUsHxpDeQE+kM24MLNt0cWx5jy7VbAXP8Ex/mmD9dMfwrGi7LmfHh30MPrT0GInKpUZDEfrBZK1s/TuG4+FGPuC7868S+AyaTHoxCKV9UrrUfjUXE7gaCe07rqRIg3Y3XwLIcGf8eygobRZRXuUdvAQhabZ7hn10xpc1muSQgrUPvvf1C+irHQLk1svBkutB+uULIYYDhqT/arw+bMdVGWn/FBmJQ86y1hMOISY5SSC7Y+c+I4iCafVk9UzctttaUnu5NaETosFfl8IUvpjJvT3qXNpWw/1Xv+Xf3WIHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZdhhqaV5RJmdxXlQHhgKfxvaO1DrCJb2vBm5hBoVy0=;
 b=KusCjl9RLugw2eeMOYxGSSfXUnsP5yWvPTkRa/Qu8+eItobq/WJxwiX6qazsLd6iJRGsgSbEF0AfODKixlwYZY2O1tBysu6RlGBxB+d/4MuQp1ShP3c5jZuAnIcp5zAGkZKZrsauNoVsvAUPe+FkXFtRTewRL8LgItaI4ECxb5TNvUZ4NIfK6Z9/KlDlPNTLAOaKucaGdwD0duH0lTUz4G9wQyPN/tRXF3XM2Go/2aNusB+Wr2uOhReOyQyA5vS6KYaCyX/NwOY141sn7H666ly4BYxXT8AmD2kZjEeDPPbeF053pvziMCtGWPTbouWSlrCCBe1uBswgr4dChXW6dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZdhhqaV5RJmdxXlQHhgKfxvaO1DrCJb2vBm5hBoVy0=;
 b=gSH33CH4nbK6Kbi2/ERB3ZLVLFngaWbQ9ghAmOecXr69pxAyw7pQaXDjXv+OYhC8pejTlQA0pCnb5A7kM7CsINbJ3fknAepAx23LzjE2GQQz0Pb4ey/G3knllMKo08fsWoVmHPnAvp77w9xEE5ZHyY3lUOjQkHv8g62nWonrskw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB4267.namprd10.prod.outlook.com (2603:10b6:5:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 17 Oct
 2023 14:14:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:14:57 +0000
Message-ID: <8f34e144-0ec1-4ca0-9e41-29da90aa7aef@oracle.com>
Date:   Tue, 17 Oct 2023 15:14:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
 <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
 <20231017131045.GA3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017131045.GA3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0046.eurprd04.prod.outlook.com
 (2603:10a6:208:1::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM6PR10MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a7525e-129d-4ea9-ae43-08dbcf1b7103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUOSZzsMvxGu/1WR7ycq2uWW/E4lwXcb73KLtfDCmmdPItSnwh1zBqGIJPWrIXb0JrTShsYIHnew2WobSZUPEDksUQ7QrXZ2hb+kqimIG1QmHUOX4idSoFUvMPAG5541QAgAWihWTn4snSW95QgszFeZzapP3mLyeC0/DXKGmlQaInRhCDOuabAlkp7zTcoxDpH0YOvhxXlmkh/1fDoyTpx7JRBek2DuaTbn9URLtkCoTfRSPw5BZvvAdrR2Aveja5zNwxjlPVA+OkZw9AP2ND6H3V84IeUeKdzwpSkWM8P5NoMloHbG93zPAYGRPHkaETrnsir5XWouFdfBGK6R8RzgjU4NECXTRdsuKVcJofaR0bqok71Qi+aiatpQlrLSxoc0Pd/wV3ARlR8I2N9QFHnll911SpI+xGSIJlxY30CZlWVb6/C2dkrNC0o0yV9N7VoFoqWkOsXPRNs74xPcsNp5xjOC3tMMx9O7CGcUffJfiPxxwFqOpZVXBGmjagN8q/bOce1nEy4zsdLNYUYvFrKptlr5VeJZOhXGnKSNpL549dBw2y79bQSmvXXKiF3zupKFJfvb2OU9fJou8xPs68uf8GdwRQJoF9DZUhT4I26CkkHWzVSdFJ2k0wIxdF7/AwratFDzKNX5WR6BDt3G1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(136003)(39860400002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6512007)(26005)(38100700002)(2616005)(36756003)(66946007)(7416002)(66476007)(54906003)(6916009)(66556008)(41300700001)(8936002)(8676002)(4326008)(316002)(5660300002)(2906002)(86362001)(6666004)(53546011)(31696002)(6506007)(6486002)(4744005)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDQzMmg5bk5SZUcvN3k3UjRvNzFsdW94V3E0c0pHM0MwcWZiS3Y0eFdiWTQw?=
 =?utf-8?B?QmVrb1ExRU4yajYyeWVxWmI2Q0RTUStNK2lxb3JrbURFSHBzSEVFV2tvNURO?=
 =?utf-8?B?Y0llUmp0cDRzbWMvK2o0ditGbXVCSjlWVW12UHRFSEFQdkl1V3V5MldQU1l0?=
 =?utf-8?B?MU1abFgzNGI1SXBTcm1aZ3hxeDRRYW02YjBvaHNYMDFZNUkvcko0c2RVclUx?=
 =?utf-8?B?R2MyRFJaMTYvYWJNYzlGcTdYaXVJdVJuTnBHYU5BbTQybG5QSjFOVmxlMEYz?=
 =?utf-8?B?bzIzeDlPSFIrS1JKZFVlZ0dPWGs0T2ovT3ZYL1BqR2xwT3NDWVZ6K2J4TlVS?=
 =?utf-8?B?ZElKd2xPS0RNRUlCQlBkbWtVb2czU0R0emUvUXQyYU9CcWNROXlsNEdSaVpX?=
 =?utf-8?B?N3NNRE1PY2c3eXA3ZUFuSTEyb09TMXhJTjh2aEdGTHlwRkgrTjhmQnFvR1hX?=
 =?utf-8?B?WmlhYllTNkRobHF1dlNHZGFtOXZDQzJhRmZzRTJvd1hmWU5pUGcxc1hGMGkx?=
 =?utf-8?B?cWZNb3dSTWRXWEQ3Q3RTUlAxY012OUFOUVhjdDZ2cFlpZXRiVmpsWStDYzRT?=
 =?utf-8?B?L2R1VGhtRWFmUThVVXlZQUhtTmVHejJLQmFIYy9HQTkyY3RjMjVnNTRlRmJh?=
 =?utf-8?B?YVVVWmx2UUZaandUZUxiek1rZlc4TlV5U0xFUG1zajJzNFR3aDJyYzZmVVVC?=
 =?utf-8?B?V0RUMkdkZFdab1FDamd4eWdlYXRFZ1NnVWN3RUlqQTVqYWFOUTNFbFk5WTdi?=
 =?utf-8?B?a3Q1OXpaUVVoUFNBUGpnclZSbnZWa2QyL01LRHNCQ3VsU0JXU0RXWnludEVM?=
 =?utf-8?B?SDdENHFvSXZvV0F2SEI1QW5RNDJZTzNsUDBicXl4NUhRVTNJOC9QODcydVJI?=
 =?utf-8?B?dlN6b2twbzQvSVJQTHV0YW5lUE9NS3BmSllSTk1KR1RzS09kcWhaTlZ3RTVz?=
 =?utf-8?B?VzFCQnNsaU9GR1N2VnZDTU5nUUZsbEtnSFI0VjQ3N2ltRE8ycTFEZE5hZkNX?=
 =?utf-8?B?SnR1T1Q4L0tDMUxCc09DUjdta282V21ITjdtcHlqcVhneVpiSTBTTlNDZEM5?=
 =?utf-8?B?SC9mT3lTYlZRRWRTM0QwVitJVDRidzBtb2xQQW1oSlJqa0dBa1FqM0IwOEps?=
 =?utf-8?B?Vmtrc3dEeXA4ZWtXV3NDM0xLTm1ubDgxaHJ3Q0ZFNHhCblMwUnBjOXhXL1Jo?=
 =?utf-8?B?aDA2QkhCUTlhcHV1d3hRRUdQTW9qbExnVW5MTWpzOWdqcWdEYW43cFcwYnhs?=
 =?utf-8?B?VXc5d2lLQzNHN080aStaTjVaVnpVMm9uTXY2eDdRZ08ydFJkdEkrdkp4TCtu?=
 =?utf-8?B?L0pKbThoSHpxdlpmVmJWUUREUGQ2czB5MXNlVGJnNUdlWjVaRXQ0elh0THBT?=
 =?utf-8?B?RDE2R2xVUXAvekdrbVczYWVId2VXandWM1FrVHRjdDUyZitXS2lOQ0hLbGQ0?=
 =?utf-8?B?V1RSUGNmRnlVdWtDUmEzZXVPbCtUYXVMMkE0cm11UTR3MVNjS0hrRW1UblVq?=
 =?utf-8?B?d3dzdjRMU0tKTTQ1R0JNbDlyWlgyZnVLUjQ2S3VUU3hER29mRHJ1ZGF4MElt?=
 =?utf-8?B?bDNqSjNOekZzTFpUVWlzdTZ1ckJVQUQ1UlRnTjhWY1pFSVdtMjVLMWIwbjFp?=
 =?utf-8?B?d2pjNlRmb014Y3JLbGlia3NhQWVVeWhEQktORjB0UStGdnoxYTlFL1pRbGp0?=
 =?utf-8?B?dEdZMkkrK0tiYkpjOEszMnduZ29KKzZFVXpQMnh1V3hSN3R6TDJibmNMQkFO?=
 =?utf-8?B?NDkvY0I5VW0zVUpDOXg4U1BHMHNvMzhwVVpnVDQ2RTVnWTByTkhNVVdJSmN3?=
 =?utf-8?B?cGFGOXIvMWpIRkdvU0FoVGpXczhYZXRjMmhvNXJVcU4vY0JkcEgxbjZ5czho?=
 =?utf-8?B?TWRQN1pkazE2eVk1MmEyZFFteTVuVU5nZVdvQmhMbkdKOXM0MER4NUU4S3Ro?=
 =?utf-8?B?MWF5bkRuT0RyM2hHUFNHWjJwSFRnQnNVTFVEUkY5UVBId3k5bklIVXd1Rk5a?=
 =?utf-8?B?c2lQSDVvRk51YllUSUxTMmZYTUhLMWpDYmwwdmRtZjRucjFVTnVra1pLNGUv?=
 =?utf-8?B?YkhiYUtBMTN6Vmh2cDU2M0Y4Tk1kQTJQUGMyc2ltMUM0dW9yWjFIM0lHN0My?=
 =?utf-8?B?Z0RZWnUrOWRHaThwTTd3YTZpdlZnWThwaTk1TGtzeVdNVVRHQ1gySUYrb3hn?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Sk4zUkhEdTJkUW9IaldiNlRWVCs1a01JUzVCY3ZFbWFwY29SSVh6NjRSSzZk?=
 =?utf-8?B?YURMYU90OTZpTUppa1pjMlNJbTFoa0pmV29qZ3R1QlU1NHlQMHNxaEYwbGxz?=
 =?utf-8?B?amdPb3paOEVsUnR5NUp4OElYTmUzaUFKVVZJMys1aXRUYWMwdm81aG1NMDJZ?=
 =?utf-8?B?d0FYVlpyOWtvczJsSXB2QTQvSVFCSzhiTVp2YUU5MGtVRHpKV3ExRXdvYlJz?=
 =?utf-8?B?NXNlRklteGhmbGxQYTVpcGJnalphOENONzFtYUJ6S2d2TVcwWER0dTN6WDF5?=
 =?utf-8?B?YmRQNFJjRkdEN213aHRqT2kwcDMvUy9ENW5oamdqbXFISktPNEx5QWZZKzd1?=
 =?utf-8?B?K3VGTXk4UDNnWXZOTWpjNHJDc2NiSGdHY1ZBc1lJUDJmbEsyN1hYaXhMeGMx?=
 =?utf-8?B?M2c5OTZqRkZkZWFyNzZOL0U0TVByRTAzbVlPZGdXRzd0bERscnM3OW9FTUh2?=
 =?utf-8?B?RXRTSThXQUovd0lNb2xtODJNbXFSZSswY3VsOVNMU2d6dzhuQnpva2hjTGIz?=
 =?utf-8?B?RlFCWCtHMGNuT3ZhTWt5Z2FkTG9KalB3QUdHcE91UDZ4MWEyV2tWU0E2UlpG?=
 =?utf-8?B?WjFGNnluSlcySTB5YnRQSDAydzVqbUc1bnMzT1IwNEVWK3JMZll4Q2kvWEwv?=
 =?utf-8?B?bnBiN2hEaG8rcWxKclhMU2pWWDd5ZlM2dWVQUDN0SHJIbE9rNWdvM1lJaFlM?=
 =?utf-8?B?alFFdW9wSWczT2hJQ2J6L0hBa3N4QW5PTytKNHJOcFA5VmNKVW5sczlwQlI2?=
 =?utf-8?B?MTB1OWNZRGJ6bXVBOWhDdG9lK2lUdGJSSTdGNXk3dGVERUhVbnRlRHZNMTBq?=
 =?utf-8?B?OHJ5c0lwL3NuSWJjbXhJcGErL0E4NWpwT0s4Tll5cVpKaUxBTFVhUkdHeXda?=
 =?utf-8?B?NVNTM09DVC9oWVRod3BsWnZlcWFaSlhtYzQ5THlGUklhdnN3c3NtYTlOeUtD?=
 =?utf-8?B?ZFhISUpSQ0VvVTBpeDdZWXRVTWFTNEpaMzVmMGphdmRnY0k1TTRGcFpwWFdX?=
 =?utf-8?B?cURlSkFsM1VWK0dLczZGY1hCVXVwM256cDVkdERJeFltaTUxQXU4SWtoMnRy?=
 =?utf-8?B?MTdBbG52VkVWeTUweDF3UWJyWkE1bkJnZFpnckRpRHZpQVA0NXNFdDg5azdB?=
 =?utf-8?B?VC9waTVCRXROanNlcE9kQ20xZDk2clhTL01tRWhQaDQvbzRFM1FJb1BJbUpT?=
 =?utf-8?B?RHR3MFp5RFdGaWxmeUk0VEJYaGNNTVBRckFRWFkzaGp5c01PUUNMYUM0RkZx?=
 =?utf-8?B?Wno4WTZaYUZla095NktvblVkRk40WlFlamp2eEttUFdQN1B0SDFzMTFBMFVF?=
 =?utf-8?B?T0tqS1I0L28rT2pUSXlKM0J5REFla0NsY0NqV2J3UGVtQ1g3Zm5PTWc1YlFS?=
 =?utf-8?B?Yy9RVDhrWm9Yc3FPMzM4RXZ1MTJvR1FkbEIzRGhPRnlrYlNsc1JUbW5vaUNp?=
 =?utf-8?Q?MJ5EzcDv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a7525e-129d-4ea9-ae43-08dbcf1b7103
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:14:57.2246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22zhB07tKsXEpuNyq5PBidpO9W+MhAe9Qpj9eokydnwXN9cYwACNC3J113VQvbiZ5CfPSuXG6Trq36nppxaOc0hUOvyQje2pHm68ybHJwJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=882 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170121
X-Proofpoint-GUID: kS9S8B06rFkw8szAV2nuxdhJ30RVhsxE
X-Proofpoint-ORIG-GUID: kS9S8B06rFkw8szAV2nuxdhJ30RVhsxE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/10/2023 14:10, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 10:07:11AM +0100, Joao Martins wrote:
>>
>>  static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
>> -                                                 struct amd_iommu *iommu,
>>                                                   struct device *dev,
>>                                                   u32 flags)
>>  {
>>         struct protection_domain *domain;
>> +       struct amd_iommu *iommu = NULL;
>> +
>> +       if (dev) {
>> +               iommu = rlookup_amd_iommu(dev);
>> +               if (!iommu)
> 
> This really shouldn't be rlookup_amd_iommu, didn't the series fixing
> this get merged?

From the latest linux-next, it's still there.
