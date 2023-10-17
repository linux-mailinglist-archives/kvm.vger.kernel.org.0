Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429787CCAAD
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343606AbjJQSdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjJQSdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:33:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F29E
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:33:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HHsK8b011749;
        Tue, 17 Oct 2023 18:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=muAi4Ho2P2Yw2JcCJPwGjxXoDsb/ZJiLxFKv9FtAv3w=;
 b=B2pZdKed6ZD6bJc+GXpmHLIsOmkMSUHCBKrFgsynnl2WxIJLjx0jaIO6T9gHH42uJy1I
 5rMszyDrnup5j2QphKAlupITBV1D6ImDVEI+QhCiwyxZNmOJ/K2clqoCbQDbZj8llAXQ
 Ekb6fw8fIvx7aMksoceEM+cqQHRmH59y55A7kchO8gtHkhJT8JZ8B+dCKxKAqhViG7AU
 2E7BWZOWa74vJsC/ZAxnnksPBaFHa/fXXLVvHhc76hVPcZG83CTLTM6TgERUmxuFDSSz
 g01o8uXMDPdiudsIXOKOUs6hhpcJeIqKHACBgPlHH1fQazu5CIe/UeBcF9lDyrG5Zods kA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu5x09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 18:32:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HHXhDc009149;
        Tue, 17 Oct 2023 18:32:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0n6vjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 18:32:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMII9Zs/i31zYXjyvMZsqgC7Ghv4n2jU00yPWldOr7MyASPctOnhPPmQlCFOWBQyeJdHx1z6LRYAONgVd3qFOMnJkB98498EQi2ZJIcym9FIK6DUSgOtYTcbydN1M/c5BwMKJ1sFDiI6wESjbvPlsTO/bOi2Z5leOV4Vv4Fv2Hp9faf7DHn3SWiii/a4wPooZkxZHJq68iG6QbS/cdEx2hrErXF+3U/m+DBZNZF5v/BIKOfebpoYwlDp28G+SCuk/hRlGMrq305/viiqdPrq/9UExGhtdSzjgnxrhJc1Mdbhscaj5zaFEiYGPQdFg20GpD4G1a0WEoGz7kRicWttAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muAi4Ho2P2Yw2JcCJPwGjxXoDsb/ZJiLxFKv9FtAv3w=;
 b=CQqh6VPrR7FtGh83MG4W5LQFXvKn2dJNfNuhMbZ+Lo78PvidISvqTlpp2ZCg6ihWTWHriv4dTjJTk8zEw5gHydPjrFDfmEnTubDU/KC3zF9HG6Ozb1cXOaIvcJ4buDe9sgVCnhl4QwBXzAcDqrvpm/W2IsS+bpwi0KrPVkOM4fvtPHvP49ClZP4s0P/0FfOr7kz40+VYMUhUWuN0UE6SL7CuOhoWTvddxX75EUWuf8olMbT6XsEUOIt+MNiJ9zQ4+bCUjVAUvoMUts68vywOEthTidaawh8ZNuEvahyqlOZwsBkKdqSxqIaboSpbWKNq2InmPFg5lJ2uBSU06hocQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muAi4Ho2P2Yw2JcCJPwGjxXoDsb/ZJiLxFKv9FtAv3w=;
 b=nqHKOzRc1wbZCKudcQzaQI4q/u8gAtyeuluubVkVAK7ZJgJd9ZvUMh+oVrbZtsYW1a7yDhBnR9b3vavfJpMJyeaWhtHRP9X9QcChvwIgb+qsDidiKMSW51Dn+8mI+FF2CDT8yWt+P4GZE0yI/pnBVvFZBYZitd0/HaVJdp3BYf4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7807.namprd10.prod.outlook.com (2603:10b6:610:1bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Tue, 17 Oct
 2023 18:32:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 18:32:37 +0000
Message-ID: <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
Date:   Tue, 17 Oct 2023 19:32:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
In-Reply-To: <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: abcc31c3-1dd4-413e-45fc-08dbcf3f6fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqbzWmBP6nNMYs42UzC3J1XQ6/xc8vD88BBItAIc60pI1zJ7TEMVtElPhe8ZMe67kimjhyTX3TZ2G4UvuzRhENa7TKmzcHF7tFlOEZBwCcGoCQ3DA/25vhJ6bP7nR+ZYNb9jUJuC1uV/0bxG9jPa/+mOH8kDoAPDflvGofQwaYH1kV94gf3hBZ9XFi3BZK20np8z8u+BWDh+bPAL31QnujmY0fk3/Xe+NGE/jvj7APal8wVEVjJ2S2ByOG4WGWySM/Y7oqH7aPrVFCSM/XjURHBmuhFkk9rpKAeLlD9pdWcDsBRC24tEp0gIPvRemeSmTvfCC5S03xGflB2fl5p3gDWBs8l6UxY7MmlXwgLkKhO0UECBy1SgeaJdZdatFOlBsjCVRmTVX5leu9EH2Q87CxjLhBAFZXmewVGF8TWHkui+/8YRPPySu5onMYJVdQJIEvy7JLd0nTdMKPylOll1s44JUwMEli2Lz+xoRJHFxhQt1kA+rIMR3Pk8zleDzjnzrp16/Gj8/53QKhQms6Ym5pSJ0xRuKg8ebP2orNI6CbJTFyvWtFckfMfGRP8/bjUmfXR9Jx5otayxuxcXCV4hZkTTA1/HJuPWaFfKULNzPRSIjSsHWk8QvIDeNbDgTOpmeBZ1oqIhQEVx2pLucIHF+8zi9YZ56/WxoTsmqrTslao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(39860400002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(53546011)(83380400001)(26005)(36756003)(5660300002)(41300700001)(8936002)(4326008)(110136005)(8676002)(2616005)(86362001)(31696002)(31686004)(6486002)(66476007)(6666004)(966005)(2906002)(66946007)(478600001)(316002)(54906003)(7416002)(66556008)(6512007)(6506007)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGlhaERIUFMyYjR2YlFMa29CUGpaWDA2eEpaMHhBVDNmRmh5OXl2cElodUt5?=
 =?utf-8?B?ZDFxRHRtSklCU0I5Zy9pM29wZENoT1c0WW5rajBwa3drVGttQ01LK2p5OGc0?=
 =?utf-8?B?RGtBMzZZMG83VnNlWlc2d1RUTXI0NSt5MDFrOXZDanhWVjZ1VGdSZ2pLSDFN?=
 =?utf-8?B?TlBTV2RCT3dCMU0zakM1OGlSOGl3TnVFaWtTTnUzNTEyV0grUnBFT3BXMnVi?=
 =?utf-8?B?c25BZXZoWDR6Q0hmKy9XVWlZcjdnVDdjYTNLR0p6VkpMNXlJTmVIVVJzOVNM?=
 =?utf-8?B?SGhNMlErbXBtMzJhTUUycGFrdlpXVGwzOHhMclRXUUtpOEl2KzRzSFRPQjUw?=
 =?utf-8?B?SXpNTUpyUVYzRFBlYUlYdElUdmc3TmJpYzhZbWxlUU4rQmhtaTFYaDQ5ZFRk?=
 =?utf-8?B?d3VnbHl4N1NmVm5QcDJzUDdaOUhKQ0R4clVYSHdGQldKSE1EVzdRQWZZNkdH?=
 =?utf-8?B?Vmw5alY1c0R6cllUZGZoazFMQjM2MGlJNGVJdnV5Wk9mL1ZlS1hlRmZ6WHNm?=
 =?utf-8?B?RzlKeERVUW5QcEREY0NWNk96WnJmVjZSVm9HckVyMFFEaVlqdm8xSFBaR0dz?=
 =?utf-8?B?YTRhaXpRSDF6ZUEyVVMxNjNkeEU4S2QrSUdCcHFSV0ZRbGtySWNLWHVaUXpX?=
 =?utf-8?B?S2FqQTQwd0dOQVNJMHNYUlloejljZDFsL04rVDVsVmQvb3BETi9LSEdQQkU1?=
 =?utf-8?B?Rk85QnBOYngxL3NDTHd4bTRBQzd3c2xWOHZTWm9zZkRKcjdtYm5DaFpuMmxz?=
 =?utf-8?B?TmRqUTlWbCtUY3RiRXZZRGhPdFpwd2NIY0N0VU44Z3V0TXNHc3pjaS84cGlR?=
 =?utf-8?B?UVZkdjFORG9ZYzRSbEdLQVZoZ2ZpWHgvNW1TeWtOV2ZmUzZ0ZG5DQ0VLdFJK?=
 =?utf-8?B?VDhESW54bk1FYXpsYmN3OGd0V0xLTUV5WU5sRGxlTGFVaE55NlJsOEpsOWMy?=
 =?utf-8?B?RHg2R3lzbmw0R2hHRlEvTk1ISUc5SWtoVVU0cmRWYjNSTlozQWw4NEIxMUVh?=
 =?utf-8?B?NDBtemNzcis2WG1meU5TaUx2NGk2SW1zY3NKYVJOeVhPRm1DWXVMakVMckpC?=
 =?utf-8?B?Mlk0Y3pkaFhRNkZOSEg0R09NUmlIREJkZU95Q2U2TVRIWG0yazBPVmdDVWpa?=
 =?utf-8?B?Wjc5QjNPQWtLOXV2ODhFK3hWZGRNT2VNQlRVbEJtQk1DY245MzZ3WFRuWGFT?=
 =?utf-8?B?eElPZkJ5ZXBoYWQyK2NGL1EydEd6WHF1T1JIa2xITWhSNk9QNHEwV0ZxYzZM?=
 =?utf-8?B?NThwYzdWWExnZldoYzJ1TlBoL25UWnlTZ1RxcXZUMkV6VUQzeEJBQzFZQSs0?=
 =?utf-8?B?YnllM2JIWGI4d1hsVHBKeDV2dWw4M2l2b1k0VEpsRUlzdCtMOXkwdFA4QmNR?=
 =?utf-8?B?N01Edm1KSnFGbG5zZk1rV3FrTlBUYjdFL2lIaHVaMW5NbXNTSmd3RDBISEVD?=
 =?utf-8?B?bGxNUFFwR1MrUy9JbXYyVEU5bGxLa3hjSDlRNVJpem05djY0Y0N0TEFvMUJl?=
 =?utf-8?B?VVVvRU5mNmNHR0QrZ3U1KzBBTFJBTEsrV1lMUEdFazErblgrREVmTXhsbkJX?=
 =?utf-8?B?YTFsT291Mk93WWhmY283SHgySXBYVUx4SWk1M2pRUGYyVWV3SThGWTJkYlZn?=
 =?utf-8?B?MHkrSXNwbzViWEx6UEFyZWxCYmZoNzlIUU90azJ1N1AwbExHOW5sSGRybjhN?=
 =?utf-8?B?ZitOVXZaaUdoeVdRTVMxY0xLeGhOL3Rod282WTgxVWlvdHZwUEl2MUgxbGl5?=
 =?utf-8?B?bUdVZjBOZmcxUlQvNGRxbWxxcytxUWJtbzNHTlY2WjVxa0JRU1Z2SG94M3Bx?=
 =?utf-8?B?dXEvdkhpZWpQYTRUNVdJWlZFVEZ5ZWZqT0pha1FQMlhSY1ZCdjgwWkFCSE9r?=
 =?utf-8?B?OXJEMS9kUktuaGhEdDZ4TDI3alBVUGpJbnRxWFdaZmhWTjVacWhmVjR4UFZV?=
 =?utf-8?B?K1NEM25hbzRXclQ5QlFmZGt1cFViclBBNWpqUGFxYTFyN0dDSXFERUN5L09w?=
 =?utf-8?B?UmhwQjFXZ2pWcnhsYjBUQkEyZXFYVnpET2VJd0NlU3dkRjhwcnhVSWZobE1r?=
 =?utf-8?B?UThqdlZ2djh6UGlCemtydFhTRFR1RFh0Y3BjSXFCY1dBYXRScXlzQm1uWm1i?=
 =?utf-8?B?emVDektGaFcwaU5hT0NVeCtGZ2NFR2tLalRMNHpGMXR5S1owV2NwZ0M0VnM2?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SFMraUQrWjVLTHRhdE93bzhRU3MrVTIxaHpHb2M0QkRHWXQ0UFRQVjVUcnl6?=
 =?utf-8?B?eUhSZGZXSDhLdW1aV1RpYnk1WGdJMW9VZm9Oc1Jna3JuQkZIWG1GUWQ4Y3ZP?=
 =?utf-8?B?S2E1aWZBNVh2VHhUN3pQcDlKNmRBM1dnc2VXT3BBV21CYVBxeXozQTQycy9v?=
 =?utf-8?B?V3BITXVZcWgwY1luelp5RFFiMmw5eUdIQktDeWRVZ21HYzNITDlUS2RScHRI?=
 =?utf-8?B?Z0ErRTcvbncxVHNqaFU3ajJkT0x4K0xwbU93RzAraW1rdHp1eVJhTGxBVkZO?=
 =?utf-8?B?UWw1WVhodGd0WWJ6MW01L0gwbXdZOTRPUVpKWXp4NWdDVm1INDdUQ0kwbWZW?=
 =?utf-8?B?Nzd5NjVXNjdXR1llZGpzSG54SnZEdGloeE9EcHcrZUo1d2RqUmtFdnNZTHlW?=
 =?utf-8?B?QmRTR2JlMThqQWdZdkxDVU40NVRjbVZ2dXE4RGYvY202U2xqSzYzTEhyZFZh?=
 =?utf-8?B?bWJHYmxkQ05makIrMHFYTDdkeUhnNGNkOHBwRVV6QXIwUDMrTk5NcG1jUkp5?=
 =?utf-8?B?YjVtL1ZYbUNFb2kxcitlZUdiN0NvUmlUbzVuL2J6L2R2Z3FJaUZ2NzJ6b3Zq?=
 =?utf-8?B?cm4xQzlobDJCNnVRWjdzVFdiTm9NNGdtK1MvazBGMllBdk91aXhFZTcxVWxo?=
 =?utf-8?B?QnRCNmxJL2ZxWFR1MytlVllnNjVlTTYzRE1PaklCMlFOK3F4T0hOYTdOQjlq?=
 =?utf-8?B?aklSdW1TUHgva3lHdUd0NFR5YnlnK1FkM3AxUWg3aVphbUhuZWNGR01NcTRj?=
 =?utf-8?B?VVdqSkgxTHNRRzRucE1ZRnV1VndEaW1sQmFsc1ZEa1VRNnMxdlo3ZFhCeTBw?=
 =?utf-8?B?OVZMRHViSFFiakg5azVlM3k2QmlnbktVL1pqbkQrdW84RStzYmhDRHdxK2tY?=
 =?utf-8?B?MllENXA5RGFQNGEwdUZQaHFLSDRlbGNFSEFMbmhxUkk4bzVNZUkzRU1zU0FB?=
 =?utf-8?B?R1QrMGo0UXR3a1VLc0xUc1haZHVwRVlkVXowZGFuVXgrWWVVSnRGNWk2OXl3?=
 =?utf-8?B?Z0JzdTFibzNPQnZqZ0xydXFDWG5KelVyTW1WZjJRNnNDcitNQzlvWEF0N0dB?=
 =?utf-8?B?YlB3bXVWUzBxcXZBVXJpZ3hYMEVZWVpRK0xQRzBRZEtUbFBaaFcxR3VKY3lk?=
 =?utf-8?B?TVUvcW4yemJpaFlKWW1qcWlSNHlPZlZKMExnWlNRVzhBc1R2VnJDU1pQalpa?=
 =?utf-8?B?M013Z0VyK0M4Q2tTcGdSM3IvYlJRL0hZdzNIRVZ1SE9SZWlKVHowd1NUa0Fq?=
 =?utf-8?B?UUlOVjJWbEI2U2FvSVg5Zks0eGxUZlhMSXAwUW1FbCtNbU13djNza0h6ZkhN?=
 =?utf-8?B?TTd4T0RvbUI4aHJpTC92UVdUTGIvaDZwa2V3OFN3MkNVek5FVk1IRGhleXk0?=
 =?utf-8?B?L2drUnFWK0kvSEdCNHBMM1VTcXhEaVJYcUJBNHRTNlZra3NXT1pnWko5VThN?=
 =?utf-8?Q?x2w5U5c5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abcc31c3-1dd4-413e-45fc-08dbcf3f6fc9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 18:32:37.0030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31/MdtUd5CN8FsgRXScx6wlOtRZC6MqlXOhnmgZ8RxsM02RaDULyQq5QTGUpqLHYHztwZ/Tr+C8vfnQHjQ8fUuhGwL7mG0zPCdu/G+46BT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170156
X-Proofpoint-GUID: zDyMp5MiFM49vYx7IGVaH-5YVcZg3Qv1
X-Proofpoint-ORIG-GUID: zDyMp5MiFM49vYx7IGVaH-5YVcZg3Qv1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Suravee,

On 17/10/2023 10:54, Joao Martins wrote:
> On 17/10/2023 09:18, Suthikulpanit, Suravee wrote:
>> On 9/23/2023 8:25 AM, Joao Martins wrote:
>>> +    return 0;
>>> +}
>>> +
>>>   /*
>>>    * ----------------------------------------------------
>>>    */
>>> @@ -527,6 +610,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct
>>> io_pgtable_cfg *cfg, void *coo
>>>       pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
>>>       pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
>>>       pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
>>> +    pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
>>>         return &pgtable->iop;
>>>   }
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index af36c627022f..31b333cc6fe1 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> ....
>>> @@ -2156,11 +2160,17 @@ static inline u64 dma_max_address(void)
>>>       return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>>>   }
>>>   +static bool amd_iommu_hd_support(struct amd_iommu *iommu)
>>> +{
>>> +    return iommu && (iommu->features & FEATURE_HDSUP);
>>> +}
>>> +
>>
>> You can use the newly introduced check_feature(u64 mask) to check the HD support.
>>
> 
> It appears that the check_feature() is logically equivalent to
> check_feature_on_all_iommus(); where this check is per-device/per-iommu check to
> support potentially nature of different IOMMUs with different features. Being
> per-IOMMU would allow you to have firmware to not advertise certain IOMMU
> features on some devices while still supporting for others. I understand this is
> not a thing in x86, but the UAPI supports it. Having said that, you still want
> me to switch to check_feature() ?
> 

Do you have a strong preference here between current code and switching to
global check via check_feature() ?

> I think iommufd tree next branch is still in v6.6-rc2, so I am not sure I can
> really use check_feature() yet without leading Jason individual branch into
> compile errors. This all eventually gets merged into linux-next daily, but my
> impression is that individual maintainer's next is compilable? Worst case I
> submit a follow-up post merge cleanup to switch to check_feature()? [I can't use
> use check_feature_on_all_iommus() as that's removed by this commit below]
> 
Jason, how do we usually handle this cross trees? check_feature() doesn't exist
in your tree, but it does in Joerg's tree; meanwhile
check_feature_on_all_iommus() gets renamed to check_feature(). Should I need to
go with it, do I rebase against linux-next? I have been assuming that your tree
must compile; or worst-case different maintainer pull each other's trees.

Alternatively: I can check the counter directly to replicate the amd_iommu_efr
check under the current helper I made (amd_iommu_hd_support) and then change it
after the fact... That should lead to less dependencies?

>> (See
>> https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec)
>>
>>> ...
>>> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain
>>> *dom,
>>>           return 0;
>>>         dev_data->defer_attach = false;
>>> +    if (dom->dirty_ops && iommu &&
>>> +        !(iommu->features & FEATURE_HDSUP))
>>
>>     if (dom->dirty_ops && !check_feature(FEATURE_HDSUP))
>>
> OK -- will switch depending on above paragraph
> 
>>> +        return -EINVAL;
>>>         if (dev_data->domain)
>>>           detach_device(dev);
>>> @@ -2371,6 +2390,11 @@ static bool amd_iommu_capable(struct device *dev, enum
>>> iommu_cap cap)
>>>           return true;
>>>       case IOMMU_CAP_DEFERRED_FLUSH:
>>>           return true;
>>> +    case IOMMU_CAP_DIRTY: {
>>> +        struct amd_iommu *iommu = rlookup_amd_iommu(dev);
>>> +
>>> +        return amd_iommu_hd_support(iommu);
>>
>>         return check_feature(FEATURE_HDSUP);
>>
> Likewise
