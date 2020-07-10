Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E950021BAD1
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgGJQZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgGJQZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:25:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18171C08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:25:13 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a6so5521139ilq.13
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IcDMEhTSKKMXTowJquzFDFHW0B9rJZphvCEGihxlBug=;
        b=lLxKHjlVieE8CR/C5FWlzc7Uis/0nuwWMvc4hUOICx3oO4m/PttpooF9Mfku50uTuz
         pbnZevuDsAvUwVhSH2i1Nd6lpOBQzVB6TDXzhXu8318gMbmyO/OjdyNHdHnbz5kvy/J+
         3FS0W7SMo3hcsVmFYEmHhG+8eUXCsBoAm3xnKtZw9P1CTJEQqC0YKOviRG6ubCfAaxaf
         RO6zqusol8TO1/uZctwduaG05iNaFYJVhnwMn/wBO4+QJdzfFFkSWfHUK87pb8boRXkH
         nP760DKxd+QNElhvMSp65xXZazGWiaN06ArD8BtuDLN0k2OEsNupQGnE1O05yXSKjYEx
         ob4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IcDMEhTSKKMXTowJquzFDFHW0B9rJZphvCEGihxlBug=;
        b=pA9fQrMAHmQil4muBLQi7wMTLGTqUoadgVUdfcoq5sC1/aWGXO4gvCEZJFUSZjLK5N
         MKZ+4TnonNEFKUYfyCUgHZgvBfVNkBo4OWqddEwAIA8Oh0polema6u10u+h8Hm1eT+42
         zYGsNZhfJFTSUUQBYfGHe4UmCXelYM/nnGUJ18UvL6S/pt4rI3XOF/aZAtcov98MGQL8
         oO+ROY/b3pS0ZiyJZSKmCr+xt61WrjJjqxLiuR6y+F7d7FVs6lvj8eJaVCrtNaUreAhl
         L4Vmwze6QK05/uYcjD19SIQ0V1Ya6ltlI/74Jxvx+pAFTR5+gOXwfsBoCSw7CTLP6v3N
         640Q==
X-Gm-Message-State: AOAM531F8haqtRRXffaq//m5y6VpzE5C+eJzRMUC70PXT8GZ+XoSGGqB
        T5N3ARyhPd/Q/G3zMS1ExeEDm7LrtFCm3o/ujFsm+LR0
X-Google-Smtp-Source: ABdhPJx9kxVePErlat1+e+tKLypo+bvNuYSB4wDq+i1m1pqY+SMTsBHy1h3u6qRFuDiZ87hhCu416AWVwxklMXbnREo=
X-Received: by 2002:a92:aac8:: with SMTP id p69mr54333019ill.26.1594398312271;
 Fri, 10 Jul 2020 09:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-6-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-6-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Jul 2020 09:25:01 -0700
Message-ID: <CALMp9eRXZmtZ5zZ91q3Q0i7Yg5XUNAyLxWaX91okZ_ogNikKqQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: update exception bitmap on CPUID changes
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 8:48 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> Allow vendor code to observe changes to MAXPHYADDR and start/stop
> intercepting page faults.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
