Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9463D718F4B
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 01:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjEaX6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 19:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjEaX6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 19:58:39 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07A8134;
        Wed, 31 May 2023 16:58:37 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VK0PwQ010866;
        Wed, 31 May 2023 16:58:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=Bb4kqG1+myUDx7b/yR7w+hZl/uSfMg/XP00VWbrfqWg=;
 b=v+3Ij3X7EtdDp/H8/NeyADt0TCtZ9eUOxthXVB72FB7Ho/pLF1x2ouO/ypfkkKn5G3hF
 rGZqVTKEj1jovEnfxa3+z2ge10Xy2NQIVhAaVNJnPXuD29C2ID8GR3OoN3X6oBPpwtGL
 TwLdssKwS7uqGbx2hR6JBBSUBflZ1j7Tz8LbNaCjnpRZq5vz8QN2l8JW08uNlU7FdmFo
 Lw/5ZlTvr4YbL7QVtu6DRJqKV9PcF+0xc0zUbdQivo9rSJQLkMVCLt4c7Ixmmwx4OboA
 LWAd9wHxi02NKxlXU5re8jy4hj3zN0d9iBwrPDsg7UvO7ep86KfDqTqQjMG8vrxWJZiI 5A== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufyfb4wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 16:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlhSMLG+BwSpMip6oNZ8JVVbSuIoll+2tsZ2u6NJSNjRKP0VRdBTuZZkmziRjDLUQjx2Hfe52oRTZnjxh3ONKZTLNlDkGmtiABGXDNKwsiljvk6oIB/h8wwp7P+c6T1NwTuq0+Ln+uQzYi3a2gE4TkkQhHqSgADDQv+vzoGI+bJocoVJDpW7+qNbnUY8SRRIU7YrLcl3CRFMA9Rwvm7dA1FupwCwpxO0KO8cvyTsAp1aF4PuEBuQ4XwR7XQf3lPvhHf/1drn40vg2yK0+P6zFpcxzNYinclzYPgmEeIDVvwFhOIsrS6lMs1PczkOwD2KGvtPHP+j4EjL1pRUUAKr0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb4kqG1+myUDx7b/yR7w+hZl/uSfMg/XP00VWbrfqWg=;
 b=lzGyqN30umeOnXTaZseg3dwwQ7YWZT+0A3rzHdFisq8K8FYbsx/8NBoJwYCr+TQsuqtyg32byCrFa8upLjXAScnmsf7rn748DkMZHUajaijT7w1wuMLm4dlwS92umgD+5vFkUKnLsJC/ExApQ5iEdwJyqbxq7UbUAbonBgMk4vaXaZqgS/A0uN5ThEoo3x4FckuHZquc61Ru4iH7xagQ1ILkvPoGNHlZExDjz0aKOgqZ53+YXCOFJA8jcLYXX623W++to0ljGM3xvf+5WXXhv+FWaEbmkBXI+Mlc+T7i/pQ7GNQU6k9XoalWZyOvNCwDtx0yop1ajE+z7klwPPmyPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb4kqG1+myUDx7b/yR7w+hZl/uSfMg/XP00VWbrfqWg=;
 b=b8AEdLO1DznPE4TM4NBsFGid5REgJt2RFvqDrQqWBMq7apJRtMMbsT9efiGAo6VT1QMlYQZnUtfN0o3UiH/Yeetoet4satH37Fl/WJslfLhb241l31qdDgwHqJdtTAJuPVfMGrrJkmnMuB97tiY9kTvTCjNozvIEgQR0pkIjEXfg6iGEbHRGmFzC7VvO3087ZrUKcksgKnwX7ZWS9NmSNirpzMLNali+UQh+hjpWxBxBQNaU9EnjnXduCSfZLj1/Gf1RTcO+ZRjKOwBsrxh7JWhCPEA1tQebwNahcN0lEmCGANq4DrTIgt6hReFzHKXTOlswhfeLRDFYvWtkk6AQDA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH3PR02MB10059.namprd02.prod.outlook.com (2603:10b6:610:19c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Wed, 31 May
 2023 23:58:12 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 23:58:12 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Topic: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Index: AQHZk9DFtRNtW0r2UU2DHIN38zEv2a91BL4AgAALIIA=
Date:   Wed, 31 May 2023 23:58:12 +0000
Message-ID: <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
In-Reply-To: <20230531231820.trrs2uugc24gegj4@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|CH3PR02MB10059:EE_
x-ms-office365-filtering-correlation-id: f66e878e-353e-45dc-1716-08db6232e457
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SShJ17Jf+zEQ9b5k+Y1kVdpbxCiUYRfz1tn054UkTaWuCZIj5WllTfl049FJ3hICvUTI3uTXO/KlfUlsXmKy7JKYK5nyCLQET14bU87cBtfVKK29usmyaWbTtGWLk8yUj1loCwyZuN//YLK2moysw6Hq4r4/zPmIMienRFLKSAUMpxyEwTqIk57H6dSvO4aMROzAM0Heg+YxCi7oXFiY1co6rAy+k6hcFfaPae7p8h5MC9O+ZB0qCNPuGUouwQlSZAUvuS2gQw/bx/dN8eAz0YOgiZeNWb75VYDgLhSS18ubyILt2AZkRRmX+4itlaKAJxDF94CNiCjHyuuOFFEN5/XZiwL147TZimayONLB5d9y5lX8uNKb/v3sG8xdDHoMhF5ZPw17t10uBNya/XbQEASxnMXDp+b2kUFH8ok7ApRoIHuJQ0xkCKGYSREaILzqlP2NNLEz9YushpEzBLiKw3E0DCJaGhUKIMI282s6UlWkOhKU0GxeOmi4SGG7Xc49tDJaha1L9gGhN7peIhyiu3acol3kEKQDuLcGU9mP6nHGFe6Udf9ZkAivjOlhtBUt+Yh3OCd4bZgcRap+ANZ6ekRNbpNU4r8cxFsAMiNlDWOeUUA5yfEhadQ3mH+sFcXT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(86362001)(36756003)(66476007)(6916009)(54906003)(66446008)(66556008)(64756008)(91956017)(66946007)(76116006)(478600001)(4326008)(6486002)(5660300002)(966005)(316002)(41300700001)(53546011)(8936002)(8676002)(7416002)(38070700005)(71200400001)(2906002)(83380400001)(38100700002)(122000001)(2616005)(33656002)(6512007)(6506007)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFFIN3k2eU9nOERITjYwTEcweVBSVkN3TUthQ0ZEM3dCU3ZJUldsdm9kTCtx?=
 =?utf-8?B?UmU3UzhDcElucG1RVFp1OGxnRFhKOFdXV2dPSUQ3Y1p5bnRXUFlKNkMrQlh1?=
 =?utf-8?B?UDRNdWkvODlPeGZCWU85YmFxQnRWV25iSUVIV3QzbjJuYXMvUjhGODhiZGd2?=
 =?utf-8?B?Nmc5RWdoNytrMUloZ2s2NmJibkZPNW9HdmRqVDFpenZXSnllREZ2Rkd3bGxp?=
 =?utf-8?B?U3F5UVZxMzBqV2xDM3N3TVVWenk0RDluRkd0cnNXY0lPcDYyMEp3ZDgrSURv?=
 =?utf-8?B?MnR1SW9QYTJyaUFxYTZCbHQ4UG9FMmRydkZYSTMybEh1OEFkY1d5Smk0cDRs?=
 =?utf-8?B?Rno2c1pRcEtUZmdHcnpOUXkraEtlWElnQmZjclpKTE5FMm1OOFJ1WFovRjd0?=
 =?utf-8?B?dy83emZJbUdFbUoxSmdkM004VHZIdnNSclhUcVZYeDRBTXgvV0FMVkhZNWx5?=
 =?utf-8?B?VncwZjJnam1XMXZSKzc3d1lZMUExQ2RHOXVWbDd3b0ZDNXVUbmpuWVRzSHUy?=
 =?utf-8?B?NUpVa0RoRWM3WGJqSHByRlpNOXNyVjFoYkNPMVE2VFN1REdiaVIvbE9hVTRD?=
 =?utf-8?B?RW9laytMemlxS0pmb1E1Wjl3VjZ5VTJ3RXYweS9CN1NCQVV2YWNXb3pDTjYv?=
 =?utf-8?B?WjJIK3FnTUR6M1JqZHgydi9GNENKSDJGNHM5U1Q2YjlRbmI5a2habkYrUTRS?=
 =?utf-8?B?c3MzY29BMWMvWk5YdDFmUzUrWVJvNkJqdEFqelVxYjlZbzJwUU5OUUkvM0J4?=
 =?utf-8?B?bnlEbHBDLzNIaHN0cWZXc2w1UHNFUEtNVzMrTHA5VDlnYlVBQzlFUEYxRkFn?=
 =?utf-8?B?NDljV3ZXUG9IV1JnNThtQTRHM1RTUERsVXQrVlJHMzBkZHBVQTNQVGc2TWNi?=
 =?utf-8?B?YUtYYjNVY0hSNk1ZeThtVzUzSGQ0WjA4ei9JRkNMdGNlRGN2QXBIRWd1eUZT?=
 =?utf-8?B?NmhscGhtVE5sbU9STE9ST1h3MFluNXhoYkRabGFvaWFZdThkR0MzSGx0UXJK?=
 =?utf-8?B?Y2JRMkdSNUl1VVk2d0JTdGREeDE0VEJmL1BNL3JHaVJtcGc3SStYVWlYYnNs?=
 =?utf-8?B?ZE9pTyswSTB4VU94blVpb2VrMlFxYXhudlVsUWR5MTBuR1ZGWXZ3dDZUUlp2?=
 =?utf-8?B?VlMrSkErbk9nQjJiM0Q0YlVBZjVyMnRSMUZaVkI4Uy91ZmhtbkRuYUN2T3ov?=
 =?utf-8?B?RzJvMnBUY2QzaHZzbkMxeXZXcG1aRUR2RjhTQ2ZDeUx4Z2ZuYmsrQ0s4MEpD?=
 =?utf-8?B?alJsZWp5dGZHUW9ydWs1K00zckJvcFVFVEtJVGR3eXhOdTg3a21KTmtUM2JD?=
 =?utf-8?B?dUY3Nm5WS1VseTFQWHlQMHVFM1dPdWRjeVZWc2RBVStiakFGZWVHU2lHTXNU?=
 =?utf-8?B?VHI4VEN2MHJPOTZ5VnNtTTFqYlN2Wm9NYVdiajRxM1k2ekVxUEZFNjlKVHM5?=
 =?utf-8?B?dno3dTIxZTlXT1BjR1h0bHNXMENRU203R29iTXlzcmI3c0p5cTZNaXdUcG01?=
 =?utf-8?B?bnY5TGFZdWJzUVZxZzBYdGEyUzFRUGlVOG03RW1MeGJOTE5pVERrRnZyZzF2?=
 =?utf-8?B?L3FsQWFWYzV1UzhubDBTQ25ubHB0QXBUUHdVdmtGT3pqcG9rc3ZhQVV2OVRZ?=
 =?utf-8?B?bVZ5NjZtTk1HaHNldHk0TU5ISUlYMXRNQ3lVdmRvbE05VUFDQUlqUDNycURV?=
 =?utf-8?B?TzVtTlpMTjVsdFBmREV0ZS85T1J4QjFlRHEvMElENVh3TTRFMVR2UDg2UVBz?=
 =?utf-8?B?Q1hVZ0gyNEViZk1ZdDRqck55d01KQjRhb09oaXlZbUtXNm05T09OVEVRbXJY?=
 =?utf-8?B?OEkwTUMyTGxJMVUvWTh4d2d6Z3VJNE9iWElhVGhsRTVxUDFOSzdGSFNxeTRy?=
 =?utf-8?B?UkQxbElOWEYwaWdxOHF4V0tHYkhoWThubWErN1VhRE1ocVpicHZVTG5JeWZm?=
 =?utf-8?B?bEZaYnhoL1YyTFJUK05XK1Z0L3p3WEk5cUNxQnp2NXozTGRyWCsvajY5UWhU?=
 =?utf-8?B?bW9GMEVhMHd6VFdtNGU3QXVhcnVKS0k1bGVKeTc2Rks0dms1eXZLOEVhQ0Jh?=
 =?utf-8?B?WkcyOEdDaVQ1SVVvb0Z5cllrbnl6b0ducXMveEdKc2p6WGNOSy9zSmZtREtp?=
 =?utf-8?B?a1YxcjQ5STFqRVgxWWNPMVhqYXdLUnovcEpLYTFDKzNHMkRyR0tSSU9sTUpP?=
 =?utf-8?B?eXpyYXRTeWFKUjVMTDhKS1VCMWE1ZjU5YWVRQUlaRmQ1K05ZajMzZjRzWWZN?=
 =?utf-8?B?ZDkxc2thRUZRNjlSRklEVHdUQzhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0965E8C0BD0A0438BCE29E9F8B93366@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f66e878e-353e-45dc-1716-08db6232e457
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 23:58:12.1643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BhzJf4EiyTtJKyvBPkynnSrEJJhyVlFNI2sPNkro20/ljiYvI4Z045G/T/2kh7Lz4BsMFhIpSFPEniX2nH8sOdcuhPTYs4onLjEW6omGtXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10059
X-Proofpoint-GUID: nCueayZ1rYigAeEPxcfBsvPRNTfV68fj
X-Proofpoint-ORIG-GUID: nCueayZ1rYigAeEPxcfBsvPRNTfV68fj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCA3OjE4IFBNLCBKb3NoIFBvaW1ib2V1ZiA8anBvaW1i
b2VAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAzMSwgMjAyMyBhdCAxMTow
MToxMkFNIC0wNDAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gUmVtb3ZlIGJhcnJpZXJfbm9zcGVj
KCksIHdoaWNoIHRyYW5zbGF0ZXMgdG8gTEZFTkNFLCBpbg0KPj4gdm14X3NwZWNfY3RybF9yZXN0
b3JlX2hvc3QoKSBhcyBSU0ItYmFycmllcnMgKGFzIGRlZmluZWQgYnkgWzFdKQ0KPj4gYWxyZWFk
eSBleGlzdCBwcmlvciB0byB0aGlzIHBvaW50Lg0KPj4gDQo+PiBUaGlzIExGRU5DRSB3YXMgYWRk
ZWQgb24gY29tbWl0IGZjMDI3MzViMTRmZiAoIktWTTogVk1YOiBQcmV2ZW50IGd1ZXN0DQo+PiBS
U0IgcG9pc29uaW5nIGF0dGFja3Mgd2l0aCBlSUJSUyIpIGluIHRoZSA1LjE5IHRpbWVmcmFtZTsg
aG93ZXZlciwNCj4+IGNvbW1pdCAyYjEyOTkzMjIwMTYgKCJ4ODYvc3BlY3VsYXRpb246IEFkZCBS
U0IgVk0gRXhpdCBwcm90ZWN0aW9ucyIpIGluDQo+PiA2LjAgdGltZWZyYW1lIGFkZGVkIGEgTEZF
TkNFIGZvciBYODZfRkVBVFVSRV9SU0JfVk1FWElUX0xJVEUgd2FzIGFkZGVkDQo+PiBkaXJlY3Rs
eSBpbiB2bXhfdm1leGl0LCBwcmlvciB0byBDQUxMIHZteF9zcGVjX2N0cmxfcmVzdG9yZV9ob3N0
Lg0KPj4gDQo+PiBGb3IgcG9zdGVyaXR5LCB2bXhfc3BlY19jdHJsX3Jlc3RvcmVfaG9zdCBhbHNv
IHdpbGwgZXhlY3V0ZSBXUk1TUiB0bw0KPj4gSUEzMl9TUEVDX0NUUkwgZm9yIFg4Nl9GRUFUVVJF
X0tFUk5FTF9JQlJTIG9yIHdoZW4gZ3Vlc3QvaG9zdCBNU1IgdmFsdWUNCj4+IGRvZXMgbm90IG1h
dGNoLCB3aGljaCBzZXJ2ZXMgYXMgYW4gYWRkaXRpb25hbCBSU0ItYmFycmllci4NCj4+IA0KPj4g
WzFdIGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9f
d3d3LmludGVsLmNvbV9jb250ZW50X3d3d191c19lbl9kZXZlbG9wZXJfYXJ0aWNsZXNfdGVjaG5p
Y2FsX3NvZnR3YXJlLTJEc2VjdXJpdHktMkRndWlkYW5jZV9hZHZpc29yeS0yRGd1aWRhbmNlX3Bv
c3QtMkRiYXJyaWVyLTJEcmV0dXJuLTJEc3RhY2stMkRidWZmZXItMkRwcmVkaWN0aW9ucy5odG1s
JmQ9RHdJQmFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVy
Q1EmbT1tV3Rkb3hEWTVjT1JfYUtBdFY5RDhrSGZlV2kzODBrMWtZd0dCX1JBUFRFTDFGX0FVU3N0
WWJldnlWbjlsaGstJnM9SUctZ1pmalBHT19YSTlGa2RicnZaRnZIUHlXTVFEOEVLOUF1QkVwVlk5
NCZlPSANCj4+IA0KPj4gRml4ZXM6IGZjMDI3MzViMTRmZiAoIktWTTogVk1YOiBQcmV2ZW50IGd1
ZXN0IFJTQiBwb2lzb25pbmcgYXR0YWNrcyB3aXRoIGVJQlJTIikNCj4+IEZpeGVzOiAyYjEyOTkz
MjIwMTYgKCJ4ODYvc3BlY3VsYXRpb246IEFkZCBSU0IgVk0gRXhpdCBwcm90ZWN0aW9ucyIpDQo+
IA0KPiBTb3JyeSwgSSBrbmV3IEkgc2hvdWxkIGhhdmUgcHV0IGEgY29tbWVudCB0aGVyZS4NCj4g
DQo+IFRoZSBnb2FsIG9mIHRoaXMgYmFycmllcl9ub3NwZWMoKSBpcyB0byBwcmV2ZW50IHNwZWN1
bGF0aXZlIGV4ZWN1dGlvbg0KPiBmcm9tIGJ5cGFzc2luZyB0aGUgU1BFQ19DVFJMIHdyaXRlIChk
dWUgdG8gbWlzcHJlZGljdGlvbiBvZiB0aGUNCj4gY29uZGl0aW9uYWwgYnJhbmNoLCBTcGVjdHJl
IHYxIHN0eWxlKS4gIE90aGVyd2lzZSB0aGUgbmV4dCBpbmRpcmVjdA0KPiBicmFuY2ggb3IgdW5i
YWxhbmNlZCBSRVQgY291bGQgYmUgYW4gYXR0YWNrIHRhcmdldC4NCj4gDQo+IFNvIGFueSBwcmV2
aW91cyBMRkVOQ0VzIGJlZm9yZSB0aGF0IGNvbmRpdGlvbmFsIGJyYW5jaCB3b24ndCBoZWxwIGhl
cmUuDQo+IA0KPiAtLSANCj4gSm9zaA0KDQpBaCBpbnRlcmVzdGluZy4gT2ssIHRvIGJlIGNsZWFy
LCB0aGF0cyBhIGd1ZXN0IC0+IGhvc3QgYXR0YWNrLCBjb3JyZWN0PyBBbmQgc3VjaA0KYW4gYXR0
YWNrIHdvdWxkIG5vdCBhdCBhbGwgYmUgdGh3YXJ0ZWQgYnkgdGhlIGZpcnN0IENBTEwgcmV0aXJl
ICsgTEZFTkNFIHRoYXQNCndhcyBhZGRlZCBvbiBjb21taXQgMmIxMjk5MzIyMDE2ICgieDg2L3Nw
ZWN1bGF0aW9uOiBBZGQgUlNCIFZNIEV4aXQgDQpwcm90ZWN0aW9uc+KAnSk/IFNvcnJ5IHRvIGJl
IGxvbmcgd2luZGVkLCBqdXN0IHdhbnRpbmcgdG8gdHJpcGxlIGNoZWNrIGJlY2F1c2UNCnRoZSBh
Zm9yZW1lbnRpb25lZCBjb21taXQgd2FzIGFkZGVkIHNsaWdodGx5IGFmdGVyIHRoZSBvcmlnaW5h
bCBvbmUsIGFuZCBJIA0Kd2FudCB0byBtYWtlIGV4dHJhIHN1cmUgdGhhdCB0aGV5IGFyZW7igJl0
IHNvbHZpbmcgdGhlIHNhbWUgdGhpbmcuDQoNCklmIHRoYXQgaXMgaW5kZWVkIHRoZSBjYXNlLCBk
b2VzIHRoYXQgY29tbWl0IG5lZWQgdG8gYmUgcmV2aXNpdGVkIGF0IGFsbD8NCg0KT3IgYXJlIHdl
IHNheWluZyB0aGF0IHRoaXMgSW50ZWwgdnVsbmVyYWJpbGl0eSBuZWVkcyAqdHdvKiBMRkVOQ0Xi
gJlzIHRvIGtlZXANCnRoZSBob3N0IHNlY3VyZT8NCg0KSWYgdGhhdOKAmXMgdGhlIGNhc2UsIHRo
YXTigJlzIGZpbmUsIGFuZCBJ4oCZbSBoYXBweSB0byB0cmFuc2Zvcm0gdGhpcyBjb21taXQgaW50
bw0Kc29tZSBjb21tZW50cyBpbiB0aGlzIGFyZWEgdG8gY2FwdHVyZSB0aGUgaXNzdWUgZm9yIGZ1
dHVyZSBvbmxvb2tlcnM/DQoNCg==
