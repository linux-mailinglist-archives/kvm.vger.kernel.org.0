Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59037725B57
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 12:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbjFGKOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 06:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbjFGKOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 06:14:01 -0400
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0597C1BCA;
        Wed,  7 Jun 2023 03:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.es; i=@amazon.es; q=dns/txt; s=amazon201209;
  t=1686132840; x=1717668840;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=G7tXsJgQL2dp1Z2qVO87BdtC4KV1AU/HrZ3Nz1hNKas=;
  b=YVOc384QUkESg2au1r+BPK4t8H9aHW0DRDoU6+TP1GTxzzaS1/aJz74H
   d/nuI3P3zJBmbSBk8hKqR06B7u2a4HYaMNyQYFXYWhW14cKK9sgJemjCD
   lKI8QiBamQu9cq0ogwBD7RSEUopvCKnnPkwqthownUF2G1rq/4IBTRd64
   M=;
X-IronPort-AV: E=Sophos;i="6.00,223,1681171200"; 
   d="scan'208";a="589390051"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 10:13:57 +0000
Received: from EX19D001EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 4964C803BC;
        Wed,  7 Jun 2023 10:13:56 +0000 (UTC)
Received: from EX19D037EUB003.ant.amazon.com (10.252.61.119) by
 EX19D001EUA001.ant.amazon.com (10.252.50.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 10:13:53 +0000
Received: from [192.168.30.121] (10.1.212.27) by EX19D037EUB003.ant.amazon.com
 (10.252.61.119) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 7 Jun
 2023 10:13:49 +0000
Message-ID: <150e1ad0-3d59-762b-6032-897d5630a3bf@amazon.es>
Date:   Wed, 7 Jun 2023 12:13:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Alexander Graf <graf@amazon.de>,
        "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com>
Content-Language: en-US
From:   Babis Chalios <bchalios@amazon.es>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2023
In-Reply-To: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.1.212.27]
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D037EUB003.ant.amazon.com (10.252.61.119)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/5/23 11:55, Paolo Bonzini wrote:
> Hi all!
>
> We are planning on submitting a CFP to host a KVM Microconference at
> Linux Plumbers Conference 2023. To help justify the proposal, we would
> like to gather a list of folks that would likely attend, and crowdsource
> a list of topics to include in the proposal.
>
> For both this year and future years, the intent is that a KVM
> Microconference will complement KVM Forum, *NOT* supplant it. As you
> probably noticed, KVM Forum is going through a somewhat radical change in
> how it's organized; the conference is now free and (with some help from
> Red Hat) organized directly by the KVM and QEMU communities. Despite the
> unexpected changes and some teething pains, community response to KVM
> Forum continues to be overwhelmingly positive! KVM Forum will remain
> the venue of choice for KVM/userspace collaboration, for educational
> content covering both KVM and userspace, and to discuss new features in
> QEMU and other userspace projects.
>
> At least on the x86 side, however, the success of KVM Forum led us
> virtualization folks to operate in relative isolation. KVM depends on
> and impacts multiple subsystems (MM, scheduler, perf) in profound ways,
> and recently we’ve seen more and more ideas/features that require
> non-trivial changes outside KVM and buy-in from stakeholders that
> (typically) do not attend KVM Forum. Linux Plumbers Conference is a
> natural place to establish such collaboration within the kernel.
>
> Therefore, the aim of the KVM Microconference will be:
> * to provide a setting in which to discuss KVM and kernel internals
> * to increase collaboration and reduce friction with other subsystems
> * to discuss system virtualization issues that require coordination with
> other subsystems (such as VFIO, or guest support in arch/)
>
> Below is a rough draft of the planned CFP submission.
>
> Thanks!
>
> Paolo Bonzini (KVM Maintainer)
> Sean Christopherson (KVM x86 Co-Maintainer)
> Marc Zyngier (KVM ARM Co-Maintainer)
>
>
> ===================
> KVM Microconference
> ===================
>
> KVM (Kernel-based Virtual Machine) enables the use of hardware features
> to improve the efficiency, performance, and security of virtual machines
> created and managed by userspace.  KVM was originally developed to host
> and accelerate "full" virtual machines running a traditional kernel and
> operating system, but has long since expanded to cover a wide array of 
> use
> cases, e.g. hosting real time workloads, sandboxing untrusted workloads,
> deprivileging third party code, reducing the trusted computed base of
> security sensitive workloads, etc.  As KVM's use cases have grown, so too
> have the requirements placed on KVM and the interactions between it and
> other kernel subsystems.
>
> The KVM Microconference will focus on how to evolve KVM and adjacent
> subsystems in order to satisfy new and upcoming requirements: serving
> guest memory that cannot be accessed by host userspace[1], providing
> accurate, feature-rich PMU/perf virtualization in cloud VMs[2], etc.
>
>
> Potential Topics:
>   - Serving inaccessible/unmappable memory for KVM guests (protected VMs)
>   - Optimizing mmu_notifiers, e.g. reducing TLB flushes and spurious 
> zapping
>   - Supporting multiple KVM modules (for non-disruptive upgrades)
>   - Improving and hardening KVM+perf interactions
>   - Implementing arch-agnostic abstractions in KVM (e.g. MMU)
>   - Defining KVM requirements for hardware vendors
>   - Utilizing "fault" injection to increase test coverage of edge cases
>   - KVM vs VFIO (e.g. memory types, a rather hot topic on the ARM side)
>
>
> Key Attendees:
>   - Paolo Bonzini <pbonzini@redhat.com> (KVM Maintainer)
>   - Sean Christopherson <seanjc@google.com>  (KVM x86 Co-Maintainer)
>   - Your name could be here!
>
> [1] 
> https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com
> [2] 
> https://lore.kernel.org/all/CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com
>

Hi Paolo,

I think this idea is great!

On our side, we 've been working on providing ways to let VMs (kernel 
and user space)
know that they have been cloned/snapshotted/restored from snapshots[1].

This is tightly coupled with PRNGs both in kernel and user space and 
there needs to be some
collaboration with random.c to tie everything together [2][3]. It sounds 
like it could be a good
fit for this MC (?).

It would be interested to figure out whether such notifications would be 
interested to other
parts of the kernel as well.

Cheers,
Babis

[1] https://www.spinics.net/lists/kernel/msg4808187.html
[2] 
https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg09016.html
[3] 
https://lore.kernel.org/lkml/65d872db2e1be29bb03b43ed606e7cc9e74ec08d.camel@infradead.org/T/
