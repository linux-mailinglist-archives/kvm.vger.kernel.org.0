Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2341574B5E5
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 19:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjGGRgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 13:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjGGRgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 13:36:00 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA761FE5
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 10:35:59 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-47e4d002e0bso858452e0c.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751358; x=1691343358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k32j4a8QbpnW53Pf3SJsom1ArrFeeJaQ6sfNzVvKozI=;
        b=gOUxjYtKmemM9rSwFVqBwsrvvDaXtY1CAJ62wNFZkyKxytUkU5E67ToCQH1kDCKbI1
         2bNvtE80A9p/dNMBuAnWS6+sZBue0RagX+fKzRWJThtxugrQudn8QAnkxR/aNTmOWP1s
         30ptnlfJrnMg8TItc5drxmcfveEOljNn1gjN//82zCg5ZQctghFiGlRrE0P6RQjZO+Rb
         6bksyYCw2Pm8qUbvjsdg8GnjxfYSJUIZ3UG1kXe8lN1FgoRR8ZkaSe9xqUMPuvxpPwIA
         Q5Vrrj1zKdNIIRbrtTSGtJE4ok8m2OIDPIaecMppwwdIuGKi5reQ2T8R29y+ehT6n7W1
         Wg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751359; x=1691343359;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k32j4a8QbpnW53Pf3SJsom1ArrFeeJaQ6sfNzVvKozI=;
        b=VueXWUxDH3gF2fqFuS6vkXOAatutNJlAzOx81CDqy+hq3W+lEIwQ/tqNmFkVGik7g7
         CVazlakpdSE13GsSJZjFAVb4YVdpLHRPcRt9E/aYRsGK9NFiYydWQ03OyS3fJ+ImiQdP
         EVf8GeBzWnwUTg/WWGx0TGhKTCZoX7jFBwxKr0xZGKA6EORwoSURCmXem7QSITrWGl9W
         UdwKTvnBbF6einJE+2JaLqBXZfwavzGXOPc0lxRuugdA6wbgNp8wGJgzYyFrKi4uPMtw
         mgrHqM7tUpw6jx6jFTVB9e8/Es0fpzCvij7IYo8A6GgYzuM+YkzKpiJSBQhQ1tJSNPcC
         hI1w==
X-Gm-Message-State: ABy/qLaFz5+Ad0EyTZ6L+//HvcdpZQm1DKU4pv61Ob7g1eV3IXSx8SMV
        gMBQHfi+oq9aOpNIUVXLgydUATEGq28Jbr5SQMRTVg==
X-Google-Smtp-Source: APBJJlFA7kuw3wNahT9JybNFRocuZb5lWG68SxruTTjYJuWfiHBf1ZbEk1fvMQGWHBQdFDX1LvSvsG1Lm5AeiXVoh8k=
X-Received: by 2002:a1f:5cc2:0:b0:471:8bf8:3d59 with SMTP id
 q185-20020a1f5cc2000000b004718bf83d59mr4448306vkb.8.1688751358687; Fri, 07
 Jul 2023 10:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-7-amoorthy@google.com>
 <ZIoTWOmM2a3iVDAi@google.com>
In-Reply-To: <ZIoTWOmM2a3iVDAi@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 7 Jul 2023 10:35:23 -0700
Message-ID: <CAF7b7mqO1tJ1PwQ3NzN19mSFmVQ+wy1HB8XVLJdFzdGahyrPDQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Done, and same question/comment as the "write" patch (though I'm sure
we'll just keep all the discussion there henceforth)
