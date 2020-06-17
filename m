Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44C1FD057
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 17:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgFQPJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 11:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgFQPJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 11:09:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF03C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 08:09:33 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j198so4681940wmj.0
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 08:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:subject:reply-to:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iBkqAQvRxN5BSn7GG/za52BR5dOLhn8NvgdHSfNx9cE=;
        b=NzvmBWJPd6I/wASWtQwW1czhA24kqlroaiN9rLaQz+Jz5rLjWxe6R8zVHZogxS2wW4
         ilNF55KIyXr7IqW0ebLNUFmxq4716U4psKsqdJ9Lubr+tkeJBo50IrK8Xr4PxhKiWo9j
         +GLkvcyzec4sluOuRypHfzwTbHZRIiltFkgzBbZQ76mCWMKDmevBh6iK+U0kuf0bdvK9
         yFYMUIvXAql0ci/pq4NJZWKigm5k05QH6qy4S5R/GAXdWUsh1hwXieg//fTXdhhcU2qr
         EclVxBMolLRwdBKrhdlq/mYpkhKVf/b74p9UdagMtFMYGzTKjzufBm7Y4VFGYl2Zbtk+
         rneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:subject:reply-to:to:references
         :autocrypt:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iBkqAQvRxN5BSn7GG/za52BR5dOLhn8NvgdHSfNx9cE=;
        b=fbX/BZ7be/e2KNMrlqNApeYAoabYf5Zrih0JFFJgfqL/dL81ri7CDM3ifNzP/163+B
         FemwibpNA1DWRLJljz2Evyh8NnRr/rQSTe8G8SnlGhzjplKzKulXjkd2TYjCg7JOi+D7
         tcy2VzshB0b8Zpfrd2UVMLPr72/fMxuX16U82U74tVPIIEp7gdIQwPzQVjrRCMyZ8jKz
         +9S/br5U/Ec8LCYoyxS4yEUVsrRiCqpgqA95Av2l6ishU/47xKyB5UFKWJpCZcvynKRs
         ChwD/Brt1wRyrI7mREZW8N6U21Leoq4+pQZLbJxM9ZAg9cMRrrLYeaLtuPf42JxD1Nal
         jORg==
X-Gm-Message-State: AOAM533yK2D9iYsbg715IUKcF1iflYC3v8uEvrUAwvU6oV/nC4f4PvFY
        uJ3BIy42ItbX1IgFPVx4k5nbwruovHw=
X-Google-Smtp-Source: ABdhPJx3lMOjntnm1VqGIsOUoUKSBwEp0DKIxpPKrrF9GxtNiMdzfOwiK6J4aEFMEBxO6IlR3aDTWA==
X-Received: by 2002:a1c:6243:: with SMTP id w64mr8904996wmb.162.1592406571859;
        Wed, 17 Jun 2020 08:09:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:48a4:82f8:2ffd:ec67? ([2001:b07:6468:f312:48a4:82f8:2ffd:ec67])
        by smtp.googlemail.com with ESMTPSA id g25sm59608wmh.18.2020.06.17.08.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 08:09:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: CFP: KVM Forum 2020 virtual experience
Reply-To: kvm-forum-2020-pc@redhat.com
To:     qemu-devel <qemu-devel@nongnu.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        KVM list <kvm@vger.kernel.org>
References: <a1d960aa-c1a0-ff95-68a8-6e471028fe1e@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <391a9edc-57e3-75a8-c762-d1606fefb4ae@redhat.com>
Date:   Wed, 17 Jun 2020 17:09:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a1d960aa-c1a0-ff95-68a8-6e471028fe1e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM Forum 2020 is becoming a virtual experience this year in light of
the COVID-19 situation and will take place online on October 28-30, as
planned.

The virtual event will continue to deliver the same content you would
have received in-person (keynotes, conference sessions, BoFs, co-located
events) as well as attendee collaboration, networking tools, a "hallway
track" and much more.  And just like previous years, all content will be
made available for free after the event.

In order to allow everyone to present at KVM Forum, including people
who might not have been able to travel to Dublin, we are extending the
submission deadline for presentations for 6 more weeks!

* CFP Closes: Sunday, August 2 at 11:59 PM PST
* CFP Notifications: Tuesday, September 1
* Schedule Announcement: Tuesday, September 1
* Slide Due Date: Monday, October 26
* Event Dates: Wednesday, October 28 – Friday, October 30

We encourage you to submit and reach out to us should you have any
questions. The program committee may be contacted as a group via email:
kvm-forum-2020-pc@redhat.com.

Thanks,

-your KVM Forum 2020 Program Committee


On 25/04/20 12:29, Paolo Bonzini wrote:
> ================================================================
> KVM Forum 2020: Call For Participation
> October 28-30, 2020 - Convention Centre Dublin - Dublin, Ireland
> 
> (All submissions must be received before June 15, 2020 at 23:59 PST)
> =================================================================
> 
> KVM Forum is an annual event that presents a rare opportunity for
> developers and users to meet, discuss the state of Linux virtualization
> technology, and plan for the challenges ahead. This highly technical
> conference unites the developers who drive KVM development and the users
> who depend on KVM as part of their offerings, or to power their data
> centers and clouds.
> 
> Sessions include updates on the state of the KVM virtualization stack,
> planning for the future, and many opportunities for attendees to
> collaborate. After more than ten years in the mainline kernel, KVM
> continues to be a critical part of the FOSS cloud infrastructure. Come
> join us in continuing to improve the KVM ecosystem.
> 
> Based on these factors, we encourage you to submit and reach out to us
> should you have any questions. The program committee may be contacted as
> a group via email: kvm-forum-2020-pc@redhat.com.
> 
> 
> SUGGESTED TOPICS
> ----------------
> 
> * Scaling, latency optimizations, performance tuning
> * Hardening and security
> * New features
> * Testing
> 
> KVM and the Linux Kernel:
> * Nested virtualization
> * Resource management (CPU, I/O, memory) and scheduling
> * VFIO: IOMMU, SR-IOV, virtual GPU, etc.
> * Networking: Open vSwitch, XDP, etc.
> * virtio and vhost
> * Architecture ports and new processor features
> 
> QEMU:
> * Management interfaces: QOM and QMP
> * New devices, new boards, new architectures
> * New storage features
> * High availability, live migration and fault tolerance
> * Emulation and TCG
> * Firmware: ACPI, UEFI, coreboot, U-Boot, etc.
> 
> Management & Infrastructure
> * Managing KVM: Libvirt, OpenStack, oVirt, KubeVirt, etc.
> * Storage: Ceph, Gluster, SPDK, etc.
> * Network Function Virtualization: DPDK, OPNFV, OVN, etc.
> * Provisioning
> 
> 
> SUBMITTING YOUR PROPOSAL
> ------------------------
> 
> Abstracts due: June 15, 2020
> 
> Please submit a short abstract (~150 words) describing your presentation
> proposal. Slots vary in length up to 45 minutes.
> 
> Submit your proposal here:
> https://events.linuxfoundation.org/kvm-forum/program/cfp/
> 
> Please only use the categories "presentation" and "panel discussion"
> 
> You will receive a notification whether or not your presentation
> proposal was accepted by August 17, 2020.
> 
> Speakers will receive a complimentary pass for the event. In case your
> submission has multiple presenters, only the primary speaker for a
> proposal will receive a complimentary event pass. For panel discussions,
> all panelists will receive a complimentary event pass.
> 
> 
> TECHNICAL TALKS
> 
> A good technical talk should not just report on what has happened over
> the last year; it should present a concrete problem and how it impacts
> the user and/or developer community. Whenever applicable, focus on work
> that needs to be done, difficulties that haven't yet been solved, and on
> decisions that other developers should be aware of. Summarizing recent
> developments is okay but it should not be more than a small portion of
> the overall talk.
> 
> 
> END-USER TALKS
> 
> One of the big challenges as developers is to know what, where and how
> people actually use our software. We will reserve a few slots for end
> users talking about their deployment challenges and achievements.
> 
> If you are using KVM in production you are encouraged submit a speaking
> proposal. Simply mark it as an end-user talk. As an end user, this is a
> unique opportunity to get your input to developers.
> 
> 
> PANEL DISCUSSIONS
> 
> If you are proposing a panel discussion, please make sure that you list
> all of your potential panelists in your the abstract. We will request
> full biographies if a panel is accepted.
> 
> 
> HANDS-ON / BOF SESSIONS
> 
> We will reserve some time for people to get together and discuss
> strategic decisions as well as other topics that are best solved within
> smaller groups.
> 
> These sessions will be announced during the event. If you are interested
> in organizing such a session, please add it to the list at
> 
>   http://www.linux-kvm.org/page/KVM_Forum_2020_BOF
> 
> Let people you think who might be interested know about your BOF, and
> encourage them to add their names to the wiki page as well. Please add
> your ideas to the list before KVM Forum starts.
> 
> 
> HOTEL / TRAVEL
> --------------
> 
> This year's event will take place at the Conference Center Dublin. For
> information on hotels close to the conference, please visit
> https://events.linuxfoundation.org/kvm-forum/attend/venue-travel/.
> Information on conference hotel blocks will be available later in
> Spring 2020.
> 
> 
> DATES TO REMEMBER
> -----------------
> 
> * CFP Opens: Monday, April 27, 2020
> * CFP Closes: Monday, June 15 at 11:59 PM PST
> * CFP Notifications: Monday, August 17
> * Schedule Announcement: Thursday, August 20
> * Slide Due Date: Monday, October 26
> * Event Dates: Wednesday, October 28 – Friday, October 30
> 
> 
> 
> Thank you for your interest in KVM. We're looking forward to your
> submissions and, if the conditions will permit it, to seeing you at the
> KVM Forum 2020 in October!
> 
> -your KVM Forum 2020 Program Committee
> 
> Please contact us with any questions or comments at
> kvm-forum-2020-pc@redhat.com
> 
> 

