Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A604FC6EF
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiDKVzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiDKVzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:55:08 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A821C900
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:52:52 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u19so8903189lff.4
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pI4K/rWtmJbCFl6kiv6Q4jyEum/goaEHREnhmyYd7Pc=;
        b=VRCs/5nN1ovqngdWOExmadHC8jND5SOWNGH7bJqsVZBqpX2GbzcCwL8zGJuXg5DZsY
         Siudos0iY4X+peh1F1ZZjwVuWq0d7aL9D8F0NlJS1PiId+42UUmsnHS+cuwbDMJRZdb8
         klpWABVxNlh+7xEcztnsN22mc3AWJWVMu1/vEfsmzWsE7BrRy4j3O17wTrhOSrvUiPRc
         VdXHyqtnOUaC+vEtJR/bNsgyHdrcx2FtHrni2BdyIwqiyddq0eh17iO/Lw8PpNjfxmgL
         gb6zllGbApBPbC9pKo3FCE22qsbDxmJzceJtoVPdM7AM+WKheylNTSbykLTkOPXWwuw6
         78Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pI4K/rWtmJbCFl6kiv6Q4jyEum/goaEHREnhmyYd7Pc=;
        b=r9vX2guhflriTvIP7iNbARCJeWx44MZkGQheVDu4ya87gsFugH04v50iVNTclqDmmu
         0XeqZHXmA9H/WlbvMRHrme8kO4R986U8Q3+FVSU4RhKGvNLsGMI3hCBgr6CiQhFXp8KM
         pN1n1HbWC9Q0wpLj/6KA2OYDU6gsNpKybJB+j666WpHTOXVhIAQLwuHEiZgV2MqLspi5
         rI2q+4qCuDxu6WYP5P0dkYlRhcCSBLCSANk1kgyxwXsiNlwTQxeTbFvw/a+RmjRPnS8Z
         K+quq3+JfO1Rr7fkE+bKMZSSmJfLybeGwWBaw9U3Qa2ekmuPEiGmY05YvwpR2Coox3jl
         UBBg==
X-Gm-Message-State: AOAM5328KIR0mhEfZ3XK6vDr1gIdeRJB+NJVpo3C0VtYelKASoxVfTB3
        Fn2UQbyzvStZY+drRGugpPMI8MRf9NYkMaQ2gj88Cg==
X-Google-Smtp-Source: ABdhPJz2KX8XMYBTqkLJeTv6BOxEdbL24TWjbtAoG3LTQYbwlAaHLzqzwgFWPtDsVUv+ftzpqNQsSSXzfQFvOVgthms=
X-Received: by 2002:a05:6512:128e:b0:44a:4067:9ffe with SMTP id
 u14-20020a056512128e00b0044a40679ffemr23423879lfs.64.1649713970708; Mon, 11
 Apr 2022 14:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-2-bgardon@google.com>
In-Reply-To: <20220411211015.3091615-2-bgardon@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Apr 2022 14:52:24 -0700
Message-ID: <CALzav=d_DB+onkMZmZwEj7yd_gDqg_phqQJpTw0g9ahe3WmvqA@mail.gmail.com>
Subject: Re: [PATCH v4 01/10] KVM: selftests: Remove dynamic memory allocation
 for stats header
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
>
> There's no need to allocate dynamic memory for the stats header since
> its size is known at compile time.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  .../selftests/kvm/kvm_binary_stats_test.c     | 58 +++++++++----------
>  1 file changed, 27 insertions(+), 31 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 17f65d514915..dad34d8a41fe 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -26,56 +26,53 @@ static void stats_test(int stats_fd)
>         int i;
>         size_t size_desc;
>         size_t size_data = 0;
> -       struct kvm_stats_header *header;
> +       struct kvm_stats_header header;
>         char *id;
>         struct kvm_stats_desc *stats_desc;
>         u64 *stats_data;
>         struct kvm_stats_desc *pdesc;
>
>         /* Read kvm stats header */
> -       header = malloc(sizeof(*header));
> -       TEST_ASSERT(header, "Allocate memory for stats header");
> -
> -       ret = read(stats_fd, header, sizeof(*header));
> -       TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> -       size_desc = sizeof(*stats_desc) + header->name_size;
> +       ret = read(stats_fd, &header, sizeof(header));
> +       TEST_ASSERT(ret == sizeof(header), "Read stats header");
> +       size_desc = sizeof(*stats_desc) + header.name_size;
>
>         /* Read kvm stats id string */
> -       id = malloc(header->name_size);
> +       id = malloc(header.name_size);
>         TEST_ASSERT(id, "Allocate memory for id string");
> -       ret = read(stats_fd, id, header->name_size);
> -       TEST_ASSERT(ret == header->name_size, "Read id string");
> +       ret = read(stats_fd, id, header.name_size);
> +       TEST_ASSERT(ret == header.name_size, "Read id string");
>
>         /* Check id string, that should start with "kvm" */
> -       TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header->name_size,
> +       TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
>                                 "Invalid KVM stats type, id: %s", id);
>
>         /* Sanity check for other fields in header */
> -       if (header->num_desc == 0) {
> +       if (header.num_desc == 0) {
>                 printf("No KVM stats defined!");
>                 return;
>         }
>         /* Check overlap */
> -       TEST_ASSERT(header->desc_offset > 0 && header->data_offset > 0
> -                       && header->desc_offset >= sizeof(*header)
> -                       && header->data_offset >= sizeof(*header),
> +       TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
> +                       && header.desc_offset >= sizeof(header)
> +                       && header.data_offset >= sizeof(header),
>                         "Invalid offset fields in header");
> -       TEST_ASSERT(header->desc_offset > header->data_offset ||
> -                       (header->desc_offset + size_desc * header->num_desc <=
> -                                                       header->data_offset),
> +       TEST_ASSERT(header.desc_offset > header.data_offset ||
> +                       (header.desc_offset + size_desc * header.num_desc <=
> +                                                       header.data_offset),
>                         "Descriptor block is overlapped with data block");
>
>         /* Allocate memory for stats descriptors */
> -       stats_desc = calloc(header->num_desc, size_desc);
> +       stats_desc = calloc(header.num_desc, size_desc);
>         TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
>         /* Read kvm stats descriptors */
>         ret = pread(stats_fd, stats_desc,
> -                       size_desc * header->num_desc, header->desc_offset);
> -       TEST_ASSERT(ret == size_desc * header->num_desc,
> +                       size_desc * header.num_desc, header.desc_offset);
> +       TEST_ASSERT(ret == size_desc * header.num_desc,
>                         "Read KVM stats descriptors");
>
>         /* Sanity check for fields in descriptors */
> -       for (i = 0; i < header->num_desc; ++i) {
> +       for (i = 0; i < header.num_desc; ++i) {
>                 pdesc = (void *)stats_desc + i * size_desc;
>                 /* Check type,unit,base boundaries */
>                 TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
> @@ -104,7 +101,7 @@ static void stats_test(int stats_fd)
>                         break;
>                 }
>                 /* Check name string */
> -               TEST_ASSERT(strlen(pdesc->name) < header->name_size,
> +               TEST_ASSERT(strlen(pdesc->name) < header.name_size,
>                                 "KVM stats name(%s) too long", pdesc->name);
>                 /* Check size field, which should not be zero */
>                 TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
> @@ -124,14 +121,14 @@ static void stats_test(int stats_fd)
>                 size_data += pdesc->size * sizeof(*stats_data);
>         }
>         /* Check overlap */
> -       TEST_ASSERT(header->data_offset >= header->desc_offset
> -               || header->data_offset + size_data <= header->desc_offset,
> +       TEST_ASSERT(header.data_offset >= header.desc_offset
> +               || header.data_offset + size_data <= header.desc_offset,
>                 "Data block is overlapped with Descriptor block");
>         /* Check validity of all stats data size */
> -       TEST_ASSERT(size_data >= header->num_desc * sizeof(*stats_data),
> +       TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
>                         "Data size is not correct");
>         /* Check stats offset */
> -       for (i = 0; i < header->num_desc; ++i) {
> +       for (i = 0; i < header.num_desc; ++i) {
>                 pdesc = (void *)stats_desc + i * size_desc;
>                 TEST_ASSERT(pdesc->offset < size_data,
>                         "Invalid offset (%u) for stats: %s",
> @@ -142,15 +139,15 @@ static void stats_test(int stats_fd)
>         stats_data = malloc(size_data);
>         TEST_ASSERT(stats_data, "Allocate memory for stats data");
>         /* Read kvm stats data as a bulk */
> -       ret = pread(stats_fd, stats_data, size_data, header->data_offset);
> +       ret = pread(stats_fd, stats_data, size_data, header.data_offset);
>         TEST_ASSERT(ret == size_data, "Read KVM stats data");
>         /* Read kvm stats data one by one */
>         size_data = 0;
> -       for (i = 0; i < header->num_desc; ++i) {
> +       for (i = 0; i < header.num_desc; ++i) {
>                 pdesc = (void *)stats_desc + i * size_desc;
>                 ret = pread(stats_fd, stats_data,
>                                 pdesc->size * sizeof(*stats_data),
> -                               header->data_offset + size_data);
> +                               header.data_offset + size_data);
>                 TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
>                                 "Read data of KVM stats: %s", pdesc->name);
>                 size_data += pdesc->size * sizeof(*stats_data);
> @@ -159,7 +156,6 @@ static void stats_test(int stats_fd)
>         free(stats_data);
>         free(stats_desc);
>         free(id);
> -       free(header);
>  }
>
>
> --
> 2.35.1.1178.g4f1659d476-goog
>
