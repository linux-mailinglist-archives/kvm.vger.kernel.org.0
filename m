Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8150D1AB5E8
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 04:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387984AbgDPCeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 22:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732144AbgDPCeR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 22:34:17 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444D0C061A0C;
        Wed, 15 Apr 2020 19:34:17 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h6so19399006iok.11;
        Wed, 15 Apr 2020 19:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itmXKVVHyhLg4W1YbKAR76og2TJJfG4RTgXOFdOAIfs=;
        b=AKvcIeylaJL4mM38i15Et+R3ijXRnPl6dbtXgWWUNoKE0vNTmaRSqugqfWcTiTv+0+
         /qEqY9utKcuBty9HFel7Hi4tuAN5IvwSP7L+MFKC/VSD9oJO55sT3jNry9EBGV8RSCZV
         fGs/VnbMS8uvOvYY0vB5PSO3qRgkp39khpesAubvBb3DZ+wzFJgkv0Idh6C9eApyd+Qj
         uyRe6UM0URWaoOQ6P6r7SxdyHGwKz/ZG/2NGVXDbS4LIKjG/dbfzBmtsahXrMWmYr2L3
         yWC7GRe3k1aV8M88ZmsdItgmh4GiGGUPNFKdnbM8WNA73VgSd5wtDNKJw0QvvipHkgh9
         Zc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itmXKVVHyhLg4W1YbKAR76og2TJJfG4RTgXOFdOAIfs=;
        b=TopH933RFutb/W6ByfMpou7pGqpzlIukZbIe15Fx7Hq4mbAJ9FHJP71jlzlMLZoACY
         heU84eukIRTm+wEPqgfZJ6BUBfOI1HpVbwGP74etc09usw2X5Tl/LN0QZUWM1GoJ44ac
         UZWCNV6LWG64DNIxPP3KOAN5QnuqC5lalXM+l4XnNGBIg8XbItH207eDZoUb3JvoouoW
         M++7KUG/+BJkyo+ZxDBir33BIAi64Hx9TZDHcPVPfcHjll9aRd1rbxcw7NYC34Oqty26
         BrRlwSzc7fT2+OqGXjX+eczFEB593PFETAn0Qhzoi9EpwUq4B59FJDrGsw95Ti5mFlK+
         iXqA==
X-Gm-Message-State: AGi0PuYJx6VplMFn9w/R6D2hHO/B/9Opd4jLLPEQfGJTKVrwn3vD5aMJ
        jaEG5/L/hDGkj19yjjMXuiVNRxqP5Tro+ac7jDgjiTeg
X-Google-Smtp-Source: APiQypKUzKRz1ojShZLzll6LlFHpm4yH8NN5p1XpJRJ2u8XiXVRaiRkeYPaOeK2Zy3/dI8zwAu/ZQ4tDDcBpbKHkUDU=
X-Received: by 2002:a05:6602:22c3:: with SMTP id e3mr29157327ioe.75.1587004456483;
 Wed, 15 Apr 2020 19:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200323075354.93825-1-aik@ozlabs.ru> <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
 <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru>
In-Reply-To: <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Thu, 16 Apr 2020 12:34:04 +1000
Message-ID: <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
Subject: Re: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA window
 at 4GB
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 11:27 AM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> Anyone? Is it totally useless or wrong approach? Thanks,

I wouldn't say it's either, but I still hate it.

The 4GB mode being per-PHB makes it difficult to use unless we force
that mode on 100% of the time which I'd prefer not to do. Ideally
devices that actually support 64bit addressing (which is most of them)
should be able to use no-translate mode when possible since a) It's
faster, and b) It frees up room in the TCE cache devices that actually
need them. I know you've done some testing with 100G NICs and found
the overhead was fine, but IMO that's a bad test since it's pretty
much the best-case scenario since all the devices on the PHB are in
the same PE. The PHB's TCE cache only hits when the TCE matches the
DMA bus address and the PE number for the device so in a multi-PE
environment there's a lot of potential for TCE cache trashing. If
there was one or two PEs under that PHB it's probably not going to
matter, but if you have an NVMe rack with 20 drives it starts to look
a bit ugly.

That all said, it might be worth doing this anyway since we probably
want the software infrastructure in place to take advantage of it.
Maybe expand the command line parameters to allow it to be enabled on
a per-PHB basis rather than globally.

Oliver
