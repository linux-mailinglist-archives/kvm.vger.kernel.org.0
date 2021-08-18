Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DC73EF676
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhHRAFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:05:20 -0400
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:45967
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232706AbhHRAFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:05:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdYUkX0XwfSUwSVLQzh7QhNvnOBW/JKafloXm3FlX8ZlfoXjuSE2eWbYUODe5RsRA6zlt/zzEkobOWhnFrKOPBZpaKfHvXlqtjMhhziJwbTf3+DdMCSl7tnrxFu+pO3ihQSgIXI9afkheUTaxpBFVKcHOVBcUq2LgTHWvLj5I3SAuu3wMsQXcWyE1zGcn53SciH1Ax7415HGHbdd/d7/kwx2H0vjsD5bTh+R/QfDds+VKJ31eO3EZPUTM3eW0Rscc/4AxiffT90yHtq63y6LlKhu5ZbxBGl7QNoZ1Z24Xs9EIWgRea5tw08f3+yq7bN/4wttPv6A3oVevihlonErug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWgKAQ3w1ASdN1xyHo0d2Wds/eK4KKocqjz9IF0YIyU=;
 b=M/Eowp4JgxgtgJ810qTU5j5q0VVSBM5XCbGSuEJyGYsH+9LMjUyPvWrRWDktQraBqgL6pnderD2z7yDqvOLdtGIKTWGzYuhx5H0gMrmscw7tRUZOcNkCvUaHrcS0Nz5l0aZjE6MnQl++CdI4dBjEUShQrcUFsWVr1dsnCvztq6o3Pg01tKNMihI8uxn2iWwvMTOWdv0MBvHewvCtuTpTeOT84qsHdKR2Dh3fVxNLYoBYlL06gbBRxtdotus2iuxxNxWRiYGHhqPNLLnhWMVOttdvSU/DUvPcemuWb+1kTzuqd3XlWOD/KfcfHkihODXDY9J0F/5jx/0IsRS1en/O3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWgKAQ3w1ASdN1xyHo0d2Wds/eK4KKocqjz9IF0YIyU=;
 b=tyH4LRoZlvX9MH3HqIAA1DQmkGpCDYdxLZvnvMjaWIXgOvbxQUS1OZWYkNQn82AL4jtDyLNqvE87IvCj2Fcd3Z4csLt7l8/RC55r3SZtt+uqLYhNCZ46IXPi4sI3/59uV8jlSHpM8zgkTZKNwwSpn2JV3E5kbxH+eMi0gtmogH0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 00:04:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 00:04:44 +0000
Date:   Wed, 18 Aug 2021 00:04:36 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v5 6/6] x86/kvm: Add kexec support for SEV Live Migration.
Message-ID: <20210818000436.GA31519@ashkalra_ubuntu_server>
References: <cover.1624978790.git.ashish.kalra@amd.com>
 <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
 <CABayD+fWA2bVe_MhR4SnOo7VH7Qs5kR5n9Jb6s7byqaP+UhXQA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fWA2bVe_MhR4SnOo7VH7Qs5kR5n9Jb6s7byqaP+UhXQA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SA0PR11CA0031.namprd11.prod.outlook.com
 (2603:10b6:806:d0::6) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0031.namprd11.prod.outlook.com (2603:10b6:806:d0::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 00:04:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 999d64dc-25d9-424f-5548-08d961dbc824
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495417AD66BDA227AD2629B8EFF9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9M+DNVWm/0Sp5zksjqdnHaBpxa+q53/vlCxWvHqdJL8xnZ6zJQ9+OrrMYj6D2fYgPfjIiUyaZ974J/PHzhQptOtnxwfv176TA2HzzEpGl9v9fUTnqf+Yc0pTHPbYWCFZ+tKYLbSObanVd++JTprgfZ66fgjwc5lNpmHxo4hncOOEB1ev4EysVIpVTLTjtPU9TlAz7o9gW0pimRvN+j7k4A2T9UBXES+1lvT+rz4N0PQTIE4f6z0O1JyIY4JPtmQs6x1hDO+iAFB7P6pJ+jv1rx2ijRZHQ4IJrPvDRGOd9f3ZMKWYzUkrPfSoSwNVOIFxPVGuomK0TreC6X9U2AUMEahdCmgdsvmpIFzQYXc9vaBbxwz6Op078zl8MOQWWFC4yxHdnTjWh1r4gJM5AY3x7HpeIZX9ou8LWJnEElnA//ugjwQ39LXRUceKobDkCA21LyAN38x8T8mNaNkeFSz07wq0IsJmCbs7lq1KVqJlGQInO5uL0TLb96XvzgyND95/oGUQLfXDUK2ZaEJNZdBoDlV8nrz+P5qr3OdLGWcpE0IMO9Nv3amgoheWvvgWn+VO8kAsL8LNHKOkmt5v+ee/1Cruq5SKH9B3+hGIfMxcPqYy1bFJidr5XD4i0iHGIzZbwEe1HCM5xGUHur/MM4cAdIq0vDkoCucgAFOTwZq689HqsKs8f0ryBDexvlwmwV1q646RXF62tevHEa6Fd9WJLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(1076003)(2906002)(5660300002)(38100700002)(956004)(4326008)(9686003)(478600001)(55016002)(316002)(38350700002)(44832011)(6666004)(86362001)(52116002)(33716001)(33656002)(7416002)(6496006)(66476007)(66556008)(6916009)(66946007)(26005)(8676002)(186003)(8936002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcL6iJDAIimKs13wmQT+JEtuaheKKsxWxtxIt27MTFxOSUnS09kgOwRrp5aq?=
 =?us-ascii?Q?hMtAaO4DC+fYTRZl0IgC4pfMt5NMfBwGBu9cHLi+TYLSWbIbak56Me2tGGSv?=
 =?us-ascii?Q?kLktq46jL9n5Ab27DuOwjx1Tci8wU/onKM2J2X6VEJ0EVrEYkoeVa40EXSfq?=
 =?us-ascii?Q?Qzt0O3hOxKMs8tRW4RB4AOH1L51ze/9pMNsdJYAiu/3yr7X69/HYxhQB5plf?=
 =?us-ascii?Q?zChWVsQEZrpXo+G7IQKwKC7pe8T9svCwif2X2PXdaOHMD/MMLhk/gFoaJoEZ?=
 =?us-ascii?Q?+qfjRbRni7grLRFkwA8h8uqvoc4t/VXLtni0jZQAIYeYsHmOayZhr7Hy/20I?=
 =?us-ascii?Q?mvxJhLe57dQvdhelHVkNzbGEY+tvyIfF+Pk+J85Nu19mHb+SXKBKLZk6zEHK?=
 =?us-ascii?Q?uyl0ktiwzZlcQXUxXgKKzm96vDOhh5XcpF3XJN8i6IrJe27X3x+04ky9Pudn?=
 =?us-ascii?Q?YhuHUUPLdRcr1QnGe3w7mdzjQQJNxVFyDm0exi4s34aQqTufz2nDYOOMs7hW?=
 =?us-ascii?Q?au5UXTwk7hyHQLfQLZq+b18WBzQeryrwgV6gI7SfY7bGBCXY3oGvovYJ0WRf?=
 =?us-ascii?Q?8a4jEE8dDiP3fkEvndhBRpOFNotqqH18oMdPqtmOYIdRoP3Gg1Kv/bmSd/IZ?=
 =?us-ascii?Q?m+qaSdBWtKnkYGMUToNnLn9PwxiXKDf7sENfSVri3cGjuO69g8W7fgTNhAUy?=
 =?us-ascii?Q?MDbIiXug4rfhK9gC6bs65nSu4cdNHCpArutWztsMS3fiDTBE1WHjqzno86wJ?=
 =?us-ascii?Q?82ig5QbJbTpQGwT31pabMJ+ShoR5zOS5xvWoQC5Rl23mEIsER/RIu1I7/sGa?=
 =?us-ascii?Q?2AVCWE02hLCsaaTmTaMbQE/td746m4ofJCzWm9pNXaSoxMQxzIDv+Gd2mu+N?=
 =?us-ascii?Q?VrrkqOVVL1TQsLMt2hob9B5GhZUY4abCE4VRf5Ci+TiRzg3C8SRKdm4Svexi?=
 =?us-ascii?Q?KvWMgZCGxKNU3EAgJbgXQv14/+FvACA987sfNKxWWMtAFqxOgzed/5oBmE94?=
 =?us-ascii?Q?rpCi8/kPrQZ8KQ+6l1BO1kqgX/0ilFP7vWBWHdWgTrr0BX7BFvQqfBlKDisC?=
 =?us-ascii?Q?dewPM7lSUHBwYe8h0yOx2WpwWNT0PhN/6pTWUswrCBy3KDj65C4MMES7fQOb?=
 =?us-ascii?Q?QIAZDggHF18eQ3Bd8UvWLgMNps5lxiuyGTw7Gc/RAvB98OAyv9kLcnrfN10P?=
 =?us-ascii?Q?74xREYAAk1/Hg+C8WCdeTBLKOIY7rXA+y2hDmfyDWYK1DqERGENQCq3xjOvs?=
 =?us-ascii?Q?47uDRp5MzhE7qbkbuVxu8Qlzb+FfMoEUhwIK9IBdD1LKzefsaBUXPjz4+7vz?=
 =?us-ascii?Q?Hzj57GgtugUv2AuidDJ/u7wV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999d64dc-25d9-424f-5548-08d961dbc824
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 00:04:43.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzK/UlhgZ9QBy4Ssl75x00xvvoIB2JqAEX/WBa5hGLgzF63lpBbu6dKUDjf0IkfdKQFiLUHyPTEChMom8q9nBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Tue, Aug 17, 2021 at 03:50:22PM -0700, Steve Rutherford wrote:
> On Tue, Jun 29, 2021 at 8:14 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Reset the host's shared pages list related to kernel
> > specific page encryption status settings before we load a
> > new kernel by kexec. We cannot reset the complete
> > shared pages list here as we need to retain the
> > UEFI/OVMF firmware specific settings.
> >
> > The host's shared pages list is maintained for the
> > guest to keep track of all unencrypted guest memory regions,
> > therefore we need to explicitly mark all shared pages as
> > encrypted again before rebooting into the new guest kernel.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/kernel/kvm.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index a014c9bb5066..a55712ee58a1 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -869,10 +869,35 @@ static void __init kvm_init_platform(void)
> >         if (sev_active() &&
> >             kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
> >                 unsigned long nr_pages;
> > +               int i;
> >
> >                 pv_ops.mmu.notify_page_enc_status_changed =
> >                         kvm_sev_hc_page_enc_status;
> >
> > +               /*
> > +                * Reset the host's shared pages list related to kernel
> > +                * specific page encryption status settings before we load a
> > +                * new kernel by kexec. Reset the page encryption status
> > +                * during early boot intead of just before kexec to avoid SMP
> > +                * races during kvm_pv_guest_cpu_reboot().
> > +                * NOTE: We cannot reset the complete shared pages list
> > +                * here as we need to retain the UEFI/OVMF firmware
> > +                * specific settings.
> > +                */
> > +
> > +               for (i = 0; i < e820_table->nr_entries; i++) {
> > +                       struct e820_entry *entry = &e820_table->entries[i];
> > +
> > +                       if (entry->type != E820_TYPE_RAM)
> > +                               continue;
> > +
> > +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> > +
> > +                       kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, entry->addr,
> > +                                      nr_pages,
> > +                                      KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
> > +               }
> > +
> >                 /*
> >                  * Ensure that _bss_decrypted section is marked as decrypted in the
> >                  * shared pages list.
> > --
> > 2.17.1
> >
> I believe this entire series has been reviewed. Is there any appetite
> to queue these for 915?
> They may need to be resent, since I'm not sure there is a single patch
> series that contains all the patches.
> 

I believe that there are couple or more patches still pending an ACK.

Patch#1 of this series which basically inverts the KVM hypercall from
VMCALL to VMMCALL probably needs an ack from either Sean or 
Paolo.

While Patch #4 was ack'ed by Boris, it still has a dependency on Patch
#1. 

Patch #5 & #6 need to be ack'ed by Boris, again have dependency on Patch
#1.

I am more than happy to send this guest kernel and guest API patch-set
for live migration again.

Please note that this guest kernel and guest API patch-set which is
essentially guest hypercall invocations are needed for both in-guest
migration and PSP based migration as they are used for tracking guest
page(s) encryption status.

Thanks,
Ashish
