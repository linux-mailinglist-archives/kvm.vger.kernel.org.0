Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA55131EE4C
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhBRS3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:29:15 -0500
Received: from mail-co1nam11on2058.outbound.protection.outlook.com ([40.107.220.58]:19152
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231756AbhBRRGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:06:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dP2Z6jcJ65JwRhgMgLc4Bq5Ole5Qe3d4Q+4evcJKZviPPizjNw1AQwAdq3byNCg5TahKMLWWtQUvPfp9GRtMENnKEO8+PXZcbr6jbiZkrXZ3J+kBpwf7ywKbQWT8/BEmiuznB5Is4DcoM9BuLWB2LeAELevTxhlCgV+2SuMLFf1okYVDxano7FQ4+LVywX3WJrJ4XlLmLJfNzeZENcripHTkHXkvSBaLD2CrKyveOA96uluEz53h6OKbfY0kFQ1/lL2SVP7nS60ZVlH9ajvAMCl4TAa+eFUiip4rLVEERssDkqGA7H2S/h8OCWhIn/V1oKR6SZHZ9gNSLxbBe1uE4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dJPWvzC+D/0J+wEx0asaP13QDTW+v37F98GQJOAjJQ=;
 b=DnrIhaqEF4GLbOcf9gJ2rMdm/3KEjMF0Shn0MgPcCIBDYk7MIKb4HUKUBzCzBFfQ02Tl/szEPBAyXzk7sg65ZDCNTL/tceOTrufGiHweg/Ko5awNxaLAQCASUtxJ8XYYk1Tp8qRXaQ/FsLYpbLA5uPcb9eWLGxHt2dNkyj1jkL7xhWJpFksmSX5CwUkQmDoJf/0clAc/KCOkSd5mPgb0ybUhvcSQUSOmgxI3YGk33nGEzA/CeNYeUzOCHKuWe46/fUPm5aq9ly45XfGo75A/cNXCv3N3i94+TjX5nA3Yt2cc9mWCocxMcNBK+tmDLKySxFC2Zx99cA/HODTTpL8p7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dJPWvzC+D/0J+wEx0asaP13QDTW+v37F98GQJOAjJQ=;
 b=0I22ltQadlUhFDJJ/0s3+U1l0I6Y+TQvPwjhyXFVX3/dXN4TRBJamEIIP0e1woZFeRxdNtVnSnLmlvla6PWwUiIWnZbgTR+G3yb5DlsUz4Ru79a5enyncYMBewMUg4p5DGOQwDKX5i34TxUWxrIEyaReBLmVJpd/eG7fOcFrwf4=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 17:05:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 17:05:23 +0000
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
Thread-Index: AQHW+o4w4C5VGgubRkqZlElkExidF6pbnD+AgADRN1CAACz4AIAA7nZggACrNwCAAAP8AA==
Date:   Thu, 18 Feb 2021 17:05:23 +0000
Message-ID: <SN6PR12MB2767A978C3A2B43982F2F4898E859@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YC1AkNPNET+T928c@google.com>
 <SN6PR12MB27676C0BF3BBA872E55D5FC78E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YC6YOuJyNlSxKVR4@google.com>
In-Reply-To: <YC6YOuJyNlSxKVR4@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-18T17:05:18Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=c2c774a6-218c-4325-9e2d-775ee0a08af6;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [183.83.213.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f4a1dd7-1ee9-454b-dab5-08d8d42f6142
x-ms-traffictypediagnostic: SA0PR12MB4415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR12MB44155FD208EBDD4970D0C47D8E859@SA0PR12MB4415.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5+ILRHGHcqEUGT1hwEJtYyO3nUHEkz4nEQ4b8bUwJgEIwq3eFArrETnFVhpDojv57Ai1mWtxfuD1mtYqDsp7D6p4muJfpJHFROYFg+FaWVqeIIwVNug5FBZIxAZtWRDTH+XiyLdjC5rR3Cb/JwBQc0XY2wpRoVsYoNgXLhTp8UMWznN1wIpesvZK0XELCGECaQExRR1zPkQjt07UZEkb4NrkZ8T3HexWbqChinalvrFx+7Y9ok4rj99UZ0BXO4Xhj9fHCBltp/n9vI3nzdJXurLg6YZkUT2DW10FHHpUNT97AJ4YiOmWJ/3gEPrId7YbabE5RCTxBG2LvztU3dpl/ISmXIifButtA3TZk9B50Z8KhduJ2adp/47XHH5EHVXjovRicMcd3q3ilg3EGu8iNSSeFu+anv0GM/ShDUZtW3ifbmq5JbQhowG++asI0hdAy2QSdhLkW2hUfj7NhG+F0ZhPpk22QdvWSwa7zNdp7b4twuhLGd+7Tt6mCqxwr6y5CuPANaVf1Yjs0oUlzRi3pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(9686003)(66556008)(66476007)(2906002)(83380400001)(316002)(71200400001)(66446008)(54906003)(8936002)(4326008)(7696005)(76116006)(26005)(6506007)(478600001)(5660300002)(86362001)(66946007)(33656002)(53546011)(8676002)(7416002)(55016002)(52536014)(6916009)(186003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UjibT6nnyR+shpL1HYkAQfOFf7fZfkZ4Hj25oEHHXN/862Hn7JsJBig8d3I5?=
 =?us-ascii?Q?SRenQi3MR6DVJA/NP8I17RziEcoggZcTc9Aw7/0kf13HHkEfEok+JEUbRy1/?=
 =?us-ascii?Q?ip6wMLx1wMudRNSRvg39sJe+Qb/R6L/d+zBCtDojtOPqr33BRKdq9qpzlLQD?=
 =?us-ascii?Q?zZY5sipIlonC/nj/ErBIEWFTE/MajAwos1gc1V/hME0oJpZyaxpnEEBnyG26?=
 =?us-ascii?Q?i6RXs7Pf4GUwySmBPZ5rZQ8QivUpcCP/mOFFlD0EHWdjuiliXvKxdzV57n1s?=
 =?us-ascii?Q?+M2PrzTqyVbPKah49cj0b1aI6NQrF4+9YtuYsC4MNZVN5LVHjtzKDUazVNKo?=
 =?us-ascii?Q?ydoypyNp8WXqTljNbAE0xvw23tqqOYwbH507E7YQlHJMYnOkjWKti1aQKDCR?=
 =?us-ascii?Q?9i0wK0watpi0LAHUiYzKFajt7Mx3r1RxGNFU/0tG9tu8WswuFR0fN4rFm5Ky?=
 =?us-ascii?Q?6hY+wHS/cpi4w+UDW8PlVxLZC5uY8OhexuS1Z4/uoLtn2aluLgOI+ByP71Dh?=
 =?us-ascii?Q?HKzk054jx/AyH2WVAd6SaxBddr4BrQW9RT/FfWy0IxxUpUqEMCVwoR3CSWgL?=
 =?us-ascii?Q?XK5oEN+f6nPpbQZEFruS7wnhpTICE2uIxLFd58HOKGMXVwZdhfKlTSqjhu0P?=
 =?us-ascii?Q?S/6VTa+vHQj6ZH74OslveWNBeOvbIN+kIC1JrlhaMyfbjp51ob9LVOfgP7LE?=
 =?us-ascii?Q?zUHVk92L9bK/GX70swmo/uMrw1qxQB4WKzEkCmj4U4R0uNPhhy6eYNqmDrvP?=
 =?us-ascii?Q?8BGdj9nDeid/OvXohGVw55EMgvXZUk47wAdTkYvfms74W4xncZEGEgNNAHxQ?=
 =?us-ascii?Q?6q57Dhb20mXVe4OkG5+UhNcW1w15qRBmk6FUeu1aCm7/afpUpRY2NrZOr1X4?=
 =?us-ascii?Q?iUeXIxVho/2zd7ZSD/IixSyrm8Vgh4SJXQkPkvM9DxaQMDswQm9I9RbOR6UG?=
 =?us-ascii?Q?jGLDpApJzLXl/xA62OHOAYAbIH90VlJBZNLoAmDFlGgu10RoVTS3zGZ1nyg9?=
 =?us-ascii?Q?6VacWH5GniU0yJdSHKyfnCyYKYjwWiZvm8epIiTgPsi1jP6R0cDGz1DWqJIN?=
 =?us-ascii?Q?lbVdnOiZ3jt1PgtxXb/JRwqiL4Klb5NhLdKUW6X7zGpaC0ycDYJg6rKS6DuI?=
 =?us-ascii?Q?fA9Aae0HWaqLcTvEt+8X+LLrA/V22THljAEfnIV8tmyeHhSRMQDVkHn7hiE7?=
 =?us-ascii?Q?iB6dCxuW1Ob+DZu5X9DByZKAMYC5iQG/5d5uA9n35zGDsb5gQKnx9zssYq7I?=
 =?us-ascii?Q?9rc+Gt3rUfybd/vYC7dzzBSW6tLTJQsuPP0o+jQBLu9UZYTKaGIQhbG5QNoY?=
 =?us-ascii?Q?bY3g8lRFsUZFg2SpE+QjYAnG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4a1dd7-1ee9-454b-dab5-08d8d42f6142
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 17:05:23.2188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NUV7wMCEF6Glw9PmadvEg5JTnC21ZV9vAan+Xsy603L2K+MzPsYckhOueuM/yM34IgVdwebTs9ugjaPgpXII8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Public Use]


-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Thursday, February 18, 2021 10:39 AM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.co=
m; rkrcmar@redhat.com; joro@8bytes.org; bp@suse.de; Lendacky, Thomas <Thoma=
s.Lendacky@amd.com>; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger=
.kernel.org; srutherford@google.com; venu.busireddy@oracle.com; Singh, Brij=
esh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIS=
T ioctl

On Thu, Feb 18, 2021, Kalra, Ashish wrote:
> From: Sean Christopherson <seanjc@google.com>
>=20
> On Wed, Feb 17, 2021, Kalra, Ashish wrote:
> >> From: Sean Christopherson <seanjc@google.com> On Thu, Feb 04, 2021,=20
> >> Ashish Kalra wrote:
> >> > From: Brijesh Singh <brijesh.singh@amd.com>
> >> >=20
> >> > The ioctl is used to retrieve a guest's shared pages list.
> >>=20
> >> >What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS=20
> >> >is passed through to userspace?  That way, userspace could manage=20
> >> >the set of pages >in whatever data structure they want, and these get=
/set ioctls go away.
> >>=20
> >> What is the advantage of passing KVM_HC_PAGE_ENC_STATUS through to=20
> >> user-space ?
> >>=20
> >> As such it is just a simple interface to get the shared page list=20
> >> via the get/set ioctl's. simply an array is passed to these ioctl=20
> >> to get/set the shared pages list.
>>=20
>> > It eliminates any probability of the kernel choosing the wrong data=20
>> > structure, and it's two fewer ioctls to maintain and test.
>>=20
>> The set shared pages list ioctl cannot be avoided as it needs to be=20
>> issued to setup the shared pages list on the migrated VM, it cannot be=20
>> achieved by passing KVM_HC_PAGE_ENC_STATUS through to user-space.

>Why's that?  AIUI, KVM doesn't do anything with the list other than pass i=
t back to userspace.  Assuming that's the case, userspace can just hold ont=
o the list >for the next migration.

KVM does use it as part of the SEV DBG_DECTYPT API, within sev_dbg_decrypt(=
) to check if the guest page(s) are encrypted or not,
and accordingly use it to decide whether to decrypt the guest page(s) and r=
eturn that back to user-space or just return it as it is.

Thanks,
Ashish
