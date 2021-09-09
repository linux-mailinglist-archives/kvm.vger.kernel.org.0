Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954A3405CEC
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhIISma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbhIISm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:42:29 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78EC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:41:19 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so3715058otg.11
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FGwdHabjkufqn4yU32pO7nEIm+xPwcKK0RU25Q+pWVw=;
        b=nhp8cBS7efctoU5E+Pm8Fi49rCQ3tJbH3oRKUsltbTIfKg8geNn1pUJLEYfC67OwHx
         w+rGZ7oC3Jleuk+WBDh3ToLBF0b1rpD02nBgcZgB485XPOUNfT9GhlaRQd2UdaI8LecA
         ulv2QC7xkhqATuZrnZpZsRNwnn++IvQj6lcp9ftP5v/Z+/5AbncN/zCNdDmAFW1KOiwp
         AArMDSq+Z3QFZweHTN9rZ82CUIoFWvsIBnoAU39/RFwfKonM/deEnuo4vVZUhG/FaVUb
         VmUGInKYq40+IH8Sp4AABmPZh4lE1XnM5KkLTb/YTvVcDaKvxGFDD4/MkGUVADMVyNBq
         33EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FGwdHabjkufqn4yU32pO7nEIm+xPwcKK0RU25Q+pWVw=;
        b=F+WIWi2ueqx4sQpN04MchKAa1arWgNNCm2nEhl7C3/xVGGqwux6IFA3yiQgyWzuC92
         BUvNizxub0t6rHVtccaaqPlGqIolpAvMI9pnhcNSTxFT1XpCxklUxN8+Ckx2shMJ/Gvx
         UJh/iIPID9uR77G+ArAzT85yMioqZqNeblTRzjvQELtVEhOvx6vkcgnv/PQX5uq6rkKS
         1SxmkaZRpfd1UnLSrHYdNasJxunW/WWjanci6FQPB1wY/sAALeT/BrSYVDXVLNcO3Zlt
         mIfojp1PRXEX9+v/GG8suIfV5JGvpGcn7wuXw2+MSrb72QPnj+BWsTav9XYbCVjXhtml
         seew==
X-Gm-Message-State: AOAM533SWLStlBKLR4/6wOixxyPradHxuB8qqIYjdlcq3CKZJVtWMf35
        LsSMULOFN6dDFosmr5Sag1ICzFPcRuGQwEdkP5adEg==
X-Google-Smtp-Source: ABdhPJxZgPdoJjQOVeE3MORlPX1kABiLQTH6iH2zPWSSnqJvD7Ie4Ot8WybhuVqyCPFKaZFHzvw80ONF4JJo0uOscUY=
X-Received: by 2002:a9d:63cf:: with SMTP id e15mr1152664otl.172.1631212878791;
 Thu, 09 Sep 2021 11:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-2-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:41:07 -0700
Message-ID: <CALMp9eTuZFGL4JJhT+FRaVZ5rc+4_ZYcX-z_dgBXP=1E7M-TQA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Drop x86/processor.h's
 barrier() in favor of compiler.h version
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:33 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop x86's duplicate version of barrier() in favor of the generic #define
> provided by linux/compiler.h.  Include compiler.h in the all-encompassing
> libcflat.h to pick up barrier() and other future goodies, e.g. new
> attributes defines.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
