Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74A24C6E2
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 22:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgHTUwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 16:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgHTUwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 16:52:17 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A6C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 13:52:15 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a24so3084289oia.6
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 13:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFg+jFmtOnyHlScqARdOHpvmudoSnqaQBg5KCeRa9UQ=;
        b=Sot0iVxSbuwVCve9v8QZv0lD2QM3MOxOl7KaOfewuGZDmolNdBIN7EQvQ7bTJMGlrJ
         q3HrH+JdFgxknsJMrQeND2akyErRnHIoq62wfpoXoySbe9dvqSDLOt3vXQ6ACgGiRCs8
         rR80UK/DbV1zI5JhxQcse1CoRao5fbW7EYBriilVFryfXCgWXlrf+a+owiU4BgWiiDrc
         nBnNJiDbXKVWrM5Zh3aLCUzTwdP1pi9EN4Y7Zswa9zrqyqjXlb14ohFMUlEr91wUg9yt
         znwAN4npy2kfSXL2Td3kPAsfXCazr9ToqpO+dgR//rKCRC5keTh3pLE+4XXQi1oaf5SP
         C/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFg+jFmtOnyHlScqARdOHpvmudoSnqaQBg5KCeRa9UQ=;
        b=KKvt0z4T9w/syrIsHDC1bJvJ2M5OJkxmZEO1KnAbmJgMF/L4so4QX4fRMIdd5RzTpi
         dCoo5OuW3V3F2SubCJygqJMZhFbuRMLGyv3ECSLwjN4zUmzWkmViL3JzbqNhxUwqK6S3
         XgYkXUmeVNp4gVcZSd4L1ed8oKuK/mI/CFI07GrK/QeUqly92J7d0rSRtf7u0sCbfGp/
         iRcSQFpOGRZHD6j+HbSbN8wpUUHjNqmCeMgbo5Zd+eGLD+Wx3lo5G3Ct+ZdNIkw8779G
         NX2XMPoDfzud7RsW8hZuePvY6DCTMwgYDohgIouX/GS1HCTdBpROSfU1v7RN0++/rDJL
         x/1w==
X-Gm-Message-State: AOAM531aPwfb1DVpQ+1T7KHXt7N7pb/69rZc9wr6HzFjJXehcFRcHAEZ
        rYnR6piINVrerPUHoi5rzt+7cNghlJU7Wa8EFyK5/A==
X-Google-Smtp-Source: ABdhPJy2aO1SL1t0M+h2xAvPXa9rCV7M+MQaUATKbbFZWbdBB38MDHybjeRJoqtv8x9PM9oAG0488c4xvxRJZPRbDCA=
X-Received: by 2002:aca:670b:: with SMTP id z11mr157629oix.6.1597956734635;
 Thu, 20 Aug 2020 13:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200820133339.372823-1-mlevitsk@redhat.com> <20200820133339.372823-2-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-2-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 13:52:03 -0700
Message-ID: <CALMp9eRzB-NXa_QAJXr1JSkkGYTc7MzzfEOcBa9-+Cu1sc13ow@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] KVM: SVM: rename a variable in the svm_create_vcpu
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 6:33 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> The 'page' is to hold the vcpu's vmcb so name it as such to
> avoid confusion.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
