Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A5A4043CB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349727AbhIIC4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 22:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349433AbhIIC4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 22:56:53 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A567C06175F
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 19:55:45 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z2so490764iln.0
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 19:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=70g9MtOxJ+c9WQaUJGlWTIEgCLNxdZNwZARtMaXCcgM=;
        b=fybdFrS1IowdAXfYbxOXZ3I6iSICWHOoF9IqHePDV3JYI5GmKvgKKa90x5sb5L8SYR
         9szwaRfJMm9JfBRUgGGY3YY12Mjuc+rk2CbaIqEdAE32pvpey8S5NzpVoqHHXoJoizU9
         Y4m0MBUqxSXXIpH97d7OQLDeqGByZe+DbZDDbBDInbxLt8uB2fzneSrc+2gXDZ6qGE7k
         UtVvjlpHQ5cpq/I/6xiR7ftkjaNaD1UCpUlyMn/WeV1wyAJhooWq7AgiBdv15eANHjag
         wv9n6hADOzo+d0E/yh8ZUZBX4YFEHDZJ9eQixJtbt9LixnwUWFrLJ9+yU+ejmrjmnr5b
         qvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70g9MtOxJ+c9WQaUJGlWTIEgCLNxdZNwZARtMaXCcgM=;
        b=0prVb4QFk8urCJfcyiQtgykxoVfsiOzNTu5ktKon+Zg3OVyPuOewEH3IJVjiX2TPum
         SV/rSYTGX51f0HM8HrajV4UFBnwKmequ/2oQKNGizUFlLPznZkGkc+LMWHaSxzkYvaac
         1BmbHCwQCth0N14F6WSYK7xFu5qZDyTXkZIDFGT/+1h8Hrme/0Pit+Jj8v2dGukRlIfr
         uxdHZWTttD8gXhSwInZbC5lfAOZjTmyyJKp/ww1cdYGDhRRtMIkLOp84MS5BqkhZmbeF
         eN8rJKQ61YGPAUYyWDDNatN0ZAJZaeDJOjU3bvqle8gndOOHR5G4swf475ulz+gDux7J
         iQ+Q==
X-Gm-Message-State: AOAM532yORR9zxj+UGUbWQqEEayjZNmR2OYNyUFnYcT9yMwp/lEI+AZN
        wE0tUaIe8RAhBsDAhDBUt6Mxig==
X-Google-Smtp-Source: ABdhPJwe5z4yVVGtg+ZHPkN6LiNEnHan8VvEXYzBBzUdrsrQl6RJRGqbPl1NpgQBsDKzC/M6vmVW7Q==
X-Received: by 2002:a92:6907:: with SMTP id e7mr563449ilc.301.1631156144318;
        Wed, 08 Sep 2021 19:55:44 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a2sm259247ilm.82.2021.09.08.19.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 19:55:43 -0700 (PDT)
Date:   Thu, 9 Sep 2021 02:55:40 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
Message-ID: <YTl3rP50dYjvmmDP@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:03AM +0000, Raghavendra Rao Ananta wrote:
> Make use of the register read/write definitions from
> sysreg.h, instead of the existing definitions. A syntax
> correction is needed for the files that use write_sysreg()
> to make it compliant with the new (kernel's) syntax.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
>  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
>  2 files changed, 15 insertions(+), 26 deletions(-)
>

[...]

> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 96578bd46a85..bed4ffa70905 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -8,6 +8,7 @@
>  #define SELFTEST_KVM_PROCESSOR_H
>  
>  #include "kvm_util.h"
> +#include "sysreg.h"

#include <asm/sysreg.h>, based on comments to 02/18

Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>

