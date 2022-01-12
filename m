Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E221448C827
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 17:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355044AbiALQUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 11:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355175AbiALQUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 11:20:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C840BC0611FD
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 08:20:29 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id t18so4703426plg.9
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 08:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8P3NbvLtm/sHGFjlL5IbXRJr6Wgq4sdrM5EN9QSrHU8=;
        b=Pot0TKlWSTcrjniZWpHFupf9AZEsXBw/FWT//gwIdi2N2lf5MV+gnpkruPceUkydfp
         rzgLMeerZVjI+nV6hOmobpWmPv79GJIiHdFGSEgYalnCBtUYNAdH/7q5QC6QHxtpyPqi
         SUzvF9LYn3OsPZMewOWX1udBtWFAYZmXuYVCtXyemw+2knX2hjwpeWEamkr7S/o2gxB6
         jw0M2+YWQ8RwuRfg8LYXIJfb7S1rRarS8PSxsmC0dZgHJmiUup6mygyhGRiWbJH6evyl
         tSuPfqDPnXbuK7BzFwCgWfBeNGv3DmKFsaVypklSyaARaMDXTp9aeQbxcUF1ACT08iSa
         1ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8P3NbvLtm/sHGFjlL5IbXRJr6Wgq4sdrM5EN9QSrHU8=;
        b=IhnaEw1SS01DwqgrHYYjguWhPU5QEnjda587LmOxUO6tG80ba+yXSAYkaBW6vbCZso
         p4IKko+sS1wACJMFzguOX+xt36LOBawr1kRpJrYZOEoG0Lan4k4jL0bY6eSSST6tPdW2
         fCV+rFAZ+ISBqqJaG1M/Bzgev1fIs9JXS2mA890Ts46z7T/gqUOMD5oFRkClb2z9j1Ck
         mbg+lhci3pRzSMfHPJQFdATUqUEyCZLxMR++wdnD7u9XFMAH8w3PWz3HEWx/KejygJXh
         S5vtvmW24YT6NT9QVnYpGgB+KQLJaCaH4uiqUoLVUfvV9jYExmPJQVWvIaMwig3QV4/N
         ZGnQ==
X-Gm-Message-State: AOAM530KxydWAfALwAiQlEJqJC5AZadpu9s0UdQ6zC0Bt5Wp77usaVdE
        ul9h7/rSAdT6Cm6ovAcln2X+fw==
X-Google-Smtp-Source: ABdhPJxIMzVSsbcRDTJVXSyYABjcwRSX4/H7Hg85BbmPlqFpOU0lQuAwIQSRysKKI0o2vDK5Z3qdPA==
X-Received: by 2002:a63:2acd:: with SMTP id q196mr391306pgq.370.1642004429118;
        Wed, 12 Jan 2022 08:20:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k2sm126788pfc.53.2022.01.12.08.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 08:20:28 -0800 (PST)
Date:   Wed, 12 Jan 2022 16:20:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Make the module parameter of vPMU more
 common
Message-ID: <Yd7/yUFQr3pbqVCi@google.com>
References: <20220112040116.23937-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112040116.23937-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Like Xu wrote:
> ---
> v1 -> v2 Changelog:
> - prefer we keep "pmu" for the module param; (Sean)

...
> +/* Enable/disable PMU virtualization */
> +bool __read_mostly pmu = true;
> +EXPORT_SYMBOL_GPL(pmu);
> +module_param(pmu, bool, 0444);

Sorry, I should have been more explicit.  What I meant was this:

  /* Enable/disable PMU virtualization */
  bool __read_mostly enable_pmu = true;
  module_param_named(pmu, enable_pmu, bool, 0444);

That way KVM can use "enable_pmu" for all its checks, but the user only needs to
type "pmu=?" when manipulating the module param.
