Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7401FAB98
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFPItH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 04:49:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21646 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgFPItH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 04:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592297345;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=J/OKJ+x8WoN1fO7CP/VINKY4JjpkFHuvXvGJ4GsZ8TM1K6Sdou54cBSUZWmS7wVXUOyEIQ
        X/jtX8kWVIqO14lVAbKlAyiAbpTgxAoyGN+5IOQ3JCqz+VhiAS77UwRbEy/SsnL4Tpn2RW
        B7S5JdcGglzW5DnjTA3yAVTrmIBXCRo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-UP2a1wEiMF69-InK8f8O2w-1; Tue, 16 Jun 2020 04:49:03 -0400
X-MC-Unique: UP2a1wEiMF69-InK8f8O2w-1
Received: by mail-wm1-f71.google.com with SMTP id b65so953668wmb.5
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 01:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=loul9qVKH6ZpI28aJIp0wcQ1f3JjUKSDtj3ToDUrXwDp5wuKCgUERAXE2mp1l5Bvma
         QbioL39xU0JElevohudR5fk4PnO1vNLHnuXgQ0g3bezNgBsWOcIOQnzTSgbUNVWdn4fU
         bWRtloMP1b9njNx6PKmTy2zr1dmykJQH7Dngu+L6k7mIqOES3pNCR/alff9fs5moSILf
         Wm6mho4PMHlUox/k3QmQlZHj/H1bzV7ow8voZsXFheHWm8LZ47B8P9c3GHCWowi54uMX
         Jq2KFbtPRnXufVenZ9hewJF/6Cq4HxTtMrObq8+AZSkZMCvZ96cq+QTko7FfGpkt134X
         Y9Og==
X-Gm-Message-State: AOAM532YIVnvF9f1K1rsvjC8FjbrlSvu8bcVjQM4AIbK8W8KK6nIMWxZ
        qB+VueGurU7YhIPfR5H6uv5Rr6uVm2zw5Wr1GjChfzbsvtq88HVicR77ZD21NUO5ZKCGwdhJoUQ
        +hi8hoT8+zVI8
X-Received: by 2002:adf:e285:: with SMTP id v5mr1840474wri.129.1592297342348;
        Tue, 16 Jun 2020 01:49:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEn7kENsYjcXnQwyyS7aWlQp3jLb1PHk7TkKGkmsPonFYcw7ViNxKhXJFLqEgygiHSMwM0ug==
X-Received: by 2002:adf:e285:: with SMTP id v5mr1840455wri.129.1592297342108;
        Tue, 16 Jun 2020 01:49:02 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id c68sm2976259wmd.12.2020.06.16.01.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:49:01 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2020-06-30
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 16 Jun 2020 10:49:00 +0200
Message-ID: <87d05zxuo3.fsf@secure.mitica>
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

