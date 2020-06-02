Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630A21EBC8F
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFBNGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:06:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30093 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726839AbgFBNGB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 09:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=vdmj+Tg8SGx2NrYVAizct++/zxOMWuxvcR8U68lSB2Q=;
        b=Xy2qJhbjXoyS70Z86Z5bNfgNPwUttpmJ6dVZ8IF+MteBfqU2aQFQQ0CmT3r5lESWZVB9kS
        ckU6rnubx4qZkypXiWORAHNmc6sJAsrW5iE2s9x2NfVAX6EoVFSmK/zE2DaEGtlwxxUEbB
        wA5CkJO02FJwjJ/AoS+nSmyK5ezmd80=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-hYdAybLvOyOb1FVWHJD7YA-1; Tue, 02 Jun 2020 09:05:58 -0400
X-MC-Unique: hYdAybLvOyOb1FVWHJD7YA-1
Received: by mail-wr1-f69.google.com with SMTP id w4so1378873wrl.13
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vdmj+Tg8SGx2NrYVAizct++/zxOMWuxvcR8U68lSB2Q=;
        b=rPqtLYLC4doIL0BCSCnrRp/KRqdmo4QG3K4Ms7QmLLNfCFa+b5/XRuWvtgCkKsTstV
         WessR7Eup++tv6GNST8PjJQ95Lyy6RRC6NyfofoOzXgikN9prQSEOgHcEoC7hSd1Ie5p
         fdLUPKWz0XrpGU+qhx29qqTplNkGnIscK2O/DLYNuwO91O5kyFBXw4unuMVEmXlS1/Ub
         7Vz/PQc/TrHWlzq9EWzxibh4xRY6r4Tw0BSkvyhAkjKo9LGkPALqeNgxtkmGPaAQkszj
         JvmuZNDLsHlc5iYHUKAq4klRx9IbqQYTyNokzqEfV4PRICrdTVgdVZeEYE8dd3bugkcQ
         1Idg==
X-Gm-Message-State: AOAM533zUGG83PQWKMf0enCVWPMIEhv9Jyc/KW2rxq9YWTBb2CCgFwO1
        x6Ig/Sabtr056EcrTN3ZUQpv7QeV5YKuc19zQR+9E4b+KpWA7xu3VELsbRq0+rNT4w+fWhsLcWU
        cx9xKptxOgFZj
X-Received: by 2002:a1c:e355:: with SMTP id a82mr3952749wmh.1.1591103156750;
        Tue, 02 Jun 2020 06:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxhvL+9CoWDlbet28l8cBoDZ1y4Jq12uY4hkhtEZgSR8vXHFkGEgf8rds3ZCLy2cNng3Lahg==
X-Received: by 2002:a1c:e355:: with SMTP id a82mr3952727wmh.1.1591103156470;
        Tue, 02 Jun 2020 06:05:56 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id 5sm3408485wmz.16.2020.06.02.06.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:05:55 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:05:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 00/13] vhost: format independence
Message-ID: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We let the specifics of the ring format seep through to vhost API
callers - mostly because there was only one format so it was
hard to imagine what an independent API would look like.
Now that there's an alternative in form of the packed ring,
it's easier to see the issues, and fixing them is perhaps
the cleanest way to add support for more formats.

This patchset does this by indtroducing two new structures: vhost_buf to
represent a buffer and vhost_desc to represent a descriptor.
Descriptors aren't normally of interest to devices but do occationally
get exposed e.g. for logging.

Perhaps surprisingly, the higher level API actually makes things a bit
easier for callers, as well as allows more freedom for the vhost core.
The end result is basically unchanged performance (based on preliminary
testing) even though we are forced to go through a format conversion.

The conversion also exposed (more) bugs in vhost scsi - which isn't
really surprising, that driver needs a lot more love than it's getting.

Very lightly tested. Would appreciate feedback and testing.

Michael S. Tsirkin (13):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched version by default
  vhost: batching fetches
  vhost: cleanup fetch_buf return code handling
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  vhost/net: convert to new API: heads->bufs
  vhost/net: avoid iov length math
  vhost/test: convert to the buf API
  vhost/scsi: switch to buf APIs
  vhost/vsock: switch to the buf API
  vhost: drop head based APIs

 drivers/vhost/net.c   | 173 +++++++++----------
 drivers/vhost/scsi.c  |  73 ++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 375 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  46 ++++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 436 insertions(+), 283 deletions(-)

-- 
MST

