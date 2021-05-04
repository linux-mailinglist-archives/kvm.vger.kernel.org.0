Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A43372E7B
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhEDRI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhEDRIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:08:55 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB00C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:07:59 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id b5-20020a9d5d050000b02902a5883b0f4bso8887755oti.2
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a18OKh4si98wo09kax0C+fC9YoLiwXZ0QN6CWagL1Cs=;
        b=l0a+ZCk1mvC2qrYMpznn9uww9cuoDy8csjja3nJULF43BcRzIrFE4qzQW9vTrdg28r
         n20IX5OQ+DWKCyqD+/7XcaJ19euRwcDdGMRWYHlYJmkzGF5qj1Uk95gqHoSdW7XXomDE
         5BUPiRNaj6jKxTK9W44hVvVBZ3ESaghYvQ8TzqDFu1LtA/hkOqxfWNzN/VJDDDRFvkEH
         1wg/adLf4PzdVav1C+BaoxAYKaoqCmis7D7oKJ8iDgMb21hIrbmxxUxyDxGbYuM+rYOT
         1wiQC/Agt8jUJjk+7HZ8gjfaNA2+USxgZtGk+a3jYemMrrFN5swzL0lOZcLTLput/EaV
         uoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a18OKh4si98wo09kax0C+fC9YoLiwXZ0QN6CWagL1Cs=;
        b=jv3VBdlwDS5jaRUD4WT1X8CKKE3GYlenvpc4e5GQy1cghUsmt1Oj7AJVB7UYog9H/S
         bJDz5kJy9sMl711Fpub2OdITQPZatpJQEO8SGZbYDt9Lf8sbQa5xX/91/cwwIlfC1z58
         hvBv+QGperEhAc0e0U9P/E7ye9iRzeoS4ZtNHX609wux0Xu615ViKRj1FloHB93r3wHv
         82oLNHD/C2oohrjtknvpOcsm1z9cUEI1Lbh/JdcOquWtRG3UnxXqVEV9sB/rYLUJBO89
         1UWNx/u3Vr3saEVxcsB+95Xvt2MRqQrS64GgXCppMtkHPJjdB55VTcOY1DVHGLXuchMf
         gJUg==
X-Gm-Message-State: AOAM5304uaYFqCApbKqruJxT0WRL3VVcZ7alzh4uqfZz1OIRsO6XEC+V
        olhf9TpUn9jR/yUVLf4OLM7myGCfw+6G3X22O7A3yg==
X-Google-Smtp-Source: ABdhPJwix7Joyua4FEpha2I/asd4LydO4GNegfTBK83bnNOxLSrPda6QDFGRLt6MHScTIRxQCioFNs9DySxnGTSg3cQ=
X-Received: by 2002:a05:6830:16c8:: with SMTP id l8mr20109273otr.56.1620148078808;
 Tue, 04 May 2021 10:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210309045250.3333311-1-morbo@google.com>
In-Reply-To: <20210309045250.3333311-1-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 10:07:47 -0700
Message-ID: <CALMp9eStUGcyY5bD8ETDvuepQ7VVNDnRRyJVaS=9v9gH41L=5A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] Makefile: do not use "libgcc" for clang
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 8, 2021 at 8:53 PM Bill Wendling <morbo@google.com> wrote:
>
> The -nostdlib flag disables the driver from adding libclang_rt.*.a
> during linking. Adding a specific library to the command line then
> causes the linker to report unresolved symbols, because the libraries
> that resolve those symbols aren't automatically added. Turns out clang
> doesn't need to specify that library.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
