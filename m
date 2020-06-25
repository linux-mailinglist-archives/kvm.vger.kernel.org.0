Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8620A306
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390862AbgFYQdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:33:07 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:6225
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390007AbgFYQdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 12:33:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Upjm6fiC+DoZbz5BGzWV673A69gWBWkadS7iGgqefCyb9tOvnwrOjJ7K/VVNYfHqEBVswg4baxLSE7/63Wr6Z6tpVlaavvDpvAnjrAC6h+f88XmdP6RPRAPyvg7Gn/zyVsT+4Yidatb/rj+UxMWfixo5NSrq3LQOQMWZcbHCMr38kqCrajE3V/TzOkJWWa3SctdR7vIa269R7OhmkBhGqhqK+leqhmCUVBvZGIWxHHlUcnTttFWifCEvaYWEotQzcNIMH3ZAH7ZXiEKkBgU2G2b5fT3ywKBGxXU7gC4arJHn6w2AF4OuVt7CwsFB4L889HA9fV44twVkQrI7pz7Jew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aECQopGjmkpXBvaqfk5Bbe/vAwJ4WEnwclqGp6caqtw=;
 b=JH4RHgaI3C44xeI4ZmiZRyuW1+2g7I9ij76ZacaTm/HSFPHLfE1ipNszI9X1WKt0cciHr7MHuiV93LyE2MhsMr2dEPHA53RFObd1vFeuDXU6OFBu/kr1iB8bGRa7B7ArlZGioiP4iOMfou49q0m1W1DhTr0vYLnrQCvweLkvXCZeCFGMLPyQH7FuXy33oJWA5XaXU7190eELDYn1dAABUef+TrXXozN6k6YKVMKAri8PZ1Ts8LfZ4qb7Wbwhed1mN5vPTLlqIn9rmM7Uei2oYfTAmOCYwYoFJsJ0ttNAKkzaffHhtaf2Na73M1Rz5CyK4M5pix/pNNsKUB66lPzTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aECQopGjmkpXBvaqfk5Bbe/vAwJ4WEnwclqGp6caqtw=;
 b=XzyemskIg+Eq3+TIagNwUC4U6sntxab0FuHoYUODwDiNLdx6pRDYVKe7NvRzVwFqH/R1UM/QXaUYbj2H7tOtoO71PniNUR44iuu3wP3LmepcqPNpAgz+jqnlfTZLsZY4Leh7BSQwxX8wJoAYfUY8mB8hxpkysI5M6sOMUXfZx7Y=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BY5PR05MB7189.namprd05.prod.outlook.com (2603:10b6:a03:1d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10; Thu, 25 Jun
 2020 16:33:04 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3153.010; Thu, 25 Jun 2020
 16:33:04 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: fix failures on 32-bit due to
 wrong masks
Thread-Topic: [kvm-unit-tests PATCH] x86: pmu: fix failures on 32-bit due to
 wrong masks
Thread-Index: AQHWRnGg65cszY9EKUS3gD7wnxztI6jpj7MA
Date:   Thu, 25 Jun 2020 16:33:04 +0000
Message-ID: <7C9B3448-6547-4813-AD40-109E2D413D51@vmware.com>
References: <20200619193909.18949-1-namit@vmware.com>
In-Reply-To: <20200619193909.18949-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:5ca0:c8b1:77cc:5741]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c36d172-84cb-4e4b-0d93-08d819256f29
x-ms-traffictypediagnostic: BY5PR05MB7189:
x-microsoft-antispam-prvs: <BY5PR05MB71893DE71978D28DB2FF41AFD0920@BY5PR05MB7189.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6uyFLZIXcK/OdqDwwDY0yUxJTo9QauLlYdQ8xw2RYidIEeeP9lmnpSSlCHhGc+1IWnv6g076t9fzbcilzRuFaal+sV4GQXyg5QhK5MLLOSGiAmr++EBPFU8JiC3vuWYB3lCtePrXzyUdd1E53jXD1fxuBiTSkUUx0Vl7nh15sHyGtjeuNEzFKV+7HKYhEXXrjhAtGN+e/lSktg7X6VbKBzg99VDufnMMy6uszawtLmEKvgCPruGJl/MbPpQi8O7EvFw1XY+afImzu64Jbr3C7ga63DDe3RTHrahRHzIa5FR0arLDY4LyIrHGSMxoV9Ar
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66476007)(5660300002)(36756003)(33656002)(86362001)(6486002)(498600001)(4326008)(2906002)(76116006)(6512007)(66446008)(64756008)(6916009)(66556008)(4744005)(66946007)(71200400001)(83380400001)(2616005)(6506007)(53546011)(186003)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ocPecB3n4wH2MuvJSdtlWZ+3jGIRZwyzcsQih0RVJ3yazL80glC+gbgJk9dMCk/46XTChOHZhQu1z+5zU8fGtPQSGTJ6e1Wm5n4muSulcDwYyOmXt+AUhR7gbFry4KJl/PC4G1unseeJ4Pg5KuXDANELjUeR4lx22r72SxqlkA2PuYp0a9Cny0Gwz/eg8BSTKXMtZrm0ep6pbgFKyWMZ3a62GZOzWEIodRVwxdxFoJm4hdQ01hgKp5BiBCGry2nUmv8c1ZeCDGB2CLJx8ZDkHH/p5UnRtbc+xXxS1UuEC11CL8YT5ZZTcTaheRo7G0WJ5Qf2Q8mozLqyWUlmAChVsiThJzXnIemBDSbyWKzCOVlJxEzDLBSB6Rbzwg4RHleiVGFPMfd2F0VBaoNTAXQwrfIGcpsVbGdD2KPxKlCfziSBA6fh4MR1FVp1Fh54NqyzXIbzrzEiqmHLazT/rt24YvRBtDkJUm/8dAqpcigk9XEjX3NAp5pS2UWHzVRt51YSawaYWkeORjIklcOwp9w/y0odIfBds721Hwe9zKdxh3g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E29CC12624E194CBAE9419D64A84A71@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c36d172-84cb-4e4b-0d93-08d819256f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 16:33:04.0342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cLUr2tFU6z/kyTy45Cei1yzlgGKMKZtnrdiWuArl5Ti1FDOWdktMEf0KHcgVaHi+5vAojIuCIkLmmk1HMUfgiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB7189
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 19, 2020, at 12:39 PM, Nadav Amit <namit@vmware.com> wrote:
>=20
> Some mask computation are using long constants instead of long long
> constants, which causes test failures on x86-32.
>=20
> Signed-off-by: Nadav Amit <namit@vmware.com>
>=20

Paolo,

As you were so quick to respond to the other patches that I recent sent
(despite some defections), I presume you missed this one.

(Otherwise, no rush).

