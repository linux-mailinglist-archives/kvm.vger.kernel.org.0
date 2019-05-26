Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B445F2AA8C
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfEZPwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 11:52:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36727 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfEZPwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 11:52:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id z1so7098917ljb.3
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 08:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHoFdmqYPstpJxz64t3x628SCZa/yDvhSqOoPOA4w6g=;
        b=HiVrlb3j4Y5yNwh6/jTPn8HCpEbqXkEXDwOcla5O5f8dWYrdyYwvVOYh79ZPa5sLuR
         posfmVSL3U7+kfupnep0eUcaME8BznR+rnxBQnRGiLRiCqJigRr8Gn1qraU3yTBtQxsN
         V4wSIbMLLzvD35ihMOTj7pcvMESgxu3h5Wr1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHoFdmqYPstpJxz64t3x628SCZa/yDvhSqOoPOA4w6g=;
        b=Yb7RJS5quwz/NOhBqoYX4/5jLhY9emCn6IRLxE2IEFVeJdf/hbOhWm/IRgvPBtAFMx
         O8z3zlYfO883PCvNvILN3SGmASUBRXMrGXuuh48qa0xtMb3Q9K0GN2iCokmYw06U2fSF
         xIsqajI1su4TQDIoIRWSCh61qSSaAImyXFrLP9DRMicToNNcTvhz/nxpJnczQCipzsmG
         w4GL2G4QPpxkJqSC9Autdu4l3QZz+bQM3+aeJ6/ItI8zGq1bUDFXoE3OFdQKml0SFJ/W
         bhMbQyg43NayAduuZfM/gWw/nsk/0QwOti8FZWQ+AFFF5Me/VpQY1ZunMROK6XEbZE6c
         UE4A==
X-Gm-Message-State: APjAAAUG6aAUYUPU84la5gkejzRDfYe9ohn7k0fgFII4KO+11/bVw0ug
        e4hafon1Q12eqPOAP7F9cO20Q8Aev0s=
X-Google-Smtp-Source: APXvYqyDoSeBuj9OpIVPfz3VR69lGrdPwYNzKoBYRGzjzBFzdc5nhmNVxR3xr/pTvCThalZQtSfgow==
X-Received: by 2002:a2e:5515:: with SMTP id j21mr32109345ljb.198.1558885928159;
        Sun, 26 May 2019 08:52:08 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id i1sm1754075lfc.86.2019.05.26.08.52.07
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 08:52:07 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id v18so10347544lfi.1
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 08:52:07 -0700 (PDT)
X-Received: by 2002:a19:7418:: with SMTP id v24mr12467788lfe.79.1558885926829;
 Sun, 26 May 2019 08:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <1558864555-53503-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1558864555-53503-1-git-send-email-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 26 May 2019 08:51:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi3YcO4JTpkeENETz3fqf3DeKc7-tvXwqPmVcq-pgKg5g@mail.gmail.com>
Message-ID: <CAHk-=wi3YcO4JTpkeENETz3fqf3DeKc7-tvXwqPmVcq-pgKg5g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.2-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 26, 2019 at 2:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

This says it's a tag, but it's not. It's just a commit pointer (also
called a "lightweight tag", because while it technically is exactly
the same thing as a branch, it's obviously in the tag namespace and
git will _treat_ it like a tag).

Normally your tags are proper signed tags. So I'm not pulling this,
waiting for confirmation.

               Linus
