Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F1632CA92
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 03:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCDCxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 21:53:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:13315 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhCDCxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 21:53:40 -0500
IronPort-SDR: uZXXVjRcj272xTsIC6QZ8/TLz3zblExCtBLugUGnYh1Oa71oRMDlIUWSMKTPSflWew/xSBupWl
 9oGmCkd67syA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="174444362"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="174444362"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:52:58 -0800
IronPort-SDR: 3i9zbih/qTnJ32Z9atLme0OLnL9sE717HSH9+ywfyQtC2DUtXDXMnSgdKq1O45rMUp+L1THRRm
 VfqTf3SzqBig==
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="445547078"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:52:57 -0800
Date:   Wed, 3 Mar 2021 18:55:13 -0800
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@intel.com,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <20210303185513.27e18fce@jacob-builder>
In-Reply-To: <20210302081705.1990283-3-vipinsh@google.com>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

On Tue,  2 Mar 2021 00:17:05 -0800, Vipin Sharma <vipinsh@google.com> wrote:

> +Migration and Ownership
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +A miscellaneous scalar resource is charged to the cgroup in which it is
> used +first, and stays charged to that cgroup until that resource is
> freed. Migrating +a process to a different cgroup does not move the
> charge to the destination +cgroup where the process has moved.
> +
I am trying to see if IOASIDs cgroup can also fit in this misc controller
as yet another resource type.
https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
However, unlike sev IOASIDs need to be migrated if the process is moved to
another cgroup. i.e. charge the destination and uncharge the source.

Do you think this behavior can be achieved by differentiating resource
types? i.e. add attach callbacks for certain types. Having a single misc
interface seems cleaner than creating another controller.

Thanks,

Jacob
