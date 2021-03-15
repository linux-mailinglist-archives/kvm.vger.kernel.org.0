Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F69233C916
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhCOWJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:09:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:24979 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhCOWJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:09:36 -0400
IronPort-SDR: 92spJeBzHVX1Wqwx0W/3ytlPnt6+cBuFFYzv/tjVsTNJGUirjzRzyW800UHKZQdWCTwpRTgEjE
 ZYjbRX5ZATmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189252800"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189252800"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 15:09:34 -0700
IronPort-SDR: h8R33qztUP4g3UWFP1eMSDTvke59umLwYr2NaDzDujI4j9ez+ZOoIOyvqjxkBlv7P+E+GuGOUu
 g5ZI9i5IL7Kw==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="522298432"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 15:09:34 -0700
Date:   Mon, 15 Mar 2021 15:11:55 -0700
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
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        jacob.jun.pan@intel.com
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <20210315151155.383a7e6e@jacob-builder>
In-Reply-To: <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
        <20210313085701.1fd16a39@jacob-builder>
        <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tejun,

On Sat, 13 Mar 2021 13:05:36 -0500, Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Sat, Mar 13, 2021 at 08:57:01AM -0800, Jacob Pan wrote:
> > Isn't PIDs controller doing the charge/uncharge? I was under the
> > impression that each resource can be independently charged/uncharged,
> > why it affects other resources? Sorry for the basic question.  
> 
> Yeah, PID is an exception as we needed the initial migration to seed new
> cgroups and it gets really confusing with other ways to observe the
> processes - e.g. if you follow the original way of creating a cgroup,
> forking and then moving the seed process into the target cgroup, if we
> don't migrate the pid charge together, the numbers wouldn't agree and the
> seeder cgroup may end up running out of pids if there are any
> restrictions.
> 
Thanks for explaining. Unfortunately, it seems IOASIDs has a similar needs
in terms of migrating the charge.

> > I also didn't quite get the limitation on cgroup v2 migration, this is
> > much simpler than memcg. Could you give me some pointers?  
> 
> Migration itself doesn't have restrictions but all resources are
> distributed on the same hierarchy, so the controllers are supposed to
> follow the same conventions that can be implemented by all controllers.
> 
Got it, I guess that is the behavior required by the unified hierarchy.
Cgroup v1 would be ok? But I am guessing we are not extending on v1?

> > BTW, since the IOASIDs are used to tag DMA and bound with guest
> > process(mm) for shared virtual addressing. fork() cannot be supported,
> > so I guess clone is not a solution here.  
> 
> Can you please elaborate what wouldn't work? The new spawning into a new
> cgroup w/ clone doesn't really change the usage model. It's just a neater
> way to seed a new cgroup. If you're saying that the overall usage model
> doesn't fit the needs of IOASIDs, it likely shouldn't be a cgroup
> controller.
> 
The IOASIDs are programmed into devices to generate DMA requests tagged
with them. The IOMMU has a per device IOASID table with each entry has two
pointers:
 - the PGD of the guest process.
 - the PGD of the host process

The result of this 2 stage/nested translation is that we can share virtual
address (SVA) between guest process and DMA. The host process needs to
allocate multiple IOASIDs since one IOASID is needed for each guest process
who wants SVA.

The DMA binding among device-IOMMU-process is setup via a series of user
APIs (e.g. via VFIO).

If a process calls fork(), the children does not inherit the IOASIDs and
their bindings. Children who wish to use SVA has to call those APIs to
establish the binding for themselves.

Therefore, if a host process allocates 10 IOASIDs then does a
fork()/clone(), it cannot charge 10 IOASIDs in the new cgroup. i.e. the 10
IOASIDs stays with the process wherever it goes.

I feel this fit in the domain model, true?

> Thanks.
> 


Thanks,

Jacob
