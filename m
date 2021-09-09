Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE34405CED
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbhIISoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIISoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:44:10 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449CCC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:43:01 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so3732125otq.7
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LRbxEoc9WSLNqwGfx9ANw+lcr9SGcQNaa+aI0KNApo=;
        b=Y/0JXxixSwFlx2ja1UCUbCWRw+WJ0OJPaKh+23JUeLFzsFxT/UED6YUOlK4+uFXWF0
         4WNZ7DVBrGIkKx8pRgYl6xzg5BhcImYqGYW2zYZlCW/FQ6rTssoFrnmTl2ui0K/MfeC0
         95rnkOpF4YuRFTprAUaJRzaPD8ExhyUdqTxKVdmrk9xw0wUs6dxyZv1aBwdJSU9E6nXj
         0pBAmWBRxgkgjsl8gMqXoW00pyiIC9y46OjFX/yHYwFtRfNKTLl5vzUbXVgBBh9Iheyq
         geP49cx41zivrlrBY+ccLniY2cBgh0YVkiTsWM2BdV/91Ix2y0/vlWE5DyT6y+/E/9AQ
         bYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LRbxEoc9WSLNqwGfx9ANw+lcr9SGcQNaa+aI0KNApo=;
        b=dhoauepp7UpcyTkZGa5QLizN+E3kok/nc2PSW2Stqzd7PVi7ReAbyRulPQ+usJiLKv
         AtfHulhGAm/JqoZO5+4YxnTkJeFlcI1jneidethI+pzXUKe72wHktKbXYCofTAAsynO/
         yAeiqet9fKBVErvxMbIoUoOgOSlFhJr/0+nPZ1DLkWdYk+FJ2P5dhAcpXyBWVvnrTAQI
         zVZfAz0KfHspDSQg/2wntffpotFfYbMPFwv0axXj9tKXex3oO9QYogu7GDiaWTjDD86y
         1UHph8/0zDMiaP5EqxrNZsnQ1tA747+/btaAxQxN0E0N8TXGmZkObe+fl2qwGXILeAdd
         t1Jg==
X-Gm-Message-State: AOAM532XKH+9DmCSEAZrR4TfrxkUbfcQT17v479VBstow41NyiaDZMNZ
        L60ZMPxZl58AwkJqgJ5Wq16SmnrKn1aQ80DbuNKxpZ1ge4Q=
X-Google-Smtp-Source: ABdhPJy8GrDhTHHE0kWEkp2gbDxPReUpPVdEhksa26DTTKY7xB+JhK9jV04+9tQYtr1zXWGQ2SyfiA1qO7Cl+ujJCng=
X-Received: by 2002:a9d:5a89:: with SMTP id w9mr1096298oth.91.1631212980385;
 Thu, 09 Sep 2021 11:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-3-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:42:49 -0700
Message-ID: <CALMp9eQJ3CiOYJ0udMjy8KTEpWnsMzQ7Z9uQj1D=JMXFtOSNYw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/7] lib: define the "noinline" macro
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
> Define "noline" macro to reduce the amount of typing for functions using
> the "noinline" attribute.  Opportunsitically convert existing users.

Nit: Opportunistically.

> Signed-off-by: Bill Wendling <morbo@google.com>
> [sean: put macro in compiler.h instead of libcflat.h]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
