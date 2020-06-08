Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB47B1F1B74
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgFHOvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgFHOvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 10:51:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40099C08C5C2
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 07:51:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so17705867wrr.10
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 07:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=09t4vJAEJNOcAKbjc/XrD7rKiwG3r51o8wQyvTLcyH8=;
        b=H0W6Kxn1tWB0Gd5mhqe5+76N1JoRrfQBzuFyeHyKdKuKr3c0mxvi1yAFcfLLIJyh55
         0k8dOPOj9CmK+GRAegeskyYIv+TKDj2iQeUXFmB0nzECSIxyFfzhVJWU9aWVBdTEchFP
         GlzcpS27DdL03xE79FQZzpNvHLcxsYPNwzcAPR76BqA9jTXdUk/YUdxlqW4FAdbBRwNf
         larkyRCJnjdssMA6KHO2gAUNviKrbJ7XhB3sWo/Wp1musUseGP2k62qvdmy2yuoLieci
         tP3J5viTXpUZQyvmoWug1BfYa6vn0NDeWQAQ07YD0Y4SXO0NCVrrvhcExX8dj7+yQfL9
         PSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09t4vJAEJNOcAKbjc/XrD7rKiwG3r51o8wQyvTLcyH8=;
        b=U1EQuXueewYuPlk83+kKtb49g4SBGtIdABChOd6MP/AQWkgqLBDcy4V/feZG8lZwPN
         NgWLDJLA/rGD9SCy5mKk1vZ78NWQNnBU9nbYpY+lkRGlIeSqmjJp0rAViCODD9TVN36p
         YDEmqziNDYcfUltaaO5YU+kA6b7Y9QbLB0CXUiUSh1HcIi4RcX6LdRF96fXIjIXAZLYm
         FaFkU76eTFMvRqOV1AzSTHQhXaFj8JsF8eyJWQGOQZqJvb9bGIxzD6XUjJFmC1pqbnVS
         Y3coTHx50A0ftluLOj4nga+edH1IFEgsDbBDRwPyse9p6HB/y3tsjC/6we2fz5gYvMmO
         4w0g==
X-Gm-Message-State: AOAM531+eqYSSu7xuLWI0aqm2xRS+tGa7h77FAyy+Ltg/9wCt2HDqXD1
        f3pCxjkvVziskdLkp7H4yvCEpA==
X-Google-Smtp-Source: ABdhPJw/eKBztQ3a9E6WKUS5WsHzaQqYg5KTtA62h7WxrR2Vb+QDhRKkaSCaXQP78CvwMVocDYT20A==
X-Received: by 2002:a5d:558a:: with SMTP id i10mr25577401wrv.207.1591627910886;
        Mon, 08 Jun 2020 07:51:50 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id c5sm19131623wma.20.2020.06.08.07.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 07:51:50 -0700 (PDT)
Date:   Mon, 8 Jun 2020 15:51:45 +0100
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
Message-ID: <20200608145145.GA96714@google.com>
References: <20200608085657.1405730-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608085657.1405730-1-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 09:56:57AM +0100, Marc Zyngier wrote:
> For very long, we have kept this pointer back to the per-cpu
> host state, despite having working per-cpu accessors at EL2
> for some time now.
> 
> Recent investigations have shown that this pointer is easy
> to abuse in preemptible context, which is a sure sign that
> it would better be gone. Not to mention that a per-cpu
> pointer is faster to access at all times.

Helps to make the references to `kvm_host_data` clearer with there now
being just one way to get to it and shows that it is scoped to the
current CPU. A good change IMO!
