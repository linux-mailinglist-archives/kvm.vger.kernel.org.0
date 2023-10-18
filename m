Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1E7CD903
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 12:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjJRKTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 06:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjJRKTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 06:19:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D96DFF
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 03:19:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39I74DnK027010;
        Wed, 18 Oct 2023 10:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=288mm2LcgEHvo8pkJIJKLlw41zfIw9fTczvqCSY9/R4=;
 b=vWgEKoHwlZg72VUoPkheeHdUmKz8ixiT7702iyXU1ka1ON4r5SDayBfRCsmv4rQsVKzA
 oDtM+p6lU+7zOqpURmf4323bZ4qXJik0d/V7jEkJdfKjN/1ncBLiFcfcbAaU3abaXgrE
 dMaCttdD3kvYAfeyUItPciDa2e1y/W0pulnHj1SfogSNJ6oiiostyLgoJiJ+h3SdAOb+
 wXpT0Z+UkorUvcjmbl5QFVq1CR9f6IgaPjqNSPE4Nrp2t0zx3IPjTGdVivB7zod069FE
 k8PST9aPXHuZn4q8R36y89y3hTCacb0dsS3a9b/CGLTOaBrTJve2Zsq/wNd18BTnAefg 3A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1f56g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 10:19:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IAG2bZ028200;
        Wed, 18 Oct 2023 10:19:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy4thkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 10:19:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ1bI2ak5FXIwIcwFeXaf4DPfbC8JLDHpyekeG3INnswEjtVsHCO5Efw0k7DY4Upax/fA/8Oy+b5QjcecgOYbRYcdP95xz8SilwHOSqGZZV0dpzKrupwr3m2RMDSwGCgps/fL2c79lwjpVexfkfPRSH30zD1h9E+FCbqwXgY3rDm6wWEfmOjc0gJNMIVHrpKVtyJt3YBAdwsegsoHWFoZZeWjkkmsmV7VB7gZso+FCNIyWFkjc300sFWUKxKSrcsRdg4BgSE79bg+upuq1YQwKgzdrgYcRZ0e609GJOIclnW2YPIFuTVsSvKv3XIjM2iRkYrg5GUgUHg069EoRdbeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=288mm2LcgEHvo8pkJIJKLlw41zfIw9fTczvqCSY9/R4=;
 b=m7v0zyFREAxcIJ/FXZvKzAEBh466bgy9zV6MCymuIKS755MN3sAIP1A04yxSnmvtnS2WN/MEE1eA/wWEI5G+ojP+bAf14tYTnaJeR0hV+PBgYY41p9UWkr+opsumEq/ZMmz7RpiyxdL4C09L0GpKF6sC0ty/wn2yq9n5xXOtjQeQ4wFntnS40PuWLWBLvHPQQq98u58TN0J94fi6+BsjzL8rYlgF2SsDUFlrOpjIHQcaUepT6gon/qV/oDajX3uO0SFYU/aasSooA0mT+m9uwpWZVzZ4ju2bVihf3VjIvweqUebwXqp+5TvGNAwVDwHXIL/qrTDW1r8+aVIuOnvGcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=288mm2LcgEHvo8pkJIJKLlw41zfIw9fTczvqCSY9/R4=;
 b=fbGJVh3RFb52/m0ez7qYq1RmfvNr++Uu0JqMCzk66KpVSM+WIY5x7HxgxTfqU3EWkTz8Sy1Vn5TH16tjfQqAi7dwNOGjXyjLRENEs9id1MaSK+IFY9ie5+yCdZ9NAB5uuWa8YvdSRb4v0s/+pdbZf5xsB0StDPM6bEGe80sHLiM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB7147.namprd10.prod.outlook.com (2603:10b6:930:75::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 10:19:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 10:19:20 +0000
Message-ID: <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
Date:   Wed, 18 Oct 2023 11:19:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231016180556.GW3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:195::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b91d72-1cae-41cd-2ecb-08dbcfc3b159
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVAEwzEv9ld27ge1y/3AIEdRogdRtjMdGK8h8tzsiB0bTQNoSXN7DyVFzoQBtpJwRetPdIaoUqdNfiEvZz2QX/vRjPGb4EGyih1KU4FuLEizPTq5RR89cnvAFgy/gfVGLuqaDyh6OdVjYE1UuYFdN1VCc+1jVsakeXXugL4FSa1JHGNU17OWH46VNZVdD/UyCgcwLOBiW8ueN0MiBYRogyyN7CCi1WgEayfsEAkwNZr4sGn63pTdLv/nGeb4XUeNLYvJlTHR8f0RCT7arLLv7isF8C5NKKYN04Ih4iT14EupiPSpWpWX920isYgs+JG20AGJNJsVXrA783IH45pSiQyfEpePWdJLCTcJpuFhQ9hPg/ugFTdw5J7jT/+kI4k6tF9LeAKTM0gkBIMgcHdmdGO04XxzTbCdNzx24KTyDb8mRstCFvR4JvBelYFA+ALlVE786SuzjinvxLcBp6db75BPQF1Dul3hJ6FIqXizmoDzoHarvUqIxvMPaDWuzLIagPQBnbtZ+eqGkv85M1Fhcw1ZJp5ZOquiywC1iooD036Ty4eg9tceJnVGwbdXtmCNMNF/69ybdbqs2my4k7yWs2Lf8caEbh8XMvklI8o4RsIRcv0rjFpkIGPUyllLcYg90H7TU0FJcVspIsIaaSrpiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(366004)(346002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31686004)(54906003)(6916009)(66946007)(478600001)(6486002)(6666004)(66556008)(66476007)(316002)(5660300002)(38100700002)(6512007)(53546011)(6506007)(31696002)(36756003)(86362001)(2616005)(26005)(7416002)(8676002)(4326008)(2906002)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?citYSGJDa0cyZkZDL0h0WXByTTlhY21XUWROUHMzekQyM29WZ3V6OCtNV0o3?=
 =?utf-8?B?dDFmVG5NeUxZMWErNFAxZWgyeVU4UEZqTFJxbjdzSlRGSFNUTldjQ0RPUU1j?=
 =?utf-8?B?dDhicmZlTEJhOCsxRlVCMXhDT3Y5RTJiZE9EdUtzVmwyRUhpNkRCSitrOUpq?=
 =?utf-8?B?WTM3a1RDUWM1VnEvN1ZFR1o4VjRTN3RhMkY2VitOTDlPY1Y4cmQ0c0gzRGp6?=
 =?utf-8?B?YitkY0h5a04vSG5sUm1ZR2xFUFBRR1RFZDh5RXcwWnFmcWNNc0NTcmQxU0lz?=
 =?utf-8?B?TVgzYmZ0SUpEdTdYa1NRVmtrTHVNV1RidklMMlA1cE1Ud3BTK2lDOXVCWVNS?=
 =?utf-8?B?TktPNDliTG9yU2NoOEc0Q2JEcytrZWJva0lBWWFEbi9NWHhjS1NucGlZR0Rj?=
 =?utf-8?B?L2Vza3NSN0s3Tyt4UitEeTh1bkVNR2hzaGR2L1B3M1diMERoenJLUjZiUDZq?=
 =?utf-8?B?cG5MRXRYT1FpN3Z3NEdlWHVuaW1LVjREMnNxSkI3VlMrWTMwOEFxeGp2TVJG?=
 =?utf-8?B?QURYWnZveW1pb1l0S3hrZm5neXZsOHgycUtRbkRWMzZYYTRhcUpYVmxHWWxX?=
 =?utf-8?B?UDE3VStCWnBmbVltWFJVaEszei9DUjVyZEszcHgreHlmN1ZGRnRDMUxaYjBJ?=
 =?utf-8?B?ZXVmdnZyWm1HMEx2QzFvd200ZEszWWNMRlBvS1pUOFVzSDUyaExYem1WMVcw?=
 =?utf-8?B?K1NJQkU2WEZaZFlpNVhFUFEzSWE2UFRnQU9ySTBMMkZrZkhBWlFaYkVkTDlj?=
 =?utf-8?B?dmQ3MmFuZWhhYkdLLytuN3NrdmFXR2ZZWko0VHFuNlVZSEQ5T0dTT2xCNld4?=
 =?utf-8?B?VHpmbmhDakUvUnBycENLTVNnYXVCTnpydmxTUDlMcjJvYUxZT1U3OHUyWlhO?=
 =?utf-8?B?bVBaNU9QQ0pTOURCeXEwWTZwQTFkREFweE52YWQ0V2s4UzcrZjl3Ry9xQVNN?=
 =?utf-8?B?Y0ZwQy9JYWZWT0lDcjd0M3VZaE1Ydng5S0lYY2RLRnJ5Nnk2ck5EeUhxWFY1?=
 =?utf-8?B?dFFyRkhUdGtVTkFFTkE4bUxRYTYvbjkvVkRFaXphQmRlYUVPZ0VBWG55N2wx?=
 =?utf-8?B?WVVmK1d1RGlvMUU4VG4vTXZnaytBOFpiRXFRSjhrMzZuMmd6UXM1bUJIQlpF?=
 =?utf-8?B?YytoVHBTaEI4MU9uMzlnT2REOGdsQ1dEKzU4c3dQVTVJcUZ6NjVyYUo2UkNa?=
 =?utf-8?B?bDZKYyt1WVUxOGU1QjhmQjYvaDkxQ2ZKS3ZaWW50V3RFbWY5UW9INFV3QnYw?=
 =?utf-8?B?RjYvblB2Sm9QWmJWR25MTUhKMFlwcjllK3VIY3YwenAwTldKTnMyNkZjV2hS?=
 =?utf-8?B?T3RscERVdVAvbXBlS1NEYytsRjVseUNMTTRxdXhwdzBIYTBPQXFVZ1MxV1NY?=
 =?utf-8?B?S1BGMXRnUGZVeVgwam05VzR1bGxnK2QwK1ptU1BtYkdsWjA2REt1S1ZMV2xH?=
 =?utf-8?B?cUg3VWdqeGx1RW5tZmVsSk9HNWN6RWtFTkZ3cHlTekh0TDR1SGVRREdldDdH?=
 =?utf-8?B?TnFjWTFVSDM2QmhQVjlpdmdFdEZHVisvbER1SG10RngzRVUxMkduT1g3L0Fn?=
 =?utf-8?B?T0hnRTZsdUtmQUsxaEp2Y3lxV1FuWXJ3WS80YzNXcnp5akZDWWxQMzV3MlNR?=
 =?utf-8?B?SmdhNDRPaGZ1MUxLMWJmMXpoUXUxalNGNnRiUXp0enFlMEtKTDJwZGRyNnU4?=
 =?utf-8?B?QTMxeHlkMENSR25GV25KaWlhM1FVQmpvTTdVNVk1cHZrUkRkZmNMYXY5TmFJ?=
 =?utf-8?B?bkw3ZEYya29GNFVJd0ZxTlJ4KytKNHZXdm0rZHJlRWFWRmF1M2lpNkZlNjlU?=
 =?utf-8?B?U3JRR3ZqOEp6S1V5Z0tOM2Y0SjI0d1VYTTdKcFpUUlJBdG9panJhNFU0ak5Q?=
 =?utf-8?B?Y3FQRW1RR1FZaUY4WFFyS0Y2YmpMUWd2K2hNTERINVdiQ2tkWXhwZjZ2NWlC?=
 =?utf-8?B?bVNBajRuQk5sQmRTQWRWY1d1M0JwNngzNmVCdXpyMjFpckxhL09aL0Zud3VN?=
 =?utf-8?B?cmI5VSt6REo2cC9kZ0NoRFV2TEhHcUpyYU5nYlJtbXBaTVcyV0NxTlp5Yk51?=
 =?utf-8?B?YldKQzlCdnhibFVjRDhOTnJQMmw5UjluMUxlZUxsWU1zYzhWa1ZxdjdWRTIz?=
 =?utf-8?B?VUdtdzZWMGlWYmZNdXNuNzBOSWtlbDZzMWl4SjFXT29MOS9oZjVQY05ZQUEw?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cFBmSzhlM05uOGNBUXJrc2hHUHlDNnd6S0c0bGQrU3llQWwzRW94NkQ3dWRl?=
 =?utf-8?B?dS9lNG0rMXBGdU1RU05qNnpmZ0VPSUdha0lJWUZlb2QxWkFNTnBwQVJkVTd0?=
 =?utf-8?B?RlNnRlkwTEZpYUx0TktKV1FUeEZCL0p2UEwwVERYQnp2UXFxVlpNUTlrUmN0?=
 =?utf-8?B?UkU3UzROb0ZMWXJVdjF2UFJPdzJpZnZCdmhWV2hVZURwbFpBM2hlR0hDRzhR?=
 =?utf-8?B?QVBGMURwQnBFS2Z3aEV1Mkx1RWJmeHA5K0J3dDhqbnVwNnN5Y2xvdFN5UTNO?=
 =?utf-8?B?dkZwaFpoR09Ja0lEU2NiZHdySUJWZmxDdDAweXBuOGI5VEo0WkRzazJNZUlm?=
 =?utf-8?B?SUdZUDExcDE0UWRKaGJ1VkUrVnlDVnRvaXdGdW8rK09QUStpQllEUjErcTJU?=
 =?utf-8?B?ZXNwN3RFU0IweGhNVHprVkRSUHlzU3dhNURsVkI4eFhHVDhEeTBGMm1ldWdm?=
 =?utf-8?B?VS83ZTZZd0pUVE5mUDd0QS96TE1aM3ZmdjN5UFVVZFZUbC9acERUV3JUbFh5?=
 =?utf-8?B?bkV3dEpXcmU5U0FRUDhpeXlKVzVyNG90MkV3R0U2eERhVWo2c245cXpjVkcw?=
 =?utf-8?B?VmlzMEI5eUMvKzB6Sm1ETWd3eno0aXhFSWhsQlF4M1A3OGdkNThTTTEvZ21U?=
 =?utf-8?B?TGViYUNueU9DeHgzWDBVbjM2T3F5aFdveG5ieitvYWRxMmRpNUFISXdaazZD?=
 =?utf-8?B?Z0I0U3F0MkFzaXUzTGVnN3FPVDJLVklyQWtEQlB2OU0veVNWNkd4Yk5yRllQ?=
 =?utf-8?B?RndZUGdjUkZQcEg1YnlvQndEUXA4Y0YxRUxMUG5vNjNVMjBsOXZ6NmFlWkxY?=
 =?utf-8?B?cUx5MDA3Nysxb1F3cmdQNmpKcEN6T0Z0blU2c2xGdHJLQU5kbnJKT2Z4OUhL?=
 =?utf-8?B?Tkl1dzY3blpjY2cyM3hoMHREekRnajV1aVVINTk4RURXQy9TbCtjNEorN0xF?=
 =?utf-8?B?ZEIvQ3FvR3JlV1BDa0pUWUtOV2JBT3hRdzVXQWh4VmtuMTJPckMyK3VoTEJi?=
 =?utf-8?B?R05FTkR2VTF6ZXBjMmNKV3BZK3pIdU5Ga3M3eUJQc3NXaGhGYzZaQk55Z2lC?=
 =?utf-8?B?cmxyNmF6N0dMNTR0enUxRjFpMXJhWHo3WUlkZVBTaXUrVlZUOVJQS3Ryb1o0?=
 =?utf-8?B?UU9sNHoxUXFTZXBVUUtUOUJlN0ZzOXFGYTVYNStuZXMxMDhOMDFOU2hkZmxL?=
 =?utf-8?B?SnlZS09PT0JOTmpaQXdsSFE3TnBDTGs0aktzTWNSMldSeEkrSGxqT3RtWWd5?=
 =?utf-8?B?ekdaY2VRNy9yTHJwbVAzcXpacHRTNXE2T2dYbEpjb2VzY012a2lLOWRFc2Zz?=
 =?utf-8?B?N1dtSXRQdXRtb004c2RzWThFeUx2ZlZZUm5WUDJicnl3ZDVZNnN0RU1MTUpK?=
 =?utf-8?B?ZXdBWHQrNGYxUlAxUDk2QURGc0NPUitFcG1uSEZ4Nksvd2U5SHNDYUZ2dnIw?=
 =?utf-8?Q?PGWww/G1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b91d72-1cae-41cd-2ecb-08dbcfc3b159
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 10:19:20.7254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyiCFqrg5QT4ecChlmGrQvlWmKJFHOfl6BzpJrL04Xwwvh2F7fZj0V6/EWgWyQdnrUPDoXr+E1TavIb8szbv9JfGQ7wGNw3M9k9Mj6rb8y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_08,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180086
X-Proofpoint-GUID: Jeh6Kn4FRUFA3dlJl3CptCoDLlRGoJXT
X-Proofpoint-ORIG-GUID: Jeh6Kn4FRUFA3dlJl3CptCoDLlRGoJXT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 19:05, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
>> On 16/10/2023 17:34, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
>>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>>>> index 99d4b075df49..96ec013d1192 100644
>>>> --- a/drivers/iommu/iommufd/Kconfig
>>>> +++ b/drivers/iommu/iommufd/Kconfig
>>>> @@ -11,6 +11,13 @@ config IOMMUFD
>>>>
>>>>           If you don't know what to do here, say N.
>>>>
>>>> +config IOMMUFD_DRIVER
>>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
>>>> +       default IOMMU_API
>>>> +       help
>>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
>>>> +         drivers.
>>>
>>> It is not a 'user selectable' kconfig, just make it
>>>
>>> config IOMMUFD_DRIVER
>>>        tristate
>>>        default n
>>>
>> tristate? More like a bool as IOMMU drivers aren't modloadable
> 
> tristate, who knows what people will select. If the modular drivers
> use it then it is forced to a Y not a M. It is the right way to use kconfig..
> 
Making it tristate will break build bisection in this module with errors like this:

[I say bisection, because aftewards when we put IOMMU drivers in the mix, these
are always builtin, so it ends up selecting IOMMU_DRIVER=y.]

ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/iommufd/iova_bitmap.o

iova_bitmap is no module, and making it tristate allows to build it as a module
as long as one of the selectors of is a module. 'bool' is actually more accurate
to what it is builtin or not.


	Joao
