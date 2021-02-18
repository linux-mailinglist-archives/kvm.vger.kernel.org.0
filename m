Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9897531E68A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 08:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhBRGyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 01:54:35 -0500
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:15520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231261AbhBRGtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 01:49:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7X9YPcFrwU/uHwcHqt98FVHpg5FaXOBcDDP3rD75RXYgcAywhWEBYV/mTQL287NquQYSG/9ScRONkD63BaFw5irvIzBlgqXSTsOupaNIsj6u0gqH1XQWnQ3l16E1VXTgfZhf4GhMlB7wim1vL9T5IXmm+feS5qB1bePHmai0gj7mDhFZM9qPu6NInkt7DTnbQi2YSmdG0UmbBCTgD2HkqW4umHEsSsL6+k9nQPmP+OIOgvMN8ljBLkHqdsONpY/F+h9Mnq3ifXqf8QKD1dVGqZAYPz6MLj6LpdUQpmnCSf+K1EeMZGVgB7Dp4VPUcKbIccgktDKG/G4pY99qXJM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpZlNRpSh7XDDgBOipBNUVTqRgogCtg+zXzht3hsovE=;
 b=Xx+8BN7mY046EtpLjAn21UNw8CIwAasD9oZ6XxOdVUY5IRMwYafg/u2l0rZZOFLABexetAs3LTlUuF2K5cG+doPlEZMr7lOhTNxl12i60VxjVZ8jRYw55MfxSTsYV2bQxa8nMEmywmtLUg4ZDbxLKbLUsNOijszw7Q0laHMbsooZRyB3VXhauedIreCENSB/EJ/KBiA5jydc3MCGGv7c66jZLYaXjDPcXE5iN4DCrOtEAWbWXXWgXyhmWanY18uA8PBRNUUYxsKuMl49aDsth+Zt+fYHuHcg9qpTQem9/IayiR0tjUV+gNGsSPsxxRPO5eMzV+UxaSGH1FUvNKXX/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpZlNRpSh7XDDgBOipBNUVTqRgogCtg+zXzht3hsovE=;
 b=2X+JNgiXlNCpBjRk4DTgSM7mcc2WDI4qC4BEX9JGUNl+DVLwJQ72Q22OM+gIZCk9hvpewcdSnPf0kGVxMoJWoLCc8yOk9d8J+QQsy3ZZEtbsE6K+bjKRsi1dkOhUqCwS/08tRhUKDQbgtWXW2rwn7B3hQi1sBNiXlDUdZTa3O0U=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Thu, 18 Feb
 2021 06:48:31 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 06:48:31 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: RE: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Thread-Topic: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Thread-Index: AQHW+o4w4C5VGgubRkqZlElkExidF6pbnD+AgADRN1CAACz4AIAA7nZg
Date:   Thu, 18 Feb 2021 06:48:31 +0000
Message-ID: <SN6PR12MB27676C0BF3BBA872E55D5FC78E859@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YC1AkNPNET+T928c@google.com>
In-Reply-To: <YC1AkNPNET+T928c@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-18T06:48:26Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=92813286-7e8a-42dc-8876-5cb5b51e1532;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [183.83.213.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3fc2e1a-03aa-41d5-251a-08d8d3d9345c
x-ms-traffictypediagnostic: SN6PR12MB2685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR12MB2685FBC4DD0BCC0C413A4CF28E859@SN6PR12MB2685.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Z/GdIQivdBwF8bmyWlqSfCe2MvOefVsyIs5M+/oNPzB7uK8e/9ng4UHWuxGiatTkfZS6oM+hvq+eeZGFn6fsE6ABuCrGUAUoJyUEDjEvTMruwYMcHd6tKZV3GkfW6RpBx7S1j2yw1g96NIaFZJESMzveYHlAmJr30Q+sP6TQ0K6LnvD2JMScpXmbQQEZYOJTC8Q6kQbqVum3wb2nywBvpATOAAusYOFZdOaGmBuVbL5q9D90+dxIHyOFxyZl+24Xd+C9ZQv9Xwh5q+XT2urD1tZlZboGjnOTEY8QJjCfI5Ta6izoeJg0IJ0hhSqRIPmjHIHn0FT0x0zwGwcmA9lESa096Di10C0qckEGWg2Xg7isVerKEImFcxyNULSlr3IFwU+xLdyVmyMz7ES22jFI2Iam+HqQ3fAJAWR2zt+4A7t1Uyeu7l3RUfevs/PmTR0LWWooJK7efmz13EqtCik6DEs52MBxoffog0LtZyX0pIERPeStQGXrVmk6QeTSekCkejdeMfWk8/W+ZaUqy6O0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(66446008)(66476007)(66556008)(5660300002)(64756008)(7416002)(2906002)(33656002)(55016002)(9686003)(7696005)(6916009)(52536014)(186003)(71200400001)(26005)(316002)(83380400001)(76116006)(86362001)(54906003)(478600001)(6506007)(66946007)(53546011)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?u108LN2t7sz6nMY0O0VDo1MaJJe6Ze0E6IFP2/uOz/bSYUZfdnc2RAu+G98S?=
 =?us-ascii?Q?oPWs5pva3qLwSv8Wuht5itfALjcmWo56zuNxbHZVLjhMx/krLt1eIttTsMXZ?=
 =?us-ascii?Q?9B30iCR47Uqovs2+bEFLUPgqADx7zcX4FmhaVT5vqWHMIBHYRB9CqvrJzZlB?=
 =?us-ascii?Q?1APBlXm2U3tgHYUkZFlIUtH2PCR8vXacVJuDxZkBtrsPepB4XWY1JCnzwYC6?=
 =?us-ascii?Q?Be+EXDhxw+ZPzNrGXSI10+u4tXqFLxn1LkjbjV9P0NC/LMLPUO575j6119s0?=
 =?us-ascii?Q?+PYy4fMRq9jMaLHsaKqh/aDEP3Wkg8J0c/gYyUZJiBe6YeTmgetmo27dpt+U?=
 =?us-ascii?Q?C414t4RVC+/EdE+yfUFumSCdN7xaisOwEKB3we2s46k99NQN5c1Cqam50Blr?=
 =?us-ascii?Q?9O2lKKxG0B1MN7OrU3umazRAY7+X3PkxnyJlk/Gkd2MfZA0sBdtKA2I0HON6?=
 =?us-ascii?Q?cZ4223LTbcBrOuKH3CsuG5933W3SF7rmGmZkfqhGPdXaIYMnBqZnaY778cgW?=
 =?us-ascii?Q?c6PDfBVVT8yJ2kU8wB+d0mUJjrBOHf2G35fNQm8iMcoFvnEQQCfsT5aKpmub?=
 =?us-ascii?Q?tvc+ITVotjUbIU18xZBkfUsBEu2ok2KhCAMbmHuarTftMOWwwuCC3znTaaFC?=
 =?us-ascii?Q?IJpu2CP4WVQyg/t0urkubGJgLa3tHcM7jOvu6tCRqsiQJi1rOp4K5UdDMINf?=
 =?us-ascii?Q?8jCyK40AYmPoSlMSYPZK97+fK0e2lbDFwUCeGa3mI6N/pbmZfwhvjS6pPsK1?=
 =?us-ascii?Q?f4dpowQ2PLSSvOaKze/PwbntxCooRdAc8RIUaALim9LF2In33mgn0VZ3f9lN?=
 =?us-ascii?Q?mNoqa8wsi2nisj/ZXG1bT/jktS7HgYJ9BnpaUoIU6KBUp8aazfp9+2Hc5o2R?=
 =?us-ascii?Q?tZsznSNqaBKfb91Grxm2YfpFzELdBYSUn2UoxwXznlAR/IiVHJemNkedbYVF?=
 =?us-ascii?Q?v54483RDqPoZebV8Tn8IymXeMV9xHBSkloT09lUSRbetH/EyX3ToyfYEjvno?=
 =?us-ascii?Q?5gKv/56TzgUb9xQUhBQoOk+nYIxXxt928ZbfRGMYvOwhDOpwM27sKr75bMEt?=
 =?us-ascii?Q?HrdValQKF7LoUH0TvJVfXeQnZw+DjDVh0q6PQIsy+twbMh4XkUbgVv7tyAEf?=
 =?us-ascii?Q?VQia/DmklwtxZBN7Mw38vYUAho5EK4cHgZu9bzMzgphpepeJqd3Qen78poMW?=
 =?us-ascii?Q?nrSgX040YT8XkAI3xNAixSh8FCI8WT9UkHK2xXaoheQRxn+HR0Cr/c/MN6MN?=
 =?us-ascii?Q?3X7BhbuigdtVSt6Bkin9n5T2FbdAeEg2y0uiaF8fHaXTUM3crs4y76ZSZZhG?=
 =?us-ascii?Q?AH8mP4nPIj4vwe07EQJWNohe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fc2e1a-03aa-41d5-251a-08d8d3d9345c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 06:48:31.1104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJ/WkF2qhe56EQfOaTt1zv18/R7Ho0R0TBXZXkOEcp0EC4ikHwNJyqC/A7+BvdyOu+794YQ2snmf40yenPLLig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Public Use]

-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Wednesday, February 17, 2021 10:13 AM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.co=
m; rkrcmar@redhat.com; joro@8bytes.org; bp@suse.de; Lendacky, Thomas <Thoma=
s.Lendacky@amd.com>; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger=
.kernel.org; srutherford@google.com; venu.busireddy@oracle.com; Singh, Brij=
esh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIS=
T ioctl

On Wed, Feb 17, 2021, Kalra, Ashish wrote:
>> From: Sean Christopherson <seanjc@google.com> On Thu, Feb 04, 2021,=20
>> Ashish Kalra wrote:
>> > From: Brijesh Singh <brijesh.singh@amd.com>
>> >=20
>> > The ioctl is used to retrieve a guest's shared pages list.
>>=20
>> >What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is=20
>> >passed through to userspace?  That way, userspace could manage the=20
>> >set of pages >in whatever data structure they want, and these get/set i=
octls go away.
>>=20
>> What is the advantage of passing KVM_HC_PAGE_ENC_STATUS through to=20
>> user-space ?
>>=20
>> As such it is just a simple interface to get the shared page list via=20
>> the get/set ioctl's. simply an array is passed to these ioctl to=20
>> get/set the shared pages list.

> It eliminates any probability of the kernel choosing the wrong data struc=
ture, and it's two fewer ioctls to maintain and test.

The set shared pages list ioctl cannot be avoided as it needs to be issued =
to setup the shared pages list on the migrated
VM, it cannot be achieved by passing KVM_HC_PAGE_ENC_STATUS through to user=
-space.

So it makes sense to add both get/set shared pages list ioctl, passing thro=
ugh to user-space is just adding more complexity
without any significant gains.

> >Also, aren't there plans for an in-guest migration helper?  If so, do=20
> >we have any idea what that interface will look like?  E.g. if we're=20
> >going to end up with a full >fledged driver in the guest, why not=20
> >bite the bullet now and bypass KVM entirely?
>=20
> Even the in-guest migration helper will be using page encryption=20
> status hypercalls, so some interface is surely required.

>If it's a driver with a more extensive interace, then the hypercalls can b=
e replaced by a driver operation.  That's obviously a big if, though.

> Also the in-guest migration will be mainly an OVMF component, won't =20
> really be a full fledged kernel driver in the guest.

>Is there code and/or a description of what the proposed helper would look =
like?

Not right now, there are prototype(s) under development, I assume they will=
 be posted upstream soon.

Thanks,
Ashish
