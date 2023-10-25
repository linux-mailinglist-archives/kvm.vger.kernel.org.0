Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D7B7D6F1E
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjJYO0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbjJYO0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:26:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E20B1B1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:26:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da03390793fso2107864276.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698243998; x=1698848798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1WI5INH1Stly4YCUjb5S4g/deUr+thfE6my+iNPVjR4=;
        b=kLtGESOaullrmk5lovnpaCkmNG9z7j+QY+ZR+TpFLaR3vH/ZdXCd/ObcFeDB3TWqRk
         l/cEXAsGg5RSyCaWikN65t4vlPi/sstNBfaLFW/uufvjXxsbTI1dMCofpodBwCFjgZFV
         YidtkEA30VgDurVVw1OVzS4qtnUiUjSIIz+z7LoKlNpZvMFMAlNtyZdbv8ywEwxNZpKX
         Q4KuW/T/8ePl+o/VCSo3xCuMIwGsy6qDZuLcolQTWgh9N88hqVqUIcLDjAZfo9iGmqqZ
         KVFuv0zHZMbaeiZkrniN+Kkx1Kgp7KW0/4XKrfrepQeBkhi51FbcerVLBQQVVBzFewQL
         hbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243998; x=1698848798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WI5INH1Stly4YCUjb5S4g/deUr+thfE6my+iNPVjR4=;
        b=ZwVhQZv6Y7MruH0F8QT2j7tmXiUHJqv/6JKmCtN4/BJ9ZKrj+jaRC8WDQlc1Dlx+Mx
         NpFdgGKr9Ki+XGc2bQUF4xTgZgpr+/0IKHi/HKbTrumkKbcReBH/pis2bI4rQT4qHQJT
         nchMA3RqAQzPw53HgTbwX8xz5Us4ExTgoTkKPVSXvwOVXKbxPk4zIpO7BHybLP4VEX94
         p3GEuyG9wz//BGCyI6FoPFbH8/JtrplY89X1BKbcFER2gm9iN5WbAsm75MmX+tEBAx00
         Ztx8h5IzuU7zaMBGyQ3zu9XJaRaMJoaSw8y9RpQ59NnoE/JPOI4rM0yy2234ZStVNR1C
         dzmQ==
X-Gm-Message-State: AOJu0YyIYtPcauQHelJjoiiaPraDMh0aiqlw927bnY7WI6WpCJF6KE8n
        Wb7RhxskHQka2T0JE/GCPDHcj8IzHNU=
X-Google-Smtp-Source: AGHT+IGz2sE4kXgcUz98HZRxm94YuZHpfdpx/LqJCgjXNzxCLit/k7flAOyfSmBn1O8jAJnCT2kjJ+Of2Gg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7749:0:b0:da0:94e8:84d4 with SMTP id
 s70-20020a257749000000b00da094e884d4mr6228ybc.12.1698243998349; Wed, 25 Oct
 2023 07:26:38 -0700 (PDT)
Date:   Wed, 25 Oct 2023 14:26:36 +0000
In-Reply-To: <53d7caba-8b00-42ab-849a-d8c8d94aea37@gmail.com>
Mime-Version: 1.0
References: <20231007064019.17472-1-likexu@tencent.com> <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
 <53d7caba-8b00-42ab-849a-d8c8d94aea37@gmail.com>
Message-ID: <ZTklnN2I3gYjGxVv@google.com>
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void function'
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023, Like Xu wrote:
> Emm, did we miss this little fix ?

No, I have it earmarked, it's just not a priority because it doesn't truly fix
anything.  Though I suppose it probably makes to apply it for 6.8, waiting one
more day to send PULL requests to Paolo isn't a problem.
