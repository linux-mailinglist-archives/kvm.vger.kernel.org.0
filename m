Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E83A682D
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhFNNmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:42:11 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:35411 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhFNNmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:42:06 -0400
Received: by mail-lj1-f169.google.com with SMTP id n17so20276059ljg.2
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwXVBisdJjThQGclWp6IXCFWn4jZGyH9ozIVniD3KMs=;
        b=Sfnahi+pG4f+QayKKfpg1VM9f1f/aavyhFB9lV4TW7kVp8kgwXwutKZgf8qxz/lUHO
         lMF1eyk+OUeIfEflL2EVp7oOntvNTW4LR2xdgfo10unS7HOrbD/JfqvVvE65tdtNURq3
         cWjf08IDH/DHN/POTRHR+exPljpQFlQagIGlpaFpZGCbIGxW37FFXdAJ24/hrWm4l1f2
         3S+64Qxp+3t/WL/Nkn6sjpuboNlGonNj//y/G4zguiIgohLGREJhMkKuaVzxUvB3Vpm0
         66uiv+f1PifS8I+j8o9hts2k1EwrzNpReCSpsWIPLf3JP/VAkc3BYSjJLmrmllFTpLpo
         pDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwXVBisdJjThQGclWp6IXCFWn4jZGyH9ozIVniD3KMs=;
        b=OWXEdYNek2ZY1CThVN0PkCsrEZ44aKesh0ANx1eIYc6p5m3gvdoaRv2fPkCi+9a9K/
         63ub1VpvYwhXKI50+AQEebuVJDAmUPtSkexRvL0dfF+stEWLLAYYqPd6mcnTsWmEh5O9
         0RIVBpOEj5Z7NVKL8+k4o6gZyauHxKd72NhsRtMK5BRY1v3jU29pLIADXOfyYjZnA04G
         BIzBg+yJC8Yp8Ricx0pm4/UO/Yudb/3nMBiWm7pOvmlihOpWx8RPzGtfSs4OHoV7uya2
         PxNXTkrwe6b5s+XKq94ZmYOIW+mOeWFcxxFUK50Qvmd+txWpeW5vEXJaLecGUpnsSW4+
         z7ZA==
X-Gm-Message-State: AOAM533BKGVBlASa1/L0IzsmEnisbm7eGPk5Z77udfAAjcxCC6pzPozy
        ZSwplvtpsh/8UnWRIDuKaMbfVMyKlbaV38RzFyKSQA==
X-Google-Smtp-Source: ABdhPJxvc1pwRawgj0zOcL4Ijt7TpwUjNPqVQwwwwNAeptDw/nWdJwRIpcLx7ajZLxmfXVy2goAh+tpIPcpdk7YzAj8=
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr13317109lji.304.1623677928539;
 Mon, 14 Jun 2021 06:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com> <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
In-Reply-To: <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 14 Jun 2021 08:38:36 -0500
Message-ID: <CAAdAUtjxXmN0cG9EU55Pd1TFuED-itoUJQECv3_ab=8imkxMtQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Remove duplicated stats definitions for debugfs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 4:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/06/21 04:53, Jing Zhang wrote:
> > This is a follow-up patchset to binary stats interface patchset as below:
> > https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com
> >
> > This patchset contains a commit to fix some missing stats and add static
> > check to make sure we have the right number of stats descriptors and add an
> > 'offset' field in stats descriptor to make sure the or order of stats
> > descriptors is not relevant to the order of stats in vm/vcpu stats
> > structure. This will totally avoid the possibility of missing stats and
> > mismatched stats definitions.
> >
> > The binary stats interface defines stats in another array of descriptors,
> > while the original stats debugfs interface uses array of kvm_stats_debugfs
> > item. To remove the duplicated stats definition, this patchset would
> > utilize only the stats descriptors to provide stats information to debugfs
> > interface. This patchset adds a 'mode' flag to support the read/write mode
> > of stats, which can be used to indicate the file permission of debugfs
> > stats files. It removes the usage of kvm_stats_debugfs_item and all the
> > debugfs_entries defined in all archs.
> >
> > The patch also fixes an issue that read only stats could be cleared in
> > global level, though not permitted in VM level in the original debugfs
> > code.
>
> Thanks for putting this together quickly.  I think we can drop the mode,
> see the suggestion in patch 2.
>
> It's probably best to fold the v8 for the stats functionality, these
> patches (squashed appropriately) and Fuad's remars in a single posting.
>   But I'm quite confident that it can make it in 5.14.
>
> Paolo
>
Thanks. Will drop the mode, squash stats functionality with v8 and fold them
in another single posting (v9).

Jing
