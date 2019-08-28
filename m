Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3611A0743
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfH1QYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 12:24:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43077 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfH1QYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 12:24:37 -0400
Received: by mail-io1-f67.google.com with SMTP id 18so672379ioe.10
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 09:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1lLimGMYhfmCL3MKSeS32GLZr2shj1mXSQdp3B8730=;
        b=ofSVl+blw2/4lc/BpfotBwPm68T0GUBhYn2TVoo6BIKVGtOfIrFEKZK+pVGkY/id/v
         ApBscizv0pvB/os00gahz9wmDuYhvyhgHdpHtTjg67O3SsZexQvBNjhYQQzNP5vqzl+Y
         dk47lAClDeZDmUPm5Oko6rc1i+IwiSHtE4hewoKm2dLTdAqfmSQSqhNgpAHrzX9Ce/it
         dn3fDMrFnlrzDR6odgC13+w31g9sVRAqL2FBT+aLM0r99ae4Au+q1ulsCQRbYF4MV4vD
         RkLlQbA3fthbHRtpaUIa+qSgrs1ltTsqUvMO4hb5xa6gnrMdBYsgBkuKY9P2VQ6Uq7rI
         T2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1lLimGMYhfmCL3MKSeS32GLZr2shj1mXSQdp3B8730=;
        b=mdywm5YRw3oYDzgbeSAe2D9wKHfGqaDqmP8Qgg3KKiuMuEAdy7unJthY3Lus1XnbNS
         uh1x1FxkibWGkxApDbz3gM1d8IKI1/Z3Lu9IxunzAaIAA27IUAMaVDSk1Rz1pmi2yG7b
         kwR17coohpVKRStq5O40KBV1779SMvVSlVFP3Xvuwnaz8dfsdPiDoSKbJMzc1NFgIr39
         cl8ekniQ/NlJcSCAtoNwLm9CDKiKBxf/ab0/dhRjVCh0ALUIegAa8gtBX1OOPFAElLUv
         EhW6Oh2joT8YaWz/7cKh7Wl19HaDAqmxhDKwzuS9nwzTCtdRS5+miSrrM1xYtWB+3k3h
         LfUw==
X-Gm-Message-State: APjAAAUwzNjc21eHFaFKDurEmmrvjLq36mBflGUK1kuPIhew2DpkKwWg
        kmt03la6g5A9TZNFwjKnrhIE8ylIfA5LuPK1ZzSThIfZiw8=
X-Google-Smtp-Source: APXvYqy75W4ZP+4Mea96982CTuaW26M/54Xn2KLmojJRs1wlL52kL56BQ3O3f/OEsss37qyJsNrqN1tJKeeS8MGj0RM=
X-Received: by 2002:a5d:8f9a:: with SMTP id l26mr1849026iol.26.1567009475969;
 Wed, 28 Aug 2019 09:24:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190828075905.24744-1-vkuznets@redhat.com> <20190828075905.24744-3-vkuznets@redhat.com>
In-Reply-To: <20190828075905.24744-3-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 28 Aug 2019 09:24:23 -0700
Message-ID: <CALMp9eTB_yoYGoNQ5DP+XtVbM8fD21aSD+D6onaE7gCxJueqvw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS
 support only when it is available
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

On Wed, Aug 28, 2019 at 12:59 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> It was discovered that after commit 65efa61dc0d5 ("selftests: kvm: provide
> common function to enable eVMCS") hyperv_cpuid selftest is failing on AMD.
> The reason is that the commit changed _vcpu_ioctl() to vcpu_ioctl() in the
> test and this one can't fail.
>
> Instead of fixing the test is seems to make more sense to not announce
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS support if it is definitely missing
> (on svm and in case kvm_intel.nested=0).
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
