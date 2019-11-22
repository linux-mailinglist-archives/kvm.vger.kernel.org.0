Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E43107988
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVUiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 15:38:05 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35383 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVUiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 15:38:05 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so9577430ior.2
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 12:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4EY+L0eGZ4WSKeWrVoqmJLDgGRBkaxrsR16Y79FkEg=;
        b=rbT//6qY1fpKENEcz7UjkdeZ0G9BIwLj3plBAuSXus5TwMrw37kWVyChPz6Y7phbBX
         KzH6HO8sBlEjFs9AgEzBpqHjRC6sZxChsXaTv+QFyEuHrpuHqFnAdXcMzSbS87poMWc2
         sgmmUJn0hYiuILV9ecWSMWZwV9royWKR2DEt/rYKT19McfBOfZzSnLJFTE2RnfK54/6a
         UodMlkeomEdMoYn+dSoZCu1iCkqP/eFbOd9KrmYA+SaGUq0yqpCOLm++NeM2l70f+W4V
         io5QbPZUd3Mr0SPlKhBOzBHw97cmnhvGFl9P5gPBjeNgE0NNDYBSyk7H0YHnURaf3zaB
         iZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4EY+L0eGZ4WSKeWrVoqmJLDgGRBkaxrsR16Y79FkEg=;
        b=RAWUNGVJBxxMpKjJMzAbmSwlPip+pmRkHqJ8qLygThu3eyLJ5kTWHGQ7Ew/YRQgpzR
         BelddasVEdQf6T6mUuKI3B4pzHrjPbMrUwgwQ01+UR5PiIgMyxWsy0/1BsLFhD8mrcBs
         1J9YpK18NrV/VaFyDBYRaQBxULzcMFB9tSHwFyEb6B1N7gn1w69rZ7c7u4oiLEAqgcWw
         FvkySdIoJiUCTawtRSbg8XzbRlwFk7Prwwe1k+ybieyCw1qoWdGhkuATM+99sDkX7OLo
         WoeUUbwtqnJSZKkpqvgUs7o6hrTCaEMXtQHFCJUsbqEE09oa38V2gTYNqb+rWkX9yZgG
         Lr7Q==
X-Gm-Message-State: APjAAAWkVvfkleYO303Ttbx694MaFzPnEW5zuuPYSdtUzP8ayZ2/W8YM
        +LiUF0vaT54RkPLKz+0wNtCCSl0o0fTARFOgS9LcQw==
X-Google-Smtp-Source: APXvYqw5ZsjN6vcHfYbxED9Va4YQZrgZvX410QXLamUq6cXoprh45iLKHBNFHyA73grdoto1ozpgBov3t05ZstVzb7Q=
X-Received: by 2002:a5d:9b08:: with SMTP id y8mr15622207ion.108.1574455084320;
 Fri, 22 Nov 2019 12:38:04 -0800 (PST)
MIME-Version: 1.0
References: <20191122201549.18321-1-sean.j.christopherson@intel.com>
In-Reply-To: <20191122201549.18321-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Nov 2019 12:37:53 -0800
Message-ID: <CALMp9eSL0LPjOBtKpTuL-SAYUiwjrL9raMnSdX3hyW9WkO4B-g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Remove a spurious export of a static function
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 12:15 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> A recent change inadvertantly exported a static function, which results
Nit: inadvertently
> in modpost throwing a warning.  Fix it.
>
> Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
