Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A1907AC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfHPSXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 14:23:06 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37901 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfHPSXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 14:23:00 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so8028241ioa.5
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 11:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agJWohZMr3q676k9RQlDh/wbKRZjdc0c7MZS5+ZmeB0=;
        b=pDG5hmdil4HLm+qgjeNBLGvkzY0OcQFeCNXBtf7EeZzS3CCemkaN1U8cf0ks6SUiY1
         9G4ZyZFbH7i0BW2ERj9II63tLaL06iinZlXcnBfsRD6QGo7ksVIlWyFtaA34oEYUSLmC
         dfO8AHPySJM4CrHjwQRcin/Lqm2SQCpWf/Mcb2dykytnB8anoIOuojBLlza/PIzqi6AL
         v62V/uInV/Uaj89pzuGuWwQzIg2qm7n+YeWNjn8Vuqe87kujWukdtqvww0zw/2jY8TiU
         0wkDBmKXVaAdPkSFFVD55p8ftsEERyFIxUxDEB3LECntCj9RrVCMH148PDdyu/u6fvwS
         RuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agJWohZMr3q676k9RQlDh/wbKRZjdc0c7MZS5+ZmeB0=;
        b=E5x6SwrKJ4wxxWtXe0axMgkDFLRczygWuOsyyZcX8ghPDrL+T6mynYbpSfL/5qUhT5
         8g1jb5Hm+RUmaYC0DvXvzJfCOnWeYkKWsRGh9wNVu62yMBg0HgHvDD4zBOZt5Uv2+WEl
         65X38b5C/Vv6Qyzxp0loUt7Mgl/fsiUlj98jzjV+r8AMmWEd4QQmcGZeeQPXA5MVg6wc
         bdL2KOsLL7rvpwoitEwA+viYc7eyrGDWUclKsKqTxQTpSn3jverud1t0+1gUnbsYE2dX
         W3stes8WfNbvzSDDgSjCah7xzvdwKO5N6dIy80qQnp7MBCJh8pENrnVQAMHx2FLo6+tm
         HM9g==
X-Gm-Message-State: APjAAAU9QCzJUtEdk3qn8aV0UK87OpCFK5Eqs8O7BuQBB661E1nJlSAb
        QJu2ClNvq2zSdno6I7EO3qfy1e4uL7gTUGF16dcckA==
X-Google-Smtp-Source: APXvYqymMyZ+oLaWjU/FyURpfwyR0j6qSnHvftCbU4CW4/Vtsw891sNKDL+NmgRsDkE0mHHV/0o5zWYlsFX1HLQV7xc=
X-Received: by 2002:a5e:c911:: with SMTP id z17mr971749iol.119.1565979778912;
 Fri, 16 Aug 2019 11:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190815200931.18260-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190815200931.18260-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Aug 2019 11:22:47 -0700
Message-ID: <CALMp9eQvy-UH3=Puq0AzM-f-C-5wFL1amWubRStZa2aH-m6ebA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Fix and tweak the comments for VM-Enter
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 1:11 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Fix an incorrect/stale comment regarding the vmx_vcpu pointer, as guest
> registers are now loaded using a direct pointer to the start of the
> register array.
>
> Opportunistically add a comment to document why the vmx_vcpu pointer is
> needed, its consumption via 'call vmx_update_host_rsp' is rather subtle.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
