Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50636F3DB
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 03:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhD3Bzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 21:55:55 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:34062 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhD3Bzx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 21:55:53 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13U1s6wu016065;
        Thu, 29 Apr 2021 18:54:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=7dSfXq8awoO6mgbRBRKlVQ8Ci5ZkoFpohr6Hpi51+5Y=;
 b=ZBU28vGXnHnnbRpCXKO6auHWB+UsjfwbYiB2IrBM4yK/csoDjTaJGYu8iosMZbBZsy6o
 mzY5xDDAq0u3VIlcGNNipB+sCGRaG68uhnnM51q/aOoE06caP5fSBAVreOev/Dg34Gqb
 0C3WoPZwwSbtJKyGbG6ciNVkzOWC5bdaRGHgI/fwYP3ZKEeHSFqB1qfVtDy7MSFeUZ8u
 wKpUntxR0xsiX5jk1zehHj8rWnB107+UuW/OMcunYtR617CBSJbDQrZncnOO57pu8VbF
 Ra5YKzMGM373FOSkUhbqyMQ2as0chlMe0OFfKKpx1maETRPGlKv2i9OprMCQavUQz1N0 mQ== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by mx0a-002c1b01.pphosted.com with ESMTP id 387vtjhjjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 18:54:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmrOHHGptz7a6cGnilJYn97qMJ6zQWJ5rYpYtpSjRyW3CgsxeTnesROcB9euBXSJTa+aS30K8xmb1IIzCz7ToT/wSizzbiZT7MfKffmViUwG3EPVmVNUH2dr1YjD+MQiCWJC/ExRSwfHZGtErK8f7Eni9uhgVwfCCdiLIIrwCcVrZUlWepLyRYAgUcL1bHYBBhBHqBdLbV8BzZJMxC8tRFcqHoIM2qUxJUq54SA+xXIDze789TDlkwqXAEoHUN1gJCKVKMX5d5MZjkAWTSLBi/LQKYKD4ZT8gPfZF3E5ysOeMiS53ZD1s70JnQYJx1beTNYgmi8gO+WjqJ21Cczu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dSfXq8awoO6mgbRBRKlVQ8Ci5ZkoFpohr6Hpi51+5Y=;
 b=DwQpalXM5YoUCuByPf+J+DRApgcf+dUOJhd2Av/yTV372pfJvf3WZI2FZNMy7FtMJ1eAwrYXO/uw4Z5gTCQIqVHsAlSye5gjPteQV0dXxzwLxk/y919XYzRbcR+gaM34O7p0Diwoz/PL3ql98s1gQjJKeChxp+T5W+r4NffKEtwhnupUd/gzXEfQ6doiaQbBgpt8yAlzTZI8fXzxLR/CKgioAUQxSLPcqOvSSam478YORuUsVOHtBlX4r75aaRl0C3Es7DkLO6zRteN30WeI69eEdy22zCEHe27e+FJykBgQ3ownhdOm3s1Roz4yXY1UaLGO4zgvtecZ78XCyRNciw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BY5PR02MB7089.namprd02.prod.outlook.com (2603:10b6:a03:238::13)
 by BYAPR02MB5173.namprd02.prod.outlook.com (2603:10b6:a03:6d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.30; Fri, 30 Apr
 2021 01:54:02 +0000
Received: from BY5PR02MB7089.namprd02.prod.outlook.com
 ([fe80::b451:d958:ef66:51f3]) by BY5PR02MB7089.namprd02.prod.outlook.com
 ([fe80::b451:d958:ef66:51f3%7]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 01:54:02 +0000
From:   Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
To:     Jon Kohler <jon@nutanix.com>
CC:     Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "junaids@google.com" <junaids@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Thread-Topic: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Thread-Index: AQHXPWOxRQKeCmrcKUi/WXx7mQC4fA==
Date:   Fri, 30 Apr 2021 01:54:02 +0000
Message-ID: <F64AE2A0-4E6B-4ABF-B0B8-AD3E5DF3BD0B@contoso.com>
In-Reply-To: <<20210428173820.13051-1-jon@nutanix.com>>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.48.21041102
authentication-results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [98.207.125.158]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a69da83-7ba2-494d-914e-08d90b7ad457
x-ms-traffictypediagnostic: BYAPR02MB5173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB517332D6C76DDD7F762003DD825E9@BYAPR02MB5173.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGFRTg9k2OpLs9REVbhiH5BO9XODOfc0YwJe84ofy8IsqW72GSh7OQrtqLusrNYndxYWqpjOAnJ0zgdLa0Ucr112/21D0jeZSeGaetcpLAYUz6i+p1RlcIe97A3EC7RwRJQQFCj+OigaMSRZQYz7os30k8BiUxJzzRarHype49vyIfVXLHySbcVg4qkswYbZkSLX0KHMSBbFP7BGIEE1RqICiXTT9koGHeGZIEaUxsTjyfDphC1M+h9+DULWRoyQ2Rp3ktj3jfkQmVnYWIB12tbMl6HBGzzdZ0VpJGn7VVd+VvQjQH1+hvUl/peA4bhvIaW4VG7S7KiYeuWdSD3bgQ0fuvNw2IofCFv/7eidk9JWpJNOi+qwCCbnKInn6txpiJPMyRtGtf10/D3va/Y4dqFbhcHJNhdJ45J7150AwqkHsrDCqb8llQVagt/ufpqwhZ1k+I4wXAERcA31aOPOIETvgJFGyJCIbe3MM3dZgxRVtRw9EHm7/ss7lMUCnHJtJjTez6pMv5VUhjha4mgpNSNEGgcDGP2wjTd0a4VVGhqJAFT+xtQD4plIQtJzkPQ4Dyg3w69eMZojnOF1GHozn3aUaP3Hit5wj/Odk7aIY9Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB7089.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(26005)(19618925003)(8676002)(186003)(4326008)(6512007)(6486002)(9686003)(36756003)(8936002)(5660300002)(7416002)(558084003)(478600001)(38100700002)(54906003)(86362001)(71200400001)(316002)(4270600006)(122000001)(2906002)(6636002)(44832011)(6506007)(64756008)(76116006)(66446008)(66476007)(6862004)(66946007)(33656002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OE9yWmNobnR6YkxCd3ZDWDQvcStKeFJabU81a0VYN3p4amcrU2V3OElUM0FT?=
 =?utf-8?B?eVdyLythTmFDcVJLVHlTbnhJTUwzckxleUlpU0NKYlMxUUs1a2xjTE5nV3Er?=
 =?utf-8?B?Qi8rdkhmWnNPMjB5SkpVU2xGTFQvQkVUZ1RneUREL1RsRS9wYWw0SEhpQTBp?=
 =?utf-8?B?SXVEbUZRU2xiaEFjU0VyeUhkaTBUTzRKZ3BoN1R2eDVPNVlLcGNxeUx1cXdC?=
 =?utf-8?B?VnZHSm1sTkpWMGM5a1ZHZ05sWVExVTB6SjFyelNJL0kwSW1HMDZjVmxwMjZt?=
 =?utf-8?B?d0gzTm1FU0tacWMrY3NtUDY2MGtzd204eGFEdVZZbHJ2WmhjblE1aHRPODVF?=
 =?utf-8?B?WTRBZ2xVcmgrVzVGWEZtbWlTQm9BSEI4T25SK1lSTEFwQmpERVkveHNIMmo2?=
 =?utf-8?B?NlpldkJLaDFLRXJtZEdOSWxiWWV3dit6WFhaOGttU2ZLeU04dzVZTUgzOEtR?=
 =?utf-8?B?bjdDODU4b1BxSU9Gc1hrTWI5SkpveUFydHpPZ1Z0SEh1OUl0TUlEVjdHZ1Jv?=
 =?utf-8?B?L2tNYkdvaERoa3NkZUE2dnAxS24rVGk0R3lNWHJJbnJ3dGcvOXIxQVVYZVBh?=
 =?utf-8?B?c2xSdXovU0d1b3AxR3hYTFFMbmQ4bnc2ODZ5aDRoUnV1Q1BQWGI0UXJ2Mktz?=
 =?utf-8?B?eDZ2TnBDYnc4Ukd5Tnl3TE9yZEg2M0kwdWtWQ2tjNTRpTGhZTXNiNnJSajVY?=
 =?utf-8?B?RTR3YzhMN2ZxbVVHUXNCSmllSEpBOFdUdkIxN0FSUDdIZHdBQmx6bDd5M2Z1?=
 =?utf-8?B?TGEweHgramNYUS9iU3Z3cE13NmFsTmVqT0QyYWJ0cUtoSUxjakgvWWpIRUQy?=
 =?utf-8?B?RjhkQ2lWTUE3T0JKQzV6SGN1QWJNUE8zY0RHajdTQjhFUWFqL0NrYm1wcSt6?=
 =?utf-8?B?Ymt1bkhaeTVBUlZRV29oRDg4bG5CWEdvaVhxVVllZ0ZLZmM4WVlBRXpDYmQv?=
 =?utf-8?B?aDRwL1g0UW80MGF1OFNyMDNOdHBzcEVqN3ZDNy9zd0JEQVNjN2FTTjN5blFi?=
 =?utf-8?B?RlhsZitZQjduTFZqbVE2a240OUtmdElkZHJwNE5PbnQ2Rk1EbzBVODBGRXZh?=
 =?utf-8?B?V1pmekVFcE1DZ3BReEgwOUFUejgrOExONmtaRDV6NDZGbEVuRU1vMi94eGpH?=
 =?utf-8?B?Z3JZSk4wZEZnSzkycmYzYVJrZHppWlZYWG1ZVVEwZ3Q4bERVcUVlcVF6WThx?=
 =?utf-8?B?TXJuZjFmVzBndDRXYjY4MDZpZHc2MVlhbHY5MzluYnkxaDRnbytuUGN5cHRC?=
 =?utf-8?B?Q0VtalhSbUhxNTE4ZXMrME0xOGp1em1sM21CRnVjZGVNUFh6M09XYkk2dUVU?=
 =?utf-8?B?VWozS1hmdmptQXNEWTNpWVQrcXJoL1VqZ0Z3K2drOUEwTGkybitpU3Z4YUVl?=
 =?utf-8?B?RjBOTEFxSXViNnNvdTNCNDRoNDdmT3ZSdmRmdjJWOXlid0QvWWxteTMybkZC?=
 =?utf-8?B?K2EwdFJZeVRsY2hFTnArRGRsU0gzZHdxZjM2K0t1blhBcGoxeE96eVZDdmVN?=
 =?utf-8?B?ZVFzVEs3R1N1dEVCV2ExYUhJa0JGdmRPU1pyV3oyNWd2WDFGaHd3NkhldGpm?=
 =?utf-8?B?ZkI3eUsrcXF5TmNiSGhqeWJmMTVaWHJad3JVOVJlanNOS1F0dThCTjMrOGkx?=
 =?utf-8?B?V2x1Q3UrSnRqd0lMK1FhS2k1UFVQaEhTZUw3V1Q0UjVkVytpY3ZPdllqSDM2?=
 =?utf-8?B?RjN5WEtKT2NTTzI3aVpxQnpKaEpYMC92alNhL0FJSGVMZHpFMzUyV3BUeWw0?=
 =?utf-8?B?MkVuNWlIbWRYYjNyd2FYR2EwZW5XZm1zd3EvREpzOXRuZWU0NVpST1JXWjRW?=
 =?utf-8?B?cldLWEw1NFA4TFVWYlFjUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D807C4E3C49EA84DBE457C9B53AEBF73@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB7089.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a69da83-7ba2-494d-914e-08d90b7ad457
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 01:54:02.5253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HDZ7IOvjMae/iMHpVTUgCsTeWKlPFVjLRi/dJLcvgDHJTWv8ZRf/BH65NjI46OgUUcMOYJy2e4rIBI8VzYtpF6cFq/7FpM25HZ8Xn3HJSCz5yFaNvnN9Bv9e7y68diz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5173
X-Proofpoint-ORIG-GUID: upVY83pmZ4J__y6UrizimXkBN-2wRu_a
X-Proofpoint-GUID: upVY83pmZ4J__y6UrizimXkBN-2wRu_a
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_13:2021-04-28,2021-04-29 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UmV2aWV3ZWQtYnk6IFByYXNoYW50aCBTcmVlbml2YXNhIDxwcmFzaGFudGguc3JlZW5pdmFzYUBu
dXRhbml4LmNvbT4NCg0KDQo=
