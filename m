Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB71E622C9B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 14:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKINmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 08:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKINmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 08:42:31 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875EA233A3;
        Wed,  9 Nov 2022 05:42:30 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id f37so25644363lfv.8;
        Wed, 09 Nov 2022 05:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldyqt2mSXXrEosQOvqIK5dNWaqrseYntTJhs+D88oGk=;
        b=ex9WzbT962IPus2/cssqm29tzXLBUJLZc40PlJ+tkwm69kc1nFLEifs9mte7yOWvyW
         ihAGElQGpsU8v56l7Prjuaf4i7o5sSuNA77p5+7QCYEWW0zyvUVIJ86otEj69E+RxqNN
         NVZKCiYAJld1YSIWXqJZCHkcGxaS5Vo84LWazoT1VdOdHbaAhzKXLCg96vzmBsa9w0yc
         UPFrhFixcjBUbOV/Jt1BOYPZoZzNCjiHb7/9W3ezznIAIFsl5M8w+/icOYyV+7aJXx1Z
         /A728BlfGK/mf4GU3fqioXMQlIuNIouIe8uRrExFp+PF3rycwcxecboLyaumB/egy/sB
         SFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldyqt2mSXXrEosQOvqIK5dNWaqrseYntTJhs+D88oGk=;
        b=YcVXzvwX02AXXTNe1kolpc4mkGyjwmH9LCwohQGLI94r9t3I/Mdn9HdzJ61f8+N4Yn
         yZbmPCT/XLZw4kKP+dqBgIUN3rNvAUiZ1HmVs0bsMGHtA8BIBKPszrZAfAy+qzhMEyVG
         PQjpL74IaAG2ldiTwbtfsvYdjQXjV7QhZush0rr9bPNNTQbCIsTERY7X6uLgg0VU4wOR
         quHG+9VeqHClWxKFj968vnMltmTcABHViSm9u5nbqQ/J7hT/QsY+WL9cicTJSJGQtgUv
         AaJxqaq1jX3jBD2CbtvjYXX0NaKqLcWE3nKKOTQrYhyawy4dSfHm3bET/6u+vn8kYzFU
         a95Q==
X-Gm-Message-State: ACrzQf1Of7TDvaNm+ogbTwTSbhtk+Sqqi71lJZtT+FQrLSd+jsxx7Cp7
        mw5bSkBYXEzgdzrd2Ds3dPw=
X-Google-Smtp-Source: AMsMyM6vfh+OOlUal4C5kj/cADC/0nT85QcsS9k8WHwaskcuhklUHHIcAci46UikXwl+BVKq0QM+hQ==
X-Received: by 2002:ac2:5c4e:0:b0:4ab:db5d:10ee with SMTP id s14-20020ac25c4e000000b004abdb5d10eemr20180736lfp.142.1668001348804;
        Wed, 09 Nov 2022 05:42:28 -0800 (PST)
Received: from curiosity ([5.188.167.245])
        by smtp.gmail.com with ESMTPSA id du9-20020a056512298900b0049465afdd38sm2232452lfb.108.2022.11.09.05.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 05:42:27 -0800 (PST)
Date:   Wed, 9 Nov 2022 16:42:27 +0300
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC  4/9] RISC-V: KVM: Improve privilege mode filtering for perf
Message-ID: <Y2uuQ4wH4dU98K2b@curiosity>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-5-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-5-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Atish,

> Currently, the host driver doesn't have any method to identify if the
> requested perf event is from kvm or bare metal. As KVM runs in HS
> mode, there are no separate hypervisor privilege mode to distinguish
> between the attributes for guest/host.
> 
> Improve the privilege mode filtering by using the event specific
> config1 field.

... [snip]

> +static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
> +{
> +	unsigned long cflags = 0;
> +	bool guest_events = false;
> +
> +	if (event->attr.config1 & RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS)
> +		guest_events = true;
> +	if (event->attr.exclude_kernel)
> +		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FLAG_SET_SINH;

IIUC we should inhibit host counting if we want guest events:
		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_SINH : SBI_PMU_CFG_FLAG_SET_VSINH;

> +	if (event->attr.exclude_user)
> +		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FLAG_SET_UINH;

Same here.

> +	if (guest_events && event->attr.exclude_hv)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_host)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_guest)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
> +
> +	return cflags;
> +}

Regards,
Sergey
