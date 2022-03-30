Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F324ECCB1
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349924AbiC3Sw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244584AbiC3SwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:52:24 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6B13585B
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:50:37 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id i186so23504523vsc.9
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4RP6ZIb6nfoCe38E1LjWdpnaf2x01PGpFhrn4r34+gk=;
        b=D4o24SCQHBEK/0l70rQ3rNq74R3VzyFN5awFR8E3t++6rzGP550Y75tNfTrFyNu5x3
         HwKzi93V832u6Or7ororHsnTNJvdA9L2bQrhXsjrP8DAhWbOpURyFC7aszY1VNbgi7PX
         kIEij1vpGA76hXfrar/RqKj1USWnRMMF7q3ReyBM18UTDirnv8Pk/KWdmRse19p5JGRC
         GOTDt6Vila6DgarlLkdXgAjGUGLwXzoIdN74feVn97yvy33Mz20jBnK40RJ18NxlWXMT
         5W9cKcchtzuzFGFYdR8uKVpVTCaqrMdxPdhjWIyzEL+Zkjyt5KWKTstrfwwLotQvCCeA
         N46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4RP6ZIb6nfoCe38E1LjWdpnaf2x01PGpFhrn4r34+gk=;
        b=EyNrTVJB2XvXviTeBWMulDIrTqYcL8/qZe+mAEuh2jB9y4HGkO/OOcJDjqfvUc/yPW
         E7ltJeqwiUD/BQ6nTW7twQ7wUPvLA5gjCV4qTmUii+sbhWNK2L+/8i513hhmMpa5zKev
         hrERwmw999/3Lj7RzgbJpKFcMhyXzXaD7GaSioDfhDXrzjCAiBe2376AUlG8f6IpeBjc
         RIhYHD8qYpOIIoZnPcIFlyPLKqHTL0E3F5+Z9LuJbAWr5e1P4Bcvi7q3stdPOjsCv6k0
         l06KEW/XN8k7SnOo/OSMz25QTIcizwjraC+EvlGRUlnHN88aHg/m5TiAxncXOueXpy9I
         HSgg==
X-Gm-Message-State: AOAM530/7Ptu49YTDPrsDrmG2FueZaQ98qejwJwNwJswN2aVjFna/yYw
        BHYG2D5FIMsGrEPW9O7FCfgwU0CbSSrMQQlFyIP8Iw==
X-Google-Smtp-Source: ABdhPJzcFFmI2sygg0IiWWXXPv74hvZzkkgklf0CQ5STYuqcwsE7CwvJBSV7OjXpon8cLhu8xl9UpF9mq7jYuceuof4=
X-Received: by 2002:a05:6102:670:b0:325:afe6:1253 with SMTP id
 z16-20020a056102067000b00325afe61253mr599228vsf.22.1648666236433; Wed, 30 Mar
 2022 11:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-3-bgardon@google.com>
In-Reply-To: <20220330174621.1567317-3-bgardon@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 30 Mar 2022 11:50:25 -0700
Message-ID: <CAAdAUtiaSgbYsggjxjASW-cKHo2ePWjCa4Buv+AixKm-magGXQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Dump VM stats in binary stats test
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 10:46 AM Ben Gardon <bgardon@google.com> wrote:
>
> Add kvm_util library functions to read KVM stats through the binary
> stats interface and then dump them to stdout when running the binary
> stats test. Subsequent commits will extend the kvm_util code and use it
> to make assertions in a test for NX hugepages.
>
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |   1 +
>  .../selftests/kvm/kvm_binary_stats_test.c     |   3 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 143 ++++++++++++++++++
>  3 files changed, 147 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 976aaaba8769..4783fd1cd4cf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> +void dump_vm_stats(struct kvm_vm *vm);
>
>  uint32_t guest_get_vcpuid(void);
>
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 17f65d514915..afc4701ce8dd 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -174,6 +174,9 @@ static void vm_stats_test(struct kvm_vm *vm)
>         stats_test(stats_fd);
>         close(stats_fd);
>         TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
> +
> +       /* Dump VM stats */
> +       dump_vm_stats(vm);
>  }
>
>  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 11a692cf4570..f87df68b150d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2562,3 +2562,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
>
>         return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>  }
> +
> +/* Caller is responsible for freeing the returned kvm_stats_header. */
> +static struct kvm_stats_header *read_vm_stats_header(int stats_fd)
> +{
> +       struct kvm_stats_header *header;
> +       ssize_t ret;
> +
> +       /* Read kvm stats header */
> +       header = malloc(sizeof(*header));
> +       TEST_ASSERT(header, "Allocate memory for stats header");
> +
> +       ret = read(stats_fd, header, sizeof(*header));
> +       TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> +
> +       return header;
> +}
> +
> +static void dump_header(int stats_fd, struct kvm_stats_header *header)
> +{
> +       ssize_t ret;
> +       char *id;
> +
> +       printf("flags: %u\n", header->flags);
> +       printf("name size: %u\n", header->name_size);
> +       printf("num_desc: %u\n", header->num_desc);
> +       printf("id_offset: %u\n", header->id_offset);
> +       printf("desc_offset: %u\n", header->desc_offset);
> +       printf("data_offset: %u\n", header->data_offset);
> +
> +       /* Read kvm stats id string */
> +       id = malloc(header->name_size);
> +       TEST_ASSERT(id, "Allocate memory for id string");
> +       ret = pread(stats_fd, id, header->name_size, header->id_offset);
> +       TEST_ASSERT(ret == header->name_size, "Read id string");
> +
> +       printf("id: %s\n", id);
> +
> +       free(id);
> +}
> +
> +static ssize_t stats_desc_size(struct kvm_stats_header *header)
> +{
> +       return sizeof(struct kvm_stats_desc) + header->name_size;
> +}
> +
> +/* Caller is responsible for freeing the returned kvm_stats_desc. */
> +static struct kvm_stats_desc *read_vm_stats_desc(int stats_fd,
> +                                                struct kvm_stats_header *header)
> +{
> +       struct kvm_stats_desc *stats_desc;
> +       size_t size_desc;
> +       ssize_t ret;
> +
> +       size_desc = header->num_desc * stats_desc_size(header);
> +
> +       /* Allocate memory for stats descriptors */
> +       stats_desc = malloc(size_desc);
> +       TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> +
> +       /* Read kvm stats descriptors */
> +       ret = pread(stats_fd, stats_desc, size_desc, header->desc_offset);
> +       TEST_ASSERT(ret == size_desc, "Read KVM stats descriptors");
> +
> +       return stats_desc;
> +}
> +
> +/* Caller is responsible for freeing the memory *data. */
> +static int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +                         struct kvm_stats_desc *desc, uint64_t **data)
> +{
> +       u64 *stats_data;
> +       ssize_t ret;
> +
> +       stats_data = malloc(desc->size * sizeof(*stats_data));
> +
> +       ret = pread(stats_fd, stats_data, desc->size * sizeof(*stats_data),
> +                   header->data_offset + desc->offset);
> +
> +       /* ret is in bytes. */
> +       ret = ret / sizeof(*stats_data);
> +
> +       TEST_ASSERT(ret == desc->size,
> +                   "Read data of KVM stats: %s", desc->name);
> +
> +       *data = stats_data;
> +
> +       return ret;
> +}
> +
> +static void dump_stat(int stats_fd, struct kvm_stats_header *header,
> +                     struct kvm_stats_desc *desc)
> +{
> +       u64 *stats_data;
> +       ssize_t ret;
> +       int i;
> +
> +       printf("\tflags: %u\n", desc->flags);
> +       printf("\texponent: %u\n", desc->exponent);
> +       printf("\tsize: %u\n", desc->size);
> +       printf("\toffset: %u\n", desc->offset);
> +       printf("\tbucket_size: %u\n", desc->bucket_size);
> +       printf("\tname: %s\n", (char *)&desc->name);
> +
> +       ret = read_stat_data(stats_fd, header, desc, &stats_data);
> +
> +       printf("\tdata: %lu", *stats_data);
> +       for (i = 1; i < ret; i++)
> +               printf(", %lu", *(stats_data + i));
> +       printf("\n\n");
> +
> +       free(stats_data);
> +}
> +
> +void dump_vm_stats(struct kvm_vm *vm)
> +{
> +       struct kvm_stats_desc *stats_desc;
> +       struct kvm_stats_header *header;
> +       struct kvm_stats_desc *desc;
> +       size_t size_desc;
> +       int stats_fd;
> +       int i;
> +
> +       stats_fd = vm_get_stats_fd(vm);
> +
> +       header = read_vm_stats_header(stats_fd);
> +       dump_header(stats_fd, header);
> +
> +       stats_desc = read_vm_stats_desc(stats_fd, header);
> +
> +       size_desc = stats_desc_size(header);
> +
> +       /* Read kvm stats data one by one */
> +       for (i = 0; i < header->num_desc; ++i) {
> +               desc = (void *)stats_desc + (i * size_desc);
> +               dump_stat(stats_fd, header, desc);
> +       }
> +
> +       free(stats_desc);
> +       free(header);
> +
> +       close(stats_fd);
> +}
> +
> --
> 2.35.1.1021.g381101b075-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
