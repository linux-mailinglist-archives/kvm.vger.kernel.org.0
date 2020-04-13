Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B11A6E75
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 23:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgDMVec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 17:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389146AbgDMVeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 17:34:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74491C0A3BDC;
        Mon, 13 Apr 2020 14:34:23 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d27so2643150wra.1;
        Mon, 13 Apr 2020 14:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WDLpX6un52/AMwecGbJF0+8vb65HmQ8qFANqOY0XK7Y=;
        b=IuYqFbiHvSBMhlKLU88FQD6ph6l8u5128kLqE8SenvYihQJEPGmJINrkyvIh6vpW2u
         /atBvA75QL7UmEbyidSfCXE9VeE6SdB9IhYX6B3aHhwgMX0tmJ1dGgq1iHOBxSuH5Ezk
         VCWc51OJuo2eWBiWuYxF2kVCeRK0CX7KJ1dT2S+MSOGnulH5DMjtn5pZ88A/Y0yof0T2
         UcJ+AiMZeX97qHo6+sK6kWsJjsp0iuoGeKviv5k/BbU7JcMcpQXEn6SjrQEbaon0dw6S
         y7IERsJ3FCFJptrbidN9ACEH4G0Eg5BXm3yzzlYa9opYGLDAD1VPzulRpYMvxfhhzH+p
         vOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WDLpX6un52/AMwecGbJF0+8vb65HmQ8qFANqOY0XK7Y=;
        b=bgX5qGR3TMooU5ruQwb0em7W4TjwaE0SNh3KtvyC7CAbNFVBGJSKiT2FYh4zISOt2n
         bRTmfUzkw97XBVazHZkGdLd/xE5RM1z2kBHY8CAmND1s2nPvMzuiSj17sg08An0xnAg4
         0EEpxsIxkKdhKZ4nKuVYo3jSNYJQwm7xUGNPw3rCsVoszvpYT//bOENtREJNJSFT0DI4
         85/BBjjdg7ocVMC5DWlOqSaJdLA/yrCmX2j2dsZTtHUhCIl2K3wCCMCuiQc0DSeQRMd3
         TOKcev90P5lUVojB+IBYZ7Q1FWGpPmOQZDNE6D9V/2rZ7U3j0Is5LO/eBtDrTKqpJOGb
         AyUg==
X-Gm-Message-State: AGi0PuZQ0v+xGeXG3A8blRagFRQb27aAab40lBzoKHV9QTkd9xRLL6AI
        h5W+ShgjlNSBcvqRl8WapPdpP7li6mWDmQ==
X-Google-Smtp-Source: APiQypIaudaXPJ6rENC31BASdvEjjHEOZ24liPPj6hbZ7Im0hP2KXUJDynYo1n+j8lgnYgsqwzYqNQ==
X-Received: by 2002:a5d:5230:: with SMTP id i16mr14472562wra.71.1586813661849;
        Mon, 13 Apr 2020 14:34:21 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id b11sm16503963wrq.26.2020.04.13.14.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 14:34:21 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
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
Message-ID: <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
Date:   Mon, 13 Apr 2020 23:34:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200413140332.22896-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Emanuele,

On 4/13/20 4:03 PM, Emanuele Giuseppe Esposito wrote:
> The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
> files, each used by a different architecure to initialize the debugfs
> entries for statistics. Since they all have the same purpose, they can be
> unified in a single common definition in include/linux/kvm_host.h
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/arm64/kvm/guest.c    | 23 +++++++--------
>  arch/mips/kvm/mips.c      | 61 +++++++++++++++++++--------------------
>  arch/powerpc/kvm/book3s.c |  3 --
>  arch/powerpc/kvm/booke.c  |  3 --
>  arch/s390/kvm/kvm-s390.c  |  3 --
>  arch/x86/kvm/x86.c        |  3 --
>  include/linux/kvm_host.h  |  3 ++
>  7 files changed, 43 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 23ebe51410f0..3e3aee8b37c0 100644
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
> +	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
> +	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
> +	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
> +	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
> +	{ "hvc_exit_stat", VCPU_STAT(hvc_exit_stat) },
> +	{ "wfe_exit_stat", VCPU_STAT(wfe_exit_stat) },
> +	{ "wfi_exit_stat", VCPU_STAT(wfi_exit_stat) },
> +	{ "mmio_exit_user", VCPU_STAT(mmio_exit_user) },
> +	{ "mmio_exit_kernel", VCPU_STAT(mmio_exit_kernel) },
> +	{ "exits", VCPU_STAT(exits) },
>  	{ NULL }
>  };
>  
[...]
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6d58beb65454..e02d38c7fff1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1130,6 +1130,9 @@ struct kvm_stats_debugfs_item {
>  #define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
>  	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
>  
> +#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
> +#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__

I find this macro expanding into multiple fields odd... Maybe a matter
of taste. Sugggestion, have the macro define the full structure, as in
the arm64 arch:

#define VM_STAT(n, x, ...) { n, offsetof(struct kvm, stat.x),
KVM_STAT_VM, ## __VA_ARGS__ }

Ditto for VCPU_STAT().

> +
>  extern struct kvm_stats_debugfs_item debugfs_entries[];
>  extern struct dentry *kvm_debugfs_dir;
>  
> 
