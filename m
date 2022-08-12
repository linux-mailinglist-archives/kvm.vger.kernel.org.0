Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9327B5913C0
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbiHLQMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiHLQMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:12:22 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E1FA50DA
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:11:42 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id c5so700471ilh.3
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uG2BbQ/2oop4t4NNibciOOBEbcBwYCCbk1PT1h020FU=;
        b=edKzOzRxI663Gh5MvdtZw4oaD9L5kB71EJL1DR3+2hAqgphh3g6sC5HWsGNweF/Brk
         BuUUNWT5pE2Q054S9RnKgoneDa8DC+2/08i0xYF3BauJD2dQI9/L5UxplU9Rox3vkIyX
         rEY7BCjYw8kNguJc6GOE3qX6ueTGc4G6AMH4AbYKdmhsoVTv47XyGJqvJ28GtXjj/Ckp
         Bscnk1OTRGouOd6t7cMN2pnNUQLEB/A1bvM6gfmpKE+fdLXUfXcf92DlU2m01MW40t8E
         hzBlKccYDG0iTsSOG/cGI4Ynfo89yK0Ih06sCbaWeh5DSQpx4aOHG3QhakVyKG7xGXWU
         PbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uG2BbQ/2oop4t4NNibciOOBEbcBwYCCbk1PT1h020FU=;
        b=lfvTXueu33/Kz7F6RyFaurNpTMRx/tRYnRygWr08qoJb/ujNkwnfKd6wnDQHHbnraN
         /7Q72xTXvsk5ZvQX/t35OIe/iceVCRb2uaAPW+8T47KlkRbyXe4mQPnBU5KxS5DZufgp
         iecpq2jaRtHG3hOP5sIMhDYOCYA5qT931xfcIVYGs8Zxa0tOdor9WVQUSiHb7CM+2FCg
         8dGzmpzyIBb/0f3Rsoe42DwRsloNzQUjVEi+pXSaoEz200SIdW9ml4ly0f75uwfWkr+I
         mZrPNSbSVrmyNOOqxTrLXLy2GiKLLt4/urFHLWqqksDCLIyvVU3XyxMHm6W7gcefq1WD
         JzlA==
X-Gm-Message-State: ACgBeo1/D0eZO0vLtPrn2sq0FJzefNi/I7JKZxQ5G6f+uz7jaguDoSzy
        dCt9FrAK+3Liua3/eZMziWl4gg==
X-Google-Smtp-Source: AA6agR7mHOYEVQsen81xSgTnaPRyNJKPOWqIZOt6EGYXSFH/hzed25u1LU/+enbaDRirxByfDGtFig==
X-Received: by 2002:a05:6e02:12e5:b0:2de:d1f2:793c with SMTP id l5-20020a056e0212e500b002ded1f2793cmr2183317iln.14.1660320700446;
        Fri, 12 Aug 2022 09:11:40 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id n44-20020a02716c000000b0034358669334sm44193jaf.87.2022.08.12.09.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 09:11:39 -0700 (PDT)
Date:   Fri, 12 Aug 2022 16:11:36 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Randomize which pages are written vs
 read
Message-ID: <YvZ7uDcnpLzW8r1/@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-3-coltonlewis@google.com>
 <YvRAWKGXbPzool6j@google.com>
 <YvRBS5ZJ/kx92TnC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvRBS5ZJ/kx92TnC@google.com>
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

On Wed, Aug 10, 2022 at 04:37:47PM -0700, David Matlack wrote:
> On Wed, Aug 10, 2022 at 04:33:44PM -0700, David Matlack wrote:
> > On Wed, Aug 10, 2022 at 05:58:29PM +0000, Colton Lewis wrote:
> > > Randomize which pages are written vs read by using the random number
> > 
> > Same thing here about stating what the patch does first.
> 
> Sorry -- you do state what the patch does first here. But I think it
> could just be a little more direct and specific. e.g.
> 
>   Replace the -f<fraction> option in dirty_log_perf_test.c with
>   -w<percent>, to allow the user to specify the percentage of which
>   pages are written.
> 
> > 
> > > table for each page modulo 100. This changes how the -w argument
> > > works. It is now a percentage from 0 to 100 inclusive that represents
> > > what percentage of accesses are writes. It keeps the same default of
> > > 100 percent writes.

Will do.
