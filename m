Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11356778030
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 20:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbjHJSYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 14:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbjHJSYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 14:24:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06EB2684
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:24:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37AGxmkM020163;
        Thu, 10 Aug 2023 18:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3lP50ggpM+EQTPyIB68nK5eNRND/jD68qnWNFZCPp7c=;
 b=KK4Dzjpa13Re/lDiOGLcyMcse91GK1hHEzGidCibo/p3oZHnnrb6rWkjAvcmgTPBr2jw
 cjXai90fZK64AYMA0Ttw7mRbiDSY24e9XkNhPu0+GVt9lxhHDrlhSbJB6W2dJnp7n1w2
 kNiQ3xWSgoNmeiZET6yJYBnmz2mfcLD2d4Mqff/AL71ss8LmgfqqJFEWfUUirf3kkKkp
 Sr6X45l367SwUX+ko/AFPlDlFCm7hucXW6786a/V48LkCtmBIy5eH3h/piszImVUuLGQ
 LATniEwgLagwtG2Cui/RWYYW6Ei7ogpcQMJo0/uHDV1Rss/FwHXEG2GrCUgVQCIJG8cP EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d12kw1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 18:23:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37AHouFh003040;
        Thu, 10 Aug 2023 18:23:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv957cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 18:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVL420JIrsflq6D0c10RsV8ypLnhxfmciI/e3Or+z5U1rjXtXwfKuwdP0hRrxj43aF+SHrzJs113kCRJnAQ3SikmhGp8+su/V4wDeQl+YjR0hSayqyNfiFy51zZIn5FEmhDa7YIs+f2vnv5hSV0Xv0jidJRuc2DKFEEhsjN0LSiAYTduCpvEjx5UCUmqmfjxQpUqoUJPkWvkmtgsW8SAqEYlZi5JEbRrP0bn4By1y0o2ecVksq3dFppDHsp8NHc/a+0JSPB8KSYZCYzaCVhzTL5YHfET5WM1i59FZKbDozEMzYMQqHfZzpeEKRgAtGlxMX/LSsxmiZ6L8LQtZ4kdDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lP50ggpM+EQTPyIB68nK5eNRND/jD68qnWNFZCPp7c=;
 b=LodPdgiedlLT+fmEtVHS0d+kE9PUv5PB6aEldUHCB887sQ5drvxRTpCpN3lJDKKNR2mRUnszXONSU+IkeXvkW/Jpby0kzik7bYyPgiGMgaW0z9Mnw/GHR7SbV0UKTPGfVMibT3RHKHLYxquO5QVLYqyMJ/qlEdb2VZOqu02Y3Di7JwgZC1pP+pOvjsKxyfxCYnafVjeY+JE52gKMqMsSrFD5Hdqnn+S1rq0OMzmaAimXTQ1jCbiRN6xz2zDISaOAU4ELSRDIyvsJ9Yy/bNmUatgoIEAxNqG8N2KXjsbEwVMADbQveL4iPWVhov8ThL/030go8LxlIbqhoECr/vzO+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lP50ggpM+EQTPyIB68nK5eNRND/jD68qnWNFZCPp7c=;
 b=mhUA9uJqr4bfla6OpNPV7bHPoezkKYiuNwLUuAfU3McgOUDb9uGyeoeYd+wDSsSmma4IFoR0H+5RgeJQvI5ZtpToW6NDnH9NCO1s5Pe7bvBBpjrH5Phy/KelmlvuvaCQtRzoQU/jFV6OHV2lPDhr0jXZLc7m6Ixp0J9OQYNYiq8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB7229.namprd10.prod.outlook.com (2603:10b6:208:400::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 18:23:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 18:23:18 +0000
Message-ID: <69511eee-69b5-2a83-b7b9-f4a2664e15e8@oracle.com>
Date:   Thu, 10 Aug 2023 19:23:11 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
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
X-ClientProxiedBy: AM0PR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: 62554aa4-dfe3-4eb9-97f6-08db99cedefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgVLEgMm+jqBhdruDCjtQZAp6rwiZJDN1GbEPlkRREcXQg2tJyWzp0mxDfwQWH3E7JXGagWRVkApP4q7QY5HQEZylr1vdlnU+vBbdOGAEwaNE8FKTXPMkL1JDwgQOpKJkzXCAVpB6nODKWR5W2pJkw3aNZ4Q2/LLX6mtQC413z8jpyw1+SRHhinBc6dERXQ3ogrfS9n/5adDXkN9L9P0v5xPzPCm59PdihjbJh2r8xHkNMjH0cBl9wTIlNRts41A5tu5ItsPtVG/OFXxWHfClAxtEhAkqqjMFevKj0ZvzaRl57FHKMOx/Fgl+0HH2nwhAFv1T42n1fWEy3a0iAR1QIkQdAnB9GCw+tdCM5Ew4kfCNPMxEfLRHRa+BFtMuyqmNbq57c9ewUoidKCsMJCNha0eUbtPjWsjShVRo9dqsrr5lhkBG8la0/eF4ATXjChECOeKLgi7/D3fu7palstYMic5G6iSCTqAg3UDCGVK7+QhDn0F4Z/UKy4q7n7VTeRQ3RMMFgdU+ZtzQ97rlOflfY+vh0ARd2eTJTNluLReOGRp7odApyiX6dgsLYCtwkQu5BBEgMSShc2RAA1bM6eW60y/8yht6h7Cn2QruOax8ZmLMYcxjRJaxaaWkmKgEsulxorgAojKCADagXxVu0xs9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199021)(186006)(1800799006)(26005)(6506007)(53546011)(86362001)(31696002)(41300700001)(66476007)(83380400001)(5660300002)(7416002)(36756003)(316002)(2616005)(66946007)(8936002)(66556008)(8676002)(38100700002)(6666004)(2906002)(54906003)(6486002)(110136005)(31686004)(478600001)(6512007)(4326008)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjU5RVBZMDFvOXloZk5SRXJyb3hMUFAzUjVVaFVETE9zbjdLbnFSWFJIWEJF?=
 =?utf-8?B?VkczcVZCQzgveUkvaTZteGlWdytiTUJpTjVKZ2NlcmJ3QndId0ZCTGNtK2Fs?=
 =?utf-8?B?K3RqSkhqYkdtQWEybWgyMDFRVUpzQmR1c3UvY3R4UVZPUWJnNkRtdit0TDVu?=
 =?utf-8?B?ajVjaVdoS1ZrQmFBMnNXdTcwQXMxWUxoUFcrcEJOR0JBRkR2V2JSbEdIeEpH?=
 =?utf-8?B?SzhRRnFmU21XbDBLekJ3TnZGQjhjdWc3djhJdnFNOEk4ZzlhZThFSnRGUHEv?=
 =?utf-8?B?TXVLNzJnMjZOc0t4amgyeGJmNzZxZGVacjROZEtUZjZXTmMwWERFWXRhbXd2?=
 =?utf-8?B?bFEwYnd4NFlwVkpCNWFaclVQTFZLRGJDRnpFNDNnajNKWkhqeGxIS1ZBNDBE?=
 =?utf-8?B?azdxL0pnbUg0N3M4Sk9HR3hhR1RKM2NXZkFXRGpOQTlyS0tjamhKQ2l2a2RM?=
 =?utf-8?B?anIva281TFZrOXJQMkxUTk5pUjRhUlZKT2Vjd0RObTRsQkszRGVPc1dMdlFv?=
 =?utf-8?B?SG52NHBHZDdXS0x1OFU4VWFRZHJGektMMGxaTnBoUGptaE5yYUEwWUs5c2FC?=
 =?utf-8?B?TkhEa09wZGRLNWJ3cG5SMFozcTluak13V0lBSkRITXVRNDBZZ0tFbythVkNS?=
 =?utf-8?B?Ky9nMVYrYlVnbGlmMnA1Mms2ZTNlc3NaekRFL2RSd201dGhiMElDS2NNTjc3?=
 =?utf-8?B?QncyOWFiNnRnTDFzbW9Rbm1FV1F4cVB1NHNVN3NmbXNTRlA0Q0taV25PZGVH?=
 =?utf-8?B?eXJyRHlKNzhGVmhXWUJrMkl5aEFMNjN5TndnUVBZUWpTZEI1a3ZvQU9DV3Ax?=
 =?utf-8?B?UVU3U25uUDhWUDdwUnhEYWlXdGovRmoybEZpQ2VtUmV1cC9FUHJ5WXBXZnlz?=
 =?utf-8?B?eXNEeXYvWFh4UW5iSno5aFBiS2JLMVI3S1M3RnBQN2dRYnYzNHp5Qk84dEpL?=
 =?utf-8?B?QURDWmNpS0c5ckRBby9iaENGaW5oUGRjZkJvQmxna2hMVVZFTzNkSWpVd1dK?=
 =?utf-8?B?U2Z4K1pPMlRXK2V4R29pRG5xbUtrTXRjb0hmY2szUGV5bkpMd3ZHaXJLbTlp?=
 =?utf-8?B?QjhGcE5MV2V2NFdKS0dWc3FIVCtxcHZ0M09WRTlkNDdZSUZrSk96Z2FTMEVs?=
 =?utf-8?B?UlFPVDZxK2E4Y1hUOTAxY1F4RjNuN1NVc1Z4emdvakRvZEc4bG9vclZzNEdE?=
 =?utf-8?B?TmV3OUJwZWp3K24xcHliZXExdzFyR05kWFhEQnFDTkMvN05YVHo0MEQwZDBC?=
 =?utf-8?B?UE92SUV0Tm5sdmN4UzA5b01SOVpPTTR5NjVrblJWM3Z5aFAxN0puTzRQblVN?=
 =?utf-8?B?bzlaZkdtcjlWWVlXcGtjeVZicXBIazVOMzFnNDVNOVptWE5FMzdZckJQVTAz?=
 =?utf-8?B?MTd1WjhORzRBbXh6VVZkajhSRWwweFkwZ0RsZE1zZVk2emd2b0V1cTJZSnh0?=
 =?utf-8?B?OEJ0TzV3eU9zdFozdFBKeEFldlpyY01FQkhJeWFaYkRkUEVacUNic1NRZW4w?=
 =?utf-8?B?am1vNksyd2s1WnJxaUNwU1J5c25PL2RnVmxTNDg3anpWbWhXcHFZdmtyRzNz?=
 =?utf-8?B?S3orOENWSEpaVDZ5N2ZRU0dCUTB0UjF1RlBpd0s2eWJoV3JaQ0ptS1BzdjA0?=
 =?utf-8?B?MnRub1VFem55d1IxTzU0dDZ2dW5UZExNZUJNa0QyWUhBRzQ4SDJ0SGtMdHdy?=
 =?utf-8?B?anl3cjNOanQxQnQ2Qm9KQVZuWDFYTXpBQk1KWUFIcW81Y010d0hadlFMUVBR?=
 =?utf-8?B?RGJCVXd2QUFTcm5lRUpZblJwdE5ocWNDNE1rQUlSVlJlOGlXZDJ3Q3hjTHQ0?=
 =?utf-8?B?RzRVM2NVaG1xQ2dHeU9NaWx3aTliQ0FNWXhkR21hRXJQc3J1bHRPeFVmaGFB?=
 =?utf-8?B?RmxrbGZWVTFxMXd3Q2ZDdWkxWGxISExoQjE2cnZ4SFJiWUVPOURaR1l5b2xw?=
 =?utf-8?B?N2dMTVgzUDhJdE4rdHhBYkQvRW85dUtnV3BmYlFWOEgvZUdHUHVnanNReVUv?=
 =?utf-8?B?dStkYUR5UkFXdFcwWUhsZitHbnplNFQwOVFBY0tXWEZXZTVSWFpZZElpRVBR?=
 =?utf-8?B?bTc0cnRlVDdva25GRTJpZHV3MFNTbWtGcCsvTTFKYzBlWjNDTW5RMnJRV3RO?=
 =?utf-8?B?eEtNYmYvV09yTjhGZjZrMjZ3S1BCcDNFZHZ5TnZJTFZSOW1keld4bmVZWHF4?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MkxLQU03NVNMQUtDdXVxdkVtRW9NbkVwL0NDanZLSGdzTGxSRUg0TjlGeWtv?=
 =?utf-8?B?WG9wQVh1b2RBWmg4NGk4VTErN1hzRFQ4WmJ0VU9ZOTJyazRPSGZaWXYzbEZJ?=
 =?utf-8?B?VkcxN2djNjYwYW5XSlE3Zmd6eGtHdVRWdDdsRXJyRnB3R1puZXZYUnNSVW0w?=
 =?utf-8?B?by9iWm9QNnl3Rm5GWWZ6WmJUY0FWZXp1ZU1raGhwajc1SCt2VkNWL0tIbkp6?=
 =?utf-8?B?TGNLclpucHh0S3o1dFVBa0J3UWZodDlSWE5zT0xpZEVtUTlvZ3BmOHNxVnlq?=
 =?utf-8?B?TVJiUitLZjlqbFBXbnFlMWpsTWRSWERDbTdVa3J1MGpBUm8yVVZNSFN5clZj?=
 =?utf-8?B?aDliZUY4Skg5dTRKa1J3c3pPWVhpaXI5MVJSaklvZU5DblRXMGFySlRNbVNk?=
 =?utf-8?B?M0JyRnFCYkZVejJrTFd1L1l6YjExUkVvSEwzQUZQV2lsZnNZczFBUlpNekpu?=
 =?utf-8?B?ZFZ0YWZ6Q3krOVVGQ2JyWHZxVFpLOEZWZ3ZPWERqVmZucThLNm9LS2gxOEpJ?=
 =?utf-8?B?L2g4SEpkazhPdncvdGpVeGFUUEtiVlhFTy9NNUxKL0Q5UW15Z1BUZ01CSlE0?=
 =?utf-8?B?dWxoN2ExblJjYTZWQVlxcWw0TkZXRVhJbkZEYkEvUU1pZzExYXpVcndPRFZR?=
 =?utf-8?B?Z2o4V24yM1ZraUNOeURGbm82VXU1ckF1T08rNjFUOWUzWmNUSUVZU3FBT2VM?=
 =?utf-8?B?ZiswUVpuZ3FSMzVBSEF0aDR5WEplUTNkS2Q2QzUyNXJPQ2JKU0dpU0djZXRm?=
 =?utf-8?B?Q0tJeVVteTh0akRxUzVvNy96cnhpcVh2UWNjdlhHZGJFZExxaElvSnJTWGNI?=
 =?utf-8?B?N0FIOGRWZTk2T3M3cU0xT0ZmMGY0Yk83ZEh4eE5BcDRINXhrRTFlaFkvMnJ3?=
 =?utf-8?B?UFBWQTgvSWFpZElCaDJLWTFQNHkvM0h6WUNocStERXNjQkhrS3UwNXkxemdz?=
 =?utf-8?B?OENnYWFFZXNSMlplUE9uZm1DeGx3MGZrcytjL2RsSmtEVXlZalk3NFpvNlVx?=
 =?utf-8?B?ZCs5YjJPR1UrZlM4bmRvZlI1bGl2a0wrOEtjRTcrRzZwZHBPNGIvWGc4Lyt4?=
 =?utf-8?B?U2xadXdwMHVBc1VFdlBMUzBsUzNQL3VXM0cxSlJoYWpuVERCcFl3WW9rczVV?=
 =?utf-8?B?eWZvQTZwQ1pMd3BrQ3lHbUtRR2MyMXk4ZWhYZ1BLREdESG1PLzFFaCt2d0ps?=
 =?utf-8?B?OUdrdXNNWVBIU2xaOG9lUm4wMHN3ZzlKMXdTS3paV1p6enJVRUJWNE55QWZJ?=
 =?utf-8?B?Q3kzdFFIaWt2ZlpIVkI3ZmhvZWk3YlpJNGZNRWQ2VUVDdFZIZHlmVTYyUmpQ?=
 =?utf-8?B?bFdvbzdwa3lNeUVhekRSNm5JMENiT09zdUxOWFF1c2F5TEFLNGpOU3FLY1I3?=
 =?utf-8?B?S2hBRERjNnFoQVkyaVZHa0tGSW5XbGMzVVc2TXdiOW8yYXNzblRWQmZkcUMz?=
 =?utf-8?B?NWxUWDduREk1cHNmUExMZ3poYy9VaWp2NTdRVEJBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62554aa4-dfe3-4eb9-97f6-08db99cedefd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 18:23:18.8647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxourLrBh4YcwOU3ueJJajXhwwkpypTd9fJyA19R73QguKxoopOyYKiCXEmELZQi0UiZiHukXci9M5WSlN+gf1k3CKYwEAD+kMP5VVJ+w2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_14,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308100158
X-Proofpoint-GUID: 3T_0KXs7xdWX_XEqz4gY16a9qcU--Mrd
X-Proofpoint-ORIG-GUID: 3T_0KXs7xdWX_XEqz4gY16a9qcU--Mrd
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:29, Jason Gunthorpe wrote:
> On Fri, May 19, 2023 at 12:56:19PM +0100, Joao Martins wrote:
>> On 19/05/2023 12:51, Jason Gunthorpe wrote:
>>> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
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
> Since alloc_user (or whatever it settles into) will have the struct
> device * argument this should be easy enough with out getting mixed
> with the struct bus cleanup.

Taking a step back, the iommu domain ops are a shared global pointer in all
iommu domains AFAIU at least in all three iommu implementations I was targetting
with this -- init-ed from iommu_ops::domain_default_ops. Not something we can
"just" clear part of it as that's the same global pointer shared with every
other domain. We would have to duplicate for every vendor two domain ops: one
with dirty and another without dirty tracking; though the general sentiment
behind clearing makes sense

But this is for IOMMUFD API driven only, perhaps we can just enforce at HWPT
allocation time as we are given a device ID there, or via device_attach too
inside iommufd core when we attach a device to an already existent hwpt.

This is a bit simpler and as a bonus it avoids getting dependent on the
domain_alloc_user() nesting infra and no core iommu domain changes;

Unless we also need to worry about non-IOMMUFD device-attach, which I don't
think it is the case here

e.g.

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4c37eeea2bcd..4966775f5b00 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -339,6 +339,12 @@ int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable
*hwpt,
                goto err_unlock;
        }

+       if (hwpt->enforce_dirty &&
+           !device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY)) {
+               rc = -EINVAL;
+               goto out_abort;
+       }
+
        /* Try to upgrade the domain we have */
        if (idev->enforce_cache_coherency) {
                rc = iommufd_hw_pagetable_enforce_cc(hwpt);
@@ -542,7 +548,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
        }

        hwpt = iommufd_hw_pagetable_alloc(idev->ictx, ioas, idev,
-                                         immediate_attach);
+                                         immediate_attach, false);
        if (IS_ERR(hwpt)) {
                destroy_hwpt = ERR_CAST(hwpt);
                goto out_unlock;

diff --git a/drivers/iommu/iommufd/hw_pagetable.c
b/drivers/iommu/iommufd/hw_pagetable.c
index 838530460d9b..da831b4404fd 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -62,6 +62,8 @@ int iommufd_hw_pagetable_enforce_cc(struct
iommufd_hw_pagetable *hwpt)
  * @ioas: IOAS to associate the domain with
  * @idev: Device to get an iommu_domain for
  * @immediate_attach: True if idev should be attached to the hwpt
+ * @enforce_dirty: True if dirty tracking support should be enforced
+ *                 on device attach
  *
  * Allocate a new iommu_domain and return it as a hw_pagetable. The HWPT
  * will be linked to the given ioas and upon return the underlying iommu_domain
@@ -73,7 +75,8 @@ int iommufd_hw_pagetable_enforce_cc(struct
iommufd_hw_pagetable *hwpt)
  */
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
-                          struct iommufd_device *idev, bool immediate_attach)
+                          struct iommufd_device *idev, bool immediate_attach,
+                          bool enforce_dirty)
 {
        const struct iommu_ops *ops = dev_iommu_ops(idev->dev);
        struct iommufd_hw_pagetable *hwpt;
@@ -90,8 +93,17 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct
iommufd_ioas *ioas,
        refcount_inc(&ioas->obj.users);
        hwpt->ioas = ioas;

+       if (enforce_dirty &&
+           !device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY)) {
+               rc = -EINVAL;
+               goto out_abort;
+       }
+
@@ -99,6 +111,8 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct
iommufd_ioas *ioas,
                        hwpt->domain = NULL;
                        goto out_abort;
                }
+
+               hwpt->enforce_dirty = enforce_dirty;
        } else {
                hwpt->domain = iommu_domain_alloc(idev->dev->bus);
                if (!hwpt->domain) {
@@ -154,7 +168,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
        struct iommufd_ioas *ioas;
        int rc;

-       if (cmd->flags || cmd->__reserved)
+       if ((cmd->flags & ~(IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
+           cmd->__reserved)
                return -EOPNOTSUPP;

        idev = iommufd_get_device(ucmd, cmd->dev_id);
@@ -168,7 +183,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
        }

        mutex_lock(&ioas->mutex);
-       hwpt = iommufd_hw_pagetable_alloc(ucmd->ictx, ioas, idev, false);
+       hwpt = iommufd_hw_pagetable_alloc(ucmd->ictx, ioas, idev, false,
+                                 cmd->flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY);
        if (IS_ERR(hwpt)) {
                rc = PTR_ERR(hwpt);
                goto out_unlock;
diff --git a/drivers/iommu/iommufd/iommufd_private.h
b/drivers/iommu/iommufd/iommufd_private.h
index 8ba786bc95ff..7f0173e54c9c 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -247,6 +247,7 @@ struct iommufd_hw_pagetable {
        struct iommu_domain *domain;
        bool auto_domain : 1;
        bool enforce_cache_coherency : 1;
+       bool enforce_dirty : 1;
        bool msi_cookie : 1;
        /* Head at iommufd_ioas::hwpt_list */
        struct list_head hwpt_item;
