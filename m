Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9036FB31
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 15:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhD3NJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 09:09:55 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:49703 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhD3NJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 09:09:54 -0400
Received: from [192.168.100.1] ([82.142.15.170]) by mrelayeu.kundenserver.de
 (mreue010 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1M2etD-1la0IM1chL-004F0A; Fri, 30 Apr 2021 15:07:57 +0200
Subject: Re: [PATCH] accel: kvm: clarify that extra exit data is hexadecimal
To:     David Edmondson <david.edmondson@oracle.com>, qemu-devel@nongnu.org
Cc:     qemu-trivial@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
References: <20210428142431.266879-1-david.edmondson@oracle.com>
From:   Laurent Vivier <laurent@vivier.eu>
Message-ID: <1c7d4641-7da2-ec5f-e931-c9499ff34205@vivier.eu>
Date:   Fri, 30 Apr 2021 15:07:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210428142431.266879-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:QJ6V3Q9+FKxd+WkhS1cf8YqYJEvUkAerm7patM7RuiRdo3XY9DK
 WNT3hscPlTNuu1NGvOrrLuUlMv/FB7snhyV3VPt4RJw5x3+W6U0ZiXtk+nvxglN7P4nnrdA
 tcWbbQryZZQsJM0ObVATf1BnB9mygmPERPLJYql+oMAxC0UhkG/RKjLrOTv3OfLkE6SoOzv
 Vy3DlUfnI6HB0oew5Tmgg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nF2FljgqfGQ=:JNoGSgYcG+JUTS0CpR4dnd
 X00xag9RUJyh5q4bq66A6Ddm0TdE5MCMm4b3T9m4PXhK0XS92gulVf9qgOT5XGgNl4fehKND8
 EwNrpjJ9Xd+nO2m3UJspehIwBbfuQjZPmfU2RhWKiPShJuzq7EB3ADmr2WVV33Z1UVQXWmwJz
 4k8gRvPu55Lu5tZKlMdPNiGwzV4sO8HykV4AO6Erphd4voZcpNTw1Avltdd9XgsGk6U+Ks0zc
 1bPpEuF3XYAVyOU80SdyTapYuBlFLRABHc+HqHv4IavS+8iysP2PN/zI1lwTtNOgB3jf+W2Ts
 sQKx+9O/DR8YfBG/qY94gXBSUGL0bgpLxbbvmBo2aZTennY0xnknYIX/sgaaLCEKSxfyj5Xue
 0YXN/xEKnRNfqkLV1N4Hq65dYGDd8eo3/J4D7jRgs88CS32CaXZSjbhpPGDc/Dl9i17iHa86P
 iovF6z9IVE7o7ioICoFtrXr37Rj0ldtYxQEVM3+yduzhCXg+m/whZCbUrk4WswsqsRflhWIHM
 CiLIPRBJh5uzWfplQ7vcEU=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 28/04/2021 à 16:24, David Edmondson a écrit :
> When dumping the extra exit data provided by KVM, make it clear that
> the data is hexadecimal.
> 
> At the same time, zero-pad the output.
> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  accel/kvm/kvm-all.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index b6d9f92f15..93d7cbfeaf 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2269,7 +2269,7 @@ static int kvm_handle_internal_error(CPUState *cpu, struct kvm_run *run)
>          int i;
>  
>          for (i = 0; i < run->internal.ndata; ++i) {
> -            fprintf(stderr, "extra data[%d]: %"PRIx64"\n",
> +            fprintf(stderr, "extra data[%d]: 0x%016"PRIx64"\n",
>                      i, (uint64_t)run->internal.data[i]);
>          }
>      }
> 

Applied to my trivial-patches branch.

Thanks,
Laurent

