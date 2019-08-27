Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9511C9F0F2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfH0Q5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 12:57:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46056 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbfH0Q5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 12:57:37 -0400
Received: by mail-io1-f65.google.com with SMTP id t3so47828498ioj.12
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGOUb6qETbWsgAJoalsCTFlAvdsb83uQVVXs/w4mwBE=;
        b=VBIsrc0k26FUtEar2ReJlFb0cg8xeFC2xexRrOXNtYtYJjLoug03whgz8WJlzMuaDQ
         7JK4jplpFQZ8tCMjKW8F2AKSdfMe0/ceSV/ixQVYo8W2MIizdFxT8C1GuY3dusICVPE3
         z9vUBtjOJBJHbjPFAkhEj8hvRBhAV5Tw5YgAnSzqZLgkZnELvo83/PqcA7lmTe/S/ZYP
         v8XbQGjooZ8kU2BJ7I32GgDLo3l1CeWZUn5JoE5AExetPx0bpdPSN0DF8uknSNTZBYgR
         FGKhWxbUpCK7/lSfOHMiIVnProPheI9lKMJfp0/Ck1ye3VbZdIJYUJ49YgjOtyEWc1qO
         GATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bGOUb6qETbWsgAJoalsCTFlAvdsb83uQVVXs/w4mwBE=;
        b=tDyx3uFZyOaCZPUYHNzxFFojX0ca4NKW+gVhf7AKGTx5r85GWHGPtFvJWo5uiAa4R8
         fYHGAIeXCQmhvVIyrmjGWgTEyR42bvhyL36G5FFC5Hwz+MqgxMrZ8i+xI/RsJQf0eCxc
         z2xQTOWG+kKgT5aX3TjUHfBBZUhH/y+V6VQCIvmEzdQyh/QPAkDakIkMpKAH9wSlyDsr
         RJ+Sed+vN9hWmS8z2XF3dycNG8v39Iz7/iBaV2lVIrRt3juOJPNolVG/lspPZ+PYhWXS
         m37DoDKG5fpaIth1iwuj2g+ZhNM7qjCI0KNojZz3Em5hMUTky0Oc6T6VY8zSrk55iQ8c
         WUww==
X-Gm-Message-State: APjAAAVB60QAvayeAKCCQ14TkPj7DeIurEoR/WvYroZSnc9KT52pPwMp
        mkg/aksspxqAF3HxfB6UlxXW9IpfM1V664BV2Sk7Og==
X-Google-Smtp-Source: APXvYqw5P+1iPQwzpQ0PkMddqAw7dDWHOpCeRE8Gzm38lrWZHgeRKZTaqN/9e3LzgB/+45/Suy7SL7Xu8mCoHsnZz8g=
X-Received: by 2002:a5e:a811:: with SMTP id c17mr326399ioa.122.1566925056306;
 Tue, 27 Aug 2019 09:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190827160404.14098-1-vkuznets@redhat.com> <20190827160404.14098-3-vkuznets@redhat.com>
In-Reply-To: <20190827160404.14098-3-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Aug 2019 09:57:25 -0700
Message-ID: <CALMp9eTE4JsUsU2CRE-Y04_nuqpjav1YohuW8SsSdh+m8s=7mw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: svm: remove unneeded nested_enable_evmcs() hook
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 9:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Since commit 5158917c7b019 ("KVM: x86: nVMX: Allow nested_enable_evmcs to
> be NULL") the code in x86.c is prepared to see nested_enable_evmcs being
> NULL and in VMX case it actually is when nesting is disabled. Remove the
> unneeded stub from SVM code.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
