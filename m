Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E331D05DF
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 06:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgEMEVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 00:21:17 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:1480 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgEMEVQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 00:21:16 -0400
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D4IV6I024396;
        Tue, 12 May 2020 21:21:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Mk/GhjcQEUv8RUInyp5LDgolKmm9jNh7XGOIwWSNKvo=;
 b=fT6L5UyW3AlpNlI9SXkLsd/ADeJXbtnAUUBwqY8k/YZM3eUZGZmru2UnTedRGcc1mJny
 vMrTrcoZZf9xtXc1pHb5SWX40urZkZuUDlVxvbVfnntmwMlwn/KKJxkdQ2h5LZK2mI5/
 HHaGpHQ5xrdFPoQn8BkM6NRMVQj6brCDG8nJoZi0gk2DxFn9Vg83Gcfx+849yR5WOiLW
 qbNMtt/MpMSiOMDjK/oeWXmc5DNVLgxmiA5ZvN5Aat+jgucGEkDcPBfkY566OJdMIbfs
 ku0+G7Z1a2QjyqJtQg54iqJSGQeQdewtFGMAnKlmfRIVlFl6sxEVBmHmUMwsoTcEcdpD tA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3100yn8x1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 21:21:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYzVNgrQK4sq4QUooAWK9ZT3ImWgTX+kY+SnTulZ/W9eT6GyY75BuHwJVM51IlMRxp1rKkUk89YAlquiq069gv6jC1VbIffi72pXG9+7ESafUvbRt5+wdIJmRK3GFuUMVTF3iJOlTSVnwTvZ3SmaDHGd78n/cLht9aCq2FVD1mbGIPEB8GH35V3mdWiKgcpI5PJOeXZBBC2MxTPfjpaFM55I9Ef0JOqbnSGZM2jxhmH4TWpoutsNJgHak7gJQZbwcoKTBZ/Qlfmx8fbTJOngb60nAluslqGs9kd2HHwxSUOZY297mbHCgNHZQST4Dt4F2ZKpSVCuAKXqtVsczNYAzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mk/GhjcQEUv8RUInyp5LDgolKmm9jNh7XGOIwWSNKvo=;
 b=KUz6f8BNpNYGGciRtFpO80KmzS6/ZSget/k4yo4uN4lpj4E56Fd7qTzbEmPJyvtOMHQKj2PgBFTVTdg2WbxaHa9QhJDpYB8led6EiR901n9eXTwLXAWhWW14jovLtIhQS+7Vxq9KnE/xnVNklqzMMG8AVkK1Ca67RqHo3T4jL58CvSOTZ8jRe/zKyfpaPJVRkVv6WLuN3futlmkiHgTEc1ACoNAGdf69Z3YA6L6sA/7bBtsaWND2Lsw6TIFToOGjjPifRdjnzD9ATWJawyWVgVDMQQLV0cmlqSKq95JlfPaI1XUhWHzjexUH8fULqZNgJECJnG90AYp+T+DF1V9O3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB5735.namprd02.prod.outlook.com (2603:10b6:a03:128::30)
 by BYAPR02MB5413.namprd02.prod.outlook.com (2603:10b6:a03:99::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 04:21:13 +0000
Received: from BYAPR02MB5735.namprd02.prod.outlook.com
 ([fe80::b1a7:d1d2:ec70:66e]) by BYAPR02MB5735.namprd02.prod.outlook.com
 ([fe80::b1a7:d1d2:ec70:66e%5]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 04:21:13 +0000
From:   Suresh Gumpula <suresh.gumpula@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Virtual LAPIC page corruption
Thread-Topic: Virtual LAPIC page corruption
Thread-Index: AQHWKN3voVV18REUfU2qO8eUl1dg+A==
Date:   Wed, 13 May 2020 04:21:12 +0000
Message-ID: <67D1E884-FE2C-44C3-8214-75958A9D445A@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
x-originating-ip: [192.146.154.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e030f5b-0378-4724-d86e-08d7f6f5124f
x-ms-traffictypediagnostic: BYAPR02MB5413:
x-microsoft-antispam-prvs: <BYAPR02MB54133CC0DA0A7E5B94875F4997BF0@BYAPR02MB5413.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1jmMUSgfMGH9fqhelk/10EjQDnzw6B6lj/JC7avJzptJD7EeyJklXFtWNXjKgSzFpn80tv8fKmr4D/rLKfREglm92Mis0vYWOKgXCQeuhJMeHGzhjfvMubiYpsD1MlEyncOGclqAmiGtdHRonddt6fSt70zEProh3MMtm/5JVJZaKwIhhL3K6na+F21JqbUWNSIbg1DvgIvxnZGFitIHFG+JH5SxgYS1Mf648ltcCs/6hexWgUt8fQiJ/0R9qiLkIvfQNUGUAyu6VO7R2K1vH0cyirKBXFeJpq+vVyVGlx92VxgX7ij+QudaFe2fv3RuQDeJP33CfvIq/29bz2R/sIcKqJwu37cHwQjKPFRfzgzurji+arH5BtyShqdd2E+DI93Pwp+p1gtA/WChLWcUlbEniMm07RXy3KSh7nUtdTjlr7wq4VelVwOUmLhPeEf+A2C9ZJ35G7NQ/vaO4oedJ80325hN6pNiqVqEQcEcdFgrAbUu5F1Hv6G9hp1U5hu26NocYnSG/lRy22/4fUu+SD5J0J2F4rmx1tmLSRXsIsZER3uF4OrfcYiHMKP8bzjHWlzLnCC1Nr2PjeJQHNrhF3V2OvfPPA75b4DEvGRWg6kFPsOpiUejZ4ZBxXsWF6uWuoWbP2qXZMsrNvgpvbGJdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5735.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(366004)(396003)(136003)(33430700001)(64756008)(478600001)(33440700001)(2906002)(26005)(316002)(966005)(8936002)(71200400001)(186003)(36756003)(450100002)(6512007)(6506007)(3480700007)(66476007)(66556008)(66946007)(66446008)(5660300002)(6486002)(86362001)(110136005)(76116006)(8676002)(33656002)(2616005)(4744005)(44832011)(489414009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Ipa7b/uL6qHGA1WiiNbLl8ghbs4hPRTTxw3wnNHzcNt8BDwZk0vD/+Q/zdjcDD0tNHeuxH5QpSq+P60qK/way+AXcCCbjnGwahzTD13kJCf4TNnL09VxQNuVYm4o+k9KyUkBs+FImyrcUBTTKuFsLIsTMyEh3JFnd759rXcWDQxmpOOj1cuktStRynEa8JK4kAiZjaOZSW4oRtAeE7tUZG2P+SxzcHkIW4TOukHxNL34nUbcnt48vuNhtnQg/BUa3IvIJIb0MLYoNZf6ASjDPbBr25U8+UcVUz3AgebJfJGKfjtu5KL6p/fSWEdT5mjgE/3EZZCR0oXjpQDwgkT09A4QtwYAYUK9+kHJuAg52U1gpoXE7gLuiBmdK4Un5c6Dat3enZaxqowdeUuH3rQfjzOOpshBKbYVCPb2fV1ywv8Q0F7G4SdVIMM6Kif2oZHcxxZdjJJA7YUOr4iha0uHWD5B3jGm5i2T6myH2DU2WrM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4EB724E62F2454EA82648C11ED84283@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e030f5b-0378-4724-d86e-08d7f6f5124f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 04:21:12.9678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DzgaR09AliXktagaTQKie+y/wcJ73d+jnCRcQC1nOcWcFMTm4bxbLSfSVboISlRocYU6nOHojbg8DQp5AdML/SXJO0GUvH5NyFnI9e6ZC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5413
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_01:2020-05-11,2020-05-13 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksDQoNCldlIGFyZSBhIHNlZWluZyBhIHByb2JsZW0gd2l0aCB3aW5kb3dzIGd1ZXN0cygyMDE2
LzIwMTJSMikgd2hlcmUgZ3Vlc3QgY3Jhc2hlcyB3aXRoIA0KVmlydHVhbCBBUElDIHBhZ2UgY29y
cnVwdGlvbiBzaW1pbGFyIHRvIHRoZSBmb2xsb3dpbmcgcmVkaGF0IHRpY2tldC4NCmh0dHBzOi8v
YnVnemlsbGEucmVkaGF0LmNvbS9zaG93X2J1Zy5jZ2k/aWQ9MTc1MTAxNw0KDQo+IEFyZzQ6IDAw
MDAwMDAwMDAwMDAwMTcsIFR5cGUgb2YgY29ycnVwdGVkIHJlZ2lvbiwgY2FuIGJlDQoJMTYgIDog
Q3JpdGljYWwgZmxvYXRpbmcgcG9pbnQgY29udHJvbCByZWdpc3RlciBtb2RpZmljYXRpb24NCgkx
NyAgOiBMb2NhbCBBUElDIG1vZGlmaWNhdGlvbg0KDQpIZXJlLCB3ZSBhcmUgc2VlaW5nIHRoZSBj
b3JydXB0aW9uIExBUElDIHBhZ2UgYW5kIGd1ZXN0IGlzIEJTT0QnaW5nLg0KTG9va2luZyBhdCB0
aGUgZ3Vlc3Qgd2luZG93cyBkdW1wLCB3ZSBzZWUgdGhlIGZ1bGwgcGFnZSBpcyB6ZXJvZWQuIEFu
ZCBpdCBzZWVtcyB0aGUgDQpHdWVzdCB3aW5kb3dzIGtlcm5lbCBwYXRjaGd1YXJkIGlzIGRldGVj
dGluZyB0aGlzIGNhc2UgYW5kIHJlc2V0dGluZyB0aGUgVk0uDQoNCklzIGl0IHBvc3NpYmxlIHRo
YXQgS1ZNLCBzb21laG93IGNvcnJ1cHRlZCB0aGUgdmlydHVhbCBMQVBJQyBwYWdlPyAgV2hpbGUg
dGhlIGd1ZXN0IGlzIHJ1bm5pbmcNCnRoZSBLVk0gaXMgbm90IHN1cHBvc2VkIHRvIHRvdWNoIHRo
YXQgdmNwdSBsYXBpYyBwYWdlPw0KDQpDb3VsZCB5b3UgcGxlYXNlIGdpdmUgdXMgc29tZSBwb2lu
dGVycyBvbiB3aGF0IGNvdWxkIHdyb25nIGhlcmUuIElzIGl0IGEga25vd24gaXNzdWUgaW4gdGhl
IGt2bT8NCldlIGFyZSB1c2luZyB0aGUgaG9zdCBrZXJuZWwgNC4xOSBhbmQgcWVtdSAyLjEyIGFu
ZCB3aW5kb3dzIGd1ZXN0cygyMDE2LzIwMTIpDQoNCg0KVGhhbmtzLA0KU3VyZXNoDQoNCg0KDQo=
