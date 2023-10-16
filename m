Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D897CB110
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjJPRH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbjJPRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:07:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB1A1723;
        Mon, 16 Oct 2023 10:05:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GGwvUq010391;
        Mon, 16 Oct 2023 17:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=eYNtPpAXIv3+ePowRwk0pyx/dgViBAv7EAu9XTHAw3Q=;
 b=pA7vsxySJZPe2bBuP0DxVrNyut6FV9kp0rsDdfcTi3FAJnNTVaEpnIkA8hN0CF55dBc0
 mE5kwV2IzCpBVreMUuk8tyzowZtYztZN1a9t1stjqPkrzf2QXcl7p1WjcIF2cf/5Fq1u
 WcjQjznyXenEheXYihroA4QPC9T7U9aFFwy77xIb9nVQk2caH4Z99R5DKJuVugvHv847
 gJZ33opH5piibkglSC2u1K/VJMNSJLuL5T2YOywTQM14dDjqdrEm3CddJ4I5HL+huWa/
 O6aIteuiPbCo4M7i5S9fakV/1TYFefikjYtEl3Ktacwb5nI7puMO8f9MNrNKA3hfllFJ LA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynba3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 17:04:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GGHGue015439;
        Mon, 16 Oct 2023 17:04:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1dwf87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 17:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlZ9Xs29YTVqnnCnAM+bjYmhdPHtHDUG6TJpI3eqgO/dWqrgzcQ17cHuPXWrqvUjhCF0pZVSWQjoqYXJFAZldC2NvbiMwXRMsQ5AfetZkGk/PIFzSUaPD1YZ0n+Obzg0tnsS77nTg7722zFi2ovCShR9iyFuZQlpWqDr7QWSA8+BM6g0mfYCP1ZQXME97vbIZ3ZdvBsqWP0bSMEYdj1sEjAuvx0bJKmHB7ZfkF1sRoQA12DK7TVStilVgJbArkUjNuqnuNQTAYy7V1ft4duScePBvDqWFIRFDQvgWA/F1N+qRHHO+tKt8/jgooi53gp1fwoutdPnawfri5t+UQy7Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYNtPpAXIv3+ePowRwk0pyx/dgViBAv7EAu9XTHAw3Q=;
 b=E5W4K6EjgdLlbuEvIax5hL81C1TSUbFPEL5lriiradSRVx9XfxZ/XauLC3SG0NJv2fuf/2Wy+5RhiSzzpFP/IeUZnGZXVQQMMcn5b0apvrfzpMJRBcmVnK+166nYcOho4OZ1NpKHblQ1dj7UbT5V6dFfAYRWM72f+F+UR4OcKx+LeJjSJrzNWAJ0fEwLHFIKhHsCIlSom4+Vuf6URW4HAh7w00Decsnp8uHIsGyaDX7vjvikJUiKydbjTV3dA2MSCWw+5OkUELvqwcEd3HViU+L/B4Xml9DAXalvYA2fpFf7bugK+byr1Of5jyVSC9zOg2iKk0IL0DzffRiFl8uP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYNtPpAXIv3+ePowRwk0pyx/dgViBAv7EAu9XTHAw3Q=;
 b=qcb8piaXVjxd7ql/PwerQGPidb4cNxBa6YkYFM8N28oABoNpRTmSokpUHUPxC8eBiwDCSgoMomfJdQ1Cn6Y/aESdvemyzhZZNeVBEBgn03bvXwhfd3ynlUjBJgO+eYPNC8GPe+lDf+0/5f942vRLWX8Oj9bkm1gi4HzrDkuTwQU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO1PR10MB4692.namprd10.prod.outlook.com (2603:10b6:303:99::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 17:04:43 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 17:04:43 +0000
Message-ID: <e9e41bc1-952a-bbf7-0228-e580defbdc3f@oracle.com>
Date:   Mon, 16 Oct 2023 10:04:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <ZRtl94_rIif3GRpu@google.com>
 <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com>
 <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com>
 <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com>
 <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com>
 <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com>
 <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
 <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
 <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:332::30) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO1PR10MB4692:EE_
X-MS-Office365-Filtering-Correlation-Id: 788a4b04-1474-4b6d-3a14-08dbce69fe1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /G5LqcmcGZY6n3dAEgeUmgQ8NUn7IAdxoe7YrgsgEDCDaekNjQ1chtHnKYgXx+rWUgy9/4DGoyFokxoORxrEQOamnzz5wkPF1ehYXXkylhFoF8VFOMyzjZs29CaYUjbXNc55tYxabPzqmNGCt0kacmWDQv9lotouUwa/f9Cbxv/oAF1jhzmOyS2mtJR/Zlw3eAoUgcqNkjpi7I66DlZbd4uNBlNz9hNZVfwaHWPGWWCd7+xP7NC6qIG7M/hElHeFUuYQAZ+L8U9MOi4+S0hy6Uaoz1BUZXWPFK7TT3fWdezaZE9Zx2Bubnv//2ef/7+/gN5zri2faUUpwoBufkpPk0OZNgu6EUNQUFZF0xQD7foVqJZJYXeX6XR3VeXi4xYcXd8KwoaSndqrCHwRTzhkey79f43KLExVJg7wQDrWSUPWxogjIdyDruKiv6LG3jEDggLJ8Gry0+4leA3PgF0Wy7/tUxrIHhXP8Sa5xQRTRaV7PZP5LO3n1zyF2WqzS6bzp8GtCqHsxZ6PSiUGoR516qHK/jN82M4OQUfYbrOe5Fem/mZ9D/WWbY9lUzrX6X7F7gycptAYs47mY2mCPE9G8cVhUh6k45IGCPdCKXnnGcqWqwr5IIp3/vhAmQx0p8qUMhYtz1AWT1C4jMsOUF1XJiQjHwPpRBFtsmmsy9Up1nGAeW/HV3HhdFDW9ckncZgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(39860400002)(396003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6506007)(53546011)(5660300002)(44832011)(66899024)(2906002)(26005)(36756003)(4001150100001)(2616005)(83380400001)(15650500001)(38100700002)(86362001)(31696002)(6512007)(7416002)(6486002)(966005)(31686004)(41300700001)(8936002)(66476007)(316002)(110136005)(66946007)(66556008)(8676002)(4326008)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXk3RVh6d3daZzByNGZQL2xLMzhYdW5QazMxZENGRlZqU2N1Q1d5a244S3Vq?=
 =?utf-8?B?SFp4bGtMRVV3VGxncFBseEo2R2FodDJqWWZMK3JLd3JSa20xRlJJaTg1T2I5?=
 =?utf-8?B?MHFnUm5hcW8wM3VOTE5tL0NvUXhNUW5LemdXRFhUOUlrbys3Q21TWFZtRVQ1?=
 =?utf-8?B?NFJ5SHJ5SDB3L3V0UDhCWGJTSVRzNEZZRGtENHR1VGltVU0vd251OU4xSjFM?=
 =?utf-8?B?WmdPRWtzZU5kMHFiK0t0cy9aeGFZRlVMZHo2MCtJaVBiVVpYbkhJanhhMDJ3?=
 =?utf-8?B?QWRGc090WDM3dVVhQ09wdjdjaGp4bHAycEtQaWpZK2Q3Ylk1bHJEMzI4Snc3?=
 =?utf-8?B?VCtua2t2b3BaYTBpWS8yd1VCQk5pekozRWdZdURUVnBwMFlsaVVmellzWFBE?=
 =?utf-8?B?S2xueG1UMUJPZVdtWWMrcCs0cE9sS1FvVDNmdm5pZk94c0QyMmUzWjhmdFkv?=
 =?utf-8?B?OUtRdVZ5WTNiZkNoTUNYYWUyVlhPYjFxaDl4UVlWS2RKTWUyQlJrSFF5ODRo?=
 =?utf-8?B?bEx2T2xyNk13akwzN04wcWtBc0twajZPa0YvMS81aHEvdnFrcHVmQ0xrYUY5?=
 =?utf-8?B?QzJLV3RBdWg1SG1LV1FTTDIrRGhoWDJjbFFOVGtBOHlERDk3VGZWMXNreDVY?=
 =?utf-8?B?UUZaRmtXMStyUzgvVytqVU9PWko4bmtFOTU0ckNmdlZpN3lvbEdnREpOM2pO?=
 =?utf-8?B?VTdOaUhhUFRaL1BWcFh2UUhoZHYwRUxtbG9TcEE4T3RHNGFFWjBFWkQ4U0dP?=
 =?utf-8?B?Z2h3RW9oOXNtbjFIVHlScWVjZmt6SkZ4d3Q4a1JjWlhObmdIVnpGTEM2WEha?=
 =?utf-8?B?Tk1kM1p3U1g0WXpKZlAvbXA0eTR1ZXNTakRBS25Ka3hYb0hvOE5pSmdWdWUv?=
 =?utf-8?B?OHU3YkxTaWZYbU5UQ3lEcWMrK1FWVFZXV3Q0Zm5HeXN6Rm1MTG44WTlLRC9K?=
 =?utf-8?B?djZSRDNzenR1dEw5MGw4OE5YWTFSMkdVUnNqSHlEcnQ0OExzN1Z1YStPdndQ?=
 =?utf-8?B?QXB3Ylo1Qi90WDVKMmVBamNiSVNnRWwvTW03a3ZOaHpUeUtRZDFSZGJiaVpM?=
 =?utf-8?B?eGl2cUJuL2xkM213bUxEUUtFWjR2OVJKN2xLTER1TE03UEdBU093WHpvbEQ5?=
 =?utf-8?B?d3hlMGZObDdhanpQcHd5VFA1MUg0UUZ5Tk4wbnpuM3UyUXp1U3UxZGlETkw3?=
 =?utf-8?B?WVFvK29xR3FRb1BPRnhIREI3QXVMKzFvaW5tdTNkN2FiSldLY01kK2dXZU5i?=
 =?utf-8?B?SHFMMlpZeGZDT3prMnF5YTNzU3JUeXdLaWVYbWY4ZzVBS3I1dzFMd28yNEQ3?=
 =?utf-8?B?T2RzWjdpbWlKSGRyNmhacFVXRU5XamdjWms4eU05UnRzYzkvbG8yYzFWeXFs?=
 =?utf-8?B?R25YRW5CMENpQkNDOWVTR2NBMDBzaVcyMWlmRGVTRldyaDNxajFod0JQUW5R?=
 =?utf-8?B?Ym40ZGhsaWxEZnJUVWdRbVMzUnN1VTgyUlMzcTI2NVJEUm9ock5GTHUybHJu?=
 =?utf-8?B?U1Y3WDJSVkdNMDBUSEpnY2xidTdFbjNnSHR5MHRqWDFZZzZKdnMvR1NFbzh6?=
 =?utf-8?B?NHpoSE4rOTNzMGkzSkhpMlA2V016QXlrbGQzclZWMDJqalU2eWIrS1dwZy9Z?=
 =?utf-8?B?YjBIbit6REZ0TXdLZFJmNTBTd2dRdkpYNTNBb3N3SkJFb21Qd2loWnc0WlRp?=
 =?utf-8?B?WUcvdTQxOExSRHZGb0cwT0E0ZmxjRkQvR28zSGZ1aXJCWGZCTk5yODVlekpl?=
 =?utf-8?B?NkI0NlA5aVpjL3FSaHNSSEpuQ1ArQUZ6NnJxQkhjK0hHaWdoZFJtWnBuZlli?=
 =?utf-8?B?ZXF6TFZRZTRDWmErV3FqUmdWOE1BUnFtLzVJM0RNWGdUdW9PQjhaZTZjdmdM?=
 =?utf-8?B?VnJ6Y0p0am1aNS85bXVyaUszVjU5RXRINjh2Zm40VHlkNS9rRmtEQVQ4cEdT?=
 =?utf-8?B?NlJHTWRpUDFhVHpSTG5qbzdtWVN2Vko4R096QTB5MG1QeGQ0K2YvSVFWUHRq?=
 =?utf-8?B?VzhUdlAyZXJSMXZkcWpqbzBiVzlUamR6RE9KeDJNK29HY1lTbTZmbVFqMDNR?=
 =?utf-8?B?ckNIczJZcGJaTHUxSnVCU3FxaTBZT1ZuY3FCSVNQOFJWclhBNVJYUmpodHc0?=
 =?utf-8?Q?0d9Ao7XuO5vRZWABYiVJLr8uj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OTZ2ODI0SGxQVmxzdkhkYU94VGkwZWJCaXRSanB5N00xTGRsbi9WUURJUUFm?=
 =?utf-8?B?MHl0aDJGeDlLWEl4eUJ3VTEybno4VjcvVkVaQS84bjlJSk4rUEZEV1dpYUtQ?=
 =?utf-8?B?dWdpcCtLcXVkK1VQcjU3REZNSjE1dnh2S2tCMDlMR2pJNUIrcWNoTVVXZTBH?=
 =?utf-8?B?WVVSSmduWFZQOFJJY2VFc2dsSi82WkxKUlFSODhCdmNvTVdhcU5WWTlza0Zn?=
 =?utf-8?B?QzNKaml5YnFrRkxiRS93bEFISmFkaldNRlVDWWdQVytRSGhobk0zbXFCZWJG?=
 =?utf-8?B?RXcwY0JyVmVjb3V5MWFEWXdITEI1MGZmQ1A2THVtRVFwYzhJUU4rVTVLc0RZ?=
 =?utf-8?B?cTdaeW1aUGF1bkVtckdMMTlSeUsxN0lrUFBkME0vamRxd1lac2VmTU1UYXov?=
 =?utf-8?B?YmRsNkVxUkVkVXpwUWQydWVsN0h0clZhYld4OGRNWDJReGtHTTIvVm14U3VX?=
 =?utf-8?B?UGYwWWptYXVJWUFiekV5RnpLVUw0N3VMR2EvRVBwVHIwQmladCt6S2JSOFg2?=
 =?utf-8?B?NkNpK1lwczUybjRwdTNsNWlEQzM0SEZmUFJSZCtyV2hBdUZrMEdVUkY3MURQ?=
 =?utf-8?B?WEQwV2c3Z0xIb1gvczhQR1B6eGNVanRmRXJ1MHpzbFVpdW9qeUN3WWp6ZXpH?=
 =?utf-8?B?U1pPT1hEZy9HMGZoYXg3Y2tyMTJsUGEzYkZ6OGd3amFwUjMxSU4yUlNKNHlk?=
 =?utf-8?B?QUZpRXlRMHZpaWMxZUN4a3JVU2NDdExqNGtHS3cwUkViMnQ5VUZSNE1zUHhE?=
 =?utf-8?B?OURVcFBIYTZzUHBnMzhhdGFoSmpoOC8xaE8rNjJqbGtvaXVUczR2dDROU3Z4?=
 =?utf-8?B?bzc1cnIzejg2VFZSSjRXTGZpckEyYnNtVTVTV2VqTFNaYzlCZGp3Mk5Uam91?=
 =?utf-8?B?c3ZpakNFdlpPeWlPUHlQcWFNaFdzV2tWWmVrc2ZaTFdBNU43VzBZWmZ3MnFC?=
 =?utf-8?B?THhJT2l2U0lBb3RFcmU3SkNSQlQ5YTJtZnRiSzlEc1JCanBESDBJOTYzUzFj?=
 =?utf-8?B?YlFjL2tiZVpNelBEbitRZmtaQ01QMnlJZEF3ajNDcGVxRTJqSDFPaVRPWm44?=
 =?utf-8?B?K3F6Mm9wMnE1WVlCbFZGenN6M3Z6TTl2Mk1rSlRHTVNqRHg5ZkhEbjhxVGxL?=
 =?utf-8?B?SFFUY0J4d3NjQjhGQmxJZkRManBLam12amlsNnNVekZCZTJQK09hUTVPZFB4?=
 =?utf-8?B?cVB2K05rejhzckFSS0J0bkhJd0lrS1RHSjZvYW1zV1pKQ2k2UCs5RHoxcFVi?=
 =?utf-8?B?VE9aQ1JHamkvNjczUzNPYVBnZTJJYTVlZ1ZUVm45QXpYRzVhdjNCcC9Pb0Zu?=
 =?utf-8?Q?Ix16g2PA98gucVG8cUC2CiloYJQoIpkgQ6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788a4b04-1474-4b6d-3a14-08dbce69fe1b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 17:04:43.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8wZ7z54N3zci6PYWklQ/6D3DRIbuoBgAJaiqFvbK9LubnKDRVOZ0nTgWJW/0Q3ojgE+66QbJ9Ce5ltnNdP2hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4692
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160148
X-Proofpoint-GUID: PORrjgcc_okSK_5cKPV7ikuebeADxiup
X-Proofpoint-ORIG-GUID: PORrjgcc_okSK_5cKPV7ikuebeADxiup
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 10/16/23 09:25, David Woodhouse wrote:
> On Mon, 2023-10-16 at 08:47 -0700, Dongli Zhang wrote:
>> Hi David and Sean,
>>
>> On 10/14/23 02:49, David Woodhouse wrote:
>>>
>>>
>>> On 14 October 2023 00:26:45 BST, Sean Christopherson <seanjc@google.com> wrote:
>>>>> 2. Suppose the KVM host has been running for long time, and the drift between
>>>>> two domains would be accumulated to super large? (Even it may not introduce
>>>>> anything bad immediately)
>>>>
>>>> That already happens today, e.g. unless the host does vCPU hotplug or is using
>>>> XEN's shared info page, masterclock updates effectively never happen.  And I'm
>>>> not aware of a single bug report of someone complaining that kvmclock has drifted
>>>> from the host clock.  The only bug reports we have are when KVM triggers an update
>>>> and causes time to jump from the guest's perspective.
>>>
>>> I've got reports about the Xen clock going backwards, and also
>>> about it drifting over time w.r.t. the guest's TSC clocksource so
>>> the watchdog in the guest declares its TSC clocksource unstable. 
>>
>> I assume you meant Xen on KVM (not Xen guest on Xen hypervisor). According to my
>> brief review of xen hypervisor code, it looks using the same algorithm to
>> calculate the clock at hypervisor side, as in the xen guest.
> 
> Right. It's *exactly* the same thing. Even the same pvclock ABI in the
> way it's exposed to the guest (in the KVM case via the MSR, in the Xen
> case it's in the vcpu_info or a separate vcpu_time_info set up by Xen
> hypercalls).
> 
>> Fortunately, the "tsc=reliable" my disable the watchdog, but I have no idea if
>> it impacts Xen on KVM.
> 
> Right. I think Linux as a KVM guest automatically disables the
> watchdog, or at least refuses to use the KVM clock as the watchdog for
> the TSC clocksource?

You may refer to the below commit, which disables watchdog for tsc when it is
reliable.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b50db7095fe002fa3e16605546cba66bf1b68a3e

> 
> Xen guests, on the other hand, aren't used to the Xen clock being as
> unreliable as the KVM clock is, so they *do* use it as a watchdog for
> the TSC clocksource.
> 
>>> I don't understand *why* we update the master lock when we populate
>>> the Xen shared info. Or add a vCPU, for that matter.
> 
> Still don't...

I do not have much knowledge on Xen-on-KVM. I assume both that and kvmclock are
the similar things.

The question is: why to update master clock when adding new vCPU (e.g., via QEMU)?

It is already in the source code, and TBH, I do not know why it is in the source
code like that.


Just to explain the source code, taking QEMU + KVM as an example:

1. QEMU adds new vCPU to the running guest.

2. QEMU userspace triggers KVM kvm_synchronize_tsc() via ioctl.

kvm_synchronize_tsc()-->__kvm_synchronize_tsc()-->kvm_track_tsc_matching()

The above tries to sync TSC, and finally sets KVM_REQ_MASTERCLOCK_UPDATE pending
for the new vCPU.


3. The guest side onlines the new vCPU via either udev rule (automatically), or
sysfs (echo and manually).

4. When the vCPU is onlined, it will be starting running at KVM side.

The KVM sides processes KVM_REQ_MASTERCLOCK_UPDATE before entering into the
guest mode.

5. The handler of KVM_REQ_MASTERCLOCK_UPDATE updates the master clock.

> 
>>>>> The idea is to never update master clock, if tsc is stable (and masterclock is
>>>>> already used).
>>>>
>>>> That's another option, but if there are no masterclock updates, then it suffers
>>>> the exact same (theoretical) problem as #2.  And there are real downsides, e.g.
>>>> defining when KVM would synchronize kvmclock with the host clock would be
>>>> significantly harder...
>>>
>>> I thought the definition of such an approach would be that we
>>> *never* resync the kvmclock to anything. It's based purely on the
>>> TSC value when the guest started, and the TSC frequency. The
>>> pvclock we advertise to all vCPUs would be the same, and would
>>> *never* change except on migration.
>>>
>>> (I guess that for consistency we would scale first to the *guest*
>>> TSC and from that to nanoseconds.)
>>>
>>> If userspace does anything which makes that become invalid,
>>> userspace gets to keep both pieces. That includes userspace having
>>> to deal with host suspend like migration, etc.
>>
>> Suppose we are discussing a non-permanenet solution, I would suggest:
>>
>> 1. Document something to accept that kvm-clock (or pvclock on KVM, including Xen
>> on KVM) is not good enough in some cases, e.g., vCPU hotplug.
> 
> I still don't understand the vCPU hotplug case.
> 
> In the case where the TSC is actually sane, why would we need to reset
> the masterclock on vCPU hotplug? 
> 
> The new vCPU gets its TSC synchronised to the others, and its kvmclock
> parameters (mul/shift/offset based on the guest TSC) can be *precisely*
> the same as the other vCPUs too, can't they? Why reset anything?

While I understand how source code works, I do not know why.

I shared the below patch from my prior diagnostic kernel, and it avoids updating
the master clock, if it is already used and stable.

https://lore.kernel.org/kvm/cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com/

> 
>> 2. Do not reply on any userspace change, so that the solution can be easier to
>> apply to existing environments running old KVM versions.
>>
>> That is, to limit the change within KVM.
>>
>> 3. The options would be to (1) stop updating masterclock in the ideal scenario
>> (e.g., stable tsc), or to (2) refresh periodically to minimize the drift.
> 
> If the host TSC is sane, just *never* update the KVM masterclock. It
> "drifts" w.r.t. the host CLOCK_MONOTONIC_RAW and nobody will ever care.

I think it is one of the two options, although I prefer the 2 than the 1.

1. Do not update master clock.

2. Refresh master clock periodically.

> 
> The only opt-in we need from userspace for that is to promise that the
> host TSC will never get mangled, isn't it?

Regarding QEMU, I assume you meant either:

(1) -cpu host,+invtsc (at QEMU command line), or
(2) tsc=reliable (at guest kernel command line)

> 
> (We probably want to be able to export the pvclock information to
> userspace (in terms of the mul/shift/offset from host TSC to guest TSC
> and then the mul/shift/offset to kvmclock). Userspace may want to make
> things like the PIT/HPET/PMtimer run on that clock.)
> 


Thank you very much!

Dongli Zhang
