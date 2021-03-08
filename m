Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7537330B71
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 11:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhCHKkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 05:40:46 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:17761
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230271AbhCHKk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 05:40:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNVNEH7j4WR/Tye509joXJuM8U4h3ygO0LLDK2+eGYGKQ/TR3IT8Zp9BAfmHYhoXcNfoT/IRxilt7JzAePSf8oVYzR6tOV5VBlflJljavSfbCtUIbZysiSo5i+VBGdGZwQ2ZD8+zfVyFPZs0YfEVaKeb2nAlgCA8nYklnD2U4+N8dNa90KN5lNekMuoExlJi+fb9fUW9eL+AZVYEysbBTzBcwKGvR+eS+/H7juMD67dNrNUw9vlkVhkIsq9H7Ct9iX2QokNhs/c0MCjPS8PS+AuUzCtwZzOjssIyjFovtEESBmh3gCHpkL9ZL2DSAzyis0r6WBKmzvTG9ouIuzsCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdzhFv6yd5p5KlgV/Tlab6uEvFV9oKa2fLBbR+YL6xE=;
 b=D65jN2CMeT/XvoBCZnwUZygdxLRup1xV6xU5YY8C24aBqRSl5xWcThKK8xJVoh0v60SQrl0u5UKyiy4Bcl04kfLCNYH+rDqTKYJVoMMq8F5XP027px8/bgZXa5+1F093j4Dn8GeXNZQGjBLY2Ds9jaq+oA+SKuFkl0nDJM9XJninyQTv5z8K3mxZltUpaNFiGBdriwqd2a/E05MuaXMfrQu5zf4hjKTYEjLiy6B9doU+vI+tZwPii5Y4eYMCSDhlF4Tfx2DCHRqbyMcxMAD2CoQp6cUCfVNCyzgeXyILB+C2rqyuttzQxfPp6J1wMVhj8oKxpHqUdHt/4pSXNzn7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdzhFv6yd5p5KlgV/Tlab6uEvFV9oKa2fLBbR+YL6xE=;
 b=yyXxYAh5CwTQAU7z3EXBthH0eIsLmqYveVRzWr1uzSN9C1XMZ9O87EgXiVC6h1fySKtdXovaMYfb5JVoesRiEygMF04DTMZp/hHNEouW0kOBzqkKdfYb3UCBmSFFS2Uwz5grp0Y6boV1ecM9QNeKVqVJNy0J47TGTaLrnCwrg9E=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 10:40:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 10:40:21 +0000
Date:   Mon, 8 Mar 2021 10:40:14 +0000
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
Message-ID: <20210308104014.GA5333@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDkzibkC7tAYbfFQ@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0149.namprd05.prod.outlook.com
 (2603:10b6:803:2c::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0149.namprd05.prod.outlook.com (2603:10b6:803:2c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.14 via Frontend Transport; Mon, 8 Mar 2021 10:40:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85b868f9-a634-4c70-6bce-08d8e21e9254
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575ECB38FDA0BA83D96B48B8E939@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2jTeDaXi5BZQE5AS+m5WeorUzu4RKwr3zJaXUjGdVlBsPCsozPNrStmd/9G2bDvIH2cJp1Y+SLYyVyQ3IVymut8F6ykTpsTOrmhbY5dOCDWjeeV2d3kGgt9a+wkGEW7Uhti8mQaNoQgiNH8wtyOVszv6LiPZ9kiQtMSwW3QQYdg3+AKyCsKMMmj7tAwseiXD9oJHFWJtmjp2arMkP1sE9vE7tPyUk2bcoNDL/h3boRA/id1q7WxLJinHGdkXco/+4YrM2rjLikMmLSMPAqZuHKjgKsvaFQJAuMihQDCQEWzfA4Z1BXTC4eECVB3tPbxRrFw48wFx0YCSBFXTyo6XNDofN/2gfUPb6YPkVhETTVohpwej96WdP5cr7m5jFoxKQwVKtHqS4tSNbp+YsQ2PjY3+1G+6znp8c4hgRhUKir7LIjdKdT4eRnpxzayluqA2AlXZE65+b6k2fxL/e3AIiX4jHTsPAbA7X96DHtGFMs1rq3wYy4UD4dBy+p1k0PXCOvrFKTjYF/5jXek+fi2T0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(6916009)(9686003)(5660300002)(33656002)(4326008)(2906002)(55016002)(26005)(66556008)(8936002)(66476007)(956004)(33716001)(316002)(54906003)(53546011)(6666004)(83380400001)(44832011)(8676002)(6496006)(66946007)(86362001)(186003)(478600001)(52116002)(16526019)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/Mib/w9vAcuEDdYb6YOiwDWDJGN4bu0yFIlrf0hj+VP4srnyEGthB2OkI6Dd?=
 =?us-ascii?Q?EaKDufXMzwoRipWDcHA1GS6l9OtVLdFgXeibp8PlzUgaq8pA/w4plGYNwiGk?=
 =?us-ascii?Q?+x2UkHQTJB2NACSSt+l2vjWRcVXU2iXvXPuAG9eFxrm6EnGIG/gqbZTlrRDx?=
 =?us-ascii?Q?VOZd7Ul3MTl9FYCom2+Gca1TnfJ/8Lv8dPDYKZ3QelrwEpXIsZJuB6zVgshI?=
 =?us-ascii?Q?Fs6wKckGM+aZDb9oLAK8l3VPcYE53nW/OqzZQwc/xE9qHvKbfJWByQgNFlqA?=
 =?us-ascii?Q?2MxCpmoRsInz95ipCh56OembfS60EQFuS+TVeIIK31H+GQ71+kKQjmhI+blD?=
 =?us-ascii?Q?1UT9wJ0Sxhfghsod4N3VUn1YV9R/A48EDHpN2rGWItezRB27EMJsETPL6v/7?=
 =?us-ascii?Q?eOvnFClzSPlu9/uLYoYEZZRJLM395xNSr7OPhn7qjNU4qJuRBrF5XFFdmjyq?=
 =?us-ascii?Q?A2JCt9GC2V5h8hdPfW/e7pkbotRqOagMxtSFsa2ucwZ3ykvtzYJ/Y5jT5z23?=
 =?us-ascii?Q?yESB+wpPZx0LmM36Z2A0btszO/X0kLzGtXncvU5V/N5WKBBfE6CPxaRC84b3?=
 =?us-ascii?Q?99h7RNpl9EvbD+OQF/VoPrJR3x9mtY7I/UCvBe7I5Grn5EokcPAONKSloVuJ?=
 =?us-ascii?Q?r94Xk77mvrnRZru7m6cKtOEOayCx23hLHJfI7Dv4koDn6AGaMPXdcFVuJ2dx?=
 =?us-ascii?Q?Sm4QYHq/tNuc1e4jHpuOy5UAvpZirQneBu/2A5bkO2VVFqnhU3Z/WQc4gDcI?=
 =?us-ascii?Q?/J/EW55rXxjJouqrNvqVYyRCj4bLerCIDA8saZLtGd/5Vsg0DzybHeMFVp+T?=
 =?us-ascii?Q?5geN5mc0MFTdeJB1nelpwe+GbDpQOljdNK2yUiq1Vvd9R0obj0Omj6XDd9Eh?=
 =?us-ascii?Q?fc0H8SZEmuFeL/pI19Ox24hCermmyCpBW2ERn/Tn/OLwQinqI/1Ks/W+kKjN?=
 =?us-ascii?Q?CeoZgJCPi8zYB/4c7vvzVJDOZdIDNu4zEsMTLA7yPJxiPIBklk7zRQyn36tf?=
 =?us-ascii?Q?IAuu8d+gsYgJwFKOsKKSziN2aleuWQDbjMZdP/46RgRhaD/UUBERwwevC3jq?=
 =?us-ascii?Q?I9dRn9cGfCrRuTEQ1uLDMol0uaiKisJlS2T9t+tOUipJXaT/aM1gREjgLtse?=
 =?us-ascii?Q?fnjUy2qicSKyyOHP4UPYmH0G6RbbpVrfJQwcaWC/qET59/YRQuEzT4x9AkCx?=
 =?us-ascii?Q?g5rpQX5Rl5bNNHu0ZTgk7bKyX6+r3RX1yXNobFvJDcV+XVpY0LAA2zi2nVbF?=
 =?us-ascii?Q?jwdZhPuVHdrOK8P3VOz6jQdzpT69rcJmIuFApHcKDEmaMkbRPKfcVmN4xEf4?=
 =?us-ascii?Q?1/aBS5OzOwDSfla+wFv+IrfY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b868f9-a634-4c70-6bce-08d8e21e9254
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 10:40:20.9125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5njpUidLXd1XHVMEGH2/8cdI/nIKE8/WYrFfCo8yECnMasKN4u5FpdC/EW5Hu922ioL/kyi+ZQ06Nv7sSsdXag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> +Will and Quentin (arm64)
> 
> Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> point.
> 
> On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > Thanks for grabbing the data!
> > > 
> > > I am fine with both paths. Sean has stated an explicit desire for
> > > hypercall exiting, so I think that would be the current consensus.
> 
> Yep, though it'd be good to get Paolo's input, too.
> 
> > > If we want to do hypercall exiting, this should be in a follow-up
> > > series where we implement something more generic, e.g. a hypercall
> > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > exit route, we can drop the kvm side of the hypercall.
> 
> I don't think this is a good candidate for arbitrary hypercall interception.  Or
> rather, I think hypercall interception should be an orthogonal implementation.
> 
> The guest, including guest firmware, needs to be aware that the hypercall is
> supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> implement a common ABI is an unnecessary risk.
> 
> We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> require further VMM intervention.  But, I just don't see the point, it would
> save only a few lines of code.  It would also limit what KVM could do in the
> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> then mandatory interception would essentially make it impossible for KVM to do
> bookkeeping while still honoring the interception request.
> 
> However, I do think it would make sense to have the userspace exit be a generic
> exit type.  But hey, we already have the necessary ABI defined for that!  It's
> just not used anywhere.
> 
> 	/* KVM_EXIT_HYPERCALL */
> 	struct {
> 		__u64 nr;
> 		__u64 args[6];
> 		__u64 ret;
> 		__u32 longmode;
> 		__u32 pad;
> 	} hypercall;
> 
> 
> > > Userspace could also handle the MSR using MSR filters (would need to
> > > confirm that).  Then userspace could also be in control of the cpuid bit.
> 
> An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> The data limitation could be fudged by shoving data into non-standard GPRs, but
> that will result in truly heinous guest code, and extensibility issues.
> 
> The data limitation is a moot point, because the x86-only thing is a deal
> breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> memory with a host.  I can't think of a clever way to avoid having to support
> TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> multiple KVM variants.
> 

Potentially, there is another reason for in-kernel hypercall handling
considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
of each guest page, for instance pages in hypervisor state, i.e., pages
with C=0 and pages in guest valid state with C=1.

Now, there shouldn't be a need for page encryption status hypercalls on 
SEV-SNP as KVM can track & reference guest page status directly using 
the RMP table.

As KVM maintains the RMP table, therefore we will need SET/GET type of
interfaces to provide the guest page encryption status to userspace.

For the above reason if we do in-kernel hypercall handling for page
encryption status (which we probably won't require for SEV-SNP &
correspondingly there will be no hypercall exiting), then we can
implement a standard GET/SET ioctl interface to get/set the guest page
encryption status for userspace, which will work across SEV, SEV-ES and
SEV-SNP.

Thanks,
Ashish

