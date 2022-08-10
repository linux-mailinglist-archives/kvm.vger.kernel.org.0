Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626C58F4F2
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 01:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiHJXh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 19:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiHJXhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 19:37:54 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F77A175A1
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:37:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 12so15706293pga.1
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/E6nBCcLsQwwDZ/U1TZhczKKBZUxXj9p9RGy5ZKcpWc=;
        b=KIp0QySzSV1Fmfo2pNMcNcneRmnI/xACVdmspYl1Avy30ceVPUOOCAuNpVXKJdfByB
         A//wYIRlMJY2ug244yb8jP4ZhWUeu2dgcIR27wXcYmeRcv1o/IuDE6gZXEIHDSOXGYZP
         HeNYY5RMXBHu86d1AiXFVOeNPVvYDfLH4kSmCj67Y2chfXqlhXe81MyqBuoKJqFH+0Yd
         Vg6r427fQ4K+qT0+uzl3ZPKkQVtPx52sM77//aaf9XjPzvoqxGs1trxikx0G5Dsz1ue9
         zU+d/QpE6sxzDkNR8jP53K5sjdRPuot6YYSBQMlLZ3c4Rqvd3WKU06yfY/fHhKDuxE/1
         p1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/E6nBCcLsQwwDZ/U1TZhczKKBZUxXj9p9RGy5ZKcpWc=;
        b=ZTovvRUk6pWtj6ywsMEcCFE8MtHI7xsHMXSLUDSSGvY5NVL1w894EQRAaUUWlozjls
         C8hF3W8W9GF+tCBy5Oz0baj5zLlqw28QESF8SCNrA6dIFFWwYbmTMhbEfj2UGOnISTjg
         bCD3xKpdcO5KMjxCjfeV6y7WATajVNGS00PbkqoORtZPKC4Joo9Ke2IRw/r9RwzL4eSW
         YMZh48NEELefL72atGwdMYfCax3GZ8rswph5c2Vxxbj46KGLFhSTx8YBu3FMc5ALoGSm
         qrUa5dmJ9faYlLQxhM/SHzMeNmeKyfzP1N+LprNwk+WgT0J+IyMOdHrOCWSKVG4Mr1/v
         b1dA==
X-Gm-Message-State: ACgBeo0kfkIHIgSCaBJ0PVIUl24H7IZMAAxN964DgSF3dgDKw/I7keEp
        0MnEZmnAq/i0FX0vjyJLO6Dv/w==
X-Google-Smtp-Source: AA6agR5IkMWQN8IzhJxauA9aBwsBCCM83w9h4nhiouQnkIT6U7d1XjGsfkQ88Yy88S0aj5Sw/qiAqQ==
X-Received: by 2002:a63:c5:0:b0:40d:d290:24ef with SMTP id 188-20020a6300c5000000b0040dd29024efmr24608214pga.141.1660174672769;
        Wed, 10 Aug 2022 16:37:52 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id r24-20020aa79638000000b0052ad6d627a6sm2538496pfg.166.2022.08.10.16.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 16:37:51 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:37:47 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Randomize which pages are written vs
 read
Message-ID: <YvRBS5ZJ/kx92TnC@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-3-coltonlewis@google.com>
 <YvRAWKGXbPzool6j@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvRAWKGXbPzool6j@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 04:33:44PM -0700, David Matlack wrote:
> On Wed, Aug 10, 2022 at 05:58:29PM +0000, Colton Lewis wrote:
> > Randomize which pages are written vs read by using the random number
> 
> Same thing here about stating what the patch does first.

Sorry -- you do state what the patch does first here. But I think it
could just be a little more direct and specific. e.g.

  Replace the -f<fraction> option in dirty_log_perf_test.c with
  -w<percent>, to allow the user to specify the percentage of which
  pages are written.

> 
> > table for each page modulo 100. This changes how the -w argument
> > works. It is now a percentage from 0 to 100 inclusive that represents
> > what percentage of accesses are writes. It keeps the same default of
> > 100 percent writes.
