Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F432CA59B
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 15:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbgLAO3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 09:29:00 -0500
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:4320
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387607AbgLAO25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 09:28:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBpzQ6QU2QwO6mKwtVJelCjEWgxytusOb2Gaq6dAvsdFQLjpiFeXMOitXUwlMg69U7mKgjSM7FDJIbsJT22Z6Tq9WPWi/WQjOTVrgAo0zhG0tHwQJjdYajm6ESw3bplyFjcu+ME5P8VaLGc/WeBMvLpEmoHR9aiMXcGlTxHUuQmBa7O+nCPLEpxyFV8n1Cp6Tyj6DCfi8h0FMqJ5B/xczbU705rml+1XEQSn/cZGrfQZ1gGg1rOw9G8kTraD7Oc+s0YPyj5xrAMMENoSkxGCrKz9B/MO3pf0fixlqQcG5IlUGBNy4dhnb6gf8VHZ5EhR+cWggZHStOWlX5hl/ruWzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50xtY0p5Y+lD54elodTuXiTzZYV9EuskI9Y70u+vOFY=;
 b=lN0ecg2d1T6ZhtaOrfzfsh5Zj4oQTxZ2V7ojDEdgO/uQ6BQsRfQw4OIBJHXFyD8k7M/1V/47QKEi6OjPpqAwaoLJwjRSDbggOzb8r5NHnolRLUy3FO3u97C0n4oyQxX/QmVK86CTV6icyVTSx0GFH5Ubrajf/Kw5sq5KnngwhqVv2ZwmeywA6UIT1cMM+w0H7ogPKMTj4GV9FCH85dVis+7W0bgVCKKGAp25qdGpYmpsMyk4PreTiK7+hiOGNOLZsn+riQ4oJAogBtDUnKCHT6VNYmwbRPof1VUJlmTrlZr3hgtFxeclUNdSoQLxqVU8I0ziwGBjc++dQ1waALjtMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50xtY0p5Y+lD54elodTuXiTzZYV9EuskI9Y70u+vOFY=;
 b=pK4Yol5E8wQPKaaZ34UfyEF97g36TMKKCF8GFQpsDgF32U6CNwTfJkQLRxqbYeNW7ZHS1ZQryFeDhV0uUcuMxBb2xaGmcbE0sYo/OfernL32/8men5N7d0jck7pT1/wbpT2tNfM4+2oZSseHnDuuH+LuKwWQKAgN3Z3N77QMmqg=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 14:28:04 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 14:28:04 +0000
Date:   Tue, 1 Dec 2020 14:27:56 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 02/11] exec: Add new MemoryDebugOps.
Message-ID: <20201201142756.GA27617@ashkalra_ubuntu_server>
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
 <CAFEAcA8=3ngeErUEaR-=qGQymKv5JSd-ZXz+hg7L46J_nWDUnQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA8=3ngeErUEaR-=qGQymKv5JSd-ZXz+hg7L46J_nWDUnQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:4:60::38) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR08CA0049.namprd08.prod.outlook.com (2603:10b6:4:60::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 14:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e5b1abd-23f7-44fa-4e66-08d89605509e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4429513795D25D558E126CE58EF40@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQ3qnk5N5emK4BpTtkZotIV7IFE03yzNyDntFm5CkKxqz9BYL3tFEd6katLQz74hh9cjFA0VIBgDhIPJ8jOaIMK02BNlEe09WJJGi/oM1Ooivw8V3cGO01TfIVbozfXGRg7u5G3uiE4u+SzrERLEwGDxGmb0C2etdIUHNzxjRixZcmNB4L9DSrRdrEOJzF/YONz4C6KGs5YqEFnTaMjLaAMxyCpXCdn3DdEJbsRrguB+G7CWr9qRUQojzRHYuuCywaGBvgVBDx1ZhJ/rdEEJhhxEilcYbJzRNpRXn3XD6tDxrF2pY4gDwGqwdhuKxQgMXIIVKGQILq6foezzUNqRzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(478600001)(316002)(6666004)(2906002)(26005)(83380400001)(6496006)(8676002)(52116002)(8936002)(9686003)(55016002)(6916009)(86362001)(1076003)(54906003)(956004)(44832011)(33656002)(7416002)(16526019)(4326008)(186003)(5660300002)(33716001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5uV9U2RBf20ObFRb33Bq9NpV+YWO1HgLVwnSV/M02Wb+dGWUFye5qGh+NiqO?=
 =?us-ascii?Q?Z2iPN32B914bUc6AcNKWJyoqD7IPcisOeNRRUrOMo/QMVnrZrRqJU+xnAhRH?=
 =?us-ascii?Q?d3c2+I2SCBYnfeQmiq8J3f9Z7Ah315km7b1TnhOmVUbN1ZIh6QF40n0ABuD4?=
 =?us-ascii?Q?NTRG7XBy6+FvsLwe+Te2Kcgh4SNhVh+uZXK0aMxShORfrPU+vhj8Li6N5TtZ?=
 =?us-ascii?Q?SagGzt+LDDpIaim6gedT+me7Dph4GWnzxwGCOYtE0eX2/O7m1tevjQdKr+37?=
 =?us-ascii?Q?J7ZUzIe/fxSHx6UZeJxjA2DWS/x6H3J1EoGzUj19smbaRLpOG0ilIqtOd7qQ?=
 =?us-ascii?Q?VX6kPtlNLS7lGIqKawBwK+Nx+Ek2keOON4+FzvMa9sGIKikEdjCTcJRNppSI?=
 =?us-ascii?Q?ne1L5L0vbAkaxQEfRB0Kp8zf9Ch8YKPg4fXG504MrAIwiScZIm02WHHZHMHv?=
 =?us-ascii?Q?6tMoCbFozE52seI0J+st2WPzQzyEuXXZVgaJqGTD3sbUDzkMPPC8QFbWUziy?=
 =?us-ascii?Q?6Kvc/WXJpr67R6nYj/KEa2mtmXAHMAaA/w21JB+GJCJovkIfcSTWPNLuGjvV?=
 =?us-ascii?Q?2Cr3QN2/KsYdXThJ+nyb8goeT3egg45adTCnVW6ikToJ7xQr+g7FVPyM7uc4?=
 =?us-ascii?Q?C/RDdyZ1x42VExjawu2SgCSkrHt6fttvSFihg3yOOk+TMoRvkkNsTLVGz+jO?=
 =?us-ascii?Q?nsIfeW/NEW7hLmsZMT+jdZGzk/QCxBn54J2GrZkqRtFSx/roaEqEYP5RMUwX?=
 =?us-ascii?Q?4Wm88tQI7RN8Lf3HsvXEyIeP2DegwhjBtZgKXB517KdwQy5j0WbbLtrLPzuo?=
 =?us-ascii?Q?brX64kV0QOvXDSXI0EdVx/vsofF09tEjBcgw5/dDIHrGq7fZ2WdVMmaqpAhj?=
 =?us-ascii?Q?IPJtMvczA3Z0PiOKNg1u0soYb3q/ew/7I2zyBcvWvBJNyr3arzum/A4ptJqS?=
 =?us-ascii?Q?yG25x5kVF3Uemsvgnh0W500Vxx9TkKIGfVpYSH6JVMTaA78AS7ECZY+5SX9S?=
 =?us-ascii?Q?5ZAj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5b1abd-23f7-44fa-4e66-08d89605509e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 14:28:04.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOj8bBY5gNt8ypM2W8JP3zHQa7OHYaxyeC0FnXquc4u0h1iSr1BQK0gRyBuxyjxEW6NJmBcm9+/eMtQQ/ucXrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 01, 2020 at 11:48:23AM +0000, Peter Maydell wrote:
> On Mon, 16 Nov 2020 at 19:07, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Introduce new MemoryDebugOps which hook into guest virtual and physical
> > memory debug interfaces such as cpu_memory_rw_debug, to allow vendor specific
> > assist/hooks for debugging and delegating accessing the guest memory.
> > This is required for example in case of AMD SEV platform where the guest
> > memory is encrypted and a SEV specific debug assist/hook will be required
> > to access the guest memory.
> >
> > The MemoryDebugOps are used by cpu_memory_rw_debug() and default to
> > address_space_read and address_space_write_rom.
> 
> This seems like a weird place to insert these hooks. Not
> all debug related accesses are going to go via
> cpu_memory_rw_debug(). For instance when the gdb stub is in
> "PhyMemMode" and all addresses from the debugger are treated as
> physical rather than virtual, gdbstub.c will call
> cpu_physical_memory_write()/_read().
> 
> I would have expected the "oh, this is a debug access, do
> something special" to be at a lower level, so that any
> address_space_* access to the guest memory with the debug
> attribute gets the magic treatment, whether that was done
> as a direct "read this physaddr" or via cpu_memory_rw_debug()
> doing the virt-to-phys conversion first.
> 

Actually, the earlier patch-set used to do this at a lower level,
i.e., at the address_space level, but then Paolo's feedback on that
was that we don't want to add debug specific hooks into generic code
such as address_space_* interfaces, hence, these hooks are introduced at
a higher level so that we can do this "debug" abstraction at
cpu_memory_rw_debug() and adding new interfaces for physical memory
read/write debugging such as cpu_physical_memory_rw_debug().

This seems logical too as cpu_memory_rw_debug() is invoked via the
debugger, i.e., either gdbstub or qemu monitor, so this interface seems
to be the right place to add these hooks.

Thanks,
Ashish
