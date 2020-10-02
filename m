Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD167280F8C
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBJJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 05:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBJJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 05:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601629791;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=LLY7W9DKJou6LoXrOLGaFqgZXvA9GsySl0Xr1TMIq1k=;
        b=E+gyOIUp7zLESTcXKXfWYcr4LCTEdsQxrOvZh2N1ObxdFkx/bP1pEP+A8CONJirV4JWTbE
        aAthf+dsS0yPWtTcjjv5Ov5EgxmNL3K8Gtj3jAPIcy8pAdGx/lDoybrDuQ7t7swaK+Z/y/
        6UhJfRdFGk/LmH//HDtjlgQPvnhE5AU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-sOgKXH6WOcu0p8kDE_RIGA-1; Fri, 02 Oct 2020 05:09:48 -0400
X-MC-Unique: sOgKXH6WOcu0p8kDE_RIGA-1
Received: by mail-wm1-f71.google.com with SMTP id u5so319187wme.3
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 02:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=LLY7W9DKJou6LoXrOLGaFqgZXvA9GsySl0Xr1TMIq1k=;
        b=ExZZzct2sDA4YhhrsLXt9LxNkYr6XXhG0HR5TFschMs8xnUpfsmBu6iFXHcwj7k3LV
         ZxYJvUq3YYxJk3/0HYm/0SWFSPCZDy65Gp5Gnm3vXfJHFbd/+NgE8WmWkbOPLPC3NRJG
         mcyV3mzZTFcRCJosCWTLGP2oT7HeevbpJsB+aWNMvkmUzwmWF0BlfEpq1GH5ARVU2GmT
         cFIEbf7EHebCLri3Ohj9hf9ghFr3Je3tIRE2ic4cxq7TL8vd/uNsaMRx1W+OcPA4ZZPm
         5HNqYEBWqzcAziOL0NO2kcfb+Mqkf7kW5NraNUAHgAoxV1KsKeoOXhxYbjEjuyYOETtw
         lpKw==
X-Gm-Message-State: AOAM531gNEi2nbDNvZi8bHefdsUm4HULLa2UaPU0gU2v1baFaU4gMiaH
        YKiP/TyIN7iTPBN3aeOCKBHLFKsUnV0tJE+VOLPj68mZnkMOlvZ3Cmsfa+hFDa7JDJqjyYqv8kV
        7lrDRra+/qZx/
X-Received: by 2002:a05:600c:20c8:: with SMTP id y8mr1675181wmm.108.1601629786847;
        Fri, 02 Oct 2020 02:09:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZK9qEvHj04yc/0eHdit3b1zXLDyx0gaAVoYt2N5f88LvHJNF+gKyApwXGkzohhGbsHgANGg==
X-Received: by 2002:a05:600c:20c8:: with SMTP id y8mr1675155wmm.108.1601629786550;
        Fri, 02 Oct 2020 02:09:46 -0700 (PDT)
Received: from localhost (62.117.241.112.dyn.user.ono.com. [62.117.241.112])
        by smtp.gmail.com with ESMTPSA id v9sm180778wmh.23.2020.10.02.02.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 02:09:45 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        John Snow <jsnow@redhat.com>
Subject: KVM call for agenda for 2020-10-06
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 02 Oct 2020 11:09:44 +0200
Message-ID: <874kndm1t3.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.


For this call, we have agenda!!

John Snow wants to talk about his new (and excting) developments with
x-configure.  Stay tuned.


After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

