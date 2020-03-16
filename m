Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C351873A3
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbgCPTvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:51:44 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39080 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPTvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:51:44 -0400
Received: by mail-pj1-f66.google.com with SMTP id d8so9241293pje.4
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dDpacGNq/K7yM6PKdJ9BQLRdTUbRwvHtCgHhyhlKoTg=;
        b=AQjrgjZKqVW/SyhQvefTLDqlDuksBjLCZbzgROzXz0n3JVr1JybTnPwHORasM0VeEe
         bq5kFWQxiy7uwsxIt9CDyb3Cq43Ew/R6BEHUV0xOQBY9NyeA/6TKyhKL3I1y7QL9NC/p
         +zamfgWV7c/8s1b/1OzmI0cF5UKQKr6YcirpPVQhPDhEeojdSOBgn3uW4ItALdn4s/E4
         ZXPaw1lxlqJzmAQEmMbkOXThEbnBjtDyx4ciihBUo5D5u9HB4IMzyJOrGm85up3rapRK
         Glg//oOapd89gfUzTPU/7lWeB/O0ZGRy9j+vPrgmOkmGVZ8GS3kzUg/Yq6N4pLhhS8G3
         BWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dDpacGNq/K7yM6PKdJ9BQLRdTUbRwvHtCgHhyhlKoTg=;
        b=Lsd42urWykQVuoEhxM8DmJshuTu/aEmo3syNHwvUSzg9dGHVtZXyKpL4FdZvoPEmZ8
         BfV6zS/Bjp5xXa1vKJLi6Ax53xZg1EXDaUKjge2ftEyo47v6mKa1F5/1Nx0F1NHmj0km
         cwoNdoLd+T5PgpcTEUwXNn19SKA6dW/jQnQOdmc0eCB1VtlV3BRweWfyCQsQIQWYs33P
         r/VasOe0RYvxYTQlgbgWWJjK22wlmdxM5KCVfXp/He8DeqsdM6SjZHOqWiV4EUYKXup/
         qdpGGQFWbdutRj0vwV4s5LkorleRDMluvLklZsRMByUJ7rnTCsnCuLgnWO+QnL6/k0di
         WIeA==
X-Gm-Message-State: ANhLgQ0vmvlPrzOpDrnmt2xW2S5NQmuMwno7Wz3OxgLizjJuM9Yj74FR
        quZp6XJHjJyXRdGrh4VQPzoqAw==
X-Google-Smtp-Source: ADFU+vvjl9rPaCPg+vR6UzDGMf3+UPc19rwSelQmwlrtWB0EVNu6h7E4JtH8civEN52sD0o5SxTzKA==
X-Received: by 2002:a17:902:a9c5:: with SMTP id b5mr789269plr.126.1584388303264;
        Mon, 16 Mar 2020 12:51:43 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id j19sm671763pfe.102.2020.03.16.12.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:51:42 -0700 (PDT)
Subject: Re: [PATCH v3 10/19] target/arm: Restrict ARMv4 cpus to TCG accel
From:   Richard Henderson <richard.henderson@linaro.org>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-11-philmd@redhat.com>
 <b5c047f3-ab3e-825d-35c8-b24c8efc616e@linaro.org>
Message-ID: <bd65d0e1-c94a-6823-cd5b-41aeef8df260@linaro.org>
Date:   Mon, 16 Mar 2020 12:51:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b5c047f3-ab3e-825d-35c8-b24c8efc616e@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 12:50 PM, Richard Henderson wrote:
> I much prefer ARRAY_SIZE() to sentinels.
> I know the existing code make much use of them,
> but we don't need to replicate that here.

... but otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
