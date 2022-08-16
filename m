Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89236595F9D
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiHPPu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiHPPuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:50:40 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD698053E
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:46:43 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id l5so8413881qtv.4
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=POhayPKlQA9tcwGuPczeKWnXvo1Czxt3hU8vSTwzwSU=;
        b=k0J1Hhq3INPQMG4hforKE812V6L71+dgLVdEODPkknTXvMZrytQ5yRLwrmUGsCso5D
         CKFnPw5N7e4TnVksKOu+Dmrzi2QDCKmYwc+eFqzJJkG1+MwMwzD9MEo9Kfy0uBy2G/ak
         74V7Bz36q/RZ88arYH1EDEkEyFwIPdje7WH9Uy16clFrozrJOVVABHVYXyrAHomnCL8v
         R5LvXRlaAeVz9mKuffsOVRgOqrnU1Q5TvDZQfIIlfCfTyPKt7Y3c3ZLn9zdNKyNybjyl
         NOyntPzLRxKs1gNTt7XoHm0EGTGQdQ3oyEkoTmUgRrIxWauzg3WHnMnkUYnFg7K4gk8f
         VO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=POhayPKlQA9tcwGuPczeKWnXvo1Czxt3hU8vSTwzwSU=;
        b=wJqhUwi1EhHrMVR7mDwbAOJLrdiQKudHvypOePlb+xjwznOI+G/XInoWm/FSRqxCJc
         paRbjC6iAogxw81PkV5+WV65TJApHQ6/8dTUMwEXCE5UpbO5oTqdvykA0ZF4Ekwi8X1k
         IKk4+Ln7pZuoZGXdRnV05k2g0ikVpKiI0LjWfEPoPwfiZlcxsFIqy20TgyY2v2hk3aAc
         lTH0oEgzn8/vqgzxFhh/STRP2HeEtStEMZwSZa5yVFVZ+4DN1OvGCuR4UZrccrhWvr+d
         S7nmrpmOK9RcKjs/ybfhERa/EpI3Wjisgv4leWLYaACzpMVVlJrS2x3PXPml01EzLj/8
         h2vw==
X-Gm-Message-State: ACgBeo0niv8MjquRNwfjmL1jHI39sdzBWlePTMpEdrvYycRm7YzggNRM
        w3RgUvJtiaCW0wEBjzvf+dp7pA==
X-Google-Smtp-Source: AA6agR5vZ7rQsyzJxFoWb8T1mCPALz84GEoH2NP8WNeHcyKi7aflsGiHrbaTJTCnyisxMZromE/mWw==
X-Received: by 2002:a05:622a:38e:b0:343:677a:abd7 with SMTP id j14-20020a05622a038e00b00343677aabd7mr18309870qtx.268.1660664802956;
        Tue, 16 Aug 2022 08:46:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id dm14-20020a05620a1d4e00b006bad20a6cfesm10890585qkb.102.2022.08.16.08.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:46:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oNym6-002p7G-MP;
        Tue, 16 Aug 2022 12:46:38 -0300
Date:   Tue, 16 Aug 2022 12:46:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] vfio/fsl-mc: Fix a typo in a message
Message-ID: <Yvu73uzpxA6K/+rq@ziepe.ca>
References: <3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 05:24:46PM +0200, Christophe JAILLET wrote:
> L and S are swapped in the message.
> s/VFIO_FLS_MC/VFIO_FSL_MC/
> 
> Also use WARN instead of WARN_ON+dev_warn because WARN can already print
> the message.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
