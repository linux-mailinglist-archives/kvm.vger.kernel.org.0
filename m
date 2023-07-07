Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D874AA16
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 06:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjGGEw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 00:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjGGEw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 00:52:56 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B2410F7;
        Thu,  6 Jul 2023 21:52:53 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 42D53120003;
        Fri,  7 Jul 2023 07:52:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 42D53120003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688705572;
        bh=9VxNKVkl0KSq5bEapiGV2wEyObLBoul2dcTRSiwh07I=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=QW1pz+FNfZvjIW+CUyRkC3Fn0y4Ed+uo2ntS6eETda18OsY3HAxOo0YRCJcjBYmec
         aiF77vaXeg77nyDBgG+RlA3tei6sEV+C87lgG4aKX4E4UqRgLUts4KOVoDJbenTENj
         37dqfFJ7wtUh18cNYJnxpdIBV6t8bKFCoGzcu79ul0a8gbNpJiW7JXgAJgDmmRI8K/
         Xmtoo/fqVUtKgbw26L2sQh9+VI7CyZAGQH/zwFKjc239xldtC6YuuYx83//QC4j8kW
         Va4U3VZ5tNEx2biBwNHWigTzBqoUwHliTP5XzY23N4iegFHaRqYPuDSS0IbUh9/Rtu
         /YCzYyYLaV2BQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri,  7 Jul 2023 07:52:51 +0300 (MSK)
Received: from [192.168.0.12] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 7 Jul 2023 07:52:37 +0300
Message-ID: <6328cdd3-3ee8-34f3-18b5-5de8c7454b2f@sberdevices.ru>
Date:   Fri, 7 Jul 2023 07:47:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v5 17/17] test/vsock: io_uring rx/tx tests
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-18-AVKrasnov@sberdevices.ru>
 <CAGxU2F5V8jfGnYnp3wdLR3PVwvW6ce02U+R5k1G81r2FdxCV0Q@mail.gmail.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <CAGxU2F5V8jfGnYnp3wdLR3PVwvW6ce02U+R5k1G81r2FdxCV0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178485 [Jul 06 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 520 520 ccb018a655251011855942a2571029252d3d69a2, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/07 00:05:00 #21574510
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.07.2023 20:06, Stefano Garzarella wrote:
> On Sat, Jul 01, 2023 at 09:39:47AM +0300, Arseniy Krasnov wrote:
>> This adds set of tests which use io_uring for rx/tx. This test suite is
>> implemented as separated util like 'vsock_test' and has the same set of
>> input arguments as 'vsock_test'. These tests only cover cases of data
>> transmission (no connect/bind/accept etc).
> 
> Cool, thanks for adding this!
> 
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> tools/testing/vsock/Makefile           |   7 +-
>> tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
>> 2 files changed, 327 insertions(+), 1 deletion(-)
>> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>>
>> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>> index 0a78787d1d92..8621ae73051d 100644
>> --- a/tools/testing/vsock/Makefile
>> +++ b/tools/testing/vsock/Makefile
>> @@ -1,12 +1,17 @@
>> # SPDX-License-Identifier: GPL-2.0-only
>> +ifeq ($(MAKECMDGOALS),vsock_uring_test)
>> +LDFLAGS = -luring
>> +endif
>> +
>> all: test vsock_perf
>> test: vsock_test vsock_diag_test
>> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>> vsock_perf: vsock_perf.o
>> +vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o $(LDFLAGS)
> 
> Why we need `$(LDFLAGS)` in the dependencies?

Hm, yes, seems my mistake, LDFLAGS must be used without adding it to dependencies.
I'll check it.

Thanks, Arseniy

> 
> 
>>
>> CFLAGS += -g -O2 -Werror -Wall -I. -I../../include
>> -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow
>> -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
>> .PHONY: all test clean
>> clean:
>> -      ${RM} *.o *.d vsock_test vsock_diag_test
>> +      ${RM} *.o *.d vsock_test vsock_diag_test vsock_uring_test
>> -include *.d
>> diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
>> new file mode 100644
>> index 000000000000..7637ff510490
>> --- /dev/null
>> +++ b/tools/testing/vsock/vsock_uring_test.c
>> @@ -0,0 +1,321 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* io_uring tests for vsock
>> + *
>> + * Copyright (C) 2023 SberDevices.
>> + *
>> + * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> + */
>> +
>> +#include <getopt.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <liburing.h>
>> +#include <unistd.h>
>> +#include <sys/mman.h>
>> +#include <linux/kernel.h>
>> +#include <error.h>
>> +
>> +#include "util.h"
>> +#include "control.h"
>> +
>> +#define PAGE_SIZE             4096
>> +#define RING_ENTRIES_NUM      4
>> +
>> +static struct vsock_test_data test_data_array[] = {
>> +      /* All elements have page aligned base and size. */
>> +      {
>> +              .vecs_cnt = 3,
>> +              {
>> +                      { NULL, PAGE_SIZE },
>> +                      { NULL, 2 * PAGE_SIZE },
>> +                      { NULL, 3 * PAGE_SIZE },
>> +              }
>> +      },
>> +      /* Middle element has both non-page aligned base and size. */
>> +      {
>> +              .vecs_cnt = 3,
>> +              {
>> +                      { NULL, PAGE_SIZE },
>> +                      { (void *)1, 200  },
>> +                      { NULL, 3 * PAGE_SIZE },
>> +              }
>> +      }
>> +};
>> +
>> +static void vsock_io_uring_client(const struct test_opts *opts,
>> +                                const struct vsock_test_data *test_data,
>> +                                bool msg_zerocopy)
>> +{
>> +      struct io_uring_sqe *sqe;
>> +      struct io_uring_cqe *cqe;
>> +      struct io_uring ring;
>> +      struct iovec *iovec;
>> +      struct msghdr msg;
>> +      int fd;
>> +
>> +      fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +      if (fd < 0) {
>> +              perror("connect");
>> +              exit(EXIT_FAILURE);
>> +      }
>> +
>> +      if (msg_zerocopy)
>> +              enable_so_zerocopy(fd);
>> +
>> +      iovec = iovec_from_test_data(test_data);
>> +
>> +      if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>> +              error(1, errno, "io_uring_queue_init");
>> +
>> +      if (io_uring_register_buffers(&ring, iovec, test_data->vecs_cnt))
>> +              error(1, errno, "io_uring_register_buffers");
>> +
>> +      memset(&msg, 0, sizeof(msg));
>> +      msg.msg_iov = iovec;
>> +      msg.msg_iovlen = test_data->vecs_cnt;
>> +      sqe = io_uring_get_sqe(&ring);
>> +
>> +      if (msg_zerocopy)
>> +              io_uring_prep_sendmsg_zc(sqe, fd, &msg, 0);
>> +      else
>> +              io_uring_prep_sendmsg(sqe, fd, &msg, 0);
>> +
>> +      if (io_uring_submit(&ring) != 1)
>> +              error(1, errno, "io_uring_submit");
>> +
>> +      if (io_uring_wait_cqe(&ring, &cqe))
>> +              error(1, errno, "io_uring_wait_cqe");
>> +
>> +      io_uring_cqe_seen(&ring, cqe);
>> +
>> +      control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>> +
>> +      control_writeln("DONE");
>> +      io_uring_queue_exit(&ring);
>> +      free_iovec_test_data(test_data, iovec);
>> +      close(fd);
>> +}
>> +
>> +static void vsock_io_uring_server(const struct test_opts *opts,
>> +                                const struct vsock_test_data *test_data)
>> +{
>> +      unsigned long remote_hash;
>> +      unsigned long local_hash;
>> +      struct io_uring_sqe *sqe;
>> +      struct io_uring_cqe *cqe;
>> +      struct io_uring ring;
>> +      struct iovec iovec;
>> +      size_t data_len;
>> +      void *data;
>> +      int fd;
>> +
>> +      fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +      if (fd < 0) {
>> +              perror("accept");
>> +              exit(EXIT_FAILURE);
>> +      }
>> +
>> +      data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
>> +
>> +      data = malloc(data_len);
>> +      if (!data) {
>> +              perror("malloc");
>> +              exit(EXIT_FAILURE);
>> +      }
>> +
>> +      if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>> +              error(1, errno, "io_uring_queue_init");
>> +
>> +      sqe = io_uring_get_sqe(&ring);
>> +      iovec.iov_base = data;
>> +      iovec.iov_len = data_len;
>> +
>> +      io_uring_prep_readv(sqe, fd, &iovec, 1, 0);
>> +
>> +      if (io_uring_submit(&ring) != 1)
>> +              error(1, errno, "io_uring_submit");
>> +
>> +      if (io_uring_wait_cqe(&ring, &cqe))
>> +              error(1, errno, "io_uring_wait_cqe");
>> +
>> +      if (cqe->res != data_len) {
>> +              fprintf(stderr, "expected %zu, got %u\n", data_len,
>> +                      cqe->res);
>> +              exit(EXIT_FAILURE);
>> +      }
>> +
>> +      local_hash = hash_djb2(data, data_len);
>> +
>> +      remote_hash = control_readulong();
>> +      if (remote_hash != local_hash) {
>> +              fprintf(stderr, "hash mismatch\n");
>> +              exit(EXIT_FAILURE);
>> +      }
>> +
>> +      control_expectln("DONE");
>> +      io_uring_queue_exit(&ring);
>> +      free(data);
>> +}
>> +
>> +void test_stream_uring_server(const struct test_opts *opts)
>> +{
>> +      int i;
>> +
>> +      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +              vsock_io_uring_server(opts, &test_data_array[i]);
>> +}
>> +
>> +void test_stream_uring_client(const struct test_opts *opts)
>> +{
>> +      int i;
>> +
>> +      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +              vsock_io_uring_client(opts, &test_data_array[i], false);
>> +}
>> +
>> +void test_stream_uring_msg_zc_server(const struct test_opts *opts)
>> +{
>> +      int i;
>> +
>> +      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +              vsock_io_uring_server(opts, &test_data_array[i]);
>> +}
>> +
>> +void test_stream_uring_msg_zc_client(const struct test_opts *opts)
>> +{
>> +      int i;
>> +
>> +      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +              vsock_io_uring_client(opts, &test_data_array[i], true);
>> +}
>> +
>> +static struct test_case test_cases[] = {
>> +      {
>> +              .name = "SOCK_STREAM io_uring test",
>> +              .run_server = test_stream_uring_server,
>> +              .run_client = test_stream_uring_client,
>> +      },
>> +      {
>> +              .name = "SOCK_STREAM io_uring MSG_ZEROCOPY test",
>> +              .run_server = test_stream_uring_msg_zc_server,
>> +              .run_client = test_stream_uring_msg_zc_client,
>> +      },
>> +      {},
>> +};
>> +
>> +static const char optstring[] = "";
>> +static const struct option longopts[] = {
>> +      {
>> +              .name = "control-host",
>> +              .has_arg = required_argument,
>> +              .val = 'H',
>> +      },
>> +      {
>> +              .name = "control-port",
>> +              .has_arg = required_argument,
>> +              .val = 'P',
>> +      },
>> +      {
>> +              .name = "mode",
>> +              .has_arg = required_argument,
>> +              .val = 'm',
>> +      },
>> +      {
>> +              .name = "peer-cid",
>> +              .has_arg = required_argument,
>> +              .val = 'p',
>> +      },
>> +      {
>> +              .name = "help",
>> +              .has_arg = no_argument,
>> +              .val = '?',
>> +      },
>> +      {},
>> +};
>> +
>> +static void usage(void)
>> +{
>> +      fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
>> +              "\n"
>> +              "  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
>> +              "  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
>> +              "\n"
>> +              "Run transmission tests using io_uring. Usage is the same as\n"
>> +              "in ./vsock_test\n"
>> +              "\n"
>> +              "Options:\n"
>> +              "  --help                 This help message\n"
>> +              "  --control-host <host>  Server IP address to connect to\n"
>> +              "  --control-port <port>  Server port to listen on/connect to\n"
>> +              "  --mode client|server   Server or client mode\n"
>> +              "  --peer-cid <cid>       CID of the other side\n"
>> +              );
>> +      exit(EXIT_FAILURE);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +      const char *control_host = NULL;
>> +      const char *control_port = NULL;
>> +      struct test_opts opts = {
>> +              .mode = TEST_MODE_UNSET,
>> +              .peer_cid = VMADDR_CID_ANY,
>> +      };
>> +
>> +      init_signals();
>> +
>> +      for (;;) {
>> +              int opt = getopt_long(argc, argv, optstring, longopts, NULL);
>> +
>> +              if (opt == -1)
>> +                      break;
>> +
>> +              switch (opt) {
>> +              case 'H':
>> +                      control_host = optarg;
>> +                      break;
>> +              case 'm':
>> +                      if (strcmp(optarg, "client") == 0) {
>> +                              opts.mode = TEST_MODE_CLIENT;
>> +                      } else if (strcmp(optarg, "server") == 0) {
>> +                              opts.mode = TEST_MODE_SERVER;
>> +                      } else {
>> +                              fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
>> +                              return EXIT_FAILURE;
>> +                      }
>> +                      break;
>> +              case 'p':
>> +                      opts.peer_cid = parse_cid(optarg);
>> +                      break;
>> +              case 'P':
>> +                      control_port = optarg;
>> +                      break;
>> +              case '?':
>> +              default:
>> +                      usage();
>> +              }
>> +      }
>> +
>> +      if (!control_port)
>> +              usage();
>> +      if (opts.mode == TEST_MODE_UNSET)
>> +              usage();
>> +      if (opts.peer_cid == VMADDR_CID_ANY)
>> +              usage();
>> +
>> +      if (!control_host) {
>> +              if (opts.mode != TEST_MODE_SERVER)
>> +                      usage();
>> +              control_host = "0.0.0.0";
>> +      }
>> +
>> +      control_init(control_host, control_port,
>> +                   opts.mode == TEST_MODE_SERVER);
>> +
>> +      run_tests(test_cases, &opts);
>> +
>> +      control_cleanup();
>> +
>> +      return 0;
>> +}
>> --
>> 2.25.1
>>
> 
