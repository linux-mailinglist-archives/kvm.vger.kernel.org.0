Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290242F8B06
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 04:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbhAPDpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 22:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPDpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 22:45:00 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E62C061757;
        Fri, 15 Jan 2021 19:44:19 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 186so13816963qkj.3;
        Fri, 15 Jan 2021 19:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/rrxaLl/1RYv52Tg0tmQaRL1KMmod/XpsPxJFkVknMw=;
        b=pNabNEooGioMTBokqWDJs4vPKzX6S2/DjTzFl3fopsSC+CcHCbpL9lL559Asbyt60E
         gWSrSZmHP5WIGcbDaHDs2xuEHm235/Dr8eiqMjj3SM2zjw8TCOats7USFDvUUHEbZwrC
         sUrCLnkSxnGEQC45/05qUT30+tf9LFuLN8utC/5DQ7KEAezjyk1R27XavvgXohBbftmg
         nwadR36gQdasHOIGPufBPtwJ3lFyKzGF8Xc36K0UMb+yd2SvYQh3XyEtkXNv9y7b2HXB
         giDPpmqTrqal1FaxZXlKkePNsvel6tULDXWt2XEo64T5+wOUvHPX+uoz4uC3htXu5ZCJ
         7egQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/rrxaLl/1RYv52Tg0tmQaRL1KMmod/XpsPxJFkVknMw=;
        b=Zo9B6oNKxjmFzfGFZ0V3pCRxV5WI5GcEu4M41MFFezLQm9ylInDGx6S0yVlKSA0rPR
         hJ7NLBmk9hZa76kY0XnUf+xhXO8elfErvmGrPxsF3KfDcRs+c7FnsIYY007nAvZaxR4r
         4/eZoXy/jCli6Kb9IAF6dBzOr9n3SDo7iKzfl2Dgwyk8xTStH2IPh0D0oAinakoUvXuB
         FlWqgoaLHMy2fktFOaimEKullB/Pu6daIaQRLBxvIFo2dUqj2iTpFuh2CaUihWhM9mGE
         hsNoq510js9l6n848LVzd8tXQRZm5y0uVe5XEzQzel2IYSXZDdVuHX5Y8hVMoCxSq5wF
         5DlA==
X-Gm-Message-State: AOAM530+swOTqo9slrDaQ9jOEYQYXIOunG3MJSwmBI2VmYxuEuID6TBb
        9mVmczv9/q5tdDt5azraW+E=
X-Google-Smtp-Source: ABdhPJynVqU/CwTbgp1vs2jPStddCiUYSDME4g3C5qJEBj3otsVC9Wrvh9NZpdISEi/cZFMawOHo0w==
X-Received: by 2002:a05:620a:f92:: with SMTP id b18mr15760892qkn.146.1610768658824;
        Fri, 15 Jan 2021 19:44:18 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-433a-72fa-020f-de4e.res6.spectrum.com. [2603:7000:9602:8233:433a:72fa:20f:de4e])
        by smtp.gmail.com with ESMTPSA id b15sm6235254qta.75.2021.01.15.19.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 19:44:17 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 15 Jan 2021 22:43:32 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAIUwGUPDmYfUm/a@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 02:18:40PM -0800, Vipin Sharma wrote:
> > * Why is .sev a separate namespace? Isn't the controller supposed to cover
> >   encryption ids across different implementations? It's not like multiple
> >   types of IDs can be in use on the same machine, right?
> > 
> 
> On AMD platform we have two types SEV and SEV-ES which can exists
> simultaneously and they have their own quota.

Can you please give a brief explanation of the two and lay out a scenario
where the two are being used / allocated disjointly?

> > > Other ID types can be easily added in the controller in the same way.
> > 
> > I'm not sure this is necessarily a good thing.
> 
> This is to just say that when Intel and PowerPC changes are ready it
> won't be difficult for them to add their controller.

I'm not really enthused about having per-hardware-type control knobs. None
of other controllers behave that way. Unless it can be abstracted into
something common, I'm likely to object.

> > > +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> > > +{
> > > +	unsigned long flags;
> > > +	enum encryption_id_type type = seq_cft(sf)->private;
> > > +
> > > +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> > > +
> > > +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> > > +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> > 
> > Dup with .current and no need to show total on every cgroup, right?
> 
> This is for the stat file which will only be seen in the root cgroup
> directory.  It is to know overall picture for the resource, what is the
> total capacity and what is the current usage. ".current" file is not
> shown on the root cgroup.

Ah, missed the flags. It's odd for the usage to be presented in two
different ways tho. I think it'd make more sense w/ cgroup.current at root
level. Is the total number available somewhere else in the system?

Thanks.

-- 
tejun
