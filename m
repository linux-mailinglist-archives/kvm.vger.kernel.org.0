Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F276D2DF1
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 05:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjDAD23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 23:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDAD20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 23:28:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273D4C656;
        Fri, 31 Mar 2023 20:28:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n14so7341865plc.8;
        Fri, 31 Mar 2023 20:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680319704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aOQ4eYy8N4YCSiaLMCwB/yerXMVOmw3wp9ck3pUmQA=;
        b=Ok8vzWQ0fTWrdQmBekE/vwQkYJaeU+hCLGvU18l6tpgh+LY+guFyw1PCOkt6cTIDi2
         Bi2rSAQ4ZWcSGNL5VXFZfhfY9W+UUMxFc836pBNMtI/YKiNa3lkmWiIeZkq/HOE2i6v1
         CrYVfVRFvUIKsb9OYQYZttYR9+0qI6gi6G2q3B6O6heI5B6NINqaX8Decf4bPIdmgNnw
         OaJfm9V/8H+3AActZ4CZ6pmApo3U2T1Addxc3QfoMJxKRJcGIg7WF89sAh+ZjT4HrCSn
         og13ZG7hFc8Nl0yLoQjtBu0DXS/TVzMXnQhNidB4L5HU73Pr3qRkc91hBgz7qlyfdc9C
         2WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680319704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1aOQ4eYy8N4YCSiaLMCwB/yerXMVOmw3wp9ck3pUmQA=;
        b=jmFDBpOy8Z6Mp+u440v8SSVvR+vvDcWrYFi3YgJWfZISb7JJ0wY1pOEsFiY5/VPaLh
         mUfzY5n7yY+5UGc0xJNcfNFtXwEVwi9BQmxJDzferfuHhj7c9LbSqtmxzu/DK1+SVwdp
         6J+sCwO3+ZOZtbKWlfOWcR5BTyPzKrZDq1I6GrHfenoDsWJJqWqQ1d5nroRkw2b+E2Au
         LBI2zl79kHlc3UxbUVOlsPFzcvcrEuxkh1sV46OBqt383cqKGzPtBmqPXmyTyMca/8HG
         oy6A/Ia8iG4TcWO1yQelE2Kb3Srr+Il7RdGutEk8PehQ+g0XaVdSZ8GWBuXcI5jV+7hu
         skzA==
X-Gm-Message-State: AAQBX9eVttcyHn477xSpnzX1V+5jvg3y8LjqQtrCx/mTiMkAqlHkaA/A
        2RHCRcaTB9IQZkn6NdlUKno=
X-Google-Smtp-Source: AKy350Yoi20kGNomZnY7Fh4bdxg2fFhnur0eeEf88TS9IaTsvuK0id2OfKq0eADwsFcWp5pRxAwcFg==
X-Received: by 2002:a17:902:f683:b0:1a0:7156:f8d1 with SMTP id l3-20020a170902f68300b001a07156f8d1mr37983907plg.19.1680319704568;
        Fri, 31 Mar 2023 20:28:24 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b001a1f5dc64e5sm2271330plr.177.2023.03.31.20.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:28:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id CC3F510677D; Sat,  1 Apr 2023 10:28:21 +0700 (WIB)
Date:   Sat, 1 Apr 2023 10:28:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v2 4/6] kvm: arm64: Add support for get_freqtbl
 service
Message-ID: <ZCek1YOmg99d6l9A@debian.me>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-5-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331014356.1033759-5-davidai@google.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 06:43:48PM -0700, David Dai wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 38ce33564efc..8f905456e2b4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8400,6 +8400,14 @@ after normalizing for architecture. This is useful when guests are tracking
>  workload on its vCPUs. Util hints allow the host to make more accurate
>  frequency selections and task placement for vCPU threads.
>  
> +8.42 KVM_CAP_GET_CPUFREQ_TBL
> +---------------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that the KVM supports getting the
> +frequency table of the current CPU that the vCPU thread is running on.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/Documentation/virt/kvm/arm/get_freqtbl.rst b/Documentation/virt/kvm/arm/get_freqtbl.rst
> new file mode 100644
> index 000000000000..f6832d7566e7
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/get_freqtbl.rst
> @@ -0,0 +1,23 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +get_freqtbl support for arm/arm64
> +=============================
> +
> +Allows guest to query the frequency(in KHz) table of the current CPU that
> +the vCPU thread is running on.
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_GET_CPUFREQ_TBL_FUNC_ID: 0x86000042
> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_GET_CPUFREQ_TBL_FUNC_ID
> +    ==============    ========    =====================================
> +    Function ID:      (uint32)    0x86000042
> +    Arguments:        (uint32)    index of the current CPU's frequency table
> +    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
> +                      (uint32)    Frequency table entry of requested index
> +                                  in KHz
> +                                  of current CPU(r1)
> +    Endianness:                   Must be the same endianness
> +                                  as the host.
> +    ==============    ========    =====================================

Sphinx reports htmldocs warnings:
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

8.42 KVM_CAP_GET_CPUFREQ_TBL
---------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

8.42 KVM_CAP_GET_CPUFREQ_TBL
---------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/arm/get_freqtbl.rst:4: WARNING: Title underline too short.

get_freqtbl support for arm/arm64
=============================

I have applied the fixup:

---- >8 ----
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index baf8a4c43b5839..3579c470375938 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8401,7 +8401,7 @@ workload on its vCPUs. Util hints allow the host to make more accurate
 frequency selections and task placement for vCPU threads.
 
 8.42 KVM_CAP_GET_CPUFREQ_TBL
----------------------------
+----------------------------
 
 :Architectures: arm64
 
diff --git a/Documentation/virt/kvm/arm/get_freqtbl.rst b/Documentation/virt/kvm/arm/get_freqtbl.rst
index f6832d7566e7e5..215bf0f653e461 100644
--- a/Documentation/virt/kvm/arm/get_freqtbl.rst
+++ b/Documentation/virt/kvm/arm/get_freqtbl.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 get_freqtbl support for arm/arm64
-=============================
+=================================
 
 Allows guest to query the frequency(in KHz) table of the current CPU that
 the vCPU thread is running on.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
