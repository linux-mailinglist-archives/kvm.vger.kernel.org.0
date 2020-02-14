Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AFD15F7CE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 21:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgBNUgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 15:36:49 -0500
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:5031
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387432AbgBNUgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 15:36:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Apmq1Rs/XUd+yqYiyepB7jkC5zo9vM31hEmKiXknwkm+txSLxxYnqxmpTUGpKL59mEv4M5IQGgxiuIRYwhcGty2lzrabJlXksGx+CR5M+wyfZ5DTUuE3lfi/f6h3qFPCQMn/Xs6f/OD3LpdRkgq9aJy8xVXy6nTpB3kMH7De8goib/2af08/7zqe5o4Tho196FKinHQOub8YtZXWoNtsYnmSLM1RjJZmpAHBAkaGuVk1ax/6WjcVJ0mKDYQOQfzAskhU38Kfbqka9JI+2lng1OxBlLDfv9mcvSkCCEuD6SjIAiroB5a/P4vEMU0ePHnJALCeILok0bgYMAwJdVV/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWb40P9qWSQO/ds6C1riFEfWfr7Vp3bBXaJfrEEDiNQ=;
 b=Sr/ze3glrsROcTDs+vB0Q7TvIzzbb2So4E2gNukIRnz/g+tIAfaL0OylbqwipTbXG71QY5DPGGuGg+D16L1v8R43X6EGOYtaJadrQo8T9D1CsN86fWXJ6Ti83Zhj6rK5p3SeQTAlgYeokmTDpQ8y0TzJwJAS+/ek8/YfC7kPOnaIDMhHyvwsPSYq52itt/hwbQcpqjRAVdJbwvIdVb3IfqP3NgPOs5Xzs4U6fIZzv3ZXT2Tq5IDqY3Adg0rvIFwoCIZS+kWQ82Fd4/UWmet4CBC3dluY+8GV8FwBZxqBMkuqM9AgnsURrXVAoSa50eBK403EEMlwvCbqFar+DhVUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWb40P9qWSQO/ds6C1riFEfWfr7Vp3bBXaJfrEEDiNQ=;
 b=aucl3JqIjhWZvTgjLddOEHBMSrp+y9HpygEZkwCC5WZHEfCVCo/yLEl/sGE2BXIPk6YYyHiXOF+m9hjHc+BwkcXWkBLgf9xXRkG3h55a3hiiaqY8j3QnhmiFR4NdMoKRdZMhdV5f/T9j+bFoxX53tAdweuD+/7JxBk1Wf5DrTPM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2557.namprd12.prod.outlook.com (52.132.193.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 14 Feb 2020 20:36:46 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 20:36:46 +0000
Date:   Fri, 14 Feb 2020 20:36:41 +0000
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
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20200214203641.GA11368@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
 <CALCETrX6Oo00NXn2QfR=eOKD9wvWiov_=WBRwb7V266=hJ2Duw@mail.gmail.com>
 <20200213222825.GA8784@ashkalra_ubuntu_server>
 <CALCETrX=ycjSuf_N_ff-VQtqq2_RoawuAqdkM+bCPn_2_swkjg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX=ycjSuf_N_ff-VQtqq2_RoawuAqdkM+bCPn_2_swkjg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0801CA0013.namprd08.prod.outlook.com
 (2603:10b6:803:29::23) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0801CA0013.namprd08.prod.outlook.com (2603:10b6:803:29::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Fri, 14 Feb 2020 20:36:46 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa991d5c-7a3f-46cc-d79e-08d7b18d9c3e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2557:|SN1PR12MB2557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2557A2EB2DAA1906159BFE418E150@SN1PR12MB2557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(199004)(189003)(4326008)(8936002)(9686003)(55016002)(7416002)(53546011)(5660300002)(66946007)(52116002)(6916009)(33716001)(66476007)(6496006)(2906002)(66556008)(86362001)(54906003)(44832011)(26005)(8676002)(316002)(186003)(956004)(16526019)(1076003)(33656002)(478600001)(81156014)(81166006)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2557;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFBKv2LHCtKyqYQj7HVek/QW+D4StvOjscCWN560N9TQWlaOcg+/qAePANW4ds/GnztpB3dv2QZoFLBR4ECLo0SLphy3sTHspPLXob7dl6R+dAScCTrSRiqgm7o7S0HSFXlEZKmvemoduLqoI45yevsckuZqoA1P2XXXuj10ytycXmOZvdo+juUStCnb7/xGOh6n6g8g8igphPW7pUYoC7KjCpfLvfzIzTLv73xOSnvmsFCZ0Hf1LdCgMCITR1UeJKAHi0+T4fKSgY8iFl2kUYR5uxsBvlLJyw6Pbhgx0ImrkxpF5W+9lb/6LoeEZ/lTec0jsYs+1SuvJNg99HPTxmsmGmKTBQ7qVOPpE79LsJGLa+NO4xdvjfLbkw/PXm+eSEwM6dbIyrMQ6+VEPJ/5c15bK6MZPvL8zjb99NZ2CcqnbTJOrSudsolFhPTKUyrA
X-MS-Exchange-AntiSpam-MessageData: fEGZQvLHnpaN6TeG9x4HEcYVlBtm0Qx1hrr3VH3/LWsbYt01jJGaIMM1cNGZWMm838v5eFdL5jAC70uwpY3WPgig0Y1ikK/uXptyVsFO3bDuejbTK1t4hmSyH0uXb1wPh4+v1yAoBOin7Fw5QGO0+Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa991d5c-7a3f-46cc-d79e-08d7b18d9c3e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 20:36:46.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVpAsrc0DuRcbVVKF8N9V/TkQWr+3cpB/Oy42ZxVh5dFyw67lAwvli+VS85XGFhyCONxUzzMhDWaO+e+Bgndew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2557
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 10:56:53AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 13, 2020 at 2:28 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Wed, Feb 12, 2020 at 09:42:02PM -0800, Andy Lutomirski wrote:
> > >> On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >> >
> > >> > From: Brijesh Singh <brijesh.singh@amd.com>
> > > >
> > > > Invoke a hypercall when a memory region is changed from encrypted ->
> > > > decrypted and vice versa. Hypervisor need to know the page encryption
> > > > status during the guest migration.
> > >>
> > >> What happens if the guest memory status doesn't match what the
> > >> hypervisor thinks it is?  What happens if the guest gets migrated
> > >> between the hypercall and the associated flushes?
> >
> > This is basically same as the dirty page tracking and logging being done
> > during Live Migration. As with dirty page tracking and logging we
> > maintain a page encryption bitmap in the kernel which keeps tracks of
> > guest's page encrypted/decrypted state changes and this bitmap is
> > sync'ed regularly from kernel to qemu and also during the live migration
> > process, therefore any dirty pages whose encryption status will change
> > during migration, should also have their page status updated when the
> > page encryption bitmap is sync'ed.
> >
> > Also i think that when the amount of dirty pages reach a low threshold,
> > QEMU stops the source VM and then transfers all the remaining dirty
> > pages, so at that point, there will also be a final sync of the page
> > encryption bitmap, there won't be any hypercalls after this as the
> > source VM has been stopped and the remaining VM state gets transferred.
> 
> And have you ensured that, in the inevitable race when a guest gets
> migrated part way through an encryption state change, that no data
> corruption occurs?

We ensure that we send the page encryption state bitmap to the
destination VM at migration completion and when the remaining amount of 
RAM/dirty pages are flushed. Also as the source VM is stopped before
this flush of remaining blocks occur, so any encryption state change
hypercalls would have been completed before that.

Thanks,
Ashish
