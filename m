Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C32549D21
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbiFMTOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348906AbiFMTNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:13:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47F3645ACD;
        Mon, 13 Jun 2022 10:34:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A65923A;
        Mon, 13 Jun 2022 10:34:37 -0700 (PDT)
Received: from bogus (unknown [10.57.4.242])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 450673F792;
        Mon, 13 Jun 2022 10:34:35 -0700 (PDT)
Date:   Mon, 13 Jun 2022 18:33:48 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc:     mst@redhat.com, jasowang@redhat.com, cristian.marussi@arm.com,
        Sudeep Holla <sudeep.holla@arm.com>, quic_sramana@quicinc.com,
        vincent.guittot@linaro.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] dt-bindings: arm: Add document for SCMI Virtio backend
 device
Message-ID: <20220613173348.t4ibrtzzs5pe6nii@bogus>
References: <20220609071956.5183-1-quic_neeraju@quicinc.com>
 <20220609071956.5183-2-quic_neeraju@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609071956.5183-2-quic_neeraju@quicinc.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022 at 12:49:54PM +0530, Neeraj Upadhyay wrote:
> Document the properties for ARM SCMI Virtio backend device
> node.
> 
> Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
> ---
>  .../firmware/arm,scmi-vio-backend.yaml        | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
> 
> diff --git a/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml b/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
> new file mode 100644
> index 000000000000..c95d4e093a3c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
> @@ -0,0 +1,85 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/firmware/arm,scmi-vio-backend.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: System Control and Management Interface (SCMI) Virtio backend bindings
> +
> +maintainers:
> +  - Neeraj Upadhyay <quic_neeraju@quicinc.com>
> +
> +description: |
> +  This binding defines the interface for configuring the ARM SCMI Virtio
> +  backend using device tree.
> +
> +properties:
> +  $nodename:
> +    const: scmi-vio-backend
> +
> +  compatible:
> +    const: arm,scmi-vio-backend
> +

One only change between this and the existing DT binding is the compatible.
I don't see any explanation here as why this deserves to be separate binding
document. What can't you just add the compatible to the existing one if there
is no other change. If not, please provide details and examples on how it
differs.

-- 
Regards,
Sudeep
