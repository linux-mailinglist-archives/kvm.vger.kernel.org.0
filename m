Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6374497ABB
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 09:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242369AbiAXIwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 03:52:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236352AbiAXIwE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 03:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643014323;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=LXRVvwoiwZzifxDn36r5XLBHH/133EA03m6HU6kUIs8=;
        b=EsrnpfKBPP4oFb8zA/4EMxGah/tPSO/2BGb83o6RMatQqr+5qjhWghL3sjAzWorieiLLe0
        rJUvjqxPBAFAyqUIGxBXKaLKEiopAnOJZGivWp+NE6QvnU3p5T74iJkqqNPaqdDDpVKf3Y
        XGAlJDVQlUXIiUmjl3a2xZenxz7d4G4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-AEuLbdXaNQCYj_osvz1cbw-1; Mon, 24 Jan 2022 03:52:02 -0500
X-MC-Unique: AEuLbdXaNQCYj_osvz1cbw-1
Received: by mail-wm1-f72.google.com with SMTP id j18-20020a05600c1c1200b0034aeea95dacso14600863wms.8
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 00:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=LXRVvwoiwZzifxDn36r5XLBHH/133EA03m6HU6kUIs8=;
        b=ElPIXVHIEpBqXKa/E/g0xClPbHFVb3bLYQ+wflw9PD55A/wqv0QuQH8EEdBHAU5Fpi
         +wdsPyPa/i8+pQPEOA+TO2hqKbx//9uY/VDa9TroyRqxPRY2oActEbSBrfjV/UlMOoLs
         NWE611O9iHTjky0uK4A15hmlRvtgWqrkDGZ99hRj1UltcKfYSFKnkJmqDc4qYIdl/c9e
         h+5W9+AanbS1QDmEFcUJpVIISkL+D2W29bgRnhP4v3sfM1yXk/b7Zfag6mtI46S1Bj+D
         9e3nmYJ6oZJ1kJjhOPXmhKAk5nDwUKpipPfaI+CWx0BI6g494T4xb4//HhOr87BpeXxr
         QPqA==
X-Gm-Message-State: AOAM53060OgI9E9KxfHEMEQRuLuNYmArnZ1r1iPa0UU9sf6FJRf6GBPV
        ZNrmT2Znge2lTfQmco5VgUwJgE4pI8Wsloz/RFFZyXRruicPtowiShCAN4/QOpvzvdo+Q9fhy9B
        F6ERbJW2hNsTFe7MbFt1Cuos2ebcC06GA9Cedq0UbMAE/njzXatvdrEIIT4oDQwH6
X-Received: by 2002:a05:600c:4e4e:: with SMTP id e14mr857526wmq.98.1643014320955;
        Mon, 24 Jan 2022 00:52:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweugE/T1AI2/YI2Cq1E8ZAzZqGnBoCZEb6UCIovSBN7a7OQuU0OFTQ77CISW3JTub+9knOTA==
X-Received: by 2002:a05:600c:4e4e:: with SMTP id e14mr857511wmq.98.1643014320687;
        Mon, 24 Jan 2022 00:52:00 -0800 (PST)
Received: from localhost ([47.61.17.76])
        by smtp.gmail.com with ESMTPSA id l4sm540392wrs.6.2022.01.24.00.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:52:00 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2022-01-25
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 24 Jan 2022 09:51:59 +0100
Message-ID: <87y2355xe8.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

This week we have a continuation of 2 weeks ago call to discuss how to
enable creation of machines from QMP sooner on the boot.

There was already a call about this 2 weeks ago where we didn't finished
everything.
I have been on vacation last week and I haven't been able to send a
"kind of resume" of the call.

Basically what we need is:
- being able to create machines sooner that we are today
- being able to change the devices that are in the boards, in
  particular, we need to be able to create a board deciding what devices
  it has and how they are connected without recompiling qemu.
  This means to launch QMP sooner that we do today.
- Several options was proposed:
  - create a new binary that only allows QMP machine creation.
    and continue having the old command line
  - create a new binary, and change current HMP/command line to just
    call this new binary.  This way we make sure that everything can be
    done through QMP.
  - stay with only one binary but change it so we can call QMP sooner.
- There is agreement that we need to be able to call QMP sooner.
- There is NO agreement about how the best way to proceed:
  * We don't want this to be a multiyear effort, i.e. we want something
    that can be used relatively soon (this means that using only one
    binary can be tricky).
  * If we start with a new binary that only allows qmp and we wait until
    everything has been ported to QMP, it can take forever, and during
    that time we have to maintain two binaries.
  * Getting a new binary lets us to be more agreessive about what we can
    remove/change. i.e. easier experimentation.
  * Management Apps will only use QMP, not the command line, or they
    even use libvirt and don't care at all about qemu.  So it appears
    that HMP is only used for developers, so we can be loose about
    backwards compatibility. I.e. if we allow the same functionality,
    but the syntax is different, we don't care.

Discussion was longer, but it was difficult to take notes and as I said,
the only thing that appears that everybody agrees is that we need an
agreement about what is the plan to go there.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

