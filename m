Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E83770084
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjHDMtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 08:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjHDMtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 08:49:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F949F9;
        Fri,  4 Aug 2023 05:48:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-307d58b3efbso1747914f8f.0;
        Fri, 04 Aug 2023 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691153322; x=1691758122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xjH/ryp1J57ZKJnJ2tl0LljaSJPaayNedWWuu7ipUsU=;
        b=WduViqHTvAq6wggt3wylP2g1m7R03G0zmozRk7zfAa+372lYPbg9KfpKRHTIrOi6jg
         r+KZnGx7sNwUUy+StCRHqqcRyeGuMbkP5GaOZrMirZrZpdFaAPYFRdRW1VNuwH4HzguH
         KHbzw35KkOETcaJBsPuqlNGcvTE1vulIj/qUm098rCLyyxXmisOhef7l5Wwrt4lSinte
         SdVQLtA/715Pez0npBlm6dFiFuyYhBQUoevO7yO5SSR8wewOzSHEoiTHq3sDaNPQF70n
         xabYb+zwwO55ZnPfwIYG9qZeW2aehhOuCFTPbUePbXxJB6tlcxOc2JGUjDELfXrhKLRS
         gIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691153322; x=1691758122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xjH/ryp1J57ZKJnJ2tl0LljaSJPaayNedWWuu7ipUsU=;
        b=Za2IadEwSX5qexjLkz6GLQmPGKvftG1u7dILVyFfWl9qDkhll9JYzbL8dfn+vkEpVz
         4EafxgY0E8PhFK4z58+dgEyfaFv26ibYj+2KT5IapIGWro+ZctUy/yughl1xP6CsIIZv
         Mu0POEB+pqfCVd4JOZylqMC0h4ruaJp6UUgARaq6MiAkV5Sjb0MjG6BiQ+tkfvBcVKK2
         pQIxH9AuqIJygvqMmgCVYAh6LwphCmMO818RZwgunxwNBXf7XLo1LxgXnP3MR7YVpbNB
         urYMgMK95oFZdFfwpPMvXJMJd8PombF77qTlzlfcc7PI2zViuXyfBKjPWVbMRtJoq/DH
         PoLA==
X-Gm-Message-State: AOJu0YylSDPynjPKhmCR5PNWX8Vm8FKjmsIUVTIxNGSsSn8jLw/t4ns8
        mEDcip+9iZPEZiCuGZx5xfE=
X-Google-Smtp-Source: AGHT+IG3RyJc+EVDKHnJrUxtxF1bZHzSETebjwatfa4H8sdNgt2QKMrSsgxt0rOhIhQCKNoV1DOtSQ==
X-Received: by 2002:adf:ce90:0:b0:314:3b02:a8a8 with SMTP id r16-20020adfce90000000b003143b02a8a8mr1286060wrn.55.1691153321907;
        Fri, 04 Aug 2023 05:48:41 -0700 (PDT)
Received: from [10.9.105.115] ([41.86.56.122])
        by smtp.gmail.com with ESMTPSA id f9-20020a7bc8c9000000b003fba92fad35sm6606038wml.26.2023.08.04.05.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 05:48:41 -0700 (PDT)
Message-ID: <3e7b020e-329b-6800-2b60-08207bda8b03@gmail.com>
Date:   Fri, 4 Aug 2023 15:48:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v1 2/2] test/vsock: shutdowned socket test
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-3-AVKrasnov@sberdevices.ru>
 <76yecufn7766obfi5zae5hpg6yrlestrqocnk56jgnukakkdds@rqbgbhh7xgck>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <76yecufn7766obfi5zae5hpg6yrlestrqocnk56jgnukakkdds@rqbgbhh7xgck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.08.2023 11:00, Stefano Garzarella wrote:
> On Tue, Aug 01, 2023 at 05:17:27PM +0300, Arseniy Krasnov wrote:
>> This adds two tests for 'shutdown()' call. It checks that SIGPIPE is
>> sent when MSG_NOSIGNAL is not set and vice versa. Both flags SHUT_WR
>> and SHUT_RD are tested.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
>> 1 file changed, 138 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 90718c2fd4ea..21d40a8d881c 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -19,6 +19,7 @@
>> #include <time.h>
>> #include <sys/mman.h>
>> #include <poll.h>
>> +#include <signal.h>
>>
>> #include "timeout.h"
>> #include "control.h"
>> @@ -1170,6 +1171,133 @@ static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
>>     return test_msg_peek_server(opts, true);
>> }
>>
>> +static bool have_sigpipe;
>                  ^
> We should define it as `volatile sig_atomic_t`:
> 
> the behavior is undefined if the signal handler refers to any object
> [CX] [Option Start]  other than errno [Option End]  with static storage
> duration other than by assigning a value to an object declared as
> volatile sig_atomic_t

Yes, exactly, I forgot about sig_atomic_t.

I'll fix it.

Thanks, Arseniy

> 
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/signal.html
> 
> The rest LGTM!
> 
> Thanks,
> Stefano
> 
>> +
>> +static void sigpipe(int signo)
>> +{
>> +    have_sigpipe = true;
>> +}
>> +
>> +static void test_stream_check_sigpipe(int fd)
>> +{
>> +    ssize_t res;
>> +
>> +    have_sigpipe = false;
>> +
>> +    res = send(fd, "A", 1, 0);
>> +    if (res != -1) {
>> +        fprintf(stderr, "expected send(2) failure, got %zi\n", res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (!have_sigpipe) {
>> +        fprintf(stderr, "SIGPIPE expected\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    have_sigpipe = false;
>> +
>> +    res = send(fd, "A", 1, MSG_NOSIGNAL);
>> +    if (res != -1) {
>> +        fprintf(stderr, "expected send(2) failure, got %zi\n", res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (have_sigpipe) {
>> +        fprintf(stderr, "SIGPIPE not expected\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +}
>> +
>> +static void test_stream_shutwr_client(const struct test_opts *opts)
>> +{
>> +    int fd;
>> +
>> +    struct sigaction act = {
>> +        .sa_handler = sigpipe,
>> +    };
>> +
>> +    sigaction(SIGPIPE, &act, NULL);
>> +
>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (shutdown(fd, SHUT_WR)) {
>> +        perror("shutdown");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    test_stream_check_sigpipe(fd);
>> +
>> +    control_writeln("CLIENTDONE");
>> +
>> +    close(fd);
>> +}
>> +
>> +static void test_stream_shutwr_server(const struct test_opts *opts)
>> +{
>> +    int fd;
>> +
>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_expectln("CLIENTDONE");
>> +
>> +    close(fd);
>> +}
>> +
>> +static void test_stream_shutrd_client(const struct test_opts *opts)
>> +{
>> +    int fd;
>> +
>> +    struct sigaction act = {
>> +        .sa_handler = sigpipe,
>> +    };
>> +
>> +    sigaction(SIGPIPE, &act, NULL);
>> +
>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_expectln("SHUTRDDONE");
>> +
>> +    test_stream_check_sigpipe(fd);
>> +
>> +    control_writeln("CLIENTDONE");
>> +
>> +    close(fd);
>> +}
>> +
>> +static void test_stream_shutrd_server(const struct test_opts *opts)
>> +{
>> +    int fd;
>> +
>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (shutdown(fd, SHUT_RD)) {
>> +        perror("shutdown");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("SHUTRDDONE");
>> +    control_expectln("CLIENTDONE");
>> +
>> +    close(fd);
>> +}
>> +
>> static struct test_case test_cases[] = {
>>     {
>>         .name = "SOCK_STREAM connection reset",
>> @@ -1250,6 +1378,16 @@ static struct test_case test_cases[] = {
>>         .run_client = test_seqpacket_msg_peek_client,
>>         .run_server = test_seqpacket_msg_peek_server,
>>     },
>> +    {
>> +        .name = "SOCK_STREAM SHUT_WR",
>> +        .run_client = test_stream_shutwr_client,
>> +        .run_server = test_stream_shutwr_server,
>> +    },
>> +    {
>> +        .name = "SOCK_STREAM SHUT_RD",
>> +        .run_client = test_stream_shutrd_client,
>> +        .run_server = test_stream_shutrd_server,
>> +    },
>>     {},
>> };
>>
>> -- 
>> 2.25.1
>>
> 
