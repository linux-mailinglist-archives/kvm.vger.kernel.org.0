Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8E5F59EF
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 20:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJESex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 14:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJESep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 14:34:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9112AF3
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 11:34:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so2572813pjo.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vIQeQBaU7SZLqbvv/kcyYT31XcNdWZYb0ZmFC1JBQDI=;
        b=QN417gOnuMG5hGKE9xqDie4hpJhbTSu48Pv/TbcYkqI8HOiq0yZJOn7+dot/L4I1Xe
         MOuULgvqzUbl8Y9Y+r+pT8H9exv25fT6DlMtzPogc6LhSQEsg11G/dfR4Pex2fi4KXAG
         0sn12/Pc4te5Ee48bYRwTM4OYySOzowDZJARzoT0PT6UU0JRqu74Ph5xuq67DkfQIBjc
         XpKh/XQhHWgBi87bgHcAt6qUfor+NdvjwlBmoHa2nue/WZClfSMlkyiKy6A+wOaNtfmr
         PcU1fojgiWH09LZbEgkv/AevFkTzmTieMzGz1UiR5JeLT4NutGbKhzHNQ9RfPHaHIeeL
         BhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIQeQBaU7SZLqbvv/kcyYT31XcNdWZYb0ZmFC1JBQDI=;
        b=hObDb64Kndj7L/UC03mvHx1jJ6sFYlCm0DiuI0POSXTv4RbUGroi0rpHZRYhbcc5LV
         Up0oQO0Ed+mHapHY9qkRJysIuPFNq6w5oMcC6O176GpMSRcW4JfdUJtB4JTnu2GVvC5L
         TRxLXYMeC7EUphpgm2+QNlOcpcXVltUUI8WAB6Gkm2IsZR+0eS5/jiTrf5OdxltzhCJK
         SYCRIJaeW/F1wPQObF2yGHAupdbEb2QryMNffei0ECt26MVpwIkZkPqvwqwTvvd4ZDK1
         RTJOZ6lQRsTL5acYaLOs7smqxTUjt/KzFf1JyuG9koV2EBCHCfYm7JArngHy9oveBPZS
         Bz5Q==
X-Gm-Message-State: ACrzQf2a1C7GO26AUDKMGces/dadYB/swSCEPMLvT1fZpxyhxA7QuBkC
        JjEAsJVpqJmp2mVfx+zpMjLN3z/TfvA0dQ==
X-Google-Smtp-Source: AMsMyM67Sp51yormyLe0ctkrcr5XsW2A1wV1sEFwyCesdwKdkh8D/BZqZTjmQWeG5qJRcpkNoOJDrw==
X-Received: by 2002:a17:902:f650:b0:172:8ee1:7f40 with SMTP id m16-20020a170902f65000b001728ee17f40mr809154plg.101.1664994884747;
        Wed, 05 Oct 2022 11:34:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j36-20020a63fc24000000b004296719538esm53785pgi.40.2022.10.05.11.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:34:44 -0700 (PDT)
Date:   Wed, 5 Oct 2022 18:34:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang@fb.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        shankaran@fb.com, somnathc@fb.com, marcorr@google.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] x86/efi: Update unittests.cfg to
 build standalones
Message-ID: <Yz3OQN66Eufpxv+I@google.com>
References: <20220816175413.3553795-1-zxwang@fb.com>
 <20220816175413.3553795-4-zxwang@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816175413.3553795-4-zxwang@fb.com>
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

On Tue, Aug 16, 2022, Zixuan Wang wrote:
> This patch updates all EFI test cases with an 'efi' option in

Avoid "This patch".

> unittests.cfg to build them as standalone test cases.
> 
> With this patch, `make standalone` and `make install` should generate
> standalone EFI binaries, instead of reporting file not found errors.

Isn't this a fix that unrelated to standalone mode?  E.g. I see the same behavior
when running KUT in non-standalone mode due run_tests.sh trying to run tests that
aren't built for EFI.
