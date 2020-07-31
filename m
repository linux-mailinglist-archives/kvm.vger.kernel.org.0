Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0926233FD8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbgGaHSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:18:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726985AbgGaHSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596179882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ypX2QdRDvTSSbZY1iWmS7yoRM8niq7umNA3+s02Gxo=;
        b=DprzdIB5XOZrcdHVqn7QoG7f4YtfFwlbHb+pkgHu90Fo/Ypy+aIsHOsOxdbUE8LIshe2US
        izeCX4tqfvXiKFsGmW2PfnxJsilNZtxLxl1WY4SSdBYCrv9NXCmXk1hny15EIrkMpwAfcE
        sKlJ/OkH8wEOOe6TPnUlGiFoU39VwKI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-tYl2RIBiNaG7hZ2IaWgDUg-1; Fri, 31 Jul 2020 03:17:56 -0400
X-MC-Unique: tYl2RIBiNaG7hZ2IaWgDUg-1
Received: by mail-wm1-f72.google.com with SMTP id a207so1879511wme.9
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 00:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9ypX2QdRDvTSSbZY1iWmS7yoRM8niq7umNA3+s02Gxo=;
        b=ab4ucDtTdbgazzJxAakSfUo6faYrBziosdJbuYC9ylp8PD8Rezj6adov+GW0+rczki
         SVzBVdL/vx0+H2mnoAwnx+7Ml4wCJTth1bJTrfnh1N6zvoyH2SwbeFusshPpgYqTK+lG
         CMiEoF4OUofo0UJi/gkzJ1VdJNgmXbiOpdiFi5kQJiRRM7JMeu/YlKNgfKXVXK7OHvz+
         4bA5a76AOxCTxEk8t0koR569Zcpy5BJcu9HbxJdX3BN4VY0YfQo+fza4HFeBoaP7hjx4
         5kUBuJu46Efd7XvJd1bds9/rXEbHa3r/szkGBgms0Xx6L71HHimS0TYH8GfKWlZsDkL5
         6piA==
X-Gm-Message-State: AOAM5305Crg4d1xvWDlPF5Qh+1qInQ0C0G5WLNl2Vda9LLzy3tyeiLKR
        X8UIsKmb9sYP5hReOLGDNFpcEdmAANnfLdabWdPidthUQ7VjYzc2W9gOv83pg57ccrBhrCaDd5Y
        aoj43ukR7YI6t
X-Received: by 2002:adf:f289:: with SMTP id k9mr2206022wro.203.1596179875232;
        Fri, 31 Jul 2020 00:17:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6bmxNc0frxcNUhCEA2JmYoM0OviIclmzy+hGGdUWKDNgBtzOwALQFKxuk5p0FEsPUcLDs/Q==
X-Received: by 2002:adf:f289:: with SMTP id k9mr2206008wro.203.1596179874996;
        Fri, 31 Jul 2020 00:17:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id c4sm12187182wrt.41.2020.07.31.00.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 00:17:54 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1
 |"
To:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200731060909.1163-1-thuth@redhat.com>
 <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
 <b3e57992-3f61-50fb-4cbb-3f3a494d7639@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <805d57bb-be3d-50af-a40f-4d37629d42d5@redhat.com>
Date:   Fri, 31 Jul 2020 09:17:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b3e57992-3f61-50fb-4cbb-3f3a494d7639@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 09:13, Thomas Huth wrote:
> the bash version that Apple ships is incredibly old (version 3).

Yes, due to GPLv3.  :(  I think either we rewrite the whole thing in
Python (except for the "shar"-like code in mkstandalone.sh) or we keep
bash 4 as the minimum supported version.

Paolo

