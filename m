Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0127B68E5BC
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 03:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBHCCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 21:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjBHCCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 21:02:31 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E272941A
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 18:02:29 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id s24-20020a17090aa11800b00230ffd3f340so962312pjp.9
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 18:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZM7tKDUmFmAO/L3kFSvOtmA+FlKMvKEqNg4/JC7dRUs=;
        b=D5TpMUamhsbMvj+QI8F3K/Ri243aq8/Q3sPs7JdFPCd2mxf9Ayjt4Zor7sEY/6UUuh
         CpnsWz+4ezuixvSJmwifboG5R/5O2nvORJSrYb5xjmpSuGwLG8CG3fY4YGVUWLJYlfQg
         ZNgfeEg5kvG/s6EYeLXD9vXpKxg5S8HEV02gYMxMQcn0iG32WlaVH4zSXEhALJYZ/DqI
         FKHrBbAjyyFKq2B74u22MKzf4Rp4F+YDr4FF+JiAoxMCxwVZkjfO3rk6KDhf5hk3A6QO
         XIZtpOMeo8b1AyfixIHFui27LcXhieYLnrEWRUmtUPjHjRnRHr0FShPR+dyZNmOqhn5J
         H2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZM7tKDUmFmAO/L3kFSvOtmA+FlKMvKEqNg4/JC7dRUs=;
        b=ta4eTkt5QdkM6+c9YWPbLwtFkcOOSypTIqj7Hq1hipT0HzioeK8I5yQWWHsqH48J7P
         v1ZQr7LUojBX4r/16EMejah26tC5Zlm8NfK0WbAA4NUD6cRZn3M2C6IufC7rv0TnY6vq
         yOCvYfCpffcfMsaQnhg5ypSlKn71D0kSPTo2ys+YbBVoJHvFzpetCXnPoyeFz6OtkC9u
         PN/lkDPP3Oau/osN9YUMl+ROLS0+3CrWwY65HcAQoXtfyVS8ZenreEC5kWlxRDNFsX3g
         iq7OyCiqRdrtNkjT4LX/YXtqboWqFml/8i+IFdAKowlseRgWD0BpXQx9Y75HKt/XSzy0
         YSFA==
X-Gm-Message-State: AO0yUKVoTP9B4pJhVPjImg+oNS6bR3RCxL01JReJ/Y3auJIyHi3GO01G
        AuqexbCKQqPAKMQ4lqkJbMbC90Ufhcc=
X-Google-Smtp-Source: AK7set/BpLfxZjWVJsr3asXJBj2Th5ZjBuc0VMRMeqCQBz5ym9rDmC8kmzJaIwIiNgpj3hwASIpeiI9oAq4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54b:b0:192:c7f1:977b with SMTP id
 h11-20020a170902f54b00b00192c7f1977bmr1463879plf.1.1675821748956; Tue, 07 Feb
 2023 18:02:28 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:02:19 +0000
In-Reply-To: <20230202081342.856687-1-yongw.kernel@gmail.com>
Mime-Version: 1.0
References: <20230202081342.856687-1-yongw.kernel@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167582153155.456727.4672588708621236361.b4-ty@google.com>
Subject: Re: [PATCH] KVM: update code comment in struct kvm_vcpu
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        maz@kernel.org, Wang Yong <yongw.kernel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 02 Feb 2023 08:13:42 +0000, Wang Yong wrote:
> Commit c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray")
> changed kvm->vcpus array to a xarray, so update the code comment of
> kvm_vcpu->vcpu_idx accordingly.
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] KVM: update code comment in struct kvm_vcpu
      https://github.com/kvm-x86/linux/commit/5bad5d55d884

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
