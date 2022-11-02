Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC08616DA6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiKBTQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 15:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKBTPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 15:15:51 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BFF6150;
        Wed,  2 Nov 2022 12:15:50 -0700 (PDT)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2FaqBa000397;
        Wed, 2 Nov 2022 19:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=PAQ+3XaWZ2xgyUZ9V+RKt3oPmRZJZ8g6LIHYupfoehI=;
 b=RNfdQ+BPecVoKucwehiuTxBRfz1iE/3S/7wm/0E/TaPEaeDiN+4fTMdgKPhcjn+x2Zr5
 daFLEa/Q05rqNIGT/Qq4oQm/IMYgH4r1b7s0Y/RajgjF1NW4bs4ZJOJB1fIApbPjjkr3
 TpZRsZMdpM6BmyXu6p0R5zStym11HefbQwlBtMUNEzTQj7NfESrcf6RdGNaOtqgKHiHC
 krfLr5k4Mazoa46ggnokn0kEN1rxYBNd/X+FTZvl6PY6jn8waElTpT9vOoE7rfSFfddK
 ycFNDhA4DTbXRl3/yQVEAxy4RbIwv12H/jSGDDcjFcIeppAVVUSTno7hc3jMnw2rXlTk FQ== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kkmhxnqu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 19:15:17 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 61B4680473A;
        Wed,  2 Nov 2022 19:15:16 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 2 Nov 2022 07:15:01 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 2 Nov 2022 07:15:01 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 2 Nov 2022 07:15:01 -1200
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 2 Nov 2022 07:15:00 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNoQQ/VGVMmVgsIshnxTEOTAG8KwNHqZ9iBOs5nkKFE53N5dSBRa9vlXNL9tURlVZsZQSM7vwJOZXXTortPeS9AfD54F4dr4Kwgu4aM7Wqmc1gp6n6/49hgUo8j63tEmdaUE4EsLtohwDeHxJqpYK8igCLD036kpKyF/4ZeTBTgPhUCjlScJSxwPImSmVvzRvsmG/FlToPbf3I1TxnRwsOS1gSSbVX1khWYOzZi5/rHclv+kDShva3PxatG9pv+1k4mENcFjXY4MK5+abp1DG2ojMAdluRXSf16nyEy/YNG+B01ot5lj89bXBWqM4MKlpGS/UmZivOJ//MSu4/8KQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAQ+3XaWZ2xgyUZ9V+RKt3oPmRZJZ8g6LIHYupfoehI=;
 b=KXXRNbRJus3TlwjikoevDCgXX8MvJvnrudarKOXWiFk+MT6eHuuz3+0NgvM6kgsy97UdI2hn0bEhUbVrLNy0pUk+M7VSGm/sayMCtyBfzYSiuChz2a9WIV+iHSIk/DimtJIBIOZ2XzospZdwK/7AWdBlzZGC/OfD945Sjfobjgs0VMUYSCBw9e2ev0Hgye3ZJcursFBVsOrYit+GxtbTM0udhAMUi7ibBsq0EDcPcxVxMtMjCVh2sGA6Eo8cC5wcNIHb6XqbRmumTc5lh57nv2GW5ouM+AZkzfDZNqOyE+cDaQlpyqrmfcY8IfHKSlAbD3oUqIDfGcfKPXgd/WY05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1663.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 19:14:52 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5769.019; Wed, 2 Nov 2022
 19:14:52 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Tony Luck" <tony.luck@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Thread-Topic: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Thread-Index: AQHYmrCtxgDPUooKvUy7zbsHugNcO63nM6UAgAEqvoCACb+BAIAC/LgAgCJ0nwCAFLyuAIAAA7OQgAApwgCAACBpAIAACipw
Date:   Wed, 2 Nov 2022 19:14:52 +0000
Message-ID: <MW5PR84MB18428E61A6F65FFCA1749FEAAB399@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic>
 <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
 <YzGlQBkCSJxY+8Jf@zn.tnic>
 <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com>
 <Y1EOBAaLbv2CXBDL@zn.tnic> <fd2cf028-bd83-57ff-7e6d-ef3ee11852a1@redhat.com>
 <MW5PR84MB18428331677C881764E615D2AB399@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <EFDA4E40-4133-4CED-97FA-DC75AEA24556@zytor.com>
 <B5ECAF37-5B38-4B6C-83AD-E49885B2A5B6@zytor.com>
In-Reply-To: <B5ECAF37-5B38-4B6C-83AD-E49885B2A5B6@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|DM4PR84MB1663:EE_
x-ms-office365-filtering-correlation-id: 30e682b7-e4c0-4da8-f6e0-08dabd0684da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGvPssmhYIprCNcHDYE2E8uuhKGCAb36031yTfZmvsR/BnFE1kMy7aDKEf0rS+zfW2Zkdg2VLyshWyG01TnTwRd8SZyjY5AdMaOPMiINbn2vhf++pAkUO70NWcYchGPlleO+13dfc60ryF8TKglg58poMFp9kKo9W0s658ejpc22idLUYMq2kVSvcsdo4d1ZvyAnlbn5mptW92Qrsj//EQbmGMHprPxRt4jCMjQ9JIiZPJ3ZaUMaJVZyIfWJ0y0u2SzLfRLvGKc8P3ywgySxakycQHmiCMj7lAw/cqwAmvxGP/9z48nT8fC71g0fx8qgJEuq/+a9SEJKpQjPPs/CUB25v6vR63mN6lH9nMWa5R6K8+6fFb2x0kwtgQ/UGe0C32mQbkZmehxXbJCHsP0wtMXpRXePcvKD6DA5gKGsbTZrEktCTU8JNezZOuH9KBqghqceCEVqODshOAtHZvalexf0P7SqbUF011sJ900knamUYvR4wYdBwLGNQ6yR7pb0ZIZulQMAjR+g4sOur+abQxZzeLfzvc7dNtYnbNXeGMkL6IAS1VPp+647CZlwFBYlMN95qbkxey7w1LLR4O+lWl0qJw5ZjgBpsO6DVjaeWxXuFHlA9zFY/F49DbzZAQe85p407li/J/M32NP4KV1xsZHpPMV2bdwT0984wO+R2k0dee7VZwfi9GBOLcZcoAKY+ICbOfapGcPpWJSMkDIq8R0VTtRJBk8D2h55ZDJZsFy2zlo+3xEakHKEAkbvh3xI0gf5ecQ4az8BW8p1OyfHJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(76116006)(54906003)(66446008)(66556008)(64756008)(33656002)(316002)(186003)(86362001)(110136005)(8676002)(38100700002)(8936002)(41300700001)(38070700005)(122000001)(82960400001)(52536014)(55016003)(71200400001)(4326008)(66946007)(2906002)(5660300002)(7416002)(6506007)(83380400001)(478600001)(7696005)(26005)(9686003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nkg0VG8xNVo0b0lRWDdxcWQyVEFCdUxQUWpMZS9iaWpTUVJGbEQ1UEtTNFpv?=
 =?utf-8?B?d0xkeFlSUFhoSlFpQWgvV041QU9UMnRaaloyOGkvdDV5T2YwL00zbjQ1TzJC?=
 =?utf-8?B?NTFGYXFReGZqbVBYNXFGSldzNmQwM1hzMjQwZ0E5OThsQ2krLy9LWHpiL0R5?=
 =?utf-8?B?UHpHZU1KS25YYUVKQWlQWHcwN2hSbUFyRGYwYm5mcXFLZ1J6QVFqN0NvYzNn?=
 =?utf-8?B?NWVsWEVMR0tJaXZxYlF3WHBrREZxK1pmN2FyQVFKODNZUWs2Ylg3YWEyQmFz?=
 =?utf-8?B?YVlJVXhBVEVlaVd0UjhRVURDY25xeEJRRFJTak5lK2hBT29ISzFOZzIvQVcy?=
 =?utf-8?B?bzdJOVNqb0FKWmxYbXpMbDlxS2FQZGp4bVMyM0hhQjR3dW9oWHU1NWdFd2lt?=
 =?utf-8?B?M29id3JSdzgzbTNMajhkMFBYd3U0TWcwWVBmVW0wYS9udHBUWVIzN3Fadzlq?=
 =?utf-8?B?UkoxQ0JxYm8vUUhHbG91MWRxeEI4UXl5cytrU0l5ZWFMZ1dtbGVxWUJ0WW4w?=
 =?utf-8?B?Mzk0ZTF1ZnlhaldZcndPM2pwNEJZNVdkdkk2NmV3MkQ4Y0FISzh6aHd1YTFB?=
 =?utf-8?B?REVQREltdzQvbFVhQ0YrZXhDc2NPMlhvbnV0WUFxNFBrc0xXWmFJMG1QK1A1?=
 =?utf-8?B?TDRwcnFNS0FZVjFrcUFLMUtkNXNla3UyckxHZ1RFNEk3a2ZJS00vV0NWakxw?=
 =?utf-8?B?MWlHemdDajVOdmJNYVFNbE1ERGVPSnM3OFBkV2MvRGNqa09UekFtcTJOMDFU?=
 =?utf-8?B?b0h3STFIYVc0NnVja0FJS053K01NWkN0eGlKeHlLUk9DUzRNUTk2eG1SeEYw?=
 =?utf-8?B?WG9XMnlBZ2hkKzJ1eUVFUDhzbmhoeGxNRnNrcFZNN3luL0kyUW1CWWFNbzl4?=
 =?utf-8?B?MkdjT0VzU1ZZL3RjaFhUbDVUbnFPTmE1dzlyaC9uZWY1a1BrTUltdTAwYndi?=
 =?utf-8?B?QXhPekVjWWUvRHU0OVZlbmlDQ3hqV1RlWnVqS2Y1eXNZeXJ1V1doS3V5NEhW?=
 =?utf-8?B?eW91TnRQd0pVRGdCd2gzdHBhVUJHNTNRWFoyQitzZnhza0JXVDR5K1JQUlFB?=
 =?utf-8?B?b3gveXM1TE5MQnNYbXdDbElWcys1UWVlak04SXhnM1I1SVgzVmYxK3hiU3Ay?=
 =?utf-8?B?Y05OSi9Jd3VFWUJoazRjdnBhU1pZRitBeGptd1l4K1o0Q3JWUzJZZENhYjVF?=
 =?utf-8?B?aDdZSGhJUm1vbkdNMW52UzlSZnRZQUtiKzR5MVFGK0RjbmFmdkJmRG5EQm1s?=
 =?utf-8?B?L0UyYjVwWGRqVFczeW9yVUxqTHNZUGJWT2RtRWdISWpUdks5dzkrRGJ1ZWZF?=
 =?utf-8?B?QWlhbHJINlhRYWlUU092TDdzaVJ6TTBhcEN4YWgzczJmK3hjcm90b0xqQWRC?=
 =?utf-8?B?QnR3dWFnSHRjVkpXYjA0WnNIbTVXVmV5SEgvV0pyMzV6RVpwMjI4bjMyYWY4?=
 =?utf-8?B?dXh4T1d1bk9lR1hQdnNpNklXaEhVS0RyRnFqSTEySjdpRTZhbHpWUHpIYUVM?=
 =?utf-8?B?L2tZcDI1M01IQmxBbWdGem03N2NLNkE0ejBYY2V3eUQ3dTF6WldCajRLYU9o?=
 =?utf-8?B?bTRVVTFNOGZ5TlJvdjlQdmlDakpJRUJlOHYvSERPYUpSODAzalE2cVE1d3Ja?=
 =?utf-8?B?WjcyczNGYSt4ZzlIeFlFWHRtWHVQUENVV2tNTkFvbmR4QzkyRXQxVVZOUWVL?=
 =?utf-8?B?Ymttb0M5ckpUVDJTK0JIZFYwSFQrVTUvRFp1S3lJcy9UbzUxeHBYeStQRVd1?=
 =?utf-8?B?bXJkMlJTaXNMaTdHZFZ0YjE0L0I4Z2F3TjVLWUlrekdoVEthbHJDN1JHdC9Y?=
 =?utf-8?B?Rk0rSjZsS3ZBT1JZbGs3SE90Zkc1RkR2NHl2bFI5OTFiUTBDZUV3c0hIRTk3?=
 =?utf-8?B?K2xmbEY0cWVPY2ZMNmJtRC9RM1lkcXgxVXN3RWd3UlJ3Y21tMGVDQy8rNXB6?=
 =?utf-8?B?cVBlUkx4S1NkZDRmeHpZMERIbDBzVHZOd3Z5S1A2RU4vTHdoVklsTG8rVDY2?=
 =?utf-8?B?Ri9uakhkSEIyOXJKN3BJYkNXVXNqakpRamh2QUNCMHAwSWxGak9zM1Jwc0Nh?=
 =?utf-8?B?NWdacUgzbXQ4LzRxNVhTemk0bkpOOVlhYjBzcDZMOUd0SUlVdG1WK29obFFV?=
 =?utf-8?Q?qoGQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e682b7-e4c0-4da8-f6e0-08dabd0684da
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 19:14:52.2116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WTcR6fVNgKb85SBhwy9m49tbYS2oXNnMhibfXsj6LwdJGPS6+bS9NyPUnMeEANJ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1663
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: dlkhZ30QaIvjcQ8l6LQKvWqrduK-F-Mv
X-Proofpoint-GUID: dlkhZ30QaIvjcQ8l6LQKvWqrduK-F-Mv
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_14,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211020126
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID5XZSBoYXZlIGEgZGVwZW5kZW5jeSBzeXN0ZW0gZm9yIENQVUlEIGZlYXR1cmVzLiBJZiB5
b3UgYXJlIGdvaW5nIHRvIGRvDQo+IHRoaXMgKGFzIG9wcG9zZWQgdG8gImZpeGluZyIgdGhpcyBp
biBRZW11IG9yIGp1c3Qgc2F5aW5nICJkb24ndCBkbyB0aGF0LA0KPiBpdCBpc24ndCBhIHZhbGlk
IGhhcmR3YXJlIGNvbmZpZ3VyYXRpb24uIg0KPiBPbmUgbW9yZSB0aGluZzogZm9yIG9idmlvdXMg
cmVhc29ucywgdGhpcyBkb2Vzbid0IGZpeCB1c2VyIHNwYWNlIGlmIHVzZXINCj4gc3BhY2UgY2Fs
bHMgQ1BVSUQgZGlyZWN0bHkgYXMgb3Bwb3NlZCB0byByZWFkaW5nIC9wcm9jL2NwdWluZm8gb3Ig
bG9va2luZw0KPiBpbiBzeXNmcy4gVW5mb3J0dW5hdGVseSB0aGlzIGlzIHRoZSBydWxlIHJhdGhl
ciB0aGFuIHRoZSBleGNlcHRpb24sDQo+IGFsdGhvdWdoIGZvciBzb21lIGZlYXR1cmVzIGxpa2Ug
QVZYIHVzZXIgc3BhY2UgaXMgYWxzbyBzdXBwb3NlZCB0byBjaGVjaw0KPiBYQ1IwLCBpbiB3aGlj
aCBjYXNlIGl0IHdpbGwgd29yayBwcm9wZXJseSBhbnl3YXkuDQoNClRoZSB4ODYgY3J5cHRvIG1v
ZHVsZXMgdXNlIGJvb3RfY3B1X2hhcygpIHRvIGNoZWNrIGZlYXR1cmVzIGJlZm9yZQ0KdXNpbmcg
dGhlbS4NCg0KSWYgdGhhdCAob3Igc29tZSBvdGhlciBmdW5jdGlvbiB0aGF0IHdlIGNoYW5nZSB0
aGVtIHRvIHVzZSkgcmV0dXJuZWQgZmFsc2UgDQppZiB0aGUgbmVjZXNzYXJ5IFhTQVZFIGJpdHMg
d2VyZSBub3Qgc2V0LCB0aGVuIHRoZXkgY291bGQgZHJvcCB0aGUNCmNwdV9oYXNfeGZlYXR1cmVz
KCkgY2FsbHMuDQoNCmFyY2gveDg2L2tlcm5lbC9mcHUveHN0YXRlLmMsIHdoaWNoIHByb3ZpZGVz
IGNwdV9oYXNfeGZlYXR1cmVzKCksDQphbmQgYWxzbyBoYXMgYW4geHNhdmVfY3B1X2ZlYXR1cmVz
IHRhYmxlIGxpc3RpbmcgdGhlIGZlYXR1cmVzIG5lZWRlZA0KYmUgZWFjaCB4ZmVhdHVyZS4gUGVy
aGFwcyB0aGF0IHNob3VsZCBwcm92aWRlIGEgY3B1X2ZlYXR1cmVfdXNhYmxlKCkNCmZ1bmN0aW9u
IHRoYXQgY2FsbHMgYm9vdF9jcHVfaGFzKCkgYW5kIGNvbmZpcm1zIHRoZSBhc3NvY2lhdGVkIHhm
ZWF0dXJlcw0KYXJlIHByZXNlbnQuIFRoYXQgd2F5IHRoZSBsb2dpYyB3b3VsZCBiZSBpbiBvbmUg
cGxhY2UgcmF0aGVyIHRoYW4NCnJlcGxpY2F0ZWQgaW4gMjArIGNyeXB0byBtb2R1bGVzLg0KDQoN
Cg==
