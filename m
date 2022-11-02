Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C45616520
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 15:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiKBO3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 10:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiKBO3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 10:29:00 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDFE286D9;
        Wed,  2 Nov 2022 07:28:58 -0700 (PDT)
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2ENEQA011723;
        Wed, 2 Nov 2022 14:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=ZtaC+Bnd8JTj7D00iqyY3SpGJJWP/ShrulD9nBE/0kI=;
 b=UB1HiTMAJ/dv47JbfY/39Ig9LaRpnVmNqAlGrYiClE+BFnf/hXX7SCNuBTZo0nzpnDHo
 YLDjaHFUQZkm13phJIRkBeCqLCceNlMiKKlj9rLz0gSIgXffNvqWUKRwhN+4CzI7hk4Z
 T79M4RsvK3lEVBUZLTyhCcx1neXDbO/Y9OpVT3JQ6/RofIcemRT1uX4cuuwhcKGG324O
 zrqBCh7Sd9dekk80MEsVnd3zrsFNC9Szyj57WOPNKKn6v57YzwTjEUes0qdOFWQdifEd
 U7S6ardfTFlFw1azleWXsswxnuDj9GlOpx0ph9Erfq9BKMDfB8at07+ds/c7lQK3IdWv 0w== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kkt8y01cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 14:27:59 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id BEFC3804735;
        Wed,  2 Nov 2022 14:27:55 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 2 Nov 2022 02:27:55 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 2 Nov 2022 02:27:55 -1200
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 2 Nov 2022 02:27:55 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rxtw5bjzqhHV1B1SZYAGboGu1luICIWEfFCYx20xSzlSHIiHfyg4l7O6XVYD3KKEtUqHLYwMXQBj8jwnmyfjwSwnwvrqq6fHREf4RhBRGiD/UZV/dkhPKlrQF0RK1cNYy48BQ+fOzf9p8SoKnb3sDIYGJphbsHFmsa3N2Mr5Bd6L1mLPt5E45xYSOnvrraDGuW+5nfY7NcNNfemyWQL2/IVE4NgSWV9jKX4OmFz5e5fqPBGZpSFQBG67caEs3sBO7MZAWx7ZcDgeWxWMjfDQVrOo30nzmbFo0C4tpPys/AfknImj9kc9EnEJuggLZcinDCm7l4a5Hlp2xjeuYJl85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtaC+Bnd8JTj7D00iqyY3SpGJJWP/ShrulD9nBE/0kI=;
 b=ZtA/rTGkBysXU4Yy7c4gL/tIx/t5HNL38qOmVmAgKPtE/Apx1UqbEy7dCe6WUH8RapXlToYjtDi4ch/sg3DgvNTjNK7tTGyOXYGwRcNAcrTq4+X70o741VI4UIylXtI4ekDE3z6B2HW0/CmINwFTFhqH14L1uEQU7vPLpXJGpEPmw03jvzuCHtxJBtteSQFtYi0dCD7m+nQpDfc7ZHo9n7545SpyULGDHh9BKQo/kVR9IGmUfhN7VaFpzekV6ZKJIF4fB/49JQQ9EfVER00MjP1ve1vPM89w50xp/zt92zefSehdOg0rXKcV1pCKARssX2YC+5qndb7TLqS5uXyR9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by SJ0PR84MB1578.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:430::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Wed, 2 Nov
 2022 14:27:53 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5769.019; Wed, 2 Nov 2022
 14:27:52 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Kees Cook" <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jiri Olsa" <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Thread-Topic: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Thread-Index: AQHYmrCtxgDPUooKvUy7zbsHugNcO63nM6UAgAEqvoCACb+BAIAC/LgAgCJ0nwCAFLyuAIAAA7OQ
Date:   Wed, 2 Nov 2022 14:27:52 +0000
Message-ID: <MW5PR84MB18428331677C881764E615D2AB399@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic>
 <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
 <YzGlQBkCSJxY+8Jf@zn.tnic>
 <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com>
 <Y1EOBAaLbv2CXBDL@zn.tnic> <fd2cf028-bd83-57ff-7e6d-ef3ee11852a1@redhat.com>
In-Reply-To: <fd2cf028-bd83-57ff-7e6d-ef3ee11852a1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|SJ0PR84MB1578:EE_
x-ms-office365-filtering-correlation-id: dd22c144-6e87-486f-5e11-08dabcde6d45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dOFrSMpcL72OVyjUEbQEXvOe6IeMqmZCyJkLfKXj3VdlJt4N94qexpEL4cORdYZ8lf906PRPKV3N1kFSfCVhVt2owf5dYB8E/6+o+DrcZAWmfnI1bGxWL664aCSVkM20D3dWLl09FREiF27Gt/+MpQhYmhn+Bm3EPBtHLPF8anOzQnoOf9MKZOT/JDSTce6Kcu/cBXmAifeY//NteQvuwB7Hv3rGcukACCNwwOM9nJ3NGzNhYHt7a46/bgtUkr0ypZBO2vIAN/TPLCR0cYjdjsdA21MB/sYh93ZoS619VVVdZWGE8ui1kyzEfbGvR5npA/A7uXWIlw3/yxNPnDv/g+4l+4ziIT+60847pzktjblGAKZZ6rd/agVM1PtnGFxS4VfABV3X55hx6rNiNoh9OxhSVfljw3E/gachXDarJPruI027/oYnJ0OwCSXvfIfxGIKvvHypXMsowsmBwI5duf1Ov9dBVrO50CWYq7KPmYApI3h3QLKgZgscEUIwuZ1uGakf00W6g3rQ8nnxGbeDdCMbSluabfxcwRfhnrPtrS66CbO0GGYf/xWaG0lN1SI8HoDQg9oU9JJHYUWh2Ts0oKBTTNrliYyFs0wEMjD6+TEiE10/3cHkHpGJxAJzDEjqW7d9rLXgUN2qfg2zJlkuFAGFJktVV4CE3JwFplmsn5gTAvrURaxabel4QoUzuL3IxY6gsFy6zUel+ATFNO6+Xq2pd2bO8UI+Z1seeC5AeV8HPxSv2LpLBbAXgSJIqlRu4wLQyhSYtMhLKfGnKX8WuuAhZCd0eGawlc9O+1KG1/o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(33656002)(38070700005)(86362001)(38100700002)(82960400001)(122000001)(6506007)(55016003)(2906002)(66556008)(5660300002)(186003)(26005)(7696005)(9686003)(76116006)(64756008)(66446008)(478600001)(54906003)(7416002)(66476007)(8676002)(41300700001)(52536014)(66946007)(110136005)(8936002)(316002)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGEzQ3BQbXd5bFZHT1ZzQmNwcFNBRFprSVN5U3BXRXZ6V1VGcVRGY3djTzhk?=
 =?utf-8?B?REFPNUhBM3l2aW9CemxiTk1Ic1pMZkUyZmExYzhYMUc4Z0pjeU5IcTVZelkv?=
 =?utf-8?B?MCs3V0VGeG91SjNIS0pvc3VxMHQzay9YSjlHUU42dExtdWFlM3hMYWpGSE00?=
 =?utf-8?B?OWlsWGtWTXNHd1dLVFc5cGN1QXlxd0ZRUit5WC9vSWtSa0dJMmdCZU5zaXNv?=
 =?utf-8?B?Z1RCTTdSUHZXVWxPenFyU1NKSll3N1cvZHd0TW94YlFuUjFSdXc2NFRYWm5S?=
 =?utf-8?B?cXBVUUo3ZXgrb3ljNkFLWDh2Y2xRa0IwMW5GeXdaTk1PRWhsOGJHcWIwMnZP?=
 =?utf-8?B?Z1FMNklNQnZYVGJYYTBOWk9idm01dWxQOTQ5YVZ1ZEJWRnl5cHlmYmMrODhL?=
 =?utf-8?B?eVJKNzR4Mk1yWitiUk41OTNIQWMrR2U0T1lDbEVsb0lyL1VHVVIxWCtjTmRu?=
 =?utf-8?B?eHpCU2VwVjlLYWVORWQ3clhOWTYzNk9mTTVJelFMZUQ0V2c1T01UdmFVZW5u?=
 =?utf-8?B?NWhhTytqUVNtL3JWZlM3aU9nZDd2RnJuQUwvcXAyVUl4SmpVMndEZE9CS2hG?=
 =?utf-8?B?cnhmdkJtS1d0T3NhcXJiQUEweU5rdkJodFRhVDV2RlNpeWYwaG1mbm9uRnVC?=
 =?utf-8?B?Njl1WlFOMXFJLzdYcnc4T3YwZkd1VjU0NmQvQXdiQVNuZzdkQmRJN3dzQ2hQ?=
 =?utf-8?B?bnh4eVljNkdzOTRZdlVLR0EzU1VIbGRhRnE0d21MeDEraEdWdjVGdmc1bU5y?=
 =?utf-8?B?SEdiUUpZKzArelpZUFY4cGhsRjdCTlhDaDFOVXJhZ2tFRmJmbC9OZW1TMU9S?=
 =?utf-8?B?UW1tYW5vZHJMVGNqNFNzZ2daWVcwVUpvZCs2TVM2ZkRueHNtdjNRdUszZEpj?=
 =?utf-8?B?TGQ0aTAvMDBXL0tXUWpoc1VOMnNaVjhBTHBDWFVlZDA2ZVI3cHJIRXB3NEVU?=
 =?utf-8?B?bTdROEVEb0FtWHQwY0kzUUtJZEFic3BTbjZlQ0p0VG1tV3BTbWZuWmFEWWlo?=
 =?utf-8?B?ZXU2bisxZGovV1J0Mmt0VWNmcStZdHZITHZ0MUY0Zm9ENzRwN0tJNGNhc3Rp?=
 =?utf-8?B?K3Y3VnBCcUFRUnVROVdad09COVliZE1PZFk4Z3NDcXVvRmsxUnc0VFRTelpD?=
 =?utf-8?B?YTh0UDl2d1JSRE1QeDBxVXl3dlYyRzR6R2dUU1hURjFweE8wWEhKeXkvTlQr?=
 =?utf-8?B?ZlFhcTJyQm1XZStlQmpJSzdxNmV2LzlXK09CQVJTZDlXT0oxYzdUaFc1ekRn?=
 =?utf-8?B?bzI3amNrUHVVTnQxN1JQdmFUTzBpQ0plQkxBUHJMeHZ5SG1Uc2hta01WQzJM?=
 =?utf-8?B?QTRlUVRXWTZuOUx1dnVqTFR1dHhTMHJOT2g2aFVQZStLTEVCSTUycmdhOHNi?=
 =?utf-8?B?ZnlsbmtzUklJZ3lmMU9ET2lNK1NuSnJEWkp6d1NMZUhWM001T0NpRGlNYjVv?=
 =?utf-8?B?MUw5eStqYXpZaHFFeHZzc0FaM2xrNkJZMUFLbWRSai9QMXZTT25JcDAvVWFu?=
 =?utf-8?B?NGZDdkc2eFhNZ3RCSVIwVFlHbmF4Vi9MOTBCb1lmZEFCVmsrM0ZHTW55d2lj?=
 =?utf-8?B?OHJCT1NDS2JiWTgybjVWOVlHRlc3d0xiVUgrajQwOTVHTHhXdTIyZVZxdlJ3?=
 =?utf-8?B?bWZCa3k0UTFxWTlRcG1iazJUTGFTRVJBbWxjdjJ1RTloZENHWVRiaE54dzQz?=
 =?utf-8?B?SEdiOHc1bHpKLzF0U0RCSHV6WDhFMWpjekF0Y0FWL0JHK3JBTWxBVzdQekxl?=
 =?utf-8?B?bks2dG9GR0NiZWRZd0tGVzg1U2N2MFFHYjN0OHIvN0ZFeTE4NUl1SWorSkd0?=
 =?utf-8?B?VUFiS2MrMFMySDJBa0g0SjBJVU1CM0tOSUV3ZEo0S0FvWHhxUVh3WlVGL2dR?=
 =?utf-8?B?d0JjbmFRdDYyMm5YMzRwYnc0L2ZLdXFoNGpuVnBRN3VqMThwOTVzMEFQY0hF?=
 =?utf-8?B?UVB6VWViV2M4V1JVZUk5NHR5QWxaVUZNd1g2Mlhkc0lWb3VqdFB2cGFMbEpx?=
 =?utf-8?B?d3ZYeHoxZVhBa1owWmxscHhwVm9RcG9KdVFGbWg4UUl1THA1anhxTDhiOTlN?=
 =?utf-8?B?eUIwd2RpS2VBWGl4c2pRS1k0Z0ZsTkloUUJhRkIrQUJkenUwck9XaEw1djMv?=
 =?utf-8?Q?MjKY=3D?=
Content-Type: text/plain; charset="utf-8"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dd22c144-6e87-486f-5e11-08dabcde6d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 14:27:52.7734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Qn3U7FZYfx8pRgqmAbzEcz0RcJahCcYs67RffWpPd+9kYVr7wWDxvPEBFRqwEz9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1578
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: _o5McNuPrwd_PzppleRRxqQRaC2ux0ul
X-Proofpoint-ORIG-GUID: _o5McNuPrwd_PzppleRRxqQRaC2ux0ul
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_11,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 adultscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020092
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IEZyb206IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQouLi4NCj4gKDIp
IGluIHBhcnRpY3VsYXIgaG9sZHMgZXZlbiBvbiBiYXJlIG1ldGFsLiAgVGhlIGtlcm5lbCBidWcg
aGVyZSBpcyB0aGF0DQo+IFg4Nl9GRUFUVVJFX0FWWCBvbmx5IHRlbGxzIHlvdSBpZiB0aGUgaW5z
dHJ1Y3Rpb25zIGFyZSBfcHJlc2VudF8sIG5vdCBpZg0KPiB0aGV5IGFyZSBfdXNhYmxlXy4gICBJ
bmRlZWQsIHRoZSBYQ1IwIGNoZWNrIGlzIHByZXNlbnQgZm9yIGFsbCBvdGhlcg0KPiBmaWxlcyBp
biBhcmNoL3g4Ni9jcnlwdG8sIGVpdGhlciBpbnN0ZWFkIG9yIGluIGFkZGl0aW9uIHRvDQo+IGJv
b3RfY3B1X2hhcyhYODZfRkVBVFVSRV9BVlgpLg0KPiANCj4gTWF4aW0gaGFkIHNlbnQgYSBwYXRj
aCBhYm91dCBhIHllYXIgYWdvIHRvIGRvIGl0IGluIGFlc25pLWludGVsLWdsdWUuYw0KPiBidXQg
RGF2ZSB0b2xkIGhpbSB0byBmaXggdGhlIGRlcGVuZGVuY2llcyBpbnN0ZWFkDQo+IChodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMTExMDMxMjQ2MTQuNDk5NTgwLTEtDQo+IG1sZXZpdHNr
QHJlZGhhdC5jb20vKS4NCj4gICBXaGF0IGRvIHlvdSB0aGluayBvZiBhcHBseWluZyB0aGF0IHBh
dGNoIGluc3RlYWQ/DQoNCk1vc3Qgb2YgdGhlIHg4NiBjcnlwdG8gbW9kdWxlcyB1c2luZyBYODZf
RkVBVFVSRV9BVlggZG8gY2hlY2sNCgljcHVfaGFzX3hmZWF0dXJlcyhYRkVBVFVSRV9NQVNLX1lN
TSwgLi4uDQoNCnNvIGl0J3MgcHJvYmFibHkgcHJ1ZGVudCB0byBhZGQgaXQgdG8gdGhlIHJlc3Qg
KG9yIHJlbW92ZSBpdCBldmVyeXdoZXJlDQppZiBpdCBpcyBub3QgbmVlZGVkKS4NCg0KMS4gQ3Vy
cmVudGx5IGNoZWNraW5nIFhTQVZFIFlNTToNCiAgYXJpYV9hZXNuaV9hdnhfZ2x1ZQ0KICBibGFr
ZTJzLWdsdWUNCiAgY2FtZWxsaWFfYWVzbmlfYXZ4Ml9nbHVlCWNhbWVsbGlhX2Flc25pX2F2eF9n
bHVlDQogIGNhc3Q1X2F2eF9nbHVlCQljYXN0Nl9hdnhfZ2x1ZQ0KICBjaGFjaGFfZ2x1ZQ0KICBw
b2x5MTMwNV9nbHVlDQogIHNlcnBlbnRfYXZ4Ml9nbHVlCQlzZXJwZW50X2F2eF9nbHVlDQogIHNo
YTFfc3NzZTNfZ2x1ZQkJc2hhMjU2X3Nzc2UzX2dsdWUJc2hhNTEyX3Nzc2UzX2dsdWUNCiAgc20z
X2F2eF9nbHVlDQogIHNtNF9hZXNuaV9hdngyX2dsdWUJc200X2Flc25pX2F2eF9nbHVlDQogIHR3
b2Zpc2hfYXZ4X2dsdWUNCg0KQ3VycmVudGx5IG5vdCBjaGVja2luZyBYU0FWRSBZTU06DQogIGFl
c25pLWludGVsX2dsdWUNCiAgY3VydmUyNTUxOS14ODZfNjQNCiAgbmhwb2x5MTMwNS1hdngyLWds
dWUNCiAgcG9seXZhbC1jbG11bG5pX2dsdWUNCg0KMi4gU2ltaWxhcmx5LCBtb2R1bGVzIHVzaW5n
IFg4Nl9GRUFUVVJFX0FWWDUxMkYsIFg4Nl9GRUFUVVJFX0FWWFg1MTJWTA0KYW5kL29yIFg4Nl9G
RUFUVVJFX0FWWDUxMkJXIHByb2JhYmx5IG5lZWQgdG8gY2hlY2sgWEZFQVRVUkVfTUFTS19BVlg1
MTI6DQoNCkN1cnJlbnRseSBjaGVja2luZyBYU0FWRSBBVlg1MTI6DQogIGJsYWtlMnMtZ2x1ZQ0K
ICBwb2x5MTMwNV9nbHVlDQoNCkN1cnJlbnRseSBub3QgY2hlY2tpbmcgWFNBVkUgQVZYNTEyOg0K
ICBjaGFjaGFfZ2x1ZQ0KDQozLiBTaW1pbGFybHksIG1vZHVsZXMgdXNpbmcgWDg2X0ZFQVRVUkVf
WE1NMiBwcm9iYWJseSBuZWVkIHRvDQpjaGVjayBYRkVBVFVSRV9NQVNLX1NTRToNCg0KQ3VycmVu
dGx5IGNoZWNraW5nIFhTQVZFIFNTRToNCiAgYWVnaXMxMjgtYWVzbmktZ2x1ZSANCg0KQ3VycmVu
dCBub3QgY2hlY2tpbmcgWFNBVkUgU1NFOg0KICBuaHBvbHkxMzA1LXNzZTJfZ2x1ZQ0KICBzZXJw
ZW50X3NzZTJfZ2x1ZQ0KDQoNCg==
