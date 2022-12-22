Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9564565434A
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 15:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiLVOng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 09:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiLVOne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 09:43:34 -0500
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C58DF3F;
        Thu, 22 Dec 2022 06:43:34 -0800 (PST)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1322d768ba7so2713701fac.5;
        Thu, 22 Dec 2022 06:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFFd7m/bU9463PFLncKR6cUl2BapFHel3PaN5ohq5f0=;
        b=mZ9TMNuvZ3ro9y76mK98ILg01hMZXH5wllYwixUjGZEiPFVlvXKZ3+xQkbekMXHnml
         BN9keBU0d7O6m3ZLWT8rnBBcjmYXs4ppL3/M/fdFTQvZPIglwMsQ5GFknHXp44Cx13kj
         EqLic31iqzMZDUPcAHVvyk8hsnnhUcuQ8rUncbYGsVUa/H6KvB0Hdnj1MVZuYgsU2YOc
         2KUds6QUt2PKBDXZs4XUUwGB6rv+/kvLoajXD6zrGgJjWEV+KR9A1K5wQfiRbTQNu6na
         NoXrvFGDJon1xTmTwivD3Wb2ojLydfRgKDFTpV0dxkUUKT9VAcgKYvMVEAewLj/F1pZO
         ciTA==
X-Gm-Message-State: AFqh2kq7CAsuvFSFBQUoH6+qebxhlkGULCiN+cxoNBnXZ4ZOI5hdz6aI
        gkN0h6O489cROWOn6dVyC7z7b6z/xA==
X-Google-Smtp-Source: AMrXdXtQBOve/jNx+L/Q8K8KWjdlB5ZI36GhyWwtlKDL2DTz835Npj1AXWHHeMYIsiF/DhTdYe3CWQ==
X-Received: by 2002:a05:6870:814:b0:144:54b3:750 with SMTP id fw20-20020a056870081400b0014454b30750mr2756769oab.12.1671720213458;
        Thu, 22 Dec 2022 06:43:33 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z44-20020a056870c22c00b001375188dae9sm147865oae.16.2022.12.22.06.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:43:33 -0800 (PST)
Received: (nullmailer pid 1211543 invoked by uid 1000);
        Thu, 22 Dec 2022 14:43:32 -0000
Date:   Thu, 22 Dec 2022 08:43:32 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>, kvm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] of: overlay: Fix trivial typo
Message-ID: <167172020686.1211425.17489090373509742153.robh@kernel.org>
References: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
 <20221220-permited-v1-3-52ea9857fa61@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220-permited-v1-3-52ea9857fa61@chromium.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Tue, 20 Dec 2022 23:20:32 +0100, Ricardo Ribalda wrote:
> Permitted is spelled with two t.
> 
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/of/overlay.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
