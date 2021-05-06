Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F254375BAD
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhEFT0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhEFT03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 15:26:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58968C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 12:25:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so4012684pjz.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 12:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMGMOvQ5q418Ceph1tt/bJGdVBp1Eq6LdOxVTMsFDWQ=;
        b=wDMyPfbBA4bpoOkIxuwgizFpEga+k/0hOPxQOga3eKaFW0lQbh+WFWoo6IErzI5czg
         XvXNSZuH+lIpNZZpvTBAAOG7GrG7SvnK+xTYIBh7TdD7HJTrR+dqJBcdS+clgDXysD5b
         MuomI4tVmF7qds27SEfkYskITuM30kZncIbRH6hL/n35CbFEYipWwVNbNerXYk4zEgUo
         R13BP/g2hCL8GljDA9XeNI8GivSUQjxSamLjkIqMX0BMasY4NekLVOtmINuHu62QUMFs
         Ntq6uDBMsjjk2saXIzT920uUnZjI+/4I5UhE4CFC7HO+cxSXOVqJsrobYj21q0oRMxgG
         PixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMGMOvQ5q418Ceph1tt/bJGdVBp1Eq6LdOxVTMsFDWQ=;
        b=OpFM1ziLgx1Gia8IOI2RVhPtI+TXMG1HhRAIwbQmTS2VZ+zGgWVICMZ4CF4W1CUMTF
         WqJPBbqony51pg406pj6mYFwiFLCWSCaGDLPQdRsDDbDpw3IqcJVXHB39IZ0ZBza6LNC
         CWU/o7LIYonBDx+kbPKlUL4QBHFLlQKe2znoSuz2S6En3gwO2CSalTuh7ZAqi5Yspr6Y
         s7Fr8RGj4Rlny15VoUgheYhFKOM63tDpT2KoA4pdYQo+/84QPgPqSu63z1G3uHsHsRDx
         2zlFg7rBKEJgUcpco59MIYuEr92ScL336v8EhfbIUd4pTJ4S8G7DCod8MVnqu+V/wfAX
         nBwQ==
X-Gm-Message-State: AOAM5319Antu7XSleY43gh+DjeuB6tte1VC5Qzd6FxhBIhawf/qde9L5
        saaFEpODAPxcDqi+WadY9g5h1A==
X-Google-Smtp-Source: ABdhPJzFysD3c1+Y2C5BLc7zv4oWvoZ4Bd+ArzikrDwphaOuc2hEETZ3Uc60xPueK9IMU7ASeduXFQ==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr6111250pjo.45.1620329130671;
        Thu, 06 May 2021 12:25:30 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v21sm2521262pgh.12.2021.05.06.12.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 12:25:30 -0700 (PDT)
Date:   Thu, 6 May 2021 19:25:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jacob Xu <jacobhxu@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
Message-ID: <YJRCpv9O/Q24DKmZ@google.com>
References: <20210506184925.290359-1-jacobhxu@google.com>
 <YJQ8NN6EzzZEiJ6a@google.com>
 <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Jacob Xu wrote:
> > memset() takes a void *, which it casts to an char, i.e. it works on one byte at
> a time.
> Huh, TIL. Based on this I'd thought that I don't need a cast at all,
> but doing so actually results in a movaps instruction.

Ewwww.  That's likely because emulator.c does:

  #define memset __builtin_memset

and the compiler is clever enough to know that __attribute__((vector_size(16)))
means the variable is (supposed to be) aligned.

> I've changed the cast back to (uint8_t *).

I assume removing the above #define and grabbing memset() from string.c fixes
the movaps generation?  If so, that has my vote, as opposed to fudging around
the compiler by casting to uint8_t *.

As evidenced by this issue, using the compiler's memset() in kvm-unit-tests seems
inherently dangerous since the tests are often doing intentionally stupid things.
