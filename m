Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971C07D36F7
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjJWMiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjJWMh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:37:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398B5C4;
        Mon, 23 Oct 2023 05:37:57 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39N6jEdv029477;
        Mon, 23 Oct 2023 12:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SutCKSUKb4a7zAKknirFkzaw/kGUiByJdpq7UZTt4kA=;
 b=Jd+Oe3f9rTbXBL6v1Mx2aea3SpMp1cy0yz6r6EPutqOqvmojkPGJlCjAbyHHOFBNnjD5
 a20wCZCgsOv5kpc3SXGq0VLw6pk+T0ly+B87Bv0DVFfCrih+0Yt3tU41B4KQurLBmnE7
 cUoy2ja7d0PuGvdMxiJx6aKE8y6IBHdR8TUmp7+p/u8//eHpRuuj+Uj+vRazQ01CWqpp
 1/xuYbXopvWojYfq4AmzOVyCjxbL9A2NMYYFjnbyjO1S9Y7dTzW01p952boAVF8SwdTq
 4NEUnue6c7Fbk9MSlapJzL3lBAapHdVuoCq67oR7S/7Uo1U02gXll74gVrFfdQ/VD3LE MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv5jbb0wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 12:37:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NBGph2014087;
        Mon, 23 Oct 2023 12:37:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tvbfh5ygu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 12:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7PW5pUQk/UjE3O3QA7xkSvqNWfjjmRJGFimV0nxgcQQedh7Gw/xqORrsISjWdVnailB2mozb2ystlGRz6FmCaFwm+x/7H/PLuK7U/xYsaOlvwBP1Nik1GGaOshz8eyLqI4vg6MgxZAvgebUxpNeGqT7WzBn56B/T5uURwSm+d7Z5R+qjxosAgtqejJ6nH1obyqfiN7rvcOUFtz0CkOMXhvLP9GGHfk4STMAKDLuKNt7zqhLaEFCz0d0Jli4q2rpqyl/N+WZefIBghKW9jYqPbgVnm31R4wWr8XJjDLigLuCYU8H1r67pV5nMQ16r8QxHRTc0rodZVqITc5XrPa5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SutCKSUKb4a7zAKknirFkzaw/kGUiByJdpq7UZTt4kA=;
 b=Y2fvoixcEfia1Igsq8MMCq+9Uf5sgazSztFz3ehKNzwAywRO+1H9h+oAWxTljLh3sCyxk4uZdS+2i+gRar2RS9HzZoUMHImidH0zdi3JkF8cXDaALWFdobFWkKXSxcNvKhjF69daPlvQjXtsDYEpxWKurmyDO6KHvlhjavIKM4Si0HndczqY5PIoD8rKmhqY3fcsR+G+MM/ex7CpHmVvlc29dNU1KzfwtrlgRNvzOdSn50PO7MzLAzsiLteUWxJIRhylF+4Fw0DuUa6zvqLBLbyfnZvOqiFoeHUtBg69iHci7WJHFoKjeWjnJy5Ef56yesrWugG9r/nXWR+ADMauQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SutCKSUKb4a7zAKknirFkzaw/kGUiByJdpq7UZTt4kA=;
 b=EUtyHM2TsNbuVo93Wmz8Qvs7c4GQpEG5c+wH3GUaDxcNLIP8XYPAh1dP8eNhYsGRJmdINhlkimfHmQ9LI2kVVagXXaJE8cCgbWOSbPKzzajyGFYf8bcVQiLokSNgV3TUI+swJVluNnDSfyne5Qf6STmBmlvamkxynfFwoK722ig=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 12:37:33 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 12:37:33 +0000
Message-ID: <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
Date:   Mon, 23 Oct 2023 13:37:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Arnd Bergmann <arnd@kernel.org>
Cc:     Kevin Tian <kevin.tian@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231023120418.GH691768@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0369.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c68f35-8f59-4fa0-4783-08dbd3c4d418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgB8EHtYHUj1vouTwjMhOmSkKTzHeDsc6hCXNzgdxHz79buRVDN9LghWSzTd0eON3+K6b5g0pW0ZzM2ob12d1iU0r7gWrQc0mYiWD07ZXGQZAdAwqyRNVZJV8+cGqMMY09a7tmYQnaw0NwchXsolb+I1TutWiC8/K+mOfIdt/uLioLWIWbSxHk98HNAU5VxS7E3HHubDw9ZHn9ercVrA4uRuxM8gGSxVZ0hjHdw+xZhIE7MCUM3Ab0kZzctOQXc2Ug/Y49H5VjM+MVoAObDare0uLp0mF8fOGPTu1zlWmB34zrLYc1B2ieNS8MxSNQmSkxMAGwt8m6hX4zBw26W22jH5ymCXdO3VHb+AAWUXcXALYtpS26kIOmZhF3sHyzve3zgoNKE6gY7D6ZiYiOEKCFK4ZAkojuv/2Gz7cEoDcMekjEaNu8NhcBmD721laiAWN04IlzY2PkPRj7ywfnDiLxKdIH5lE71unMUo+zWmQrt+wmsRkEOZYOu31ZxVD1kmYzTiKUvuWpty9ML9TlzUGFxqePwnmGU+8SkiHONbp2y+TlLeQOQOkCHyv5UcC6x6OFedGDLZHUzvUSy3VEBl6dND6VVx2w4n6V2i3TWY7cYhwzcx8/yH4VrQbGlurZGXMv0iQvGc5AwObfDm/m2seA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(346002)(366004)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(2906002)(41300700001)(86362001)(7416002)(31696002)(5660300002)(36756003)(8676002)(8936002)(4326008)(2616005)(6506007)(478600001)(26005)(110136005)(38100700002)(66556008)(316002)(54906003)(66476007)(66946007)(83380400001)(6512007)(6486002)(6666004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk9wVndyVlVpaW5Ha2JhNzNJTENzdjBDYmQwWE9oV1ZpZU9uRWxSUXZvWWVV?=
 =?utf-8?B?RnNGMVJMRnArY202MFNaeDVkUXY0WVNXbG5qc0VPUFc3NUg0Q2RZUjZ2ZzV4?=
 =?utf-8?B?R2s4Q0R0NWxWNGp1dnBUR3lqR3NHbm1NbjZLbzI0NHdoMGNaRUJMNmNRNkNm?=
 =?utf-8?B?TUt5ZCt4QmxyS3g5NUJyeitxR2p6bTluSUd4NWVPYkNzazN0UmZ0NHMrMDdm?=
 =?utf-8?B?K055ZmYyMVBUanJ6MHh1VkxBL3lhV0paTHduNzBzTmg1SkJadEdGYlJuSUlZ?=
 =?utf-8?B?U05ZT3ZqL1BjTW9jMGFweWY2enZqTS9OQzVJSGxVL1UwOVFTUmxXN1dxVHNT?=
 =?utf-8?B?YlVZcHU3VFNncTQyVDBubHQ2ZWtHYTk4TWt2bDFCMndMb1Q1T3VoNjUydFFr?=
 =?utf-8?B?bWVpRkQzN09rOHN2eE02Qkg1ZlRZblV4TWZDcyt1MTd4Vm1aRVZhbmJ0ams1?=
 =?utf-8?B?NkQzaHZIekxET1IySU9qNWNwZ1ViK1ZKRGRPR3EvU3I5WnJzcDlXWTNDaXVH?=
 =?utf-8?B?ZHpWMUFzS2NxUVJQMFI5ei9NcjcvMnNIanNTaGVoTnBvRFdyTStOWkgyU0RV?=
 =?utf-8?B?eUhoZUZoQ2FuczZUVEJ3K3RPNy9BMkR4clMrcVM3OUQrMG5rQlJKbXl5TjRR?=
 =?utf-8?B?clp5RjljbjliaHRta0ZxUlRlVW5tdjFac1BOUnB4OXI0MnprU0NBTU0xRE9L?=
 =?utf-8?B?cnBWbTd3b0djK1hiRmZJNHNNbmFMRmNpTytzVkRwMlRURzVjc1FFckJlRVVt?=
 =?utf-8?B?Qkg1eTQrZ3p5UmVReUZpbldHazZMK0NLZHozZWVCcmNXak16SUxpeEVuNG15?=
 =?utf-8?B?SjJvMU5nY0VGMUl6Y2ZMYUNPclV1bWNtMGdidEx1ZGxzckEycDhlMkdQbGlI?=
 =?utf-8?B?ZWtzOE52bzVIT05zZEQwYWNBdkJqWHdPTXNmODdNMnRYYUxQMU5MRkhONENo?=
 =?utf-8?B?MnM3L0FzZ05xT3hMaE9Qd0Y0TFRsQ3ZpV1BBUWluenJTVTJMTUNxRjREZzRT?=
 =?utf-8?B?ZVBEb1I4Z3dzbUVzdCtNR1lLRS9VRWxHcEhDNWtqSHNWa2svQUtUQmZZb1lz?=
 =?utf-8?B?K2duTmhXZ1Jlc09VdjE2bnBsRm9TQWkwanpQbHM3V0FJQzZTRkt0SkJxTDdS?=
 =?utf-8?B?d29rZzZXTXAzbk0rS2FUc2Z3WFN3cGwwZVppekdSV2EvcnZwaFpzSXM0b0hx?=
 =?utf-8?B?QWZHZGdNWnZqTE8rMWNrK2dzakpubkNjSFQ5RHRxOXZQUnFwSkRqNU1NVjZx?=
 =?utf-8?B?aGRjRmVWNUw4QVpyU3psNlhMOFM1OFg5TXh4and4TXA0SlZ6Y05YUlVsYUVP?=
 =?utf-8?B?YUFVTnBlNkVvWmpYSzhHanJuMEhuVko1akN3MERORi8zUExSZmNBSVJSZGo3?=
 =?utf-8?B?bDJIa1NLZEpBZklrTVB5b3BPZ1ovNHZJZDB0bC9nN2Rrb29rQkdNb0xGVHND?=
 =?utf-8?B?SjlVWWUzdTYwZjZxRER6ZTY5OS96Y09ybVZEanZQUms5eHphSmNuM1BjaGVW?=
 =?utf-8?B?VGtvaXJHV29NaFpjNm90TWpydWQ5bTdzVitXd3VrQ00vSnVhdFFsNGcxa2I0?=
 =?utf-8?B?YVdCaXZPSDNzU3RSWmVyZFFZeDBxdGlIR01OTnNEM0lmYWJMZ1BqL0s0QVpR?=
 =?utf-8?B?RkJmN0prM2YydHN3b1krQVB4NTVFclhSK0RoTHI0VkRSRVVUdGpKYjhONDBS?=
 =?utf-8?B?cyszS1B5ZUM0OGYxV0NHZkRuK1hRYnFqbitzVFFON0FiQVl6OS95bFBudm5O?=
 =?utf-8?B?bmFCUTdFTkZ5aE5yVUhNRjBmdXBGUUpYSmhOcHBWbzQrcDFmL2w3QjJXeXN4?=
 =?utf-8?B?ZHVSaUlIQzBjaHdXTkFSZzZKMlgzcng2WmRnSEdaNzNQTE5Pd0R0RDFUNUxo?=
 =?utf-8?B?RjlVNzVnOGxjeWtVY0JES2I4SEVTK0lJM0tKRnpRd2dOODZXVjUxdE9KTU9V?=
 =?utf-8?B?VUxFT1VSMlpGaE9MeSsyeGk4Zy84ZmJ4RzRNYXpjb2xIWGN4b2txVmpDb3JW?=
 =?utf-8?B?cE5SYXh5OHFyZW9lcVNYVGdtcmJ5TEhLMGV2MHVPbEFUV3hacFJFNkJNbFIx?=
 =?utf-8?B?dzJnTUk3QlpyUXFiUks3UUwrTXpHWldwd0JEeDRsOHhwY3ZqTWJTYTNoVGUy?=
 =?utf-8?B?bFAyeStDSFN0ZkdZYzhFbm9iczF2ZTMxb3FDZzluZU9EOTkveWVBK0cvMGIz?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZlBPaG9JVVd4ZG9YSHBqdEdkeWQ2eGtuTDR2NU9SWk9wR2FwVUNGS2ZDS1Nj?=
 =?utf-8?B?aHJ5N3hTS0RKSFViYlIrdTNLUWs3cVRJZzdManV2aFhlRHVtRkRkM0VZeTJH?=
 =?utf-8?B?Z2Q0ejdxWTFTTUl5ZmZ1eHBlSEFucVRMd285M0dhWHhweXdqUnVMOXdXWVZa?=
 =?utf-8?B?Y0NaSGdSQS9ua29rVWxLS0YwVGxKU3NjQW1rbVRwUnRYUGhSRkMzbU5EWHRJ?=
 =?utf-8?B?czhzT3Bjdng4aE16VGV0VUc2NnVaZU5FNG1ETXRweDZJbmtIZUk5cThDYUtG?=
 =?utf-8?B?MDFpbWlnbGtJVmU4R3JCaHJMY3M0MHFkRGJ5Z2JkY3RGRE0xWWFINnZIdWpa?=
 =?utf-8?B?bjZtTmgzQWFTV3JVRVFGT2h5ZndFV1padVNhcVhtcDdGdDNHSElNWmtzQllK?=
 =?utf-8?B?T1NIV0xrandWVVRwc28zSDVtdmErL2lmMEtydmJlVHRQRGdvcHpsRDY5VjNk?=
 =?utf-8?B?czEwNTR1elNBV2VTNlNxd3JJS0FpQmdoMGY2OUYyQTRHWm93cmpiZ1lrSHZo?=
 =?utf-8?B?ZUZRbktNL2xGR3l1Y2hTQ2Z4akpCM1ZYOVZvYmFaM09sYktNeUM0a3dDUEJo?=
 =?utf-8?B?ZUtKdFVtN3lMTnNXcWcrYTVFNjFCRWNXT0lJV1ZZNXZCbGJmUWVTQVN0TjNR?=
 =?utf-8?B?VUFma0hYU0RiNG4rL1JZWDM0NDR6aUQ4VWIrZjNuWE5YSmdwTEtjYXhjTFh0?=
 =?utf-8?B?MHBFSGZEQTlJd1MzalJvS3RPc3QrRktDeGhmM2oxNk50MHZIZjhOV2l4N0hU?=
 =?utf-8?B?eHdEamREWFZvWHVNQ05ZSkVacVRZRDZjZ3NsdDN2bVA2V0dzTWJtYjF4dWVY?=
 =?utf-8?B?QUZidUVGRmpOM2w0R0FvZXUxWENiSmNXeUZNSW91M3lJNy9iNVdOb2J2RDQ0?=
 =?utf-8?B?ckl0d1NiV0pVQ1A5aFJDeVR1a3ZJSHBpa3FTOCtreVZaWG1Qd0hiUUFEbjU1?=
 =?utf-8?B?TURXRFllZDNFYWhRa3hBRTE5NWNKc2l3K2hxOUhuVmdCKzBCeVNOVWg0Q2FM?=
 =?utf-8?B?MG5HRVlKcGcyRS9xcW1GemVZM3ZvV2oyNXlia09rRVJmdFZHUGFIZmprSS9j?=
 =?utf-8?B?VDN0VWpibmRKWlQ2TythTVRVZDVQeDUrM3FVcjlDWitVMXFSMGx2aWFyZzZ2?=
 =?utf-8?B?eDZ4V2xWRjN1aXpvRktzb2xJRDZnRUMvWXRCYm8xRGhya0VCZkFRb0xwMFhK?=
 =?utf-8?B?OXZ0dTJkUnQ1dXdJTnkybis5dGlDVHBkRklCNDJGUnVudHQxcUtBdEorUWlv?=
 =?utf-8?B?czVUYW9QRnpELzNsUU5zQmEwSEpseVE5YTFPb0c1MFVtN3I4L3Qzc2dHRUo4?=
 =?utf-8?Q?fk3XfV1dWu3QQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c68f35-8f59-4fa0-4783-08dbd3c4d418
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 12:37:33.0401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+LIEuCTcvLJSxCvCr3DlvZvhAAwd9eZjVIASF2Jc4aAC+xn28nrKBeV0oSIKauaJTFtE2N+YRqDlS3RxL7u32xl4QSysgfZwJcIkKadYMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230110
X-Proofpoint-GUID: yevtW7KTwTcdvpYCKNB-aTqyKL-g_qmp
X-Proofpoint-ORIG-GUID: yevtW7KTwTcdvpYCKNB-aTqyKL-g_qmp
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 13:04, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 01:55:03PM +0200, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> Selecting IOMMUFD_DRIVER is not allowed if IOMMUs themselves are not supported:
>>
>> WARNING: unmet direct dependencies detected for IOMMUFD_DRIVER
>>   Depends on [n]: IOMMU_SUPPORT [=n]
>>   Selected by [m]:
>>   - MLX5_VFIO_PCI [=m] && VFIO [=y] && PCI [=y] && MMU [=y] && MLX5_CORE [=y]
>>
>> There is no actual build failure, only the warning.
>>
>> Make the 'select' conditional using the same logic that we have for
>> INTEL_IOMMU and AMD_IOMMU.
>>
>> Fixes: 33f6339534287 ("vfio: Move iova_bitmap into iommufd")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/vfio/pci/mlx5/Kconfig | 2 +-
>>  drivers/vfio/pci/pds/Kconfig  | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> But this isn't the logic this wants, it wants to turn on
> IOMMUFD_DRIVER if MLX5_VFIO_PCI is turned on.
> 

Right -- IOMMU drivers need really IOMMUFD (as its usage is driven by IOMMUFD),
whereby vfio pci drivers don't quite need the iommufd support, only the helper
code support, as the vfio UAPI drives VF own dirty tracking.

> I think it means IOMMUFD_DRIVER should be lifted out of the
> IOMMU_SUPPORT block somehow. I guess just move it into the top of
> drivers/iommu/Kconfig?

iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
moving it out from the iommufd kconfig out into iommu kconfig should fix it.
Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
I'll make the move in v6

	Joao
