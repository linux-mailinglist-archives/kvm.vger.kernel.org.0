Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2033D521E0B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345644AbiEJPWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346121AbiEJPWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:22:11 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FA9193C2;
        Tue, 10 May 2022 08:04:56 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AB9tYf004892;
        Tue, 10 May 2022 08:03:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=3UfXwDqAa2QHcTkeN73RiILOw+q9GiXQ4k3nbhbugLs=;
 b=frP/XfTRs2Hc+geDWaJ2lsnXsxnZRfqUwIQcgqn4nw8Irxh9nqqOLS/+kWN0X+KcG+xr
 sSIdXtjxp9Op9L7d+6juoVGHRBC078G+mPv1WQXD1Sd412asZRaGGQqrZQRx0SLSMUCg
 OgVgkE+n6kflkEU1p2dKCXhCze6mo828PTg/nzJiDWBAaZ7Nju8IXipd/O5PcNIKJ0ag
 5ozQltESmu9fT5LiGuwB1GVLuV//o6Hm4oupb0w4hQF737VnNKVwLUGMcuySKC69uni3
 Iva8Us6dTsj/BANY1cRIbve0nSt+l/LsPPRFG0ZnVvjzcb2aJ6pCceheKmCwQRLevLEL aQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fxyxm36mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 08:03:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkyfC0bgjgpi3FutU3uj+4aT0Awl6Eu/AWKA8HXhmQbaYnSXEUx13QBt+hbaoqUU7lnYwuBmB08e0aXwuDvRIc0v03St/8AVk+/3UeI8KVlwobB+pqGoVf20ob2AbEadknwDlsrg2xnIzDPECn5BfHni3VpviJZnyRBzndQoidHLp8E+PpCZscJBLVK0g16qzxocAd9n8GdfNZf+rPpP3n31DR/iTWV9XCSR2YHJfNLoeofSX2En1Q/mTCvx2RIcMBt6QEiTLYfVn/rJvOn9dXbQyC0CqMFgmbDtCR5w2RifODqw6+WDVPjO+8zc1JRm1QT2BIrkrhX9Tt+HP83fIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UfXwDqAa2QHcTkeN73RiILOw+q9GiXQ4k3nbhbugLs=;
 b=SOh0R3r3zcOn5pKmtND4RaBvWclLxbSldSuZb+OqKQqfr/4eAPCVWA/9OZnKoZmnuElJCmgoRUXP5zcURkv5ks/LjwozFIu5LTD7MHoY4xOTnTm/TzDGVXdlnyQhUX3NEXk+4LejpjukG90qr/Qb4J3cIoLufdqDF64Q8HpYI0rM23AZMP9AIBiLyT1wF0eWsP3r+PflwD+nsWd2pBwcOHrD02Z1HR0bDRfawpSbHpA7g6E4AKkla7BCI/1RJUwld1TT4I9R9NTmWBXfYZ1iTsgOd0q8iy2cAhLH4XSPTWOWoS5+3n7+WhW3MXGsHS787qJm0HJU8n4Lh4VfyPDTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BY5PR02MB6385.namprd02.prod.outlook.com (2603:10b6:a03:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 15:03:32 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 15:03:32 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Borislav Petkov <bp@alien8.de>, Jon Kohler <jon@nutanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAAD+oAgAAIS4CAABD0AIAABkcAgAARGQCAAK85AIAAU8oAgAAV5oCAD5/VAIAABTSA
Date:   Tue, 10 May 2022 15:03:32 +0000
Message-ID: <520D7CBE-55FA-4EB9-BC41-9E8D695334D1@nutanix.com>
References: <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic> <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic> <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic> <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic> <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
 <Ym1fGZIs6K7T6h3n@zn.tnic> <Ynp6ZoQUwtlWPI0Z@google.com>
In-Reply-To: <Ynp6ZoQUwtlWPI0Z@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbbac5df-40f2-49a1-b6ce-08da32963ff7
x-ms-traffictypediagnostic: BY5PR02MB6385:EE_
x-microsoft-antispam-prvs: <BY5PR02MB6385E7F899B8CF8EDEBF37ABAFC99@BY5PR02MB6385.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6HJypx4t1M9otBYuqcGrupTpSz/zvs8UzAF2n/XEMEKLgTKAodsqHBM7U97hvDj+NrouLIkDYu3Z795pkVpC6ebcoraUKsSlnXFick7yhgCsp2o3pVsqCq8wosi4KznEZGdVz/CLjKnAxBamKAOV+i5zAq88zfzy6fkmbbEbhDy5SXV7A/ZxI7+qlg23OigG+86hGzw/jqCXsHML99FUrILy7t00GrsXN958oPSgi0nEjDYBfmteiMcx42NYC3xB9FfUOSPW7Zlb/FDV+kH9ev8Aa+69FpzbiDcpqbwtEaG3xu6q2lW3Gusj6QYSxcwBZzSlJHSlnFmeubjsMFHE+ddEMd+GuG0L4Pnef/OzTfI0Xnd3NT+pzyTVwMmERI2XBOx4HQWOaDjfk7YHoSQeX/uHmyOxTtkZl+P9Lef1YChmqQrIINH73/xSOGTBLnStlPyYDocuIQXP1GW7PtkzLnKK5htdOp5yA0cgcay4+FE1zW4/YoUoUqMi8YusC9QXinFz8CEqbdWeNWJPHLD4Skalz2K1S/dBiPt6Yea/kLs2kE6elRnjPkF74sILgPfelwGjf8i5k/p2c8bdA6hMBoCrcg01jMXIHjSCid+siUd2ycob9DpVRU9O/mQaj027qu82eAXs/L67imPC+gYA/FPhESJJUDN5mVfmxOrQ+d6103vWvbQx9dBCJfUdtQlGzqgW+momKSa2thuSd5uwzCDWhXU7uOrSd11dwiIJbjBUjJ1IAmbnC0l3MdWD5yQr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(122000001)(6486002)(36756003)(2906002)(6512007)(5660300002)(7416002)(4326008)(8676002)(8936002)(186003)(66556008)(66476007)(64756008)(66946007)(66446008)(83380400001)(38100700002)(6916009)(53546011)(38070700005)(316002)(508600001)(2616005)(86362001)(54906003)(33656002)(71200400001)(91956017)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjFzS0ZEMFpJRjExSzM0ZFMvTW0vakZvZmJDQ2hLZzdMci9zZ3ZveERaTWI5?=
 =?utf-8?B?RHpOcTZiQUd1QXFTUVp4TU4ya3gwOE1KdGdaekN1VUs0RHl6WDYzcTBCeHU4?=
 =?utf-8?B?L1JXVTF1anZPcXhJdll0alhCUjJnU3RrNEJhWHZQOWRPS3pHRnNDZDRCalNy?=
 =?utf-8?B?OXVwbTVaY0djM3FPOC84UkN3SjhYRWx5QU9yTDhnak5DQm9GNit2QWxxRlpX?=
 =?utf-8?B?cXpyTmhudlBadFJLSHN2ZzNNZTltaVdoN1M5NDl0K1NUWXI5dkpsbndTbEd5?=
 =?utf-8?B?UUV5MFkxU3k0amFqSE1LVkd6L0JuWXg3Z2JrSEFhakFmQnJYaG5RTENSMzFa?=
 =?utf-8?B?V0YrLzd0Nm5FS2Rya1lkelFIVis4RHFQdk1YdGFTN1M1NCs0U3lNMWZvM2dK?=
 =?utf-8?B?dG9veEtCN1FsekJVN3ROMGcxUkI3VGZZTi9pd2pVOUgycUJaQW14bzBlNHhW?=
 =?utf-8?B?dG1aQVg1Q2x3bjVMMDNQY1pkaEZmZnd0WVMvMCtacWZQZzR1K2dOOVB0cWFh?=
 =?utf-8?B?aVhqclI4YUNtZGJaanphbGRsQlA1SkZaN3JKakYzT3pXOEpUclJ0cFExVHhV?=
 =?utf-8?B?TTJKTEMzaVhCdWFZRG9YMjFmU2Jha1MzZHZ4bE9BVHdZNjJERTVMM2RKd1NE?=
 =?utf-8?B?bzJpSTAxbzE3bjBUQmc3UEhxOWJWTlZ2QlhQcDI0V25IRXU0MXhaREdPam9p?=
 =?utf-8?B?cndjUWZ4NUxiTFNhNTlySlYvWmxLNXN2TWlidEdKWmNOK0ZrMHBVZmRqTlZC?=
 =?utf-8?B?NVZ4RVl6ZkN4L01idDI0UjBDQ1l0SmpEd0hVbHdlL0JMN05lV0R5YmJaaks2?=
 =?utf-8?B?a04zejJHZHA3WHZhenAzWTlxQzExVlZneFNlaHQveCtnQUlHc3IxUXY0a05h?=
 =?utf-8?B?QTJrRy83eXlpdTNMaWZ2RjRoQURYS25WRXRRK01VTmNoU0h0NytJLzYwZG5T?=
 =?utf-8?B?ZmFHU29YZ1FmWll4NDhXanI5b3dLYVVBdFpDeW5qZlZvazJPeXhtNERvdnZp?=
 =?utf-8?B?OU9zVXpweW8ybTNsdEkwSklIaWJKRlBkV1YvNHhqRkVuWkswNU1QNjE4TzJR?=
 =?utf-8?B?Q0xpNWlQV0RRK281V2ZSb2VRZzdhK0RyNnVOYzgzK1kyanpQZk8wWFMwa0FV?=
 =?utf-8?B?cVVXTmwvTWtVWkYzdXRWNVVTTGRscnRtaEY0WFNHa3JzT3NPZE8zR1p5K2tz?=
 =?utf-8?B?TTU1bTZDZEVUdHh4VnhBemtTbUI4Zndsc2VOdW5LU2Q1N1ZZblFIVEpPZ1o2?=
 =?utf-8?B?b3RNVjBFUWJFUDhWenJoMmNTQkt3cmVFUGNGaVVJWS9FRDZwYVluNjZUbDEv?=
 =?utf-8?B?WGFUQUduMExmVUlldDl0bVo0a1NwV1pwcjJKSnY3YnJsc3dvZzk5ZFhMRmE1?=
 =?utf-8?B?alRMZ1ZuSHN5QzN3SWlHajVNZEdGR2FaYXErdWxDNjBBbWtlZ3BzYUZlak8v?=
 =?utf-8?B?S0FFWGpOQkRXUDZYVDRjK0grWUt0aTZ0ZVJMQzRIQUlMcC85bEp0bit6c3RD?=
 =?utf-8?B?Q0JoYkpyZ3FGdUtuTlJDUjlRdjFHNE10cVByOWpSYTBXSDNKbVhvTm9lUVNB?=
 =?utf-8?B?S0FzVmZoNnQzMVBQK2JCcVdXT3ptNVFCNjVVTnk0aS9oSGdUaGxrNDJBbzZE?=
 =?utf-8?B?b2Q2NWNMTTRmOWhxWTQ2eFFXVnNJcm4rT2NGeWxXa2RLSVhYL3ZKZ0FsalE1?=
 =?utf-8?B?V0RjREs4cVpSSUVya3J1Tk11UDdBL0g1eWFDZGVFWWg5bitQM0JRRExuQjY4?=
 =?utf-8?B?bk9iS2UvVW1MQ3cxZEZqV0V6bTlxcTRoSk95S0djS2dKeHNkZTdvUElKL3ha?=
 =?utf-8?B?dUxaclR0eUVHbDR3RkRJSzVHd0pXUUg0U0RZT0lBcDhYa2FhTmRpTGpNV2l4?=
 =?utf-8?B?S0NDRXM3alFwdTNmSDFYZFZ6UVpHVDZObEFoZkhYMDA0cUd1NGNxbkdnN2Qr?=
 =?utf-8?B?eFBXSUZVbnlraEQ4L1dwNjFZd1ozWXNtK1dBYnZGWm9pQVZYd0owMUJsK2VK?=
 =?utf-8?B?VytobzF4aHI5U3lSQktCZEpzTGlPcXdzSG01M1dvN1U4Yk5pVDloa0VkQm1F?=
 =?utf-8?B?TjRBVEVkVzZBc0lWSWxPYmIzbUFyWWdjTWhaRk1iYUp0OGN1a2IvNTJrQVJa?=
 =?utf-8?B?VTJtOGdTTHVFTVJzcFVTeHd4c2NsUHNTOGtWUFhhTlF1ZG96V2tZVk41bnNz?=
 =?utf-8?B?bkp0QmpoM1pLOE8xeHBRN1BQblRkaXArc1ArNldWa3A2MGVHdHJkSGRDY3FE?=
 =?utf-8?B?REVCYSszb1NlVE92QXZJT0NIRVhpTXJtZ2xKKzE0bFRmZVpVcnpYUkdtM3d2?=
 =?utf-8?B?NXdwMEdiL3VreHpTc2RMaVdoLytHSENVVFU1RHppVkl3SnVPK29RNDZ0R29P?=
 =?utf-8?Q?fHsdnVnsGoMdIu/dTCof44PGnNVOoXqsdycCIuKyXLlHk?=
x-ms-exchange-antispam-messagedata-1: 9oSF23IFW4CVQ3r3fsG031DmmsgQv2jmfP4RaUxO/dTjjCoc5QJR58CY
Content-Type: text/plain; charset="utf-8"
Content-ID: <C905C44CC9049140B185C1BFE4124A24@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbac5df-40f2-49a1-b6ce-08da32963ff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 15:03:32.5559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tU1sdC4o/bT9ms+OnUvOLzoBM9ZAiAmN4qgXdY2iOvH7tO74VU+sPwEeiyxI04SsyGfW1Fpp6gLvvhZsi95AVLOKyrYpGJxyNco5fM7ZWWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6385
X-Proofpoint-GUID: mzepV79nBJdgfeyvOfuPCL10kOpe9cl4
X-Proofpoint-ORIG-GUID: mzepV79nBJdgfeyvOfuPCL10kOpe9cl4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDEwLCAyMDIyLCBhdCAxMDo0NCBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gU2F0LCBBcHIgMzAsIDIwMjIsIEJv
cmlzbGF2IFBldGtvdiB3cm90ZToNCj4+IE9uIFNhdCwgQXByIDMwLCAyMDIyIGF0IDAyOjUwOjM1
UE0gKzAwMDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4gVGhpcyBpcyAxMDAlIGEgZmFpciBhc2ss
IEkgYXBwcmVjaWF0ZSB0aGUgZGlsaWdlbmNlLCBhcyB3ZeKAmXZlIGFsbCBiZWVuIHRoZXJlDQo+
Pj4gb24gdGhlIOKAmG90aGVyIHNpZGXigJkgb2YgY2hhbmdlcyB0byBjb21wbGV4IGFyZWFzIGFu
ZCBzcGVuZCBob3VycyBkaWdnaW5nIG9uDQo+Pj4gZ2l0IGhpc3RvcnksIExLTUwgdGhyZWFkcywg
U0RNL0FQTSwgYW5kIG90aGVyIHNvdXJjZXMgdHJ5aW5nIHRvIGRlcml2ZQ0KPj4+IHdoeSB0aGUg
aGVjayBzb21ldGhpbmcgaXMgdGhlIHdheSBpdCBpcy4NCj4+IA0KPj4gWWFwLCB0aGF0J3MgYmFz
aWNhbGx5IHByb3ZpbmcgbXkgcG9pbnQgYW5kIHdoeSBJIHdhbnQgc3R1ZmYgdG8gYmUNCj4+IHBy
b3Blcmx5IGRvY3VtZW50ZWQgc28gdGhhdCB0aGUgcXVlc3Rpb24gIndoeSB3YXMgaXQgZG9uZSB0
aGlzIHdheSIgY2FuDQo+PiBhbHdheXMgYmUgYW5zd2VyZWQgc2F0aXNmYWN0b3JpbHkuDQo+PiAN
Cj4+PiBBRkFJSywgdGhlIEtWTSBJQlBCIGlzIGF2b2lkZWQgd2hlbiBzd2l0Y2hpbmcgaW4gYmV0
d2VlbiB2Q1BVcw0KPj4+IGJlbG9uZ2luZyB0byB0aGUgc2FtZSB2bWNzL3ZtY2IgKGkuZS4gdGhl
IHNhbWUgZ3Vlc3QpLCBlLmcuIHlvdSBjb3VsZCANCj4+PiBoYXZlIG9uZSBWTSBoaWdobHkgb3Zl
cnN1YnNjcmliZWQgdG8gdGhlIGhvc3QgYW5kIHlvdSB3b3VsZG7igJl0IHNlZQ0KPj4+IGVpdGhl
ciB0aGUgS1ZNIElCUEIgb3IgdGhlIHN3aXRjaF9tbSBJQlBCLiBBbGwgZ29vZC4gDQo+Pj4gDQo+
Pj4gUmVmZXJlbmNlIHZteF92Y3B1X2xvYWRfdm1jcygpIGFuZCBzdm1fdmNwdV9sb2FkKCkgYW5k
IHRoZSANCj4+PiBjb25kaXRpb25hbHMgcHJpb3IgdG8gdGhlIGJhcnJpZXIuDQo+PiANCj4+IFNv
IHRoaXMgaXMgd2hlcmUgc29tZXRoaW5nJ3Mgc3RpbGwgbWlzc2luZy4NCj4+IA0KPj4+IEhvd2V2
ZXIsIHRoZSBwYWluIHJhbXBzIHVwIHdoZW4geW91IGhhdmUgYSBidW5jaCBvZiBzZXBhcmF0ZSBn
dWVzdHMsDQo+Pj4gZXNwZWNpYWxseSB3aXRoIGEgc21hbGwgYW1vdW50IG9mIHZDUFVzIHBlciBn
dWVzdCwgc28gdGhlIHN3aXRjaGluZyBpcyBtb3JlDQo+Pj4gbGlrZWx5IHRvIGJlIGluIGJldHdl
ZW4gY29tcGxldGVseSBzZXBhcmF0ZSBndWVzdHMuDQo+PiANCj4+IElmIHRoZSBndWVzdHMgYXJl
IGNvbXBsZXRlbHkgc2VwYXJhdGUsIHRoZW4gaXQgc2hvdWxkIGZhbGwgaW50byB0aGUNCj4+IHN3
aXRjaF9tbSgpIGNhc2UuDQo+PiANCj4+IFVubGVzcyBpdCBoYXMgc29tZXRoaW5nIHRvIGRvIHdp
dGgsIGFzIEkgbG9va2VkIGF0IHRoZSBTVk0gc2lkZSBvZg0KPj4gdGhpbmdzLCB0aGUgVk1DQnM6
DQo+PiANCj4+IAlpZiAoc2QtPmN1cnJlbnRfdm1jYiAhPSBzdm0tPnZtY2IpIHsNCj4+IA0KPj4g
U28gaXQgaXMgbm90IG9ubHkgZGlmZmVyZW50IGd1ZXN0cyBidXQgYWxzbyB3aXRoaW4gdGhlIHNh
bWUgZ3Vlc3QgYW5kDQo+PiB3aGVuIHRoZSBWTUNCIG9mIHRoZSB2Q1BVIGlzIG5vdCB0aGUgY3Vy
cmVudCBvbmUuDQo+IA0KPiBZZXAuDQo+IA0KPj4gQnV0IHRoZW4gaWYgVk1DQiBvZiB0aGUgdkNQ
VSBpcyBub3QgdGhlIGN1cnJlbnQsIHBlci1DUFUgVk1DQiwgdGhlbiB0aGF0DQo+PiBDUFUgcmFu
IGFub3RoZXIgZ3Vlc3Qgc28gaW4gb3JkZXIgZm9yIHRoYXQgb3RoZXIgZ3Vlc3QgdG8gYXR0YWNr
IHRoZQ0KPj4gY3VycmVudCBndWVzdCwgdGhlbiBpdHMgYnJhbmNoIHByZWQgc2hvdWxkIGJlIGZs
dXNoZWQuDQo+IA0KPiBUaGF0IENQVSByYW4gYSBkaWZmZXJlbnQgX3ZDUFVfLCB3aGV0aGVyIG9y
IG5vdCBpdCByYW4gYSBkaWZmZXJlbnQgZ3Vlc3QsIGkuZS4gYQ0KPiBkaWZmZXJlbnQgc2VjdXJp
dHkgZG9tYWluLCBpcyB1bmtub3duLg0KPiANCj4+IEJ1dCBJJ20gbGlrZWx5IG1pc3NpbmcgYSB2
aXJ0IGFzcGVjdCBoZXJlIHNvIEknZCBsZXQgU2VhbiBleHBsYWluIHdoYXQNCj4+IHRoZSBydWxl
cyBhcmUuLi4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgeW91J3JlIG1pc3NpbmcgYW55dGhpbmcuICBJ
IHRoaW5rIHRoZSBvcmlnaW5hbCAxNWQ0NTA3MTUyM2QgKCJLVk0veDg2Og0KPiBBZGQgSUJQQiBz
dXBwb3J0Iikgd2FzIHNpbXBseSB3cm9uZy4NCj4gDQo+IEFzIEkgc2VlIGl0Og0KPiANCj4gIDEu
IElmIHRoZSB2Q1BVcyBiZWxvbmcgdG8gdGhlIHNhbWUgVk0sIHRoZXkgYXJlIGluIHRoZSBzYW1l
IHNlY3VyaXR5IGRvbWFpbiBhbmQNCj4gICAgIGRvIG5vdCBuZWVkIGFuIElQQlAuDQo+IA0KPiAg
Mi4gSWYgdGhlIHZDUFVzIGJlbG9uZyB0byBkaWZmZXJlbnQgVk1zLCBhbmQgZWFjaCBWTSBpcyBp
biBpdHMgb3duIG1tX3N0cnVjdCwNCj4gICAgIGRlZmVyIHRvIHN3aXRjaF9tbV9pcnFzX29mZigp
IHRvIGhhbmRsZSBJQlBCIGFzIGFuIG1tIHN3aXRjaCBpcyBndWFyYW50ZWVkIHRvDQo+ICAgICBv
Y2N1ciBwcmlvciB0byBsb2FkaW5nIGEgdkNQVSBiZWxvbmdpbmcgdG8gYSBkaWZmZXJlbnQgVk1z
Lg0KPiANCj4gIDMuIElmIHRoZSB2Q1BVcyBiZWxvbmcgdG8gZGlmZmVyZW50IFZNcywgYnV0IG11
bHRpcGxlIFZNcyBzaGFyZSBhbiBtbV9zdHJ1Y3QsDQo+ICAgICB0aGVuIHRoZSBzZWN1cml0eSBi
ZW5lZml0cyBvZiBhbiBJQlBCIHdoZW4gc3dpdGNoaW5nIHZDUFVzIGFyZSBkdWJpb3VzLCBhdCBi
ZXN0Lg0KPiANCj4gSWYgd2Ugb25seSBjb25zaWRlciAjMSBhbmQgIzIsIHRoZW4gS1ZNIGRvZXNu
J3QgbmVlZCBhbiBJQlBCLCBwZXJpb2QuDQo+IA0KPiAjMyBpcyB0aGUgb25seSBvbmUgdGhhdCdz
IGEgZ3JleSBhcmVhLiAgSSBoYXZlIG5vIG9iamVjdGlvbiB0byBvbWl0dGluZyBJQlBCIGVudGly
ZWx5DQo+IGV2ZW4gaW4gdGhhdCBjYXNlLCBiZWNhdXNlIG5vbmUgb2YgdXMgY2FuIGlkZW50aWZ5
IGFueSB0YW5naWJsZSB2YWx1ZSBpbiBkb2luZyBzby4NCg0KVGhhbmtzLCBTZWFuLiBPdXIgbWVz
c2FnZXMgY3Jvc3NlZCBpbiBmbGlnaHQsIEkgc2VudCBhIHJlcGx5IHRvIHlvdXIgZWFybGllciBt
ZXNzYWdlDQpqdXN0IGEgYml0IGFnby4gVGhpcyBpcyBzdXBlciBoZWxwZnVsIHRvIGZyYW1lIHRo
aXMgdXAuDQoNCldoYXQgd291bGQgeW91IHRoaW5rIGZyYW1pbmcgdGhlIHBhdGNoIGxpa2UgdGhp
czoNCg0KICAgIHg4Ni9zcGVjdWxhdGlvbiwgS1ZNOiByZW1vdmUgSUJQQiBvbiB2Q1BVIGxvYWQN
Cg0KICAgIFJlbW92ZSBJQlBCIHRoYXQgaXMgZG9uZSBvbiBLVk0gdkNQVSBsb2FkLCBhcyB0aGUg
Z3Vlc3QtdG8tZ3Vlc3QNCiAgICBhdHRhY2sgc3VyZmFjZSBpcyBhbHJlYWR5IGNvdmVyZWQgYnkg
c3dpdGNoX21tX2lycXNfb2ZmKCkgLT4NCiAgICBjb25kX21pdGlnYXRpb24oKS4NCg0KICAgIFRo
ZSBvcmlnaW5hbCAxNWQ0NTA3MTUyM2QgKCJLVk0veDg2OiBBZGQgSUJQQiBzdXBwb3J0Iikgd2Fz
IHNpbXBseSB3cm9uZyBpbg0KICAgIGl0cyBndWVzdC10by1ndWVzdCBkZXNpZ24gaW50ZW50aW9u
LiBUaGVyZSBhcmUgdGhyZWUgc2NlbmFyaW9zIGF0IHBsYXkNCiAgICBoZXJlOg0KDQogICAgMS4g
SWYgdGhlIHZDUFVzIGJlbG9uZyB0byB0aGUgc2FtZSBWTSwgdGhleSBhcmUgaW4gdGhlIHNhbWUg
c2VjdXJpdHkgDQogICAgZG9tYWluIGFuZCBkbyBub3QgbmVlZCBhbiBJUEJQLg0KICAgIDIuIElm
IHRoZSB2Q1BVcyBiZWxvbmcgdG8gZGlmZmVyZW50IFZNcywgYW5kIGVhY2ggVk0gaXMgaW4gaXRz
IG93biBtbV9zdHJ1Y3QsDQogICAgc3dpdGNoX21tX2lycXNfb2ZmKCkgd2lsbCBoYW5kbGUgSUJQ
QiBhcyBhbiBtbSBzd2l0Y2ggaXMgZ3VhcmFudGVlZCB0bw0KICAgIG9jY3VyIHByaW9yIHRvIGxv
YWRpbmcgYSB2Q1BVIGJlbG9uZ2luZyB0byBhIGRpZmZlcmVudCBWTXMuDQogICAgMy4gSWYgdGhl
IHZDUFVzIGJlbG9uZyB0byBkaWZmZXJlbnQgVk1zLCBidXQgbXVsdGlwbGUgVk1zIHNoYXJlIGFu
IG1tX3N0cnVjdCwNCiAgICB0aGVuIHRoZSBzZWN1cml0eSBiZW5lZml0cyBvZiBhbiBJQlBCIHdo
ZW4gc3dpdGNoaW5nIHZDUFVzIGFyZSBkdWJpb3VzLCANCiAgICBhdCBiZXN0Lg0KDQogICAgSXNz
dWluZyBJQlBCIGZyb20gS1ZNIHZDUFUgbG9hZCB3b3VsZCBvbmx5IGNvdmVyICMzLCBidXQgdGhl
cmUgYXJlIG5vDQogICAgcmVhbCB3b3JsZCB0YW5naWJsZSB1c2UgY2FzZXMgZm9yIHN1Y2ggYSBj
b25maWd1cmF0aW9uLiBJZiBtdWx0aXBsZSBWTXMNCiAgICBhcmUgc2hhcmluZyBhbiBtbV9zdHJ1
Y3RzLCBwcmVkaWN0aW9uIGF0dGFja3MgYXJlIHRoZSBsZWFzdCBvZiB0aGVpcg0KICAgIHNlY3Vy
aXR5IHdvcnJpZXMuDQoNCiAgICBGaXhlczogMTVkNDUwNzE1MjNkICgiS1ZNL3g4NjogQWRkIElC
UEIgc3VwcG9ydCIpDQogICAgKFJldmlld2VkYnkvc2lnbmVkIG9mIGJ5IHBlb3BsZSBoZXJlKQ0K
ICAgIChDb2RlIGNoYW5nZSBzaW1wbHkgd2hhY2tzIElCUEIgaW4gS1ZNIHZteC9zdm0gYW5kIHRo
YXRzIGl0KQ0KDQoNCg0K
