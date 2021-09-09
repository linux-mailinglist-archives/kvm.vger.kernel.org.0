Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C92C405CEE
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhIISpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIISpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:45:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE372C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:43:54 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so3723945otk.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1xZV9KAMlHLDPNZn3KJiShWyI/lhpUIKZuyKpRO4RE=;
        b=Q5wKMrdJ2HQOXkaaylaf6WkgSTpkjcrip0o1cWPgfIgMmZIbjJs4TxFZLjRyhY/1rS
         0IULCMBksbeyKq7wlHngq8zYxEk0WLT9Bak1/dU1YoFkqBWcVu34Xjce8xd13cIwMEcE
         RPrGZaKGm7MsiLFGci3perLWNMSoAkuRvqyDRvo/rXvODj/4eC7qpXEi1S+mVJj+s3eJ
         +p1QJq7uRDlyhfHCbEQ2DvE0xmEjP2g9EUPQ55Til2d3+bLv9YjWwPH28HlajdfcK+/d
         e1qg0clst/Wi1IjiFduOHTdXTo5pjTQJW4y+LtUPSvfcg8E1bgLAZzqqnMktriyM82MF
         DZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1xZV9KAMlHLDPNZn3KJiShWyI/lhpUIKZuyKpRO4RE=;
        b=KFBKhXPF1o+LBgJ/iazVjimjZ6kiX/PLOhvbaHJsWMfsqxQpnr95nX7xpZdiSgiY7m
         0EQVPWqWfQYRUaDPELOQUdaMeOLcAKMCs5jceUW1oi77ZSKEr6656KV21K3aFFYfgxo5
         GBRlKgwXDgIg6olXqZOQwpxvsFjVOXXV9evsfSIlnI0IWGysfig2ZCf7kzAx3oV/QvZ7
         khz7UPJSHjooi1tOZ7EoFxVd/G2mKywFhbGmTTeLafCRguL6KYmonHfTbTbHGdoyJJWi
         h39pWq0/qvrzWtCm7WrGi9D8x+zUEdZZis+P40LGX3U4knNx4sATMdaHuZ43uhw27DUP
         pmAQ==
X-Gm-Message-State: AOAM531/xH5VKNyoxZbAI71KEB0HiaYo+mJHl00fbVWvBBV221YtgyMf
        z7xQMXHH+PM53p1tyYjvmQqjwQy43hBDApUELj0TvXvUmKY=
X-Google-Smtp-Source: ABdhPJxPIUyBu/hZ5uXn3EdX4kVipByCHKi2sYKhLlOEw7pbatRuIyDUdq6RdOOg7E+aIu7O+J4H33Lqk4p0heH6LHI=
X-Received: by 2002:a05:6830:2b0d:: with SMTP id l13mr1120170otv.39.1631213034031;
 Thu, 09 Sep 2021 11:43:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-4-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-4-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:43:42 -0700
Message-ID: <CALMp9eT=zk3uBFvs1s17CSSszYVN1B7NHQYaKi7_eGz3RZutMQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/7] lib: Move __unused attribute macro
 to compiler.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Move the __unused macro to linux/compiler.h to co-locate it with the
> other macros that provide syntactic sugar around __attribute__.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
