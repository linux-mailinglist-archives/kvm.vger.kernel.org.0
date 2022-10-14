Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95345FE946
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJNHOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJNHOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:14:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D45A2C5;
        Fri, 14 Oct 2022 00:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0217561A21;
        Fri, 14 Oct 2022 07:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B46C433D6;
        Fri, 14 Oct 2022 07:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665731675;
        bh=XIkzcs9sFTLKy2SGQR+FJTYqZbqKMl+CzpRoO0bQ9Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+A8gMjdJuFM5PwXc4qk1fUqpOqtIugtD1kt1TTLaBrcI+J5wF3m/QGdf9LQEYVCX
         bjcedEscToBui6t/AaPjWgnD6lkzLU4SXPHe2veQIkBqcPk/2SKobB8AG5B2SK+pvm
         tnZUGb8LuoyWfSZ9twee2iifM5xZF0ov9EoFZa0Y=
Date:   Fri, 14 Oct 2022 09:15:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
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
Subject: Re: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Message-ID: <Y0kMiMVQ7gj7scoY@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-3-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014044049.2557085-3-nipun.gupta@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 10:10:43AM +0530, Nipun Gupta wrote:
> CDX bus supports the scanning and probing of FPGA based
> devices. These devices are registered as CDX devices.
> 
> The bus driver sets up the basic infrastructure and triggers
> the cdx controller to scan the cdx devices once registered.
> 
> CDX bus uses ops registered by the CDX controller to scan,
> reset and write MSI message on the CDX devices.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>

Why is this all still "RFC"?  RFC means to me, "I don't know what to do
here, so here's a half-baked proposal".  When you are on v4 of a RFC,
that is a huge sign that this all isn't working at all.  Also, where is
the questions that you still have that you need help with here?

Also, I don't review RFC changes normally as that means the submitter
doesn't think they are good enough to be submitted, so why would I
review them when I have hundreds of other changes that submitters do
think are good enough?

Can you just submit these "for real" if they work properly for you and
you have tested them and you would be happy if they are accepted.

thanks,

greg k-h
