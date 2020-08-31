Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD4A258353
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 23:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgHaVO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgHaVO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 17:14:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0995BC061573
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 14:14:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g207so1394578pfb.1
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=22ecnwz+xQW3jC3RmGUWnbBUJnB+yHXpUAC3wkYPOZM=;
        b=CLNxAAe+WaENWsLmNvra+PCKEJZZf6eskpqFY0XUytZPyrwF+gwAoBmmROdwcAwA0V
         K6DRuLe1WLT+w6qRdoAmu9xXNBGEA+/op1R6Q5cQfCMk2jMMvLW/uJaaZvnQG4HHGWHH
         5KBlGPcTzODDiwfvc5hMN6blYqmAhi3mGieoRhSzDILvb2ZxGMo6t9n9lyntTJcPF2hv
         5hUB4KSxIN2+pVXvEIm+3yIEYnHvtM8XnX4JpbksTmOy/mAApJsEuDGPxfYgtI8a4uq/
         aGb0NwFLUC1T2jANlvuz94ZxxPa1Q7rCeVXwDPuTFjGIx2/H4n+w8gfD6WIgME8RqXR1
         bIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=22ecnwz+xQW3jC3RmGUWnbBUJnB+yHXpUAC3wkYPOZM=;
        b=ML3NsLMXJ3Nnyr+HM1sfnFu5Ggik2iHeDcsstbLpr2yQ9YLq521XmhFqbOh3tBCwRO
         hmhOGCZoAhkeXy5i2Z0vp53qsbZGaHICZp/xwE6TCx6rZCJPheS4pKDAPYaMXyY4UEaW
         aDaWTVpNuqsPxrPF+QvPUJu3wU/bb0vgZB5YiRRVLLCRgfrFFa3XxJxDuoVE8bN+XA8W
         75bVLKoNamiCYFtbCHlaw+Fs10gzmtAPSkljs8rqvQY1dvqgTS3bL35YpYGZ4Q//F9qa
         o2xsd/hTAhbXdXHThxkLSDZMvUEvmRI5ZnqUhxvT6ZSawUuBgNOEn5wGAo96LW8gvOWc
         KSQg==
X-Gm-Message-State: AOAM532HkeQDXqS7b2KJaAEnROasjVhyJVLmChITqNsJ3judw05K6roG
        31CTpOBNcGm6DRmIUl7+hE+J3Q==
X-Google-Smtp-Source: ABdhPJxFuPR+29HZdaPJx2lHNbrzWzLlBqAb9kdsGjblmeTNHekGacpovLmbUh/crggwrgUfOdrouQ==
X-Received: by 2002:a63:4923:: with SMTP id w35mr1200787pga.368.1598908465353;
        Mon, 31 Aug 2020 14:14:25 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.141.89])
        by smtp.gmail.com with ESMTPSA id l145sm9590077pfd.45.2020.08.31.14.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 14:14:24 -0700 (PDT)
Subject: Re: [PATCH v2 1/7] target: rename all *_do_interupt functions to
 _do_interrupt_locked
To:     Robert Foley <robert.foley@linaro.org>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Sarah Harris <S.E.Harris@kent.ac.uk>,
        Cornelia Huck <cohuck@redhat.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        David Hildenbrand <david@redhat.com>,
        Anthony Green <green@moxielogic.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marek Vasut <marex@denx.de>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:sPAPR" <qemu-ppc@nongnu.org>,
        Richard Henderson <rth@twiddle.net>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        "open list:S390 general arch..." <qemu-s390x@nongnu.org>,
        "open list:ARM TCG CPUs" <qemu-arm@nongnu.org>,
        Michael Rolnik <mrolnik@gmail.com>, pbonzini@redhat.com,
        Stafford Horne <shorne@gmail.com>, alex.bennee@linaro.org,
        David Gibson <david@gibson.dropbear.id.au>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Michael Walle <michael@walle.cc>,
        Palmer Dabbelt <palmer@dabbelt.com>, peter.puhov@linaro.org,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20200819182856.4893-1-robert.foley@linaro.org>
 <20200819182856.4893-2-robert.foley@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <45ce8b56-a00d-9504-7eeb-e4cce4efed31@linaro.org>
Date:   Mon, 31 Aug 2020 14:14:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200819182856.4893-2-robert.foley@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/20 11:28 AM, Robert Foley wrote:
> The rename of all *_do_interrupt functions to *_do_interrupt_locked
> is preparation for pushing the BQL lock around these functions
> down into the per-arch implementation of *_do_interrupt.
> In a later patch which pushes down the lock, we will add
> a new *_do_interrupt function which grabs the BQL and calls to
> *_do_interrupt_locked.
> 
> This is the first patch in a series of transitions to move the
> BQL down into the do_interrupt per arch function.  This set of
> transitions is needed to maintain bisectability.
> 
> The purpose of this set of changes is to set the groundwork
> so that an arch could move towards removing
> the BQL from the cpu_handle_interrupt/exception paths.
> 
> This approach was suggested by Paolo Bonzini.
> For reference, here are key posts in the discussion, explaining
> the reasoning/benefits of this approach.
> 
> https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg00784.html
> https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg01517.html
> https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg08731.html
> https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg00044.html
> 
> Signed-off-by: Robert Foley <robert.foley@linaro.org>
> ---

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
