Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31894F5D31
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 04:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfKIDbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 22:31:49 -0500
Received: from conssluserg-03.nifty.com ([210.131.2.82]:35601 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfKIDbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 22:31:48 -0500
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id xA93VZJr005710;
        Sat, 9 Nov 2019 12:31:36 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com xA93VZJr005710
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1573270296;
        bh=6OHje3sJ3IH4vfH9hJBC9ocohmUm5nws/CQJC/szrJQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sx+HneNN8cr5CBKlq9ynCzBxH8/Mo1voqRskEijABmx2mUDJM3GEUf8RqIbrCSwcX
         LuG8PlfCEQWsPXk7isXAxwea9nyV3hgP079wAoDzZ/tVArTyQ1hZj/Wgj4Jcx4CcOI
         Vbs/2Be3VF2fqdwlnyRYreiKgS4VGuFa9QYeKVj2UHX76aPuHp0I/FVF/CJ+JcUOo9
         DYBNk+Cwkn0gCPfok+ZHdxC+oxVpt4sf9vDPT5/yWw59e44DXFwPu9w/iI2hmRh4w/
         4HibnS6QxbJjXYpx1s2Z3IZCS/cY0QdyC/zh3e5JEbQcZ3RTj8GStiL3RokZz9FK44
         7+bGB6s2Pvv6Q==
X-Nifty-SrcIP: [209.85.221.181]
Received: by mail-vk1-f181.google.com with SMTP id k19so1979609vke.10;
        Fri, 08 Nov 2019 19:31:36 -0800 (PST)
X-Gm-Message-State: APjAAAUjgLUpWOx5dcbWQZchYLRF6ohSYw6vXD1QtsfJ6YQpaQFP55jo
        zcr7lYyAKDVVpqtOPBLD57N6yTKR3N2o+r1zNe4=
X-Google-Smtp-Source: APXvYqwn1k0Py2w8hdwvLc/AH0HjvRnF/eQ3fqI+Dv0e7f7OFpcw5uDcnzNWwC/AykME9yoPfKDpIJ4V0MmplWRv1Sc=
X-Received: by 2002:a1f:7387:: with SMTP id o129mr10392097vkc.73.1573270294578;
 Fri, 08 Nov 2019 19:31:34 -0800 (PST)
MIME-Version: 1.0
References: <20191104230001.27774-1-aarcange@redhat.com> <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com> <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com> <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com> <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
 <20191108135631.GA22507@linux-8ccs> <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
In-Reply-To: <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 9 Nov 2019 12:30:58 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQnLBDPEW_EWGxoqF6UOb2V2tH+R6f3HuSnwujJvjY=bw@mail.gmail.com>
Message-ID: <CAK7LNAQnLBDPEW_EWGxoqF6UOb2V2tH+R6f3HuSnwujJvjY=bw@mail.gmail.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(+CC: Lucas De Marchi, the kmod maintainer)

On Sat, Nov 9, 2019 at 4:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/11/19 14:56, Jessica Yu wrote:
> > And I am
> > not sure what Masahiro (who takes care of all things kbuild-related)
> > thinks of this idea. But before implementing all this, is there
> > absolutely no way around having the duplicated exported symbols? (e.g.,
> > could the modules be configured/built in a mutally exclusive way? I'm
> > lacking the context from the rest of the thread, so not sure which are
> > the problematic modules.)

I do not think having a white-list in the modpost
is maintainable.

>
> The problematic modules are kvm_intel and kvm_amd, so we cannot build
> them in a mutually exclusive way (but we know it won't make sense to
> load both).  We will have to build only one of them when built into
> vmlinux, but the module case must support building both.
>
> Currently we put the common symbols in kvm.ko, and kvm.ko acts as a kind
> of "library" for kvm_intel.ko and kvm_amd.ko.  The problem is that
> kvm_intel.ko and kvm_amd.ko currently pass a large array of function
> pointers to kvm.ko, and Andrea measured a substantial performance
> penalty from retpolines when kvm.ko calls back through those pointers.
>
> Therefore he would like to remove kvm.ko, and that would result in
> symbols exported from two modules.

If this is a general demand, I think we can relax
the 'exported twice' warning; we can show the warning
only when the previous export is from vmlinux.


However, I am not sure how the module dependency
should be handled when the same symbol is exported
from multiple modules.


Let's say the same symbol is exported from foo.ko and bar.ko
and foo.ko appears first in modules.order .
In this case, I think the foo.ko should be considered to have a higher
priority than bar.ko
The modpost records MODULE_INFO(depends, foo.ko) correctly,
but modules.{dep, symbols} do not seem to reflect that.
Maybe, depmod does not take multiple-export into consideration ??

If we change this, I want this working consistently.


Masahiro Yamada




> I suppose we could use code patching mechanism to avoid the retpolines.
>  Andrea, what do you think about that?  That would have the advantage
> that we won't have to remove kvm_x86_ops. :)
>
> Thanks,
>
> Paolo



-- 
Best Regards
Masahiro Yamada
