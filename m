Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97960321D41
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhBVQmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhBVQlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 11:41:23 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22056C06174A
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 08:40:43 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id d24so6699280lfs.8
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=dUJJMpAGKGo8HRpjRwpwydLIj3FkS0MLnsKzd8YFmro=;
        b=kfJWtINjCcO+Zu6gLW43xnxvzkYhggILERV1ml820MsNt5ddkRQ+nDSrgOAYx4dm0R
         hSDbG5iiz3KJ7ilz6A1ndHOajvgAbbXdVwtrz6I6yclF7AojhqzcoKmdtKeV2/iEwofZ
         aOo9me47PWI/NxTqzCSIZOenKriN19HAEt9nLDodWv3SGJ0C9t5/hI2oxikMl7fwj4Kn
         gmRNl27KdX16ZgQ0rM1pnmRCL+W5YFlGcQ53FsTBVHpdyaZzO4htCOxYqZ5wYYUWkpAi
         ZvcKNqLOixh+m2uM6tJOg8gW7IPbeITlleYjQOyC3kBD1mK05Z182xNK3x1/lDONB5Zx
         Tfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dUJJMpAGKGo8HRpjRwpwydLIj3FkS0MLnsKzd8YFmro=;
        b=brGVz04Ysx+IHQYnOysaLDGQkCpSNUCxVDiFn4ictOafbHwX4rD8V3rS+UQMCPjtdp
         BR9+46aXHQs9gf6CFzwf0zB1kZS5JSS2ykCmrbGpDe4jLJPDGtV5jQzr0YZoi0HRER+l
         yB+pxw1MIDWwOHr+Hyl51qh2acvwHNY7JD7Z6Yg+DrXRovd8OPEchjrkniPX3YVMSwc+
         QAC68vs4DjPaFQ3I8T9fJnxhbYx17CLOKy0bXLpeGNBTCR+7mpnGmhu/GU8b0eBgJ+S3
         hwX7ThkWG9dU9eY91GK7ZxzwJfh+zGgeS3+RHV4xzXXyMBjW5YT00CBOPm5sYxZEiaMA
         gOoQ==
X-Gm-Message-State: AOAM530kMKffXIMCpMtCL/K7z3UNidbC0YZYtWFOJbwE6qYsnQW0X477
        6mKfsbNi0pAV0ZGdaZXR6pk=
X-Google-Smtp-Source: ABdhPJypFE6vh1Cw7yWJ0D4WXOwTgEM/Mbuw/QYqK0wpfizKmnHAxVfYUcslkih9RD6v5ipbZPEuvQ==
X-Received: by 2002:a19:810c:: with SMTP id c12mr14737671lfd.244.1614012041520;
        Mon, 22 Feb 2021 08:40:41 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id o16sm1163569lfn.252.2021.02.22.08.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 08:40:41 -0800 (PST)
Message-ID: <2690c9daa9127a55bef0daa2a4d83688a2b396d1.camel@gmail.com>
Subject: Re: [RFC v3 0/5] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, jasowang@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
Date:   Mon, 22 Feb 2021 08:40:28 -0800
In-Reply-To: <8fc8eae6-7bea-9333-47cb-e49cf86fa336@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <8fc8eae6-7bea-9333-47cb-e49cf86fa336@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2021-02-21 at 18:06 +0100, Paolo Bonzini wrote:
> On 21/02/21 13:04, Elena Afanasova wrote:
> > This patchset introduces a KVM dispatch mechanism which can be used
> > for handling MMIO/PIO accesses over file descriptors without
> > returning
> > from ioctl(KVM_RUN). This allows device emulation to run in another
> > task
> > separate from the vCPU task.
> > 
> > This is achieved through KVM vm ioctl for registering MMIO/PIO
> > regions and
> > a wire protocol that KVM uses to communicate with a task handling
> > an
> > MMIO/PIO access.
> > 
> > TODOs:
> > * Implement KVM_EXIT_IOREGIONFD_FAILURE
> > * Add non-x86 arch support
> > * Add kvm-unittests
> > * Flush waiters if ioregion is deleted
> 
> Hi ELena,
> 

Hi Paolo,

Thank you for your answer.

> as a quick thing that jumped at me before starting the review, you 
> should add a test for the new API in tools/testing/selftests/kvm, as 
> well as documentation.  Ideally, patch 4 would also add a testcase
> that 
> fails before and passes afterwards.
> 
Ok

> Also, does this work already with io_uring?
> 
I have a few kvm-unittests and QEMU testdev patch for testing base
functionality. I haven't tried to run them with io_uring (only run with
socket and pipes). Will do.

> Paolo
> 
> > v3:
> >   - add FAST_MMIO bus support
> >   - add KVM_IOREGION_DEASSIGN flag
> >   - rename kvm_ioregion read/write file descriptors
> >   - split ioregionfd signal handling support into two patches
> >   - move ioregion_interrupted flag to ioregion_ctx
> >   - reorder ioregion_ctx fields
> >   - rework complete_ioregion operations
> >   - add signal handling support for crossing a page boundary case
> >   - change wire protocol license
> >   - fix ioregionfd state machine
> >   - remove ioregionfd_cmd info and drop appropriate macros
> >   - add comment on ioregionfd cmds/replies serialization
> >   - drop kvm_io_bus_finish/prepare()
> > 
> > Elena Afanasova (5):
> >    KVM: add initial support for KVM_SET_IOREGION
> >    KVM: x86: add support for ioregionfd signal handling
> >    KVM: implement wire protocol
> >    KVM: add ioregionfd context
> >    KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
> > 
> >   arch/x86/kvm/Kconfig          |   1 +
> >   arch/x86/kvm/Makefile         |   1 +
> >   arch/x86/kvm/vmx/vmx.c        |  40 ++-
> >   arch/x86/kvm/x86.c            | 273 +++++++++++++++++-
> >   include/linux/kvm_host.h      |  28 ++
> >   include/uapi/linux/ioregion.h |  30 ++
> >   include/uapi/linux/kvm.h      |  25 ++
> >   virt/kvm/Kconfig              |   3 +
> >   virt/kvm/eventfd.c            |  25 ++
> >   virt/kvm/eventfd.h            |  14 +
> >   virt/kvm/ioregion.c           | 529
> > ++++++++++++++++++++++++++++++++++
> >   virt/kvm/ioregion.h           |  15 +
> >   virt/kvm/kvm_main.c           |  36 ++-
> >   13 files changed, 996 insertions(+), 24 deletions(-)
> >   create mode 100644 include/uapi/linux/ioregion.h
> >   create mode 100644 virt/kvm/eventfd.h
> >   create mode 100644 virt/kvm/ioregion.c
> >   create mode 100644 virt/kvm/ioregion.h
> > 

