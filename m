Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E933DC60
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhCPSRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:17:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:9049 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234366AbhCPSQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:16:46 -0400
IronPort-SDR: NHvPOs4MwvM542MOoi5r5IGZJ2h2OBY+wfzcdl5U5dcak80yl/joQXTzu5hcGOFIncVGRJLkbi
 Dq6ABb5MRrqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="185951210"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="185951210"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 11:16:45 -0700
IronPort-SDR: Cztyz60fnMHguSV703xnY9lhec9N/0NGqFc6oNBH/4GUyEvAec+gGdEaq38jMD3PJXTjc0NPNo
 K5UgsGOpaZmw==
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="405627942"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 11:16:42 -0700
Date:   Tue, 16 Mar 2021 11:19:04 -0700
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
Message-ID: <20210316111904.5d92472e@jacob-builder>
In-Reply-To: <YFAWVJrM86FB17Lk@slm.duckdns.org>
References: <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
        <20210313085701.1fd16a39@jacob-builder>
        <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
        <20210315151155.383a7e6e@jacob-builder>
        <YE/ddx5+ToNsgUF0@slm.duckdns.org>
        <20210315164012.4adeabe8@jacob-builder>
        <YE/zvLkL1vM8/Cdm@slm.duckdns.org>
        <20210315183030.5b15aea3@jacob-builder>
        <YFAWVJrM86FB17Lk@slm.duckdns.org>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tejun,

On Mon, 15 Mar 2021 22:22:12 -0400, Tejun Heo <tj@kernel.org> wrote:

> On Mon, Mar 15, 2021 at 06:30:30PM -0700, Jacob Pan wrote:
> > I don't know if this is required. I thought utilities such as cgclassify
> > need to be supported.
> > " cgclassify - move running task(s) to given cgroups "
> > If no such use case, I am fine with dropping the migration support. Just
> > enforce limit on allocations.  
> 
> Yeah, that's what all other controllers do. Please read the in-tree
> cgroup2 doc.
> 
Thanks for your patience and guidance, will try to merge with misc
controller and go from there.

Thanks,

Jacob
