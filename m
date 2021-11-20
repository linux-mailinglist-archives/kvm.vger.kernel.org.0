Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3C7457DD3
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 13:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbhKTM2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 07:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhKTM2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 07:28:04 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5447C061574
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 04:25:00 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so12625639wme.0
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 04:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k4t/moyFPTnHr3tkMLXdwzp25OETETV91StNXhkcfik=;
        b=mTt0jFk99R2Hwmx6XtvgMNqXkKwzzU/oAFpisDMSKhRsdclK3eNa5imnm7YU1wQB/N
         DeliNaskMhSb/BnpkkkRqnVQlYONk77YC/IvM8NpN7SOijehD4mtQPpawUl8aTDll4Yq
         v4LvStzkKeZqpEbd7T832AZqX/9YzwQyvhiE+v7UtxQ+9Y7+KPn4F3k+7wEacgdxc1qw
         qTg8seqVVJklVhR78mMVC4RbnLE0GbA2xu9dCVgAz+/QeJk7HylDumSo30RrRoKrznoc
         sxtU801bzcYKU3zi6Fe7r+D2upCgVv6P4+OeBlnrwDXvhPMbOtksThBtpmb1K3+ajzUs
         jn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k4t/moyFPTnHr3tkMLXdwzp25OETETV91StNXhkcfik=;
        b=tvE32Iui68+Qfc0ULi//LK2hZTyH7iKzCjPI9YQu1THE8ysE/3UsWnkSOr6pt374RJ
         PpQHAPUEb7nUHhBAwcMyvjZkNQ2Ca2UYyvCmIZ5FT3laqfbbuupwADS+r1AkzFXHWtbD
         9oX7dC9Y8sqUQVyWPXg4e0Qh9lABQ7HvvuheGt11aqhkT1GgkifD8pyQ9S3R6mwYwGyE
         MhlO/qYjtMnYefdG7LCKJ+81TQhxusK9RTt5KdrYTtjlPM39Qt/tSB7J/qwBJwcOl3u+
         4TWid+ayv7Bxcg62tD1Qutgux5QgvKOYiHbLv7QWNWZ4yllSVc3uY9E7ADxDpSmUG5Qp
         0ANA==
X-Gm-Message-State: AOAM530PpSODZsuE5ggQhBrlsNom26eoblMc/ZOkXkPExQatUlybR5Xh
        6X+e83IVvbkZaqVvOmVX9BU=
X-Google-Smtp-Source: ABdhPJy74oP1WqfRYny5eO9aXcR0fnFrgZXOV0i6XL8EyY0WicsV91rMm7YQV/K2FH+SnMgCAUJXew==
X-Received: by 2002:a05:600c:1d01:: with SMTP id l1mr9908447wms.44.1637411099258;
        Sat, 20 Nov 2021 04:24:59 -0800 (PST)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id g13sm2698002wmk.37.2021.11.20.04.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 04:24:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <afe5b14f-ec27-2722-73a8-b9f6716d207e@amsat.org>
Date:   Sat, 20 Nov 2021 13:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
Content-Language: en-US
To:     Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     bin.meng@windriver.com, Mingwang Li <limingwang@huawei.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, anup.patel@wdc.com,
        wanbo13@huawei.com, Alistair.Francis@wdc.com,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        palmer@dabbelt.com, fanliang@huawei.com, wu.wubin@huawei.com,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-9-jiangyifei@huawei.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20211120074644.729-9-jiangyifei@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/20/21 08:46, Yifei Jiang wrote:
> Use char-fe to handle console sbi call, which implement early
> console io while apply 'earlycon=sbi' into kernel parameters.
> 
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  target/riscv/kvm.c                 | 42 ++++++++++++++++-
>  target/riscv/sbi_ecall_interface.h | 72 ++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 target/riscv/sbi_ecall_interface.h
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 8da2648d1a..6d419ba02e 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,8 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>  #include "kvm_riscv.h"
> +#include "sbi_ecall_interface.h"
> +#include "chardev/char-fe.h"
>  
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -440,9 +442,47 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
>      return true;
>  }
>  
> +static int kvm_riscv_handle_sbi(struct kvm_run *run)
> +{
> +    int ret = 0;
> +    unsigned char ch;
> +    switch (run->riscv_sbi.extension_id) {
> +    case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> +        ch = run->riscv_sbi.args[0];
> +        qemu_chr_fe_write(serial_hd(0)->be, &ch, sizeof(ch));
> +        break;
> +    case SBI_EXT_0_1_CONSOLE_GETCHAR:
> +        ret = qemu_chr_fe_read_all(serial_hd(0)->be, &ch, sizeof(ch));
> +        if (ret == sizeof(ch)) {
> +            run->riscv_sbi.args[0] = ch;
> +        } else {
> +            run->riscv_sbi.args[0] = -1;
> +        }
> +        break;

Shouldn't this code use the Semihosting Console API from
"semihosting/console.h" instead?
