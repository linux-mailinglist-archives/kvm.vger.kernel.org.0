Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F711C54FE
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgEEMDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:03:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39867 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728627AbgEEMDL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588680189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DXU9jnkzEWsc8RIwzVWDcrKiNbYLHD6VS+ixLrplBg=;
        b=PGEn77Ts0qd708PRnAXuEUf1Yg/+jRfpqBS46rH/N/R4iMzSA/u/FE0iUBKkdQtlhlqvnR
        kANSYq8iLThYUfwWCe3OdsYsXuDHHit41FDmUc2oyHQoZdWtFyCNIzU3i1T4W8j8VEqkFU
        LBttRffghbOEXgqdAnw5d4I20cXIPZU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-dmw0gwQaNBuwt4mcn1J0_w-1; Tue, 05 May 2020 08:03:02 -0400
X-MC-Unique: dmw0gwQaNBuwt4mcn1J0_w-1
Received: by mail-wr1-f72.google.com with SMTP id g7so1079053wrw.18
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 05:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/DXU9jnkzEWsc8RIwzVWDcrKiNbYLHD6VS+ixLrplBg=;
        b=OvviyrOYWuvQPulqyEXxRjd1MdM0ncvcOos9pHuDIXu0iK+biBjrnL32YduFTk3g0s
         p0GoidyAJggRy3+0U3ng88xEizlFfmDTiOUIhjwWraNNx/qvXF4L6XWYVl8lpC9ChwxJ
         JmcLH3/Lvn5uO09p123Clo/TrA3ZaHfzyboH97XVYKBTLufswJgq/jyCi25oXLj1udut
         ur93k2lU2AQ2fHSqGbhrWg3C01j7ONg+NN/V4L/31qD/yXVChebqpkp5dV4kGv9vphsR
         UPoJzOHkMsPGfEI6q/xNMRhjEVspjM96obowOMIA20rlUTNW4L69ZPEU1qp+XsIyKqsA
         9trA==
X-Gm-Message-State: AGi0PuaLuQvOljjFEJPbrjdVEv66IMjtW1fNQm+Enw3JwsGK6+hO+CFH
        ywI5IsHLj6WEl5KgCuJR2M3HRQXYtokVnPrThdigfgFWIKHqa5RkZnW1XqAjar4O0V/xnsL7O6t
        OR9TAI96k1n19
X-Received: by 2002:a1c:7f4e:: with SMTP id a75mr481440wmd.178.1588680180687;
        Tue, 05 May 2020 05:03:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7IzTjOz51JO/SWb2AMc+MUgkyW4Ja8vaXAJ3f3R4DvZvvTSTTvwvZQoo6247SSzfludH+Qw==
X-Received: by 2002:a1c:7f4e:: with SMTP id a75mr481415wmd.178.1588680180348;
        Tue, 05 May 2020 05:03:00 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id y10sm3370112wma.5.2020.05.05.05.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 05:02:59 -0700 (PDT)
Subject: Re: [PATCH v3] docs/virt/kvm: Document configuring and running nested
 guests
To:     Kashyap Chamarthy <kchamart@redhat.com>, kvm@vger.kernel.org
Cc:     dgilbert@redhat.com, cohuck@redhat.com, vkuznets@redhat.com
References: <20200505112839.30534-1-kchamart@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8bb56a1-8556-a9ff-7b69-caf116729a23@redhat.com>
Date:   Tue, 5 May 2020 14:02:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505112839.30534-1-kchamart@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 13:28, Kashyap Chamarthy wrote:
> +
> +Live migration with nested KVM
> +------------------------------
> +
> +The below live migration scenarios should work as of Linux kernel 5.3
> +and QEMU 4.2.0 for x86; for s390x, even older versions might work.
> +In all the below cases, L1 exposes ``/dev/kvm`` in it, i.e. the L2 guest
> +is a "KVM-accelerated guest", not a "plain emulated guest" (as done by
> +QEMU's TCG).
> +
> +- Migrating a nested guest (L2) to another L1 guest on the *same* bare
> +  metal host.
> +
> +- Migrating a nested guest (L2) to another L1 guest on a *different*
> +  bare metal host.
> +
> +- Migrating an L1 guest, with an *offline* nested guest in it, to
> +  another bare metal host.
> +
> +- Migrating an L1 guest, with a  *live* nested guest in it, to another
> +  bare metal host.
> +
> +Limitations on Linux kernel versions older than 5.3 (x86)
> +---------------------------------------------------------
> +
> +On Linux kernel versions older than 5.3, once an L1 guest has started an
> +L2 guest, the L1 guest would no longer capable of being migrated, saved,
> +or loaded (refer to QEMU documentation on "save"/"load") until the L2
> +guest shuts down.
> +
> +Attempting to migrate or save-and-load an L1 guest while an L2 guest is
> +running will result in undefined behavior.  You might see a ``kernel
> +BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> +Such a migrated or loaded L1 guest can no longer be considered stable or
> +secure, and must be restarted.
> +
> +Migrating an L1 guest merely configured to support nesting, while not
> +actually running L2 guests, is expected to function normally.
> +Live-migrating an L2 guest from one L1 guest to another is also expected
> +to succeed.
> +

This is a bit optimistic, as AMD is not supported yet.  Please review
the following incremental patch:

diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentation/virt/kvm/running-nested-guests.rst
--- a/Documentation/virt/kvm/running-nested-guests.rst
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -182,11 +182,23 @@ Enabling "nested" (s390x)
 Live migration with nested KVM
 ------------------------------
 
-The below live migration scenarios should work as of Linux kernel 5.3
-and QEMU 4.2.0 for x86; for s390x, even older versions might work.
-In all the below cases, L1 exposes ``/dev/kvm`` in it, i.e. the L2 guest
-is a "KVM-accelerated guest", not a "plain emulated guest" (as done by
-QEMU's TCG).
+Migrating an L1 guest, with a  *live* nested guest in it, to another
+bare metal host, works as of Linux kernel 5.3 and QEMU 4.2.0 for
+Intel x86 systems, and even on older versions for s390x.
+
+On AMD systems, once an L1 guest has started an L2 guest, the L1 guest
+should no longer be migrated or saved (refer to QEMU documentation on
+"savevm"/"loadvm") until the L2 guest shuts down.  Attempting to migrate
+or save-and-load an L1 guest while an L2 guest is running will result in
+undefined behavior.  You might see a ``kernel BUG!`` entry in ``dmesg``, a
+kernel 'oops', or an outright kernel panic.  Such a migrated or loaded L1
+guest can no longer be considered stable or secure, and must be restarted.
+Migrating an L1 guest merely configured to support nesting, while not
+actually running L2 guests, is expected to function normally even on AMD
+systems but may fail once guests are started.
+
+Migrating an L2 guest is expected to succeed, so all the following
+scenarios should work even on AMD systems:
 
 - Migrating a nested guest (L2) to another L1 guest on the *same* bare
   metal host.
@@ -194,30 +206,7 @@ QEMU's TCG).
 - Migrating a nested guest (L2) to another L1 guest on a *different*
   bare metal host.
 
-- Migrating an L1 guest, with an *offline* nested guest in it, to
-  another bare metal host.
-
-- Migrating an L1 guest, with a  *live* nested guest in it, to another
-  bare metal host.
-
-Limitations on Linux kernel versions older than 5.3 (x86)
----------------------------------------------------------
-
-On Linux kernel versions older than 5.3, once an L1 guest has started an
-L2 guest, the L1 guest would no longer capable of being migrated, saved,
-or loaded (refer to QEMU documentation on "save"/"load") until the L2
-guest shuts down.
-
-Attempting to migrate or save-and-load an L1 guest while an L2 guest is
-running will result in undefined behavior.  You might see a ``kernel
-BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
-Such a migrated or loaded L1 guest can no longer be considered stable or
-secure, and must be restarted.
-
-Migrating an L1 guest merely configured to support nesting, while not
-actually running L2 guests, is expected to function normally.
-Live-migrating an L2 guest from one L1 guest to another is also expected
-to succeed.
+- Migrating a nested guest (L2) to a bare metal host.
 
 Reporting bugs from nested setups
 -----------------------------------

