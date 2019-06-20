Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304A34D999
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfFTSle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:41:34 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40410 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfFTSle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:41:34 -0400
Received: by mail-io1-f67.google.com with SMTP id n5so978442ioc.7
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 11:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bnNSwv6vtlQWGp/eiIohBlhjTQOOeCXZtmIH40KDQI=;
        b=SdRO1o4Dv3uJylFNXAeVIYPkEvywun2pv/WsTGBkVrhdWiMDQaDvJkWuUBD3ptdZfo
         KHsZAqb/0VXSI+pg2lzg4DoyPEX18u70VhZS25BdeR5UV9c1UqqFsyl5R7qIvcx/Qhvh
         wrcSjmNaZwYvCxLetHHCHVQlBO5p+fbTWGsm2Uh48nze5wONwuRGz5gtqlNhU0Zz7R9y
         KMZ+pDKB90OZkvm+vrfE+j3F71NSQYYfTsvbMvJz7ajW410iXCVQ+8NOlZVRcYwEnnHm
         h9Nw4Dcv/WDBmISX0zrdhrlBoczoWjv22Ym1uwfB8UMT+U+Gccu05KZiCLzg1r4ZqPHv
         OjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bnNSwv6vtlQWGp/eiIohBlhjTQOOeCXZtmIH40KDQI=;
        b=Kaa8Jx/JBIkGre5EgxYYYWcrA3nIaLkiLY5NkVvzsxg5lEwKPw1VEuOHnMni97avNl
         6l+ZnpbzyRuUeyTAwP4Svo5C3c2uo7YyLu7fE8A9qok9gi9uMxcaAc8+RxgippY4NwCA
         TB30PNyU+2cuTxtJlCJYp0Exf+OuzGbceOYI+z8qRl0ec/hVbIBu4PWet6gWMvO7kT6c
         LFqUSjO9lOI8jIxjL9hwLoJU4Ego8hl5NXZXyvZGK86pciNPFOzh42Qj6lnVjNWGTmKe
         LjAs/iqd5iP+ycw0hRzQvWvtfR1hLiRvsN2/26SKmgwcRsM1VjzSt8Xm+ou5lZWawxim
         Z9Dw==
X-Gm-Message-State: APjAAAV0gzP5bZk1xlfR9mrqyLm6FX9EANVLSZkYNOLuwMLgKFYyuk98
        9VgGGlYdblsXoUnCahlJDYtec7cX7BiJGWBS8/0da23PzUw=
X-Google-Smtp-Source: APXvYqxfGPRpdr5RB5w/4lIohLuEV2fFxQOtLYCVm+Two3E6fxDYIpOgEEnkOnjHIO6BGcdWZ8MyOKh7vcd+kfN6aO4=
X-Received: by 2002:a6b:f80b:: with SMTP id o11mr55413954ioh.40.1561056093467;
 Thu, 20 Jun 2019 11:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-6-vkuznets@redhat.com>
In-Reply-To: <20190620110240.25799-6-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Jun 2019 11:41:22 -0700
Message-ID: <CALMp9eQo3KW_qjW=8KPbJuggs-VOWsBgLjXYi1F6_1aoJ0kfsg@mail.gmail.com>
Subject: Re: [PATCH RFC 5/5] x86: KVM: svm: remove hardcoded instruction
 length from intercepts
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Various intercepts hard-code the respective instruction lengths to optimize
> skip_emulated_instruction(): when next_rip is pre-set we skip
> kvm_emulate_instruction(vcpu, EMULTYPE_SKIP). The optimization is, however,
> incorrect: different (redundant) prefixes could be used to enlarge the
> instruction. We can't really avoid decoding.
>
> svm->next_rip is not used when CPU supports 'nrips' (X86_FEATURE_NRIPS)
> feature: next RIP is provided in VMCB. The feature is not really new
> (Opteron G3s had it already) and the change should have zero affect.
>
> Remove manual svm->next_rip setting with hard-coded instruction lengths. The
> only case where we now use svm->next_rip is EXIT_IOIO: the instruction
> length is provided to us by hardware.
>
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
