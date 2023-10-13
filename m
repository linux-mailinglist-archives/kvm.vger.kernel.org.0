Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78587C8968
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjJMP7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjJMP7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:59:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BC71BD
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:58:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0mYl019219;
        Fri, 13 Oct 2023 15:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vBwB6bXq+d+UwHCcod9+/ysYtcP/+wgDh/leDPXGtU8=;
 b=zQ2vPvFpx/wBFJU90ib6da0z8Wx66qCqR3CQbAuDdcNrinyMIe3QpmX34anOy6x1oXnF
 I3ZuwtrSpfKlmG6W0s4Yz9H+G60Oe9OGfpvhHEGn1cpwcp6pPjORvSy8GtHlxrUOP76/
 cBZqF6R+U9Gmgu9afRVeCPUNJSoMjh2EXtuSJz8ND2mde0Jba7Jm809EWnoAivPL/wCq
 H8MwTYaoZGUR9pRo16C/ONdrPhU3qE+qNRq3cLIVTgWsdPaeHon91N7Ft2SCLdDsJkhq
 FY4RTjOoPtGmR7FSdvRTQAN/zTIth/eYyE/En5a6pQOOgoWiYv6nKsiYUsvOMRdjh2KL Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh912nbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 15:58:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DFKNvT040234;
        Fri, 13 Oct 2023 15:58:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tpteasav4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 15:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwpGvJkCNHKfgk55GI5a2INRZO2mcINJXnEbvIVJr76bXzwdFz/r5zKhn1/POc/bdw/40T8TO4St/yBjN8VJYFCAifDM7uzRiVPWxGwH8X+30iyeQ2LSA60i7TWndmSpNSjdI9Fy03tYtZChozvL21J/Gv+bTPEqe4s9H2ArRiCDBAYmY+pdDII0fsaaudhORul0gtlhw6JbVo88WREQJetq70jW+SZ5rd+PtvH2uJkx1CMBxZMADEoYwjLKc2cAferGa3zKiHoHi6YSyA/JlhwkVeHGqMAlFaDn0XC1P8YuWYoWqPqPm0o1xtUbQIcDvRvay/38oKXVBhGOvTOEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBwB6bXq+d+UwHCcod9+/ysYtcP/+wgDh/leDPXGtU8=;
 b=aRC+6xbOIftK5nQy5S3IINZmKLKXjlO8p5QlR2q3l8iX1uBedZr1sZOrSZ7g2UEAUwbuDgHkqpAYDnCUXBPZkWK+0kUkxAxIxjJPXtoeLP7zx8zv0KB9jbyyUHH79coDi8T9HGIIgXm3IIH+uxupJco+VRCNk/JsQi2Ogjc74gZifR/s/Mt1VFF8P7zY9XIyWIzwknEbQyZH/6CH2OiIPAu3DYdz3Q3oRHefA2prSj+3YotRo0ZnwwpA/NoMoeM/O8xSrsk64FNVDFrMHe/Nhz8qmT8EAEXio5g3YJ4OjmcI/iQCAR+akzdRozbAp3OAd4arjUGwmwx7bYq+H/Yx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBwB6bXq+d+UwHCcod9+/ysYtcP/+wgDh/leDPXGtU8=;
 b=WifVcfcgAHhzVCyCmKuwdl3nRZeoigOSMD4CNg6Iox140aYFxPcAMkeYQdfIi2zOHNNLfHWSa4qtZLdKP0om+rpzgXx3g7h1a9ZP3lU732e9IfjRVO8eSDpMtoXkzXAxmy2xJIVNB66bbVdVS7Y6UCQ9quN3+cVARravYDNzlJI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB4825.namprd10.prod.outlook.com (2603:10b6:610:da::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 15:58:00 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 15:58:00 +0000
Message-ID: <8d141f1d-bb60-4413-b85b-8e952cceef78@oracle.com>
Date:   Fri, 13 Oct 2023 16:57:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/19] vfio/iova_bitmap: Export more API symbols
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
 <20230923012511.10379-2-joao.m.martins@oracle.com>
 <20231013154349.GW3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013154349.GW3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f873fab-d0c2-49b5-bf23-08dbcc052cc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqCmWzYeHv9UqCNEMBeIQuRS/jljBx/bPel1rCE+ITOAEcGT0D+2s5UqlKqu0PZipaKFS/tRlmmTx7kLFYNth1L5voy03ulkTmMbRHV3Z1cAwkzHFNpIAp4TqLG3UY+15yY2erSJ0HNwfQQWpFCJKsUOShll+SqAWTKCS/o42Gon9BKlIqT6V/R+YcYL88wmvrpv7PQFPwSfD2AwvGzIrE8DqkDrlEFXLyVASmy2ieFyI1Z1/j6V+vIFvIeDpib0keIEZx+6p2KZ9HP5Yyis+o0RaJa3W2o/5pytdtx75qfxIw8JkiPTuQjZPxj/pL8N/1DVHkjNuVmSOo6Y8GvxiM0WHgy2aCw5oHkvYrb3BefHwgznBLVdclBrwN9EqKuT7Z75avDfhVyjMO95w4DPwidFDTN5CinujMOepW8SYHzX/9KGUt+/SAjWs9+m032/vuvFb/Yz6ar98UmqG1gGEAyjpM9nos5pJapH46daFxdNNDVggYQS1CMBPvCViG5s0qOeScZwFsfM9TdjguFeyK+8rQR1/nOM0pKqu6JHaPPf3PW5mryiftPZ8IfLaC+IJdg7XsxFUwDZaS8vO/57A7iUDSwyxvkRqdizj/rCB4+PXK8UVP6jvQbaOZ89A8DkA3nOVu5VKq+QmSfW8PefAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(6512007)(26005)(38100700002)(2616005)(478600001)(4326008)(5660300002)(8936002)(8676002)(31696002)(7416002)(86362001)(4744005)(2906002)(66476007)(66556008)(54906003)(36756003)(41300700001)(6486002)(66946007)(316002)(6916009)(6666004)(53546011)(6506007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUhJNXB3UG0wNXp6ejFJUTlheCtIWHJUdWRRY2JJSjBoaW93R2lXVkxEMXdR?=
 =?utf-8?B?U0EzVEI5RXFwNTg1cDcxNnRNVnZwNEhCeEI3blVtTkJCZGEvSTQ1b0t5RGdv?=
 =?utf-8?B?RG1WY1hXUldQckpBWUJ3cE1SbjRiYUs5RklOMUxjUzI4R0Z0V3BxWGV5TXov?=
 =?utf-8?B?VUpIN3Q0cjVEanpZRkRseEJRT3NXUnJPNTB3aDhPNFY4OHZwODhuY0dteFU5?=
 =?utf-8?B?T3A4TzBHUllSV1dEWXQ2bkNsYytyY3ROUVRQdkttS2d1Ky9RenFvemV2Ym42?=
 =?utf-8?B?ZVJzQnlnaC9UTTRPNEJYdHJkbWszSW5CRklFWXdObXJYMnBKcWloYmg2a1d3?=
 =?utf-8?B?cE1FRHFrMTVzdUF1SVNpZndxaHpiK2VwbVN3M29lZEVjVVkzNXdlMDlyby9B?=
 =?utf-8?B?bXV3L3BjS2lzc1N3NXdUQThySFA4VSszU3UvL2pkRnFhZmo3MVNRMG1RelBP?=
 =?utf-8?B?R0xnOXJUNnNnejJsR2puRldCRW5xOE9pNmYyY3NHWUxldGtPNS8xWDFhVWFo?=
 =?utf-8?B?cUtmTzRDUHA4SUdUQmdlVmcrRXRtZUNiTkhlQ05BMHJKTVdIQ3FPdHJnaWlh?=
 =?utf-8?B?dGRCNkF4S2dqVDg1ckhJZmJQbThhVnErbjRWOTY1LzdSQW5vMnE3RVpBN1BT?=
 =?utf-8?B?Qm5VaUtmcW5yUitTZ1gvZ0xRa1I0ZE4yVW5POEsvTTlOcmxVUXJ6ZmlZYlJi?=
 =?utf-8?B?QW9xblpodEJQS3ZqYkdSUWx1citQUlF4WWNSYXpMcEFZN1lZNmx5TmtwOG5v?=
 =?utf-8?B?aDNKOVpoeXNzWk5CUlNvZEZ5N3ZKSTkxMm1XVVUyZ2dTcGlYdGZiSnNibmxp?=
 =?utf-8?B?M1kxRzV1TjFqczJ5TXdSN0tSWkREMUdoWERYK2NORWR4bXNheUpsOVRpL3Zu?=
 =?utf-8?B?cWlVUmlXRm9jY0NnbXQ2Zlg2OVdOa0lpRGVuU2JsOHdiL2ZuTTVQVSsyeExZ?=
 =?utf-8?B?QlRZdDBsK1JOOW9HQ1cxclJIUHVsdEgzMXRLRWFVaWZMSmsrb0R5Z0tQSU9I?=
 =?utf-8?B?MDNrL25QcGRlUFJKaklHWnppdXRIcVNTRFluOTc2KyttWkFKNXBwbXlwcHZn?=
 =?utf-8?B?NkZJamQ4a1lYbGY4WC9rb0dkdVY1bDg4WEV0WnBPTVNJN0dIRkZzNjREeGlV?=
 =?utf-8?B?YUd5YUQ5cXF6S1ZNMVh5NzhjZGlPN2lDRzZWZU55TjI1cVZFTDBaSjM4T3E3?=
 =?utf-8?B?Uy9ZZVhmcC9mR01PNWMrcWNVOXZxWWdYa0xRL3lGMTJQS1l5RjN3VWJ6N0Ez?=
 =?utf-8?B?NllVZ2UxWjFXbGY3czcxYTdwNW95VEQxODJQSkp1bGRDaUVkTzZZTE5pRmkv?=
 =?utf-8?B?aFQyWlNKZG1uNGZkMlV1UE43NWdkOHJjcFBWbjFxYUpBTUFBOTVVVTlqT0l5?=
 =?utf-8?B?N3ZNTUplM1VacjBOWWNUdCtyVEVOczZ5QWN5RHhpRFVibnVGdXpnLzNnenNC?=
 =?utf-8?B?QVB0MmlNeDREckVxVEFDUTdkOXRnWjZSNnYzZ1RWNFZwS0JQTVVzMWVocE1Z?=
 =?utf-8?B?aGhhRXZrcDR5QTN2Nk1XdmlXZ0M1c3dNZkZPMm10eEVrK3FvU081b3BGNktY?=
 =?utf-8?B?dU9Ec1czYWdhWm1NMFAvUGtFSEFzVjBoOEFBOUgzRk54V2VpSVRBY0lnb0xX?=
 =?utf-8?B?TkUya3NRZUltcWJ5Y2JuajZQUXNqM3Y1WTNiT29pdDIyZnU2UnpBL0hwUEl0?=
 =?utf-8?B?M2lHZW1vZ3oyUVY5THA4bm0rQzdXU1VNcUFIb2JzL0daRXM5c1RtT0dJRm5u?=
 =?utf-8?B?MkYyRTFZamxqWFZvV0hhY25TRDZnSERGOU12NzlXR3VKamtxYjYyOU9kUGQ4?=
 =?utf-8?B?bEdCZkdKYkIxNC9zVDUraFRyRmZ5Rnc4N3Yva3hIZ1h1VjNLcGowZ2tUVmZS?=
 =?utf-8?B?VERPN3J1MC92cUhSMjZ1MEJLYnFkT25iSDNISjZDOUtRclI2VTdqdFpoQ20w?=
 =?utf-8?B?ZXpMYmw3U0taMTdZZzR3OC9oNGJkNU91eFErRUVLTVUva1B5R3VDekh2TzNv?=
 =?utf-8?B?VC9td1hSNm5GRnZickZQZ1QzeEpmNTdOdExMd2xUOGhHY1I1NTlVbWdteTNu?=
 =?utf-8?B?VXhhVUJkNTVQb09hRHVpb09tOVlSS2lURGNZc1VWYXpxWlYyeHNvLzRaS0tE?=
 =?utf-8?B?V284NlJMMEp6Kyszdzh6SE9rajdsR0JhaXppRnAwNW9PejdtN1d2dUtTK3JF?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWhqTlNqY2tVMW55S2ZEYkEvMXlxWXlNNUY3Nzl5WkZvRy9aSnNWSm5pc1VX?=
 =?utf-8?B?dnJSRE9ER0ZmeExSZkpWZC8xcHVBc3ptQ1BZNERWM1BKeDYwQ3JSZW1sVW10?=
 =?utf-8?B?dlUycUh6THBiZStRS1ZXWHhEUDdJZWEzYTU0SWl0NHhzSXRBY1lhcXZwOVVx?=
 =?utf-8?B?OFo0K0cySXNPTjhYTzFsdjNkbFQ4UDlkdzZRNW9RMnhHWVBKSFRmTVZXWHFP?=
 =?utf-8?B?bHl5djlKL2ZZYlJ1cWRUUm9hQXBBN3UzQ1MxUzhzUHhTaGhjcWhPYzdHS3p1?=
 =?utf-8?B?bjYwV3BVc3MxS3c2OGdnRDFhMUdrZDdUZUtDSDRHUmJlcHBkdnpnTFREbHVU?=
 =?utf-8?B?R1ZJTXBJelBhdXpuWFIyQjZ1dmlXanZzakk1bzNpS094SkNlT2RudjVaczM2?=
 =?utf-8?B?dk9wREVYN2R4L29LL01aN1lIVnhCVDF5OHFrRVVPNzdLcVczc1AzSkNTQnBS?=
 =?utf-8?B?K0huaXJDM3NEZjFIRDA1QUZhQjZEYnc3Zzk5V0ZKMHFuUGswTGZiNFB6ZnlF?=
 =?utf-8?B?V3pOR1dUeHNxRDQvS1pLWm1vd3ZNancxbVFTb0g2c2tja0JIaTNrM3A3RllH?=
 =?utf-8?B?SEdUR05qU01CZWpEYUNyd0FMU0IrMmJ3WVU3SVJXUTBFZHd1RHBGRm1aamNs?=
 =?utf-8?B?bzQrK2g0R280MjhXNmgyQzFpMUl1bHNFRFhpNVh0WTZEdkVFcjlKQkI1d0Uy?=
 =?utf-8?B?c1A3Y09NTkU3Wk1MOG0rR0h1cmxLbUZJdi9id1V3VmExNE50MTBzcDdpckxV?=
 =?utf-8?B?NmpEWStDM3luRmdhYzFPRDdCTHJQTi9GWWxzS1o2R3JBNVM1ZXNXdXJhTW1R?=
 =?utf-8?B?b3BJOUdpRStBdEhkSC9oMmFXNjBWLzRqSzgzTmo0VXd2MXpYb1M1Mithamor?=
 =?utf-8?B?U3d2clUra2dBREhQNUROZ1JkQllpWks0cFBrV0JNY2lkcVVMOEN3c29XUjlw?=
 =?utf-8?B?VWcxR0twb05OWnY1bjdQR2ttTG9yaHRWWlpiV1NFV2g4UVc1SFRnT051V1pQ?=
 =?utf-8?B?V3hnaStsUmhZR3pkMHcvRFQ1NDFkNEtnWVpXMnB1ejRPQ0ErZmsvVG50TVdU?=
 =?utf-8?B?WURNMG5qaVpaUDJiQUN3ZFh2cjRQU2tXQnFqUlAwNzFHZUdZZ2NnRzJNVjNu?=
 =?utf-8?B?YkdDRTNaWkJiWjlUU0VlU3JxY0xRa0lYbGp5ZHZRNjF1d2E4R0dtd1QrZGtX?=
 =?utf-8?B?R0NtZm9QaEszUlZ1U3pHR2lxdzl4RzN6YlVNSGxkTWxTL2FwSFBZT3Q4Yy9k?=
 =?utf-8?B?S0RGNEs3OGJDZXFQcWZQSzhBTFlYMlViUE1qSVZGczlxR1dUMmNKY0VFeXRr?=
 =?utf-8?B?YVFXWXVwZVFNbFYvU2JXSDlENUxvTkx4Sng2ZXhxOTZEZWFMOFZOamhCektW?=
 =?utf-8?B?ZnV6d2Y4bCszbk1RN1B2RFFmV0o0NjVhU0t4dlh6VzkyODVEbkJDQlg1eFp4?=
 =?utf-8?Q?+0fhyoSg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f873fab-d0c2-49b5-bf23-08dbcc052cc1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 15:58:00.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWPVsZOxNLiA0+/eNFVxma6Yb6jep6c0O+KYjFUzEkBhIm/iBdu/i8gH1X+zScrgCaNM2/jnqLIc81qH+bMA3tO0wVCiaOu2zjBupYXrTnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4825
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_06,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130135
X-Proofpoint-GUID: MmgOqrDDvSzs96RcOergAW_hdsWQcnST
X-Proofpoint-ORIG-GUID: MmgOqrDDvSzs96RcOergAW_hdsWQcnST
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 16:43, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:53AM +0100, Joao Martins wrote:
>> In preparation to move iova_bitmap into iommufd, export the rest of API
>> symbols that will be used in what could be used by modules, namely:
>>
>> 	iova_bitmap_alloc
>> 	iova_bitmap_free
>> 	iova_bitmap_for_each
>>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/vfio/iova_bitmap.c | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> All iommufd symbols should be exported more like:
> 
> drivers/iommu/iommufd/device.c:EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
> 
> Including these. So please fix them all here too

OK, Provided your comment on the next patch to move this into IOMMUFD.

The IOMMU core didn't exported symbols that way, so I adhered to the style in-use.
