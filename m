Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7BD7B8D26
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbjJDTPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 15:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245300AbjJDTOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 15:14:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD32C1713;
        Wed,  4 Oct 2023 12:14:35 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ2LX016048;
        Wed, 4 Oct 2023 19:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pSFMXZNtUDp65v7+/eRLyJPjM6gi2hr3PNp3syZckQY=;
 b=N6yHir6cvl3xkn0PBBptNuXDfvIPLtSIkacOkW0UGGwoQqzW3QCpX3G0gb6rYQ0bljqn
 chjFu0MXGY0YZxya/WTNmWT7FuMhH7U+eMuKMakUMXL3w6M+Lhb/tVZGdgYjdSR/O/6z
 B90QPJ1YA1hx6nz00OHfjQPWoWznLR+jjFRxC5lBT+nIeAuuDb/4T9YItXHd2NM0R0qg
 XrXdpMc5PXjLtKj9sxpPGDN/ktKAfZgJlyK34EHGSPyydWBWTtxtGf6yMN4HPtq53pKE
 uP+53AB+AuWAnp2uJSkdWvwFVcNBiE1asLxNXUJxOUMAO/cnE3xGJegpFRXJt2+PmXjS TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcfx95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 19:13:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394Hx9jc009654;
        Wed, 4 Oct 2023 19:13:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3thcx5tyj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 19:13:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WstoOeJ9RSBDProLA+LevJsrVe0/Ov3Djriy8C3euYO38JK8S5oczMilofpSxZvKo4t9nqhTPgzgq+0G/14NW4BvrNVKIdASthJWpIkm94NO5bChB0/YHXZBbXatRFRPSVB5exB02B+dcaQeV77aLIG+QQIZVWmwHs+ZhJhD7fj7eoGwQmfxZ464ICKflTfZ8cAbZuBAFEt4hsxjlufbf5qCIzidtY1HFwRIMLwSmjBJRMExvuyeHm9tdGfZkLDWXKrk8b0W1+5CBPy+B794GrDi71zsjm24jDyz47jeXnTvI2Xw3ogKj5HTi3ruci/Epg3nkuSQxEn8EDqniVW7hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSFMXZNtUDp65v7+/eRLyJPjM6gi2hr3PNp3syZckQY=;
 b=XvFcF5cyy6aJA6BCIIuR6fW5xyqnBYMzu0xjYc026qw73RzY6r9akX8YKMUTMBmfk/5XOm98wQJjMlAzI9iNFTa5OhKZd7Bk0SzHPJ2Beb7f5aNn6V4F51XjD11IyBDwYFfsK+cL8TE6nzNI5oEzcCjlyEOcqGJ4I1/puWmsz0FhS5vn2FLriROD+vYoVqysTsJH2GjDlj92Ua9Qrgm1Kb2h68/U2So4OIkb1kXG3gAyof0joHn13Dc03oyUb3y5qJBnYq+V6WmpclD0l5eDuMK+kwiE22jL41i1bZRbuYExDFEvK1MhGqyjPv7yOqzhLaxrrWOMV/k00FuOB0jtYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSFMXZNtUDp65v7+/eRLyJPjM6gi2hr3PNp3syZckQY=;
 b=ItkLWpx5h6OAu3Z6Na6qmMqnN1aYKlC18X8SQu6RJnuUoBWmcqB0aKcKKidaspn//e+KpF3FpEAyFVt2br1MCr6yrfz0TF96iOhahkpImk4yFf0IdO9w0bZ1od2JV0rixQmbGMqYQqXY19ieSzITHWKniDKnlHiOqW1uvo4h/fE=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.34; Wed, 4 Oct
 2023 19:13:53 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.033; Wed, 4 Oct 2023
 19:13:53 +0000
Message-ID: <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
Date:   Wed, 4 Oct 2023 12:13:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
 <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com>
 <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com>
 <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZR2pwdZtO3WLCwjj@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::6) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO1PR10MB4577:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4dc938-30d5-43b6-9406-08dbc50e0c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMSx81VuM/UAx1JXrWT6spxcX+IPsT5W6A0whrJAZNUz0pI37Gd7HnmBq4CVo89Xa04rFkCA15Avh6SN9IBT86j5sFAiLlNfITQdtocrvWwc81ohShma5L7PgYZcEIEPcAup9CH93etfaRdv6PYONkKpt1vSGelcy26D8I0s0Bsj3aO4iLDr4SlduVsSrfr2Up++0gR7Y2Qy3jPryNyrMhzachzXSBXe3D5jXS7IFrProSHFZFjvnI6sU5K9IHcFMz+Cd5rizWEkLdG32Qb6RsVb5tctR6zY69ayIeT8ddPj6tqhhjsWFCwc/kZsIoAs7vIlGd4qIkAog0fGs4bJTd4DL8tmLNyRuoLQhOpXim6G3y1/BQocJ7O/izy+K2qQ0DZNwJJAj+78eNfOGCEpO52qvGKmf/og7a/9Fc2To2sxDOT64hMtHfXDNcTvmnWQnwm96FEjvjE+IG9+WRxYYxCvzsIpsbp1vH+0WO6Ob7HWFUKyr8K0a92eBHRuKbvo4W2R1Qw6FPuAfLmemzZOiTeDPjK3SNJVKNWI37HfNul1aBD6Dwb6E2StasZ2rH3dJasgX2bnOINHWGwsyD2i6hBKe/KV2d7tH/+PIRwjx6xtB6KfeHFb+4RHaPiDNZExgRxuQGlfM9CVndJfWUq8Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(396003)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(2906002)(44832011)(7416002)(5660300002)(8936002)(4326008)(8676002)(31686004)(15650500001)(30864003)(41300700001)(316002)(66476007)(66946007)(66556008)(110136005)(26005)(6666004)(36756003)(2616005)(6506007)(53546011)(6512007)(86362001)(38100700002)(83380400001)(31696002)(478600001)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXRoL3MvOEdReURHK0s1YkFKUFU2Q0ExRE4yTG9kb2xRQmxNb3RiNk5GQTVw?=
 =?utf-8?B?ZWJuZEpsRlB5R3VZKzZrMlY5em9kSDEvYTVSMnRUcUhCTGllYlUwWGUzNUt5?=
 =?utf-8?B?UFJnQ2tIZ1pkUVdDcUtsWXhtL1I4UTRLU0FRZHBWWWVzdS9NeGgyRkN5SDFT?=
 =?utf-8?B?OXV0RzliVjkwYlRFY0E3TE51MnlMVllnLyszdjlCN21vUjg4VUg3enpHNmFC?=
 =?utf-8?B?N0h5QlArSG9iMmJBL3QxU0U4WDZwYkRGU2RwSnhvczlQZW81ajd6QmE5K2FJ?=
 =?utf-8?B?OVRhbkx3cG9JZmZoR0hzUmdNOW5SclEybG9UR0E0RUZFUXN5ci84SEhzK3dE?=
 =?utf-8?B?dWNrQjh5SFpRRER4cmxNVTNVWVVoanlwbUlHMGRqRlUxdnNRNkVnNGpPQXBs?=
 =?utf-8?B?N00xU0VHc2FUWFk3QkNzN2dVZmVTdVhqVkhKN0YzQ1AzajZkbkozbDNlMEN6?=
 =?utf-8?B?bHp4WXM4bUNrRG1TTHE3QjFDbDVSQlgxV3VSSHdTelNBT0xNZWgvVWJZL2V1?=
 =?utf-8?B?V3VQVmlWUXhmVVN5Z0RwMlhJTEpkak9lS2Q3TjJWS05HeStPVTVEME9YRjE2?=
 =?utf-8?B?dUE0YjNVaWg1aHMvRkxMN2ZaWGNrbytSaGZQbm04VGp2NE9DbmQ1dDIraWhy?=
 =?utf-8?B?OUx3UU9rSG9QakNaVStoZEZFMlR2Ym1NQUVwKy9lUm1ONGdKOUc0b2NJdEpu?=
 =?utf-8?B?YUFBcE5PZ1gvT2d1YzA0UHFuUXNVb0liTkIrVzBNdDY5czVJRnhaMnR5KzlB?=
 =?utf-8?B?M0p2VFg3V01nYmw3dUFDeitYMmFFTU5hNDQvZ09oeHZhTDlNSVJCWWlTSFBY?=
 =?utf-8?B?MDMrU2VET1ZCSXp5V3RPd2VPQWJhZkxZZXFNZFZZbkZtQVcyZDRzdVVLN3dw?=
 =?utf-8?B?aTU1d0xrNzJ3Qmt6b28vd2hhLzMzNDJzcTRYOG1DR2xIcnJva2lHQmUwcC9J?=
 =?utf-8?B?aEFTbUN3bUIwN3JHZCtqYUhoYjZjaFRtMGxBdTZUMCtnNVZWTitYdmJ3RWJJ?=
 =?utf-8?B?T3pLMGU1RkxjNHNvbTViZTk3UDFsSkFNd1BmWU9DV05nNmNzQVZrQkxISUMw?=
 =?utf-8?B?MWdWaDFnQ3hvNjQrandkNnpKU044ZSttUXJXdnVIOTJvcitvbmp2ZXdzVkNv?=
 =?utf-8?B?SnlCbEhQb2dKdUZ2cWF5M0VDS0FwVlVvQzlhTVpFOEczWWZSbytRNlpLWGQ1?=
 =?utf-8?B?Smt5SndkV29jQ0NSUzRONEoxNDRTL01jWnlaTzcvcUgwVU9iNEdhR0JXdVN0?=
 =?utf-8?B?N0VvQXNpYkc1d3BCMm1qbGlxcCtyMkRqeVlOZDk5UGVsTXhXZ3NiM3BsZ3lq?=
 =?utf-8?B?aHhTN3JkakJZTlFuSER4UElObEZIZS9Vdm55a0xmWU55UWdYSi9NREZSWWsv?=
 =?utf-8?B?cFZ5c3F5NG9wTDR4V3ZZc3lVVnUvU3NOaWp1TjhoVms1VSt6RFJoVGdNbC9Y?=
 =?utf-8?B?dXNkcEM5cld2OG5zc0RUMEZyUG53Tk1hWENVaXE3NG1JOE1xZzNZQmM5bVgw?=
 =?utf-8?B?c2s5d25CUWJWOWhsY1d0Y0ZwOTRib09BZ1dDNCt3WDh3c1JGenF2M21LS0Uv?=
 =?utf-8?B?ZTFqTzJOcXdsa3ZpL1kxcEs2N29Ua2NuUUhYWlVUTk1vcmo1aHE4ZXkrOGNZ?=
 =?utf-8?B?UHVVNUswNnMrK2xVZ1ludVhXdDJvMnRNekF3SXJHaGw5L3RPVmF6RmxTRnlP?=
 =?utf-8?B?b3paczZWUFo5V1dQY1hydWJoMUs1aytncmt6VEJicDNzQTBQY3ZxK0tMbk1p?=
 =?utf-8?B?Zk1RRlBLcmN6YVNtNTY4OW5SQk9xdW0yKzNiTDNqc01pTHJHM0JBR20raFJj?=
 =?utf-8?B?NXVJQU5XL0VTeDQxeHY4dHRvdzRxMW5mdnlQK1ppckNZdmlXSS9adnl5RC9R?=
 =?utf-8?B?MGRWTzdKbGlYZWEzNFdRcGdTam5Xdyt5N05tTWVLU0o1dEhPOGJleHJOZVYv?=
 =?utf-8?B?cjJVTVFXUDViRkI5SXA3d2JmSUx6SFJIcnNyVHZHQzd2cVMxZEdtOExmSld4?=
 =?utf-8?B?eFRqUFllbk9iZk41RC9EMkpiMEkzeEVtbDNFZUNnN1NJNEtvd0lzTmYzbHVQ?=
 =?utf-8?B?UjBwN2NCUXo3VGhZUmZ6dVpIZkVFanpBbTF4VGlkT1NOUDI4b0VJUnRhSFQ0?=
 =?utf-8?B?WTRHckIraVVNYW13YXdzMmE2UVZCdTBQTElSRkxaV3V0OGNMaFRjcTRjajJy?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZFd0aXMwMVFIQk1QOEJmZjk4NzVuZHErbUw2Qy9KOW5MNWRLRUNJOTVpa2VM?=
 =?utf-8?B?WmUwOEVtejdkak1MeWtkc1hzcm9WODM2MUFrWisyMDJMdkNLMjkzcVRlYmVC?=
 =?utf-8?B?ZjRtYjQ5amlibXBEdEtFY1RpUmdQVnorWXovNlZQbEkzd0tXelhjVGpyaWFy?=
 =?utf-8?B?eTgzVkVSelpaeURqb2svQmhSUVZHWHVnS241djRmYTdITjJjUmNBM29kOUJw?=
 =?utf-8?B?UzJlWlNDWjgzSWlWYm9FNGhoOG5oTVYrdDVFQ0VUMHlUVk9ySzZ5cGNVcHlS?=
 =?utf-8?B?YVl5MWxpR2FBRjJNK29QNko2TktGMkkzUXlOM1ZEUitHalNqMFJ5RldiTnBR?=
 =?utf-8?B?enBTaUpEeUtTOUZDMHdtZ0w0MWtlclFYWXJEaVptR3JJSUtoemFYY3RKdHdq?=
 =?utf-8?B?c1gxdjUzckNmcmc3emJYYVVtV0V4d1ZHeVQyNmlySE5jczBEcmhxQkJ6TFI1?=
 =?utf-8?B?a2xsU2xNckRtV2RvMEFKYm11MjVCN1JmZU13UHZQWEVVQTluUHNzeVd4dk5M?=
 =?utf-8?B?aDBrc0hDTnZzcVhTdTdxYmtHTElRQzNQUFB5S05rTWkwK3NRRjJEUjl3QmRz?=
 =?utf-8?B?Wk56VFp6c0V4K0VyUFllNU9qa0Mra01yRzBucXRCQmQzTWZCQWJETCt2WXFj?=
 =?utf-8?B?WHJmUFlzNHBEVXVXeU5mRmdjMnJaRzBUaTRMc1kvbXo1YUFPS3ZlRm5nR1dx?=
 =?utf-8?B?ZnlJQWZYVkJwS0dzSzcyd01QWEQ2QVo5K0F1Nlo5aE9HUFJHNnNzNG5MRzY0?=
 =?utf-8?B?RFB0Y1J6TktKSk1BaGwvaFpaOExEamZXTEx1OS8xUFNjK050OWJ2cXhjZkxq?=
 =?utf-8?B?Y1BibUFZWXRNcmpscGZadlBzS2tKS2FuT2g5Wm83Ujhsd0Q1V0Z2anhLNDhm?=
 =?utf-8?B?WUkrVGp2aFNXL3h2MlhwTlhyaDI2eHRlM25HV1BFTzExQ3NvWGQ1YjRLeEVU?=
 =?utf-8?B?Y2pKWmtUdmpVTmVxT2V6YlA3eXdTbi9PcDVSUjhwSEVFTmM2VmRISmxJZk9r?=
 =?utf-8?B?NUQrbzFUZVpsbmgxclZucnhNTU40bW1SYThpMW4rbXNsUGRyRkFVQzNWYTlI?=
 =?utf-8?B?dDZ0MTI2RVEyaThiQ1N4YXBhQVdGQ2dyekgzdjU0ODV4RUsvdktmNkxtOXUy?=
 =?utf-8?B?QS9XT0ZFYU8zK3laR3haWmxlVkhhL1NpN1R4NHRDWHJWTDJpNzFYdG9zQzRO?=
 =?utf-8?B?cEJsTVdEdW1WSU00eHRPWUVhTk9QRDVZbFRDTTJlNUFRQndXVXNHeE9Rb2dO?=
 =?utf-8?B?ek82THpOSDNxUFJraVE4WGV5cmNoeUxqYXpGbDBmZkVDa3U0OHBOZEcwa0V4?=
 =?utf-8?Q?RlJanb/XxbV6s8wI2/L0XCwKjZE0eKvLFM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4dc938-30d5-43b6-9406-08dbc50e0c3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 19:13:53.0499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7DN/289m6yBcPf4X7bLsAyREg51upi+lf6UmY4LZGH5z0eD2KSYswZeDEP2TSVoTGH6mg9/VRD2kf9xUxWESg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_10,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040141
X-Proofpoint-GUID: 8WqhiEuadBGDkV7pqt2kR8c-19O6ExcL
X-Proofpoint-ORIG-GUID: 8WqhiEuadBGDkV7pqt2kR8c-19O6ExcL
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/4/23 11:06 AM, Sean Christopherson wrote:
> On Wed, Oct 04, 2023, David Woodhouse wrote:
>> On Tue, 2023-10-03 at 17:04 -0700, Sean Christopherson wrote:
>>>> Can't we ensure that the kvmclock uses the *same* algorithm,
>>>> precisely, as CLOCK_MONOTONIC_RAW?
>>>
>>> Yes?  At least for sane hardware, after much staring, I think it's possible.
>>>
>>> It's tricky because the two algorithms are wierdly different, the PV clock algorithm
>>> is ABI and thus immutable, and Thomas and the timekeeping folks would rightly laugh
>>> at us for suggesting that we try to shove the pvclock algorithm into the kernel.
>>>
>>> The hardcoded shift right 32 in PV clock is annoying, but not the end of the world.
>>>
>>> Compile tested only, but I believe this math is correct.  And I'm guessing we'd
>>> want some safeguards against overflow, e.g. due to a multiplier that is too big.
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 6573c89c35a9..ae9275c3d580 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3212,9 +3212,19 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>>                                             v->arch.l1_tsc_scaling_ratio);
>>>  
>>>         if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
>>> -               kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
>>> -                                  &vcpu->hv_clock.tsc_shift,
>>> -                                  &vcpu->hv_clock.tsc_to_system_mul);
>>> +               u32 shift, mult;
>>> +
>>> +               clocks_calc_mult_shift(&mult, &shift, tgt_tsc_khz, NSEC_PER_MSEC, 600);
>>> +
>>> +               if (shift <= 32) {
>>> +                       vcpu->hv_clock.tsc_shift = 0;
>>> +                       vcpu->hv_clock.tsc_to_system_mul = mult * BIT(32 - shift);
>>> +               } else {
>>> +                       kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
>>> +                                          &vcpu->hv_clock.tsc_shift,
>>> +                                          &vcpu->hv_clock.tsc_to_system_mul);
>>> +               }
>>> +
>>>                 vcpu->hw_tsc_khz = tgt_tsc_khz;
>>>                 kvm_xen_update_tsc_info(v);
>>>         }
>>>
>>
>> I gave that a go on my test box, and for a TSC frequency of 2593992 kHz
>> it got mult=1655736523, shift=32 and took the 'happy' path instead of
>> falling back.
>>
>> It still drifts about the same though, using the same test as before:
>> https://urldefense.com/v3/__https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/kvmclock__;!!ACWV5N9M2RV99hQ!KEdDuRZIThXoz2zaZd3O9rk77ywSaHCQ92fTnc7PFP81bdOhTMvudMBReIfZcrm9AITeKw4kyMTmbPbJuA$ 
>>
>>
>> I was going to facetiously suggest that perhaps the kvmclock should
>> have leap nanoseconds... but then realised that that's basically what
>> Dongli's patch is *doing*. Maybe we just need to *recognise* that,
> 
> Yeah, I suspect trying to get kvmclock to always precisely align with the kernel's
> monotonic raw clock is a fool's errand.
> 
>> so rather than having a user-configured period for the update, KVM could
>> calculate the frequency for the updates based on the rate at which the clocks
>> would otherwise drift, and a maximum delta? Not my favourite option, but
>> perhaps better than nothing? 
> 
> Holy moly, the existing code for the periodic syncs/updates is a mess.  If I'm
> reading the code correctly, commits
> 
>   0061d53daf26 ("KVM: x86: limit difference between kvmclock updates")
>   7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
>   332967a3eac0 ("x86: kvm: introduce periodic global clock updates")
> 
> splattered together an immpressively inefficient update mechanism.
> 
> On the first vCPU creation, KVM schedules kvmclock_sync_fn() at a hardcoded rate
> of 300hz.
> 
> 	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
> 		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> 						KVMCLOCK_SYNC_PERIOD);
> 
> That handler does two things: schedule "delayed" work kvmclock_update_fn() to
> be executed immediately, and reschedule kvmclock_sync_fn() at 300hz.
> kvmclock_sync_fn() then kicks *every* vCPU in the VM, i.e. KVM kicks every vCPU
> to sync kvmlock at a 300hz frequency.  
> 
> If we're going to kick every vCPU, then we might as well do a masterclock update,
> because the extra cost of synchronizing the masterclock is likely in the noise
> compared to kicking every vCPU.  There's also zero reason to do the work in vCPU
> context.
> 
> And because that's not enough, on pCPU migration or if the TSC is unstable,
> kvm_arch_vcpu_load() requests KVM_REQ_GLOBAL_CLOCK_UPDATE, which schedules
> kvmclock_update_fn() with a delay of 100ms.  The large delay is to play nice with
> unstable TSCs.  But if KVM is periodically doing clock updates on all vCPU,
> scheduling another update with a *longer* delay is silly.

We may need to add above message to the places, where
KVM_REQ_GLOBAL_CLOCK_UPDATE is replaced with KVM_REQ_CLOCK_UPDATE in the patch?

This helps understand why KVM_REQ_CLOCK_UPDATE is sometime enough.

> 
> The really, really stupid part of all is that the periodic syncs happen even if
> kvmclock isn't exposed to the guest.  *sigh*
> 
> So rather than add yet another periodic work function, I think we should clean up
> the mess we have, fix the whole "leapseconds" mess with the masterclock, and then
> tune the frequency (if necessary).
> 
> Something like the below is what I'm thinking.  Once the dust settles, I'd like
> to do dynamically enable/disable kvmclock_sync_work based on whether or not the
> VM actually has vCPU's with a pvclock, but that's definitely an enhancement that
> can go on top.
> 
> Does this look sane, or am I missing something?
> 
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +-
>  arch/x86/kvm/x86.c              | 53 +++++++++++----------------------
>  2 files changed, 19 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 34a64527654c..d108452fc301 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -98,7 +98,7 @@
>  	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_SCAN_IOAPIC \
>  	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
> +/* AVAILABLE BIT!!!!			KVM_ARCH_REQ(16) */
>  #define KVM_REQ_APIC_PAGE_RELOAD \
>  	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_HV_CRASH		KVM_ARCH_REQ(18)
> @@ -1336,7 +1336,6 @@ struct kvm_arch {
>  	bool use_master_clock;
>  	u64 master_kernel_ns;
>  	u64 master_cycle_now;
> -	struct delayed_work kvmclock_update_work;
>  	struct delayed_work kvmclock_sync_work;
>  
>  	struct kvm_xen_hvm_config xen_hvm_config;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6573c89c35a9..5d35724f1963 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2367,7 +2367,7 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
>  	}
>  
>  	vcpu->arch.time = system_time;
> -	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> +	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);

As mentioned above, we may need a comment here to explain why
KVM_REQ_CLOCK_UPDATE on the only vcpu is enough.

>  
>  	/* we verify if the enable bit is set... */
>  	if (system_time & 1)
> @@ -3257,30 +3257,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  
>  #define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
>  
> -static void kvmclock_update_fn(struct work_struct *work)
> -{
> -	unsigned long i;
> -	struct delayed_work *dwork = to_delayed_work(work);
> -	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
> -					   kvmclock_update_work);
> -	struct kvm *kvm = container_of(ka, struct kvm, arch);
> -	struct kvm_vcpu *vcpu;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> -		kvm_vcpu_kick(vcpu);
> -	}
> -}
> -
> -static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
> -{
> -	struct kvm *kvm = v->kvm;
> -
> -	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> -	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
> -					KVMCLOCK_UPDATE_DELAY);
> -}
> -
>  #define KVMCLOCK_SYNC_PERIOD (300 * HZ)

While David mentioned "maximum delta", how about to turn above into a module
param with the default 300HZ.

BTW, 300HZ should be enough for vCPU hotplug case, unless people prefer 1-hour
or 1-day.

>  
>  static void kvmclock_sync_fn(struct work_struct *work)
> @@ -3290,12 +3266,14 @@ static void kvmclock_sync_fn(struct work_struct *work)
>  					   kvmclock_sync_work);
>  	struct kvm *kvm = container_of(ka, struct kvm, arch);
>  
> -	if (!kvmclock_periodic_sync)
> -		return;
> +	if (ka->use_master_clock)
> +		kvm_update_masterclock(kvm);

Based on the source code, I think it is safe to call kvm_update_masterclock() here.

We want the masterclock to update only once. To call KVM_REQ_MASTERCLOCK_UPDATE
for each vCPU here is meaningless.

I just want to remind that this is shared workqueue. The workqueue stall
detection may report false positive (e.g., due to tsc_write_lock contention.
That should not be lock contensive).


Thank you very much!

Dongli Zhang

> +	else
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
>  
> -	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
> -	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> -					KVMCLOCK_SYNC_PERIOD);
> +	if (kvmclock_periodic_sync)
> +		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> +				      KVMCLOCK_SYNC_PERIOD);
>  }
>  
>  /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
> @@ -4845,7 +4823,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		 * kvmclock on vcpu->cpu migration
>  		 */
>  		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
> -			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  		if (vcpu->cpu != cpu)
>  			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
>  		vcpu->cpu = cpu;
> @@ -10520,12 +10498,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			__kvm_migrate_timers(vcpu);
>  		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
>  			kvm_update_masterclock(vcpu->kvm);
> -		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
> -			kvm_gen_kvmclock_update(vcpu);
>  		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
>  			r = kvm_guest_time_update(vcpu);
>  			if (unlikely(r))
>  				goto out;
> +
> +			/*
> +			 * Ensure all other vCPUs synchronize "soon", e.g. so
> +			 * that all vCPUs recognize NTP corrections and drift
> +			 * corrections (relative to the kernel's raw clock).
> +			 */
> +			if (!kvmclock_periodic_sync)
> +				schedule_delayed_work(&vcpu->kvm->arch.kvmclock_sync_work,
> +						      KVMCLOCK_UPDATE_DELAY);
>  		}
>  		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
>  			kvm_mmu_sync_roots(vcpu);
> @@ -12345,7 +12330,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.hv_root_tdp = INVALID_PAGE;
>  #endif
>  
> -	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>  
>  	kvm_apicv_init(kvm);
> @@ -12387,7 +12371,6 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
>  void kvm_arch_sync_events(struct kvm *kvm)
>  {
>  	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
> -	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
>  	kvm_free_pit(kvm);
>  }
>  
> 
> base-commit: e2c8c2928d93f64b976b9242ddb08684b8cdea8d
