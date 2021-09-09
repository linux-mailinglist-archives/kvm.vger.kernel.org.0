Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF9405CFF
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbhIISs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbhIISs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:48:56 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFDC061757
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:47:46 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id c79so3767827oib.11
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sdw/A8k04pJ6pAzFG7fU83MlSi3Tgb3VMS95Y4EKaC0=;
        b=ddeMOgUk/wFXC/vz3y+QZRSh3+wjenLuykgXiGKaSGoYItQ4A3UqX/GO7xQLxSmjRk
         +ZLGKObwHP4sOVswZw9XSDafffQupgRjPf7OoZLZh/QDZsuk3nxKY5aYt9xaa+9Af5bl
         wltXOpV9ivxes2sTqhBy0TlJLU1n6UdkS3eww97WgWCh9dm5gHFU9xdmkOOUTSttIov+
         Egs2FE87NcFfyW8XSD4+gJpxq7iL6Wf0vGACr0v/V7O/wnyPCYcAZv5UdHTviKcDS3j5
         uT/psWumOAMcloohqqXpBvl48YCHnM5JZGs173kDnXf45zpHf0tRNPeU2hWKvBR+xyGk
         zvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sdw/A8k04pJ6pAzFG7fU83MlSi3Tgb3VMS95Y4EKaC0=;
        b=aIGc+EWT1UzfugQvRM81V604o2JyQCvfDPBk3eGXzu8hjhl6WVJgsrhHSbXcPbc2Qe
         VDC9OFWablZBGits4x45WocmOynijPU/7cTZVkUlLLCbQqjpUqB0Ae8KiqbiR0TQfbrS
         F7JpzhwpvbvFNpyOv/UPI+f+UXCO9WM37N61K6WUTYglganqGgEUnBOK3jIMzJlc5Rqa
         ghzeh8cDIEFlZSDlzj+IrJR7t6piM99F7YNv9SDkOS2gOOVrQ+nZrSjZDIWYJH1qFEvl
         xrCRUdrFgx59w+3Xx7pYy3AGRbiNJ+8I3LGMlGCEOxJqMYz4VOlhlgq6UW32/YNUPVL/
         wB+A==
X-Gm-Message-State: AOAM530nW4gkckK87t0t33nMcsxfhJLownAHFJ8iFs0ihz9vC0i3iEaf
        k7FVzRntsykczOUZyp7bHzx0wuVW8q8mmXKDOv852w==
X-Google-Smtp-Source: ABdhPJyDA6ugPrlUXufXAr55Obkp7kXT8RGhd46fRkIQWFdIDnrubweAiEU+kcAK9p8koClqezJQDlxRCCnIpqgxnm8=
X-Received: by 2002:aca:c6ce:: with SMTP id w197mr1134707oif.6.1631213266005;
 Thu, 09 Sep 2021 11:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-7-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-7-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:47:35 -0700
Message-ID: <CALMp9eQoK1DVOZsQ8wA3QFMbtF+cpV5yyHrMjng8Kb-6ukkJcw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/7] x86: umip: mark do_ring3 as noinline
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> do_ring3 uses inline asm that defines globally visible labels. Clang
> decides that it can inline this function, which causes the assembler to
> complain about duplicate symbols. Mark the function as "noinline" to
> prevent this.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> [sean: call out the globally visible aspect]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
