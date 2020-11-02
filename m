Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E904B2A3734
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 00:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgKBXe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 18:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgKBXe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 18:34:56 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDF1C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 15:34:56 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id 32so14332289otm.3
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 15:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/BgjUxQrlsJTlqh8Vvks9TqxhTA1QqUSKhezsePtfE=;
        b=dS1axwX8kPE1UC99L+vc1KrJTixMNeBQOGuNV4lF60NW79Jsk4dekCCDvFYBgPGcmf
         CjnwSf6woTQU/dDyU9dcF5cfo9TphEWC5Bdg6SdwNVwEU7cFcrpHsW/u2x4T/dSNjokU
         euFz8eDvNGAqZdaIhd7cYh5C/bZJPVKArVVd+E4Abt7/ggGVBCngigtOLJpMmx5Kkvw6
         uKQJuZDerIgl/CFitbyIPQTIFFrqTUMlRZ/DlVTwhyNCdsCXJUtFF0ciYQVzIki/PXLG
         lEdugwRWvqtBFuO8Xw6V6dUhF7r95X5ziQgDc/HlfNuCl9axDg/sekalKo8TomZQG6m8
         5vbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/BgjUxQrlsJTlqh8Vvks9TqxhTA1QqUSKhezsePtfE=;
        b=ju7enRoCBx/5KI/wOuaYFKFmyCepDi5peYV9V+SWFEXcU+e46AgiEl+YLJHB6MBJMe
         UvN0RRpjJ2onHTLnllDAJmkZ/3Nw6NNsR9v1+FfzcAiwgCykcxY+BxkzuxUyfUJFdTrs
         8YwGC3FWCSbZGNr71CY7yaCcvmEiuhJKWA75LQStMcyfsQNQgYtA09SpCci/eARlDe8T
         QIAWMRQCCiRJI9lnn6sgE7/2G4xU09moeQCElbQF1VjYL7L4lbqkO5kJCoB+bALt9T++
         YbjRbvMqAlJ0KP5YXhQNJbDpiyIL0BFp14KZEIl/VUgY7bNzlQZr93011h4Lo6g0imAR
         S6ZQ==
X-Gm-Message-State: AOAM532OG0zGMKQMinBozeVn21G/P1n5iAzoCs6mQE+ZUefKAV3adzaf
        YgKxp0iZhXSQqu0Y9OG249lxsWcSJKRCjk7a0Oceu1/9Stc=
X-Google-Smtp-Source: ABdhPJx4cAa7BcY9Oa4Nwmb3uoBJeYTH1huCAHwhNYpfO/EsZl65vMjzNGXW5g/iOTXnTsBDMvZZ7q12/61/zB6ohAk=
X-Received: by 2002:a9d:7d96:: with SMTP id j22mr14421462otn.295.1604360095321;
 Mon, 02 Nov 2020 15:34:55 -0800 (PST)
MIME-Version: 1.0
References: <20201031144851.3985650-1-pbonzini@redhat.com>
In-Reply-To: <20201031144851.3985650-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Nov 2020 15:34:44 -0800
Message-ID: <CALMp9eQ7s4prn+ZEDiuC6gPLcz3HmvvL_69mJ9W69J=heiTB_w@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] port80: remove test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 7:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM has not passed port 0x80 directly to the hardware for three years
> (commit d59d51f08801, "KVM: VMX: remove I/O port 0x80 bypass on Intel
> hosts", 2017-12-05) so the port80 test is a useless duplicate of the
> outl_to_pmtimer vmexit test, without the reporting of how long the
> access takes and without adaptive choice of the number of iterations.
> Remove it.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
