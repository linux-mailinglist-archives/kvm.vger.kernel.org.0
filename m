Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3349A7D3B8B
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjJWP4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJWP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:56:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A0EBC
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:56:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NFNvwa011294;
        Mon, 23 Oct 2023 15:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=JRILR4lp9maEX+H0c5s71fPv9bpz7rkV+TwpSnQgg/g=;
 b=30eoAo3dh8qP6TYRpyOwazqg5Xoa27m+mMJvTyl2MNKu0e3ajriS93zFpHC8Tca43EzN
 ts8BN4JjKFXBXCWiZoj5GrPY5PJL52AnFSUXkPjBNy8TBoNP3Ji0DHoE+Tchho1KY1C6
 fcK6I2bGbY25yH8PC++vcuYhA7J+DJQo8qQlVMIELW4nNRKXvYCJSo01uHzyL/XAjJWA
 rK2uvKVTD5Kc5c/fL/A5vN3lDYIiwyC+wOLj5Ng2u1v0ayhj+DULkGX7xkmL0sCStukR
 jQBYbbkzC5ym5eYXD9UprI3daOGU4YcCxIBdl+7HeFY+b2IO4Y+g052qW3/zErEcQoCy ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52duecb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 15:56:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NFj37a001514;
        Mon, 23 Oct 2023 15:56:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53amjqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 15:56:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJvOvYnqAYigdtTLlDWPSzSVnkfE86K4A1O0oDcU6v0Yw3pOqayiX+pHE1kvcfB6kijiA+6LG8IzBW1RMoV+fQ0Ez9Mux270ob6a41dml7+bIN6sW0XxAvxBcim6A6BLZu7l3zFtZOAz2WmUsXYw14qBednfkNbq6rJw+mjX1kdclXWcrx33KgTqQbJ0TH12cxNubfs2xhMBJmbHYR4U+7YjBuClJYnAvK7g/Do6+h6VMVDKkGdaRENRcXQgl3WQWB4TqwD13jHxRv4qUpSB3p74EbdHimfM0l61p2Ivd3E8U3Be1HnS6V5sM2cJFeBx2WRIc+yB/s76lA0egb3lIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRILR4lp9maEX+H0c5s71fPv9bpz7rkV+TwpSnQgg/g=;
 b=VVeYq2MkRsW8OfMJmTMSl2g/Fs8GgSceJwVCYBuyBtz6HXShBmf51rJaHIoxv7vS7ijaRBFpfq5wADoCT5shAaiciXEDNQR9KHNBiupgeOftb572T63Bv2OZIq/F7zMc8Qrpd6CUMTskjnYqRIyWyq4VQYfWonov3nqYqURCvwPTuFgzFE7qw6b8WnNtAaxoB458VD/vJICJCZstpIFJ5bHHhcwKfuia1w1vhdVs4jn2mRp/UGZ+vUcYaUcqQbKbqj3ACZYpyVlm+M1/MGbggbqUO/6N4nPHXaV6DFk0bOgWwQNe/UxKimDmDrXm7SfPfR19hC/rOS+fZ7DeI6Kn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRILR4lp9maEX+H0c5s71fPv9bpz7rkV+TwpSnQgg/g=;
 b=SLvLd3+YzRvLI3pCAgsLGcfheOjP8YmtiW/iHtVjM6o4DnyEudIfUfC7z5xD9e+0cwWj+P6ARxgBo1gZtZhgpu+ktWPohZ1uER3ikkSOAzrZfDyjzZ+6uu7OpxiR1NWI95PrqbtKcM6dzjJ7J063V+0e4BpeJ5MxSMCzhZsGzVs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB4842.namprd10.prod.outlook.com (2603:10b6:610:df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 15:56:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 15:56:16 +0000
Message-ID: <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
Date:   Mon, 23 Oct 2023 16:56:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0208.apcprd04.prod.outlook.com
 (2603:1096:4:187::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB4842:EE_
X-MS-Office365-Filtering-Correlation-Id: c9425eee-69b5-4512-bdd5-08dbd3e09723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+zkW6yZJfe2R23dpRWqlAbSA4DMQApK1Mxf5G0B1TCU9r8W4CLDSV7clbLgxsBtjPMO2zdMbk4Mi/E+AAXmeMuj78XpfhHlwLZBsK3hbJqXnkLYlmE3eNqJSNFq32enJChovqu2ygsNLqrBtTI2N+kB3avBjMJGUf/9+UfGt0Mu0s6NyKZhbrUQ2fw+zkkmP9XtBxTDWIE2+CGYDMeh5O/ugstqc5eAV/nYx2gO0L4XB4FUViZk1o63Q8r1gDg6ruK3uYclG4LD4ySJSsBt98Ur0mg+oRGDYhlrfg5hBafV3M7vynOSGmXBvdUeE8lg160KD1B4XO/KiNRdjsOug5/UuCGTkrZCmE2vgfJfZTD2xY6SZiaLholFgjqrp3DhGI2ayyAvOkHXnUXyWpabd668xE7+laAtPEE4UDnlP9oeo6XOg+WdprxM8CWaYpJby6muaEyGgyG/rD4nZlFl3FJA9tao5pmxLpsBowwd7rUXb9aSeapt/m2TiEVf7na2P6c+rP94n1p+9wnd5TopKdeznJjPGWi9T+450afnq17gnnFMRL3NBGlDTSZdIaEzoJHve9QSHJNGg9ECs/DZMRwA2d29Gwat1t9ib/EBq02tF7jm3cSVzZYR+/ZITgkgLAHFOaayGK2OjolGSUluI0J9Qz8cBrWX2RmMXjlfSPs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(5660300002)(31686004)(4326008)(8936002)(6506007)(2616005)(41300700001)(8676002)(26005)(6512007)(66476007)(66556008)(316002)(54906003)(66946007)(110136005)(38100700002)(53546011)(6666004)(31696002)(36756003)(2906002)(478600001)(6486002)(86362001)(7416002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1oxWGxRbVZMaFR0UTVSQW5BWWFJMWRaRFJLVjRrL1JHZFo3V20yTDRIS1JJ?=
 =?utf-8?B?STVHdVcxTGltOUdBQ0dZNUVQMXhXZkkzSkpJTzZZSG9McXlJNC9ZSFBLdVF1?=
 =?utf-8?B?VXZMZmVieERuNE9VK1RuM3h5em5ZcE00SGcra2tZc3lySWFtLzlHcjNWRkVJ?=
 =?utf-8?B?S3ZRbE9pNFBaN2I3K0pvRy8rYnI3ZSt0L2tIVWQ0YTRsV01DZVMxU1FBcjVn?=
 =?utf-8?B?ZXZMeW9jL1o4Nld5UjBwVXROU1ByVXdKN254RkZ5blZmZ0s1bWs1OG9sUTBO?=
 =?utf-8?B?NGl6RUwxclpWUjZHWTdPcjlHVndsMWZuSzg5b3pRekx3VHVsMWhDem14VkN0?=
 =?utf-8?B?SDFsUWVZOXlzN0FDY1dsS25YQ3c3aldSNFBhSEhYcUowZnpSUm5LVEN5UWRF?=
 =?utf-8?B?b0R1aWwzT05pNmVISVRZb1FhWC9WR1NSdkRKOW9aSDUydHc2WDBjWWNwQURF?=
 =?utf-8?B?blJmc3l3VFlpdzhoVGI2NW90RVR2bEJKZGh4UjJ0V2hXL04xeUlKeFJlZktC?=
 =?utf-8?B?UURYMEhiTjJOZGNOS2RGcHhhbHhtaW1mdiszTmNWdDVFMVhnNkF1OEZCNHVD?=
 =?utf-8?B?anFoYzh1dTlINGgrWWZsZitTbEo4Zm9PbHFtaTg2ai9RL1NQUlFOV21KQzla?=
 =?utf-8?B?TzlnbVZOWk9MUlA2dVdyU0djeUt5MmJOeWIyZ3Rua1FETzE0N2hMUHk1ajkw?=
 =?utf-8?B?U0NPVDcxUEFNcjhFSTRkdXJqSG4wYk9MdlJvaStWSFV4TTVhemlpMXQ0M1dT?=
 =?utf-8?B?amVNWU92bEdMRXBiZHp4TGcyQmt6eDJMVFVRQlM5VFQxbHFBaG9PUWpMWHQr?=
 =?utf-8?B?VkJTN1JHUGQrR0NsMXNjTkVNVDVqZy9tdnVwVUQyc3lVSDJGbm95eXVPR2ow?=
 =?utf-8?B?TU1BaXY3U2JnMHZPRk5hMGo3WHlKWWo1QTRlMnlsaTYrd2JBYXRJdk4zdlJJ?=
 =?utf-8?B?YmpIOW1ZaldEbytTU3U3anJyOGp6OWhCcjhDeXdFejE2WWtxSFFXWG53TFlB?=
 =?utf-8?B?YkVITXRhWGwyK3BHNlVEZlNzSnRXNmpDWEthMnM0T0VCQWJsRDBXaW1PdElT?=
 =?utf-8?B?ajlydm1Xa1d2eENncS9XQmp2ZkU5S2I2RnViektYaTMwczhTcm1KbCsyZ3o0?=
 =?utf-8?B?bVJTU2xYWk03UjY0Z1h4NWJjNDl6RmNJV1hmYkx1b1RXek1tZHpPSTdxanAz?=
 =?utf-8?B?d2swYk83VXVIdGVPa3diNjIrVHNIZVpTTnpaSVNVcGZIMit0TklaVXRCV3Ba?=
 =?utf-8?B?RFBNTFBmY3JzcWF5dVNvd1pFeFIyUi8zLzdBZklBaFlQcXYveSt4NFFGUm9k?=
 =?utf-8?B?eTE4aTUrak1yd052OUxSN3lnc3NGemdjNFVQZmU4QU4wTm1SMHd6M2ZFTk5N?=
 =?utf-8?B?TE4wYXdKd2h0Z3F1Y0dGWDZHU256SzBqd2lkdGVpTE1BbTFuYXc0RGtEMC91?=
 =?utf-8?B?YmVqaGdVSHFvNlZXU1Evdm9zWW12Q0dGRXBiaEJGOVFNeWYzNFhKS3VYdDNy?=
 =?utf-8?B?UWJKWU55WkNFd0RlS1d4NUsxNHVZaTZhbW9MS1BjdmxOaCtLdGtNNzZGS3I0?=
 =?utf-8?B?Q1VGS0RHY3d3czFFaVAvekdoY25BdkxIMUZVUTFWeWllTzZtTExCTzU5RmN6?=
 =?utf-8?B?VVc4UFFCRXNQaThDT2RtNDFaV2ZYU0wrM2NQeG4ybmpKZWhJSHg4YjNoVDB0?=
 =?utf-8?B?a3ZUZk1qTnRJMjJsU2JMdnBRV1U5VUJMbFJOY00rQ3kvZWZabnBCdERPUzUv?=
 =?utf-8?B?cFlYSVhidkdLMlNwUmdwQlJMTVJ0VEZKUm5vYU5HclZVb2szV0h2WW5Yb1Ix?=
 =?utf-8?B?U0gvOEJDc1FMSzQ0VkIwR2dXanRhVk9vV09rU2hRRkNrQkN3ZXNKbk9pQXl4?=
 =?utf-8?B?VzNyblpmNjBNOFhsUXBaZXBseDBQVkM0RTU4SFJZb25BNE5sblErZmRRZFp0?=
 =?utf-8?B?UVIwYVN2cmtCNGVzVTYyWEtuL3lNMm1rVjV1U2l4R1oxTUpRb3dEeTRDVmtt?=
 =?utf-8?B?WmdULzNXQmgxUTM4VVZ6bWZpaWZ3SU1yWEplMlZzbElmQ0VjdE1OQkJNKzV1?=
 =?utf-8?B?dUFGbmtxOTZGTHZhL25NMTlWSmZlRWhVS1F2MXFMS2w3MXZqS2xpc0tMc1hr?=
 =?utf-8?B?SEZPV1VabnlhUy9ZYjVNK2xMNEFBNzM3VUJnb0kvNG1na2FGTFIra0pGcTBP?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VkZHMitEQ3daLzVVblE0YTByM0p2bmFka0k4eXZSaEcyMkFhSTJLY245Qm9G?=
 =?utf-8?B?VkNEM0I4cktjNnhqUm5tRGNGVVZQSEFXUkRvT21GU3NKd2NrSXN3YXZPMVlq?=
 =?utf-8?B?QmZGeHFXaElvRFBUa1ZtVHk4ekw5ZUZMQ3JtaGIwMVkvMWV3RGY0MENOT08w?=
 =?utf-8?B?QTZuQXdTdi93aHM3Z1lodk5XYVdFczNBblo2TWpFdDRHS3V0QXhPL2RrcC9q?=
 =?utf-8?B?bnpucTBRTi9WNWk1aFowN0NSOThKSS9HZDR6TlpUU0JkNEsrVVpqQXBYeGJB?=
 =?utf-8?B?NHdhVGdoV2pzc2VpR291QXgycFZHbHR3NEhoRCtKQVMwVmU1d2xXUmZxcTNq?=
 =?utf-8?B?a2JqNWlEaWNIZHlobVZxU2NXcTh6aHRVMGxzbXlTQlNnYXdxSXg1YldHdEV5?=
 =?utf-8?B?Mm5PdGIvaEFsWDZibHRJSFJQTXFDcVFhTUxVckdlejRGUFZkaXRLeVUvSkFK?=
 =?utf-8?B?SGhXT1ZWbm9EK25yVjVsZHRZVEp5RllaOEVTcTF2b0l6SndzM1BsU2hkY1RW?=
 =?utf-8?B?a1c1elhkYTNGVHBqdHRjRVIxWnRwSXZNZmVJTnp4MkJ6ODhWUVdJVzRkbUxw?=
 =?utf-8?B?MitZa2JHaEczb01qL1FQS041bEZZRUtpbE1QVmNYVTlqZjh1YXNQRTQwUjUw?=
 =?utf-8?B?dmRXVTZrRWl4U2VqY0NEaXVXRmhXZFpTcHBEREl0d2RvVHNlbXZCSEw5Z3Vl?=
 =?utf-8?B?V1ZxM3hKY0FScXJhbm5nVWZ5eUdITHNYU2h5WVNLcVdaaDFPS0lyaURyYlgv?=
 =?utf-8?B?K1BQeTR2R0p6ME96YW5UemMyaW80RUM5M0RtR0I5UHQyUWsrdm4rSUlhUFlD?=
 =?utf-8?B?a3FHeDVKb29zRWQ3cmxPcHFMcHhTWWVIb2tHeDRJZ29oWEtERG9jdWxkbHVk?=
 =?utf-8?B?Mk03UXowMVVvNGwzWGZHeDB1KzdaMTB0a2VjdEwrZ2JVREZEOC8yUlREV2h2?=
 =?utf-8?B?L2VTNGhDSnZmWEh4dkJwd09lVDdVbVZlNzllNDFTWVl4Z3p4Nzl2Q3ZCQXVO?=
 =?utf-8?B?RVVxSnB4T3Z0V2xvalJwd2tuR0JSUnFRRE9aaVYwNjc0QXRFc3duTE8zT1Fl?=
 =?utf-8?B?Unk2eHQrMGhUWEFsZHd2Qlo1Um9CVmU0VHdQYndHSE5KQkxCbkRQTlg5eTFk?=
 =?utf-8?B?UjdpcUdmWlBzajJRd0FyOC85ZDc0MS8zUTlsVDZqVjhVV01WU2pVaDZkVTh1?=
 =?utf-8?B?VzlQRFlabHpQMkFZaGtISGdTLzV3dDErK3luUldKZGNkWHFXK0MxaWNlT3My?=
 =?utf-8?B?OWk0azluYTlIa2pNSm40ZFV0NXpGS1phVU82VmZNMmd2UWkxaGxnOUtBUnpW?=
 =?utf-8?B?RjRKTFpTTWV0MXpxODNMOCtycHhJUFo5VVB4VGswd0hHaWFXTWh0SWJxT25n?=
 =?utf-8?B?U29nNDN1VFEvdC9UV0JRc1d6R1pSYVRDSENkNlNJbERQM2cxNEJkWldQbUMy?=
 =?utf-8?B?NGxIN3N0RDVOSTc1TjBXUzgrL2wreTIwNDUwcTZRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9425eee-69b5-4512-bdd5-08dbd3e09723
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 15:56:16.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvigHEx5oLBqG9KHKj3z4qKtW6/r6hxiwOLQNSAp7PRkxa+AuyyECRgHNt0NBFnDSKQ6ghlYxnh5BruFPJTLBcx7TO6uLPrutVegtusucmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_15,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230138
X-Proofpoint-ORIG-GUID: m-AYs82EQ8YX4LPEjE6Wgr9NmB4X3GKy
X-Proofpoint-GUID: m-AYs82EQ8YX4LPEjE6Wgr9NmB4X3GKy
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 13:41, Arnd Bergmann wrote:
> On Mon, Oct 23, 2023, at 14:10, Jason Gunthorpe wrote:
>> On Mon, Oct 23, 2023 at 10:28:13AM +0100, Joao Martins wrote:
>>>> so it's probably
>>>> best to add a range check plus type cast, rather than an
>>>> expensive div_u64() here.
>>>
>>> OK
>>
>> Just keep it simple, we don't need to optimize for 32 bit. div_u64
>> will make the compiler happy.
> 
> Fair enough. FWIW, I tried adding just the range check to see
> if that would make the compiler turn it into a 32-bit division,
> but that didn't work.
> 
> Some type of range check might still be good to have for
> unrelated reasons.

I can reproduce the arm32 build problem and I'm applying this diff below to this
patch to fix it. It essentially moves all the checks to
iommufd_check_iova_range(), including range-check and adding div_u64.

Additionally, perhaps should also move the iommufd_check_iova_range() invocation
via io_pagetable.c code rather than hw-pagetable code? It seems to make more
sense as there's nothing hw-pagetable specific that needs to be in here.

diff --git a/drivers/iommu/iommufd/hw_pagetable.c
b/drivers/iommu/iommufd/hw_pagetable.c
index a25042b0d3ba..4705954c51fe 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -224,23 +224,27 @@ int iommufd_hwpt_set_dirty_tracking(struct iommufd_ucmd *ucmd)
 int iommufd_check_iova_range(struct iommufd_ioas *ioas,
                             struct iommu_hwpt_get_dirty_bitmap *bitmap)
 {
-       unsigned long npages;
+       unsigned long npages, last_iova, iova = bitmap->iova;
+       unsigned long length = bitmap->length;
        size_t iommu_pgsize;
        int rc = -EINVAL;

        if (!bitmap->page_size)
                return rc;

-       npages = bitmap->length / bitmap->page_size;
+       if (check_add_overflow(iova, length - 1, &last_iova))
+               return -EOVERFLOW;
+
+       npages = div_u64(bitmap->length, bitmap->page_size);
        if (!npages || (npages > ULONG_MAX))
                return rc;

        iommu_pgsize = ioas->iopt.iova_alignment;

-       if (bitmap->iova & (iommu_pgsize - 1))
+       if (iova & (iommu_pgsize - 1))
                return rc;

-       if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
+       if (length || length & (iommu_pgsize - 1))
                return rc;

        return 0;
diff --git a/drivers/iommu/iommufd/io_pagetable.c
b/drivers/iommu/iommufd/io_pagetable.c
index 9955797862eb..00f5f60dc27e 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -486,15 +486,7 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
                                   unsigned long flags,
                                   struct iommu_hwpt_get_dirty_bitmap *bitmap)
 {
-       unsigned long last_iova, iova = bitmap->iova;
-       unsigned long length = bitmap->length;
-       int ret = -EINVAL;
-
-       if ((iova & (iopt->iova_alignment - 1)))
-               return -EINVAL;
-
-       if (check_add_overflow(iova, length - 1, &last_iova))
-               return -EOVERFLOW;
+       int ret;

        down_read(&iopt->iova_rwsem);
        ret = iommu_read_and_clear_dirty(domain, iopt, flags, bitmap);
