Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5195AF8AB
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIFXxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiIFXx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:53:28 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EBD98A40
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 16:53:17 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id 14-20020a9d048e000000b0063936a5db40so7289530otm.23
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 16:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=1U1xnd8X+CegYA1dQ4+qC8F2xFIOm1ilUZdquyiy5yU=;
        b=EMznTkpTJ1tYkIU9PgB5H2R0SPNBuUKX0+V3sDMyLAFsuCtbQlGWZgoZxDhXs+mk8Y
         EP2bCwFn2MZBFYXNuiXEO+Ma+0wOmknFCKOG/zQdkZUPVgmJG0i/c7xXXGRROMjCDFCq
         rJRjlBpkriuQwAqsbb3a/EVXoTSuPuodLLCC7A4SV39vWJyticYG51AQ/C7vGguABkSa
         Gvpj4gaqVwSXzG2DzlRh3zb6J75E5tGFlR/exOdkE3PXjGKydxMhD1F1/f5PAi9PI85j
         UOrdsins53at0CsziBQ5UDS+yEiaPfykTkKwgh6opFuDnX1uLAh3DM4A4LdLawpnQeWx
         fQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1U1xnd8X+CegYA1dQ4+qC8F2xFIOm1ilUZdquyiy5yU=;
        b=i/dbz9Iw++VQuCooinpgE03D9DZ9DxMhDMesdzPiKwY9eJjEPuXMv5TBeiIDb0NhMn
         ZxlWFMn3NHYHpkN+MZ7mkX3jOt+5wOzCfo19Thrf+1DeATFpTpxMjEM6QQacMuHjw9nN
         RDGkSFXOLw15lRddmkmHzGKlHWuQprFzD1A519toToQOmXNZ2G8hVtaQ5OmfMHjRMzLC
         LWu1ZpMPQDaicrefP9rSNs+aicnjd0lb/oeJ3eSv+8gS7Hto2cpSnUJjvHd26UbOV7xP
         KiaFEwlNA+8ykivJdnPAhb0tVLBVZnzfgVmpsWquciklKnkeI63e6T07JY3keDlhugvx
         XxyQ==
X-Gm-Message-State: ACgBeo3gGrI+Dbh6yEWSTD8Tra1bJtL344J9nbKWFSBZYTrVybR33SRj
        e+Xv34M6vL18vT7K02cz85mGlMCAM+e3JHtC1A==
X-Google-Smtp-Source: AA6agR6hqqU4laLu3xqp+uhueyKbV/jTUTaEZFYa0zuGqDyFWfExlejgawYMrgn4+0E9+NOUeElbHCN5cQ8WlYQr9w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6808:130a:b0:344:efcd:8d47 with
 SMTP id y10-20020a056808130a00b00344efcd8d47mr376137oiv.227.1662508397088;
 Tue, 06 Sep 2022 16:53:17 -0700 (PDT)
Date:   Tue, 06 Sep 2022 23:53:16 +0000
In-Reply-To: <YxeZCwxmS5z5Msjy@google.com> (message from Ricardo Koller on
 Tue, 6 Sep 2022 12:01:31 -0700)
Mime-Version: 1.0
Message-ID: <gsntsfl4oyab.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 1/3] KVM: selftests: Implement random number generation
 for guest code.
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:

> On Thu, Sep 01, 2022 at 07:52:35PM +0000, Colton Lewis wrote:
>> +
>> +/* Park-Miller LCG using standard constants */
>> +static uint32_t perf_test_random(uint32_t seed)
>> +{
>> +	return (uint64_t)seed * 48271 % ((uint32_t)(1 << 31) - 1);
>> +}

> Nit: I would prefer moving this to include/kvm_test_util.h, maybe
> something like: get_next_random(seed). There could be other users of
> this.


Agree this might be useful elsewhere. Whoever needs it can move it to
the common header then.
