Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAE01F1E29
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgFHRJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730681AbgFHRJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:09:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F881C08C5C2
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 10:09:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j198so455588wmj.0
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 10:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O5kyIIzxsOCQ0wtFJtMJAdBIg3y6KuYFhCf9iMzgFJQ=;
        b=p1wdQUodkbKA53RU829/S14bgNwXUZk4oaZTZITlLvC1R/7pCLt8Qec1xAGFhamIuc
         6GF1n0XpMYAVGZKMywm22h1ALDMPKC6G/E5cO+DrxJ5qCSzcWyrUHMqFumgbHdUB4PKI
         NXGPYjtcPBb58hKLeEFKZhEW3c+c7gfIsbHDkzXKT86fv2c6LRGCjIStT6NFcC/RFCUV
         Cd6FPlkFGwdFBPcY9Gu+WoR99u+T8tOtU2rKJ8OttEpNZZcKTZiS/TQdIyt7UoWh0mnL
         jSWwEg9ye92wgPswhOn2ZJsE21UwfoMC1vNYT56fDTeseRBdlyb87eNnOHq3gueSJbtm
         +Z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O5kyIIzxsOCQ0wtFJtMJAdBIg3y6KuYFhCf9iMzgFJQ=;
        b=orj7XTEfutbE1qX7f76Wd6gDe59AIgwe0MnTfQ0jVbx4xvM7WhkMr6dEa7KFf9G0uI
         UUusoni5aSsSRnjTOEhTGgI1y8n1VsORlmya89YtiZ38cfjUNEGGykPq+5vfOds33Gho
         h1akvrvJ11zt4K+e0trhrtCcumpw+gf7bXU1bki1QDdxFHLaDTjr0MBMj1SgZIRZzSEn
         WEkBpZMIHnbIqzwAKq+NVfQqGFtJV0Q2DDUCy4gHtIwwbM41GH++CpKGfZSLE9B9O+yX
         noW18LKicxbzmkCcwFZVpOLYCp02Ukx15JCf6D9rsKQj/P1AXDZU1xk5IYBIf4JsVRV/
         plfQ==
X-Gm-Message-State: AOAM5333kGvKsYu3qHHEVNTu/0MiSe3AJ350aOWzMw18X7NiwdUhuaQe
        kgU2hysxW3XdH6WWN5hyrKcqTA==
X-Google-Smtp-Source: ABdhPJxZEDJueTXgTcDW9U9iUaISMszgUVW6R1TTHIBvERHVRmV8seKAaqqSKuvHuMRooFnwn0NlQQ==
X-Received: by 2002:a7b:cc08:: with SMTP id f8mr350455wmh.106.1591636165854;
        Mon, 08 Jun 2020 10:09:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id z8sm357180wru.33.2020.06.08.10.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 10:09:25 -0700 (PDT)
Date:   Mon, 8 Jun 2020 18:09:20 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Remove host_cpu_context member from vcpu
 structure
Message-ID: <20200608170920.GC96714@google.com>
References: <20200608085657.1405730-1-maz@kernel.org>
 <20200608145145.GA96714@google.com>
 <1a00887a4af019fa83380b68afd43a29@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a00887a4af019fa83380b68afd43a29@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 04:42:42PM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-06-08 15:51, Andrew Scull wrote:
> > On Mon, Jun 08, 2020 at 09:56:57AM +0100, Marc Zyngier wrote:
> > > For very long, we have kept this pointer back to the per-cpu
> > > host state, despite having working per-cpu accessors at EL2
> > > for some time now.
> > > 
> > > Recent investigations have shown that this pointer is easy
> > > to abuse in preemptible context, which is a sure sign that
> > > it would better be gone. Not to mention that a per-cpu
> > > pointer is faster to access at all times.
> > 
> > Helps to make the references to `kvm_host_data` clearer with there now
> > being just one way to get to it and shows that it is scoped to the
> > current CPU. A good change IMO!
> 
> Thanks! Can I take this as a Reviewed-by or Acked-by tag? Just let me know.

Build and booted your kvm-arm64/ptrauth-fixes branch contianing this
patch with VHE and nVHE on qemu. Booted a VM within each with kvmtool.

Reviewed-by: Andrew Scull <ascull@google.com>
