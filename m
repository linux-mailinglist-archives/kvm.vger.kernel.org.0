Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928B76A83DB
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCBNxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBNxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:53:32 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79005158B5
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:53:29 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1567533wmo.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 05:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbXU2vj0IY0hDAFlf1iKe9fCzrKJhIF9m2xoBHeQ8sM=;
        b=nzZGz0EFBELApdZdc294t+3VMNK80yqkMxRFyQt8bxLf7A00opB9NFPpVAMlFebgpc
         vtxitShyyRYLKv0IWJl6UKEo4xek5nXKi1DYQtxZ2GIwCy0WfPpLfYyD/8JVh+vVw2qv
         1PzQHhP5wGypk5fy8ZKyCJ0AXCutqG4BG7wSoVyO+D1rlR30IiVfbvtex+mrGIBvus5a
         yFIj4HMHdFTUfk1os8zwOCgKOx24gg0jZ5/QO6SWgi2+ydMsnkU0tFw6Ftp6YgpFdVnS
         LnDzNY1RthZfPufv6l++CCRYGXtRG06Ekri3mVSaL9hF/GnCXlPKy0uelkLgDKT6uzSN
         WqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RbXU2vj0IY0hDAFlf1iKe9fCzrKJhIF9m2xoBHeQ8sM=;
        b=ne6YP0iKSJn76NDLvNR63bvpwZpcl8QlayyTI6JHsEGzxyVWk0WgEbA3amZNlO+TGc
         snrl3CInJWgUk2jswT8YJr/xOvrfqD7LRXYaPR2DTGdpV3+gTrRbpgGhlrbvvVo8dagH
         +qiVvf0p9dRmrfC7iyVbmivYeXKImTLPBqBq43RcVKnyCqkhNw7WtYbDGSA2ACyZjJ6q
         lTDK1EVjXAxjoPVbIxJGZL3M2awcxRzCMSfE6Cp+/g/ddsl4hmkFL35XiG5OGiMf9KXl
         Rs+TbSlnZF/0FDOIT56XdWCNkJibypzb/B6TFt/X+DXrPU5pp+BLcCR0WTzs1krbuY35
         OBxQ==
X-Gm-Message-State: AO0yUKU5jCbNXtZHpscQBPdWlvKuqa5al+SX2F0XDC51xzrObDZqvsFx
        ALVMR2zEDCNvvBYUcTUJLO85YQ==
X-Google-Smtp-Source: AK7set+WFnV3eoB2pGaqVNAcQyx5YnDuMwI0evXG+gQim0dd76evQ+KvVdy7Wg7HwfjMHB311tEU9Q==
X-Received: by 2002:a05:600c:3c89:b0:3eb:39e2:9157 with SMTP id bg9-20020a05600c3c8900b003eb39e29157mr7683004wmb.22.1677765207984;
        Thu, 02 Mar 2023 05:53:27 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p8-20020a7bcde8000000b003dc521f336esm3088826wmj.14.2023.03.02.05.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 05:53:27 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2D6141FFB7;
        Thu,  2 Mar 2023 13:53:27 +0000 (GMT)
References: <20230207131721.49233-1-mads@ynddal.dk>
User-agent: mu4e 1.9.21; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Mads Ynddal <mads@ynddal.dk>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mads Ynddal <m.ynddal@samsung.com>
Subject: Re: [PATCH v2] gdbstub: move update guest debug to accel ops
Date:   Thu, 02 Mar 2023 13:53:21 +0000
In-reply-to: <20230207131721.49233-1-mads@ynddal.dk>
Message-ID: <874jr3b6p4.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Mads Ynddal <mads@ynddal.dk> writes:

> From: Mads Ynddal <m.ynddal@samsung.com>
>
> Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
> check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
> code, and replace it with a property of AccelOpsClass.
>
> Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>

Queued to gdbstub/next, thanks.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
