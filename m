Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB616793077
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 22:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbjIEU4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 16:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjIEU4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 16:56:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB17191
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 13:55:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56f75ec7ca9so3443020a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 13:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693947350; x=1694552150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w6LEeuIUq92rAHAZ7mAmJgBEms8v856H+Y3Q8JQ/ZhA=;
        b=LxdL10MulmXIsdZArrfFmx/UlGRDYmFWuJi1d6pzXy4SOLHrU0tVO0Ff+9Sy9XVpdQ
         yJQAeKW+/9FNDKga186T4gbDVSQG9jaKmp9MWuqaheyRRxC5Se08/30v9oYb2Ud2ey3K
         o8fzJubcfAtHgggJLuGFsVHo2ecBzLLtr6pCcDKSox746Dc1zKlHVEIop7HQDPOoFae7
         +oE9OOh8Exqw7itElm6ykDRjTG5CLObDL164u7GECWLIiiSXGlzaUaKNEP83CEkVQ5bY
         t11FOIsoltSaXfF3CBiJfQ3fi4lwW18qanksn215ysuUb58IJXko4tj2tspGapq7y+t+
         PwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947350; x=1694552150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6LEeuIUq92rAHAZ7mAmJgBEms8v856H+Y3Q8JQ/ZhA=;
        b=QkSGjmR4hSGlQcln+Df7Xl2mF4ituPY8VZzBqYE5SmtktWcmdf3J7B8/4Yv+Mbt1u8
         NTn73QGboRk5ozYAj6mBXFaqIy8QIW22w5XewBOrL6vAvNhGmpNtiuQJCo9GzNDHhwok
         vtmW0zJX6OV4a5LDc0Z3nugNVo840dgfrBmOQNNjlwFhQr3g73a3FlPLqumqZgm1xfZH
         mEzAI0MeEaR1SCEQRkjFxCep8Zs5cT1SJppqYL1yZ5OAzz04PnK2cD9BY45h9wh+lhyM
         6cuAliSTDac+t+PqMx51F2vJ1uGTeWJ9+d/ECCSOj8zNd1wK3kvTJkRk8MZPN+n/cgyK
         RmKA==
X-Gm-Message-State: AOJu0Yw32ZUeRuJ1IN6/ejXELSibY0XhSsApSfMpwmqo/26njqdSrsbV
        SV1Fk4PnPWc7JT/7XmJCd6XrZ89LsOg=
X-Google-Smtp-Source: AGHT+IEjams5rniEgM7cs4+ynQa1LuRNNrqo9AodJZkUYioBUByGU6PFFnWPIs5rhIq+5Uz9R+i3yyzmZGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:af1a:0:b0:563:e937:5e87 with SMTP id
 w26-20020a63af1a000000b00563e9375e87mr3415922pge.5.1693947350154; Tue, 05 Sep
 2023 13:55:50 -0700 (PDT)
Date:   Tue, 5 Sep 2023 13:55:48 -0700
In-Reply-To: <DSxaeYtslZW13dZU36PVY2RooaqU99qcXgPSYkyw6F5t8LSJk8MkAn1shTVrb-cAFRaKEVr5VDrWD6JRmSTlpDbGrHBiM-8zHwIiH90nNHI=@protonmail.com>
Mime-Version: 1.0
References: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com>
 <ZPeBE5aZqLwdnspl@google.com> <DSxaeYtslZW13dZU36PVY2RooaqU99qcXgPSYkyw6F5t8LSJk8MkAn1shTVrb-cAFRaKEVr5VDrWD6JRmSTlpDbGrHBiM-8zHwIiH90nNHI=@protonmail.com>
Message-ID: <ZPeV1GWQWeH48a2G@google.com>
Subject: Re: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023, Jari Ruusu wrote:
> On Tuesday, September 5th, 2023 at 22:27, Sean Christopherson <seanjc@google.com> wrote:
> > As for working around this in your setup, assuming you don't actually need a
> > virtual PMU in the guest, the simplest workaround would be to turn off vPMU
> > support in KVM, i.e. boot with kvm.enable_pmu=0. That should cause QEMU to not
> > advertise a PMU to the guest.
> 
> Newer host kernels seem to have kvm.enable_pmu parameter,
> but linux-5.10.y kernels do not have that.

Gah, try kvm.pmu.

Commit 4732f2444acd ("KVM: x86: Making the module parameter of vPMU more common")
renamed the variable to avoid collisions, but it unnecessarily changed the name
exposed to userspace too.  My gut reaction is to revert the param name back to
"pmu".

Paolo, any idea if reverting "enable_pmu" back to "pmu" would be worth the churn?
