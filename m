Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BCE310F6D
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhBEQVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbhBEQTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:19:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F76C0613D6
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 10:00:49 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q20so4821107pfu.8
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 10:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qb1CyCQjn/N+1y/YOs2JFjHcLhMQN11acgAoLNGKiQ=;
        b=VVHaLfLKNyYdA5QhCxSkdfo9vcIXZlgeeExzIcDLdit6Cwz79JwZjnR9mN4wSkzjz4
         dy0HpQQhUTiQOJD/dH0xmL+h/d6U3IA6hcdJWGCn0DnqZPInxzfyK5Mfoj+7UpAskeHv
         gJlKMk0UN67uJOO3S6q01Lspk2sEmmBXz0CZ4N3g7jcm7pFR/TugKpafwtQAEdfDhgih
         kljOAquYcTx+TMj3xOAFzy5MChDZ/zV8uGnHEYxJkbnzpPkkJIwf5EIjFgUFXzxF39rK
         wajcA0PgmVfz8+eOdZHu/ooY6KtCYHjOQhZxn8CcYmlked0L6nzMXYZ32LBnnrluYOs9
         Cwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qb1CyCQjn/N+1y/YOs2JFjHcLhMQN11acgAoLNGKiQ=;
        b=RlC1Kth/3BsdFKxlHkrnosOnXp2J68qMjuYTOs/pc3hp05R1NWY61+QU0n7YKmBRHa
         eLWvvC88hcAZwKQOB8y+03YYLbeTeFSCIefyzR2NOaPF3TFOBdBgE3FBhIrqgI8hkwzr
         Ce1O6bSVah86jGNbOCB3G+g0owh3QKtB9jxASLG4vsMumLhVpfJhv9D3sFtln6Pzkntg
         xf4gWxxUJ1yUmDbw9Y/ZQLuYG+ffhmZMPCwIJ5tewCRKJ57G6tRiU96T8w9550qEckJ+
         E3T/ojPDVoIoXBCQatfVyVIDNR5LQKbtdRI7e7PhW0zmLnkDYSy0WRT6kNSu4A1K2Fj4
         dcHw==
X-Gm-Message-State: AOAM530LJ14XfjcwPVG5hWh/ZsxXSlBzK/LZM561Rl/EQxWWNTFDMwJ8
        tj5qEWSvvLzJyE70WCzTaKk6eg==
X-Google-Smtp-Source: ABdhPJyqrLSbGinpw8kAw9OAisrZH9ZMhkWsRghDbIat1Imo0jHkgsZrHsOrwJ9ds6qdleA9MfPldQ==
X-Received: by 2002:a63:2f86:: with SMTP id v128mr5345741pgv.241.1612548048759;
        Fri, 05 Feb 2021 10:00:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d169:a9f7:513:e5])
        by smtp.gmail.com with ESMTPSA id w12sm8852108pjq.26.2021.02.05.10.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:00:48 -0800 (PST)
Date:   Fri, 5 Feb 2021 10:00:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jonny Barker <jonny@jonnybarker.com>
Subject: Re: [GIT PULL] KVM fixes for 5.11-rc7
Message-ID: <YB2HykY8laADI+Qm@google.com>
References: <20210205080456.30446-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205080456.30446-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021, Paolo Bonzini wrote:
> Sean Christopherson (3):
>       KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode

Ah, shoot.  Too late now, but this should have been attributed to Jonny, I was
just shepherding the official patch along and forgot to make Jonny the author.

Sorry Jonny :-/
