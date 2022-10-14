Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880F25FF01C
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJNORl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 10:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiJNORd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 10:17:33 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBFA1D2B61;
        Fri, 14 Oct 2022 07:17:18 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id z11-20020a05683020cb00b00661a95cf920so1908371otq.5;
        Fri, 14 Oct 2022 07:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJgQbbx8GSTxjlJ5aSREgb5VNrrd8KKlXzB6L8m9N+U=;
        b=3cRXTvr/VuU3qFtcOtr8IF0GviVlIopMG91MNoYtZHHq1vL/GIJTfdEoDxcnWyXh2I
         AZVFbmjPrlP64BC/UlTdzh4DnGbZtU34HZeAzwJORX5UPOguCaEEVjqLYaT1UAqeysa3
         fCdredyrReUjohGs5crCgbF704MuFtUz3bZVQqXsYp7fMuY1Z0prFhrjHBA7a0lmr1gt
         H9BKuJOebtbJySFbg7+HM1mH/01qN9jpB03L9cbvFJpmaGS8YYvBb5ezF8PFPsDx3bfD
         r+BcqFBkxOjXZP6bzx1W80hYoZLO+6pThwkuKZaFkklTCe4B8IE/FDWWGpBeveEhZFgV
         glgg==
X-Gm-Message-State: ACrzQf15ORcJg8ahJMPLDz8EADqQhwGJPAdgJ2PmqUewqRI3V68fx/ZV
        W0QyKw1wXoWxdeQ+YBflsg==
X-Google-Smtp-Source: AMsMyM59Imc0Bum5glqerPFxzEzBx5VO/JKDoGC25QZgv78bQSe0lQuroyOM/A7u3yzpW/yFykaDuA==
X-Received: by 2002:a9d:1d3:0:b0:661:a1a9:3727 with SMTP id e77-20020a9d01d3000000b00661a1a93727mr2551605ote.372.1665757037501;
        Fri, 14 Oct 2022 07:17:17 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v6-20020a9d69c6000000b006618586b850sm1284868oto.46.2022.10.14.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 07:17:16 -0700 (PDT)
Received: (nullmailer pid 1900473 invoked by uid 1000);
        Fri, 14 Oct 2022 14:17:17 -0000
Date:   Fri, 14 Oct 2022 09:17:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v4 1/8] dt-bindings: bus: add CDX bus device tree
 bindings
Message-ID: <20221014141717.GB1862711-robh@kernel.org>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-2-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014044049.2557085-2-nipun.gupta@amd.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 10:10:42AM +0530, Nipun Gupta wrote:
> This patch adds a devicetree binding documentation for CDX
> bus.

Please read submitting-patches.rst and what it says about commit 
messages.

> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
>  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 65 +++++++++++++++++++
>  MAINTAINERS                                   |  6 ++
>  2 files changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> new file mode 100644
> index 000000000000..984ff65b668a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> @@ -0,0 +1,65 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/bus/xlnx,cdx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: AMD CDX bus controller
> +
> +description: |
> +  CDX bus controller detects CDX devices using CDX firmware and
> +  add those to cdx bus. The CDX bus manages multiple FPGA based
> +  hardware devices, which can support network, crypto or any other
> +  specialized type of devices. These FPGA based devices can be
> +  added/modified dynamically on run-time.
> +
> +  All devices on the CDX bus will have a unique streamid (for IOMMU)
> +  and a unique device ID (for MSI) corresponding to a requestor ID
> +  (one to one associated with the device). The streamid and deviceid
> +  are used to configure SMMU and GIC-ITS respectively.
> +
> +  iommu-map property is used to define the set of stream ids
> +  corresponding to each device and the associated IOMMU.
> +
> +  The MSI writes are accompanied by sideband data (Device ID).
> +  The msi-map property is used to associate the devices with the
> +  device ID as well as the associated ITS controller.
> +
> +maintainers:
> +  - Nipun Gupta <nipun.gupta@amd.com>
> +  - Nikhil Agarwal <nikhil.agarwal@amd.com>
> +
> +properties:
> +  compatible:
> +    const: xlnx,cdxbus-controller-1.0

Where does 1.0 come from?

> +
> +  reg:
> +    maxItems: 1
> +
> +  iommu-map: true
> +
> +  msi-map: true
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
> +    soc {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        cdx: cdx@4000000 {

bus@...

> +            compatible = "xlnx,cdxbus-controller-1.0";
> +            reg = <0x00000000 0x04000000 0 0x1000>;
> +            /* define map for RIDs 250-259 */
> +            iommu-map = <250 &smmu 250 10>;
> +            /* define msi map for RIDs 250-259 */
> +            msi-map = <250 &its 250 10>;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f5ca4aefd184..5f48f11fe0c3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -935,6 +935,12 @@ S:	Supported
>  F:	drivers/crypto/ccp/
>  F:	include/linux/ccp.h
>  
> +AMD CDX BUS DRIVER
> +M:	Nipun Gupta <nipun.gupta@amd.com>
> +M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> +
>  AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
>  M:	Brijesh Singh <brijesh.singh@amd.com>
>  M:	Tom Lendacky <thomas.lendacky@amd.com>
> -- 
> 2.25.1
> 
> 
