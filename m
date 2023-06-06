Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7737235C0
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 05:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjFFDbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 23:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFFDbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:31:39 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B9127
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 20:31:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51458187be1so8477974a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 20:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1686022297; x=1688614297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wndiCL3ooX0unGrdnlGJh/CooZNsl4DJY/nw60Bvyg=;
        b=4TRPlzmgxwVP4N8fCb9RZqV8HP2cOLntI5VkdodB0q2HH1Nh3nliJ06uBXogZqvlRh
         n0Ux0Sg/MwrolvFP0BlIZBqOOMuEawIj0/4iHJnz2AIIkh4EIpYwcXNQY2yHffTqjSwK
         ub+KmHvGOASUEhHANwD2GWK/czhgqWLIZoor/CjWQvsmNZQN1GHtz0V73BNKvrpIIbWQ
         LhOMozGqRslMCUgEf9ZBTaJ0JI3fUmRe9u/AQWBayZYhtLGZZw5d+Zn+Ztmx4VxC8PHV
         UM58F5k1N9OCzT7+2aZrnm9+mMUeANgphTgzhJX8R8/6kx2zFDHtzkqYhNcSJ2RMkScc
         vF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686022297; x=1688614297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4wndiCL3ooX0unGrdnlGJh/CooZNsl4DJY/nw60Bvyg=;
        b=OTjzJgNmH9/r8x8BVO/cRRMcEKS+wSXkg32jC4lXOWPBqFTb43oDzCRJyu/crgf1TH
         Q6JbAZKXyJ33BZv3mvoJWQjlCuA8ZPhD71IuMP+XEiaVL0dTgbm9+LcQEhM+eSsHZMlD
         5GUecfLLWJEL4d5YkUpFdUKgjfEUmzJp5bqcew/EdHEwv3z1+26GR0f4Q2SbmBX06d5+
         FzXezUv0ni8i8I8sQ5UqQJCOqY2+QH92zSTKeeuQNyNyH6g1ZHok9YacoG9MUX+spLJI
         nRpzqCH0yq5flgMnuMpWD1ANjtsGrMYTtVPA1xQZIU5Us4ddtfpOdfWDSU3sXn5bwfLK
         7+xg==
X-Gm-Message-State: AC+VfDzHylAoMGq52i6OmPIGe/ykTlnz9qp5GJg41m9sa0OJF/5DwcZ/
        ohJiFFLNIDMIk/AcZFm0dEXOzli917ONGTIoi+R2STXHOSHkjlGFHFo=
X-Google-Smtp-Source: ACHHUZ7QVZa3RQDP+a9VtfAzcQwf4YFT2UhxLoxBDM/IYolOEXUPpKLOggoV+GzyCKjIgfGl5Xi5Ec22NKzBN859hBs=
X-Received: by 2002:a17:907:c11:b0:973:8afb:634a with SMTP id
 ga17-20020a1709070c1100b009738afb634amr899934ejc.54.1686022296937; Mon, 05
 Jun 2023 20:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <202305061710302032748@zte.com.cn>
In-Reply-To: <202305061710302032748@zte.com.cn>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 6 Jun 2023 09:01:25 +0530
Message-ID: <CAAhSdy3isg4788uz=fP6DCTD3LgVbXz9Ud7aoi2VmEbRKYkW6w@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: use bitmap_zero() API
To:     ye.xingchen@zte.com.cn
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 6, 2023 at 2:40=E2=80=AFPM <ye.xingchen@zte.com.cn> wrote:
>
> From: Ye Xingchen <ye.xingchen@zte.com.cn>
>
> bitmap_zero() is faster than bitmap_clear(), so use bitmap_zero()
> instead of bitmap_clear().
>
> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>

Queued this patch for 6.5

Thanks,
Anup

> ---
>  arch/riscv/kvm/tlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 0e5479600695..44bc324aeeb0 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -296,7 +296,7 @@ static void make_xfence_request(struct kvm *kvm,
>         unsigned int actual_req =3D req;
>         DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>
> -       bitmap_clear(vcpu_mask, 0, KVM_MAX_VCPUS);
> +       bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
>         kvm_for_each_vcpu(i, vcpu, kvm) {
>                 if (hbase !=3D -1UL) {
>                         if (vcpu->vcpu_id < hbase)
> --
> 2.25.1
