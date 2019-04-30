Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F581F47B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfD3KtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:49:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45127 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfD3KtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:49:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so20401912wra.12
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 03:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=97TD+Q9Krb1tplLkNXM736KxS03CDwsZjp1RvZz2GVM=;
        b=FjKr6PUQ9jT85/B1ITKxf9AblSHVW0Jq9rpYIOUHFpNFTggWsltWrWByy7vD4GnKj+
         Uw6wUbr11+z/vFpPhCylWYx+Zbzysw1SSIbNHLg7yOwxAvA3CnrHTqo7+ObYt3mOl8lM
         uSATwqAgjAGFZ+O6A/fgwbx3c7zrQS5uRr4kh6HfZ2I8ys79c5zwRshTh5tzWMaXAxbu
         JPotoN9pt8KFu34TPxCnvxvBrDCgH13dgQSxWpO7PrI3X4TcGwRD8Wex/98spw//9eSv
         NrsRRakGP5Br8ORFxSK3XFxatgnpj6fjiqYYFHezQXyXgXNYXrz8V/eIsanO8aIU7YeJ
         1KIQ==
X-Gm-Message-State: APjAAAW2Xmu/l1qqg7cUlQwQYCYasO8/T+673sSmE6WstZGh/zbaD34W
        RJIKzTuzZ0NpzpMqsJITmFJNB6NkuGU=
X-Google-Smtp-Source: APXvYqy0WBnKLPsfdyTxu71kPcAAr0FhHvuvYa1anOSxeOn0Z/EMQU7w9v1Y5OMlMZyg0p+qDNo8Ow==
X-Received: by 2002:a5d:5092:: with SMTP id a18mr2360805wrt.112.1556621357060;
        Tue, 30 Apr 2019 03:49:17 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b11sm3993839wmh.29.2019.04.30.03.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 03:49:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Christopher Pereira <kripper@imatronix.cl>
Cc:     kvm@vger.kernel.org
Subject: Re: "BUG: soft lockup" and frozen guest
In-Reply-To: <ba7deff9-6a29-9514-642f-99b3f7cd8fe1@imatronix.cl>
References: <1798334f-3083-bb4d-410c-849dc306e6b2@imatronix.cl> <87muk958jn.fsf@vitty.brq.redhat.com> <ba7deff9-6a29-9514-642f-99b3f7cd8fe1@imatronix.cl>
Date:   Tue, 30 Apr 2019 12:49:15 +0200
Message-ID: <874l6f6a50.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christopher Pereira <kripper@imatronix.cl> writes:

> On April 29, 2019 7:56:44 AM AST, Vitaly Kuznetsov <vkuznets@redhat.com> 
> wrote:
>
>     Christopher Pereira <kripper@imatronix.cl> writes:
>
>         Hi, I have been experiencing some random guest crashes in the
>         last years and would like to invest some time in trying to debug
>         them with your help. Symptom is: 1) "BUG: soft lockup" & "CPU#*
>         stuck for *s!" messages during high load on the guest 2) At some
>         point later (eg. 12 hours later), the guest just hangs without
>         any message and must be destroyed / rebooted. I attached the
>         relevant kernel messages. Host (spec: Intel(R) Xeon(R) CPU
>         E5645) is running: kernel-3.10.0-327.el7.x86_64
>         libvirt-daemon-kvm-1.2.17-13.el7_2.5.x86_64
>         qemu-kvm-ev-2.3.0-31.el7_2.10.1.x86_64
>         qemu-kvm-common-ev-2.3.0-31.el7_2.10.1.x86_64 
>
>
>     This is pretty old stuff, e.g. kernel-3.10.0-327.el7 was release with
>     RHEL-7.2 (Nov 2015). As this is upstream mailing list, it would be great
>     if you could build an upstream kernel (should work with EL7 userspace)
>     and try to reproduce.
>
> Hi Vitaly,
>
> Yes, but it's a critical production environment and I haven't seen any 
> related patch in the kernel changelog since 3.10. We will try to upgrade 
> whenever possible.

It's hard to tell which changes may be related here (as, for example, I
also see nf_conntrack_* in your trace and the bug may as well be there)
but even in RHEL-7.2 updates (kernel-3.10.0-327.*) I can see several
dozed KVM commits (and there's several hundred between 7.2 and 7.6).

>
> I believe this bug could be related to overcommitting resources. Does 
> qemu-kvm throw any log message when resources are overcommited? Is there 
> some way to enable this?
>
> We have seen this happening one in a while in the last 4 years on 
> different production hardware and wanted to ask if this is a common 
> issue and how to address/debug this issue.


Define "resources" and "overcommit" ;-) In case you overcommit
CPUs/memory severily (like dozens/hundereds of vCPUs per pCPU, host
constantly swapping) guests may, of course, start to misbehave. In case
it is just a couple of vCPU per pCPU and the host is not swapping
guest softlockups are not normal.

In case there's no way to trigger the issue you may want to enable kdump
and set

sysctl -w kernel.softlockup_panic=1
sysctl -w kernel.softlockup_all_cpu_backtrace=1

and then inspect the crash dump.

-- 
Vitaly
