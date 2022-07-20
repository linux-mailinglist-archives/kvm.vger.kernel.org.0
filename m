Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5840B57AB18
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiGTAoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiGTAox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:44:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08CA5A476
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:44:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u5so901256wrm.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iaSAAUJfYxw6BjeslG6VAuKaY6a92Xkr7dZVWPuh750=;
        b=RHC+v+pu3Ta5e3zYef84dSW7oulAbaFp+xxY5Yunj1110Ek9kqp6QUwm/DoJEZ/Gju
         h4G5UufhQ8ue88YbXRxVtHTQxA+AnE1TKxDS/mqFOg/ihB8G5srW4qD2v07N0Si2gF6n
         Rb6iSMa8PV3qnwsiA/D8715hO1dEVx7MlTAqWhDGalq6a3kNCZaZ3wsMcNsQPb72Lrmq
         7aJTOr18Z8a2Yyz2aUdPwlPSq/xqGl5jZjJItTkKKK2rCiEZ8l8RHbkWay9OIUGrVGK/
         OdjWjYMqqIIUfKmO2kHd2w47IfJzK4GBrEtCR0A0WUvj2UgceIN+7coc+hMy6vhfKOA+
         e36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iaSAAUJfYxw6BjeslG6VAuKaY6a92Xkr7dZVWPuh750=;
        b=mjsrKj+5NuGluOcbUOuZcxPSwZ30wdV2P7ciiWXrmqYwDNbRPxs/fk9qzSh517nik7
         11FCuCK8QPKs1IRACX+D4jTgyHrGQEvVHfoydgAIqNPO+SzdDxmEP6JZ5QFroAVtxsG2
         w5ueCrySs/LWc9gVLg7xG3ly/vmnpnigS6HGkcm4sz6/ecrz5vo11ieUGgfEfd4J7Z23
         o6IQ8RjhXJnnjg8HKFhY891xbZEkvotPG1Cfo/596E/AHEuy2YwLofzU0GkY+x1mu9GT
         zAcq7gd00wQFyTZowgiG4IZgLUQEnRbj1cOicWcR/s4jnsJDZVCcf+gHydbf0OTyrqLW
         vO6A==
X-Gm-Message-State: AJIora+2zQWdCnjfJf2pJnePHmzmyq1+8ulib9rBZMJpA0DogGp9my34
        an/zfQIYxWHYy+q7OJrJvZik4UFzdyArJX1imX9h/Q==
X-Google-Smtp-Source: AGRyM1v41Uj12cw+3NPigdpWSLrSP3ZpGSY6Fi0rdYqI4UGGzdIbJw/NuGVSrJOHMxHbWhf0UDhItru8ELdbJfWH6Ds=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr1633868wrw.375.1658277890418; Tue, 19
 Jul 2022 17:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-20-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-20-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:44:38 -0700
Message-ID: <CAP-5=fWd8Mns84=XF+Osy24PKL71-E2Gy1RP4_d+V=0A4CfROw@mail.gmail.com>
Subject: Re: [PATCH 19/35] perf script python: intel-pt-events: Add
 machine_pid and vcpu
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Add machine_pid and vcpu to the intel-pt-events.py script.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/scripts/python/intel-pt-events.py | 32 +++++++++++++++++---
>  1 file changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/scripts/python/intel-pt-events.py b/tools/perf/scripts/python/intel-pt-events.py
> index 9b7746b89381..6be7fd8fd615 100644
> --- a/tools/perf/scripts/python/intel-pt-events.py
> +++ b/tools/perf/scripts/python/intel-pt-events.py
> @@ -197,7 +197,12 @@ def common_start_str(comm, sample):
>         cpu = sample["cpu"]
>         pid = sample["pid"]
>         tid = sample["tid"]
> -       return "%16s %5u/%-5u [%03u] %9u.%09u  " % (comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
> +       if "machine_pid" in sample:
> +               machine_pid = sample["machine_pid"]
> +               vcpu = sample["vcpu"]
> +               return "VM:%5d VCPU:%03d %16s %5u/%-5u [%03u] %9u.%09u  " % (machine_pid, vcpu, comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
> +       else:
> +               return "%16s %5u/%-5u [%03u] %9u.%09u  " % (comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
>
>  def print_common_start(comm, sample, name):
>         flags_disp = get_optional_null(sample, "flags_disp")
> @@ -379,9 +384,19 @@ def process_event(param_dict):
>                 sys.exit(1)
>
>  def auxtrace_error(typ, code, cpu, pid, tid, ip, ts, msg, cpumode, *x):
> +       if len(x) >= 2 and x[0]:
> +               machine_pid = x[0]
> +               vcpu = x[1]
> +       else:
> +               machine_pid = 0
> +               vcpu = -1
>         try:
> -               print("%16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
> -                       ("Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
> +               if machine_pid:
> +                       print("VM:%5d VCPU:%03d %16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
> +                               (machine_pid, vcpu, "Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
> +               else:
> +                       print("%16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
> +                               ("Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
>         except broken_pipe_exception:
>                 # Stop python printing broken pipe errors and traceback
>                 sys.stdout = open(os.devnull, 'w')
> @@ -396,14 +411,21 @@ def context_switch(ts, cpu, pid, tid, np_pid, np_tid, machine_pid, out, out_pree
>                 preempt_str = "preempt"
>         else:
>                 preempt_str = ""
> +       if len(x) >= 2 and x[0]:
> +               machine_pid = x[0]
> +               vcpu = x[1]
> +       else:
> +               vcpu = None;
>         if machine_pid == -1:
>                 machine_str = ""
> -       else:
> +       elif vcpu is None:
>                 machine_str = "machine PID %d" % machine_pid
> +       else:
> +               machine_str = "machine PID %d VCPU %d" % (machine_pid, vcpu)
>         switch_str = "%16s %5d/%-5d [%03u] %9u.%09u %5d/%-5d %s %s" % \
>                 (out_str, pid, tid, cpu, ts / 1000000000, ts %1000000000, np_pid, np_tid, machine_str, preempt_str)
>         if glb_args.all_switch_events:
> -               print(switch_str);
> +               print(switch_str)
>         else:
>                 global glb_switch_str
>                 glb_switch_str[cpu] = switch_str
> --
> 2.25.1
>
