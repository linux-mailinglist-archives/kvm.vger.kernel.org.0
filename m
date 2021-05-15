Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20043818E3
	for <lists+kvm@lfdr.de>; Sat, 15 May 2021 14:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhEONAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 May 2021 09:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhEONAP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 15 May 2021 09:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621083542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R/lM2H0tEoj6m/RZLn59Xfyz3aFDE19qQoJl9YUN95E=;
        b=HVkBqIfsr6+kX9xoJNZWdM8+xl9uTrnMKYw5UcwpvT22jmY3C4zzHwkYencH2XGM2uiji8
        AG/aES52AiYJ0v8+zEpzfSEaGxMPiOFjAy3BmbZNtTY3ntoyiW2NAesyTXFq1SADhsCzjN
        UHKWOr5psBBDgAUomtgcya9iw2Atb/U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-QdcQHboBM4GkkrwB5rE89Q-1; Sat, 15 May 2021 08:58:55 -0400
X-MC-Unique: QdcQHboBM4GkkrwB5rE89Q-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640242d3b0290388cea34ed3so1009091edc.15
        for <kvm@vger.kernel.org>; Sat, 15 May 2021 05:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=R/lM2H0tEoj6m/RZLn59Xfyz3aFDE19qQoJl9YUN95E=;
        b=MEmwh1UdzJLj5Dajg2Hy2FuKneIZ7E443mPdjjOtzlp2owefNYCluFnP9sevHtyw5N
         icpRIwmiPet4l+rtA3a6wYn7WgvpZSZ9cGiCHBImacC6Z88AOdhRfu9vvy3nmFjhiZrz
         xjkWaum1SXGFRVxhmPTPL2eUlBK3ulFrtyakxr/IcId4eZY/3yS5D/wemLwDDKXY73eQ
         EQ7v4/xc0fMX+MjMzrAEtmwVpAzqVHFIJ/SrrbM6U9RkRwKPwbAetZ6iSkOfiqeW2azC
         tMgVXb2ujj62kOuXX6h2H+wJ8aqtRaZ+W/9LCxkdst4bPkhlzQIgQaqSPG4YDZQKj4AB
         i9Aw==
X-Gm-Message-State: AOAM531kpefB5b7/DzJxqKqm60prOWc+KQC6vtKvVBPDsRUEZVWsX1MG
        q+TarOUPJjtZMcjA3gr98lG8Tu4HhPQaXVhDJ04YtjlZLDvCL0afkTfhiJ4QrRPeo50KRXAHHH1
        amlfuv8Eynwwx
X-Received: by 2002:a50:f1ca:: with SMTP id y10mr8995422edl.294.1621083533788;
        Sat, 15 May 2021 05:58:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC2J3JPhqBmU1yJdHfbOWaV6E3RjT1vAIzyIPbj+bRZXCe53EwEjPybz294FPdsr9qtAh47Q==
X-Received: by 2002:a50:f1ca:: with SMTP id y10mr8995413edl.294.1621083533600;
        Sat, 15 May 2021 05:58:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p14sm6666040eds.28.2021.05.15.05.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 05:58:53 -0700 (PDT)
X-Mozilla-News-Host: news://lore.kernel.org:119
To:     KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "rust-vmm@lists.opendev.org" <rust-vmm@lists.opendev.org>,
        "kata-hypervisor@lists.katacontainers.io" 
        <kata-hypervisor@lists.katacontainers.io>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: CFP Reminder: KVM Forum 2021
Message-ID: <faa18dd9-6e7c-5729-ff1c-1e9323f0aed5@redhat.com>
Date:   Sat, 15 May 2021 14:58:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

================================================================
KVM Forum 2021 virtual experience
September 15-16, 2021

(All submissions must be received before May 31, 2021 at 23:59 PST)
=================================================================

KVM Forum is an annual event that presents a rare opportunity for
developers and users to discuss the state of Linux virtualization
technology and plan for the challenges ahead. This highly technical
conference unites the developers who drive KVM development and the users
who depend on KVM as part of their offerings, or to power their data
centers and clouds.

Sessions include updates on the state of the KVM virtualization stack,
planning for the future, and many opportunities for attendees to
collaborate. Over the years since its inclusion in the mainline kernel,
KVM has become a critical part of the FOSS cloud infrastructure. Come
join us in continuing to improve the KVM ecosystem.

Due to continuing COVID-19 safety concerns, KVM Forum 2021 will be
presented as a virtual experience. You will have the ability to network
with other attendees, attend sessions with live speaker Q&A, interact with
sponsors in real-time, and much more – all virtually, from anywhere.

We encourage you to submit and reach out to us should you have any
questions. The program committee may be contacted as a group via email:
kvm-forum-2021-pc@redhat.com.


SUGGESTED TOPICS
----------------

* Scalability and Optimization
* High Availability and Fault Tolerance
* Hardening and security
* Testing

KVM and the Linux Kernel:
* New Features and Architecture Ports
* Resource Management (CPU, I/O, Memory) and Scheduling
* Device Passthrough: VFIO, mdev, vDPA
* Network Virtualization
* Virtio and vhost

Virtual Machine Monitors and Management
* VMM Implementation: APIs, Live Migration, Performance Tuning, etc.
* Multi-process VMMs: vhost-user, vfio-user, QEMU Storage Daemon, SPDK
* QEMU without KVM: Hypervisor.framework, Windows Hypervisor Platform, etc.
* Managing KVM: Libvirt, KubeVirt, Kata Containers

Emulation
* New Devices, Boards and Architectures
* CPU Emulation and Binary Translation


SUBMITTING YOUR PROPOSAL
------------------------

Abstracts due: May 31, 2021

Please submit a short abstract (~150 words) describing your presentation
proposal. Slots vary in length up to 45 minutes.

Submit your proposal here:
https://events.linuxfoundation.org/kvm-forum/program/cfp/

Please only use the categories "presentation" and "panel discussion"

You will receive a notification whether or not your presentation
proposal was accepted by August 17, 2021.

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

   http://www.linux-kvm.org/page/KVM_Forum_2021_BOF

Let people you think who might be interested know about your BOF, and
encourage them to add their names to the wiki page as well. Please add
your ideas to the list before KVM Forum starts.


HOTEL / TRAVEL
--------------

This year's event will take place at the Conference Center Dublin. For
information on hotels close to the conference, please visit
https://events.linuxfoundation.org/kvm-forum/attend/venue-travel/.
Information on conference hotel blocks will be available later in
Spring 2021.


DATES TO REMEMBER
-----------------

* CFP Closes: Monday, May 31 at 11:59 PM PST
* CFP Notifications: Monday, July 6
* Schedule Announcement: Thursday, July 8
* Slide Due Date: Monday, September 13
* Event Dates: Wednesday, September 15 – Thursday, September 16


Thank you for your interest in KVM. We're looking forward to your
submissions and, if the conditions will permit it, to seeing you at the
KVM Forum 2021 in September!

-your KVM Forum 2021 Program Committee

Please contact us with any questions or comments at
kvm-forum-2021-pc@redhat.com

