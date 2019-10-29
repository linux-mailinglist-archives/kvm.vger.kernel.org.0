Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62EFE8CBE
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 17:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390374AbfJ2Qck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 12:32:40 -0400
Received: from mail-wr1-f73.google.com ([209.85.221.73]:37721 "EHLO
        mail-wr1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390252AbfJ2Qcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 12:32:39 -0400
Received: by mail-wr1-f73.google.com with SMTP id q14so8813799wrw.4
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 09:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aFBVvPMXMdVoNWS+arga+zyutc52PrhwrmcehtICP7Y=;
        b=dnUlLPeHrSuhFF3+r3nexRhXSUgG2QFJmbgnM7MsHtu9FFwvUjdpifIlzbNDwRGkd/
         Rugpk2suP1+NWI0NcnbXkosWcp5TC1CcRvDazP+lW6hm5NaO4SXfRFuKQfst1xaVJ735
         loWFY3SBTLlZeW5p5a4BNCH8n5LF1tQy9M5Dcw9+Hx9HDhgklnBWRMOaVr3t+JbGQwPk
         o6f2umBa8YgNSH/0EA9o69e8rdGo1yiXatKJ1mHoKWzbMUsqFfKYyPCdlgB1rnZCCvbE
         ikFEJ8JrBVmn8KZDM/0CUXuDXrNd2ZFJCWCzeVgBfFhqtnbvvxAlQICeYgavC606yNrC
         8ECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aFBVvPMXMdVoNWS+arga+zyutc52PrhwrmcehtICP7Y=;
        b=s8gypUmysc8DAMt4VWTU/ASjq4MHBo7mp5uB9PF+fYwmouOvmQibdzvro2xMXcbfHE
         2aUQb54Qo5U1U2aNdj3XM9FpRopDlo+/pJhgEcZr5XtElNXPXfU/RH/oK08g7kg+Do9w
         Y7jfSxXMFm8sk2qer1+hziplfCbCq01TYzNUDygCaVV41JhREN2QDxh9RCkTNu5Ad3mg
         wqRfhiH8n3vWf6j1PShMo/L6RJQdJlcsXL/5w6ewXZRdRowBKhp8kNaUpGB8IQRAWYdy
         Vwc585Q5x+Xmxfm/ulKFAoNHmQ98ZPAYYra7dSMOf8Ekk4zKs3No8iT8zNK+a0mFjVXn
         AkWg==
X-Gm-Message-State: APjAAAVIzvu+NUOjhcbQnaUXOsseXIX3MPeXDFsxeEFU1r88+J7CkVRN
        lQzf778Lo9N57Lb8rqZUxbju4Il4hWSGZt1e
X-Google-Smtp-Source: APXvYqyQYFo/SVqLudHuBq0akKPCDJONWrXAYKTaEfxtfHzCYvYIvxkO/0zufmfXYgX8y9D4iHgx4ShS3grBopTf
X-Received: by 2002:a05:6000:142:: with SMTP id r2mr20520344wrx.30.1572366756966;
 Tue, 29 Oct 2019 09:32:36 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:32:26 +0100
Message-Id: <cover.1572366574.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 0/3] kcov: collect coverage from usb and vhost
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset extends kcov to allow collecting coverage from backgound
kernel threads. This extension requires custom annotations for each of the
places where coverage collection is desired. This patchset implements this
for hub events in the USB subsystem and for vhost workers. See the first
patch description for details about the kcov extension. The other two
patches apply this kcov extension to USB and vhost.

Examples of other subsystems that might potentially benefit from this when
custom annotations are added (the list is based on process_one_work()
callers for bugs recently reported by syzbot):
1. fs: writeback wb_workfn() worker,
2. net: addrconf_dad_work()/addrconf_verify_work() workers,
3. net: neigh_periodic_work() worker,
4. net/p9: p9_write_work()/p9_read_work() workers,
5. block: blk_mq_run_work_fn() worker.

These patches have been used to enable coverage-guided USB fuzzing with
syzkaller for the last few years, see the details here:

https://github.com/google/syzkaller/blob/master/docs/linux/external_fuzzing_usb.md

This patchset has been pushed to the public Linux kernel Gerrit instance:

https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/1524

Changes v2 -> v3:
- Removed using u64 division as arm can't do that.
- Added EXPORT_SYMBOL() for kcov_common_handle(), kcov_remote_start() and
  kcov_remote_stop().
- Added usage comments for kcov_remote_start(), kcov_remote_stop() and
  kcov_common_handle().
- Expanded a comment in kcov_task_exit() to better explain WARN_ON()
  condition.
- Reduced KCOV_REMOTE_MAX_HANDLES to 0x100 to avoid allowing too many
  GFP_ATOMIC allocations.

Changes v1 -> v2:
- Changed common_handle type back to u64 (to allow extending it in the
  future).
- Reworked kcov_remote_handle() helpers.
- Fixed vhost annotations when CONFIG_KCOV is not enabled.
- Use kcov_disable() instead of kcov_remote_reset() when
  KCOV_REMOTE_ENABLE fails.

Changes RFC v1 -> v1:
- Remove unnecessary #ifdef's from drivers/vhost/vhost.c.
- Reset t->kcov when area allocation fails in kcov_remote_start().
- Use struct_size to calculate array size in kcov_ioctl().
- Add a limit on area_size in kcov_remote_arg.
- Added kcov_disable() helper.
- Changed encoding of kcov remote handle ids, see the documentation.
- Added a comment reference for kcov_sequence task_struct field.
- Change common_handle type to u32.
- Add checks for handle validity into kcov_ioctl_locked() and
    kcov_remote_start().
- Updated documentation to reflect the changes.

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Andrey Konovalov (3):
  kcov: remote coverage support
  usb, kcov: collect coverage from hub_event
  vhost, kcov: collect coverage from vhost_worker

 Documentation/dev-tools/kcov.rst | 129 ++++++++
 drivers/usb/core/hub.c           |   5 +
 drivers/vhost/vhost.c            |   6 +
 drivers/vhost/vhost.h            |   1 +
 include/linux/kcov.h             |  23 ++
 include/linux/sched.h            |   8 +
 include/uapi/linux/kcov.h        |  28 ++
 kernel/kcov.c                    | 547 +++++++++++++++++++++++++++++--
 8 files changed, 712 insertions(+), 35 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

