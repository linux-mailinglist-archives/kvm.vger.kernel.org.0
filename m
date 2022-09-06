Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41FA5AF304
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 19:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiIFRrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 13:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFRqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 13:46:55 -0400
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C506E2DC;
        Tue,  6 Sep 2022 10:46:47 -0700 (PDT)
Received: by mail-oo1-f43.google.com with SMTP id n11-20020a4aa7cb000000b0044b3583d373so2054317oom.2;
        Tue, 06 Sep 2022 10:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uiew6NbFXf44Z/IbImQfdvjEizUYy8izei1Fpy5Vg/0=;
        b=f/12ZMIwCsEBCbNRwz1Fakq+guxaXrntYNpzGu3FRDTBoIyqGbwNC7+FYBfmwnZgB+
         20vpS7Fis2pV5N6kfbliarW/fZTDyUPgagRIAUZW1HbTVyS/k78kmfwlvxNXYG9h0Y0d
         gwEqNEMTJdmS2QWmlP8StQHS99yJuXC7oc6J3MlJkIuVWH6wwFtYqA+laCt74Xi37LqS
         MJsgVz/vKbb/Ys6Pzbije0CjIUaMlFuJelehYivGUI1ML7p+MeHdvmvcowF7toyeXKxS
         qw9oPd2pWx0kdKvYjOuAsvJd2a+OABFvp4j6P9IBvFK+HpZfG1GWXX8cg6t1s0hDprXh
         kurg==
X-Gm-Message-State: ACgBeo33n0oODw677HDSyTzyeVaXJcXZguGpYWeGt1vBKeNVG9Y6NpeQ
        xiA9rYj5pXgqc4PZokR0mg==
X-Google-Smtp-Source: AA6agR5bj+5NJ3XNxjU5HfDtqr6HRIQ7mmileSv2rYw50aB+2a5kFqg1A4SznszpVYY8bgrNu8YWNw==
X-Received: by 2002:a4a:e1ad:0:b0:448:b28c:5fe3 with SMTP id 13-20020a4ae1ad000000b00448b28c5fe3mr18839646ooy.21.1662486405944;
        Tue, 06 Sep 2022 10:46:45 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p4-20020a0568301d4400b006339b36127dsm6158688oth.3.2022.09.06.10.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 10:46:45 -0700 (PDT)
Received: (nullmailer pid 780026 invoked by uid 1000);
        Tue, 06 Sep 2022 17:46:42 -0000
From:   Rob Herring <robh@kernel.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     gregkh@linuxfoundation.org, eric.auger@redhat.com,
        devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org,
        jeffrey.l.hugo@gmail.com, maz@kernel.org, puneet.gupta@amd.com,
        Michael.Srba@seznam.cz, cohuck@redhat.com, will@kernel.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org, joro@8bytes.org,
        okaya@kernel.org, alex.williamson@redhat.com,
        song.bao.hua@hisilicon.com, jgg@nvidia.com, mani@kernel.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rafael@kernel.org, f.fainelli@gmail.com, jgg@ziepe.ca,
        kvm@vger.kernel.org, nikhil.agarwal@amd.com,
        harpreet.anand@amd.com, yishaih@nvidia.com,
        linux-arm-kernel@lists.infradead.org, git@amd.com,
        saravanak@google.com, aleksandar.radovanovic@amd.com,
        michal.simek@amd.com, ndesaulniers@google.com
In-Reply-To: <20220906134801.4079497-2-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220906134801.4079497-1-nipun.gupta@amd.com> <20220906134801.4079497-2-nipun.gupta@amd.com>
Subject: Re: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree bindings
Date:   Tue, 06 Sep 2022 12:46:42 -0500
Message-Id: <1662486402.681939.780022.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 06 Sep 2022 19:17:55 +0530, Nipun Gupta wrote:
> This patch adds a devicetree binding documentation for CDX
> bus.
> 
> CDX bus controller dynamically detects CDX bus and the
> devices on these bus using CDX firmware.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
>  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 75 +++++++++++++++++++
>  MAINTAINERS                                   |  6 ++
>  2 files changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:18.23-21.11: Warning (unit_address_vs_reg): /example-0/smmu@ec000000: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:23.22-30.11: Warning (unit_address_vs_reg): /example-0/gic@e2000000: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:26.35-29.15: Warning (unit_address_vs_reg): /example-0/gic@e2000000/gic-its@e2040000: node has a unit name, but no reg or ranges property
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: smmu@ec000000: $nodename:0: 'smmu@ec000000' does not match '^iommu@[0-9a-f]*'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: smmu@ec000000: 'reg' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: $nodename:0: 'gic@e2000000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: '#interrupt-cells' is a dependency of 'interrupt-controller'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: 'reg' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: gic-its@e2040000: False schema does not allow {'compatible': ['arm,gic-v3-its'], 'msi-controller': True, 'phandle': [[1]]}
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: gic-its@e2040000: '#msi-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: gic-its@e2040000: 'reg' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: gic@e2000000: 'oneOf' conditional failed, one must be fixed:
	'interrupts' is a required property
	'interrupts-extended' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb: cdx@4000000: reg: [[0, 67108864], [0, 4096]] is too long
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

