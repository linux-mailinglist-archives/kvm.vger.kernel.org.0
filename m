Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3C1B85AD
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDYK3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 06:29:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYK3d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 06:29:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587810571;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=Wtc798SaiZRKd4xvI15KW6Lm5IMWQxOD5VKCV+R0GjA=;
        b=cgChzG6wuAdhYTEG3uYGF0LwOCYRHmTths8rGoZjcyowg+pGAhGEeqMqxGJW2b3LbWrXN1
        7PGZ9eCXio4VFXB64cpx+qEu0U8mdvXOg06zW7il8Za+gFCPXzrSbJeaSo/mEj5ebhphf5
        LW2JrLLQypL58Dk6IJZAjYxLx0b0/R4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-j4oRagRgP_-enPD-w-ciSQ-1; Sat, 25 Apr 2020 06:29:26 -0400
X-MC-Unique: j4oRagRgP_-enPD-w-ciSQ-1
Received: by mail-wr1-f72.google.com with SMTP id m5so6493131wru.15
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 03:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:reply-to:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=Wtc798SaiZRKd4xvI15KW6Lm5IMWQxOD5VKCV+R0GjA=;
        b=Lxke5rJokHZ8KIEVoKnTx/0ABJXVP1c5P9LD0ywUgGNq4/XaOiBHJUq+BNMFNHSWGn
         j0KhdwBYuDpO+pEAbZZJmrPRPj0K974Rmwc3UjIpE7hHBKonwTc4rAytKYoZe4Zp/8Nx
         uEhLRtPsvTttx5EfsUnc2WX4v+pvmpHvzb/MU5YV/xD1R28tkne0RwLQ3deAjP/7PXFM
         FJtIGJXkGccnMkzgM7pfsO3TnrCUkGYL/hzkvwlEcjTRv+fOec183fRurBa/H2yQGYOb
         F5zjq1h+ii55K6S9eT5Vm3HRbYaWyNUi3uKnr0+1kw6hq7sCCuyBngU5hvmqk/T5EypE
         bIsQ==
X-Gm-Message-State: AGi0PuZYkhrXFHCWhHXLEueHlY1fZl6knJ6al7rozwooOVnvU/bpKSLv
        oWntnpTEJdzvAHAXRII+fiRi+NXK4cjH6TMt5mBLdPNdRJivecZp8yxFOqS5hpGT6SxetSCszYT
        j4C1dOE4vUYTX
X-Received: by 2002:a5d:6b8a:: with SMTP id n10mr16036965wrx.36.1587810565330;
        Sat, 25 Apr 2020 03:29:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypKrXXpKyRrBQw9KkMlM/i2jcGT9lAiH2FwZ8dFH+eCYZgK0PBopf1xo9ue/6znHXT3G3NYTtA==
X-Received: by 2002:a5d:6b8a:: with SMTP id n10mr16036938wrx.36.1587810564943;
        Sat, 25 Apr 2020 03:29:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id v1sm12516300wrv.19.2020.04.25.03.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 03:29:24 -0700 (PDT)
To:     qemu-devel <qemu-devel@nongnu.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        KVM list <kvm@vger.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Reply-To: kvm-forum-2020-pc@redhat.com
Subject: CFP: KVM Forum 2020
Message-ID: <a1d960aa-c1a0-ff95-68a8-6e471028fe1e@redhat.com>
Date:   Sat, 25 Apr 2020 12:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

================================================================
KVM Forum 2020: Call For Participation
October 28-30, 2020 - Convention Centre Dublin - Dublin, Ireland

(All submissions must be received before June 15, 2020 at 23:59 PST)
=================================================================

KVM Forum is an annual event that presents a rare opportunity for
developers and users to meet, discuss the state of Linux virtualization
technology, and plan for the challenges ahead. This highly technical
conference unites the developers who drive KVM development and the users
who depend on KVM as part of their offerings, or to power their data
centers and clouds.

Sessions include updates on the state of the KVM virtualization stack,
planning for the future, and many opportunities for attendees to
collaborate. After more than ten years in the mainline kernel, KVM
continues to be a critical part of the FOSS cloud infrastructure. Come
join us in continuing to improve the KVM ecosystem.

We understand that these are uncertain times and we are continuously
monitoring the COVID-19/Novel Coronavirus situation. Our attendees'
safety is of the utmost importance. If we feel it is not safe to meet in
person, we will turn the event into a virtual experience. We hope to
announce this at the same time as the speaker notification. Speakers
will still be expected to attend if a physical event goes ahead, but we
understand that exceptional circumstances might arise after speakers are
accepted and we will do our best to accommodate such circumstances.

Based on these factors, we encourage you to submit and reach out to us
should you have any questions. The program committee may be contacted as
a group via email: kvm-forum-2020-pc@redhat.com.


SUGGESTED TOPICS
----------------

* Scaling, latency optimizations, performance tuning
* Hardening and security
* New features
* Testing

KVM and the Linux Kernel:
* Nested virtualization
* Resource management (CPU, I/O, memory) and scheduling
* VFIO: IOMMU, SR-IOV, virtual GPU, etc.
* Networking: Open vSwitch, XDP, etc.
* virtio and vhost
* Architecture ports and new processor features

QEMU:
* Management interfaces: QOM and QMP
* New devices, new boards, new architectures
* New storage features
* High availability, live migration and fault tolerance
* Emulation and TCG
* Firmware: ACPI, UEFI, coreboot, U-Boot, etc.

Management & Infrastructure
* Managing KVM: Libvirt, OpenStack, oVirt, KubeVirt, etc.
* Storage: Ceph, Gluster, SPDK, etc.
* Network Function Virtualization: DPDK, OPNFV, OVN, etc.
* Provisioning


SUBMITTING YOUR PROPOSAL
------------------------

Abstracts due: June 15, 2020

Please submit a short abstract (~150 words) describing your presentation
proposal. Slots vary in length up to 45 minutes.

Submit your proposal here:
https://events.linuxfoundation.org/kvm-forum/program/cfp/

Please only use the categories "presentation" and "panel discussion"

You will receive a notification whether or not your presentation
proposal was accepted by August 17, 2020.

Speakers will receive a complimentary pass for the event. In case your
submission has multiple presenters, only the primary speaker for a
proposal will receive a complimentary event pass. For panel discussions,
all panelists will receive a complimentary event pass.


TECHNICAL TALKS

A good technical talk should not just report on what has happened over
the last year; it should present a concrete problem and how it impacts
the user and/or developer community. Whenever applicable, focus on work
that needs to be done, difficulties that haven't yet been solved, and on
decisions that other developers should be aware of. Summarizing recent
developments is okay but it should not be more than a small portion of
the overall talk.


END-USER TALKS

One of the big challenges as developers is to know what, where and how
people actually use our software. We will reserve a few slots for end
users talking about their deployment challenges and achievements.

If you are using KVM in production you are encouraged submit a speaking
proposal. Simply mark it as an end-user talk. As an end user, this is a
unique opportunity to get your input to developers.


PANEL DISCUSSIONS

If you are proposing a panel discussion, please make sure that you list
all of your potential panelists in your the abstract. We will request
full biographies if a panel is accepted.


HANDS-ON / BOF SESSIONS

We will reserve some time for people to get together and discuss
strategic decisions as well as other topics that are best solved within
smaller groups.

These sessions will be announced during the event. If you are interested
in organizing such a session, please add it to the list at

  http://www.linux-kvm.org/page/KVM_Forum_2020_BOF

Let people you think who might be interested know about your BOF, and
encourage them to add their names to the wiki page as well. Please add
your ideas to the list before KVM Forum starts.


HOTEL / TRAVEL
--------------

This year's event will take place at the Conference Center Dublin. For
information on hotels close to the conference, please visit
https://events.linuxfoundation.org/kvm-forum/attend/venue-travel/.
Information on conference hotel blocks will be available later in
Spring 2020.


DATES TO REMEMBER
-----------------

* CFP Opens: Monday, April 27, 2020
* CFP Closes: Monday, June 15 at 11:59 PM PST
* CFP Notifications: Monday, August 17
* Schedule Announcement: Thursday, August 20
* Slide Due Date: Monday, October 26
* Event Dates: Wednesday, October 28 – Friday, October 30



Thank you for your interest in KVM. We're looking forward to your
submissions and, if the conditions will permit it, to seeing you at the
KVM Forum 2020 in October!

-your KVM Forum 2020 Program Committee

Please contact us with any questions or comments at
kvm-forum-2020-pc@redhat.com

