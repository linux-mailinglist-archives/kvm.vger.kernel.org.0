Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC6C3EE08E
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhHPXy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 19:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhHPXy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 19:54:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CDCC061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 16:53:54 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b7so16225374iob.4
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 16:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6rnzdttRGmDpc4upKuRPK555MR67/vxvccDJI40Fjqc=;
        b=F/iM0Qx/CKI/qoIkfwF7bo2W1QE88wd1HUh9CFFxfgaSJVUK/LjcFPKvvwG+dSbFeJ
         1pzn99wwud+I+RxXT1XGhocWCY9oIakvWla6Pcolj5GmtRsw7NZbzMoNKZSGs93AD/0K
         A1KrzDx2OH6b4Db7r2IMm8C0iVB12mlLfaq0k44TtEeDTpAA6diNHGnQHQ1PxTAGjK5n
         KOTBzyKcYKFs++I7hRBrxmP8hG1PjmZX3yMh3rR+OBb4vFomNYr6zGcedWmuaRpvFtTI
         xtiLUI+PsffB5E7AMkE27VyVj5R8qOlH9MY8MtsYbfcj6NWX6qZ+3hMTdrDh9fCshHuh
         r6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6rnzdttRGmDpc4upKuRPK555MR67/vxvccDJI40Fjqc=;
        b=JDlX8Nd3K6+J8zmm7vh03I81RqxImuNamCFXjKPG8BLymSToDKQpOZ4EBBTLh7NFO9
         6tRzqntfLCk/drlcsLlNrAk0VpmHhDJc9qh5Jrp5wt5W1G9lPVJAhHDDLM1jkV+7qgej
         6elJCzk7/ofM7cloDedi7GxlICoS6NPV+Gc9WPkuj1RtKKCh4AycM9DEExvCqrPNVa1u
         JAttQMfXe/g//o8WfX/ruE34e0B8+L5vnRlBA6SuKlAo35se4Nc2Jzgl+6XzsV4OqgjS
         S9HghiXkEUZx17zIOd7ii4p2yWQg/VjiBGsZCmuydF6zd5ZOVPLOS0ExnOq3Ka3kNw8a
         em4g==
X-Gm-Message-State: AOAM533zsURsadZGUNgZm2nywvLlwLWvB2mewcHU+JZuRhUcvE+0wd74
        mi0v8W6FymUaVKjTqNkF6NSDZIP74MGOLzMlp5zEgQ==
X-Google-Smtp-Source: ABdhPJxeWwQ+w4zWPBYIqBeuwHefu/YNIr0LXVlgvLDyAYp4yNz4ttC1Ks8VXzvus2helXAwOYuoVoB8VT0g8ZmUzCQ=
X-Received: by 2002:a02:1942:: with SMTP id b63mr371548jab.111.1629158034133;
 Mon, 16 Aug 2021 16:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com>
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 16 Aug 2021 16:53:17 -0700
Message-ID: <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 6:37 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> This is an RFC series for Mirror VM support that are
> essentially secondary VMs sharing the encryption context
> (ASID) with a primary VM. The patch-set creates a new
> VM and shares the primary VM's encryption context
> with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> The mirror VM uses a separate pair of VM + vCPU file
> descriptors and also uses a simplified KVM run loop,
> for example, it does not support any interrupt vmexit's. etc.
> Currently the mirror VM shares the address space of the
> primary VM.
Sharing an address space is incompatible with post-copy migration via
UFFD on the target side. I'll be honest and say I'm not deeply
familiar with QEMU's implementation of post-copy, but I imagine there
must be a mapping of guest memory that doesn't fault: on the target
side (or on both sides), the migration helper will need to have it's
view of guest memory go through that mapping, or a similar mapping.

Separately, I'm a little weary of leaving the migration helper mapped
into the shared address space as writable. Since the migration threads
will be executing guest-owned code, the guest could use these threads
to do whatever it pleases (including getting free cycles). The
migration helper's code needs to be trusted by both the host and the
guest. Making it non-writable, sourced by the host, and attested by
the hardware would mitigate these concerns. The host could also try to
monitor for malicious use of migration threads, but that would be
pretty finicky.  The host could competitively schedule the migration
helper vCPUs with the guest vCPUs, but I'd imagine that wouldn't be
the best for guest performance.


--Steve
