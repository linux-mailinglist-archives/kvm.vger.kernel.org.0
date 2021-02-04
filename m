Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C8630E9F2
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhBDCGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:06:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6281 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbhBDCG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:06:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601b567a0000>; Wed, 03 Feb 2021 18:05:46 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 02:05:46 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 4 Feb 2021 02:05:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfClZJ0b/QQ0zck+rg+6YMzgBa8Ixf+slZvVPL8L9AZSMzRzNNKei6s+EbRE6kDPmgc8FZpPVRe2RNknHfUiLDiihCM1JVYN8WqBclvPs7SPVrSG7VCn+ee5qFdtUlsDYhA/JBfvusuLzEjDA4yEDrmiCO5qn25uVgGOVNlZrTASba5qsEsCOkdmCtxmYp7yLAjYPpD/shruhxtMcVk6jsgIUAqVNscRKl86MFFvJ2bOS1RjIO4JoMEQEJjTvD56RaM4RMxEW/woBXcEHO2fPkSAK2+xLQ5Bm0LpsfM+EH2b0QZIUelEPxxn0i+PBLYZzMH/VL3qxHx0hefRcDiXDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjDf1EkmVQAb1q5m9ytW3JPw5q5pn898kXcv3bPGoZs=;
 b=Vdz0NE5BiwPyuKmf3jKcklZWPj6lz8qZLU4e4Y+AwC0DrLKvzp1+iOC4+pJLqR+JS+FoQhuhgFUxHC8nSdzmjwSdwxqa1j+wbpDY+NDxkM5efKaD+6QqRNecxpm6gHwG5kQkAehmzBVBc8l+WbD82ud8BwwtMT4KJBDkHCMPwoezIof4TsLuL/aDRRqtCLOjMaqE0PlzIWQSepF1s8/K8Zt9F0yfx5Vrk7QDnp8puskvzE6ADjXzX2vM4k7xT8oPUERoM+dG05DES+jez0D6xwav1fYZsHPMACoWLZVIGTvl8tqLmwmPAwomm7c46I0qrkTeRZZ1B8tmWJszwQ58XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3321.namprd12.prod.outlook.com (2603:10b6:5:3c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.19; Thu, 4 Feb
 2021 02:05:44 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::fde4:47b0:69c6:6cc1]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::fde4:47b0:69c6:6cc1%3]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 02:05:44 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Somdutta Roy" <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: RE: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Topic: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Index: Adb59oEjzgg4QSxwQnWgWIvDOxc3GgAC+LyAAAKxoIAAIPt5EA==
Date:   Thu, 4 Feb 2021 02:05:44 +0000
Message-ID: <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
In-Reply-To: <878s85pl4o.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=kechenl@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2021-02-04T02:05:43.4017748Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic;
 Sensitivity=Unrestricted
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14bcaf51-44b0-4772-cf09-08d8c8b161c4
x-ms-traffictypediagnostic: DM6PR12MB3321:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB33216C897967254C314816D6CAB39@DM6PR12MB3321.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kTUZRpEOu5Yxfcp5DbTf0v2ERqtNKtrV6ldZYvw/EH4z9eoG+nWxjvV+QY9hcN14dC3FRiJKQhpG3YBaz3lIhKpAyAYcIppVEtm83N6S2IUBDq3PHEHYpTpjnSgQOpGvONbxLLNNCIke0vcdZE9b0yZ/g98gNuTfSU1VjTH5DFfYEgjWEemI4iSVg/sOa4E2qTCrRWsGj1ZCvRWARLOq0dTFx+jme84TbReRw9SXRnuG/Z5xtT7YU4MjUguJOgU5yusl1G7eokMpG02rawVRJZ/hn1P5DSMvYiDwXq1pE92/0OXiUVKUETWi0PBI9pqIvH5AhLjHkmXmCTyqDzaX4w2IhiuioWvVGng6XQ62JL5g5rOAp/3MzZo63hGkJQBgSyAEBiOHfk3cCAslhv1sPOo760O3n8YfcGOUsg/lcd30ZlOaK+yf+8ZJH2UyuVEKcdbu6JEgJIUPoiI8JResogmHkJyGJzfmfRgJMexVmNVXraoxyGtcKYIKIFgVofuAVzOkh132GDyapZMNqj7jiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(54906003)(316002)(86362001)(186003)(83380400001)(55016002)(71200400001)(26005)(6506007)(8676002)(2906002)(478600001)(64756008)(66446008)(66946007)(4326008)(52536014)(66476007)(76116006)(66556008)(5660300002)(110136005)(33656002)(53546011)(9686003)(8936002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GzxBWBBKOZwwVADEe7bW4ktnDxdu7uThjClYLkD5c2Kbkv7RAn7hOdEoB/Nf?=
 =?us-ascii?Q?SkNGv8h0uREjKbHsK5CMcaXCLylM9sGRCiIOUld/ETf801NBE6qlXCzli8ff?=
 =?us-ascii?Q?nlEW7l045zS8ns/F5lvaylNxNLZj9lU2Xx3pdiF8P/wx3v5fLKxqCudyMm9h?=
 =?us-ascii?Q?MBLp3dFdsMS7sGrRR1DU2mzqwBvKu2mdIIAoAj2JBmFEIVh5+PTXt2YQ/bho?=
 =?us-ascii?Q?/bls0QI8R/mtwJ41ax+WVq1otLJSNzmORM+WtLr6XOfGIT2Qtxm1nULZ/czF?=
 =?us-ascii?Q?ibgjh9TLj9gA7BUVHA6lb+Gc5EryysR0BUQV1zkrW2guHH1rtkE8kOBTCarr?=
 =?us-ascii?Q?MrrGZ5zLIUkxFYpIIPeEW5W2cvSQjZO8XCLcWTVan6YlhqaXoVo7WezuMlUQ?=
 =?us-ascii?Q?VbGowQzwl0wLNRVtvHw/ENx9EH+7q+zMiUd6X3DY4o3abAhF79PsphkOfnEK?=
 =?us-ascii?Q?gzPXSU4KyvAnzP35d5ZjL1mYpwyhUuNoIxHrWLlpm8FKc2lKK5VouczN/dU9?=
 =?us-ascii?Q?DRb0MFIlP1r6p0A3DsX89rL/VCZgT10MWlP5huLrfMJUlfi6vvw277HbHDCh?=
 =?us-ascii?Q?6vFCwnPETSAF2yyfN07O+UYsto0XZBttD9Qc4tJGIFSRCTpuVZQM8xAvtQde?=
 =?us-ascii?Q?E48Tm7DRgBSBQlTG6FptW4dRHD+bomG7/dcsLg9L7oG+INvGtX2SxrTW0MGq?=
 =?us-ascii?Q?9LRXEmg84XBBGU825DzFdfu8FSQW+sucnDYj0sMMMI75Vun5lfpWhty7ctND?=
 =?us-ascii?Q?00aXD0p4A14lPJnpRoE4crwLJYULQukFSV/apv67yfQPSQThRbZQPU7HlDyH?=
 =?us-ascii?Q?g5BaJhyRUGuk0gVBDPQW9MlFRbKBMzhkss/Yr2kB9wJ6lVEOvOw7vNAyXbXX?=
 =?us-ascii?Q?5a8xpI56wDoNGEF/L/2/6dnrNZTrLoi2by/Id5JIn8sO6Fg1+aj4GdDDXgYp?=
 =?us-ascii?Q?68k7nBWEmjvS1P9iqEqNBcroTYDDFwicESgciZvewtD1M8QlcMM4nDD1e/8x?=
 =?us-ascii?Q?zbXGq+Lx46EJ0sfpDthG1dkghl8nPPJ77if1ld4NWwjJ2dJ6PWNRtuebIdce?=
 =?us-ascii?Q?kdfzpWmHoAUvSYUeSbMVlfb+Xhgmf7BYuAqY9bmFcisRlD9JssZH1WhDELuh?=
 =?us-ascii?Q?YvsVfe76+3DjjpBYHHKTkqoKF8GyO6oVBqTkBDNVFlQiYOUvvJEMfGO29lbp?=
 =?us-ascii?Q?e63Jq8EfYSvPWOj5nE5vhx/ieIo9G/MS4VoBib2T5k2EnyIL51sGc0DPQIR/?=
 =?us-ascii?Q?ClSw0n7w6KIWU3b5yrZVXt1PyOdz3qZWPIJkSbQNAwxyua5400v6U+vwCvXj?=
 =?us-ascii?Q?zFqy9D/rUGnyf5qKzJ+rKHFO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bcaf51-44b0-4772-cf09-08d8c8b161c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 02:05:44.6560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSvSoV6xhNaq46RthTAIbeA+4Txxr65ubOggYVB2iKyP96EaCGdSY8nJK0+XhHnFiSRy1vIOTRxFVbEKYfoqcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3321
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612404346; bh=zjDf1EkmVQAb1q5m9ytW3JPw5q5pn898kXcv3bPGoZs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:msip_labels:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=rndKkrj4OrsGdAGWgm2ck16CGY6zMsqgqhnGh+frL6C2h3xz7g8945oUq+TkyFrCp
         zMHPNiBEKhQxKYsosZpk2LTySuQkwc8ZZkcYe3GDbQhicDHbLBi0WtlIOvwG7l6yE1
         z58GWqcknz4+j2ia/ti10KzALXan1FqsuUHv+bC28pP+yP6UhwvXlhcAYfUTo29b3H
         CjWhND3+I4welNx0R9UzIPWgCXzYMc5uyuhFuDesABv53mP8bRNVOWuN24bSJWzvAS
         QoZPZ8rF8nor6O1o1JQgMLlaSNYRllIPW5wjBANzMjA4RKGIYqYS6qAenB528Tn2Qm
         Wr8eIoV1+iBCw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly and Paolo,

Thanks so much for quick reply. This makes sense to me. From my understandi=
ng, basically this can be two part of it to resolve it.=20

First, we make sure to set and expose 0x40000004.EAX Bit9 to windows guest,=
 like in kvm_vcpu_ioctl_get_hv_cpuid(), having this recommendation bit :
-----------------------
case HYPERV_CPUID_ENLIGHTMENT_INFO:
...
+	ent->eax |=3D HV_DEPRECATING_AEOI_RECOMMENDED;
-----------------------

Second, although the above could tell guest to deprecate AutoEOI, older Win=
dows OSes would not acknowledge this (I checked the Hyper-v TLFS, from spec=
 v3.0 (i.e. Windows Server 2012), it starts having bit9 defined in 0x400000=
04.EAX), we may want to dynamically toggle off APICv/AVIC if we found the S=
ynIC SINT vector has AutoEOI, under synic_update_vector(). E.g. like:
-----------------------------
if (synic_has_vector_auto_eoi(synic, vector)) {
	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
	__set_bit(vector, synic->auto_eoi_bitmap);
} else {
	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_HYPERV);
	__clear_bit(vector, synic->auto_eoi_bitmap);
}
---------------------------------

Curious about what current plan/status of upstream is for this. If that's d=
oable and not current pending patch covering this, I can make a quick draft=
 patch tested and sent out for reviewing.=20

Best Regards,
Kechen

>-----Original Message-----
>From: Vitaly Kuznetsov <vkuznets@redhat.com>
>Sent: Wednesday, February 3, 2021 1:16 AM
>To: Paolo Bonzini <pbonzini@redhat.com>; Kechen Lu <kechenl@nvidia.com>
>Cc: suravee.suthikulpanit@amd.com; Somdutta Roy <somduttar@nvidia.com>;
>kvm@vger.kernel.org; qemu-discuss@nongnu.org
>Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
>
>External email: Use caution opening links or attachments
>
>
>Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> On 03/02/21 07:40, Kechen Lu wrote:
>>> From the above observations, trying to see if there's a way for
>>> enabling AVIC while also having the most optimized clock source for
>>> windows guest.
>>>
>>
>> You would have to change KVM, so that AVIC is only disabled if
>> Auto-EOI interrupts are used.
>>
>
>(I vaguely recall having this was discussed already but apparently no chan=
ges
>were made since)
>
>Hyper-V TLFS defines the following bit:
>
>CPUID 0x40000004.EAX
>Bit 9: Recommend deprecating AutoEOI.
>
>But this is merely a recommendation and older Windows versions may not kno=
w
>about the bit and still use it. We need to make sure the bit is set/expose=
d to
>Windows guests but we also must track AutoEOI usage and inhibit AVIC when
>detected.
>
>--
>Vitaly

