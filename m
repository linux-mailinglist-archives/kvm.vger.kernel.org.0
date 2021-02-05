Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C933104AE
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 06:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhBEFjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 00:39:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18240 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBEFjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 00:39:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601cd9e20001>; Thu, 04 Feb 2021 21:38:42 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 05:38:41 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 05:38:37 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 5 Feb 2021 05:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwxyGXDh3JE5vsZLyV8IBcshtC1kk9L6pwyB6on/BFajZITUboBiV8a8bbYEQhFoYXdHtKciV3zxGtazpYfPUYVl72CPiEB8kZMyh4XfG/7QycCB+yR6SnM+efhT6hJU45NkjuSYFdSNKyQ961JAoHwKIPnQ8dijhO0+/o0lIjQjxKE9JMIss1DZRljk/2yqMDB/7QsU2mtDBHH5+wAdIMSn3rDu/aA2V7xMm8rqpvfZK69i78WdL9oddJdMBQoF9z/vU4HYr07Qcg15MKhwwfl2tkn/Oa8N8bz98UT83Zldf3nmt/mDPG0GjNzVWD7taeYiR57WvymSCPn7YqHhoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kr4DbUCgLwzPzl9tx5/+qaxTxIJ1Vxc9r6+ZFU+ZiNM=;
 b=Nocihk14nvvYGwKLAJGYolgLXPcioyeiNcrCOGqmINQjh1J/5bpOt4SD4Mr9qbTnUwk08XsF/gdHG1ihTeY82naLINwSnrv1uwTBzuJgMYzOg2zjq2KE+RNb0y52Rf+0Y0B+l6bTeyOXgqKpMLqlQBKH92NX/Y111VA5djCXg70erp9M1NBThV7Ee18fuTgEikZxIqpAMcvNnC7yy+g2CxSRVMgHLL6ukz2U3u9zmGL0Gz4VGK2DkL8cM5sFpAp7ibbai0E3elGG0Pc/R7m+M5scZR4iJIck5AqRqAg7scz6czDu1arCqryWVCxJ8ztnL5cMQxWxfFgC9vp3+PQp3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3130.namprd12.prod.outlook.com (2603:10b6:5:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 05:38:34 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::99ad:984a:7f84:be07]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::99ad:984a:7f84:be07%6]) with mapi id 15.20.3825.023; Fri, 5 Feb 2021
 05:38:34 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Somdutta Roy" <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: RE: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Topic: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Index: Adb59oEjzgg4QSxwQnWgWIvDOxc3GgAC+LyAAAKxoIAAIPt5EAAX5X8AAAJ4aAAAAwABAAAAokaAABmP/vA=
Date:   Fri, 5 Feb 2021 05:38:33 +0000
Message-ID: <DM6PR12MB350095499FBD665AA7D969A2CAB29@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
 <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
 <87wnvnop1p.fsf@vitty.brq.redhat.com> <87tuqroo7g.fsf@vitty.brq.redhat.com>
In-Reply-To: <87tuqroo7g.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=kechenl@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2021-02-05T05:38:31.8843857Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic;
 Sensitivity=Unrestricted
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8da68d24-d66a-4a7e-f38a-08d8c9984769
x-ms-traffictypediagnostic: DM6PR12MB3130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3130E2B1CF95ADC767432231CAB29@DM6PR12MB3130.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rm2Sfab+6StW0Hkp+FQDbfcPJV12U5Yv3nrqtk4IfWZqBkuEqGacjCyQR6uWawh7Noz+KwQZ7tkLEpajSa56DjOATWNBrpmvlfWpSKjh/ZlPWWRaDIMs8qu54TBfvUVxykx6df2Z+6WJCUIQhnG+q2Y1lCFfVzHqyzksZS+9dX0arFx+xWuhMFHhKHqMx+BrwriT3iiW9ZXfVhqfK0UeBcHOGC+oG7ssCHr22okusEXkXjL7+2MKpXhOOuTMTbAePdGvLftp93TdhzSBDt6bgsIpxiXLp2h34vKmZxxv1y25xcr1+tO0+oFxhCmjI0Pg5E2DjTcu6AoqcFLaI0UjIcdgzSUFx4msJ+L4Ii2tuEH5ZEcI6w1KNQ8y/EqnUbckslb4Rof+WLze81oxOO1pHM0XhZ2/C75HwOAnDcVFV/0MEcRlQgkSuHS5xgx7RvK7Fcvb20JHC0n3tKqSH5uaoeVj5lStXDFa5qAfk8vid8GhkeaiLS2TC7RwyA3UkbA9zt4+LQNjh6h00wDzEx0BLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(76116006)(52536014)(186003)(2906002)(66946007)(66556008)(66476007)(64756008)(66446008)(8936002)(478600001)(316002)(4326008)(26005)(83380400001)(54906003)(71200400001)(110136005)(86362001)(9686003)(8676002)(5660300002)(33656002)(6506007)(7696005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WrlJk2OPmY85NCvDP2ykFkmIIbF7MYI3tTGiNI7OVQTKKhAeYgjpcj01ZBx0?=
 =?us-ascii?Q?eRJeCqceGN2lQ5DEJ/1xzSYgWlhkUvBi1Kc+NMpC0S2HXyrkaSz6aUgpDXCE?=
 =?us-ascii?Q?xjrzM5Hn+wvlxCKyefKuRJhyBYBdvviYxk8Fq3IOy6pvXojohUbAPKXD7ZsT?=
 =?us-ascii?Q?NmBjbUYHHu3fzz3opa9PS+YOOqfieJnyHDHQmBPWVvlIOgPULkkwpp8jXiKr?=
 =?us-ascii?Q?lE2q7Rnhb5BgTCFiTI6J/uMfGjhHUrN4dLpjCpoSt1myA8F0SzdPxqPuLTYe?=
 =?us-ascii?Q?K+3GroE+J6405KtL6e/9e9nGbpEz/Mn+WKULgxoutnr0m4f3DqQ2NICfwlMB?=
 =?us-ascii?Q?o3EmHvzGJYinN0QMmb12+7J4GkqIJO0D+QMmYLH0N42jivgH6Z/CgpReOKn9?=
 =?us-ascii?Q?14aAaIGsQrVGvm2ieLmQdzqTX1utSejfZYfwTSLfn9Yl4GPTZ5PnXsWwcJRt?=
 =?us-ascii?Q?UN1hl/N12vCHqIO+Vdd/ysYImzqgoQgvo/b6kKoWaxWh5x39ZDueuaMJ7NRQ?=
 =?us-ascii?Q?xGgml8F09NQacCOuuaAILnUSxXRmiy0fwianIzMhptKCx2oyEmtPJvBjhZVv?=
 =?us-ascii?Q?WXaNJBNns1s7NhqtiPT5Yv15f8ebpGeXAHKP/KmQuMiCdGqp4CpwtneG2NG0?=
 =?us-ascii?Q?KNB8aYUOWBe3YhhcxjViTE6TW9AmK4Wqt+hy8xNRzMxeLk+bOd6HRyr/6PC+?=
 =?us-ascii?Q?SoqFd0TaUzqlmoqQgIrH+4030+rhCWMOGTqvAh7qkiGlwYSjfEqjeFndX7a3?=
 =?us-ascii?Q?xRG1gQqiUwf81MnulZpknvTA4WJt8Od9hy9BuPvGnWdDKpb07tKN5SxqUoZ3?=
 =?us-ascii?Q?rApRpXaHRgPziaTk4oHfLIDpwpK0RqRHFuI0EX4sK2mejvMf4943BUv1AKF0?=
 =?us-ascii?Q?4ynO8U/Ba04o2h7PeDdsrfbUfmdmPsibgU0IbeMKrv7IyFZibGBjLmfGal9Q?=
 =?us-ascii?Q?/7NPtkgsQm/O1QE2BP8N+Ppuj6zg5n3aypIYX3NtxWLNnXx37iN0qSa55AHq?=
 =?us-ascii?Q?fekIz3tc8yGKfkh3k9aQrDTOn12Zx6nNqAIfNB0XKCnWAE/WA9ASMYxJMbLJ?=
 =?us-ascii?Q?cocP1pSrO+ngxsbPEVaXTFJv6+SaHdvBcXHVmwJzYf+gtBRt53+WjE+8NaEB?=
 =?us-ascii?Q?vnU9vVlhOBvwqKqcLRYFb9yu//UIiQI4bgE74IAUChXUZpGobZNo0j8GZxNG?=
 =?us-ascii?Q?p2me+2JH3Xh8B8pKvhih155VkFvUpznCOZDiVU2jIwtVEtrnMM6sZCX4BSkO?=
 =?us-ascii?Q?fxR0ktG3agvy85wN3+SAghC/vPvrC1GbB7k0tn+ncR/2/+p9+HqtU+NodO8J?=
 =?us-ascii?Q?81la/y4meA5CxgwqN457QLnG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da68d24-d66a-4a7e-f38a-08d8c9984769
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 05:38:34.2753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDQcd0S0iZNlxu+yWd+WRx+vuG90Wk6HHvk4rc2ToQJI3BI943dIIgWpcLBt98Y3/nMISO2KbvdT4Pu6T0phgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3130
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612503522; bh=kr4DbUCgLwzPzl9tx5/+qaxTxIJ1Vxc9r6+ZFU+ZiNM=;
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
        b=AGTT9M6RQVjbboNLUA00jR66R2v0fJKf9IHatwyZOLpenInLjNMbh4/Hu30zSEux2
         Ubnt+OZMOhZKRNJ8oasBmatp2cQpj6uZUQ11kKLhfLZAwvg2F0D6AV0cni7nuUhik2
         8bT3NqN0Nyp5rxv9BaNJ9Fl3LRSLrIEAF2jUV1A1pjvLLW2CEoRxx4HAFbVMQ7kOsz
         44hCe0wluViA3ky7TUMv2MLErGyMeLp3lB/QJn59JAuPSlXQO0hUzzfZbSiuje3QQU
         RWBSxNFVsZx4Gl5pahwPNSIoAh03Gu1dUfO4BN/XS3fS7scIwU5G7Fv7bC6UWwMevj
         cu7hd+YWx+vBQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cool! Thanks for correction, yeah, APICV_INHIBIT_REASON_HYPERV setting is p=
er-VM while synic is per-vCPU. Since the machine with AVIC is not in my han=
ds today, I will test it hopefully by end of this week:)

BR,
Kechen

>-----Original Message-----
>From: Vitaly Kuznetsov <vkuznets@redhat.com>
>Sent: Thursday, February 4, 2021 7:19 AM
>To: Paolo Bonzini <pbonzini@redhat.com>; Kechen Lu <kechenl@nvidia.com>
>Cc: suravee.suthikulpanit@amd.com; Somdutta Roy <somduttar@nvidia.com>;
>kvm@vger.kernel.org; qemu-discuss@nongnu.org
>Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
>
>External email: Use caution opening links or attachments
>
>
>Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>
>> +
>> +     auto_eoi_new =3D bitmap_weight(synic->auto_eoi_bitmap, 256);
>> +
>> +     /* Hyper-V SynIC auto EOI SINT's are not compatible with APICV */
>> +     if (!auto_eoi_old && auto_eoi_new) {
>> +             if (atomic_inc_return(&hv->synic_auto_eoi_used) =3D=3D 1)
>> +                     kvm_request_apicv_update(vcpu->kvm, false,
>> +                                              APICV_INHIBIT_REASON_HYPE=
RV);
>> +     } else if (!auto_eoi_old && auto_eoi_new) {
>
>Sigh, this 'else' should be
>
>} else if (!auto_eoi_new && auto_eoi_old) {
>
>...
>
>> +             if (atomic_dec_return(&hv->synic_auto_eoi_used) =3D=3D 0)
>> +                     kvm_request_apicv_update(vcpu->kvm, true,
>> +                                              APICV_INHIBIT_REASON_HYPE=
RV);
>> +     }
>>  }
>>
>>  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
>> @@ -903,12 +923,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu,
>> bool dont_zero_synic_pages)  {
>>       struct kvm_vcpu_hv_synic *synic =3D vcpu_to_synic(vcpu);
>>
>> -     /*
>> -      * Hyper-V SynIC auto EOI SINT's are
>> -      * not compatible with APICV, so request
>> -      * to deactivate APICV permanently.
>> -      */
>> -     kvm_request_apicv_update(vcpu->kvm, false,
>APICV_INHIBIT_REASON_HYPERV);
>>       synic->active =3D true;
>>       synic->dont_zero_synic_pages =3D dont_zero_synic_pages;
>>       synic->control =3D HV_SYNIC_CONTROL_ENABLE;
>
>--
>Vitaly

