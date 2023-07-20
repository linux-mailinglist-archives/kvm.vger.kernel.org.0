Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A235D75A30E
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjGTADx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 20:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjGTADw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 20:03:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65651FD2;
        Wed, 19 Jul 2023 17:03:50 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JFOLGD029551;
        Thu, 20 Jul 2023 00:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Kao42yPwRO82pjByDl/nyiRFwWQxjV8GJVsnt8uj3sg=;
 b=Lrc4pLQKTLknXDLSzghqRkcODkQITwmhL6/K/5DVNUdKbpa32do8TLm++udPQ+f4U9DW
 oglpMwZAoJHGoYRBJUoh1dUlGGQUgEVeodhJwslZVG1OKU1ds2BRHX9gFgKiLUOiIZui
 Hinnv0can+/1zazTYba12e9Jkfvlf0w0hzP2xufkTB01mhH1rLdwxV+VtDlOgTkXm234
 VaPxodweWS500+Da0PaH2g3Fnqqpb+WWBHwUqy5w3F3VxwMNQYNBB5LJD/+pqsIxnShl
 ETO5aTW98/c29c7xk55t5oTqVEE2+X5wc3eygeTDzDJWpovCaOqL9nPX84WXofz2Xfs/ wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88rqhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 00:03:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36JLUWYb000877;
        Thu, 20 Jul 2023 00:03:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw7qs1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 00:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3Ckdc67gasyhmnfVdjKPH3Rz68+ajLCou0HBMa0ugBWE8+PKQm8qk5jmFpOvpeov3v9KC2xW2RrfvY4R5bhng7EQ5UBGb+jfIpZwsxpyLnQrPREeOEu2gTXlBvX6jWkLruqAaQKRkd8DvH/NQsV+3NXEMonVp62q0jK4Rcw17YyU6IZI3VFC/zGDL4gflhgBa7PpsOxV92LCtHa/8Xj3Sr5NRjUjp/nX5UoZnrDcVn/m2PRoEM8EmplG9dzfGcvuKP05bhtYmgvZ8RFB5HKR8U2Bix8Bhrm/eq3/znd9DJ0tqbpTxvsvJC75OHMgKlOq4Yb91IsTBb3vJtPIdIdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kao42yPwRO82pjByDl/nyiRFwWQxjV8GJVsnt8uj3sg=;
 b=O7Ybf72Ibh1Yc1WOh3M/ry46+mqG6VShV2jk2xgbULLKb42h4VGuipJPGAjLmy9XoIHbxNl87vEP8qdgLFVdHCeRuKVld4BHE3MCQ2ErBLj0MLnHBWjFF6hPvAN6CAacb2+yk1DuEt7BeLy5asX9q64YT/jfQH5UzwSFc7vioEk/Lx2C1BVN3CoCAaFddZlGXepisqncJ7LMik+JBBcPBxCQrL6eKc+pCrCXV+ucCUfWBzZU+O0kuLdaFRAtPW5S/krguMmwE5yAXaR4hn62Xvg/Lci5SzqmeD2JuW9D+hc+sUlK/9bfaM9k2lVjC+lxSsL+ijX2Vp0hSmsHyP9jjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kao42yPwRO82pjByDl/nyiRFwWQxjV8GJVsnt8uj3sg=;
 b=iM7BGLWpWYE/MSu6bp4gfUAirsvy7dZF6IWPg2PJB+V5UM3j+MjPU1Ia9GbwLwqD2p+K1FIV9xmER79zNcgdV472b8qJ4jTIE1Sm71yRk4KNeaaUuz4AUqfUvhDhCPAXitDW15qo273OoIKEen8VJUVmuuCallbXkjeeWG9tw9s=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by DS0PR10MB7903.namprd10.prod.outlook.com (2603:10b6:8:1ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Thu, 20 Jul
 2023 00:03:40 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::a11b:61fb:cdea:424a]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::a11b:61fb:cdea:424a%5]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 00:03:39 +0000
Message-ID: <bf2164a9-1dfd-14d9-be2a-8bb7620a0619@oracle.com>
Date:   Wed, 19 Jul 2023 17:03:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eugenio Perez Martin <eperezma@redhat.com>
References: <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
 <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
 <eff34828-545b-956b-f400-89b585706fe4@amd.com>
 <20230706020603-mutt-send-email-mst@kernel.org>
 <1fdf73cb-f23e-0c34-f95f-f1bac74332da@oracle.com>
 <20230719182112-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230719182112-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::18) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|DS0PR10MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 2755c219-f30c-43e7-b671-08db88b4c5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4PnK8M9lEPYzWPoAXKo8DE0JBFUBHdtkQrbS+7QxZWkJz3UKHD8qxyavEhsdNn/0yn7RnqteOycojnWv+5I1mh6bgqtU41KahHxZx5QQdb2cIlYliHdpSlic454GQKAky2T1pATqK8IHJ9H+KM1vQl3VimKG7MAOqcV3s7MEsNWhBYdyLmYAYGw+/THuIHJzIfnQ00wjUHKjRLF5gwQP7UdveC0zBgiCHu2LqOUpkI1skhDyb0CQteTjiyjAjfTGdRQ8qq2oZSIGLeDbX8tSfEW4pYc6LDYcAOAjP0VEFMQqjkm0ZP20o6RpmAs4cBDT41kk22AKrp0DjQVXhgx5JWy72/Qhp6QAQ92Fe5IFCzuUdSMmPLETUa6tcBn6VlkSODIgrp8Uf0VgLYkGDoflB00d3D/b5Q0M4a+JeZgpkgdA1HpOdFk5KRiz2LDpLmoSPFBxK9m6cJemwbF3/KUQIh3w5YicLcwTX1S1c7VTRTIwLExT69AWAEmO2MvEZ1lUvmjG6hAMrdrnz+/Kf22iLzq7YT4i1CYF6sdOQscIa+tsK8p0SWMfrT3BoNDxK1ikwqWmbjYDokIYNByVZFbtUA39q/Htu/LNaCh+zoWD86XfXLv6BubKF/pUi3dUIvpt1FdnKI4bWYNmS8Dd0JNvNPghvJFa+Lzi8KRn9YXKCdxlYXyYJ1zjNLg9pAQCyPK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(54906003)(478600001)(6506007)(53546011)(26005)(186003)(966005)(6486002)(6666004)(6512007)(66899021)(83380400001)(2616005)(36916002)(66574015)(86362001)(5660300002)(38100700002)(8936002)(8676002)(84970400001)(41300700001)(316002)(6916009)(4326008)(2906002)(31686004)(31696002)(36756003)(66556008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDRxK3R6djlFOXNrYkp2TW8wOVFZdFc2ZFRDSHR0SVZSa3ZNUGNWam1TTmg0?=
 =?utf-8?B?N0ZacUhudGduNHlDeWZ0WlJ1SXc4UTg4eHMwcWVoUlR6L2ZFSFpXKzkvRlFG?=
 =?utf-8?B?NlVqbFlLYU05SnNGTUNHR25QSEp0Z2RIb2ZTREJMUGZZa21CVG5VY2lJcDBu?=
 =?utf-8?B?MlVuTnJFejVFSjFKYUM5YytRTjh5NEwrellVSVIzQVhRSXgzRHhTMzdQU2NT?=
 =?utf-8?B?SWxiOEpYWVlEUzJWMlB4TVRYS3F4TGh5SnQxQ21lRWNidTl6SE9Cb2ZKdnRC?=
 =?utf-8?B?cGg0amJuRUhhUGZsaEFwckpRbkd1b0M3cXdKeC9CMy9oY2FNejhtNWNqL1Qr?=
 =?utf-8?B?cml5aXZlTlJQc0ROa1lYb0NMTXVsUFFrYlBiSEhoeXhCeUxKMER1YTIwTHZD?=
 =?utf-8?B?c0M2Snc5a3F4Q2hlOEV6TjVKMFRPbW9hWEMvQTAxaU85VkRseEE1L0o0b2R2?=
 =?utf-8?B?TGJZdm4yNWlxSDhaYlZPbml0bHMzS3Arbi80aFJ5ZFRsZnlHZjZLUmJVRW9C?=
 =?utf-8?B?T3lQaXJqR0dKT2xWMGNnRGtJMy85bWQ5emJCR1dBSDdhVGx5MmplQXhQT1Jr?=
 =?utf-8?B?ZkxKNGF1VC85MVdSTjVWMFdOWjNSUDNuNHJ6VVNMNU9vT0dWWk0yeG12czhK?=
 =?utf-8?B?Q1V3ZnRkTG05cnBMNEpGejJtY2U1SUN5a0tjOGFEeUsxczh2VU5vek00WVdZ?=
 =?utf-8?B?SjI4WkFvenFFNlJpSkRiS2ZramVPaTJmRkhMS2RVNGJDamt2STNKRHl2UzRK?=
 =?utf-8?B?VzFpL3FnS1UxaFFnN056UUlFTE1ieTNqc1M4aWR6b2JCbEJIYzBPY05KMHA2?=
 =?utf-8?B?Um9jSnRJdVI0bDFpWU9EbGpiNkdWd2VJbHp1VzEvY05yWFRBSkpidjhqTlNE?=
 =?utf-8?B?OGdicWo3RytwMGVPUWR0WG1CUHd2L1lxVzgvTlZXTWNLSzk3dHRBQnJmd0Zu?=
 =?utf-8?B?NW5qby9vMDEvRUNSZmtpR2ZrYllHRkRxWW5LNzI4cVR1Z0JJNlR3SHd4L1VE?=
 =?utf-8?B?c2tLMSthWG04Y3lTLzNmYWR1TXpleEwvejRZRFpaRk1XeUFXRTl1VUI4bkwx?=
 =?utf-8?B?TVVaZXpNS0pZZGRraFdHK2V6SHNLY0NTS25MT3MyaXVyN3FGT2NOWlZaUVBW?=
 =?utf-8?B?cnRZTXo1UVpldHBMaUtmbnFVOEU3N3V3QnBzR1dLcmY0Q3gxSFJnb2FackJ4?=
 =?utf-8?B?U3lDVk16MGNuR2o0aDJoVnY5UFp3WDRqTFRPYUYzeThRWXI5aE14TUlsNXkw?=
 =?utf-8?B?cGlFSkdkWmJxRGJuUEdaRUpRblllVy8xVmEveS9KcTYzUkNrdlgxUURMN1ph?=
 =?utf-8?B?MWRlYmN5LzczUnlMVlRoSU1kYWF2WWpJeCsvcDR0ZE5RckgwNzFkK3dyaXdM?=
 =?utf-8?B?VUhyKzM1Q2ZNMnFvWFUzY3R6R1RYRjVibzl5QnJNU0RhYXorZUNEYVVCd3FP?=
 =?utf-8?B?OFJpLzhKRkVIQjVCTVNZQ0lTZ2VYTjFRaUlYZEpRLzFrVHl6anF5NE55MGs0?=
 =?utf-8?B?ditxMS9wZFhsNVFieEpvVTVyOUVUU2VjUXVpU3lMdkt2SThiRkdvY21TS1lV?=
 =?utf-8?B?dFpVM216TFZuZGthaDBxaThXTGoveVFvZ1I0WEJUZXpCVWxkWU5BZnZJZmVo?=
 =?utf-8?B?M2xjU3ZiVTFPUkxrcmhzcSt2emxBSVluejZjeExMQ0tYaUxqcEcyRUZyVXl2?=
 =?utf-8?B?dWx1MGo2cTNlWmswTFVNdkpmUWc1UUp5dFZGOERsclZHd2p5NmZ2ajJjVmow?=
 =?utf-8?B?NkFjRzVSUUpacHIvZUROSkg5bGlVaHRlNHB6OVA4aDNaeHVMNlprWngvaFJZ?=
 =?utf-8?B?NEdzNXdUeWhXNDBVcVl1M0x6WktaeXB2SG1KNGRtd1lUVFBwN2pPZmNCcE5D?=
 =?utf-8?B?TzAxSVZCR2wwSjZvQWV5Y3JWNVpyanlCU0dEY25GNTJKR0pncjJ6SHkzbkdM?=
 =?utf-8?B?M2toZDhwd1A4aW1Nb2laQzVLNUoxdXdWUnVPVFhxeFQ1ekEzL0g4S1czOXBy?=
 =?utf-8?B?eFNsaGJadG5manptTGtzeEJmY3diSWE4VHFLY2h0QUVVTVprY0NJQzltL2ZE?=
 =?utf-8?B?R2MyY04wNnNwZXNhQ01ISnNPUUVqQ1FDWjFrbnlMUTgyN3JvdDVkMmNBSXpn?=
 =?utf-8?Q?6gj0bchScWImon/dPxY4jiD05?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U8l4XZEf6ThL46iKAQig9Y2nRmby0SbncHZsP/hWgozYS4HomqH5caPQkUE1AqXBH97TLNc8WCkb83ZT3C0Lp53CbA8uM5Da8YYnIWBPGhA6jzxzFWc72xksLRMF5rHHaykxuEvwtu38dF0jWALl6eZeVGyy/7x1vlAjX29ZUQ5GXckQ1R3/SSlsfAek3eE2L4+gU7+8evgqwq4rYMZHPJZ8QB1PfVIs7niTV3Naju4U5UiDnpuFyJwclKKaiHaZKxpi1+Ee14XnwJfDnqVmk494InEMMpl1wjpRYYw1XGkHOALj5Vvk/9aOTb9KgbbXNKCjMxAvCf+BIJI8W9fQa+2AbmMmq9yvmtUU0fWNzuxZLKa+njyhAPWClo4neZW/gm+y4ocqo7XyZ+DRPuRvw/YOSX9K0IN4lfKQVhVuqtGpUZUqJZoXvZF7ZuuP3CjuDc/P+IzQQI5TglMVDZUphdQZhSHYqK4PxkTdxRLYihWxkc8i+UApYvkvRcOyBpOiXg9Bdf3ez3d3XYI3wo6B49h7eQSNRcVcu6V95ldG0b9iqdE3/9rPP0NTb09MiyFyJIS+OzdVOFAoMfxI3hTidrbpo/UJZvXzG6aOwqOnaqNBTtQMwuCkkAuzf8/St4twJDkLGtyy5ux2vTJVo9+rnFuQvYEEymiEtI2jWTF1EYYrafgOMeY+8qNyT797rfaIw1+zX9SOc/ajsFFCKiipYhwQG9jFN3ovNoYIOyiSBlxStO7IYz4yMI2MN0yli7hj5uGuqPseq+lGu0krLkqSqhYFOpp9VRTZDXWZN0VySvrEFAX68zSRwkZItVrkYb1MZbyTn2ZQLAjvMZmj47yljzVGxT7JqeAq+6ewSJgQOC/sORZfK9C4VpYOp4zTJtn2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2755c219-f30c-43e7-b671-08db88b4c5c1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 00:03:39.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH/B6UP2J9mxuZTcICLgwIpWMkoEa1eaS65A88IFglQUnWRo/wLewLoYsXx75WEhbt23/5zzAiqM7i2mDVPuTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7903
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_16,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190217
X-Proofpoint-GUID: x0BhONA9AJ8V3S-Tzy2PzdwsRFkzrVCU
X-Proofpoint-ORIG-GUID: x0BhONA9AJ8V3S-Tzy2PzdwsRFkzrVCU
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/19/2023 3:26 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 19, 2023 at 03:20:03PM -0700, Si-Wei Liu wrote:
>>
>> On 7/5/2023 11:07 PM, Michael S. Tsirkin wrote:
>>> On Wed, Jul 05, 2023 at 05:07:11PM -0700, Shannon Nelson wrote:
>>>> On 7/5/23 11:27 AM, Eugenio Perez Martin wrote:
>>>>> On Wed, Jul 5, 2023 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On Tue, Jul 4, 2023 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>> On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
>>>>>>>> On Tue, Jul 4, 2023 at 12:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>>> On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
>>>>>>>>>> On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>>>>> On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
>>>>>>>>>>>> With the current code it is accepted as long as userland send it.
>>>>>>>>>>>>
>>>>>>>>>>>> Although userland should not set a feature flag that has not been
>>>>>>>>>>>> offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
>>>>>>>>>>>> complain for it.
>>>>>>>>>>>>
>>>>>>>>>>>> Since there is no specific reason for any parent to reject that backend
>>>>>>>>>>>> feature bit when it has been proposed, let's control it at vdpa frontend
>>>>>>>>>>>> level. Future patches may move this control to the parent driver.
>>>>>>>>>>>>
>>>>>>>>>>>> Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
>>>>>>>>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>>>>>> Please do send v3. And again, I don't want to send "after driver ok" hack
>>>>>>>>>>> upstream at all, I merged it in next just to give it some testing.
>>>>>>>>>>> We want RING_ACCESS_AFTER_KICK or some such.
>>>>>>>>>>>
>>>>>>>>>> Current devices do not support that semantic.
>>>>>>>>> Which devices specifically access the ring after DRIVER_OK but before
>>>>>>>>> a kick?
>>>> The PDS vdpa device can deal with a call to .set_vq_ready after DRIVER_OK is
>>>> set.  And I'm told that our VQ activity should start without a kick.
>>>>
>>>> Our vdpa device FW doesn't currently have support for VIRTIO_F_RING_RESET,
>>>> but I believe it could be added without too much trouble.
>>>>
>>>> sln
>>>>
>>> OK it seems clear at least in the current version pds needs
>>> VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK.
>>> However can we also code up the RING_RESET path as the default?
>> What's the rationale of making RING_RESET path the default? Noted this is on
>> a performance critical path (for live migration downtime), did we ever get
>> consensus from every or most hardware vendors that RING_RESET has lower cost
>> in terms of latency overall than ENABLE_AFTER_DRIVER_OK? I think (RING)RESET
>> in general falls on the slow path for hardware, while I assume either
>> RING_RESET or ENABLE_AFTER_DRIVER_OK doesn't matters much on software backed
>> vdpa e.g. vp_vdpa. Maybe should make ENABLE_AFTER_DRIVER_OK as the default?
>>
>> -Siwei
> Coming from the spec RING_RESET has clearer semantics.
Spec doesn't have clearer semantics on vdpa specifics - such as how does 
RING_RESET interoperate with ASID?
> As long as we support it it is not critical which one
> is the default though.
The point is vdpa vendor drivers may implement RING_RESET for a 
different purpose than live migration. In case they support both I don't 
see a reason why it has to fallback to a slower path given there's a 
faster path. May we should leave this to vendor driver to decide, but I 
am not sure.

-Siwei

>
>
>>> Then down the road vendors can choose what to do.
>>>
>>>
>>>
>>>
>>>
>>>>>>>> Previous versions of the QEMU LM series did a spurious kick to start
>>>>>>>> traffic at the LM destination [1]. When it was proposed, that spurious
>>>>>>>> kick was removed from the series because to check for descriptors
>>>>>>>> after driver_ok, even without a kick, was considered work of the
>>>>>>>> parent driver.
>>>>>>>>
>>>>>>>> I'm ok to go back to this spurious kick, but I'm not sure if the hw
>>>>>>>> will read the ring before the kick actually. I can ask.
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>>
>>>>>>>> [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html
>>>>>>> Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?
>>>>>> My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
>>>>>> sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
>>>>>>
>>>>>> But this reminds me one thing, as the thread is going too long, I
>>>>>> wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
>>>>>> supported?
>>>>>>
>>>>> The problem with that is that the device needs to support all
>>>>> RING_RESET, like to be able to change vq address etc after DRIVER_OK.
>>>>> Not all HW support it.
>>>>>
>>>>> We just need the subset of having the dataplane freezed until all CVQ
>>>>> commands have been consumed. I'm sure current vDPA code already
>>>>> supports it in some devices, like MLX and PSD.
>>>>>
>>>>> Thanks!
>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>>
>>>>>>>>>> My plan was to convert
>>>>>>>>>> it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
>>>>>>>>>> was not explicit enough.
>>>>>>>>>>
>>>>>>>>>> The only solution I can see to that is to trap & emulate in the vdpa
>>>>>>>>>> (parent?) driver, as talked in virtio-comment. But that complicates
>>>>>>>>>> the architecture:
>>>>>>>>>> * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
>>>>>>>>>> * Store vq enable state separately, at
>>>>>>>>>> vdpa->config->set_vq_ready(true), but not transmit that enable to hw
>>>>>>>>>> * Store the doorbell state separately, but do not configure it to the
>>>>>>>>>> device directly.
>>>>>>>>>>
>>>>>>>>>> But how to recover if the device cannot configure them at kick time,
>>>>>>>>>> for example?
>>>>>>>>>>
>>>>>>>>>> Maybe we can just fail if the parent driver does not support enabling
>>>>>>>>>> the vq after DRIVER_OK? That way no new feature flag is needed.
>>>>>>>>>>
>>>>>>>>>> Thanks!
>>>>>>>>>>
>>>>>>>>>>>> ---
>>>>>>>>>>>> Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
>>>>>>>>>>>> commit. Please let me know if I should send a v3 of [1] instead.
>>>>>>>>>>>>
>>>>>>>>>>>> [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
>>>>>>>>>>>> ---
>>>>>>>>>>>>     drivers/vhost/vdpa.c | 7 +++++--
>>>>>>>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>>>>>>>> index e1abf29fed5b..a7e554352351 100644
>>>>>>>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>>>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>>>>>>>> @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>>>>>>>>>>>     {
>>>>>>>>>>>>          struct vhost_vdpa *v = filep->private_data;
>>>>>>>>>>>>          struct vhost_dev *d = &v->vdev;
>>>>>>>>>>>> +     const struct vdpa_config_ops *ops = v->vdpa->config;
>>>>>>>>>>>>          void __user *argp = (void __user *)arg;
>>>>>>>>>>>>          u64 __user *featurep = argp;
>>>>>>>>>>>> -     u64 features;
>>>>>>>>>>>> +     u64 features, parent_features = 0;
>>>>>>>>>>>>          long r = 0;
>>>>>>>>>>>>
>>>>>>>>>>>>          if (cmd == VHOST_SET_BACKEND_FEATURES) {
>>>>>>>>>>>>                  if (copy_from_user(&features, featurep, sizeof(features)))
>>>>>>>>>>>>                          return -EFAULT;
>>>>>>>>>>>> +             if (ops->get_backend_features)
>>>>>>>>>>>> +                     parent_features = ops->get_backend_features(v->vdpa);
>>>>>>>>>>>>                  if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
>>>>>>>>>>>>                                   BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>>>>>>>>>>>>                                   BIT_ULL(VHOST_BACKEND_F_RESUME) |
>>>>>>>>>>>> -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
>>>>>>>>>>>> +                              parent_features))
>>>>>>>>>>>>                          return -EOPNOTSUPP;
>>>>>>>>>>>>                  if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>>>>>>>>>>>>                       !vhost_vdpa_can_suspend(v))
>>>>>>>>>>>> --
>>>>>>>>>>>> 2.39.3
>>> _______________________________________________
>>> Virtualization mailing list
>>> Virtualization@lists.linux-foundation.org
>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

