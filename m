Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2947E7CDD0D
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjJRNSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjJRNSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:18:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993F83
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:18:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39ICwm8J028901;
        Wed, 18 Oct 2023 13:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bZLtx4WdeQY0tgn9iNnFJv/VQ9C6HkCfY8owhq6btG8=;
 b=TohunrD73eoSkm574m/N6LwKAAhnvi38ijxN7djD2CMG88gV9rd6kiKH+OhlQLjdzp7u
 1GKUchJnMKL6VrNy9gh8QMtqUywhrijWenw5KA0xs7wUtufFFyv4UOH01WYbmwDIuzHP
 gokijvy40Q+RK5yGS3GV8GTdIVlya+mWDcOAEsh2k8DY+I8scYL9eyEnqFxRlFCjpvHg
 ybBDJCBQBEi9zULz4/5Xz0c/sWJXHnfwxBPbZUqsSJOs3cKHNwEuDfjkC1E4MPIs5CcH
 UM4Epc+pAcDk4q88KbXL4qBnA4Q/1ra8es85OsZpaHfnomlzeU8jkxMy5TlTuMr7UDwa Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jqhat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 13:17:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IBUZDT015221;
        Wed, 18 Oct 2023 13:17:35 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1gfs08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 13:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bf7Z9OtMST8gaI3SNZWAFGo7Mxv6Uuqj9aWIIQvJhi/ywupCTKsSOIaY3yWsBQAHNtdbFuYqW+itonCPebV4gib3g8aVmAUThUEkxQ4RUjRzNfEdV2f48d2tAZklMPcWYmjK7QaHXOz9JlX+9NQLm9meUEswpZRB8GILx9uA20KapKA4jI1Q54hP45SPnzou8AE1DL+sSeC5eXyY2DWF8o6f3fLvWTHp/HERNRcmxeGPRTpLzWbGX0yymLozEG7JypCO8WHI3B4O0DcC84p6wsA4A15D89YTS+5zUFfNIOsTJ6Dz4uyY5f8GNQ9sVLMs1r8Q4pF1dWbOD9EjGOgd3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZLtx4WdeQY0tgn9iNnFJv/VQ9C6HkCfY8owhq6btG8=;
 b=Eqki8tIqQiaoO+ysamUbnRtd54BvHppgo1i1OZ4Loe03vs5pUCrv8PQ5V7Rv+ZmzCLKbjAwUjES/IFlTt1pFkoM9CM+ACWOkb6BP8AxM6JVsX4rjJ8twtFnHJgrmtZGDEToKVfrnIAdYK99jsesZxvBR+WCxJFTZjMBki8bT2uXIT7QNLp1jykc/SsAj9c5rzVQbW4bGi4tlR93tICWiOU26G/zlKYFYy0jcQQUbEuMQPcLwW6gnVoI3yubqjLhrw151HEvCWEqen964GUEPt7UilacBKBt/97Ch3tOc4iqEh0L7fSI/z0962LIRQRDqdTJkznon1I7tMJbUPaCaKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZLtx4WdeQY0tgn9iNnFJv/VQ9C6HkCfY8owhq6btG8=;
 b=IA7A/D/0Vep/Pjc0YKs3L+WjqzganzNwAnkZLMta8aCIfjCR3wqx36Xp0yp8OpySbpXfxKY0uMCAkS9R6MDG4rGE3L7bZDtE/7TDHCYJE5FI0bouSfyNJH0lAoKD+2+4oo/XZ8SVgMhuRWB8kP8CTFHQMKzc+u8nBu4EJe8+sBU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB4298.namprd10.prod.outlook.com (2603:10b6:5:21f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Wed, 18 Oct
 2023 13:17:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 13:17:34 +0000
Message-ID: <8ad231da-9662-40da-a418-fc3856652c1a@oracle.com>
Date:   Wed, 18 Oct 2023 14:17:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM6PR10MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb4a154-f5be-44a5-a07f-08dbcfdc9722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzM5BWiNMpjhl8CEvH/g4RTLXkOd4e80lN6mY2BbGnHyUsIccrElUXVI5X0snC8aqrW6mbMsnipBA5utvsfBsQztRrTrzr/5rbp05lDfV6nOMPiV+Qt0PT7Cr+uhf6Fk8NO3p5vFqx2U2TdBOs+prAX+d4UVT3z8nDIWaulx4UnN4iauQk8fR7u/rU/Mj0POJ4e2hfmkyPZrPUhNQUM+CkdfWEMAWgHhmdw2uO7SxpohUMtn8pIbG/KsQDlnT1JPoEoD7qCag52P18/LppEXUa67SEdO4cQFSQV/6Z/0Cp1mv3o4CKXGHnAeZL8LbUKYTE24Q8WbcIG+Ba2br56ZtIYgNfTE5skR/mc5Aaerb7qN5KBXYbgqSPZCyE9rXMDZ8F22tj7whqafLGBmQbdQhoesHxV/5xTs5NzyJsbXJ/LrYa2KqjAOcf76efcKR/yJh8/UAm85X8OwE3xwfd6LG/tdT1cWHxReu9Y0cRjolTXwEhdi9aAzIpPZ6xY0M1ZzRYWG99Wx3fnh+40veLtYe6PPwSm8tEsX1bBxmCkh7cXSIZf2vRBkP9Sylp8ky2l/quiEsKnztl4ZHUzXOahkn/D/hLlx1C5I7GtW34tYKE10ABSlBTn/JN/81OyfLD0mUO5O306F6G6ts5JB4S+uSGY4pJvh0+bUSZSyv8HV/Po=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(346002)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6506007)(2906002)(66476007)(26005)(54906003)(7416002)(2616005)(316002)(66556008)(41300700001)(4326008)(53546011)(5660300002)(8936002)(6486002)(8676002)(6512007)(6666004)(478600001)(38100700002)(36756003)(86362001)(31696002)(31686004)(66946007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUNka3hiZ1NkR3gxcEN5VXhKUjVPeEkrN2lMcVNXck93b0pPWTlGUXBkS2hM?=
 =?utf-8?B?MTJDVUp4cER0Z1JXTkVBRVpSUHExNkc2L2ZTVnduenE3c3Y4cXlFZGRjbldk?=
 =?utf-8?B?bjR6QnAwUzhabDZpV0VLRHJrbUJWeElpTmdXbDE2MGRuTnBCUHdNOCtoNkpZ?=
 =?utf-8?B?amFmWUVzS0pMaC9yUzRRaU9nd1YzbWd6NjhocVE0RTA1MjRIRXNCQzJkQ096?=
 =?utf-8?B?anI5TVA0a2RWNkl3UEg0WXNEL2xpUnROZ1VvVXN4SWJiOUxMdFpnYTM2eWNr?=
 =?utf-8?B?Tk1GT2crTnpCbmNUYVY4bVgyTnNDb0IyUlVPMnVHR3Nra0k3QjRZdTVWeXdl?=
 =?utf-8?B?TTVjb1RxdGtlSEZsT0JHSjk0akExSTJZZGZmb0N6ZVBXS0R4aGRkMlhsU3h0?=
 =?utf-8?B?NHZxU1N2WFFBRXVPdVhTaWs0YjdKS08wUlFacXlFaVU2S2NCOTV5Y1NtdUN0?=
 =?utf-8?B?MGw0YWZDS3lCL2NOOWxZT2h4YW9QUFNmY3JOMThMS3AzNGtwNmRjbGVmUFN2?=
 =?utf-8?B?czM4RmtFZWx6Zm1pejBhZVhKc2RxQXZ1dk4zTTU0cXFnR1RoeklkTnJPbEpF?=
 =?utf-8?B?dWpEaHZmSTZtKzNZRndPZ1FwRWM4cXc2MDNRd1FRM0k1SWsxbWZ4S3JoTFZr?=
 =?utf-8?B?VEF2V0JjUWdzMDdBVldXSkZUTHk3YjJ4dGNiSFo0NXFkTGlXMnBoT01sVVNa?=
 =?utf-8?B?SFBLZGJEVEhwK0doaTlLcG03WnBNM3BvZXJoZlpuTzVWTlNGMk03RUFzZnQw?=
 =?utf-8?B?NUJKK000VEdBZW5tUDFrSCtmLzdQM29ITXV5TkdrRUdLcC9NTlJwbzBWQmwr?=
 =?utf-8?B?a2F0YzVXRzQrNm1UdzhWMU9LZXc0WTFWaXNVNGkyazR2K3REbnVpN0NrYVI0?=
 =?utf-8?B?ZEtDejlpemFKTXVwTEtQMDl6UHNqN1BRalYrRk9vZjFzS3VPbFZkeWxhUUJp?=
 =?utf-8?B?RStCTjBDMmxTQ2JvdXI3NGZoWEZvTkFrYyt4SEp6L0NwazJqSmptUlduRDk0?=
 =?utf-8?B?YTlOd3lxUnZaZEx6QXl6YXdJcFlnSGJSVjZ0d21IRklYQUgvSThPSzdrRXh4?=
 =?utf-8?B?ZnFwOUZ1bFVwbC94V2lpY0tTVEwra0tNbHo1ZllmbWVpcWlsbmRiRzFQK1VE?=
 =?utf-8?B?dkhkMjVjaWQ5UEpiQ0tBelk1Tm1JVTc5blhUWnRETWE4TkJxcVkzQzdxUVM5?=
 =?utf-8?B?a1B6bE1UTkhkSlBacWFHa0dDajZUUlFubTRUNzU1bEZ3VEY4UmJvN2hTWllP?=
 =?utf-8?B?aDNhbU5ESEt5TjRUaCtIbjg4OGZMa1o4TllGeTVHWWI1M2huVGNVcVZZZFlu?=
 =?utf-8?B?SUhDL0p5TWI0K3hLTUVrWndvL0w5d2x1c0lDUUNyK2tWWlR0QUttU0FNRzUr?=
 =?utf-8?B?dTgxQ1YrU2dYQlBlTWFaN0k2eWo4R0hydUUrMUZXci92aWhTV3VhV3N1TW80?=
 =?utf-8?B?eGRnOUdJV2VOWklhT1ZpaTc3OTRQemF3b05XQ0pBSU4wK2JlK3YycjBkbW82?=
 =?utf-8?B?YjE4UElFOFdSL2QxTjJycFUyd0E1MjFxV1ZUWXZIVDYzalFEVGE1cEMvY2tS?=
 =?utf-8?B?VEJQL1ozZmg0ZkFlbHQrakFDRk9IN09pTTZOdGVTY1Z0Qmk2VVZIY1NNdnd2?=
 =?utf-8?B?aHBQQ1NPb0g2dEVFMFFkZEhuV1ZiTEIrS2Era09Oc2RQc1ZTT3NFdGM0T0wv?=
 =?utf-8?B?RE9ScEZVMWJndXJpaG40TEw4RE1BN3BYZGVNbHF3TlFwMTJQZzVseks0R2dz?=
 =?utf-8?B?TzBCdXpROFpiQ0J4VHJwQ0l0Y200b3A3UUJlUzUvSWE5aGthemxUOGFWN3A3?=
 =?utf-8?B?UlNYbldPNXZZRm5qdjlJdjRTMjQ5RWMyMVhqdCtaMkJzTDV5LzN4S0tGYURo?=
 =?utf-8?B?WVlybW5lNDZKT0k0dkVoQ2dIVUF1VVRXL2xleFkxVEEyVmVQMnAvdTV1UThM?=
 =?utf-8?B?M1dCK0o1K0wveFAwa3lsL2hBbm45NlFtdUU2TmJ5cGRjcTZhRG94TGlhTUpT?=
 =?utf-8?B?NjMxMUY1NW5kOHRzVHd5SnZZTGNGRVRmQTlOY25vMlZYdWhBSTVlaHlVTUQy?=
 =?utf-8?B?U2MrWEZQSWRqZXVsMkRQZWtjWWdtZUYyM0JRb013UDN5bFhrRjkyTlA5cUwr?=
 =?utf-8?B?QXJmZG5VbE8vNS90TXVMNFdhTFRYc2pLU05mcDAwSm11S1hpN1h4UkZJckdM?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NnZrb1lET2t0SDZaODZZYll1eUw5Z2I4WDNLQXhGY0tya08wbHNEWE9tWWRM?=
 =?utf-8?B?c2ZGMlNJWXZZcWFCaFR1L2FlcXB1SXprdXJQMXdOQzBhaHltY2JJR0UzREdv?=
 =?utf-8?B?VW0reG5TRSt1cjZOajhHcWtPeWRpQkQ3R2Jid3c1MEErSXIvTXJlbHRiQVNO?=
 =?utf-8?B?Ui9DbXZmOEtrTUtzZlpJZTNBcVgwM0hBNEdDdzNBbXY1elh4bUttZ3NCZm0y?=
 =?utf-8?B?TXprWlJacWRuQU1FWVBIRkdXNXZLOEo1a2hjcldIaEM2WkttbjIwT0RGM3F1?=
 =?utf-8?B?cis4eGwvUGIrTXJHSEZHSS9WdkFManNuK21OWjRsVTIwV2R0Y1l5amJBOWdC?=
 =?utf-8?B?eXVWUWZrWFdad3pMZUlMdjlxOWpSeG04Qk91QXNYdEd4N1dZaXRxR2JpL280?=
 =?utf-8?B?KzN2YlBCTTV2TVVKa2xZVmxXQ0Y2NEpCRnIwNXVsRlVKRkFEeFFkVVlVM0dt?=
 =?utf-8?B?UHlpK2hldVpLazhNbW1PS05UY3NvOTNyTERnTjg4OXhBRzVud2psblp5Y3pM?=
 =?utf-8?B?V0R2Z01JUUlQZXN6dEIzanJwbmQ1LzY0SmhKTzdWZzdJeW9LZGVDOGJTdEZI?=
 =?utf-8?B?cVQ3TFVPWG9RcXRZYmZ1S2l2R1RWZGh4QVFyQVNiK2RnRENBczlWMXpPM0Vm?=
 =?utf-8?B?WHNQSEE1SDVDanhoY1VQWEtuWXNmcHU5dWJwSmZFcG45VmJTR2Rqemlzbkp1?=
 =?utf-8?B?RDBtbmpKMGpLNjZmSTNmTTdRVE1xVElBbStMRmZzeGhZaHdzVjdWb1h1TWlY?=
 =?utf-8?B?NWFmaURCNU5KWncyb082UVQ5dEw0T2VYVkx4VGtBZlhvd0FZNWd2T0FaVHJO?=
 =?utf-8?B?RVZWQ0U2TEZ1aHJvTi8rMVVHZU53MnJKa0FzR2V3Sjh6Y0tsRWs3MjBmbG1k?=
 =?utf-8?B?MXFkdWtkQitHVWNrSFVheklOSmJrek81VkVPbjBxR01JSE04amsvUElOZEt4?=
 =?utf-8?B?TThwUVAzczNsMXZJckJydHZlQkpHa3M5NldzRlRleVZ5NDFmUi9SY21mWWVz?=
 =?utf-8?B?UzJQY0dtenY0eDFwcFQxbFViVFY3Q3FyTm93MG03NDJlQVdzMERxQnRPcjY2?=
 =?utf-8?B?Q05EVW9MazNERnd6bEVFZTJpL2w4Wk96dWg4Yzh4YkhOcWxDcFhaSnNxNE51?=
 =?utf-8?B?cWlrcUNCUzRya1lzbHhUTVJCRzNUdEVNSk5iSlp5bzZvS1IyQ3luQitnU1E4?=
 =?utf-8?B?R1doZzFBL3FJZ1dWMEdvSGFWeGhZanZIV2huejNEM1pDbjBMMytoV2MyZk9N?=
 =?utf-8?B?YTlxck82c0FoaGF6WXNkVGtRQkJNTzFkOVJnN3dpdi90V2dRcmt5WlhYNTJ2?=
 =?utf-8?B?NXh1YkFJcjYvaFFLMHY1bUtSbXN2dDRkK3NtTGhpRkN0T0p2aUtiM3dvVlg4?=
 =?utf-8?B?MGRNWmtxeEdhSHh5Y1c1RnNuM1hHRnk2OWZRSDcvTTdxczVvdDUrMS9QT1Er?=
 =?utf-8?Q?NrnTWgjf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb4a154-f5be-44a5-a07f-08dbcfdc9722
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 13:17:34.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+YvyfweQiNPH7VX94MbyyGTiQSBp3/nkA0AhigB8GUCtAziY51F75Sub9A4icxXmPntpjbLCExkq4Khp9SSWz4kk2pL8zujBaJvIdCG0UI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_12,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180110
X-Proofpoint-GUID: wBS5syAA6uOJG4muFB3DWA_mjnrFPu11
X-Proofpoint-ORIG-GUID: wBS5syAA6uOJG4muFB3DWA_mjnrFPu11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/10/2023 14:04, Suthikulpanit, Suravee wrote:
> Joao,
> 
> On 10/17/2023 4:54 PM, Joao Martins wrote:
>>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>>> index af36c627022f..31b333cc6fe1 100644
>>>> --- a/drivers/iommu/amd/iommu.c
>>>> +++ b/drivers/iommu/amd/iommu.c
>>>> ....
>>>> @@ -2156,11 +2160,17 @@ static inline u64 dma_max_address(void)
>>>>        return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>>>>    }
>>>>    +static bool amd_iommu_hd_support(struct amd_iommu *iommu)
>>>> +{
>>>> +    return iommu && (iommu->features & FEATURE_HDSUP);
>>>> +}
>>>> +
>>> You can use the newly introduced check_feature(u64 mask) to check the HD
>>> support.
>>>
>> It appears that the check_feature() is logically equivalent to
>> check_feature_on_all_iommus(); where this check is per-device/per-iommu check to
>> support potentially nature of different IOMMUs with different features. Being
>> per-IOMMU would allow you to have firmware to not advertise certain IOMMU
>> features on some devices while still supporting for others. I understand this is
>> not a thing in x86, but the UAPI supports it. Having said that, you still want
>> me to switch to check_feature() ?
> 
> So far, AMD does not have system w/ multiple IOMMUs, which have different
> EFR/EFR2. However, the AMD IOMMU spec does not enforce EFR/EFR2 of all IOMMU
> instances to be the same. There are certain features, which require consistent
> support across all IOMMUs. That's why we introduced the system-wide
> amd_iommu_efr / amd_iommu_efr2 to simpify feature checking logic in the driver.
> 

Ack

> For EFR[HDSup], let's consider a VM with two VFIO pass-through devices (dev_A
> and dev_B). Each device is on different IOMMU instance (IOMMU_A, IOMMU_B), where
> only IOMMU_A has EFR[HDSUP]=1.
> 
> If we call do_iommu_domain_alloc(type, dev_A, IOMMU_HWPT_ALLOC_ENFORCE_DIRTY),
> this should return a domain w/ dirty_ops set. Then, if we attach dev_B to the
> same domain, the following check should return -EINVAL.
> 
True; this is what it is in this patch.

> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
>          return 0;
> 
>      dev_data->defer_attach = false;
> +    if (dom->dirty_ops && iommu &&
> +        !(iommu->features & FEATURE_HDSUP))
> +        return -EINVAL;
> 
> which means dev_A and dev_B cannot be in the same VFIO domain.
> 
Correct; and that's by design.

> In this case, since we can prevent devices on IOMMUs w/ different EFR[HDSUP] bit
> to share the same domain, it should be safe to support dirty tracking on such
> system, and it makes sense to just check the per-IOMMU EFR value (i.e.
> iommu->features). If we decide to keep this, we probably should put comment in
> the code to describe this.

OK, I'll leave a comment, but note that this isn't an odd case, we are supposed
to enforce dirty tracking on the iommu domain, and then nack any non-supported
IOMMUs such taht only devices with dirty-tracking supported IOMMUs are present.
But the well-behaved userspace app will also check accordingly if the capability
is there in the IOMMU.

Btw, I understand that this is not the case for current AMD systems where
everything is homogeneous. We can simplify this with check_feature() afterwards,
but the fact that the spec doesn't prevent it makes me wonder too :)
