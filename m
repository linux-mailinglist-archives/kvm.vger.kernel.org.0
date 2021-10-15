Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3242ED00
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhJOJCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:28078 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhJOJCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:02:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="251324126"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="251324126"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 02:00:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="716452948"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 15 Oct 2021 02:00:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:00:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 02:00:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 02:00:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBKbynlfEP9SnZh30/AG9/D3bqUgXIP0rcWDSk10Aie7aUEmhvsPUyqMcNmquutunj21jMd3jTk4aYpf5ls2zuVDSqrDk+KtYAZDBKI16DhidRkjLuW/MyETQQxHviYFifMGgZTMv7qiugB6Idf7OOOdSbElPS/CX97loP+lP+RrPKMK3Of0xVBGphvRTTC+GeX4K4FQc1BY9uDmDwgKFSIFa+v6K077A17EsycLsS36iAw6KX/qT3Z9xt/ltZO3IstcalNQftZB/ymHSFJ6hNgSrJgKxhvdjJxk+LVBatwBGeaWgYADzf4ud70KwG8Ma/EWe/4lnnhjIQeGi6cy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+8rh/TFbD2MmmNhkW0leL6gZbLDXJ0y+k5Ux7WAWws=;
 b=obxbQrPHnDP/5ssWJkfowvme7wVvSthxZTrYkUzltfLjeGYXQQa15bbjiruwg0InGKKF1Y5DvwtnWKKAO2an4Jb+EI6TGJzCuoJalYXTVwttPMEn8cpsmYhSKLLINDoBa6aBNPNyH3kRsPd+04cTwMf4uDJbHYMtga6h2Q9+evzuHMMSxUqQnsq0gAjBTQMyLPnZSiWD/d1hLYPayLlJYo9ZLY9w5AmFCOQAzg6FOgHd+1nMJDLKk5S9DiyoapshlrwWgYN5uS/41OmfPHD5aKvmbHUrvZTohHcOMXYCCVGxBLzw7mpNmx78arnTrT/z7gZHtU6iOmB08OFv9UNJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+8rh/TFbD2MmmNhkW0leL6gZbLDXJ0y+k5Ux7WAWws=;
 b=eEZ9ymf5vZJPOeGsP18GZwDseWJPwnxCVXk/odbQTmXC+CTCCDwHmMiLWi/YXLZLIRncq8tNwoOZ3KxD6Zx8Bz8Sl5vk6Dd98jOVUbGHr2R6b/8VlO6T638r/Ou8aeL5chB7SXwg4RQjg5n7XyvtuLmvu/r395ErnN93HnW38cs=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3255.namprd11.prod.outlook.com (2603:10b6:a03:1d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 09:00:34 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 09:00:33 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAAFYIAIAADomAgAEsGrA=
Date:   Fri, 15 Oct 2021 09:00:33 +0000
Message-ID: <BYAPR11MB3256D90BEEDE57988CA39705A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
In-Reply-To: <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 152c76c8-153a-4ad8-bbe1-08d98fba3f49
x-ms-traffictypediagnostic: BYAPR11MB3255:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3255BACD489C893B453D4BA5A9B99@BYAPR11MB3255.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Gt7ozZvLNQLHLS61gTFgb2p3ZhAfn3yY5fFu2vQ+xWA3xhIOhboyhQ8Mf+8I9Vyo/0BisCHsEKhNzohi8EmTjl9ch8sQ0v4CFMorH/e5nueTZ7Fz9Iv0NFXgMoCK03zLpIsRofuHOCxY7sObiNbjjDXVKi57KY+x7nztkSf1rY3lirXVc/AOSyKcqx2q3cSNPSbZbtREPdi/e4yB9RTs0hEUV4pChp9sWci3ANtkXcTC4Cz1LlwKneHfkCj3t8mexdNaxFeT8+yXHqluIIjefAcJoeZExILu7YcHPJdfacMrvSsxiVnE/lrEKEejh1K0eKSXa7y3DqTnp64c8YrbMGwY5O+UdUrFPyaKoxNeVP9kpW5vThQ8CTgiUKi6LzwuB8ckw1/D76A5aq6aQkqzzYDUr4Q/JsA84BBHpF/tjWW6iT/SnPmn4SGp/S+s55Zh5CzeddUNTOhdiBjgJTG70JpxQimjnVPkM0e95q++4ls9pewuVSVTBEeJmPTaCa5KxSDqxucVR46USuVJUdwe88dTk171nB8n6pE6NvJfZfb/tXRZJofcY4H+Y2vgrGtiNV8HRqM/XQgQWNT9X03qCQtyNTJXXwBm69gOn0hn1HleDZGvS4+orD6aolDEm0WzANSysckfKBVCtfH9W0Z4koyfqmbADiTfw6Yq7WGP6cFdywa/uuKUL1iYGRpf91ljqsV8R+GK4Z6QwUJpbbAxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(4326008)(7416002)(508600001)(82960400001)(110136005)(54906003)(33656002)(38100700002)(2906002)(76116006)(26005)(53546011)(71200400001)(8936002)(86362001)(9686003)(316002)(55016002)(66946007)(64756008)(66556008)(66446008)(66476007)(52536014)(8676002)(5660300002)(6506007)(38070700005)(7696005)(186003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2RjdXFVZ3BxcHh6c1AwcTJWcXlKRGZjUi9SUGo4NVRpTUp4OWF6d0pWVS9O?=
 =?utf-8?B?RTlxVHc2elBlWjRjYTBsYk84RmZhaDNJekl4Q2FRZkQ5VE5iWjRFK1hHWkZr?=
 =?utf-8?B?YnF1bUIrUHFBVHJOWlZySVhwQWYwTDY1SVZIaGlYanFDVENEaWFlMnl6YzZj?=
 =?utf-8?B?NGxNN2dKb25wak9sN0E0dHc3YmNlN3FsenAwNVcvb1hpY0xGMWZ1VUtrbDhh?=
 =?utf-8?B?TTNnR0I5VzV4akJRWnRzQU5FUk5Ka3RacGlwdHNCLzlHbFVwZzRra0JjMFpS?=
 =?utf-8?B?eG03Vlg5dVNCUVZDR0xndER4WXJBTUNCbGRRS0lEcU9YeDV0WVN2dGFYTEZa?=
 =?utf-8?B?bURRbUdZQWdxSW5zV2c1MkU3YjlUN216Y1VIU3Bndmt0Mnk3cURxWHdLYkJ0?=
 =?utf-8?B?VnQydlM0Tmk2ODlIdVR5Ti9FcGtaQVl5ZlNiUkc5RHdkMUU3bjgvZ0gxeGFi?=
 =?utf-8?B?ZkRaNGR1YWo2ZkpmcVhDMWRQSktvN2xjTThOR3FkTWR5RzZsdDNOcEpYZCt6?=
 =?utf-8?B?eEYwN3M5SUQyS2p3TkZEVkNZYVhjTlVlYmRtb01FZTVJV3VNS1B5SjBjWUsr?=
 =?utf-8?B?RXZoOWRkRnhmYjBENlVHby9xSzVVa3dVQ2k5SFRycStpakE4R3lGakMrNUdx?=
 =?utf-8?B?dnFqRnJEaUtGQklaM0FpUDF0OHBhYldWVUFlSXNaMDc2ZkYvaFgvMVFBR0lM?=
 =?utf-8?B?VEtwa3J1OWhwNWl1Z1hKWm5IczdhclVaUXQ5OWR4OFJDYmtQSEtPQSs3YWJX?=
 =?utf-8?B?YUlpOHh3RS91KzFhUkp5UW5lOEx0cEpNeDdpZ2RaaXRGeUZtalpSanUyR0tW?=
 =?utf-8?B?YTJBVE40SENTdHBKWitMTkQrcUoxM01RY0ZRWko3L3B2Q1hEUHBDS2hySWYx?=
 =?utf-8?B?Ulg5Q0ZmWnRaRmRzMjJqQ2k3ZlpUelcrSEdXMWZpdHZLV09QYWtMb1BwekVz?=
 =?utf-8?B?SWR5TVNib05jR1BPelJLNXZHZWg4WjVuUk5TRXNRMXl4aXlxWTBsTzFETlFo?=
 =?utf-8?B?UmtCamIwNFZ4RTJqa1Z4dUZlUjQ5Qnlib2FnSHN3c2ZpQWlVRjYvWWVpaGh5?=
 =?utf-8?B?UzROVnMzME83WDhiMDRPL3djQ3ZCMkloUnRndG9JSmxEbVhWNExLSG43WVo2?=
 =?utf-8?B?dG11ODUyeTMyUDZBZW03cWRKOUhVKzU0RDNyZVhWR29WcmxQQlh5SVllS2hV?=
 =?utf-8?B?N0wxZDlNdThEN3l0Z3Ywc2JCRFl4ZUwwVUNXM3VVM3RMdTZiYlFDYXF0U0Ry?=
 =?utf-8?B?VGFFQXVmZmZQSlV2UzF6UVVRZ1JsVFZYVDJpMW0zanpISmNVeS9CUG5DZmRM?=
 =?utf-8?B?MjZKMkhUcUlEcnBhZzdYdllIOXM5WVpSLzIxeGEzdHEzM28yQnY4ZTdiSU9O?=
 =?utf-8?B?TjVuY0ExeGJxdVAyMDlyNE96alFNK2Q4VHZ3Ny80VktGWk9MWDgzVEVpUFE4?=
 =?utf-8?B?dHZOUWhZZDNvQkRSTUNPMlBGM2VWYVZBazh2dkNyZnBneUVDMkM1cnU3Q2Vk?=
 =?utf-8?B?SmVyeFpmaUhYOGFQdlg1N3NBN09GYTZZZmZSNGNQMFVhd0FKR3hoWEV0bjBh?=
 =?utf-8?B?OFh4YzlsQWNDa2JxT1FpSWZsM0FUWHBOajAySXVWMnRzT1c4d2tZZHR2ajlp?=
 =?utf-8?B?UGR2ekRxcFYyN3ZDYVVpaFgxUS94UndnOHhwQ2JMeUNyZFRibFNVQ0hxbVVJ?=
 =?utf-8?B?NGM5endiS20yaUVVZ2hQaGN3T2xCY1BlZVI4K3EydTVJYUgrZGdDeVZaWE55?=
 =?utf-8?Q?/o4zklLxmK/QxcYOcco2DZrrj9S4iiHaSJl1Q4p?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152c76c8-153a-4ad8-bbe1-08d98fba3f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 09:00:33.2245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lr64jFi2B/TZTN8sQ7brnTOiwQdzRXVFmcT5hdPT8ekXWnG/voByBI8aWqJ8ABKYdJ2uKSjSo9oe5MazFMYGvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3255
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMC8xNC8yMDIxIDExOjAxIFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KWy4uLl0NCj4g
Q2FsbHMgaW50byB0aGUgZnVuY3Rpb24sIGJ1dCBkb2Vzbid0IG5lY2Vzc2FyaWx5IGFsbG9jYXRl
IGFueXRoaW5nLg0KPiBXaGF0IHlvdSB3cm90ZSBiZWxvdyBsb29rcyBjb3JyZWN0IHRvIG1lLCB0
aGFua3MuDQo+IA0KDQpGb3IgdGhlIGd1ZXN0IGR5bmFtaWMgc3RhdGUgc3VwcG9ydCwgYmFzZWQg
b24gdGhlIGxhdGVzdCBkaXNjdXNzaW9uLA0KZm91ciBjb3BpZXMgb2YgWEZEIG5lZWQgYmUgY2Fy
ZWQgYW5kIHN3aXRjaGVkLCBJJ2QgbGlrZSB0byBsaXN0IGFzIGZvbGxvd3MuDQoNCi0gdmNwdS0+
YXJjaC54ZmQ6IHRoaXMgaXMgdGhlIHJlYWwgZ3Vlc3QgdmFsdWUgZm9yIHJ1bm5pbmcuDQpTaW5j
ZSBrZXJuZWwgaW5pdCBYRkQgYmVmb3JlIFhDUjAsIHNvIEkgdGhpbmsgS1ZNIGNhbiBpbml0aWFs
aXplIGl0IGFzDQpiaXRbbl09MCwgZm9yIGEgZ3Vlc3Qgc3RhcnQgdmFsdWUuIE90aGVyd2lzZSwg
a3ZtX2FyY2hfdmNwdV9jcmVhdGUoKQ0KbmVlZCBpbml0aWFsaXplcyB2Y3B1LT5hcmNoLnhmZD1n
dWVzdF9mcHUtPnhmZD11c2VyX2ZwdS0+eGZkPTEuDQpHdWVzdCB3cm1zciBYRkQgdHJhcCB3aWxs
IG1ha2UgaXQgdXBkYXRlLg0KDQotIHVzZXJfZnB1LT5mcHN0YXRlLT54ZmQ6IFFlbXUgaXRzZWxm
IGFuZCBub3QgZm9yIGd1ZXN0LCB3aGljaCBpcw0KcHJvYmFibHkgYWx3YXlzIHNldC4NCg0KLSBn
dWVzdF9mcHUtPmZwc3RhdGUtPnhmZDogdGhpcyBpcyBmb3IgS1ZNIGludGVybmFsIHZhbHVlIGJl
dHdlZW4gdGltZVsqXS4NCktWTSByZWluaXRpYWxpemVzIGl0IGFzIGJpdFtuXT0wIChub3QgdGhl
IHNhbWUgYXMgdXNlcl9mcHUpLCBhbmQgaXQgd2lsbCBiZQ0KdXBkYXRlZCB3aGVuIGd1ZXN0IHdy
bXNyIHRyYXAuIFRodXMsIGJlZm9yZSBwYXNzdGhyb3VnaCwgaXQncyB0aGUgc2FtZQ0KYXMgdmNw
dS0+YXJjaC54ZmQsIHRodXMgdm1lbnRlci92bWV4aXQgbmVlZCBub3QgcmV3cml0ZSBtc3IuDQpB
ZnRlciBwYXNzdGhyb3VnaCwgdGhpcyBrZWVwcyBiaXRbbl0gYXMgMCBmb3JldmVyLg0KDQotIGN1
cnJlbnRfZnB1LT5mcHN0YXRlLT54ZmQ6IGl0IHNob3VsZCBiZSB0aGUgc2FtZSBhcyBLVk0gaW50
ZXJuYWwgdmFsdWUNCmJldHdlZW4gdGltZVsqXS4NClsqXSB0aGlzIG1lYW5zIGJldHdlZW4ga3Zt
X2xvYWRfZ3Vlc3RfZnB1IGFuZCBrdm1fcHV0X2d1ZXN0X2ZwdS4NCg0KRnJvbSBndWVzdCBib290
aW5nIHRpbWVsaW5lLCAgdGhlIHZhbHVlcyBhcmU6IA0KDQpCb290aW5nIHN0YXJ0Li4uICAgIyBJ
biB0aGlzIHRpbWUsIHZjcHUtPmFyY2gueGZkW25dPWd1ZXN0X2ZwdS0+eGZkW25dPTANCkluaXQg
WEZEIGJ5IFdSTVNSKFhGRFtuXSwgMSkgIAkjIFRoZW4sIHZjcHUtPmFyY2gueGZkW25dPWd1ZXN0
X2ZwdS0+eGZkW25dPTENCkluaXQgWENSMCBieSBYU0VUQlYgCQ0KLi4uDQojTk0gV1JNU1IoWEZE
W25dLCAwKSAgIyBUaGVuLCBndWVzdF9mcHUtPnhmZFtuXT0wLCB2Y3B1LT5hcmNoLnhmZFtuXT0w
Lg0KdmNwdS0+YXJjaC54ZmQgd2lsbCBiZSB1cGRhdGVkIGluIGxhdGVyIHZtZXhpdHMuIA0KDQpC
VFcsIHdlIG9ubHkgbmVlZCBsYXp5LXBhc3N0aHJvdWdoIFhGRCBXUklURSBhbmQgcGFzc3Rocm91
Z2gNClJFQUQgZGlyZWN0bHkuDQoNClRoYW5rcywNCkppbmcNCg0KPiBQYW9sbw0KPiANCj4gPiBB
bHNvIHlvdSByZWFsbHkgc2hvdWxkIG5vdCB3YWl0IHVudGlsIF9hbGxfIGR5bmFtaWMgc3RhdGVz
IGFyZSBjbGVhcmVkDQo+ID4gaW4gZ3Vlc3QgWEZELiAgQmVjYXVzZSBhIGd1ZXN0IHdoaWNoIGhh
cyBiaXQgMTggYW5kIDE5IGF2YWlsYWJsZSBidXQNCj4gPiBvbmx5ID4gdXNlcyBvbmUgb2YgdGhl
bSBpcyBnb2luZyB0byB0cmFwIG9uIGV2ZXJ5IG90aGVyIGNvbnRleHQgc3dpdGNoIGR1ZQ0KPiB0
byBYRkQgd3JpdGVzLg0KDQo=
