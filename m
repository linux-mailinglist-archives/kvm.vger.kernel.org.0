Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8893F06E5
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 16:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbhHROmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 10:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239485AbhHROmr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 10:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629297732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oHOC6qM8SYsxg5GXK1RakJzITqPj1QkZBCg9QMQDUco=;
        b=WN/p2Jq5u3CErt5ePIFGqAZk07OzU6H2IPIZY8ynAj8SXAbDrM5vBH2xTewXxqnC8jHkC4
        29DjLhpzU3+Quxks/FR34pqrGg2txtIL3XlYIL/NNA4g/Z6C3aEuemS95qdc8eEkzut9Kv
        m3xJTnpO9DZ+5J2iZPFNh8lx4heIZp4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-1zaPGECXPAyQi6uVfEG3nQ-1; Wed, 18 Aug 2021 10:42:10 -0400
X-MC-Unique: 1zaPGECXPAyQi6uVfEG3nQ-1
Received: by mail-ed1-f70.google.com with SMTP id e18-20020a0564020892b02903be9702d63eso1143927edy.17
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 07:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oHOC6qM8SYsxg5GXK1RakJzITqPj1QkZBCg9QMQDUco=;
        b=AeasNp53iwyMt3s5bvI5NArLvOcfe9f6nzqsc+GLhZ4Cxi/wrr4hLFHwNkvZ0ebGCk
         8FWGTS2z1HFj8JxErEF9tumn0VH61jk22VEWnM3F3qZ6c4sUnezWmtAz8JXF1w8h4EFp
         xG4+LrY3vO4Ie2aTuso05mKa9lCUeC0mI+iC8waRrDcjQy/8niwHxjaiLXgqvxfQrrCM
         ck/a13qWx3PPn5J1mVmHnGobLP9ImEviimIe+MdB4YxlVNsJlqZYBrrTug3lyK5koq2s
         8+x386lvn4+x0L8Z1BW1gRreAM1OKcwJJD4c3KX2qe4ND3OWa+ep++YwtEgSgmbaVMYW
         Bnhw==
X-Gm-Message-State: AOAM530Kce1FiR+LoeJSVhAzvLNb6S0z0qqx/RBGyLViGkKlyyfEXRaY
        t5Nxv5+Nwbn2h7i9Y0IYs6cT/PLssVIwVuBdtK2wwvqNTCHa6nqYWJypCJ4LyqFS1oJLMQ6vqtX
        jmAFp+OGgJgzf
X-Received: by 2002:a17:906:769a:: with SMTP id o26mr10260107ejm.18.1629297729714;
        Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsUMjWsJZkdAO5Ia6PsQSh8NFeDEF2eu0vMI7nX2SYA8sWVGkvZya4kW3CwJkzpaxp1jcgJQ==
X-Received: by 2002:a17:906:769a:: with SMTP id o26mr10260095ejm.18.1629297729568;
        Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id a2sm112760edm.72.2021.08.18.07.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:42:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 4/4] selftests: KVM: Introduce psci_cpu_on_test
Message-ID: <20210818144207.o7ycdaiy5iyap63k@gator.home>
References: <20210818085047.1005285-1-oupton@google.com>
 <20210818085047.1005285-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818085047.1005285-5-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 08:50:47AM +0000, Oliver Upton wrote:
> Introduce a test for aarch64 that ensures CPU resets induced by PSCI are
> reflected in the target vCPU's state, even if the target is never run
> again. This is a regression test for a race between vCPU migration and
> PSCI.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |   3 +
>  4 files changed, 126 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

