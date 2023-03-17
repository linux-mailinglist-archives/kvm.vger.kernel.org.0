Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC006BF235
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCQUPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 16:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCQUPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 16:15:48 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326FB3E1CA
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:15:46 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id g23so4128627uak.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679084145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpiNCoQ2+ECAu0Qa5pXam+DH/IOK5zHBsyO0KdSU/oc=;
        b=hScem/ZE+Fh4HebuH/sjBZHvum8pkYFP8oz9K1wUYdqmlBew6kVS2kCWNYZMOYqtgT
         yoA8cuwWJi2P3CKlukCgoUukJsPXh6V3mluUIdO931Jtwa+PslAhlAFkl/hdPtmcNeZk
         /p2Vrj+MWCdbMVC5NT8fyxFZz/c76YVZ6baE7coPoc28iLo0AkRv5B3VGQBb5JeO+zbK
         cOlPKVwTSaxHR37BF6+6FbbK84fLsOShVJd9ykXG6zte0A/To7XNdwkX5OUqZHs10+/G
         ZChiiNZ+7SJuj5Zkj0ad8iSSb2IEF1N1qDbnYrwFGPej2p9/0g08EnlB2KeqIzkN8GSS
         1wlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gpiNCoQ2+ECAu0Qa5pXam+DH/IOK5zHBsyO0KdSU/oc=;
        b=QRz9W+ENeu0RHNck/2Xg9j8StivFCCRqr/jXktADb3qYrjeAwmwoJfzXIDUoBCc3Bt
         1foUExw4DPE6T93SmoCcESxMGtKJbhdpuzrXJGjZD392Rcaf5C+7tSCegptxRhAqtIE/
         JOaxj8vlEX+4xV2eBo1nYcmgUzrzoI4gatB7xJ/4AWP5GV7p/prrqC43vIz3noAoJSqd
         S1+miLfJC/mimEAVWZDjNReCsQ5kUZ0DoCg8eah6PgiAzUsF7YMFVXk++HaynLiTuI+Y
         lD21bY0oMieZKSlZgkkHxaJfJlc58iKxUXfKJUkl4FOANl3ndZl7sg4ogb9weBTtBE/i
         utXQ==
X-Gm-Message-State: AO0yUKUSxxFKfWVnMyO7vwdKUt8kZCNeQSYHZVCwM+8pUM9f+JBFcmAo
        rxyaaqHxCA5KVZs+qV9KgXx13E02Lv6cHBNqnPSybw==
X-Google-Smtp-Source: AK7set8VH+bybk41rZnQA1UUNEOAoDNfeVoj3v7pMoyS/o+C+onCHqHbHYjEy01UQZkDxPNot53wGKWxLFamjf7Wx70=
X-Received: by 2002:a1f:72cf:0:b0:40f:f3e1:53c with SMTP id
 n198-20020a1f72cf000000b0040ff3e1053cmr756714vkc.1.1679084145260; Fri, 17 Mar
 2023 13:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev>
In-Reply-To: <ZBS4o75PVHL4FQqw@linux.dev>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 13:15:09 -0700
Message-ID: <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
To:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Cc:     jthoughton@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 11:59=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:

> > +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
>
> call it KVM_MEM_EXIT_ABSENT_MAPPING
> ...
> I'm not a fan of this architecture-specific dependency. Userspace is alre=
ady
> explicitly opting in to this behavior by way of the memslot flag. These s=
ort
> of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> series.

I'm not a fan of the semantics varying between architectures either:
but the reason I have it like that (and that the EFAULT conversions
exist in this series in the first place) is (a) not having
KVM_CAP_MEMORY_FAULT_EXIT implemented for arm and (b) Sean's following
statement from https://lore.kernel.org/kvm/Y%2FfS0eab7GG0NVKS@google.com/

On Thu, Feb 23, 2023 at 12:55=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> The new memslot flag should depend on KVM_CAP_MEMORY_FAULT_EXIT, but
> KVM_CAP_MEMORY_FAULT_EXIT should be a standalone thing, i.e. should conve=
rt "all"
> guest-memory -EFAULTS to KVM_CAP_MEMORY_FAULT_EXIT.  All in quotes becaus=
e I would
> likely be ok with a partial conversion for the initial implementation if =
there
> are paths that would require an absurd amount of work to convert.

The best way that I thought of how to do that was to have one cap
(KVM_CAP_MEMORY_FAULT_NOWAIT) to make KVM -EFAULT without calling slow
GUP, and KVM_CAP_MEMORY_FAULT_EXIT to transform efaults to useful vm
exits. But if you think the two are really orthogonal, then we need to
resolve the apparent disagreement.
