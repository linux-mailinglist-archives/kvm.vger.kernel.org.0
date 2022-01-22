Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9747496A61
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 06:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiAVFwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 00:52:50 -0500
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:50785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229799AbiAVFwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 00:52:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfAeQH/2sbZkyEa1TNik+qofULyCBWjaVp3D/A9MEz4JhPTmZEuiV0c1Yd6a7IliggXF9HqwnjSqMmO16Imdywf1VFU5gicWaj2ur38FsUQv0v/MM6oWOrB3zRdzTmeeFWMPs1AfDUpkEGXyGg/fY/IdMJi0nDitzibgh8vmR+5t4QwlRmaoFjOKyNkG8vIy6Opt5McHisNQLB9x/CywCW5jbc63HoZWIu1NbRgmwbVdALMRneyRVoZ+eKbZKnnl+1ffH/9Nx9Nq1u28dSF2vRS2uIzavc1kUh3YZ5RIPnt2IznIHHWXvBSTrmW1NMMaLotduuG7txiiSKNS3wLleg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjXiI1wDrer+tExHmAybAT2yHXCNvTlnfDD7STUrRSY=;
 b=jzxnQ56BqPnmIkI1PfHy4ZhUHW7ubtK9dxkAlw0F9p52+bitcqB1qu8+NqM6I5mwJ/EtOPQH08dmcpE4eFg39hIJRfGHQuRakSDoT5UcPLAucVHDBIyOQlVIngpHpQ9NYu3Addz4pGlCFEOeFDgzp55NxM9HZHc0k89ur2Jj+EXNR4hojDeRTEZh4YUp4wzIh9PDFCIRVuDkQQVVqAXLqZnvVGysDDCwMqZsVOnIt6seaDW+jUXZ9Dmmm/g1Zn1KJO0egdMPPh9yYiF8mvfmkduzUMLn10As57UgYD91W3XRuZ65yShT/gIl5C3DoWHT+086Yki1NDU+8HDjJJyihA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjXiI1wDrer+tExHmAybAT2yHXCNvTlnfDD7STUrRSY=;
 b=x6qzp7W4t++1eMPe0RTHEZG5xjic/Z5Oqv+xSBb4lFZZjkD9Jj+427FE5TuI2bIwpFntOtrwYEbbEc0ikZ+mLouG4KqzzhvvfTDF5i2PVst6epxtyG71wXOvyJnqewU1x63lt4giYPld1CW7azD14MAOsmGYjmGcIrWbH9kJ2cE=
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Sat, 22 Jan
 2022 05:52:48 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::9c25:ce1d:a478:adda]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::9c25:ce1d:a478:adda%6]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 05:52:48 +0000
From:   "Lazar, Lijo" <Lijo.Lazar@amd.com>
To:     James Turner <linuxkernel.foss@dmarc-none.turner.link>,
        Alex Deucher <alexdeucher@gmail.com>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Thread-Topic: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Thread-Index: AQHYDo+lzAdL4BCVWUC/DLCLGS2ze6xtr4mAgACHo4CAAFNgYA==
Date:   Sat, 22 Jan 2022 05:52:47 +0000
Message-ID: <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
In-Reply-To: <87czkk1pmt.fsf@dmarc-none.turner.link>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2022-01-22T05:49:35Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=51f6cb21-2656-41a6-9736-d64bdddf1dc6;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_enabled: true
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_setdate: 2022-01-22T05:52:44Z
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_method: Standard
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_name: AMD Official Use
 Only-AIP 2.0
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_actionid: c578b90f-e591-40d1-b6ba-b723a475338d
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea355f9e-64e3-4e3e-f84e-08d9dd6b6b64
x-ms-traffictypediagnostic: DM6PR12MB4106:EE_
x-microsoft-antispam-prvs: <DM6PR12MB410629DC8FCD86A2147DD108975C9@DM6PR12MB4106.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PEjy9vh8IQQyRdBvCFc3oUpTv26u2hZmR/rdtm1rHbT3h8gWa5HhLcddbhSUYcV+di/PRPUq9VefcGJx6XUqLhFazImNdtS2aZZDkoi6Uf3psrhoSqPMAE5p00RyK8WIOhvfURiJb2N0KxFWbh5fO/gSYjceaSilKgUUAArxA4v/hYl2P9bOwLv+r5CMP4zXL+BgdHBOKgwgPUNPb3aKpLsYevlhYn/jbFt5mzYQiTT7cGQcQwq0bjIfEfFPxxo//tSgLJmBPd7QWNMLv8KmNlJy2kcHwedGKZ9QNjjtAMhcIZE2RGnYs5o238i2od24KGcfX2eHQ0aY6vggT3hvAZ5l0VJLOI3zofE9CzdlJcaD8i7Z1rQCcuFXdkKONIiIrtNh3XDaKq1ZfzS1caMAhYcUHXK8HIGcc/R4uTCSgkXL+fXksZkTp2Z2g0zx+yyF47B+FbCaMT/ponpwN9lm0Rw0uFW3Kl8O229qOc5TD5IJPYMoNCWIsAWZ62oqkRPF2nO0paAFYjdFTOMV01w9BQWsIpU7mfPFIYNk7ofQ2gQaJVsRcbt13Y7OEGcJY9zUWkZS2U5VWeMZ1PPpBz03F+PNHGn/vKv5iqfy9tYQS0SLzUsrEkcEaCyoGkwHx2gi4B690UdwFOdhTz4IsUjBZhdyiBOgE5+/fJPqhuTbGG/I7ZZvmMjYVoJl+HAVpMS/vJW2cG39ESCB3i94TlYBag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(186003)(8936002)(5660300002)(6506007)(966005)(52536014)(83380400001)(33656002)(71200400001)(55016003)(26005)(8676002)(2906002)(316002)(122000001)(110136005)(38100700002)(54906003)(4326008)(508600001)(76116006)(7696005)(66476007)(53546011)(66446008)(66946007)(64756008)(66556008)(38070700005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnAwb0xycG14bGxtV0NTdjJWc3ljLytFTjVoclZHbEtBVlRVYUIzUGtWb2Ur?=
 =?utf-8?B?Y0pSMnRBTzlWcUg4M3BQQjZpVmhHQjhRaE1qZWVYMWNENjlsVzUvWTVXWjRL?=
 =?utf-8?B?a096SEI3VmRYMFU5OU5xcHIxZ0xaODdERkc2eGs5Y0JBLy9uSitZa1hZN2ov?=
 =?utf-8?B?MEIxNW1hTU1tZGlBdmcwS1ZWUWNjN3JZT3BxdElFYmNGdmJWY3dUdFphdCtG?=
 =?utf-8?B?NEg5aHlEeS9TL0F2NjlFOXQvQy8yY1ZNcVJYTGFQVGI2bHlyTkc4alRvS2R3?=
 =?utf-8?B?bWRNREdPZVMzc3BBSFFia0xhWnB6ZHVOQlZJZVpKNmRrKzlxVFVaRTRiTjRN?=
 =?utf-8?B?TmsrTUVibG9FQjdUV3dOUE92N2E1UjJJZnJFZkpKRmhESDRWQkVBbk4vMGJO?=
 =?utf-8?B?SkJ1Q002TVVQVlpMdGFUZ0Z0bm9UN1lMNEl3bTB6R0kwN1lxOVVNNm9OUmpI?=
 =?utf-8?B?aHZ4Sll2c0Vxb3o2VWhXT29EOXBFRTBsMHJzajBaaG13OWNPR3pWcEJTdEpZ?=
 =?utf-8?B?MmZyVERKY2Z4L29hTFJBZWJWa0U3SWhZcjJEY0dvNnkydk9EU0x4eXBHUTNh?=
 =?utf-8?B?TDc1OWRONWVmeUpaTG1wZXUxajgvUTRmaXBHOTZVNGNWVG83NnA4UmYwK05Y?=
 =?utf-8?B?RzlyL0lqM0czaWd2bzFQR2JmTGNnaTBSek1tRDdhL29BQkJWdXUzSElRTUxH?=
 =?utf-8?B?dHZRd0t2b3E2SnowNjFWR0xFam1LOFlFUVlKNEcya04rV2RGQ1Vyci8xVW5q?=
 =?utf-8?B?cWk5bWUvZ1VsVjNrcnBLa2xlVUhOM3JQdUxyenJ3ejBXYXdpMzVDWmtzdHUr?=
 =?utf-8?B?K2Jsd1FzamdRYktnVFVncGkzdHoxeExzcHVPbkZBREFVMkM1MmtjTGkwMTRs?=
 =?utf-8?B?WVI5bm04U2E4VEt2bTZYeHR6UEJhc20xYW9FQytrZkVBVmhOeW1kSDdab2VZ?=
 =?utf-8?B?L0dUYjhvT3YrRkp0S0E5ME0xMzFxRERucUhMNmNIcEtkTVpPTHJNcUY1ajdt?=
 =?utf-8?B?VmZoYmh1by9MbmpPNXU0a0VKM1hwRUViK09QRnI3T0h6cVZpV1d4UGF0SmxM?=
 =?utf-8?B?Vkw5MFBkN3I0dXhVMU01NGJ4SGdIaVN1TjExK1I1ciswZ09DUUlEaEhyMkpX?=
 =?utf-8?B?MVl6UzFCMzFVRXRIbm9Ca1JmNEh0WHprYUdvS3FRMkE5a2tuZXFMOFNzaTUx?=
 =?utf-8?B?anFnTFAzWG9lbncwUW0rZkZla0w5RnFJTi9SRUVzTzZWWlZobnd2RE92Y1ly?=
 =?utf-8?B?Sjc1QVoyaVNFTnpVa1M5dmFLcjQzTWVVRkZscDhzQmRLdFYzM3FPaHkySlcv?=
 =?utf-8?B?KzFqMFdRaDBJYXdKQ25DVXgxaHB0c0ltdEtxblp4NkVwSDErb2xEQmQ1YjEv?=
 =?utf-8?B?SW9DS0FzR0tMcGFybFRzMjYrYlVBMVdyRkNPbHFIWGsrcFVaQy84YW5Sa0pD?=
 =?utf-8?B?cno5ck5meGI2ZVp3Z0ZnRk1BWkhDNmdFTllJZ3liWG82enZ3NGdYR0xJU2ZN?=
 =?utf-8?B?S1NaQlFrOEpOYmE5T2VsUlQyZ0tTb3V2SnBBOHN2alAxcmZQdDhyZXoxRndz?=
 =?utf-8?B?azZ3R1JDM3JGckFBVkllMFFhd1hnWUVqY1BndzhXdDh1bHllY1FyRmNXMk56?=
 =?utf-8?B?SnRvN3lTeVcyb0ZaZklsU3k4QkdJWFdBRVhxLzNoZndnQzhJdFpQYi92Rm92?=
 =?utf-8?B?YzJuSmIvZzZGVzdBczEvU3lsTU5za0l4TnZIdC9XelMwQW0xL2FFVXVKYUEy?=
 =?utf-8?B?Z1RuWUZGSG5kbFN1RXhYSnhjZFFaRndjeXRKZ2RVbHJWZExwYzhwVHVISnlh?=
 =?utf-8?B?RjNkRlZCM3NGd0s4ZFJ0YktUQ21rc3ErcmQ4V1NTTlBTakhLZTdWTTMvVWJX?=
 =?utf-8?B?SWFSeTdWN244QURvYmhoblNwSjJFMjlybXg1SzRKTkpIeUpzZ3JPbnFCZG81?=
 =?utf-8?B?SC9MdWdwdkdwWlZMRmRnYXVFV3hraHM3R3k0aG1VeWRGUGFpeDhaTE9vWHJq?=
 =?utf-8?B?a21TTjQvYXlrRHVyV0czMnV4WFpiV1p6YnFURXZHZHRMcWptMUxJaHRkUTFi?=
 =?utf-8?B?eldkc0g5S3VBdE5iaW83eWlOMnBHeEl2U2NQMGtHZWV0SStTaGhEdnBaQllk?=
 =?utf-8?Q?2bD4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea355f9e-64e3-4e3e-f84e-08d9dd6b6b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2022 05:52:47.9685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jP7a3z1awP6LD1PklWequzwVB0Ua8OyJ2nGY5u1ZT1mP0FCHyYDKomFufN7ZznLc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seV0NCg0KSGkgSmFtZXMsDQoNCkNvdWxkIHlvdSBwcm92aWRl
IHRoZSBwcF9kcG1fKiB2YWx1ZXMgaW4gc3lzZnMgd2l0aCBhbmQgd2l0aG91dCB0aGUgcGF0Y2g/
IEFsc28sIGNvdWxkIHlvdSB0cnkgZm9yY2luZyBQQ0lFIHRvIGdlbjMgKHRocm91Z2ggcHBfZHBt
X3BjaWUpIGlmIGl0J3Mgbm90IGluIGdlbjMgd2hlbiB0aGUgaXNzdWUgaGFwcGVucz8NCg0KRm9y
IGRldGFpbHMgb24gcHBfZHBtXyosIHBsZWFzZSBjaGVjayBodHRwczovL2RyaS5mcmVlZGVza3Rv
cC5vcmcvZG9jcy9kcm0vZ3B1L2FtZGdwdS5odG1sDQoNClRoYW5rcywNCkxpam8NCg0KLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEphbWVzIFR1cm5lciA8bGludXhrZXJuZWwuZm9z
c0BkbWFyYy1ub25lLnR1cm5lci5saW5rPiANClNlbnQ6IFNhdHVyZGF5LCBKYW51YXJ5IDIyLCAy
MDIyIDY6MjEgQU0NClRvOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4NCkNj
OiBUaG9yc3RlbiBMZWVtaHVpcyA8cmVncmVzc2lvbnNAbGVlbWh1aXMuaW5mbz47IERldWNoZXIs
IEFsZXhhbmRlciA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT47IExhemFyLCBMaWpvIDxMaWpv
LkxhemFyQGFtZC5jb20+OyByZWdyZXNzaW9uc0BsaXN0cy5saW51eC5kZXY7IGt2bUB2Z2VyLmtl
cm5lbC5vcmc7IEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgUGFuLCBYaW5o
dWkgPFhpbmh1aS5QYW5AYW1kLmNvbT47IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc+OyBhbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgQWxleCBXaWxsaWFtc29uIDxhbGV4
LndpbGxpYW1zb25AcmVkaGF0LmNvbT47IEtvZW5pZywgQ2hyaXN0aWFuIDxDaHJpc3RpYW4uS29l
bmlnQGFtZC5jb20+DQpTdWJqZWN0OiBSZTogW1JFR1JFU1NJT05dIFRvby1sb3cgZnJlcXVlbmN5
IGxpbWl0IGZvciBBTUQgR1BVIFBDSS1wYXNzZWQtdGhyb3VnaCB0byBXaW5kb3dzIFZNDQoNCj4g
QXJlIHlvdSBldmVyIGxvYWRpbmcgdGhlIGFtZGdwdSBkcml2ZXIgaW4geW91ciB0ZXN0cz8NCg0K
WWVzLCBhbHRob3VnaCBJJ20gYmluZGluZyB0aGUgYHZmaW8tcGNpYCBkcml2ZXIgdG8gdGhlIEFN
RCBHUFUncyBQQ0kgZGV2aWNlcyB2aWEgdGhlIGtlcm5lbCBjb21tYW5kIGxpbmUuIChTZWUgbXkg
aW5pdGlhbCBlbWFpbC4pIE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBgdmZpby1wY2lgIGlzIHN1
cHBvc2VkIHRvIGtlZXAgb3RoZXIgZHJpdmVycywgc3VjaCBhcyBgYW1kZ3B1YCwgZnJvbSBpbnRl
cmFjdGluZyB3aXRoIHRoZSBHUFUsIGFsdGhvdWdoIHRoYXQncyBjbGVhcmx5IG5vdCB3aGF0J3Mg
aGFwcGVuaW5nLg0KDQpJJ3ZlIGJlZW4gdGVzdGluZyB3aXRoIGBhbWRncHVgIGluY2x1ZGVkIGlu
IHRoZSBgTU9EVUxFU2AgbGlzdCBpbiBgL2V0Yy9ta2luaXRjcGlvLmNvbmZgICh3aGljaCBBcmNo
IExpbnV4IHVzZXMgdG8gZ2VuZXJhdGUgdGhlIGluaXRyYW1mcykuIEhvd2V2ZXIsIEkgcmFuIHNv
bWUgbW9yZSB0ZXN0cyB0b2RheSAocmVzdWx0cyBiZWxvdyksIHRoaXMgdGltZSB3aXRob3V0IGBp
OTE1YCBvciBgYW1kZ3B1YCBpbiB0aGUgYE1PRFVMRVNgIGxpc3QuIFRoZSBgYW1kZ3B1YCBrZXJu
ZWwgbW9kdWxlIHN0aWxsIGdldHMgbG9hZGVkLiAoSSB0aGluayB1ZGV2IGxvYWRzIGl0IGF1dG9t
YXRpY2FsbHk/KQ0KDQpZb3VyIGNvbW1lbnQgZ2F2ZSBtZSB0aGUgaWRlYSB0byBibGFja2xpc3Qg
dGhlIGBhbWRncHVgIGtlcm5lbCBtb2R1bGUuDQpUaGF0IGRvZXMgc2VydmUgYXMgYSB3b3JrYXJv
dW5kIG9uIG15IG1hY2hpbmUg4oCTIGl0IGZpeGVzIHRoZSBiZWhhdmlvciBmb3IgZjliN2YzNzAz
ZmY5ICgiZHJtL2FtZGdwdS9hY3BpOiBtYWtlIEFUUFgvQVRDUyBzdHJ1Y3R1cmVzIGdsb2JhbCAo
djIpIikgYW5kIGZvciB0aGUgY3VycmVudCBBcmNoIExpbnV4IHByZWJ1aWx0IGtlcm5lbCAoNS4x
Ni4yLWFyY2gxLTEpLiBUaGF0J3MgYW4gYWNjZXB0YWJsZSB3b3JrYXJvdW5kIGZvciBteSBtYWNo
aW5lIG9ubHkgYmVjYXVzZSB0aGUgc2VwYXJhdGUgR1BVIHVzZWQgYnkgdGhlIGhvc3QgaXMgYW4g
SW50ZWwgaW50ZWdyYXRlZCBHUFUuIFRoYXQgd29ya2Fyb3VuZCB3b3VsZG4ndCB3b3JrIHdlbGwg
Zm9yIHNvbWVvbmUgd2l0aCB0d28gQU1EIEdQVXMuDQoNCg0KIyBOZXcgdGVzdCByZXN1bHRzDQoN
ClRoZSBmb2xsb3dpbmcgdGVzdHMgYXJlIHNldCB1cCB0aGUgc2FtZSB3YXkgYXMgaW4gbXkgaW5p
dGlhbCBlbWFpbCwgd2l0aCB0aGUgZm9sbG93aW5nIGV4Y2VwdGlvbnM6DQoNCi0gSSd2ZSB1cGRh
dGVkIGxpYnZpcnQgdG8gMTo4LjAuMC0xLg0KDQotIEkndmUgcmVtb3ZlZCBgaTkxNWAgYW5kIGBh
bWRncHVgIGZyb20gdGhlIGBNT0RVTEVTYCBsaXN0IGluDQogIGAvZXRjL21raW5pdGNwaW8uY29u
ZmAuDQoNCkZvciBhbGwgdGhyZWUgb2YgdGhlc2UgdGVzdHMsIGBsc3BjaWAgc2FpZCB0aGUgZm9s
bG93aW5nOg0KDQolIGxzcGNpIC1ubmsgLWQgMTAwMjo2OTgxDQowMTowMC4wIFZHQSBjb21wYXRp
YmxlIGNvbnRyb2xsZXIgWzAzMDBdOiBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMuIFtBTUQv
QVRJXSBMZXhhIFhUIFtSYWRlb24gUFJPIFdYIDMyMDBdIFsxMDAyOjY5ODFdDQoJU3Vic3lzdGVt
OiBEZWxsIERldmljZSBbMTAyODowOTI2XQ0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiB2ZmlvLXBj
aQ0KCUtlcm5lbCBtb2R1bGVzOiBhbWRncHUNCg0KJSBsc3BjaSAtbm5rIC1kIDEwMDI6YWFlMA0K
MDE6MDAuMSBBdWRpbyBkZXZpY2UgWzA0MDNdOiBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMu
IFtBTUQvQVRJXSBCYWZmaW4gSERNSS9EUCBBdWRpbyBbUmFkZW9uIFJYIDU1MCA2NDBTUCAvIFJY
IDU2MC81NjBYXSBbMTAwMjphYWUwXQ0KCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgWzEwMjg6MDky
Nl0NCglLZXJuZWwgZHJpdmVyIGluIHVzZTogdmZpby1wY2kNCglLZXJuZWwgbW9kdWxlczogc25k
X2hkYV9pbnRlbA0KDQoNCiMjIFZlcnNpb24gZjE2ODhiZDY5ZWM0ICgiZHJtL2FtZC9hbWRncHU6
c2F2ZSBwc3AgcmluZyB3cHRyIHRvIGF2b2lkIGF0dGFjayIpDQoNClRoaXMgaXMgdGhlIGNvbW1p
dCBpbW1lZGlhdGVseSBwcmVjZWRpbmcgdGhlIG9uZSB3aGljaCBpbnRyb2R1Y2VkIHRoZSBpc3N1
ZS4NCg0KJSBzdWRvIGRtZXNnIHwgZ3JlcCAtaSBhbWRncHUNClsgICAxNS44NDAxNjBdIFtkcm1d
IGFtZGdwdSBrZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4NClsgICAxNS44NDA4ODRdIGFtZGdw
dTogQ1JBVCB0YWJsZSBub3QgZm91bmQNClsgICAxNS44NDA4ODVdIGFtZGdwdTogVmlydHVhbCBD
UkFUIHRhYmxlIGNyZWF0ZWQgZm9yIENQVQ0KWyAgIDE1Ljg0MDg5M10gYW1kZ3B1OiBUb3BvbG9n
eTogQWRkIENQVSBub2RlDQoNCiUgbHNtb2QgfCBncmVwIGFtZGdwdQ0KYW1kZ3B1ICAgICAgICAg
ICAgICAgNzQ1MDYyNCAgMA0KZ3B1X3NjaGVkICAgICAgICAgICAgICA0OTE1MiAgMSBhbWRncHUN
CmRybV90dG1faGVscGVyICAgICAgICAgMTYzODQgIDEgYW1kZ3B1DQp0dG0gICAgICAgICAgICAg
ICAgICAgIDc3ODI0ICAyIGFtZGdwdSxkcm1fdHRtX2hlbHBlcg0KaTJjX2FsZ29fYml0ICAgICAg
ICAgICAxNjM4NCAgMiBhbWRncHUsaTkxNQ0KZHJtX2ttc19oZWxwZXIgICAgICAgIDMwMzEwNCAg
MiBhbWRncHUsaTkxNQ0KZHJtICAgICAgICAgICAgICAgICAgIDU4MTYzMiAgMTEgZ3B1X3NjaGVk
LGRybV9rbXNfaGVscGVyLGFtZGdwdSxkcm1fdHRtX2hlbHBlcixpOTE1LHR0bQ0KDQpUaGUgcGFz
c2VkLXRocm91Z2ggR1BVIHdvcmtlZCBwcm9wZXJseSBpbiB0aGUgVk0uDQoNCg0KIyMgVmVyc2lv
biBmOWI3ZjM3MDNmZjkgKCJkcm0vYW1kZ3B1L2FjcGk6IG1ha2UgQVRQWC9BVENTIHN0cnVjdHVy
ZXMgZ2xvYmFsICh2MikiKQ0KDQpUaGlzIGlzIHRoZSBjb21taXQgd2hpY2ggaW50cm9kdWNlZCB0
aGUgaXNzdWUuDQoNCiUgc3VkbyBkbWVzZyB8IGdyZXAgLWkgYW1kZ3B1DQpbICAgMTUuMzE5MDIz
XSBbZHJtXSBhbWRncHUga2VybmVsIG1vZGVzZXR0aW5nIGVuYWJsZWQuDQpbICAgMTUuMzI5NDY4
XSBhbWRncHU6IENSQVQgdGFibGUgbm90IGZvdW5kDQpbICAgMTUuMzI5NDcwXSBhbWRncHU6IFZp
cnR1YWwgQ1JBVCB0YWJsZSBjcmVhdGVkIGZvciBDUFUNClsgICAxNS4zMjk0ODJdIGFtZGdwdTog
VG9wb2xvZ3k6IEFkZCBDUFUgbm9kZQ0KDQolIGxzbW9kIHwgZ3JlcCBhbWRncHUNCmFtZGdwdSAg
ICAgICAgICAgICAgIDc0NTA2MjQgIDANCmdwdV9zY2hlZCAgICAgICAgICAgICAgNDkxNTIgIDEg
YW1kZ3B1DQpkcm1fdHRtX2hlbHBlciAgICAgICAgIDE2Mzg0ICAxIGFtZGdwdQ0KdHRtICAgICAg
ICAgICAgICAgICAgICA3NzgyNCAgMiBhbWRncHUsZHJtX3R0bV9oZWxwZXINCmkyY19hbGdvX2Jp
dCAgICAgICAgICAgMTYzODQgIDIgYW1kZ3B1LGk5MTUNCmRybV9rbXNfaGVscGVyICAgICAgICAz
MDMxMDQgIDIgYW1kZ3B1LGk5MTUNCmRybSAgICAgICAgICAgICAgICAgICA1ODE2MzIgIDExIGdw
dV9zY2hlZCxkcm1fa21zX2hlbHBlcixhbWRncHUsZHJtX3R0bV9oZWxwZXIsaTkxNSx0dG0NCg0K
VGhlIHBhc3NlZC10aHJvdWdoIEdQVSBkaWQgbm90IHJ1biBhYm92ZSA1MDEgTUh6IGluIHRoZSBW
TS4NCg0KDQojIyBCbGFja2xpc3RlZCBgYW1kZ3B1YCwgdmVyc2lvbiBmOWI3ZjM3MDNmZjkgKCJk
cm0vYW1kZ3B1L2FjcGk6IG1ha2UgQVRQWC9BVENTIHN0cnVjdHVyZXMgZ2xvYmFsICh2MikiKQ0K
DQpGb3IgdGhpcyB0ZXN0LCBJIGFkZGVkIGBtb2R1bGVfYmxhY2tsaXN0PWFtZGdwdWAgdG8ga2Vy
bmVsIGNvbW1hbmQgbGluZSB0byBibGFja2xpc3QgdGhlIGBhbWRncHVgIG1vZHVsZS4NCg0KJSBz
dWRvIGRtZXNnIHwgZ3JlcCAtaSBhbWRncHUNClsgICAxNC41OTE1NzZdIE1vZHVsZSBhbWRncHUg
aXMgYmxhY2tsaXN0ZWQNCg0KJSBsc21vZCB8IGdyZXAgYW1kZ3B1DQoNClRoZSBwYXNzZWQtdGhy
b3VnaCBHUFUgd29ya2VkIHByb3Blcmx5IGluIHRoZSBWTS4NCg0KDQpKYW1lcw0K
