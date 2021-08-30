Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA03FB4B2
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhH3LjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 07:39:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236591AbhH3LjW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 07:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630323507;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=MqPNGfBnOYZX9J+TczLmdsyoKaKEvqSBNegYR2tl10eD+6ZrgPtW4DXiQ3BoGwrA3xBrs6
        9W9I4y09ZLDCqU0SrB5qteu+BUF98I6kdkKcRQo1/Nf2oRGwqvIYtrjTWMUC+Eqxqh/QAP
        bbQgoqkUdgZk8t+zfb3mnT0TUZQLNgE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-aKT1USbCN82Z-m0dMgrUww-1; Mon, 30 Aug 2021 07:38:26 -0400
X-MC-Unique: aKT1USbCN82Z-m0dMgrUww-1
Received: by mail-wm1-f70.google.com with SMTP id p5-20020a7bcc85000000b002e7563efc4cso4438804wma.4
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 04:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=cjeSsWfJlBy3FHO4FAysp7fJhfuJRBctZRYkqQKOMMUvI88BY2Bw05T04f8aaVCB15
         4iNBCXPYUHaZliXIZSVqHfatWCgvHUsJep2/8ntKMiB/+MyuPvZkkvc+yotEaHIMDEoP
         0j0hhCwrxvv7xDPA3KZqJjZHJFXjernsCHC8wcnR2bGTgyBGIVtjaV0CVdlIXpdrnVYl
         zJ1dZPZ2Cj5oVQr3z4nmqSV0EupWE9Qk8aCwYO/i7VkszgOc7M1h3f2O7gcyBKz4KogT
         n+aSxC90kqJV0GSMvwaCFnJycaaVFj9puE3wJjYKCEctbMVQdGf5olHGpj9sLRZ2F9xC
         LOWA==
X-Gm-Message-State: AOAM531RiLZE23iJvjVEdkXI4+jlBay0ViInupm0SCNFvpi6yLe0OdwC
        qW4jVC7SKc5iK0Y/8vmlw8lnNcHcTZngrSx8SfT1YpemsWMqCU+mooQyqxi9UAofWNr1pPXEx3y
        RCYloQdD7tQ0zdscBWEZLpkCpYkm/ogh9EdsM8SC3Sipce5BF+xweTT0CTHt87Th6
X-Received: by 2002:a05:600c:ac7:: with SMTP id c7mr21198203wmr.40.1630323504764;
        Mon, 30 Aug 2021 04:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJXH67bayqR9aHgrx805eJZykx5xZYfFq27eKtVG304N1Rq5OGFXrWr5hyR/agotbGjIS6NQ==
X-Received: by 2002:a05:600c:ac7:: with SMTP id c7mr21198189wmr.40.1630323504572;
        Mon, 30 Aug 2021 04:38:24 -0700 (PDT)
Received: from localhost (62.83.194.64.dyn.user.ono.com. [62.83.194.64])
        by smtp.gmail.com with ESMTPSA id g1sm17621628wmk.2.2021.08.30.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 04:38:24 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2021-09-07
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 30 Aug 2021 13:38:23 +0200
Message-ID: <87wno32mds.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

