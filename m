Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C2849319A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 01:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiASAHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 19:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiASAHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 19:07:50 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A303C06161C
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 16:07:50 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id q25so844127pfl.8
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 16:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vAxUGBdxlByR43mCEdZpVjv0Zz9WIa7OMWfFPmEbMTk=;
        b=qBXZz3eV8Rov2cm1W3wCt0Wf5F4ztIaFimefC7TG1Rnsledjc6d3hrI2tmNnsnk5ds
         46g8Nl6YqHfQImsWCVu9ZE/+2+quk+HTgCOPTzKEjkoXOnZ/ShhHtxfonlnThm8Ihtq8
         PmKepSxLMvuRUptYU7UdU5+d1atrnaYttTrpddGtCSVLAjHnyElfzJcEzcnQLw3PQKqf
         gWNb3gFBRJpOBXG7e758cFocItjh3GRGCOt2WYq0JFuxKSF1WgHrGbinNWK/SjAdgKbF
         RVY5+MHZdltx0CezKaIfkDI54ms+HBx7lceqPVX8LfnWyUumSYbbMdxiDhBKyxUT9p1W
         k7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vAxUGBdxlByR43mCEdZpVjv0Zz9WIa7OMWfFPmEbMTk=;
        b=8PyBOr/T6SFbEHk14CodSk5KssK1SMA/SAhW/1yXg0Dq8kE2a3fmExoxVrYzztb9Gf
         Qy3gR0jRja2L6Av9/H7WOual/Cuz/2npnIupqgeQd5qo5hSv9k/CrQ1a1ZKAjyhQTskB
         lzCWoV076+fzax6NV/14tSLFmegQI0UZrJRCkcbnEYFeVtdExX8h5gD7vl/U1B05tCgL
         mQNDUTyFuSUftAIHlSR7Ms/m8N55WbG0Z06N5jaHFDFJ1vkjFYZalEftM89ZTrcp6kj3
         USRMMTQeC7R7rE9hAQgMZ2yS09jJtczZMRBypEdZR0nf2CEiUeLpgMp/d6BnLIVxt5IZ
         vk0A==
X-Gm-Message-State: AOAM532shzUwj5CywpHsCJPhDA+aE+My44+leeex2uUvKCGkfn/h5zZK
        1Vv9/lWrMxL/V/63wTYa5pEeqQ==
X-Google-Smtp-Source: ABdhPJxPq8SLTjE6n9JfYMFuQM1fFo8QhRlyyDWq9vPyshu5dZQT3oKCJx+oL4oaffzzN4FevbTMSQ==
X-Received: by 2002:a63:d417:: with SMTP id a23mr9394020pgh.297.1642550869199;
        Tue, 18 Jan 2022 16:07:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n11sm13527252pgm.1.2022.01.18.16.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 16:07:48 -0800 (PST)
Date:   Wed, 19 Jan 2022 00:07:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YedWUJNnQK3HFrWC@google.com>
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> The restriction, with which KVM doesn't need to worry about the changes
> in the registers after KVM_RUN, could potentially protect or be useful
> to protect KVM and simplify future changes/maintenance of the KVM codes
> that consumes the values.

That sort of protection is definitely welcome, the previously mentioned CPUID mess
on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
e.g. if there are side effects that are visible in other registers, than an update
can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
inconsitent.

If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
a relatively common pattern in KVM, and provides a clear boundary to userpace
regarding what is/isn't allowed.
