Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652FC216EA3
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 16:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgGGOX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 10:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGOX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 10:23:28 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C18C061755
        for <kvm@vger.kernel.org>; Tue,  7 Jul 2020 07:23:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z15so34060464wrl.8
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oO3TSnPnLZsZ6hr/3xEKQF0iyJv2XW9TlVVpl0eB868=;
        b=l23YHn7NpMGLhdriRqfvDmhlIkMmtTuy7DKkxyqd/iZIf2klvNkA+UlPN3Mde+fFy4
         T0SO4N+f470SYeQJylCGfL9yiwMJhao6UKh8amu9ZQFM12gl+S6eBrkrYdsh5RaDvyNH
         Y8L01uPdZNPzCLsWiTdyzpclByhFuIfVXOYZ6M9jmSmW5dgl7yKIrutdSTqiBoiijGJm
         vNxvTXAlwm6kb6QLalF6Sk7jw51IwNzP56CwGxOfwGC1xM5Xs/jIqVMcgxcm34GDrZlE
         59e5pFsS6IJWKAAMn0n6zs4NMvHy3gSfY+VZLkfruIbeEgIuJy+D21gbk61/cTJ1T8Br
         0bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oO3TSnPnLZsZ6hr/3xEKQF0iyJv2XW9TlVVpl0eB868=;
        b=Ins4RbTrb5gkrXtOmVpNkOTCwqhM+D/vZLKfuXCi0fSFFe2c93n/J5sIhwhcaMe2pT
         64nafn01pWNO9isddycNO7bI4JUCuOOFd6bdjKEfmLSh8Bu/emozFRbEhqdq21raEt0N
         KNnWBQMSSaqtt5Ri37mRfI6ImuohrFv66E6yyeZAptPcMrXWKy80KExIA66CPtX55vVt
         bvTIdJyV4YpQoxg+5Ev2Rxr+pK1QhOa9TMWbYl7AvY9GQPDfqZ7LMH+LwT7Loa4o0b81
         egkRaeQQqsaiEKrWUR3f3NsjEdM+Nf36HpTYGM0io3XlZoPUiuZ1hY6thEaFvqNArTBY
         /OcA==
X-Gm-Message-State: AOAM533Lq7O3BXFAM1pvi0lvjGI9eq66By8JrcEUXcjayAS372pxPvnS
        rID+W2IidMskjiiclyJs5IaCAc6FIhgUUK3lC6W/+p0VGjE=
X-Google-Smtp-Source: ABdhPJwwZC9Blc0kX3D8MRr6MuPJdnwjk5LH+vwNOW9jT/3xWq/i9fMHlRQ2KAL/HsDooz71Ohq6HrvtdrkImGZ6RNU=
X-Received: by 2002:adf:dd8d:: with SMTP id x13mr53156914wrl.362.1594131806438;
 Tue, 07 Jul 2020 07:23:26 -0700 (PDT)
MIME-Version: 1.0
From:   Tim Stowell <stowellt@gmail.com>
Date:   Tue, 7 Jul 2020 08:22:49 -0600
Message-ID: <CAOkj57_qs7Tdph4yCRLLMMoqqqFoYO-NuP3tZPJBJFXMQTOfyg@mail.gmail.com>
Subject: read_tsc causing high cpu usage
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I've noticed when running "perf kvm --host top (pid of qemu-kvm)" that
"read_tsc" is using on average 20% of the CPU when a FreeBSD guest is
idle. I'm somewhat new to kvm, is that normal? I've tried various
timer options with libvirt, but read_tsc is almost always using most
of the cpu. I'm using an AMD EPYC 7302P processor if that is helpful,
thanks.

-Tim
