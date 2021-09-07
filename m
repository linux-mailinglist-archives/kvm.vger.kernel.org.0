Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FDC4029D3
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 15:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344706AbhIGNiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 09:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344664AbhIGNiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 09:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FDA60EB7;
        Tue,  7 Sep 2021 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631021868;
        bh=aGK2dcSou8XexWMUytCSYbgfygwqSAPDqtXuf+UXqOw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RYDLqIr/p1PCNyZkxKeuh2ErR9cdhCMuDUHa27a1QxV9AdMjhtFwwfakIeuyuUrnz
         Q7f7ZWbsLbPRFTUoPKP7FdnsSbCW0pMz9IZvvWlbGvrB5oktkU4TW7QeW+h4z3pbA+
         4WxlkcFrHPAGI4sHvokUHFg0zeU4SDEv9Njei0CaY9vftkbRluhjkLybtXX0DLHrpo
         SE3qh3LgLPkBbruQ6WO4Lra7HaWRIUwsRiqDu8VSRrcHsPu3cn8C8Jt4y7alXWM497
         KvDb6jLLjw+eE/B27OhBj1IcEi7iJcKIJ4qipYpb0DED5zNk7ZRVi5K3YtqmbFOvcx
         176R8xkVm8pOg==
Message-ID: <80cb912c6ef946a0b0c82bfdccaa92c82fe41d47.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 07 Sep 2021 16:37:46 +0300
In-Reply-To: <a43d34d5-623f-20f3-c29a-56985d5614ba@redhat.com>
References: <20210903064156.387979-1-jarkko@kernel.org>
         <YTI/dTORBZEmGgux@google.com>
         <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
         <a43d34d5-623f-20f3-c29a-56985d5614ba@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-06 at 10:35 +0200, Paolo Bonzini wrote:
> On 03/09/21 17:58, Jarkko Sakkinen wrote:
> > > Eh, it doesn't really simplify the usage.  If anything it makes it mo=
re convoluted
> > > because the capability check in kvm_vm_ioctl_check_extension() still =
needs an
> > > #ifdef, e.g. readers will wonder why the check is conditional but the=
 usage is not.
> > It does objectively a bit, since it's one ifdef less.
>=20
> But you're effectively replacing #ifdef CONFIG_X86_SGX_KVM with #ifdef=
=20
> CONFIG_X86_SGX; so the patch is not a no-op as far as KVM is concerned.
>=20
> So NACK for the KVM parts (yeah I know it's RFC but just to be clearer),=
=20
> but I agree that adding a stub inline version of the function is=20
> standard practice and we do it a lot in KVM too.

OK, this is perfectly fine for me (I care most that we can do this in
SGX side).

/Jarkko
