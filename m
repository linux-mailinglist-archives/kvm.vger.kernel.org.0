Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAED41C53ED
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgEELIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:08:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29577 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEELIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 07:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588676900;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=KeGEY//dbi43i4PKd7K9eVr4oJ9VVerAJQ5mEvKflfFXvH0KIDF68h2Rinp96O7cT0f49d
        X3gXDFLq+NpfZ79j+WReZJlNoecdIjOmgFozpMxyfY844vxJE+rHOwRRWvnWHDFaGCh6wB
        P/WnUPNzl7Nux5urPuzv23Dv1BNQxDI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-vN0cALAxNTGuosjGkcVPNQ-1; Tue, 05 May 2020 07:08:17 -0400
X-MC-Unique: vN0cALAxNTGuosjGkcVPNQ-1
Received: by mail-wr1-f72.google.com with SMTP id o6so1049232wrn.0
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 04:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=tcnTaGypI5WWWAf4Q3ulTivlKOGkICMmLSyvSoQ9BsPo8E2Ut3M/E6uRhK6qYzL2jr
         rMQ5FZNHIt6nm6z6dgfEfINgggGyDU5mF2ev7E2LgVq0VHa9dNqfoC5sOoxLH7jmWWAV
         FZTZCMRdQ9lVacLfG7yhxxj7qRwDmOPUxHJpyi861IsuBNaJ2qg8iErB6eKVkfG+KGWU
         7tln5054escB95DqMSeZneuw2dlVymMbxmfBf+F5jOrvhgDGjynMdstF4M/HGonGM4O8
         ktOD8bv3Mz7ae99UInq5egXFH0Klc2NHSoEjlPe/OhsjanTA2SoWTtnBDmN8tt8lDklH
         YbaA==
X-Gm-Message-State: AGi0PuaPZApmESoMaTS2sUOT+av1ueFkIgNgJ9oq5ekxh+Hcto5jzBT+
        zUekLYd1AK/S4eYpUnVS9OEKnsag483bHhOExX9jWwMlQxFU573/tpBzy9SG/1mBEQMxiEuACI4
        B+hRrn+Rm2TPi
X-Received: by 2002:adf:fccd:: with SMTP id f13mr3271410wrs.386.1588676895823;
        Tue, 05 May 2020 04:08:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypK5GxCqI4HICd7sSuy32iCCsa9f245KrM4v4vS5liHVKpaaBkd4+1n5GD7WxOvbEcbkkddRCg==
X-Received: by 2002:adf:fccd:: with SMTP id f13mr3271359wrs.386.1588676895342;
        Tue, 05 May 2020 04:08:15 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id z22sm3204539wma.20.2020.05.05.04.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 04:08:14 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2020-05-19
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 05 May 2020 13:08:13 +0200
Message-ID: <87o8r24p2a.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
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

