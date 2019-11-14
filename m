Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB15FCA5E
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKNP5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:57:10 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38525 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfKNP5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:57:10 -0500
Received: by mail-oi1-f193.google.com with SMTP id a14so5707270oid.5
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 07:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yjMXCbazTOSF5ZA1NpqAV9Px3HPrhaWxcfkJjI+LIPY=;
        b=wss5Uy39oJlSYHFFHHEOWzpAvbWEgcIP3BFM8PM3bJBmSYB5EXD9/2b6UZMZUiiJb9
         yLhZ2DyPKwFcRVAZkdxSjetdSPm0YuTCliwOyZKPAH6SNN2YXCW7A2CccOccn3vyw/wu
         icYtnF9cSXXIopsv8FpEvj3zWIClYBExFqIcLxdKVzmqfQKrVu/eMrO+/f4OtTUmtYma
         1kE6I14Mxtait7vHzk49xNI3TkVimWfzP3/dDbIrBP6XVVZ7NpZuZ0ujOaQuruHXfRc4
         dhy2SdCZklRn/3RI6JWPKBhtBtoWiXndUT/TCfVWXwvCmoFARhJrMmUcwdGcdOPCKGlb
         1F+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yjMXCbazTOSF5ZA1NpqAV9Px3HPrhaWxcfkJjI+LIPY=;
        b=QPBwu5C3AAVPYd1ZsPCTKpyRm/UgFo2CD7c7rmw0A6a08InG1U7IJQVdtKpqaKZmF1
         a6N/BpOSoI5ZTKCGdCJgdtW4nBv4serNo+9LZao26ilNPMZf/mJ3pAsSOr5ZmaEFEbq6
         9Sx1ossVwAuqBISZTCTyJRNb5ZlE656aTRreIft/toK0EIfQnmfsXUi8OstzyIBcCldn
         KOUePm3OvC2eFLWPAVKLKiPC23Cg7NVNFIWqVDZKIMiL7YcHdHlIxvEx6it9UTI7tMcO
         J1deRz13O0SCTcWaKd6R3eQLkj6fnTHkr8XuCDzGDgDlN1aZ2mDG5IWzNwiGS0H19Rfi
         ZrhA==
X-Gm-Message-State: APjAAAW0rkm9OsI3lp+0bgJkttVG81V6ew3lhlkXrAYJTyhUEYcEA8Jx
        PVWwRfO5kkNQ2AugDpUki8CQGDmSrzzgSVZ3jr6JaQ==
X-Google-Smtp-Source: APXvYqz5IQbjutZdvvYa/3o0Mr6hqGWXbe7G7tQsit1pTz8/pYN9OG6VZnW+z/gr1RizUorqEyF5YU2yY3mz3vzG/rg=
X-Received: by 2002:a05:6808:b04:: with SMTP id s4mr4127338oij.163.1573747029581;
 Thu, 14 Nov 2019 07:57:09 -0800 (PST)
MIME-Version: 1.0
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com> <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com> <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
 <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com> <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
 <CAFEAcA_kcQwrnJxtCynX9+hMEvnFN0yBnim_Kn-uut5P4fshew@mail.gmail.com> <241e3df3-e3e3-14a0-3fbe-5398a1bf9d00@arm.com>
In-Reply-To: <241e3df3-e3e3-14a0-3fbe-5398a1bf9d00@arm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 14 Nov 2019 15:56:58 +0000
Message-ID: <CAFEAcA9-BPCN2VC5qJO0oPPPdVbai05KM68eMUxA3tDn_10LFw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping GICD_CTLR.DS
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 at 15:47, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> On 11/14/19 3:27 PM, Peter Maydell wrote:
> > The virt board doesn't do EL3 by default, but if you add -machine secure=true
> > to your command line then it it should emulate it, including a
> > trustzone-aware GIC.

> Indeed, and that made the test fail because apparently qemu implements it as
> RAZ/WI (which is allowed by the architecture). Thank you for the suggestion!

Hmm. The behaviour QEMU thinks it's implementing is:

 * if we have only one security state, then CTLR.DS is RAO/WI
 * if we have two security states, then:
    - for access from NonSecure, CTLR.DS is RAZ/WI
    - for access from Secure, CTLR.DS is initially 0, and is
      writeable, but if you write 1 to it then the only way
      to get it to go back to zero is to reset the system

thanks
-- PMM
