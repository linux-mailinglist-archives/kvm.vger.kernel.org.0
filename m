Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B576331907
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCHVFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:05:50 -0500
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:57550
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229757AbhCHVFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:05:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDQYQigVyt7u8/29qbgxRr608R7PCOBU++xxQdIohunxwOHn3cLp3FkFJz3QKHeikoel5lEyMF2sOSRjnjln+mJ/crjowOKag/QZ82wH7UcWc6dzezadgQLXN4MwhA2rUggnTeepP7pII+snQKvZ1b4tQAfXIyfiQzzKdtXTa6LS9UqeH0IaMriBvC3JDesw0QF7e49kj6/JekVxPdhsd3gCS1SmByIR42ksAebUJtOYX1A9NTUhFynys2aOgiDhTi6XZkT+TMqHCDNsPTHajaStVV++3SqFinK3hHCy5zpGq/BqwTENs1w4BGnoG7+gDSFE7Zsn2DeI2X1iGw7Qdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRh7uGP3StYP+zunzHViVeaucvV/rv64T9+MxoiLkQ=;
 b=FGwlSG9bh8ftgXjbObSHGarhfMoog9ALyPH+GBIsPfneNZSQ34C/gNTRY3cms1keQybvSRDqt/gtrV7P7O/AekivYQkZa81wBwTNojX6U76pfF5obFP2huYNKkuQexD6wY+Xihjyvnzym0C0rh3NM8SExtG24M9nila1qBI3dlQuEUMAA8e4stXyOy0LBS8l4doJ8wJispE9AL2kKLtuMBdVHQhOjKGNB+0fAxNEXlLA7eD05XTdH/Qv+F90E7pzlABwKKIJOgW/KZnObyqUaPQ59FBGWx9K30NXwbbkXzMycwt+ikLtp3xSHMPgJRXvld+UqBacuTAI7535io8lkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRh7uGP3StYP+zunzHViVeaucvV/rv64T9+MxoiLkQ=;
 b=TarNi6VpQpRxhs0DrMYyG5uOEjNa/SVJQ94ArQYmjy7WvPyhJjYlbl7OAiwFRkfsFzE8Yuna78pCGNEieeUtOxk+Wui6Dt+2LvLLpKrXzaS+K7tndZLu4ySEEnBYVx4cfdxPDOS1JMIKh9hQOWq0rbxueGhwcz9F9mGpoGBXjWE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2510.namprd12.prod.outlook.com (2603:10b6:802:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Mon, 8 Mar
 2021 21:05:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 21:05:41 +0000
Date:   Mon, 8 Mar 2021 21:05:33 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210308210533.GA5553@ashkalra_ubuntu_server>
References: <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server>
 <YEaAXXGZH0uSMA3v@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEaAXXGZH0uSMA3v@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0014.namprd06.prod.outlook.com
 (2603:10b6:803:2f::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0601CA0014.namprd06.prod.outlook.com (2603:10b6:803:2f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 21:05:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21a2c598-b766-49af-72e8-08d8e275ee5b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25108D4925CB0782A737AA588E939@SN1PR12MB2510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AmXu8TnANqQJZtmISNf8QQRe9Bah4vf0bx4naGhPZb16SkONNtCO40q7hfrwXY5CFANZ0oM5lgSrRIxg6XMhDL7Pt8TdDV9oZXneEpEymwfL246QRRehV75Mo63XKd41vxO5vXXdzOvmj+G2AMKJ9TCkDB9VBfI9CauyzIdxv6SCaneh/72AmWM2oiwarRCCxBKKerfWrfi8aaP2W/Ibf4CMP3bAmkf9Ub/PH2J5W0M9I9enpSVhNsOIBOHiFBZbvfDxVaXIytR9qV432Or58ZbPlxreibUjN2eLZ7n7+LfjNzSPprjPg44YeAh27ijHReUBWUwnR8NFQbuF3cCY2NtgxpXPpHu35XLI9B6DEoverTkcY4wGNWSc4cLTzRlsumXHKDIT+4LuPMkyRsSWT41yaSqRCq2uRBoJlgoF/5gzO98thPucmktF3+7P66XYqpQ8hOgS3SgpCWlTrlC5A/XN/HGYp+2Gcvpyykj837wjq3R2PMvgw1mzk8J3+VyRKWK3kOlstkqiSlzn+vV1kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(8676002)(8936002)(66946007)(66476007)(6666004)(54906003)(66556008)(1076003)(86362001)(316002)(4326008)(33656002)(5660300002)(956004)(9686003)(26005)(83380400001)(478600001)(2906002)(53546011)(52116002)(55016002)(6496006)(186003)(16526019)(33716001)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tdEiYByiPTf8UwuqXxdu8k5x5mKpxYyxiaSHaVZo0orPU/ptXfUGAqWoF7pk?=
 =?us-ascii?Q?gVf8hq+++mZwfMfE3kmPHlyJw6XSTQwf5i04S2x92NGEjGJ9DpneR1nLORqW?=
 =?us-ascii?Q?ytd+M3iR5FDfRrsxZV+urWK8dM3Lt7KKKpNpwWlMRw4sRPDip3a+HvFETS6D?=
 =?us-ascii?Q?3EN754h1NyoAuDqdi439KaD2BQ5lXxkF0/FKALFxUbyo1iOqjqeJtzmgoCmY?=
 =?us-ascii?Q?RaY6920+cBhvILBB+68vqkJsUCNdyG2N3YwitMAkW4vd+vI7SL5sehs675KQ?=
 =?us-ascii?Q?/0FIhOPnHE/ejtoFo/3HS1rE7++I3YgdBVYI/DhQdFcgLCCYTKZOL248pL60?=
 =?us-ascii?Q?riLsz0HYxXNcnvjQve3JcrxBeCvhJzrRHRYvLeWMtrK+5HwyOKXcedwUVP5l?=
 =?us-ascii?Q?TMVann0MmQ5OSpe9UFY1vuXKfnOurmDh4/U5P5SnmONfrag9cyiahuGpzAI3?=
 =?us-ascii?Q?JVeYkxRR1o1tKktgAcp0K2lKCrj3kIWNxPoWH1dQKNF+cwNbyx4r5zmBael+?=
 =?us-ascii?Q?zrMImuOSfRfJMJAGr9G+kT9dR7D7jVYf/mnOAkAIQ1f+EQEK5pCDpx5fdcaQ?=
 =?us-ascii?Q?mY/UwjJiyH649E3Aau+fO9GUk6CvgN/fE7zqvxX1WmUsL2FuKdJ23jH7vTZo?=
 =?us-ascii?Q?gwhxyaRii1fF9uI07yEdeHIW+QlUiMZogXdZ8E3K4M/2SKKreZYzaVU2KLhO?=
 =?us-ascii?Q?aCWU1cmejWybcFTOOLTmH4RRwfOeNNlkdcwMS5R4gvFGf1RdsWh52rIa+8kX?=
 =?us-ascii?Q?/nqepnVHulj3A7D323u0iakEREJJpTf+B2vaaNGv69vM1FN5D2aAajWJ9P4y?=
 =?us-ascii?Q?QwKN0o7SZqB7M+nc4PZ80CpYdB+sDENPAWOzQe+MqxcY6hlks+ldL8vZSNRz?=
 =?us-ascii?Q?ZnBiYTT/o9jjksV1OnI38xgwVhJsRARkdEJSwINi9MloHAZLluWI502In12H?=
 =?us-ascii?Q?x4HUsJnu2uSuS5HIHA1m5tilj3K+3QTSPlYTLWjOIH0GENcPRIXIl6nFZVux?=
 =?us-ascii?Q?aY4FuthwZnFwJd/YfHPLsrWhuuXEtCNmOwkc+gHmvzkMFflbehzjqytTwfZS?=
 =?us-ascii?Q?kSSmu5uOLd01D70kQfd+3FmlPRpD9qHz8Pa2C/tllBCwHs2ND108eONDIBj2?=
 =?us-ascii?Q?HJtTju6rc8ImEuX9qSTcz7njPUUl1C/qdUmyADqmiCDAUJjLtppevgqU08zV?=
 =?us-ascii?Q?07Bd2DvR0IJqSnaP7mJOUKFtmrngqq70NshLH6dMTtruQkccxFGhGP5s1ykd?=
 =?us-ascii?Q?GuJDEQID8YIkO/UHGL8crIl0zR4k0Yg0vz6XSYCt4Dt3/fSGeryyc0AC9sU0?=
 =?us-ascii?Q?sqG2nJAMFMEV6zyLuIaxd4yn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a2c598-b766-49af-72e8-08d8e275ee5b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 21:05:41.4095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/i7w1RDti6+ISX6Rz6NxHQPgcEl1wO4u4aLPm/REPQ4RezBNOjUQlqIw4SkJN7NyM7Xj8qyLAZ2haUTv5sbkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 11:51:57AM -0800, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Ashish Kalra wrote:
> > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > +Will and Quentin (arm64)
> > > 
> > > Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> > > point.
> > > 
> > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > Thanks for grabbing the data!
> > > > > 
> > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > hypercall exiting, so I think that would be the current consensus.
> > > 
> > > Yep, though it'd be good to get Paolo's input, too.
> > > 
> > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > series where we implement something more generic, e.g. a hypercall
> > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > exit route, we can drop the kvm side of the hypercall.
> > > 
> > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > rather, I think hypercall interception should be an orthogonal implementation.
> > > 
> > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > implement a common ABI is an unnecessary risk.
> > > 
> > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > require further VMM intervention.  But, I just don't see the point, it would
> > > save only a few lines of code.  It would also limit what KVM could do in the
> > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > then mandatory interception would essentially make it impossible for KVM to do
> > > bookkeeping while still honoring the interception request.
> > > 
> > > However, I do think it would make sense to have the userspace exit be a generic
> > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > just not used anywhere.
> > > 
> > > 	/* KVM_EXIT_HYPERCALL */
> > > 	struct {
> > > 		__u64 nr;
> > > 		__u64 args[6];
> > > 		__u64 ret;
> > > 		__u32 longmode;
> > > 		__u32 pad;
> > > 	} hypercall;
> > > 
> > > 
> > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > > 
> > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > that will result in truly heinous guest code, and extensibility issues.
> > > 
> > > The data limitation is a moot point, because the x86-only thing is a deal
> > > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > > memory with a host.  I can't think of a clever way to avoid having to support
> > > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > > multiple KVM variants.
> > > 
> > 
> > Potentially, there is another reason for in-kernel hypercall handling
> > considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
> > of each guest page, for instance pages in hypervisor state, i.e., pages
> > with C=0 and pages in guest valid state with C=1.
> > 
> > Now, there shouldn't be a need for page encryption status hypercalls on 
> > SEV-SNP as KVM can track & reference guest page status directly using 
> > the RMP table.
> 
> Relying on the RMP table itself would require locking the RMP table for an
> extended duration, and walking the entire RMP to find shared pages would be
> very inefficient.
> 
> > As KVM maintains the RMP table, therefore we will need SET/GET type of
> > interfaces to provide the guest page encryption status to userspace.
> 
> Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
> for converting between shared and private.  And in the case of TDX, the hypercall
> can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
> the host.

One question here, is this because if hypercall can cause direct
modifications to the shared EPT, it can induce #MC in the host ?

Thanks,
Ashish
