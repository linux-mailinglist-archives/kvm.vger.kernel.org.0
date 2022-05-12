Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28F2525610
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 21:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358197AbiELTw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 15:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358162AbiELTw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 15:52:27 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B808E2701B2;
        Thu, 12 May 2022 12:52:23 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFVanm023466;
        Thu, 12 May 2022 12:51:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=8O3hN6Qo1i5UYfU3xQK4vr+mBSxLU2n+mJqj+61x7ec=;
 b=FO6wHzz0Z0VcTcc/QPkYaj+Ri8nmF4cIvLXOloWzhWyMHE8/rmGdAGqFm6X1HxNFRcRs
 VafxItwd/IPrS4fC4sOzDzepiGdjiy7f012NcrQMtISz39PEaoglON29VszSJaRAJ5SP
 JQyqWbcJP7ArzOwnnkexnahI9u1B/D+f6ZudIE9ICZCkQPWqaPpJWQcOTnMUGrI4JtJT
 3NTuiURuSgxpd0fqwgMn3AI2k3kihKbbLY8BcdZCdnjvz5vrU/z/5daV0S3Q0NlfC5ub
 V0BL0HB/DiGkc8nW1WEObnGMqKMRrXUeq7VfMNJXvdQaNDSA1ELZiYIEeFZAeBvXUVkH VA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwr3fusdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:51:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8nVWn3qrQdgbiwDoMJ1sK+la7gylG9QZA7WSkK63D/r2UNw+hxARouN4HYQRpNM3X0dsEnIetvKlEVbyDlN1UvxLAKRFc0tySOP95gIh/H8cMOmLGKmS95MQOkCIiucvpSSzw7d7kp4JKpDWy1KkWMLWV8wt39k5VhSbBavtssI4W6PpcBQb34N+mu8jEMvWfry6vl966YmqFi7uu+rG9D8aDIdqeX16JR9c+e4nBHTTIKb/M7qx5IQ/L61mA0ZbkS8AY96LZyuIbIt4eMr61nxpepXGW0KKGgSjQ6TdtrxVYrb+y2Q9pqriNxuFs4ngN+EqtIphwqT2u6eVG8COA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8O3hN6Qo1i5UYfU3xQK4vr+mBSxLU2n+mJqj+61x7ec=;
 b=jP3sMupVaNvFpwIpRLsHMNlKBB8orez4urbuC015t741i2nmAq/Pqgfs37q32l5shDSvxXeggotdBu+yE2+K/M/K9ATZeKAC6h5TcgnYi8QffRDcPg3bHcg3pOXYj8AGeCc+BQZqUHIsnOmPCZGA0KP4X24hzW+N5TUUi2XuGiaPZfItOP3SLRkVbaoenKMth06LZgLZeofTWgYoc97NsDH4W504bNGwSd3ztkSVcWTiQURfCSEmUX+TwN5iUhWZLv3Xb2SwqiM0sbcq9Xpdbt45Bj6nUqlgR6EvRQoIUax3GV8crFBkit/DVtrRjr5FiFVJwWU0xEsIxjPbcuxgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SN6PR02MB4320.namprd02.prod.outlook.com (2603:10b6:805:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 12 May
 2022 19:51:09 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 19:51:09 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Topic: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAA==
Date:   Thu, 12 May 2022 19:51:09 +0000
Message-ID: <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
In-Reply-To: <Yn1hdHgMVuni/GEx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e2a558a-a266-4be6-b28f-08da3450c29c
x-ms-traffictypediagnostic: SN6PR02MB4320:EE_
x-microsoft-antispam-prvs: <SN6PR02MB432021639CC9563C5B9686C5AFCB9@SN6PR02MB4320.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bcts/9S/zD/YLzFj+47dpsgZkl9WEJWXZWiRtGpSk3xpT5JnvgjImOgu6VZqr7WOJ0EKH8zh4sK+/xEiEuvt8eaYs81XpPEwNYANYIlrjfxn9RBgtIEhWQz7HlYWAcAx4qWVakd/GCmg8ZITm1VURs+lpm+bOABZs2HE5V9j8oPI0MJ3k+iZVBd3Y8pQ/AgtfLjzlOBm9y8/hSkPHVvLX+SIYhH8bAx931s8BJU7klnv6eATId+gCq3JTDFB4l9QEmMk2LDO+4Jkr9z8C5zV2WXIBlUajftiazvNQczmybMU7dCmd0IcSoFIcKOB7pTDC9okQAMNkB1HNiH69rgy7MUyKmdCAQeJcl/q8ZEoAbl/CNhxQlrI69C5D/vdOLbn70PnfhJY/7xiVahxigMFEGc+cG5f4ckrL9ea7r06NzPRjfr9BwhoSYhRlCvwcKXF06c8sH67G8CZpZZxNPRrT3I7yiTnx+AgYYRf2+xTt8xWNU6XZC7YXlXY2O5ffTteDzZnc8GxzZOZ3b8+ielcFMEVq5ieEuAWnbZrG9ztKMff4CDOcoSw1YT35QwhAP4UitKxf7Z9ZbnJQ+njJZsRCOBJQ5X6FcMKA1zP1QIYftdYqe0XjK59FQ9fWJUEwWYvQxBu7SSWM8bDZwrTuJNyf7CJtdEXAqBySHMju9sV/rqcIMKK0xvNElSxt61GGHrN7/jVsOWjJSGy3A0DDcxxEiBGDriwhmTDOLJGtTfmiIQI8OYvlkgAWJe3H8FflyH8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(122000001)(86362001)(2616005)(6506007)(186003)(38070700005)(53546011)(38100700002)(5660300002)(6486002)(7416002)(6512007)(71200400001)(8936002)(508600001)(36756003)(91956017)(76116006)(66946007)(66476007)(33656002)(64756008)(66556008)(2906002)(66446008)(6916009)(54906003)(83380400001)(8676002)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3luTnQwbnk1UkxzVjNLdi9kcThDR2hTSXlNSWZRR3A2T1BFVE5mTUdwRmlM?=
 =?utf-8?B?Yi9VSGdTbWY5TDhUWGw0S3grU3p2aVVheUEvWnZrRE9NTnZjM1VLa3pDSy94?=
 =?utf-8?B?S0IvQ1Y4Ri9RL0VSTTN1SVZPUWZnRlZvMndBeitiRnlPbEdweXlQVFVRZi9Y?=
 =?utf-8?B?Y1BKTHNxaXU4WVFRbDF0NlFQc05rbG1LblQwR3JIRTZrV0lXY2Z2dGNuOWE0?=
 =?utf-8?B?WmV6U0w5aG9maDVvK09EVUh5NVlmQUNIOEpwbnJscXpHYzFQeUlNblY3YUQ1?=
 =?utf-8?B?d1ZpV0Yvd0JXQjdPMnhscFVXSFVJWU5ySnlzbGZjS1RoZUVpS2dTenhuaFpw?=
 =?utf-8?B?SzZVWTNiSmJlcGcxUU5rYy9rYU9sVmdwRHg2eEd0NGhQSEx0OHhUZG81cUh1?=
 =?utf-8?B?blUyRWJrcTkzSXFYbVVjSFppZG9IbXMwa1J2dXNzV2s5aGMwblljN3FaWE1k?=
 =?utf-8?B?VXJvMVRRUXVUMi9oSzVxU254SjdHVUZLRTNLTmlIRmdZV3F3WERYbFJWR2x4?=
 =?utf-8?B?VDFmalZnZHRpNUtZa1kwRUxtSXFXaDFRT2ViWnVvREJYU1pIVXlwR08rRVdB?=
 =?utf-8?B?dGVMMGFsOEs3Y2Fwc2tPUjE5MHQ3aHJrTVNzeFJnVHhIdVBjRXJYbmllVUJV?=
 =?utf-8?B?TUoxNERzS014NElZbGIxT2tNQWFIZXJaQUplMmtRWHJPbzNQZUxETVhJMzI3?=
 =?utf-8?B?MVl6WWJiVHRDTmk4aGdVZ0pWSEJwTFljWE92QWp2dHB6TUE1cWxLeXZCTzlh?=
 =?utf-8?B?RnhGU3k5R2hMRnhTRzdiR3FORG4xNFFDQXdhamtJZEdBdk5sZ1FKdncxcWhy?=
 =?utf-8?B?dWtwK0MwVmlFb0VWUGwveUFWQkVPL1VEV3c5OVZFUmxMelJNaFdXTk15V0h3?=
 =?utf-8?B?TklhU0lxZEl1bUxVdXZlMnBxaDJvUmV1N25oSzUxY3JOWVE2dnNBcjVocksr?=
 =?utf-8?B?WUFLMmNtYUJocW1zL3UweDBxcjJJMUUzMGlReVppaWw4dyt2NTZSRGVMZzhh?=
 =?utf-8?B?bUUrUEJTbXlsMDc5Nm05dlVjY2NBa0ptNDhLODlQYmdZVDVMTWFSeVVYWnY0?=
 =?utf-8?B?RHJjVHZzdHdqNkw1bkpjVHFtSGhlRzUzaWo1K0h5UGtQR3lDTnZqdjJtTmF4?=
 =?utf-8?B?OWVEYVdOSnhWNVdUSnA1YUJlVjU5T3RsWkdPSEFqRXhXVGIwN01valBxSkNW?=
 =?utf-8?B?dVBZY2d4LzVsZ0MyT3VFWHJjU0xOOVJTQW13MXZtSzk2RzFMQWRQT0kvajhU?=
 =?utf-8?B?bFVuSXQ2MEtlaWVKS2NuYnB2aEtvaTlmcG5aSnBnaDUzUmNMVHFIN0MwQU8w?=
 =?utf-8?B?NlMrSDVId3JpMWRhUTVlbk9sQ3A3ODUxdlVGMkg1YUVwdmlZemxobCtYcTVj?=
 =?utf-8?B?bE5pMG5oSi9kRVIyM2hER2VhMTVSbzFEbVZrTU5iOTRUOG42dEt0NngyYndm?=
 =?utf-8?B?TmJ0TXhsQTBWZkJqeElFZk1UNlIwMUFScWlNYXB6WVR2V2VLdWVpQ1NNQWQ5?=
 =?utf-8?B?SExqMTNVN3kvRCs5N2ZVaTFpYzJtVDNtNUprVjZ0Tmh5NnJvZ1V1ZElBcGRS?=
 =?utf-8?B?cnc2dEFQTEkySVNNN1JuUzQ1RFRnWWpsbG13NlRnMFhRbm9IL1V4Q0FKMGdr?=
 =?utf-8?B?TWRXaDVMQk8rVTl0WE9ueFBvRGN3dEhzODU0bUZWVzhLUEV3aHloMU9jTGJ6?=
 =?utf-8?B?ZXVmTjhIMlUrWElBQXdOZnJ0cVJZd0ZuU1VoMHdBNXhQZ3VUWVVLZURXRTFw?=
 =?utf-8?B?RVMyVDVlMmE3dFh4RzQrcU1FbzRvQXJnOXBrVEVsWjBjeFN5eUlKcHhSVHI0?=
 =?utf-8?B?cXlXTENPMkRLZ2FkTmUvTUNIYXhjeWN0d2JSR3N3UWhDRWxGelRQdlVNZDZ5?=
 =?utf-8?B?Z1Z4c0piQ3FicTRzSUl5REI5R2FialRPY1RPTTJpU1k3bnFpRTB4ZmdMd1hp?=
 =?utf-8?B?VWNuN0VtNEwySkhsV2htWldjbTBMVUdlSVYzbTdxNDZZODlVKy9ZM0J0a0d2?=
 =?utf-8?B?M3dyT1pDVEw3U0N6L0hpYVp3bGxuRy9DR2VYWlNHSWFLYnRqTXUxTzlnRVR5?=
 =?utf-8?B?RnhrdkVxVG9pZnhJMFVwNlhkbGtHd0I0M0UvcWY5dVZuTTRPbHdPWVNUTjEz?=
 =?utf-8?B?NEUvbFdlTWxRdGtMdGZBT1E2c0dvc3czZFRScnVHVURNMlpqbzNNdnB6eEc1?=
 =?utf-8?B?VzNva0FncHEvQkdhNU52ZE5Nd3hTNU1POXBZSnFWbTEvQ3dvZUlyZ1MzZlJX?=
 =?utf-8?B?d1Z5VXNwN09DMFhjK1BzT2h3eWkxQW5EUFhvdFB5dUsyd2FZTzl3UVBSbzMy?=
 =?utf-8?B?Qkk3V2l3Zy9mQTZLOHZKR1pXd2JuRDVFdWxVN0F6MldWUS9zY2ZCd2xqMlUz?=
 =?utf-8?Q?jH0vOnzGpZhmVo6Jir4/uPeMV+LGu+20yRReWG9iNecNO?=
x-ms-exchange-antispam-messagedata-1: pPk0U2zWXt2lxjyo0hFmcyodFhNTasO0cq7zEbSbwtD17uHAPVyoq0Kq
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AF26272F1F2744DAB952FE1562A89C9@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2a558a-a266-4be6-b28f-08da3450c29c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 19:51:09.2955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvB+aGWeK6WjhGcJVow7fHzfaC9y/ISrsObhYn7zNP9zHLjTHDk/LIIC6eqWna7UrCNa8/opS8OI9Lew0rUJ7Trgi4kjXUCMDyvX1F0wpj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4320
X-Proofpoint-GUID: vLDnJZJ9l7gEfLWlB6y5GwVqJPNZJx5V
X-Proofpoint-ORIG-GUID: vLDnJZJ9l7gEfLWlB6y5GwVqJPNZJx5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_16,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCAzOjM1IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIE1heSAxMiwgMjAyMiwgU2Vh
biBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+IE9uIFRodSwgTWF5IDEyLCAyMDIyLCBKb24gS29o
bGVyIHdyb3RlOg0KPj4+IFJlbW92ZSBJQlBCIHRoYXQgaXMgZG9uZSBvbiBLVk0gdkNQVSBsb2Fk
LCBhcyB0aGUgZ3Vlc3QtdG8tZ3Vlc3QNCj4+PiBhdHRhY2sgc3VyZmFjZSBpcyBhbHJlYWR5IGNv
dmVyZWQgYnkgc3dpdGNoX21tX2lycXNfb2ZmKCkgLT4NCj4+PiBjb25kX21pdGlnYXRpb24oKS4N
Cj4+PiANCj4+PiBUaGUgb3JpZ2luYWwgY29tbWl0IDE1ZDQ1MDcxNTIzZCAoIktWTS94ODY6IEFk
ZCBJQlBCIHN1cHBvcnQiKSB3YXMgc2ltcGx5DQo+Pj4gd3JvbmcgaW4gaXRzIGd1ZXN0LXRvLWd1
ZXN0IGRlc2lnbiBpbnRlbnRpb24uIFRoZXJlIGFyZSB0aHJlZSBzY2VuYXJpb3MNCj4+PiBhdCBw
bGF5IGhlcmU6DQo+PiANCj4+IEppbSBwb2ludGVkIG9mZmxpbmUgdGhhdCB0aGVyZSdzIGEgY2Fz
ZSB3ZSBkaWRuJ3QgY29uc2lkZXIuICBXaGVuIHN3aXRjaGluZyBiZXR3ZWVuDQo+PiB2Q1BVcyBp
biB0aGUgc2FtZSBWTSwgYW4gSUJQQiBtYXkgYmUgd2FycmFudGVkIGFzIHRoZSB0YXNrcyBpbiB0
aGUgVk0gbWF5IGJlIGluDQo+PiBkaWZmZXJlbnQgc2VjdXJpdHkgZG9tYWlucy4gIEUuZy4gdGhl
IGd1ZXN0IHdpbGwgbm90IGdldCBhIG5vdGlmaWNhdGlvbiB0aGF0IHZDUFUwIGlzDQo+PiBiZWlu
ZyBzd2FwcGVkIG91dCBmb3IgdkNQVTEgb24gYSBzaW5nbGUgcENQVS4NCj4+IA0KPj4gU28sIHNh
ZGx5LCBhZnRlciBhbGwgdGhhdCwgSSB0aGluayB0aGUgSUJQQiBuZWVkcyB0byBzdGF5LiAgQnV0
IHRoZSBkb2N1bWVudGF0aW9uDQo+PiBtb3N0IGRlZmluaXRlbHkgbmVlZHMgdG8gYmUgdXBkYXRl
ZC4NCj4+IA0KPj4gQSBwZXItVk0gY2FwYWJpbGl0eSB0byBza2lwIHRoZSBJQlBCIG1heSBiZSB3
YXJyYW50ZWQsIGUuZy4gZm9yIGNvbnRhaW5lci1saWtlDQo+PiB1c2UgY2FzZXMgd2hlcmUgYSBz
aW5nbGUgVk0gaXMgcnVubmluZyBhIHNpbmdsZSB3b3JrbG9hZC4NCj4gDQo+IEFoLCBhY3R1YWxs
eSwgdGhlIElCUEIgY2FuIGJlIHNraXBwZWQgaWYgdGhlIHZDUFVzIGhhdmUgZGlmZmVyZW50IG1t
X3N0cnVjdHMsDQo+IGJlY2F1c2UgdGhlbiB0aGUgSUJQQiBpcyBmdWxseSByZWR1bmRhbnQgd2l0
aCByZXNwZWN0IHRvIGFueSBJQlBCIHBlcmZvcm1lZCBieQ0KPiBzd2l0Y2hfbW1faXJxc19vZmYo
KS4gIEhybSwgdGhvdWdoIGl0IG1pZ2h0IG5lZWQgYSBLVk0gb3IgcGVyLVZNIGtub2IsIGUuZy4g
anVzdA0KPiBiZWNhdXNlIHRoZSBWTU0gZG9lc24ndCB3YW50IElCUEIgZG9lc24ndCBtZWFuIHRo
ZSBndWVzdCBkb2Vzbid0IHdhbnQgSUJQQi4NCj4gDQo+IFRoYXQgd291bGQgYWxzbyBzaWRlc3Rl
cCB0aGUgbGFyZ2VseSB0aGVvcmV0aWNhbCBxdWVzdGlvbiBvZiB3aGV0aGVyIHZDUFVzIGZyb20N
Cj4gZGlmZmVyZW50IFZNcyBidXQgdGhlIHNhbWUgYWRkcmVzcyBzcGFjZSBhcmUgaW4gdGhlIHNh
bWUgc2VjdXJpdHkgZG9tYWluLiAgSXQgZG9lc24ndA0KPiBtYXR0ZXIsIGJlY2F1c2UgZXZlbiBp
ZiB0aGV5IGFyZSBpbiB0aGUgc2FtZSBkb21haW4sIEtWTSBzdGlsbCBuZWVkcyB0byBkbyBJQlBC
Lg0KDQpTbyBzaG91bGQgd2UgZ28gYmFjayB0byB0aGUgZWFybGllciBhcHByb2FjaCB3aGVyZSB3
ZSBoYXZlIGl0IGJlIG9ubHkgDQpJQlBCIG9uIGFsd2F5c19pYnBiPyBPciB3aGF0Pw0KDQpBdCBt
aW5pbXVtLCB3ZSBuZWVkIHRvIGZpeCB0aGUgdW5pbGF0ZXJhbC1uZXNzIG9mIGFsbCBvZiB0aGlz
IDopIHNpbmNlIHdl4oCZcmUNCklCUELigJlpbmcgZXZlbiB3aGVuIHRoZSB1c2VyIGRpZCBub3Qg
ZXhwbGljaXRseSB0ZWxsIHVzIHRvLg0KDQpUaGF0IHNhaWQsIHNpbmNlIEkganVzdCByZS1yZWFk
IHRoZSBkb2N1bWVudGF0aW9uIHRvZGF5LCBpdCBkb2VzIHNwZWNpZmljYWxseQ0Kc3VnZ2VzdCB0
aGF0IGlmIHRoZSBndWVzdCB3YW50cyB0byBwcm90ZWN0ICppdHNlbGYqIGl0IHNob3VsZCB0dXJu
IG9uIElCUEIgb3INClNUSUJQIChvciBvdGhlciBtaXRpZ2F0aW9ucyBnYWxvcmUpLCBzbyBJIHRo
aW5rIHdlIGVuZCB1cCBoYXZpbmcgdG8gdGhpbmsNCmFib3V0IHdoYXQgb3VyIOKAnGNvbnRyYWN0
4oCdIGlzIHdpdGggdXNlcnMgd2hvIGhvc3QgdGhlaXIgd29ya2xvYWRzIG9uDQpLVk0gLSBhcmUg
dGhleSBleHBlY3RpbmcgdXMgdG8gcHJvdGVjdCB0aGVtIGluIGFueS9hbGwgY2FzZXM/DQoNClNh
aWQgYW5vdGhlciB3YXksIHRoZSBpbnRlcm5hbCBndWVzdCBhcmVhcyBvZiBjb25jZXJuIGFyZW7i
gJl0IHNvbWV0aGluZw0KdGhlIGtlcm5lbCB3b3VsZCBhbHdheXMgYmUgYWJsZSB0byBBKSBpZGVu
dGlmeSBmYXIgaW4gYWR2YW5jZSBhbmQgQikNCmFsd2F5cyBzb2x2ZSBvbiB0aGUgdXNlcnMgYmVo
YWxmLiBUaGVyZSBpcyBhbiBhcmd1bWVudCB0byBiZSBtYWRlDQp0aGF0IHRoZSBndWVzdCBuZWVk
cyB0byBkZWFsIHdpdGggaXRzIG93biBob3VzZSwgeWVhPw0KDQo=
