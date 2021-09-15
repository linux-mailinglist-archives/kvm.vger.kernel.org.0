Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463D40CF13
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhIOV5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhIOV5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:57:41 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7E9C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:56:22 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b15so4535605ils.10
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aShydBVRXLiIBWXuwQG0mC/y0LItYbBYk4fdb7bSweg=;
        b=mhl/9K6NnogX97B7j2gz0qJTH0ZVsMLmXrFpdtv40Yp4khd/fQ2wrgsyYH1chrwM2N
         JZwtiCQXmgZvS8I4hhNxX1a7ssUHxX600hsXHHxWdaZzMFscRLkuVxdHkMgG6WxKZOHu
         fr2WZAM6toG6qaGzMUZx45TnS6qpS5wlvSX2LmT4WEoL0eacSZDynRSbI/yU5FXfc+gn
         FB45EHshqvpyfZCJw6loFUtmMi4Ikr3u/HGkyMO1vFt2u2dRQdnL4sWnGk9hTi/RLQ6i
         WsPx0EtWUIqs9cYoDhRz+ntuiE/HB1+gnm0BtKRpOXN4D9ucUd0iTxOY0nMobP0uufS7
         XLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aShydBVRXLiIBWXuwQG0mC/y0LItYbBYk4fdb7bSweg=;
        b=fWaI+oDq6SWtDiWAOoSMYFb5mwmrlzniHq8qQHrEVAEcfebIXp4omYfOhmLZdi41BK
         hq/OT8Y653X//9+6bTM+DzUsPXRFXkHEXoYydPh4PQqfCWN6tWX6rPJrIdFhHTCSxNCJ
         TLijwDcw49mByRgSb+vsPCUcoI/0gXzKjxGpDKuBaFCwC1SLXF+G7zyEG84xfYnnBQdf
         NY4ATKMPrUiZxJfx9SHif1ueU1ILlG3thGZ0HtAFmGJgStQxj09s6MCsYH+iZa6jv9iN
         p+zj1B39KryEAlgC/53YfvMv/wGjVCS+LfgSIeOiF/8aTRreNnqLyDWEn6Kml7ZvPhWB
         mdYQ==
X-Gm-Message-State: AOAM530XGdAQRyF/tsHHctu2rpMQMiqdAow8G6hRiy2DS8QL5r/xsflN
        DMuliB0eNo3WystPBPF2qLD2rU2T78yBBi4mx01P5A==
X-Google-Smtp-Source: ABdhPJwmF88B0tJamhGjuVSZRad/o61oOeqJHHQcTzifuttq6i+69/QQ51H32pbMDHHKexI+q58ZW+wGLcWCDmsq2As=
X-Received: by 2002:a92:870f:: with SMTP id m15mr1573244ild.2.1631742981900;
 Wed, 15 Sep 2021 14:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com> <20210915213034.1613552-2-dmatlack@google.com>
In-Reply-To: <20210915213034.1613552-2-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 15 Sep 2021 14:56:11 -0700
Message-ID: <CANgfPd_cAsT-Kt7CnVyEWN4g3tWhqLjGeX4iKRUxuw4i4OhUxg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: selftests: Change backing_src flag to -s in demand_paging_test
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
>
> Every other KVM selftest uses -s for the backing_src, so switch
> demand_paging_test to match.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e79c1b64977f..735c081e774e 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -416,7 +416,7 @@ static void help(char *name)
>  {
>         puts("");
>         printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
> -              "          [-b memory] [-t type] [-v vcpus] [-o]\n", name);
> +              "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
>         guest_modes_help();
>         printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
>                "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> @@ -426,7 +426,7 @@ static void help(char *name)
>         printf(" -b: specify the size of the memory region which should be\n"
>                "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>                "     Default: 1G\n");
> -       printf(" -t: The type of backing memory to use. Default: anonymous\n");
> +       printf(" -s: The type of backing memory to use. Default: anonymous\n");
>         backing_src_help();
>         printf(" -v: specify the number of vCPUs to run.\n");
>         printf(" -o: Overlap guest memory accesses instead of partitioning\n"
> @@ -446,7 +446,7 @@ int main(int argc, char *argv[])
>
>         guest_modes_append_default();
>
> -       while ((opt = getopt(argc, argv, "hm:u:d:b:t:v:o")) != -1) {
> +       while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
>                 switch (opt) {
>                 case 'm':
>                         guest_modes_cmdline(optarg);
> @@ -465,7 +465,7 @@ int main(int argc, char *argv[])
>                 case 'b':
>                         guest_percpu_mem_size = parse_size(optarg);
>                         break;
> -               case 't':
> +               case 's':
>                         p.src_type = parse_backing_src_type(optarg);
>                         break;
>                 case 'v':
> @@ -485,7 +485,7 @@ int main(int argc, char *argv[])
>
>         if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
>             !backing_src_is_shared(p.src_type)) {
> -               TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -t");
> +               TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
>         }
>
>         for_each_guest_mode(run_test, &p);
> --
> 2.33.0.309.g3052b89438-goog
>
