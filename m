Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC741669BC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 22:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgBTVVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 16:21:31 -0500
Received: from mail-eopbgr690076.outbound.protection.outlook.com ([40.107.69.76]:9023
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbgBTVVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 16:21:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWn5t/LEFaHC9MXFenNA2WVByS+8599JVJbeJEh1izoo3HoNVgLaOrzUTIpiwUdz+rU+SSHDYWgKHvkHwAOPXWOnxGZCr72S7vW15m5ImQKuY88CyQklhEo3282O16FUmzuMSU8pifddfuioFnWGb5W7SDA8PH/IIqUsxEdQ3sIVF3MT4XTkv779aaXtHpgZgS1gf3/B/fj7GtgCZmTuI1g05hk0XPGIpmZhik5JGVCt1ggNFJhyErw6uAfijVOaBGtqH+m7HFKNfbJ18Y9mI9VRJdboNfRVjdYAPhh4Mh4Ss+SxWV9d9Zw3mLOr/OzfAHWI281kq2AnCIMO8mEgPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9Y6Z9PpTW76vZFXC69zNaJwQGlfpLThBMkEyYUY6IU=;
 b=GiQFNmwy/qpLM/xoGfJUBl/e3kmWLwg3L61oife4geNQv18Ja8H8zFzXbp3Kc5aXUKfDs6mJrRAE5duju6DSMs8Jd8EF7bG+cTNf/UuqbQTALJerC+wDJCFO+2ehUc4nR8jZZpEVxAzn1CItUh29wacYwBG3ZXHVl/KZaEV8/gdQ1LMNQ1Nt9BQg6dd232YAWs/g1hthVuDAoKAmwf0RWa5SkcsJzxf29T6kTaJjJu0AgIVm+lGhKDoHBKm9aKnUap536L6YenuTFucK5fMXkTkFL/dOkionN4m83yx6GOoTCNNxll09hgp7TPmGYXkiKqToXyDEGJ2+rLXplrB/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9Y6Z9PpTW76vZFXC69zNaJwQGlfpLThBMkEyYUY6IU=;
 b=cz0TScv1ynGV6dBO9vGsaEt60t4AlEd8yb6JuYx3zmccly5Lm+I4+TmnMjXJLHGAYXTbkGq9hR/Eix+T71S6GFwojxCzDhujc4s8O9r1XOVZKlIlLKRDbTvkASeMm/UImIyY5zSiW00G+PtXWDLaDew2+TllMoKjnpcV/N/uDig=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
 by SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25; Thu, 20 Feb
 2020 21:21:27 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 21:21:27 +0000
Date:   Thu, 20 Feb 2020 21:21:20 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20200220212120.GA25966@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <fc5e111e0a4eda0e6ea1ee3923327384906aff36.1581555616.git.ashish.kalra@amd.com>
 <CABayD+fM-s0+j6JXN5qb0zce2Kqi6AC8+c+7qbqKr0NgC-QYiQ@mail.gmail.com>
 <20200220052821.GA21598@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220052821.GA21598@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR12CA0004.namprd12.prod.outlook.com (2603:10b6:4:1::14)
 To SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR12CA0004.namprd12.prod.outlook.com (2603:10b6:4:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Thu, 20 Feb 2020 21:21:25 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0d70d6d-a6f1-42d4-04d6-08d7b64ad878
X-MS-TrafficTypeDiagnostic: SN1PR12MB2448:|SN1PR12MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2448A91BC847A7835BABD9028E130@SN1PR12MB2448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 031996B7EF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(199004)(189003)(81166006)(6916009)(8676002)(81156014)(8936002)(5660300002)(6666004)(66476007)(7416002)(52116002)(6496006)(66556008)(66946007)(54906003)(316002)(4326008)(55016002)(53546011)(33656002)(33716001)(86362001)(1076003)(956004)(9686003)(2906002)(44832011)(26005)(16526019)(478600001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2448;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QgLS81PskkZAWMYGFAql9jjruPdExVB+55fXxa/M3sHMgZN1a2/w8I+iAOEwRf1tpz0PM/P+qxaIugWJQmHARDz5AugnahWGl8wiC8XFJtZmJaDxG1vF3QjFDLR9d+Lz/LjvmkLY428Xl5sxHp34yxQ3B5TmUwhzLa1wb9VXMIdn15tke7NRf9mZ78MaHdZ8S51x/bNEYY+Yt76TB/JnXqLy03iLo9+qX1WVv8IpUlSDXLRBZfRJWhfRBKn64A/CyJIBD3KSOnWELA9SVVhtvTGYVX1L7hnKI8VvSmSL+cnunJYQG488ZgllReF+JOGpkr8KTFIXCuZ5rRyULZRxwROMv0A6FAFeRwF+Fg49pRsfg+dM1rP+cwY12LusB1uDEMCzgnIzphU6wUAhDhaGNCFykYDmZb+fLZ2Enam8iDkAx+JjAPYvetFEhUznWMyN
X-MS-Exchange-AntiSpam-MessageData: B0rTkkMV3o8g1ru+Wf8KMI1et5J8UNITvIl/ZlTOZ18uS0tQqyi4HP3oRte50nyZVhLPyO5TS0P9Hib+LJV0mBJPzwbS1SulDbr4ij0pyBuHXmPcsymRz8pqKslgirM4hboVAhRxSZWYES0kKpvwuA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d70d6d-a6f1-42d4-04d6-08d7b64ad878
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2020 21:21:27.4452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzwYKQC0RGnKj/jL30YJxPmnIXhm21UcTxX4+akxXs9/SxuiraPpD7ithJKAcghOL6HPl8HE+jmoqKsdoX3OdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2448
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 05:28:21AM +0000, Ashish Kalra wrote:
> On Wed, Feb 19, 2020 at 06:39:39PM -0800, Steve Rutherford wrote:
> > On Wed, Feb 12, 2020 at 5:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > >  static void vmx_cleanup_l1d_flush(void)
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index fbabb2f06273..298627fa3d39 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -7547,6 +7547,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >                 kvm_sched_yield(vcpu->kvm, a0);
> > >                 ret = 0;
> > >                 break;
> > > +       case KVM_HC_PAGE_ENC_STATUS:
> > > +               ret = -KVM_ENOSYS;
> > > +               if (kvm_x86_ops->page_enc_status_hc)
> > > +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> > > +                                       a0, a1, a2);
> > > +               break;
> > >         default:
> > >                 ret = -KVM_ENOSYS;
> > >                 break;
> > Add a cap to kvm_vm_ioctl_enable_cap so that the vmm can configure
> > whether or not this hypercall is offered. Moving to an enable cap
> > would also allow the vmm to pass down the expected size of the c-bit
> > tracking buffer, so that you don't need to handle dynamic resizing in
> > response to guest hypercall, otherwise KVM will sporadically start
> > copying around large buffers when working with large VMs.
> > 
> 
> Yes, that is something we have been looking at adding.
> 
> But, how will VMM know the expected size of the c-bit tracking buffer ?
> 
> The guest kernel and firmware make the hypercall to mark page encryption
> status and depending on the GPA range being marked, the kernel's page
> encryption bitmap needs to be dynamically resized as response to the guest
> hypercall.
> 

Discussed this with Brijesh, though KVM can provide a hint about
the expected (max.) size of the c-bit tracking buffer, but there is
still an issue for hotplugged guest memory, hence dynamically sized 
encryption bitmap is probably the right approach.

Thanks,
Ashish
