Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA026F0D3F
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 22:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbjD0UfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 16:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbjD0Uey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 16:34:54 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9B83ABC
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:34:52 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3ef36d814a5so822851cf.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682627692; x=1685219692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1yyV2YzfH7rOLyHSf8GhXQSsNeJYF/6E6RCMyqSCyg=;
        b=xWHYdie28I+Dez+Z3Rys12aHD1WWeZJoHzaHoIa7wcXOPIBcUJrSIuADWRfc0FdzxP
         8e3l+bJ0YjkOB7WyI1b8J+NETOkP3kmkPs9FH1uEkMUSahlgQMCzLw7FUo6VwDEcAOH+
         KwKw2xODiy/cUdO8T3O70ZcZ+cOoKsspZOqObuLm9JKxeqRkRgaJ/Dj4jPYu34hBtIfw
         OesBLyuY6cCeCLFVB70JAVF0/PrWrbBH8zSa8RoScKsj/jSSeMgKmoe+4mDNk347ANPi
         j7dZ+HIdnJGOx1H1aiH8QrWDYrHtXaKTqFJc7lYOyU3ysXPKDXYB+SWBbYpWApHo8paB
         7j0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682627692; x=1685219692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1yyV2YzfH7rOLyHSf8GhXQSsNeJYF/6E6RCMyqSCyg=;
        b=eni+3wrgNT/U1FDnovZhjZ0xismlNRgPeJNVBiskDM0e2QczDVEvbu+tpX9XAIPJqe
         KeOCwAXfJO40/yvICbP3ZV7b8fOZu3F/XR6cWB8uASuqlgYy49IGdWJ589clEJ4sGuuW
         1UwINmJVS23nJd4Wwh+eY25Lp5ReozPvjhKeoFfqZI/de4emNCxFfooTpSVXwzfCLLtk
         tdoHAapUwHDRxyjABmSSCwN9u36ApVZaIXvl8HAnIyYpmPHcdnIlsGHxO0LZp54LV1hl
         ezABTx8HsrH5LmVxSt9cJotVREHR5gcPboJ9iXfErynHYzn1DoBO13DgLjopA8ygbnF+
         7SEQ==
X-Gm-Message-State: AC+VfDzXRp0KSTS7caITtfA6KSSdHBSz3P5dC3T+NCO33CzaTIG1fHsM
        /8xRZ1LxcyusqER4m9PX02RsgFN6tPoFHSRqklZ8hg==
X-Google-Smtp-Source: ACHHUZ4UPSDWGdGeDyVcwUFiL8hMkoisHo6Rmqr+2so+fTP3z2DsM7cV0c+3kFYv5gQRh8jeVS7NjJKQsn0vWDjJbIY=
X-Received: by 2002:ac8:5710:0:b0:3ef:5008:336f with SMTP id
 16-20020ac85710000000b003ef5008336fmr99178qtw.1.1682627691911; Thu, 27 Apr
 2023 13:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230427201112.2164776-1-peterx@redhat.com> <20230427201112.2164776-3-peterx@redhat.com>
In-Reply-To: <20230427201112.2164776-3-peterx@redhat.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 27 Apr 2023 13:34:16 -0700
Message-ID: <CADrL8HUAY62FX_TYqU9ro4wfhJhcCAC-aDW=zUS5eYQTbWx3oA@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/kvm: Allow dump per-vcpu info for uffd threads
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Apr 27, 2023 at 1:11=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> There's one PER_VCPU_DEBUG in per-vcpu uffd threads but it's never hit.
>
> Trigger that when quit in normal ways (kick pollfd[1]), meanwhile fix the
> number of nanosec calculation.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  tools/testing/selftests/kvm/lib/userfaultfd_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/t=
esting/selftests/kvm/lib/userfaultfd_util.c
> index 92cef20902f1..271f63891581 100644
> --- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -70,7 +70,7 @@ static void *uffd_handler_thread_fn(void *arg)
>                         r =3D read(pollfd[1].fd, &tmp_chr, 1);
>                         TEST_ASSERT(r =3D=3D 1,
>                                     "Error reading pipefd in UFFD thread\=
n");
> -                       return NULL;
> +                       break;
>                 }
>
>                 if (!(pollfd[0].revents & POLLIN))
> @@ -103,7 +103,7 @@ static void *uffd_handler_thread_fn(void *arg)
>         ts_diff =3D timespec_elapsed(start);
>         PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n=
",
>                        pages, ts_diff.tv_sec, ts_diff.tv_nsec,
> -                      pages / ((double)ts_diff.tv_sec + (double)ts_diff.=
tv_nsec / 100000000.0));
> +                      pages / ((double)ts_diff.tv_sec + (double)ts_diff.=
tv_nsec / NSEC_PER_SEC));

I almost confused this fix for [1]. Thanks for catching this!

[1]: https://lore.kernel.org/kvm/20230223001805.2971237-1-amoorthy@google.c=
om/

>
>         return NULL;
>  }
> --
> 2.39.1
>
