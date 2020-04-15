Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6C71A934E
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 08:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393557AbgDOGgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 02:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgDOGgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 02:36:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F21EC061A0C;
        Tue, 14 Apr 2020 23:36:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id ca21so3218372edb.7;
        Tue, 14 Apr 2020 23:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ziy3CvjiTZBb7re9okjvNzQcGH3k+TOTS0/15gywnMU=;
        b=qqWsPrEf0Ts6quEdGNgBCMsV+kOpY8DsnLT8o+GDgNvhTV7DBX8PBknwe8j0CFEmZX
         jpltKjKxsibH1qtE9Pf+Yz7+KL62s7h7jGgyQlIBJ/TlhWE5yR2c4gr+7Tj1c78y1fr6
         +Zrz2j6Hmf3jl/P4hZRQjAS6AYMTJfyK4LyMEMf53j3sfn38rtV0w5wPuRetHtwAIhxz
         pWb4hDPYcN9P2BvtRDpRaqKHmXbtsK7GhxWOnwkikmDYVI0XvWIhVDDk0RLbEDIYG847
         +cFNtefbyrNvpUo935pS2ws6qM5Vz4D5kiUbknZ6Gro0unFWFR9g7XFcFYGMgY7GmiKA
         lYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ziy3CvjiTZBb7re9okjvNzQcGH3k+TOTS0/15gywnMU=;
        b=CFoQ1JtgeIGw7IYaMOaTBznq7Y8J36YqBr/207bsKGHrIn7OXpVnLROXXWeJVSQql2
         PawT57o9CgoOgaHZh6s+Kb3K9jN0fV9fx+XLaQevXvC8vpAWrt6gFgcoYueZYTeWOoP/
         uIkU5MlERoKdmnUKu+AsBEmhglNWsHH+csNGqxiG4GuaZuAvxXxzxMaF/7gRU03BsIfS
         SkeWEOPPqD0jcziuStjSzD1L7nSibPuwgkoQKL/8mNi9gIS9xr9JJdX0r+kZWqhtxKBm
         g/H7+pD3sDddLQBxGoXBGFbiMTyrJXYsjWLWIL1caq/hBqWwvwPYSVj1W7aaw0bPYUwQ
         loLQ==
X-Gm-Message-State: AGi0PuZDPIHPOeEDrwx+krYcf3GvUP5QxSeMPedLo5sfXVhRgS+fp1No
        uX8S9Gbmci8X4ZqkF0HJEG4su4mFPfeNmw==
X-Google-Smtp-Source: APiQypLBhzQGFSJJza9fhbUNOdf67Ws8AWLLrc2T019xWRRZvN78jvwPXZ4Cq/fMHCh3e7IoI3AkbQ==
X-Received: by 2002:aa7:cf15:: with SMTP id a21mr15771536edy.349.1586932578974;
        Tue, 14 Apr 2020 23:36:18 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id y10sm2423364ejm.3.2020.04.14.23.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 23:36:18 -0700 (PDT)
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org
References: <20200414155625.20559-1-eesposit@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
Date:   Wed, 15 Apr 2020 08:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414155625.20559-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/20 5:56 PM, Emanuele Giuseppe Esposito wrote:
> The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
> files, each used by a different architecure to initialize the debugfs
> entries for statistics. Since they all have the same purpose, they can be
> unified in a single common definition in include/linux/kvm_host.h
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/arm64/kvm/guest.c    |  23 ++---
>  arch/mips/kvm/mips.c      |  61 ++++++------
>  arch/powerpc/kvm/book3s.c |  61 ++++++------
>  arch/powerpc/kvm/booke.c  |  41 ++++----
>  arch/s390/kvm/kvm-s390.c  | 203 +++++++++++++++++++-------------------
>  arch/x86/kvm/x86.c        |  80 +++++++--------
>  include/linux/kvm_host.h  |   5 +
>  7 files changed, 231 insertions(+), 243 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 23ebe51410f0..8417b200bec9 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -29,20 +29,17 @@
>  
>  #include "trace.h"
>  
> -#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
> -#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
> -
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> -	VCPU_STAT(halt_successful_poll),
> -	VCPU_STAT(halt_attempted_poll),
> -	VCPU_STAT(halt_poll_invalid),
> -	VCPU_STAT(halt_wakeup),
> -	VCPU_STAT(hvc_exit_stat),
> -	VCPU_STAT(wfe_exit_stat),
> -	VCPU_STAT(wfi_exit_stat),
> -	VCPU_STAT(mmio_exit_user),
> -	VCPU_STAT(mmio_exit_kernel),
> -	VCPU_STAT(exits),
> +	VCPU_STAT("halt_successful_poll", halt_successful_poll),
> +	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
> +	VCPU_STAT("halt_poll_invalid", halt_poll_invalid),
> +	VCPU_STAT("halt_wakeup", halt_wakeup),
> +	VCPU_STAT("hvc_exit_stat", hvc_exit_stat),
> +	VCPU_STAT("wfe_exit_stat", wfe_exit_stat),
> +	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
> +	VCPU_STAT("mmio_exit_user", mmio_exit_user),
> +	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
> +	VCPU_STAT("exits", exits),
>  	{ NULL }
>  };

Patch easily reviewed with --word-diff.

[...]
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6d58beb65454..2e6ead872957 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1130,6 +1130,11 @@ struct kvm_stats_debugfs_item {
>  #define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
>  	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
>  
> +#define VM_STAT(n, x, ...) 													   \
> +	{ n, offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__ }
> +#define VCPU_STAT(n, x, ...)												   \

Not sure while you use so many whitespaces here... (maybe Paolo can
strip some when applying?).

Otherwise it looks nicer that v1, thanks.

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

> +	{ n, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__ }
> +
>  extern struct kvm_stats_debugfs_item debugfs_entries[];
>  extern struct dentry *kvm_debugfs_dir;
>  
> 
