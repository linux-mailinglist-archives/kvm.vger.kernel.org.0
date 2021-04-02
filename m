Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01724352A16
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhDBLJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:09:35 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:38526
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235055AbhDBLJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 07:09:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arREZBQ4zkjTuNa4pHmpNiJsEu5JCpZfE1mIbW9xKSi7bpm5sWU+TXOyH0BrPCfoQCBeHpHibypvVqbtLxLrGn03307NnDwW9M0Qf4/F3NdCbh2aRnaHw0dcyQCLoO+cKdoul7smHaX8WR3/F3I1PZLt9uYvjtRbIjhdHSlLsPsN5xxUIG92xA00R6jXasAszM9Gf1PSlY42ten0dtqz7PfMysvTOQ+hRQNEddV4uGe5EEppcdEZHsGln0YsCYNwlyo68NbA2CbVD64IwnWxuYdC6MqZp8yYSZDeBmnyNljp64c1iMFqWDZ6pY0C4wXVIvFSUOdjsoiPQdR6j+OH1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQve+TNt/uJu26hwBSfydZ2UCHWP5KZxgRMBZph9R60=;
 b=m3etu5KSDmxrCNH/uLeJzb0KM1It+aQjIYITQj370KUptU0bKzaVT2Em8gv2pYWOel0LVufJm1vqdeFG0Y8N/jzfdR9mrYThOZCC3xhQg3ApjtwItIH1WzynRKZpgfmM2bifL+KFyfkPwdlEvhHZD5wNIubEWWhO0dGFCjbVKCe6hCNzpdO/+qAkcoqZhK/l/S/YDBTQ/s7rbUwVIk+ESy70hidl5+onB2iv4jpowfE5C5SCtRrltqgOX+zXMG3+oic7BKasbjJu3LNXTzN6UU4HtWzzlvvRWLkmfsNtBS+1XGQOwE83UQC/AbQMQ7gBf/tfK0D9eCa+1z3ik3d/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQve+TNt/uJu26hwBSfydZ2UCHWP5KZxgRMBZph9R60=;
 b=urZrATvHRdVIMNcsL6xgylHKK/keJoyqID5jyu0/ymzPi3X/3D985WYl7sN6vHJDwILlAfMWKtKg25TiYGwWgNfFJQOzrnh1uvvY25b94OdJdKL+57O7tqxtwQV8QCQRWKR3RZwSaGYrJgboPpTX8DVl3OO5+of8UR7xAQVi7ec=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 11:09:31 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 11:09:31 +0000
Date:   Fri, 2 Apr 2021 11:09:24 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Quentin Perret <qperret@google.com>, maz@kernel.org
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210402110924.GA17630@ashkalra_ubuntu_server>
References: <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server>
 <20210303185441.GA19944@willie-the-truck>
 <20210311181458.GA6650@ashkalra_ubuntu_server>
 <CABayD+cXH0oeV4-Ah3y6ThhNt3dhd0qDh6JmimjSz=EFjC+SYw@mail.gmail.com>
 <20210319175953.GA585@ashkalra_ubuntu_server>
 <CABayD+eJzGRsE_Y+YRJ+w-PKbXyX0_kvTSZhZqhMLQtQj2w_7g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+eJzGRsE_Y+YRJ+w-PKbXyX0_kvTSZhZqhMLQtQj2w_7g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0011.namprd04.prod.outlook.com
 (2603:10b6:803:21::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0401CA0011.namprd04.prod.outlook.com (2603:10b6:803:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 11:09:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee1a251-2465-4121-9bd9-08d8f5c7c9ee
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2511B13C8960A72F57C747868E7A9@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mXTfWlGl7ULshC0Klmf2i1xLFNHRitoghbJUAhdDMcyM1CVIzylwxDaIX6GVoPudWrRTcBxHVeW9VelWfDgrJPJ4hC3Fa6Q/zlnaOFWCUjyGSXNXFEHSfZhIhFJVrZgCXUG4kjPSgv9D5P5ikVINbi90pv+RnvZfNOxg17Xr8AkjALFRfsRg8igzg59bpDEsnX0wuVJrd3nPrkZ/ZeeNE6Xh2sR4QKsVBR2WcNWR5XUD+6oq4D0j/k8uUqid+WEEXX0WLe2mE0bX108Slcc1hNZx+ClL1J8o7ccGiY5lej02XOkgVQ+1jmwShhxrH6wiru4n49ljU9ZIHFu9Ce+o1+AsSSt0d9o7t8QXB4Nc88HP7NBPIpFcuyJKoADn9pn9MTj3sfkwAuOFba7TP98G4oXUZfiFV96mvEpiCgY9jXkzv//iEhW33aY08deuHGTyfVFfhN76D4rukDEpc8p0ICsFNXQ6lrpyMZgxYY2qjFhfO/uY1IZn6y/ifRo+DZCWyeJOkwbNo5Dw21BSEnFXkmPadrbY2/gZB7/PZBRdtnNNflSjSbGQ9IJZhr1ng2ckIZX2/nickaSYbY8S80on9p+Er/XhQffvT72Kk5G56XyV+sDYzCcQ6hBCanyGRg5PxD4QifhtRRCPtrLgOaegcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(6496006)(66946007)(66476007)(66556008)(52116002)(316002)(478600001)(33656002)(5660300002)(26005)(956004)(55016002)(44832011)(9686003)(38100700001)(1076003)(6666004)(186003)(83380400001)(8676002)(6916009)(8936002)(86362001)(53546011)(7416002)(54906003)(33716001)(2906002)(4326008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3eMPqOBxDhEqQdZP+eU9/5CvwVnNaoCxfYpyCtCxYTfNiJWC0pGMzcRLzSdf?=
 =?us-ascii?Q?PJs0fyLa52lV+h3ABq9ylyCbia/1A/Mu0fdNM8bmb3zrM7cQjTAuKMUKipvN?=
 =?us-ascii?Q?L6nuwgU2kZiw1MuLsCrg5HfraR8Er6yI1bKBj8PzTMVVHbMZDGfTLMvv7Axv?=
 =?us-ascii?Q?zV58UcP+I0R/th42sSr0fdpvURndQbN/ZZUrhKbU2WTZRzTQr9O0wOIRSJ+j?=
 =?us-ascii?Q?Je4YukfeI0Kq0cHY/kJ8MK0b4Rnd8ym2wx/co2uMEXrbmTGuFaE2DUIeBOUc?=
 =?us-ascii?Q?LC0q0VhoPoD9Qd0mtf/QQck+bEbLb59uI+mT7OP2Eqkc0uSsSJ8NsrqEpCH9?=
 =?us-ascii?Q?Ez5926bHNbG5n8sGt9+eqlCoXBIbQ/b0ohdKFtclz15EhUmnZ3Wm/2/IhIXG?=
 =?us-ascii?Q?h9Jpso3ai3OSJQphme/S/ZW3ZbOqqrRvmfGvVM2tyH7fWN1LUzktV1x+kYj4?=
 =?us-ascii?Q?KviHsGgkFzak2vnIS4Wyr2ptmJhQn9k3o73FeOx1Uw2s6yhfxsqpVS7rFiOo?=
 =?us-ascii?Q?+tISt+VgY2QQ6KpFyaUOSEjhW9jL355NwMOTdZp6hXSXa3TEBvq8JbPR/jK3?=
 =?us-ascii?Q?0GYZPufECn3GtNPibipciLxgz9hXK6P7QtVKZSb0b5bwhiJh/isHtCGD2NVD?=
 =?us-ascii?Q?jXY2WmSTHfFZctTIy8q43cw8KTvWAXGePBjfvZ5XwN4kvFxJskwe05etmudV?=
 =?us-ascii?Q?dac2D47M0xOAn/zVrHldhr0x6Ai3KDRbxGY3Lk1yEAh0pQSoFH83MU+C2jCG?=
 =?us-ascii?Q?MxokEByt+StMz4VASUy4QAgI2e+JCO4fEuahru0x/zrM7B76YzX1slNRvqfo?=
 =?us-ascii?Q?G4d4ivaBS/PPnq2aQzaF6AmFwqA1pYE/Op7868SvNNQMU6Bv0u4NVwPa7Oy1?=
 =?us-ascii?Q?h6fhCIdR3EFw9CjDnIJYSaB4f8hNXHaVss7sR7quDj6FOZv1O5hU3lNIZlfc?=
 =?us-ascii?Q?Y/kDP5Km3DLALADBi6lzRkqtCdaOG3yU4As2dFkPj2i0Wt8PoJrWHJAOKcj5?=
 =?us-ascii?Q?/OjptwbG5Bh00SSWMf5DugdiUXZUF2ZlVwdB2GbPo5GcuAIuFi0e8N9jPDQF?=
 =?us-ascii?Q?lI1gZQ4iCUuiRxMGb2h16KN0zdPyrt+7noN1ZTT7ocMjLnFmRTbPnVqjZVVd?=
 =?us-ascii?Q?NWjZWmYKhIu3us3iS9GQhQtjgc8M8iKfMx/96CuuvIlWvQFNXl8EDcpCOX3w?=
 =?us-ascii?Q?HDK9zx1OxSSr2Dbw4Y3eLQqBeqXO6Wbnftu9UoqzVBoznOeyJ4REQlm72RbJ?=
 =?us-ascii?Q?6JXtQQQ3X9ElPqHH3N0OeWC38z0il/Ewk4t504Bzb4ceZAYi46Q7CA5UieFs?=
 =?us-ascii?Q?PzO6urrC1AiEY8tVS1UymQTh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee1a251-2465-4121-9bd9-08d8f5c7c9ee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 11:09:31.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rntv8v/UtaCTiRLnl1xXM2nCXkvVNFoif7vkZBGiWUJPPvgV9gBY+sdS8em9kEAwQSW/vL+KMbziu3Mm2iHrUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Apr 01, 2021 at 06:40:06PM -0700, Steve Rutherford wrote:
> On Fri, Mar 19, 2021 at 11:00 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Thu, Mar 11, 2021 at 12:48:07PM -0800, Steve Rutherford wrote:
> > > On Thu, Mar 11, 2021 at 10:15 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > >
> > > > On Wed, Mar 03, 2021 at 06:54:41PM +0000, Will Deacon wrote:
> > > > > [+Marc]
> > > > >
> > > > > On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> > > > > > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > > > > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > > > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > > > > > Thanks for grabbing the data!
> > > > > > > > >
> > > > > > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > > > > > hypercall exiting, so I think that would be the current consensus.
> > > > > > >
> > > > > > > Yep, though it'd be good to get Paolo's input, too.
> > > > > > >
> > > > > > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > > > > > series where we implement something more generic, e.g. a hypercall
> > > > > > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > > > > > exit route, we can drop the kvm side of the hypercall.
> > > > > > >
> > > > > > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > > > > > rather, I think hypercall interception should be an orthogonal implementation.
> > > > > > >
> > > > > > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > > > > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > > > > > implement a common ABI is an unnecessary risk.
> > > > > > >
> > > > > > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > > > > > require further VMM intervention.  But, I just don't see the point, it would
> > > > > > > save only a few lines of code.  It would also limit what KVM could do in the
> > > > > > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > > > > > then mandatory interception would essentially make it impossible for KVM to do
> > > > > > > bookkeeping while still honoring the interception request.
> > > > > > >
> > > > > > > However, I do think it would make sense to have the userspace exit be a generic
> > > > > > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > > > > > just not used anywhere.
> > > > > > >
> > > > > > >   /* KVM_EXIT_HYPERCALL */
> > > > > > >   struct {
> > > > > > >           __u64 nr;
> > > > > > >           __u64 args[6];
> > > > > > >           __u64 ret;
> > > > > > >           __u32 longmode;
> > > > > > >           __u32 pad;
> > > > > > >   } hypercall;
> > > > > > >
> > > > > > >
> > > > > > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > > > > > >
> > > > > > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > > > > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > > > > > that will result in truly heinous guest code, and extensibility issues.
> > > > > > >
> >
> > We may also need to pass-through the MSR to userspace, as it is a part of this
> > complete host (userspace/kernel), OVMF and guest kernel negotiation of
> > the SEV live migration feature.
> >
> > Host (userspace/kernel) advertises it's support for SEV live migration
> > feature via the CPUID bits, which is queried by OVMF and which in turn
> > adds a new UEFI runtime variable to indicate support for SEV live
> > migration, which is later queried during guest kernel boot and
> > accordingly the guest does a wrmrsl() to custom MSR to complete SEV
> > live migration negotiation and enable it.
> >
> > Now, the GET_SHARED_REGION_LIST ioctl returns error, until this MSR write
> > enables SEV live migration, hence, preventing userspace to start live
> > migration before the feature support has been negotiated and enabled on
> > all the three components - host, guest OVMF and kernel.
> >
> > But, now with this ioctl not existing anymore, we will need to
> > pass-through the MSR to userspace too, for it to only initiate live
> > migration once the feature negotiation has been completed.
> 
> I can't tell if you were waiting for feedback on this before posting
> the follow-up patch series.

Actually, i am going to post the follow-up patch series upstream early
next week. 

I have already added support for MSR handling and exit to userspace, the
current implementation looks like this :

The custom MSR is hooked both in svm_get_msr() and svm_set_msr():

@@ -2800,6 +2800,17 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        case MSR_F10H_DECFG:
                msr_info->data = svm->msr_decfg;
                break;
+       case MSR_KVM_SEV_LIVE_MIGRATION:
+               if (!sev_guest(vcpu->kvm))
+                       return 1;
+
+               if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
+                       return 1;
+
+               /*
+                * Let userspace handle the MSR using MSR filters.
+                */
+               return KVM_MSR_RET_FILTERED;

So there is special check added for both sev_guest() and requisite CPUID
bit set in guest CPUID, if either fails this will signal #GP to guest.

Otherwise, it returns MSR_FILTER return code, which will allow userspace
to use msr intercepts to handle the reads and writes via userspace exits
using KVM_EXIT_X86_RDMSR/KVM_EXIT_X86_WRMSR.

Let me know if you have any feedback/comments on the above handling.

Thanks,
Ashish

> 
> Here are a few options:
> 1) Add the MSR explicitly to the list of custom kvm MSRs, but don't
> have it hooked up anywhere. The expectation would be for the VMM to
> use msr intercepts to handle the reads and writes. If that seems
> weird, have svm_set_msr (or whatever) explicitly ignore it.
> 2) Add a getter and setter for the MSR. Only allow guests to use it if
> they are sev_guests with the requisite CPUID bit set.
> 
> I think I prefer the former, and it should work fine from my
> understanding of the msr intercepts implementation. I'm also open to
> other ideas. You could also have the MSR write trigger a KVM_EXIT of
> the same type as the hypercall, but have it just say "the msr value
> changed to XYZ", but that design sounds awkward.
> 
> Thanks,
> Steve
