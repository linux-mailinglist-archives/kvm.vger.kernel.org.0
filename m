Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE04F6CB7
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiDFVb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiDFVb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:31:28 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108BD2A2679
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:37:13 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2eb543fe73eso40161447b3.5
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 13:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSwQ++FPyKB/vl2bGzRhFWSxoUzqGVu0Qa3zcm0+NfI=;
        b=gBxOw0iOw1J8HClN/uFFu0sKeRWMZxQ0rip9XVW1IyOZJBuu6Tzu9J8LeKdWS2jMkH
         HTAQk5sUlb5pzXUxCnXlJS5rcuSxky8ob1bhWdUrOqBT3U1+LtuoC0d1vIGHmcF4E4v9
         6O7XbqkiswHR4DZdZ5GfajSloucuqoM0d+FL7KBnLM5AM5zYz5Vdp2s6FKZWTmk3WirX
         vHr7OlOL9K2e9GjiAwrTEnRMaOsl2Z8yO9WvuzSlUK75bXn0nAxK+dCJ2rsTExtvmFaF
         144g0hKlbMM68rN6c4hmBmAs+li435U4LwVewzh/gmKUrT70RE39iCu7QkmBH8cW2WRv
         P19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSwQ++FPyKB/vl2bGzRhFWSxoUzqGVu0Qa3zcm0+NfI=;
        b=VMlv7lzkufIL+EpJR0tEIs/mo0hu2SK8plC8IulDRzNG9+szJnyL3kzmlcgmtqIH3m
         kEVunw+FnkPyUjnm7LgjmAiQOGqUsFYBtH/U+nNIZtOLFN8zqMTPN0b5Srb12gyz8XMr
         1Muvf8cwZeNx4vbv9+sqantyBTap3q3LLQLae0gy6OlXr1pqXfKG85C8xeaQ7texZITU
         /7CFdm8swzgvcfNUA/JVw7Fs9PC0RCg8xwjsWiULeQmsoetlhNQzMz854vnM3S4o1jiD
         1+CpGvcgzxwUtrUykCyJ5m8V2J1ibirPWneroqUhEmGn4SrrmSsRgweh84+uA45jtJBG
         lVag==
X-Gm-Message-State: AOAM531QKyWAPZyE9xHdjIPcFUWfQiWPFwB9YjhsH5JfJW7xSibqloF7
        ak6ZjydhjfVBdgESOp17ebUWPnOHXM7o5r6FlKQXZA==
X-Google-Smtp-Source: ABdhPJx6BjpXpRTZbOCj6S4XC4E20ax9/WY3he9jDUUmpUOjjPX98vnnGCOKnlrBeyYUaG54088ly2FIWWatFwNAM7U=
X-Received: by 2002:a0d:d5c3:0:b0:2e5:cc05:1789 with SMTP id
 x186-20020a0dd5c3000000b002e5cc051789mr8479547ywd.472.1649277432095; Wed, 06
 Apr 2022 13:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-3-bgardon@google.com>
 <YkzAV8FPdSjzDOd1@google.com>
In-Reply-To: <YkzAV8FPdSjzDOd1@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 6 Apr 2022 13:37:01 -0700
Message-ID: <CANgfPd9frTex7L1ouCHCeNU_C6b-cxZJL+3FG31wAu5HRRT4YQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Dump VM stats in binary stats test
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
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

On Tue, Apr 5, 2022 at 3:19 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Mar 30, 2022 at 10:46:12AM -0700, Ben Gardon wrote:
> > Add kvm_util library functions to read KVM stats through the binary
> > stats interface and then dump them to stdout when running the binary
> > stats test. Subsequent commits will extend the kvm_util code and use it
> > to make assertions in a test for NX hugepages.
> >
> > CC: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |   1 +
> >  .../selftests/kvm/kvm_binary_stats_test.c     |   3 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 143 ++++++++++++++++++
> >  3 files changed, 147 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 976aaaba8769..4783fd1cd4cf 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
> >
> >  int vm_get_stats_fd(struct kvm_vm *vm);
> >  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> > +void dump_vm_stats(struct kvm_vm *vm);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > index 17f65d514915..afc4701ce8dd 100644
> > --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -174,6 +174,9 @@ static void vm_stats_test(struct kvm_vm *vm)
> >       stats_test(stats_fd);
> >       close(stats_fd);
> >       TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
> > +
> > +     /* Dump VM stats */
> > +     dump_vm_stats(vm);
> >  }
> >
> >  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 11a692cf4570..f87df68b150d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2562,3 +2562,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
> >
> >       return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
> >  }
> > +
> > +/* Caller is responsible for freeing the returned kvm_stats_header. */
> > +static struct kvm_stats_header *read_vm_stats_header(int stats_fd)
> > +{
> > +     struct kvm_stats_header *header;
> > +     ssize_t ret;
> > +
> > +     /* Read kvm stats header */
> > +     header = malloc(sizeof(*header));
> > +     TEST_ASSERT(header, "Allocate memory for stats header");
> > +
> > +     ret = read(stats_fd, header, sizeof(*header));
> > +     TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> > +
> > +     return header;
> > +}
>
> It seems like this helper could be used in kvm_binary_stats_test.c to
> eliminate duplicate code.

It could, but I think the duplicate code in that test has value in
being verbose and well commented and having a bunch of checks to
assert things the regular library function isn't interested in.
I'd prefer to keep the duplication as-is.

>
> > +
> > +static void dump_header(int stats_fd, struct kvm_stats_header *header)
> > +{
> > +     ssize_t ret;
> > +     char *id;
> > +
> > +     printf("flags: %u\n", header->flags);
> > +     printf("name size: %u\n", header->name_size);
> > +     printf("num_desc: %u\n", header->num_desc);
> > +     printf("id_offset: %u\n", header->id_offset);
> > +     printf("desc_offset: %u\n", header->desc_offset);
> > +     printf("data_offset: %u\n", header->data_offset);
> > +
> > +     /* Read kvm stats id string */
> > +     id = malloc(header->name_size);
> > +     TEST_ASSERT(id, "Allocate memory for id string");
> > +     ret = pread(stats_fd, id, header->name_size, header->id_offset);
> > +     TEST_ASSERT(ret == header->name_size, "Read id string");
> > +
> > +     printf("id: %s\n", id);
> > +
> > +     free(id);
> > +}
> > +
> > +static ssize_t stats_desc_size(struct kvm_stats_header *header)
> > +{
> > +     return sizeof(struct kvm_stats_desc) + header->name_size;
> > +}
> > +
> > +/* Caller is responsible for freeing the returned kvm_stats_desc. */
> > +static struct kvm_stats_desc *read_vm_stats_desc(int stats_fd,
> > +                                              struct kvm_stats_header *header)
> > +{
> > +     struct kvm_stats_desc *stats_desc;
> > +     size_t size_desc;
> > +     ssize_t ret;
> > +
> > +     size_desc = header->num_desc * stats_desc_size(header);
> > +
> > +     /* Allocate memory for stats descriptors */
> > +     stats_desc = malloc(size_desc);
> > +     TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> > +
> > +     /* Read kvm stats descriptors */
> > +     ret = pread(stats_fd, stats_desc, size_desc, header->desc_offset);
> > +     TEST_ASSERT(ret == size_desc, "Read KVM stats descriptors");
> > +
> > +     return stats_desc;
> > +}
>
> Same with this helper.
>
> > +
> > +/* Caller is responsible for freeing the memory *data. */
> > +static int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> > +                       struct kvm_stats_desc *desc, uint64_t **data)
> > +{
> > +     u64 *stats_data;
> > +     ssize_t ret;
> > +
> > +     stats_data = malloc(desc->size * sizeof(*stats_data));
> > +
> > +     ret = pread(stats_fd, stats_data, desc->size * sizeof(*stats_data),
> > +                 header->data_offset + desc->offset);
> > +
> > +     /* ret is in bytes. */
> > +     ret = ret / sizeof(*stats_data);
> > +
> > +     TEST_ASSERT(ret == desc->size,
> > +                 "Read data of KVM stats: %s", desc->name);
> > +
> > +     *data = stats_data;
> > +
> > +     return ret;
> > +}
>
> Same with this helper.
>
> > +
> > +static void dump_stat(int stats_fd, struct kvm_stats_header *header,
> > +                   struct kvm_stats_desc *desc)
> > +{
> > +     u64 *stats_data;
> > +     ssize_t ret;
> > +     int i;
> > +
> > +     printf("\tflags: %u\n", desc->flags);
> > +     printf("\texponent: %u\n", desc->exponent);
> > +     printf("\tsize: %u\n", desc->size);
> > +     printf("\toffset: %u\n", desc->offset);
> > +     printf("\tbucket_size: %u\n", desc->bucket_size);
> > +     printf("\tname: %s\n", (char *)&desc->name);
> > +
> > +     ret = read_stat_data(stats_fd, header, desc, &stats_data);
> > +
> > +     printf("\tdata: %lu", *stats_data);
> > +     for (i = 1; i < ret; i++)
> > +             printf(", %lu", *(stats_data + i));
> > +     printf("\n\n");
> > +
> > +     free(stats_data);
> > +}
> > +
> > +void dump_vm_stats(struct kvm_vm *vm)
> > +{
> > +     struct kvm_stats_desc *stats_desc;
> > +     struct kvm_stats_header *header;
> > +     struct kvm_stats_desc *desc;
> > +     size_t size_desc;
> > +     int stats_fd;
> > +     int i;
> > +
> > +     stats_fd = vm_get_stats_fd(vm);
> > +
> > +     header = read_vm_stats_header(stats_fd);
> > +     dump_header(stats_fd, header);
> > +
> > +     stats_desc = read_vm_stats_desc(stats_fd, header);
> > +
> > +     size_desc = stats_desc_size(header);
> > +
> > +     /* Read kvm stats data one by one */
> > +     for (i = 0; i < header->num_desc; ++i) {
> > +             desc = (void *)stats_desc + (i * size_desc);
> > +             dump_stat(stats_fd, header, desc);
> > +     }
> > +
> > +     free(stats_desc);
> > +     free(header);
> > +
> > +     close(stats_fd);
> > +}
> > +
> > --
> > 2.35.1.1021.g381101b075-goog
> >
