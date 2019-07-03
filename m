Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5C5E5E5
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfGCN7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 09:59:42 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:39821
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbfGCN7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 09:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNjqZ+aenZhYUq/YghJPylXcAvK1uOEnMqDjRInX0F4=;
 b=87C8volSZekeGaTts18u1345Rh6w+PtdvPMsEZ8ylId0DCn6WgxQjtvUZapyigS5koPGnQGc8Dw9LnYEg08KGRwZkupGHyWJ4actQqDtyV5YaoKjC+27oJXn0dv4x8HsaPfspDsjBEAJpgog5OuVd3Gup4uBEklrBu2QZDIWFGs=
Received: from HE1PR0802CA0011.eurprd08.prod.outlook.com (2603:10a6:3:bd::21)
 by AM6PR08MB3959.eurprd08.prod.outlook.com (2603:10a6:20b:a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2032.18; Wed, 3 Jul
 2019 13:59:33 +0000
Received: from DB5EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::201) by HE1PR0802CA0011.outlook.office365.com
 (2603:10a6:3:bd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2052.17 via Frontend
 Transport; Wed, 3 Jul 2019 13:59:33 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT054.mail.protection.outlook.com (10.152.20.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.15 via Frontend Transport; Wed, 3 Jul 2019 13:59:31 +0000
Received: ("Tessian outbound a1cd17a9f69b:v23"); Wed, 03 Jul 2019 13:59:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2424c75720940826
X-CR-MTA-TID: 64aa7808
Received: from 0fb0bc6fd120.1 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.10.55])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 353DFCD1-7691-4501-8F9A-DDF356E57FD9.1;
        Wed, 03 Jul 2019 13:59:25 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0fb0bc6fd120.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Wed, 03 Jul 2019 13:59:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c2srtvv4DksdOXSnWGlVY0thhjRxq2E2vL/aPmkhXk=;
 b=V3sj3d9MbrVe33Y/tCxbLeYbyca8Dyze6SHXrxeEfgoduW/igwTSDdl50yZU3lZbqJ8VNK1iBQSzRerIwRa1vY7s4dJbUhjZogS62LfjjWDM/PeO8wBm2eqp4S+s82h0cnMt/2BdjfDuvzZDK7Cgxym/AQaYoW7Y5BxgOPUhqs4=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.97.141) by
 AM6PR08MB4951.eurprd08.prod.outlook.com (10.255.120.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 13:59:24 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::c178:d92c:7890:dde4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::c178:d92c:7890:dde4%4]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 13:59:24 +0000
From:   Alexandru Elisei <Alexandru.Elisei@arm.com>
To:     Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Andre Przywara <Andre.Przywara@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 32/59] KVM: arm64: nv: Hide RAS from nested guests
Thread-Topic: [PATCH 32/59] KVM: arm64: nv: Hide RAS from nested guests
Thread-Index: AQHVKBVSo+n491sHA0G5dXeF83Z7Iqa4/t6A
Date:   Wed, 3 Jul 2019 13:59:24 +0000
Message-ID: <94798498-08fb-785e-e03e-3d732952a5a1@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-33-marc.zyngier@arm.com>
In-Reply-To: <20190621093843.220980-33-marc.zyngier@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::24) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:c7::13)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.54]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 751ccb61-dfd7-4db7-58e4-08d6ffbeac14
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR08MB4951;
X-MS-TrafficTypeDiagnostic: AM6PR08MB4951:|AM6PR08MB3959:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3959F9AB11E8A7D623C9B68B86FB0@AM6PR08MB3959.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 00872B689F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(6512007)(2501003)(52116002)(66556008)(386003)(6506007)(53546011)(102836004)(66446008)(476003)(6436002)(11346002)(2171002)(6246003)(2906002)(229853002)(66946007)(73956011)(66476007)(64756008)(76176011)(110136005)(53936002)(26005)(446003)(31696002)(186003)(99286004)(316002)(2201001)(2616005)(54906003)(86362001)(7736002)(71200400001)(6486002)(44832011)(81156014)(8936002)(81166006)(71190400001)(31686004)(486006)(36756003)(5660300002)(4326008)(66066001)(25786009)(14454004)(68736007)(256004)(14444005)(8676002)(72206003)(478600001)(305945005)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4951;H:AM6PR08MB4756.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: SUHxHA5HC+RnpUGc5hfB6FbNXo1TYRQcm9Z9xPi/nULprM7qyrnDcGJkARKJzxZ1bm32L9OYSB8Np9DdiPRM2CTDBElHOs6Tvip3DQL9tZRo4gfsmLtiCDIlasuoqWIyX+3Dw9e0FO3D9Xe0fhnrYERZ4Y0/sMzm0I42RI7WjMZ8Ijkw1lCeIzdUZqgI8WubP6XlM2mUwy6DuYRlPbJx4omUbpWcJm88gUG2R5OTaeI4ouRKAsfGV6I6BDfAlgiwO16oJRRQngGD0OYei/WW4qbYCrYCftRL4auLs5KWEJ25DgfoVmNoqad2zP7+wFr5LS6rogYAmG1CQnWA6y7DQ0/FEghssiaUupgw111CSt1k7Ts8rCtHKYco/430SNy1XU6QpHqov1QAQS3hNBS8AijnVwUtWpyogEN7IeFNfvI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE030ECC4F20204AA40DBAA9D8716FA6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4951
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(2980300002)(199004)(189003)(40434004)(110136005)(4326008)(7736002)(6116002)(2501003)(81156014)(3846002)(336012)(14444005)(31686004)(186003)(8676002)(63370400001)(63350400001)(436003)(5024004)(229853002)(8936002)(316002)(50466002)(99286004)(6486002)(102836004)(486006)(14454004)(26005)(22756006)(81166006)(305945005)(54906003)(2171002)(2906002)(66066001)(47776003)(6246003)(36756003)(6512007)(446003)(11346002)(2616005)(476003)(126002)(2486003)(5660300002)(386003)(6506007)(53546011)(76176011)(70586007)(23676004)(86362001)(72206003)(31696002)(26826003)(70206006)(478600001)(76130400001)(2201001)(25786009)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3959;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 972a2f14-1bae-4c7b-8286-08d6ffbea79f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(710020)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR08MB3959;
X-Forefront-PRVS: 00872B689F
X-Microsoft-Antispam-Message-Info: ge9S1mtgrA1+m6+A0IkDGxza4nLqNKQjuzHM9FzW7oXE7KcCLdEQpypm24FegA/2WAUsnCwwSC+t5JaPE9olf9Nr+VxUWIbn1FyrVGi1VVz3+jL+bAJwRjLzkz319J+jexS66G8uMxrFd2bv6LhEfHDux+WCHRX9f9m+BWz5zpyLVrBjiSsecptBcCFh+jwVaygjwo8JJClZLj+qu/5uD8zk6Pqkh6+2y9KLLUsa0+ywkeWqagyjJruHNuVDU7fosOzKcuaqmhlHlnLN6AQ+EEfJ3mI0bPPDJyZyCo8tkz1UPiXAGyvXM4wohkVsWbOiKH2RJc4qauZnuiA43OKvCBi6Rd/MteJlMCNLNiSwQ55LxM4zUqHCItWBDlkTnvRd1vIN3XJUgcGveAMHPHhkEE+v5LXAQwmZl5pfxmCXppo=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2019 13:59:31.4857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 751ccb61-dfd7-4db7-58e4-08d6ffbeac14
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3959
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiA2LzIxLzE5IDEwOjM4IEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+IFdlIGRvbid0IHdh
bnQgdG8gZXhwb3NlIGNvbXBsaWNhdGVkIGZlYXR1cmVzIHRvIGd1ZXN0cyB1bnRpbCB3ZSBoYXZl
DQo+IGEgZ29vZCBncmFzcCBvbiB0aGUgYmFzaWMgQ1BVIGVtdWxhdGlvbi4gU28gbGV0J3MgcHJl
dGVuZCB0aGF0IFJBUywNCj4ganVzdCBsaWtlIFNWRSwgZG9lc24ndCBleGlzdCBpbiBhIG5lc3Rl
ZCBndWVzdC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJA
YXJtLmNvbT4NCj4gLS0tDQo+ICBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMzIgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyOSBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
c3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gaW5kZXggMzRmMWI3OWY3
ODU2Li5lYzM0YjgxZGE5MzYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdz
LmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiBAQCAtNTc3LDYgKzU3Nywx
NCBAQCBzdGF0aWMgYm9vbCB0cmFwX3Jhel93aShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAg
ICAgICAgICAgICAgcmV0dXJuIHJlYWRfemVybyh2Y3B1LCBwKTsNCj4gIH0NCj4NCj4gK3N0YXRp
YyBib29sIHRyYXBfdW5kZWYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiArICAgICAgICAgICAg
ICAgICAgICBzdHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnAsDQo+ICsgICAgICAgICAgICAgICAgICAg
IGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnIpDQo+ICt7DQo+ICsgICAgIGt2bV9pbmplY3Rf
dW5kZWZpbmVkKHZjcHUpOw0KPiArICAgICByZXR1cm4gZmFsc2U7DQo+ICt9DQo+ICsNCj4gIC8q
DQo+ICAgKiBBUk12OC4xIG1hbmRhdGVzIGF0IGxlYXN0IGEgdHJpdmlhbCBMT1JlZ2lvbiBpbXBs
ZW1lbnRhdGlvbiwgd2hlcmUgYWxsIHRoZQ0KPiAgICogUlcgcmVnaXN0ZXJzIGFyZSBSRVMwICh3
aGljaCB3ZSBjYW4gaW1wbGVtZW50IGFzIFJBWi9XSSkuIE9uIGFuIEFSTXY4LjANCj4gQEAgLTE2
MDEsMTMgKzE2MDksMTUgQEAgc3RhdGljIGJvb2wgYWNjZXNzX2Njc2lkcihzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCwNCj4gIH0NCj4NCj4gIC8qIHN5c19y
ZWdfZGVzYyBpbml0aWFsaXNlciBmb3Iga25vd24gY3B1ZmVhdHVyZSBJRCByZWdpc3RlcnMgKi8N
Cj4gLSNkZWZpbmUgSURfU0FOSVRJU0VEKG5hbWUpIHsgICAgICAgICAgICAgICAgIFwNCj4gKyNk
ZWZpbmUgSURfU0FOSVRJU0VEX0ZOKG5hbWUsIGZuKSB7ICAgICAgICAgIFwNCj4gICAgICAgU1lT
X0RFU0MoU1lTXyMjbmFtZSksICAgICAgICAgICAgICAgICAgIFwNCj4gLSAgICAgLmFjY2VzcyA9
IGFjY2Vzc19pZF9yZWcsICAgICAgICAgICAgICAgIFwNCj4gKyAgICAgLmFjY2VzcyA9IGZuLCAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gICAgICAgLmdldF91c2VyID0gZ2V0X2lkX3Jl
ZywgICAgICAgICAgICAgICAgIFwNCj4gICAgICAgLnNldF91c2VyID0gc2V0X2lkX3JlZywgICAg
ICAgICAgICAgICAgIFwNCj4gIH0NCj4NCj4gKyNkZWZpbmUgSURfU0FOSVRJU0VEKG5hbWUpICAg
SURfU0FOSVRJU0VEX0ZOKG5hbWUsIGFjY2Vzc19pZF9yZWcpDQo+ICsNCj4gIC8qDQo+ICAgKiBz
eXNfcmVnX2Rlc2MgaW5pdGlhbGlzZXIgZm9yIGFyY2hpdGVjdHVyYWxseSB1bmFsbG9jYXRlZCBj
cHVmZWF0dXJlIElEDQo+ICAgKiByZWdpc3RlciB3aXRoIGVuY29kaW5nIE9wMD0zLCBPcDE9MCwg
Q1JuPTAsIENSbT1jcm0sIE9wMj1vcDINCj4gQEAgLTE3MDAsNiArMTcxMCwyMSBAQCBzdGF0aWMg
Ym9vbCBhY2Nlc3Nfc3Bzcl9lbDIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiAgICAgICByZXR1
cm4gdHJ1ZTsNCj4gIH0NCj4NCj4gK3N0YXRpYyBib29sIGFjY2Vzc19pZF9hYTY0cGZyMF9lbDEo
c3RydWN0IGt2bV92Y3B1ICp2LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnAsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnIpDQo+ICt7DQo+ICsgICAgIHU2NCB2YWw7
DQo+ICsNCj4gKyAgICAgaWYgKCFuZXN0ZWRfdmlydF9pbl91c2UodikgfHwgcC0+aXNfd3JpdGUp
DQo+ICsgICAgICAgICAgICAgcmV0dXJuIGFjY2Vzc19pZF9yZWcodiwgcCwgcik7DQoNClNvIFNW
RSBpcyBtYXNrZWQgaW4gdGhlIG5lc3RlZCBjYXNlIGluIGFjY2Vzc19pZF9yZWcgKHdoaWNoIGNh
bGxzIHJlYWRfaWRfcmVnLA0KbW9kaWZpZWQgaW4gcGF0Y2ggMjUgb2YgdGhlIHNlcmllcykuIExv
b2tzIHRvIG1lIHRoYXQgdGhlIGFib3ZlIGNvbmRpdGlvbiBtZWFucw0KdGhhdCB3aGVuIG5lc3Rl
ZCB2aXJ0dWFsaXphdGlvbiBpcyBpbiB1c2UsIG9uIHJlYWRzIHdlIGRvbid0IGdvIHRocm91Z2gN
CmFjY2Vzc19pZF9yZWcgYW5kIHdlIGNvdWxkIGVuZCB1cCB3aXRoIFNWRSBzdXBwb3J0IGFkdmVy
dGlzZWQgdG8gdGhlIGd1ZXN0LiBIb3cNCmFib3V0IHdlIGhpZGUgU1ZFIGZyb20gZ3Vlc3RzIGhl
cmUsIGp1c3QgbGlrZSB3ZSBkbyB3aXRoIFJBUz8NCg0KPiArDQo+ICsgICAgIHZhbCA9IHJlYWRf
c2FuaXRpc2VkX2Z0cl9yZWcoU1lTX0lEX0FBNjRQRlIwX0VMMSk7DQo+ICsgICAgIHAtPnJlZ3Zh
bCA9IHZhbCAmIH4oMHhmIDw8IElEX0FBNjRQRlIwX1JBU19TSElGVCk7DQo+ICsNCj4gKyAgICAg
cmV0dXJuIHRydWU7DQo+ICt9DQo+ICsNCj4gIC8qDQo+ICAgKiBBcmNoaXRlY3RlZCBzeXN0ZW0g
cmVnaXN0ZXJzLg0KPiAgICogSW1wb3J0YW50OiBNdXN0IGJlIHNvcnRlZCBhc2NlbmRpbmcgYnkg
T3AwLCBPcDEsIENSbiwgQ1JtLCBPcDINCj4gQEAgLTE3OTEsNyArMTgxNiw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjIHN5c19yZWdfZGVzY3NbXSA9IHsNCj4NCj4gICAgICAg
LyogQUFyY2g2NCBJRCByZWdpc3RlcnMgKi8NCj4gICAgICAgLyogQ1JtPTQgKi8NCj4gLSAgICAg
SURfU0FOSVRJU0VEKElEX0FBNjRQRlIwX0VMMSksDQo+ICsgICAgIElEX1NBTklUSVNFRF9GTihJ
RF9BQTY0UEZSMF9FTDEsIGFjY2Vzc19pZF9hYTY0cGZyMF9lbDEpLA0KPiAgICAgICBJRF9TQU5J
VElTRUQoSURfQUE2NFBGUjFfRUwxKSwNCj4gICAgICAgSURfVU5BTExPQ0FURUQoNCwyKSwNCj4g
ICAgICAgSURfVU5BTExPQ0FURUQoNCwzKSwNCj4gQEAgLTIwMzIsNiArMjA1Nyw3IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjIHN5c19yZWdfZGVzY3NbXSA9IHsNCj4gICAgICAg
eyBTWVNfREVTQyhTWVNfVkJBUl9FTDIpLCBhY2Nlc3NfcncsIHJlc2V0X3ZhbCwgVkJBUl9FTDIs
IDAgfSwNCj4gICAgICAgeyBTWVNfREVTQyhTWVNfUlZCQVJfRUwyKSwgYWNjZXNzX3J3LCByZXNl
dF92YWwsIFJWQkFSX0VMMiwgMCB9LA0KPiAgICAgICB7IFNZU19ERVNDKFNZU19STVJfRUwyKSwg
YWNjZXNzX3J3LCByZXNldF92YWwsIFJNUl9FTDIsIDAgfSwNCj4gKyAgICAgeyBTWVNfREVTQyhT
WVNfVkRJU1JfRUwyKSwgdHJhcF91bmRlZiB9LA0KPg0KPiAgICAgICB7IFNZU19ERVNDKFNZU19D
T05URVhUSURSX0VMMiksIGFjY2Vzc19ydywgcmVzZXRfdmFsLCBDT05URVhUSURSX0VMMiwgMCB9
LA0KPiAgICAgICB7IFNZU19ERVNDKFNZU19UUElEUl9FTDIpLCBhY2Nlc3NfcncsIHJlc2V0X3Zh
bCwgVFBJRFJfRUwyLCAwIH0sDQpJTVBPUlRBTlQgTk9USUNFOiBUaGUgY29udGVudHMgb2YgdGhp
cyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25maWRlbnRpYWwgYW5kIG1heSBhbHNv
IGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBs
ZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZG8gbm90IGRpc2Nsb3NlIHRo
ZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2UgaXQgZm9yIGFueSBwdXJwb3NlLCBv
ciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBhbnkgbWVkaXVtLiBUaGFuayB5b3Uu
DQo=
