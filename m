Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B51B1535
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 20:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDTS5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 14:57:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTS5A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 14:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587409019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ikq5Qv3PPrHuziquCmfU1ccKUu3yxf8tVVUKAEUcDc8=;
        b=iTnq2mAqznq9DsDnFx8zfI1PfrT1bNmW+gJuM074pRor9cOp54l6lcSefjHJa6lKiu4Jnl
        A2irYSjYGIanUiHOvoYxHb2cDda2abgP89lBAAMapfFt3rKhdjj9nDcYzBhdrvnEhTY52m
        JW7K4hrAJougmh7M5uGKiyiU7B44Cic=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-FO96bpnuPTWABs7qL1Pz4A-1; Mon, 20 Apr 2020 14:56:57 -0400
X-MC-Unique: FO96bpnuPTWABs7qL1Pz4A-1
Received: by mail-wm1-f71.google.com with SMTP id u11so262352wmc.7
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 11:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ikq5Qv3PPrHuziquCmfU1ccKUu3yxf8tVVUKAEUcDc8=;
        b=Qxw4/a+fiZWdPQG+4Ed8Tdl8kzf57Ef+jPhybCjysUGWpaBWN79YRGANxQpcpUw+Be
         3hwKopdWzoveoLjm63eanBu4CXl2gJG0gAbHPSX3/gWUxMIAMJlytl9uXZf4d7WztXqA
         Wzbl/KM64u9ZzRm2SKFdtMCHiTUov1Y7A+i6/Ja60AGBGBXcCws+IrSJs3Kb7DE4ULOh
         YVYdJgwRw933/yGtQLDSbnJ0YC/jjy47KWitQDhNn4Cp9ozf9puGxMWvJljOM5oyd7jQ
         lVgfBKL5ebf0/M86Ym6MF3kIAStneISz6+GdYc8OUaPYx4ai9pj3IfvjP/S5EmpL15Tl
         z+6A==
X-Gm-Message-State: AGi0PubKkr5E8/Nuhyk7cQOnaT2FcJ58xmQXGhOT2nziz2Knr+imR++7
        Y9a40q4uHNFJCruQTanDe0UBAHgsts2wP8OdUxThKZJ894AxBJrb4OIwFJtS5SKStM6pY8k0NL3
        /eMjll152LjfM
X-Received: by 2002:a05:600c:4112:: with SMTP id j18mr791663wmi.69.1587409016722;
        Mon, 20 Apr 2020 11:56:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypLytHwWpbA0ak+M3QB2qxFoOsfkJhgfSmRcq6JPNF6U1hiCSUFMi1MYXikJrBJYEfStR5louA==
X-Received: by 2002:a05:600c:4112:: with SMTP id j18mr791639wmi.69.1587409016531;
        Mon, 20 Apr 2020 11:56:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5c18:5523:c13e:fa9f? ([2001:b07:6468:f312:5c18:5523:c13e:fa9f])
        by smtp.gmail.com with ESMTPSA id b2sm561952wrn.6.2020.04.20.11.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:56:55 -0700 (PDT)
To:     KVM list <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <jroedel@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: experiment: KVM x86 pull requests
Message-ID: <a4415abf-cf53-9344-93eb-641b2a2924e6@redhat.com>
Date:   Mon, 20 Apr 2020 20:56:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I'd like to start an experiment in accepting x86 pull requests.  These
for now would be restricted to enablement for new x86 processor
features, since there are a few of them pending, but there's no reason
why that wouldn't be extended in the future to e.g. the MMU or to other
parts of the vmx/ and svm/ subdirectories.

Anybody who is listed as an x86 KVM reviewer can send a pull request.

Paolo

