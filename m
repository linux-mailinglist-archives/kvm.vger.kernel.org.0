Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7194F7BAF15
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 01:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjJEXIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 19:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjJEXGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 19:06:37 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB89123
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 16:03:54 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-57bb0f5d00aso912103eaf.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696547034; x=1697151834; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GOzZRCKO7Xll/sARcXB2ndjpn0IClscKumkt8MaJ4qo=;
        b=egErG5Do5dZP9kB4mBQi6HRV+gZatN6aS4hpHkaojvtpvgFtGcrgreQUYyyqgfztey
         DB0Sr9N5aYWTPt5yWDX1PA+ZtSpNq56fvIajiX+o4XdZtB1ay142uuADW8Ftu/5Dahz0
         0JYqmfsUgEodGNkrfbz/BLB878RBpH9W3ijtjHF2j8ZaGEU7daApTxqBNZqvfaTwxg6E
         fxqxv8XNfuJq3fNMecQQ4FM3CRXz0c/oz1+RoXU0QrKRulLkH5c1CDIb0Tnd0+O+sXcH
         NZuVoG6U13rURRFNUtSd0S/6zeATHMyXnR1n97deSMYQng40WjbOjbO4X6H2mMqVCzTX
         C0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696547034; x=1697151834;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOzZRCKO7Xll/sARcXB2ndjpn0IClscKumkt8MaJ4qo=;
        b=eME26V+QIZcDGyl/n5cCWZkaPZ/wuLqV8AykO4ISY1yoCFG1iBAuWKJP3kbDnaUWEa
         mDXT3yJQRzvUy7WrjF7hqIs1XOB3hcDI02B5s2GOW1K7cHwzLnG3cgdRS8SBIfn50y54
         8+NAK1AHLj08duf3sYP7MWqJ1lAjGDNZspeO3gHUyGD/7I9wZs0eHfNiftk13vDKi0rB
         uZhVrm2kZqfyi/GIg48YMITZNPUsZFIAtJpN5/n4IDlH40a2p6wxhsK1JqFZnb0OhTZH
         WUxPMB1/JCYXd+bCdZlgymK1sKh+jZVdDTyeCuzva4sQbV07btSyYWuYgfw/C7AZJfgu
         Q/GA==
X-Gm-Message-State: AOJu0Yzz5ieGhx8l2L1bXuGLoAXve0jXfjkPyk2Qa1HsnAygkdAiSTH4
        8UDE0WkNo+SJtmbiHAqpzzINSkYBeTOgpqyIHxQbTw==
X-Google-Smtp-Source: AGHT+IHBBIc3dqlKzgt4G6XEK3q9QVBUjB3hE4QN7O80/SFjgK5pI7utYm61Zz8NTxMYdUxk8iLPJy1zn4a/nJ8Zpxo=
X-Received: by 2002:a4a:3447:0:b0:571:1fad:ebdb with SMTP id
 n7-20020a4a3447000000b005711fadebdbmr7016005oof.3.1696547033774; Thu, 05 Oct
 2023 16:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-6-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-6-amoorthy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 5 Oct 2023 16:03:17 -0700
Message-ID: <CAF7b7mrC_gX1OQhk3cEr3M3rMQU2v-hwF_jpXORjnZ2acsNyOA@mail.gmail.com>
Subject: Re: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dropping as per
https://lore.kernel.org/kvm/ZR88w9W62qsZDro-@google.com/. Take that,
kernel test robot!
