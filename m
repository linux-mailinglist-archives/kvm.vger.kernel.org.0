Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF553A6DDA
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhFNSAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 14:00:21 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:41546 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhFNSAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 14:00:19 -0400
Received: by mail-il1-f170.google.com with SMTP id t6so12970762iln.8
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKFHk2DKgvmCJkrQVZPEfT5XbIgup0xP3Qo6JGYykt0=;
        b=YjDUAYnF5OOnn1l6/GQVw/BSbIcn0xbHrqSBn3o5C1p2VTj6IMYNoqW+bDQWtDB3j3
         gtEZZ8ReAfZxh4wuYZJCCjAI9t7jYkuoPWQ9Oos+z/V9KWmM8WjwZYIJiSE+xrm5YHtL
         t3ZXoSWUb9mu7h72bVuOkJIs+uhs5eKtfN+WHudMPwirK5eAFbHR2/80kJUZBTnsLx6U
         dgXJQb52dMK9tsJzv7QS603FWyBLCC1uGkFpGlBEA+O2CBtye3ZJjlDyR7Of2DBJdP5i
         Per3gapJzchvofN7In1ZJOhHxWBjb7KE7trARf3P3s7IPb6im5uOT7OzlJP/Wh7ZKwaW
         CCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKFHk2DKgvmCJkrQVZPEfT5XbIgup0xP3Qo6JGYykt0=;
        b=iQhvNFLEbagWJoJNhTAVMQi8+sP6DM6BYCrZl+gw4y4sACkVbbD1NLh4N/UqtDKN3A
         9lTiVbTMNZzByj2K2//dBbhpwu4W7YAVDnFux/f0EXHuGocgTPORLHc88axLfqMnynpy
         o3vODs89ifmStWv3r1u/eX9GF4znCaW/iwSdSaMTWFES/UKELu9yA0nzl4WAJFyV18Fv
         wgTzJJT5dLSPk8RzaXgxnXKUPvrr6y2tPWAfkq6TZ9tTLnRPr47JUqkoEG0X4V5wuKEw
         Lq6u0HWPJg5PO+Xi3miKqFSJL8Ve05E92OrJwZ2BtREGdBpW4RyBvusNlPcK2JuOd7DJ
         2Xhw==
X-Gm-Message-State: AOAM531loHIXPPu2HURhR8IH7jzJcNKyGcg7Com0QRclDezJYbaD+Tth
        rgK+M7akgoa/c8EN7YAHQiBiDb3ufsJBon6UGYIvfg==
X-Google-Smtp-Source: ABdhPJy8frvrYfwS6XRV3De9KS0JTkfQtLDQ+pcUYd5qcZUqt/sX1NcnZLmbVDcUu0kOKFgRntYbpmA6kp3rNmII1w0=
X-Received: by 2002:a05:6e02:5c7:: with SMTP id l7mr14375866ils.283.1623693422959;
 Mon, 14 Jun 2021 10:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-8-dmatlack@google.com>
In-Reply-To: <20210611235701.3941724-8-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 14 Jun 2021 10:56:52 -0700
Message-ID: <CANgfPd8PREGL9p8pAQOpXF08x0tzQOm1YAziBT8x-EH5-9kNjg@mail.gmail.com>
Subject: Re: [PATCH 7/8] KVM: selftests: Fix missing break in
 dirty_log_perf_test arg parsing
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
>
> There is a missing break statement which causes a fallthrough to the
> next statement where optarg will be null and a segmentation fault will
> be generated.
>
> Fixes: 9e965bb75aae ("KVM: selftests: Add backing src parameter to dirty_log_perf_test")
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon


> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 04a2641261be..80cbd3a748c0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -312,6 +312,7 @@ int main(int argc, char *argv[])
>                         break;
>                 case 'o':
>                         p.partition_vcpu_memory_access = false;
> +                       break;
>                 case 's':
>                         p.backing_src = parse_backing_src_type(optarg);
>                         break;
> --
> 2.32.0.272.g935e593368-goog
>
