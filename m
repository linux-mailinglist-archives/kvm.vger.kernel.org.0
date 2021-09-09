Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4908840450D
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350792AbhIIFhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350756AbhIIFha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:37:30 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A920BC061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 22:36:21 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h29so749072ila.2
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 22:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rs5Tku62bnXK35H0Ulh2hfV6Nn9BVEa4pNd3KqkqUPs=;
        b=GMYQBh6WtXAaT5vNg8hi9Kb7xMdP3NL5qvzhh7Ue+yitvRoS2SOSlMiAf34qHAUOYb
         fxbnbFHZlBEtGe5Dl1hVQT1yA49nnbTthLHge+Pdh0Qv22zejYyAiivtcBg+ous2chQ9
         nDhlQu96I30StM5J6gnplhjyT+qyeJEVbxKpp+xMSoNAXousbBAJirlV1a/CrEyefBhO
         pI8q4n+Itugi/jPAQrP/0j2b6ipq4nt8miMBop9exEii3zQzzyPmh8XNEtoV+yW8RBS2
         zk/iIl8kAp8QzxOoM46ukJRXafhKCM9e6QCgoVq4mW5BBz+409Ab+Y+/+T7iT6wRw7NQ
         EUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rs5Tku62bnXK35H0Ulh2hfV6Nn9BVEa4pNd3KqkqUPs=;
        b=JWsyH8jahA7voU5S7m+zoxkyOVr3Qukooluc9Rf1DrFkJtqhHhXNWLE9o4xg6UXiB9
         +q9LY++eJS+8IffhXHont87njiICZsC0rNfw+V7IyfeDKfNgcTMIuPMi6Zeg+6SmUALX
         7ar6cZD9L635m5rHVpEiSJawGgNpSRy9R0PJFWakfGI6ERRyTHCOCFPMMfKl3NV1/RRN
         TWnE4i3biQga8eci/NBFF+XGbrD7r3GkIU9db8bAR7L79fuNhyodENWTHct8zhx/VXjK
         iRmFkeaY0lJ+77KqSiFVTaZMordLN3ZS96oDdI4ZAkXq3AHe6U5Wb25+7DnvYXTJbjND
         2AEQ==
X-Gm-Message-State: AOAM530cwVMmmRDXBF9jV9QcYb4in6xQpkYxh+e2Pzpd1kR5P8MdX9WR
        odiGCWuga4PXJJQW9jg56MpANg==
X-Google-Smtp-Source: ABdhPJz2tiiZiLS+hXn/+gHFSIX1wmyP8hppIZxSTGQIgnCL75/acuIPebWpw5ZoRZACvU+9n9ydSw==
X-Received: by 2002:a92:da49:: with SMTP id p9mr1010706ilq.89.1631165780802;
        Wed, 08 Sep 2021 22:36:20 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id c11sm424815ilu.74.2021.09.08.22.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 22:36:20 -0700 (PDT)
Date:   Thu, 9 Sep 2021 05:36:16 +0000
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
Subject: Re: [PATCH v4 18/18] KVM: selftests: vgic_init: Pull
 REDIST_REGION_ATTR_ADDR from vgic.h
Message-ID: <YTmdUEcbvf/7mkOw@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-19-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-19-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:18AM +0000, Raghavendra Rao Ananta wrote:
> Pull the definition of REDIST_REGION_ATTR_ADDR from vgic.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Just squash this into the commit where you hoist it into vgic.h. It is
fine to glob it together with the other vgic changes since you're
dropping it into a completely new header file.

--
Thanks,
Oliver
