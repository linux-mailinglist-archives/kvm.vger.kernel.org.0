Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6E433AE8
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhJSPoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhJSPoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 11:44:19 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B46C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:42:05 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u5so6937417ljo.8
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+siEuSa+WJS75qSN0RpdHUMGuy5oBwzzmiWqMaEMuPs=;
        b=pQERdD5nUQPjtLansM70NTxO+0b2qTozpDkpxrIOccRNdx92Apbk596hBAT6w3aMiG
         u4j/LqsgHx8YgTX60We0/gkJTzZ6WzHCGuZs2AIO4ZYM/XeiHXPdeblO0YwKiGy5Qa/W
         jkTA0pHMxDPi3SEKywafQl5fio6bLgWDzOFad8ZFYEcrDgR6XZFkKUCVvUH+SZPRGXdH
         7TWAfXzqj+yCfoTC0lO4OhXcU8l+BpuPkkCNzd8szQroeryK67ZymNb1mRJ2zVeBeMyE
         oACHdT8f8h8SltYC1ZEFCX4477F9/pEVnnqIpWr5Was1xLbtlG3k4et/GFW5yn+/rHSZ
         rCqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+siEuSa+WJS75qSN0RpdHUMGuy5oBwzzmiWqMaEMuPs=;
        b=gR56IXQJ0Vc2cRXNgDVDMmqZ94bSGl3W8JtQD7kB2YQxgWjawUXE+05ej244xrjc5r
         zWjqjMiDNa5ymad3f6dAiCLrRlD9XEMZNqUvO5BVAafYyqfRJ0iogK2nx8Tl+H0OYXXR
         sTh9VXV5sr85MNHfdN0BUvNU/Y6h8rm/y2etttJ7pK0+3kA6stAmYSHs/n9qYRGCptQQ
         OmONrCatBMyzCEv0yBya9rAakF71kn1uKuT0xfwMHWShykVlS66fFns6/37gyN23o/dw
         dmIg84wzok0RHCce7L5XDywACASAEyu3Y+/ypReEiiMdCYnZhzDVVsXDcNmwe3hKXWoF
         Ul6Q==
X-Gm-Message-State: AOAM530GEAw/zWdiYZj+s53SIWWcLe+FORs93Jnp+f/XAKWa5JR9hAio
        dks1GkVgqO25rF16ZryNhd0LMBUi5GGXWSh8toyzXQ==
X-Google-Smtp-Source: ABdhPJycBomzQY6404BBSVeaKo0fPDsTR2GIxvbSVRXPqVQk7Srg23I+zHCL1LEnHBi2/zX21QLCOrfkMQRN/hgLcjo=
X-Received: by 2002:a2e:6c0c:: with SMTP id h12mr7361810ljc.361.1634658124071;
 Tue, 19 Oct 2021 08:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211019000459.3163029-1-jingzhangos@google.com> <f7aa03ab-2067-be7f-06c0-1aad96e460a4@redhat.com>
In-Reply-To: <f7aa03ab-2067-be7f-06c0-1aad96e460a4@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 19 Oct 2021 08:41:37 -0700
Message-ID: <CALzav=d-CnScgY4zonVXj1_6B48b_asf3PB1eEk1Ds0H6aKOog@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: stats: Decouple stats name string from its field
 name in structure
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 8:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/10/21 02:04, Jing Zhang wrote:
> > There are situations we need to group some stats in a structure (like
> > the VM/VCPU generic stats). Improve stats macros to decouple the
> > exported stats name from its field name in C structure. This also
> > removes the specific macros for VM/VCPU generic stats.
>
> Do you have other uses in mind than generic stats?

Yeah we have stats internally (that are in our queue to send upstream
:) which store stats in sub-structs so that we can compute the same
stats in multiple ways (e.g. snapshot vs. cumulative). When Jing was
upgrading these stats from our internal API to the fd-based API I
suggested breaking out the name to keep the stat names consistent
across the upgrade. Then we noticed this would also clean up the
VM/VCPU_GENERIC stuff as well.


> I didn't like the
> "generic" macros very much either, but not being able to use "#" at all
> is also not nice.
>
> Paolo
>
