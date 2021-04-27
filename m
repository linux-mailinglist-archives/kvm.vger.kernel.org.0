Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBE836BFB9
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 09:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhD0HFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 03:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237579AbhD0HFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 03:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619507080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vq5D1dmgYRhw7JEWpexSDaLKtPIBt7nneiJL3FVKCro=;
        b=HrkyXytnTq/THGJmE/qzAcOkE55yG814qVIGmA746VHVDKWSfet2e8SvsA8/S2Ui0axdr4
        egPWtAUq3Gf6WBASZOG+qJdBXRWk7116wOUyTqxfWxIirkq/8CVVG1OZQ2aMsr5h9YyGes
        fLemOmvLd55bC+sH4zl96ilEQizAjDY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-S1M749z1MMad2os0rNV6-Q-1; Tue, 27 Apr 2021 03:04:38 -0400
X-MC-Unique: S1M749z1MMad2os0rNV6-Q-1
Received: by mail-ej1-f70.google.com with SMTP id s23-20020a1709069617b02903907023c7c0so582832ejx.0
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 00:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vq5D1dmgYRhw7JEWpexSDaLKtPIBt7nneiJL3FVKCro=;
        b=HpdNWaJt6lYsOXhNEdIagJjxt46uNCRczf/nHntwIsvpRKffLqipo17f1Y9PCkM211
         hLbLb+7NCtAsG7Omao3g8qSWLDav0qklXA/yZIFPeAl95GZ4/Lz6CIIn81sB64iaNMXk
         ZyPT6FJIsU3sFLlCHZmeVi2rm1r0dAIKsfZfTs5IY7UiPyBEkIPWod3rDlPHTRIjHSyt
         gMZFMVK9+J9Ef3mgVqd9fsHibC8Oe4jqSZQvQtFn1LSfd8FQkTSL7PuW29Vzi9B3nWwi
         3V+TIbyFI9LlHvm6/LAYNpkrFhxDUsa/6geCWDHLTDhE7Mbe7Uu+Ugu8lIWqbH0SWnP5
         jL1Q==
X-Gm-Message-State: AOAM5300JRQ4DYcQiScckr+ooSdhc+MMn8D8cy43JWZSnMW1gcRyM9V/
        l6/G0cGt8Ahs2TO588KE4Q2RwkSeE3FendN6uzQ2BCYKl2AzGVrrO21UmIAYb0VSbuBjNK2waLW
        sqLGriAf+uM2F
X-Received: by 2002:a50:ed0c:: with SMTP id j12mr2629970eds.12.1619507077539;
        Tue, 27 Apr 2021 00:04:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyryIh5RBqbNIbHqf6VF9OAO773lSYnlUYuCt72W2NNb20FWbp7rRgDi3/azf8lhBiftuhROw==
X-Received: by 2002:a50:ed0c:: with SMTP id j12mr2629947eds.12.1619507077279;
        Tue, 27 Apr 2021 00:04:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p22sm1660354edr.4.2021.04.27.00.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 00:04:36 -0700 (PDT)
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
References: <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop>
 <5b988c4e-25e9-f2b9-b08d-35bc37a245e4@sifive.com>
 <CAAhSdy2g13XkeiG4-=0pHVw9Oq5zAeseM2LgxHf6daXD+qnc1Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d6e2b882-ae97-1984-fc03-2ac595ee56b4@redhat.com>
Date:   Tue, 27 Apr 2021 09:04:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2g13XkeiG4-=0pHVw9Oq5zAeseM2LgxHf6daXD+qnc1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/21 08:01, Anup Patel wrote:
> Hi Paolo,
> 
> Looks like it will take more time for KVM RISC-V to be merged under arch/riscv.
> 
> Let's go ahead with your suggestion of having KVM RISC-V under drivers/staging
> so that development is not blocked.
> 
> I will send-out v18 series which will add KVM RISC-V under the staging
> directory.
> 
> Should we target Linux-5.14 ?

Yes, 5.14 is reasonable.  You'll have to adjust the MMU notifiers for 
the new API introduced in 5.13.

Paolo

> Regards,
> Anup
> 
> On Tue, Apr 27, 2021 at 11:13 AM Paul Walmsley <paul.walmsley@sifive.com> wrote:
>>
>> On Fri, 9 Apr 2021, Palmer Dabbelt wrote:
>>
>>> On Wed, 31 Mar 2021 02:21:58 PDT (-0700), pbonzini@redhat.com wrote:
>>>
>>>> Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
>>>> drivers/staging/riscv/kvm?
>>>
>>> I'm certainly ready to drop my objections to merging the code based on
>>> it targeting a draft extension, but at a bare minimum I want to get a
>>> new policy in place that everyone can agree to for merging code.  I've
>>> tried to draft up a new policy a handful of times this week, but I'm not
>>> really quite sure how to go about this: ultimately trying to build
>>> stable interfaces around an unstable ISA is just a losing battle.  I've
>>> got a bunch of stuff going on right now, but I'll try to find some time
>>> to actually sit down and finish one.
>>>
>>> I know it might seem odd to complain about how slowly things are going
>>> and then throw up another roadblock, but I really do think this is a
>>> very important thing to get right.  I'm just not sure how we're going to
>>> get anywhere with RISC-V without someone providing stability, so I want
>>> to make sure that whatever we do here can be done reliably.  If we don't
>>> I'm worried the vendors are just going to go off and do their own
>>> software stacks, which will make getting everyone back on the same page
>>> very difficult.
>>
>> I sympathize with Paolo, Anup, and others also.  Especially Anup, who has
>> been updating and carrying the hypervisor patches for a long time now.
>> And also Greentime, who has been carrying the V extension patches.  The
>> RISC-V hypervisor specification, like several other RISC-V draft
>> specifications, is taking longer to transition to the officially "frozen"
>> stage than almost anyone in the RISC-V community would like.
>>
>> Since we share this frustration, the next questions are:
>>
>> - What are the root causes of the problem?
>>
>> - What's the right forum to address the root causes?
>>
>> To me, the root causes of the problems described in this thread aren't
>> with the arch/riscv kernel maintenance guidelines, but rather with the
>> RISC-V specification process itself.  And the right forum to address
>> issues with the RISC-V specification process is with RISC-V International
>> itself: the mailing lists, the participants, and the board of directors.
>> Part of the challenge -- not simply with RISC-V, but with the Linux kernel
>> or any other community -- is to ensure that incentives (and disincentives)
>> are aligned with the appropriately responsible parts of the community.
>> And when it comes to specification development, the right focus to align
>> those incentives and disincentives is on RISC-V International.
>>
>> The arch/riscv patch acceptance guidelines are simply intended to ensure
>> that the definition of what is and isn't RISC-V remains clear and
>> unambiguous.  Even though the guidelines can result in short-term pain,
>> the intention is to promote long-term stability and sustainable
>> maintainability - particularly since the specifications get baked into
>> hardware.  We've observed that attempting to chase draft specifications
>> can cause significant churn: for example, the history of the RISC-V vector
>> specification illustrates how a draft extension can undergo major,
>> unexpected revisions throughout its journey towards ratification.  One of
>> our responsibilities as kernel developers is to minimize that churn - not
>> simply for our own sanity, or for the usability of RISC-V, but to ensure
>> that we remain members in good standing of the broader kernel community.
>> Those of us who were around for the ARM32 and ARM SoC kernel accelerando
>> absorbed strong lessons in maintainability, and I doubt anyone here is
>> interested in re-learning those the hard way.
>>
>> RVI states that the association is open to community participation.  The
>> organizations that have joined RVI, I believe, have a strong stake in the
>> health of the RISC-V ecosystem, just as the folks have here in this
>> discussion.  If the goal really is to get quality specifications out the
>> door faster, then let's focus the energy towards building consensus
>> towards improving the process at RISC-V International.  If that's
>> possible, the benefits won't only accrue to Linux developers, but to the
>> entire RISC-V hardware and software development community at large.  If
>> nothing else, it will be an interesting test of whether RISC-V
>> International can take action to address these concerns and balance them
>> with those of other stakeholders in the process.
>>
>>
>> - Paul
> 

