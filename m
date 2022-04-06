Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC44F6CD4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiDFVfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiDFVe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:34:28 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A3316BCD5
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:49:02 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2e64a6b20eeso40600477b3.3
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WHuiTVMzOu/G4N5A7/XhEoBcceNzSg+USAXqJ4DGBJM=;
        b=n4WWQeUZ7DJk10ayZdnFG35bvu6nAHc+bOzCRfEV/MKbk2vKdvpcmjBd8raZfWheiK
         HGQLtQsXHmWxftu4njnZ5BIfpZ5sNjOjUST6aFDdFKGNbfn0yQjM4v8L+Vs5YRw/DOEs
         e9Th5d1FoNnfVLznb0Vp3hUr+WfQc8pC2/HDNG0Lcyjy1qeK9EjdljRYNMK+ekBXsBiB
         TXZyZUyVPgMO/3DBxwjzsBBfa9ULzo+FiWSxuYszkEIxRJJVBzTgDblAaxMnvcGLsIJZ
         SRzGgUsfDcdS8ELxTRjaz5aFjzzh12mP1UGKNm0MW5rBS8TLOX2ic+eNM+aEkedK7/F6
         d7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WHuiTVMzOu/G4N5A7/XhEoBcceNzSg+USAXqJ4DGBJM=;
        b=ckoBS9CMxHMczdtPQq+QEL+fJhpZ1zzbxVVhlFZ05zop5uJv4YqTVopLtUJyrpvPc8
         MRt8xkepfyD3feTU2/mfsXNlyqLPE2EpCiTWIkokmdYlYpefZSXp0gBMZld1fmVp9dPz
         QyVulYhr9cxf4/+xibZVxaq9UNLBAkLOHxaZz85gdGthqd5XcmKy2knznzHWPX8CXACy
         7+st35dqUCTmxaTLI3mkrJNKH4yoDADK6+1fis/PNDtkKZhLzP8bfCE5U7o9wcq/71SY
         9ZNoNdJ4SR2pN2ZwI4hVeJDam87TN9BKGe+k1+nJ6jl/HIByk2HVvXk19QLkfawzMZ3d
         euFA==
X-Gm-Message-State: AOAM533vnRAMVwY5j2enHtnVm1To7vdeZprLnXaDulrcvc1TKrM0Zhr9
        uKgXiJwhK6Ez1UjZXkeO+a9/R1BvnxW67A5bYwR7+w==
X-Google-Smtp-Source: ABdhPJwuJoeIIXWujwLOGjbRRuwN2N7IUM86IvsuFfG+uYj8QUCQPhq3Yklmnw+3BgnlUv+islcTR3mLgAVQ42d1wpA=
X-Received: by 2002:a0d:d5c3:0:b0:2e5:cc05:1789 with SMTP id
 x186-20020a0dd5c3000000b002e5cc051789mr8513921ywd.472.1649278141176; Wed, 06
 Apr 2022 13:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-4-bgardon@google.com>
 <YkzBjF3NyI9fyZad@google.com>
In-Reply-To: <YkzBjF3NyI9fyZad@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 6 Apr 2022 13:48:50 -0700
Message-ID: <CANgfPd8xTpsW-9hZACY74JfyDBU2vLoBVLGUNyABgBsjm0L4Kw@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: selftests: Test reading a single stat
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 5, 2022 at 3:24 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Mar 30, 2022 at 10:46:13AM -0700, Ben Gardon wrote:
> > Retrieve the value of a single stat by name in the binary stats test to
> > ensure the kvm_util library functions work.
> >
> > CC: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  1 +
> >  .../selftests/kvm/kvm_binary_stats_test.c     |  3 ++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
> >  3 files changed, 57 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 4783fd1cd4cf..78c4407f36b4 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -402,6 +402,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
> >  int vm_get_stats_fd(struct kvm_vm *vm);
> >  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> >  void dump_vm_stats(struct kvm_vm *vm);
> > +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > index afc4701ce8dd..97bde355f105 100644
> > --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -177,6 +177,9 @@ static void vm_stats_test(struct kvm_vm *vm)
> >
> >       /* Dump VM stats */
> >       dump_vm_stats(vm);
> > +
> > +     /* Read a single stat. */
> > +     printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
> >  }
> >
> >  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index f87df68b150d..9c4574381daa 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2705,3 +2705,56 @@ void dump_vm_stats(struct kvm_vm *vm)
> >       close(stats_fd);
> >  }
> >
> > +static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
> > +                         uint64_t **data)
> > +{
> > +     struct kvm_stats_desc *stats_desc;
> > +     struct kvm_stats_header *header;
> > +     struct kvm_stats_desc *desc;
> > +     size_t size_desc;
> > +     int stats_fd;
> > +     int ret = -EINVAL;
> > +     int i;
> > +
> > +     *data = NULL;
> > +
> > +     stats_fd = vm_get_stats_fd(vm);
> > +
> > +     header = read_vm_stats_header(stats_fd);
> > +
> > +     stats_desc = read_vm_stats_desc(stats_fd, header);
> > +
> > +     size_desc = stats_desc_size(header);
> > +
> > +     /* Read kvm stats data one by one */
> > +     for (i = 0; i < header->num_desc; ++i) {
> > +             desc = (void *)stats_desc + (i * size_desc);
> > +
> > +             if (strcmp(desc->name, stat_name))
> > +                     continue;
> > +
> > +             ret = read_stat_data(stats_fd, header, desc, data);
> > +     }
> > +
> > +     free(stats_desc);
> > +     free(header);
> > +
> > +     close(stats_fd);
> > +
> > +     return ret;
> > +}
> > +
> > +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> > +{
> > +     uint64_t *data;
> > +     uint64_t value;
> > +     int ret;
> > +
> > +     ret = vm_get_stat_data(vm, stat_name, &data);
> > +     TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
> > +                 stat_name, ret);
> > +     value = *data;
> > +     free(data);
>
> Allocating temporary storage for the data is unnecessary. Just read the
> stat directly into &value. You'll need to change read_stat_data() to
> accept another parameter that defines the number of elements the caller
> wants to read. Otherwise botched stats could trigger a buffer overflow.

Will do.

>
> > +     return value;
> > +}
> > +
> > --
> > 2.35.1.1021.g381101b075-goog
> >
