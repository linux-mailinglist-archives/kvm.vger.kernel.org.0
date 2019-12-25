Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E5B12A7D4
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 13:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLYMVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Dec 2019 07:21:08 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45643 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfLYMVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 07:21:07 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so9420881pls.12;
        Wed, 25 Dec 2019 04:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Wnv0YtxvwjhRCPhA4AJ3WaBp5/g5a1eicQCrc+kMTmY=;
        b=OMG2oDNknz48cEtssDl/vVCwRTDpy4JZD7NsViNt1A+1tVmxUvamS9au6lXuwsfsbb
         xo7sYco5GmLylmIKjvVYxQbeDWo7CINAyrGKej02lF1ONZc7Ij+iiWgI0fvXGFVf7JIa
         Qj2XJgg5U2BXd7VaXEQQaMqF66hMrscytGmNF2e5U1AIxdXFYRRuLw2HOn8tCGywk/Ms
         6GJBKQjpjpc08ZZvU/gqtKv+992lHA4zqnlBS9hEkNo2vVG8z+/XPDB1Z+YjCt7hVThR
         DO76tUarJfoxdKwQ0ewdU7FW+XrT4fVhFo0KeJgFhk0EK9f4IOaWflpfWJQnNEPLKrVb
         wQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Wnv0YtxvwjhRCPhA4AJ3WaBp5/g5a1eicQCrc+kMTmY=;
        b=swTZun40150ZKGhmHR1Xj73bjh5ha/iw13nyjwS41lG4a/RVMG4cw/gfYOmpH9g7I4
         QsuoIU3U02i0G7vxV5eodK3w9MpuAq7nu+Bsph3Hqgo1+wT9sMvPvjhjcauDt/shDl1Y
         N1AO3V7rxIRqUehnziNt4//9YhuVzdPdp0KV3ndAEx6J0ETB0WZoq4dvTAVFeOD49A5p
         NeDqBObrmqFuaCcMPY3TbnRRl59hR7+kWbOucNXqxF6YLODnhIXvPJapt8C+uPxiuU9F
         woCpPmrHRJ3HpkSB3zmcEF1Px2oFDNVNiGp/h1ntCXmx16u1PZY3q8HOX7li3U0a6LJj
         T1tQ==
X-Gm-Message-State: APjAAAWWfQD+/c987CkrJbhWV6Oc2gTCZSjH4aap82MCTJk5B02nC6/s
        rtsCoDNYiAR6MDOjPC8qRa0=
X-Google-Smtp-Source: APXvYqy58ZqVkaIvHcFkCrMhdICYlw646jVoZnTKQnvdCw8RedHK5kwZitO2+Q0vWLmz8BO97emiag==
X-Received: by 2002:a17:902:74cb:: with SMTP id f11mr39713272plt.139.1577276466677;
        Wed, 25 Dec 2019 04:21:06 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id b65sm30400263pgc.18.2019.12.25.04.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Dec 2019 04:21:06 -0800 (PST)
Date:   Wed, 25 Dec 2019 17:50:58 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio-ccw: Use the correct style for SPDX License Identifier
Message-ID: <20191225122054.GA4598@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header file related to S/390 common i/o drivers.
It assigns explicit block comment to the SPDX License
Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/s390/cio/vfio_ccw_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
index 30162a318a8a..f5d31887d413 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Tracepoints for vfio_ccw driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Tracepoints for vfio_ccw driver
  *
  * Copyright IBM Corp. 2018
  *
-- 
2.17.1

