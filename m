Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9517B240D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 18:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388716AbfIMQ0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 12:26:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38822 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388221AbfIMQ0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 12:26:16 -0400
Received: by mail-io1-f66.google.com with SMTP id k5so38561680iol.5
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Jvt42VoVMIvX+z8JvgXA9bBfoE/Qc/TXYUYnG8sqD4=;
        b=jabpBu46Dgj78Nkjza9EwVDqOHcInrTK4g8e1L7FkDO0uL2FpAN06adAdTjtj9EC/3
         /NcYtjj3CEOhqtBZKcqi0But8hbCg657muR0Dow0ZcP2HkZe2gbfOtIys13k7T5axp8R
         DxbYmYdI224nn/RVFriKoWY8diVF5lH/9NnNxop8UvXRdz9ubuvTXWLe4JjqzKONNo8j
         1kTtLjZszsoKWGz+/99Pr8q3gpICKtCgSMCAsIew8WpyxvoKxIR2QZsaCSAKR60psJQg
         QYj40navpmdFS8CPB4ZSFy8BCn+v6Q8U2iIZ6wS7A9XqJ+V7ImLxvGIHW5GaCOsdlbcv
         W3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Jvt42VoVMIvX+z8JvgXA9bBfoE/Qc/TXYUYnG8sqD4=;
        b=t8EC/DHrnzTnq12EEoC9cWCxDvOMDwDYkxxQHiWNYltxETi+kyWeSNAF7Li0FPXxJO
         0qlzWJQ+bI53CZN57QRlOFnE23cdw4NyJfFLZqwJIzWe9r+zmnMEMKcVNaDq+KAgHcPc
         MhTmAHFq54vvw4RJIi3RoMBi+FsdeFHO+6iH5IG0jBfM0HF9KlejUkxk2/Z6WtPzNU5C
         0d8gi9TbnH1UvPpzSV+F5scfLIMhWfyH9oLuCVEpA11qqbDcgGwnqrTxpTIZZc3hg2gL
         i/g0gzTiQoMIggfZe987xMfMIYAGmUSZa1UlHtGzj/GTju4JWOcITEjY50wYJt6H/TaP
         eXTw==
X-Gm-Message-State: APjAAAVTtgBMuDfQUqbTjJbu9KJByejbgqg1S9IhDikrTA7iOXM21160
        08ZIDg02Ar6CHEKj7ZrhPKv1wUOP3QQlXHh3kKPUQw==
X-Google-Smtp-Source: APXvYqx0Q/sG2Jsk+9s0Lw9oKQo4ajm52kJ1v8tNV97lViBaTmfzD7mY59nnC/lR7CTu+P6P263UqxwYfWfWFdL/mGI=
X-Received: by 2002:a02:b782:: with SMTP id f2mr4303520jam.48.1568391975095;
 Fri, 13 Sep 2019 09:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190912180928.123660-1-marcorr@google.com> <20190913152442.GC31125@linux.intel.com>
In-Reply-To: <20190913152442.GC31125@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 Sep 2019 09:26:04 -0700
Message-ID: <CALMp9eQmQ1NKAd8qS9jj5Ff0LWV_UmFLJm4A5knBpzEz=ofirg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 8:24 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> This is a misleading name, e.g. it took me quite a while to realize this
> is testing only the passing scenario.  For me, "limit test" implies that
> it'd be deliberately exceeding the limit, or at least testing both the
> passing and failing cases.  I suppose we can't easily test the VMX abort
> cases, but we can at least test VM_ENTER_LOAD.

It's hard to test for "undefined behavior may result." :-)

One could check to see if the test is running under KVM, and then
check for the behavior that Marc's other patch introduces, but even
that is implementation-dependent.
