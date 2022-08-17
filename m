Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02859758C
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 20:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbiHQSRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 14:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiHQSRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 14:17:18 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FAB8E0D5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:17:17 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id x9so14301256ljj.13
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0Mv5jQ8hRqokFuTzuLGQ2+4HMm4gXf4KWrwhyD1wz0c=;
        b=o8RUy/jSIMwh4sAkv2mej0jQFwK5rKnhv/VJzW+EIi6nn/iKf8ijgOH1HwiIYsCnPj
         qiD0yjs8OOsiqMjg7Tz+Fzjcqfev/69am+6UAE1nmdDRcRQkUB5t1gbVmOfh7t6MOaFM
         xCAic4M5ANXNdecfH74Y2ngj5M6FPihUWCPn621rIfuQbz444WN+JyQ7I4uSyeG52uNn
         ms1WC+zXAxDU8uF5RaSxeTp4hUyBKlvzQZoqCNh6Gw2rJbpv6peVHa9iUuuRQtTAKJ1+
         KZKbErsHDGAANOpEGaMwGM2wM4+36GUmd5z2LVFfx0GR2B+KfEdAXnpV+hYDSifqCVHG
         aoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0Mv5jQ8hRqokFuTzuLGQ2+4HMm4gXf4KWrwhyD1wz0c=;
        b=jbgFscZ3WPrycrhAe8b0p5Ie/GuFLz4m0JAEKH6ed4NLV3IlLVAJRcCbsoux76nshi
         0rPDMkal7+Md9uNbsWPLdCGPOYzJHug1vF/vRfUdO/Byv93tb8wXqPBlXP+7XMbs718P
         CDGwx/H+0C2zzbDjfUkpDepXkNq+hrWP5+s8ANTgejA7APRffpYNwtLjr9hy90oMas05
         8hPjtH/yzmOfg+ieB+D7UyOSD+1YgzaufQPXtTC6xgQ3ZkjHC4uJFHO6nMgklWhEQgPC
         v9z9tjtmBNljvEB15jf7es0DMkSorFgRKAAyaZs1iyDc/eijDUm+Kkodoj4/1upLBJRs
         gCkg==
X-Gm-Message-State: ACgBeo0bwHIHibVqJkKD1/7cqUpH0FuBqwC0eJXDiCSSKX6+BQpR1Svl
        1LcAY9kgIASF/cG78kmJWtpD5VM41KcTo58tFZ8tgQ==
X-Google-Smtp-Source: AA6agR5KIO8bHZ8lbPtaNNKPJwuv1GQFMl4w/Fu5FDzI/yobfzH9duSxiXQQ+ANJhp08iVUWx5o9GKseHPMLTTC8agE=
X-Received: by 2002:a2e:8606:0:b0:25e:51c1:4cfe with SMTP id
 a6-20020a2e8606000000b0025e51c14cfemr8677689lji.33.1660760235102; Wed, 17 Aug
 2022 11:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220817152956.4056410-1-vipinsh@google.com> <Yv0kRhSjSqz0i0lG@google.com>
In-Reply-To: <Yv0kRhSjSqz0i0lG@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 17 Aug 2022 11:16:37 -0700
Message-ID: <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Aug 17, 2022 at 10:25 AM Sean Christopherson <seanjc@google.com> wrote:
>
> > +static int parse_num(const char *num_str)
> > +{
> > +     int num;
> > +     char *end_ptr;
> > +
> > +     errno = 0;
> > +     num = (int)strtol(num_str, &end_ptr, 10);
> > +     TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> > +                 "Invalid number string.\n");
> > +     TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
>
> Is the paranoia truly necessary?  What happens if parse_cpu_list() simply uses
> atoi() and is passed garbage?

On error atoi() returns 0, which is also a valid logical cpu number.
We need error checking here to make sure that the user really wants
cpu 0 and it was not a mistake in typing.
I was thinking of using parse_num API for other places as well instead
of atoi() in dirty_log_perf_test.

> > +
> > +     cpu = strtok(cpu_list, delim);
> > +     while (cpu) {
> > +             cpu_num = parse_num(cpu);
> > +             TEST_ASSERT(cpu_num >= 0, "Invalid cpu number: %d\n", cpu_num);
> > +             vcpu_to_lcpu_map[i++] = cpu_num;
> > +             cpu = strtok(NULL, delim);
> > +     }
> > +
> > +     free(cpu_list);
>
> The tokenization and parsing is nearly identical between parse_cpu_list() and
> assign_dirty_log_perf_test_cpu().  The code can be made into a common helper by
> passing in the destination, e.g.
>
> static int parse_cpu_list(const char *arg, cpu_set_t *cpuset, int *vcpu_map)
> {
>         const char delim[] = ",";
>         char *cpustr, *cpu_list;
>         int i = 0, cpu;
>
>         TEST_ASSERT(!!cpuset ^ !!vcpu_map);
>
>         cpu_list = strdup(arg);
>         TEST_ASSERT(cpu_list, "Low memory\n");
>
>         cpustr = strtok(cpu_list, delim);
>         while (cpustr) {
>                 cpu = atoi(cpustr);
>                 TEST_ASSERT(cpu >= 0, "Invalid cpu number: %d\n", cpu);
>                 if (vcpu_map)
>                         vcpu_to_lcpu_map[i++] = cpu_num;
>                 else
>                         CPU_SET(cpu_num, cpuset);
>                 cpu = strtok(NULL, delim);
>         }
>
>         free(cpu_list);
>
>         return i;
> }
>

Yeah, it was either my almost duplicate functions or have the one
function do two things via if-else.  I am not happy with both
approaches.

I think I will pass an integer array which this parsing function will
fill up and return an int denoting how many elements were filled. The
caller then can use the array as they wish, to copy it in
vcpu_to_lcpu_map or cpuset.

> > @@ -383,6 +450,26 @@ static void help(char *name)
> >       backing_src_help("-s");
> >       printf(" -x: Split the memory region into this number of memslots.\n"
> >              "     (default: 1)\n");
> > +     printf(" -c: Comma separated values of the logical CPUs which will run\n"
> > +            "     the vCPUs. Number of values should be equal to the number\n"
> > +            "     of vCPUs.\n\n"
> > +            "     Example: ./dirty_log_perf_test -v 3 -c 22,43,1\n"
> > +            "     This means that the vcpu 0 will run on the logical cpu 22,\n"
> > +            "     vcpu 1 on the logical cpu 43 and vcpu 2 on the logical cpu 1.\n"
> > +            "     (default: No cpu mapping)\n\n");
> > +     printf(" -d: Comma separated values of the logical CPUs on which\n"
> > +            "     dirty_log_perf_test will run. Without -c option, all of\n"
> > +            "     the vcpus and main process will run on the cpus provided here.\n"
> > +            "     This option also accepts a single cpu. (default: No cpu mapping)\n\n"
> > +            "     Example 1: ./dirty_log_perf_test -v 3 -c 22,43,1 -d 101\n"
> > +            "     Main application thread will run on logical cpu 101 and\n"
> > +            "     vcpus will run on the logical cpus 22, 43 and 1\n\n"
> > +            "     Example 2: ./dirty_log_perf_test -v 3 -d 101\n"
> > +            "     Main application thread and vcpus will run on the logical\n"
> > +            "     cpu 101\n\n"
> > +            "     Example 3: ./dirty_log_perf_test -v 3 -d 101,23,53\n"
> > +            "     Main application thread and vcpus will run on logical cpus\n"
> > +            "     101, 23 and 53.\n");
> >       puts("");
> >       exit(0);
> >  }
>
> > @@ -455,6 +550,13 @@ int main(int argc, char *argv[])
> >               }
> >       }
> >
>
> I wonder if we should make -c and -d mutually exclusive.  Tweak -c to include the
> application thread, i.e. TEST_ASSERT(nr_lcpus == nr_vcpus+1) and require 1:1 pinning
> for all tasks.  E.g. allowing "-c ..., -d 0,1,22" seems unnecessary.
>

One downside I can think of will be if we add some worker threads
which are not vcpus then all of those threads will end up running on a
single cpu unless we edit this parsing logic again.

Current implementation gives vcpus special treatment via -c and for
the whole application via -d. This gives good separation of concerns
via flags.
