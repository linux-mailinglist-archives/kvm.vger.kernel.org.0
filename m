Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CA630CE68
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhBBWEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbhBBWEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:04:32 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8F6C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 14:03:46 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gx20so3316281pjb.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 14:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/FrjqYRUuRwK8S8uhoaD4ADwfZIJ5IDa1H6e88pRYWA=;
        b=AStmNRjOiZW5uzqLBZcXuKDhi9znb+xM6M5y9GNFf8RdX12D7NCABTjkVxFktsGjso
         xkw3uQlPwFl4zoLCcQKtj9GByFVFCt7/rNRHTaNwXwOWum0vlq73a2fLYYvv0i6A0woP
         csMQ64FEANdOPT6jF0WaRJml2SN69Ql/jXvisXACRZTs3/j1xhkbJkpBwUM8WOxCA8E1
         Sqt9HmcHaXcuXOCa7FblI46rSVoWA9cYnqKSnqHYoomkjjNvFAFu3jyNZvGDOyCQFSTH
         G5nzSxSerxeyF2ZP0O9n78j4VbdyOXezHllPCiejP1Kz4ccrZBBVhSrqZxKz2r/WDhwL
         4KHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FrjqYRUuRwK8S8uhoaD4ADwfZIJ5IDa1H6e88pRYWA=;
        b=VCjT9/ZrwjHV4+4XfELVuhe6JHc79tUPAJNpYYpPSjY576VvauF94gX4Ktb7OK1o+A
         /nk6AJBKx2JfW7oMt3/nV9faLOg2UjkmoYrtLQxWeVUCA8C5cZkHyla7co/ykI2F+9HC
         A4zXUs92KKBeTOGGBT6Ov6SuU/LYpXNVEtK0keVrErrzppju/eW7ihZGkq4gosT0JrFB
         cW9xhgyZZcB48FBERzLQva6QeGkC5C8PA4krDiRaxnwQCge6HZ/dWsNIwI7QRL1WSC6v
         DZB5eSFakGEalGVPrMJox9M8XjWseas1Ko3GtlEGBd1wbAMilh7/KO9zyFZ71w8mrO5M
         ejIw==
X-Gm-Message-State: AOAM530N+qzXTEbOqPFzvxYL9f8//Xe334uef7gyGO0ilX+DVNzsLhq7
        NJdJg1LKa6hRmQvOBLL7J5w5Ow==
X-Google-Smtp-Source: ABdhPJyfItTY9BGF90ULdUUyIRsLBQvj/qCseMOc1dy33i1QselrIGc2B1c042kdzeeHzkj1mLFJew==
X-Received: by 2002:a17:902:fe0d:b029:e1:681d:31e0 with SMTP id g13-20020a170902fe0db02900e1681d31e0mr934plj.9.1612303426143;
        Tue, 02 Feb 2021 14:03:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id o190sm22216367pga.2.2021.02.02.14.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 14:03:45 -0800 (PST)
Date:   Tue, 2 Feb 2021 14:03:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 75/78] include/linux/compiler-gcc.h:96:38: error:
 inconsistent operand constraints in an 'asm'
Message-ID: <YBnMO/+CJUsq9Pu9@google.com>
References: <202102030530.9h17DoZg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202102030530.9h17DoZg-lkp@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   21f7d796fb43e13f71746be37985da90df27e66e
> commit: f84a54c045404f00bd77bf64233dad52149a6361 [75/78] KVM: SVM: Use asm goto to handle unexpected #UD on SVM instructions
> config: i386-randconfig-a004-20210202 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=f84a54c045404f00bd77bf64233dad52149a6361
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout f84a54c045404f00bd77bf64233dad52149a6361
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/compiler_types.h:85,
>                     from <command-line>:
>    arch/x86/kvm/svm/sev.c: In function 'sev_es_vcpu_load':
> >> include/linux/compiler-gcc.h:96:38: error: inconsistent operand constraints in an 'asm'
>       96 | #define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)
>          |                                      ^~~
>    arch/x86/kvm/svm/svm_ops.h:21:2: note: in expansion of macro 'asm_volatile_goto'
>       21 |  asm_volatile_goto("1: "  __stringify(insn) " %0\n\t" \
>          |  ^~~~~~~~~~~~~~~~~
>    arch/x86/kvm/svm/svm_ops.h:56:2: note: in expansion of macro 'svm_asm1'
>       56 |  svm_asm1(vmsave, "a" (pa), "memory");
>          |  ^~~~~~~~

Blech.  The address is technically a physical address, but VMSAVE, VMRUN, etc...
consume rAX based on the effective address size.  Patch incoming...
