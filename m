Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933C27B8517
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 18:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243347AbjJDQ1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 12:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243320AbjJDQ1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 12:27:09 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD199B;
        Wed,  4 Oct 2023 09:27:03 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 5FD88100004;
        Wed,  4 Oct 2023 19:27:00 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 5FD88100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696436820;
        bh=EFQVhw6fYTMY6UWXKcDcO7apZ+fR55bhOQt6crlIk1I=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=ALil8poam6PVIlTiQFA+4gPDdt6M+32dus+jed43yAGppm6/r4MW93WwOXkSW/M7B
         JqRddGfHkYepUPY9/06EABAFHF46uBGSjj/0gSZZkYW/cKkiLW9hnqCdEHD4qX2vvl
         RuZdCKUbBIWuvHkjRHBZU3C70DjoFyupGXnyeqTM8qa6ztThFne1/snJCb3rGMd8Ue
         206/p309wVwv/UQ3K3d1EnMe/FmmzoR+b90vpTtIvixMaFLa5TDp2/NEKgml50Pfiw
         PYYkbzxMapGuqe3Xt3vF6BKuyMtR88a/ImOMooVXObEgyvlgccbY/c63DJfyfycTiQ
         SbwKP0PmFGtRQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed,  4 Oct 2023 19:26:59 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 4 Oct 2023 19:26:59 +0300
Message-ID: <16da1122-f5c7-cea1-b12e-c77b67349e45@salutedevices.com>
Date:   Wed, 4 Oct 2023 19:20:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 10/12] test/vsock: MSG_ZEROCOPY flag tests
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
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-11-avkrasnov@salutedevices.com>
 <z2pa3jl37srx7rymhswjiazkssq67scrp2dh5pjyb73zxa4232@6verblafci2w>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <z2pa3jl37srx7rymhswjiazkssq67scrp2dh5pjyb73zxa4232@6verblafci2w>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180362 [Oct 04 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/04 15:39:00 #22058417
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.10.2023 18:39, Stefano Garzarella wrote:
> On Sun, Oct 01, 2023 at 12:03:06AM +0300, Arseniy Krasnov wrote:
>> This adds three tests for MSG_ZEROCOPY feature:
>> 1) SOCK_STREAM tx with different buffers.
>> 2) SOCK_SEQPACKET tx with different buffers.
>> 3) SOCK_STREAM test to read empty error queue of the socket.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v1 -> v2:
>>  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
>>
>> tools/testing/vsock/Makefile              |   2 +-
>> tools/testing/vsock/util.c                | 214 +++++++++++++++
>> tools/testing/vsock/util.h                |  27 ++
>> tools/testing/vsock/vsock_test.c          |  16 ++
>> tools/testing/vsock/vsock_test_zerocopy.c | 314 ++++++++++++++++++++++
>> tools/testing/vsock/vsock_test_zerocopy.h |  15 ++
>> 6 files changed, 587 insertions(+), 1 deletion(-)
>> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
>> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
>>
>> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>> index 21a98ba565ab..1a26f60a596c 100644
>> --- a/tools/testing/vsock/Makefile
>> +++ b/tools/testing/vsock/Makefile
>> @@ -1,7 +1,7 @@
>> # SPDX-License-Identifier: GPL-2.0-only
>> all: test vsock_perf
>> test: vsock_test vsock_diag_test
>> -vsock_test: vsock_test.o timeout.o control.o util.o
>> +vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>> vsock_perf: vsock_perf.o
>>
>> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>> index 6779d5008b27..2a641ab38f08 100644
>> --- a/tools/testing/vsock/util.c
>> +++ b/tools/testing/vsock/util.c
>> @@ -11,10 +11,14 @@
>> #include <stdio.h>
>> #include <stdint.h>
>> #include <stdlib.h>
>> +#include <string.h>
>> #include <signal.h>
>> #include <unistd.h>
>> #include <assert.h>
>> #include <sys/epoll.h>
>> +#include <sys/mman.h>
>> +#include <linux/errqueue.h>
>> +#include <poll.h>
>>
>> #include "timeout.h"
>> #include "control.h"
>> @@ -444,3 +448,213 @@ unsigned long hash_djb2(const void *data, size_t len)
>>
>>     return hash;
>> }
>> +
>> +void enable_so_zerocopy(int fd)
>> +{
>> +    int val = 1;
>> +
>> +    if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
>> +        perror("setsockopt");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +}
>> +
>> +static void *mmap_no_fail(size_t bytes)
>> +{
>> +    void *res;
>> +
>> +    res = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
>> +           MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>> +    if (res == MAP_FAILED) {
>> +        perror("mmap");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    return res;
>> +}
>> +
>> +size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
>> +{
>> +    size_t bytes;
>> +    int i;
>> +
>> +    for (bytes = 0, i = 0; i < iovnum; i++)
>> +        bytes += iov[i].iov_len;
>> +
>> +    return bytes;
>> +}
>> +
>> +static void iovec_random_init(struct iovec *iov,
>> +                  const struct vsock_test_data *test_data)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < test_data->vecs_cnt; i++) {
>> +        int j;
>> +
>> +        if (test_data->vecs[i].iov_base == MAP_FAILED)
>> +            continue;
>> +
>> +        for (j = 0; j < iov[i].iov_len; j++)
>> +            ((uint8_t *)iov[i].iov_base)[j] = rand() & 0xff;
>> +    }
>> +}
>> +
>> +unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum)
>> +{
>> +    unsigned long hash;
>> +    size_t iov_bytes;
>> +    size_t offs;
>> +    void *tmp;
>> +    int i;
>> +
>> +    iov_bytes = iovec_bytes(iov, iovnum);
>> +
>> +    tmp = malloc(iov_bytes);
>> +    if (!tmp) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    for (offs = 0, i = 0; i < iovnum; i++) {
>> +        memcpy(tmp + offs, iov[i].iov_base, iov[i].iov_len);
>> +        offs += iov[i].iov_len;
>> +    }
>> +
>> +    hash = hash_djb2(tmp, iov_bytes);
>> +    free(tmp);
>> +
>> +    return hash;
>> +}
>> +
>> +struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data)
>> +{
>> +    const struct iovec *test_iovec;
>> +    struct iovec *iovec;
>> +    int i;
>> +
>> +    iovec = malloc(sizeof(*iovec) * test_data->vecs_cnt);
>> +    if (!iovec) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    test_iovec = test_data->vecs;
>> +
>> +    for (i = 0; i < test_data->vecs_cnt; i++) {
>> +        iovec[i].iov_len = test_iovec[i].iov_len;
>> +        iovec[i].iov_base = mmap_no_fail(test_iovec[i].iov_len);
>> +
>> +        if (test_iovec[i].iov_base != MAP_FAILED &&
>> +            test_iovec[i].iov_base)
>> +            iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
>> +    }
>> +
>> +    /* Unmap "invalid" elements. */
>> +    for (i = 0; i < test_data->vecs_cnt; i++) {
>> +        if (test_iovec[i].iov_base == MAP_FAILED) {
>> +            if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>> +                perror("munmap");
>> +                exit(EXIT_FAILURE);
>> +            }
>> +        }
>> +    }
>> +
>> +    iovec_random_init(iovec, test_data);
>> +
>> +    return iovec;
>> +}
>> +
>> +void free_iovec_test_data(const struct vsock_test_data *test_data,
>> +              struct iovec *iovec)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < test_data->vecs_cnt; i++) {
>> +        if (test_data->vecs[i].iov_base != MAP_FAILED) {
>> +            if (test_data->vecs[i].iov_base)
>> +                iovec[i].iov_base -= (uintptr_t)test_data->vecs[i].iov_base;
>> +
>> +            if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>> +                perror("munmap");
>> +                exit(EXIT_FAILURE);
>> +            }
>> +        }
>> +    }
>> +
>> +    free(iovec);
>> +}
>> +
>> +#define POLL_TIMEOUT_MS        100
>> +void vsock_recv_completion(int fd, bool zerocopied, bool completion)
>> +{
>> +    struct sock_extended_err *serr;
>> +    struct msghdr msg = { 0 };
>> +    struct pollfd fds = { 0 };
>> +    char cmsg_data[128];
>> +    struct cmsghdr *cm;
>> +    ssize_t res;
>> +
>> +    fds.fd = fd;
>> +    fds.events = 0;
>> +
>> +    if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
>> +        perror("poll");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (!(fds.revents & POLLERR)) {
>> +        if (completion) {
>> +            fprintf(stderr, "POLLERR expected\n");
>> +            exit(EXIT_FAILURE);
>> +        } else {
>> +            return;
>> +        }
>> +    }
>> +
>> +    msg.msg_control = cmsg_data;
>> +    msg.msg_controllen = sizeof(cmsg_data);
>> +
>> +    res = recvmsg(fd, &msg, MSG_ERRQUEUE);
>> +    if (res) {
>> +        fprintf(stderr, "failed to read error queue: %zi\n", res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    cm = CMSG_FIRSTHDR(&msg);
>> +    if (!cm) {
>> +        fprintf(stderr, "cmsg: no cmsg\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (cm->cmsg_level != SOL_VSOCK) {
>> +        fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (cm->cmsg_type != VSOCK_RECVERR) {
>> +        fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    serr = (void *)CMSG_DATA(cm);
>> +    if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
>> +        fprintf(stderr, "serr: wrong origin: %u\n", serr->ee_origin);
> 
> What "serr" means?

serr == sock_extended_err, this function is based on the same logic from:
tools/testing/selftests/net/msg_zerocopy.c

> 
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (serr->ee_errno) {
>> +        fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>> +        fprintf(stderr, "serr: was copy instead of zerocopy\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (!zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>> +        fprintf(stderr, "serr: was zerocopy instead of copy\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +}
> 
> Why we are putting this functions in util.c if they are only used by
> zerocopy tests?
> 
>> diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>> index e5407677ce05..407f415adef6 100644
>> --- a/tools/testing/vsock/util.h
>> +++ b/tools/testing/vsock/util.h
>> @@ -2,9 +2,18 @@
>> #ifndef UTIL_H
>> #define UTIL_H
>>
>> +#include <stdbool.h>
>> #include <sys/socket.h>
>> #include <linux/vm_sockets.h>
>>
>> +#ifndef SOL_VSOCK
>> +#define SOL_VSOCK    287
>> +#endif
>> +
>> +#ifndef VSOCK_RECVERR
>> +#define VSOCK_RECVERR    1
>> +#endif
>> +
>> /* Tests can either run as the client or the server */
>> enum test_mode {
>>     TEST_MODE_UNSET,
>> @@ -18,6 +27,17 @@ struct test_opts {
>>     unsigned int peer_cid;
>> };
>>
> 
> Ditto.
> 
>> +#define VSOCK_TEST_DATA_MAX_IOV 4
>> +
>> +struct vsock_test_data {
>> +    bool stream_only;    /* Only for SOCK_STREAM. */
>> +    bool zerocopied;    /* Data must be zerocopied. */
>> +    bool so_zerocopy;    /* Enable zerocopy mode. */
> 
> What is the difference between `zerocopied` and `so_zerocopy`?
> We should explain better, or change the names, they are a bit confusing.
> 
>> +    int sendmsg_errno;    /* 'errno' after 'sendmsg()'. */
>> +    int vecs_cnt;        /* Number of elements in 'vecs'. */
>> +    struct iovec vecs[VSOCK_TEST_DATA_MAX_IOV];
>> +};
>> +
>> /* A test case definition.  Test functions must print failures to stderr and
>>  * terminate with exit(EXIT_FAILURE).
>>  */
>> @@ -53,4 +73,11 @@ void list_tests(const struct test_case *test_cases);
>> void skip_test(struct test_case *test_cases, size_t test_cases_len,
>>            const char *test_id_str);
>> unsigned long hash_djb2(const void *data, size_t len);
>> +void enable_so_zerocopy(int fd);
>> +size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
>> +unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum);
>> +struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data);
>> +void free_iovec_test_data(const struct vsock_test_data *test_data,
>> +              struct iovec *iovec);
>> +void vsock_recv_completion(int fd, bool zerocopied, bool completion);
>> #endif /* UTIL_H */
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index da4cb819a183..c1f7bc9abd22 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -21,6 +21,7 @@
>> #include <poll.h>
>> #include <signal.h>
>>
>> +#include "vsock_test_zerocopy.h"
>> #include "timeout.h"
>> #include "control.h"
>> #include "util.h"
>> @@ -1269,6 +1270,21 @@ static struct test_case test_cases[] = {
>>         .run_client = test_stream_shutrd_client,
>>         .run_server = test_stream_shutrd_server,
>>     },
>> +    {
>> +        .name = "SOCK_STREAM MSG_ZEROCOPY",
>> +        .run_client = test_stream_msgzcopy_client,
>> +        .run_server = test_stream_msgzcopy_server,
>> +    },
>> +    {
>> +        .name = "SOCK_SEQPACKET MSG_ZEROCOPY",
>> +        .run_client = test_seqpacket_msgzcopy_client,
>> +        .run_server = test_seqpacket_msgzcopy_server,
>> +    },
>> +    {
>> +        .name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
>> +        .run_client = test_stream_msgzcopy_empty_errq_client,
>> +        .run_server = test_stream_msgzcopy_empty_errq_server,
>> +    },
>>     {},
>> };
>>
>> diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>> new file mode 100644
>> index 000000000000..655ef92ef25d
>> --- /dev/null
>> +++ b/tools/testing/vsock/vsock_test_zerocopy.c
>> @@ -0,0 +1,314 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* MSG_ZEROCOPY feature tests for vsock
>> + *
>> + * Copyright (C) 2023 SberDevices.
>> + *
>> + * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> + */
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <sys/mman.h>
>> +#include <unistd.h>
>> +#include <poll.h>
>> +#include <linux/errqueue.h>
>> +#include <linux/kernel.h>
>> +#include <errno.h>
>> +
>> +#include "control.h"
>> +#include "vsock_test_zerocopy.h"
>> +
>> +#define PAGE_SIZE        4096
> 
> I think we can move all the util.c/util.h changes here.
> 
>> +
>> +static struct vsock_test_data test_data_array[] = {
>> +    /* Last element has non-page aligned size. */
>> +    {
>> +        .zerocopied = true,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 3,
>> +        {
>> +            { NULL, PAGE_SIZE },
>> +            { NULL, PAGE_SIZE },
>> +            { NULL, 200 }
>> +        }
>> +    },
>> +    /* All elements have page aligned base and size. */
>> +    {
>> +        .zerocopied = true,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 3,
>> +        {
>> +            { NULL, PAGE_SIZE },
>> +            { NULL, PAGE_SIZE * 2 },
>> +            { NULL, PAGE_SIZE * 3 }
>> +        }
>> +    },
>> +    /* All elements have page aligned base and size. But
>> +     * data length is bigger than 64Kb.
>> +     */
>> +    {
>> +        .zerocopied = true,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 3,
>> +        {
>> +            { NULL, PAGE_SIZE * 16 },
>> +            { NULL, PAGE_SIZE * 16 },
>> +            { NULL, PAGE_SIZE * 16 }
>> +        }
>> +    },
>> +    /* Middle element has both non-page aligned base and size. */
>> +    {
>> +        .zerocopied = true,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 3,
>> +        {
>> +            { NULL, PAGE_SIZE },
>> +            { (void *)1, 100 },
>> +            { NULL, PAGE_SIZE }
>> +        }
>> +    },
>> +    /* Middle element is unmapped. */
>> +    {
>> +        .zerocopied = false,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = ENOMEM,
>> +        .vecs_cnt = 3,
>> +        {
>> +            { NULL, PAGE_SIZE },
>> +            { MAP_FAILED, PAGE_SIZE },
>> +            { NULL, PAGE_SIZE }
>> +        }
>> +    },
>> +    /* Valid data, but SO_ZEROCOPY is off. This
>> +     * will trigger fallback to copy.
>> +     */
>> +    {
>> +        .zerocopied = false,
>> +        .so_zerocopy = false,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 1,
>> +        {
>> +            { NULL, PAGE_SIZE }
>> +        }
>> +    },
>> +    /* Valid data, but message is bigger than peer's
>> +     * buffer, so this will trigger fallback to copy.
>> +     * This test is for SOCK_STREAM only, because
>> +     * for SOCK_SEQPACKET, 'sendmsg()' returns EMSGSIZE.
>> +     */
>> +    {
>> +        .stream_only = true,
>> +        .zerocopied = false,
>> +        .so_zerocopy = true,
>> +        .sendmsg_errno = 0,
>> +        .vecs_cnt = 1,
>> +        {
>> +            { NULL, 100 * PAGE_SIZE }
>> +        }
>> +    },
>> +};
>> +
>> +static void test_client(const struct test_opts *opts,
>> +            const struct vsock_test_data *test_data,
>> +            bool sock_seqpacket)
>> +{
>> +    struct msghdr msg = { 0 };
>> +    ssize_t sendmsg_res;
>> +    struct iovec *iovec;
>> +    int fd;
>> +
>> +    if (sock_seqpacket)
>> +        fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>> +    else
>> +        fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (test_data->so_zerocopy)
>> +        enable_so_zerocopy(fd);
>> +
>> +    iovec = iovec_from_test_data(test_data);
>> +
>> +    msg.msg_iov = iovec;
>> +    msg.msg_iovlen = test_data->vecs_cnt;
>> +
>> +    errno = 0;
>> +
>> +    sendmsg_res = sendmsg(fd, &msg, MSG_ZEROCOPY);
>> +    if (errno != test_data->sendmsg_errno) {
>> +        fprintf(stderr, "expected 'errno' == %i, got %i\n",
>> +            test_data->sendmsg_errno, errno);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (!errno) {
>> +        if (sendmsg_res != iovec_bytes(iovec, test_data->vecs_cnt)) {
>> +            fprintf(stderr, "expected 'sendmsg()' == %li, got %li\n",
>> +                iovec_bytes(iovec, test_data->vecs_cnt),
>> +                sendmsg_res);
>> +            exit(EXIT_FAILURE);
>> +        }
>> +    }
>> +
>> +    /* Receive completion only in case of successful 'sendmsg()'. */
>> +    vsock_recv_completion(fd, test_data->zerocopied,
>> +                  test_data->so_zerocopy && !test_data->sendmsg_errno);
>> +
>> +    if (!test_data->sendmsg_errno)
>> +        control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>> +    else
>> +        control_writeulong(0);
>> +
>> +    control_writeln("DONE");
>> +    free_iovec_test_data(test_data, iovec);
>> +    close(fd);
>> +}
>> +
>> +void test_stream_msgzcopy_client(const struct test_opts *opts)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +        test_client(opts, &test_data_array[i], false);
>> +}
>> +
>> +void test_seqpacket_msgzcopy_client(const struct test_opts *opts)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
>> +        if (test_data_array[i].stream_only)
>> +            continue;
>> +
>> +        test_client(opts, &test_data_array[i], true);
>> +    }
>> +}
>> +
>> +static void test_server(const struct test_opts *opts,
>> +            const struct vsock_test_data *test_data,
>> +            bool sock_seqpacket)
>> +{
>> +    unsigned long remote_hash;
>> +    unsigned long local_hash;
>> +    ssize_t total_bytes_rec;
>> +    unsigned char *data;
>> +    size_t data_len;
>> +    int fd;
>> +
>> +    if (sock_seqpacket)
>> +        fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    else
>> +        fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
>> +
>> +    data = malloc(data_len);
>> +    if (!data) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    total_bytes_rec = 0;
>> +
>> +    while (total_bytes_rec != data_len) {
>> +        ssize_t bytes_rec;
>> +
>> +        bytes_rec = read(fd, data + total_bytes_rec,
>> +                 data_len - total_bytes_rec);
>> +        if (bytes_rec <= 0)
>> +            break;
>> +
>> +        total_bytes_rec += bytes_rec;
>> +    }
>> +
>> +    if (test_data->sendmsg_errno == 0)
>> +        local_hash = hash_djb2(data, data_len);
>> +    else
>> +        local_hash = 0;
>> +
>> +    free(data);
>> +
>> +    /* Waiting for some result. */
>> +    remote_hash = control_readulong();
>> +    if (remote_hash != local_hash) {
>> +        fprintf(stderr, "hash mismatch\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_expectln("DONE");
>> +    close(fd);
>> +}
>> +
>> +void test_stream_msgzcopy_server(const struct test_opts *opts)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>> +        test_server(opts, &test_data_array[i], false);
>> +}
>> +
>> +void test_seqpacket_msgzcopy_server(const struct test_opts *opts)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
>> +        if (test_data_array[i].stream_only)
>> +            continue;
>> +
>> +        test_server(opts, &test_data_array[i], true);
>> +    }
>> +}
>> +
>> +void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts)
>> +{
>> +    struct msghdr msg = { 0 };
>> +    char cmsg_data[128];
>> +    ssize_t res;
>> +    int fd;
>> +
>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    msg.msg_control = cmsg_data;
>> +    msg.msg_controllen = sizeof(cmsg_data);
>> +
>> +    res = recvmsg(fd, &msg, MSG_ERRQUEUE);
>> +    if (res != -1) {
>> +        fprintf(stderr, "expected 'recvmsg(2)' failure, got %zi\n",
>> +            res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("DONE");
>> +    close(fd);
>> +}
>> +
>> +void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
>> +{
>> +    int fd;
>> +
>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_expectln("DONE");
>> +    close(fd);
>> +}
>> diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
>> new file mode 100644
>> index 000000000000..3ef2579e024d
>> --- /dev/null
>> +++ b/tools/testing/vsock/vsock_test_zerocopy.h
>> @@ -0,0 +1,15 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef VSOCK_TEST_ZEROCOPY_H
>> +#define VSOCK_TEST_ZEROCOPY_H
>> +#include "util.h"
>> +
>> +void test_stream_msgzcopy_client(const struct test_opts *opts);
>> +void test_stream_msgzcopy_server(const struct test_opts *opts);
>> +
>> +void test_seqpacket_msgzcopy_client(const struct test_opts *opts);
>> +void test_seqpacket_msgzcopy_server(const struct test_opts *opts);
>> +
>> +void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts);
>> +void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts);
>> +
>> +#endif /* VSOCK_TEST_ZEROCOPY_H */
>> -- 
>> 2.25.1
>>
> 
