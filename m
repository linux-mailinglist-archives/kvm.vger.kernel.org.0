Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39D6EE15D
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 13:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjDYLxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 07:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjDYLxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 07:53:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40813F85
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 04:53:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f195b164c4so27098345e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 04:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682423603; x=1685015603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mm/NNC5OznPx25xic2u8+3GloMnc6ORalv+vKEtj7X4=;
        b=iB7rZKVxXFRYnNY4YLzghPV9s3ZeGNPVSNCL8cdFai9oZ/7AmrN46iXqoknIazcvFR
         WyJMVVCeOuGRDYRtMMDPKftnsrhpzuXEhv8x7IHrXC6Ia5mFsCZY2V4/8unf/mq+yGWH
         A94BgPkrfCjSV2WYNryqASwINRnDrNZXl55vEhfjMwrRCJtpZ4kaFR8FN1GnhMcZqNoA
         vcO0zDs6i30tlNYyE/0ffpEkX1uN+NNi5KLQTp5GOCzOnQUfhHE58pfnFkLwVETnPwX/
         Wx6PMb2yR2GIK+aqXKDeUBWaRyZ7TX7cPHpJ3dasoiddxiolkKjA4m5wHxI0OMfmZZHh
         WJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682423603; x=1685015603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mm/NNC5OznPx25xic2u8+3GloMnc6ORalv+vKEtj7X4=;
        b=HtInuwzBJUYlUpr5iW56bHPup6jyAB6N2HHnaEP7/zogPsyEBi2gDbBFJivJJiWvgZ
         CgXGmXZZ7oyxXh1D7daoM03GD2N/AEm3rKOVOi5Ip5Mmv0XpGAMbYlR6IKs2VqbOIn0H
         Xf13tlG0iK8VpwpPKRFRfpuXcKh8zvDo0r0MuTA9ML09NnhKPm47/vEloYeGRd65bKk1
         yfv3bjVfSHoNrn22yhybeT8si6QSna5LJqznDXIgFGBaZ9alw0Hl+k7Fe+ZUTOhKMTaj
         v00qBYyV3xfIPKYCuyvTNPLPCG3T6Rsni4mWikWBI5jiJbgCzlil1izt7u2v0jSCmkq9
         OCOw==
X-Gm-Message-State: AAQBX9coQfP8kFmfDaTI4nNAMKQrhtG9eOgkglxE2/d0LE+IL+DFy/Ru
        pj3+a1QjCwgXDs+DKdaTovVSBg==
X-Google-Smtp-Source: AKy350a+MF8epCD781DyDJxjC7n4hD/6/nzLX/7fvhE01eTeHpBNPFoMpDYfnp58+USYFxnaNSATQg==
X-Received: by 2002:a05:6000:1819:b0:300:2067:f5d8 with SMTP id m25-20020a056000181900b003002067f5d8mr12526180wrh.65.1682423603641;
        Tue, 25 Apr 2023 04:53:23 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id s13-20020adfeb0d000000b002fb6a79dea0sm13094201wrn.7.2023.04.25.04.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 04:53:23 -0700 (PDT)
Date:   Tue, 25 Apr 2023 12:53:23 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 04/16] virtio/vhost: Factor notify_vq_gsi()
Message-ID: <20230425115323.GC976713@myrica>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
 <20230419132119.124457-5-jean-philippe@linaro.org>
 <20230420155249.50e95126@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420155249.50e95126@donnerap.cambridge.arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 03:52:49PM +0100, Andre Przywara wrote:
> >  struct net_dev {
> > @@ -647,11 +644,7 @@ static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
> >  	struct net_dev *ndev = dev;
> >  	struct net_dev_queue *queue = &ndev->queues[vq];
> >  
> > -	if (!is_ctrl_vq(ndev, vq) && queue->gsi) {
> 
> So this first condition here seems to be lost in the transformation. Is
> or was that never needed?

Hm, good question. The theory is that it was never needed, because the
control virtqueue is owned by kvmtool and not vhost, so we never set
queue->gsi for the control queue, in which case virtio_vhost_reset_vring()
is a nop. However in net, notify_vq_gsi() doesn't actually check which vq
this is, and does set queue->gsi for the control queue. It's a bug but
hasn't caused trouble so far because the Linux guest doesn't setup MSIs
for the control queue (it polls the queue until the command completes).
I'll add a check to notify_vq_gsi().

> Apart from that the changes look fine.
> 

Thanks for reviewing this!

Jean

