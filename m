Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188876D20A6
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjCaMnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 08:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjCaMm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 08:42:58 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5137A2061E;
        Fri, 31 Mar 2023 05:42:30 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-17786581fe1so22990281fac.10;
        Fri, 31 Mar 2023 05:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680266536;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=beHNZoTWpfe1Iychh8E+2Pd1ABXoxogRlM+B8js6fxY=;
        b=2Hog1KsjnveK0cub86R0g1RzCfUL7KrMdStzkO+WlQK3dFYImmAzLtXxb09m4NKEGm
         2SZw9kCiVRtxGqn0bWqOC3JpotMTlBGo4Ne95wrCc4W6rai6J2+wRbLma5An7zRmUZM1
         4YYUC47iWwUMJ3vSRzP8Zf3zhZjzN2tfepxzKVj8iTRicOn4HIu3wFXhYJj/rqUO0R13
         Qdtip0XPslqjMr6H9e/17oKxYQI9QsNDq/WB6DYHtHl7Q34+MfUak/jxVjTWZ3MmnTIJ
         BCVlyOQAehT1Y4IfI0Z0dFlzjqqr/Qub+bXhdKi56wuDwyNdAeLhi0jYPHX4ds0hDkeb
         85cA==
X-Gm-Message-State: AAQBX9erdpW1Q1ep6LHquv+dVazteZ/3wl6YnQPP8sgCFC2V7ExZB9Ac
        f2YRq+R5u1I4n1qXWm1jqw==
X-Google-Smtp-Source: AKy350aZVWt7V5ZjS97pTxzJSN9yyHjuZdEBpdJxg6kf08veWsSig9HeD3mfdM5vIOgkoKYCiH1xbw==
X-Received: by 2002:a05:6870:8a0d:b0:17a:ce6b:72c with SMTP id p13-20020a0568708a0d00b0017ace6b072cmr15564322oaq.51.1680266535933;
        Fri, 31 Mar 2023 05:42:15 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id kw17-20020a056870ac1100b001802d3e181fsm902270oab.14.2023.03.31.05.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:42:15 -0700 (PDT)
Received: (nullmailer pid 690279 invoked by uid 1000);
        Fri, 31 Mar 2023 12:42:14 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     David Dai <davidai@google.com>
Cc:     linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        linux-pm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-kernel@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Valentin Schneider <vschneid@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        devicetree@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Will Deacon <will@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20230331014356.1033759-6-davidai@google.com>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-6-davidai@google.com>
Message-Id: <168026628573.685196.6713450502150551916.robh@kernel.org>
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for
 virtual kvm cpufreq
Date:   Fri, 31 Mar 2023 07:42:14 -0500
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, 30 Mar 2023 18:43:49 -0700, David Dai wrote:
> Add devicetree bindings for a virtual kvm cpufreq driver.
> 
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: David Dai <davidai@google.com>
> ---
>  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.example.dts:18.9-10 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:419: Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1512: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230331014356.1033759-6-davidai@google.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

