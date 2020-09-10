Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E511264373
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgIJKOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:14:24 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:54273 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgIJKOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:14:17 -0400
Received: from [192.168.100.1] ([82.252.148.206]) by mrelayeu.kundenserver.de
 (mreue107 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1Mnqfc-1ks4FY1yqw-00pNRE; Thu, 10 Sep 2020 12:13:50 +0200
Subject: Re: [PATCH 6/6] target/i386/kvm: Rename host_tsx_blacklisted() as
 host_tsx_broken()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Joel Stanley <joel@jms.id.au>, qemu-trivial@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-7-philmd@redhat.com>
From:   Laurent Vivier <laurent@vivier.eu>
Autocrypt: addr=laurent@vivier.eu; prefer-encrypt=mutual; keydata=
 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
Message-ID: <495edfec-a372-34fd-17e8-0d55ea1dae0a@vivier.eu>
Date:   Thu, 10 Sep 2020 12:13:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-7-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XGp5DuYNaH/nAV2W3VvFSDzo1Frn05RQUKvEboRsocfDHUjstLb
 emdlViaZq2xhlXLcUKhsnBwGc5YWzo0QRnxhZCUltjdu1GnTk3sv9pFUf8i9GhliOARfAoz
 H62lkq0Fo2L8bwR71Hc1pT0WZKRJyP+tzRx2PlJgy68ZMDuhEpQmikgxT/TA/kkXa6AnSix
 /hjxZf2sbssdXH21smfeQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BeEbZUjj9Rs=:TDtpgIqE+MSeQ+o/TcwB3U
 piGq0nJO1hA31q4Zj0Q1fESWa/S2q3lg9bnToJhyo3kvePN9Lfd9MH7s4m9RYLxFhpYzaO/VP
 kFR5oeXNoiYAF21wPjO2LC3ojpCtNUY7ggV/EuLA4A6JjLPJIccMn1KuV9cU/5lz1L0xKG605
 uZvAc2YS06xY8BXgRUGjTxWfi6I9GHe5/S+oKhsABcn8NvGw61g10U8wS2/+ut8kRgwEpjNbV
 vSfUxHGUOof5WRZV7O6zLY24tUBBEkUMF94hmK8zceHmblfbuCMcQ+2+FmRDcLn0biXx9tGHf
 S6Flkfn28PmYUXyyL1EQq+0SwwtXe1vdzUhp3SmAGNmIIbMoGgNNUZfLAvQFX3TXVuOZyGQ0d
 C+jmly2iSfp/8y+lpcYIzSWm633FHwefoyb1N60+GTgZ64TwlOVPt+M76qII/8cND//fSs/Kw
 97LeE47vTBJjC/WKZ2W2FRDyNYZmu2Aq6QUFkGgQaESxHk83uPHb0iVScpi9qV+B47y2LGtfS
 WAPd/vSOrwhc/sW5Yb52GiDMXSNCQxWFnVhd4BmVoss1EgtN/Vl/xdnogyF7l8DrK6DnqYTxd
 z54BVlUc4vmTKzPXAnuY8eqtJP8wTvJXiRmi/Qy6hW3+v4AdEw47WfgT6bc5Os8VF1tOvyijR
 064Ai+PMYzOar3iW42VzWanSbyhTOxukkeV1i582KPFDDEGPtp6sA8qUKuEJYRsazNmOe5D/a
 QguA7ij9BGMyjAqetMGiBX5Rnb9Gvk9a0BCiR3z++B0/YoQZJ9LeEgctSMQYpLnvKIF7+8NU+
 rua9WcTjKQjDoXhZ/i57vmLZR+klxEW7GJTaqA0LLhNDguGeLjDyDSK8Qn0/gxjyrXsKV2L
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 10/09/2020 à 09:01, Philippe Mathieu-Daudé a écrit :
> In order to use inclusive terminology, rename host_tsx_blacklisted()
> as host_tsx_broken().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/i386/kvm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 205b68bc0ce..3d640a8decf 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -302,7 +302,7 @@ static int get_para_features(KVMState *s)
>      return features;
>  }
>  
> -static bool host_tsx_blacklisted(void)
> +static bool host_tsx_broken(void)
>  {
>      int family, model, stepping;\
>      char vendor[CPUID_VENDOR_SZ + 1];
> @@ -408,7 +408,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>      } else if (function == 6 && reg == R_EAX) {
>          ret |= CPUID_6_EAX_ARAT; /* safe to allow because of emulated APIC */
>      } else if (function == 7 && index == 0 && reg == R_EBX) {
> -        if (host_tsx_blacklisted()) {
> +        if (host_tsx_broken()) {
>              ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
>          }
>      } else if (function == 7 && index == 0 && reg == R_EDX) {
> 

Applied to my trivial-patches branch.

Thanks,
Laurent

