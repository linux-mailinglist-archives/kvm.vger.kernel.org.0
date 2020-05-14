Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8D91D2DEE
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 13:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgENLMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 07:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgENLMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 07:12:00 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584B7C061A0C
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 04:12:00 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id z25so1972863otq.13
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 04:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kmgi+cXn2gA4xTq/eWQ2tj3BWMUlW5Uh0vA4ZY02OgQ=;
        b=yOD9BEP+L4vp0L0QbU0583eI/64Vtdb+Vt8GUEIqlZjLC8UQDZhgu8acs5q0pZmY3R
         o00lLwlujnB8dGEB7NYufCm/qVRyh3bBTKmFL6YAs6DfZWjM/RacaQTLetZ2d2iekcMh
         2wpjzSe+4GJ3LYuag1nA+wWtaJoJR07cfnIvUkpUs5BPpQInS7+j5u99dKm6/cj4rr4V
         86qn8/Ne8n7JS2qc9+6xJwquyiClpVEjianf1m5fU45slKhjr8pxYlZNUCNzD3rr7fIb
         b3UB20VZ1tVEnjBF6i/bND/paxzBEFewoe71UUmQ5NCH65A/Qdh4zsyyxBVxwVIFZoDq
         MYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kmgi+cXn2gA4xTq/eWQ2tj3BWMUlW5Uh0vA4ZY02OgQ=;
        b=TFWGQKtUV2B/T+Y7l0xnXaQSZcsDgkYBj1sfXH/oSDS+7C5N+CNo1nghDe1YvMgpEi
         S3uv0nfuQflwRDXqnKABqtDwi+u7JdvEduBU+zBTnU3LIuW/3NQJ2IGdZIW6/o4MuElI
         Uu3dZyYfEM5ROsZBLqhf8TYVT92JdbS4Ykj7gZqhtDWiloofWfqMQNoiw7G91xJPjr/4
         GVmSrW0iEkFOXi7f3BP3IGr+Lfe/fXXMWo24czdWCkFfuTrIw1m4MweijtBLl8VuDvDx
         z1b+YctBgoEltiqM8g0njhayAnJkRZkukbyt/AxpfHDl9gaKsl748tfaZAOObfDWzcxO
         0DPQ==
X-Gm-Message-State: AOAM533WTPecQfW0jqqbhHNHKUtdp93TLLl6fykdfORyT9ONUVAk8Q1Y
        c9hXylx1smETNUVhHADLmjIzk7pu6LIGEv0vqbVb2Q==
X-Google-Smtp-Source: ABdhPJyIQwz7oPWt9b/QQJ2Z0yCWjuVRj+YVTalDvpNE9UmAW4Hm6eKvHRaDu2AANo9WPC8tNWM4a1x/NRCDr2QEFR8=
X-Received: by 2002:a05:6830:1e4e:: with SMTP id e14mr3006788otj.91.1589454719798;
 Thu, 14 May 2020 04:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200512030609.19593-1-gengdongjiu@huawei.com> <20200512030609.19593-2-gengdongjiu@huawei.com>
In-Reply-To: <20200512030609.19593-2-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 14 May 2020 12:11:48 +0100
Message-ID: <CAFEAcA9RBWDM4gwputTLmePuL9FJ7Xv5x1uqyFHoru21S4GkeA@mail.gmail.com>
Subject: Re: [PATCH v27 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common macro
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 May 2020 at 04:03, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> The little end UUID is used in many places, so make
> NVDIMM_UUID_LE to a common macro to convert the UUID
> to a little end array.
>
> Reviewed-by: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
