Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C999E6184C3
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 17:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiKCQey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiKCQeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 12:34:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6281DF0A
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 09:32:52 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id io19so2423477plb.8
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 09:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zp0hKQFYpMXsqPQeTtpAgSfuyEGdLZbv3V3PmSt1YDA=;
        b=g8deluGwWU806iGn0uz4Aow6rnAOD6QEbUTAp9U0saUWgI8EYf1uilvLKnwIVdmv1E
         LOxdBOHfaEEEuc9RzD2e8bMJ2ZmDvuYChBHboAglNkik03dTe0CdVlGr2Q0D0wytzpL9
         VVzt+Dex9XZ3aTjZhVzgw0fxXxyIWqrUH7gUHueu+8VphzzHT3cV2RKVnXnm2MUs4xi7
         FgBEz5oDtUkpeHgoGRZKGRKPtstXf4GIx+tSLw2UCga+L8/GX3jz225AG+babe57KJD7
         7WqZa4iMyr7TxxdNdRPWL6FRYOO4HhQ4eswfSrdABoNIEoBaacmeFCO7l4xy1WFMNze1
         I8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zp0hKQFYpMXsqPQeTtpAgSfuyEGdLZbv3V3PmSt1YDA=;
        b=vDjulLkOA79S+VQLA0Q0EpzbOZqx1aRGvSvkQAYKZhEy8egyxKYjZCuM7nhtSq4pY4
         S0TQKnPPhngJFjGdqSewWzochFQgZ59DT7NS3xdY++tY1ENJ+ZddS4Zx/nW53hFowmR7
         7K+QdfifYlHFfbrf/0g0Sa4otpSjKWO1jHj+wv/6TVO6CMkRsq2H0gkA0/OR8STviw+n
         z4RI8bY9s+8M3eOh2K+F4QC/ZzoLNmXIzaMJ42LG6bSXGdlBN4kRHVq2fd5LO9CymMNh
         GqktUQpa2gLXtFOXiXB1bUowthrEdRbvk/AMRyoW4vXTf12lFlIcUrtnSJQmdj+09bo2
         14Zw==
X-Gm-Message-State: ACrzQf2kli7dqxzrv7OnMQbMIX/ZC7ECY8bvfki3LRvKVlATmg/FhvGx
        wjyw162z18YFaB4Xw+VErbvQzw==
X-Google-Smtp-Source: AMsMyM6HbFYkSw5tIo2J+V1x0BIk1CWbdUFjwqQaTyI1DWl3NUZ7Sw6/1GdoMtTIAKxHV62ETlsZlw==
X-Received: by 2002:a17:90a:8b93:b0:20a:bd84:5182 with SMTP id z19-20020a17090a8b9300b0020abd845182mr51114581pjn.161.1667493171499;
        Thu, 03 Nov 2022 09:32:51 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090ac48400b002130c269b6fsm218282pjt.1.2022.11.03.09.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:32:51 -0700 (PDT)
Date:   Thu, 3 Nov 2022 09:32:47 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 4/4] KVM: selftests: randomize page access order
Message-ID: <Y2PtL4dWISkLRqnI@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-5-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-5-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 04:00:07PM +0000, Colton Lewis wrote:
> Create the ability to randomize page access order with the -a
> argument. This includes the possibility that the same pages may be hit
> multiple times during an iteration or not at all.
> 
> Population has random access as false to ensure all pages will be
> touched by population and avoid page faults in late dirty memory that
> would pollute the test results.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
