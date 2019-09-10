Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DDCAEEDB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393966AbfIJPrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 11:47:36 -0400
Received: from mail-eopbgr800058.outbound.protection.outlook.com ([40.107.80.58]:2176
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726664AbfIJPrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 11:47:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S40FcFW+unTBTJ27FuHyu6XpiqlX2FSzL44vYcPnmpHFxOUUZUout7jkZ8PXZ/g4PcEdWiEZPXtFFWrArvOQ++enW7YUXNgrUEG/Kr/EhKafuE1NPNGSK7OhaDuofPjHy7XHYjTc8qa8H/6kLv01DM6FC6aff0j4gFTyQvdeIk9fMOnfZ8mHj0qJEhXJcM2GLpG0JRJn0tM+wPrMNnzOh/sC87MMVAHuPfG82JvdgPRXxy71DR0+r4hQDe/SWT1PiU78VJDpEVk+od+hfYsIS3WAHZJBo/4foXOJRERLe2LF0EUY9wx7Js25skfGYI8aYkvkyg0KbGNDPdF/R7e13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zVi2Of8ZGrAWFrDslKp6AytFw8VvE4KwncfUu9wBdc=;
 b=K2fWasztkHL/dMBCKezefug7u2q62dDfZO6XB7TTTjYnVT3s+d6XHe9u1cuc0rZMegJ6ffjzs05VJLM0FrR9HbSg9ESidocm5HaUjsrcS/Ivkha3PdxVfw1kV1sS7GVpzPWUKYdMcdMfByiBkFYHQ90nmjZNlnKGRFz2ypDDd+69ccJng57aV/xd93MH/c1X14OM3u6XTFYYeUXdrdEc+J3eThvfurU3Cs3bxEQIad/AH+goMjU4MwYlGl2xDYv0TsOFCcpxbmm4OTgn0k8YuCr6IyS+kRzx2VRsm8SrGdvN5BxASjtYaaN1y0qZAwcyhtPxFM+ay/Ndt+bfjUsPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zVi2Of8ZGrAWFrDslKp6AytFw8VvE4KwncfUu9wBdc=;
 b=XIsdM2YzaKMp9NxXnN83LZG5yQRgJiEgPn742fM/EAggAeQG+4lsipxICv7htZf4b3xM8NbxwXxgd+dXZm25ASdTluqiC2kVFk1xfUwSa9Co2SpaxkFPpI+Bo/yMH+lcr5ukJhv9GTR4gTpgm1FtyTzrh1x8hihnbmJ2e7TBBN0=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3644.namprd12.prod.outlook.com (20.178.199.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Tue, 10 Sep 2019 15:46:54 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 15:46:54 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "Graf (AWS), Alexander" <graf@amazon.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Schoenherr, Jan H." <jschoenh@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVU4YFgD8+7+7+rEC5OVevDFYqvqcCTLuAgA5zwgCAAEh/AIAULeUA
Date:   Tue, 10 Sep 2019 15:46:54 +0000
Message-ID: <5f0eb131-d3a5-d1f5-0d7b-be0623e781c9@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
 <1ed5bf9c-177e-b41c-b5ac-4c76155ead2a@amazon.com>
 <5aaef6f4-4bee-4cc4-8eb0-d9b4c412988b@amd.com>
 <82C8A08D-6CB3-4268-BF79-802E1015E365@amazon.de>
In-Reply-To: <82C8A08D-6CB3-4268-BF79-802E1015E365@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN4PR0501CA0094.namprd05.prod.outlook.com
 (2603:10b6:803:22::32) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eef8d468-e243-4306-3edd-08d736061a7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3644;
x-ms-traffictypediagnostic: DM6PR12MB3644:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB364477E8E2483D7355EBDE78F3B60@DM6PR12MB3644.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(199004)(189003)(99286004)(71200400001)(2906002)(316002)(52116002)(4326008)(58126008)(11346002)(2616005)(71190400001)(305945005)(256004)(14444005)(31696002)(446003)(186003)(7736002)(486006)(6486002)(54906003)(53936002)(26005)(81166006)(6506007)(8676002)(81156014)(53546011)(386003)(36756003)(14454004)(229853002)(476003)(8936002)(76176011)(66066001)(66446008)(6916009)(65806001)(64756008)(6246003)(66556008)(66476007)(66946007)(6116002)(65956001)(3846002)(6512007)(5660300002)(25786009)(478600001)(102836004)(31686004)(86362001)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3644;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eHY2YQnrHIvb0xJVTSVnCGH4k6huAcIOuUj94S60qWSgPVH7T0gzB03TDzOSXadzmmGY+f2tO1D9FTMaxRzaXV+5GRYN56OXp/W4pkuBGTIF7oNLDMzFSwJNCTzZmRZqCkaYD8WfKNIJiw8Q6BQumo6zhQ6M5pl6RpYavW7qq+FE41AkH8/QOh8cf9xiWXXXc61Mt2DQS2PZYDliKeN6mhQQl0Zf+wL0cM0yHlnArSD1LCYdDAV5Gqi7ENoI7Rr8nleblU9oRWkJtbqh0G2ic733HdNcLqcjQMJxQo5AsH5YlDiZrTyPpw4Hh9YK/A6U8R/vuxxjgleI/BBSgzN/Bg+dslyhWGAyVO+G1T/+6KDpM1rNV2z2wbHG5uoq0vSIoBXZK+cxXSgHFIEwgChzckP44sxaG5Tm5GHeFb0bwpI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F62DD3126B8C7C438F27AE6B8A22D5F4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef8d468-e243-4306-3edd-08d736061a7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 15:46:54.0521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AeDE0ALH3ZIb6tfgZy6NikH1S5KK6/gnptOnGXtqaX20qy3suaVHi3kdEFXCNajkOwXy6kO1n2fn483JCQpzGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3644
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8yOC8xOSAyOjM3IFBNLCBHcmFmIChBV1MpLCBBbGV4YW5kZXIgd3JvdGU6
DQo+Pj4+IEBAIC01NTIyLDkgKzU1NTgsNiBAQCBzdGF0aWMgdm9pZCBlbmFibGVfaXJxX3dpbmRv
dyhzdHJ1Y3Qga3ZtX3ZjcHUNCj4+Pj4gKnZjcHUpDQo+Pj4+ICAgIHsNCj4+Pj4gICAgICAgIHN0
cnVjdCB2Y3B1X3N2bSAqc3ZtID0gdG9fc3ZtKHZjcHUpOw0KPj4+PiAtICAgIGlmIChrdm1fdmNw
dV9hcGljdl9hY3RpdmUodmNwdSkpDQo+Pj4+IC0gICAgICAgIHJldHVybjsNCj4+Pj4gLQ0KPj4+
PiAgICAgICAgLyoNCj4+Pj4gICAgICAgICAqIEluIGNhc2UgR0lGPTAgd2UgY2FuJ3QgcmVseSBv
biB0aGUgQ1BVIHRvIHRlbGwgdXMgd2hlbiBHSUYNCj4+Pj4gYmVjb21lcw0KPj4+PiAgICAgICAg
ICogMSwgYmVjYXVzZSB0aGF0J3MgYSBzZXBhcmF0ZSBTVEdJL1ZNUlVOIGludGVyY2VwdC4gIFRo
ZSBuZXh0DQo+Pj4+IHRpbWUgd2UNCj4+Pj4gQEAgLTU1MzQsNiArNTU2NywxNCBAQCBzdGF0aWMg
dm9pZCBlbmFibGVfaXJxX3dpbmRvdyhzdHJ1Y3Qga3ZtX3ZjcHUNCj4+Pj4gKnZjcHUpDQo+Pj4+
ICAgICAgICAgKiB3aW5kb3cgdW5kZXIgdGhlIGFzc3VtcHRpb24gdGhhdCB0aGUgaGFyZHdhcmUg
d2lsbCBzZXQgdGhlIEdJRi4NCj4+Pj4gICAgICAgICAqLw0KPj4+PiAgICAgICAgaWYgKCh2Z2lm
X2VuYWJsZWQoc3ZtKSB8fCBnaWZfc2V0KHN2bSkpICYmIG5lc3RlZF9zdm1faW50cihzdm0pKSB7
DQo+Pj4+ICsgICAgICAgIC8qDQo+Pj4+ICsgICAgICAgICAqIElSUSB3aW5kb3cgaXMgbm90IG5l
ZWRlZCB3aGVuIEFWSUMgaXMgZW5hYmxlZCwNCj4+Pj4gKyAgICAgICAgICogdW5sZXNzIHdlIGhh
dmUgcGVuZGluZyBFeHRJTlQgc2luY2UgaXQgY2Fubm90IGJlIGluamVjdGVkDQo+Pj4+ICsgICAg
ICAgICAqIHZpYSBBVklDLiBJbiBzdWNoIGNhc2UsIHdlIG5lZWQgdG8gdGVtcG9yYXJpbHkgZGlz
YWJsZSBBVklDLA0KPj4+PiArICAgICAgICAgKiBhbmQgZmFsbGJhY2sgdG8gaW5qZWN0aW5nIElS
USB2aWEgVl9JUlEuDQo+Pj4+ICsgICAgICAgICAqLw0KPj4+PiArICAgICAgICBpZiAoa3ZtX3Zj
cHVfYXBpY3ZfYWN0aXZlKHZjcHUpKQ0KPj4+PiArICAgICAgICAgICAgc3ZtX3JlcXVlc3RfZGVh
Y3RpdmF0ZV9hdmljKCZzdm0tPnZjcHUpOw0KPj4+IERpZCB5b3UgdGVzdCBBVklDIHdpdGggbmVz
dGluZz8gRGlkIHlvdSBhY3R1YWxseSBydW4gYWNyb3NzIHRoaXMgaXNzdWUNCj4+PiB0aGVyZT8N
Cj4+IEN1cnJlbnRseSwgd2UgaGF2ZSBub3QgY2xhaW1lZCB0aGF0IEFWSUMgaXMgc3VwcG9ydGVk
IHcvIG5lc3RlZCBWTS4NCj4+IFRoYXQncyB3aHkgd2UgaGF2ZSBub3QgZW5hYmxlZCBBVklDIGJ5
IGRlZmF1bHQgeWV0LiBXZSB3aWxsIGJlIGxvb2tpbmcNCj4+IG1vcmUgaW50byB0aGF0IG5leHQu
DQo+IElmIGl0J3Mgbm90IHN1cHBvcnRlZCwgcGxlYXNlIHN1c3BlbmQgaXQgd2hlbiB3ZSBlbnRl
ciBhIG5lc3RlZCBndWVzdCB0aGVuPw0KDQpPaywgdGhpcyBtYWtlcyBzZW5zZS4gSSdsbCB1cGRh
dGUgdGhpcyBpbiBWMy4NCg0KPiBJbiB0aGF0IGNhc2UsIHRoZSBhYm92ZSBjaGFuZ2UgaXMgYWxz
byB1bm5lY2Vzc2FyeSwgYXMgaXQgb25seSBhZmZlY3RzIG5lc3RlZCBndWVzdHMsIG5vPw0KDQpB
Y3R1YWxseSwgdGhlIGZ1bmN0aW9uIG5hbWUgbmVzdGVkX3N2bV9pbnRyKCkgaXMgbWlzbGVhZGlu
Zy4gSGVyZSBpdCANCnJldHVybnMgdHJ1ZSB3aGVuIF9OT1RfIGluIGd1ZXN0IG1vZGU6DQoNCi8q
IFRoaXMgZnVuY3Rpb24gcmV0dXJucyB0cnVlIGlmIGl0IGlzIHNhdmUgdG8gZW5hYmxlIHRoZSBp
cnEgd2luZG93ICovDQogICBzdGF0aWMgaW5saW5lIGJvb2wgbmVzdGVkX3N2bV9pbnRyKHN0cnVj
dCB2Y3B1X3N2bSAqc3ZtKQ0KICAgew0KICAgICAgICAgICBpZiAoIWlzX2d1ZXN0X21vZGUoJnN2
bS0+dmNwdSkpDQogICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQogICAuLi4uDQoNClNv
LCB0aGUgbG9naWMgYWJvdmUgZG9lcyB3aGF0IHdlIHdhbnQgd2hlbiBBVklDIGlzIGVuYWJsZWQu
DQoNClRoYW5rcywNClN1cmF2ZWUNCg==
