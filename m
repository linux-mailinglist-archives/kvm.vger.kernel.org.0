Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA01645169
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 02:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLGBpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 20:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLGBpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 20:45:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4157F528AB
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 17:44:59 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g10so15678053plo.11
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 17:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G4K9ZUmYsCxxchQmMrwAUo9vu1D928UD4ZeUzjYPtuc=;
        b=CYzt+zIi/4GN/K95j9qM5oJ7nfGevpUSJjlkifnWXo6axlWb2X+FIL98KspgUsBwGC
         M/yWVA5i/wQLc8+la++A8/KSKPrQX77yYvJdPNqQeWJE3trSEFpnV43XgBOwA73wKbB9
         VpHXbNQadSM/gpiJpFyNwrtSqHYrJeGi/DbFGy5zCfK8kebSdZB0zDvFnXpP1eAjgilV
         KTAdL6fsaynhLFhBWGwCLUS/KnkUtZEel0uc1su3UxcgTaX+8YLK3pJBPow5m1R2hLks
         eqTANsKTTcSiK0IDK2LHZGFHsxsBGBDybuZifqbv2kVtJi0cCg018400dZ5I7BFaeCMp
         HKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4K9ZUmYsCxxchQmMrwAUo9vu1D928UD4ZeUzjYPtuc=;
        b=R/CXuIApV8VILn9b4MmgkC7QI61P6mX1gsapkltmqNOdz6FeVkljl5kKvHOgwR3Hgv
         /aA6Snkdg3dNZnTrqMAQjs9FNdF4khsJMWH9Ctcar5Mjb18a00KAuuSO3mzPGuY2Pdn9
         DVRx5TRHYW216+FwDY9Je7Z+uSn89kUDvQgbIeURc8tyr5wdAP5Oj0b4vKAGVt97U7CF
         I1Rj3hNSrNaEpkU/3W6+fbOIw9en8ASPG3EA1YaJyD2Hij8UjfYzh/L2WnnaAnCVGYnD
         +mntDIyQ+S5qQ6jaB5d/Ke0uMk8FH4OtM5wmSgdf3gdPcnEJfZz/GuAroz8bJNL2R6z2
         o9QQ==
X-Gm-Message-State: ANoB5pmec4eoP/mI1UdRaXIJTm03QQlmK3yOg/Y5Foo4l/UBabYjkg3/
        CjuGHmoDUYQzRq0c3XXS4rqsaA==
X-Google-Smtp-Source: AA0mqf5e9WTWkYYX8+eNr0xOX6dYc+v6GziWbMbo43+uuHJHnhy6yQMzt1z4JyZU2TFG6+rXCAWFtg==
X-Received: by 2002:a17:902:d647:b0:189:cf7a:b564 with SMTP id y7-20020a170902d64700b00189cf7ab564mr15046087plh.8.1670377498674;
        Tue, 06 Dec 2022 17:44:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h13-20020a65468d000000b00477f5ae26bbsm10421191pgr.50.2022.12.06.17.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 17:44:58 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:44:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: selftests: Fix build for memstress.[ch] rename
Message-ID: <Y4/wF19A7snZQH3I@google.com>
References: <20221206175916.250104-1-broonie@kernel.org>
 <20221207074108.42477c2d@canb.auug.org.au>
 <47b3d23b-e00e-b78f-69f4-4687f4ac607f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47b3d23b-e00e-b78f-69f4-4687f4ac607f@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Oliver

On Wed, Dec 07, 2022, Paolo Bonzini wrote:
> On 12/6/22 21:42, Stephen Rothwell wrote:
> > Thanks for that.  I have added that as a merge fix patch to the kvm-arm
> > merge.  I assume this will be fixed up when that tree is merged into
> > the kvm tree.
> 
> Yes, I'll push as soon as I get confirmation that my own resolution is
> correct.

Holler if you need/want help on getting arm's page_fault_test.c functional, I
think Oliver is already poking at it.
