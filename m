Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F41E161BDC
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 20:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgBQTuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 14:50:11 -0500
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:2144
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727217AbgBQTuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 14:50:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfbILDBQxoIoD0FdRqR4ZsmkZ6XCI/L64cYp8r06keLZ1tgKjoOTMdmSfS/pL55FI3VKiE0aIMgUSlalYPCqzzA6bHCegVe0X7in6Hlb2rSeJ//f64z5gxJ8iDAmc0CTsTkYFFFvK9gO9y6/lHKoZvYf6NniZ1wEL2wBRFLbDKpWK+8lCNn35QHexkRJ8ZzA8mJKjJuBNndaZCgOxPQ3ZWxJNFP+hkeSp3iTeAxQNotXWSBrpZkDWnBBt2/TvGaG4Vk9dwEUyIK7o/CT+VIs06UzGYlRaCY2udjqJGUqSZzCRtuUKAyBy3ocbB1kjf5gPaeEfA6oJSmk6vcjdgrraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hB3lbuJToFDCX08I1cyh4hmkgvLeFIVnxrSaPH3tUxk=;
 b=YyTuzSAYlg2ipQLCwZvVUC40v6Q98Z2J+KfrgtmiDyJoldKcxvKTMNnCDJYUVvyPuNXQuPZ106rb0GiMSCiQwsWW8hGhtk0HnBr512wvUL1hDAPjA010SlrulMELLT6kOWNomZdp8yky07RDHgRql3/PfGewUjk10016GfYyifDb4UctqM4xXaEsa6SIIcTiNBQ8wzz99FXq3SVXcvl4x6+XVtoTuG7O6/tu4vmsttmp6rka1rdN7xyFfx8SlUwHgq3TmGKRmvaYxkY325ZCd8eJqWdchxLt3s9JL/mu/8QfuYBZRi81gchhbUSauq+rJQOZITz1vSbKNhw4BSgl3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hB3lbuJToFDCX08I1cyh4hmkgvLeFIVnxrSaPH3tUxk=;
 b=m7g68OwuAqR3D1NEyKNY9O5FKVFiS8NsGWPatJbnESGnni/wtQrhdIFdePUl/jDqPBIH7FsIBfhrIXvredkC9YtimTyVm1hXVr2rvafdP966emSyDiANLIZOaGg/JRWQ+syA5x6nGlv/TwWM1Uk11T/WIV9c6r3kfMrLsUoaJaY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2397.namprd12.prod.outlook.com (52.132.195.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Mon, 17 Feb 2020 19:50:07 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2729.032; Mon, 17 Feb 2020
 19:50:07 +0000
Date:   Mon, 17 Feb 2020 19:49:59 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
Message-ID: <20200217194959.GA14833@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
 <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:4:60::48) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR08CA0059.namprd08.prod.outlook.com (2603:10b6:4:60::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 19:50:05 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65d08e2e-bfa1-4af7-5a01-08d7b3e296df
X-MS-TrafficTypeDiagnostic: SN1PR12MB2397:|SN1PR12MB2397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2397AF76A36C7B10AFF1F58A8E160@SN1PR12MB2397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(199004)(189003)(316002)(9686003)(6666004)(4326008)(66556008)(66476007)(478600001)(1076003)(66946007)(55016002)(7416002)(2906002)(5660300002)(86362001)(8676002)(44832011)(81156014)(33656002)(956004)(33716001)(53546011)(26005)(81166006)(52116002)(8936002)(54906003)(6916009)(6496006)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2397;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vNMkw0wzUZ/3zE1tpEvUK/i1e8POwamqlAn3ZZMt0kubVMbIdUAOQ8rtxkX8gpLx3OPUP69JB6ubsgPyuWUXRlUceRGnYzG8HrTU1mxvFQx7fqfj83uG78/3u64rC1NAeod2gH4utyhXNayWMQR2BXXDAAoMMXBKUPtWLCt7i9Kv2Ky8CmV2aJXspJZkQIqq1aeJhFdQQ82vbw1YcMh8ef3ZzsFBsgoKaGDpTRiHUb7TF1o0SiA7OlJPQhE8ciBCkZCaaDB2Rnx4et40z+YoTS5K4VbzACTy5pByT9Ef+iWtb2CTW2U/uGbHyh1u0PftfXbggGf4eWJF/9YSsGdE+Ah9Tq7CiCxwWmh0jHU13b3SFSbM6ghafXCI6dPDmmOINfutsAvd3LJDZ05m1QpKC3PCnnY1T/O2rJjENZozRTqTl+VY/KybrTk4bvNE3Pl
X-MS-Exchange-AntiSpam-MessageData: NbYSPqUZeSjZCwQs+cpQVvikbpkG/iaQJbveKJZFz7wS6QzIw824impX/RkEKHqG8c9enNRLgzGiL0LZRGAgmNjGvHsxHPO43KaYJPhdchNfepjQry2XVxitu+tR/Y8tmW+MVO91d6ctV3HgRUiO3Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d08e2e-bfa1-4af7-5a01-08d7b3e296df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 19:50:07.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt/OyD18Z3UP5x1TTvCyD3rWyzWkJBAs2/ecaDq0yXyx1YG75Pmage0Im+sdJJOyJZErgTW9rJOVg8SNeAOlTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2397
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 10:58:46AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 13, 2020 at 3:09 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Wed, Feb 12, 2020 at 09:43:41PM -0800, Andy Lutomirski wrote:
> > > On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > >
> > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > >
> > > > This patchset adds support for SEV Live Migration on KVM/QEMU.
> > >
> > > I skimmed this all and I don't see any description of how this all works.
> > >
> > > Does any of this address the mess in svm_register_enc_region()?  Right
> > > now, when QEMU (or a QEMU alternative) wants to allocate some memory
> > > to be used for guest encrypted pages, it mmap()s some memory and the
> > > kernel does get_user_pages_fast() on it.  The pages are kept pinned
> > > for the lifetime of the mapping.  This is not at all okay.  Let's see:
> > >
> > >  - The memory is pinned and it doesn't play well with the Linux memory
> > > management code.  You just wrote a big patch set to migrate the pages
> > > to a whole different machines, but we apparently can't even migrate
> > > them to a different NUMA node or even just a different address.  And
> > > good luck swapping it out.
> > >
> > >  - The memory is still mapped in the QEMU process, and that mapping is
> > > incoherent with actual guest access to the memory.  It's nice that KVM
> > > clflushes it so that, in principle, everything might actually work,
> > > but this is gross.  We should not be exposing incoherent mappings to
> > > userspace.
> > >
> > > Perhaps all this fancy infrastructure you're writing for migration and
> > > all this new API surface could also teach the kernel how to migrate
> > > pages from a guest *to the same guest* so we don't need to pin pages
> > > forever.  And perhaps you could put some thought into how to improve
> > > the API so that it doesn't involve nonsensical incoherent mappings.o
> >
> > As a different key is used to encrypt memory in each VM, the hypervisor
> > can't simply copy the the ciphertext from one VM to another to migrate
> > the VM.  Therefore, the AMD SEV Key Management API provides a new sets
> > of function which the hypervisor can use to package a guest page for
> > migration, while maintaining the confidentiality provided by AMD SEV.
> >
> > There is a new page encryption bitmap created in the kernel which
> > keeps tracks of encrypted/decrypted state of guest's pages and this
> > bitmap is updated by a new hypercall interface provided to the guest
> > kernel and firmware.
> >
> > KVM_GET_PAGE_ENC_BITMAP ioctl can be used to get the guest page encryption
> > bitmap. The bitmap can be used to check if the given guest page is
> > private or shared.
> >
> > During the migration flow, the SEND_START is called on the source hypervisor
> > to create an outgoing encryption context. The SEV guest policy dictates whether
> > the certificate passed through the migrate-set-parameters command will be
> > validated. SEND_UPDATE_DATA is called to encrypt the guest private pages.
> > After migration is completed, SEND_FINISH is called to destroy the encryption
> > context and make the VM non-runnable to protect it against cloning.
> >
> > On the target machine, RECEIVE_START is called first to create an
> > incoming encryption context. The RECEIVE_UPDATE_DATA is called to copy
> > the received encrypted page into guest memory. After migration has
> > completed, RECEIVE_FINISH is called to make the VM runnable.
> >
> 
> Thanks!  This belongs somewhere in the patch set.
> 
> You still haven't answered my questions about the existing coherency
> issues and whether the same infrastructure can be used to migrate
> guest pages within the same machine.

Page Migration and Live Migration are separate features and one of my
colleagues is currently working on making page migration possible and removing
SEV Guest pinning requirements.
> 
> Also, you're making guest-side and host-side changes.  What ensures
> that you don't try to migrate a guest that doesn't support the
> hypercall for encryption state tracking?

This is a good question and it is still an open-ended question. There
are two possibilities here: guest does not have any unencrypted pages
(for e.g booting 32-bit) and so it does not make any hypercalls, and 
the other possibility is that the guest does not have support for
the newer hypercall.

In the first case, all the guest pages are then assumed to be 
encrypted and live migration happens as such.

For the second case, we have been discussing this internally,
and one option is to extend the KVM capabilites/feature bits to check for this ?

Thanks,
Ashish
