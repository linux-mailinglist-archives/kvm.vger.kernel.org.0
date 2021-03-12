Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1403398BB
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 21:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhCLU4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 15:56:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:49632 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235011AbhCLU4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 15:56:25 -0500
IronPort-SDR: GZt40eTfKr0URQLU/Tc+BtdeyHeiOGDa29QSlS0yaqhhfkZjQelBAtgLDp4ucYl09L2EAWt93p
 oExztKn7WgQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168804613"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="168804613"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 12:56:02 -0800
IronPort-SDR: +yAZQZlRFxNXGrsWBVBqLoh/L0S7tpb3FBFzxMaALzYg4kQ7i99mlKqSU50VYpRr6f29lPQa1b
 oHgYgPF50/xw==
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="409967645"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 12:56:02 -0800
Date:   Fri, 12 Mar 2021 12:58:21 -0800
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, jacob.jun.pan@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <20210312125821.22d9bfca@jacob-builder>
In-Reply-To: <YECfhCJtHUL9cB2L@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin & Tejun,

Sorry for the late reply, I sent from a different email address than I
intended. Please see my comments inline.


On Thu, 4 Mar 2021 03:51:16 -0500, Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Mar 03, 2021 at 10:22:03PM -0800, Vipin Sharma wrote:
> > > I am trying to see if IOASIDs cgroup can also fit in this misc
> > > controller as yet another resource type.
> > > https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> > > However, unlike sev IOASIDs need to be migrated if the process is
> > > moved to another cgroup. i.e. charge the destination and uncharge the
> > > source.
> > > 
> > > Do you think this behavior can be achieved by differentiating resource
> > > types? i.e. add attach callbacks for certain types. Having a single
> > > misc interface seems cleaner than creating another controller.  
> > 
> > I think it makes sense to add support for migration for the resources
> > which need it. Resources like SEV, SEV-ES will not participate in
> > migration and won't stop can_attach() to succeed, other resources which
> > need migration will allow or stop based on their limits and capacity in
> > the destination.  
> 
Sounds good. Perhaps some capability/feature flags for each resource such
that different behavior can be accommodated?
Could you please include me in your future posting? I will rebase on yours.

> Please note that cgroup2 by and large don't really like or support charge
> migration or even migrations themselves. We tried that w/ memcg on cgroup1
> and it turned out horrible. The expected usage model as decribed in the
> doc is using migration to seed a cgroup (or even better, use the new
> clone call to start in the target cgroup) and then stay there until exit.
> All existing controllers assume this usage model and I'm likely to nack
> deviation unless there are some super strong justifications.
> 
Thank you so much for the pointers. Just to be clear, you meant
1. Use clone3 CLONE_INTO_CGROUP to put the child into a different cgroup.
2. Do not support migration of the parent (existing proc)

Thanks,

Jacob
