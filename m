Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DBB156114
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 23:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGWP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 17:15:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40328 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgBGWP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 17:15:56 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so1204775iop.7
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 14:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfZLiffjzS8p0VcpmAdgeBkNbj1uA9jdNca01ue7Jt4=;
        b=ez+9IuDImdaUY7iHSTgV+FCo7hQlp4h/2a0nUVizcOs3oBlJ/RRxgF6bIAU0ObYswc
         oPeSVvZy446HOPH5Xt1e3KZvlQaBBWMcZiFk9qP8FxLXOx4fwQB8AovK25jkxUNthXN6
         uvgJKuhuj2/gihncyDcwLrEcE9O+SOFWPZqbjw1nt1ItVNEdrNKjJSzGfuuFUh7uBF2U
         UC/nEm6Lk0iI+a6bdnS3j8T9OTsed2h9kln58cKRdK5nAVQ7QGfMZx3wd0qUBY/HOiQy
         g7GFtcCRdf/7vRrJO+xBX1lulK1l2RZfaYsAF4x3ROyhHYCIpik6GHJ73WrcnqiQKl5C
         qU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfZLiffjzS8p0VcpmAdgeBkNbj1uA9jdNca01ue7Jt4=;
        b=KgmtriwMqcI1lNDGBxlZ9RAWn1mA5eHb3QX2nsjAB+BjC9NQSH9vJg8pR+PK8rsDYP
         0pwIzqKm0q3kW41QQrUIjJbHiCEXxRKis0K4MKewjtaP2HXYqXXNBk3iKpYMIgwxBFRm
         H/k1Qrbg6E1Hg+pHX/ykoXj9B/6kR10f9MN7e2BOUr+Wex2vkTzP4GpApMyTtsH4LuoK
         zfaDv323ruJpMmxM/+yN/Yi2GWUC0FQYFMcZ5Aw7dBI9sd8kNDIKd8V2JPAzY4wuiohW
         qe/f7Dh+Dc8DVKevstqwv7TBzvIh5ho7Qlb0fwkEyukRnBKT9VH06CAEZN3K54V+OHGo
         ZVmw==
X-Gm-Message-State: APjAAAXQFzSIUa7xSweAoEKb2N+03CfRi1+Vm9jSWu+kJ9CvfYtG6V/k
        gkTfbZe+YuYbhEkJx7CgDLVpYIs68boGtClUN98WtQ==
X-Google-Smtp-Source: APXvYqx6uhzoHSlOqVuZtnEdU6UHdi8JnHFJryKQ4FvVyStADif7DkR6ipcJ1CsZbjO5ly5yUz01y9XExH+ustLG4AU=
X-Received: by 2002:a6b:92d4:: with SMTP id u203mr606535iod.288.1581113755090;
 Fri, 07 Feb 2020 14:15:55 -0800 (PST)
MIME-Version: 1.0
References: <20200127212256.194310-1-ehankland@google.com> <2a394c6d-c453-6559-bf33-f654af7922bd@redhat.com>
 <CAOyeoRVaV3Dh=M4ioiT3DU+p5ZnQGRcy9_PssJZ=a36MhL-xHQ@mail.gmail.com> <c1cec3c8-570f-d824-cb20-6641cf686981@redhat.com>
In-Reply-To: <c1cec3c8-570f-d824-cb20-6641cf686981@redhat.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Fri, 7 Feb 2020 14:15:43 -0800
Message-ID: <CAOyeoRWX1Xw+iPX52uCZef6Rqk44d-niUTikH1qL-fRoaYJeng@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Yes, please send it!  Thanks,

I sent out the test a couple days ago and you queued it (commit
b9624f3f34bd "Test WRMSR on a running counter").
Are there any other changes that I should make?

Thanks,
Eric
