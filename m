Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655E369859
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfGOPZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:25:49 -0400
Received: from mail-eopbgr810053.outbound.protection.outlook.com ([40.107.81.53]:56768
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730650AbfGOPZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 11:25:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eN6ONlz29HlNTQQmZyR9Q0Cqqibf5wXkg+4jfWUFmbaVf9FBTNsNRsJAveuCDLwe277kyhXUMDrHMUZd/PZpF+VWvdndhH4TT0paGfVikT1UR0PE6avtPu9UxD6bpDNJLkxBaJKxuDfkpU57UNluQO5pFX6Hi+EO8beCZ9KUi7JQUi/bdpIivSEEMad2UVsTW4TlTCKeh7eFKINFe+KvkGNoEtdVIRO1iejyw9TgAc0pqwENBGy3X5LfiVK0RX7Nf75ktwKP4VzVzd7JeiwJ/XN2GqNJls/J+cKCkd1m9PSr6AuqBWt8rrbnOxnzrS+tr7n0ifLFBZPEFboPqRvA3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJp3Z2XIi2XSaZT+2SVa3WQCpicHH6kPsOq70Ikj8jI=;
 b=mSjwMAl3nhTWfttxXM3YSkiNEe2YQCTE25p3l0P4lv2WxvQHnuaAiSLNMAAVuajDcZTFMfI8/4JdOIzGde8edRziE25OAxAjpdkzrc7Og+8ClIHFbtiUGCbRLEYmImhO+BAuxP2WJcmS8vqC6OvMKr07yRG6w7uH7SSFleednqBrvb7QT1f+ZGd8+A6yTFt/VhLhpXIi+paS9s692/0ttwsLY9PYoac7h1hKEHbr67OojXxo+E2syxivWSsHis0fMsWrHcCpLwZuTev1El2AGvFKqq9gYsGEFsYbd0vnV05ubRFeVujWBl3nW5ienhd6FQrVja79FUnWnAGi0TuinQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJp3Z2XIi2XSaZT+2SVa3WQCpicHH6kPsOq70Ikj8jI=;
 b=GkDMWYKizM8j+AXdVK2r1A+FZCPK8EZOLpjpWSc6zWv0pVklY2XTpnWTI65BQ+Jx2/cRefCI3isvD9VhIiUw2K8pgAXZ4UAZZyaMq6xxfr3y2ipx/mNdPMdIz/cno7tsxYBCQcd/AB9CMe70G/ydJxzGQt290AcIeOIjovLWUJE=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3467.namprd12.prod.outlook.com (20.178.199.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 15:25:45 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7%6]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 15:25:45 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Thread-Topic: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Thread-Index: AQHVOw+4rDn9YtKGU0COMSucJynHjabLqgKAgAACLwCAAA6qgIAAEieA
Date:   Mon, 15 Jul 2019 15:25:45 +0000
Message-ID: <3f6616a5-7fd5-c706-4d2b-90341882e602@amd.com>
References: <20190715131719.100650-1-pasic@linux.ibm.com>
 <20190715132027.GA18357@infradead.org>
 <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
 <20190715142045.GA908@infradead.org>
In-Reply-To: <20190715142045.GA908@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:805:2a::39) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7259913-428d-440e-53ff-08d70938b49d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3467;
x-ms-traffictypediagnostic: DM6PR12MB3467:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR12MB3467D4C7221507BCC7DE20DCECCF0@DM6PR12MB3467.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(189003)(199004)(6116002)(3846002)(186003)(25786009)(54906003)(68736007)(26005)(6436002)(66066001)(6306002)(316002)(8676002)(31686004)(446003)(478600001)(2616005)(476003)(11346002)(6512007)(966005)(6246003)(7736002)(256004)(81156014)(8936002)(81166006)(14454004)(7416002)(4326008)(71200400001)(71190400001)(52116002)(76176011)(36756003)(6506007)(386003)(102836004)(6486002)(4744005)(53546011)(53936002)(66446008)(99286004)(64756008)(31696002)(6916009)(5660300002)(229853002)(66946007)(66476007)(66556008)(86362001)(2906002)(305945005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3467;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I7isukUKVnhKbvlQaE37T3MsiqdPyR2En4c7EZ8knmUMbv3FoQyNwQV6mFY2MtHaX9IJsOvmWZ4kKQmN9mDROtB8rVeDLSRB8kukD4X29fi7+rikQFvMTe1glxOvj/DOgd5QF3gwRO4pMr/d+ZOxnNVxQXhPdKl+FdnBYP7bE+850Muy9A/G6plstOY5e5PMud0saoY1cdt1zAI8BjCDVDde6xtYLrT29rwudBAQ5+QtGcZzg4F3vWzA7ADVY0eQEFWyvAYvovUo4AQfouKU0S5AbrXuHCuz3kS8qWHPZ7OQ2O9IQotHwVsVJcBAvrwLEf3bZvaX3ADjP9sC/5N4zmIqkCIJxW2jwE8ZxWPQms0alq5MGgrqvlFcwI62Nv2kQ5aIBFvuTxxRVB39YnXkAvDcf0cEw54Ava2ySXGhPhw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0B0E7303168684AABB6319B9CC87D6B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7259913-428d-440e-53ff-08d70938b49d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 15:25:45.1401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3467
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNy8xNS8xOSA5OjIwIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT2ssDQo+IA0K
PiBJJ3ZlIGZvbGRlZCB0aGUgbWluaW1hbCBzMzkwIGZpeCBpbiwgcGxlYXNlIGJvdGggZG91Ymxl
IGNoZWNrIHRoYXQgdGhpcw0KPiBpcyBvayBhcyB0aGUgbWluaW1hbGx5IGludmFzaXZlIGZpeDoN
Cg0KTG9va3MgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KVG9tDQoNCj4gDQo+IGh0dHA6Ly9naXQu
aW5mcmFkZWFkLm9yZy91c2Vycy9oY2gvZG1hLW1hcHBpbmcuZ2l0L2NvbW1pdGRpZmYvN2JiOWJi
Y2VlODg0NWFmNjYzYTdhNjBkZjllMmNjMjQ0MjJiM2RlNQ0KPiANCj4gVGhlIHMzOTAgZml4IHRv
IGNsZWFuIHVwIHNldl9hY3RpdmUgY2FuIHRoZW4gZ28gaW50byB0aGUgc2VyaWVzIHRoYXQNCj4g
VGhpYWdvIGlzIHdvcmtpbmcgb24uDQo+IA0K
