Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7913441FA
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbfFMQSW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Jun 2019 12:18:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42303 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733063AbfFMQR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:17:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so6141227wrl.9
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 09:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+ExDmq83dNbYZk/tg/QUni7x/D2i/YpUnnQbUVgRM1g=;
        b=HPwTEE5Pjb7z/ImtSQffWZB1daB6uYCSB0bkRjOxAaW0YEstxkiuPeZ9DTN/8WDtdQ
         pezMh2/DQSbnZGoLOdw2Dq+BePmbf0Nu4mDEbfE1rMA+GSXJ0Xnhp0sm2+OYLg24TOdi
         N3CH6ktKXsSlioH5YSExMntzygJ+EgbCVLK7Ip8VyduXQpOPFJU/rWPA8GnBVBUeQgNy
         C5vr4gShCkRGuUT/AHLpBUDnKbCT70QTEPwjQvKb8cjm45xG1u5x/8oLXFiymg9P+v2J
         pqwTFRq+oTmfSFwd9FgTRNJOaZGeMRmWP/x0em5wK84z1EBQdKPswmYRBktppadkke5k
         cn1g==
X-Gm-Message-State: APjAAAUA0HLAcuJdFKL82QRYYILu8+K9Yl41kKzpicCrx3hb0uho5xBA
        SARPe5j/0VcSb0Eq+fMQSvc/Sg==
X-Google-Smtp-Source: APXvYqw7fiCb3kkZyxbRFxo4VVBrfPt65Goan0zuATppllSWJ/nVFQ8A9q+sa1xWwDQSlKFs+w4gnw==
X-Received: by 2002:adf:8367:: with SMTP id 94mr10309136wrd.179.1560442676625;
        Thu, 13 Jun 2019 09:17:56 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b6a:1220:f9e9:3f02:38a3:837b? ([2a01:e35:8b6a:1220:f9e9:3f02:38a3:837b])
        by smtp.gmail.com with ESMTPSA id t6sm403947wmb.29.2019.06.13.09.17.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 09:17:55 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
From:   Christophe de Dinechin <cdupontd@redhat.com>
In-Reply-To: <20190523172001.41f386d8@x1.home>
Date:   Thu, 13 Jun 2019 18:17:53 +0200
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
References: <20190523172001.41f386d8@x1.home>
To:     Alex Williamson <alex.williamson@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 24 May 2019, at 01:20, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> Hi,
> 
> Currently mediated device management, much like SR-IOV VF management,
> is largely left as an exercise for the user.  This is an attempt to
> provide something and see where it goes.  I doubt we'll solve
> everyone's needs on the first pass, but maybe we'll solve enough and
> provide helpers for the rest.  Without further ado, I'll point to what
> I have so far:
> 
> https://github.com/awilliam/mdevctl

While it’s still early, what about :

	mdevctl create-mdev <parent-device> <mdev-type> [<mdev-uuid>]

where if the mdev-uuid is missing, you just run uuidgen within the script?

I sent a small PR in case you think it makes sense.


Thanks,
Christophe

> 
> This is inspired by driverctl, which is also a bash utility.  mdevctl
> uses udev and systemd to record and recreate mdev devices for
> persistence and provides a command line utility for querying, listing,
> starting, stopping, adding, and removing mdev devices.  Currently, for
> better or worse, it considers anything created to be persistent.  I can
> imagine a global configuration option that might disable this and
> perhaps an autostart flag per mdev device, such that mdevctl might
> simply "know" about some mdevs but not attempt to create them
> automatically.  Clearly command line usage help, man pages, and
> packaging are lacking as well, release early, release often, plus this
> is a discussion starter to see if perhaps this is sufficient to meet
> some needs.
> 
> Originally I thought about making a utility to manage both mdev and
> SR-IOV VFs all in one, but it seemed more natural to start here
> (besides, I couldn't think of a good name for the combined utility).
> If this seems useful, maybe I'll start on a vfctl for SR-IOV and we'll
> see whether they have enough synergy to become one.
> 
> It would be really useful if s390 folks could help me understand
> whether it's possible to glean all the information necessary to
> recreate a ccw or ap mdev device from sysfs.  I expect the file where
> we currently only store the mdev_type to evolve into something that
> includes more information to facilitate more complicated devices.  For
> now I make no claims to maintaining compatibility of recorded mdev
> devices, it will absolutely change, but I didn't want to get bogged
> down in making sure I don't accidentally source a root kit hidden in an
> mdev config file.
> 
> I'm also curious how or if libvirt or openstack might use this.  If
> nothing else, it makes libvirt hook scripts easier to write, especially
> if we add an option not to autostart mdevs, or if users don't mind
> persistent mdevs, maybe there's nothing more to do.
> 
> BTW, feel free to clean up by bash, I'm a brute force and ignorance
> shell coder ;)  Thanks,
> 
> Alex

