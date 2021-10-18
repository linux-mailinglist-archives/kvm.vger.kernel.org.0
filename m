Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2853431933
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhJRMgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhJRMgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 08:36:42 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84940C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 05:34:31 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so1282616ote.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1pbSkqWxiSZgJ8e5OjIcgFH/1bBQSml1rT02P7vRiI8=;
        b=Mgez5oeoSkR2Rfz90An/K8bMShcEt62O9xMJHG2RoiYEVmzfIBQxHJ4d5vdTZ6v31H
         L0IT059zRHYOmef8sJmO1oflziQY7bbPRfhrja6d7dtbka+dM6x6L8/4FQOfHwB26wdv
         kY7Gh2SM5lI9RuTLn0YbJB9veeZN+M3KRADX5Yv1nSFP5i99IGPTCpAC5P0T7Wt9HtuN
         uNmuTJkg4ag9DNYfCqh9pbvTVWwOx6ZiLp1tKrtkJs3JcmYE6DxAi+M/E8NdiyFFVRwY
         LXRR+V84Bqp2JG2NInoUALz+Q5xh7vVpNXCVVZpk8JAD8PYdsSzJUQfE30kYhpzXQ/Lm
         ne3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1pbSkqWxiSZgJ8e5OjIcgFH/1bBQSml1rT02P7vRiI8=;
        b=RAHHZN8poPN9TmXqHfDHQC0PRWUVWLWrHtfuuuE6kQj5v8XQHD4ah0s1LTjysW+qJ8
         p8lAQxm8azoJNjmL//hTo/BkZkvcmrV8HSQOkWowSlJxvLUWrTfyfBGfOG6cwm5HIU43
         DPkFADUHZ+s+bYLWZ4I8zSjiMZTaafThSnh/n0BrX9MoqOer4Pe7g1eCWX4kqXnnm6+/
         7rXO6xe4bI275Z2iF3x3KSgER+jT4wp6btPuP4zhy3IUzpPVPDJZODmelLerpOWqCG8f
         O7mveUyYuXO3bwqILYK//Fs4MlMMy97t0DJook52cLNVYmd9k0O6RXcum5NZtPevCC/Y
         e3lw==
X-Gm-Message-State: AOAM533dgdM2+OIsH+8UekJRS3wKAkeEv5F27gzIl9ary9yRobb8Dlbk
        De+NlyZQgPvIGRvc8F4cb0qw3/CNLbbIsRneYXryRg==
X-Google-Smtp-Source: ABdhPJwmLCo4x7wGytVHP4ezHwU7qhNTDaKBXu8Z84dYPzNngqLyw3XKmfneyTsFw7kja67groR2U7W6EsbitXQCZTU=
X-Received: by 2002:a05:6830:210c:: with SMTP id i12mr21214780otc.102.1634560470718;
 Mon, 18 Oct 2021 05:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-12-tabba@google.com> <20211013120346.2926621-1-maz@kernel.org>
 <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com> <20211018104505.52jvpuhxkbstzerg@gator.home>
In-Reply-To: <20211018104505.52jvpuhxkbstzerg@gator.home>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 18 Oct 2021 13:33:54 +0100
Message-ID: <CA+EHjTyDMMMp_jzdfL-OUoBv0YU8pbxMnCu4vErVCex7wHa6bw@mail.gmail.com>
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Oct 18, 2021 at 11:45 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 18, 2021 at 10:51:54AM +0100, Fuad Tabba wrote:
> > Hi Marc,
> >
> > On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > This is an update on Fuad's series[1].
> > >
> > > Instead of going going back and forth over a series that has seen a
> > > fair few versions, I've opted for simply writing a set of fixes on
> > > top, hopefully greatly simplifying the handling of most registers, and
> > > moving things around to suit my own taste (just because I can).
> > >
> > > I won't be reposting the initial 11 patches, which is why this series
> > > in is reply to patch 11.
> >
> > Thanks for this series. I've reviewed, built it, and tested it with a
> > dummy protected VM (since we don't have proper protected VMs yet),
> > which initializes some of the relevant protected VMs metadata as well
> > as its control registers. So fwiw:
> >
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> >
> > And to whatever extent possible at this stage:
> > Tested-by: Fuad Tabba <tabba@google.com>
> >
>
> Hi Fuad,
>
> Out of curiosity, when testing pKVM, what VMM do you use? Also, can you
> describe what a "dummy pVM" is? Is it a just pVM which is not actually
> protected? How similar is a pVM to a typical VIRTIO-using VM? Actually,
> maybe I should just ask if there are instructions for playing with pKVM
> somewhere that I could get a pointer to.

Considering the WIP state of pKVM, my setup is hacky and not that
stable. I use QEMU, along with Will'ls pKVM user ABI patches [*] and a
couple of hacks added on top to run a normal VM with the protected
codepath applied to it, to be able to do some testing and sanity
checking. There isn't really any proper way of playing with protected
VMs yet.

Thanks,
/fuad

[*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

> Thanks,
> drew
>
