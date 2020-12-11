Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1932D8123
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405358AbgLKV2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 16:28:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392101AbgLKV2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 16:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607722034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2baaQLSNBEeqb8s4I052o+MuhTpKsGsOVMcltvWRcFE=;
        b=MS/6rZbU/buc9zcnquU9rlpJ7y6a29qJAmOsKrzkVtmTZyxPFJ0NPAiB0rgEoJFTJvx2V1
        Z9YEI0TC0K0ndOiqNDziy+/tOtgq41Zpah5T2qcJLr10T/LTEsUh6KFqu4MK8Yty+J+5DT
        UQLIzxVDLGm2q9BGWkNvwWa/gAsIOsc=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-hixGFL-SNAKLSlbKDHwIvg-1; Fri, 11 Dec 2020 16:27:13 -0500
X-MC-Unique: hixGFL-SNAKLSlbKDHwIvg-1
Received: by mail-ua1-f69.google.com with SMTP id 93so1945308uax.12
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 13:27:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2baaQLSNBEeqb8s4I052o+MuhTpKsGsOVMcltvWRcFE=;
        b=sakE1sF4LWU3IJvah72fCH6TSDVAEBgKj8qw9dODJxLHHp7XeOL3aBPhnNA/YuFgI2
         UMpUABiWZrqxc08+VtB5iPvesovBfMDfD037NupulbHHPeeiZpQPVC/zo5IqlhRW6FcS
         Qv9WSIs8O/v0m3GsEZGZtBP1DQDCV1dXhMFY8tfxW6AfE8Wnn6A/CwPeTCW/Kf8G+sXc
         2++NydDxHZ/OQADYklpRt+8cfkAWfqpGOdzn6PWZh3K16zEthIYhTl3iyN3XTL7nMyxc
         o6XNFZ8Gixbe2xD7l9m+tjv2lWclqWXcwZqCMLP7zqyXwcwq5ZFcYlgx0JcAhCCp0HAO
         HNHQ==
X-Gm-Message-State: AOAM532/IhNWcW5E2HTz/5OlcI+43CfNd2+DstWBC4qIfc1CSu2Vh0CE
        6QPydMVLLfpfQaViPQ2fde7Fj2cqYhYg5JCLFbIyCoi7mXid71UIgKxclGR9A1937afAsio8auW
        WEXv8MQmHQf9lrhYMYq9ee/jHMS7X
X-Received: by 2002:a1f:3216:: with SMTP id y22mr16017722vky.1.1607722032621;
        Fri, 11 Dec 2020 13:27:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoAxYS7LmWjUd46I3qBH/wmX8+rEnzXAY9WUS8yNPb88aaCCmUw66PGF9HvP9W43g/thyTvGXx+ar4+M0xIEI=
X-Received: by 2002:a1f:3216:: with SMTP id y22mr16017712vky.1.1607722032420;
 Fri, 11 Dec 2020 13:27:12 -0800 (PST)
MIME-Version: 1.0
References: <20201207131503.3858889-1-philmd@redhat.com> <20201207131503.3858889-2-philmd@redhat.com>
In-Reply-To: <20201207131503.3858889-2-philmd@redhat.com>
From:   Willian Rampazzo <wrampazz@redhat.com>
Date:   Fri, 11 Dec 2020 18:27:01 -0300
Message-ID: <CAKJDGDYwUdGxHC4ctzqO6JfrsGQDv7uwdCC29x5Ty61=fzV2RA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] gitlab-ci: Document 'build-tcg-disabled' is a KVM
 X86 job
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 7, 2020 at 10:15 AM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> Document what this job cover (build X86 targets with
> KVM being the single accelerator available).
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  .gitlab-ci.yml | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: WIllian Rampazzo <willianr@redhat.com>

