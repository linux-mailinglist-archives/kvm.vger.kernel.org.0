Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C970F814
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 15:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjEXNxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 09:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbjEXNxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 09:53:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70293A9
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 06:53:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3090d3e9c92so855716f8f.2
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 06:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684936413; x=1687528413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tzz+pmKwgetR+IeiD//D2VjvYfDbSY7K421R2l4B78o=;
        b=Eh7oitBh88BJk9lsl8m1Hh4k1sp0//pI2yETrcDbFzkldLpf7EjCwYOrGPPTT0h4u3
         Tubk8JumDZ7EIJE3dX0f7aQgCccVVXvjXPIAse1shE94DORUwuzn8wPgq/J0NUxXmkf2
         DlKjDuhznIzCrE+P2ckZ30Ou7L/TvOPv5eoCP1KTx0I9Oe1ejTan9nHmgWmJaBOm8All
         31gQK/kDzWp6T/dE7J6fqlxBs7qGxy6d4vNfplyxUoPuiZf7OaIaC5TtHCubEaJ9Wnc+
         nXFPquzNHZJyrebVVeYO8xgq22Jf46uw92L0D4bxCKYRqv4pRFVBj/2MYw299Ad9L7Ik
         xevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684936413; x=1687528413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzz+pmKwgetR+IeiD//D2VjvYfDbSY7K421R2l4B78o=;
        b=gmQnJNpxER5rnTWIpb2/+1LxN3qxRPj10q0UwdDlT9hdgYuFE2vwpAThSqvhphGdxu
         1DTRO5wYjYiOjqA+RhZ6PrWVlZhAoR7Gxmxa+sUs/BQuxyISPug6JJosyDhXLLoP5odp
         +SsnXOSS7A7UAxoNkOtK0iDk3oUlMAW0EcZpGDtLsRBsTAqSIHp6yDMutaxxT0EzxoDV
         92acQHYBbjOWrkksqC86o6REBCyD3YICFlQ/lzixSDY2cveEY/G5ClRhq6Jh0tPpmsTj
         Gt5iakzm15JuPewTrPNJFb7yDEO75ateSGlQZ+bIQTXJXkHVngs3WfEaLEEPHqq76BI9
         +dyQ==
X-Gm-Message-State: AC+VfDxvHAQm65J9mNyeXZUBz3hBXIACIF5uu00sHOEdTC8xylTrILBY
        nkjc69eyM9YRIeSSwb/fh1VplA==
X-Google-Smtp-Source: ACHHUZ4VEpeg/DLyfYWYrblNo1rHn+ICt/PBm1kN8F08k5vJC4LfPQ0DP8+ZN/xgDwMLef5h7e4vMQ==
X-Received: by 2002:a5d:6ace:0:b0:306:3945:65e9 with SMTP id u14-20020a5d6ace000000b00306394565e9mr13816769wrw.3.1684936412835;
        Wed, 24 May 2023 06:53:32 -0700 (PDT)
Received: from myrica (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id n11-20020a7bcbcb000000b003f427cba193sm2382732wmi.41.2023.05.24.06.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 06:53:29 -0700 (PDT)
Date:   Wed, 24 May 2023 14:53:31 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 00/16] Fix vhost-net, scsi and vsock
Message-ID: <20230524135331.GB48723@myrica>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
 <20230523104607.GC7414@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523104607.GC7414@willie-the-truck>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Tue, May 23, 2023 at 11:46:08AM +0100, Will Deacon wrote:
> Hi Jean-Philippe,
> 
> On Wed, Apr 19, 2023 at 02:21:04PM +0100, Jean-Philippe Brucker wrote:
> > Kvmtool supports the three kernel vhost devices, but since they are not
> > trivial to test, that support has not followed kvmtool core changes over
> > time and is now severely broken. Restore vhost support to its former glory.
> > 
> > Patches 1-4 introduce virtio/vhost.c to gather common operations, and
> > patches 5-11 finish fixing the vhost devices.
> > 
> > Patch 12 adds documentation about testing all virtio devices, so that
> > vhost support can be kept up to date more easily in the future. 
> > 
> > Patches 13-16 add support for vhost when the device does not use MSIs
> > (virtio-mmio or virtio-pci without a MSI-capable irqchip). That's only
> > nice to have, but is easy enough to implement.
> > 
> > Patch 17 documents and fixes a possible issue which will appear when
> > enabling CCA or pKVM.
> 
> Do you plan to respin this with the outstanding comments addressed?

Yes, I'll try to resend it within a week or two

Thanks,
Jean
