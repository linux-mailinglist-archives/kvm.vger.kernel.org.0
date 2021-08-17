Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ECF3EEE26
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbhHQOJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 10:09:13 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:6915
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231359AbhHQOJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 10:09:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7B7V1lLOYkD/afWCxg7vRot56o3wPRs9uQMWgT+DZFWsEUVsPPi53H5roa7715qqEqWf6QyIkPqFNgHn90UHTIQfegw/3UL4Cxl3GMeR0nk3redGQ9TFVMoJZuWzTQdG9xAkFxCiqTVPP6ah8bipC+2DOImd1U7GYqU/aCM2LKGbVi37IoCIML5s3/SrQx+JpGEp35jezQibSp+Oq0byOOMWT0cP35fpg5pRz13ubbobrUlrohCopo7FdmswQglqAZNZPAYgV1qOFuh30Vr15rNhWjHOTW5n6qSoaanUqYedGBGPEiA5AcZo02/9gkJZ3Zc6F5kFjebimIUE7pjKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib8iM326UnOMCERkIrV46gu6R45NOqLORMOqUn9lJmA=;
 b=l/C4qPODfgQXU+MU78QfH2I6ie4gTD59zNtkx1m/xMVgWCagszMcj02nR9JPT9pmZxk57VlGiWC8ijOisPXRQjWgMka4EE01LF2IyKkpkRmMHJuZyRF14Qejtx0fqAahpsPYUEQ1r7Vby9V8oCj01cJ14ilM6fyqEK86nnQgcD+l5lF9a0gvJFQIOSH8/8ddyzDltUs4+2g2wn8HIUPt6Am3jJgZkjoyIpKBSecThu1y5yYnI7UxZ9M+rgf4JVwy+NS4fr5yMkclPyuYldveshgg5lkok9WISB5J1AAu25SPOg7ELG6r49qI0bYi0qntIRbb1CDBJjV7nlG8nVSDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib8iM326UnOMCERkIrV46gu6R45NOqLORMOqUn9lJmA=;
 b=oJ3h8lj9sdeie/gg2xiiK4JkOEuJD5i2Q0ApEILJvnUv5xW4eiDsblYgEGEALwsa+FkNTwP7EZ2689x+esDryRO37a+Vm1botvfR2YtvPPiF08ZsoaISZsKqDIdpgmZHuN16bDUsNhw+8oyag3lJoV9GRps+26YtfbBw1Q4xxxw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Tue, 17 Aug
 2021 14:08:37 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 14:08:37 +0000
Date:   Tue, 17 Aug 2021 14:08:30 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Steve Rutherford <srutherford@google.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210817140830.GA31037@ashkalra_ubuntu_server>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <YRt1gHThNWvRzUF8@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRt1gHThNWvRzUF8@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN1PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:802:20::42) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN1PR12CA0071.namprd12.prod.outlook.com (2603:10b6:802:20::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 14:08:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf465ba-f094-4d0d-52ac-08d9618881cf
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2637FE7549D5FE398F2A932B8EFE9@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T5XuvZRa4AfRwTda1qYlBRYdm96f7ZNOiGe6o96jU91hQ+hePoHKiLRg7fec7jivIM68eND8kz+0tWOPKvbTXXUa0cqXx3GmBT5xC4W6/NPcS3d4vh7IUQf7Je9Mho7c/QTgwo2Ml/q6kKhGMA2+qRyskKSTxM6HH0XYhk7z/tyV4ZFZ0BtOWmvLT20FSCohTL996W3vIXQFEY0pNfKHnDycBPLAZFrL6KCNB2O3rPQhEKykUPZgG8bFmjb9gU3Wrw4m9RdTICg4srf6NBGOseHgBW5RQqeymR4XQMFkVDvrT5y30Z9/hs66sskVQ/wA/Q4ngW/3URE6ceLrPIyT9p+n2wBlNpjopmzs4ufcQb9k6GozkvoePsmfMDL6PlJ2iCf7X4pHteJdGxUkWUz8bP6Ei8jaT5vzwCju3vWsFoTQ5BRscNCBUERUOa+K3bUzWgn0c0fkhyqGpry47Ya2gkdYRavFdg7lQntoLqP+Md/dlCwa+BsjGD2tXnjxJqpYFFIcHhY6uud1D9dgzTtKqr5UzAvLMfy7W82m+wk1B3KOwY0Jd145zpCo1Vgf7sYHtWTInFgu4OVwEqCVMgHq33+3iuVNHCGi5TnlgvONxsBE7MqpJGh0SnaJGPFb+WXTKSAGNyfktFuvppM3qJXBqJeZR+AZO5lewkwcuVIUR4I2hmUEJCnVDvPodLQi22S/8gigXt8FBjNiDQMf4wT7pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(5660300002)(9686003)(66946007)(316002)(55016002)(38350700002)(38100700002)(1076003)(478600001)(33656002)(66556008)(83380400001)(6666004)(66476007)(52116002)(4326008)(53546011)(2906002)(956004)(33716001)(8936002)(8676002)(7416002)(86362001)(6916009)(26005)(186003)(44832011)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/BFxaLor7vQDMYfx895xJm6ESVcJn4Rv7R3Eaco80XCCeYW8KscLaOEyHrb/?=
 =?us-ascii?Q?8eUZGerz6jTfUkKCqJ8hci1aoCn1Ni6jc05abGIxUq2jOlH1q/Fj5NwWs3yX?=
 =?us-ascii?Q?+h4iE5R9fDxjHO3hS1i1SLy6suckgT0McnMgRWkQtZ6RQ8nZeLqc5TkR9fJI?=
 =?us-ascii?Q?3OXE9GDA+FyC4goPzwpKeCMu4PlveU6/dKUksqiGPBmnbiKxxJuXq7w+s3Hd?=
 =?us-ascii?Q?eu+G69PAr2w/RPJmjNeFGpRO8HaVUs/3VuCLP/k2qbF4GkmMI72UFeL+HZOl?=
 =?us-ascii?Q?V9akYmvS5D6qWf2ls+7g4w3hynuDgaAVw0LOsBNoC128XV4iyDWcUrVAwbb5?=
 =?us-ascii?Q?HI6cdhUyup4/Xg11rcbHwHLk5r3kbyXXY66pxsK/RiEp1tZ8zWm4R5q+RZQQ?=
 =?us-ascii?Q?xwrpi/Ev9AblnjymXT35f0ojj3e1mhUPL9dTF82R8LfYcfOFkae1TYJDr0mg?=
 =?us-ascii?Q?an64m2OhXtcDwka3HTQUmKTbsuIRj4AhlMLepcigu7YMCwYbyToEuFDSgkzg?=
 =?us-ascii?Q?UddJyXFT8fTBKLNh7LO/cyy6h1u/77Ruz2/vHxFxDZoEmXiEkTv/cEVCZDP7?=
 =?us-ascii?Q?MwQeMFHFd4VJ0ruTvUvuwju34qCERnwhIx8vVDuu875MJqQ2g5pcJO930Kk6?=
 =?us-ascii?Q?+UYBWQNbSSdTeIeys3LMXPZzLWQOxJTxU+DpV1PtsmSri6mfnsvhLC06bVDY?=
 =?us-ascii?Q?qNhwGwkvIsV9XuduuRlzNXqw3Hqv2eBAm7GsKahElC9CWZg4/7SCzzluPD8c?=
 =?us-ascii?Q?Xk5+QJ6p+aOXRqkJPlp7431nfbnrz3dYIdXQvbbgCTgQBvjc3Jn7RZfWvsXK?=
 =?us-ascii?Q?qUMPraDe6msWbvCMY1yn2LI62NQ+pWEaqAKaXk6PLzy3I8bJCTNo9g/1n9JC?=
 =?us-ascii?Q?G5CRkJvQxU5zvt3oL17nxmBWj9GFJqH6qrZkUDUZXqC/+8YdUKsiTGpO2DjE?=
 =?us-ascii?Q?SPsqLaI1RLm8lk2vCMGsqw9r1Dj6vx4CMxyQarfv5AJyP8kvm4VBF2Xd7d9X?=
 =?us-ascii?Q?Pj5lP9srsMSOvGwO1Ma/cRkx+gI88cTqQp0n4J6BJt8NhGzzeg3RVeoT28nV?=
 =?us-ascii?Q?Qfu9bvGmMsDBxePkeNjsELV/N7+fSRIFtTzpG9SteUrX9A9tTcrLVZP2sLUN?=
 =?us-ascii?Q?ThkoD7TtzZ9+EPA7UmmT9LYTSbMZdcpaR87OtHiy55LdYLFGj+61xBS8Xdjq?=
 =?us-ascii?Q?wj8F5sex4T2EDN53G33TksSYnAMSTAOigYAk1tm7CXE+FBFAfjaG9/UDlykA?=
 =?us-ascii?Q?iwsq1jnn7kYBEQruPmbCpnGEBNQV2gXxeUKeh6mNWDc44NAYfWswfJyMHgRl?=
 =?us-ascii?Q?whdWzX/jnv9ABiiGAHFiXl76?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf465ba-f094-4d0d-52ac-08d9618881cf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 14:08:37.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZv8MoE5G4Vq56tEyMz09Qrum6Bvuw2LFOpfdMN268rvmjb9GpeR3jkO9Iltx1xXgBxxf1/+HROuNbTn12odsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dave, Steve,

On Tue, Aug 17, 2021 at 09:38:24AM +0100, Dr. David Alan Gilbert wrote:
> * Steve Rutherford (srutherford@google.com) wrote:
> > On Mon, Aug 16, 2021 at 6:37 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > This is an RFC series for Mirror VM support that are
> > > essentially secondary VMs sharing the encryption context
> > > (ASID) with a primary VM. The patch-set creates a new
> > > VM and shares the primary VM's encryption context
> > > with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> > > The mirror VM uses a separate pair of VM + vCPU file
> > > descriptors and also uses a simplified KVM run loop,
> > > for example, it does not support any interrupt vmexit's. etc.
> > > Currently the mirror VM shares the address space of the
> > > primary VM.
> > Sharing an address space is incompatible with post-copy migration via
> > UFFD on the target side. I'll be honest and say I'm not deeply
> > familiar with QEMU's implementation of post-copy, but I imagine there
> > must be a mapping of guest memory that doesn't fault: on the target
> > side (or on both sides), the migration helper will need to have it's
> > view of guest memory go through that mapping, or a similar mapping.
> 
> Ignoring SEV, our postcopy currently has a single mapping which is
> guarded by UFFD. There is no 'no-fault' mapping.  We use the uffd ioctl
> to 'place' a page into that space when we receive it.
> But yes, I guess that can't work with SEV; as you say; if the helper
> has to do the write, it'll have to do it into a shadow that it can write
> to, even though the rest of th e guest must UF on access.
> 

I assume that MH will be sharing the address space for source VM,
this will be in compatibility with host based live migration, the source
VM will be running in context of the qemu process (with all it's vcpu
threads and migration thread). 

Surely sharing the address space on target side will be incompatible
with post copy migration, as post copy migration will need to setup UFFD
mappings to start running the target VM while post copy migration is
active.

But will the UFFD mappings only be setup till the post-copy migration is
active, won't similar page mappings as source VM be setup on target VM
after the migration process is complete ?

Thanks,
Ashish

> > Separately, I'm a little weary of leaving the migration helper mapped
> > into the shared address space as writable. Since the migration threads
> > will be executing guest-owned code, the guest could use these threads
> > to do whatever it pleases (including getting free cycles)a
> 
> Agreed.
> 
> > . The
> > migration helper's code needs to be trusted by both the host and the
> > guest. 
> 
> 
> > Making it non-writable, sourced by the host, and attested by
> > the hardware would mitigate these concerns.
> 
> Some people worry about having the host supply the guest firmware,
> because they worry they'll be railroaded into using something they
> don't actually trust, and if there aim of using SEV etc is to avoid
> trusting the cloud owner, that breaks that.
> 
> So for them, I think they want the migration helper to be trusted by the
> guest and tolerated by the host.
> 
> > The host could also try to
> > monitor for malicious use of migration threads, but that would be
> > pretty finicky.  The host could competitively schedule the migration
> > helper vCPUs with the guest vCPUs, but I'd imagine that wouldn't be
> > the best for guest performance.
> 
> The CPU usage has to go somewhere.
> 
> Dave
> 
> > 
> > --Steve
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
