Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844901B87CD
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 18:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgDYQyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 12:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgDYQyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 12:54:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFDAC09B04D;
        Sat, 25 Apr 2020 09:54:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so4626738pjb.5;
        Sat, 25 Apr 2020 09:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ni7dX1B7pi70mNP8/hgrlsRSdpbg/0CNNTaHtJC2aBI=;
        b=ZB7oVq7fsOIznxNS7UZhzn6Makn3MVh/Kbd5M1MhKtQ7IVzXRT8b0T4OR+HsFLeDf0
         16s/BRqJ0tII4C67qPq3tbfd4TaxpWmqVNhsJk6kdtBGJs3+9/VfQX54W+zowmirKHOW
         Y7Z8uS4tho7igDx/US3ImS4KKFPXagoW7E4uf7LBZ9XAp1dkVAJpZn5beBXkT9ZsXWRd
         inkzCrJnV5djMsXdzOMzVJ2czjDS28tW0tmxjhUqStCZfKIla7I3Isar0lJpXG9jjHqS
         cgrSaMTd7T5VodoQzTM8VqAUwz/DzbOgrKECm4z/RJYhcRfiGYcwmbKFuhHa2yevxBon
         KDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ni7dX1B7pi70mNP8/hgrlsRSdpbg/0CNNTaHtJC2aBI=;
        b=TniSzqkuAIikBqVmFkZ0EWsSgEIlptNHDRribHWKYbV58m2NsXThliq5tE9AZZainV
         gkZ/URaNBu0eRbvSVBZFst87ey36k2A9UnxBlqEGHAqCzdJe9cf6FAuqmKVrk/baOUtV
         gdirXzrbAfQ/ecSrWjZttn2qhuyPyW15bk6WltuiHd50Ibq5X2mNl7uG99qkwyitZZY2
         ZImx5JtcogBMtrRR3EOXQtbCCPQiyC5flevYZxuOfpthfv1X+7ObPF/kU3aGyTvpBdoL
         tA6uTeoGIagipXDSsXyHy+5/iy+H89piLfhTvQGZG+YmK4x5BebME9+VNNd7hnA7ci7e
         R1+g==
X-Gm-Message-State: AGi0PuYXzw55qXXDNuipZCcC1U4szsjgpTVBveezQM7g0YI+xQaPSezT
        V0fd8KtR4zfCNunZ/1OZXxA=
X-Google-Smtp-Source: APiQypJhvMOXcEqGt6tXZHSLN+DNe9cAdJX+NSPOYfKzDd5EYKyzLqQq0zW6vraDp2ui3eyKU00toQ==
X-Received: by 2002:a17:902:a5ca:: with SMTP id t10mr7463608plq.300.1587833649881;
        Sat, 25 Apr 2020 09:54:09 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:6553:6836:584f:1008? ([2601:647:4700:9b2:6553:6836:584f:1008])
        by smtp.gmail.com with ESMTPSA id v1sm7424946pjs.36.2020.04.25.09.54.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Apr 2020 09:54:09 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <85cb5946-2109-28a0-578d-bed31d1b8298@redhat.com>
Date:   Sat, 25 Apr 2020 09:54:07 -0700
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <08C6D1FB-A4F7-49FA-AC46-5323C104840A@gmail.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <85cb5946-2109-28a0-578d-bed31d1b8298@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 25, 2020, at 1:07 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 16/04/20 12:15, Xiaoyao Li wrote:
>> To make it more clear that the flag means DRn (except DR7) need to be
>> reloaded before vm entry.
>>=20
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>=20
> I wonder if KVM_DEBUGREG_RELOAD is needed at all.  It should be easy =
to
> write selftests for it, using the testcase in commit message
> 172b2386ed16 and the information in commit ae561edeb421.

I must be missing something, since I did not follow this thread and =
other
KVM changes very closely.

Yet, for the record, I added KVM_DEBUGREG_RELOAD due to real experienced
issues that I had while running Intel=E2=80=99s fuzzing tests on KVM: =
IIRC, the DRs
were not reloaded after an INIT event that clears them.

Personally, I would prefer that a test for that, if added, would be =
added
to KVM-unit-tests, based on Liran=E2=80=99s INIT test. This would allow =
to confirm
bare-metal behaves as the VM.

