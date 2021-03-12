Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBC339585
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhCLRtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbhCLRtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 12:49:32 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF7CC061762
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:49:31 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 30so7710362ple.4
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=csMPZAYxCBTEQbPB3Xmop3XmbNBt5+uYFADY2kRb6qA=;
        b=o9KG5np4GiSzQMqkEaxSRIqmTD15b/mJFR0bihIPG/1y69mD7nFyMiABc8fYtXdqOk
         GFpEv76l31p8dmd//oe7ARKidD3Cb0XkZaJduHtnrKMONTq935ng9PTueZ4JHI7R1IAI
         l5f2a42VDoEXXfyBPIZ3RxzHdfYzyXJSs5giZu/ivRvMJelLVtiHSNvV20sMuLjQTWYJ
         iLNLdo3EbAApFxiSxmQSqJljwgZ6BYuoQAOInEE/vhT86GYPfiRQLgYNuTp6f7v4O/ZP
         n2/Cf3MmFDF1tubVD7LXT2U0k2QQXJCKgW6bh2shK8GwEMNLfm4BUR1rZN6/SxNuT0ix
         ZnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=csMPZAYxCBTEQbPB3Xmop3XmbNBt5+uYFADY2kRb6qA=;
        b=MWXfAqK6NhhP698HoP4H8CLXjgFKefoycTFOY/in14l3eVoyxtBOpeUWwECSWFWAtM
         Ry7910eqO1NF4QxoqNnv7OTrFuopqhacm0AQszfSkpduRvuf+/EMqOPBTA48oybsSZT8
         4PQXfigXkpN17gjDf633M5Ycf/j2dKMDL+6OhL+AT/3f7GlnVMHsXu39TBRvBCy897SE
         PdrDN98407V62NIkKMfjIZ7tYtbM4pBwFBdYAOobjve38BO+PCAS4fbwedwpAQbCAd1R
         0jAAYKuvWFnmuUZFec+Bfrva8gWaWfPd+i3uwfmGD4TtaZSuj6QqSZ/ESN3bZ5I95JgI
         QhYg==
X-Gm-Message-State: AOAM533yIIgCwUrcpgGE7/NwEYZYZvj8AiLn/SJXfchCMjv9jFkuB+6P
        NsHD9MFUdbMiaIhL5kTPKUkDfQ==
X-Google-Smtp-Source: ABdhPJxDcsQ5VU1Ul+tvaM/5WNQYzRGAcYEvzabmGHrHnG/f8+KP0FFlDC91xTOQsYGcCfrDagW7rA==
X-Received: by 2002:a17:90a:29e4:: with SMTP id h91mr14914204pjd.225.1615571371008;
        Fri, 12 Mar 2021 09:49:31 -0800 (PST)
Received: from google.com ([2620:0:1008:10:18a1:1d64:e35b:961e])
        by smtp.gmail.com with ESMTPSA id e8sm6017651pgb.35.2021.03.12.09.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:49:30 -0800 (PST)
Date:   Fri, 12 Mar 2021 09:49:26 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Tejun Heo <tj@kernel.org>, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Message-ID: <YEupplaAWU1i0G6B@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEpoS90X19Z2QOro@blackbook>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 07:58:19PM +0100, Michal Koutný wrote:
> I admit, I didn't follow the past dicussions completely, however,
> (Vipin) could it be in the cover letter/commit messages shortly
> summarized why cgroups and a controller were chosen to implement
> restrictions of these resources, what were the alternatives any why were
> they rejected?

I will add some more information in the cover letter of the next version.

Basically, SEV will mostly be used by cloud providers for providing
confidential VMs. Since they are limited we need a good way to schedule
these jobs in cloud infrastructure. To achieve this we either come up
with some ioctl for "/dev/sev" to know about its usage, availability,
etc. This requires existing scheduling mechanism in the cloud to have an
extension for this interaction. Now same thing needs to be done for TDX.
IBM SEID doesn't have scarcity of this resource but they are also
interested in tracking and limiting the usage. Each one coming up with
their own interaction is a duplicate effort when they all need similar
thing. One can say that abstraction should be at KVM level but these
resources can be used outside VM as well.

Most of the cloud infrastructure use cgroups for knowing the host state,
track the resources usage, enforce limits on them, etc. They use this
info to optimize work allocation in the fleet and make sure no rogue job
consumes more than it needs and starves other. Adding these resources
to cgroup is a natural choice with least friction. Cgroup itself says it
is a mechanism to distribute system resources along the hierarchy in a
controlled mechanism and configurable manner. Most of the resources in
cgroups are abstracted enough but their are still resources which are
not abstract but have limited availability or have specific use cases.

> 
> In the previous discussion, I saw the reasoning for the list of the
> resources to be hardwired in the controller itself in order to get some
> scrutiny of possible changes. That makes sense to me. But with that, is
> it necessary to commit to the new controller API via EXPORT_SYMBOL? (I
> don't mean this as a licensing question but what the external API should
> be (if any).)

As per my understanding this is the only for way for loadable modules
(kvm-amd in this case) to access Kernel APIs. Let me know if there is a
better way to do it.

> 
> Besides the generic remarks above, I'd still suggest some slight
> implementation changes, posted inline to the patch.

I will work on them.

I appreciate you guys taking out time and helping me out with this patch
series.

Thanks
Vipin
