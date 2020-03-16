Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1711873A5
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgCPTwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:52:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35413 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732447AbgCPTww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:52:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id 7so10336483pgr.2
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSjEqM1pkBNOiCDD3KKMFDmPsx6HNqfksrbdlb11Ou8=;
        b=Gwk6BbG/T8f3eN13G9OnikR2IhbOtZYySgqLI6oGzGzX/SSL2N27F7fS4vW5XphLYL
         Lgoc7yfCuFcx8aWtqPTyy+8JQ9L4QSkEBfqFT7ULWWu8FsibH/2kRuWFeVG/bOLE1uhW
         xnXLOTObXStrqlbLkN1GKQPiXziVFs4slfjkMzSeMkrMZCuojJUtwSWkFPJRSOZX+d1z
         KdUajQP3fyNnjIkpVY8yIv8/xS3FgjoyQ5nsyaKb18JBYhYN8LfDyLyXgUroNC7sbB6r
         tum1yASvPUEnmC3qOwEYj572Nu5IOgyLlWvba0cLCU8PC2OJib8jzK2lomvL9EWtHhx3
         Mq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSjEqM1pkBNOiCDD3KKMFDmPsx6HNqfksrbdlb11Ou8=;
        b=cyRWJ2q5XKjxZ12LPVP4/Nmjx6VTdEkR/hRKzrOa1HGEwslGRP6iP65SfNw2NfT8c2
         BEFt6rEvINPgkq+GJLxT9SEr/tfA+h0qOQBwLnZpPX5pFL0IEYpmBDpAgqKhAVldlnVc
         r5UHM93sEd6Rv67uWd7WY2/Mrbj2r+FnCvqn2ip8dkkm8/UX5cDd6pZPKinPSl9GGVM/
         q4nbWgqkGAulNAzE23yCeiYgQLGnTywKCG3BV3kegrWfapVAGhoQXnj51FxyljHYpeVE
         47flIt3EV3gXfTd9hix6BxoS87pBNN29p/Ry6hJlWqQDPhRPPX7hZZI5h8IUo8Q8Wfbz
         VhDw==
X-Gm-Message-State: ANhLgQ3emt5UP3ZjVFiAkenhD3xKzolSx4eIRDsmY0Re2joMXTfBWgpP
        7H3PJHbbsrl7Zh6u02t7NpdzSQ==
X-Google-Smtp-Source: ADFU+vvijoQC/afij+HOEtKUgij1P27ugBHOV9BUVP/3wT3gYK7jYSwQx2OzJQnwoRsS6W/O+au1/g==
X-Received: by 2002:a62:7d11:: with SMTP id y17mr1251492pfc.127.1584388371660;
        Mon, 16 Mar 2020 12:52:51 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id o11sm558996pjb.18.2020.03.16.12.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:52:51 -0700 (PDT)
Subject: Re: [PATCH v3 11/19] target/arm: Restrict ARMv5 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-12-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <4ee60dab-8799-0174-65f0-3d516fa3de30@linaro.org>
Date:   Mon, 16 Mar 2020 12:52:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-12-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +static void arm_v5_cpu_register_types(void)
> +{
> +    const ARMCPUInfo *info = arm_v5_cpus;
> +
> +    while (info->name) {
> +        arm_cpu_register(info);
> +        info++;
> +    }
> +}

Similarly wrt ARRAY_SIZE.  Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

