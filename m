Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A815A30DD
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344613AbiHZVNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344593AbiHZVNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:13:30 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5417DE68C1
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:13:27 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q7so3525616lfu.5
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tbpadwyNsGF5OvB8OARNmocarvqfqchX8oAmiz2J6Do=;
        b=im090+OfFLEr50nKUecm4rK2iVu3y9FkYyrT2CcXNSzAxsnMc5I5ad+hcrrRTg5R8q
         xh/yj0a0v9xxVLj7XhzT13KW1ZE9m933i7G+igrYt8kT/UIPhQH+3vQB/qvT/X4fkAYP
         L+1O2tRtRIk9UYDA47u6KAD04tP31oAwMXl313v3PYetnrspzL3jUKscNZ1H52sSFxQL
         oEoayALbOaqMe27KsddtTeb7YryUHvGHm5mGP9r/9whVU1Mf6J6Mm6ZQgBDzgd0g69aB
         25j7x1Xjx2sZRdh63+Y1VYpB9hvc0tVB89aDR8oCvsuV1hnSptpYNEBkNdp2RPhccu5z
         SXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tbpadwyNsGF5OvB8OARNmocarvqfqchX8oAmiz2J6Do=;
        b=elNIcPJ/UgCpGYxW+ttkkXopJ6DvCLg4go72eo3689oFwnuExcfgmTMDwm0ALQesho
         JpMlUpC9reuFc9Gw0hBAMxL5SljZzSc2znSaf+vKjm0JoqLGMQYzfQUrA4hG8e8G6co1
         mV7yUJt9uELQcBbUau+rKgiCiXB0SQNnrAXKPaF7MXJWjZPAkGaqqFWIcsTeLRSJPOYR
         bOvhb9Ej6HNp2qrNlOTsJcj1cMZzgGm4UcOxoUvLziqfKrnkiBmlDEDr7yoOPsGN9Br0
         cwJ4KJ5/4CgHjJMuSQKmqBLlXY2rFG4gI9r2uPDqrs4npBKrcYKUUk4PNRKyrTGpWAtu
         fQWw==
X-Gm-Message-State: ACgBeo2R3xyekGpN+7azx+gunH0DNZdP9dn1H/Hn4C5zLvqnrTSt5mOO
        3oT1P9ee8z+BYGFIhBOW7qlKJfAleRGmkxKo3ytNwg==
X-Google-Smtp-Source: AA6agR6gSYM8FeWg1aka9MqO6V98wH2USEWbt+ev7Qg7QXHkG1gzvGeKWkDNS0yQzQtoyqiD5NDZFJNmSHuS/utNNGk=
X-Received: by 2002:a05:6512:3d06:b0:492:c211:b781 with SMTP id
 d6-20020a0565123d0600b00492c211b781mr3351561lfv.511.1661548405311; Fri, 26
 Aug 2022 14:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com> <20220826184500.1940077-2-vipinsh@google.com>
In-Reply-To: <20220826184500.1940077-2-vipinsh@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 26 Aug 2022 14:12:49 -0700
Message-ID: <CAHVum0e0piX9zS6BuqzzeCu1M=2fdOjdov18aA-AEOm=+bd2mg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: selftests: Explicitly set variables based on
 options in dirty_log_perf_test
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 11:45 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> Variable set via -g are also indirectly set by -e option by omitting
> break statement. Set them explicitly so that movement of switch-case
> statements does not unintentionally break features.
>
> No functional change intended.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..a03db7f9f4c0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -411,6 +411,8 @@ int main(int argc, char *argv[])
>                 case 'e':
>                         /* 'e' is for evil. */
>                         run_vcpus_while_disabling_dirty_logging = true;
> +                       dirty_log_manual_caps = 0;
> +                       break;

@Sean, I hope you intentionally didn't write a break between -e and -g
when you created the patch and it is not just a missed thing :)


>                 case 'g':
>                         dirty_log_manual_caps = 0;
>                         break;
> --
> 2.37.2.672.g94769d06f0-goog
>
