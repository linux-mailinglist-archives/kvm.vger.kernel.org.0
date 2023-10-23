Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2239C7D413E
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjJWUus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjJWUuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:50:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16BE9D
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:50:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NKOXSA022288;
        Mon, 23 Oct 2023 20:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Jr5xYdxdC8g84TXrmiqABvwVqXntNY851QVp5dt9d7g=;
 b=S8B2y6iBLv2aVLeakRt8F+hDd5SEHV2NjtN3sfL/51lDbev4PIwDzBYJvgDPJ1AHd+jA
 CmqSFoXjimr/YV+0cxg+blI8vQ9jBI84rSmaHMMNYdDS+NiF775XKS6ie0KT+GsL+IaD
 FCIR/ckPSxpQs6oHYZ9/o+lETmHMuPwFaXTCmDD5WNVaGd/l07eal+qUB9aLwIWs7ne6
 RkDQJFMJD9Y/JoqlSkU8JzAuTZIx2LhPoCttD1WQZVCN+Np+76UTu+g2Nh3t52UgSrh5
 YBKXDJZyChUr/aSl6sGG2DyEpkfM5JKutOiwo/RrOdGFKJxWnq52YEiE4oHXeeBCynmc KQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52dv2jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:50:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NJ2RX6034526;
        Mon, 23 Oct 2023 20:50:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv534g0pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:50:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YswMQIbfYRCKKEW3pbgPV/MgZlSI//a8aWOiHirZH2WglBVj8Mg/Elz+XG1RYnhAYjOBje+bGGNmr1/4sqUKYgQdObBR8jGnd2T1bLBn1e9xc2De6TjzbkGSV0rMLFJOON6hCKdw2oEUOPltFnVkDSg3T3oFUkNxFXuOlBZqjtCd+P7iEsUD3gmXWzY/IM0E7rnfH7lcQ6JmCWp1ONqYV9kQcrgoN5fP2VXA+nuvvkwdxE2PoEnOe4bfphFVEwHCIp6wb4XECREIsRqWilrVI5gj3X8IDzISUXhuXf40lRipyotBHxhqJvaQ3/MgdxqUwD+aV7+iSXqIwwqza4/hVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jr5xYdxdC8g84TXrmiqABvwVqXntNY851QVp5dt9d7g=;
 b=GOHhqtQlhzyRiwvYP90PhyZZxjUXVc1ctMsqDJSse9d4wnHv7Tg+TdxBqabtUQRksjURxLTUtbLejd5fC6ufZ/V6SHbyaGXupe73uMmWn4+W0HEuf/rokjwV0Avqf6A6YrhLof5uBgyck1IYZMK0qfr1tKO4qcxKGKnl3g7Gh5T92fefsukAR/MevtxrFwL695LnmJxUSLoau05TxRAHdvQlcnOf5dhbYe6q6bULaAMEWdxu/3qY7hUbLjmmrJI3i3NpjGp1HjB40YMt40/iVY30k7hR9afyyKuFlpK+n1nVCGJ5k8vjK2TRy5MfhCsThcik5pm+IsCao63YBUvStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jr5xYdxdC8g84TXrmiqABvwVqXntNY851QVp5dt9d7g=;
 b=Dhi474hdaMJCDU0gUTYRZ+8fvxO2wrkxB2B62Wtwma3pTXnUBn5+2/hhUy31NG7MK/APC+y0XAPLNou+kJVXm9Ks6FnSAlWSawkRfGy7Xo01ouazpjKvFJ0CFlKliKLDtLYx7CNRd/9NdG8hUkE+a1H7cEKTVRnZqkm+07VIqtI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 20:50:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 20:50:16 +0000
Message-ID: <455beefa-9b1c-427a-a33f-a64f8e764f8e@oracle.com>
Date:   Mon, 23 Oct 2023 21:50:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
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
 <20231020222804.21850-17-joao.m.martins@oracle.com>
 <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
 <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
 <ZTbZiKhkrSaxpqNU@Asurada-Nvidia>
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTbZiKhkrSaxpqNU@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34a::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 85029c9b-8b86-4661-d43e-08dbd409a94e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22qKJiGyvSk2Lb3Dd7OnlNA1niZGb12c4zDz3FdHnm6gMeRoqkkN44VLUyC5sRFvYYNApig/iXakdHmasMzU9KklpygFUTkVSmN71DMMMVsveGrO8/N3zNkplVksugEU2aTCglMkCBu2Xt9HRxKJFhsQFhH8Y2JzNJNcAC6zAZbYwYBdUPoAClJa5X1gQpb+j8ODn/Rpey8E1qfUrbdi6CTDmtZTwA6DZc8SZdD7VJUe7NI7SgMXHVRUXmqr3JMkUwj8iRG/Dk6Tup8XhYw3cmAgMWTf4u+Eu4odhRoSzcvpz5GUbx32T0yd/kiW6pF8sbL/e6/Fh6cPOBbElACUGIvplsQIsJO2VssyMV3H+KLgGIOKtqm6Qtqg4f73j8oG54Ry9GwvziZy6MUIiFwiolgymgREUoURONx53tZvCqNcpsF2KZlNWlDfMxkqQt2U/vHznox3YK1k1Y8AOus+G3pKx9sWELB5I6PSUxRApapFixXXHkm6f0uplSvAFXTjgMxy9bq2ZsnUnjTWjjFZj41SFlIoYRPLtnfAu3PqZwqDiFt/15Tl/9e90uNdBJXlb1JAjHSamDWhEhh78tniyl2lJpxDpsAMrlTSxYxlRfwZCOI7ZrV/AaR1dSILcP7U0DQJwANiq3xplq/MjDvNnMsNROAvZj+8GhtIBNFDh4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(396003)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(31686004)(83380400001)(7416002)(2906002)(8936002)(36756003)(8676002)(4326008)(53546011)(38100700002)(2616005)(26005)(6666004)(6506007)(5660300002)(6916009)(31696002)(316002)(6486002)(6512007)(478600001)(66946007)(86362001)(41300700001)(66476007)(54906003)(66556008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGtFOC9HT00xbXpVQ2wrMXJ0M0tZdnBRVXF0Tk9ocHovcFhYVTA5cC9Sa0M5?=
 =?utf-8?B?TmpOVnFsNXMrb1pxRDVDbGV6cEdpRDdKN09hSWh2N1dvZnMzT0NVenlpNVd1?=
 =?utf-8?B?eVJLZ25YOG5VR3ZlK3hwT2pNNGxYV0c5U2RvUDltZXpXOVlQWlFFeTNyM05l?=
 =?utf-8?B?RGd2SlVISVFkNHk5RjZMdVQ2ajZnK1lkZkZPV0doSk1pMko5eUd1dktpZXY5?=
 =?utf-8?B?U3dvY3hhN1ZsYzlCMkZZbUNQSWJZejRwTnJTTTJ3R0hMbjJHbXhiRVJUVHY5?=
 =?utf-8?B?RWl5Qk1DZDVSZ0xRWmxINS9HS1I0b2c4NmR0YlIzYTFFSjUyVmR3SG0xdU9T?=
 =?utf-8?B?WEZYVkp4czMyQTI4UG5DbEwwdVpJNFlob2JJbURWckhVbng1RDJ5SnpLaElD?=
 =?utf-8?B?UlpFdEdGS0owRzM4N3FuQ0tDbUxmNnJGOWdJdlE4aVZCektMOEhkdTJib2xi?=
 =?utf-8?B?UlAxOG1aTjRHbDhhd29zeUFnN3dqNE9HQXFxejlTaUdvYlZjV1NxK2FXcUo2?=
 =?utf-8?B?Unk4V2ZZVDhMbDBpK2hlVVpPRkJNYUVyM0llcnZ6YWR4d3ZFTWxtczBiQ1Jy?=
 =?utf-8?B?SXZqTWd2eFU0RWVzZ1NtWmVTSTQvZ2dxUWcwWEhYUnZadnZkWkpaaU9lZmFE?=
 =?utf-8?B?TXdDUWNtNnlnaVI1V2dMUUlBODd6NDRIS0R1ZU5rYUhkNDRTRTFDQVl6YWFq?=
 =?utf-8?B?cU0xT1dUUENSN3RURkk2dlVuUHdSTit1Q1hWZ2tvZER4Ulh0L25uckJ1OFg3?=
 =?utf-8?B?eXFRWmpWY3RuQXNKNk5mOFVodGxoRGMvay85OFZoTHd0Tzc1NUZnL2p1eGdY?=
 =?utf-8?B?cHFNUkFGU3hyNHVqU2Z2VGVSSElXSEVEOFp4MGR5MFVzRTB6Y2VmcitBOFlm?=
 =?utf-8?B?MmxJbDZGNy9lalBlM3UxWnZrS2ZwOXp1RXp0OG1xdHdkN3I2d1JmdzN1R2M3?=
 =?utf-8?B?Um84WDkwb0pCRk5oZm11RGk0QTlUcVVlR3J6NjVEWGpOdEFwS09tN0htTzBF?=
 =?utf-8?B?cENlQVVwTWZuTHNDck9lR1BKSWI3cjRkeEI2TXBwOWFCTUsydjJvakowaVVV?=
 =?utf-8?B?ZllWRTNDdEpISTI4clNMVkNobTJCRndMVGZsVGoyanhDSGVWeEtsZldpbWRo?=
 =?utf-8?B?cGNxV1lDRVc5RHJpSGY3VDhOZEw0NG4yK25rSDhNS1lzTS9jS2V3N2dBZ2h1?=
 =?utf-8?B?Z3Q5T3NVUmE2UDlGMTJhZ250dUtCTUxwK2QrTmdMRmN6VmJvR0g3ZVN5cldK?=
 =?utf-8?B?blZUcWU0UzRYWTVRU3pwQk1kSWsrUkRMMlRHNHZLcFBrRVk1YmVPMmtDajZH?=
 =?utf-8?B?ODFHV2NGbE43MXNYb3lCYUovMnRVajNFay81YVV0SWNORjdkOGlZWjZzbUtq?=
 =?utf-8?B?bFRteUhTdVE2UHRsY05vZHNQWmlEUFZ0TWtJWW1aUzA0cmhTQm9neHIvOEJY?=
 =?utf-8?B?cWZuYXR0Y2dmUERIY3NHN2J1TisrYWRiY1E4Y2xPTjZzYXprR1JGblNWT2sz?=
 =?utf-8?B?NnViSzA4SVRRY0xjNGl1QU1CNGQvc1F3bER3aEY0TXV4Mk1PK21EaE8xLzRV?=
 =?utf-8?B?RS9ZSHZlZ0xLekdIdmJHbTJ1TzZMaWFMSDhmQVowUm85aC9qdm1LREUyem9U?=
 =?utf-8?B?U3ZWWlVvczR1a2oxOUJrSnp2ZER0SmFISUltRWpWbk93QnViRGJHUGc1NXZa?=
 =?utf-8?B?Z1hnaVlteXFxZFN4Rk9NUUlyRkNERTJuNERWWnBTZjhIVFoyamdSZFk4K2Ri?=
 =?utf-8?B?RUFCNzBMMzZ1ZHJSdjVoV1NGSHpCODdlVFdUazl4NXJHTVVlQkNFYmpqVnYv?=
 =?utf-8?B?b3YrZlhqRjl6ZDVnRmtxWWtnYTY5SWwwY0FZQlVIbkNTTDhaK1hTb3JTcGJP?=
 =?utf-8?B?ZWM5ZGZDdmRoRGkvcWtvMVZxcnRGa0thNHJJeGVTa1JjT3djUStaYWdncFk3?=
 =?utf-8?B?MUgxS09EKyt3aFd1d00yVkRQb0N3MkE5OWI1SEtVWE5WNCtEM2REdXNsSERq?=
 =?utf-8?B?S1h2dkxneS9UdEVxUmxUdUozOVJsRWJvNGtnZXh2M0NpVDh4S2RxakdVKzhu?=
 =?utf-8?B?THhXQTJLbUl1ZEMzUEtWKzBRR1FEWFBnUG91a0ZNeVdKeWQ2Y0Q4ckJQZ2l6?=
 =?utf-8?B?WGJrOU9SS2VZQUdJYzBmeHZJNnZ0ZUh0WFA1ZEl0N3VxaVNyS04wWEJMRUlz?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bkhoakh4bDJid21VNWYrN1dkcTdVQ3lVbXFtMVhTcVVOM0k1a2UxYzgrS1NP?=
 =?utf-8?B?cGlicklrTWFETFVncDgzZDlud2ZZSllsWlBwR1liZm5qaDdzdTlDRGVpYm1i?=
 =?utf-8?B?RHJmOTJncWdiR240NUt0L0Q3dW1IUTMzQ2ozQ0xZZDlYN0E2b3RzZkNHTUJt?=
 =?utf-8?B?YUdnYWxBdzVWRzdBa0plenpUcE1aeDE2MUZCTStVMUMxTit0WVVJM0R5Tnlv?=
 =?utf-8?B?dWFEOXRFdTNrc285Ykg0a3U5Q1ZZQUpRbzl3ZUxZUzB3cGRFNHJHR05oRFFE?=
 =?utf-8?B?bHlwd0Z6S09LY1lDUkF6c2p1cGRNY2tzVXFxM2ZBUlRyQTROdlVDcmlSekpN?=
 =?utf-8?B?eWFTUk9ZVTZ2em5INkpIU2x5YmNDdDJRNGI2MmFadXprd04vQ0JVVzlvaklB?=
 =?utf-8?B?VnZva0o1aW1nR21XL1VReWphbi9URktheVRkaExlYXFZMHFWaytuaUJFMXNw?=
 =?utf-8?B?a2JsU2NiL3EvUGs5RHdzQUxuWWs2UmNPNkJnRmVSY3kybGJUNHh3bzcvUlNX?=
 =?utf-8?B?Y3dBcE9rNlN2NmQrSUFNZ3RqWlByWklmellDblRpTFdIMXAzN0RSQlhYQ1Rr?=
 =?utf-8?B?QlhXTXg0QVdTSVYrc2lZUWtMUEkvMjZLMWRWT3lBTnN0Y244bTgzSEEvaW9w?=
 =?utf-8?B?Nk9LZkVJWmtGL1Znb0VCOGk1aGlEWm43SXQ3SVZRVGNjYmJmbDM4K0Qra0pC?=
 =?utf-8?B?TlFXMFppRUhmckc3QTVZdHFHMHlhdnNzY0Z1d3BSeit1Ylo0UE1sajdKcDVV?=
 =?utf-8?B?QUNNVXB4SGp3eFZnbWk4RnZEUXQzanZxZVlNVjB5V21YQ29RbjZzOHNLZXRY?=
 =?utf-8?B?UmdaTmhUeXB0NUFxRzFmVC9GMHlTaWdNdEFxak9yMEtzWWpSamVqYnYxL3Qy?=
 =?utf-8?B?ZkJrTzVLM2k0VnNiWTVMWHNrbzJRa2kwSlRvWVNucklFSmo5VHVybURDWG5E?=
 =?utf-8?B?RlVpdWdTc0ZRM2N4aVMweEVwVFBuZTlVRHZCbFNNbytUbE43S29Ob0E0bU9t?=
 =?utf-8?B?b3JoZHpBQkNtZHZ6aDNuam9qNmM2elozVEh5SlhXMjErdEtBMU5xSXFkWkRt?=
 =?utf-8?B?VElqUmc2cEdaVFI1dnlqKzVWWVpoV1J1cEpRRWg0SVB0UFJ1SjNWbm5TZStI?=
 =?utf-8?B?ZitmTjVLbUF4czV3bExVcGhVSU5RU2hYcUtXZ3VaTFhRcVhYZ1ozQ0ROVlR5?=
 =?utf-8?B?NW16aHIwQmI0RTNYZmNsaXJCa3ZWeVdRY3l1ckIrN3RYTWcweXJtcTFZS2lm?=
 =?utf-8?B?aXNpZmQ5MHpqdzRobEIwUGE2NGFPVUpsWEJOeXVTQVBvRlVhTFNrb2xjVWhM?=
 =?utf-8?B?bndZVlZTUmZ5Wk5ORnZRU1hFM3FlT21CUTZ3VkZpNnY5S0FjS3c4OHorbitj?=
 =?utf-8?B?NmtKcWc2OTRtMnpkSFlqczR1RlhRZnNndmVqMzFqZ3BlbHFTdldraFNZWkU5?=
 =?utf-8?Q?OMcPFQd0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85029c9b-8b86-4661-d43e-08dbd409a94e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 20:50:16.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooeBtIPgxy0HH0eJOQ4ptl6tMmYaR56VRhQRzl+BNBNhmJTE2maqaigDw2SQl0ak1jS49+m7WOqYmV7PmaszUNMFY7Kx3H9UWcaSiOP16Dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_20,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230183
X-Proofpoint-ORIG-GUID: UaRTBptKK4AI_gJsApfeOz0bV0sD5a7T
X-Proofpoint-GUID: UaRTBptKK4AI_gJsApfeOz0bV0sD5a7T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/10/2023 21:37, Nicolin Chen wrote:
> On Mon, Oct 23, 2023 at 09:15:32PM +0100, Joao Martins wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 23/10/2023 21:08, Nicolin Chen wrote:
>>> On Fri, Oct 20, 2023 at 11:28:02PM +0100, Joao Martins wrote:
>>>
>>>> +static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
>>>> +                             unsigned int mockpt_id, unsigned long iova,
>>>> +                             size_t length, unsigned long page_size,
>>>> +                             void __user *uptr, u32 flags)
>>>> +{
>>>> +       unsigned long i, max = length / page_size;
>>>> +       struct iommu_test_cmd *cmd = ucmd->cmd;
>>>> +       struct iommufd_hw_pagetable *hwpt;
>>>> +       struct mock_iommu_domain *mock;
>>>> +       int rc, count = 0;
>>>> +
>>>> +       if (iova % page_size || length % page_size ||
>>>> +           (uintptr_t)uptr % page_size)
>>>> +               return -EINVAL;
>>>> +
>>>> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
>>>> +       if (IS_ERR(hwpt))
>>>> +               return PTR_ERR(hwpt);
>>>> +
>>>> +       if (!(mock->flags & MOCK_DIRTY_TRACK)) {
>>>> +               rc = -EINVAL;
>>>> +               goto out_put;
>>>> +       }
>>>> +
>>>> +       for (i = 0; i < max; i++) {
>>>> +               unsigned long cur = iova + i * page_size;
>>>> +               void *ent, *old;
>>>> +
>>>> +               if (!test_bit(i, (unsigned long *) uptr))
>>>> +                       continue;
>>>
>>> Is it okay to test_bit on a user pointer/page? Should we call
>>> get_user_pages or so?
>>>
>> Arggh, let me fix that.
>>
>> This is where it is failing the selftest for you?
>>
>> If so, I should paste a snippet for you to test.
> 
> Yea, the crash seems to be caused by this. Possibly some memory
> debugging feature that I turned on caught this?
> 
> I tried a test fix and the crash is gone (attaching at EOM).
> 
> However, I still see other failures:
> # #  RUN           iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap ...
> # # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (32768) == out_dirty (13648)
> # # get_dirty_bitmap: Test terminated by assertion
> # #          FAIL  iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
> # not ok 147 iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.enforce_dirty ...
> # #            OK  iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
> # ok 148 iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking ...
> # #            OK  iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
> # ok 149 iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability ...
> # #            OK  iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
> # ok 150 iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap ...
> # # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (65536) == out_dirty (8923)
> 
> 
> Maybe page_size isn't the right size?
> 

You are probably just not copying it right.

The bitmap APIs treat the pointer as one big array of ulongs and set the right
word of it, so your copy_from_user needs to make sure it is copying from the
right offset.

Given that the tests (of different sizes) exercise the boundaries of the bitmap
it eventually exposes. The 256M specifically it could be that I an testing the 2
PAGE_SIZE bitmap, that I offset on purpose (as part of the test).

Let me play with it in the meantime and I will paste an diff based on yours.

Thanks a lot for digging it through

> -------------attaching copy_from_user------------
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 8a2c7df85441..daa198809d61 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1103,8 +1103,9 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>  	struct iommufd_hw_pagetable *hwpt;
>  	struct mock_iommu_domain *mock;
>  	int rc, count = 0;
> +	void *tmp;
>  
> -	if (iova % page_size || length % page_size ||
> +	if (iova % page_size || length % page_size || !uptr ||
>  	    (uintptr_t)uptr % page_size)
>  		return -EINVAL;
>  
> @@ -1117,11 +1118,22 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>  		goto out_put;
>  	}
>  
> +	tmp = kvzalloc(page_size, GFP_KERNEL_ACCOUNT);
> +	if (!tmp) {
> +		rc = -ENOMEM;
> +		goto out_put;
> +	}
> +
>  	for (i = 0; i < max; i++) {
>  		unsigned long cur = iova + i * page_size;
>  		void *ent, *old;
>  
> -		if (!test_bit(i, (unsigned long *)uptr))
> +		if (copy_from_user(tmp, uptr, page_size)) {
> +			rc = -EFAULT;
> +			goto out_free;
> +		}
> +
> +		if (!test_bit(i, (unsigned long *)tmp))
>  			continue;
>  
>  		ent = xa_load(&mock->pfns, cur / page_size);
> @@ -1138,6 +1150,8 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>  
>  	cmd->dirty.out_nr_dirty = count;
>  	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_free:
> +	kvfree(tmp);
>  out_put:
>  	iommufd_put_object(&hwpt->obj);
>  	return rc;
