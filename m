Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0056965925C
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 23:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiL2WFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiL2WFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 17:05:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463B663E7
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 14:05:49 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n12so7665079pjp.1
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 14:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rz1IgC1dsBFMMq4a2Q6YVtfZCv7R8DZEvtSW5dezElo=;
        b=gCXD/2KA3j6mGqSP+LbcRLeATOfrTYkl7OGDG389+dBDkUDa7AsJLEytlhcx6vi5jT
         BvJ/A93cRoudfLzmC1pHgwfih9y4JfbeceDA8Wat677e6YUkcx+OGFJYOFX1M4Jqkd7Q
         6LcGFhjSGH8a0OMBM5Xs9IRLiw9hbQatgTb1rm03A1Zo0FEgHsP6Q1jjQc0bRBuS7FRj
         dxATvU2xnHAjCz5E2+lStJdZ5n+i+NZoI4YtAd/FnhNvkU2NhDvK1bVNNJcUgj9moo83
         7hY3vgtE19nn5RxIv8UOpSZp7FKR1x/W37a91glEsBqGtxpab55w6U4RyTEmjGU9fxm7
         AEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rz1IgC1dsBFMMq4a2Q6YVtfZCv7R8DZEvtSW5dezElo=;
        b=QFnvfaTdWUyWYwRSFRjf88cPY24xopH6tAEUtOE2mk179RjAAN1L3+SkZzCRHuoHEf
         rN4xX/cI3J/mY0DAB1hSI+qV1gChwCiCNPlae4Oy6cKfucpZX2fKZvathbPkWEUzAvDX
         3X0o0fgP9eCxWb7jnpOlKLAaK+5XHZO2TeNQZX7fhkNnLKKzbYY1vDKy+RbMMzjT3iyy
         aODay2J174MoFj0ziYsDHT3ive0wNMAmqlnMPuVbLm4HsJbw/162ZRWrKlpeGSOtWSV/
         005XehwRgTHebi7L6u+banw/rPIPEAwiSynLVnO2YsKl4q9zGVN/Yz7DWk7uEwQGRiZv
         ePFg==
X-Gm-Message-State: AFqh2koThdK8MzAIaALVhCRYDtp7Pi2lctoeO+nqsdp+VQ7T5EBvTPNv
        o9WLOETz4WCz0/DuHu2sqYWnKw==
X-Google-Smtp-Source: AMrXdXvab4deuwAhXAsLv5yUzZsJff5RNOBIpINV0O6+91V2MjY0mGJ8WIRNTcBgS6crnHA79WqGlg==
X-Received: by 2002:a05:6a20:4655:b0:aa:23f9:7314 with SMTP id eb21-20020a056a20465500b000aa23f97314mr30991003pzb.46.1672351548667;
        Thu, 29 Dec 2022 14:05:48 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903121000b0018725c2fc46sm13344585plh.303.2022.12.29.14.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 14:05:48 -0800 (PST)
Date:   Thu, 29 Dec 2022 14:05:44 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 4/9] KVM: Add module param to make page tables NUMA
 aware
Message-ID: <Y64POFmcq0lPf9gO@google.com>
References: <20221222023457.1764-1-vipinsh@google.com>
 <20221222023457.1764-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222023457.1764-5-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:34:52PM -0800, Vipin Sharma wrote:
> Add a numa_aware_page_table module param to make page tables NUMA aware.

Generally it's not good practice to introduce dead code. So I would
request merging this with the next patch.
