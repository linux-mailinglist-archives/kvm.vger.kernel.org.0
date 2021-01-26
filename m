Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68C305C0B
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313966AbhAZWvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbhAZWBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 17:01:50 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E15C06174A;
        Tue, 26 Jan 2021 14:01:06 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id x81so14730873qkb.0;
        Tue, 26 Jan 2021 14:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MIH2UNLi2fhCMoMNiRx154+VpM0NIRieyzpHxs5Dshw=;
        b=DEjU2Vlz+c8s8l7i4VvNrOHrZX1BFA/CoCHLraoX/TGR7m7IOU/Tk+tMXGz2Ie8kVj
         NRrXxn6RiYvZpVsXxyW2ANxFvOjsPw4fYgILW+Q5wT0h4ekogKQAo1eKS1P77lgKI3nI
         1mkQ+1lcbvQhLF8LTabfIIo+NAgLtSI25NYjLc4f8IcvqpFBJSRSI43sJ5oVpm02n96D
         QVU/+8yE+q/cn9U/oK+XTtYMJXq+KdR1HO8fMUu0+7yHtjfPTvUZedtrUjvG7fCSneZs
         e9r9Ve3hIZgRPOpS/7mGJOTQ3Etujv//AbXyOlHj1gMJpEg1TnivcCjUgu+u+sloivxz
         wPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MIH2UNLi2fhCMoMNiRx154+VpM0NIRieyzpHxs5Dshw=;
        b=d/+dpZBRwpV39dm8EzskT6p0ZDamIMjc17bYtgk+i8QCBZxWhDDIbZzrmBLfRpPRah
         gTjm3cXaMkM2XO8wFzmWkQ0cZlpmTl9xDlUGL18UrCsvNROcc3NS0NRD82u4wcFSRLfd
         Gp8tCSlVCARYlqSwjAIQWiRbiTgB/olGXUrfgq8BgHStjIJgytzZrgK+OK7TSbhltRfg
         TiayRUtdw1XHxc9WoeQ/JmkNEuSSZdTa8CtpBhpUfnJxVo6uPlzlgjLO99uvMkBquOo3
         CCiKC8woPe7ugKfjCqerzqksCT+SIoT9Q8GKPV27u5N1SE+qUhAMQTk5GYViOYEKSwwQ
         JbhQ==
X-Gm-Message-State: AOAM531m3KGh0bxj/2ebS+RKlojNjTpXXNHon96rAOtsS2bYERvVuWR2
        9uV7mqRTanbr+kunlgoFWkc=
X-Google-Smtp-Source: ABdhPJxCGoD28UZpYnoVrJkVxaNC0LAX7DFLMqKvCIyNhqeE9W8d95d/tnyrGdZGdIdjcWjqWJOcbA==
X-Received: by 2002:a37:9f55:: with SMTP id i82mr6102308qke.205.1611698465257;
        Tue, 26 Jan 2021 14:01:05 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id q92sm13832qtd.92.2021.01.26.14.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:01:04 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 26 Jan 2021 17:01:04 -0500
From:   Tejun Heo <tj@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>,
        "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YBCRIPcJyB2J85XS@slm.duckdns.org>
References: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Jan 26, 2021 at 12:49:14PM -0800, David Rientjes wrote:
> > SEV-SNP, another incremental enhancement (on SEV-ES), further strengthens the
> > argument for SEV and SEV-* coexistenence.  SEV-SNP and SEV-ES will share the
> > same ASID range, so the question is really, "do we expect to run SEV guests and
> > any flavor of SEV-* guests on the same platform".  And due to SEV-* not being
> > directly backward compatible with SEV, the answer will eventually be "yes", as
> > we'll want to keep running existing SEV guest while also spinning up new SEV-*
> > guests.
> > 
> 
> Agreed, cloud providers will most certainly want to run both SEV and SEV-* 
> guests on the same platform.

Am I correct in thinking that the reason why these IDs are limited is
because they need to be embedded into the page table entries? If so, we
aren't talking about that many IDs and having to divide the already small
pool into disjoint purposes doesn't seem like a particularly smart use of
those bits. It is what it is, I guess.

> I'm slightly concerned about extensibility if there is to be an 
> incremental enhancement atop SEV-* or TDX with yet another pool of 
> encryption ids.  (For example, when we only had hugepages, this name was 
> perfect; then we got 1GB pages which became "gigantic pages", so are 512GB 
> pages "enormous"? :)  I could argue (encryption_ids.basic.*,
> encryption_ids.enhanced.*) should map to 
> (encryption_ids.legacy.*, encryption_ids.*) but that's likely 
> bikeshedding.
> 
> Thomas: does encryption_ids.{basic,enhanced}.* make sense for ASID 
> partitioning?
> 
> Tejun: if this makes sense for legacy SEV and SEV-* per Thomas, and this 
> is now abstracted to be technology (vendor) neutral, does this make sense 
> to you?

The whole thing seems pretty immature to me and I agree with you that coming
up with an abstraction at this stage feels risky.

I'm leaning towards creating a misc controller to shove these things into:

* misc.max and misc.current: nested keyed files listing max and current
  usage for the cgroup.

* Have an API to activate or update a given resource with total resource
  count. I'd much prefer the resource list to be in the controller itself
  rather than being through some dynamic API just so that there is some
  review in what keys get added.

* Top level cgroup lists which resource is active and how many are
  available.

So, behavior-wise, not that different from the proposed code. Just made
generic into a misc controller. Would that work?

Thanks.

-- 
tejun
