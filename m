Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73B5347D70
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhCXQPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:15:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:57098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhCXQOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:14:35 -0400
IronPort-SDR: zfGTiFEjKYvtYdtrDBg2JmPFkHkDM31AVIESN2o4IN/pF8FZLlrYnuAeT6rTbFpQSWc+CyNxmY
 nhDw2gaHwFyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="187430914"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="187430914"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 09:14:35 -0700
IronPort-SDR: QSC95SEdrOKTkNAZDK+sqyjUDZsIHx2HWakvGcOAsBjSY6RfDxOQm0tHKN5ZPswqAR2wDcgFXZ
 I+y6CZWu0a8w==
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="391356730"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 09:14:34 -0700
Date:   Wed, 24 Mar 2021 09:17:01 -0700
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
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        jacob.jun.pan@intel.com
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <20210324091701.63c9ce8e@jacob-builder>
In-Reply-To: <YFjn7wv/iMO4Isgz@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
        <20210304231946.2766648-2-vipinsh@google.com>
        <20210319142801.7dcce403@jacob-builder>
        <YFjn7wv/iMO4Isgz@google.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

On Mon, 22 Mar 2021 11:54:39 -0700, Vipin Sharma <vipinsh@google.com> wrote:

> On Fri, Mar 19, 2021 at 02:28:01PM -0700, Jacob Pan wrote:
> > On Thu,  4 Mar 2021 15:19:45 -0800, Vipin Sharma <vipinsh@google.com>
> > wrote:  
> > > +#ifndef _MISC_CGROUP_H_
> > > +#define _MISC_CGROUP_H_
> > > +  
> > nit: should you do #include <linux/cgroup.h>?
> > Otherwise, css may be undefined.  
> 
> User of this controller will use get_curernt_misc_cg() API which returns
> a pointer. Ideally the user should use this pointer and they shouldn't
> have any need to access "css" in their code. They also don't need to
> create a object of 'struct misc_cg{}', because that won't be correct misc
> cgroup object. They should just declare a pointer like we are doing here
> in 'struct kvm_sev_info {}'.
> 
> If they do need to use "css" then they can include cgroup header in their
> code.
> 
I didn't mean the users of misc_cgroup will use css directly. I meant if I
want to use misc cgruop in ioasid.c, I have to do the following to avoid
undefined css:
#include <linux/cgroup.h>
#include <linux/misc_cgroup.h>

So it might be simpler if you do #include <linux/cgroup.h> inside
misc_cgroup.h. Then in ioasid.c, I only need to do
#include <linux/misc_cgroup.h>.

> Let me know if I am overlooking something here.
> 
> Thanks
> Vipin Sharma


Thanks,

Jacob
