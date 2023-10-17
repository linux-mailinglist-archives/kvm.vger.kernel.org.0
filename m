Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5B7CC89D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343573AbjJQQTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJQQTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:19:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941C59E;
        Tue, 17 Oct 2023 09:19:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGDsdU013745;
        Tue, 17 Oct 2023 16:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2+tH/rmuncj/u5b0honUsHIrDDGe3I5jwnApPm9WeOs=;
 b=niqQXO22sUZK1H/cjZohhSFm3MaSPjHDINRQ5LVSOLuF4fMDUXOwEJ4OxAb7AS2edyW3
 QAee7Jzw51jSwp9BE7HJylRun9wcHIbI1okT2c0piAJjkhZA0580axSVB+UNvNBGEjFa
 3X5eQW8qC7dJht4n7rMYhb03t1JeTud5EUsaew1klGjA2I8HpoOFuAGJsFTzv8dUdkHY
 pIuT4Z7tZEd0E0/BMm4K0a6D5mKBGwdoD8IIG6tNiszhfx+xF/AQLmrWjppmkqCi+WH6
 JOyD3beEs8O3zz6Zpomgc9E1fmkxlR/yHKpxZ9LgCJFwao32LGOu9LULqHgLy5NdJhyp lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cwkdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 16:18:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HFGjqG021595;
        Tue, 17 Oct 2023 16:18:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg518pkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 16:18:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuWGch4LudDVfx3Y7Sr+17YV8uToNjk2PD13myxX0ryV3YZnv+EXdHUn7jiaTZPzNvYNChh9fTCTPvzDeeY5YvjZvS0G5sKDWXo/KPyEyxtiXd0+0zRjYBeqoGvFKvt5b5wQaqSH28ZJKL6cnQ/F3jcgHiEim4Qxy/Wk5Ho/o9tGNH3+HFZaJtYS+gTPLCU6IO7nCRPoVQKoY1iU+SefXSg45JDJdjgbrZLot0D5jsaan8XqwmnOwJ3tQbmuN2qTM1jkALgoDPxbdjczLyMUDrGCNGmkKHyALluF7A8/DPdVsD43VtXbPs1ylVD2LWMRLXnOKMUTIivuEEc7ucqDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+tH/rmuncj/u5b0honUsHIrDDGe3I5jwnApPm9WeOs=;
 b=F8xUy/pZmGP7EiwxC7LE9ZpS9qSjI+q0pekdP/81lXyw+6NPyjnKAkZUSwqhNNhxd2fNUejU7P8UVhvOuplwQASt/iwy9zXKXP7M9rMi43p1YoOdHLGsEoMo77UDKCuggJVNt5fplbkn31aLUaXHtpxKP+zqgcgdj9esqrSqjJ17YXvzZVv3ZTrXkq75Wr2XVmwcg+7HhS3SMTNRyPYTREHY1xpdSWZl+8CyOKmSi9sTeQBZW8oJRc3xCpeianJQmUZTxulnSRId2BVvYJ4TsFSBwOwaHuscf/FV9fjkvwy2gWoEwerziTnHxYbJ/Y+ZZV4Qq3qwvTeeYoqOLRKtjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+tH/rmuncj/u5b0honUsHIrDDGe3I5jwnApPm9WeOs=;
 b=Uxn0OUYgCvcqVgFAwLF9PZICMeYlnJJk9QDfCwzxu/RwpKOd/qZn5iqn+9qUUryRNF7uu3z6U+NHp83VNmqcBpZjtj47ML5vKpqWIoUjllYuMMxVJNGKZ4u+oeYWaejfjgjkg9O9sl68DHbpqE0wV6FgdU2sIIqQcQAORF6TrK0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB7292.namprd10.prod.outlook.com (2603:10b6:930:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Tue, 17 Oct
 2023 16:18:51 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 16:18:51 +0000
Message-ID: <fa081a65-6abd-c8dc-240c-b25d6af55bb2@oracle.com>
Date:   Tue, 17 Oct 2023 09:18:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
References: <ZSXqZOgLYkwLRWLO@google.com>
 <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com>
 <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com>
 <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
 <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
 <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
 <ZS2Fq5dr2CeZaBok@google.com>
 <b3721f33-d5b0-79db-8500-d6b93dded0c1@oracle.com>
 <ZS29teniU3xer0Xu@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZS29teniU3xer0Xu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0500.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::7) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB7292:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b25beab-b74a-407d-516d-08dbcf2cc052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yt0l9BMKpTO+7kQFogRHAKimqu7tksY2qgQK2JspPKthTnOyTKlxV8MFVwFSCa+sULisqObuJMSOPuW2JK25j0VuzmbShrv+rZKPMYvddYYEhvqHAk4s70qS2MJVqMLPSrA1DzaDBUphNXEsBwWwyfctP1q+uYPPHXsfEpwSFN/Hey/mtlhsx57UMmbO35FGoilpEtq5HDvYjA1TEPVEwHHe4eGRMYgFXM5QqhLszrCxtcLzqIJ4hdlRxFm88m6Kg/o9nfw18/IBjt4goWarqWLPbboqRckHg9WDTdnr65FRo9pEBFHNYPHmcgqCOXwvtdMq7yDMRn9bW+I/ltvF1iAGFQHmrWYyezCskUDpnYU6BDF2r2e3nfAf7oLvMsHJqiE8HNzYshHrPb1krJ5sluo07nzT9LzNtL/Ps7hlBQ7EIs8ERJVwqWQFLXgjTkkDqRtGg4AM5dpUNjiG1nI/Uukmq7XNYIc06dBO0xEwSuqPm7I88xc4cpVVuBxYsFZbodfvYhQ+s+/rXQrJ8oRpP1tFLNfKnpNLc3ZH23k208jMtznC9zihYVIFe4XhgX9vn41qSlxTT9NBOQP626kCQsKjnRSer+QKUAs00Jfl3bUGQvn9lJJFpX8aerDMq5qPhxEgV1iSDaxRSe6YOjy/iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(376002)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(83380400001)(6666004)(38100700002)(6506007)(53546011)(6512007)(26005)(2616005)(6486002)(478600001)(31686004)(66556008)(66476007)(54906003)(316002)(8936002)(66946007)(6916009)(41300700001)(4326008)(8676002)(7416002)(2906002)(86362001)(31696002)(15650500001)(5660300002)(44832011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nlp6ZUFNcTdIWkwxdlc4OG5RZEQzb3pYMTBUSlM0VGdSNkhXamRESzdSQjJz?=
 =?utf-8?B?Tlp6YlFTQVpsTVN0dXduUXVwVHlKTWdDTnNUQTkrMWxGcFhUVUt0UGQ2d1pu?=
 =?utf-8?B?cU1JNFZqejNxVmdCcnJuL21YTUV1WUVBdGZVQUxzWmRUN0dqZ2NnalVVeWty?=
 =?utf-8?B?UGFNbmhrdVhhd21LWHZhN25BVDArSUdZUzhBeGZxeWpnMHNFRWdGTEpBNEl5?=
 =?utf-8?B?MGo1UzVBMW5SOUhRSHZxVkV0dkVaWGNQVjB3Vks3YkgxT09qOTladGMwWE84?=
 =?utf-8?B?S2YvTVM3azcwWW0rN25aaW1NOTM3VEdpUlBVUGlqWC9CY2g1TmU1SWd5TjZN?=
 =?utf-8?B?WmI4M2lEUDVPKzBPbFJIdldjQVpUbnRsemdxdHRRREIxUG10WU9iY2NRWi90?=
 =?utf-8?B?ZGc3Y2hzQ0IyQ1RBNGlSVkU2a3BweWw4Z211ZVZvNEhNZW1iampzeXVWMUs1?=
 =?utf-8?B?ekhqU05CQUtpV3ZHTnkvV3hPbjZydXhOamdYMFhiSCtTY1J3cUxPS2JWOXFs?=
 =?utf-8?B?V3M3SEhaQ1ZBaVRuRlFxU0hsSHJrdnBwWmtYRDg1bE5seVhYK3dwNHE2dHYz?=
 =?utf-8?B?VnVvaGhTYk1aOHBmWkhWY1hLV0tXNFB0S3ZQRmlMTTB4Nlk3QTFyaG1CVzlh?=
 =?utf-8?B?QVRWYy9aY0tLbkl6NmVESHB6dmRsM0lpTWhybXlSMCtDVmM3ZElPZ2FsKzRQ?=
 =?utf-8?B?ZzF1Ulh3NEFyZVpaS01yTFlGdUZobW91eTZPSU1lQzdHMldIb2lSekQ4V1RL?=
 =?utf-8?B?T2JFL1gzdzhuUlhnSW5GZ2FybWVJOE9UZndDNzY3TTFLRWJEVXVzakIzRFI2?=
 =?utf-8?B?Z1lpN2NhZkI0L2g1V1NvZjFaU3FjVVZuUGxPcWttU3R3N0pBaDZ4cXZDb3ZJ?=
 =?utf-8?B?aDhUWTkzMzk1S1Rkczg1blpFYVE2RjIvMVplU0krS2VMVW5lTy9meVd6bHcr?=
 =?utf-8?B?Vk9VV2R3Z2dYckg0NzNsYVhFUlBsWi90RlR5cHJvSUpFZ0NpenZIRFBONzlH?=
 =?utf-8?B?aEs5WjB1R092YUp1QitRNjR3MGZ5TkgzNWF2UHpFZGM4VXpTQTBic0JuUlJK?=
 =?utf-8?B?UkZwc01zNThDTkdZd1YycFE1L1BpTDd2d1ZWelhadWdYSnU3a2RZS3F1YUQx?=
 =?utf-8?B?VnVYbEtEQU9nVGlmc0xvY3E3T3RBbS9BSU9nZzREZXdwamt2VnYxek9lMzZx?=
 =?utf-8?B?NHVSbHlMdXhqdExXM3UvcjkzYmMwY2I3MGV1T1VOVXlFY2Z0eml1MGhWOFVJ?=
 =?utf-8?B?UjNaVCtjMEZzUjhtQU8rQU1sZEh1V1l5YTJSajJJK1JuODU0T0lacU5wWnBT?=
 =?utf-8?B?UjBHRjZkK25JY1o3U2Y5VWtjZ1RNUlZlWU9TUG45VHhPSnkyd0VoNVdmSG5C?=
 =?utf-8?B?ZWZhZ0N3WkxobWQwMGFLandCTGkrQ25qTVZlWTkrM3VIeVJvREN3SndtNDVj?=
 =?utf-8?B?cWgrd3BWR3orR1VpR0wzTkRCaitIbTVPZG1RK3RycG45aVh3Q1plL01BbmVD?=
 =?utf-8?B?M2FuVGVESVBIcXEwMzdBZzhwYWVBRUpRQ0E3Z0JObytsV2J5Y2ZWTG9hZFNF?=
 =?utf-8?B?bjVnUm9XTS9IZFlkNmRNc1lRNkJFbWhiMk96TVp1NmczdWNpT3hXaTdjYXVT?=
 =?utf-8?B?QVIwSEN0YTVieFNrMmJPTmRvTVRKMTNDNUVRbXRKK1N1a1VyYXpWZHdKTHRX?=
 =?utf-8?B?VjRQTTJzcVJwRFlhaXF2bXB6dUc1VXpQS24yaDJBV3hXYlBQbUo4WU5FN0d0?=
 =?utf-8?B?bVZhQzRjZTZrL3F4UTJuUmNiKzlIdTZhUzdSOXhTcytiWDFnZ3EyY2ZDcCtj?=
 =?utf-8?B?V2t6d092cy9qSHl2cU1Ma0VLTGlHR0JCQ0E2bFdDa0gxb2ZNelBmT25sdkFp?=
 =?utf-8?B?SDFRQitIZDQrbUtXNGxQVjJQTlVIZWlsa0tlYnhWSTNkL250WWdvbkw4NG5U?=
 =?utf-8?B?ZGh6L3FSYWxyWWVGTDlrODAybUNaWFpubnlyQzl3UTRTY3ZBcllkZFV2N1p2?=
 =?utf-8?B?WlJZWU5OWEtGODRVMFZXNVJlNThjVkpEM09tSTE5ckhpU0QxZ1lXTE5YV2xr?=
 =?utf-8?B?b3dORjY4QWI3aHdDT0kzRXhSd0NZbUZWMGhKRGl1SWIxZ3RQRllNcmhudXNN?=
 =?utf-8?Q?fvyYxUtNMj0yeyEsO8NHT6kec?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YnZNb1REaFNpSWNjK2hPK1lBMWRNVG10aVhLc0NXbUtSUEJGZHR4dG5xRTl4?=
 =?utf-8?B?RGswSFBjU21IbUJMMFd5Ujlrdk1ocWJHUHByUWdlWWFEdzYwRmFqU1FweFRZ?=
 =?utf-8?B?TFF0WkRKY1pRMkhTS0ZXM21tTkZnTzlNTnIxTWFUa3JCNnd0UkxITmV0R1Rl?=
 =?utf-8?B?SXErTmFBN1ZuSmQvUWFQd0Q1Q2Qzd0VuZWRXTFUySDR0QUdJR0RTTjdRVGVx?=
 =?utf-8?B?NFkzVEdnRTgvbG43dGlyUkFqY0h1RUN5d3FUVEpyMHcvTUZhVnBpTDNJNVpx?=
 =?utf-8?B?aVk5QzBvMzJMNUtReE1ZQjdDVUozY1c0QXd3ZGg3KzNuWS9QbnRsZVRodUpT?=
 =?utf-8?B?bXYzRm9wSCtZRDcweklhUURDaFZMemd4b2prNXBtSFJYM212RnNLT2E2eE5S?=
 =?utf-8?B?eURZNFYyZ3dTL3Fvb1FwVWdyWXhNNTBTWUlMSGRjVlN5Y25GNjgvME5QYVVr?=
 =?utf-8?B?Q0lRcDFjU0ZhL0JKOXp2MWNBRUtwQjRyNUliU2pYMjhPVEVvM09nS1VtQ0ZV?=
 =?utf-8?B?NzJlQmdzejNKWHllTTUvNCtDdzZsTUZZa3pmVm1DY0srelM0QlBsNWZSUDdW?=
 =?utf-8?B?RjJVVWNqcTJzZ0xxemtBMDVBaE5LdGcrV0duUlNWY2s3M2hvci9YTUJpeENJ?=
 =?utf-8?B?bit1YlAvaGVYN2R3dVdTMWwwYlhldWpMVGtxbEZIRXAvY0t2OWtEb2habGo4?=
 =?utf-8?B?OVRheWthbGhtM0xFQTZYM2trWitEWkpWT1IzcVc2UjdRRTd3ZmY0bDJ1OUNz?=
 =?utf-8?B?d1lyTnVidXNnL2IzMGVWT2d4dkRXK01IRytKYTVRdzJ2YWdlM1Y0RFlzbVU5?=
 =?utf-8?B?RFFCcEtqRytyMHhyOHpUd0N5ZGVrM3picEg4ekFKc0MxdktzRWZNSHFIY0xy?=
 =?utf-8?B?ZmVFMGlRSHpRSDB3d01SRmppYjBQWSt3dWZuNGZSTjdJWnBPcUFVYXlUcC9o?=
 =?utf-8?B?UjlpRCt2WjdlQUt2UlRVUDI5V0lzUDhPYWxJaTFwbWVrdkR1bEU1UGFYZFhG?=
 =?utf-8?B?L0pmN3cvakxRRmpSMDN0TUJOZThHWjNsVzRDaXE0NmxEUWhxR0JST2p2UDJa?=
 =?utf-8?B?Mm5Lc0E4cHZSRG14ZUFud1BSdjBnbnh2am9zL2x0eUljalE1cnJwblFjbndU?=
 =?utf-8?B?cmZzRnAvVlo1K2ZPeE5VY0xldzhRdytjUlZCbEdUVEI3Y29JdXVGendTeUxV?=
 =?utf-8?B?aGl0YWxlZ2xXQnRqb3VHVFhMOWhmUGFYdEhNV2dGMXNNUkZNQWVBVjdrK1hi?=
 =?utf-8?B?QUdORjNuZlE0c0t6ekxlanRrek50cy96SWk1L25UQWo1VG12UFJzeENTM3Vz?=
 =?utf-8?Q?OxfkgglJTZCaEuMVnuIB4R+a2AnsRvuvVA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b25beab-b74a-407d-516d-08dbcf2cc052
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 16:18:51.8210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1SAG6qAdD19FdO0XNHUPnkajHR0pBskI/KOjha954V6yAQW3Y8/ivQc43Zi/j3+7hshZfq/592wyJTvZDLjn/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7292
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170137
X-Proofpoint-GUID: WZ65fpXn_wvttbKozWeU8REGkJieuDlM
X-Proofpoint-ORIG-GUID: WZ65fpXn_wvttbKozWeU8REGkJieuDlM
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/16/23 15:48, Sean Christopherson wrote:
> On Mon, Oct 16, 2023, Dongli Zhang wrote:
>> Hi Sean,
>>
>> On 10/16/23 11:49, Sean Christopherson wrote:
>>> Compile tested only, but the below should fix the vCPU hotplug case.  Then
>>> someone (not me) just needs to figure out why kvm_xen_shared_info_init() forces
>>> a masterclock update.
>>>
>>> I still think we should clean up the periodic sync code, but I don't think we
>>> need to periodically sync the masterclock.
>>
>> This looks good to me. The core idea is to not update master clock for the
>> synchronized cases.
>>
>>
>> How about the negative value case? I see in the linux code it is still there?
> 
> See below.  
> 
>> (It is out of the scope of my expectation as I do not need to run vCPUs in
>> different tsc freq as host)
>>
>> Thank you very much!
>>
>> Dongli Zhang
>>
>>>
>>> ---
>>>  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
>>>  1 file changed, 16 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index c54e1133e0d3..f0a607b6fc31 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
>>>  }
>>>  #endif
>>>  
>>> -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
>>> +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
>>>  {
>>>  #ifdef CONFIG_X86_64
>>> -	bool vcpus_matched;
>>>  	struct kvm_arch *ka = &vcpu->kvm->arch;
>>>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>>>  
>>> -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
>>> -			 atomic_read(&vcpu->kvm->online_vcpus));
>>> +	/*
>>> +	 * To use the masterclock, the host clocksource must be based on TSC
>>> +	 * and all vCPUs must have matching TSCs.  Note, the count for matching
>>> +	 * vCPUs doesn't include the reference vCPU, hence "+1".
>>> +	 */
>>> +	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
>>> +				 atomic_read(&vcpu->kvm->online_vcpus)) &&
>>> +				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
>>>  
>>>  	/*
>>> -	 * Once the masterclock is enabled, always perform request in
>>> -	 * order to update it.
>>> -	 *
>>> -	 * In order to enable masterclock, the host clocksource must be TSC
>>> -	 * and the vcpus need to have matched TSCs.  When that happens,
>>> -	 * perform request to enable masterclock.
>>> +	 * Request a masterclock update if the masterclock needs to be toggled
>>> +	 * on/off, or when starting a new generation and the masterclock is
>>> +	 * enabled (compute_guest_tsc() requires the masterclock snaphot to be
>>> +	 * taken _after_ the new generation is created).
>>>  	 */
>>> -	if (ka->use_master_clock ||
>>> -	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
>>> +	if ((ka->use_master_clock && new_generation) ||
>>> +	    (ka->use_master_clock != use_master_clock))
>>>  		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>>>  
>>>  	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
>>> @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>>>  	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>>>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>>>  
>>> -	kvm_track_tsc_matching(vcpu);
>>> +	kvm_track_tsc_matching(vcpu, !matched);
> 
> If my analysis of how the negative timestamp occurred is correct, the problematic
> scenario was if cur_tsc_nsec/cur_tsc_write were updated without a masterclock update.
> Passing !matched for @new_generation means that KVM will force a masterclock update
> if cur_tsc_nsec/cur_tsc_write are changed, i.e. prevent the negative timestamp bug.


Thank you very much for the explanation. Now I understand it.

Thanks to the immediate call to kvm_synchronize_tsc() during each vCPU creation ...

kvm_vm_ioctl(KVM_CREATE_VCPU)
-> kvm_vm_ioctl_create_vcpu()
   -> kvm_arch_vcpu_postcreate()
      -> kvm_synchronize_tsc()

... the local variable "bool use_master_clock" in your patch may always be true.
At that time, the "(ka->use_master_clock != use_master_clock)" returns true.


As a result, we will be able to trigger the KVM_REQ_MASTERCLOCK_UPDATE  during
VM creation for each vCPU.

There is still KVM_REQ_MASTERCLOCK_UPDATE for each vCPU during VM creation.
However, there will be no KVM_REQ_MASTERCLOCK_UPDATE for vCPU hot-add.

Thank you very much!

Dongli Zhang
