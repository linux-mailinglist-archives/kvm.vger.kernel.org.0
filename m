Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7CE4412C1
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 05:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhKAEhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 00:37:52 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:54380
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhKAEhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 00:37:51 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AE8453F170
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 04:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635741317;
        bh=rPuCvocgoqcLO1V7CjbdCCqaDF3oAtmRQEnh4OXdZEc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=t+FahR4nlUsL+EE0JV8v970hR/JQfqm+Fr7Y2F+fRTceagyY0aCa3HGRjA9H4yWYN
         a0ZITU+67IvK54aPLom9X0MlgfmAvgfDtSXwcVkDODqRLJzTRYNksjDAxZgbvRsu13
         KggzA+EzTh3uZ3pOj0ErKDuhCF+MYv1T5Bp+512Bvwud8Vgz0tCAFZ70DHFpUIQ3jk
         KePCOXKniAZpGJDAzVgPtMjd+fzby6nvxgvMQlidn0lMYtu2PTIWDLtWVBIAblAVOr
         V4ipOOj6oczmP/RTfm/dQISyBzht39vsIlQyBfHktajyuJUiNPHz30Yl/8f5AEW4e/
         sl+05SvHPq4qQ==
Received: by mail-pg1-f200.google.com with SMTP id w5-20020a654105000000b002692534afceso8674238pgp.8
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 21:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPuCvocgoqcLO1V7CjbdCCqaDF3oAtmRQEnh4OXdZEc=;
        b=dXLngKqTSpWu2Zv5W3eN93IH/0eENgIaW1AUUZ/pl3PKe/mS2X0nnTMmB1RCJX2izW
         X0f48Yo6ppYS6G29bY0V+t5sT0IX5eOhGTRqwWCl6F+rGROypzi+rZDUKX4mTxyqInw5
         qeUtK5rZfIR/7oQzKrnRJh059Ta6esZZMcvXYGErUD6Elqx08LKGxQ4rC3Xxg8Uq+QT5
         fuiMivDxGsKwzt0Yjd5AduA155MBuxwxfIJSx8VCDQ10uMN+yVktz6cOoslZ42Tjy3Ok
         /CcV4tcdcOOqvNmaOxCkWKXF+usxiqPdI+TFNE2YH/AFaWwRTbgvOGYPuIFrSwBTy2Jw
         elMA==
X-Gm-Message-State: AOAM531SDsZtpj/XG9CxGP7enf6L2dhLEY0JPuughZlYoXjPu+XgRXiY
        z24EoQf3ITJiSYQO7zn1Ebl/MqvWMGpxol/s0OJ+1srNWr4+4TO2S2hjAo7mGefc0sehwW/jvvi
        S5GnF9BrpewvWjDQwpg1/d2ZAXvWFP6nXIYZ6NFRRTwTCYg==
X-Received: by 2002:a17:902:6544:b0:13e:dd16:bd5b with SMTP id d4-20020a170902654400b0013edd16bd5bmr23143380pln.61.1635741316152;
        Sun, 31 Oct 2021 21:35:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9JrD8IKjg3BvZKYy6Ba3qzaLk7ffCbMCcbPJpZq/ef8pKfF+vT3H+Yii9wmk8NpViNKGV8hfmqZVHjSOuV8k=
X-Received: by 2002:a17:902:6544:b0:13e:dd16:bd5b with SMTP id
 d4-20020a170902654400b0013edd16bd5bmr23143368pln.61.1635741315880; Sun, 31
 Oct 2021 21:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
 <20210914104301.48270518.alex.williamson@redhat.com> <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
 <20210915103235.097202d2.alex.williamson@redhat.com> <2fadf33d-8487-94c2-4460-2a20fdb2ea12@canonical.com>
 <20211005171326.3f25a43a.alex.williamson@redhat.com> <CAKAwkKtJQ1mE3=iaDA1B_Dkn1+ZbN0jTSWrQon0=SAszRv5xFw@mail.gmail.com>
 <20211012140516.6838248b.alex.williamson@redhat.com> <CAKAwkKsF3Kn1HLAg55cBVmPmo2y0QAf7g6Zc7q6ZsQZBXGW9bg@mail.gmail.com>
In-Reply-To: <CAKAwkKsF3Kn1HLAg55cBVmPmo2y0QAf7g6Zc7q6ZsQZBXGW9bg@mail.gmail.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Date:   Mon, 1 Nov 2021 17:35:04 +1300
Message-ID: <CAKAwkKsoKELnR=--06sRZL3S6_rQVi5J_Kcv6iRQ6w2tY71WCQ@mail.gmail.com>
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Nathan has been running a workload on the 5.14 kernel + the test patch, and has
ran into some interesting softlockups and hardlockups.

The first, happened on a secondary server running a Windows VM, with 7 (of 10)
1080TI GPUs passed through.

Full dmesg:
https://paste.ubuntu.com/p/Wx5hCBBXKb/

There isn't any "irq x: nobody cared" messages, and the crashkernel gets stuck
in the usual copying IR tables from dmar, which suggests an ongoing interrupt
storm.

Nathan disabled "kernel.hardlockup_panic = 1" sysctl, and managed to reproduce
the issue again, suggesting that we get stuck in kernel space for too long
without the ability for interrupts to be serviced.

It starts with the NIC hitting a tx queue timeout, and then does a NMI to unwind
the stack of each CPU, although the stacks don't appear to indicate where things
are stuck. The server then remains softlocked, and keeps unwinding stacks every
26 seconds or so, until it eventually hardlockups.

Full dmesg:
https://people.canonical.com/~mruffell/sf314568/1080TI_hardlockup.txt

The next interesting thing to report is when Nathan started the same Windows VM
on the primary host we have been debugging on, with the 8x 2080TI GPUs. Nathan
experienced a stuck VM, with the host responding just fine. When Nathan reset
the VM, he got 4x "irq xx: nobody cared" messages on IRQs 25, 27, 29 and 31,
which at the time corresponded to the PEX 8747 upstream PCI switches.

Interestingly, Nathan also observed 2x GPU Audio devices sharing the same IRQ
line as the upstream PCI switch, although Nathan mentioned this only occured
very briefly, and the GPU audio devices were re-assigned different IRQs shortly
afterward.

Full dmesg:
https://paste.ubuntu.com/p/C2V4CY3yjZ/

Output showing upstream ports belonging to those IRQs:
https://paste.ubuntu.com/p/6fkSbyFNWT/

Full lspci:
https://paste.ubuntu.com/p/CTX5kbjpRP/

Let us know if you would like any additional debug information. As always, we
are happy to test patches out.

Thanks,
Matthew
