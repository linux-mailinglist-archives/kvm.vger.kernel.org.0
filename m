Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E81D7637
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfJOMOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 08:14:35 -0400
Received: from mail-40132.protonmail.ch ([185.70.40.132]:57845 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfJOMOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 08:14:35 -0400
Date:   Tue, 15 Oct 2019 12:14:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1571141672;
        bh=UB7mShLk4gAoFzJ6cJUrtXLJnRhVNTUgd/vPjQH+QNU=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=Ftok2DuE/87MvCVeQfyXZx5L0eljA/rxgim3y7XLkPe+cee79oRaeb8jFdUqjsbha
         QAgfLToZwWhzVxjN1WpNjrTP14j9fkcgXchOUNu79as21bcTxdbEEkQWm2do/9iCOx
         NLyR7YTkoWlXaX62CkYXD/3vVOFAY+LZDxtdBZTQ=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   Mathieu Tarral <mathieu.tarral@protonmail.com>
Reply-To: Mathieu Tarral <mathieu.tarral@protonmail.com>
Subject: KVM interest in VM introspection
Message-ID: <byBCKRwxXzjlR_VKlzJct5taU98vNs1H_88eLnU38HPgS96vnoCixR-x7O5WZxpVeB0SHaAD7RzuCxWTkXKgHFcydlmRkSGWSD5CQraK-Pg=@protonmail.com>
Feedback-ID: 7ARND6YmrAEqSXE0j3TLm6ZqYiFFaDDEkO_KW8fTUEW0kYwGM1KEsuPxEPVWH5YuEnR43INtqwIKH-usvnxVQQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear KVM maintainers,

As I'm preparing a talk about the new introspection API proposed by BitDefe=
nder,
that you are currently reviewing, I wanted to better understand your opinio=
n and
goals on offering VMI on KVM.

I'm asking you this because today, there is no consensus that hypervisor ve=
ndors
should provide this type of API and what benefits they might get.

Looking at the hypervisor support, we have the following situation:
- Xen: upstream since 2011 (and even before)
- KVM: patches under review since 2017
- VirtualBox: unofficial patches available, no interest for integration and
  support by Oracle
- VMware: no public interest
- Hyper-V: no public interest

Therefore I would like to better understand your point of view about this
technology:
- What are the concrete benefits for the KVM community ?
- What are your targeted users or use case ? (enabling OS research, advance=
d
  debugging, malware analysis, live forensics, OS hardening, cloud monitori=
ng ?)
- What's your vision about this technology, considering that new trends lik=
e
  AMD's Secure Encrypted Virtualization and Intel's SGX wants to lock down =
the
  VM state, even for the hypervisor underneath ?

Note: The title of my talk is "Leveraging KVM as a debugging platform".

I have been working on LibVMI to rewrite the KVM driver[1], and I built a G=
DB stub
on top of it, improved with introspection capabilities to understand the
execution context.[2]

I'm planning to present a demo of my debugger running on top of KVM, and
debugging user processes.

Note2: I will be at the next KVM Forum, in Lyon, and I would be delighted t=
o
continue our discussions in person !

[1] KVM-VMI:  https://github.com/KVM-VMI/kvm-vmi
[2] pyvmidbg: https://github.com/Wenzel/pyvmidbg


Thanks,
Mathieu Tarral
