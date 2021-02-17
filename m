Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9FD31DB16
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhBQOBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:01:39 -0500
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:2277
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232951AbhBQOBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 09:01:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAXMeSHALO8YN8ICco2VSRbKtqyPhrL3p3WTAYYbOi8TNORm366cvcv2tox7goSNgmXSdfjJ0iq5tHMRTFGZkHVeH/RHqByiubHuHA8/63XPnT9y14pCOJYpQ4PmRUyDXBE6WwWFgsZIItOEdsvQlDQ2EudGWBQ6GC1WljJXWwo8ufVlK6z2F0afgXBZuvaWTN1Xg/zigX+gTsHULSEsAP/r/fwpMPt5gu85bSK4J31Wx+Co6a9g4nDL9klelgnNVFsWiOXXegu4QBYfGaptCdBWPumPj+tyWnxbBEZ4xsYdIGX68KiR3VFNS114O2bunwkKnduHND3PNvnmjXi6Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19K+b3miusv4ceQxLVTA3stkUaQcR7yOZ7LeqwUKuD0=;
 b=e01VKHI1M7yOZFWcHoPALidfDBEwNj+Mv/b8CWLmvx6KASe3D6y3cfJUK+pMe8v7S5l3lx/cipatYe6S1C1xAOJTCvFmBOmK4rqcs2SCLXVeEiGSfi3dkAPrAvxJZQfJBLs6jsQtnT9ONDCrI5qQR0L+oZlugP9wi6ovxQPSdYo4IU6H8rj4zPwMGELVj7Ilh6GPZh0wxfwdMYVryMq1iXQJg41Yn0foq3PvPSQrPVSIRneWrET7dlETJA5xwY95o7tvt3J6Deq0vJBLwdnKyplKUQODcteHRyG7geIZIV5DrOayNGEq7lk5+4a+c4qgYsW7vT7YdZbs/EucYq8BlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19K+b3miusv4ceQxLVTA3stkUaQcR7yOZ7LeqwUKuD0=;
 b=J+ydtboQDzvszFgKjXNwzOI29btXZDAdvenXPODmT5YRJiid9TRTMDPnqKDES4agX00IgaXxJX9oZnrW5mjaXZ/fv8FsGjFTwIp/DGF/kYcjRTdobPeWTr2I4bC9ycV9JU3nPSlgLTceGgCREs682MaKTY715kQ5sbWrXoFUB8w=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 14:00:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 14:00:44 +0000
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
Thread-Index: AQHW+o4w4C5VGgubRkqZlElkExidF6pbnD+AgADRN1A=
Date:   Wed, 17 Feb 2021 14:00:44 +0000
Message-ID: <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
In-Reply-To: <YCxrV4u98ZQtInOE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-17T14:00:39Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=460fabc0-65bf-43df-931a-4ad924367558;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [183.83.213.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4bf3b653-706e-4d71-5ae6-08d8d34c6b56
x-ms-traffictypediagnostic: SA0PR12MB4511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR12MB45117D5AA6ABBC867E9FCDEB8E869@SA0PR12MB4511.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2DKaBqM8AR8qNtZnoGi8tDxvzKlMeCkpr7YnUdfGxY1qzM88F6J0guL0c7aFGM4l5NB2UvBaPg1xcNRPcrY2JQkFotL3rw8AgGHYNQ3MwFeuFto43g/RzWYUmJisgIwuWtIHxkPbs6IFfVic9cft+OhhIkYBvkGArqyGUJeaj97RK0ylLgRImZwTcmCJRJPrGLBZC1UcqKJ63jlTw0BxqUTMP6GwXy+ck3huBpIyt+oYIEjepvSZJsE/g1TUek+o0O/uwQldQbv3mEXvS+LZT71ORmrktXeONZjawPFijF+KcYe9EWI5+auikLFfIprRj7fBuijB6f76ZVCx7T67G9NmOl1XnXI/MVuaHLAlF19t+Skbe+X2XG9b7ZCHMykB6CsIPriCxPJU93JbscASvTwUvb7T79sxnSsoKUNuaaslPU0mfgE+fDmJ40FdFxPg+HE/FZKEwr5YiIoBTDMc54Ewye78dNu8SlenRXB/rlXgq9Hg9/bwVEr4WJ5DW3z3Dn6e782YG8ihmPlLTw9ytg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(9686003)(66446008)(53546011)(66556008)(66476007)(5660300002)(64756008)(55016002)(52536014)(26005)(76116006)(83380400001)(186003)(6506007)(8676002)(66946007)(478600001)(316002)(6916009)(71200400001)(4326008)(33656002)(7416002)(8936002)(86362001)(2906002)(54906003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pnnWXb22pbE5r7s4q53CM5YXAR4tteyCl9uF82QEv9DyyyGXT67OUL0vl4nU?=
 =?us-ascii?Q?c3zcdbAg8IPlOSAljdIRZJW9wRWFQh88i3PSHmM2aZOK7wMjnibJ8Cy3S4QA?=
 =?us-ascii?Q?3a/Za23wryDjJAXWfNVOhHiNZuB7Si+3++MrwR1YELRHVY+T7bl97BHrnGf+?=
 =?us-ascii?Q?qM74w6YUnRWPuJDDAkru2MfR8JM9ifFjAyUGhYszk21wggJRCXGY4T1Jflhd?=
 =?us-ascii?Q?bUHlL/LHdMsVslHemTRs/WM5c7sVT8KmkglF2ZJ1qtk8aS69xhsnOpO/tt6A?=
 =?us-ascii?Q?TRu7ZfEer9QKM0Vs9jVrZYewSX5dw1vBbVqaY7BNlj9qmbiiHGitdkPYNOP8?=
 =?us-ascii?Q?GjHjY1WEy3n5QkNUPxrbcLoD+jAKZ/gobe4H/Z8pASDfQvhCGlDZwCQ/y77L?=
 =?us-ascii?Q?0u5w3riA7pjdDBEaaj2FyryL6F+Bdm4QyX5N7ZorF+6QLLX2EFEPxGFaabrG?=
 =?us-ascii?Q?R14oLSJwpswq9S1YcRLBQ9q4qvBWCUcO4UU/Ql7djgj0K7kCZoIu+hdj09qx?=
 =?us-ascii?Q?fuE4/gOtomrU1HBbzsTL1gwkAZHqLCk4Y7e9LZmLPn3f2S6ddJn5asGUNupx?=
 =?us-ascii?Q?B1COhwGq0VLRQQsDJHAYthxsIIdHPuw6OYIBJUjab7M9rs0uVK09l151XJrN?=
 =?us-ascii?Q?Izq03MQlr3px2qg37YacUfEVciyO2Dj+Bsl5wsry2FOEoqdPhEMRkzTyJvmu?=
 =?us-ascii?Q?atxQ9qUFn0pJa8STGQVQW/APx8WXTIaC05zuzKlOOVLmKy5U5LPyzGbshER+?=
 =?us-ascii?Q?xYYax8B1Jf1ScPSrT+ZaCWYmI18HRNbejSDxzEoRLAFA/2t/I1gnEeDssd5W?=
 =?us-ascii?Q?sG2r6ZDj32K/db02G8g1wIVqBJcZ2arxQbXoN7eCHxUItzhR7ido2jrfhUS6?=
 =?us-ascii?Q?s4Rqed59nql0U/08x5vC43ZITuqHCOxN27lydLwojKgkavxJIMyMkxOYzcOK?=
 =?us-ascii?Q?g9+sWv5yezYAAco00IAfaLZS2Bh/IGFnnQD0P3Jpp6CytT69kJ+1NsG8rO7z?=
 =?us-ascii?Q?PfoS2f0P5vVvx/oM5DRT1/Q0jxT8UTgUtqYclRnGlISpsDJEYZjdVDl0uB3r?=
 =?us-ascii?Q?KCSW+wViBAGZ1YZrwkbzWxmqovPBGyIYJPX7Ncob2e5ywglxQDFw5K0fSWGr?=
 =?us-ascii?Q?6J/4Kx4k6R896M8BffAQFckOuZC3kuulG3G8fqWveqk1903i/f3fqsyjRR4e?=
 =?us-ascii?Q?yVhMsxBbzWEZV2bvvx73tncoqFc+yMDBk32XVHMOigq1jcRopEVrGdUdtvW1?=
 =?us-ascii?Q?ZTAxlFiJdpIe2b3EjpJO1tR7AQRkoY2HvZB8vBws0zy+Yar+BUlAobHqetEw?=
 =?us-ascii?Q?gx8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf3b653-706e-4d71-5ae6-08d8d34c6b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 14:00:44.2972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EnSrqzhWNVw7gUDa0ML8RxOyyP8ptIF/kL1I7KGQbV0dZFrNaj332VI7ISFf2ei1tRxVbvDiBhYYCBf/XeHoow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Public Use]

-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Tuesday, February 16, 2021 7:03 PM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.co=
m; rkrcmar@redhat.com; joro@8bytes.org; bp@suse.de; Lendacky, Thomas <Thoma=
s.Lendacky@amd.com>; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger=
.kernel.org; srutherford@google.com; venu.busireddy@oracle.com; Singh, Brij=
esh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIS=
T ioctl

On Thu, Feb 04, 2021, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>=20
> The ioctl is used to retrieve a guest's shared pages list.

>What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is passe=
d through to userspace?  That way, userspace could manage the set of pages =
>in whatever data structure they want, and these get/set ioctls go away.

What is the advantage of passing KVM_HC_PAGE_ENC_STATUS through to user-spa=
ce ?

As such it is just a simple interface to get the shared page list via the g=
et/set ioctl's. simply an array is passed to these ioctl to get/set the sha=
red pages
list.

>Also, aren't there plans for an in-guest migration helper?  If so, do we h=
ave any idea what that interface will look like?  E.g. if we're going to en=
d up with a full >fledged driver in the guest, why not bite the bullet now =
and bypass KVM entirely?

Even the in-guest migration helper will be using page encryption status hyp=
ercalls, so some interface is surely required.

Also the in-guest migration will be mainly an OVMF component, won't  really=
 be a full fledged kernel driver in the guest.

Thanks,
Ashish
