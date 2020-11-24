Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BDD2C33CF
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 23:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389361AbgKXWV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 17:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388664AbgKXWV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 17:21:56 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE643C061A4F
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 14:21:55 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t8so399638pfg.8
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 14:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5IOFKT2E7UmZNE+UF5+67kx99kzkXEJjEUmTB7hYGQ8=;
        b=PPW0lZFNYlL9xRQ+lUkWVVx5ASkq2QlU7KPxrRbKvts6ZAtAw/YUXZhM00orxYqZfg
         axDh5BKUUvJfH1rkZb1iFvF3gGMZcUslXFz1OnmAK2hSpHozP1AeLCn7YxOoymaXua0F
         YPHGL6s6rf3LcwZy1VWcM46dUUoniltGD4MQtyFFbyXB5wNB6YB5uZatAOdoV/Ihq8TG
         3r6uq5Gqwt+p9XWl76NXYbnJIK7ElVTmVJvBv6TRKon+oWOUX9v/tMdjJCekCayPVXqy
         UNYFgRHvy5HX/eP2SdDiFXEu97Cxezw3gu3zyftZAAWT7ia3ApuC2r0pjTAxXSPHK/3t
         4k8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5IOFKT2E7UmZNE+UF5+67kx99kzkXEJjEUmTB7hYGQ8=;
        b=AnpY6Ef84GW6H8ntMMzExJxCBJSlPGFr8q2m6wNf4b0L0Kg/Ig3bPLp23aTpIHxH2Y
         yBj1xlglTvv3B8p8vty0XmZisAInHRM4isK7OGShh57a3R9r8UR4by/Ih9f0Qo9T53xD
         vHKpw1LKGudcs1el5i0e/bgpa6qpsEg1n63oalaX1flViosr7GDzsybWH7n/qoiGXOcb
         I8E4RrPylLilqXcOEYrlBv6kvJ9gTtm32nIoXogjHOp6oZ7IMhq8cderZHw0MHPcpWKj
         +AXw5IC/h5cLc8RxXKrKvuGB6NSuRleZjjEO+Sr+OCgBbjsYOQpvHZYmXhvJacCYcD9c
         axCQ==
X-Gm-Message-State: AOAM532HNG9lKt4QmXfS+LNWczVuJILBM6NXbeFPsWXgUUpkNgoh64Cp
        Rhzf7b8hb5PnxxoyX5BQl6EqvEJ8W77zsurG
X-Google-Smtp-Source: ABdhPJzEi0HzFsD9olRT/c+V4q89YY33lIFUdwC1A293ipnDcgbJp25euiagGKlo/ygjoSazDXIMug==
X-Received: by 2002:a17:90b:68f:: with SMTP id m15mr373352pjz.209.1606256514953;
        Tue, 24 Nov 2020 14:21:54 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id g14sm173736pgi.89.2020.11.24.14.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 14:21:54 -0800 (PST)
Date:   Tue, 24 Nov 2020 14:21:49 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas <thomas.lendacky@amd.com>, pbonzini@redhat.com,
        tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>,
        Eric <eric.vantassell@amd.com>, gingell@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20201124222149.GB65542@google.com>
References: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
 <20201124191629.GB235281@google.com>
 <20201124194904.GA45519@google.com>
 <alpine.DEB.2.23.453.2011241215400.3594395@chino.kir.corp.google.com>
 <20201124210817.GA65542@google.com>
 <20201124212725.GB246319@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124212725.GB246319@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 09:27:25PM +0000, Sean Christopherson wrote:
> On Tue, Nov 24, 2020, Vipin Sharma wrote:
> > On Tue, Nov 24, 2020 at 12:18:45PM -0800, David Rientjes wrote:
> > > On Tue, 24 Nov 2020, Vipin Sharma wrote:
> > > 
> > > > > > Looping Janosch and Christian back into the thread.                           
> > > > > >                                                                               
> > > > > > I interpret this suggestion as                                                
> > > > > > encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         
> > > > > 
> > > > > I think it makes sense to use encryption_ids instead of simply encryption, that
> > > > > way it's clear the cgroup is accounting ids as opposed to restricting what
> > > > > techs can be used on yes/no basis.
> > > > > 
> > > 
> > > Agreed.
> > > 
> > > > > > offerings, which was my thought on this as well.                              
> > > > > >                                                                               
> > > > > > Certainly the kernel could provide a single interface for all of these and    
> > > > > > key value pairs depending on the underlying encryption technology but it      
> > > > > > seems to only introduce additional complexity in the kernel in string         
> > > > > > parsing that can otherwise be avoided.  I think we all agree that a single    
> > > > > > interface for all encryption keys or one-value-per-file could be done in      
> > > > > > the kernel and handled by any userspace agent that is configuring these       
> > > > > > values.                                                                       
> > > > > >                                                                               
> > > > > > I think Vipin is adding a root level file that describes how many keys we     
> > > > > > have available on the platform for each technology.  So I think this comes    
> > > > > > down to, for example, a single encryption.max file vs                         
> > > > > > encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      
> > > > > 
> > > > > Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
> > > > > no need to enumerate platform total, but not knowing how many of the allowed IDs
> > > > > have been allocated seems problematic.
> > > > > 
> > > > 
> > > > We will be showing encryption_ids.{sev,sev_es}.{max,current}
> > > > I am inclined to not provide "events" as I am not using it, let me know
> > > > if this file is required, I can provide it then.
> 
> I've no objection to omitting current until it's needed.
> 
> > > > I will provide an encryption_ids.{sev,sev_es}.stat file, which shows
> > > > total available ids on the platform. This one will be useful for
> > > > scheduling jobs in the cloud infrastructure based on total supported
> > > > capacity.
> > > > 
> > > 
> > > Makes sense.  I assume the stat file is only at the cgroup root level 
> > > since it would otherwise be duplicating its contents in every cgroup under 
> > > it.  Probably not very helpful for child cgroup to see stat = 509 ASIDs 
> > > but max = 100 :)
> > 
> > Yes, only at root.
> 
> Is a root level stat file needed?  Can't the infrastructure do .max - .current
> on the root cgroup to calculate the number of available ids in the system?

For an efficient scheduling of workloads in the cloud infrastructure, a
scheduler needs to know the total capacity supported and the current
usage of the host to get the overall picture. There are some issues with
.max -.current approach:

1. Cgroup v2 convention is to not put resource control files in the
   root. This will mean we need to sum (.max -.current) in all of the
   immediate children of the root.

2. .max can have any limit unless we add a check to not allow a user to
   set any value more than the supported one. This will theoretically
   change the encryption_ids cgroup resource distribution model from the
   limit based to the allocation based. It will require the same
   validations in the children cgroups. I think providing separate file on
   the root is a simpler approach.

For someone to set the max limit, they need to know what is the
supported capacity. In the case of SEV and SEV-ES it is not shown
anywhere and the only way to know this is to use a CPUID instructions.
The "stat" file will provide an easy way to know it.

Since current approach is not migrating charges, this means when a
process migrates to an another cgroup and the old cgroup is deleted
(user won't see it but it will be present in the cgroup hierarchy
internally), we cannot get the correct usage by going through other
cgroup directories in this case.

I am suggesting that the root stat file should show both available and
used information.
$ cat encryption_ids.sev.stat
total 509
used 102

It will be very easy for a cloud scheduler to retrieve the system state
quickly.
