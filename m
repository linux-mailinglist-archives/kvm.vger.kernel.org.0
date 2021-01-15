Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE232F6FE8
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbhAOBRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 20:17:17 -0500
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:20544
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbhAOBRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 20:17:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8IlYk5TuzZceBSGVzfj4cBsmb1lKVKqBk68QkpsPfjFjqE8iShW0bOXRKe144GM/5Yw4nrDL5Clj7jzJmkadxnkerLDv1vL13QXXgi4F3OPTAg4B4w6o7vAQYe6YpEoR0xLM7P4cp7z92ZwMPoNWSYBQt0U4cb8TRnTwoBw2gSsBOUNJVjQhtr9IeCDtw7R9fPA0Y4Y5i/7DmTsikeT7oSppt8FW+yZueKa2r7Iy0hK38yY672z2iwSlK3mPVRdE8iH2luPrzdAAjcR2/SWXknK1RIP4nmREgtH3NsTZCUyg/8MSNCDN6JilU4AfIn7rpCqYeEGoB5JtUbX+umXHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6aLw5zmudmUJ4nKGlnsdJj2v2koygeD4I/v/krJGwc=;
 b=BrLJSDUei8vTkkWiHsm8Q3WzD2FaF65fmGJ4seClXWLvsnTLUL7Tj7jUgUjgw1Wj0hyG5kxAgGw6syzE/H5eZJUViu2Jbvj8BUbhIQPqzzPmMnAIXRQk8pa/iqJR6x8kBGiElZfBDHs1Up1lIMQcPGmiYwCW43gQIZU+KhwA1kWa37mXSnb8r4y3Xwcoj+hR0JjJbatXcg8iLGW+pIzJDvvbRrGN3xEsuvHiFn1LtKohz7K2Oj1fJ7Mo+O3onVmndnGEgPYtE2vqZyP87hohpqzzl9eBXQLqLCYANZFt0L/zQjulXd+Vx1knw4jIJX2Msk5ZtqTfHDQmyOUpdZjdNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6aLw5zmudmUJ4nKGlnsdJj2v2koygeD4I/v/krJGwc=;
 b=hDUfNAPzSUjLtlgVEvElnJM9YQvQrdFy5dhsqxiXOcncdTXMePIGgDdAnSEGvuJ2twG85z1cd/KXLY3F0/aYZw6MvjiFTmZI7JR3tHuQPzJttDvVAsSfGB8VbgkK6BC9A73VNM5dHyY7g5zXGsVZdRqoSSMG8veOx+WhKzvHj/w=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 01:16:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 01:16:21 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: RE: [PATCH v9 00/18] Add AMD SEV guest live migration support
Thread-Topic: [PATCH v9 00/18] Add AMD SEV guest live migration support
Thread-Index: AQHWza3ltIAIuI0JmE+oWkdmYf+LCKooEE+AgAAL3fA=
Date:   Fri, 15 Jan 2021 01:16:21 +0000
Message-ID: <SN6PR12MB2767A032F9939E10A65B0B018EA70@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
 <CABayD+e+_ye9s-toCFwfaZkTbhM0=pMuyt5dtjmZJpmf3OT5mg@mail.gmail.com>
In-Reply-To: <CABayD+e+_ye9s-toCFwfaZkTbhM0=pMuyt5dtjmZJpmf3OT5mg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-01-15T01:15:50Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=060027de-33bc-4bdf-9950-0000b61222d1;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2021-01-15T01:16:17Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: c7fd43c8-fd36-43c4-afb7-00003e85d89b
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
dlp-product: dlpe-windows
dlp-version: 11.5.0.60
dlp-reaction: no-action
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [136.49.12.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: da77dc50-2366-4d1a-16fa-08d8b8f32b5e
x-ms-traffictypediagnostic: SA0PR12MB4413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR12MB4413B972CF6926F8C09CFA918EA70@SA0PR12MB4413.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fL1P1Bd4BeYmKOa4xuBuYLpSmgdjj6e6zgQMb3g26OQto2p05W9dwO+b5bFnFfIyMHVdoNPNLSOM6UzG4ffNkWKFpRQ/pRLEGQrl+lSORosUfXh6OVuwUPDEEQmRgaMHXpyTyCvnDXiLfO+3A9V6gFmwCC9n4Mve45Bhi8M7zGBgO78zL7SyovvhwyRvCGUsp2BABhAqsq+z9VAIl7jL+XRf6nYH2U5AjTdCIRrZseAhpw1Bs2krDOgk+0Akb7r8WL28bMoG46maE9p/t5XoEQo7CS1JnFaupYZMm5LCIx0kZQMLCTP8jrolVlaJVI2wnYx1rE5f2YxV/mhPrz5Z66Qs1ru9H0EcruL2tHH4pjod5OUBk1MM33p75n3+aVBZ0hJ/sRIpP2Op/4bl1wx4rATutmkKVqhpxSveGzDlGtizewN1TDDNmpP/HSbEg6YsghD1c/Y3mtmHU6WV1ep2/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(8936002)(6506007)(9686003)(45080400002)(71200400001)(316002)(33656002)(8676002)(76116006)(86362001)(53546011)(6916009)(2906002)(26005)(54906003)(7416002)(966005)(52536014)(66946007)(66476007)(5660300002)(7696005)(83380400001)(64756008)(66446008)(478600001)(66574015)(66556008)(186003)(55016002)(4326008)(30864003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-2?Q?d5E4r8lRSkIr6g3r82d0ujiafz1qsHDl0f5B5FCvezNtqQP311co0G6Dpf?=
 =?iso-8859-2?Q?m5cptnGyNhcx6gntufTyRbL5gF/xEAydzcw0oIfQCEJ2MtWmXqYPCU3+RS?=
 =?iso-8859-2?Q?ORoR2H4dETDdHQD3ThAsoak94EI3xw6fcjp4eK0X91cR1rcA/J2s/+AYkT?=
 =?iso-8859-2?Q?nqTuRZBN9I8DJ84GTiVTkCahOafsLzWdpnlwUiDRxaNIvfWuTqL/jLnjJT?=
 =?iso-8859-2?Q?JqcSI+dOdYqKjRFgvvRbyRjS8pIVsPdHK1xdNG3EJG0Wx0qlVEVHlbYKiS?=
 =?iso-8859-2?Q?2fBojr8nfHPBK4q5GBdfCiRVOJEfI76XECY3L1hBdjDh377VfnKnlH9Fpp?=
 =?iso-8859-2?Q?gW1sq+T0sWS/Vb67HDmNQP2RLPtQmov22Fu6Dc6QdCzbSHZA6pWPpkJr6W?=
 =?iso-8859-2?Q?C6lsCOPVlCWBZFihp9bf5jum/h9jKgDNihWDq88iebovDKf/ztAAiyxAQr?=
 =?iso-8859-2?Q?FHWYJnzn765pBw/Tu7Q6GTs5RU5GLW1f4Ju7/n1qsCt3Ii/jwwJl0rPy+B?=
 =?iso-8859-2?Q?Io2btTSY/F10oZrsXrtOm5RGifbRA9CFeT2wpMmeLeeqrV2uKNAp9HDSRG?=
 =?iso-8859-2?Q?HzF0zumCf+KazQ1btQC2ERtbDNIj3Aq8NyJ/Lfw9I3uwKxqdsLNgqxZE20?=
 =?iso-8859-2?Q?IWueuTiHCl+7y6eWnWfrN058lPAfFa34kUJ+/qL/S2LAyYh15jBKkO1OWp?=
 =?iso-8859-2?Q?LG4I/Uk1dZl2SBoPc7xzvf1AZk4DCmmHXbmhm6yVZEcWMyMeatBQlkTZ+0?=
 =?iso-8859-2?Q?zEoEhs3LaLT3C9OK3KbU51u3+vmuE/CZnTYEP7l5U4Rm7N0cH2jJB/jnRK?=
 =?iso-8859-2?Q?dRLTDjIYSA4ExiKGEx3qLXUqVdVdvopRaqZyKmXxEinigo2NTVZSEDSess?=
 =?iso-8859-2?Q?g28cDBpPYKaxQeCZeLt9CRaIiRkUSY+8AXSkFE60ZjTatt8+k5sMsST1Jv?=
 =?iso-8859-2?Q?kBnOrgC/brr4yIlDKyNG8unetfeO126vJfzWvqRTOiy0X1d8PDZFeQTTeX?=
 =?iso-8859-2?Q?FOMNzJGScfE5mKxkU=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da77dc50-2366-4d1a-16fa-08d8b8f32b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 01:16:21.5636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GKVH4hHnAaUmzmE7KRu7Fplee/dHqytcyCtB3fh3AQhnMndcTLAsEKlsMloYW9lN2OdsGJuGaIcT06SamrRseA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Public Use]

Hello Steve,

I don't think we have ever discussed supporting this command, maybe we can =
support it in a future follow up patch.

Thanks,
Ashish

-----Original Message-----
From: Steve Rutherford <srutherford@google.com>=20
Sent: Thursday, January 14, 2021 6:32 PM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner <tglx@linutronix.d=
e>; Ingo Molnar <mingo@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Radim K=
r=E8m=E1=F8 <rkrcmar@redhat.com>; Joerg Roedel <joro@8bytes.org>; Borislav =
Petkov <bp@suse.de>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; X86 ML <x8=
6@kernel.org>; KVM list <kvm@vger.kernel.org>; LKML <linux-kernel@vger.kern=
el.org>; Venu Busireddy <venu.busireddy@oracle.com>; Singh, Brijesh <brijes=
h.singh@amd.com>
Subject: Re: [PATCH v9 00/18] Add AMD SEV guest live migration support

Forgot to ask this: is there an intention to support SEND_CANCEL in a follo=
w up patch?


On Tue, Dec 8, 2020 at 2:03 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> The series add support for AMD SEV guest live migration commands. To=20
> protect the confidentiality of an SEV protected guest memory while in=20
> transit we need to use the SEV commands defined in SEV API spec [1].
>
> SEV guest VMs have the concept of private and shared memory. Private=20
> memory is encrypted with the guest-specific key, while shared memory=20
> may be encrypted with hypervisor key. The commands provided by the SEV=20
> FW are meant to be used for the private memory only. The patch series int=
roduces a new hypercall.
> The guest OS can use this hypercall to notify the page encryption status.
> If the page is encrypted with guest specific-key then we use SEV=20
> command during the migration. If page is not encrypted then fallback to d=
efault.
>
> The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can=20
> be used by the qemu to get the page encrypted bitmap. Qemu can consult=20
> this bitmap during the migration to know whether the page is encrypted.
>
> This section descibes how the SEV live migration feature is negotiated=20
> between the host and guest, the host indicates this feature support=20
> via KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature=20
> and sets a UEFI enviroment variable indicating OVMF support for live=20
> migration, the guest kernel also detects the host support for this=20
> feature via cpuid and in case of an EFI boot verifies if OVMF also=20
> supports this feature by getting the UEFI enviroment variable and if=20
> it set then enables live migration feature on host by writing to a=20
> custom MSR, if not booted under EFI, then it simply enables the=20
> feature by again writing to the custom MSR. The host returns error as=20
> part of SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration=
.
>
> A branch containing these patches is available here:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> ub.com%2FAMDESE%2Flinux%2Ftree%2Fsev-migration-v9&amp;data=3D04%7C01%7CA
> shish.Kalra%40amd.com%7C940bfdcae0f640321ff208d8b8ed0e93%7C3dd8961fe48
> 84e608e11a82d994e183d%7C0%7C0%7C637462676023260162%7CUnknown%7CTWFpbGZ
> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C1000&amp;sdata=3DyyEegH2gWukbKMM%2FQ%2FgkMpHacwxu7KJ0E3Q3wfxLZ%2B0%3
> D&amp;reserved=3D0
>
> [1]=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fdeve
> loper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=3D04%7C01%7C
> Ashish.Kalra%40amd.com%7C940bfdcae0f640321ff208d8b8ed0e93%7C3dd8961fe4
> 884e608e11a82d994e183d%7C0%7C0%7C637462676023270160%7CUnknown%7CTWFpbG
> Zsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%
> 3D%7C1000&amp;sdata=3DRhUoTrbJelVdD4ijE4XpZNIr%2BIMokCY6FTtlAWhcLEs%3D&a
> mp;reserved=3D0
>
> Changes since v8:
> - Rebasing to kvm next branch.
> - Fixed and added comments as per review feedback on v8 patches.
> - Removed implicitly enabling live migration for incoming VMs in
>   in KVM_SET_PAGE_ENC_BITMAP, it is now done via KVM_SET_MSR ioctl.
> - Adds support for bypassing unencrypted guest memory regions for
>   DBG_DECRYPT API calls, guest memory region encryption status in
>   sev_dbg_decrypt() is referenced using the page encryption bitmap.
>
> Changes since v7:
> - Removed the hypervisor specific hypercall/paravirt callback for
>   SEV live migration and moved back to calling kvm_sev_hypercall3
>   directly.
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
>   build error when CONFIG_HYPERVISOR_GUEST=3Dy and
>   CONFIG_AMD_MEM_ENCRYPT=3Dn.
> - Implicitly enabled live migration for incoming VM(s) to handle
>   A->B->C->... VM migrations.
> - Fixed Documentation as per comments on v6 patches.
> - Fixed error return path in sev_send_update_data() as per comments
>   on v6 patches.
>
> Changes since v6:
> - Rebasing to mainline and refactoring to the new split SVM
>   infrastructre.
> - Move to static allocation of the unified Page Encryption bitmap
>   instead of the dynamic resizing of the bitmap, the static allocation
>   is done implicitly by extending kvm_arch_commit_memory_region() callack
>   to add svm specific x86_ops which can read the userspace provided memor=
y
>   region/memslots and calculate the amount of guest RAM managed by the KV=
M
>   and grow the bitmap.
> - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
>   of simply clearing specific bits.
> - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
>   KVM_SET_PAGE_ENC_BITMAP.
> - Extended guest support for enabling Live Migration feature by adding a
>   check for UEFI environment variable indicating OVMF support for Live
>   Migration feature and additionally checking for KVM capability for the
>   same feature. If not booted under EFI, then we simply check for KVM
>   capability.
> - Add hypervisor specific hypercall for SEV live migration by adding
>   a new paravirt callback as part of x86_hyper_runtime.
>   (x86 hypervisor specific runtime callbacks)
> - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
>   and adding check for SEV live migration enabled by guest in the
>   KVM_GET_PAGE_ENC_BITMAP ioctl.
> - Instead of the complete __bss_decrypted section, only specific variable=
s
>   such as hv_clock_boot and wall_clock are marked as decrypted in the
>   page encryption bitmap
>
> Changes since v5:
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>
>
> Changes since v4:
> - Host support has been added to extend KVM capabilities/feature bits to
>   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
>   query for host-side support for SEV live migration and a new custom MSR
>   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
>   migration feature.
> - Ensure that _bss_decrypted section is marked as decrypted in the
>   page encryption bitmap.
> - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
>   as per the number of pages being requested by the user. Ensure that
>   we only copy bmap->num_pages bytes in the userspace buffer, if
>   bmap->num_pages is not byte aligned we read the trailing bits
>   from the userspace and copy those bits as is. This fixes guest
>   page(s) corruption issues observed after migration completion.
> - Add kexec support for SEV Live Migration to reset the host's
>   page encryption bitmap related to kernel specific page encryption
>   status settings before we load a new kernel by kexec. We cannot
>   reset the complete page encryption bitmap here as we need to
>   retain the UEFI/OVMF firmware specific settings.
>
> Changes since v3:
> - Rebasing to mainline and testing.
> - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
>   page encryption bitmap on a guest reboot event.
> - Adding a more reliable sanity check for GPA range being passed to
>   the hypercall to ensure that guest MMIO ranges are also marked
>   in the page encryption bitmap.
>
> Changes since v2:
>  - reset the page encryption bitmap on vcpu reboot
>
> Changes since v1:
>  - Add support to share the page encryption between the source and target
>    machine.
>  - Fix review feedbacks from Tom Lendacky.
>  - Add check to limit the session blob length.
>  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
>    the memory slot when querying the bitmap.
>
> Ashish Kalra (7):
>   KVM: SVM: Add support for static allocation of unified Page Encryption
>     Bitmap.
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   KVM: x86: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
>     encryption bitmap.
>   KVM: x86: Add kexec support for SEV Live Migration.
>   KVM: SVM: Enable SEV live migration feature implicitly on Incoming
>     VM(s).
>
> Brijesh Singh (11):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   mm: x86: Invoke hypercall when page encryption status is changed
>   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
>
> Ashish Kalra (7):
>   KVM: SVM: Add support for static allocation of unified Page Encryption
>     Bitmap.
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   KVM: x86: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
>     encryption bitmap.
>   KVM: x86: Add kexec support for SEV Live Migration.
>   KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.
>
> Brijesh Singh (11):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   mm: x86: Invoke hypercall when page encryption status is changed
>   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
>
>  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
>  Documentation/virt/kvm/api.rst                |  71 ++
>  Documentation/virt/kvm/cpuid.rst              |   5 +
>  Documentation/virt/kvm/hypercalls.rst         |  15 +
>  Documentation/virt/kvm/msr.rst                |  16 +
>  arch/x86/include/asm/kvm_host.h               |   7 +
>  arch/x86/include/asm/kvm_para.h               |  12 +
>  arch/x86/include/asm/mem_encrypt.h            |  11 +
>  arch/x86/include/asm/paravirt.h               |  10 +
>  arch/x86/include/asm/paravirt_types.h         |   2 +
>  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
>  arch/x86/kernel/kvm.c                         |  90 ++
>  arch/x86/kernel/kvmclock.c                    |  12 +
>  arch/x86/kernel/paravirt.c                    |   1 +
>  arch/x86/kvm/svm/sev.c                        | 790 ++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                        |  21 +
>  arch/x86/kvm/svm/svm.h                        |   9 +
>  arch/x86/kvm/vmx/vmx.c                        |   1 +
>  arch/x86/kvm/x86.c                            |  35 +
>  arch/x86/mm/mem_encrypt.c                     |  68 +-
>  arch/x86/mm/pat/set_memory.c                  |   7 +
>  include/linux/efi.h                           |   1 +
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  52 ++
>  include/uapi/linux/kvm_para.h                 |   1 +
>  25 files changed, 1365 insertions(+), 5 deletions(-)
>
> --
> 2.17.1
>
