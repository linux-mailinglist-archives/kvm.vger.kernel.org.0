Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A719F8731F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbfHIHgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:36:15 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45664 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405749AbfHIHgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:36:12 -0400
Received: by mail-lj1-f196.google.com with SMTP id t3so2673382ljj.12
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXqS2DL68BnoaWC7BPpejArIxz6sqUi2fc/63WuQaUE=;
        b=QKL0hpgsd+0DNocYhr0sEvnxDUB9OXgs3iaJcewg/PpKtcZDd9q9ztHww7OdRd8K1x
         EsNY858u9uPhQWSOAVrxpmMIUu5KUzwaV3TsHkDCS1t3TCobq/9PGwCabM7oU8ARaMNf
         M8TmaT+8j2S7leYm4lrZuMoQyyDppVz5G/6gHWkJamj1HsNdShB8on/i+0uX0I6felNt
         seus2hiiiuYCV5cZO2OpOQTu+nPXKojbfezQmKNtqns0RTRELCP/y5WoSbMDbCsUQDL7
         xLOJABYKiF1x5K7QwK36deq4e1LaIpzb8TQQ9upjahFFRuEioMivr1TwvLkKnpeAgCfN
         PQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXqS2DL68BnoaWC7BPpejArIxz6sqUi2fc/63WuQaUE=;
        b=QO2uUTcmc5+lWIUtKd3rGq30KsXFfWnVTdJAI1nkM1SZhuTbNa/+jU+rojV7NhehZU
         Uv8QJrEV6EfMpzCrGz/+VDW4CFbPa4KfKgrtyJJNcCkDcJm0SqSRgponsyenm4UFmSsY
         O8rROEZLvWuzyNCsew5UHA4LLMuToQgzv+soR9r+p/XWl9aHhPv/jBYJMIHMR+ANnGrN
         gikA3USL8dZykk3xG1euR7YtWBmGIf/gfwjyiXj/jV5Bh++PFsJV1AJJIqaHBlvmGl6A
         zJw3GRRV8Tsti8oup1cXIgphJv5NFiCcKttDCHSmwcamQSyae+CUKnGfV4I7Uwtvr8nZ
         kGkA==
X-Gm-Message-State: APjAAAWLCChoF2GoX9oGx8K+NuEFf9cKZMXrXDW7towjegDN3I71aACM
        XV7uIhz2xYyBbfXKJ1OBU/H9+3AZnpeqog/M7F/ZpSlk6DI=
X-Google-Smtp-Source: APXvYqzeqLykT6zxNpcnNSzGlO76tabSwRrSF7hhpaCzhGrqiXaDTvhfTN7tkmBVUZHwxkSdgdismvv4yqPs8ykrJOo=
X-Received: by 2002:a2e:6e0c:: with SMTP id j12mr10467584ljc.123.1565336170583;
 Fri, 09 Aug 2019 00:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190808123140.25583-1-naresh.kamboju@linaro.org>
 <20190808151010.ktbqbfevgcs3bkjy@kamzik.brq.redhat.com> <b34e8232-ccfd-898c-49de-afef4168a165@redhat.com>
In-Reply-To: <b34e8232-ccfd-898c-49de-afef4168a165@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 9 Aug 2019 13:05:59 +0530
Message-ID: <CA+G9fYv7RZgm36fbQU5yH=58sX84TxgE93SneB_UhRsD1ivGhg@mail.gmail.com>
Subject: Re: [PATCH v2] selftests: kvm: Adding config fragments
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        sean.j.christopherson@intel.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Aug 2019 at 21:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/08/19 17:10, Andrew Jones wrote:
> >>
> > What does the kselftests config file do? I was about to complain that this
> > would break compiling on non-x86 platforms, but 'make kselftest' and other
> > forms of invoking the build work fine on aarch64 even with this config
> > file. So is this just for documentation? If so, then its still obviously
> > wrong for non-x86 platforms. The only config that makes sense here is KVM.
> > If the other options need to be documented for x86, then should they get
> > an additional config file? tools/testing/selftests/kvm/x86_64/config?
>
> My understanding is that a config file fragment requires some kind of
> kconfig invocation to create a full .config file.  When you do that,
> unknown configurations are dropped silently.

You are right on this point. As you said, unknown configs getting dropped for
arm64 cross compilation.

- Naresh
