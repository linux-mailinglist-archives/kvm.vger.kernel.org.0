Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD8D598123
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239617AbiHRJyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiHRJyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 05:54:31 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D39F1BB
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 02:54:27 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q16so631109ljp.7
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 02:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=pXQ90ApN4EsEH9C/Yy70+EtmgpkmYE8dXAbZvg4RS0s=;
        b=zhmvIkxOa0hVGga4d/DM+ZLt86lGWaPMX9AVQvDvDh0NGkh6cpRV+Dq7Ol6pr/p9oY
         xqya+/Fmbyol/ohUSvKUkOsIpabMaJM6BV0BrqVTkasX1WDpmJpB4ptWckwHr3YW42es
         qbRRzW/7fWcQG6PqXseEIiybx/kw02+vbXmcBRM6QjCCpFEybiKM0qkCQJY+OqTHFhNT
         Vv5lEstUeU4ms58k1AYDEVgFImJ3YJsmIzSeYRbbo3TT32J/BPN1s/PsxeNziNWHiaMi
         ZNIu2QSRcAKWxO49n6kQ2ZDpRrSw6gTzbm2+gdQkC6lBPhQ2FN2eOxL4jDS3nwsKiv4D
         FvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=pXQ90ApN4EsEH9C/Yy70+EtmgpkmYE8dXAbZvg4RS0s=;
        b=P9zLlao/FowM3a6iu7Smqg6iPTkfPGzP61JQO+5r0bAdwRKS27AADzoIpAZevcwzwh
         v6AVBgYf6jJYbuYmJpFlQexCdyo0E1qNaBaGYAgtxsh2KuNocNFZ+x/FvztiNDYnYE9z
         ZF0a0c0i/q8bz7AeU8khYG1JHgfhOOtRvBDbSEALA1DRL4XSBXZutyy2cQFMFwBsmbvV
         pcu8MvbdUam3Y3fGRhkeda7K6dToV7mxKemUE9LbSi6L0SsAjru16lrTnNTRBMU61Gfj
         AgCdsG+ydUUjmFstCh7yvvHwiLBoK12b9xA6jUQl3n30YlfNdNO3ZZD2oHuWq1oLYrJ2
         tNpw==
X-Gm-Message-State: ACgBeo1WzEg6OksOiyw26ZdGBI2kL/Eiu5J7j/GYyZVVPWKbAC6Tt0uE
        PeUM6lj4vVSHQkXui2FwpTnpLA==
X-Google-Smtp-Source: AA6agR6ZbcoCJtdddNSemEv9Xvgy5ZNrc4euVYcJckphXGdDZ36YVJHB6DIj47UKq1STClnTgNsehg==
X-Received: by 2002:a2e:864a:0:b0:25e:4e27:56d4 with SMTP id i10-20020a2e864a000000b0025e4e2756d4mr653005ljj.252.1660816466149;
        Thu, 18 Aug 2022 02:54:26 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id be24-20020a05651c171800b0025dfe45c031sm163246ljb.27.2022.08.18.02.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 02:54:25 -0700 (PDT)
Message-ID: <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
Date:   Thu, 18 Aug 2022 12:54:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Content-Language: en-US
To:     Nipun Gupta <nipun.gupta@amd.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org
Cc:     okaya@kernel.org, harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, git@amd.com
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-2-nipun.gupta@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220817150542.483291-2-nipun.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/2022 18:05, Nipun Gupta wrote:
> This patch adds a devicetree binding documentation for CDX
> controller.
> 
Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

> CDX bus controller dynamically detects CDX bus and the
> devices on these bus using CDX firmware.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>

Use subject perfixes matching the subsystem (git log --oneline -- ...).

> ---
>  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 108 ++++++++++++++++++
>  MAINTAINERS                                   |   6 +
>  2 files changed, 114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> new file mode 100644
> index 000000000000..4247a1cff3c1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> @@ -0,0 +1,108 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/misc/xlnx,cdx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx CDX bus controller
> +
> +description: |
> +  CDX bus controller for Xilinx devices is implemented to

You need to describe what is this CDX bus. Google says nothing...

> +  dynamically detect CDX bus and devices on these bus using the
> +  firmware. The CDX bus manages multiple FPGA based hardware
> +  devices, which can support network, crypto or any other specialized
> +  type of device. These FPGA based devices can be added/modified
> +  dynamically on run-time.
> +
> +  All devices on the CDX bus will have a unique streamid (for IOMMU)
> +  and a unique device ID (for MSI) corresponding to a requestor ID
> +  (one to one associated with the device). The streamid and deviceid
> +  are used to configure SMMU and GIC-ITS respectively.
> +
> +  iommu-map property is used to define the set of stream ids
> +  corresponding to each device and the associated IOMMU.
> +
> +  For generic IOMMU bindings, see:
> +  Documentation/devicetree/bindings/iommu/iommu.txt.

Drop sentence.

> +
> +  For arm-smmu binding, see:
> +  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.

Drop sentence.

> +
> +  The MSI writes are accompanied by sideband data (Device ID).
> +  The msi-map property is used to associate the devices with the
> +  device ID as well as the associated ITS controller.
> +
> +  For generic MSI bindings, see:
> +  Documentation/devicetree/bindings/interrupt-controller/msi.txt.

Drop sentence.

> +
> +  For GICv3 and GIC ITS bindings, see:
> +  Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml.

Drop sentence.

> +
> +maintainers:
> +  - Nipun Gupta <nipun.gupta@amd.com>
> +  - Nikhil Agarwal <nikhil.agarwal@amd.com>
> +
> +properties:
> +  compatible:
> +    const: "xlnx,cdxbus-controller-1.0"

No quotes.

> +
> +  reg:
> +    description: |
> +      specifies the CDX firmware region shared memory accessible by the
> +      ARM cores.

You need to describe the items instead (e.g. maxItems:1).

> +
> +  iommu-map:
> +    description: |
> +      Maps device Requestor ID to a stream ID and associated IOMMU. The
> +      property is an arbitrary number of tuples of
> +      (rid-base,iommu,streamid-base,length).
> +
> +      Any Requestor ID i in the interval [rid-base, rid-base + length) is
> +      associated with the listed IOMMU, with the iommu-specifier
> +      (i - streamid-base + streamid-base).

You need type and constraints.

> +
> +  msi-map:
> +    description:
> +      Maps an Requestor ID to a GIC ITS and associated msi-specifier
> +      data (device ID). The property is an arbitrary number of tuples of
> +      (rid-base,gic-its,deviceid-base,length).
> +
> +      Any Requestor ID in the interval [rid-base, rid-base + length) is
> +      associated with the listed GIC ITS, with the msi-specifier
> +      (i - rid-base + deviceid-base).

You need type and constraints.


> +
> +required:
> +  - compatible
> +  - reg
> +  - iommu-map
> +  - msi-map
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    smmu@ec000000 {
> +        compatible = "arm,smmu-v3";
> +        #iommu-cells = <1>;
> +        ...

???

> +
> +    gic@e2000000 {
> +        compatible = "arm,gic-v3";
> +        interrupt-controller;
> +        ...
> +        its: gic-its@e2040000 {
> +            compatible = "arm,gic-v3-its";
> +            msi-controller;
> +            ...
> +        }
> +    };
> +
> +    cdxbus: cdxbus@@4000000 {

Node names should be generic, so "cdx"

https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

Drop the label.


> +        compatible = "xlnx,cdxbus-controller-1.0";
> +        reg = <0x00000000 0x04000000 0 0x1000>;
> +        /* define map for RIDs 250-259 */
> +        iommu-map = <250 &smmu 250 10>;
> +        /* define msi map for RIDs 250-259 */
> +        msi-map = <250 &its 250 10>;
> +    };
Best regards,
Krzysztof
